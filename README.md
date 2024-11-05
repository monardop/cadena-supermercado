# Informe de Instalación y Configuración de SQL Server para el Proyecto de Gestión de Supermercados

## 1. Introducción

Este documento tiene como objetivo proporcionar una guía técnica detallada para la instalación y configuración de la base de datos **SupermarketDB**, utilizada en el sistema de gestión de supermercados. Esta base de datos almacenará y administrará información crítica sobre ventas, productos, clientes, y otras entidades relacionadas con las operaciones de un supermercado.

### Alcance del Sistema

La base de datos está diseñada para gestionar de manera eficiente las transacciones de ventas, el inventario de productos, y la información sobre clientes y empleados. Los datos están organizados en varias tablas relacionales, previamente especificadas en el DER, optimizadas para consultas frecuentes y actualizaciones concurrentes.

---

## 2. Requisitos Previos

Antes de proceder con la instalación, asegúrese de que el sistema donde se instalará SQL Server cumple con los siguientes requisitos:

- **Sistema Operativo:** Windows Server 2016 o superior, o cualquier sistema compatible con SQL Server.
- **Memoria RAM:** Mínimo de 4 GB (8 GB o más recomendado para entornos de producción).
- **Espacio en Disco:** Al menos 10 GB libres para la instalación de SQL Server y el almacenamiento de la base de datos.
- **Permisos Administrativos:** Permisos de administrador para instalar y configurar SQL Server.

### Software Necesario

- **Microsoft SQL Server 2019** o superior.
- **SQL Server Management Studio (SSMS)** para la administración de la base de datos.

---

## 3. Instalación de SQL Server

1. **Descargue el instalador de SQL Server** desde el [sitio oficial de Microsoft](https://www.microsoft.com/en-us/sql-server/sql-server-downloads).
2. **Ejecute el instalador** y seleccione "Nueva instalación independiente de SQL Server o agregar características a una instalación existente".
3. **Configuración Básica:**
    - Elija una **Instancia con Nombre**. Se recomienda nombrar la instancia como `SUPERMARKET_INSTANCE` para facilitar su identificación.
    - Seleccione el **Modo de Autenticación Mixta** y configure una contraseña segura para el usuario `sa` (Administrador de SQL Server).
4. **Configuración de Características:**
    - Asegúrese de instalar las siguientes características:
        - Motor de Base de Datos
        - Servicios de SQL Server Agent (para automatizar tareas)
        - SQL Server Management Tools (opcional, pero recomendado)
5. **Finalice la instalación** y verifique que el servicio de SQL Server esté ejecutándose en el Administrador de Servicios.

---

## 4. Configuración de la Base de Datos `SupermarketDB`

### Creación de la Base de Datos

1. Abra **SQL Server Management Studio** y conéctese a la instancia `SUPERMARKET_INSTANCE`.
2. Ejecute el siguiente script para crear la base de datos:
```sql
CREATE DATABASE Com2900G10; GO
```
3. **Configurar las Propiedades de la Base de Datos**:
- Defina el tamaño inicial y el crecimiento automático para los archivos de datos y de log:
```sql
ALTER DATABASE Com2900G10 MODIFY FILE (NAME = 'Com2900G10', SIZE = 50MB, FILEGROWTH = 10MB);  ALTER DATABASE Com2900G10 MODIFY FILE (NAME = 'Com2900G10_log', SIZE = 10MB, FILEGROWTH = 5MB);
```        

---

## 5. Configuración de Usuarios y Roles de Seguridad

Es recomendable seguir las mejores prácticas de seguridad al definir usuarios y permisos:
1. **Creación de Usuario para la Aplicación**:
	- Cree un usuario con permisos limitados para la aplicación de gestión de supermercados.
```sql
USE SupermarketDB; 
CREATE LOGIN supermarketUser WITH PASSWORD = 'StrongPassword123!'; 
CREATE USER supermarketUser FOR LOGIN supermarketUser;
```
2. **Asignación de Roles y Permisos**:
- Otorgue permisos de solo lectura para usuarios que solo necesiten consultar los datos y permisos completos para los administradores de la base de datos.
``` sql
-- Permisos de solo lectura 
GRANT SELECT ON SCHEMA::dbo TO supermarketUser;  
-- Permisos de escritura para un usuario administrativo 
CREATE LOGIN adminUser WITH PASSWORD = 'AdminPassword123!'; 
CREATE USER adminUser FOR LOGIN adminUser; 
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO adminUser;
```
---

## 6. Importación de Datos Iniciales
Una vez creada la estructura de la base de datos, se pueden cargar los datos iniciales:
1. **Ejecute Scripts de Población de Datos**:
      - Cree scripts para insertar datos en las tablas clave, como `Productos`, `Clientes`, `Ventas`, y `Empleados`.
    
```sql

USE SupermarketDB;  
-- Ejemplo de inserción en la tabla Productos 
INSERT INTO Productos (Nombre, Precio, Cantidad, Categoria) VALUES ('Manzanas', 1.50, 100, 'Frutas');`

```
2. **Validación de Datos**:
    - Asegúrese de que todas las tablas contienen los datos iniciales necesarios para el correcto funcionamiento de la aplicación.

---

## 7. Configuración de Respaldo y Recuperación

Para garantizar la continuidad de las operaciones, configure el respaldo de la base de datos:
1. **Planificación de Respaldo Completo Diario**:
    - Configure un respaldo completo de la base de datos `SupermarketDB` de manera diaria utilizando SQL Server Agent.
```sql
BACKUP DATABASE SupermarketDB TO DISK = 'C:\Backups\SupermarketDB_Full.bak' WITH FORMAT, MEDIANAME = 'SQLServerBackups';
```
    
2. **Respaldo de Logs de Transacciones**:
    - Si se requiere un plan de respaldo más detallado, configure respaldos de logs de transacciones cada hora.
3. **Restauración de la Base de Datos**:
    - Documente el proceso de restauración, incluyendo los pasos para restaurar tanto los respaldos completos como los de logs de transacciones.

---

## 8. Mantenimiento de la Base de Datos

1. **Índices**:
- Programe una tarea para reconstruir índices semanalmente para mejorar el rendimiento de las consultas.
```sql
ALTER INDEX ALL ON Productos REBUILD;
```
2. **Estadísticas**:
	- Actualice las estadísticas regularmente para mantener la precisión del optimizador de consultas.

---

## 9. Conexión de la Aplicación

Proporcione la cadena de conexión necesaria para que la aplicación acceda a `SupermarketDB`. Asegúrese de utilizar el nombre de usuario y la contraseña de `supermarketUser`.

**Ejemplo de Cadena de Conexión**:
`Server=SUPERMARKET_INSTANCE;Database=SupermarketDB;User Id=supermarketUser;Password=StrongPassword123!;`

---

## 10. Estructura de la base de datos.
![](https://github.com/monardop/cadena-supermercado/blob/main/DER.jpg)

