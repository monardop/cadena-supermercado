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

DECLARE @PathLocal varchar(50)= 'D:\Backup\Local\Diario\DIFF' + CONVERT(nvarchar(30), GETDATE(), 105) +'.bak' --105 fuerza el formato italiano dd-mm-yyyy
--Genero el path y nombre de archivo para el backup, el resultado final es por ejemplo D:\Backup\Local\Diario\DIFF09-11-2024.bak
DECLARE @PathRemoto  varchar(50)= 'D:\Backup\Remoto\Diario\DIFF' + CONVERT(nvarchar(30), GETDATE(), 105) +'.bak' 
--Tambien genero un path en "Remoto" para hacer una copia MIRRO en alguna nube/dispositivo secundario

DECLARE @Retencion int = 731 --Declaro un entero (debe ser explicito para RETAINDAYS) para definir dos años de retencion (incluso ante biciestos) de los documentos

BACKUP DATABASE [Com2900G10] 
To DISK=@PathLocal
MIRROR To DISK=@PathRemoto
WITH FORMAT, DIFFERENTIAL,CHECKSUM,STOP_ON_ERROR,
MEDIANAME = 'Com2900G10-CadenaSupermercado',
NAME = 'DIFF-TransaccionesDiarias',
RETAINDAYS = @Retencion;
GO

-- Se genera un backup DIFERENCIAL de las transacciones realizadas en el dia, planeado para ejecutarse una vez por dia.