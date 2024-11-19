CREATE OR ALTER PROCEDURE importacion.ImportarVentas
	@pathArchivos VARCHAR(200)
AS
BEGIN
	DECLARE @sql NVARCHAR(max) = 'BULK INSERT #importacion_ventas

    FROM ''' + @pathArchivos + '''
    WITH
    (
		FIRSTROW = 2,
		 CODEPAGE = ''65001'',
		FIELDTERMINATOR = '';'',  --CSV field delimiter
		ROWTERMINATOR = ''\n'',   --Use to shift the control to next row
        FORMAT = ''CSV'',
        FIELDQUOTE = ''"'',
		TABLOCK
    )'

	-- TODO: Pasar a tabla parametrizada
	DECLARE @id_default_cliente SMALLINT = 1;
	DECLARE @factor_iva DECIMAL(4,2) = 1.21;

	CREATE TABLE #importacion_ventas(
		numero_factura VARCHAR(100),
		tipo_factura VARCHAR(20), 
		ciudad VARCHAR(300),
		tipo_cliente VARCHAR(100),
		genero VARCHAR(100),
		producto VARCHAR(300),
		precio_unitario DECIMAL(6,2),
		cantidad SMALLINT,
		fecha VARCHAR(20),
		hora VARCHAR(20),
		medio_pago VARCHAR(50),
		empleado varchar(100),
		identificador_pago varchar(500)
	);

	-- inserto
	EXEC sp_executesql @sql
	-- DROP TABLE #importacion_ventas
	-- Sanitizo
	UPDATE #importacion_ventas SET numero_factura = TRIM(importacion.sanitizar_y_reemplazar(numero_factura,' '));
	UPDATE #importacion_ventas SET producto = TRIM(importacion.sanitizar_y_reemplazar(producto,' '));
	UPDATE #importacion_ventas SET ciudad = TRIM(importacion.sanitizar_y_reemplazar(ciudad,' '));
	UPDATE #importacion_ventas SET medio_pago = TRIM(importacion.sanitizar_y_reemplazar(medio_pago,' '));
	UPDATE #importacion_ventas SET tipo_factura = TRIM(importacion.sanitizar_y_reemplazar(tipo_factura,' '));
	UPDATE #importacion_ventas SET fecha = TRIM(importacion.sanitizar_y_reemplazar(fecha,' '));
	UPDATE #importacion_ventas SET hora = TRIM(importacion.sanitizar_y_reemplazar(hora,' '));

	-- Agrego una columna para cruzar los ID de producto
	ALTER TABLE #importacion_ventas ADD id_producto SMALLINT;

	-- Agrego una columna para cruzar los ID de medio de pago
	ALTER TABLE #importacion_ventas ADD id_medio_pago SMALLINT;

	-- Agrego una columna para cruzar los ID de sucursal
	ALTER TABLE #importacion_ventas ADD id_sucursal SMALLINT;

	-- Agrego una columna para cruzar los ID de punto de venta
	ALTER TABLE #importacion_ventas ADD id_punto_venta_empleado SMALLINT;
	
	-- Agrego productos inexistentes, sin duplicados
	DECLARE @id_categoria_default SMALLINT = 1;

	WITH CTE (id_categoria, nombre, precio, seq)
	AS (
		SELECT @id_categoria_default, i.producto, i.precio_unitario, ROW_NUMBER() OVER(PARTITION BY i.producto ORDER BY i.producto)
		FROM #importacion_ventas i
			LEFT JOIN producto.producto p ON p.nombre_producto = i.producto
		WHERE p.id_producto IS NULL
	)
	INSERT INTO producto.producto(id_categoria_producto, nombre_producto, precio_unitario)
	SELECT id_categoria, nombre,precio FROM CTE WHERE seq = 1;

	-- actualizo id_producto en tmp
	UPDATE i
		SET i.id_producto = p.id_producto
	FROM #importacion_ventas i
		INNER JOIN producto.producto p ON p.nombre_producto = i.producto;

	-- Agrego medios de pagos inexistentes
	INSERT INTO venta.medio_pago(nombre_eng, nombre_esp)
	SELECT i.medio_pago, i.medio_pago
	FROM #importacion_ventas i
		LEFT JOIN venta.medio_pago m ON m.nombre_eng = i.medio_pago OR m.nombre_esp = i.medio_pago
	WHERE m.id_medio_pago IS NULL

	-- actualizo id_medio_pago en tmp
	UPDATE i
		SET i.id_medio_pago = m.id_medio_pago
	FROM #importacion_ventas i
		INNER JOIN venta.medio_pago m ON m.nombre_eng = i.medio_pago OR m.nombre_esp = i.medio_pago;

		SELECT * FROM #importacion_ventas where id_sucursal is null

	-- actualizo id_sucursal en tmp
	UPDATE i
		SET i.id_sucursal = s.id_sucursal
	FROM #importacion_ventas i
		INNER JOIN sucursal.sucursal s ON s.ciudad = i.ciudad OR s.reemplazar_por = i.ciudad;

	-- Genero puntos de venta empleados inexistentes
	WITH CTE (empleado, id_sucursal)
	AS (
		SELECT i.empleado, i.id_sucursal
		FROM #importacion_ventas i
			LEFT JOIN sucursal.punto_venta_empleado p ON p.id_sucursal = i.id_sucursal AND p.legajo_empleado = i.empleado
		WHERE p.id_punto_venta_empleado IS NULL
		GROUP BY i.empleado, i.id_sucursal
	)
	INSERT INTO sucursal.punto_venta_empleado(numero_punto_venta, id_sucursal, legajo_empleado, activo)
	SELECT 1,id_sucursal, empleado,1 -- TODO: Pasar numero_punto_venta a parametro en tabla de config
	FROM CTE;

	-- Actualizo puntos de venta en la tmp
	UPDATE i
		SET i.id_punto_venta_empleado = p.id_punto_venta_empleado
	FROM #importacion_ventas i
		INNER JOIN sucursal.punto_venta_empleado p ON p.id_sucursal = i.id_sucursal AND p.legajo_empleado = i.empleado


	-- Elimino facturas ya importadas previamente para evitar duplicar detalles
	DELETE i
	FROM #importacion_ventas i
		INNER JOIN venta.factura f ON f.numero_factura = i.numero_factura;

	-- Inserto las nuevas facturas - Sin pago y sin total todavia
	WITH CTE(id_pago, id_cliente, numero_factura, tipo_factura, fecha_hora, total_con_iva, seq)
	AS
	(
		SELECT null, @id_default_cliente, numero_factura, tipo_factura, 
				CAST(CONCAT(fecha, ' ', hora) AS DATETIME), 0, ROW_NUMBER() OVER(PARTITION BY numero_factura ORDER BY numero_factura)
		FROM #importacion_ventas
	)
	INSERT INTO venta.factura(id_pago,id_cliente,numero_factura,tipo_factura,fecha_hora, total_con_iva)
	SELECT 
		id_pago, id_cliente, numero_factura, tipo_factura, fecha_hora, total_con_iva
	FROM CTE WHERE seq = 1; -- un registro por nro de factura

	-- Inserto los detalles de cada factura de la importacion
	WITH CTE(id_factura, id_producto, cantidad, subtotal) AS
	(
		SELECT f.id_factura, i.id_producto, i.cantidad, i.cantidad * i.precio_unitario
		FROM #importacion_ventas i
			INNER JOIN venta.factura f ON f.numero_factura = i.numero_factura
	)
	INSERT INTO venta.detalle_factura(id_factura, id_producto, cantidad, subtotal)
	SELECT * FROM CTE;

	-- Genero los pagos de las facturas
	WITH CTE(id_medio_pago, identificador, seq) AS
	(
		SELECT i.id_medio_pago, CONCAT(f.id_factura,'-',i.identificador_pago), ROW_NUMBER() OVER(PARTITION BY f.id_factura ORDER BY f.id_factura)
		FROM #importacion_ventas i
			INNER JOIN venta.factura f ON f.numero_factura = i.numero_factura
	)
	INSERT INTO venta.pago(id_medio_pago, identificador)
	SELECT id_medio_pago, identificador FROM CTE WHERE seq = 1; -- un pago por factura

	-- Updateo las facturas con los pagos creados y elimino la columna temporal
	UPDATE f
		SET f.id_pago = p.id_pago
		FROM #importacion_ventas i
			INNER JOIN venta.factura f ON f.numero_factura = i.numero_factura
			INNER JOIN venta.pago p ON p.identificador = CONCAT(f.id_factura,'-',i.identificador_pago);

	-- restauro el identificador original
	UPDATE p
		SET p.identificador = i.identificador_pago
	FROM #importacion_ventas i
			INNER JOIN venta.factura f ON f.numero_factura = i.numero_factura
			INNER JOIN venta.pago p ON p.identificador = CONCAT(f.id_factura,'-',i.identificador_pago);

	-- Calculo total con iva de la factura (Solo las importadas)
	WITH CTE(id_factura, total_con_iva)
	AS
	(
		SELECT f.id_factura, SUM(subtotal) * @factor_iva
		FROM #importacion_ventas i
			INNER JOIN venta.factura f ON f.numero_factura = i.numero_factura
			INNER JOIN venta.detalle_factura df ON df.id_factura = f.id_factura
		GROUP BY f.id_factura
	)
	UPDATE f
		SET f.total_con_iva = c.total_con_iva
	FROM venta.factura f
		INNER JOIN CTE c ON c.id_factura = f.id_factura;

	-- Creo ventas de las facturas creadas
	WITH CTE(id_factura, legajo_empleado, id_sucursal, id_punto_venta_empleado, total, fecha_hora, seq)
	AS
	(
		SELECT f.id_factura, i.empleado, i.id_sucursal, i.id_punto_venta_empleado, f.total_con_iva * (1 - (1-@factor_iva)), f.fecha_hora,
				ROW_NUMBER() OVER(PARTITION BY f.id_factura ORDER BY f.id_factura)
		FROM  #importacion_ventas i
			INNER JOIN venta.factura f ON f.numero_factura = i.numero_factura
	)
	INSERT INTO venta.venta(id_factura, legajo_empleado, id_sucursal, id_punto_venta_empleado, total, fecha_hora)
	SELECT id_factura, legajo_empleado, id_sucursal, id_punto_venta_empleado, total, fecha_hora
	FROM CTE
	WHERE seq = 1; -- un registro por factura

	-- Genero detalle de venta por cada detalle de factura
	WITH CTE(id_venta, id_producto, cantidad, subtotal)
	AS
	(
		SELECT v.id_venta, df.id_producto, df.cantidad, df.subtotal
		FROM  #importacion_ventas i
			INNER JOIN venta.factura f ON f.numero_factura = i.numero_factura
			INNER JOIN venta.venta v ON v.id_factura = f.id_factura
			INNER JOIN venta.detalle_factura df ON df.id_factura = f.id_factura
	)
	INSERT INTO venta.detalle_venta(id_venta, id_producto, cantidad, subtotal)
	SELECT * FROM CTE


END;
