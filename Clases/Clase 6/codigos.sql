--List all the actors that share the last name. Show them in order
select last_name 
from actor
where last_name in (select last_name
                    from actor
                    group by last_name
                    having count(*) > 1)
group by last_name
order by last_name;

--Find actors that don't work in any film
select concat(first_name, ' ', last_name) as Nombre_Completo
from actor
where actor_id not in (select actor_id
                        from film_actor);

--Find customers that rented only one film
select concat(c.first_name, ' ', c.last_name) as Nombre_Completo, r.rental_date
from customer c, rental r
where r.customer_id in (select r.customer_id
                        from rental r
                        group by r.customer_id
                        having count(*) = 1);

--Find customers that rented more than one film
select concat(c.first_name, ' ', c.last_name) as Nombre_Completo
from customer c, rental r
where r.customer_id in (select r.customer_id
                        from rental r
                        group by r.customer_id
                        having count(*) > 1); 

--List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
select concat(a.first_name, ' ', a.last_name) as Nombre_Completo, f.title
from actor a
where a.actor_id in (select fa.actor_id
                        from film_actor, film
                        where f.title = 'BETRAYED REAR' or f.title = 'CATCH AMISTAD');

--List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
select concat(a.first_name, ' ', a.last_name) as Nombre_Completo, f.title
from actor a, film_actor fa, film f
where fa.actor_id in (select fa.actor_id
                        from film_actor fa, film f, actor a
                        where f.title = 'BETRAYED REAR' 
                        and f.title != 'CATCH AMISTAD');

--List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
select concat(a.first_name, ' ', a.last_name) as Nombre_Completo, f.title
from actor a, film_actor fa, film f
where fa.actor_id in (select fa.actor_id
                        from film_actor, film
                        where f.title = 'BETRAYED REAR' and f.title = 'CATCH AMISTAD');

--List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
    select concat(a.first_name, ' ', a.last_name) as Nombre_Completo, f.title
    from actor a, film_actor fa, film f
    where fa.actor_id not in (select fa.actor_id
                            from film_actor, film
                            where f.title = 'BETRAYED REAR' or f.title = 'CATCH AMISTAD');
    
