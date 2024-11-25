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

CREATE OR ALTER PROCEDURE venta.CrearVentaConFactura(
	@legajo INT,
	@id_punto_venta_empleado INT,
	@productos VARCHAR(400), -- {id_prod},{cant};{id_prod},{cant}....
	@id_cliente INT,
	@tipo_factura CHAR(1),
	@numero_factura VARCHAR(11),
	@id_medio_pago SMALLINT,
	@identificador_pago VARCHAR(200)
) AS

BEGIN
	BEGIN TRY 
		BEGIN TRANSACTION;

		DECLARE @id_sucursal SMALLINT;
		DECLARE @legajo_punto_venta INT; -- Auxiliar para validacion

		IF @productos is null OR @productos = ''
		BEGIN
			RAISERROR('Debe ingresar los productos.',10,1);

			RETURN
		END;

		IF NOT EXISTS (SELECT 1 FROM venta.cliente WHERE id_cliente = @id_cliente)
		BEGIN
			RAISERROR('El cliente ingresado no existe.',10,1);

			RETURN
		END

		SELECT 
			@id_sucursal = id_sucursal,
			@legajo_punto_venta = legajo_empleado
		FROM sucursal.punto_venta_empleado
		WHERE id_punto_venta_empleado = @id_punto_venta_empleado;

		IF @legajo_punto_venta IS NULL
		BEGIN
			RAISERROR('El punto de venta de empleado no existe.',10,1);

			RETURN
		END

		IF @legajo_punto_venta != @legajo
		BEGIN
			RAISERROR('El punto de venta de empleado no corresponde al legajo ingresado.',10,1);

			RETURN
		END

		IF NOT EXISTS (SELECT 1 FROM sucursal.empleado WHERE legajo = @legajo AND activo = 1)
		BEGIN
			RAISERROR('El empleado generador de la factura no existe o esta inactivo.',10,1);

			RETURN
		END

		IF NOT EXISTS (SELECT 1 FROM venta.medio_pago WHERE id_medio_pago = @id_medio_pago)
		BEGIN
			RAISERROR('El medio de pago ingresado no existe.',10,1);

			RETURN
		END

		IF @identificador_pago = NULL
		BEGIN
			RAISERROR('Debe indicar el identificador de pago.',10,1);

			RETURN
		END


		/* DEBUG
			DECLARE @productos VARCHAR(400);
			SET @productos = '10,1;20,3;60,20;3,5'

			SELECT * FROM #producto_cantidad
		*/

		CREATE TABLE #producto_cantidad(
			par_producto_cantidad VARCHAR(100),
			producto VARCHAR(6),
			cantidad VARCHAR(4)
		);

		INSERT INTO #producto_cantidad(par_producto_cantidad)
		SELECT *
		FROM STRING_SPLIT(@productos, ';') AS par_producto_cantidad;

		WITH CTE (par_producto_cantidad, producto, cantidad)
		AS
		(
			SELECT 
				par_producto_cantidad,
				LEFT(par_producto_cantidad, CHARINDEX(',', par_producto_cantidad) - 1) AS producto,
				SUBSTRING(
					par_producto_cantidad,
					CHARINDEX(',', par_producto_cantidad) + 1, -- Arranca el substring luego del id producto
					LEN(par_producto_cantidad)
				) AS cantidad
			FROM #producto_cantidad
		)
		UPDATE p
		SET p.producto = c.producto,
			p.cantidad = c.cantidad
		FROM #producto_cantidad p
			INNER JOIN CTE c ON c.par_producto_cantidad = p.par_producto_cantidad;

		IF EXISTS (SELECT 1 FROM #producto_cantidad p GROUP BY p.producto HAVING COUNT(p.producto) > 1)
		BEGIN
			RAISERROR('Se ingreso dos veces el mismo producto para la venta, ingreselo una vez con la suma de las cantidades', 10, 1);

			RETURN
		END

		IF EXISTS (
			SELECT 1 
			FROM #producto_cantidad p
				LEFT JOIN producto.producto pp ON pp.id_producto = p.producto
			WHERE pp.id_producto IS NULL
		)
		BEGIN
			RAISERROR('Se ingresaron codigos de productos inexistentes o la lista de productos es invalida', 10, 1);

			RETURN
		END

		/*******************************************************************************
		*                         Generacion de la venta (sin factura)                 *
		*******************************************************************************/
		DECLARE @fecha_hora DATETIME = GETDATE();

		INSERT INTO venta.venta(id_factura, legajo_empleado, id_sucursal, id_punto_venta_empleado, total, fecha_hora)
		VALUES(NULL, @legajo, @id_sucursal, @id_punto_venta_empleado, 0, @fecha_hora)
	
		DECLARE @id_venta INT = SCOPE_IDENTITY();

		INSERT INTO venta.detalle_venta(id_venta, id_producto, cantidad, precio_unitario)
		SELECT @id_venta, producto, cantidad, p.precio_unitario
		FROM #producto_cantidad pc
			INNER JOIN producto.producto p ON p.id_producto = pc.producto;

		-- Actualizo el total de la venta
		DECLARE @total_venta DECIMAL(12,2)

		SELECT @total_venta = SUM(dv.cantidad * dv.precio_unitario)
		FROM venta.venta v
			INNER JOIN venta.detalle_venta dv ON dv.id_venta = v.id_venta AND v.id_venta = @id_venta
		GROUP BY dv.id_venta;

		UPDATE venta.venta SET total = @total_venta WHERE id_venta = @id_venta

	

		/*******************************************************************************
		*           Generacion de la factura, sin pago (y actualiza la venta)          *
		*******************************************************************************/
		DECLARE @cuit_emisor CHAR(13); -- Para la factura
		DECLARE @porcentaje_iva DECIMAL(6,2); -- Para la factura
		DECLARE @factor_iva DECIMAL(6,2); -- Para la factura

		SELECT @cuit_emisor = valor FROM configuracion.parametros_generales WHERE descripcion = configuracion.obtener_clave_cuit_emisor();

		SELECT
			@porcentaje_iva = CAST(valor AS tinyint)
		FROM configuracion.parametros_generales 
		WHERE descripcion = configuracion.obtener_clave_porcentaje_iva();

		SET @factor_iva = (@porcentaje_iva/100)+1;

		-- Inserto la factura
		INSERT INTO venta.factura(id_pago, id_cliente, cuit_emisor, numero_factura, tipo_factura, fecha_hora, total_con_iva)
		VALUES (
			NULL,
			@id_cliente,
			@cuit_emisor,
			@numero_factura,
			@tipo_factura,
			@fecha_hora,
			@total_venta * @factor_iva
		)

		DECLARE @id_factura INT = SCOPE_IDENTITY();

		-- La asocio a la venta
		UPDATE venta.venta
			SET id_factura = @id_factura
		WHERE id_venta = @id_venta

		-- Inserto los detalles de la factura
		INSERT INTO venta.detalle_factura(id_factura, id_producto, cantidad, precio_unitario)
		SELECT @id_factura, dv.id_producto, dv.cantidad, dv.precio_unitario
		FROM venta.detalle_venta dv
		WHERE dv.id_venta = @id_venta

		/*******************************************************************************
		*           Generacion del pago de la factura (y actualiza la factura)         *
		*******************************************************************************/
		-- Inserto el pago
		INSERT INTO venta.pago(id_medio_pago, identificador) VALUES (@id_medio_pago, @identificador_pago);

		DECLARE @id_pago INT = SCOPE_IDENTITY();

		-- Asocio el pago a la factura
		UPDATE venta.factura
			SET id_pago = @id_pago
		WHERE id_factura =  @id_factura
		
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		DECLARE @error VARCHAR(MAX) = CONCAT('Error inesperado: ',ERROR_MESSAGE())
		RAISERROR(@error,10,1)
	END CATCH
END;
GO