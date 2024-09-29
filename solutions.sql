-- netflix project

drop table if exists netflix;

create table netflix
(
	show_id	varchar(6),
	type varchar(10),
	title varchar(150),
	director varchar(208),	
	castS varchar(1000),	
	country	varchar(150),
	date_added	varchar(150),
	release_year INT,
	rating	varchar(10),
	duration	varchar(15),
	listed_in	varchar(100),
	description varchar(250)
);


select * from netflix;


select count(*) as total_contant from netflix;



select
	distinct type
from netflix;

-- 15 bussiness problems

-- 1. Count the number of movies vs TV shows

select 
	TYPE,
	COUNT(*) AS TOTAL_CONTENT
from netflix
GROUP BY TYPE


-- 2.Find The Most Common rating for Movies and Tv Shows
SELECT 
	TYPE,
	RATING
FROM
(
SELECT
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
FROM NETFLIX
GROUP BY 1, 2
) AS T1
WHERE 
	RANKING = 1 


-- 3.List All Movies Released in a specific year(e,g., 2020)
select title,release_year
from netflix
where release_year = 2020 and type = 'Movie'

select title
from netflix
where type = 'Movie'





-- 4.Find the Top Content with the Most Conten on Netflix?

select 
	unnest (string_to_array(country,',')) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5

-- 5. Identify the Logest Movie?

select *from netflix
where 
   type = 'Movie' 
   and 
   duration = (select max(duration) from netflix);
   

-- 6.find movie added in the Last Year?

select type,date_added
    from netflix
where 
	to_date(date_added, 'Month DD,YYYY' )>= current_date - interval '5 years' and type='Movie';

	
-- 7. Find all the Movies/tv Shows by Director 'Rajiv Chilaka'

select * from netflix

where director ilike '%Rajiv Chilaka%'


-- 8.List all TV shows with more than 5 sesoans?

select * from netflix
	-- SPLIT_PART(duration,'',1) AS SESSIONS
where
	type = 'TV Show'
	and
	SPLIT_PART(duration, ' ' ,1)::numeric > 5 


-- 9.Count The Number of content items in eash genre?

select
	UNNEST(string_to_array(listed_in,',')) AS GENRE,
	COUNT(Show_id) as Total_content
from netflix
group by 1


-- 10.Find each year and the average number of content release by indian
-- on netflix return top 5 year with highest avg content release?

select
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as YEAR,
	count(*) as yearly_conten,
	round(
	COUNT(*)::numeric/(SELECT count(*) FROM NETFLIX WHERE COUNTRY = 'India')::numeric * 100 
	,2)as avg_content_peryear
from netflix 
where country = 'India'
GROUP BY 1


-- 11. List all movie thats are documentaries?
select title as movies ,listed_in as genre
from netflix
where listed_in ilike '%Documentaries%'


12. find all content without a directot?

select show_id,title,director
from netflix
where director is null

13.Find how many movies actor 'Salman Khan' appeared in last 10 year?

select CASTS,RELEASE_YEAR 
from netflix
where 
    casts ilike '%Salman khan%'
	and release_year >EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- 14.Find th top 10 actors who have appeared in the highest
-- number of movies produced in india?

select 
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
where country ilike '%india'
group by 1
order by 2 desc
limit 10


-- -- 15.Categorize the content based on the presence of the keywords 'kill' 
-- and 'violence' in the description field. Label content containing these 
-- keywords as 'Bad' and all other content as 'Good'. Count how many items 
-- fall into each category.
with new_table
as
(
select 
*,
     case
	 when description ilike '%kill%' or 
	 description ilike '%violence%' then 'bad_content'
	 else 'good_content'
	 end category
from netflix
)

select 
     category,
     count(*) as total_content
from new_table
group by 1










