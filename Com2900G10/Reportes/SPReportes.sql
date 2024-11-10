USE Com2900G10;

GO
CREATE PROCEDURE reporte_mensual
    @mes    INT,
    @year   INT
AS
BEGIN
    SELECT
        CASE DATEPART(WEEKDAY, fechaHora)
            WHEN 1 THEN 'Domingo'
            WHEN 2 THEN 'Lunes'
            WHEN 3 THEN 'Martes'
            WHEN 4 THEN 'Miércoles'
            WHEN 5 THEN 'Jueves'
            WHEN 6 THEN 'Viernes'
            WHEN 7 THEN 'Sábado'
        END AS DiaSemana,
        SUM(total) AS Ventas
    FROM ventas.factura
    WHERE 
        YEAR(fechaHora) = @year AND
        MONTH(fechaHora) = @mes
    GROUP BY DATEPART(WEEKDAY, fechaHora)
    FOR XML RAW, ELEMENTS, ROOT('XML')
END

GO
CREATE PROCEDURE reporte_trimestral
AS
    -- Busco el trimestre actual
    BEGIN
        DECLARE @currYear INT = YEAR(GETDATE());
        DECLARE @MesActual INT = MONTH(GETDATE());
        DECLARE @TrimestreActual INT = CEILING(CAST(@MesActual AS FLOAT) / 3);
        DECLARE @TrimestreInicio INT = (@TrimestreActual - 1) * 3 + 1;
        DECLARE @TrimestreFin INT = @TrimestreActual * 3;

    -- Si el mes actual fuese enero o febrero, cambio 
    IF @TrimestreActual = 1
    BEGIN
        SET @currYear = @currYear - 1;
        SET @TrimestreInicio = 10;
        SET @TrimestreFin = 12;
    END
    ELSE IF @TrimestreActual = 2
    BEGIN
        SET @currYear = @currYear - 1;
        SET @TrimestreInicio = 7;
        SET @TrimestreFin = 9;
    END

    -- Empieza la consulta
    SELECT
        CASE
            WHEN DATEPART(HOUR, FechaHora) < 12 THEN 'Mañana'
            WHEN DATEPART(HOUR, FechaHora) >= 12 AND DATEPART(HOUR, FechaHora) < 19 THEN 'Tarde'
            ELSE 'Noche'
        END AS Turno,
        SUM(total) AS Ventas
    WHERE YEAR(FechaHora) = @currYear
        AND MONTH(FechaHora) BETWEEN @TrimestreInicio AND @TrimestreFin
    GROUP BY
             CASE
                 WHEN DATEPART(HOUR, FechaHora) < 12 THEN 'Mañana'
                 WHEN DATEPART(HOUR, FechaHora) >= 12 AND DATEPART(HOUR, FechaHora) < 19 THEN 'Tarde'
                 ELSE 'Noche'
             END
    FOR XML RAW, ELEMENTS, ROOT('XML')
END