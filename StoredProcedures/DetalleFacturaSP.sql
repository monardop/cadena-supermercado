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