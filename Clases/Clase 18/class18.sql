
-- 1. Write a function that returns the amount of copies of a film in a store in sakila-db. Pass either the film id or the film name and the store id.
select f.title, count(i.film_id) as amount, group_concat(s.store_id) as avaiable_stores
from film f
inner join inventory i on i.film_id = f.film_id
inner join store s on s.store_id = i.store_id
group by f.title;

select s.store_id, f.title, count(i.film_id) as amount
from store s
inner join inventory i on i.store_id = s.store_id
inner join film f on f.film_id = i.film_id
group by s.store_id, f.title
order by f.title asc;

select f.title as film, s.store_id as store, count(i.film_id) as amount
from film f
inner join inventory i on i.film_id = f.film_id
inner join store s on s.store_id = i.store_id
where f.title = "ZORRO ARK" 
and s.store_id = 2
group by f.title, s.store_id
;

-- 2. Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", that live in a certain country. You pass the country it gives you the list of people living there. USE A CURSOR, do not use any aggregation function (ike CONTCAT_WS.
DELIMITER //

drop procedure if exists ObtenerClientesEnPais;
create procedure ObtenerClientesEnPais(
    in pais varchar(50), 
    out lista_clientes varchar(255)
)
begin
    declare done int default 0;
    declare nombre varchar(45);
    declare apellido varchar(45);

    declare cur cursor for
        select first_name, last_name
        from customer
        where address_id in (
            select address_id
            from address
            where city_id in (
                select city_id
                from city
                where country_id = (
                    select country_id
                    from country
                    where country = pais
                )
            )
        );
    declare continue handler for not found set done = 1;

    set lista_clientes = '';

    open cur;

    read_loop: loop
        fetch cur into nombre, apellido;
        if done then
            leave read_loop;
        end if;

        if lista_clientes = '' then
            set lista_clientes = concat(nombre, ' ', apellido);
        else
            set lista_clientes = concat(lista_clientes, ';', nombre, ' ', apellido);
        end if;
    end loop;

    close cur;
end;
//


DELIMITER ;

-- 3. Review the function inventory_in_stock and the procedure film_in_stock explain the code, write usage examples.

-- inventory_in_stock
-- Esta funcion toma 2 parametros: 
-- - film_id
-- - store_id
-- y devuelve un valor booleano que indica si una peli esta en stock en la tienda seleccionada o no lo esta.
-- Ejemplo:
SELECT inventory_in_stock(1, 1); -- Peli: 1; Tienda: 1.

-- REsultados:
-- - True: Esta la peli en esa tienda
-- - False: No lo esta


-- film_in_stock:
-- Este procedimiento se usa para verificar si una peli esta en stock en una tienda especifica.
-- Si si esta, te muestra la info de la peli y de la tienda.
-- Ejemplo:
CALL film_in_stock(1, 1); -- Muestra información sobre la película con id 1 en la tienda con id 1, si es que esta en stock.

-- Resultadod:
-- - Disponible: Muestra la info de la peli y tienda.
-- - Disponiblen't: MUestra un mensaje diciendo que la pelicula no esta disponible en esa tienda por falta de stock.

