////////////////////////////
//Pedro Velasco Santana   //
//2D - 2024               //
////////////////////////////

describe ventas;
describe proyecto;
describe proveedor; 
describe pieza;

select table_name from user_tables

//Tablas: creación, inserción de datos, borrado 

    //Creación

create table plantilla(
    dni varchar2(9) unique, --Los valores deberán ser únicos
    nombre varchar2(20),
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