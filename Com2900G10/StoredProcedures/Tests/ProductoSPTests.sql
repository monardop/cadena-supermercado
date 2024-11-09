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
						SP: CrearProducto
*******************************************************************************/

/* Resultado esperado: Insercion OK */
EXEC [Com2900G10].[producto].[CrearCategoriaProducto] 'Test2', 'Test2';
DECLARE @idCategoria SMALLINT;
SELECT @idCategoria = IDENT_CURRENT('COM2900G10.producto.categoria_producto');  -- Obtengo una categoria cualquiera válida
EXEC [Com2900G10].[producto].[CrearProducto] @idCategoria, 'Manaos', 10.5, 'ARS';
GO

/* Resultado esperado: Error - "La categoria del producto que se quiere insertar no se encuentra registrada" */
EXEC [Com2900G10].[producto].[CrearProducto] 9999, 'Pepsi', 10.5, 'ARS';
GO

/* Resultado esperado: Error - "La moneda que se quiere ingresar es invalida" */
DECLARE @idCategoria SMALLINT;
SELECT @idCategoria = IDENT_CURRENT('COM2900G10.producto.categoria_producto'); -- Obtengo una categoria cualquiera válida
EXEC [Com2900G10].[producto].[CrearProducto] @idCategoria2, 'Coca Cola', 10.5, 'PAT';

GO
/*******************************************************************************
						SP: ModificarProducto
*******************************************************************************/

/* Resultado esperado: Modificacion OK */

	-- Creo y obtengo una categoria valida
	EXEC [Com2900G10].[producto].[CrearCategoriaProducto] 'Test3', 'Test3';
	DECLARE @idCategoria SMALLINT;
	SELECT @idCategoria = IDENT_CURRENT('COM2900G10.producto.categoria_producto');

	--Creo y obtengo un producto valido
	EXEC [Com2900G10].[producto].[CrearProducto] @idCategoria, 'Fanta', 10.5, 'ARS';
	DECLARE @idProducto INT;
	SELECT @idProducto = IDENT_CURRENT('COM2900G10.producto.producto');

	-- Para debug: SELECT * FROM [Com2900G10].[producto].[producto]
	-- Modifico
	EXEC [Com2900G10].[producto].[ModificarProducto] @idProducto, @idCategoria, 'Manaos', 11.5, 'USD';
	GO

/* Resultado esperado: Error - "El producto no existe" */

	-- Creo y obtengo una categoria valida
	EXEC [Com2900G10].[producto].[CrearCategoriaProducto] 'Test4', 'Test4';
	DECLARE @idCategoria SMALLINT;
	SELECT @idCategoria = IDENT_CURRENT('COM2900G10.producto.categoria_producto');

	-- Modifico
	EXEC [Com2900G10].[producto].[ModificarProducto] 9999, @idCategoria, 'Manaos', 11.5, 'USD';
	GO

/* Resultado esperado: Error -  "Categoria de producto inexistente" */

	-- Creo y obtengo una categoria valida
	EXEC [Com2900G10].[producto].[CrearCategoriaProducto] 'Test3', 'Test3';
	DECLARE @idCategoria SMALLINT;
	SELECT @idCategoria = IDENT_CURRENT('COM2900G10.producto.categoria_producto');

	--Creo y obtengo un producto valido
	EXEC [Com2900G10].[producto].[CrearProducto] @idCategoria, 'Fanta', 10.5, 'ARS';
	DECLARE @idProducto INT;
	SELECT @idProducto = IDENT_CURRENT('COM2900G10.producto.producto');

	-- Modifico
	EXEC [Com2900G10].[producto].[ModificarProducto] @idProducto, 9999, 'Manaos', 11.5, 'USD';
	GO

/* Resultado esperado: Error -  "Moneda erronea" */

	-- Creo y obtengo una categoria valida
	EXEC [Com2900G10].[producto].[CrearCategoriaProducto] 'Test3', 'Test3';
	DECLARE @idCategoria SMALLINT;
	SELECT @idCategoria = IDENT_CURRENT('COM2900G10.producto.categoria_producto');

	--Creo y obtengo un producto valido
	EXEC [Com2900G10].[producto].[CrearProducto] @idCategoria, 'Fanta', 10.5, 'ARS';
	DECLARE @idProducto INT;
	SELECT @idProducto = IDENT_CURRENT('COM2900G10.producto.producto');

	-- Modifico
	EXEC [Com2900G10].[producto].[ModificarProducto] @idProducto, @idCategoria, 'Manaos', 11.5, 'AAA';
	GO