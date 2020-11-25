--- construcción de tablas en la base de datos con nuevas instrucciones---
create database aeropuerto

use aeropuerto

---crear tabla piloto---

create table piloto(

id_piloto int unique, --- se usa unique para que no repita el dato ---
nombrepiloto varchar(5) not null,
horasvuelo float not null,
constraint apdopiloto primary key(id_piloto))

insert into piloto values(1,'Mateo',670)  --- inserta datos en la bd---
insert into piloto values(2,'Pedro',800)
insert into piloto values(3,'Maria',60)
insert into piloto values(4,'Juan',500)
insert into piloto values(5,'Vera',50)

select * from piloto --- hace consultas en la bd---

create table tripulacion(
id_tripulacion int unique,   --- se usa unique para que no repita el dato ---
nombre varchar(60) not null,
constraint apodotripulacion primary key (id_tripulacion))

insert into tripulacion values (011,'Alas')
insert into tripulacion values (012,'Ventura')
insert into tripulacion values (013,'ginebra')

select * from tripulacion

create table avion(
placa_avion int unique,
nombre_avion varchar(60)
constraint apodoavion primary key (placa_avion))

insert into avion values (100,'figaro A350')
insert into avion values (200,'vientp A430')
insert into avion values (300,'rayo A347')
insert into avion values (400,'condor A552')

select * from avion

create table base(
id_base int unique,
nombre_base varchar(60) not null,
constraint ide_base primary key (id_base))

insert into base values (1,'jose Maria cordoba')
insert into base values (2,'El Dorado')
insert into base values (3,'Ernesto Cortizzos')
insert into base values (4,'san peters burgo')

select * from base

create table vuelo(
id_vuelo int unique,
origen varchar(60) not null,
destino varchar(60) not null,
hora_deter datetime not null,
placa_avion1 int,
constraint apodovuelo primary key (id_vuelo),
constraint apodovuelo_placa foreign key(placa_avion1) references avion (placa_avion))

insert into vuelo values(1,'Medellin','Bogota','2020-11-03T09:39:04',100)
insert into vuelo values(2,'Medellin','San Andres','2020-11-03T14:39:04',200)
insert into vuelo values(3,'Barranquilla','berlin','2020-11-03T14:39:04',200)
insert into vuelo values(4,'Bogota','Moscu','2020-11-03T14:39:04',400)

select * from vuelo
select distinct origen from vuelo
select * from vuelo  order by placa_avion1

--modifica info--
update vuelo set id_vuelo

---- se crean tablas intermedias---

--- t.i piloto_vuelo---
create table piloto_vuelo(
id_piloto1 int,
id_vuelo1 int,
constraint apodopiloto_vuelo foreign key(id_piloto1) references piloto(id_piloto),
constraint apodovuelo_piloto foreign key(id_vuelo1) references vuelo(id_vuelo))

insert into piloto_vuelo values(1,1)
insert into piloto_vuelo values(2,2)
insert into piloto_vuelo values(3,3)
insert into piloto_vuelo values(4,4)

select * from piloto_vuelo

--- t.i tripulacion_vuelo---
create table tripulacion_vuelo(
id_tripulacion1 int,
id_vuelo2 int,
constraint apodotripu_vuelo foreign key(id_tripulacion1) references tripulacion (id_tripulacion),
constraint apodovuelo_tripu foreign key(id_vuelo2) references vuelo(id_vuelo))

insert into tripulacion_vuelo values(011,1)
insert into tripulacion_vuelo values(012,2)
insert into tripulacion_vuelo values(013,4)
insert into tripulacion_vuelo values(013,3)


select * from tripulacion_vuelo

--- t.i avion_base---
create table avion_base(
id_base1 int,
placa_avion1 int,
constraint apodoavion_base foreign key(id_base1) references base (id_base),
constraint apodobase_avion foreign key(placa_avion1) references avion (placa_avion))

insert into avion_base values (1,100)
insert into avion_base values (2,100)
insert into avion_base values (3,400)
insert into avion_base values (4,200)
insert into avion_base values (4,300)


---filtro para traer valores no repetidos
select distinct nombrepiloto from piloto
---traer en un orden especifico---
select * from piloto order by nombrepiloto, horasvuelo
---modificar informacion---
update piloto set nombrepiloto='karen' where id_piloto=5
---borrar informacion---
delete from piloto where nombrepiloto='ani'
---agregar otro atributo o campo---
alter table piloto add telefono varchar(10)
---renombrar columna a la tabla---
exec sp_rename 'piloto.horasvuelo','horavuelos','column'
---borrar columna---
alter table piloto drop column telefono


----------------------- usar el inner join-------------------------------

--- saber el tipo de avion, la placa del vuelo a berlin
select nombre_avion, placa_avion, destino, origen,hora_deter from avion

inner join vuelo  on avion.placa_avion = vuelo.placa_avion1

where destino = 'berlin'


---saber el piloto que esta volando el avion a Moscu
select nombre_avion, placa_avion, destino, origen,hora_deter, nombrepiloto from avion

inner join vuelo  on avion.placa_avion = vuelo.placa_avion1
inner join piloto_vuelo on piloto_vuelo.id_vuelo1 = vuelo.id_vuelo
inner join piloto on piloto.id_piloto = piloto_vuelo.id_piloto1

where destino = 'Moscu'


---saber el piloto que esta volando el avion a bogota y que tripulacion va con el
select nombre_avion, placa_avion, destino, origen,hora_deter, nombrepiloto, nombre from avion

inner join vuelo  on avion.placa_avion = vuelo.placa_avion1

inner join piloto_vuelo on piloto_vuelo.id_vuelo1 = vuelo.id_vuelo
inner join piloto on piloto.id_piloto = piloto_vuelo.id_piloto1

inner join tripulacion_vuelo on tripulacion_vuelo.id_vuelo2 = vuelo.id_vuelo
inner join tripulacion on tripulacion.id_tripulacion = tripulacion_vuelo.id_tripulacion1

where destino = 'bogota'


---saber el piloto que esta volando el avion a berlin y que tripulacion va con el y en que base estaba el avion
select nombre_avion, placa_avion, destino, origen,hora_deter, nombrepiloto, nombre, nombre_base from avion

inner join vuelo  on avion.placa_avion = vuelo.placa_avion1
inner join piloto_vuelo on piloto_vuelo.id_vuelo1 = vuelo.id_vuelo
inner join piloto on piloto.id_piloto = piloto_vuelo.id_piloto1
inner join tripulacion_vuelo on tripulacion_vuelo.id_vuelo2 = vuelo.id_vuelo
inner join tripulacion on tripulacion.id_tripulacion = tripulacion_vuelo.id_tripulacion1
inner join  avion_base on avion_base.placa_avion1 = avion.placa_avion
inner join base on base.id_base = avion_base.id_base1

where destino = 'berlin'