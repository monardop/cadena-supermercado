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

DECLARE @PathLocal varchar(500) = [configuracion].[obtener_path_backup_incremental]()

DECLARE @Retencion date= DATEADD(dd,2,GETDATE())
--Declaro una fecha de eliminacion igual a DOS dias despues de la ejecucion de este log.

BACKUP LOG [Com2900G10]
To DISK=@PathLocal
WITH FORMAT,CHECKSUM,STOP_ON_ERROR,
MEDIANAME = 'Com2900G10-CadenaSupermercado',
NAME = 'Log-TransaccionesPorHora',
EXPIREDATE=@Retencion;
GO

-- Se genera un backup incremental de las transacciones realizadas, planeado para ejecutarse cada una hora.
