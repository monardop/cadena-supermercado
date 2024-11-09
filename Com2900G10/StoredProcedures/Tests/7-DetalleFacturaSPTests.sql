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
						SP: CrearDetalleFactura
*******************************************************************************/

/* Resultado esperado: Insercion OK*/
EXEC [Com2900G10].[venta].[CrearDetalleFactura] 1, 1, 10;

/* Resultado esperado: Error - "La factura a la que intenta asociar el detalle no existe" */
EXEC [Com2900G10].[venta].[CrearDetalleFactura] 99, 1, 10;

/* Resultado esperado: Error - "El producto del detalle no existe no existe" */
EXEC [Com2900G10].[venta].[CrearDetalleFactura] 1, 99, 10;

/*******************************************************************************
						SP: ModificarDetalleFactura
*******************************************************************************/

/* Resultado esperado: Modificacion OK*/
EXEC [Com2900G10].[venta].[ModificarDetalleFactura] 1, 11;

/* Resultado esperado: Error - "El detalle que quiere modificar no existe" */
EXEC [Com2900G10].[venta].[ModificarDetalleFactura] 99, 11;
