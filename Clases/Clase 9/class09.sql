-- Exercises:

-- 1. Get the amount of cities per country in the database. Sort them by country, country_id.
select co.country, count(ci.city_id) as cities
from country co
inner join city ci on ci.country_id = co.country_id
group by co.country_id; 

-- 2. Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest amount of cities to the lowest
select co.country, count(ci.city_id) as cities
from country co
inner join city ci on ci.country_id = co.country_id
group by co.country_id
having count(ci.city_id) > 10;

-- 3. Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films. Show the ones who spent more money first.
select concat(c.last_name, ' ', c.first_name) as full_name, a.address, (
    select count(*) 
    from rental 
    where customer_id = c.customer_id
) as rented_films, (
    select SUM(p.amount) 
    from rental r
    join payment p on r.rental_id = p.rental_id
    where r.customer_id = c.customer_id
    group by r.customer_id
) as spent_money
from customer c
join address a on c.address_id = a.address_id
group by c.customer_id
order by spent_money desc;

-- 4. Which film categories have the larger film duration (comparing average)? Order by average in descending order
select c.name, avg(f.length) as average_duration
from category c
inner join film_category fc on fc.category_id = c.category_id
inner join film f on f.film_id = fc.film_id
group by c.name
order by average_duration desc;

-- 5. Show sales per film rating
select f.rating, count(r.rental_id) as rentals, sum(p.amount) as total_sales
from film f
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
inner join payment p on r.rental_id = p.rental_id
group by f.rating;