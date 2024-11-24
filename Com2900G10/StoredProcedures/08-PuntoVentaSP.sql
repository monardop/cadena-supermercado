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

--SP para tabla punto_venta
CREATE OR ALTER PROCEDURE CrearPuntoVenta
@nro_punto_venta INT,
@id_sucursal SMALLINT
AS
BEGIN
	IF EXISTS (SELECT * FROM [sucursal].[sucursal] s WHERE s.id_sucursal = @id_sucursal)
		IF NOT EXISTS (SELECT * FROM [sucursal].[punto_venta] pp
		WHERE pp.numero_punto_venta = @nro_punto_venta and pp.id_sucursal = @id_sucursal)
		BEGIN
			INSERT INTO [sucursal].[punto_venta] VALUES (@nro_punto_venta, @id_sucursal,1)
			PRINT ('Punto de venta insertado exitosamente.')
		END
		ELSE
		BEGIN
			RAISERROR ('El punto de venta que se esta queriendo crear ya existe',10,1)
			RETURN;
		END
	ELSE
	BEGIN
		RAISERROR ('La sucursal que se esta queriendo asociar al punto de venta no existe',10,1)
		RETURN;
	END
END
GO

CREATE OR ALTER PROCEDURE BajaPuntoVenta 
@nro_punto_venta int,
@id_sucursal smallint
AS
BEGIN
	IF EXISTS (SELECT * FROM [sucursal].[punto_venta] pp 
	WHERE pp.numero_punto_venta = @nro_punto_venta AND pp.id_sucursal = @id_sucursal AND activo = 1)
		BEGIN
			UPDATE [sucursal].[punto_venta]
			SET activo = 0
			WHERE numero_punto_venta = @nro_punto_venta AND id_sucursal = @id_sucursal

			PRINT('Punto de venta dado de baja exitosamente.')

			EXEC BajaPuntoVentaEmpleadoPorPuntoVentaSucursal @nro_punto_venta,@id_sucursal
		END
	ELSE
	BEGIN
		RAISERROR('El punto de venta que se quiere dar de baja no existe o ya se encuentra dado de baja.',10,1)
		RETURN
	END
END
GO

CREATE OR ALTER PROCEDURE AltaPuntoVenta 
@nro_punto_venta int,
@id_sucursal smallint
AS
BEGIN
	IF EXISTS (SELECT * FROM [sucursal].[punto_venta] pp 
	WHERE pp.numero_punto_venta = @nro_punto_venta AND pp.id_sucursal = @id_sucursal AND activo = 0)
		BEGIN
			UPDATE [sucursal].[punto_venta]
			SET activo = 1
			WHERE numero_punto_venta = @nro_punto_venta AND id_sucursal = @id_sucursal

			PRINT('Punto de venta dado de alta exitosamente.')

		END
	ELSE
	BEGIN
		RAISERROR('El punto de venta que se quiere dar de alta no existe o ya se encuentra dado de alta',10,1)
		RETURN
	END
END

