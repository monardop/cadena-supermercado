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

GO
USE Com2900G10;


-- SP para la tabla categoria_producto
GO
CREATE OR ALTER PROCEDURE producto.CrearCategoriaProducto
	@linea VARCHAR(100),
	@nombre VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM producto.categoria_producto WHERE nombre_categoria =  @nombre)
	BEGIN
		RAISERROR ('Ese nombre de categoria ya existe.',10,1); -- Podria hacerse con constraint UNIQUE, se hace la validación con fines demostrativos
	END
	ELSE BEGIN
		INSERT INTO producto.categoria_producto 
		VALUES (@linea, @nombre);

		PRINT 'Categoria agregada exitosamente.';
	END
END;


GO
CREATE OR ALTER PROCEDURE producto.ModificarCategoriaProducto
	@id_categoria_producto SMALLINT, -- Solo para la busqueda
	@nombre VARCHAR(100),
	@linea VARCHAR(100)
AS
BEGIN
	IF @id_categoria_producto IS NULL
	BEGIN
		RAISERROR ('El ID Categoria a modificar no puede ser nulo.',10,1);
		RETURN
	END

    IF EXISTS (SELECT 1 FROM producto.categoria_producto WHERE nombre_categoria =  @nombre)
	BEGIN
		RAISERROR ('Ese nombre de categoria ya existe.',10,1); -- Podria hacerse con constraint UNIQUE, se hace la validación con fines demostrativos

		RETURN
	END

	IF EXISTS (SELECT 1 FROM producto.categoria_producto WHERE id_categoria_producto =  @id_categoria_producto)
    BEGIN
        UPDATE producto.categoria_producto 
			SET nombre_categoria = @nombre, nombre_linea = @linea
		WHERE id_categoria_producto = @id_categoria_producto;

        PRINT 'Categoria modificada exitosamente.';
    END
        ELSE
		RAISERROR ('La categoria del producto no existe.',10,1);


END;
