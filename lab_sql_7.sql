-- Create a table rentals_may to store the data from rental table with information for the month of May.
create temporary table sakila.rentals_may as
select *
from sakila.rental
where month(rental_date) = 5;

select *
from sakila.rentals_may;

-- Create a table rentals_june to store the data from rental table with information for the month of June.
create temporary table sakila.rentals_june as
select *
from sakila.rental
where month(rental_date) = 6;

select *
from sakila.rentals_june;

-- Check the number of rentals for each customer for May.
select customer_id, count(rental_id)
from sakila.rentals_may
group by customer_id
order by count(rental_id) desc;

-- Check the number of rentals for each customer for June.
select customer_id, count(rental_id)
from sakila.rentals_june
group by customer_id
order by count(rental_id) desc;

-- Join temporary tables for May and June.

CREATE TEMPORARY TABLE sakila.joined_rentals as
SELECT m.customer_id, m.rental_id as rental_id_may, j.rental_id as rental_id_june
FROM sakila.rentals_may m
LEFT JOIN sakila.rentals_june j
  ON m.customer_id = j.customer_id;
  
select customer_id,count(rental_id_may) as rentals_may , count(rental_id_may) as rentals_june, 
case
	when count(rental_id_june) > count(rental_id_may) then 'borrowed_more_in_june'
    when count(rental_id_june) < count(rental_id_may) then 'borrowed_less_in_june'
    when count(rental_id_june) = count(rental_id_may) then 'borrowed_same_in_june'
end as rentals_difference 
from sakila.joined_rentals
group by customer_id;
