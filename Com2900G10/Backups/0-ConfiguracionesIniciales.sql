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
* "La información de las ventas es de vital importancia para el negocio,      *
* por ello se requiere que se establezcan políticas de respaldo tanto en las  *
* ventas diarias generadas como en los reportes generados.                    *
* Plantee una política de respaldo adecuada para cumplir con este requisito   *
* y justifique la misma.                                                      *
*                                                                             *
* La politica se encuentra formalizada dentro del documebto README.md del     *
* repositorio,a continuacion se adjunta la ejecucion de la misma              *
*******************************************************************************/
ALTER DATABASE Com2900G10 SET RECOVERY FULL;

USE Com2900G10
GO

CREATE OR ALTER FUNCTION [configuracion].[obtener_clave_path_backups]()
RETURNS VARCHAR(100)
AS 
BEGIN
	RETURN 'path_backups'
END
GO

IF NOT EXISTS (SELECT 1 FROM configuracion.parametros_generales WHERE descripcion = configuracion.obtener_clave_path_backups())
BEGIN
	INSERT INTO configuracion.parametros_generales(descripcion,valor)
	VALUES (configuracion.obtener_clave_path_backups(),'E:\Backups\');
END
GO

CREATE OR ALTER FUNCTION [configuracion].[obtener_path_backup_diferencial]()
RETURNS VARCHAR(100)
AS 
BEGIN
	DECLARE @pathBase VARCHAR(300);
	SELECT @pathBase = valor FROM configuracion.parametros_generales WHERE descripcion = configuracion.obtener_clave_path_backups()



	RETURN @pathBase + 'DIFF' + CONVERT(nvarchar(30), GETDATE(), 105) +'.bak' --105 fuerza el formato italiano dd-mm-yyyy
END;
GO

CREATE OR ALTER FUNCTION [configuracion].[obtener_path_backup_full]()
RETURNS VARCHAR(100)
AS 
BEGIN
	DECLARE @pathBase VARCHAR(300);
	SELECT @pathBase = valor FROM configuracion.parametros_generales WHERE descripcion = configuracion.obtener_clave_path_backups()



	RETURN @pathBase + 'FULL' + CONVERT(nvarchar(30), GETDATE(), 105) +'.bak' --105 fuerza el formato italiano dd-mm-yyyy
END;
GO

CREATE OR ALTER FUNCTION [configuracion].[obtener_path_backup_incremental]()
RETURNS VARCHAR(100)
AS 
BEGIN
	DECLARE @pathBase VARCHAR(300);
	SELECT @pathBase = valor FROM configuracion.parametros_generales WHERE descripcion = configuracion.obtener_clave_path_backups()



	RETURN @pathBase + 'LOG' + CONVERT(nvarchar(30), GETDATE(), 105) +'.bak' --105 fuerza el formato italiano dd-mm-yyyy
END;
GO


