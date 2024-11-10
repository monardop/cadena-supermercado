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
	IF EXISTS (SELECT * FROM [Com2900G10].[sucursal].[sucursal] s WHERE s.id_sucursal = @id_sucursal)
		IF NOT EXISTS (SELECT * FROM [Com2900G10].[sucursal].[punto_venta] pp
		WHERE pp.numero_punto_venta = @nro_punto_venta and pp.id_sucursal = @id_sucursal)
			INSERT INTO [Com2900G10].[sucursal].[punto_venta] VALUES (@nro_punto_venta, @id_sucursal,1)
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

--No veo la utilidad de modificar un punto de venta. Seria necesario? un punto de venta que cambia de numero, es el mismo punto de venta?
--no registramos mas informacion que esa, cual seria la diferencia con crear directamente un punto de venta nuevo y dar de baja el antiguo?
--a lo sumo la modificacion podria dar de baja el viejo y crear uno nuevo.

CREATE OR ALTER PROCEDURE BajaPuntoVenta 
@nro_punto_venta int,
@id_sucursal smallint
AS
BEGIN
	IF EXISTS (SELECT * FROM [Com2900G10].[sucursal].[punto_venta] pp 
	WHERE pp.numero_punto_venta = @nro_punto_venta AND pp.id_sucursal = @id_sucursal)
		BEGIN
			UPDATE [Com2900G10].[sucursal].[punto_venta]
			SET activo = 0
			WHERE numero_punto_venta = @nro_punto_venta AND id_sucursal = @id_sucursal

			PRINT('Punto de venta dado de baja exitosamente.')

			EXEC BajaPuntoVentaEmpleadoPorPuntoVentaSucursal @nro_punto_venta,@id_sucursal
		END
	ELSE
	BEGIN
		RAISERROR('El punto de venta que se quiere dar de baja no existe',10,1)
		RETURN
	END
END

