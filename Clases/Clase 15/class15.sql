
-- Create a view named list_of_customers, it should contain the following columns:
    -- customer id
    -- full name,
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
    concat(c.first_name, ' ', c.last_name) as customer_full_name, 
    a.address, 
    a.postal_code as zip_code, 
    a.phone, 
    ci.city, 
    co.country, 
    case when c.active = 1 
    then 'active' 
    else 'inactive' 
    end as status,
    c.store_id
from customer c
    inner join address a on c.address_id = a.address_id
    inner join city ci on a.city_id = ci.city_id
    inner join country co on ci.country_id = co.country_id;

select * from list_of_customers;

-- Create a view named film_details, it should contain the following columns: film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT
create or replace view film_details as 
select
    f.film_id,
    f.title,
    f.description,
    c.name as Categoria,
    f.rental_rate as Precio,
    f.length as Duracion,
    f.rating,
    GROUP_CONCAT(a.first_name, ' ', a.last_name) AS Actores
from film f
    inner join film_category fc using (film_id)
    inner join category c using (category_id)
    inner join film_actor fa using(film_id)
    inner join actor a using(actor_id)
group by  f.film_id, f.title, f.description, c.name, f.rental_rate, f.length, f.rating;

select * from film_details;

-- Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
create or replace view sales_by_film_category as
select
    c.name as category,
    SUM(p.amount) as total_rental
from
    film f
    join film_category fc on f.film_id = fc.film_id
    join category c on fc.category_id = c.category_id
    join inventory i on f.film_id = i.film_id
    join rental r on i.inventory_id = r.inventory_id
    join payment p on r.rental_id = p.rental_id
group by
    c.name;

select * from sales_by_film_category;



-- Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
create or replace view actor_information as
select
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) as film_count
from
    actor a
    left join film_actor fa on a.actor_id = fa.actor_id
group by
    a.actor_id, a.first_name, a.last_name;

select * from actor_information;


-- Analyze view actor_info, explain the entire query and specially how the sub query works. Be very specific, take some time and decompose each part and give an explanation for each.
La consulta #5 crea una nueva vista llamada "actor_information".

Despues seleccionamos las columnas "actor_id", "first_name", "last_name" y el recuento de películas en las que ha actuado cada actor. 

Se utiliza una combinación (LEFT JOIN) entre la tabla "actor" y la tabla "film_actor" basada en el ID del actor.

El resultado se agrupa por "actor_id", "first_name" y "last_name" para mostrar el recuento de películas de cada actor individualmente.

La vista "actor_information" mostrará información organizada sobre los actores, mostrando su ID, primer nombre, apellido y la cantidad de películas en las que han actuado.

-- Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.
MATERIALIZED VIEWS:
son objetos de base de datos que almacenan los resultados de una consulta como una tabla física. A diferencia de las vistas regulares, las vistas materializadas contienen datos reales y se actualizan periódicamente para mantenerse sincronizadas con las tablas de origen. Esto permite mejorar el rendimiento al evitar ejecutar la misma consulta repetidamente.

// EJEMPLO:
    create MATERIALIZED VIEW nombre_de_la_view as
    select t.columna1, t.columna2
    from tablas t
    where condiciones
    [REFRESH {FAST | COMPLETE | FORCE | ON DEMAND | NEVER}];

// PORQUE SE UTILIZAN?
//// Mejora del rendimiento:
        Las vistas materializadas mejoran el rendimiento de las consultas al precalcular y almacenar los resultados de consultas complejas o frecuentemente utilizadas. Esto evita ejecutar repetidamente consultas costosas en grandes conjuntos de datos.

//// Agregación y resumen de datos:
        Son útiles para agregar, resumir o transformar datos, lo que permite acceder de manera eficiente a información resumida sin consultar toda la base de datos.

//// Procesamiento sin conexión:
        Las vistas materializadas permiten realizar procesamiento y generar informes sin estar conectados a la base de datos, lo que agiliza la recuperación de datos con fines analíticos.

////Reducción de la carga en las tablas fuente:
        Proporcionan una fuente de datos alternativa y reducen la carga en las tablas fuente subyacentes, especialmente en sistemas con alta concurrencia y operaciones de lectura frecuentes.

//// Soporte para datos remotos:
        Las vistas materializadas se pueden utilizar para almacenar datos de bases de datos remotas, facilitando el trabajo con sistemas distribuidos y mejorando el rendimiento al evitar consultas directas a bases de datos lejanas.

// ALTERNATIVAS:
//// Vistas Regulares
        Son tablas virtuales que representan los resultados de una consulta sin almacenar datos. Proporcionan una vista actualizada cada vez que se consultan. Adecuadas para acceso a datos en tiempo real cuando el costo de recomputar resultados es aceptable.

//// Caché
        Almacenar en caché los resultados de consultas en memoria mejora el rendimiento al evitar cálculos repetidos. No es tan eficiente para conjuntos de datos complejos o grandes como las vistas materializadas.

//// Indices
        Crear índices apropiados en columnas consultadas con frecuencia mejora el rendimiento sin necesidad de vistas materializadas. Los índices optimizan la recuperación de datos sin almacenar resultados precalculados.

//SGDB DONDE EXISTEN:
Las vistas materializadas están disponibles en varios sistemas de gestión de bases de datos (SGBD). Algunos de los SGBD populares que soportan vistas materializadas son:

//// Oracle Database
        Oracle tiene un sólido soporte para vistas materializadas, ofreciendo varias opciones para crear, mantener y refrescar las vistas. Las vistas materializadas en Oracle pueden ser simples o complejas, lo que permite ajustar su comportamiento según las necesidades.

//// PostgreSQL
        PostgreSQL también proporciona soporte para vistas materializadas. Puedes crear vistas materializadas en PostgreSQL utilizando la sintaxis adecuada y realizar refrescos manuales o automáticos según tus requisitos.

//// Microsoft SQL Server
        SQL Server ofrece soporte para vistas indexadas, que son una forma de vistas materializadas con índices asociados para mejorar el rendimiento de consultas. Estas vistas indexadas se actualizan automáticamente cuando se modifican los datos subyacentes.

//// MySQL
        A partir de la versión 5.7, MySQL comenzó a ofrecer soporte experimental para vistas materializadas. Sin embargo, su uso todavía puede ser limitado o requerir configuración adicional.
