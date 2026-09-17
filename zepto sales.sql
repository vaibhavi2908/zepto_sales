create database zepto;
use zepto;

drop table if exists zepto;
 
create table zepto (
sku_id serial primary key,
category varchar(120),
name varchar (100),
mrp numeric ,
discountPercent numeric,
availableQuantity integer ,
discountedSellingPrice numeric,
weightInGms integer,
outOfStock varchar (50),
quantity integer );

-- data exploration

-- count of rows
select count(*) from zepto;
 
 -- sample data
 select * from zepto
 limit 10;
 
 -- null values
 
  select * from zepto
  where name is null
  or
  category is null
  or
   mrp is null
  or
  discountPercent is null
  or
  availableQuantity is null
  or
  discountedSellingPrice is null
  or
  weightInGms is null
  or
  outOfStock is null
  or
  quantity is null;
  
  -- different product categories 
  
  select distinct category 
  from zepto;

-- product in stocks vs out of stocks
 select outOfStock,count(sku_id) 
 from zepto
 group by outOfStock; 
 
 -- product names present multiple times
 select name ,count(sku_id) as number_of_skus
 from zepto
 group by name
 having count(sku_id)
 order by count(sku_id)desc;
 
 -- data cleaning 
 
 -- product  with price =0
 select * from zepto 
 where mrp = 0 or discountedSellingPrice=0;
 

 set sql_safe_updates=0;
 
delete from zepto
where  mrp=0;
  set sql_safe_updates=1;
  
alter table zepto
modify column mrp decimal(10,2),
modify column discountedSellingPrice decimal(10,2);
  

  -- convert paise to rupees
   update zepto
   set mrp =( mrp/100.0),
   discountedSellingPrice = ( discountedSellingPrice/100.0);
 
 
 select mrp,discountedSellingPrice from zepto;
 select * from zepto;
 
 -- Q1. Find the top 10 best-value products based on the discount percentage.
 select distinct name ,mrp,discountPercent
 from zepto
 order by discountPercent desc
 limit 10;
 select* from zepto;
 
 -- Q2. What are the products with HIGH MRP but Out of Stock.
 select distinct name, mrp
 from zepto 
 where outOfStock = TRUE and mrp > 20
 order by mrp desc;
 
 -- Q3. Calculated Estimated Revenue for each category.
 select category,
 sum(discountedSellingPrice * availableQuantity) as total_revenue
 from zepto 
 group by category
 order by total_revenue;
 
 -- Q4. Find all products where mrp is greater than 500 and discount is less tahn 10%.
  select distinct name ,mrp,discountPercent
  from zepto where mrp >500 and
  discountPercent > 10
  order by mrp desc,discountPercent desc;
  
 -- Q5. Identify the top 5 categories offering the biggest average discount percentage.
 select category , 
 avg(discountPercent) as avg_discount
 from zepto
 group by category
 order by avg_discount desc
 limit 5;
  
 -- Q6. Find the price per gram for products above 100gm and sort by best value .
 select distinct name , weightInGms,discountedSellingPrice,
 discountedSellingPrice/weightInGms as price_per_gram
 from zepto 
 where
  weightInGms>= 100
  order by price_per_gram;
 
 -- Q7. Group the products into categories like low ,medium ,bulk .
 select distinct name,weightInGms,
 case when weightInGms < 1000 then "low"
     when weightInGms < 5000 then "medium"
	 else "bulk"
     end as weight_category
     from zepto;
     
 -- Q8. What is the total Inventory Weight per category .
  select category,
  sum(weightInGms*availableQuantity) as total_weight
  from zepto 
  group by category
order by total_weight;
 
 
 