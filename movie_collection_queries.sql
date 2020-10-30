/*Queries for answering possible questions for the movie_collection database.
The original file was saved with a .sql extention. */

use movie_collection;
/*Question 1: Items*/
select item_id as 'item id', f.film_title as 'film title', vf.format_name as 'format', 
vc.condition_title as 'condition', purchase_price, notes from collection_item ci
join film f on f.film_id = ci.film_id 
join video_format vf on vf.format_id = ci.format_id
join video_condition vc on vc.condition_id = ci.format_id
order by f.film_title asc;
    
/* Question 2: Genre Search*/
select f.film_title from film_genre fg
join genre g on g.genre_id = fg.genre_id
join film f on f.film_id = fg.film_id
where genre_name like '%science fiction%' or genre_name like '%anime%'
group by film_title;

/* Question 3: single table select*/
Select * from video_condition;

/*Question 4: purchase price more than resale price*/
select cr.item_id as 'Item ID',  purchase_price as 'Purchase', current_value as 'Current', vf.format_name as 'Format', f.film_title as 'Title', pl.store_name, cr.update_time as 'Current Value Update Time' from current_resale cr
join collection_item ci on cr.item_id = ci.item_id
join film f on f.film_id = ci. film_id
join video_format vf on ci.format_id = vf.format_id
join purchase_location pl on ci.purchase_location = pl.location_id
where purchase_price > current_value
order by purchase_price desc;

/*Question 5: money gained*/
select sum(purchase_price) as 'Total Spent' from collection_item;
select sum(current_value) as 'Current Value' from current_resale;

/*Question 6: count items*/
select count(item_id) from collection_item; 

select count(item_id), video_format.format_name from collection_item
left join video_format on video_format.format_id = collection_item.format_id
group by video_format.format_name
order by count(item_id);

/*Question 7: top five most expensive*/
select purchase_price as 'purchase price', f.film_title as 'film title', vf.format_name as 'format', 
vc.condition_title as 'condition', notes from collection_item ci
join film f on f.film_id = ci.film_id 
join video_format vf on vf.format_id = ci.format_id
join video_condition vc on vc.condition_id = ci.format_id
order by purchase_price 
desc 
limit 5;

/*Question 8: cheapest places to go shopping */
select * from collection_item
join film on film.film_id = collection_item.film_id
inner join purchase_location on purchase_location.location_id = collection_item.purchase_location
where purchase_location IN 
(select location_id from purchase_location where city like '%pittsburgh%') and purchase_price <= 2.99 and condition_id >= 3;

/*Question 9: what movies do i have multiple copies of?*/
select film.film_title, count(*) as itemcount
from collection_item ci
join film on film.film_id = ci.film_id
group by ci.film_id
having itemcount >= 2 
order by itemcount desc;

/*Question 10: most popular genres */
select fg.genre_id, genre_name, count(*) from collection_item ci
join film_genre fg on fg.film_id = ci.film_id
join genre on genre.genre_id = fg.genre_id
group by genre_id;
