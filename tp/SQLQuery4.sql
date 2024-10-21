use baseDeDatosDelCuatri

-- EJERCICIO 1

create table Personas(
	id int NOT NULL,
	Nombre varchar(20),
	Apellido varchar(20)
)

insert Personas (Id, Nombre, Apellido) 
values (1,'Kate','Cejas')
insert Personas (Id, Nombre, Apellido) 
values (1,'Chispi','Cejas')
insert Personas (Id, Nombre, Apellido) 
values (1,'Atun','Cejas')
insert Personas (Id, Nombre, Apellido) 
values (2,'Nacho','Norte')
insert Personas (Id, Nombre, Apellido) 
values (3,'Uma','Norte')
insert Personas (Id, Nombre, Apellido) 
values (3,'Michu','Norte')
insert Personas (Id, Nombre, Apellido) 
values (3,'Michu','Norte')
insert Personas (Id, Nombre, Apellido) 
values (1,'Kate','Cejas')
insert Personas (Id, Nombre, Apellido) 
values (1,'Chispi','Cejas')
insert Personas (Id, Nombre, Apellido) 
values (1,'Atun','Cejas')

select Id, Nombre, Apellido
from Personas
where Id in 
	(select Id
	 from Personas
	 group by Id 
	 having count(Id) > 1)


-- Ejercicio 2

select row_number() over(partition by Id order by Id asc) as nro_fila,
		Id, Nombre, Apellido
	into #Personas
	from Personas


delete from Personas
where (cast(Id as varchar(1))+Nombre+Apellido not in 
		(select cast(nro_fila as varchar(1))+Nombre+Apellido
		from #Personas))
	 and
	 (Id in (select Id
	 from Personas
	 group by Id 
	 having count(Id) > 1))
	 
drop table #Personas


-- para pruebas
select Id, Nombre, Apellido
from Personas
order by 1, 2

-- se declara el cursor
declare borrarDuplicadosCursor cursor for
	SELECT Id, Nombre, Apellido
	from Personas;

-- se declaran las variables que almacenaran cada iteracion del cursor
declare @Id int, @Nombre varchar(20), @Apellido varchar(20)
 
--abrir cursor
OPEN borrarDuplicadosCursor

-- primera iteracion, guardo la primer fila en las variables
fetch borrarDuplicadosCursor into @Id, @Nombre, @Apellido;

While (@@FETCH_STATUS=0) --mientras haya filas por leer en la tabla de #Personas
	begin
		if (select nro_fila from #Personas where Id = @Id) = 1
			begin 
				delete from Personas
				where 
			end
		

		-- busca la fila siguiente
		fetch borrarDuplicadosCursor into @Id, @Nombre, @Apellido;
	end

--cerrar y liberar cursor
close borrarDuplicadosCursor
DEALLOCATE borrarDuplicadosCursor

-- Ejercicio 3
-- totales comprados por todos los clientes en cada provincia de los fabricantes

select fab.provincia_cod, coalesce(sum(det.cantidad * det.precio_unit), 0) as total_comprado
from fabricantes fab
	left join productos prod
		on prod.fabricante_cod = fab.fabricante_cod
	left join facturas_det det
		on prod.producto_cod = det.producto_cod
group by fab.provincia_cod
order by fab.provincia_cod


-- ejercicio 4

create table numeros_secuenciales(
	numero int null
)

insert numeros_secuenciales(numero) 
values (1)
insert numeros_secuenciales(numero) 
values (2)
insert numeros_secuenciales(numero) 
values (3)
insert numeros_secuenciales(numero) 
values (8)

select coalesce(min(numero + 1), 1) as primer_espacio_libre
from numeros_secuenciales
where numero + 1 not in (select numero from numeros_secuenciales)


-- ejercicio 5

select prod.producto_cod,
    sum(case when month(fact.fecha_emision) = 1 then det.precio_unit * det.cantidad else 0 end) as '1',
    sum(case when month(fact.fecha_emision) = 2 then det.precio_unit * det.cantidad else 0 end) as '2',
    sum(case when month(fact.fecha_emision) = 3 then det.precio_unit * det.cantidad else 0 end) as '3',
    sum(case when month(fact.fecha_emision) = 4 then det.precio_unit * det.cantidad else 0 end) as '4',
    sum(case when month(fact.fecha_emision) = 5 then det.precio_unit * det.cantidad else 0 end) as '5',
    sum(case when month(fact.fecha_emision) = 6 then det.precio_unit * det.cantidad else 0 end) as '6',
    sum(case when month(fact.fecha_emision) = 7 then det.precio_unit * det.cantidad else 0 end) as '7',
    sum(case when month(fact.fecha_emision) = 8 then det.precio_unit * det.cantidad else 0 end) as '8',
    sum(case when month(fact.fecha_emision) = 9 then det.precio_unit * det.cantidad else 0 end) as '9',
    sum(case when month(fact.fecha_emision) = 10 then det.precio_unit * det.cantidad else 0 end) as '10',
    sum(case when month(fact.fecha_emision) = 11 then det.precio_unit * det.cantidad else 0 end) as '11',
    sum(case when month(fact.fecha_emision) = 12 then det.precio_unit * det.cantidad else 0 end) as '12'
from productos prod
	left join facturas_det det
		on prod.producto_cod = det.producto_cod
	left join facturas fact
		on det.factura_num = fact.factura_num 
group by prod.producto_cod

-- ejercicio 7
select c1.cliente_num,
	c1.cliente_ref as 'Referente',
	c2.cliente_ref as 'Referente2',
	c3.cliente_ref as 'Referente3'
from clientes c1
	left join clientes c2
		on c1.cliente_ref = c2.cliente_num
	left join clientes c3
		on c2.cliente_ref = c3.cliente_num
where c1.cliente_ref is not null


-- ejercicio 8
