/*

Entrega 4 - Grupo 10 - Piñan, Monardo, Matter, Natario

"
Se requiere que importe toda la información antes mencionada a la base de datos:
• Genere los objetos necesarios (store procedures, funciones, etc.) para importar los
archivos antes mencionados. Tenga en cuenta que cada mes se recibirán archivos de
novedades con la misma estructura, pero datos nuevos para agregar a cada maestro.
• Considere este comportamiento al generar el código. Debe admitir la importación de
novedades periódicamente.
• Cada maestro debe importarse con un SP distinto. No se aceptarán scripts que
realicen tareas por fuera de un SP.
• La estructura/esquema de las tablas a generar será decisión suya. Puede que deba
realizar procesos de transformación sobre los maestros recibidos para adaptarlos a la
estructura requerida.
• Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal
cargados, incompletos, erróneos, etc., deberá contemplarlo y realizar las correcciones
en el fuente SQL. (Sería una excepción si el archivo está malformado y no es posible
interpretarlo como JSON o CSV). 

"

*/

GO
USE Com2900G10;
GO

-- SP para la importar datos de clasificacion de productos
GO
CREATE OR ALTER PROCEDURE ImportarCategoriasProductos
@pathArchivos varchar(200)
AS
BEGIN

declare @sql varchar(200) = 'SELECT t1.nombre_linea, t1.nombre_categoria FROM (
			SELECT TRIM([Línea de producto]) as nombre_linea, TRIM([Producto]) as nombre_categoria FROM
				 OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
							''Excel 12.0; Database='+ @pathArchivos+ ''', 
							''SELECT * FROM [Clasificacion productos$]'')
							) t1
			LEFT JOIN producto.categoria_producto c ON c.nombre_categoria = t1.nombre_categoria
			WHERE c.nombre_categoria IS NULL'

	INSERT INTO producto.categoria_producto(nombre_linea, nombre_categoria)
		exec sp_executesql @sql;
END;

/* SELECT * FROM producto.categoria_producto;
DELETE FROM producto.categoria_producto
EXEC ImportarCategoriasProductos;
SELECT * FROM producto.categoria_producto; */
