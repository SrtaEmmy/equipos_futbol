-- crear las tablas
create table jugadores (nif varchar(9) primary key, 
nombre varchar(20), apellidos varchar(20), edad int,
partidos_jugados int, importe_prima int,
nom_equipo varchar(20));


create table equipos(nombre varchar(20) primary key,
categoria varchar(20), posicion_en_liga int,
numero_jugadores int);


create table totales_tabla(tabla varchar(20) primary key,
num_registros int);


-- crear la clave ajena en la tabla jugadores que depende de la tabla equipos
alter table jugadores 
add constraint clave_ajena
foreign key (nom_equipo)
references equipos(nombre)
on delete restrict
on update restrict;

alter table equipos add column ES varchar(20) default('Emmily Santos');
alter table jugadores add column ES varchar(20) default('Emmily Santos');
alter table totales_tabla add column ES varchar(20) default('Emmily Santos');



-- insertar los dos registros predeterminados en totales_tabla
insert into totales_tabla values('jugadores', 0, default);
insert into totales_tabla values('equipos', 0, default);


-- trigger que incrementará un jugador en el campo numero_jugadores en la tabla equipos al dar de alta a un jugador en la tabla jugadores
-- a la vez que esto ocurre también incrementa un jugador en el campo jugadores de la tabla totales_tabla
delimiter $$
create trigger trigger_alta_jugador after insert on jugadores -- tras insertar un jugador (en tabla jugadores)
for each row 
begin 
update equipos set numero_jugadores=numero_jugadores+1  -- actualiza la tabla equipos estableciendo +1 en numero_jugadores (se incrementará)
where nombre=new.nom_equipo; -- donde el nombre(de la tabla equipos) sea igual al nuevo nombre de equipo introducido(en tabla jugadores)

update totales_tabla set num_registros=num_registros+1 -- incrementa en 1 el registro jugadores de totales_tabla
where tabla='jugadores';

end
$$



-- trigger que hace la inversa del anterior, decrementa en 1 el número de jugadores al dar de baja a uno

delimiter $$
create trigger trigger_baja_jugador after delete on jugadores 
for each row 
begin
update equipos set numero_jugadores=numero_jugadores-1 
where nombre=old.nom_equipo;

update totales_tabla set num_registros=num_registros-1
where tabla='jugadores';

end
$$


-- trigger que incrementa en 1 el número de equipos al crear un equipo nuevo
delimiter $$
create trigger trigger_alta_equipo after insert on equipos
for each row 
begin
update totales_tabla set num_registros=num_registros+1 
where tabla='equipos';

end
$$


-- trigger que hace lo contrario del anterior, decrementa en 1 el campo "equipos" de totales_tabla al eliminar un equipo
delimiter $$
create trigger trigger_baja_equipo after delete on equipos
for each row -- 
begin
update totales_tabla set num_registros=num_registros-1 
where tabla='equipos';

end
$$

delimiter ;


-- insertamos algunos registros para probar el trigger de dar alta (importante seguir el orden debido a la clave ajena)
insert into equipos values('brasil', 'buena', 5, 0, default);
insert into equipos values('espana', 'media', 6, 0, default);
insert into equipos values('argentina', 'mala', 3, 0, default);
insert into equipos values('francia', 'buena', 2, 0, default);
insert into equipos values('japon', 'malisima', 7, 0, default);
insert into equipos values('alemania', 'buena', 3, 0, default);


insert into jugadores values('123', 'Juanjo', 'Godofredo', 103, 4, 2, 'brasil', default);
insert into jugadores values('234', 'Juanja', 'Sigifreda', 97, 6, 1, 'brasil', default);
insert into jugadores values('345', 'Clodomiro', 'Gervasio', 123, 9, 3, 'espana', default);
insert into jugadores values('456', 'Rogelio', 'Grande', 122, 22, 4, 'argentina', default);
insert into jugadores values('567', 'Amancia', 'Clodomira', 108, 6, 1, 'francia', default);
insert into jugadores values('678', 'Euvasia', 'Mastodonte', 101, 16, 6, 'japon', default);


-- creando una vista que une los siguientes campos de las tablas 'jugadores' y 'equipos'

/*
TABLA jugadores:
apellidos
nombre
nif
edad

TABLA equipos
nombre
categoria
posicion_en_liga

ordenados por apellido y nombre en orden ascendente*/
create view view_datos_equipos as
select jugadores.apellidos,
jugadores.nombre,
jugadores.nif,
jugadores.edad,
equipos.nombre as nombre_,
equipos.categoria,
equipos.posicion_en_liga 
from jugadores inner join equipos on jugadores.nom_equipo=equipos.nombre
order by jugadores.apellidos asc, jugadores.nombre asc;



-- vista que muestra los datos de la tabla equipos donde la cantidad de jugadores en cada equipo no coincida con la cantidad de jugadores para ese equipo
create view view_descuadre as
select e.nombre as nombre_equipo, e.numero_jugadores,
(select count(*) from jugadores j where j.nom_equipo=e.nombre) as
registro_jugadores from equipos e where e.numero_jugadores !=
(select count(*) from jugadores j where j.nom_equipo= e.nombre);



-- creando y cargando tabla empleados
create table empleados(dni int primary key, letra_dni varchar(1), nombre varchar(20), apellidos varchar(40));


-- insertando datos en empleados de forma múltiple
insert into empleados values
(23456787, null, 'Juan', 'Martín González'),
(12786412, null, 'Pedro', 'Gómez Solís'),
(36557791, null, 'Ana', 'García González'),
(8345786, null, 'Mariano', 'Martín Romero'),
(12873478, null, 'Susana', 'López Sanz'),
(14789436, null, 'Ignacio', 'Castejón García'),
(45789423, null, 'Olga', 'Lorenzo Silva'),
(11907634, null, 'Carlos', 'Sainz Torres'),
(12562354, null, 'Felipe', 'Soler Cardoso'),
(3456789, null, 'Lurdes', 'Montero Gómez');


-- procedure que calcula la letra del dni y vuelca datos en archivo.txt


DELIMITER ##
CREATE PROCEDURE proc_calcular_letra_nif()
BEGIN
    -- Declaramos todas las variables necesarias
    DECLARE wletras CHAR(23);
    DECLARE v_nif VARCHAR(255);
    DECLARE v_letra CHAR(1);
    DECLARE v_nombre VARCHAR(255);
    DECLARE v_apellidos VARCHAR(255);

    -- Inicializamos la variable con las letras de los dni
    SET wletras = 'TRWAGMYFPDXBNJZSQVHLCKE';

    -- Actualizamos la tabla empleados con las letras del NIF
    UPDATE empleados-- le decimos que actualice la tabla empleados poniendo el valor que se obtenga en la siguiente operación
    SET letra_dni = SUBSTRING(wletras, (dni % 23) + 1, 1)-- SUBSTRING(variable de sql que recibe 3 parámetros: cadena de texto, fórmula, cantidad de carácteres a devovler)
    WHERE letra_dni IS NULL;

    -- volcar los datos en un archivo.txt
    SELECT CONCAT(dni, letra_dni) AS nif, nombre, apellidos
    INTO OUTFILE 'C:/desarrolloSQL/empleados.txt' FROM empleados WHERE letra_dni IS NOT NULL;

END ##
DELIMITER ;


call proc_calcular_letra_nif;
