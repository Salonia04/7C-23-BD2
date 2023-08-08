-- 1. Add a new customer

      -- To store 1
      -- For address use an existing address. The one that has the biggest address_id in 'United States'

-- Agarro las columnas que quiero dek customer
insert into customer
(store_id, first_name, last_name, email, address_id, active)
-- Pongo la store 1 (por la act.) y creo al cliente
select 1, 'Luka', 'Modric', 'lukamodric10@gmail.com', MAX(a.address_id), 1
from address a
-- La mayor id del pais Estados Unidos
where (select c.country_id
		from country c, city c1
		where c.country = "United States"
		and c.country_id = c1.country_id
		and c1.city_id = a.city_id);
		
select *
from customer
where last_name = "Modric";

-- 2. Add a rental

      -- Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
      -- Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
      -- select any staff_id from Store 2.

-- Agarro las columnas que quiero de rental
insert into rental
(rental_date, inventory_id, customer_id, return_date, staff_id)
select CURRENT_TIMESTAMP, 
		(select MAX(i.inventory_id)
		 from inventory i
		 inner join film f on f.film_id = i.film_id
		 where f.title = "ZORRO ARK" -- Seleccionas la peli que queres
		 limit 1), 
		 600, -- Put user here (in this case is the previous one insterted in excersise 1
		 null,
		 (select x.staff_id
		  from staff x
		  inner join store s on s.store_id = x.store_id
		  where s.store_id = 2
		  limit 1);
-- CURRENT_TIMESTAMP == fecha y hora local

-- 3. update film year based on the rating

      -- For example if rating is 'G' release date will be '2001'
      -- You can choose the mapping between rating and year.
      -- Write as many statements are needed.

update film
set release_year = '2001' -- Seteamos la columna a como la queremos modificar
where rating = "G"; -- ¿Donde? Donde le digamos donde

update film
set release_year = '1977'
where rating = "PG-13";

update film
set release_year = '1980'
where rating = "PG";

update film
set release_year = '1983'
where rating = "R";

update film
set release_year = '1998'
where rating = "NC-17";

-- 4. Return a film

      -- Write the necessary statements and queries for the following steps.
      -- Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
      -- Use the id to return the film.

select rental_id, rental_rate, customer_id, staff_id
from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id -- me voy hasta rental
where r.return_date is null -- busco la fecha null (debido a q si no tiene fecha de vuelta, no la devolvieron)
limit 1; -- quiero una sola

-- con la id que me da, seteo la fecha de devolucion para decir q esta devuelta
update rental
set return_date = CURRENT_TIMESTAMP
where rental_id = 11496;

-- 5. Try to delete a film

    -- Check what happens, describe what to do.
    -- Write all the necessary delete statements to entirely remove the film from the DB.

-- eliminas de todos lados la peli de id 1
delete from payment
-- en rental
where rental_id in (select rental_id 
                    from rental
                    inner join inventory using (inventory_id) 
                    where film_id = 1);
delete from rental
-- en el inventario
where inventory_id in (select inventory_id 
                       from inventory
                       where film_id = 1);                    
delete from inventory where film_id = 1;
-- de film-actor
delete film_actor from film_actor where film_id = 1;
-- de film-category
delete film_category from film_category where film_id = 1;
-- de film
delete film from film where film_id = 1;

-- 6. Rent a film

      -- Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
      -- Add a rental entry
      -- Add a payment entry
      -- Use sub-queries for everything, except for the inventory id that can be used directly in the queries.

select inventory_id, film_id
from inventory
-- busco las pelis q estan disponibles (las q tienen fecha de devuelta)
where inventory_id not in (select inventory_id
                           from inventory
	                       inner join rental using (inventory_id)
	                       where return_date is null)
-- voy a rental e inserto una nueva rental con los valores que quiero
insert into rental
(rental_date, inventory_id, customer_id, staff_id)
values(
CURRENT_DATE(),
10,
(select customer_id from customer order by customer_id DESC limit 1),
(select staff_id from staff where store_id = (select store_id from inventory where inventory_id = 10))
);
insert into payment
(customer_id, staff_id, rental_id, amount, payment_date)
values(
(select customer_id from customer order by customer_id DESC limit 1),
(select staff_id from staff limit 1),
(select rental_id from rental order by rental_id DESC limit 1) ,
(select rental_rate from film where film_id = 2),
CURRENT_DATE());
-- tengo peli rentada :D