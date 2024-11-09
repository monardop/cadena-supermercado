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
						SP: CrearCategoriaProducto
*******************************************************************************/
SELECT * FROM [Com2900G10].[producto].[categoria_producto];

/* Resultado esperado: Creación OK */
EXEC [Com2900G10].[producto].[CrearCategoriaProducto] 'Bebidas', 'Gaseosas';

/* Resultado esperado: Error - Ese nombre de categoria ya existe */
EXEC [Com2900G10].[producto].[CrearCategoriaProducto] 'Bebidas', 'Gaseosas';

/* Resultado esperado: Modificacion OK */
EXEC [Com2900G10].[producto].[ModificarCategoriaProducto] 1, 'Herramientas', 'Jardineria';

/* Resultado esperado: Error - la categoria no existe */
EXEC [Com2900G10].[producto].[ModificarCategoriaProducto] 1, 'Herramientas', 'Jardineria';

/* Resultado esperado: Error - la categoria no existe */
EXEC [Com2900G10].[producto].[ModificarCategoriaProducto] NULL, 'Herramientas', 'TEST';

/* Resultado esperado: Error - Ese nombre de categoria ya existe */
EXEC [Com2900G10].[producto].[CrearCategoriaProducto] 'Bebidas', 'Gaseosas1';
EXEC [Com2900G10].[producto].[CrearCategoriaProducto] 'Bebidas', 'Gaseosas2';
DECLARE @ultimaCategoria SMALLINT;
SELECT @ultimaCategoria = IDENT_CURRENT('producto.categoria_producto');
EXEC [Com2900G10].[producto].[ModificarCategoriaProducto] @ultimaCategoria, 'Bebidas', 'Gaseosas1';