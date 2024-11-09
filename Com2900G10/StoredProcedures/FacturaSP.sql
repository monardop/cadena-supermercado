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
CREATE OR ALTER PROCEDURE CrearFactura
	@id_medio_pago SMALLINT,
	@id_empleado INT,
	@tipo_factura CHAR(1),
	@tipo_cliente VARCHAR(50),
	@genero VARCHAR(10),
	@fechaHora DATETIME,
	@id_sucursal SMALLINT
AS
BEGIN
	INSERT INTO venta.factura 
    VALUES (@id_medio_pago, @id_empleado, @tipo_factura, @tipo_cliente, @genero, @fechaHora, @id_sucursal);

	PRINT 'Factura agregada exitosamente.';
END;


GO
CREATE OR ALTER PROCEDURE ModificarFactura
	@id_factura INT, -- Solo para la busqueda
	@id_medio_pago SMALLINT,
	@id_empleado INT,
	@tipo_factura CHAR(1),
	@tipo_cliente VARCHAR(50),
	@genero VARCHAR(10),
	@fechaHora DATETIME,
	@id_sucursal SMALLINT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM venta.factura WHERE id_factura =  @id_factura)
        BEGIN
            UPDATE venta.factura 
				SET id_medio_pago = @id_medio_pago,
				id_empleado = @id_empleado,
				tipo_factura = @tipo_factura,
				tipo_cliente = @tipo_cliente,
				genero = @genero,
				fechaHora = @fechaHora,
				id_sucursal = @id_sucursal
			WHERE id_factura = @id_factura;

            PRINT 'Factura modificada exitosamente.';
        END

         ELSE
             RAISERROR('La factura no existe.',10,1);

END;