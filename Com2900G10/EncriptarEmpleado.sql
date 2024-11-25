/*******************************************************************************
*                                                                             *
*                           Entrega 5 - Grupo 10                              *
*																			  *
*                           Integrantes:                                      *
*                           43.988.577 Juan Piñan                             *
*                           43.049.457 Matias Matter                          *
*                           42.394.230 Lucas Natario                          *
*                           40.429.974 Pablo Monardo                          *
*                                                                             *
*                                                                             *                         
*                                                                             *
*******************************************************************************/
-- Setup de encriptacion de datos de empleados

USE Com2900G10
GO

CREATE OR ALTER PROCEDURE ConfigurarEncriptacionEmpleado
AS
BEGIN
	CREATE SYMMETRIC KEY clave_simetrica_empleado WITH ALGORITHM = AES_256 
	ENCRYPTION BY PASSWORD = 'clave123'
	ALTER TABLE sucursal.empleado ALTER COLUMN dni nvarchar(256)
	ALTER TABLE sucursal.empleado ALTER COLUMN direccion nvarchar(256)
	ALTER TABLE sucursal.empleado ALTER COLUMN email_personal nvarchar(256)
	ALTER TABLE sucursal.empleado ALTER COLUMN cuil nvarchar(256)
	ALTER TABLE sucursal.empleado ADD encriptado bit default 0 not null
	
END;
GO

ALTER PROCEDURE sucursal.CrearEmpleado
@legajo INT,
@nombre VARCHAR(50),
@apellido VARCHAR(50),
@dni NVARCHAR(256),
@direccion NVARCHAR(256),
@email_personal NVARCHAR(256),
@email_empresa VARCHAR(100),
@cuil NVARCHAR(256),
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

	OPEN SYMMETRIC KEY clave_simetrica_empleado DECRYPTION BY PASSWORD = 'clave123';
	INSERT INTO sucursal.empleado (dni, direccion, email_personal, cuil, legajo, nombre, apellido, email_empresa, cargo, turno, id_sucursal, activo,encriptado)
	VALUES (
	EncryptByKey(Key_GUID('clave_simetrica_empleado'), @dni),
	EncryptByKey(Key_GUID('clave_simetrica_empleado'), @direccion),
	EncryptByKey(Key_GUID('clave_simetrica_empleado'), @email_personal),
	EncryptByKey(Key_GUID('clave_simetrica_empleado'), @cuil),
	@legajo,@nombre, @apellido,@email_empresa, @cargo, @turno, @id_sucursal, 1,1);
	CLOSE SYMMETRIC KEY clave_simetrica_empleado;
END;
GO
-- Encriptacion inicial de empleados
CREATE OR ALTER PROCEDURE EncriptarEmpleados
AS
BEGIN
	OPEN SYMMETRIC KEY clave_simetrica_empleado DECRYPTION BY PASSWORD = 'clave123';

		SELECT * INTO empleadoTemporal from sucursal.empleado

		UPDATE sucursal.empleado SET 
			direccion= EncryptByKey(Key_GUID('clave_simetrica_empleado'), t.direccion),
			cuil= EncryptByKey(Key_GUID('clave_simetrica_empleado'), t.cuil),
			dni= EncryptByKey(Key_GUID('clave_simetrica_empleado'), t.dni), 
			email_personal= EncryptByKey(Key_GUID('clave_simetrica_empleado'), t.email_personal),
			encriptado= 1
			from empleadoTemporal t
		WHERE sucursal.empleado.legajo = t.legajo AND sucursal.empleado.encriptado = 0

		DROP TABLE empleadoTemporal

	CLOSE SYMMETRIC KEY clave_simetrica_empleado;
END;
GO

-- Desencriptar empleados
CREATE OR ALTER PROCEDURE DesencriptarEmpleados
@password NVARCHAR(100)
AS
BEGIN
	IF @password <> 'clave123'
		RAISERROR ('Contraseña incorrecta.',10,1);
	ELSE
	OPEN SYMMETRIC KEY clave_simetrica_empleado DECRYPTION BY PASSWORD = 'clave123';
		UPDATE sucursal.empleado SET 
			direccion= CONVERT(nvarchar(256),DECRYPTBYKEY(direccion)),
			cuil= CONVERT(nvarchar(256),DECRYPTBYKEY(cuil)),
			dni= CONVERT(nvarchar(256),DECRYPTBYKEY(dni)), 
			email_personal= CONVERT(nvarchar(256),DECRYPTBYKEY(email_personal)),
			encriptado= 0
		WHERE sucursal.empleado.encriptado = 1

	CLOSE SYMMETRIC KEY clave_simetrica_empleado;
END;
GO

-- Lectura desencriptada de empleados
CREATE OR ALTER PROCEDURE LeerEmpleadoEncriptado
@password NVARCHAR(100)
AS
BEGIN
	IF @password <> 'clave123'
		RAISERROR ('Contraseña incorrecta.',10,1);
	ELSE
		OPEN SYMMETRIC KEY clave_simetrica_empleado DECRYPTION BY PASSWORD = 'clave123';
			SELECT
			legajo,nombre,apellido,
			ISNULL(CONVERT(nvarchar(256),DECRYPTBYKEY(dni)),dni) as dni,
			ISNULL(CONVERT(nvarchar(256),DECRYPTBYKEY(direccion)),direccion) as direccion,
			ISNULL(CONVERT(nvarchar(256),DECRYPTBYKEY(email_personal)),email_personal) as email_personal,
			email_empresa,
			ISNULL(CONVERT(nvarchar(256),DECRYPTBYKEY(cuil)),cuil) as cuil,
			cargo,id_sucursal,turno,activo
			FROM sucursal.empleado
		CLOSE SYMMETRIC KEY clave_simetrica_empleado;
END;
GO