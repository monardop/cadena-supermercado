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
						SP: AgregarConfiguracion
*******************************************************************************/

/*Resultado esperado: OK Agregado*/
EXEC configuracion.AgregarConfiguracion 'Valor Dolar', '1125'

/*Resultado esperado: 'La configuracion que se esta queriendo insertar ya existe.'*/
EXEC configuracion.AgregarConfiguracion 'Valor Dolar', '1125'


/*******************************************************************************
						SP: ModificarConfiguracion
*******************************************************************************/

/*Resultado esperado: 'La configuracion que se esta queriendo modificar no existe.'*/
EXEC configuracion.ModificarConfiguracion 'Hola', 'Pepe'

/*Resultado esperado: OK Modificado.*/
EXEC configuracion.ModificarConfiguracion 'Valor Dolar', '1200'

/*******************************************************************************
						SP: EliminarConfiguracionPorID
*******************************************************************************/

/*Resultado esperado: 'La configuracion que se esta queriendo eliminar no existe.'*/
EXEC configuracion.EliminarConfiguracionPorID 9999

/*Resultado esperado: OK Eliminado'*/
EXEC configuracion.EliminarConfiguracionPorID 1

/*******************************************************************************
						SP: EliminarConfiguracionPorDescripcion
*******************************************************************************/

/*Resultado esperado: No se puede eliminar la configuracion debido a que no existe.*/
EXEC configuracion.EliminarConfiguracionPorDescripcion 'AAAAA'

/*Resultado esperado: Eliminado OK*/
EXEC configuracion.AgregarConfiguracion 'Valor Dolar', '1125'
EXEC configuracion.EliminarConfiguracionPorDescripcion 'Valor Dolar'

