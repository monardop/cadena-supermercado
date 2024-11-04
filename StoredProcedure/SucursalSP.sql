GO
USE supermercado_aurora;


-- SP para la tabla sucursal
GO
CREATE PROCEDURE BajaSucursal
    @id_sucursal SMALLINT
AS
BEGIN
    -- Verifica si la sucursal existe y está activa
    IF EXISTS (SELECT 1 FROM sucursal.sucursal WHERE id_sucursal = @id_sucursal AND activo = 1)
    BEGIN
        UPDATE sucursal.sucursal
        SET activo = 0
        WHERE id_sucursal = @id_sucursal;
        
        PRINT 'Sucursal dada de baja correctamente.';
    END
    ELSE
    BEGIN
        PRINT 'La sucursal no fue encontrada o ya fue dada de baja anteriormente.';
    END
END;

GO
CREATE PROCEDURE CambiarUbicacion
    @id_sucursal        SMALLINT,
    @nueva_ciudad       VARCHAR(50),
    @reemplaza_por      VARCHAR(50),
    @nueva_direccion    VARCHAR(300)
AS
BEGIN
    -- Verifica si la sucursal existe
    IF EXISTS (SELECT 1 FROM sucursal.sucursal WHERE id_sucursal = @id_sucursal AND activo = 1)
    BEGIN
        UPDATE sucursal.sucursal
        SET ciudad          = @nueva_ciudad,
            reemplazar_por  = @reemplaza_por,
            direccion       = @nueva_direccion
        WHERE id_sucursal   = @id_sucursal;
        
        PRINT 'Ubicacion actualizado correctamente.';
    END
    ELSE
    BEGIN
        PRINT 'La sucursal no existe o fue dada de baja.';
    END
END;

GO
CREATE PROCEDURE CambiarTelefono
    @id_sucursal        SMALLINT,
    @nuevo_telefono     VARCHAR(50)
AS
BEGIN
    -- Verifica si ya existe la sucursal
    IF EXISTS (SELECT 1 FROM sucursal.empleado WHERE id_sucursal = @id_sucursal AND activo = 1)
    BEGIN
        UPDATE sucursal.sucursal
        SET telefono = @nuevo_telefono
        WHERE id_sucursal = @id_sucursal;
        
        PRINT 'Telefono actualizado correctamente.';
    END
    ELSE
    BEGIN
        PRINT 'La sucursal buscada no existe o está inactiva';
    END
END;

GO
CREATE PROCEDURE CrearSucursal
    @ciudad VARCHAR(50),
    @reemplazar_por VARCHAR(50),
    @direccion VARCHAR(300),
    @horario VARCHAR(45),
    @telefono CHAR(9)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sucursal.sucursal WHERE @ciudad = ciudad AND activo = 1)
        BEGIN
            INSERT INTO sucursal.sucursal 
            VALUES (@ciudad, @reemplazar_por, @direccion, @horario, @telefono, 1);
            
            PRINT 'Sucursal creada correctamente.';
        END

    ELSE
        BEGIN
        PRINT 'La sucursal ya existe y está activa.';
    END
END;


GO
CREATE PROCEDURE AltaSucurcursal 
    @id_sucursal SMALLINT
AS
BEGIN
    -- Verifica si la sucursal existe y está inactiva
    IF EXISTS (SELECT 1 FROM sucursal.sucursal WHERE id_sucursal = @id_sucursal AND activo = 0)
    BEGIN
        UPDATE sucursal.sucursal
        SET activo = 1
        WHERE id_sucursal = @id_sucursal;
        
        PRINT 'Sucursal dada de alta nuevamente.';
    END
    ELSE
    BEGIN
        PRINT 'La sucursal no fue encontrada o está activa.';
    END
END;