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

CREATE OR ALTER PROCEDURE sucursal.CrearPuntoVentaEmpleado
@nro_punto_venta INT,
@id_sucursal SMALLINT,
@legajo_empleado INT
AS
BEGIN
	IF EXISTS (SELECT * FROM [Com2900G10].[sucursal].[punto_venta_empleado]
					WHERE numero_punto_venta = @nro_punto_venta  AND id_sucursal = @id_sucursal and legajo_empleado = @legajo_empleado
					AND activo = 1)
	BEGIN
		RAISERROR('La asociacion entre punto de venta y empleado que se esta queriendo crear ya existe y se encuentra activa.',10,1)
		
		RETURN
	END

	IF NOT EXISTS (SELECT * FROM [Com2900G10].[sucursal].[empleado] WHERE legajo = @legajo_empleado AND id_sucursal = @id_sucursal)
	BEGIN
		RAISERROR('El empleado que esta queriendo asociar al punto de venta no existe o no trabaja en la sucursal.',10,1)
		
		RETURN
	END

	INSERT INTO [Com2900G10].[sucursal].[punto_venta_empleado] VALUES (@nro_punto_venta,@id_sucursal,@legajo_empleado,1)
	PRINT ('Asociacion entre punto de venta y empleado generada exitosamente.')
	
END
GO

CREATE OR ALTER PROCEDURE sucursal.BajaPuntoVentaEmpleado
@id_punto_venta_empleado INT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM [sucursal].[punto_venta_empleado] WHERE id_punto_venta_empleado = @id_punto_venta_empleado and activo = 1)
	BEGIN
		RAISERROR('La asociacion de punto de venta con empleado que esta queriendo dar de baja no existe o ya fue dado de baja.',10,1)
		
		RETURN
	END


	UPDATE [sucursal].[punto_venta_empleado]
	SET activo = 0
	WHERE id_punto_venta_empleado = @id_punto_venta_empleado

	PRINT('Asociacion entre puntos de venta y empleado dada de baja exitosamente. Filtrada por: ID Punto venta empleado')
	

END
GO

CREATE OR ALTER PROCEDURE sucursal.AltaPuntoVentaEmpleado
@id_punto_venta_empleado int
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM [sucursal].[punto_venta_empleado] WHERE id_punto_venta_empleado = @id_punto_venta_empleado and activo = 0)
	BEGIN
		RAISERROR('La asociacion de punto de venta con empleado que esta queriendo dar de alta no existe o ya fue dada de alta.',10,1)

		RETURN
	END

	UPDATE [sucursal].[punto_venta_empleado]
		SET activo = 1
		WHERE id_punto_venta_empleado = @id_punto_venta_empleado

	PRINT ('Asociacion entre puntos de venta y empleado dada de alta exitosamente.')

END
GO

CREATE OR ALTER PROCEDURE sucursal.BajaPuntoVentaEmpleadoPorEmpleado 
@legajo_empleado_baja int
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM [sucursal].[punto_venta_empleado] WHERE legajo_empleado = @legajo_empleado_baja and activo = 1)
	BEGIN
		RAISERROR ('Las asociaciones entre punto de venta y empleados que esta tratando dar de baja no existen o ya fueron dadas de baja.',10,1)

		RETURN
	END

	UPDATE [sucursal].[punto_venta_empleado]
		SET activo = 0
		WHERE legajo_empleado = @legajo_empleado_baja 
		and activo = 1

	PRINT('Asociacion entre puntos de venta y empleado dada de baja exitosamente. Filtrada por: Empleado')

END
GO

CREATE OR ALTER PROCEDURE sucursal.BajaPuntoVentaEmpleadoPorSucursal
@id_sucursal_baja smallint
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM [sucursal].[punto_venta_empleado]  WHERE id_sucursal = @id_sucursal_baja and activo = 1)
	BEGIN
		RAISERROR ('No hay puntos de ventas asociados en esa sucursal.',10,1)

		RETURN
	END

	UPDATE [sucursal].[punto_venta_empleado]
		SET activo = 0
		WHERE id_sucursal = @id_sucursal_baja

	PRINT('Asociacion entre puntos de venta y empleados dadas de baja exitosamente. Filtrada por: Sucursal')

END
GO