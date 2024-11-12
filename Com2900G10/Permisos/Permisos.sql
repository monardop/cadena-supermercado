/*******************************************************************************
*                                                                             *
*                           Entrega 3 - Grupo 10                              *
*                                                                             *
*                           Integrantes:                                      *
*                           43.988.577 Juan Piñan                             *
*                           43.049.457 Matias Matter                          *
*                           42.394.230 Lucas Natario                          *
*                           40.429.974 Pablo Monardo                          *
*                                                                             *
* Cuando un cliente reclama la devolución de un producto se genera una nota   *
* de crédito por el valor del producto o un producto del mismo tipo.          *
* En el caso de que el cliente solicite la nota de crédito, solo los          *
* Supervisores tienen el permiso para generarla.                              *
* Tener en cuenta que la nota de crédito debe estar asociada a una Factura    *
* con estado pagada. Asigne los roles correspondientes para poder cumplir     *
* con este requisito.                                                         *
*                                                                             *
*******************************************************************************/

USE [Com2900G10]
GO

CREATE LOGIN [PepeGerente]
WITH PASSWORD = 'Com2900G10', DEFAULT_DATABASE = Com2900G10,
CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF ;
GO

CREATE USER [PepeGerente] FOR LOGIN [PepeGerente]
GO


CREATE LOGIN [JoseCajero]
WITH PASSWORD = 'Com2900G10', DEFAULT_DATABASE = Com2900G10,
CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF ;
GO

CREATE USER [JoseCajero] FOR LOGIN [JoseCajero]
GO


CREATE LOGIN [FitoRepositor]
WITH PASSWORD = 'Com2900G10', DEFAULT_DATABASE = Com2900G10,
CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF ;
GO

CREATE USER [FitoRepositor] FOR LOGIN [FitoRepositor]
GO

/*


-- permisos otorgados explicitamente
SELECT
    perms.state_desc AS State,
    permission_name AS [Permission],
    obj.name AS [on Object],
    dp.name AS [to User Name]
FROM sys.database_permissions AS perms
JOIN sys.database_principals AS dp
    ON perms.grantee_principal_id = dp.principal_id
JOIN sys.objects AS obj
    ON perms.major_id = obj.object_id;

*/

/*******************************************************************************
						Rol: Supervisor
*******************************************************************************/

CREATE ROLE supervisor AUTHORIZATION dbo;
ALTER ROLE supervisor ADD MEMBER PepeGerente;

GRANT SELECT ON SCHEMA::producto to supervisor
GRANT INSERT ON SCHEMA::producto to supervisor
GRANT UPDATE ON SCHEMA::producto to supervisor

GRANT SELECT ON SCHEMA::sucursal to supervisor
GRANT INSERT  ON SCHEMA::sucursal to supervisor
GRANT UPDATE ON SCHEMA::producto to supervisor

GRANT SELECT ON SCHEMA::venta to supervisor
-- Para la venta somos mas estrictos y damos permisos por SP unicamente
GRANT EXECUTE ON OBJECT::venta.CrearFactura to supervisor
GRANT EXECUTE ON OBJECT::venta.ModificarFactura to supervisor
GRANT EXECUTE ON OBJECT::venta.SetFacturaPagada to supervisor
GRANT EXECUTE ON OBJECT::venta.CrearDetalleFactura to supervisor
GRANT EXECUTE ON OBJECT::venta.ModificarDetalleFactura to supervisor
GRANT EXECUTE ON OBJECT::venta.CrearMedioPago to supervisor
GRANT EXECUTE ON OBJECT::venta.ModificarMedioPago to supervisor
GRANT EXECUTE ON OBJECT::venta.CrearNotaCreditoParcial to supervisor
GRANT EXECUTE ON OBJECT::venta.CrearNotaCreditoTotal to supervisor

/*******************************************************************************
						Rol: Cajero
*******************************************************************************/
CREATE ROLE cajero AUTHORIZATION dbo;
ALTER ROLE cajero ADD MEMBER JoseCajero;

GRANT SELECT ON SCHEMA::producto to cajero

GRANT SELECT ON SCHEMA::sucursal to cajero

GRANT SELECT ON SCHEMA::venta to cajero
-- Para la venta somos mas estrictos y damos permisos por SP unicamente
GRANT EXECUTE ON OBJECT::venta.CrearFactura to cajero
GRANT EXECUTE ON OBJECT::venta.ModificarFactura to cajero
GRANT EXECUTE ON OBJECT::venta.SetFacturaPagada to cajero
GRANT EXECUTE ON OBJECT::venta.CrearDetalleFactura to cajero
GRANT EXECUTE ON OBJECT::venta.ModificarDetalleFactura to cajero

/*******************************************************************************
						Rol: repositor
*******************************************************************************/
CREATE ROLE repositor AUTHORIZATION dbo;
ALTER ROLE repositor ADD MEMBER FitoRepositor;

GRANT SELECT ON SCHEMA::producto to repositor