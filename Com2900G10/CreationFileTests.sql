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
						Entidad: Tabla - sucursal.sucursal
*******************************************************************************/

/* Resultado esperado: Creación OK */
INSERT INTO [Com2900G10].[sucursal].[sucursal]
VALUES
('Buenos Aires', 'Bs. As.', 'Av. Santa Fe 123', 'Lu a Vi 8am a 8pm', '+541133441122', 1);

/* Resultado esperado: Fallo por chequeo de constraint CHECK en telefono */
INSERT INTO [Com2900G10].[sucursal].[sucursal]
VALUES
('Buenos Aires', 'Bs. As.', 'Av. Santa Fe 123', 'Lu a Vi 8am a 8pm', 'ABCDEFG', 1);

/* Resultado esperado: Fallo por NULL en ciudad (NOT NULL requerido) */
INSERT INTO [Com2900G10].[sucursal].[sucursal] 
VALUES
(NULL, 'Bs. As.', 'Av. Santa Fe 123', 'Lu a Vi 8am a 8pm', 'ABCDEFG', 1);

/*******************************************************************************
						Entidad: Tabla - sucursal.empleado
*******************************************************************************/

/* Resultado esperado: Creación OK */
INSERT INTO [Com2900G10].[sucursal].[empleado]
VALUES
(1234, 'John', 'Doe', 41323432, NULL, NULL,NULL, '20-41323432-5', 'Gerente', 1, 'TM', 1);

/* Resultado esperado: Fallo por constraint CHECK en cuil (mal formato) */
INSERT INTO [Com2900G10].[sucursal].[empleado]
VALUES
(123, 'John', 'Doe', 41323432, NULL, NULL,NULL, '20A41323432B5', 'Gerente', 1, 'TM', 1);

/* Resultado esperado: Fallo por constraint FK en sucursal */
INSERT INTO [Com2900G10].[sucursal].[empleado]
VALUES
(123, 'John', 'Doe', 41323432, NULL, NULL,NULL, '20-41323432-5', 'Gerente', 999, 'TM', 1);

/* Resultado esperado: Fallo por constraint CHEC en turno */
INSERT INTO [Com2900G10].[sucursal].[empleado]
VALUES
(123, 'John', 'Doe', 41323432, NULL, NULL,NULL, '20-41323432-5', 'Gerente', 999, 'FALLO', 1);

/*******************************************************************************
						Entidad: Tabla - producto.categoria_producto
*******************************************************************************/

/* Resultado esperado: Creación OK */
INSERT INTO [Com2900G10].[producto].[categoria_producto]
VALUES
('Perfumeria','Desodorantes');

/* Resultado esperado: Fallo por linea NULL */
INSERT INTO [Com2900G10].[producto].[categoria_producto]
VALUES
(NULL,'Desodorantes');

/* Resultado esperado: Fallo por categoria NULL */
INSERT INTO [Com2900G10].[producto].[categoria_producto]
VALUES
('Perfumeria', NULL);

/*******************************************************************************
						Entidad: Tabla - producto.producto
*******************************************************************************/

/* Resultado esperado: Creación OK */
INSERT INTO [Com2900G10].[producto].[producto]
VALUES
(1, 'Perfume Jean Paul Gaultier', 10.50, 'ARS');

/* Resultado esperado: Fallo por contraint CHECK en moneda */
INSERT INTO [Com2900G10].[producto].[producto]
VALUES
(1, 'Perfume Jean Paul Gaultier', 10.50, 'PAT');

/* Resultado esperado: Fallo por contraint FK en id_categoria_producto */
INSERT INTO [Com2900G10].[producto].[producto]
VALUES
(999, 'Perfume Jean Paul Gaultier', 10.50, 'ARS');

/*******************************************************************************
						Entidad: Tabla - venta.medio_pago
*******************************************************************************/

/* Resultado esperado: Creación OK */
INSERT INTO [Com2900G10].[venta].[medio_pago]
VALUES
('Cash','Efectivo');

/* Resultado esperado: Fallo por nombre en ingles NULL */
INSERT INTO [Com2900G10].[venta].[medio_pago]
VALUES
(NULL,'Efectivo');

/* Resultado esperado: Fallo por nombre en español NULL */
INSERT INTO [Com2900G10].[venta].[medio_pago]
VALUES
('Cash', NULL);

/*******************************************************************************
						Entidad: Tabla - venta.cliente
*******************************************************************************/
/* Resultado esperado: Creación OK */
INSERT INTO [Com2900G10].[venta].[cliente]
VALUES
('Foo', 'Bar', 32948373, 'Av Siempre Viva 123', '20-32948373-5');


/* Resultado esperado: Fallo por constraint CHECK cuil */
INSERT INTO [Com2900G10].[venta].[cliente]
VALUES
('Foo', 'Bar', 32948373, 'Av Siempre Viva 123', '20-ABC-5');

/*******************************************************************************
						Entidad: Tabla - venta.factura
*******************************************************************************/

SELECT * FROM [Com2900G10].[venta].[factura];

/* Resultado esperado: Creación OK */
INSERT INTO [Com2900G10].[venta].[factura]
VALUES
(1,1234, 1, 'A', 'Consumidor Final', '2024-08-11 09:00', 1);

/* Resultado esperado: Fallo por constraint FK medio de pago */
INSERT INTO [Com2900G10].[venta].[factura]
VALUES
(999,1234, 1, 'A', 'Consumidor Final', '2024-08-11 09:00', 1);

/* Resultado esperado: Fallo por constraint FK empleado */
INSERT INTO [Com2900G10].[venta].[factura]
VALUES
(1,99999, 1, 'A', 'Consumidor Final', '2024-08-11 09:00', 1);

/* Resultado esperado: Fallo por constraint FK sucursal */
INSERT INTO [Com2900G10].[venta].[factura]
VALUES
(1,1234, 1, 'A', 'Consumidor Final', '2024-08-11 09:00', 999);

/* Resultado esperado: Fallo por constraint FK cliente */
INSERT INTO [Com2900G10].[venta].[factura]
VALUES
(1,1234, 99, 'A', 'Consumidor Final', '2024-08-11 09:00', 999);

/*******************************************************************************
						Entidad: Tabla - venta.detalle_factura
*******************************************************************************/

/* Resultado esperado: Creación OK */
INSERT INTO [Com2900G10].[venta].detalle_factura
VALUES
(1,1, 10);

/* Resultado esperado: Fallo por constraint FK Producto */
INSERT INTO [Com2900G10].[venta].detalle_factura
VALUES
(999,1, 10);

/* Resultado esperado: Fallo por constraint FK Factura */
INSERT INTO [Com2900G10].[venta].detalle_factura
VALUES
(1,999, 10);