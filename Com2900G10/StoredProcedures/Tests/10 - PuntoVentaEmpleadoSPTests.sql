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
						SP: CrearPuntoVentaEmpleado
*******************************************************************************/

/* Resultado Esperado: 'El numero de punto de venta que quiere asociar no existe o no pertenece a la sucursal.' */
EXEC CrearPuntoVentaEmpleado 1,1,1234

/* Resultado Esperado: 'El empleado que esta queriendo asociar al punto de venta no existe o no trabaja en la sucursal.' */
EXEC CrearPuntoVentaEmpleado 3,2,1234

/* Resultado Esperado: 'El empleado que esta queriendo asociar al punto de venta no existe o no trabaja en la sucursal.' */
EXEC CrearPuntoVentaEmpleado 3,1,5678

/* Resultado Esperado: 'Puesto de venta asociado exitosamente con empleado.' */
EXEC CrearPuntoVentaEmpleado 3,1,1234

/*******************************************************************************
						SP: BajaPuntoVentaEmpleado
*******************************************************************************/

/* Resultado Esperado: 'La asociacion de punto de venta con empleado que esta queriendo dar de baja no existe.' */
EXEC BajaPuntoVentaEmpleado 2

/* Resultado Esperado: Baja exitosa. */
EXEC BajaPuntoVentaEmpleado 1

/*******************************************************************************
						SP: AltaPuntoVentaEmpleado
*******************************************************************************/

/* Resultado Esperado: 'La asociacion de punto de venta con empleado que esta queriendo dar de alta no existe.' */
EXEC AltaPuntoVentaEmpleado 2

/* Resultado Esperado: 'Punto de venta dado de alta exitosamente.' */
EXEC AltaPuntoVentaEmpleado 1

/*******************************************************************************
						SP: BajaPuntoVentaEmpleadoPorEmpleado
*******************************************************************************/

/* Resultado Esperado: 'El empleado no se encuentra registrado en la tabla punto_venta_empleado' */
EXEC BajaPuntoVentaEmpleadoPorEmpleado 5678

/* Resultado Esperado: Baja exitosa */
EXEC BajaPuntoVentaEmpleadoPorEmpleado 1234


/*******************************************************************************
						SP: BajaPuntoVentaEmpleadoPorSucursal
*******************************************************************************/

/* Resultado Esperado: 'El punto de venta empleado no se encuentra registrado en la tabla punto_venta_empleado o ya fue dado de baja' */
EXEC BajaPuntoVentaEmpleadoPorSucursal 2

/* Resultado Esperado: 'Punto de venta empleado dado de baja exitosamente.' */
EXEC BajaPuntoVentaEmpleadoPorSucursal 1

/*******************************************************************************
						SP: BajaPuntoVentaEmpleadoPorPuntoVentaSucursal
*******************************************************************************/

/* Resultado Esperado: 'Los puntos de venta empleado solicitados para dar de baja no existen o ya fueron dados de baja' */
EXEC BajaPuntoVentaEmpleadoPorPuntoVentaSucursal 2,3

/* Resultado Esperado: 'Los puntos de venta empleado solicitados para dar de baja no existen o ya fueron dados de baja' */
EXEC BajaPuntoVentaEmpleadoPorPuntoVentaSucursal 1,4

/* Resultado Esperado: 'Baja exitosa.' */
EXEC BajaPuntoVentaEmpleadoPorPuntoVentaSucursal 1,3
