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

DECLARE @pathDataFiles VARCHAR(300) = 'C:\Users\lucas\OneDrive\Escritorio\repositories\monardop\cadena-supermercado\DataFiles\';
DECLARE @pathInfoComplementaria VARCHAR(500) = @pathDataFiles + 'Informacion_complementaria.xlsx';
DECLARE @pathProductosCatalogo VARCHAR(400) = @pathDataFiles + 'Productos\catalogo.csv'
DECLARE @pathProductosElectronicos VARCHAR(400) = @pathDataFiles + 'Productos\Electronic accessories.xlsx'
DECLARE @pathProductosImportados VARCHAR(400) = @pathDataFiles + 'Productos\Productos_importados.xlsx'

DECLARE @hojaSucursales VARCHAR(100) = 'sucursal';
EXEC [Com2900G10].[importacion].[ImportarSucursales] @pathInfoComplementaria, @hojaSucursales;
-- SELECT * FROM [Com2900G10].[sucursal].[sucursal]

DECLARE @hojaEmpleados VARCHAR(100) = 'Empleados';
EXEC [Com2900G10].[importacion].[ImportarEmpleados] @pathInfoComplementaria, @hojaEmpleados;
-- SELECT * FROM [Com2900G10].[sucursal].[empleado]

DECLARE @hojaMediosDePago VARCHAR(100) = 'medios de pago';
EXEC [Com2900G10].[importacion].[ImportarMediosPago] @pathInfoComplementaria, @hojaMediosDePago;
-- SELECT * FROM [Com2900G10].[venta].[medio_pago]

DECLARE @hojaCategoriasProductos VARCHAR(100) = 'Clasificacion productos';
EXEC [Com2900G10].[importacion].[ImportarCategoriasProductos] @pathInfoComplementaria, @hojaCategoriasProductos;
-- SELECT * FROM [Com2900G10].[producto].[categoria_producto]

-- Sin hoja por ser CSV
EXEC [Com2900G10].[importacion].[ImportarCatalogo] @pathProductosCatalogo;
-- SELECT * FROM [Com2900G10].[producto].[producto]

DECLARE @hojaElectronicos VARCHAR(100) = 'Sheet1';
EXEC [Com2900G10].[importacion].[ImportarElectronicos] @pathProductosElectronicos, @hojaElectronicos;
-- SELECT * FROM [Com2900G10].[producto].[producto]

DECLARE @hojaProductosImportados VARCHAR(100) = 'Listado de Productos';
EXEC [Com2900G10].[importacion].[ImportarProductosImportados] @pathProductosImportados, @hojaProductosImportados;
-- SELECT * FROM [Com2900G10].[producto].[producto]
