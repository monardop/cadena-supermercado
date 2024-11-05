/*

Entrega 3 - Grupo 10 - Piñan, Monardo, Matter, Natario

"Genere store procedures para manejar la inserción, modificado, borrado (si corresponde,
también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla.
Los nombres de los store procedures NO deben comenzar con “SP”.
Genere esquemas para organizar de forma lógica los componentes del sistema y aplique esto
en la creación de objetos. NO use el esquema “dbo”"

*/

GO
USE Com2900G10;


-- SP para la tabla categoria_producto
GO
CREATE PROCEDURE CrearCategoriaProducto
	@nombre VARCHAR(100)
AS
BEGIN
	INSERT INTO producto.categoria_producto 
    VALUES (@nombre);

	PRINT 'Categoria agregada exitosamente.';
END;


GO
CREATE PROCEDURE ModificarCategoriaProducto
	@id_categoria_producto SMALLINT, -- Solo para la busqueda
	@nombre VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM producto.categoria_producto WHERE id_categoria_producto =  @id_categoria_producto)
        BEGIN
            UPDATE producto.categoria_producto 
				SET nombre_categoria = @nombre 
			WHERE id_categoria_producto = @id_categoria_producto;

            PRINT 'Categoria modificada exitosamente.';
        END

         ELSE
            BEGIN
                PRINT 'La categoria de producto no existe.';
            END
END;

-- TODO: Definir baja de categoria