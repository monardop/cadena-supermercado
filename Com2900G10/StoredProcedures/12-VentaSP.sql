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
-- SP para la tabla Venta
CREATE OR ALTER PROCEDURE venta.GenerarVenta
@id_factura INT,
@legajo_empleado INT,
@id_sucursal  SMALLINT,
@tipo_cliente VARCHAR(50),
@id_cliente	INT,
@id_punto_venta_empleado INT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM [Com2900G10].[venta].[venta] where id_factura = @id_factura)
	BEGIN
		
	END
	ELSE
	BEGIN
		RAISERROR ('No puede haber 2 ventas para una misma factura.',10,1)
		RETURN
	END
END
GO