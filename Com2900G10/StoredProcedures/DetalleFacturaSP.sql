/*******************************************************************************
*                                                                             *
*                           Entrega 3 - Grupo 10                              *
*																			  *
*                           Integrantes:                                      *
*                           43.988.577 Juan Pi�an                             *
*                           43.049.457 Matias Matter                          *
*                           42.394.230 Lucas Natario                          *
*                           40.429.974 Pablo Monardo                          *
*                                                                             *
*                                                                             *
* "Cree la base de datos, entidades y relaciones. Incluya restricciones y     *
* claves. Deber� entregar un archivo .sql con el script completo de creaci�n  *
* (debe funcionar si se lo ejecuta �tal cual� es entregado). Incluya          *
* comentarios para indicar qu� hace cada m�dulo de c�digo.                    *
* Genere store procedures para manejar la inserci�n, modificaci�n, borrado    *
* (si corresponde, tambi�n debe decidir si determinadas entidades solo        *
* admitir�n borrado l�gico) de cada tabla."                                   *
*                                                                             *
*******************************************************************************/

GO
USE Com2900G10;


-- SP para la tabla detalle_factura
GO
CREATE OR ALTER PROCEDURE venta.CrearDetalleFactura
	@id_factura INT,
	@id_producto SMALLINT,
	@cantidad SMALLINT
AS
BEGIN
	IF NOT EXISTS ( SELECT 1 FROM venta.factura WHERE id_factura = @id_factura)
	BEGIN
		RAISERROR('La factura a la que intenta asociar el detalle no existe.',10,1);

		RETURN
	END

	IF NOT EXISTS ( SELECT 1 FROM producto.producto WHERE id_producto = @id_producto)
	BEGIN
		RAISERROR('El producto del detalle no existe no existe.',10,1);
		RETURN
	END

	DECLARE @subtotal DECIMAL (12,2)

	SET @subtotal = (SELECT SUM(@cantidad * p.precio_unitario ) FROM [Com2900G10].[producto].[producto] p
	WHERE p.id_producto = @id_producto)

	INSERT INTO venta.detalle_factura
    VALUES (@id_producto, @id_factura, @cantidad,@subtotal);

	EXEC SumarAlTotal @id_factura,@subtotal

	PRINT 'Detalle de factura agregado exitosamente.';
END;
GO

--##HAY QUE CAMBIAR ESTA SP POR EL TEMA DEL SUBTOTAL Y EL TOTAL##--
CREATE OR ALTER PROCEDURE venta.ModificarDetalleFactura
	@id_detalle_factura INT, -- Solo para la busqueda
	@cantidad SMALLINT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM venta.detalle_factura WHERE id_detalle_factura =  @id_detalle_factura)
	BEGIN
        RAISERROR('El detalle que quiere modificar no existe.',10,1);
		RETURN
    END

	DECLARE @cantidadActual int = (SELECT cantidad FROM venta.detalle_factura WHERE id_detalle_factura =  @id_detalle_factura);
	DECLARE @subtotalActual DECIMAL(12,2) = (SELECT subtotal FROM venta.detalle_factura WHERE id_detalle_factura =  @id_detalle_factura);
	DECLARE @precio DECIMAL(10,2) = @subtotalActual / @cantidadActual;

	UPDATE venta.detalle_factura 

		SET cantidad = @cantidad,
			subtotal = @precio * (@cantidadActual - @cantidad)
	WHERE id_detalle_factura = @id_detalle_factura;

	PRINT 'Detalle de factura modificado exitosamente.';
END;