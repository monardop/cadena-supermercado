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

USE [Com2900G10]
GO
/*******************************************************************************
						SP: BajaSucursal
*******************************************************************************/
/* Resultado esperado: Error - "La sucursal no fue encontrada o ya fue dada de baja anteriormente" */
EXEC [Com2900G10].[sucursal].[BajaSucursal] 999

/*******************************************************************************
						SP: CrearSucursal
*******************************************************************************/

/* Resultado esperado: OK */
EXEC [Com2900G10].[sucursal].[CrearSucursal] 'Haedo','Ramos Mejia','Calle Falsa 123','Tarde','1234-5678'
-- SELECT * FROM [Com2900G10].[sucursal].[sucursal]

/* Resultado esperado: Error - "La sucursal ya existe" */
EXEC [Com2900G10].[sucursal].[CrearSucursal] 'Haedo','Ramos Mejia','Calle Falsa 123','Tarde','1234-5678'


/*******************************************************************************
						SP: AltaSucursal
*******************************************************************************/

/* Resultado esperado: Error - "La sucursal no fue encontrada o está activa" */
EXEC [Com2900G10].[sucursal].[AltaSucursal] 1
EXEC [Com2900G10].[sucursal].[AltaSucursal] 999


/*******************************************************************************
						SP: BajaSucursal
*******************************************************************************/

/* Resultado esperado: OK */
EXEC [Com2900G10].[sucursal].[BajaSucursal] 1
-- SELECT * FROM [Com2900G10].[sucursal].[sucursal];

/* Resultado esperado: Error - "La sucursal no fue encontrada o ya fue dada de baja anteriormente"  */
EXEC [Com2900G10].[sucursal].[BajaSucursal] 1
EXEC [Com2900G10].[sucursal].[BajaSucursal] 999

/*******************************************************************************
						SP: CambiarUbicacion
*******************************************************************************/

/* Resultado esperado : Error - "La sucursal no existe o fue dada de baja" */
EXEC [Com2900G10].[sucursal].[CambiarUbicacion] 1, 'Ramos Mejia', 'Haedo', 'Calle False 456'
EXEC [Com2900G10].[sucursal].[CambiarUbicacion] 999, 'Ramos Mejia', 'Haedo', 'Calle False 456'

/* Resultado esperado: Cambio OK*/
	--Dar de alta nuevamente la sucursal
	EXEC [Com2900G10].[sucursal].[AltaSucursal] 1
EXEC [Com2900G10].[sucursal].[CambiarUbicacion] 1, 'Ramos Mejia', 'Haedo', 'Calle False 456'


/*******************************************************************************
						SP: CambiarTelefono
*******************************************************************************/

/* Resultado esperado: Error - "La sucursal buscada no existe o está inactiva" */
	-- Dar de baja la sucursal
	EXEC [Com2900G10].[sucursal].[BajaSucursal] 1
EXEC [Com2900G10].[sucursal].[CambiarTelefono] 1,'9089-7654'
EXEC [Com2900G10].[sucursal].[CambiarTelefono] 999,'9089-7654' --inexistente

/* Resultado esperado: Cambio OK*/
	--Dar de alta la sucursal nuevamente
	EXEC [Com2900G10].[sucursal].[AltaSucursal] 1
EXEC [Com2900G10].[sucursal].[CambiarTelefono] 1,'9089-7654'