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

/* CLASE 8 ------------------------------------------------------------------------------------ */

-- Get the amount of cities per country in the database. Sort them by country, country_id.


-- Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest amount of cities to the lowest


-- Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films.
--     Show the ones who spent more money first .


-- Which film categories have the larger film duration (comparing average)?
--     Order by average in descending order


-- Show sales per film rating

