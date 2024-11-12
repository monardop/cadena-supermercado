CREATE SCHEMA configuracion
GO

CREATE OR ALTER PROCEDURE configuracion.ConfigurarEncriptacionEmpleado
AS
BEGIN
	CREATE CERTIFICATE certificado_encriptacion_empleado ENCRYPTION BY PASSWORD = 'clave123'
	WITH SUBJECT = 'Certificado Encriptacion Empleado';

	CREATE SYMMETRIC KEY clave_simetrica_empleado WITH ALGORITHM = AES_256 
	ENCRYPTION BY CERTIFICATE certificado_encriptacion_empleado

	ALTER TABLE sucursal.empleado DROP CONSTRAINT CK_Empleado_Cuil;

	ALTER TABLE sucursal.empleado ALTER COLUMN nombre nvarchar(MAX)
	ALTER TABLE sucursal.empleado ALTER COLUMN apellido nvarchar(MAX)
	ALTER TABLE sucursal.empleado ALTER COLUMN dni nvarchar(MAX)
	ALTER TABLE sucursal.empleado ALTER COLUMN direccion nvarchar(MAX)
	ALTER TABLE sucursal.empleado ALTER COLUMN email_personal nvarchar(MAX)
	ALTER TABLE sucursal.empleado ALTER COLUMN email_empresa nvarchar(MAX)
	ALTER TABLE sucursal.empleado ALTER COLUMN cargo nvarchar(MAX)
	ALTER TABLE sucursal.empleado ALTER COLUMN cuil nvarchar(MAX)
	ALTER TABLE sucursal.empleado ADD encriptado bit NOT NULL default 0
END;
GO

EXEC configuracion.ConfigurarEncriptacionEmpleado
GO

CREATE OR ALTER PROCEDURE configuracion.EncriptarEmpleados
AS
BEGIN
	OPEN SYMMETRIC KEY clave_simetrica_empleado DECRYPTION BY CERTIFICATE certificado_encriptacion_empleado WITH PASSWORD = 'clave123';
		
		SELECT * INTO empleadoTemporal from sucursal.empleado

		UPDATE sucursal.empleado SET 
			nombre= EncryptByKey(Key_GUID(N'clave_simetrica_empleado'), t.nombre),
			apellido= EncryptByKey(Key_GUID('clave_simetrica_empleado'), t.apellido),
			direccion= EncryptByKey(Key_GUID('clave_simetrica_empleado'), t.direccion),
			cuil= EncryptByKey(Key_GUID('clave_simetrica_empleado'), t.cuil),
			dni= EncryptByKey(Key_GUID('clave_simetrica_empleado'), t.dni), 
			email_personal= EncryptByKey(Key_GUID('clave_simetrica_empleado'), t.email_personal),
			email_empresa= EncryptByKey(Key_GUID('clave_simetrica_empleado'), t.email_empresa),
			cargo= EncryptByKey(Key_GUID('clave_simetrica_empleado'), t.cargo),
			encriptado= 1
			from empleadoTemporal t
		WHERE sucursal.empleado.legajo = t.legajo AND sucursal.empleado.encriptado = 0

		DROP TABLE empleadoTemporal

	CLOSE SYMMETRIC KEY clave_simetrica_empleado;
END;
GO

/*
UPDATE sucursal.empleado SET nombre = 'test', encriptado = 0
EXEC configuracion.EncriptarEmpleados
SELECT * FROM sucursal.empleado
*/
CREATE OR ALTER PROCEDURE configuracion.DesencriptarEmpleados
AS
BEGIN
	OPEN SYMMETRIC KEY clave_simetrica_empleado DECRYPTION BY CERTIFICATE certificado_encriptacion_empleado WITH PASSWORD= 'clave123';
		UPDATE sucursal.empleado SET 
			direccion= CONVERT(varchar(256),DECRYPTBYKEY(direccion)),
			cuil= CONVERT(varchar(256),DECRYPTBYKEY(cuil)),
			dni= CONVERT(varchar(256),DECRYPTBYKEY(dni)),
			email_personal= CONVERT(varchar(256),DECRYPTBYKEY(email_personal)),
			encriptado= 0
		WHERE encriptado = 1
	CLOSE SYMMETRIC KEY clave_simetrica_empleado;
END;
GO

/*
EXEC configuracion.DesencriptarEmpleados
SELECT * FROM sucursal.empleado
*/

CREATE OR ALTER PROCEDURE LeerEmpleadoEncriptado
AS
BEGIN
	OPEN SYMMETRIC KEY clave_simetrica_empleado DECRYPTION BY CERTIFICATE certificado_encriptacion_empleado WITH PASSWORD = 'clave123';
		SELECT
		legajo,nombre,apellido,
		CONVERT(varchar(256),DECRYPTBYKEY(dni)),
		CONVERT(varchar(256),DECRYPTBYKEY(direccion)),
		CONVERT(varchar(256),DECRYPTBYKEY(email_personal)),
		email_empresa,
		CONVERT(varchar(256),DECRYPTBYKEY(cuil)),
		cargo,id_sucursal,turno,activo
		FROM sucursal.empleado
	CLOSE SYMMETRIC KEY clave_simetrica_empleado;
END;
GO

