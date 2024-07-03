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
    
--Es una forma menos sofisticada de aplicar un join / natural join

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

    -- La división (perdón por tantos comentarios, no es fácil de entender sin ellos jajasjd)
    
--La división es una operación que permite encontrar registros que están relacionados con todos los registros de otro conjunto.

--Aproximación mixta (en mi opinión la más fácil)
--El objetivo es obtener un conjunto vacío formado por un conjunto general (sustraendo) y otro específico (minuendo)

/*
Ejemplo

Compara el conjunto de todas las piezas con las piezas suministradas por el proveedor actual. 
Si el resultado es vacío, el proveedor ha suministrado todas las piezas.
*/

select codpro from proveedor where not exists ( --Cuando la subconsulta devuelva conjunto vacío, hemos encontrado la solución
select distinct codpie from pieza --Conjunto con todos los códigos de piezas

minus --Menos 

select distinct codpie from ventas where proveedor.codpro = ventas.codpro --Conjunto que relaciona los codpro con codpie
);

--Consulta equivalente a sustraendo de la división (sirve pa sacar la solución "a mano"):
select distinct v.codpie, v.codpro from ventas v join proveedor p on p.codpro = v.codpro;

/*
Ejercicio 3.24

Compara el conjunto de todos los proyectos en Londres con los proyectos a los que se ha suministrado la pieza actual. 
Si el resultado es vacío, la pieza ha sido suministrada a todos los proyectos en Londres.
*/

select codpie from pieza where not exists ( 
select distinct pr.codpj from proyecto pr where pr.ciudad like 'Lo%' --Todos los proyectos de Londres (C. específica)

minus --Menos

select distinct v.codpj from ventas v where v.codpie = pieza.codpie --Todos los proyectos a los que se ha suministrado una pieza (C. general)
); 

--Consulta equivalente a sustraendo de la división:
select distinct v.codpj, v.codpie from ventas v join proyecto p on p.codpj = v.codpj order by codpj, codpie;

/*
Ejercicio 3.25

Compara el conjunto de todos las piezas procedentes de una ciudad donde hay un proyecto con todas 
las piezas suministradas por el proveedor actual.
Si el resultado es vacío, todas las piezas del primer conjunto han sido proveídas por el proveedor
(joe vaya juego d palabras)
*/

select codpro from proveedor where not exists(
select pi.codpie from pieza pi join proyecto pr on pi.ciudad = pr.ciudad --Todas las piezas procedentes de una ciudad donde hay un proyecto (C. específico)

minus --Menos

select v.codpie from ventas v where v.codpro = proveedor.codpro --Todos las las piezas suministradas por un proveedor (C. general)
);

--Consulta equivalente a sustraendo de la división:
select distinct v.codpro, v.codpie from ventas v join proveedor pr on v.codpro = pr.codpro order by codpro;

---------------------------------------------------------------------------------------------------------------------------------

-- Funciones de agregación

    --Pequeña intro y ejs: sum(), min(), max(), avg() y count()
    
select max(cantidad) as maximo, min(cantidad) as minimo, sum(cantidad) as suma from ventas; --Muy útil usar renombramiento (alias)

select max(distinct cantidad) as maximo, min(distinct cantidad) as minimo, sum(distinct cantidad) as suma from ventas; --El valor 'suma' es distinto, ya que no se tienen en cuenta repes

select count(*) as suma from ventas where cantidad > 1000; --Ej. 3.26

select max(peso) from pieza; --Ej. 3.27

select codpie from pieza where peso = (select max(peso) from pieza); --Ej. 3.28 (La solución es bastante similar al 3.23) 

select distinct codpro from ventas v1 where (
select count(distinct fecha) from ventas v2 where v2.codpro = v1.codpro --Hay que hacer que las tuplas sean coincidentes para obtener el resultado
) > 3; --Ej. 3.30 (haciendo grupos, mucho más easy)

    --Formar grupos: group by y having
    
--Formar un grupo es organizar los datos en función de algún atributo.
--'Having' funciona para el filtrado, de forma similar a 'where' pero para el grupo

select codpro, count(*) as num_tuplas, max(cantidad) as max_cantidad from ventas
group by codpro
order by codpro;

--La consulta anterior nos da, para cada codpro: su número de tuplas y su cantidad máxima de ventas.

select codpie, avg(cantidad) as media from ventas
group by codpie
order by codpie; --Ej. 3.31

select codpro, avg(cantidad) as media from ventas where codpie = 'P1'
group by codpro
order by codpro; --Ej. 3.32

select codpj, sum(cantidad) as total from ventas
group by codpj
order by codpj; --Ej. 3.33

select distinct codpro from ventas
group by codpro
having count(distinct fecha) > 3; --Ej. 3.30 usando grupos y having

--Media de ventas de la pieza P1 por los proveedores que tienen entre 2 y 10 ventas de la misma
select codpro, codpie, avg(cantidad) as media from ventas where codpie = 'P1'
group by codpro, codpie
having count(*) between 2 and 10;

select p.nompro, p.codpro, sum(cantidad) as total from ventas v, proveedor p
where p.codpro = v.codpro
group by p.nompro, p.codpro
having sum(cantidad) > 1000
order by codpro; --Ej. 3.35

select codpie, sum(cantidad) from ventas
group by codpie
having sum(cantidad) = (select max(sum(v.cantidad)) from ventas v group by v.codpie); --Ej. 3.36

-- Y podrá uno pensar q si no se puede hacer:

select codpie, max(sum(cantidad) from ventas group by codpie;

-- Pues sql no lo permite, max(sum()) debe ir en una subconsulta de having porq mola

---------------------------------------------------------------------------------------------------------------------------------

--Ejercicios adicionales capítulo 3

--Ej. 3.42
select codpro, sum(cantidad) from ventas
group by codpro
having sum(cantidad) > (select sum(cantidad) from ventas where codpro = 'S1'); 

--Ej. 3.43 (El enunciado es un poco ambiguo)
select codpro, sum(cantidad) from ventas
group by codpro
order by sum(cantidad) desc; --Ej. 3.43 (El enunciado es un poco ambiguo)

--Ej. 3.44
select codpro from proveedor where not exists (
select pj.ciudad from proyecto pj join ventas v on pj.codpj = v.codpj where v.codpro = 'S3' --Todas las ciudades a las cuales suministra S3

minus

select pj.ciudad from proyecto pj join ventas v on pj.codpj = v.codpj where v.codpro = proveedor.codpro --CIudades a donde suministra el proveedor actual
) and codpro <> 'S3'; 

--(Para comparar resultados)
select codpro, codpie, v.codpj, pj.ciudad from ventas v join proyecto pj on v.codpj = pj.codpj
order by codpro, codpie;







