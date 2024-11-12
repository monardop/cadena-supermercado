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
	@numero_factura VARCHAR(11),
	@id_medio_pago SMALLINT,
	@legajo INT,
	@id_cliente INT,
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

	IF NOT EXISTS (SELECT 1 FROM venta.cliente WHERE id_cliente = @id_cliente)
	BEGIN
		RAISERROR('El cliente a facturar no existe.',10,1);

		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM sucursal.sucursal WHERE id_sucursal = @id_sucursal AND activo = 1)
	BEGIN
		RAISERROR('La sucursal de la factura no existe o esta inactiva.',10,1);

		RETURN
	END


	INSERT INTO venta.factura
    VALUES (@numero_factura, @id_medio_pago, @legajo, @id_cliente, @tipo_factura, @tipo_cliente, @fechaHora, @id_sucursal,0.0);

	PRINT 'Factura agregada exitosamente.';
END;


GO
CREATE OR ALTER PROCEDURE venta.ModificarFactura
	@id_factura INT, -- Solo para la busqueda
	@numero_factura VARCHAR(11),
	@id_medio_pago SMALLINT,
	@legajo INT,
	@id_cliente INT,
	@tipo_factura CHAR(1),
	@tipo_cliente VARCHAR(50),
	@fechaHora DATETIME,
	@id_sucursal SMALLINT,
	@total DECIMAL(12,2)
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

	
	IF NOT EXISTS (SELECT 1 FROM venta.cliente WHERE id_cliente = @id_cliente)
	BEGIN
		RAISERROR('El cliente a facturar no existe.',10,1);

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
		SET numero_factura = @numero_factura,
		id_medio_pago = @id_medio_pago,
		legajo_empleado = @legajo,
		id_cliente = @id_cliente,
		tipo_factura = @tipo_factura,
		tipo_cliente = @tipo_cliente,
		fechaHora = @fechaHora,
		id_sucursal = @id_sucursal,
		total = @total
	WHERE id_factura = @id_factura;

	PRINT 'Factura modificada exitosamente.';
END;
GO

CREATE OR ALTER PROCEDURE SumarAlTotal
@id_factura INT,
@subtotal DECIMAL (12,2)
AS
BEGIN
DECLARE @totalTemp DECIMAL(12,2)
	IF EXISTS (SELECT * FROM [Com2900G10].[venta].[factura]
	WHERE id_factura = @id_factura)
	BEGIN

		SET @totalTemp = (SELECT total FROM [Com2900G10].[venta].[factura]
		WHERE id_factura = @id_factura)

		SET @totalTemp = SUM(@totalTemp + @subtotal)

		UPDATE [Com2900G10].[venta].[factura]
		SET total = @totalTemp
		WHERE id_factura = @id_factura

		PRINT('Total de la factura actualizado exitosamente.')
	END
	ELSE
	BEGIN
		RAISERROR('La factura a la que se le está intentando actualizar el saldo no existe',10,1)
		RETURN
	END
END