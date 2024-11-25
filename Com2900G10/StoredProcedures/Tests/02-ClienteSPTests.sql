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
						SP: CrearCliente
*******************************************************************************/
--SELECT * FROM [Com2900G10].[venta].[cliente]
/* Resultado esperado: Insercion OK*/
EXEC [Com2900G10].[venta].[CrearCliente] 'Foo', 'Bar', 41928373, '', '20-41928373-5';

/* Resultado esperado: Error - "El CUIL ingresado es invalido." */
EXEC [Com2900G10].[venta].[CrearCliente] 'Foo', 'Bar', 41928373, '', '20-AAA-5';

/* Resultado esperado: Error - "El CUIL ingresado es invalido." */
EXEC [Com2900G10].[venta].[CrearCliente] 'Foo', 'Bar', 41928373, '', NULL;

/*******************************************************************************
						SP: ModificarCliente
*******************************************************************************/

/* Resultado esperado: Modificacion OK*/
EXEC [Com2900G10].[venta].[ModificarCliente] 1, 'Foo2', 'Bar2', 31928373, '', '21-41928373-5';
-- SELECT * FROM [Com2900G10].[venta].[cliente] 

/* Resultado esperado: Error - "El CUIL ingresado es invalido." */
EXEC [Com2900G10].[venta].[ModificarCliente] 1, 'Foo2', 'Bar2', 31928373, '', '21-41AAAA8373-5';

/* Resultado esperado: Error - "Nombre, apellido y DNI son datos obligatorios.." */
EXEC [Com2900G10].[venta].[ModificarCliente] 1, NULL, 'Bar2', 31928373, '', '21-41928373-5';

/* Resultado esperado: Error - "Nombre, apellido y DNI son datos obligatorios.." */
EXEC [Com2900G10].[venta].[ModificarCliente] 1, 'Foo2', NULL, 31928373, '', '21-41928373-5';

/* Resultado esperado: Error - "Nombre, apellido y DNI son datos obligatorios.." */
EXEC [Com2900G10].[venta].[ModificarCliente] 1, 'Foo2', 'Bar2', NULL, '', '21-41928373-5';
