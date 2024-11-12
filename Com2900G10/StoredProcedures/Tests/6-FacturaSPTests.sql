/*******************************************************************************
*                                                                             *
*                           Entrega 3 - Grupo 10                              *
*																			  *
*                           Integrantes:                                      *
*                           43.988.577 Juan Piñan                             *
*                           43.049.457 Matias Matter                          *
*                           42.394.230 Lucas Natario                          *
*                           40.429.974 Pablo Monardo                          *
*                                                                             *
*                                                                             *
* "Cree la base de datos, entidades y relaciones. Incluya restricciones y     *
* claves. Deberá entregar un archivo .sql con el script completo de creación  *
* (debe funcionar si se lo ejecuta “tal cual” es entregado). Incluya          *
* comentarios para indicar qué hace cada módulo de código.                    *
* Genere store procedures para manejar la inserción, modificación, borrado    *
* (si corresponde, también debe decidir si determinadas entidades solo        *
* admitirán borrado lógico) de cada tabla."                                   *
*                                                                             *
*******************************************************************************/

USE [Com2900G10]
GO
/*******************************************************************************
						SP: CrearFactura
*******************************************************************************/
--SELECT * FROM [Com2900G10].[sucursal].[empleado]
/* Resultado esperado: Insercion OK*/
EXEC [Com2900G10].[venta].[CrearFactura] '000-0-005',1,123456, 1, 'A','Consumidor Final','2024-11-09 09:00',1

/* Resultado esperado: Error - "El medio de pago de la factura no existe" */
EXEC [Com2900G10].[venta].[CrearFactura] '000-0-005', 999,123456,1,'A','Consumidor Final','2024-11-09 09:00',1

/* Resultado esperado: Error - "El empleado generador de la factura no existe o esta inactivo" */
EXEC [Com2900G10].[venta].[CrearFactura] '000-0-005', 1,9999,1,'A','Consumidor Final','2024-11-09 09:00',1

/* Resultado esperado: Error - "La sucursal de la factura no existe o esta inactiva" */
EXEC [Com2900G10].[venta].[CrearFactura] '000-0-005', 1,123456,1,'A','Consumidor Final','2024-11-09 09:00', 999

/* Resultado esperado: Error - "El cliente a facturar no existe" */
EXEC [Com2900G10].[venta].[CrearFactura] '000-0-005', 1,123456, 99, 'A','Consumidor Final','2024-11-09 09:00',1

/*******************************************************************************
						SP: ModificarFactura
*******************************************************************************/

/* Resultado esperado: Modificacion OK*/
EXEC [Com2900G10].[venta].[ModificarFactura] 1,'000-0-006', 1,123456,1,'B','Consumidor Final','2024-11-09 09:00',1,100

/* Resultado esperado: Error - "La factura no existe" */
EXEC [Com2900G10].[venta].[ModificarFactura] 999,'000-0-005', 1,123456,1,'B','Consumidor Final','2024-11-09 09:00',1,100

/* Resultado esperado: Error - "El medio de pago de la factura no existe" */
EXEC [Com2900G10].[venta].[ModificarFactura] 1,'000-0-005', 999,123456,1,'B','Consumidor Final','2024-11-09 09:00',1,100

/* Resultado esperado: Error - "El cliente a facturar no existe." */
EXEC [Com2900G10].[venta].[ModificarFactura] 2,'000-0-005', 1,123456,99,'B','Consumidor Final','2024-11-09 09:00',1,100