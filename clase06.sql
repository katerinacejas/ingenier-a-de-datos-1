/* Ejercicio 1
Contar la cantidad de facturas (o filas si fuera lo mismo) existentes. */

select count(*) as cantidad_facturas
from facturas

/* Ejercicio 2
Mostrar todas las facturas con todos sus atributos. */

select * from facturas

/* Ejercicio 3
Mostrar el n�mero, nombre y apellido de los clientes de la provincia de �BA�. */

select cliente_num, nombre, apellido
from clientes
where provincia_cod = 'BA'

/* Ejercicio 4
Mostrar el n�mero, nombre y apellido de los clientes de �BA� que no tengan referentes. */

select cliente_num, nombre, apellido
from clientes
where provincia_cod = 'BA' and cliente_ref is null

/* Ejercicio 5
Mostrar los fabricantes cuyo tiempo de entrega sea entre 1 y 5 d�as. */

select * 
from fabricantes 
where tiempo_entrega between 1 and 5

/* Ejercicio 6
Mostrar n�mero de factura, n�mero cliente y fecha de pago cuya fecha de pago este entre el primero de enero del 2021 y el 28 de febrero del 2021 ordenado por fecha de pago */

-- esta forma deja de lado los que son del 28 de febrero pasadas las 00, porque fecha_pago es un timestamp
select factura_num, cliente_num, fecha_pago
from facturas
where fecha_pago between '2021-01-01' and '2021-02-28'
order by fecha_pago

-- esta forma si funciona
select factura_num, cliente_num, fecha_pago
from facturas
where fecha_pago >= '2021-01-01' and fecha_pago < '2021-03-01'
order by fecha_pago

/* Ejercicio 7
Seleccionar todos los atributos de los productos fabricados por el fabricante �CASA� y mostrar en otra columna el precio con un incremento del 20%. */

select producto_cod, producto_desc, precio_unit, precio_unit*1.2 as precio_incrementado
from productos
where fabricante_cod = 'CASA'

/* Ejercicio 8
Mostrar todas las columnas de las �ltimas tres facturas pagadas. */

select top 3 *
from facturas
where fecha_pago is not null --ESTO NO ERA NECESARIO
order by fecha_pago desc

/* Ejercicio 9
Mostrar el fabricante con menor tiempo de entrega. */

select top 1 *
from fabricantes
order by tiempo_entrega asc

/* Ejercicio 10
Mostrar el fabricante con menor tiempo de entrega no nulo. */

select top 1 *
from fabricantes
where tiempo_entrega is not null
order by tiempo_entrega asc

/* Ejercicio 11
Mostrar del 4to al 8vo n�mero de cliente, nombre y apellido del cliente concatenados y empresa ordenados por n�mero de cliente. */

select cliente_num, nombre + ' ' + apellido as nombre_y_apellido, empresa
from clientes
order by cliente_num asc
offset 3 rows fetch next 5 rows only --REVISAR

/* Ejercicio 12
Contar la cantidad de clientes sin tel�fono. */

select count(*) as cant_clientes_sin_tel
from clientes
where telefono is null

/* Ejercicio 13
Contar la cantidad de provincias en que existen fabricantes. */

select count(distinct provincia_cod) as cant_prov_con_fabricantes
from fabricantes
where provincia_cod is not null

/* Ejercicio 14
Seleccionar los distintos clientes que tienen facturas */

select distinct cliente_num
from facturas
where cliente_num is not null

/* Ejercicio 15
Seleccionar los clientes que sean de �SA� o de �JU�. */

select *
from clientes
where provincia_cod = 'SA' or provincia_cod = 'JU'

/* Ejercicio 16
Seleccionar los clientes que sean de �SA� o de �JU�, cuyo estado sea �I�. */

select *
from clientes
where (provincia_cod = 'SA' or provincia_cod = 'JU') and estado = 'I'

/* Ejercicio 17
Seleccionar los fabricantes que tengan una �E� en el c�digo y su tiempo de entrega sea mayor a 5 d�as. */

select * 
from fabricantes
where fabricante_cod like '%E%' and tiempo_entrega > 5

/* Ejercicio 18
Seleccionar los fabricantes que contengan como segundo car�cter del nombre las letras e, f, g, h, i o j. */

select *
from fabricantes
where fabricante_nom like '_[e-f-g-h-i-j]%'

/* Ejercicio 19
Listar el n�mero de factura, l�nea_num, precio total (p x q) de todo lo facturado ordenado por n�mero de factura y rengl�n. */

select factura_num, renglon, cantidad * precio_unit as precio_total
from facturas_det
order by factura_num, renglon

/* Ejercicio 20
Obtener la cantidad total de facturas. Tambi�n la fecha de emisi�n de la primera y la �ltima. */

select count(*) as cantidad, min(fecha_emision) as minima_fecha, max(fecha_emision) as maxima_fecha
from facturas

/* Ejercicio 21
Obtener el n�mero de factura y el monto total por factura */

select factura_num, sum(cantidad * precio_unit) as monto_total
from facturas_det
group by factura_num

/* Ejercicio 22
Mostrar la cantidad total de Clientes por Provincia */

select count(*) as cant_cliente, provincia_cod
from clientes
group by provincia_cod

/* Ejercicio 23
Obtener el monto total promedio de facturaci�n. */

select sum(cantidad * precio_unit) / count(distinct factura_num) as promedio_total
from facturas_det

/* Ejercicio 24
Seleccionar la cantidad de facturas por cliente para aquellos n�meros de clientes mayores a 108. */

select count(*) as cantidad_facturas, cliente_num
from facturas
where cliente_num > 108 -- TAMBIEN PUEDE IR EN EL having
group by cliente_num

/* Ejercicio 25
Seleccionar la cantidad de facturas por cliente para aquellos n�meros de clientes mayores a 104 que tengan 2 facturas o mas. */

select count(*) as cantidad_facturas, cliente_num
from facturas
where cliente_num > 104 
group by cliente_num
having count(factura_num) >= 2

/* Ejercicio 26
Seleccionar nombre, apellido y tel�fono de los clientes. Si �l cliente no tiene tel�fono mostrar el mensaje SIN TELEFONO. */

select nombre, apellido, coalesce(telefono, 'Sin telefono') as telefono
from clientes

/* Ejercicio 27
Seleccionar nombre, apellido y domicilio de los clientes. Si el cliente no tiene domicilio, mostrar el tel�fono y si no tiene ninguno de los dos mostrar el mensaje SIN DATOS. */

select nombre, apellido, coalesce(domicilio, telefono, 'Sin datos')
from clientes

/* Ejercicio 28
Seleccionar el c�digo y nombre del fabricante y el mensaje LENTO, NORMAL o R�PIDO dependiendo si su tiempo de entrega es menor a 5, igual a 5 o mayor a 5. */

select fabricante_cod, fabricante_nom,
       case 
	        when tiempo_entrega < 5 then 'Rapido'
			when tiempo_entrega = 5 then 'Normal'
			when tiempo_entrega > 5 then 'Lento'
			else 'No se sabe'
	   end as velocidad
from fabricantes

/* Ejercicio 29
Mostrar el n�mero de factura y el promedio facturado por rengl�n (p x q) de cada factura, ordenado por el promedio en forma descendente. */

select factura_num, AVG(cantidad * precio_unit) as promedio
from facturas_det
group by factura_num
order by promedio desc

/* Ejercicio 30
Seleccionar n�mero de cliente, c�digo de fabricante y monto total comprado por cada par cliente-fabricante. Mostrar la informaci�n ordenada por cliente en forma ascendente y total comprado en forma descendente */

select fact.cliente_num, SUM(det.cantidad * det.precio_unit) as total, prod.fabricante_cod
from facturas fact
	join facturas_det det
		on fact.factura_num = det.factura_num
	join productos prod
		on prod.producto_cod = det.producto_cod
group by fact.cliente_num, prod.fabricante_cod
order by fact.cliente_num, total desc
