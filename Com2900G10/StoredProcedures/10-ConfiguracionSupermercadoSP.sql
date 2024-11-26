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
USE Com2900G10;
GO
--SP para configuracion_supermercado

CREATE OR ALTER PROCEDURE configuracion.AgregarConfiguracion
@descripcion varchar(70),
@valor varchar(70)
AS
BEGIN
	IF NOT EXISTS (SELECT TOP 1 * FROM [Com2900G10].[configuracion].[configuracion_supermercado] 
	WHERE descripcion = @descripcion)
	BEGIN
		INSERT INTO [Com2900G10].[configuracion].[configuracion_supermercado]
		VALUES (@descripcion, @valor)
		PRINT('Configuracion insertada con exito.');
	END
	ELSE
	BEGIN
		RAISERROR('La configuracion que se esta queriendo insertar ya existe.',10,1);
		RETURN
	END
END
GO

CREATE OR ALTER PROCEDURE configuracion.ModificarConfiguracion
@descripcion varchar(70),
@valor varchar(70)
AS
BEGIN
	IF EXISTS (SELECT TOP 1 * FROM [Com2900G10].[configuracion].[configuracion_supermercado]
	WHERE descripcion = @descripcion)
	BEGIN
		UPDATE [Com2900G10].[configuracion].[configuracion_supermercado]
		SET valor = @valor
		WHERE descripcion = @descripcion

		PRINT ('Configuracion actualizada exitosamente');
	END
	ELSE
	BEGIN
		RAISERROR ('La configuracion que se esta queriendo modificar no existe.',10,1)
		RETURN;
	END
END
GO


CREATE OR ALTER PROCEDURE configuracion.EliminarConfiguracionPorID
@id_config INT
AS
BEGIN
	IF EXISTS (SELECT TOP 1 * FROM [Com2900G10].[configuracion].[configuracion_supermercado] 
	WHERE id_configuracion_supermercado = @id_config)
	BEGIN
		DELETE FROM [Com2900G10].[configuracion].[configuracion_supermercado]
		WHERE id_configuracion_supermercado = @id_config
		PRINT ('Configuracion eliminada exitosamente.')
	END
	ELSE
	BEGIN
		RAISERROR('No se puede eliminar la configuracion debido a que no existe.',10,1)
		RETURN;
	END
END
GO


CREATE OR ALTER PROCEDURE configuracion.EliminarConfiguracionPorDescripcion
@descripcion varchar(70)
AS
BEGIN
	IF EXISTS (SELECT TOP 1 * FROM [Com2900G10].[configuracion].[configuracion_supermercado] 
	WHERE descripcion = @descripcion)
	BEGIN
		DELETE FROM [Com2900G10].[configuracion].[configuracion_supermercado]
		WHERE descripcion = @descripcion
		PRINT ('Configuracion eliminada exitosamente.')
	END
	ELSE
	BEGIN
		RAISERROR('No se puede eliminar la configuracion debido a que no existe.',10,1)
		RETURN;
	END
END
GO