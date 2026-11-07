
select * from blinkit_data

select count(*) from blinkit_data

update blinkit_data
set item_fat_content = 
case
when item_fat_content in ('LF','low fat') then 'Low Fat'
when item_fat_content = 'reg' then'Regular'
else item_fat_content
end

select distinct(item_fat_content) from blinkit_data

select cast(sum(sales)/1000000 as decimal(10,2)) as total_sales_millions
from blinkit_data

select cast(avg(sales) as decimal(10,0)) as avg_sales from blinkit_data

select count(*) as no_of_items 
from blinkit_data

select cast(avg(rating) as decimal(10,2)) as avg_rating from blinkit_data

--Granular requirements
--Total sales by fat content
select item_fat_content,
       cast(sum(sales)as decimal (10,2))as total_sales,
	   cast(avg(sales) as decimal(10,1)) as avg_sales ,
	   count(*) as no_of_items,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit_data
group by 1
order by 2 desc

--Total sales by item type
select item_type,
       cast(sum(sales)as decimal (10,2))as total_sales,
	   cast(avg(sales) as decimal(10,1)) as avg_sales ,
	   count(*) as no_of_items,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit_data
group by 1
order by 2 desc

--FAt content by outlet for total sales
SELECT
    outlet_location_type,
    COALESCE(SUM(CASE WHEN item_fat_content = 'Low Fat' THEN sales END), 0) AS low_fat,
    COALESCE(SUM(CASE WHEN item_fat_content = 'Regular' THEN sales END), 0) AS regular
FROM blinkit_data
GROUP BY outlet_location_type
ORDER BY outlet_location_type;

--Total sales by outlet establishment
select outlet_establishment_year,
       cast(sum(sales)as decimal(10,2)) as total_sales
from blinkit_data
group by 1
order by 1 asc

--Percentage of sales by outlet size
select 
     outlet_size,
     cast(sum(sales)as decimal (10,2)) as total_sales,
     cast((sum(sales)*100.0 / sum(sum(sales)) over ())
       as decimal (10,2)) as sales_percentage
from blinkit_data
group  by outlet_size
order by total_sales desc;

--Sales by outlet location
select outlet_location_type,
       cast(sum(sales)as decimal(10,2)) as total_sales,
	   CAST((SUM(sales) * 100.0 / SUM(SUM(sales)) OVER ())
        AS DECIMAL(10,2)) AS sales_percentage
from blinkit_data
group by outlet_location_type
order by total_sales desc

--All metrics by outlet type
select outlet_type,
       cast(sum(sales)as decimal(10,2)) as total_sales,
	   CAST((SUM(sales) * 100.0 / SUM(SUM(sales)) OVER ())
        AS DECIMAL(10,2)) AS sales_percentage,
	   cast(avg(sales) as decimal(10,1)) as avg_sales ,
	   count(*) as no_of_items,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
		
from blinkit_data
group by outlet_type
order by total_sales desc

