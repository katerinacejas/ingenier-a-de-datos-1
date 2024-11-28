-- ejercicio 6
with clientes_totales as (
	select c.cliente_num, c.apellido, c.nombre, c.cliente_ref, sum(d.cantidad*d.precio_unit) as 'monto_total'
	from clientes c
		join facturas f on c.cliente_num = f.cliente_num
		join facturas_det d on f.factura_num = d.factura_num
	group by c.cliente_num, c.apellido, c.nombre, c.cliente_ref
	)
select c1.cliente_num, c1.apellido, c1.nombre, c1.monto_total, 
       coalesce(c2.cliente_num, -999) as 'cliente_referido', -- puse -999 porque no podia poner '--' al ser cliente_ref de tipo int
	   coalesce(c2.apellido, '--') as 'apellido_referido',
	   coalesce(c2.nombre, '--') as 'nombre_referido',
	   coalesce(c2.monto_total, 0) as 'monto_total_referido'
from clientes_totales c1
	full join clientes_totales c2
		on c1.cliente_ref = c2.cliente_num
where c1.cliente_num is not null
order by c1.monto_total desc, c2.monto_total desc


select * from clientes where cliente_num = 103

--ejercicio 7
go
create table NovedadesClientes(
	cliente_num int primary key,
	apellido varchar(15),
	nombre varchar(15),
	empresa varchar(20),
	provincia_cod char(2)
)
go
create table auditoria(
	idAuditoria int primary key identity(1,1),
	fechaHora datetime,
	operacion char(1),
	cliente_num int
)
go
create procedure procesarClientesPR as
begin
	declare @operacionRealizada char(1)

	declare novCliCursor cursor for
	select cliente_num, apellido, nombre, empresa, provincia_cod
	from NovedadesClientes;

	declare @cliente_num int, @apellido varchar(15), @nombre varchar(15), @empresa varchar(20), @provincia_cod char(2)
	open novCliCursor
	fetch novCliCursor into @cliente_num, @apellido, @nombre, @empresa, @provincia_cod
		
	while (@@FETCH_STATUS=0) 
	begin
		begin try
			begin transaction
				if exists(select cliente_num from clientes where cliente_num = @cliente_num)
					begin
						update clientes
						set apellido = @apellido,  nombre = @nombre,  empresa = @empresa, provincia_cod = @provincia_cod
						where cliente_num = @cliente_num
						set @operacionRealizada = 'M'
					end
				else 
					begin
						insert into clientes (cliente_num, apellido, nombre, empresa, provincia_cod)
						values (@cliente_num, @apellido, @nombre, @empresa, @provincia_cod)
						set @operacionRealizada = 'I'
					end
				insert into auditoria (fechaHora, operacion, cliente_num)
				values (getdate(), @operacionRealizada, @cliente_num)
			commit
		end try
		begin catch
			rollback
			print 'nro. Error:' + cast(error_number() as varchar);
			print 'mensaje:' + error_message();
			print 'estado:' + cast(error_state() as varchar);
			THROW 50000, 'mensaje de error',1
		end catch
		fetch novCliCursor into @cliente_num, @apellido, @nombre, @empresa, @provincia_cod
	end
	close novCliCursor
	deallocate novCliCursor
end

-- para probar el procedure con modificacion:
insert into NovedadesClientes (cliente_num, apellido, nombre, empresa, provincia_cod)
select top 1 cliente_num, 'NUEVO_APELLIDO', 'NUEVO_NOMBRE', 'NUEVA_EMPRESA', 'BA' from clientes
-- para probar el procedure con insertar
insert into NovedadesClientes (cliente_num, apellido, nombre, empresa, provincia_cod)
values(99999, 'NUEVO_APELLIDO2', 'NUEVO_NOMBRE2', 'NUEVA_EMPRESA2', 'BA') 
execute procesarClientesPR
select * from NovedadesClientes
select * from auditoria
select * from clientes

-- ejercicio 8
go
create view fabricantesV as (
	select fabricante_cod, fabricante_nom, tiempo_entrega, p.provincia_cod, p.provincia_desc
	from fabricantes f
		join provincias p on f.provincia_cod = p.provincia_cod
);
go

create trigger borrarFabricantes
on fabricantesV
instead of delete as
begin
	declare fabABorrar cursor for
	select fabricante_cod, tiempo_entrega
	from deleted;

	declare @fabricante_cod varchar(5), @tiempo_entrega smallint
	open fabABorrar
	fetch fabABorrar into @fabricante_cod, @tiempo_entrega
		
	while (@@FETCH_STATUS=0) 
		begin
			if @tiempo_entrega < 5
				begin
					print 'nro. Error: ' + cast(error_number() as varchar);
					print 'mensaje: ' + error_message();
					print 'estado: ' + cast(error_state() as varchar);
					throw 50000, 'Error. Cliente eficiente', 1
				end
			else
				begin
					delete from fabricantes
					where fabricante_cod = @fabricante_cod
					fetch fabABorrar into @fabricante_cod, @tiempo_entrega
				end
		end
	close fabABorrar
	deallocate fabABorrar
end

-- para probar el trigger
select * from fabricantesV
-- estos fabricantes no me permite borrarlos porque son FK de productos.
delete from fabricantesV where fabricante_cod in ('ALAS','BERI')