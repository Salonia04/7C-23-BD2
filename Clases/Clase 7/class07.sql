-- 1. Find the films with less duration, show the title and rating.
select f1.title, f1.rating, f1.length as min_length 
from film f1
where f1.length <= ALL (select f2.length
                        from film f2);

-- 2. Write a query that returns the title of the film which duration is the lowest. If there are more than one film with the lowest duration, the query returns an empty resultset.
select title, length
from film as f1
where length <= (select MIN(length) 
                from film) 
and not exists (select * 
                from film as f2 
                where f2.film_id <> f1.film_id 
                AND f2.length <= f1.length);

-- 3. Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
select * from (
  select c.customer_id as id, concat(c.first_name, ' ',c.last_name) as complete_name, a.address as address, p.amount as lowest_payment
  from customer c
  inner join payment p on c.customer_id = p.customer_id
  inner join address a on c.address_id = a.address_id
  where p.amount <= ALL(
    select amount from payment where customer_id=c.customer_id
  )
) as query
GROUP BY id,lowest_payment;

--

select concat(first_name, ' ',last_name) as complete_name, a.address, MIN(p.amount) as lowest_payment
from customer
         inner join payment as p ON customer.customer_id = p.customer_id
         inner join address as a on customer.address_id = a.address_id
group by first_name, last_name, a.address;

-- 4. Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.
select id, concat(firstName, ' ',lastName) as complete_name, address, min(amount) as lowest_payment, max(amount) as highest_payment from (
  select c.customer_id as id,c.first_name as firstName, c.last_name as lastName,a.address as address,p.amount as amount
  from customer c
  inner join payment p on c.customer_id = p.customer_id
  inner join address a on c.address_id = a.address_id
  where p.amount <= ALL(
    select amount from payment where customer_id=c.customer_id
  )
  OR p.amount >= ALL(
    select amount from payment where customer_id=c.customer_id
  )
) as queryPapa
GROUP BY id;