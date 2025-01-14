use uade
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
with duplicados as (
    select Id, 
		   Nombre, 
		   Apellido,
           row_number() over (partition by Id order by Id) as nro_fila
    from Personas
)
delete from duplicados
where nro_fila > 1



-- Ejercicio 3
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

insert numeros_secuenciales(numero) values (1)
insert numeros_secuenciales(numero) values (2)
insert numeros_secuenciales(numero) values (456)
insert numeros_secuenciales(numero) values (8)

select coalesce(min(numero + 1), 1) as primer_espacio_libre
from numeros_secuenciales
where numero + 1 not in (select numero from numeros_secuenciales)

select * from numeros_secuenciales
delete from numeros_secuenciales


-- ejercicio 5
select det.producto_cod,
    sum(case when month(fact.fecha_emision) = 1 then det.cantidad else 0 end) as '1',
    sum(case when month(fact.fecha_emision) = 2 then det.cantidad else 0 end) as '2',
    sum(case when month(fact.fecha_emision) = 3 then det.cantidad else 0 end) as '3',
    sum(case when month(fact.fecha_emision) = 4 then det.cantidad else 0 end) as '4',
    sum(case when month(fact.fecha_emision) = 5 then det.cantidad else 0 end) as '5',
    sum(case when month(fact.fecha_emision) = 6 then det.cantidad else 0 end) as '6',
    sum(case when month(fact.fecha_emision) = 7 then det.cantidad else 0 end) as '7',
    sum(case when month(fact.fecha_emision) = 8 then det.cantidad else 0 end) as '8',
    sum(case when month(fact.fecha_emision) = 9 then  det.cantidad else 0 end) as '9',
    sum(case when month(fact.fecha_emision) = 10 then det.cantidad else 0 end) as '10',
    sum(case when month(fact.fecha_emision) = 11 then det.cantidad else 0 end) as '11',
    sum(case when month(fact.fecha_emision) = 12 then det.cantidad else 0 end) as '12'
from facturas_det det
	left join facturas fact
		on det.factura_num = fact.factura_num 
group by det.producto_cod




-- ejercicio 6


create table tabla1(
	columna1 int,
	columna2 int,
	columna3 int,
)

create table tabla2(
	columna1 int,
	columna2 int,
	columna3 int,
)

insert tabla1 (columna1, columna2, columna3) values (1,2,3)
insert tabla1 (columna1, columna2, columna3) values (4,5,6)
insert tabla1 (columna1, columna2, columna3) values (7,8,9)

insert tabla2 (columna1, columna2, columna3) values (1,2,3)
insert tabla2 (columna1, columna2, columna3) values (4,5,6)
insert tabla2 (columna1, columna2, columna3) values (7,8,9)

insert tabla2 (columna1, columna2, columna3) values (8,8,9)

delete from tabla1
delete from tabla2

select * from tabla1
select * from tabla2

go

create procedure asegurarMismaEstructura as
begin
	-- valido que tengan la misma cantidad de registros
	if (select count(*) from tabla1) != (select count(*) from tabla2)
		begin
			print 'Nro. Error: ' + cast(error_number() as varchar);
			print 'mensaje: ' + error_message();
			print 'estado: ' + cast(error_state() as varchar);
			throw 50000, 'Las tablas tienen distinta cantidad de registros', 1
		end
	
	-- en caso de que la cantidad de registros sea la misma, se valida que el resto sea exactamente igual.
	-- se hace una validacion de la cantidad previo a esta validacion porque el except no distingue entre duplicados,
	-- y si hay duplicados entonces podr�a variar la cantidad de registros por mas que los datos sean los mismos. 

	declare @cantidad_registros_distintos int
	select @cantidad_registros_distintos = count(*) from ( select * from tabla1 except select * from tabla2
															union all
															select * from tabla2 except select * from tabla1 ) as diferencias_entre_tablas
	if @cantidad_registros_distintos > 0
		begin
			print 'Nro. Error: ' + cast(error_number() as varchar);
			print 'mensaje: ' + error_message();
			print 'estado: ' + cast(error_state() as varchar);
			throw 50000, 'Las tablas no son exactamente iguales', 1
		end

	-- en caso de no haberse lanzado ningun eror: 
	print 'Las tablas son exactamente iguales'
end

go

exec asegurarMismaEstructura


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
create table clubes(
	codigo int primary key,
	nombre varchar(30) not null,
)

create table jugadoras(
	legajo int not null,
	codigoClub int references clubes(codigo) not null,
	nombre varchar(30) not null,
	apellido varchar(30) not null,
	dni int not null,
	fechaDesde date not null,
	fechaHasta date not null,
	primary key (legajo, fechaDesde, fechaHasta)
)

insert into clubes (codigo, nombre) values (1, 'unClub')
insert into clubes (codigo, nombre) values (2, 'otroClub')

insert into jugadoras (legajo, codigoClub, nombre, apellido, dni, fechaDesde, fechaHasta)
				values( 100,       1,      'kate', 'cejas', 12345,'2024-01-01','2024-12-31')

select * from clubes
select * from jugadoras 

delete from jugadoras

drop table jugadoras
drop table clubes

-- insert para probar el trigger

--este insert deberia fallar
insert into jugadoras (legajo, codigoClub, nombre, apellido, dni, fechaDesde, fechaHasta)
				values( 100,       2,      'kate', 'cejas', 12345,'2024-09-03','2024-12-31')

insert into jugadoras (legajo, codigoClub, nombre, apellido, dni, fechaDesde, fechaHasta)
				values( 100,       2,      'kate', 'cejas', 12345,'2023-01-01','2026-12-31')

--estos insert ejecutan bien
insert into jugadoras (legajo, codigoClub, nombre, apellido, dni, fechaDesde, fechaHasta)
				values( 100,       2,      'kate', 'cejas', 12345,'2025-01-01','2025-12-25')
insert into jugadoras (legajo, codigoClub, nombre, apellido, dni, fechaDesde, fechaHasta)
				values( 101,       1,     'chispi', 'cejas',78949,'2025-01-01','2025-12-25')


go 

create trigger evitarFichajeAlMismoTiempo
on jugadoras
instead of insert as
begin
	-- validar la existencia de la jugadora 
	if exists (select top 1 legajo from jugadoras where legajo = (select legajo from inserted))
		begin
			-- se declara el cursor
			declare cursorJugadoras cursor for
				select legajo, codigoClub, nombre, apellido, dni, fechaDesde, fechaHasta
				from jugadoras
				where legajo = (select legajo from inserted)

			-- se declaran las variables que almacenaran cada iteracion del cursor
			declare @legajo int, @codigoClub int, @nombre varchar(30), @apellido varchar(30), @dni int, @fechaDesde date, @fechaHasta date
 
			--abrir cursor
			open cursorJugadoras

			-- primera iteracion, guardo la primer fila en las variables
			fetch cursorJugadoras into @legajo, @codigoClub, @nombre, @apellido, @dni, @fechaDesde, @fechaHasta

			while (@@FETCH_STATUS=0) --mientras haya filas por leer de la misma jugadora
				begin
					-- validar que las fechas Desde y Hasta no est� ninguna de las dos dentro del periodo en la jugadora ya existente
					if
						((select fechaDesde from inserted) between @fechaDesde and @fechaHasta)
							or 
						((select fechaHasta from inserted) between @fechaDesde and @fechaHasta)
							or
						((select fechaDesde from inserted) < @fechaDesde and (select fechaHasta from inserted) > @fechaHasta)

						begin -- en caso de que los periodos no sean validos, se lanza error
							print 'Nro. Error: ' + cast(error_number() as varchar);
							print 'mensaje: ' + error_message();
							print 'estado: ' + cast(error_state() as varchar);
							throw 50000, 'Se intent� insertar a una jugadora en un periodo donde ya tiene un club asignado.', 1
						end
					-- busca la fila siguiente
					fetch cursorJugadoras into @legajo, @codigoClub, @nombre, @apellido, @dni, @fechaDesde, @fechaHasta
				end

			--cerrar y liberar cursor
			close cursorJugadoras
			deallocate cursorJugadoras
		end 

	-- en caso de no existir la jugadora, o que los periodos sean v�lidos, inserto en la tabla
	insert into jugadoras (legajo, codigoClub, nombre, apellido, dni, fechaDesde, fechaHasta)
	select legajo, codigoClub, nombre, apellido, dni, fechaDesde, fechaHasta from inserted
end
