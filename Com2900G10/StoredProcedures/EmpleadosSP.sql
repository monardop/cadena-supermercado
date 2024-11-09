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


-- SP para empleados
GO
CREATE OR ALTER PROCEDURE CambiarTurnoEmpleado
    @legajo INT,
    @nuevoTurno VARCHAR(50)
AS
BEGIN
    -- Verifica si el empleado existe y está activo
    IF EXISTS (SELECT 1 FROM sucursal.empleado WHERE legajo = @legajo AND activo = 1)
    BEGIN
        UPDATE sucursal.empleado
        SET turno = @nuevoTurno
        WHERE legajo = @legajo;
        
        PRINT 'Turno actualizado correctamente.';
    END
    ELSE
    BEGIN
        PRINT 'El empleado no existe o está inactivo.';
    END
END;

GO
CREATE OR ALTER PROCEDURE CambiarCargoEmpleado
    @legajo INT,
    @nuevoCargo VARCHAR(50)
AS
BEGIN
    -- Verifica si el empleado existe y está activo
    IF EXISTS (SELECT 1 FROM sucursal.empleado WHERE legajo = @legajo AND activo = 1)
    BEGIN
        UPDATE sucursal.empleado
        SET cargo = @nuevoCargo
        WHERE legajo = @legajo;
        
        PRINT 'Cargo actualizado correctamente.';
    END
    ELSE
    BEGIN
        PRINT 'El empleado no existe o está inactivo.';
    END
END;

GO
CREATE OR ALTER PROCEDURE AltaEmpleado
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @dni VARCHAR(20),
    @direccion VARCHAR(100),
    @email_personal VARCHAR(100),
    @email_empresa VARCHAR(100),
    @cuil VARCHAR(20),
    @cargo VARCHAR(50),
    @turno VARCHAR(50),
    @id_sucursal INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM sucursal.sucursal WHERE id_sucursal =  @id_sucursal AND activo = 1)
        BEGIN
            INSERT INTO sucursal.empleado (nombre, apellido, dni, direccion, email_personal, email_empresa, cuil, cargo, turno, id_sucursal, activo)
            VALUES (@nombre, @apellido, @dni, @direccion, @email_personal, @email_empresa, @cuil, @cargo, @turno, @id_sucursal, 1);
            
            PRINT 'Empleado agregado exitosamente.';
        END

         ELSE
            BEGIN
                PRINT 'La sucursal no existe o se encuentra inactiva.';
            END
END;

GO
CREATE OR ALTER PROCEDURE BajaEmpleado
    @legajo INT
AS
BEGIN
    -- Verifica si el empleado existe y está activo
    IF EXISTS (SELECT 1 FROM sucursal.empleado WHERE legajo = @legajo AND activo = 1)
    BEGIN
        UPDATE sucursal.empleado
        SET activo = 0
        WHERE legajo = @legajo;
        
        PRINT 'Empleado dado de baja.';
    END
    ELSE
    BEGIN
        PRINT 'El empleado no existe o ya está inactivo.';
    END
END;
