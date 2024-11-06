--Testeo Stored Procedures sucursal--

USE Com2900G10
GO

--Dar de baja una sucursal inexistente.
PRINT 'Intentar dar de baja una sucursal que no existe:'
EXEC BajaSucursal 1

--Insertar sucursal
EXEC CrearSucursal 'Haedo','Ramos Mejia','Calle Falsa 123','Tarde','1234-5678'
Select * from sucursal.sucursal

--Insertar sucursal ya insertada
EXEC CrearSucursal 'Haedo','Ramos Mejia','Calle Falsa 123','Tarde','1234-5678'

--Dar alta sucursal ya de alta o inexistente.
EXEC AltaSucursal 1
EXEC AltaSucursal 999

--Dar de baja sucursal.
EXEC BajaSucursal 1
select * from sucursal.sucursal

--Dar de baja sucursal inexistente o dada de baja previamente.
EXEC BajaSucursal 1
EXEC BajaSucursal 999

--Cambiar ubicacion de sucursal dada de baja o inexistente.
EXEC CambiarUbicacion 1, 'Ramos Mejia', 'Haedo', 'Calle False 456'
EXEC CambiarUbicacion 999, 'Ramos Mejia', 'Haedo', 'Calle False 456'

--Cambiar telefono de sucursal dada de baja o inexistente.
EXEC CambiarTelefono 1,'9089-7654'
EXEC CambiarTelefono 999,'9089-7654'

--Dar de alta la sucursal nuevamente
EXEC AltaSucursal 1

--Cambiar ubicacion sucursal
EXEC CambiarUbicacion 1, 'Ramos Mejia', 'Haedo', 'Calle False 456'

--Cambiar telefono sucursal
EXEC CambiarTelefono 1,'9089-7654'