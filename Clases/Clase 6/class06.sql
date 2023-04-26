--1) List all the actors that share the last name. Show them in order
select a.last_name, a.first_name, a.actor_id
from actor a
where a.last_name in (select a.last_name
                    from actor a
                    group by last_name
                    having count(*) > 1)
order by a.last_name;

--2) Find actors that don't work in any film
select concat(first_name, ' ', last_name) as Nombre_Completo
from actor
where actor_id not in (select actor_id
                        from film_actor);

--3) Find customers that rented only one film
select concat(c.first_name, ' ', c.last_name) as Nombre_Completo, r.rental_date, c.customer_id
from customer c, rental r
where r.customer_id in (select r.customer_id
                        from rental r
                        group by r.customer_id
                        having count(*) = 1);

--4) Find customers that rented more than one film
select concat(c.first_name, ' ', c.last_name) as Nombre_Completo
from customer c, rental r
where r.customer_id in (select r.customer_id
                        from rental r
                        group by r.customer_id
                        having count(*) > 1); 

--5) List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
select concat(a.first_name, ' ', a.last_name) as Nombre_Completo, a.actor_id
from actor a
where a.actor_id in (select fa.actor_id
                    from film_actor fa
                    where fa.film_id in (select f.film_id
                                        from film f 
                                        where f.title = 'BETRAYED REAR'
                                        or f.title = 'CATCH AMISTAD'));

--6) List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
select concat(a.first_name, ' ', a.last_name) as Nombre_Completo, a.actor_id
from actor a
where a.actor_id in (select fa.actor_id
                    from film_actor fa
                    where fa.film_id in (select f.film_id
                                        from film f 
                                        where f.title = 'BETRAYED REAR'))
and a.actor_id not in (select fa.actor_id
                        from film_actor fa
                        where fa.film_id in (select f.film_id
                                            from film f 
                                            where f.title = 'CATCH AMISTAD'));

--7) List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
select concat(a.first_name, ' ', a.last_name) as Nombre_Completo, a.actor_id
from actor a
where a.actor_id in (select fa.actor_id
                    from film_actor fa
                    where fa.film_id in (select f.film_id
                                        from film f 
                                        where f.title = 'BETRAYED REAR'))
and a.actor_id in (select fa.actor_id
                    from film_actor fa
                    where fa.film_id in (select f.film_id
                                        from film f 
                                        where f.title = 'CATCH AMISTAD'));

--8) List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
select concat(a.first_name, ' ', a.last_name) as Nombre_Completo, a.actor_id
from actor a
where a.actor_id not in (select fa.actor_id
                    from film_actor fa
                    where fa.film_id in (select f.film_id
                                        from film f 
                                        where f.title = 'BETRAYED REAR'))
and a.actor_id not in (select fa.actor_id
                    from film_actor fa
                    where fa.film_id in (select f.film_id
                                        from film f 
                                        where f.title = 'CATCH AMISTAD'))
group by a.actor_id;

        
