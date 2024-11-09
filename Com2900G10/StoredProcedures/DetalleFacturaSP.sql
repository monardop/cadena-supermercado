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


-- SP para la tabla detalle_factura
GO
CREATE OR ALTER PROCEDURE CrearDetalleFactura
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
CREATE OR ALTER PROCEDURE ModificarDetalleFactura
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