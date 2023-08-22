-- 1- Insert a new employee to , but with a null email. Explain what happens.
CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

insert into employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle) values (10, 'Modric', 'Luka', 'RMCF', null, 'CRO', 1, 'Football Player');

Rta:
No se puede agregar un email null ya que cuando creamos la tabla employees especificamos que nada puede ser nulo (NOT NULL)

-- 2- Run the first the query
-- UPDATE employees SET employeeNumber = employeeNumber - 20
-- What did happen? Explain. Then run this other
-- UPDATE employees SET employeeNumber = employeeNumber + 20
-- Explain this case also.

Rtas:
La primera query se ejecuta sin problema, ya que resta 20 a cada employeeNumber secuencialmente (empezando desde el primero que en este caso es el mas bajo) y no coliciona con ningun otro employeeNumber

En cambio la segunda, al tener una diferencia de solo 20 entre el 2do employeeNumber y el 3ero, al modificar el segundo y agregarle 20 coliciona con el 3ero, por lo que tira un error.

-- 3- Add an age column to the table employee where and it can only accept values from 16 up to 70 years old.
alter table employees
add age tinyint unsigned default 30;

alter table employees
add constraint age check (age >= 16 and age <= 70);

-- 4- Describe the referential integrity between tables film, actor and film_actor in sakila db.
Primero aclaremos que es la 'referential integrity': Se refiere a la coherencia de las relaciones entre las tablas de la base de datos, particularmente en lo que respecta a las foreign keys y las relaciones entre tablas.

Sabemos que actor guarda actores (actor_id -> primary key) y que film guarda peliculas (film_id -> primary key). Por lo que al ser una relacion de muchos a muchos (Muchos actores trabajan en muchas peliculas) agregamos una tabla intermedia que seria film_actor, en donde guardamos el id del actor y de la pelicula respectivamente para organizar todo adecuadamente.

Ejemplo:
Actores: Keanu Reeves (id: 1) y Lance Reddick (id: 2) 
Peliculas: John Wick (id: 1) y Matrix (id: 2)

film_actor
actor | film
1     | 1
1     | 2
2     | 1

-- 5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row (assume multiple users, other than root, can connect to MySQL and change this table).
alter table employees
add column lastUpdate datetime; 

alter table employees
add column lastUpdateUser varchar(255); 

create trigger before_employee_update 
    before update on employees
    for each row 
begin
     set new.lastUpdate = now();
     set new.lastUpdateUser = CURRENT_USER;
end;

update employees set lastName = 'Ortega' where employeeNumber = 1056;


-- 6- Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.

----------------- INS_FILM ------------------
-- Inserta una nueva pelicula en film_text --
BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
END

------------------------ UPD_FILM ------------------------
-- Actualiza el film_text existente por uno actualizado --
BEGIN
	IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
	THEN
	    UPDATE film_text
	        SET title=new.title,
	            description=new.description,
	            film_id=new.film_id
	    WHERE film_id=old.film_id;
	END IF;
END

---------------------------------- DEL_FILM --------------------------------
-- Elimina el film_text existente que corresponde a la pelicula eliminada --
BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
END