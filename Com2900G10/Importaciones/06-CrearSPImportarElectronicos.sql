/*******************************************************************************
*                                                                             *
*                           Entrega 3 - Grupo 10                              *
*                                                                             *
*                           Integrantes:                                      *
*                           43.988.577 Juan Pi�an                             *
*                           43.049.457 Matias Matter                          *
*                           42.394.230 Lucas Natario                          *
*                           40.429.974 Pablo Monardo                          *
*                                                                             *
*                                                                             *
* "Se requiere que importe toda la informaci�n antes mencionada a la base de  *
* datos:                                                                      *
* � Genere los objetos necesarios (store procedures, funciones, etc.) para    *
*   importar los archivos antes mencionados. Tenga en cuenta que cada mes se  *
*   recibir�n archivos de novedades con la misma estructura, pero datos nuevos*
*   para agregar a cada maestro.                                              *
* � Considere este comportamiento al generar el c�digo. Debe admitir la       *
*   importaci�n de novedades peri�dicamente.                                  *
* � Cada maestro debe importarse con un SP distinto. No se aceptar�n scripts  *
*   que realicen tareas por fuera de un SP.                                   *
* � La estructura/esquema de las tablas a generar ser� decisi�n suya. Puede   *
*   que deba realizar procesos de transformaci�n sobre los maestros recibidos *
*   para adaptarlos a la estructura requerida.                                *
* � Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal *
*   cargados, incompletos, err�neos, etc., deber� contemplarlo y realizar las *
*   correcciones en el fuente SQL. (Ser�a una excepci�n si el archivo est�    *
*   malformado y no es posible interpretarlo como JSON o CSV)."               *
*                                                                             *
*******************************************************************************/


GO
USE Com2900G10;
GO

-- SP para la importar datos de clasificacion de productos
GO
CREATE OR ALTER PROCEDURE importacion.ImportarElectronicos
	@pathArchivos VARCHAR(200),
	@hojaArchivo VARCHAR(100),
	@valorDolar Decimal(12,2)
AS
BEGIN
	DECLARE @id_default_categoria SMALLINT;

	SELECT @id_default_categoria = valor FROM configuracion.parametros_generales WHERE descripcion = configuracion.obtener_id_categoria_default_importacion()

	declare @sql NVARCHAR(MAX) = '
		SELECT 
			*
		FROM
				OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
						''Excel 12.0; Database='+ @pathArchivos+ ''', 
						''SELECT * FROM ['+@hojaArchivo+'$]''
						)';

	CREATE TABLE #importacion_electronicos(producto VARCHAR(500), precio_unitario_dolares DECIMAL(6,2));

	
	INSERT INTO #importacion_electronicos
		exec sp_executesql @sql;

	-- Inserto los nuevos
	INSERT INTO producto.producto(id_categoria_producto, nombre_producto, precio_unitario)
		SELECT 
			@id_default_categoria,
			i.producto, 
			CAST(i.precio_unitario_dolares * @valorDolar AS decimal(10,2))
		FROM #importacion_electronicos i
			LEFT JOIN producto.producto p ON p.nombre_producto = i.producto
		WHERE p.nombre_producto IS NULL;
END;
