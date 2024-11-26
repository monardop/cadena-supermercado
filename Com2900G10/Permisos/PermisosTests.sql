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

/*
Helper: 
SELECT CURRENT_USER AS 'Current User Name';  
*/

/*******************************************************************************
						Rol: Supervisor
*******************************************************************************/

/* Resultado esperado: Puede ver producto*/
execute as login = 'PepeGerente';
SELECT * FROM producto.producto;

/* Resultado esperado: Puede ver sucursal*/
execute as login = 'PepeGerente';
SELECT * FROM sucursal.sucursal;

/* Resultado esperado: Puede ver factura*/
execute as login = 'PepeGerente';
SELECT * FROM venta.factura;

/* Resultado esperado: Error - No puede insertar una NC directamente*/
execute as login = 'PepeGerente';
INSERT INTO venta.nota_credito VALUES ('000-00-9',1,10);

/* Resultado esperado: Ok - Puede generar la NC desde el SP 
(Puede tirar error de que ya existe una NC o ya se cubre el total de la factura , pero es parte de poder ejecutarlo) */
execute as login = 'PepeGerente';
EXEC venta.CrearNotaCreditoTotal 1, '000-00-9'

/* Resultado esperado: Ok - Puede generar la NC desde el SP 
(Puede tirar error de que ya existe una NC o ya se cubre el total de la factura , pero es parte de poder ejecutarlo) */
execute as login = 'PepeGerente';
EXEC venta.CrearNotaCreditoParcial 1, '000-00-9', 100
GO

/*******************************************************************************
						Rol: Cajero
*******************************************************************************/

/* Resultado esperado: Puede ver producto*/
execute as login = 'JoseCajero';
SELECT * FROM producto.producto;

/* Resultado esperado: Puede ver factura*/
execute as login = 'JoseCajero';
SELECT * FROM venta.factura;

/* Resultado esperado: Error - No puede insertar una factura directamente*/
execute as login = 'JoseCajero';
INSERT INTO venta.factura VALUES ('000-00-9',1,1,1,1,'A','Normal','2024-11-1',1,10,1);
GO

/* Resultado esperado: Ok - Puede generar factura usando SP */
execute as login = 'JoseCajero';
/* Resultado esperado: Puede crear una factura */
		DECLARE @legajo INT = 257020;
		DECLARE @id_punto_venta_empleado INT = 2;
		DECLARE @productos VARCHAR(400) = '1,3;3,2;2,1'; -- {producto},{cantidad};{producto},{cantidad};...
		DECLARE @id_cliente INT = 1;
		DECLARE @tipo_factura CHAR(1) = 'A';
		DECLARE @numero_factura VARCHAR(11) = '000-01-012';
		DECLARE @id_medio_pago SMALLINT = 3;
		DECLARE @identificador_pago VARCHAR(200) = 'A3C-S1A-X90';
		EXEC [Com2900G10].[venta].[CrearVentaConFactura] 
			@legajo,
			@id_punto_venta_empleado, 
			@productos, 
			@id_cliente, 
			@tipo_factura, 
			@numero_factura,
			@id_medio_pago,
			@identificador_pago;
GO

/* Resultado esperado: Error - No puede insertar una NC directamente*/
execute as login = 'JoseCajero';
INSERT INTO venta.nota_credito VALUES ('000-00-9',1,10);

/* Resultado esperado: Error - No puede insertar una NC por SP tampoco (Solo supervisores pueden)*/
execute as login = 'JoseCajero';
EXEC venta.CrearNotaCreditoTotal 1, '000-00-9'

/*******************************************************************************
						Rol: Repositor
*******************************************************************************/

/* Resultado esperado: Puede ver producto*/
execute as login = 'FitoRepositor';
SELECT * FROM producto.producto;

/* Resultado esperado: No puede ver facturas*/
execute as login = 'FitoRepositor';
SELECT * FROM venta.factura;

/* Resultado esperado: No puede ver sucursales*/
execute as login = 'FitoRepositor';
SELECT * FROM sucursal.sucursal;

/* Resultado esperado: No puede usar SPs de venta*/
execute as login = 'FitoRepositor';
EXEC venta.CrearNotaCreditoTotal 1, '0000-0-1'
