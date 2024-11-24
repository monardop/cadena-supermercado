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


-- SP para la tabla nota credito
GO
CREATE OR ALTER PROCEDURE venta.CrearNotaCreditoTotal
	@id_factura INT,
	@numero_nota_credito VARCHAR(11)
AS
BEGIN

	IF @numero_nota_credito IS NULL OR @numero_nota_credito = ''
	BEGIN
		RAISERROR('Debe ingresar un numero de NC',10,1);

		RETURN
	END

	IF EXISTS (SELECT 1 FROM venta.nota_credito WHERE numero_nota_credito = @numero_nota_credito)
	BEGIN
		RAISERROR('Numero de nota credito invalido, ya existe.',10,1);

		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM venta.factura WHERE id_factura = @id_factura)
	BEGIN
		RAISERROR('La factura a generar NC no existe.',10,1);

		RETURN
	END

	DECLARE @id_pago VARCHAR(300);
	DECLARE @total DECIMAL(12,2);

	SELECT @id_pago = id_pago, @total = total FROM venta.factura WHERE id_factura = @id_factura

	IF @id_pago IS NULL
	BEGIN
		RAISERROR('La factura a generar NC no se encuentra en estado pagada.',10,1);

		RETURN
	END
	
	DECLARE @sumaTotalesNCs DECIMAL(12,2)
	SELECT @sumaTotalesNCs = SUM(importe) FROM venta.nota_credito WHERE id_factura = @id_factura

	IF @sumaTotalesNCs >= @total -- Para permitir NCs parciales
	BEGIN
		RAISERROR('Esta factura ya tiene NCs que cubren el total del importe original.',10,1);

		RETURN
	END



	INSERT INTO venta.nota_credito
    VALUES (@numero_nota_credito, @id_factura, @total);

	PRINT 'NC agregada exitosamente.';
END;
GO

CREATE OR ALTER PROCEDURE venta.CrearNotaCreditoParcial
	@id_factura INT,
	@numero_nota_credito VARCHAR(11),
	@importe DECIMAL(12,2)
AS
BEGIN

	IF @numero_nota_credito IS NULL OR @numero_nota_credito = ''
	BEGIN
		RAISERROR('Debe ingresar un numero de NC',10,1);

		RETURN
	END

	
	IF EXISTS (SELECT 1 FROM venta.nota_credito WHERE numero_nota_credito = @numero_nota_credito)
	BEGIN
		RAISERROR('Numero de nota credito invalido, ya existe.',10,1);

		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM venta.factura WHERE id_factura = @id_factura)
	BEGIN
		RAISERROR('La factura a generar NC no existe.',10,1);

		RETURN
	END

	DECLARE @id_pago VARCHAR(300);
	DECLARE @total DECIMAL(12,2);

	SELECT @id_pago = id_pago, @total = total FROM venta.factura WHERE id_factura = @id_factura

	IF @id_pago is null
	BEGIN
		RAISERROR('La factura a generar NC no se encuentra en estado pagada.',10,1);

		RETURN
	END
	
	DECLARE @sumaTotalesNCs DECIMAL(12,2) = 0
	SELECT @sumaTotalesNCs = SUM(importe) FROM venta.nota_credito WHERE id_factura = @id_factura

	IF @sumaTotalesNCs + @importe >= @total -- Para permitir NCs parciales
	BEGIN
		RAISERROR('Esta factura ya tiene NCs que cubren el total del importe original.',10,1);

		RETURN
	END



	INSERT INTO venta.nota_credito
    VALUES (@numero_nota_credito, @id_factura, @total);

	PRINT 'NC agregada exitosamente.';
END;