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
CREATE OR ALTER PROCEDURE sucursal.ModificarEmpleado
	@legajo INT,
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
	IF @legajo IS NULL
	BEGIN
		RAISERROR('Debe ingresar el legajo del empleado a actualizar',10,1);

		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM sucursal.sucursal WHERE id_sucursal = @id_sucursal and activo = 1)
	BEGIN
		RAISERROR('La sucursal del empleado no existe o esta inactiva',10,1);

		RETURN
	END

    -- Verifica si el empleado existe y está activo
    IF EXISTS (SELECT 1 FROM sucursal.empleado WHERE legajo = @legajo AND activo = 1)
    BEGIN
        UPDATE sucursal.empleado
        SET
			nombre = @nombre,
			apellido = @apellido,
			dni = @dni,
			direccion = @direccion,
			email_personal = @email_personal,
			email_empresa = @email_empresa,
			cuil = @cuil,
			cargo = @cargo,
			turno = @turno,
			id_sucursal = @id_sucursal
        WHERE legajo = @legajo;
        
        PRINT 'Empleado actualizado correctamente.';
    END
    ELSE
    BEGIN
		RAISERROR('El empleado no existe o está inactivo',10,1);
    END
END;

GO
CREATE OR ALTER PROCEDURE sucursal.CrearEmpleado
	@legajo INT,
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
	IF @legajo IS NULL 
	BEGIN
		RAISERROR('Debe ingresar un legajo para el empleado',10,1);

		RETURN
	END

    IF NOT EXISTS (SELECT 1 FROM sucursal.sucursal WHERE id_sucursal =  @id_sucursal AND activo = 1)
    BEGIN
		RAISERROR('La sucursal del empleado no existe o esta inactiva',10,1);

		RETURN
    END

	INSERT INTO sucursal.empleado (legajo, nombre, apellido, dni, direccion, email_personal, email_empresa, cuil, cargo, turno, id_sucursal, activo)
    VALUES (@legajo, @nombre, @apellido, @dni, @direccion, @email_personal, @email_empresa, @cuil, @cargo, @turno, @id_sucursal, 1);
     
END;

GO
CREATE OR ALTER PROCEDURE sucursal.BajaEmpleado
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
		RAISERROR('El empleado no existe o ya esta dado de baja',10,1);
    END
END;
GO

CREATE OR ALTER PROCEDURE sucursal.AltaEmpleado
    @legajo INT
AS
BEGIN
    -- Verifica si el empleado existe y está activo
    IF EXISTS (SELECT 1 FROM sucursal.empleado WHERE legajo = @legajo AND activo = 0)
    BEGIN
        UPDATE sucursal.empleado
        SET activo = 1
        WHERE legajo = @legajo;
        
        PRINT 'Empleado dado de alta.';
    END
    ELSE
    BEGIN
		RAISERROR('El empleado no existe o ya esta dado de alta',10,1);
    END
END;
