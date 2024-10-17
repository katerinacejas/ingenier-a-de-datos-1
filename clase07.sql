use [baseDeDatosDelCuatri]

-- 1. Seleccionar cliente_num, nombre, apellido y número de factura de los clientes.
select c.cliente_num, c.nombre, c.apellido, f.factura_num
from clientes c 
	join facturas f
		on c.cliente_num = f.cliente_num

-- 2. Seleccionar cliente_num, nombre, apellido y número de facturas de los clientes hayan comprado algo o no.
select c.cliente_num, c.nombre, c.apellido, f.factura_num
from clientes c 
	left join facturas f
		on c.cliente_num = f.cliente_num

-- 3. Seleccionar cliente_num, nombre, apellido y número de factura de los clientes hayan comprado algo o no. Mostrar también aquellas facturas que no tengan un cliente asociado.
select c.cliente_num, c.nombre, c.apellido, f.factura_num
from clientes c 
	full join facturas f
		on c.cliente_num = f.cliente_num

-- 4. Seleccionar el cliente, nombre y apellido concatenados y separados por una coma, y monto total comprado por cliente para aquellos clientes de ‘BA’ que hayan comprado por mas de $15000.
select c.cliente_num, c.apellido + ',' + c.nombre as nombreYApellido, sum(d.cantidad * d.precio_unit) as monto_total
from clientes c 
	join facturas f
		on c.cliente_num = f.cliente_num
	join facturas_det d
		on f.factura_num = d.factura_num
where c.provincia_cod = 'BA' 
group by c.cliente_num, c.nombre, c.apellido
having sum(d.cantidad * d.precio_unit) > 15000
order by c.cliente_num

-- 5. Seleccionar monto total comprado por cliente y el monto promedio de sus facturas para aquellos clientes que tengan más de 2 facturas. Ordenado por total comprado ascendente.
select 
	c.cliente_num, c.apellido + ',' + c.nombre as nombreYApellido, 
	sum(d.cantidad * d.precio_unit) as monto_total, 
	sum(d.cantidad * d.precio_unit) / count(distinct f.factura_num) as promedio_de_facturas
from clientes c 
	join facturas f
		on c.cliente_num = f.cliente_num
	join facturas_det d
		on f.factura_num = d.factura_num
group by c.cliente_num, c.nombre, c.apellido
having count(distinct f.factura_num) > 2
order by monto_total

-- 6. Seleccionar cliente_num, nombre, apellido, codigo y descripción de producto y monto total de los productos comprados por cliente ordenados por cliente y producto en forma ascendente y monto en forma descendente.
select 
	c.cliente_num, c.apellido + ',' + c.nombre as nombreYApellido,
	sum(d.cantidad * d.precio_unit) as monto_total,
	p.producto_cod, p.producto_desc
from clientes c 
	join facturas f
		on c.cliente_num = f.cliente_num
	join facturas_det d
		on f.factura_num = d.factura_num
	join productos p
		on d.producto_cod = p.producto_cod
group by c.cliente_num, c.nombre, c.apellido, p.producto_cod, p.producto_desc
order by c.cliente_num asc, p.producto_cod asc, monto_total desc

-- 7. Seleccionar los nombres y apellidos de los clientes junto con los de sus referentes.
select c1.nombre, c1.apellido, c1.cliente_ref, c2.cliente_num, c2.nombre, c2.apellido
from clientes c1
	join clientes c2
		on c1.cliente_num = c2.cliente_num
order by c1.cliente_num

-- 8. Seleccionar una lista de los códigos de productos identificando con una leyenda si fue comprado o no.


-- 9. Seleccionar la lista de productos del fabricante ‘CASA’ que fueron comprados.


-- 10. Seleccionar código de producto y descripción de aquellos productos del fabricante ‘EXPO’ que no hayan sido comprados.


-- 11. Seleccione los códigos y descripciones de los productos de los fabricantes ‘CASA’ y ‘DOTO’ de 3 maneras distintas.


-- 12. Seleccione los productos en común que hayan comprado los clientes 103, 114 y 106.