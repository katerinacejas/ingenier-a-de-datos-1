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

select Id, Nombre, Apellido
from Personas
where Id in 
	(select Id
	 from Personas
	 group by Id 
	 having count(Id) > 1)

-- EJERCICIO 2
delete from Personas
--where 

DELETE FROM PERSONAS
WHERE Id NOT IN (
    SELECT MIN(Id)
    FROM PERSONAS
    GROUP BY Id
);

select Id, Nombre, Apellido
from Personas

DELETE FROM PERSONAS
WHERE Id IN (
    SELECT Id
    FROM (
        SELECT Id, ROW_NUMBER() OVER (PARTITION BY Id ORDER BY (SELECT NULL)) AS rn
        FROM PERSONAS
    ) AS duplicates
    WHERE rn > 1
);