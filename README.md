# Proyecto: Gestión de Supermercados 
# Índice
1. [Introducción](https://github.com/monardop/cadena-supermercado/#introducci%C3%B3n)
2. [Detalles de la instalación](https://github.com/monardop/cadena-supermercado/#detalles-de-la-instalaci%C3%B3n)
3. [Especificaciones de Sistema Operativo](https://github.com/monardop/cadena-supermercado/#especificaciones-de-sistema-operativo)
4. [Backups](https://github.com/monardop/cadena-supermercado/#backups)
5. [Estructura de la base de datos](https://github.com/monardop/cadena-supermercado/#estructura-de-la-base-de-datos)
## Informe
### Introducción

Este documento tiene como objetivo proporcionar una guía técnica detallada para la instalación y configuración de la base de datos **Com2900G10**, utilizada en el sistema de gestión de supermercados. Esta base de datos almacenará y administrará información crítica sobre ventas, productos, clientes, y otras entidades relacionadas con las operaciones del supermercado.

- **Objetivo**: Generar un sistema de bases de datos que registre las ventas realizadas en cada sucursal.
- **Límite**: Desde que se realizas la inserción del catálogo de productos hasta que se registra la venta.

#### Motor de base de datos
En este sistema se utilizará **Microsoft SQL Server 2022**, en su versión **Express 20.2**, con número de compilación **20.2.30.0**
### Detalles de la Instalación 
#### Configuraciones generales
- **Memoria total asignada:** 10GB
- **Procesadores asignados:** 2
- **Directorio raiz:** *C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL*
- **Server collation:** *SQL_Latin1_General_CP1_CI_AS*
- **Default index fill factor:** 0
- **Numero maximo de conexiones concurrentes:** Ilimitado *(Valor explicito: 0)*

#### Ubicación de los archivos
- **Datos:** *C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Com2900G10.mdf*
- **Logs:** *C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Com2900G10_log.ldf*
- **Backup:** *C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup*

#### Asignación de memoria.
- **Memoria minima del servidor:** 100 MB 
- **Memoria maxima del servidor:** 3GB
- **Memoria para creacion de indices:** Modo dinamico *(Valor explicito: 0)*
- **Memoria minima por query:** 1MB

#### Puertos 
SQL Server utiliza el **puerto 1433** por defecto para conexiones TCP/IP. 
#### Modo de autenticación
Se utilizó el modo **Autenticación de Windows**.

### Especificaciones de Sistema Operativo
- **Version:** Windows 11 Pro x64 (Build: 22631.4317)
- **Procesador:** Intel Core i7
- **Memoria:** 10GB

### Detalles extra
#### OLE DB
Para poder importar archivos .xlsx se instaló **Microsoft OLE DB Driver for SQL Server** desde el sitio oficial de Microsoft. Tras la instalación, se le otorgaron permisos de lectura a la cuenta de servicio de SQL en la carpeta donde se encuentran los archivos (`./DataFiles`).
Por último, se habilitó la opción `Ad Hoc Distributed Queries` ejecutando comandos que permite el acceso directo a archivos externos.

### Backups
Para las copias de seguridad / backup se estableció una política de ejecuciones periódicas según el siguiente esquema:

![](https://github.com/user-attachments/assets/b3cc13a3-7f92-4db4-a68d-f3a7a0a7ee06)

Que consiste en copias **INCREMENTALES** de los logs Transaccionales que se ejecutan cada hora, luego una ejecución diaria (preferentemente en horarios nocturnos o de desuso) de copias **DIFERENCIALES** y una ejecución semanal de copias del tipo FULL.
Esto nos permite mantener una base de datos integra ante escenarios de error, maximizando la performance del sistema a la hora de ejecutar las copias.

## Estructura de la base de datos.
![](https://github.com/monardop/cadena-supermercado/blob/main/DER.jpg)
