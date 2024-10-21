# Cadena de supermercado
---
## Pre requisitos
- **Sistema operativo**: sistema operativo compatible. PostgreSQL funciona bien en la mayoría de distribuciones Linux, Windows, y macOS.
- **Permisos de administrador (root o sudo)**: Se necesitan permisos elevados para instalar y configurar PostgreSQL.
- **Conectividad a internet**: Necesaria para descargar paquetes si no tienes los archivos locales.

## Descarga e instalación según OS
### Linux
#### Ubuntu/Debian
```bash
sudo apt update && sudo apt upgrade // actualizar repo
sudo apt install postgresql postgresql-contrib // instalo
sudo systemctl status postgresql // verificar estado
```

#### RedHat/Fedora/CentOS
```bash
// agrego el repositorio
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(rpm -E %rhel)-x86_64/pgdg-redhat-repo-latest.noarch.rpm
// instalar
sudo yum install postgresql15-server postgresql15-contrib
//inicializar la db
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb
Inicio el servicio
sudo systemctl enable --now postgresql-15
```

### En Windows
#### Descarga del instalador

1. **Descargar PostgreSQL**: Ve al sitio oficial de PostgreSQL y descarga el instalador para Windows desde [https://www.postgresql.org/download/windows/](https://www.postgresql.org/download/windows/).
2. **Elegir la versión**: Elige la versión estable más reciente de PostgreSQL compatible con tu sistema operativo. Te sugiero documentar la versión descargada y el sistema operativo donde la instalarás.
#### 2. Instalación de PostgreSQL en Windows

1. **Ejecutar el instalador**: Una vez descargado, ejecuta el archivo `postgresql-x.x.x-windows.exe` (la versión dependerá de la que hayas descargado).
2. **Pasos de instalación**: 
    - **Elige la ubicación**: Selecciona la carpeta donde se instalará PostgreSQL (normalmente `C:\Program Files\PostgreSQL\x.x`).
    - **Selecciona los componentes**: Asegúrate de seleccionar los siguientes:
        - PostgreSQL Server
        - pgAdmin (herramienta gráfica de administración)
        - Stack Builder (opcional, pero útil para extensiones y herramientas adicionales)
3. **Contraseña del superusuario `postgres`**: Durante la instalación, se te pedirá que establezcas una contraseña para el usuario administrador `postgres`. Esta contraseña es crucial, ya que es el superusuario por defecto en PostgreSQL. Documenta esta contraseña de manera segura.
4. **Puerto por defecto**: El puerto estándar para PostgreSQL es el `5432`. Si no tienes conflictos con este puerto, déjalo tal cual.
5. **Tamaño del cluster de bases de datos**: PostgreSQL te pedirá seleccionar el tamaño del cluster de bases de datos. Déjalo en su configuración predeterminada (UTF8) a menos que tengas un requerimiento específico.
6. **Finalizar la instalación**: Completa la instalación y asegúrate de marcar la opción para iniciar `Stack Builder` si planeas agregar herramientas adicionales.
## 3. Configuración inicial post-instalación
### En Windows
1. **Acceder a pgAdmin**: pgAdmin es una herramienta gráfica para gestionar tu base de datos PostgreSQL. Iníciala desde el menú de inicio. Al abrir, te pedirá la contraseña de `postgres` que estableciste durante la instalación.
2. **Acceso mediante la línea de comandos**: Puedes abrir la línea de comandos de PostgreSQL (`SQL Shell` o `psql`) para ejecutar consultas y comandos SQL directamente. Esto es útil para verificar configuraciones o administrar la base de datos desde la terminal:
```bash
psql -U postgres
```
### En Linux
- **Configurar la autenticación**: La configuración de acceso se maneja a través del archivo `pg_hba.conf`. Para acceso local, asegúrate de que la línea para `local all all` esté configurada como:
```shell
local all all peer
```
> Esto permite a los usuarios autenticarse a través de métodos de autenticación de sistema.

- Cambiar la contraseña de usuario Postgres (predeterminado)

```shell
sudo -u postgres psql
\password postgres
```
## Habilitar el acceso remoto

Edita el archivo `postgresql.conf` para permitir que escuche en todas las interfaces:
```shell
sudo nano /etc/postgresql/15/main/postgresql.conf
listen_addresses = '*'
```

En el archivo `pg_hba.conf` agregar una línea para permitir el acceso remoto por IP o rangos de IP permitidos:
```shell
host all all 0.0.0.0/0 md
```

Para finalizar, reinicia el servicio: 
```shell
sudo systemctl restart postgresql
```

En el caso de Windows, esto es simplemente buscar PostgreSQL y reiniciar el servicio.
## Crear la base de datos
### En Windows
```sql
CREATE DATABASE supermercado;
CREATE USER nombre_usuario WITH PASSWORD 'contraseña';
GRANT ALL PRIVILEGES ON DATABASE supermercado TO nombre_usuario;
```
### En Linux

```shell
sudo -u postgres createdb supermercado
sudo -u postgres createuser --interactive
```

Luego, desde el Shell de Postgre (psql):
```sql
GRANT ALL PRIVILEGES ON DATABASE supermercado TO nombre_usuario;
```
## Optimización inicial
```plain text
shared_buffers = 256MB
max_parallel_workers_per_gather = 2
max_connections = 100
```
## Mantenimiento
```shell
pg_dump supermercado > backup.sql
```

