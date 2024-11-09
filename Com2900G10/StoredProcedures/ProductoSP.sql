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


-- SP para la tabla Producto
GO
CREATE OR ALTER PROCEDURE CrearProducto
    @id_categoria_producto SMALLINT,
	@nombre_producto VARCHAR(100),
	@precio_unitario DECIMAL(10,4),
	@moneda CHAR(3)
AS
BEGIN
	IF EXISTS (SELECT * FROM producto.categoria_producto cpr WHERE cpr.id_categoria_producto = @id_categoria_producto)
	BEGIN
		IF @moneda IN ('ARS','USD') --Se agregan las validaciones por moneda y por id categoria ya que si se rebota el insert por constraint
										--se aumenta el id identity igual.
		BEGIN
			INSERT INTO producto.producto 
			VALUES (@id_categoria_producto, @nombre_producto, @precio_unitario, @moneda);
			PRINT 'Producto agregado exitosamente.';
		END
		ELSE
			RAISERROR('La moneda que se quiere ingresar es invalida.',10,1)
	END
	ELSE
		RAISERROR('La categoria del producto que se quiere insertar no se encuentra registrada',10,1)
END;


GO
CREATE OR ALTER PROCEDURE ModificarProducto
	@id_producto SMALLINT, -- Solo para la busqueda
	@id_categoria_producto SMALLINT,
	@nombre_producto VARCHAR(100),
	@precio_unitario DECIMAL(10,4),
	@moneda CHAR(3)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM producto.producto WHERE id_producto =  @id_producto)
	BEGIN
		IF EXISTS (SELECT 1 FROM producto.categoria_producto where id_categoria_producto = @id_categoria_producto)
        BEGIN
			IF @moneda IN ('ARS','USD')
			BEGIN
				UPDATE producto.producto 
					SET id_categoria_producto = @id_categoria_producto, nombre_producto = @nombre_producto, precio_unitario = @precio_unitario, moneda = @moneda
					WHERE id_producto = @id_producto;
            PRINT 'Producto modificado exitosamente.';
			END
			ELSE
				RAISERROR('Moneda erronea',10,1)
        END
		ELSE
			RAISERROR('Categoria de producto inexistente',10,1)
	END
         ELSE
             RAISERROR('El producto no existe.',10,1);
END;

-- TODO: Definir baja de producto