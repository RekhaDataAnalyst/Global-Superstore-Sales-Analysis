SELECT * FROM gsuperstore.gsuperstore;

--  Business KPI's -----------------
-- Q1.total number of records in the table.
select count(*) as Total_Records from superstore;

-- Q2.first 10 rows of the table.
select * from superstore limit 10;


select distinct Customer_ID from superstore;

-- Q3 total number of unique customers.
select count(distinct Customer_ID ) from superstore;

-- Q4 total number of unique orders
select count(distinct Order_ID )from superstore;

-- Q5 total sales of the company.
select 
concat(round((sum(Sales)/1000000),2),"M") as Total_Sales
 from 
 superstore;

-- Q6 total profit of the company.
select
 concat(round((sum(Profit)/1000000),2),"M" )as Total_Profit 
 from superstore;

-- Q7 average sales.
select
 round(avg(Sales),2)as Avgsales 
 from superstore; 

-- Q8 verage profit.
select
 round(avg(Profit),2) as avgprofit
 from superstore;

-- Business Insight-------------
-- Q9  Category wise sales--
select 
Category,concat(round((sum(Sales)/1000000),2),"M") as Total_Sales 
from superstore
 group by Category 
 order by  Total_Sales desc;

-- Q10  Category wise profit-----
select 
Category,concat(round((sum(Profit)/1000000),2),"M") as  Total_Profit 
from superstore
 group by Category 
 order by sum(Profit) desc;

-- Q11 Region wise sales---
select
 Region, concat(round((sum(Sales)/1000000),2),"M") as Total_Sales
 from superstore 
 group by Region 
 order by  Total_Sales desc;

-- Q12 segment wise sale----
select 
Segment,concat(round((sum(Sales)/1000000),2),"M") as Total_Sales
 from superstore
 group by Segment
 order by  Total_Sales desc;

-- Q13 shipmode wise sales-
select
 Ship_mode,concat(round((sum(Sales)/1000000),2),"M") as Total_Sales 
 from 
 superstore 
 group by Ship_Mode 
 order by  Total_Sales desc;

select *from superstore;
-- Q14 Top 10 Customer--
select 
Customer_Name,round(sum(Sales),2) as Total_Sales
 from  superstore
 group by  Customer_Name
 order by  Total_Sales  desc limit 10 ;

--  Q15 Top 10 customers by profit--
select 
Customer_Name,round(sum(Profit),2) as Total_Profi
 from superstore 
 group by Customer_Name 
 order by Total_Profit
 desc limit 10;

-- Q16 Top 10 products by sales--
select
 Product_Name,round(sum(Sales),2) as Total_Sales 
 from superstore
 group by Product_Name 
 order by  Total_Sales
 desc limit 10;

-- Q17 Top 10 products by profit---
select 
Product_Name,round(sum(Profit),2) as Total_Profit
 from superstore 
 group by Product_Name 
 order by Total_Profit 
 desc limit 10;

-- Q18 country-wise sales -----
select 
Country,round(sum(Sales),2) as Total_Sales 
from superstore 
group by Country
 order by Total_Sales desc; 

-- Q19 Discount vs Profit Analysis--
select 
Discount,round(sum(Sales),2) Total_Sales,
round(sum(Profit),2) Total_Profit
 from superstore 
 group by Discount
 order by Total_Sales ,Total_Profit desc ;

-- Q20 Top 5 Regions by Profit--
select
 Region,round(sum(Sales),2) Total_Sales 
 from superstore group  by
 Region order by Total_Sales 
 desc limit 5;

-- Q21 the highest-selling product in each category.
-- using CTE 
with ProductSales as
 (select Category,Product_Name,sum(Sales) as Total_sales,
 rank() over(
 partition by category order by sum(Sales) desc
 ) as sales_rank  
 from superstore 
 group by Category ,Product_Name) select *from ProductSales where sales_rank=1;
 --      ------------USing subquery-----------
 select *from (
 select category,Product_Name,sum(Sales) as Total_Sales,rank() over(partition by Category order by sum(Sales) desc) as Sales_Rank 
 from superstore 
 group by Category,Product_Name) as ProductSales where Sales_RAnk=1;
 
 -- Q22
 -- Rank Customers Based on Total sales
 with customersales as 
 (select Customer_Name,sum(Sales) Total_Sales,rank() over (order by sum(Sales)desc ) as SalesRank 
 from superstore 
 group by Customer_Name)
select  Customer_Name,Total_Sales,SalesRank from customersales limit 10;

-- ------ 
-- Find the highest profit product in each category
with productsprofit as (
select Category,Product_Name,round(sum(Profit),2)as Total_Profit,
rank() over( partition by
 Category order by sum(Profit)desc) as profitrank 
 from superstore
group by Category,Product_Name)
select Category,Product_Name,Total_Profit from productsprofit where profitrank=1;

-- Find the average of those customer totals
select avg(Total_Sales) from 
(select Customer_Name,sum(Sales) as Total_Sales  from superstore group by Customer_Name) as CustomerSales;

-- Q23 Find customers whose sales are greater than the average customer sales.
select 
Customer_Name,sum(Sales) Total_Sales  from superstore
 group by Customer_Name 
 having sum(Sales)> (select avg(Total_Sales) from
(select sum(Sales) as Total_Sales from superstore group by Customer_Name) as CustomerSales );
   
   -- Q24  Find the top-selling product in each country.
   with productsales as (
   select 
   Product_Name,sum(Sales) as Total_Sales,Country ,
   rank() over(partition by Country order by sum(Sales) desc ) as ProductRank
   from superstore 
   group by Country,Product_Name)
   select Product_Name,Country,Total_Sales from productsales where productrank = 1;
    -- or-------
   WITH ProductSales AS
(
    SELECT
        Country,
        Product_Name,
        SUM(Sales) AS Total_Sales,
        RANK() OVER
        (
            PARTITION BY Country
            ORDER BY SUM(Sales) DESC
        ) AS ProductRank
    FROM superstore
    GROUP BY Country, Product_Name
)

SELECT
    Country,
    Product_Name,
    Total_Sales
FROM ProductSales
WHERE ProductRank = 1
ORDER BY Country;

-- Create a view for the sales summary.
create view  
SalesSummary  as select  Category,
(sum(Sales),2) as Total_Sales from superstore
  group by Category;
   select *from SalesSummary;
   
 --  Use a CTE to find the top 10 customers
  with TopCustomer as (
  select Customer_Name,sum(Sales) Total_Sales from superstore 
  group by Customer_Name) 
  select *from TopCustomer order by Total_Sales desc limit 10 ;
  
   -- Classify Products Based on Profit (CASE WHEN)
select Product_Name,round(sum(Profit),2) as Total_Profit ,
case
when sum(Profit) >=5000 then "High Profit"
when sum(Profit) between 1000 and 4999.9 then "Medium Profit"
else "Low Profit"
end as Profit_Category from superstore
group by Product_Name order by Total_Profit desc;

-- Year-wise Sales Trend
select Order_Year ,round(sum(Sales),2) as Total_Sales from superstore group by Order_Year order by Total_Sales ;

-- Monthly Sales Trend
select  monthname(Order_Date) Month_Order,
round(sum(Sales),2) as Total_Sales 
from superstore 
group by Month_Order,month(Order_Date)
 order by month(Order_Date);
 
 -- Top 5 Most Profitable Countries
 select 
 country,round(sum(Profit),2)Total_Profit 
 from superstore group by Country
 order by Total_Profit desc limit 5;
  
-- . Sales and Profit by Year
select
 Order_Year, round(sum(Sales),2) Total_Sales,
 round(sum(Profit),2) Total_Profi
 t from superstore 
 group by Order_Year 
 order by Order_Year; 

-- Top Customer in Each Region (Window Function)
with CustomerSales as ( 
select
 Region, Customer_Name ,round(sum(Sales),2) Total_Sales,
 rank() over(partition by Region order by sum(Sales) desc) SalesRank  from superstore
group by Region,Customer_Name )
select Region,Customer_Name,Total_Sales from CustomerSales where SalesRank=1;

   
 