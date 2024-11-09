SET @PathLocal = 'D:\Backup\Local\Semanal\FULL' + CONVERT(nvarchar(30), GETDATE(), 105) +'.bak' --105 fuerza el formato italiano dd-mm-yyyy
SET @PathAWS = 'D:\Backup\AWS\Semanal\FULL' + CONVERT(nvarchar(30), GETDATE(), 105) +'.bak' 
/*
Genero el path y nombre de archivo para el backup, el resultado final es por ejemplo D:\Backup\Local\Mensual\FULL09-11-2024.bak
Tambien genero un path en "AWS" para hacer una copia MIRRO en alguna nube/dispositivo secundario
*/

SET @Retencion int = 731 --Declaro un entero (debe ser explicito para RETAINDAYS) para definir dos años de retencion (incluso ante biciestos) de los documentos

BACKUP DATABASE [Com2900G10]
To DISK=@PathLocal
MIRROR To DISK=PathAWS
WITH CHECKSUM,STOP_ON_ERROR,
MEDIANAME = 'Com2900G10-CadenaSupermercado',
NAME = 'FULL-TransaccionesMensuales',
RETAINDAYS = @Retencion;
GO


/*
Genero un backup FULL de las transacciones realizadas, está pensado para ejecutarse cada Semana.
*/