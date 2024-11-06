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
CREATE OR ALTER PROCEDURE ImportarEmpleados
@pathArchivos varchar(200)
AS
BEGIN
	DECLARE @sql varchar(max) = 'SELECT * FROM
			 OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
						''Excel 12.0; Database=' + @pathArchivos + ''', 
						[Empleados$]);'
	
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

	-- Elimino registros invalidos
	DELETE FROM #importacion_empleado WHERE legajo IS NULL;

	-- Cruzo el ID Sucursal para preparar la insercion final
	UPDATE i 
		SET i.id_sucursal = s.id_sucursal
	FROM #importacion_empleado i 
		INNER JOIN sucursal.sucursal s ON s.reemplazar_por = i.sucursal


	INSERT INTO sucursal.empleado
	SELECT legajo, nombre, apellido, dni, direccion, importacion.sanitizar_y_reemplazar(LOWER(email_personal),'_'), importacion.sanitizar_y_reemplazar(LOWER(email_empresa),'.'), cuil, cargo, id_sucursal, turno, 1
	FROM #importacion_empleado

	DROP TABLE #importacion_empleado;

END;

/* SELECT * FROM sucursal.empleado;
DELETE FROM sucursal.empleado
EXEC ImportarEmpleados;
SELECT * FROM sucursal.empleado; */
