GO
USE supermercado_aurora;


-- SP para la tabla detalle_factura
GO
CREATE PROCEDURE CrearDetalleFactura
	@id_producto SMALLINT,
	@id_factura INT,
	@cantidad SMALLINT
AS
BEGIN
	INSERT INTO venta.detalle_factura 
    VALUES (@id_producto, @id_factura, @cantidad);

	PRINT 'Detalle de factura agregado exitosamente.';
END;


GO
CREATE PROCEDURE ModificarDetalleFactura
	@id_detalle_factura INT, -- Solo para la busqueda
	@cantidad SMALLINT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM venta.detalle_factura WHERE id_detalle_factura =  @id_detalle_factura)
        BEGIN
            UPDATE venta.detalle_factura 
				SET cantidad = @cantidad
			WHERE id_detalle_factura = @id_detalle_factura;

            PRINT 'Detalle de factura modificado exitosamente.';
        END

         ELSE
            BEGIN
                PRINT 'El detalle de factura no existe.';
            END
END;