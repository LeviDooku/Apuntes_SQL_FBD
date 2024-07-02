----------------------------
--Pedro Velasco Santana   --
--2D - 2024               --
----------------------------

--NOTA: muchas de las creaciones y borrados no se pueden realmente usar, debido a que usan tablas inventadas

--<ctrl + enter> para ejecutar las líneas seleccionadas

describe ventas; 
describe proyecto;
describe proveedor; 
describe pieza;

select table_name from user_tables; --Para ver las tablas en tu usuario (vista de catálogo)

---------------------------------------------------------------------------------------------------------------------------------

--Tablas: creación, inserción de datos, borrado 

    --Creación

create table plantilla(
    dni varchar2(9) unique, --Los valores deberán ser únicos
    nombre varchar2(20) not null,
    estadocivil varchar2(10),
        check (estadocivil in ('soltero', 'casado', 'divorciado', 'viudo')), --comprobar que los valores sean estos
    fechaalta date,
    primary key (dni) --Clave primaria
);

create table serjefe(
    dnijefe references plantilla(dni), --Clave externa de plantilla
    dnitrabajador references plantilla(dni), --Clave externa de plantilla
    primary key(dnitrabajador)
);

    --Borrado
    
drop table plantilla;

    --Modificación esquema tabla
    
add plantilla fechabaja date; --Ej. 1.5

    --Ejercicios adicionales capitulo 1
    
create table equipo(
    codE varchar2(5) not null,
    nombreE varchar2(10) not null,
    localidad varchar2(10) not null, 
    entrenador varchar(10) not null,
    fecha_crea date not null,
    primary key (codE),
    unique (nombreE)
);

create table jugadores(
    codJ varchar(3) primary key,
    nombreJ varchar(10) not null,
    codE references equipo(codE) not null
);

create table encuentros(
    ELocal references equipo(codE),
    EVisitante references equipo(codE),
    fecha date,
    PLocal int default 0,
    PVisitante int default 0,
    check (PVisitante > 0 and PLocal > 0),
    primary key (ELocal, EVisitante)
);

create table faltas(
    codJ references jugadores(codJ),
    numero int default 0 check (numero >= 0 and numero <= 5),
    ELocal varchar2(3),
    EVisitante varchar2(3),
    foreign key (ELocal,EVisitante) references encuentros(ELocal,EVisitante),
    primary key (codJ,ELocal,EVisitante)
);

    --Inserción de tuplas
    
insert into plantilla (dni, nombre, estadocivil, fechaalta)
    values ('123456789S', 'Cabrerizo', 'casado', sysdate);

insert into plantilla select * from trabajadores; --Insertar a partir de otra tabla

    --Modificación de datos

update plantilla 
set estadocivil='divorciado'
where nombre='Cabrerizo'; --Joder....

    --Borrado de tuplas
    
delete from plantilla where nombre='Cabrerizo';
delete from plantilla; --Borrado de todas las tuplas

---------------------------------------------------------------------------------------------------------------------------------

--Consultas básicas

--(A partir de aquí empiezo a usar las tablas presentes en el cuadernillo)

select * from ventas; --Mostrar toda la tabla ventas
select codpro from ventas; --Mostrar codpro de ventas
select distinct codpro from ventas; --Consulta anterior sin repetir valores repetidos
select * from ventas where codpro='S1;' --Ventas realizadas por el proveedor S1
select * from pieza where ciudad='Madrid' and (color='Rojo' or color='Gris'); --Ej. 3.3
select codpie from ventas where cantidad between 200 and 300; --Ej. 3.4
select * from pieza where nompie like 'to%' or nompie like 'To%'; -- Ej. 3.5

---------------------------------------------------------------------------------------------------------------------------------

--Consultas multitabla / consultas de union

    --Unión externa: union / union all / intersect / minus
    
select ciudad from proveedor where status > 2 --Proveedores con status > 2
intersect 
select ciudad from proveedor where ciudad not in( --Ciudades de proveedor que sean distintas a la ciudad donde se hace P1
    select ciudad from pieza where codpie = 'P1'
); --Ej. 3.7

select codpj from ventas where codpro='S1'
minus 
select codpj from ventas where codpro <> 'S1'; --Ej. 3.8 (no sale nada pq no hay proyecto abastecido SOLO por S1)

select ciudad from proveedor
union 
select ciudad from proyecto
union
select ciudad from pieza; --Ej. 3.9

select ciudad from proveedor
union all
select ciudad from proyecto
union all
select ciudad from pieza; --Ej. 3.10 (Lo mismo pero se muestran las tuplas con igual valor)

    --Unión interna: join, natural join
    
--Join: combina filas de dos tablas basándose en una coincidencia explicitada en ON (hace falta alias)
--Natural join: encuentra la coincidencia en todas las filas de dos tablas

select distinct codpie from ventas v
join
(select * from proveedor where ciudad like 'Ma%') p 
on v.codpro=p.codpro; --Ej. 3.15

select distinct codpie from ventas v
join
proveedor p
on v.codpro=p.codpro
where p.ciudad like 'Ma%'; --Otra forma de hacer Ej. 3.15

select distinct codpie from ventas
natural join 
(select * from proveedor where ciudad like 'Ma%'); --Versión usando natural join

--Ej. 3.16
select distinct ciudad, codpie, codpj, codpro from ventas
natural join(
select distinct ciudad, codpro, codpj from proveedor
natural join 
proyecto);  

--Natural join interno: une proveedor y proyecto en ciudad y obtiene codpj y codpro
--Natural join externo: une ventas con el resultado del natural join interno

--Ej. 3.16 usando join on. Más 'seguro' pero más lioso (en mi opinión)
select distinct p.ciudad, v.codpie, v.codpro, v.codpj from ventas v
join 
proveedor p 
on v.codpro = p.codpro
join
proyecto pr 
on v.codpj = pr.codpj
where p.ciudad = pr.ciudad; 

--1er join: junta el campo codpro de ventas con el de proveedor
--2o join: junta el campo codpj de ventas con el de proyecto
--condición where: las ciudades de los proveedores tienen que ser la misma que la de los proveedores

    --Producto cartesiano
    
-- Es una forma menos sofisticada de aplicar un join / natural join

select proveedor.codpro, proyecto.codpj, pieza.codpie
from proveedor, proyecto, pieza, ventas
where proveedor.ciudad = proyecto.ciudad
and proyecto.ciudad = pieza.ciudad
and proveedor.codpro = ventas.codpro
and proyecto.codpj = ventas.codpj
and pieza.codpie = ventas.codpie
and cantidad > 0; --Ej. 3.12 con producto cartesiano

select distinct v.codpro, v.codpj, v.codpie from 
ventas v
join 
proveedor p
on p.codpro = v.codpro
join 
proyecto pr
on pr.codpj = v.codpj
join 
pieza pi
on pi.codpie = v.codpie
where p.ciudad = pr.ciudad and pr.ciudad = pi.ciudad; --Ej. 3.12 con join (haber hecho esto sin chatgpt me convierte en dios del join?)
    
    -- Ordenación (order by)
    
select nompro from proveedor 
order by nompro; --Ordenación alfabética de menor a mayor por defecto

select nompro from proveedor
order by nompro desc; --Contrario a anterior

select cantidad, fecha from ventas
order by cantidad, fecha desc; --Ej. 3.18

---------------------------------------------------------------------------------------------------------------------------------

-- Subconsultas

    -- Operadores: IN, ANY, ALL y comparadores (<;>;<=;>=;<>)
    
-- IN

select codpie from ventas 
where codpro in (
select codpro from proveedor where ciudad like 'Lo%'); --Todas las piezas suministradas por proveedores de Londres

select distinct codpie from ventas 
where codpro in (
select codpro from proveedor where ciudad like 'Mad%') --Ej. 3.19 (Para misma salida q 3.15 usar distinct)
order by codpie; --Ahora puedo usar esto jeje

select codpj from proyecto 
where ciudad in (
select ciudad from pieza);
order by codpj;--Ej. 3.20

select codpj from proyecto pj join pieza pi on pj.ciudad = pi.ciudad order by codpj; --Alternativa usando join (más intuitiva)

select codpj from proyecto where codpj not in (
    select distinct v.codpj from ventas v 
    join pieza p on v.codpie = p.codpie
    join proveedor pr on v.codpro = pr.codpro
    where p.color='Rojo' and pr.ciudad='Londres'
)
order by codpj; --Ej. 3.21

-- ANY / ALL 

--(Ejs muy tontos, ya que solo hay un tornillo en la BD, por ende las salidas son las mismas en ambos casos)
select codpie from pieza where peso > any (select peso from pieza where nompie like 'To%'); --Ejemplo 3.17 (alguna = ANY) más pesada que algún tornillo
select codpie from pieza where peso > all (select peso from pieza where nompie like 'To%'); --Ej. 3.22 (cualquiera = ALL) más pesada que el tornillo más pesado

select * from pieza where peso >= all (select peso from pieza); --Ej 3.23 ; >= para no excluir la mayor. Usando > busca una más pesada que la más pesada (no hay xd)
select p1.nompie, p1.peso, p2.nompie, p2.peso from pieza p1, pieza p2 where p1.peso > p2.peso; --Ej 3.14 (Usa producto cartesiano; el resultado del 3.23 da una salida más limpia)

    --La división (dio mio)
---------------------------------------------------------------------------------------------------------------------------------


--(TENGO QUE ORGANIZAR ESTA PARTE)

--Subconsultas

select codpie from ventas 
group by codpie
having sum(cantidad) > (select sum(cantidad) from ventas where codpie='P1');

select * from ventas where codpro in (select codpro from proveedor where ciudad='Londres' or ciudad='Madrid');

select codpie, nompie from pieza where peso > any (select peso from pieza where nompie='Tornillo')