/*

Entrega 3 - Grupo 10 - Pi�an, Monardo, Matter, Natario

"Genere store procedures para manejar la inserci�n, modificado, borrado (si corresponde,
tambi�n debe decidir si determinadas entidades solo admitir�n borrado l�gico) de cada tabla.
Los nombres de los store procedures NO deben comenzar con �SP�.
Genere esquemas para organizar de forma l�gica los componentes del sistema y aplique esto
en la creaci�n de objetos. NO use el esquema �dbo�"

*/

GO
USE Com2900G10;


-- SP para la tabla medio_pago
GO
CREATE OR ALTER PROCEDURE CrearMedioPago
	@nombre_eng VARCHAR(20),
	@nombre_esp VARCHAR(20)
AS
BEGIN
	INSERT INTO venta.medio_pago 
    VALUES (@nombre_eng, @nombre_esp);

	PRINT 'Medio de pago agregado exitosamente.';
END;


GO
CREATE OR ALTER PROCEDURE ModificarMedioPago
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
            BEGIN
                PRINT 'El medio de pago no existe.';
            END
END;
