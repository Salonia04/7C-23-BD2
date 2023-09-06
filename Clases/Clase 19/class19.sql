
-- 1. Create a user data_analyst
create user 'data_analyst'@'localhost' identified by 'pepe1234';

-- 2. Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.
grant select, update, delete on sakila.* to 'data_analyst'@'localhost' with grant option;

-- 3. Login with this user and try to create a table. Show the result of that operation.
use sakila;

create table games(
    id int primary key,
    title varchar(20),
    description varchar(100)
);

ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'games'

'''
Lo que pasa es que el usuario no tiene los permisos para crear tablas, solo para seleccionar updatear y deletear.
'''

-- 4. Try to update a title of a film. Write the update script.
use sakila; 

update film
set title = 'Star Wars 11'
where title = 'ZORRO ARK';

update film
set title = 'ZORRO ARK'
where title = 'Star Wars 11';

-- 5. With root or any admin user revoke the UPDATE permission. Write the command
revoke update on sakila.* from 'data_analyst'@'localhost';

-- 6. Login again with data_analyst and try again the update done in step 4. Show the result.
update film
set title = 'Star Wars 11'
where title = 'ZORRO ARK';

ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'

'''
Le quitamos los privilegios al usuario data_analyst con el revoke
'''

