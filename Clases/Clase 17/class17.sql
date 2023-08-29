-- 1. Create two or three queries using address table in sakila db:
    -- include postal_code in where (try with in/not it operator)
    -- eventually join the table with city/country tables.
    -- measure execution time.
    -- Then create an index for postal_code on address table.
    -- measure execution time again and compare with the previous ones.
    -- Explain the results
    select a.postal_code, ci.city, co.country
    from address a
    inner join city ci on ci.city_id = a.city_id
    inner join country co on co.country_id = ci.country_id
    where postal_code in(
        '60079', '56380', '1944'
    );

    select a.postal_code, ci.city, co.country
    from address a
    inner join city ci on ci.city_id = a.city_id
    inner join country co on co.country_id = ci.country_id
    where postal_code not in(
        '60079', '56380', '1944'
    );

    create index idx_postal_code on address (postal_code);

    ###
    Un índice en la columna postal_code ayudará a mejorar la velocidad de las consultas que utilizan postal_code como filtro de búsqueda.
    ###


-- 2. Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?
select *
from actor
where first_name = "Rock";

select *
from actor
where last_name = "Dukakis";

###
La diferencia es imperceptible, si es que la hay.
###

-- 3. Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.
alter table film add FULLTEXT(description);

select *
from film
where description like '%action%';


select *
from film
where match(description) against('action');

###
El indice FULLTEXT está diseñado para manejar consultas que buscan palabras o frases en las columnas varchar de una tabla. En esta base de datos es imperceptible el tiempo que se ahorra
###