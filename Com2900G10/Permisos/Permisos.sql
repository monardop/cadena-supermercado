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

IF EXISTS (select 1 from master.dbo.syslogins  where name = 'PepeGerente')
	DROP LOGIN [PepeGerente]

CREATE LOGIN [PepeGerente]
WITH PASSWORD = 'Com2900G10', DEFAULT_DATABASE = Com2900G10,
CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF ;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals  WHERE name = 'PepeGerente')
	DROP USER [PepeGerente]

CREATE USER [PepeGerente] FOR LOGIN [PepeGerente]
GO

IF EXISTS (select 1 from master.dbo.syslogins  where name = 'JoseCajero')
	DROP LOGIN [JoseCajero]

CREATE LOGIN [JoseCajero]
WITH PASSWORD = 'Com2900G10', DEFAULT_DATABASE = Com2900G10,
CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF ;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals  WHERE name = 'JoseCajero')
	DROP USER [JoseCajero]

CREATE USER [JoseCajero] FOR LOGIN [JoseCajero]
GO

IF EXISTS (select 1 from master.dbo.syslogins  where name = 'FitoRepositor')
	DROP LOGIN [FitoRepositor]

CREATE LOGIN [FitoRepositor]
WITH PASSWORD = 'Com2900G10', DEFAULT_DATABASE = Com2900G10,
CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF ;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals  WHERE name = 'FitoRepositor')
	DROP USER [FitoRepositor]

CREATE USER [FitoRepositor] FOR LOGIN [FitoRepositor]
GO

/*


-- permisos otorgados explicitamente
SELECT
    perms.state_desc AS State,
    permission_name AS [Permission],
    obj.name AS [on Object],
	--perms.*,
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

IF EXISTS (select 1 from sys.database_principals where name='supervisor' and Type = 'R')
BEGIN 
	-- Vacio los miembros
	DECLARE @rolename sysname = 'supervisor';
	DECLARE @cmd AS NVARCHAR(MAX) = N'';

	SELECT @cmd = @cmd + '
		ALTER ROLE ' + QUOTENAME(@rolename) + ' DROP MEMBER ' + QUOTENAME(members.[name]) + ';'
	FROM sys.database_role_members AS rolemembers
		JOIN sys.database_principals AS roles 
			ON roles.[principal_id] = rolemembers.[role_principal_id]
		JOIN sys.database_principals AS members 
			ON members.[principal_id] = rolemembers.[member_principal_id]
	WHERE roles.[name]=@rolename

	EXEC sp_executesql @cmd;

	DROP ROLE supervisor

END
GO

CREATE ROLE supervisor AUTHORIZATION dbo;
ALTER ROLE supervisor ADD MEMBER PepeGerente;

GRANT SELECT ON SCHEMA::producto to supervisor
GRANT INSERT ON SCHEMA::producto to supervisor
GRANT UPDATE ON SCHEMA::producto to supervisor

GRANT SELECT ON SCHEMA::sucursal to supervisor
GRANT INSERT  ON SCHEMA::sucursal to supervisor
GRANT UPDATE ON SCHEMA::producto to supervisor

GRANT SELECT ON SCHEMA::venta to supervisor

GRANT EXECUTE ON SCHEMA::reportes to supervisor

-- Para la venta somos mas estrictos y damos permisos por SP unicamente
GRANT EXECUTE ON OBJECT::venta.CrearVentaConFactura to supervisor
GRANT EXECUTE ON OBJECT::venta.CrearMedioPago to supervisor
GRANT EXECUTE ON OBJECT::venta.ModificarMedioPago to supervisor
GRANT EXECUTE ON OBJECT::venta.CrearNotaCreditoParcial to supervisor
GRANT EXECUTE ON OBJECT::venta.CrearNotaCreditoTotal to supervisor

/*******************************************************************************
						Rol: Cajero
*******************************************************************************/

IF EXISTS (select 1 from sys.database_principals where name='cajero' and Type = 'R')
BEGIN 
	-- Vacio los miembros
	DECLARE @rolename sysname = 'cajero';
	DECLARE @cmd AS NVARCHAR(MAX) = N'';

	SELECT @cmd = @cmd + '
		ALTER ROLE ' + QUOTENAME(@rolename) + ' DROP MEMBER ' + QUOTENAME(members.[name]) + ';'
	FROM sys.database_role_members AS rolemembers
		JOIN sys.database_principals AS roles 
			ON roles.[principal_id] = rolemembers.[role_principal_id]
		JOIN sys.database_principals AS members 
			ON members.[principal_id] = rolemembers.[member_principal_id]
	WHERE roles.[name]=@rolename

	EXEC sp_executesql @cmd;

	DROP ROLE cajero

END
GO

CREATE ROLE cajero AUTHORIZATION dbo;
ALTER ROLE cajero ADD MEMBER JoseCajero;

GRANT SELECT ON SCHEMA::producto to cajero

GRANT SELECT ON SCHEMA::sucursal to cajero

GRANT SELECT ON SCHEMA::venta to cajero
-- Para la venta somos mas estrictos y damos permisos por SP unicamente
GRANT EXECUTE ON OBJECT::venta.CrearVentaConFactura to cajero
/*******************************************************************************
						Rol: repositor
*******************************************************************************/


IF EXISTS (select 1 from sys.database_principals where name='repositor' and Type = 'R')
BEGIN 
	-- Vacio los miembros
	DECLARE @rolename sysname = 'repositor';
	DECLARE @cmd AS NVARCHAR(MAX) = N'';

	SELECT @cmd = @cmd + '
		ALTER ROLE ' + QUOTENAME(@rolename) + ' DROP MEMBER ' + QUOTENAME(members.[name]) + ';'
	FROM sys.database_role_members AS rolemembers
		JOIN sys.database_principals AS roles 
			ON roles.[principal_id] = rolemembers.[role_principal_id]
		JOIN sys.database_principals AS members 
			ON members.[principal_id] = rolemembers.[member_principal_id]
	WHERE roles.[name]=@rolename

	EXEC sp_executesql @cmd;

	DROP ROLE repositor

END
GO


CREATE ROLE repositor AUTHORIZATION dbo;
ALTER ROLE repositor ADD MEMBER FitoRepositor;

GRANT SELECT ON SCHEMA::producto to repositor