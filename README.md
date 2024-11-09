# Proyecto: Gestión de Supermercados 
## Informe
### Introducción

Este documento tiene como objetivo proporcionar una guía técnica detallada para la instalación y configuración de la base de datos **Com2900G10**, utilizada en el sistema de gestión de supermercados. Esta base de datos almacenará y administrará información crítica sobre ventas, productos, clientes, y otras entidades relacionadas con las operaciones del supermercado.

- **Objetivo**: Generar un sistema de bases de datos que registre las ventas realizadas en cada sucursal.
- **Límite**: Desde que se realizas la inserción del catálogo de productos hasta que se registra la venta.
#### SGBD
En este sistema se utilizará Microsoft SQL Server 2022, en su versión Express 20.2, con número de compilación 20.2.30.0
### Detalles de la Instalación 
#### Ubicación de los archivos
- C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Com2900G10.mdf
- C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Com2900G10_log.ldf
#### Asignación de memoria.
SQL Server Express tiene un límite de uso de memoria de 1.4GB.
#### Puertos 
SQL Server utiliza el puerto 1433 por defecto para conexiones TCP/IP. 
#### Modo de autenticación
Se utilizó el modo **Autenticación de Windows**.
### Detalles extra
#### OLE DB
Para poder importar archivos .xlsx se instaló **Microsoft OLE DB Driver for SQL Server** desde el sitio oficial de Microsoft. Tras la instalación, se le otorgaron permisos de lectura a la cuenta de servicio de SQL en la carpeta donde se encuentran los archivos (`./DataFiles`).
Por último, se habilitó la opción `Ad Hoc Distributed Queries` ejecutando comandos que permite el acceso directo a archivos externos.

### Backups

---

## Estructura de la base de datos.
![](https://github.com/monardop/cadena-supermercado/blob/main/DER.jpg)
