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
						SP: CrearEmpleado
*******************************************************************************/

/* Resultado esperado: Insercion OK*/
EXEC [Com2900G10].[sucursal].[CrearEmpleado] 1234, 'John', 'Doe', '40397273', '', '', '', '20-40397273-5', 'Jefe', 'TM', 1;

/* Resultado esperado: Error - "Debe ingresar un legajo para el empleado" */
EXEC [Com2900G10].[sucursal].[CrearEmpleado] NULL, 'John', 'Doe', '40397273', '', '', '', '20-40397273-5', 'Jefe', 'TM', 1;

/*******************************************************************************
						SP: BajaEmpleado
*******************************************************************************/

/* Resultado esperado: Baja OK */
EXEC [Com2900G10].[sucursal].[BajaEmpleado] 123456;

/* Resultado esperado: Error - "El empleado no existe o ya est� dado de baja." */
EXEC [Com2900G10].[sucursal].[BajaEmpleado] 999;

/*******************************************************************************
						SP: AltaEmpleado
*******************************************************************************/

/* Resultado esperado: Alta OK */
EXEC [Com2900G10].[sucursal].[AltaEmpleado] 123456;

/* Resultado esperado: Error - "El empleado no existe o ya est� dado de alta." */
EXEC [Com2900G10].[sucursal].[AltaEmpleado] 999;

/*******************************************************************************
						SP: ModificarEmpleado
*******************************************************************************/

/* Resultado esperado: Modificacion OK*/
EXEC [Com2900G10].[sucursal].[ModificarEmpleado] 1234, 'Alberto', 'Doe', '40397273', '', '', '', '20-40397273-5', 'Jefe', 'TM', 1;

/* Resultado esperado: Error - "Debe ingresar el legajo del empleado a actualizar" */
EXEC [Com2900G10].[sucursal].[ModificarEmpleado] NULL, 'Alberto', 'Doe', '40397273', '', '', '', '20-40397273-5', 'Jefe', 'TM', 1;

/* Resultado esperado: Error - "La sucursal del empleado no existe o esta inactiva" */
EXEC [Com2900G10].[sucursal].[ModificarEmpleado] 1234, 'Alberto', 'Doe', '40397273', '', '', '', '20-40397273-5', 'Jefe', 'TM', 999;

/* Resultado esperado: Error - "El empleado no existe o est� inactivo" */
EXEC [Com2900G10].[sucursal].[ModificarEmpleado] 999, 'Alberto', 'Doe', '40397273', '', '', '', '20-40397273-5', 'Jefe', 'TM', 1;