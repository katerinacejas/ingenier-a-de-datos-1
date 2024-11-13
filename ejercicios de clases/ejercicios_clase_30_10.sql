/* Ejercicio 1
Crear un procedimiento totalCompraPr al cual se le envíe como parámetro un número de cliente “desde” y un número de cliente “hasta”. 
El procedimiento deberá calcular y guardar en la tabla ComprasHist el número de cliente y el monto total comprado de cada cliente. 
Si el cliente ya existe, registrar en una tabla de errores el número de cliente y el mensaje de error “Cliente ya existente” y continuar con el procesamiento de los demás clientes. 
Devolver por pantalla un total de control que indique la cantidad de clientes leídos, la cantidad de clientes grabados y la cantidad de erróneos.
*/



/* Ejercicio 2
Seleccionar número de cliente, nombre, monto total comprado, y número, nombre y monto total comprado de un cliente 2, y comparándolos y mostrándolos de a pares. 
El monto del primer cliente deberá ser mayor al del segundo. Mostrar la consulta ordenada por número de cliente y monto del segundo cliente.
*/

with clientes_totales as (
	select c.cliente_num, c.nombre, sum(d.cantidad*d.precio_unit) as 'monto_total_comprado'
	from clientes c
		join facturas f on c.cliente_num = f.cliente_num
		join facturas_det d on f.factura_num = d.factura_num
	group by c.cliente_num, c.nombre
	)
select * from clientes_totales c1
	full join clientes_totales c2
	on c1.cliente_num != c2.cliente_num and
	   c1.monto_total_comprado > c2.monto_total_comprado
	where c2.monto_total_comprado is not null and c1.monto_total_comprado is not null
	order by c1.cliente_num, c2.monto_total_comprado


/* Ejercicio 3
Se requiere listar para la provincia de Buenos Aires el par de clientes que sean los que suman el mayor monto facturado, con el formato de salida:
'Nombre Provincia', 'Apellido, Nombre', 'Apellido, Nombre', 'Total Solicitado' (*)
(*) El total solicitado contendrá la suma de los dos clientes.
*/
with clientes_totales as (
	select c.cliente_num, c.nombre, c.apellido, sum(d.cantidad*d.precio_unit) as 'monto_total_comprado'
	from clientes c
		join facturas f on c.cliente_num = f.cliente_num
		join facturas_det d on f.factura_num = d.factura_num
	where c.provincia_cod = 'BA'
	group by c.cliente_num, c.nombre, c.apellido
	)
select top 1
		'BA' as nombre_provincia, 
		c1.apellido + ' ,' + c1.nombre as nombre_completo, 
		c2.apellido + ' ,' + c2.nombre as nombre_completo, 
		c1.monto_total_comprado + c2.monto_total_comprado as total_solicitado
from clientes_totales c1, clientes_totales c2
where c1.cliente_num != c2.cliente_num
order by total_solicitado desc

/* Ejercicio 4
Seleccionar los clientes de mayor monto comprador de cada provincia o, lo que es lo mismo, por cada provincia el cliente de mayor facturación. 
*/

select p.provincia_cod, p.provincia_desc, c.cliente_num, sum(d.cantidad * d.precio_unit) as total_comprado
from provincias p
	join clientes c     on p.provincia_cod = c.provincia_cod
	join facturas f     on c.cliente_num = f.cliente_num
	join facturas_det d on f.factura_num = d.factura_num
group by p.provincia_cod, p.provincia_desc, c.cliente_num
order by p.provincia_cod,total_comprado desc

select top 1 p.provincia_cod, p.provincia_desc, c.cliente_num, sum(d.cantidad * d.precio_unit) as total_comprado
from provincias p
	join clientes c     on p.provincia_cod = c.provincia_cod
	join facturas f     on c.cliente_num = f.cliente_num
	join facturas_det d on f.factura_num = d.factura_num
group by p.provincia_cod, p.provincia_desc, c.cliente_num
order by p.provincia_cod,total_comprado desc


--query final
select p.provincia_cod, p.provincia_desc, c.cliente_num, sum(d.cantidad * d.precio_unit) as total_comprado
from provincias p join clientes c     on p.provincia_cod = c.provincia_cod
	              join facturas f     on c.cliente_num = f.cliente_num
	              join facturas_det d on f.factura_num = d.factura_num
group by p.provincia_cod, p.provincia_desc, c.cliente_num
having sum(d.cantidad * d.precio_unit) = 
                 ( select top 1 sum(d.cantidad * d.precio_unit)
                     from clientes c  join facturas f     on c.cliente_num = f.cliente_num
	                                  join facturas_det d on f.factura_num = d.factura_num
                    where c.provincia_cod = p.provincia_cod
					group by c.cliente_num
					order by sum(d.cantidad * d.precio_unit) desc)
order by p.provincia_cod, total_comprado desc


/* Ejercicio 5
Crear un trigger que ante cambios (inserts, borrados, modificaciones) en las filas factura_detalle, mantenga un atributo montoTOTAL de la tabla facturas con el monto correcto (p x q).
*/

alter table facturas
add totaL decimal(10,2)

select * from facturas
select * from facturas_det

go 

create trigger actualizarMontoTotal 
on facturas_det
after insert, delete, update as
begin
	declare cursor_det cursor for
		select factura_num, renglon, producto_cod, cantidad, precio_unit
		from inserted;
	
	declare @factura_num int, @cantidad smallint, @precio_unit decimal(10,2)

	open cursor_det

	fetch cursor_det into 

end


--query final
go
create trigger facturasDetTR ON facturas_det
     AFTER INSERT, UPDATE, DELETE as
--
     declare @nro_factura int
--
begin
--
     IF EXISTS (SELECT 1 FROM inserted)
	    SELECT TOP 1 @nro_factura = FACTURA_NUM from inserted
     else
	    SELECT TOP 1 @nro_factura = FACTURA_NUM from deleted
    --
	update facturas
	   set total = (select sum(cantidad * precio_unit) from facturas_det where factura_num = @nro_factura)
     where factura_num = @nro_factura;
--
end



/* Ejercicio 6
Crear un trigger que ante compras efectuadas por los clientes, valide lo siguiente:
Que los fabricantes de CABA o Buenos Aires puedan vender a clientes de todo el país excepto a los de Tierra del Fuego.
Que los demás fabricantes de otras provincias solo puedan vender mercaderías a clientes de las mismas provincias.
Asuma que las operaciones son de una misma factura que puede tener varios renglones.
*/