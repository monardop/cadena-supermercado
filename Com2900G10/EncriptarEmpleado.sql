CREATE OR ALTER PROCEDURE ConfigurarEncriptacionEmpleado
AS
BEGIN
	CREATE CERTIFICATE certificado_encriptacion_empleado ENCRYPTION BY PASSWORD = 'clave123'
	WITH SUBJECT = 'Certificado Encriptacion Empleado';

	CREATE SYMMETRIC KEY clave_simetrica_empleado WITH ALGORITHM = AES_256 
	ENCRYPTION BY CERTIFICATE certificado_encriptacion_empleado
	ALTER TABLE sucursal.empleado ALTER COLUMN dni nvarchar(256)
	ALTER TABLE sucursal.empleado ALTER COLUMN direccion nvarchar(256)
	ALTER TABLE sucursal.empleado ALTER COLUMN email_personal nvarchar(256)
	ALTER TABLE sucursal.empleado ALTER COLUMN cuil nvarchar(256)
	ALTER TABLE sucursal.empleado ADD encriptado bit default 0 not null
END;
GO

EXEC ConfigurarEncriptacionEmpleado

CREATE OR ALTER PROCEDURE EncriptarEmpleados
AS
BEGIN
	OPEN SYMMETRIC KEY clave_simetrica_empleado DECRYPTION BY CERTIFICATE certificado_encriptacion_empleado WITH PASSWORD = 'clave123';
		
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

EXEC EncriptarEmpleados

--select * FROM sucursal.empleado

CREATE OR ALTER PROCEDURE DesencriptarEmpleados
AS
BEGIN
	OPEN SYMMETRIC KEY clave_simetrica_empleado DECRYPTION BY CERTIFICATE certificado_encriptacion_empleado WITH PASSWORD= 'clave123';
		UPDATE sucursal.empleado SET 
			direccion= CONVERT(nvarchar(256),DECRYPTBYKEY(direccion)),
			cuil= CONVERT(nvarchar(256),DECRYPTBYKEY(cuil)),
			dni= CONVERT(nvarchar(256),DECRYPTBYKEY(dni)),
			email_personal= CONVERT(nvarchar(256),DECRYPTBYKEY(email_personal)),
			encriptado= 0
		WHERE encriptado = 1
	CLOSE SYMMETRIC KEY clave_simetrica_empleado;
END;
GO

CREATE OR ALTER PROCEDURE LeerEmpleadoEncriptado
AS
BEGIN
	OPEN SYMMETRIC KEY clave_simetrica_empleado DECRYPTION BY CERTIFICATE certificado_encriptacion_empleado WITH PASSWORD = 'clave123';
		SELECT * FROM sucursal.empleado
		SELECT
		legajo,nombre,apellido,
		CONVERT(nvarchar(256),DECRYPTBYKEY(dni)) as dni,
		CONVERT(nvarchar(256),DECRYPTBYKEY(direccion)) as direccion,
		CONVERT(nvarchar(256),DECRYPTBYKEY(email_personal)) as email_personal,
		email_empresa,
		CONVERT(nvarchar(256),DECRYPTBYKEY(cuil)) as cuil,
		cargo,id_sucursal,turno,activo
		FROM sucursal.empleado
	CLOSE SYMMETRIC KEY clave_simetrica_empleado;
END;
GO
EXEC LeerEmpleadoEncriptado

SELECT * FROM sucursal.empleado