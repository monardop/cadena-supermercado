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

USE [Com2900G10]
GO
/*******************************************************************************
						SP: CrearFactura
*******************************************************************************/
-- SELECT * FROM [Com2900G10].[sucursal].[empleado]
-- SELECT * FROM sucursal.punto_venta_empleado
-- SELECT * FROM venta.cliente
-- SELECT * FROM venta.medio_pago
-- EXEC venta.CrearCliente 'Jorge', 'Rodriguez', '11222333', 'Av. Siempre Viva 123', '20-11222333-6'

/* Resultado esperado: Insercion OK*/
	DECLARE @legajo INT = 257020;
	DECLARE @id_punto_venta_empleado INT = 2;
	DECLARE @productos VARCHAR(400) = '1,10;2,20;3,30;5,23';
	DECLARE @id_cliente INT = 2;
	DECLARE @tipo_factura CHAR(1) = 'A';
	DECLARE @numero_factura VARCHAR(11) = '000-01-001';
	DECLARE @id_medio_pago SMALLINT = 3;
	DECLARE @identificador_pago VARCHAR(200) = 'A3C-S1A-X90';
	EXEC [Com2900G10].[venta].[CrearVentaConFactura] 
		@legajo,
		@id_punto_venta_empleado, 
		@productos, 
		@id_cliente, 
		@tipo_factura, 
		@numero_factura,
		@id_medio_pago,
		@identificador_pago;

	SELECT * FROM venta.venta ORDER BY id_venta DESC;
	SELECT * FROM venta.detalle_venta WHERE id_venta = 1001;
	SELECT * FROM venta.factura ORDER BY id_factura DESC
	SELECT * FROM venta.detalle_factura WHERE id_factura = 1001;
GO

/* Resultado esperado: Error - Producto inexistente*/
	DECLARE @legajo INT = 257020;
	DECLARE @id_punto_venta_empleado INT = 2;
	DECLARE @productos VARCHAR(400) = '9999,10';
	DECLARE @id_cliente INT = 2;
	DECLARE @tipo_factura CHAR(1) = 'A';
	DECLARE @numero_factura VARCHAR(11) = '000-01-0999';
	DECLARE @id_medio_pago SMALLINT = 3;
	DECLARE @identificador_pago VARCHAR(200) = 'A3C-S1A-X90';
	EXEC [Com2900G10].[venta].[CrearVentaConFactura] 
		@legajo,
		@id_punto_venta_empleado, 
		@productos, 
		@id_cliente, 
		@tipo_factura, 
		@numero_factura,
		@id_medio_pago,
		@identificador_pago;

	SELECT * FROM venta.venta ORDER BY id_venta DESC;
	SELECT * FROM venta.detalle_venta WHERE id_venta = 1001;
	SELECT * FROM venta.factura ORDER BY id_factura DESC;
	SELECT * FROM venta.detalle_factura WHERE id_factura = 1001;
	SELECT * FROM venta.pago WHERE id_pago = 1001
