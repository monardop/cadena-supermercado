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
	ALTER TABLE sucursal.empleado ADD encriptado bit default 0
END;
GO

CREATE OR ALTER PROCEDURE EncriptarEmpleados
AS
BEGIN
	OPEN SYMMETRIC KEY clave_simetrica_empleado DECRYPTION BY CERTIFICATE certificado_encriptacion_empleado WITH PASSWORD = 'clave123';
		
		SELECT * INTO empleadoTemporal from sucursal.empleado

		UPDATE sucursal.empleado SET 
			direccion= EncryptByKey(Key_GUID('clave_simetrica'), t.direccion),
			cuil= EncryptByKey(Key_GUID('clave_simetrica'), t.cuil),
			dni= EncryptByKey(Key_GUID('clave_simetrica'), t.dni), 
			email_personal= EncryptByKey(Key_GUID('clave_simetrica'), t.email_personal),
			encriptado= 1
			from empleadoTemporal t
		WHERE sucursal.empleado.legajo = t.legajo AND sucursal.empleado.encriptado = 0

		DROP TABLE empleadoTemporal

	CLOSE SYMMETRIC KEY clave_simetrica_empleado;
END;
GO

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
