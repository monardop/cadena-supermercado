/*******************************************************************************
*                                                                             *
*                           Entrega 3 - Grupo 10                              *
*                                                                             *
*                           Integrantes:                                      *
*                           43.988.577 Juan Piñan                             *
*                           43.049.457 Matias Matter                          *
*                           42.394.230 Lucas Natario                          *
*                           40.429.974 Pablo Monardo                          *
*                                                                             *
*                                                                             *
* "Se requiere que importe toda la información antes mencionada a la base de  *
* datos:                                                                      *
* • Genere los objetos necesarios (store procedures, funciones, etc.) para    *
*   importar los archivos antes mencionados. Tenga en cuenta que cada mes se  *
*   recibirán archivos de novedades con la misma estructura, pero datos nuevos*
*   para agregar a cada maestro.                                              *
* • Considere este comportamiento al generar el código. Debe admitir la       *
*   importación de novedades periódicamente.                                  *
* • Cada maestro debe importarse con un SP distinto. No se aceptarán scripts  *
*   que realicen tareas por fuera de un SP.                                   *
* • La estructura/esquema de las tablas a generar será decisión suya. Puede   *
*   que deba realizar procesos de transformación sobre los maestros recibidos *
*   para adaptarlos a la estructura requerida.                                *
* • Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal *
*   cargados, incompletos, erróneos, etc., deberá contemplarlo y realizar las *
*   correcciones en el fuente SQL. (Sería una excepción si el archivo está    *
*   malformado y no es posible interpretarlo como JSON o CSV)."               *
*                                                                             *
*******************************************************************************/

/*******************************************************************************
*						Declara parametros               					   *
****************************************** *************************************/

DECLARE @pathInfoComplementaria VARCHAR(300);
DECLARE @hojaSucursales VARCHAR(100);
DECLARE @hojaEmpleados VARCHAR(100);
DECLARE @hojaMediosDePago VARCHAR(100);
DECLARE @hojaCategoriasProductos VARCHAR(100);

DECLARE @pathProductosCatalogo VARCHAR(300);

DECLARE @pathProductosElectronicos VARCHAR(300);
DECLARE @hojaElectronicos VARCHAR(100);

DECLARE @pathProductosImportados VARCHAR(300);
DECLARE @hojaProductosImportados VARCHAR(100);

DECLARE @pathVentas VARCHAR(300);
DECLARE @valorDolar DECIMAL(12,2);
DECLARE @idClienteDefaultImportacion SMALLINT;
DECLARE @porcentajeIva DECIMAL(4,2);

/*******************************************************************************
*						Obtiene valores de los parametros					   *
****************************************** *************************************/

SELECT @pathInfoComplementaria = valor FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'path_info_complementaria';
SELECT @hojaSucursales = valor FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'hoja_importar_sucursales';
SELECT @hojaEmpleados = valor FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'hoja_importar_empleados';
SELECT @hojaMediosDePago = valor FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'hoja_importar_medios_de_pago';
SELECT @hojaCategoriasProductos = valor FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'hoja_importar_categorias_productos';

SELECT @pathProductosCatalogo = valor FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'path_productos_catalogo';

SELECT @pathProductosElectronicos = valor FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'path_productos_electonicos';
SELECT @hojaElectronicos = valor FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'hoja_importar_electronicos';

SELECT @pathProductosImportados = valor FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'path_productos_importados';
SELECT @hojaElectronicos = valor FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'hoja_importar_electronicos';
SELECT @valorDolar = CAST(valor AS decimal(12,2)) FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'valor_dolar';

SELECT @pathVentas = valor FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'path_ventas';
SELECT @idClienteDefaultImportacion = CAST(valor AS SMALLINT) FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'id_cliente_default_importacion';
SELECT @porcentajeIva = CAST(valor AS decimal(4,2)) FROM [Com2900G10].[configuracion].[parametros_generales] where descripcion = 'porcentaje_iva';

/*******************************************************************************
*						Ejecuta importacion									   *
****************************************** *************************************/

EXEC [Com2900G10].[importacion].[ImportarSucursales] @pathInfoComplementaria, @hojaSucursales;
-- SELECT * FROM [Com2900G10].[sucursal].[sucursal]

EXEC [Com2900G10].[importacion].[ImportarEmpleados] @pathInfoComplementaria, @hojaEmpleados;
-- SELECT * FROM [Com2900G10].[sucursal].[empleado]

EXEC [Com2900G10].[importacion].[ImportarMediosPago] @pathInfoComplementaria, @hojaMediosDePago;
-- SELECT * FROM [Com2900G10].[venta].[medio_pago]

EXEC [Com2900G10].[importacion].[ImportarCategoriasProductos] @pathInfoComplementaria, @hojaCategoriasProductos;
-- SELECT * FROM [Com2900G10].[producto].[categoria_producto]

-- Sin hoja por ser CSV
EXEC [Com2900G10].[importacion].[ImportarCatalogo] @pathProductosCatalogo;
-- SELECT * FROM [Com2900G10].[producto].[producto]

EXEC [Com2900G10].[importacion].[ImportarElectronicos] @pathProductosElectronicos, @hojaElectronicos, @valorDolar;
-- SELECT * FROM [Com2900G10].[producto].[producto]

EXEC [Com2900G10].[importacion].[ImportarProductosImportados] @pathProductosImportados, @hojaProductosImportados, @valorDolar;
-- SELECT * FROM [Com2900G10].[producto].[producto]

EXEC [Com2900G10].[importacion].[ImportarVentas] @pathVentas, @idClienteDefaultImportacion, @porcentajeIva;
-- SELECT COUNT(*) FROM [Com2900G10].[venta].[factura] 
-- SELECT * FROM [Com2900G10].[venta].[factura] 
-- SELECT * FROM [Com2900G10].[venta].[detalle_factura]