/*******************************************************************************
*                                                                             *
*                           Entrega 3 - Grupo 10                              *
*																			  *
*                           Integrantes:                                      *
*                           43.988.577 Juan Pi�an                             *
*                           43.049.457 Matias Matter                          *
*                           42.394.230 Lucas Natario                          *
*                           40.429.974 Pablo Monardo                          *
*                                                                             *
*                                                                             *
* "Cree la base de datos, entidades y relaciones. Incluya restricciones y     *
* claves. Deber� entregar un archivo .sql con el script completo de creaci�n  *
* (debe funcionar si se lo ejecuta �tal cual� es entregado). Incluya          *
* comentarios para indicar qu� hace cada m�dulo de c�digo.                    *
* Genere store procedures para manejar la inserci�n, modificaci�n, borrado    *
* (si corresponde, tambi�n debe decidir si determinadas entidades solo        *
* admitir�n borrado l�gico) de cada tabla."                                   *
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

