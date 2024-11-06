GO
USE Com2900G10;
GO

--Crear categoria producto
EXEC CrearCategoriaProducto 'Electrodomestico','Televisor'
EXEC CrearCategoriaProducto 'Lacteo','Yogurt'
EXEC CrearCategoriaProducto 'Carne','Milanesa'

--Modificar categoria producto
EXEC ModificarCategoriaProducto 1,'Playstation 5'

--Modificar categoria producto inexistente
EXEC ModificarCategoriaProducto 999,'Playstation 5'

select * from producto.categoria_producto

--Crear producto con una categoria inexistente.
--Devuelve constraint.
EXEC CrearProducto 98,'Playstation 4',11000,'USD'

--Crear producto con moneda erronea / inexistente..
--Ambos devuelven constraint.
EXEC CrearProducto 1,'Nintendo Switch', 150000, 'Pesos Crocantes'
EXEC CrearProducto 1,'Nintendo Switch', 150000, 'DAS'

--Crear producto
EXEC CrearProducto 1, 'Nintendo Switch', 500, 'USD'
select * from producto.producto

--Modificar producto inexistente
EXEC ModificarProducto 999,1,'Pepe grillo',10,'ARS'

--Modificar Producto
-- ID producto = 7 porque se cago el identity por los constraints.
EXEC ModificarProducto 7,1,'Pepe grillo',10,'ARS'
select * from producto.producto



