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
GO

CREATE OR ALTER PROCEDURE venta.CrearVenta(
	@legajo INT,
	@id_sucursal SMALLINT,
	@id_punto_venta_empleado INT,
	@productos VARCHAR(400) -- {id_prod}-{cant},{id_prod}-{cant}....
) AS

BEGIN

	IF @productos is null OR @productos = ''
	BEGIN
		RAISERROR('Debe ingresar los productos.',10,1);

		RETURN
	END;

	IF NOT EXISTS (SELECT 1 FROM sucursal.sucursal WHERE id_sucursal = @id_sucursal AND activo = 1)
	BEGIN
		RAISERROR('La sucursal de la factura no existe o esta inactiva.',10,1);

		RETURN
	END

		IF NOT EXISTS (SELECT 1 FROM sucursal.empleado WHERE legajo = @legajo AND activo = 1)
	BEGIN
		RAISERROR('El empleado generador de la factura no existe o esta inactivo.',10,1);

		RETURN
	END

	CREATE TABLE #producto_cantidad(
		par_producto_cantidad VARCHAR(30),
		producto VARCHAR(30),
		cantidad VARCHAR(3)
	);

	INSERT INTO #producto_cantidad(par_producto_cantidad)
	SELECT *
	FROM STRING_SPLIT('1-1,2-10,3-20', ',') AS elementos;

	UPDATE #producto_cantidad
	SET
		producto = LEFT(par_producto_cantidad, CHARINDEX('-', par_producto_cantidad) - 1),
		cantidad = RIGHT(par_producto_cantidad, CHARINDEX('-', par_producto_cantidad) - 1)
		SELECT * FROM #producto_cantidad

	-- creo la venta
	INSERT INTO venta.venta(id_factura, legajo_empleado, id_sucursal, id_punto_venta_empleado, total)
	VALUES(NULL, @legajo, @id_sucursal, @id_punto_venta_empleado, 0)
	
	DECLARE @id_venta INT
	SELECT @id_venta = MAX(id_venta) FROM venta.venta

	INSERT INTO venta.detalle_venta(id_venta, id_producto, cantidad, subtotal)
	SELECT @id_venta, producto, cantidad, pc.cantidad*p.precio_unitario
	FROM #producto_cantidad pc
		INNER JOIN producto.producto p ON p.id_producto = pc.producto
END;
GO

CREATE OR ALTER PROCEDURE venta.FacturarVenta(
	@id_venta INT,
	@numero_factura VARCHAR(11),
	@id_cliente INT,
	@tipo_factura CHAR(1),
	@tipo_cliente VARCHAR(50)
) AS

BEGIN
	IF NOT EXISTS (SELECT 1 FROM venta.venta WHERE id_venta = @id_venta)
	BEGIN
		RAISERROR('la venta no existe', 10, 1);
	END

	IF EXISTS (SELECT 1 FROM venta.venta WHERE id_venta = @id_venta AND id_factura IS NOT NULL)
	BEGIN
		RAISERROR('la venta ya esta facturada', 10,1);
	END

	DECLARE @total_con_iva DECIMAL(12,2);
	SELECT @total_con_iva = total FROM venta.venta

	SET @total_con_iva = @total_con_iva * 1.21 --sumo el iva

	--genero la factura sin pago
	INSERT INTO venta.factura(numero_factura, id_cliente, tipo_factura, tipo_cliente, fechaHora, total_con_iva, id_pago)
	VALUES
	(@numero_factura, @id_cliente, @tipo_factura, @tipo_cliente, GETDATE(), @total_con_iva, null) -- se inserta sin pago

	DECLARE @id_factura INT
	SELECT @id_factura = MAX(id_factura) FROM venta.factura

	-- paso el detalle de la venta al detalle de la factura
	INSERT INTO venta.detalle_factura(id_producto, id_factura, cantidad, subtotal)
	SELECT
		id_producto,
		@id_factura,
		cantidad,
		subtotal
	FROM venta.detalle_venta
	WHERE id_venta = @id_venta

	-- Actualizo la venta facturada
	UPDATE venta.venta SET id_factura = @id_factura;

END;
GO