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
--SELECT * FROM [Com2900G10].[sucursal].[nota_credito]
/* Resultado esperado: Insercion OK*/
EXEC [Com2900G10].[venta].[CrearNotaCreditoTotal] 1, '000-00-1'

/* Resultado esperado: Error - Supera el total de la factura */
EXEC [Com2900G10].[venta].[CrearNotaCreditoTotal] 1, '000-00-2'

/* Resultado esperado: Error - Numero de nota credito invalido, ya existe. */
EXEC [Com2900G10].[venta].[CrearNotaCreditoTotal] 1, '000-00-1'


/* Resultado esperado: Error - La suma de las NCs superaria el total */
EXEC [Com2900G10].[venta].[CrearNotaCreditoParcial] 1,  '000-00-3', 1