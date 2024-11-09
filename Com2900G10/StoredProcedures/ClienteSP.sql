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


-- SP para la tabla cliente
GO
CREATE OR ALTER PROCEDURE venta.CrearCliente
	@nombre VARCHAR(60),
	@apellido VARCHAR(60),
	@dni INT,
	@direccion VARCHAR(100),
	@cuil CHAR(13)
AS
BEGIN
	IF @cuil not like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]' OR @cuil is null
	BEGIN
		RAISERROR('El CUIL ingresado es invalido.',10,1);

		RETURN
	END

	IF @nombre IS NULL OR @apellido IS NULL OR @dni IS NULL
	BEGIN
		RAISERROR('Nombre, apellido y DNI son datos obligatorios.',10,1);

		RETURN
	END

	INSERT INTO venta.cliente 
    VALUES (@nombre, @apellido, @dni, @direccion, @cuil);

	PRINT 'Cliente creado exitosamente.';
END;


GO
CREATE OR ALTER PROCEDURE venta.ModificarCliente
	@id_cliente INT, -- Solo para la busqueda
	@nombre VARCHAR(60),
	@apellido VARCHAR(60),
	@dni INT,
	@direccion VARCHAR(100),
	@cuil CHAR(13)
AS
BEGIN
	IF @cuil not like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]' OR @cuil is null
	BEGIN
		RAISERROR('El CUIL ingresado es invalido.',10,1);

		RETURN
	END

	IF @nombre IS NULL OR @apellido IS NULL OR @dni IS NULL
	BEGIN
		RAISERROR('Nombre, apellido y DNI son datos obligatorios.',10,1);

		RETURN
	END

	UPDATE venta.cliente 
		SET nombre = @nombre,
		apellido = @apellido,
		dni = @dni,
		direccion = @direccion,
		cuil = @cuil
	WHERE id_cliente = @id_cliente;

	PRINT 'Cliente modificado exitosamente.';

END;