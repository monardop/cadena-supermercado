DROP DATABASE IF EXISTS supermercado_aurora;--Elimino la base de datos si existe.
CREATE DATABASE supermercado_aurora; --Creo la base de datos
GO

GO
USE supermercado_aurora;

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
CREATE TABLE [supermercado_aurora].[sucursal].[sucursal] (
    id_sucursal     SMALLINT IDENTITY(1,1)    PRIMARY KEY,
    ciudad          VARCHAR(50)   NOT NULL,
    reemplazar_por  VARCHAR(50)   NOT NULL,
    direccion       VARCHAR (300) NOT NULL,
    horario         VARCHAR (45)  NOT NULL    
                    CHECK (horario LIKE '[L a V]''[0-12]''[a.m-p.m]''[-]''[0-12]''[a.m-p.m]''[\n]''[S y D]''[0-12]''[a.m-p.m]''[-]''[0-12]''[a.m-p.m]'),
    telefono        CHAR(9)       NOT NULL    
                    CHECK (telefono LIKE '[0-9]''[0-9]''[0-9]''[0-9]''[-]''[0-9]''[0-9]''[0-9]''[0-9]'),
    activo          BIT
);

CREATE TABLE [supermercado_aurora].[sucursal].[empleado] ( 
    legajo          INT             PRIMARY KEY,
    nombre          VARCHAR(60),
    apellido        VARCHAR(60),
    dni             INT             NOT NULL,
    direccion       VARCHAR(300),
    email_personal  VARCHAR(300),
    email_empresa   VARCHAR(300),
    cuil            VARCHAR(13)     
                    CHECK (cuil LIKE '[0-9]''[-]''[0-9]''[0-9]''[0-9]''[0-9]''[0-9]''[0-9]''[0-9]''[0-9]''[-]''[0-9]''[0-9]'),
    cargo           VARCHAR(30),
    id_sucursal     SMALLINT        NOT NULL,
    turno           VARCHAR(30),
    activo          BIT,
    CONSTRAINT FK_Empleado_Sucursal 
        FOREIGN KEY (id_sucursal) 
        REFERENCES [supermercado_aurora].[sucursal].[sucursal](id_sucursal)
);

CREATE TABLE [supermercado_aurora].[producto].[categoria_producto] (
    id_categoria_producto SMALLINT      IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria      VARCHAR(100)  NOT NULL
);

CREATE TABLE [supermercado_aurora].[producto].[producto] (
    id_producto           SMALLINT      IDENTITY(1,1) PRIMARY KEY,
    id_categoria_producto SMALLINT,
    nombre_producto       VARCHAR(100)  NOT NULL,
    precio_unitario       DECIMAL(10,4) NOT NULL,
    moneda                CHAR(3)       
                          CHECK (moneda LIKE '[ARS]' OR moneda LIKE '[USD]'), -- Hay artículos en dólares
    CONSTRAINT FK_Categoria_Producto 
        FOREIGN KEY (id_categoria_producto)
        REFERENCES [supermercado_aurora].[producto].[categoria_producto](id_categoria_producto)
);

CREATE TABLE [supermercado_aurora].[venta].[medio_pago] (
    id_medio_pago SMALLINT      IDENTITY(1,1) PRIMARY KEY,
    nombre_eng    VARCHAR(20)   NOT NULL,
    nombre_esp    VARCHAR (20)  NOT NULL
);


CREATE TABLE [supermercado_aurora].[venta].[factura] (
    id_factura          INT         IDENTITY(1,1)   PRIMARY KEY,
    id_medio_pago       SMALLINT,
    id_empleado         INT,
    tipo_factura        CHAR(1),
    tipo_cliente        VARCHAR(50),
    genero              VARCHAR(10),
    fechaHora           DATETIME,
    id_sucursal         SMALLINT,
    CONSTRAINT FK_Medio_Pago
        FOREIGN KEY(id_medio_pago)
        REFERENCES [supermercado_aurora].[venta].[medio_pago](id_medio_pago),
    CONSTRAINT FK_Empleado_Factura
        FOREIGN KEY (id_empleado)
        REFERENCES [supermercado_aurora].[sucursal].[empleado](legajo),
    CONSTRAINT FK_Sucursal_Factura
        FOREIGN KEY(id_sucursal)
        REFERENCES [supermercado_aurora].[sucursal].[sucursal](id_sucursal)
);     

CREATE TABLE [supermercado_aurora].[venta].[detalle_factura] (
    id_detalle_factura INT        IDENTITY(1,1)   PRIMARY KEY,
    id_producto        SMALLINT,
    id_factura         INT,
    cantidad           SMALLINT
    CONSTRAINT FK_Producto_Detalle
        FOREIGN KEY(id_producto)
        REFERENCES [supermercado_aurora].[producto].[producto](id_producto),
    CONSTRAINT FK_Factura
        FOREIGN KEY(id_factura)
        REFERENCES [supermercado_aurora].[venta].[factura](id_factura)
);

GO
