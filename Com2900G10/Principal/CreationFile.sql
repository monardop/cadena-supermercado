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
USE master
GO

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
DROP SCHEMA IF EXISTS configuracion;
GO
CREATE SCHEMA configuracion;
GO

---CREACION DE TABLAS
DROP TABLE IF EXISTS [Com2900G10].[sucursal].[sucursal]
GO
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
GO
--Elimino contraints para despues poder eliminar las tablas.
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE ='BASE TABLE' AND TABLE_NAME = '[Com2900G10].[sucursal].[empleado]')
BEGIN

	ALTER TABLE [Com2900G10].[sucursal].[empleado] 
	DROP CONSTRAINT FK_Empleado_Sucursal;

	DROP TABLE [Com2900G10].[sucursal].[empleado]
END
GO
CREATE TABLE [Com2900G10].[sucursal].[empleado] ( 
    legajo          INT         PRIMARY KEY,
    nombre          VARCHAR(60) NOT NULL,
    apellido        VARCHAR(60) NOT NULL,
    dni             INT		    NOT NULL,
    direccion       VARCHAR(100),
    email_personal  VARCHAR(60),
    email_empresa   VARCHAR(60),
    cuil            CHAR(13) NOT NULL,
    cargo           VARCHAR(30),
    id_sucursal     SMALLINT NOT NULL,
    turno           VARCHAR(20) 
					CHECK([turno] IN ('TM', 'TT', 'TN', 'Jornada completa')),
    activo          BIT,
	encriptado bit default 0 not null,
    CONSTRAINT FK_Empleado_Sucursal 
        FOREIGN KEY (id_sucursal) 
        REFERENCES [Com2900G10].[sucursal].[sucursal](id_sucursal)
);
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE ='BASE TABLE' AND TABLE_NAME = '[Com2900G10].[sucursal].[punto_venta_empleado]')
BEGIN

	ALTER TABLE [Com2900G10].[sucursal].[punto_venta_empleado] 
	DROP CONSTRAINT FK_empleado;

	DROP TABLE [Com2900G10].[sucursal].[punto_venta_empleado]
END
GO
CREATE TABLE [Com2900G10].[sucursal].[punto_venta_empleado] (
	id_punto_venta_empleado INT         IDENTITY(1,1) PRIMARY KEY,
	numero_punto_venta      TINYINT         NOT NULL,
	id_sucursal             SMALLINT    NOT NULL,
	legajo_empleado         INT         NOT NULL,
	activo bit,
	CONSTRAINT FK_empleado 
        FOREIGN KEY (legajo_empleado)
	    REFERENCES [Com2900G10].[sucursal].[empleado](legajo)
);
DROP TABLE IF EXISTS [Com2900G10].[producto].[categoria_producto]
GO
CREATE TABLE [Com2900G10].[producto].[categoria_producto] (
    id_categoria_producto SMALLINT      IDENTITY(1,1) PRIMARY KEY,
	nombre_linea		  VARCHAR(100)	NOT NULL,
    nombre_categoria      VARCHAR(100)  NOT NULL
);

-- Reservo primer ID para categoria default en importaciones (Inserto en este momento para que no se pierda el ID al correr los tests
INSERT INTO [Com2900G10].[producto].[categoria_producto] 
    VALUES ('Importaciones-Default', 'Importaciones-Default');

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE ='BASE TABLE' AND TABLE_NAME = '[Com2900G10].[producto].[producto]')
BEGIN

	ALTER TABLE [Com2900G10].[producto].[producto]
	DROP CONSTRAINT FK_Categoria_Producto;

	DROP TABLE [Com2900G10].[producto].[producto]
END
GO
CREATE TABLE [Com2900G10].[producto].[producto] (
    id_producto           SMALLINT      IDENTITY(1,1) PRIMARY KEY,
    id_categoria_producto SMALLINT		NOT NULL,
    nombre_producto       VARCHAR(100)  NOT NULL,
    precio_unitario       DECIMAL(10,4) NOT NULL
    CONSTRAINT FK_Categoria_Producto 
        FOREIGN KEY (id_categoria_producto)
        REFERENCES [Com2900G10].[producto].[categoria_producto](id_categoria_producto)
);

DROP TABLE IF EXISTS [Com2900G10].[venta].[medio_pago]
GO
CREATE TABLE [Com2900G10].[venta].[medio_pago] (
    id_medio_pago SMALLINT       IDENTITY(1,1) PRIMARY KEY,
    nombre_eng    VARCHAR(200)   NOT NULL,
    nombre_esp    VARCHAR (200)  NOT NULL
);

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE ='BASE TABLE' AND TABLE_NAME = '[Com2900G10].[venta].[pago]')
BEGIN

	ALTER TABLE [Com2900G10].[venta].[pago]
	DROP CONSTRAINT FK_id_medio_pago_pago;

	DROP TABLE [Com2900G10].[venta].[pago]
END
GO
CREATE TABLE [Com2900G10].[venta].[pago] (
    id_pago INT       IDENTITY(1,1) PRIMARY KEY,
	id_medio_pago    SMALLINT  NOT NULL,
    identificador    VARCHAR(200)   NOT NULL,
	CONSTRAINT FK_id_medio_pago_pago 
		FOREIGN KEY(id_medio_pago) 
		REFERENCES [Com2900G10].[venta].[medio_pago](id_medio_pago)
);

DROP TABLE IF EXISTS [Com2900G10].[venta].[cliente]
CREATE TABLE [Com2900G10].[venta].[cliente] (
    id_cliente      INT         IDENTITY(1,1)   PRIMARY KEY,
	nombre          VARCHAR(60) NOT NULL,
    apellido        VARCHAR(60) NOT NULL,
    dni             INT		    NOT NULL,
	direccion       VARCHAR(100),
	cuil            CHAR(13)     
                    CHECK ([cuil] like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]' OR cuil is null)
					NOT NULL ,
);     

-- Reservo primer ID para cliente default en importaciones (Inserto en este momento para que no se pierda el ID al correr los tests
INSERT INTO [Com2900G10].[venta].[cliente] 
VALUES ('Importaciones-Default', 'Importaciones-Default', 00000000, '', '00-00000000-0');

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE ='BASE TABLE' AND TABLE_NAME = '[Com2900G10].[venta].[factura]')
BEGIN

	ALTER TABLE [Com2900G10].[venta].[factura]
	DROP CONSTRAINT FK_Pago_Factura;

	ALTER TABLE [Com2900G10].[venta].[factura]
	DROP CONSTRAINT FK_Cliente_factura;

	DROP TABLE [Com2900G10].[venta].[factura]
END
GO
CREATE TABLE [Com2900G10].[venta].[factura] (
    id_factura          INT             IDENTITY(1,1)   PRIMARY KEY,
	id_pago				INT             ,
	id_cliente			INT             NOT NULL,
	cuit_emisor			CHAR(13) NOT NULL,
	numero_factura      VARCHAR(11)     NOT NULL        UNIQUE,
    tipo_factura        CHAR(1)         NOT NULL CHECK(tipo_factura IN('A','B','C')),
    fecha_hora           DATETIME        NOT NULL,
	total_con_iva				DECIMAL(12,2)   NOT NULL,
	CONSTRAINT FK_Pago_Factura 
		FOREIGN KEY(id_pago)
		REFERENCES [Com2900G10].[venta].[pago](id_pago),
    CONSTRAINT FK_Cliente_factura
        FOREIGN KEY (id_cliente)
        REFERENCES [Com2900G10].[venta].[cliente](id_cliente),
); 
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE ='BASE TABLE' AND TABLE_NAME = '[Com2900G10].[venta].[detalle_factura]')
BEGIN

	ALTER TABLE [Com2900G10].[venta].[detalle_factura]
	DROP CONSTRAINT FK_Factura;

	ALTER TABLE [Com2900G10].[venta].[detalle_factura]
	DROP CONSTRAINT FK_Producto_Detalle;

	DROP TABLE [Com2900G10].[venta].[detalle_factura]
END
GO
CREATE TABLE [Com2900G10].[venta].[detalle_factura] (
    id_detalle_factura INT          IDENTITY(1,1)   PRIMARY KEY,
	id_factura         INT          NOT NULL,
    id_producto        SMALLINT     NOT NULL,
    cantidad           SMALLINT,
	precio_unitario		   DECIMAL(12,2),
	CONSTRAINT FK_Factura
        FOREIGN KEY(id_factura)
        REFERENCES [Com2900G10].[venta].[factura](id_factura),
    CONSTRAINT FK_Producto_Detalle
        FOREIGN KEY(id_producto)
        REFERENCES [Com2900G10].[producto].[producto](id_producto)
);
GO
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE ='BASE TABLE' AND TABLE_NAME = '[Com2900G10].[venta].[venta]')
BEGIN

	ALTER TABLE [Com2900G10].[venta].[venta]
	DROP CONSTRAINT FK_Factura_Venta;

	ALTER TABLE [Com2900G10].[venta].[venta]
	DROP CONSTRAINT FK_Empleado_Venta;

	ALTER TABLE [Com2900G10].[venta].[venta]
	DROP CONSTRAINT FK_Sucursal_Venta;

	ALTER TABLE [Com2900G10].[venta].[venta]
	DROP CONSTRAINT FK_Punto_Venta_Empleado;

	DROP TABLE [Com2900G10].[venta].[venta]
END
GO
CREATE TABLE [Com2900G10].[venta].[venta] (
    id_venta INT             IDENTITY(1,1)   PRIMARY KEY,
	id_factura INT,
	legajo_empleado     INT             NOT NULL,
	id_sucursal         SMALLINT        NOT NULL,
	id_punto_venta_empleado INT NOT NULL,
	total				DECIMAL(12,2)   NOT NULL,
	fecha_hora DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_Factura_Venta
        FOREIGN KEY(id_factura)
        REFERENCES [Com2900G10].[venta].[factura](id_factura),
	CONSTRAINT FK_Empleado_Venta
        FOREIGN KEY (legajo_empleado)
        REFERENCES [Com2900G10].[sucursal].[empleado](legajo),
    CONSTRAINT FK_Sucursal_Venta
        FOREIGN KEY(id_sucursal)
        REFERENCES [Com2900G10].[sucursal].[sucursal](id_sucursal),
	CONSTRAINT FK_Punto_Venta_Empleado
        FOREIGN KEY(id_punto_venta_empleado)
        REFERENCES [Com2900G10].[sucursal].[punto_venta_empleado](id_punto_venta_empleado),	
);

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE ='BASE TABLE' AND TABLE_NAME = '[Com2900G10].[venta].[detalle_venta]')
BEGIN

	ALTER TABLE [Com2900G10].[venta].[detalle_venta]
	DROP CONSTRAINT FK_Producto_Detalle_Venta;

	ALTER TABLE [Com2900G10].[venta].[detalle_venta]
	DROP CONSTRAINT FK_Venta;

	DROP TABLE [Com2900G10].[venta].[detalle_venta]
END
GO
CREATE TABLE [Com2900G10].[venta].[detalle_venta] (
    id_detalle_venta INT          IDENTITY(1,1)   PRIMARY KEY,
	id_venta         INT          NOT NULL,
    id_producto        SMALLINT     NOT NULL,
    cantidad           SMALLINT,
	precio_unitario DECIMAL (12,2),
    CONSTRAINT FK_Producto_Detalle_Venta
        FOREIGN KEY(id_producto)
        REFERENCES [Com2900G10].[producto].[producto](id_producto),
    CONSTRAINT FK_Venta
        FOREIGN KEY(id_venta)
        REFERENCES [Com2900G10].[venta].venta(id_venta)
);
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE ='BASE TABLE' AND TABLE_NAME = '[Com2900G10].[venta].[nota_credito]')
BEGIN

	ALTER TABLE [Com2900G10].[venta].[nota_credito]
	DROP CONSTRAINT FK_Factura_NC;

	DROP TABLE [Com2900G10].[venta].[nota_credito]
END
GO
CREATE TABLE [Com2900G10].[venta].[nota_credito] (
    id_nota_credito      INT         IDENTITY(1,1)   PRIMARY KEY,
	numero_nota_credito      VARCHAR(11)     NOT NULL        UNIQUE,
    id_factura INT NOT NULL, 
	importe		   DECIMAL(12,2) NOT NULL,
	CONSTRAINT FK_Factura_NC
        FOREIGN KEY(id_factura)
        REFERENCES [Com2900G10].[venta].[factura](id_factura)
);

DROP TABLE IF EXISTS [Com2900G10].[configuracion].[parametros_generales]
GO
CREATE TABLE [Com2900G10].[configuracion].[parametros_generales] (
	id_configuracion_supermercado INT IDENTITY(1,1) PRIMARY KEY,
	descripcion varchar(70),
	valor varchar(300)
);
GO

CREATE OR ALTER FUNCTION [configuracion].[obtener_clave_porcentaje_iva]()
RETURNS VARCHAR(30)
AS 
BEGIN
	RETURN 'porcentaje_iva'
END;
GO

CREATE OR ALTER FUNCTION [configuracion].[obtener_clave_cuit_emisor]()
RETURNS VARCHAR(30)
AS 
BEGIN
	RETURN 'cuit_emisor'
END;
GO

CREATE OR ALTER FUNCTION [configuracion].[obtener_clave_valor_dolar]()
RETURNS VARCHAR(30)
AS 
BEGIN
	RETURN 'valor_dolar'
END;
GO

CREATE OR ALTER FUNCTION [configuracion].[obtener_password_encriptacion]()
RETURNS VARCHAR(30)
AS 
BEGIN
	RETURN 'clave123'
END;
GO

INSERT INTO [Com2900G10].[configuracion].[parametros_generales](descripcion,valor)
VALUES
(configuracion.obtener_clave_porcentaje_iva(), '21'),
(configuracion.obtener_clave_valor_dolar(), '1080'),
(configuracion.obtener_clave_cuit_emisor(), '20-42938121-7');
GO

