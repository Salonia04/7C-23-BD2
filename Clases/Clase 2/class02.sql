Clase 2

create database imdb;
use imdb;

create table film (film_id int primary key auto_increment, title varchar(20), description varchar(40), release_year date);

create table actor (actor_id int primary key auto_increment, first_name varchar(20), last_name varchar(20));

create table film_actor (actor_id int, constraint foreign key (actor_id) references actor(actor_id), film_id int, constraint foreign key (film_id) references film(film_id));

alter table film add last_update datetime;
alter table actor add last_update datetime;


