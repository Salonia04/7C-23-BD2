mysql> show databases;
+-------------------------+
| Database                |
+-------------------------+
| Evaluacion_Supermercado |
| Shows                   |
| UBP                     |
| VIVERO_FENIX            |
| VilladaApp              |
| information_schema      |
| mysql                   |
| northwind               |
| performance_schema      |
| sys                     |
+-------------------------+
10 rows in set (0,02 sec)

mysql> create database Gym;
Query OK, 1 row affected (0,19 sec)

mysql> use Gym;
Database changed
mysql> create table Socio (dni int primary key auto_increment, nombre varchar(20), apellido varchar(20), edad int)
    -> create table Socio (dni int primary key auto_increment, nombre varchar(20), apellido varchar(20), edad int);
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'create table Socio (dni int primary key auto_increment, nombre varchar(20), apel' at line 2
mysql> create table Socio (dni int primary key auto_increment, nombre varchar(20), apellido varchar(20), edad int);
Query OK, 0 rows affected (0,40 sec)

mysql> show tables;
+---------------+
| Tables_in_Gym |
+---------------+
| Socio         |
+---------------+
1 row in set (0,00 sec)

mysql> delete table Socio;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'table Socio' at line 1
mysql> DROP TABLE IF EXISTS Socio;
Query OK, 0 rows affected (0,25 sec)

mysql> create table Socio (dni int primary key, nombre varchar(20), apelli
do varchar(20), edad int);
Query OK, 0 rows affected (0,31 sec)

mysql> create table Plan (id int primary key auto_increment, nombre varchar(20), fechaInicial date, fechaLimite date, estado varchar(15), tipoDePlan, socios_Socio int, constraint foreign key (socios_Socio) references Socio(dni));
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ', socios_Socio int, constraint foreign key (socios_Socio) references Socio(dni))' at line 1
mysql> create table Plan (id int primary key auto_increment, nombre varchar(20), fechaInicial date, fechaLimite date, estado varchar(15), tipoDePlan varchar(30), socios_Socio int, constraint foreign key (socios_Socio) refe
rences Socio(dni));
Query OK, 0 rows affected (0,41 sec)

mysql> create table Sesion (id int primary key auto_increment, nombre varchar(20), repeticiones int, series int, notas varchar(40), plan_Plan int, constraint foreign key (plan_Plan) references Plan(id));
Query OK, 0 rows affected (0,50 sec)

mysql> create table Registro (id int primary key auto_increment, fecha date, observaciones varchar(40), peso int, repeticionesLogradas int, seriesLogradas int, sesion_Sesion int, constraint foreign key (sesion_Sesion) references Sesion(id));
Query OK, 0 rows affected (0,40 sec)

mysql> create table Dia (id int primary key auto_increment, descripcion varchar(30));
Query OK, 0 rows affected (0,30 sec)

mysql> create table Sede (id primary key auto_increment, socios_Socio int, constraint foreign key (socios_Socio) references Socio(dni), dias_Dia int, constraint foreign key (dias_Dia) references Dia(id));
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'primary key auto_increment, socios_Socio int, constraint foreign key (socios_Soc' at line 1
mysql> create table Sede (id primary key auto_increment, socios_Socio int, dias_Dia int, constraint foreign key (socios_Socio) references Socio(dni)
, constraint foreign key (dias_Dia) references Dia(id));
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'primary key auto_increment, socios_Socio int, dias_Dia int, constraint foreign k' at line 1
mysql> create table Sede (id int primary key auto_increment, socios_Socio
int, dias_Dia int, constraint foreign key (socios_Socio) references Socio(dni), constraint foreign key (dias_Dia) references Dia(id));
Query OK, 0 rows affected (0,51 sec)

mysql> create table tipoDeClase (id int primary key auto_increment, nombre varchar(20), descripcion varchar(40));
Query OK, 0 rows affected (0,69 sec)

mysql> create table Clase (id int primary key auto_increment, nombre varchar(20), limite int, horarioInicio datetime, horarioFin datetime, tipo_tipoDeClase int, constraint foreign key (tipo_tipoDeClase) references tipoDeClase(id));
Query OK, 0 rows affected (0,68 sec)

mysql> create table Dia_Clase (id int primary key auto_increment, dias_Dia int, constraint foreign key (dias_Dia) references Dia(id), clases_Clase int, constraint foreign key (clases_Clase) references Clase(id));
Query OK, 0 rows affected (3,53 sec)

mysql> create table Reserva (id int primary key auto_increment, socios_Socio int, constraint foreign key (socios_Socio) references Socio(dni), clase
s_Clase int, constraint foreign key (clases_Clase) references Clase(id));
Query OK, 0 rows affected (2,68 sec)

mysql> select * from Sede;
Empty set (0,01 sec)

mysql> select * from Sede and Clase;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'and Clase' at line 1
mysql> 

