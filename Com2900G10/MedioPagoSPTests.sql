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
						SP: CrearMedioPago
*******************************************************************************/

/* Resultado esperado: Inserción OK */
EXEC [Com2900G10].[venta].[CrearMedioPago] 'TEST1', 'TEST1';

/* Resultado esperado: Error - "Medio de pago ya existente" */
EXEC [Com2900G10].[venta].[CrearMedioPago] 'TEST1', 'TEST1';
EXEC [Com2900G10].[venta].[CrearMedioPago] 'TEST1', 'TEST1';

/*******************************************************************************
						SP: ModificarMedioPago
*******************************************************************************/

/* Resultado esperado: Modificacion OK */
EXEC [Com2900G10].[venta].[ModificarMedioPago] 1, 'TEST2', 'TEST2';

/* Resultado esperado: Error - "El medio de pago no existe" */
EXEC [Com2900G10].[venta].[ModificarMedioPago] 999, 'TEST2', 'TEST2';