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
CREATE OR ALTER PROCEDURE importacion.ImportarProductosImportados
	@pathArchivos VARCHAR(200),
	@hojaArchivo VARCHAR(100),
	@valorDolar DECIMAL(12,2)
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

	CREATE TABLE #importacion_productos_importados(
		id_producto_archivo VARCHAR(5),
		producto VARCHAR(500), 
		proveedor VARCHAR(300),
		categoria VARCHAR(300),
		detalle_cantidad VARCHAR(300),
		precio_unitario_dolares DECIMAL(6,2)
	);

	
	INSERT INTO #importacion_productos_importados
		exec sp_executesql @sql;

	
	-- Sanitizo
	UPDATE #importacion_productos_importados SET categoria = importacion.sanitizar_y_reemplazar(categoria,'');

	-- Agrego una columna para cruzar los ID de categoria
	ALTER TABLE #importacion_productos_importados ADD id_categoria SMALLINT;
	
	-- Genero categorias inexistentes
	INSERT INTO producto.categoria_producto(nombre_linea, nombre_categoria)
	SELECT i.categoria, i.categoria
	FROM #importacion_productos_importados i
		LEFT JOIN producto.categoria_producto p ON p.nombre_categoria = i.categoria
	WHERE p.nombre_categoria IS NULL
	GROUP BY i.categoria

	-- Actualizo el ID de Categoria
	UPDATE i 
	SET i.id_categoria = c.id_categoria_producto
	FROM #importacion_productos_importados i
		INNER JOIN producto.categoria_producto c ON c.nombre_categoria = i.categoria


	-- Inserto los nuevos
	INSERT INTO producto.producto(id_categoria_producto, nombre_producto, precio_unitario)
		SELECT 
			i.id_categoria,
			i.producto, 
			i.precio_unitario_dolares * @valorDolar
		FROM #importacion_productos_importados i
			LEFT JOIN producto.producto p ON p.nombre_producto = i.producto
		WHERE p.nombre_producto IS NULL;
END;
