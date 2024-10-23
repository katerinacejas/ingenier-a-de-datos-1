SELECT * 
FROM facturas_det

SELECT COUNT(*) as cantidadClientes
FROM clientes

SELECT cliente_num, nombre, apellido
FROM clientes
WHERE ciudad = 'Rosario'
ORDER BY 2

SELECT  cliente_num, 
		apellido, 
		nombre, 
		apellido + ', ' + nombre AS nombreCompleto
FROM clientes

SELECT cliente_num,
		nombre,
		apellido,
		ciudad,
		COALESCE(ciudad, 'Desconocida') ciudadesNulas
FROM clientes

SELECT producto_cod, 'constante' AS constante_columna
FROM productos

SELECT producto_cod,
	precio_unit,
	precio_unit*100 AS precio_calculado
FROM productos

SELECT TOP 3 *
FROM productos