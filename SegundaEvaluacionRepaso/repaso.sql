/* REPASO PARA LA SEGUNDA EVALUACION */

/* CLASE 6 ------------------------------------------------------------------------------------ */

-- finding the max
SELECT f1.title,f1.length
FROM film f1 
WHERE NOT EXISTS (
    SELECT * 
    FROM film f2 
    WHERE f2.`length` > f1.`length`
); 

SELECT f1.title,f1.length 
FROM film f1 
WHERE length >= ALL (
    SELECT f2.length
    FROM film f2 
)
; 

-- List all the actors that share the last name. Show them in order
select concat(a1.first_name, ' ',a1.last_name)
from actor a1
where exists (
    select * 
    from actor a2
    where a1.last_name = a2.last_name
    and a1.actor_id <> a2.actor_id
)
order by a1.last_name;

-- Find actors that don't work in any film
select concat(a.first_name, ' ',a.last_name)
from actor a
where a.actor_id not in (
    select fa2.actor_id
    from film_actor fa2
)
;

-- Find customers that rented only one film
select concat(c.first_name, ' ',c.last_name) as customer
from customer c
where customer_id in (
    select customer_id
    from rental
    group by customer_id
    having count(*) = 1
)
;

-- Find customers that rented more than one film
select concat(c.first_name, ' ',c.last_name) as customer
from customer c
where customer_id in (
    select customer_id
    from rental
    group by customer_id
    having count(*) > 1
)
;

-- List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
select concat(a.first_name, ' ',a.last_name) as full_name
from actor a 
where a.actor_id in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id
        from film
        where title = 'BETRAYED REAR'
        or title = 'CATCH AMISTAD'
    )
)
;

-- List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
select concat(a.first_name, ' ',a.last_name) as full_name
from actor a 
where a.actor_id in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id
        from film
        where title = 'BETRAYED REAR'
    )
)
and a.actor_id not in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id
        from film
        where title = 'CATCH AMISTAD'
    )
)
;

-- List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
select concat(a.first_name, ' ',a.last_name) as full_name
from actor a 
where a.actor_id in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id
        from film
        where title = 'BETRAYED REAR'
    )
)
and a.actor_id in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id
        from film
        where title = 'CATCH AMISTAD'
    )
)
;

-- List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
select concat(a.first_name, ' ',a.last_name) as full_name
from actor a 
where a.actor_id not in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id
        from film
        where title = 'BETRAYED REAR'
    )
)
and a.actor_id not in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id
        from film
        where title = 'CATCH AMISTAD'
    )
)
;

/* CLASE 7 ------------------------------------------------------------------------------------ */

-- Find the films with less duration, show the title and rating.
select title, rating, length
from film
where length <= all (
    select length
    from film
)
order by length
;

-- Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
select f.title, f.rating, f.length
from film f
where f.length <= all (
    select length
    from film
)
and not exists (
    select * 
    from film as f2 
    where f2.film_id <> f.film_id 
    AND f2.length <= f.length
    )
;

-- Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
select concat(c.first_name, ' ',c.last_name) as customer, p.amount, a.address
from customer c
inner join payment p on p.customer_id = c.customer_id
inner join address a on a.address_id = c.address_id
where p.amount <= all (
    select amount
    from payment
    where customer_id = c.customer_id
) 
group by customer, p.amount, a.address
;

select concat(c.first_name, ' ',c.last_name) as customer, min(p.amount), a.address
from customer c
inner join payment p on p.customer_id = c.customer_id
inner join address a on a.address_id = c.address_id
group by customer, a.address
;

-- Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.
select concat(c.first_name, ' ',c.last_name) as customer, max(p.amount) as max, min(p.amount) as min
from customer c
inner join payment p on p.customer_id = c.customer_id
group by customer
;

/* CLASE 9 ------------------------------------------------------------------------------------ */

-- Get the amount of cities per country in the database. Sort them by country, country_id.
select co.country_id, co.country, count(ci.city_id) as cities
from city ci 
inner join country co on co.country_id = ci.country_id
group by co.country_id, co.country
order by co.country_id;

select ci.city, co.country
from city ci 
inner join country co on co.country_id = ci.country_id
where co.country = "Argentina";

-- Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest amount of cities to the lowest
select co.country_id, co.country, count(ci.city_id) as cities
from city ci 
inner join country co on co.country_id = ci.country_id
group by co.country_id, co.country
having count(ci.city) > 10
order by co.country_id;

-- Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films.
--     Show the ones who spent more money first .
select concat(c.first_name, ' ', c.last_name) as full_name, a.address, count(r.rental_id) as total_rented, sum(p.amount) as amount
from customer c
inner join address a on a.address_id = c.address_id
inner join rental r on r.customer_id = c.customer_id
inner join payment p on p.rental_id = r.rental_id
group by full_name, a.address;

select concat(c.first_name, ' ', c.last_name) as full_name, a.address, (
    select count(r.rental_id)
    from rental r
    where r.customer_id = c.customer_id
) as rented_films, (
    select sum(p.amount) as money_spent
    from payment p
    where p.customer_id = c.customer_id
) as amount
from customer c
inner join address a on a.address_id = c.address_id
group by c.customer_id
order by amount desc;

-- Which film categories have the larger film duration (comparing average)?
--     Order by average in descending order
select ca.name, avg(f.length) as average_duration
from category ca
inner join film_category fca on fca.category_id = ca.category_id
inner join film f on f.film_id = fca.film_id
group by ca.name
order by average_duration desc;

-- Show sales per film rating
select f.rating, count(r.rental_id) as sales, sum(p.amount) as total
from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
group by f.rating;

/* CLASE 11 ------------------------------------------------------------------------------------ */

-- Find all the film titles that are not in the inventory.
select f.title
from film f
inner join inventory i on i.film_id = f.film_id
where i.inventory_id is null;

-- Find all the films that are in the inventory but were never rented.
--     Show title and inventory_id.
--     This exercise is complicated.
--     hint: use sub-queries in FROM and in WHERE or use left join and ask if one of the fields is null
select f.title, i.inventory_id
from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
where exists(
    select i2.film_id
    from inventory i2
    where i2.film_id = f.film_id
    and not exists (
        select r2.rental_date
        from rental r2
        where r2.inventory_id = i2.inventory_id
    )
)
group by f.title, i.inventory_id;

-- Generate a report with:
--     customer (first, last) name, store id, film title,
--     when the film was rented and returned for each of these customers
--     order by store_id, customer last_name
select concat(c.first_name, ' ', c.last_name) as full_name, s.store_id, group_concat(f.title) as film
from customer c
inner join store s on s.store_id = c.store_id
inner join inventory i on i.store_id = s.store_id
inner join film f on f.film_id = i.film_id
where exists(
    select r.customer_id 
    from rental r 
    where c.customer_id = r.customer_id 
    and r.return_date is not null
    )
group by full_name, s.store_id
order by store_id, full_name asc
limit 10;


-- Show sales per store (money of rented films)
--     show store's city, country, manager info and total sales (money)
--     (optional) Use concat to show city and country and manager first and last name
select s.store_id, concat(ci.city, ' - ', co.country) as map, count(p.amount) as quantity, sum(p.amount) as amount
from store s 
inner join inventory i on i.store_id = s.store_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
inner join address a on a.address_id = s.address_id
inner join city ci on ci.city_id = a.city_id
inner join country co on co.country_id = ci.country_id
group by s.store_id, map;

-- Which actor has appeared in the most films?
select concat(a.first_name, ' ', a.last_name) as full_name, count(*) as total
from actor a
inner join film_actor fa on fa.actor_id = a.actor_id
inner join film f on f.film_id = fa.film_id
group by full_name
order by total desc
limit 1;

/* CLASE 13 ------------------------------------------------------------------------------------ */

-- Add a new customer
--     To store 1
--     For address use an existing address. The one that has the biggest address_id in 'United States'
insert into customer (store_id, first_name, last_name, email, address_id, active, create_date, last_update)
select 1, 'Angel', 'Di Maria', 'fideoadm11@gmail.com', MAX(a.address_id), 1, now(), now()
from address a
where a.city_id in (
    select ci.city_id
	from city ci
	where ci.country_id in(
        select co.country_id
        from country co
        where co.country = "United States"
    )
);
		
select *
from customer
where last_name = "Di Maria";

-- Add a rental
--     Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
--     Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
--     Select any staff_id from Store 2.
insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id)
select CURRENT_DATE,
(
    select max(i.inventory_id)
    from inventory i
    inner join film f on f.film_id = i.film_id
    where f.title = "ZORRO ARK"
),
200,
null,
(
    select sta.staff_id
    from staff sta
    where sta.staff_id in (
        select sto.store_id
        from store sto
        where sto.store_id = 2
    )
);


-- Update film year based on the rating
--     For example if rating is 'G' release date will be '2001'
--     You can choose the mapping between rating and year.
--     Write as many statements are needed.
update film
set release_year = "2001"
where rating = "G";

-- Return a film
--     Write the necessary statements and queries for the following steps.
--     Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
--     Use the id to return the film.
select f.film_id, f.title, r.rental_id, r.rental_date, r.return_date
from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
where r.rental_date is not null
and r.return_date is null
order by r.rental_date desc
limit 1;

update rental
set return_date = now()
where rental_id = 16061;

-- Try to delete a film
--     Check what happens, describe what to do.
--     Write all the necessary delete statements to entirely remove the film from the DB.
delete from film
where title = "SPOILERS HELLFIGHTERS";

-- Rent a film
--     Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
--     Add a rental entry
--     Add a payment entry
--     Use sub-queries for everything, except for the inventory id that can be used directly in the queries.


/* CLASE 14 ------------------------------------------------------------------------------------ */

-- Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.
select concat(c.first_name, ' ', c.last_name) as full_name, concat(ci.city, ', ', co.country) as map
from customer c
inner join address a on a.address_id = c.address_id
inner join city ci on ci.city_id = a.city_id
inner join country co on co.country_id = ci.country_id
where co.country = "Argentina"
group by full_name, map;

-- Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.
select f.title, l.name, f.rating,
case
    when rating = 'G' then 'All Ages Are Admitted.'
    when rating = 'PG' then 'Some Material May Not Be Suitable For Children.'
    when rating = 'PG-13' then 'Some Material May Be Inappropriate For Children Under 13.'
    when rating = 'R' then 'Under 17 Requires Accompanying Parent Or Adult Guardian.'
    when rating = 'NC-17' then 'No One 17 and Under Admitted.'
end as rating_description
from film f
inner join language l on l.language_id = f.language_id
group by f.title, l.name, f.rating, rating_description;

-- Write a search query that shows all the films (title and release year) an actor was part of. Assume the actor comes from a text box introduced by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.
select f.title
from film f
inner join film_actor fa on fa.film_id = f.film_id
inner join actor a on a.actor_id = fa.actor_id
where concat(a.first_name, ' ', a.last_name) like trim(upper("Ed cHAse"));

-- Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. There should be returned column with two possible values 'Yes' and 'No'.
select f.title, concat(c.first_name, ' ', c.last_name) as full_name, r.rental_id, r.rental_date
from rental r 
inner join customer c on c.customer_id = r.customer_id
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on f.film_id = i.film_id
where MONTHNAME(r.rental_date) like "May"
or MONTHNAME(r.rental_date like "June")
group by f.title, full_name, r.rental_id, r.rental_date;

-- Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.
-

-- Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. Which ones are not in MySql and write usage examples.
-

/* CLASE 15 ------------------------------------------------------------------------------------ */
/* VIEWS */

-- Create a view named list_of_customers, it should contain the following columns:
-- customer id
-- customer full name,
-- address
-- zip code
-- phone
-- city
-- country
-- status (when active column is 1 show it as 'active', otherwise is 'inactive')
-- store id
create or replace view list_of_customers as
select 
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as full_name,
    a.address,
    a.postal_code as zip_code,
    a.phone,
    ci.city,
    co.country,
    case 
        when c.active then 'Active' 
        else 'Inactive' 
    end as status,
    s.store_id
from customer c 
inner join store s on s.store_id = c.store_id
inner join address a on a.address_id = c.address_id
inner join city ci on ci.city_id = a.city_id
inner join country co on co.country_id = ci.country_id;

select * from list_of_customers;

-- Create a view named film_details, it should contain the following columns: film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT
create or replace view film_details as
select
    f.film_id,
    f.title,
    f.description,
    c.name,
    f.replacement_cost,
    f.length,
    f.rating,
    group_concat(a.last_name separator ', ') as actors
from film f 
inner join film_category fc on fc.film_id = f.film_id
inner join category c on c.category_id = fc.category_id
inner join film_actor fa on fa.film_id = f.film_id 
inner join actor a on a.actor_id = fa.actor_id
group by 
    f.film_id,
    f.title,
    f.description,
    c.name,
    f.replacement_cost,
    f.length,
    f.rating
;

select * from film_details;

-- Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.


-- Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
create or replace view actor_information as
select
    a.actor_id,
    concat(a.first_name, ' ', a.last_name) as actor,
    count(f.film_id) as total_films
from actor a 
inner join film_actor fa on fa.actor_id = a.actor_id
inner join film f on f.film_id = fa.film_id
group by a.actor_id, actor;

select * from actor_information;

-- Analyze view actor_info, explain the entire query and specially how the sub query works. Be very specific, take some time and decompose each part and give an explanation for each.


-- Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.



