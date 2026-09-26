create database FinancialPerformance
go

use FinancialPerformance

select count(*) as total_columns
from orders

select * from orders order by Row_ID desc

delete from orders where Row_ID is null

select count(*) from orders

select top 10 * from orders

select sum(sales) as total_sales from orders
select sum(Profit) as total_profit from orders
select avg(discount) as avg_discount from orders
select MAX(sales) as highest_sales from orders
select MIN(sales) as lowest_sales from orders
----------------------------------------------------
-- SALES ANALYSIS
-----------------------------------------------------
-- 1. Total Sales by Region
select Region,
	   sum(Sales) as total_sales
from orders
group by Region
order by total_sales desc

--2. Total sales by state
select State_Province,
	   sum(sales) as total_sales
from orders
group by State_Province
order by total_sales desc

--3. Total Sales by category
select Category,
	   sum(sales) as total_sales
from orders
group by Category
order by total_sales

-- 4. Top 10 customer by sales
select top 10 Customer_Name,
	   sum(sales) as total_sales
from orders
group by Customer_Name
order by total_sales desc

-- 5.TOP 10 PRODUCT BY SALE 
select top 10 Product_Name,
	   sum(sales) as total_sales
from orders
group by Product_Name
order by total_sales desc

------------------------------------------------------------------------------------------------------------------
-- PROFIT ANALYSIS
------------------------------------------------------------------------------------------------------------------
-- 1.TOTAL PROFIT BY REGION 
select Region,
	   sum(profit) as total_profit
from orders
group by region
order by total_profit

-- 2.TOTAL PROFIT BY STATE
select State_Province,
	   sum(profit) as total_profit
from orders
group by State_Province
order by total_profit

-- 3. TOTAL PROFIT BY CATEGORY
select Category,
	   sum(Profit) as total_profit
from orders
group by Category
order by total_profit

-- 4.TOTAL PROFIT BY SUB CATEGORY
select Sub_Category,
	   sum(profit) as total_profit
from orders
group by Sub_Category
order by total_profit

-- 5.top 10 customer by profit
select top 10 Customer_Name,
	   sum(profit) as total_profit
from orders
group by Customer_Name
order by total_profit desc

-- 6.TOP 10 PRODUCT BY PROFIT
select top 10 Product_Name,
	   sum(profit) as total_profit
from orders
group by Product_Name
order by total_profit desc

-- 7.LOSS MAKING PRODUCT
select Product_Name,
	   sum(profit) as total_profit
from orders
group by Product_Name
having sum(profit) < 0
order by total_profit

----------------------------------------------------------------------------------------------------------
-- BASIC CUSTOMER SEGMENT ANALYSIS:
----------------------------------------------------------------------------------------------------------
-- PROBLEM 1: WHICH CUTOMER SEGMENT GENERATES THE HIGHEST TOTAL SALE AND PROFIT?
select Segment,
	   sum(Sales) as total_sales,
	   sum(Profit) as total_profit
from orders
group by Segment
order by total_sales desc, total_profit desc

-- PROBLEM 2: Which customer segment has the highest average profit per order?
select Segment,
	   AVG(profit) as avg_profit
from orders
group by Segment
order by avg_profit desc

-- PROBLEM:3 Which customer segment has placed the highest number of orders?
select Segment,
	   COUNT(*) as total_orders
from orders
group by Segment
order by total_orders desc

-- PROBLEM 4: Which customer segment has the highest average sales per order?
select Segment,
	   AVG(Sales) as total_sales
from orders
group by Segment
order by total_sales desc

--PROBLEM 5: Which customer segment has sold the highest total quantity of products?
select Segment,
	   sum(Quantity) as total_quantity
from orders
group by Segment
order by total_quantity desc

-- PROBLEM 6: Which customer segment receive the highest average profit ?
select Segment,
	   AVG(Profit) as avg_profit
from orders
group by Segment
order by avg_profit desc

---------------------------------------------------------------------------------
-- ADVANCED CUSTOMER SEGMENT ANALYSIS
---------------------------------------------------------------------------------
-- PROBLEM 1: Business Scenario
--The company wants to classify its customer segments based on total sales performance so that the marketing team can plan different strategies.
-- Business Rules:
-- High Sales → Total Sales ≥ 700000
-- Medium Sales → Total Sales between 500000 and 699999
-- Low Sales → Total Sales < 500000
select Segment,
		sum(Sales) as total_sales,
case
	when sum(Sales) >700000 then 'Highest Sales'
	when sum(Sales) between 500000 and 699999 then 'Medium Sales'
	else 'Low Sales'
end as sales_category
from orders
group by Segment
order by total_sales desc

-- PROBLEM 2: Rank the customer segments based on their total sales from highest to lowest.
select Segment,
	   sum(Sales) as total_sales,
	   RANK() over(order by sum(sales) desc) as segment_rank
from orders
group by Segment
order by segment_rank

-- PROBLEM 3: The management wants to identify only the customer segments whose total sales are greater than ₹500,000.
with segment_sales as (
	select Segment,
		   sum(Sales) as total_sales
	from orders
	group by Segment
)
select * 
from segment_sales
where total_sales > 500000
order by total_sales desc

 -- PROBLEM 4: Find the customer segments whose total sales are greater than the average total sales of all customer segments.
 select segment,
	    sum(Sales) as total_sales
 from orders
 group by Segment
 having sum(Sales) >
 (
	select avg(total_sales)
	from(
		select Segment,
			   sum(Sales) as total_sales
		from orders
		group by Segment
	) as segment_totals
 )

------------------------------------------------------------------------------------------------------------------
-- Regional Analysis - Basic Business Analysis:
------------------------------------------------------------------------------------------------------------------
-- PROBLEM 1: Which region generates the highest total sales and total profit for the company?
select Region,
	   sum(Sales) as total_sales,
	   sum(Profit) as total_profit
from orders
group by Region
order by total_sales desc, total_profit desc

-- PROBLEM 2: Which region has the highest average profit per order?
select Region,
	   AVG(Profit) as avg_profit
from orders
group by Region
order by avg_profit desc

-- PROBLEM 3: Which region has the highest number of orders?
select Region,
	   COUNT(*) as total_orders
from orders
group by Region
order by total_orders desc

-- Problem 4: Which region has the highest average sales per order?
select Segment,
	   AVG(Sales) as average_sales
from orders
group by Segment
order by average_sales desc

-- Problem 5: Which region sold the highest total quantity of products?
select Region,
	   sum(Quantity) as total_quantity
from orders
group by Region
order by total_quantity desc

-- Problem 6: Which region offers the highest average discount to customers?
select Region,
	   AVG(Discount) as average_discount
from orders
group by Region
order by average_discount

--------------------------------------------------------------------------------------
--ADVANCED BUSINESS ANALYSIS:
--------------------------------------------------------------------------------------
-- PROBLEM 1: Classify each region based on total sales.
-- Business Rules
-- High Sales → Total Sales ≥ 700,000
-- Medium Sales → Total Sales between 500,000 and 699,999
-- Low Sales → Total Sales < 500,000
select Region,
	   sum(Sales) as total_sales,
	   case
		   when sum(Sales) >= 700000 then 'High Sales'
		   when sum(Sales) between 500000 and 699999 then 'Midium Sales'
		   else 'Low Sales'
	   end as sales_category
from orders
group by Region
order by total_sales desc

-- PROBLEM 2: Rank the regions based on total sales from highest to lowest?
select Region,
	   sum(Sales) as total_sales,
	   RANK() over(order by sum(Sales) desc) as sales_segment
from orders
group by Region
order by sales_segment

-- PROBLEM :3 Management wants to identify only those regions whose total sales are greater than ₹500,000.
with region_sales as (
	select Region,
		   sum(Sales) as total_sales
	from orders
	group by Region
)
select *
from region_sales
where total_sales > 500000
order by total_sales desc

-- PROBLEM 4: Find the regions whose total sales are greater than the average total sales of all regions.
select Region,
	   sum(Sales) as total_sales
from orders
group by Region
having sum(Sales) >
(
	select AVG(total_sales)
	from
	(
		select Region,
			   sum(Sales) as total_sales
		from orders
		group by Region
	) as region_totals
)
order by total_sales desc
---------------------------------------------------------------------------------------------
-- CATEGORY ANALYSIS
---------------------------------------------------------------------------------------------
-- PROBLEM 1: Which product category generated the highest total sales and total profit?
select Category,
	   sum(Sales) as total_sales,
	   sum(Profit) as total_profit
from orders
group by Category
order by total_sales desc, total_profit desc

-- PROBLEM 2: Classify each category based on total profit.
-- Business Rules
-- High Profit → Profit ≥ 130000
-- Medium Profit → Profit between 50000 and 129999
-- Low Profit → Profit < 50000
select Category,
	   sum(Profit) as total_profit,
	   case
		   when sum(Profit) >= 130000 then 'High Profit'
		   when sum(Profit) between 50000 and 129999 then 'Medium Profit'
		   else 'Low Profit'
	   end as profit_category
from orders
group by Category
order by total_profit desc

-- PROBLEM 3: Rank the product categories based on total profit from highest to lowest.
select Category,
	   sum(Profit) as total_profit,
	   RANK() over(order by sum(Profit) desc) as profit_rank
from orders
group by Category
order by profit_rank

-- PROBLEM 4: Find the categories whose total profit is greater than the average total profit of all categories.
select Category,
	   sum(Profit) as total_profit
from orders
group by Category
having sum(Profit) >
(
	select AVG(total_profit)
	from
	(
		select Category,
			   sum(Profit) as total_profit
		from orders
		group by Category
	) as category_totals
)
order by total_profit desc

-----------------------------------------------------------------------------------------------------------
-- SUB_CATEGORY ANALYSIS 
-----------------------------------------------------------------------------------------------------------
-- PROBLEM 1: Which are the Top 5 sub-categories based on total sales?
select top 5 Sub_Category,
	   sum(Sales) as total_sales
from orders
group by Sub_Category
order by total_sales desc

-- PROBLEM 2: Rank all sub-categories based on total profit from highest to lowest.
select Sub_Category,
	   sum(Sales) as total_sales,
	   RANK() over(order by sum(Sales) desc) as subcategory_rank
from orders
group by Sub_Category
order by subcategory_rank

-- PROBLEM 3: Find the sub-categories whose total profit is greater than ₹30,000.
select Sub_Category,
	   sum(Sales) as total_sales
from orders
group by Sub_Category
having sum(Sales) > 30000
order by total_sales desc

-- PROBLEM 4: Find the sub-categories whose total sales exceed ₹200,000 using a CTE.
with sub_category_sales as (
	select Sub_Category,
		   sum(Sales) as total_sales
	from orders
	group by Sub_Category
)
select *
from sub_category_sales
where total_sales > 200000
order by total_sales desc

-----------------------------------------------------------------------------------------------------------
-- CUSTOMER ANALYSIS 
-----------------------------------------------------------------------------------------------------------
-- PROBLEM 1: Who are the Top 10 customers based on total sales?
select top 10 Customer_Name,
	   sum(Sales) as total_sales
from orders
group by Customer_Name
order by total_sales desc

-- PROBLEM 2: Rank customers based on their total sales from highest to lowest.
select Customer_Name,
	   sum(Sales) as total_sales,
	   RANK() over(order by sum(Sales) desc) as customer_rank
from orders
group by Customer_Name
order by customer_rank

-- PROBLEM 3: Find customers whose total sales are greater than ₹10,000.
select Customer_Name,
	   sum(Sales) as total_sales
from orders
group by Customer_Name
having sum(Sales) > 10000
order by total_sales desc

-- PROBLEM 4: Classify customers based on their total sales.
-- Business Rules
-- Premium Customer → Total Sales ≥ 15,000
-- Regular Customer → Total Sales between 8,000 and 14,999
-- Standard Customer → Total Sales < 8,000
select Customer_Name,
	   sum(Sales) as total_sales,
	   case
		   when sum(Sales) >= 15000 then 'Premium Customer'
		   when sum(sales) between 8000 and 14999 then 'Regular Customer'
		   else 'Standard Customer'
	   end as customer_range
from orders
group  by Customer_Name
order by total_sales desc

----------------------------------------------------------------------------------------------
-- SHIPPING ANALYSIS:
----------------------------------------------------------------------------------------------
-- PROBLEM 1: Which shipping mode generated the highest total sales and total profit?
select Ship_Mode,
	   sum(Sales) as total_sales,
	   sum(Profit) as total_profit
from orders
group by Ship_Mode
order by total_sales desc, total_profit desc

-- PROBLEM 2: Find the average sales for each shipping mode and rank them from highest to lowest.
select Ship_Mode,
	   AVG(Sales) as average_sales,
	   RANK() over(order by avg(sales) desc) as ship_mode_rank
from orders
group by Ship_Mode
order by ship_mode_rank
