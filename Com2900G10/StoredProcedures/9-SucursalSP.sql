/*******************************************************************************
*                                                                             *
*                           Entrega 3 - Grupo 10                              *
*																			  *
*                           Integrantes:                                      *
*                           43.988.577 Juan Piñan                             *
*                           43.049.457 Matias Matter                          *
*                           42.394.230 Lucas Natario                          *
*                           40.429.974 Pablo Monardo                          *
*                                                                             *
*                                                                             *
* "Cree la base de datos, entidades y relaciones. Incluya restricciones y     *
* claves. Deberá entregar un archivo .sql con el script completo de creación  *
* (debe funcionar si se lo ejecuta “tal cual” es entregado). Incluya          *
* comentarios para indicar qué hace cada módulo de código.                    *
* Genere store procedures para manejar la inserción, modificación, borrado    *
* (si corresponde, también debe decidir si determinadas entidades solo        *
* admitirán borrado lógico) de cada tabla."                                   *
*                                                                             *
*******************************************************************************/

GO
USE Com2900G10;


-- SP para la tabla sucursal
GO
CREATE OR ALTER PROCEDURE sucursal.BajaSucursal
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
CREATE OR ALTER PROCEDURE sucursal.CambiarUbicacion
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
CREATE OR ALTER PROCEDURE sucursal.CambiarTelefono
    @id_sucursal        SMALLINT,
    @nuevo_telefono     VARCHAR(50)
AS
BEGIN
    -- Verifica si ya existe la sucursal
    IF EXISTS (SELECT 1 FROM sucursal.sucursal WHERE id_sucursal = @id_sucursal AND activo = 1)
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
CREATE OR ALTER PROCEDURE sucursal.CrearSucursal
    @ciudad VARCHAR(50),
    @reemplazar_por VARCHAR(50),
    @direccion VARCHAR(300),
    @horario VARCHAR(45),
    @telefono CHAR(9)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sucursal.sucursal WHERE @ciudad = ciudad)
        BEGIN
            INSERT INTO sucursal.sucursal 
            VALUES (@ciudad, @reemplazar_por, @direccion, @horario, @telefono, 1);
            
            PRINT 'Sucursal creada correctamente.';
        END

    ELSE
        RAISERROR('La sucursal ya existe.',10,1);
END;


GO
CREATE OR ALTER PROCEDURE sucursal.AltaSucursal 
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