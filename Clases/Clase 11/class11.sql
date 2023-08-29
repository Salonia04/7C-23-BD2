-- 1. Find all the film titles that are not in the inventory.
select f.title
from film f
inner join inventory i on i.film_id = f.film_id
group by f.title
order by f.title asc;

-- 2. Find all the films that are in the inventory but were never rented.
    -- Show title and inventory_id.
    -- This exercise is complicated.
    -- hint: use sub-queries in FROM and in WHERE or use left join and ask if one of the fields is null
select f.title, i.inventory_id
from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
where exists(
    select i.film_id
    from inventory i
    where i.film_id = f.film_id
    and not exists(
        select r.inventory_id 
        from rental r 
        where r.inventory_id = i.inventory_id
    )
    )
    group by f.title, i.inventory_id;


-- 3. Generate a report with:
    -- customer (first, last) name, store id, film title,
    -- when the film was rented and returned for each of these customers
    -- order by store_id, customer last_name
select concat(c.first_name, ' ', c.last_name) as full_name, s.store_id, f.title
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
group by full_name, s.store_id, f.title
order by store_id, full_name asc;

-- 4. Show sales per store (money of rented films)
    -- show store's city, country, manager info and total sales (money)
    -- (optional) Use concat to show city and country and manager first and last name
select s.store_id, sum(p.amount) as total_sales
from store s
inner join inventory i on i.store_id = s.store_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
group by s.store_id;

-- 5. Which actor has appeared in the most films?
select fa.actor_id, a.first_name, a.last_name, count(*) as film
from film_actor fa
inner join actor a on a.actor_id = fa.actor_id
group by fa.actor_id
order by film desc;