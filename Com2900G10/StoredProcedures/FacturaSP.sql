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


-- SP para la tabla factura
GO
CREATE OR ALTER PROCEDURE venta.CrearFactura
	@id_medio_pago SMALLINT,
	@legajo INT,
	@tipo_factura CHAR(1),
	@tipo_cliente VARCHAR(50),
	@fechaHora DATETIME,
	@id_sucursal SMALLINT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM venta.medio_pago WHERE id_medio_pago = @id_medio_pago)
	BEGIN
		RAISERROR('El medio de pago de la factura no existe.',10,1);

		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM sucursal.empleado WHERE legajo = @legajo AND activo = 1)
	BEGIN
		RAISERROR('El empleado generador de la factura no existe o esta inactivo.',10,1);

		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM sucursal.sucursal WHERE id_sucursal = @id_sucursal AND activo = 1)
	BEGIN
		RAISERROR('La sucursal de la factura no existe o esta inactiva.',10,1);

		RETURN
	END

	INSERT INTO venta.factura 
    VALUES (@id_medio_pago, @legajo, @tipo_factura, @tipo_cliente, @fechaHora, @id_sucursal);

	PRINT 'Factura agregada exitosamente.';
END;


GO
CREATE OR ALTER PROCEDURE venta.ModificarFactura
	@id_factura INT, -- Solo para la busqueda
	@id_medio_pago SMALLINT,
	@legajo INT,
	@tipo_factura CHAR(1),
	@tipo_cliente VARCHAR(50),
	@fechaHora DATETIME,
	@id_sucursal SMALLINT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM venta.medio_pago WHERE id_medio_pago = @id_medio_pago)
	BEGIN
		RAISERROR('El medio de pago de la factura no existe.',10,1);

		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM sucursal.empleado WHERE legajo = @legajo AND activo = 1)
	BEGIN
		RAISERROR('El empleado generador de la factura no existe o esta inactivo.',10,1);

		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM sucursal.sucursal WHERE id_sucursal = @id_sucursal AND activo = 1)
	BEGIN
		RAISERROR('La sucursal de la factura no existe o esta inactiva.',10,1);

		RETURN
	END


	IF NOT EXISTS (SELECT 1 FROM venta.factura WHERE id_factura =  @id_factura)
	BEGIN
	    RAISERROR('La factura no existe.',10,1);

		RETURN
	END

	UPDATE venta.factura 
		SET id_medio_pago = @id_medio_pago,
		legajo_empleado = @legajo,
		tipo_factura = @tipo_factura,
		tipo_cliente = @tipo_cliente,
		fechaHora = @fechaHora,
		id_sucursal = @id_sucursal
	WHERE id_factura = @id_factura;

	PRINT 'Factura modificada exitosamente.';

END;