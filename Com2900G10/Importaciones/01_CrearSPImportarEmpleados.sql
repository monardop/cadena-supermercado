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

DROP SCHEMA IF EXISTS importacion;
GO

CREATE SCHEMA importacion;
GO

CREATE OR ALTER FUNCTION importacion.sanitizar_y_reemplazar(@sanitizar VARCHAR(300), @reemplazar VARCHAR(5))
RETURNS VARCHAR(300)
AS 
BEGIN
	RETURN replace(
			replace(
				replace(
					replace(
					 @sanitizar
					 ,char(9) /*tab*/,@reemplazar
					)
					 ,char(10) /*newline*/,@reemplazar
				)
					 ,char(13) /*carriage return*/,@reemplazar
			)
					,char(32) /*space*/,@reemplazar
		)
END;
GO

-- SP para la importar datos de empleados
GO
CREATE OR ALTER PROCEDURE importacion.ImportarEmpleados
@pathArchivos VARCHAR(500),
@hojaArchivo VARCHAR(100)
AS
BEGIN
	DECLARE @sql NVARCHAR(max) = 'SELECT * FROM
			 OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
						''Excel 12.0; Database=' + @pathArchivos + ''', 
						''SELECT * FROM ['+@hojaArchivo+'$]'');'
	
	CREATE TABLE #importacion_empleado(
		legajo INT,
		nombre VARCHAR(60),
		apellido VARCHAR(60),
		dni INT,
		direccion VARCHAR(300),
		email_personal VARCHAR(300),
		email_empresa VARCHAR(300),
		cuil VARCHAR(13),
		cargo VARCHAR(30),
		sucursal VARCHAR(50),
		id_sucursal SMALLINT,
		turno VARCHAR(30),
	)

	INSERT INTO #importacion_empleado(legajo, nombre, apellido, dni, direccion, email_personal, email_empresa, cuil, cargo, sucursal, turno)
		EXEC sp_executesql @sql;

	-- Pongo cuil default para los que no tengan cuil
	UPDATE #importacion_empleado SET cuil = '00-00000000-0' WHERE cuil IS NULL;

	-- Elimino registros invalidos
	DELETE FROM #importacion_empleado WHERE legajo IS NULL;

	-- Cruzo el ID Sucursal para preparar la insercion final
	UPDATE i 
		SET i.id_sucursal = s.id_sucursal
	FROM #importacion_empleado i 
		INNER JOIN sucursal.sucursal s ON s.reemplazar_por = i.sucursal


	-- Inserto solo los nuevos
	INSERT INTO sucursal.empleado
	SELECT 
		i.legajo, 
		i.nombre, 
		i.apellido, 
		i.dni, 
		i.direccion, 
		importacion.sanitizar_y_reemplazar(LOWER(i.email_personal),'_'), importacion.sanitizar_y_reemplazar(LOWER(i.email_empresa),'.'), 
		i.cuil, 
		i.cargo, 
		i.id_sucursal, 
		i.turno, 
		1
	FROM #importacion_empleado i
		LEFT JOIN sucursal.empleado s ON s.legajo = i.legajo
	WHERE s.legajo IS NULL;

	DROP TABLE #importacion_empleado;

END;