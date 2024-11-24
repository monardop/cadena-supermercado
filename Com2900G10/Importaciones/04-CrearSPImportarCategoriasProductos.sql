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


GO
USE Com2900G10;
GO

-- SP para la importar datos de clasificacion de productos
GO
CREATE OR ALTER PROCEDURE importacion.ImportarCategoriasProductos
	@pathArchivos VARCHAR(200),
	@hojaArchivo VARCHAR(100)
AS
BEGIN
	declare @sql NVARCHAR(MAX) = '
		SELECT 
			*
		FROM
				OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
						''Excel 12.0; Database='+ @pathArchivos+ ''', 
						''SELECT * FROM ['+@hojaArchivo+'$]''
						)';

	CREATE TABLE #importacion_categoria_producto(linea VARCHAR(500), categoria VARCHAR(500));

	INSERT INTO #importacion_categoria_producto(linea, categoria)
		exec sp_executesql @sql;

	-- Inserto solo los nuevos
	INSERT INTO producto.categoria_producto(nombre_linea, nombre_categoria)
	SELECT
		i.linea, 
		i.categoria
	FROM #importacion_categoria_producto i
		LEFT JOIN producto.categoria_producto c ON c.nombre_categoria = i.categoria
	WHERE c.nombre_categoria IS NULL;

END;
