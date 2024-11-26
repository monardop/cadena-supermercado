USE Com2900G10;

DROP PROCEDURE IF EXISTS reportes.reporte_mensual
DROP PROCEDURE IF EXISTS reportes.reporte_trimestral


DROP SCHEMA IF EXISTS reportes
GO
CREATE SCHEMA reportes
GO

CREATE OR ALTER PROCEDURE reportes.reporte_mensual
    @anio SMALLINT,
	@mes TINYINT
AS
BEGIN
	IF @mes < 1 OR @mes > 12
	BEGIN
		RAISERROR('El mes ingresado es invalido',10,1);

		RETURN
	END

	IF @anio < 1900 OR @anio > YEAR(GETDATE())
	BEGIN
		RAISERROR('El año ingresado es invalido',10,1);

		RETURN
	END

    SELECT
        CASE DATEPART(WEEKDAY, fecha_hora)
            WHEN 1 THEN 'Domingo'
            WHEN 2 THEN 'Lunes'
            WHEN 3 THEN 'Martes'
            WHEN 4 THEN 'Miércoles'
            WHEN 5 THEN 'Jueves'
            WHEN 6 THEN 'Viernes'
            WHEN 7 THEN 'Sábado'
        END AS DiaSemana,
        SUM(total_con_iva) AS Ventas
    FROM venta.factura
    WHERE 
        YEAR(fecha_hora) = @anio AND
        MONTH(fecha_hora) = @mes
    GROUP BY DATEPART(WEEKDAY, fecha_hora)
    FOR XML RAW, ELEMENTS, ROOT('XML')
END

-- SELECT * FROM venta.factura
-- EXEC reportes.reporte_mensual 2019, 03


GO
CREATE OR ALTER PROCEDURE reportes.reporte_trimestral_con_ingreso
	@anio SMALLINT,
	@trimestre TINYINT
AS
BEGIN
        IF @trimestre < 1 OR @trimestre > 4
	BEGIN
		RAISERROR('El trimestre ingresado es invalido',10,1);

		RETURN
	END

	IF @anio < 1900 OR @anio > YEAR(GETDATE())
	BEGIN
		RAISERROR('El año ingresado es invalido',10,1);

		RETURN
	END

        DECLARE @TrimestreInicio INT = (@trimestre - 1) * 3 + 1;
        DECLARE @TrimestreFin INT = @trimestre * 3;

    -- Empieza la consulta
    SELECT
		CASE MONTH(f.fecha_hora)
			WHEN 1 THEN 'Enero'
			WHEN 2 THEN 'Febrero'
			WHEN 3 THEN 'Marzo'
			WHEN 4 THEN 'Abril'
			WHEN 5 THEN 'Mayo'
			WHEN 6 THEN 'Junio'
			WHEN 7 THEN 'Julio'
			WHEN 8 THEN 'Agosto'
			WHEN 9 THEN 'Septiembre'
			WHEN 10 THEN 'Octubre'
			WHEN 11 THEN 'Noviembre'
			WHEN 12 THEN 'Diciembre'
		END as mes,
		e.turno,
        SUM(f.total_con_iva) AS Ventas
	FROM venta.factura f
		INNER JOIN venta.venta v ON v.id_factura = f.id_factura
		INNER JOIN sucursal.empleado e ON e.legajo = v.legajo_empleado
    WHERE YEAR(f.fecha_hora) = @anio
        AND MONTH(f.fecha_hora) BETWEEN @TrimestreInicio AND @TrimestreFin
    GROUP BY MONTH(f.fecha_hora), e.turno
	ORDER BY MONTH(f.fecha_hora), e.turno
    FOR XML RAW, ELEMENTS, ROOT('XML')
END

-- SELECT * FROM venta.factura
-- EXEC reportes.reporte_trimestral_con_ingreso 2019, 1

GO
CREATE OR ALTER PROCEDURE reportes.reporte_trimestral
AS
    -- Busco el trimestre actual
    BEGIN
        DECLARE @anioActual INT = YEAR(GETDATE());
        DECLARE @MesActual INT = MONTH(GETDATE());
        DECLARE @TrimestreActual INT = CEILING(CAST(@MesActual AS FLOAT) / 3);
        DECLARE @TrimestreInicio INT = (@TrimestreActual - 1) * 3 + 1;
        DECLARE @TrimestreFin INT = @TrimestreActual * 3;

    EXEC reportes.reporte_trimestral_con_ingreso @anioActual, @TrimestreActual
END

-- SELECT * FROM venta.factura
-- EXEC reportes.reporte_trimestral

GO
CREATE OR ALTER PROCEDURE reportes.productos_vendidas_por_rango
	@desde datetime, @hasta datetime
AS
BEGIN
	IF @desde is null OR @hasta is null
	BEGIN
		RAISERROR('Debe ingresar los limites de fechas', 10, 1);
	END

    -- Empieza la consulta
	SELECT * 
	FROM  (
		SELECT
			p.nombre_producto as producto,
			SUM( df.cantidad) as cantidad
		FROM venta.detalle_factura df
			INNER JOIN venta.factura f ON f.id_factura = df.id_factura AND f.pagada = 1
			INNER JOIN producto.producto p ON p.id_producto = df.id_producto
		GROUP BY p.nombre_producto
	) t1
	ORDER BY t1.cantidad DESC
    FOR XML RAW, ELEMENTS, ROOT('XML')
END;
-- EXEC reportes.productos_vendidas_por_rango '2019-01-01', '2019-12-31'
GO


CREATE OR ALTER PROCEDURE reportes.productos_vendidas_por_rango_por_sucursal
	@desde datetime, @hasta datetime
AS
BEGIN
	IF @desde is null OR @hasta is null
	BEGIN
		RAISERROR('Debe ingresar los limites de fechas', 10, 1);
	END

    -- Empieza la consulta
	SELECT * 
	FROM  (
		SELECT
			s.id_sucursal,
			s.reemplazar_por as nombre_sucursal,
			p.nombre_producto as producto,
			SUM( df.cantidad) as cantidad
		FROM venta.detalle_factura df
			INNER JOIN venta.factura f ON f.id_factura = df.id_factura AND f.pagada = 1
			INNER JOIN sucursal.sucursal s ON s.id_sucursal = f.id_sucursal
			INNER JOIN producto.producto p ON p.id_producto = df.id_producto
		GROUP BY s.id_sucursal, s.reemplazar_por, nombre_producto
	) t1
	ORDER BY t1.cantidad DESC
    FOR XML RAW, ELEMENTS, ROOT('XML')
END;
-- EXEC reportes.productos_vendidas_por_rango_por_sucursal '2019-01-01', '2019-12-31'
GO


CREATE OR ALTER PROCEDURE reportes.top5_productos_vendidos_mes_por_semana
	@mes tinyint, @anio smallint
AS
BEGIN
	IF @mes is null OR @anio is null
	BEGIN
		RAISERROR('Debe ingresar el mes a consultar', 10, 1);
	END;

    -- Empieza la consulta
	WITH CTE(id_producto, nombre_producto, cantidad, semana, posicion) AS
	(
		SELECT 
			t1.id_producto, 
			t1.nombre_producto,
			t1.cantidad,
			t1.semana,
			ROW_NUMBER() OVER (PARTITION BY DATEPART(WEEK, t1.semana) ORDER by t1.cantidad)
		FROM (
			SELECT
				p.id_producto,
				p.nombre_producto,
				DATEPART(WEEK, f.fecha_hora) AS semana,
				SUM(df.cantidad) AS cantidad
			FROM venta.detalle_factura df
				INNER JOIN venta.factura f ON 
					f.id_factura = df.id_factura AND 
					f.pagada = 1 AND
					MONTH(f.fecha_hora) = @mes AND
					YEAR(f.fecha_hora) = @anio
				INNER JOIN producto.producto p ON p.id_producto = df.id_producto
			GROUP BY p.id_producto, p.nombre_producto, DATEPART(WEEK, f.fecha_hora)
		) AS t1
	)
	SELECT 
		id_producto,
		nombre_producto,
		cantidad,
		semana - DATEPART(WEEK, DATEFROMPARTS(@anio, @mes, 1)) + 1 AS SemanaDelMes
	FROM CTE
	WHERE posicion <= 5
    FOR XML RAW, ELEMENTS, ROOT('XML')
END;
-- EXEC reportes.top5_productos_vendidos_mes_por_semana 2, 2019
GO

CREATE OR ALTER PROCEDURE reportes.top5_menos_productos_vendidos_mes
	@mes tinyint, @anio smallint
AS
BEGIN
	IF @mes is null OR @anio is null
	BEGIN
		RAISERROR('Debe ingresar el mes a consultar', 10, 1);
	END;

    -- Empieza la consulta
	WITH CTE(id_producto, nombre_producto, cantidad, posicion) AS
	(
			SELECT
				p.id_producto,
				p.nombre_producto,
				SUM(df.cantidad) AS cantidad,
				ROW_NUMBER() OVER (ORDER by p.id_producto)
			FROM venta.detalle_factura df
				INNER JOIN venta.factura f ON 
					f.id_factura = df.id_factura AND 
					f.pagada = 1 AND
					MONTH(f.fecha_hora) = @mes AND
					YEAR(f.fecha_hora) = @anio
				INNER JOIN producto.producto p ON p.id_producto = df.id_producto
			GROUP BY p.id_producto, p.nombre_producto
	)
	SELECT 
		id_producto,
		nombre_producto,
		cantidad
	FROM CTE
	WHERE posicion <= 5
    FOR XML RAW, ELEMENTS, ROOT('XML')
END;
-- EXEC reportes.top5_menos_productos_vendidos_mes 3, 2019
GO


CREATE OR ALTER PROCEDURE reportes.acumulado_ventas_por_fecha_por_sucursal
	@fecha date, @id_sucursal smallint
AS
BEGIN
	IF @fecha is null OR @id_sucursal is null
	BEGIN
		RAISERROR('Debe ingresar la fecha y sucursal a consultar', 10, 1);
	END;

    -- Empieza la consulta
	WITH CTE(id_factura, total, fecha_hora, acumulado) AS
	(
			SELECT
				f.id_factura,
				f.total,
				f.fecha_hora,
				SUM(f.total) OVER(ORDER BY f.id_factura)
			FROM  venta.factura f
			WHERE
				f.pagada = 1 AND
				CAST(f.fecha_hora AS date) = @fecha AND
				f.id_sucursal = @id_sucursal
	)
	SELECT 
		*
	FROM CTE
    FOR XML RAW, ELEMENTS, ROOT('XML')
END;
-- EXEC reportes.acumulado_ventas_por_fecha_por_sucursal '2019-03-01', 1
GO