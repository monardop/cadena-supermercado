/*

Entrega 3 - Grupo 10 - Piñan, Monardo, Matter, Natario

"Genere store procedures para manejar la inserción, modificado, borrado (si corresponde,
también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla.
Los nombres de los store procedures NO deben comenzar con “SP”.
Genere esquemas para organizar de forma lógica los componentes del sistema y aplique esto
en la creación de objetos. NO use el esquema “dbo”"

*/

GO
USE Com2900G10;


-- SP para la tabla sucursal
GO
CREATE OR ALTER PROCEDURE BajaSucursal
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
		RAISERROR('La sucursal no fue encontrada o ya fue dada de baja anteriormente.',10,1);
END;

GO
CREATE OR ALTER PROCEDURE CambiarUbicacion
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
        RAISERROR('La sucursal no existe o fue dada de baja.',10,1);
END;

GO
CREATE OR ALTER PROCEDURE CambiarTelefono
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
       RAISERROR('La sucursal buscada no existe o está inactiva',10,1);

END;

GO
CREATE OR ALTER PROCEDURE CrearSucursal
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
        RAISERROR('La sucursal ya existe y está activa.',10,1);
END;


GO
CREATE OR ALTER PROCEDURE AltaSucursal 
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
        RAISERROR('La sucursal no fue encontrada o está activa.',10,1);
END;