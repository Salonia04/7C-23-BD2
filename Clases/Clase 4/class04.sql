--CLASE 4--

--1. Show title and special_features of films that are PG-13;--
select title as Titulo, special_features as TAG
from film F 
where rating = 'PG-13';

--2. Get a list of all the different films duration;--
select distinct length as Duracion 
from film F 
order by length asc;

--3. Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00;--
select f.title as Titulo, f.rental_rate as Renta, f.replacement_cost as Multa 
from film f 
where replacement_cost between 20.00 AND 24.00;

--4. Show title, category and rating of films that have 'Behind the Scenes' as special_features;--
select f.title as Titulo, c.name as Categoria, f.rating
from film f
inner join film_category fc on f.film_id = fc.film_id 
inner join category c on fc.category_id = c.category_id 
where special_features like '%Behind the Scenes%';

--5. Show first name and last name of actors that acted in 'ZOOLANDER FICTION';--
select concat(a.first_name, ' ', a.last_name) as Nombre_completo, f.title as Titulo
from actor a 
inner join film_actor fa on a.actor_id = fa.actor_id 
inner join film f on f.film_id = fa.film_id 
where f.title = 'ZOOLANDER FICTION'
order by a.first_name;

--6. Show the address, city and country of the store with id 1;--
select s.store_id, a.address, ci.city as Ciudad, co.country as Pais
from store s 
inner join address a on s.address_id = a.address_id 
inner join city ci on a.city_id = ci.city_id 
inner join country co on ci.country_id = co.country_id 
where s.store_id = 1;

--7. Show pair of film titles and rating of films that have the same rating.--

--8. Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).-- 
select distinct f.film_id, f.title as Pelicula, s.store_id as Tienda, concat(m.first_name, ' ', m.last_name) AS Manager
from inventory i 
inner join film f on i.film_id = f.film_id
inner join store s on i.store_id = s.store_id
inner join staff m on s.manager_staff_id = m.staff_id
where s.store_id = 2;