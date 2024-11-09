SET @PathLocal = 'D:\Backup\Local\Diario\LOG' + CONVERT(varchar(10), GETDATE(), 105) +'.bak' --105 fuerza el formato italiano dd-mm-yyyy
/*
Genero el path y nombre de archivo para el backup, el resultado final es por ejemplo D:\Backup\Local\Mensual\FULL09-11-2024.bak
*/

BACKUP LOG [Com2900G10]
To DISK=@PathLocal
WITH CHECKSUM,STOP_ON_ERROR
MEDIANAME = 'Com2900G10-CadenaSupermercado',
NAME = 'Log-TransaccionesPorHora',
EXPIREDATE=DATEADD(DAY,2,GETDATE());
GO

/*
Genero un backup incremental de las transacciones realizadas, está pensado para ejecutarse cada una hora.
*/