mysql> create database imdb;
Query OK, 1 row affected (0,07 sec)

mysql> use imdb;
Database changed
mysql> create table film (film_id int primary key auto_increment, title va
rchar(20), description varchar(40), release_year date);
Query OK, 0 rows affected (0,48 sec)

mysql> create table actor (actor_id int primary key auto_increment, first_
name varchar(20), last_name varchar(20));
Query OK, 0 rows affected (0,42 sec)

mysql> create table film_actor (actor_id int, constraint foreign key (actor_id) references actor(actor_id), film_id int, constraint foreign key (film_id) references film(film_id));
Query OK, 0 rows affected (1,03 sec)

mysql> alter table film add last_update datetime;
Query OK, 0 rows affected (0,34 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> alter table actor add last_update datetime;
Query OK, 0 rows affected (0,54 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> insert into actor (first_name, last_name) values ("Jenna", "Ortega");
Query OK, 1 row affected (0,09 sec)

mysql> insert into actor (first_name, last_name) values ("Dwayne", "Johnson");
Query OK, 1 row affected (0,24 sec)

mysql> insert into actor (first_name, last_name) values ("Daisy", "Ridley");
Query OK, 1 row affected (0,18 sec)

mysql> insert into actor (first_name, last_name) values ("Hayden", "Christensen");
Query OK, 1 row affected (0,07 sec)

mysql> insert into film (title, description, release_year) values ("Wednesday", "Mystery series", "2022");
ERROR 1292 (22007): Incorrect date value: '2022' for column 'release_year' at row 1
mysql> insert into film (title, description, release_year) values ("Wednesday", "Mystery series", 2022-11-23);
ERROR 1292 (22007): Incorrect date value: '1988' for column 'release_year' at row 1
mysql> insert into film (title, description, release_year) values ("Wednesday", "Mystery series", "2022-11-23");
Query OK, 1 row affected (0,11 sec)

mysql> insert into film (title, description, release_year) values ("Star Wars", "Science fiction", "1977-12-25");
Query OK, 1 row affected (0,23 sec)

mysql> insert into film (title, description, release_year) values ("Jumanji", "Adventure", "1996-7-11");
Query OK, 1 row affected (0,06 sec)

mysql> select * from actor;
+----------+------------+-------------+-------------+
| actor_id | first_name | last_name   | last_update |
+----------+------------+-------------+-------------+
|        1 | Jenna      | Ortega      | NULL        |
|        2 | Dwayne     | Johnson     | NULL        |
|        3 | Daisy      | Ridley      | NULL        |
|        4 | Hayden     | Christensen | NULL        |
+----------+------------+-------------+-------------+
4 rows in set (0,00 sec)

mysql> select * from film;
+---------+-----------+-----------------+--------------+-------------+
| film_id | title     | description     | release_year | last_update |
+---------+-----------+-----------------+--------------+-------------+
|       1 | Wednesday | Mystery series  | 2022-11-23   | NULL        |
|       2 | Star Wars | Science fiction | 1977-12-25   | NULL        |
|       3 | Jumanji   | Adventure       | 1996-07-11   | NULL        |
+---------+-----------+-----------------+--------------+-------------+
3 rows in set (0,00 sec)

mysql> insert into film_actor (actor_id, film_id) values ("1","1");
Query OK, 1 row affected (0,07 sec)

mysql> insert into film_actor (actor_id, film_id) values ("2","3");
Query OK, 1 row affected (0,09 sec)

mysql> insert into film_actor (actor_id, film_id) values ("3","2");
Query OK, 1 row affected (0,07 sec)

mysql> insert into film_actor (actor_id, film_id) values ("4","2");
Query OK, 1 row affected (0,08 sec)

mysql> 

