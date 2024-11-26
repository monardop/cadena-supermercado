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
/*****************************************************************************************************
	SP: CrearPuntoVentaEmpleado @nro_punto_venta INT, @id_sucursal SMALLINT, @legajo_empleado INT
******************************************************************************************************/
select * FROM sucursal.empleado
/* Resultado Esperado: Generado exitosamente */
EXEC sucursal.CrearPuntoVentaEmpleado 1,1,1234

/* Resultado Esperado: 'El empleado que esta queriendo asociar al punto de venta no existe o no trabaja en la sucursal.' */
--El empleado existe, pero no trabaja en esa sucursal.--
EXEC sucursal.CrearPuntoVentaEmpleado 3,2,1234

/* Resultado Esperado: 'El empleado que esta queriendo asociar al punto de venta no existe o no trabaja en la sucursal.' */
--El empleado no existe--
EXEC sucursal.CrearPuntoVentaEmpleado 3,1,9999

/* Resultado Esperado: 'Puesto de venta asociado exitosamente con empleado.' */
EXEC sucursal.CrearPuntoVentaEmpleado 3,1,1234

/* Resultado Esperado: 'La asociacion entre punto de venta y empleado que se esta queriendo crear ya existe y se encuentra activa.' */
EXEC sucursal.CrearPuntoVentaEmpleado 3,1,1234

/*******************************************************************************
			SP: BajaPuntoVentaEmpleado @id_punto_venta_empleado INT
*******************************************************************************/

/* Resultado Esperado: 'La asociacion de punto de venta con empleado que esta queriendo dar de baja no existe o ya fue dado de baja.' */
EXEC sucursal.BajaPuntoVentaEmpleado 999

/* Resultado Esperado: Baja exitosa. */
EXEC sucursal.BajaPuntoVentaEmpleado 1

/*******************************************************************************
			SP: AltaPuntoVentaEmpleado @id_punto_venta_empleado INT
*******************************************************************************/

/* Resultado Esperado: 'La asociacion de punto de venta con empleado que esta queriendo dar de alta no existe o ya fue dada de alta.' */
EXEC sucursal.AltaPuntoVentaEmpleado 999

/* Resultado Esperado: 'Asociacion entre puntos de venta y empleado dada de alta exitosamente.' */
EXEC sucursal. AltaPuntoVentaEmpleado 1

/*******************************************************************************
						SP: BajaPuntoVentaEmpleadoPorEmpleado
*******************************************************************************/

/* Resultado Esperado: 'Las asociaciones entre punto de venta y empleados que esta tratando dar de baja no existen o ya fueron dadas de baja.' */
EXEC sucursal.BajaPuntoVentaEmpleadoPorEmpleado 99999

/* Resultado Esperado: 'Asociacion entre puntos de venta y empleado dada de baja exitosamente. Filtrada por: Empleado' */
EXEC sucursal.BajaPuntoVentaEmpleadoPorEmpleado 1234


/*******************************************************************************
						SP: BajaPuntoVentaEmpleadoPorSucursal
*******************************************************************************/

/* Resultado Esperado: 'No hay puntos de ventas asociados en esa sucursal' */
EXEC sucursal.BajaPuntoVentaEmpleadoPorSucursal 999

/* Resultado Esperado: 'Asociacion entre puntos de venta y empleados dadas de baja exitosamente. Filtrada por: Sucursal' */
EXEC sucursal.AltaPuntoVentaEmpleado 1
EXEC sucursal.BajaPuntoVentaEmpleadoPorSucursal 1