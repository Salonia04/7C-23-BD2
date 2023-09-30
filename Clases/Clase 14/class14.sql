

    -- 1. Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.

    select concat(c.first_name, ' ', c.last_name) as full_name, a.address, ci.city
    from customer c
    inner join address a on a.address_id = c.address_id
    inner join city ci on ci.city_id = a.city_id
    inner join country co on co.country_id = ci.country_id
    where co.country like 'Argentina';

    -- 2. Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.

    select f.title, l.name,
    case
        when rating = 'G' then 'All Ages Are Admitted.'
        when rating = 'PG' then 'Some Material May Not Be Suitable For Children.'
        when rating = 'PG-13' then 'Some Material May Be Inappropriate For Children Under 13.'
        when rating = 'R' then 'Under 17 Requires Accompanying Parent Or Adult Guardian.'
        when rating = 'NC-17' then 'No One 17 and Under Admitted.'
    end as rating_description
    from film f
    inner join language l on l.language_id = f.language_id;

    -- 3. Write a search query that shows all the films (title and release year) an actor was part of. Assume the actor comes from a text box introduced by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.

    select f.title, f.release_year, concat(a.first_name, ' ', a.last_name) as full_name
    from film f
    inner join film_actor fa on fa.film_id = f.film_id
    inner join actor a on a.actor_id = fa.actor_id
    where CONCAT_WS(a.first_name, ' ', a.last_name) like trim(upper("JULIANNE DENCH"));

    -- 4. Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. There should be returned column with two possible values 'Yes' and 'No'.

    select f.title, concat(c.first_name, ' ', c.last_name) as full_name,
    case when r.return_date is not null then 'Yes'
    else 'No' end as was_returned,
    MONTHNAME(r.rental_date) as month
    from film f
    inner join inventory i on i.film_id = f.film_id
    inner join rental r on r.inventory_id = i.inventory_id
    inner join customer c on c.customer_id = r.customer_id
    where MONTHNAME(r.rental_date) like 'May'
    or MONTHNAME(r.rental_date) like 'June';

    -- 5. Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.

    No hay casi diferencias entre CAST y CONVERT, salvo la sintaxis, flexibilidad y compatibilidad

    CAST EJEMPLO:
        SELECT CAST(rental_date AS DATE) AS rental_date_convertida FROM rental;
    CONVERT EJEMPLO:
        SELECT CONVERT(VARCHAR(10), rental_date, 120) AS rental_date_convertida FROM rental;

    Flexibilidad: CONVERT ofrece más flexibilidad para dar formato a valores de fecha y hora, lo que resulta útil cuando necesitas personalizar el formato de salida. Te permite especificar varios códigos de estilo.

    Compatibilidad con Bases de Datos: Dado que CAST es parte del estándar SQL, es más portátil entre diferentes sistemas de bases de datos. Por otro lado, CONVERT ofrece opciones adicionales de formato para Microsoft SQL Server, que aunque soporte las 2, es mas conveniente usar el último mencionado.

    -- 6. Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. Which ones are not in MySql and write usage examples.

1. NVL:

Utilizado en Oracle Database.
Reemplaza valores NULL por un valor predeterminado.
Sintaxis: NVL(expresión, valor_predeterminado).
Ejemplo:
    SELECT title, NVL(description, 'Sin descripción') AS descripcion_alternativa
    FROM film;
.

2. ISNULL:

Utilizado en Microsoft SQL Server.
Verifica si un valor es NULL y lo reemplaza con un valor de reemplazo.
Sintaxis: ISNULL(expresión, valor_de_reemplazo).
Ejemplo: 
    SELECT title, ISNULL(language.name, 'Desconocido') AS idioma_alternativo
    FROM film
    LEFT JOIN language ON film.language_id = language.language_id;


3. IFNULL:

Utilizado en MySQL y MariaDB.
Proporciona un valor de reemplazo para valores NULL.
Sintaxis: IFNULL(expresión, valor_de_reemplazo).
Ejemplo: 
    SELECT first_name, IFNULL(last_name, 'Apellido Desconocido') AS apellido_alternativo
    FROM actor;


4. COALESCE:

Función estándar SQL compatible con varios sistemas de bases de datos, incluyendo Oracle, Microsoft SQL Server, MySQL y otros.
Devuelve el primer valor no NULL de una lista de expresiones.
Sintaxis: COALESCE(expresión1, expresión2, ..., expresiónN).
Ejemplo: 
    SELECT rental_id, COALESCE(customer.first_name, store.store_name) AS cliente_o_tienda
    FROM rental
    LEFT JOIN customer ON rental.customer_id = customer.customer_id
    LEFT JOIN store ON rental.store_id = store.store_id;
