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


GO
USE Com2900G10;
GO

CREATE OR ALTER PROCEDURE CrearPuntoVentaEmpleado
@nro_punto_venta INT,
@id_sucursal SMALLINT,
@legajo_empleado INT
AS
BEGIN
IF NOT EXISTS (SELECT * FROM [Com2900G10].[sucursal].[punto_venta_empleado]
				WHERE numero_punto_venta = @nro_punto_venta  AND id_sucursal = @id_sucursal
				AND activo = 1)
BEGIN
		IF EXISTS (SELECT * FROM [Com2900G10].[sucursal].[empleado]
		WHERE legajo = @legajo_empleado AND id_sucursal = @id_sucursal) --Si el empleado existe y trabaja en la sucursal que se quiere asociar el punto de venta
		BEGIN
			IF EXISTS (SELECT * FROM [Com2900G10].[sucursal].[punto_venta]
			WHERE numero_punto_venta = @nro_punto_venta and id_sucursal = @id_sucursal)
			BEGIN
				INSERT INTO [Com2900G10].[sucursal].[punto_venta_empleado] VALUES (@nro_punto_venta,@id_sucursal,@legajo_empleado,1)
				PRINT ('Asociacion entre punto de venta y empleado generada exitosamente.')
			END
			ELSE
			BEGIN
				RAISERROR('El numero de punto de venta que quiere asociar no existe o no pertenece a la sucursal.',10,1)
				RETURN
			END
		END
		ELSE
		BEGIN
			RAISERROR('El empleado que esta queriendo asociar al punto de venta no existe o no trabaja en la sucursal.',10,1)
			RETURN
		END
END
ELSE
	BEGIN
		RAISERROR('La asociacion entre punto de venta y empleado que se esta queriendo crear ya existe y se encuentra activa.',10,1)
		RETURN
	END
END
GO

CREATE OR ALTER PROCEDURE BajaPuntoVentaEmpleado
@id_punto_venta_empleado int
AS
BEGIN
	IF EXISTS (SELECT * FROM [sucursal].[punto_venta_empleado]
	WHERE id_punto_venta_empleado = @id_punto_venta_empleado and activo = 1)
	BEGIN
		UPDATE [sucursal].[punto_venta_empleado]
		SET activo = 0
		WHERE id_punto_venta_empleado = @id_punto_venta_empleado

		PRINT('Asociacion entre puntos de venta y empleado dada de baja exitosamente. Filtrada por: ID Punto venta empleado')
	END
	ELSE
	BEGIN
		RAISERROR('La asociacion de punto de venta con empleado que esta queriendo dar de baja no existe o ya fue dado de baja.',10,1)
		RETURN
	END
END
GO

CREATE OR ALTER PROCEDURE AltaPuntoVentaEmpleado
@id_punto_venta_empleado int
AS
BEGIN
	IF EXISTS (SELECT * FROM [sucursal].[punto_venta_empleado]
	WHERE id_punto_venta_empleado = @id_punto_venta_empleado and activo = 0)
	BEGIN
		UPDATE [sucursal].[punto_venta_empleado]
		SET activo = 1
		WHERE id_punto_venta_empleado = @id_punto_venta_empleado

		PRINT ('Asociacion entre puntos de venta y empleado dada de alta exitosamente.')
	END
	ELSE
	BEGIN
		RAISERROR('La asociacion de punto de venta con empleado que esta queriendo dar de alta no existe o ya fue dada de alta.',10,1)
		RETURN
	END
END
GO

CREATE OR ALTER PROCEDURE BajaPuntoVentaEmpleadoPorEmpleado 
@legajo_empleado_baja int
AS
BEGIN
	IF EXISTS (SELECT * FROM [sucursal].[punto_venta_empleado]
	WHERE legajo_empleado = @legajo_empleado_baja and activo = 1)
	BEGIN
		UPDATE [sucursal].[punto_venta_empleado]
		SET activo = 0
		WHERE legajo_empleado = @legajo_empleado_baja 
		and activo = 1
		print('Asociacion entre puntos de venta y empleado dada de baja exitosamente. Filtrada por: Empleado')
	END
	ELSE
	BEGIN
		RAISERROR ('Las asociaciones entre punto de venta y empleados que esta tratando dar de baja no existen o ya fueron dadas de baja.',10,1)
		RETURN
	END
END
GO

CREATE OR ALTER PROCEDURE BajaPuntoVentaEmpleadoPorSucursal
@id_sucursal_baja smallint
AS
BEGIN
	IF EXISTS (SELECT * FROM [sucursal].[punto_venta_empleado] 
	WHERE id_sucursal = @id_sucursal_baja and activo = 1)
	BEGIN
		UPDATE [sucursal].[punto_venta_empleado]
		SET activo = 0
		WHERE id_sucursal = @id_sucursal_baja

		PRINT('Asociacion entre puntos de venta y empleados dadas de baja exitosamente. Filtrada por: Sucursal')
	END
	ELSE
	BEGIN
		RAISERROR ('Las asociaciones entre punto de venta y empleados que esta tratando dar de baja no existen o ya fueron dadas de baja.',10,1)
		RETURN
	END
END
GO

CREATE OR ALTER PROCEDURE BajaPuntoVentaEmpleadoPorPuntoVentaSucursal
@id_sucursal_baja smallint,
@nro_punto_venta_baja int
AS
BEGIN
	IF EXISTS (SELECT * FROM [sucursal].[punto_venta_empleado] 
	WHERE id_sucursal = @id_sucursal_baja AND numero_punto_venta = @nro_punto_venta_baja
	AND activo = 1)
	BEGIN
		UPDATE [sucursal].[punto_venta_empleado]
		SET activo = 0
		WHERE id_sucursal = @id_sucursal_baja 
		and numero_punto_venta = @nro_punto_venta_baja 
		and activo = 1

		PRINT('Asociacion entre puntos de venta y empleados dadas de baja exitosamente. Filtrada por: Numero punto venta y Sucursal')

	END
	ELSE
	BEGIN
		RAISERROR ('Las asociaciones entre punto de venta y empleados que esta tratando dar de baja no existen o ya fueron dadas de baja.',10,1)
		RETURN
	END
END