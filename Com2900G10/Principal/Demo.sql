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
*						Venta / Facturacion									   *
*******************************************************************************/
	/* Queries utiles

		SELECT * FROM [Com2900G10].[sucursal].[empleado]
		SELECT * FROM sucursal.punto_venta_empleado
		SELECT * FROM venta.cliente
		SELECT * FROM venta.medio_pago

		SELECT * FROM sucursal.empleado

	*/

	/* Si se quiere probar con un cliente distinto al default de las importaciones */
		EXEC venta.CrearCliente 'Jorge', 'Rodriguez', '11222333', 'Av. Siempre Viva 123', '20-11222333-6'


	/* Genero la venta facturada

		Producto: 1 - Cantidad: 10
		Producto: 2 - Cantidad: 20
		Producto: 3 - Cantidad: 30
		Producto: 5 - Cantidad: 23

	*/
		DECLARE @legajo INT = 257020;
		DECLARE @id_punto_venta_empleado INT = 2;
		DECLARE @productos VARCHAR(400) = '1,10;2,20;3,30;5,23';
		DECLARE @id_cliente INT = 2;
		DECLARE @tipo_factura CHAR(1) = 'A';
		DECLARE @numero_factura VARCHAR(11) = '000-01-005';
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

	/*
		Caso NC Total
	*/

		DECLARE @id_factura INT = 1001;
		DECLARE @numero_nota_credito VARCHAR(11) = '999-01-001';
		EXEC venta.CrearNotaCreditoTotal @id_factura, @numero_nota_credito;
		SELECT * FROM venta.nota_credito

	/*
		Caso NC Parcial
	*/
		DECLARE @id_factura INT = 1009;
		DECLARE @numero_nota_credito VARCHAR(11) = '999-01-013';
		DECLARE @importe DECIMAL(12,2) = 1;
		EXEC venta.CrearNotaCreditoParcial @id_factura, @numero_nota_credito, @importe;
		SELECT * FROM venta.nota_credito

/*******************************************************************************
*						Encriptacion										   *
*******************************************************************************/
	-- Vista de empleados sin encriptar
	SELECT * FROM sucursal.empleado;

	-- Encriptar empleados
	EXEC configuracion.EncriptarEmpleados

	-- Vista de empleados encriptados (En crudo)
	SELECT * FROM sucursal.empleado

	-- Vista de empleados encriptados (Desencriptando en query)
	EXEC sucursal.LeerEmpleadoEncriptadoPorLegajo 257025

	-- Crear empleado manteniendo encriptacion
	GO
	DECLARE @legajo INT = 112233
	DECLARE @nombre VARCHAR(50) = 'Pepito'
	DECLARE @apellido VARCHAR(50) = 'Romero'
	DECLARE @dni CHAR(8) = '11222333'
	DECLARE @direccion VARCHAR(100) = 'Av Santa Fe 362'
	DECLARE @email_personal VARCHAR(50) = 'testP@test.com'
	DECLARE @email_empresa VARCHAR(50) = 'testE@test.com'
	DECLARE @cuil CHAR(13) = '20-11222333-5'
	DECLARE @turno VARCHAR(5) = 'TM'
	DECLARE @cargo VARCHAR(20) = 'Cajero'
	DECLARE @id_sucursal INT = 1
	EXEC sucursal.CrearEmpleado
		@legajo,
		@nombre,
		@apellido,
		@dni,
		@direccion,
		@email_personal,
		@email_empresa,
		@cuil,
		@cargo,
		@turno,
		@id_sucursal

	-- Vista de empleados encriptados (En crudo)
	SELECT * FROM sucursal.empleado

	-- Vista de empleados encriptados (Desencriptando en query)
	EXEC sucursal.LeerEmpleadoEncriptadoPorLegajo 112233