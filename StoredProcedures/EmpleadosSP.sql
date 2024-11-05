GO
USE supermercado_aurora;


-- SP para empleados
GO
CREATE PROCEDURE CambiarTurnoEmpleado
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
CREATE PROCEDURE CambiarCargoEmpleado
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
CREATE PROCEDURE AltaEmpleado
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
CREATE PROCEDURE BajaEmpleado
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
