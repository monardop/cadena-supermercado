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


-- SP para la tabla medio_pago
GO
CREATE OR ALTER PROCEDURE venta.CrearMedioPago
	@nombre_eng VARCHAR(20),
	@nombre_esp VARCHAR(20)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM venta.medio_pago WHERE nombre_eng = @nombre_eng OR nombre_esp = @nombre_esp)
	BEGIN
		RAISERROR('Medio de pago ya existente.',10,1);

		RETURN
	END

	INSERT INTO venta.medio_pago 
    VALUES (@nombre_eng, @nombre_esp);

	PRINT 'Medio de pago agregado exitosamente.';
END;


GO
CREATE OR ALTER PROCEDURE venta.ModificarMedioPago
	@id_medio_pago SMALLINT, -- Solo para la busqueda
	@nombre_eng VARCHAR(20),
	@nombre_esp VARCHAR(20)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM venta.medio_pago WHERE id_medio_pago =  @id_medio_pago)
    BEGIN
        UPDATE venta.medio_pago 
			SET nombre_eng = @nombre_eng, nombre_esp = @nombre_esp
		WHERE id_medio_pago = @id_medio_pago;
	
        PRINT 'Medio de pago modificado exitosamente.';
	END
	ELSE
	   RAISERROR('El medio de pago no existe.',10,1);

END;
