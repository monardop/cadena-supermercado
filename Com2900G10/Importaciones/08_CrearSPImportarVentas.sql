/*******************************************************************************
*                                                                             *
*                           Entrega 3 - Grupo 10                              *
*                                                                             *
*                           Integrantes:                                      *
*                           43.988.577 Juan Piñan                             *
*                           43.049.457 Matias Matter                          *
*                           42.394.230 Lucas Natario                          *
*                           40.429.974 Pablo Monardo                          *
*                                                                             *
*                                                                             *
* "Se requiere que importe toda la información antes mencionada a la base de  *
* datos:                                                                      *
* • Genere los objetos necesarios (store procedures, funciones, etc.) para    *
*   importar los archivos antes mencionados. Tenga en cuenta que cada mes se  *
*   recibirán archivos de novedades con la misma estructura, pero datos nuevos*
*   para agregar a cada maestro.                                              *
* • Considere este comportamiento al generar el código. Debe admitir la       *
*   importación de novedades periódicamente.                                  *
* • Cada maestro debe importarse con un SP distinto. No se aceptarán scripts  *
*   que realicen tareas por fuera de un SP.                                   *
* • La estructura/esquema de las tablas a generar será decisión suya. Puede   *
*   que deba realizar procesos de transformación sobre los maestros recibidos *
*   para adaptarlos a la estructura requerida.                                *
* • Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal *
*   cargados, incompletos, erróneos, etc., deberá contemplarlo y realizar las *
*   correcciones en el fuente SQL. (Sería una excepción si el archivo está    *
*   malformado y no es posible interpretarlo como JSON o CSV)."               *
*                                                                             *
*******************************************************************************/


GO
USE Com2900G10;
GO

-- SP para la importar datos de clasificacion de productos
GO
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


	CREATE TABLE #importacion_ventas(
		id_factura_archivo VARCHAR(100),
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
		id_pago varchar(500)
	);

	-- inserto
	EXEC sp_executesql @sql

	-- Sanitizo
	UPDATE #importacion_ventas SET id_factura_archivo = TRIM(importacion.sanitizar_y_reemplazar(id_factura_archivo,' '));
	UPDATE #importacion_ventas SET producto = TRIM(importacion.sanitizar_y_reemplazar(producto,' '));
	UPDATE #importacion_ventas SET ciudad = TRIM(importacion.sanitizar_y_reemplazar(ciudad,' '));
	UPDATE #importacion_ventas SET medio_pago = TRIM(importacion.sanitizar_y_reemplazar(medio_pago,' '));
	UPDATE #importacion_ventas SET tipo_factura = TRIM(importacion.sanitizar_y_reemplazar(tipo_factura,' '));
	UPDATE #importacion_ventas SET tipo_cliente = TRIM(importacion.sanitizar_y_reemplazar(tipo_cliente,' '));
	UPDATE #importacion_ventas SET fecha = TRIM(importacion.sanitizar_y_reemplazar(fecha,' '));
	UPDATE #importacion_ventas SET hora = TRIM(importacion.sanitizar_y_reemplazar(hora,' '));


	-- Agrego una columna para cruzar los ID de producto
	ALTER TABLE #importacion_ventas ADD id_producto SMALLINT;

	-- Agrego una columna para cruzar los ID de medio de pago
	ALTER TABLE #importacion_ventas ADD id_medio_pago SMALLINT;

	-- Agrego una columna para cruzar los ID de sucursal
	ALTER TABLE #importacion_ventas ADD id_sucursal SMALLINT;
	
	-- Agrego productos inexistentes, sin duplicados
	DECLARE @id_categoria_default SMALLINT = 1;

	WITH CTE (id_categoria, nombre, precio, moneda, seq)
	AS (
		SELECT @id_categoria_default, i.producto, i.precio_unitario, 'ARS', ROW_NUMBER() OVER(PARTITION BY i.producto ORDER BY i.producto)
		FROM #importacion_ventas i
			LEFT JOIN producto.producto p ON p.nombre_producto = i.producto
		WHERE p.id_producto IS NULL
	)
	INSERT INTO producto.producto(id_categoria_producto, nombre_producto, precio_unitario, moneda)
	SELECT id_categoria, nombre,precio,moneda FROM CTE WHERE seq = 1;

	-- actualizo id_producto en tmp
	UPDATE i
		SET i.id_producto = p.id_producto
	FROM #importacion_ventas i
		INNER JOIN producto.producto p ON p.nombre_producto = i.producto;

		SELECT * FROM #importacion_ventas WHERE id_producto IS NULL

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

	-- Elimino facturas ya importadas previamente para evitar duplicar detalles
	DELETE i
	FROM #importacion_ventas i
		INNER JOIN venta.factura f ON f.numero_factura = i.id_factura_archivo

	-- Genero facturas nuevas
	DECLARE @id_default_cliente SMALLINT = 1;

	WITH CTE(numero_factura, id_medio_pago, empleado, id_cliente, tipo_factura,tipo_cliente, fecha_hora, id_sucursal, seq)
	AS
	(
		SELECT
			i.id_factura_archivo,
			i.id_medio_pago,
			i.empleado,
			@id_default_cliente,
			i.tipo_factura,
			i.tipo_cliente,
			CONVERT(DATETIME, i.fecha + ' ' + i.hora, 120),
			i.id_sucursal,
			ROW_NUMBER() OVER(PARTITION BY i.id_factura_archivo ORDER BY i.id_factura_archivo)
		FROM  #importacion_ventas i
	)
	INSERT INTO venta.factura(numero_factura, id_medio_pago, legajo_empleado, id_cliente, tipo_factura, tipo_cliente, fechaHora, id_sucursal,total)
	SELECT 
		numero_factura,
		id_medio_pago, 
		empleado, 
		id_cliente, 
		tipo_factura,
		tipo_cliente, 
		fecha_hora, 
		id_sucursal,
		0
	FROM CTE 
	WHERE seq = 1 -- Me quedo solo con un registro por factura, ya que puede haber repetidos por el detalle


	-- genero los detalles
	INSERT INTO venta.detalle_factura
	SELECT 
		id_producto,
		f.id_factura,
		cantidad,
		i.precio_unitario * i.cantidad
	FROM #importacion_ventas i
		INNER JOIN venta.factura f ON f.numero_factura = i.id_factura_archivo;

	-- actualizo totales de factura
	WITH CTE (id_factura, total) AS
	(
		SELECT f.id_factura, SUM(df.subtotal * df.cantidad)
		FROM venta.factura f
			INNER JOIN venta.detalle_factura df ON df.id_factura = f.id_factura
		GROUP BY f.id_factura
	)
	UPDATE f
		SET f.total = c.total
	FROM venta.factura f
		INNER JOIN CTE c ON c.id_factura = f.id_factura

END;
