-- Ejercicio 6
select p.provincia_cod, p.provincia_desc, prod.producto_cod, sum(fd.cantidad * fd.precio_unit) as cant_total_vendida
from provincias p
	join clientes c on c.provincia_cod = p.provincia_cod
	join facturas f on f.cliente_num = c.cliente_num
	join facturas_det fd on fd.factura_num = f.factura_num
	join productos prod on prod.producto_cod = fd.producto_cod
group by p.provincia_cod, p.provincia_desc, prod.producto_cod
having sum(fd.cantidad * fd.precio_unit) = (select top 1 sum(fd.cantidad * fd.precio_unit)
											from productos prod 
												join facturas_det fd on fd.producto_cod = prod.producto_cod
												join facturas f on f.factura_num = fd.factura_num
												join clientes c on c.cliente_num = f.cliente_num 
											where c.provincia_cod = p.provincia_cod
											group by prod.producto_cod
											order by sum(fd.cantidad * fd.precio_unit) desc )
order by p.provincia_cod



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


select p.provincia_cod, p.provincia_desc, prod.producto_cod, sum(d.cantidad * d.precio_unit) as cant_total_vendida
from provincias p join clientes c     on p.provincia_cod = c.provincia_cod
	              join facturas f     on c.cliente_num = f.cliente_num
	              join facturas_det d on f.factura_num = d.factura_num
				  join productos prod on p.provincia_cod = d.producto_cod
group by p.provincia_cod, p.provincia_desc,prod.producto_cod
having sum(d.cantidad * d.precio_unit) = 
                 ( select top 1 sum(d.cantidad * d.precio_unit)
                     from clientes c  join facturas f     on c.cliente_num = f.cliente_num
	                                  join facturas_det d on f.factura_num = d.factura_num
                    where c.provincia_cod = p.provincia_cod
					group by c.cliente_num
					order by sum(d.cantidad * d.precio_unit) desc)
order by p.provincia_cod


-- ejercicio 7
go

create table historiaPrecios(
	producto_cod int,
	fecha_aumento datetime,
	porcentaje_aumento decimal(5,2),
	nuevo_precio decimal(10,2)
)
go
create procedure aumentarPreciosPR (@fabricante_cod varchar(5), @porcentaje_aumento decimal(5,2)) as
begin
	begin try
		begin transaction
			insert into historiaPrecios (producto_cod, fecha_aumento, porcentaje_aumento, nuevo_precio)
			select distinct p.producto_cod, 
				   getdate() as fecha_aumento, 
				   @porcentaje_aumento as porcentaje_aumento, 
				  ((@porcentaje_aumento + 100) * p.precio_unit) / 100 as nuevo_precio
			from fabricantes f
				join productos p on p.fabricante_cod = @fabricante_cod

			update productos
			set precio_unit = ((@porcentaje_aumento + 100) * precio_unit) / 100
			where fabricante_cod = @fabricante_cod
		commit
	end try
	begin catch
		rollback
		print 'Nro. Error:' + cast(ERROR_NUMBER() as varchar);
		print 'Mensaje:' + ERROR_MESSAGE();
		print 'Status:' + cast(ERROR_STATE() as varchar);
		THROW 50000, 'mensaje de error',1
	end catch
end

-- para probar el procedure: 
select * from productos
execute aumentarPreciosPR 'ALAS', 100
select * from historiaPrecios
delete from historiaPrecios
drop procedure aumentarPreciosPR

-- ejercicio 8
go
create table listaPreciosHist(
	producto_cod int,
	fecha_modificacion datetime,
	precio_viejo decimal(12,2),
	precio_nuevo decimal(10,2)
)
go

create trigger actualizarPreciosProductos
on productos
instead of update as
begin
	declare prod_actualizados cursor for
	select producto_cod, precio_unit
	from inserted;

	declare  @producto_cod int, @precio_nuevo decimal(10,2)
	open prod_actualizados
	fetch prod_actualizados into @producto_cod, @precio_nuevo
		
	while (@@FETCH_STATUS=0) 
		begin
			insert into listaPreciosHist
			select @producto_cod, getdate(), precio_unit, @precio_nuevo
			from deleted
			where producto_cod = @producto_cod

			update productos
			set precio_unit = @precio_nuevo
			where producto_cod = @producto_cod

			fetch prod_actualizados into @producto_cod, @precio_nuevo
		end
	close prod_actualizados
	deallocate prod_actualizados
end

--para probar el trigger
update productos
set precio_unit = 999
where producto_cod = 1000
select * from listaPreciosHist
