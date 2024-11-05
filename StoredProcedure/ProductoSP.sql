GO
USE supermercado_aurora;


-- SP para la tabla Producto
GO
CREATE PROCEDURE CrearProducto
    @id_categoria_producto SMALLINT,
	@nombre_producto VARCHAR(100),
	@precio_unitario DECIMAL(10,4),
	@moneda CHAR(3)
AS
BEGIN
	INSERT INTO producto.producto 
    VALUES (@id_categoria_producto, @nombre_producto, @precio_unitario, @moneda);

	PRINT 'Producto agregado exitosamente.';
END;


GO
CREATE PROCEDURE ModificarProducto
	@id_producto SMALLINT, -- Solo para la busqueda
	@id_categoria_producto SMALLINT,
	@nombre_producto VARCHAR(100),
	@precio_unitario DECIMAL(10,4),
	@moneda CHAR(3)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM producto.producto WHERE id_producto =  @id_producto)
        BEGIN
            UPDATE producto.producto 
				SET id_categoria_producto = @id_categoria_producto, nombre_producto = @nombre_producto, precio_unitario = @precio_unitario, moneda = @moneda;

            PRINT 'Producto modificado exitosamente.';
        END

         ELSE
            BEGIN
                PRINT 'El producto no existe.';
            END
END;

-- TODO: Definir baja de producto