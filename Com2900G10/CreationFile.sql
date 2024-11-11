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

DROP DATABASE IF EXISTS Com2900G10;--Elimino la base de datos si existe.
CREATE DATABASE Com2900G10; --Creo la base de datos
GO

GO
USE Com2900G10;

--CREACION DE ESQUEMAS
DROP SCHEMA IF EXISTS producto;
GO
CREATE SCHEMA producto;
GO
DROP SCHEMA IF EXISTS sucursal;
GO
CREATE SCHEMA sucursal;
GO
DROP SCHEMA IF EXISTS venta;
GO
CREATE SCHEMA venta;
GO

---CREACION DE TABLAS
CREATE TABLE [Com2900G10].[sucursal].[sucursal] (
    id_sucursal     SMALLINT		IDENTITY(1,1) PRIMARY KEY,
    ciudad          VARCHAR(50)		NOT NULL,
    reemplazar_por  VARCHAR(50)		NOT NULL,
    direccion       VARCHAR (100)	NOT NULL,
    horario         VARCHAR (45)	NOT NULL,
    telefono        VARCHAR(15)		NOT NULL    
                    CHECK (telefono NOT LIKE '%[A-Za-z]%' AND telefono NOT LIKE '% %'),
    activo          BIT
);

CREATE TABLE [Com2900G10].[sucursal].[empleado] ( 
    legajo          INT         PRIMARY KEY,
    nombre          VARCHAR(60) NOT NULL,
    apellido        VARCHAR(60) NOT NULL,
    dni             INT		    NOT NULL,
    direccion       VARCHAR(100),
    email_personal  VARCHAR(60),
    email_empresa   VARCHAR(60),
    cuil            CHAR(13)     
                    CHECK ([cuil] like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]' OR cuil is null)
					NOT NULL,
    cargo           VARCHAR(30),
    id_sucursal     SMALLINT NOT NULL,
    turno           VARCHAR(20) 
					CHECK([turno] IN ('TM', 'TT', 'TN', 'Jornada completa')),
    activo          BIT,
    CONSTRAINT FK_Empleado_Sucursal 
        FOREIGN KEY (id_sucursal) 
        REFERENCES [Com2900G10].[sucursal].[sucursal](id_sucursal)
);

CREATE TABLE [Com2900G10].[sucursal].[punto_venta] (
	numero_punto_venta INT NOT NULL,
	id_sucursal SMALLINT NOT NULL,
	activo bit,
	CONSTRAINT FK_sucursal FOREIGN KEY (id_sucursal)
	REFERENCES [Com2900G10].[sucursal].[sucursal](id_sucursal),
	CONSTRAINT PK_punto_venta PRIMARY KEY (numero_punto_venta, id_sucursal)
);

CREATE TABLE [Com2900G10].[sucursal].[punto_venta_empleado] (
	id_punto_venta_empleado int identity(1,1) primary key,
	numero_punto_venta int NOT NULL,
	id_sucursal SMALLINT NOT NULL,
	legajo_empleado int NOT NULL,
	activo bit,
	CONSTRAINT FK_puesto_venta FOREIGN KEY (numero_punto_venta,id_sucursal)
	REFERENCES [Com2900G10].[sucursal].[punto_venta](numero_punto_venta,id_sucursal),
	CONSTRAINT FK_empleado FOREIGN KEY (legajo_empleado)
	REFERENCES [Com2900G10].[sucursal].[empleado](legajo)
);

CREATE TABLE [Com2900G10].[producto].[categoria_producto] (
    id_categoria_producto SMALLINT      IDENTITY(1,1) PRIMARY KEY,
	nombre_linea		  VARCHAR(100)	NOT NULL,
    nombre_categoria      VARCHAR(100)  NOT NULL
);

-- Reservo primer ID para categoria default en importaciones (Inserto en este momento para que no se pierda el ID al correr los tests
INSERT INTO [Com2900G10].[producto].[categoria_producto] VALUES ('Importaciones-Default', 'Importaciones-Default');

CREATE TABLE [Com2900G10].[producto].[producto] (
    id_producto           SMALLINT      IDENTITY(1,1) PRIMARY KEY,
    id_categoria_producto SMALLINT		NOT NULL,
    nombre_producto       VARCHAR(100)  NOT NULL,
    precio_unitario       DECIMAL(10,4) NOT NULL,
    moneda                CHAR(3)       
                          CHECK (moneda LIKE 'ARS' OR moneda LIKE 'USD'), -- Hay artículos en dólares
    CONSTRAINT FK_Categoria_Producto 
        FOREIGN KEY (id_categoria_producto)
        REFERENCES [Com2900G10].[producto].[categoria_producto](id_categoria_producto)
);

CREATE TABLE [Com2900G10].[venta].[medio_pago] (
    id_medio_pago SMALLINT      IDENTITY(1,1) PRIMARY KEY,
    nombre_eng    VARCHAR(200)   NOT NULL,
    nombre_esp    VARCHAR (200)  NOT NULL
);


CREATE TABLE [Com2900G10].[venta].[cliente] (
    id_cliente          INT         IDENTITY(1,1)   PRIMARY KEY,
	nombre          VARCHAR(60) NOT NULL,
    apellido        VARCHAR(60) NOT NULL,
    dni             INT		    NOT NULL,
	direccion       VARCHAR(100),
	cuil            CHAR(13)     
                    CHECK ([cuil] like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]' OR cuil is null)
					NOT NULL ,
);     

CREATE TABLE [Com2900G10].[venta].[factura] (
    id_factura          INT         IDENTITY(1,1)   PRIMARY KEY,
    id_medio_pago       SMALLINT NOT NULL,
    legajo_empleado     INT NOT NULL,
	id_cliente			INT NOT NULL,
    tipo_factura        CHAR(1) NOT NULL,
    tipo_cliente        VARCHAR(50) NOT NULL,
    fechaHora           DATETIME NOT NULL,
    id_sucursal         SMALLINT NOT NULL,
	total				DECIMAL(12,2) NOT NULL,
    CONSTRAINT FK_Medio_Pago
        FOREIGN KEY(id_medio_pago)
        REFERENCES [Com2900G10].[venta].[medio_pago](id_medio_pago),
    CONSTRAINT FK_Empleado_Factura
        FOREIGN KEY (legajo_empleado)
        REFERENCES [Com2900G10].[sucursal].[empleado](legajo),
    CONSTRAINT FK_Cliente_factura
        FOREIGN KEY (id_cliente)
        REFERENCES [Com2900G10].[venta].[cliente](id_cliente),
    CONSTRAINT FK_Sucursal_Factura
        FOREIGN KEY(id_sucursal)
        REFERENCES [Com2900G10].[sucursal].[sucursal](id_sucursal)
); 

CREATE TABLE [Com2900G10].[venta].[detalle_factura] (
    id_detalle_factura INT        IDENTITY(1,1)   PRIMARY KEY,
    id_producto        SMALLINT NOT NULL,
    id_factura         INT NOT NULL,
    cantidad           SMALLINT,
	subtotal		   DECIMAL(12,2),
    CONSTRAINT FK_Producto_Detalle
        FOREIGN KEY(id_producto)
        REFERENCES [Com2900G10].[producto].[producto](id_producto),
    CONSTRAINT FK_Factura
        FOREIGN KEY(id_factura)
        REFERENCES [Com2900G10].[venta].[factura](id_factura)
);
GO
