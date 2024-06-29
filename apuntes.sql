////////////////////////////
//Pedro Velasco Santana   //
//2D - 2024               //
////////////////////////////

//NOTA: muchas de las creaciones y borrados no se pueden realmente usar, debido a que usan tablas inventadas

//<ctrl + enter> para ejecutar las líneas seleccionadas

describe ventas; 
describe proyecto;
describe proveedor; 
describe pieza;

select table_name from user_tables; --Para ver las tablas en tu usuario

//Tablas: creación, inserción de datos, borrado 

    //Creación

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

    //Borrado
    
drop table plantilla;

    //Modificación esquema tabla
    
add plantilla fechabaja date; --(Ej 1.5)

    //Ejercicios adicionales capitulo 1
    
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

    //Inserción de tuplas
    
insert into plantilla (dni, nombre, estadocivil, fechaalta)
    values ('123456789S', 'Cabrerizo', 'casado', sysdate);

insert into plantilla select * from trabajadores; --Insertar a partir de otra tabla

    //Modificación de datos

update plantilla 
set estadocivil='divorciado'
where nombre='Cabrerizo'; --Joder....

    //Borrado de tuplas
    
delete from plantilla where nombre='Cabrerizo';
delete from plantilla; --Borrado de todas las tuplas

//Consultas básicas

//(A partir de aquí empiezo a usar las tablas presentes en el cuadernillo)

select * from ventas; --Mostrar toda la tabla ventas
select codpro from ventas; --Mostrar codpro de ventas
select distinct codpro from ventas; --Consulta anterior sin repetir valores repetidos
select * from ventas where codpro='S1;' --Ventas realizadas por el proveedor S1
select * from pieza where ciudad='Madrid' and (color='Rojo' or color='Gris'); --Ej. 3.3
select codpie from ventas where cantidad between 200 and 300; --Ej. 3.4
select * from pieza where nompie like 'to%' or nompie like 'To%'; -- Ej. 3.5

//Consultas multitabla / consultas de union

    //Unión externa: union / union all / intersect / minus
    
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

//(TENGO QUE ORGANIZAR ESTA PARTE)

//Consultas multitabla (Join)

select nompro, cantidad from proveedor
natural join (select * from ventas where cantidad > 800);

select nompro, cantidad from proveedor p
join (select * from ventas where cantidad > 800) v on p.codpro=v.codpro; 

select codpie from ventas v
join (select * from proveedor where ciudad = 'Madrid') p on v.codpro=p.codpro
order by codpie asc;

select codpie from ventas v
join proveedor p on v.codpro=p.codpro
where p.ciudad='Madrid'
order by codpie asc;

//Subconsultas

select codpie from ventas 
group by codpie
having sum(cantidad) > (select sum(cantidad) from ventas where codpie='P1');

select * from ventas where codpro in (select codpro from proveedor where ciudad='Londres' or ciudad='Madrid');

select codpie, nompie from pieza where peso > any (select peso from pieza where nompie='Tornillo')