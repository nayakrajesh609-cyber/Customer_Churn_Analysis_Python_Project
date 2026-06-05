--Check Table
select top 10 * from advanced_customer_transactions_dataset
--Total customers
select COUNT(distinct customerid) as Total_Customer from advanced_customer_transactions_dataset
--Revenue by category
select productcategory, SUM(Amount) as Revenue
from advanced_customer_transactions_dataset
group by productcategory
--Churn logic
select customerid, MAX(orderdate) as Last_Order,
case
when MAX(orderdate) < DATEADD(day, -90, GETDATE()) then 1
else 0
 END AS Churn
FROM advanced_customer_transactions_dataset
GROUP BY CustomerID;
--Average order value per customer
select customerid, AVG(amount) as Avg_order_Value
from advanced_customer_transactions_dataset
group by customerid
--Repeat vs one-time customers
select 
     case when count(orderid) = 1 then 'One_Time'
     else 'Repeat'
end as Customer_Type,
COUNT(*) as Total_Customers
from advanced_customer_transactions_dataset
group by CustomerID
--Monthly revenue trend
select 
     FORMAT(orderdate,'yyyy-MM') as Month_,
     SUM(Amount) as Revenue
     from advanced_customer_transactions_dataset
group by  FORMAT(orderdate,'yyyy-MM')
order by Month_
--Daily average sales
select
     CAST(Orderdate as date) as Day_,
     AVG(Amount) as Avg_Sales
from advanced_customer_transactions_dataset
group by CAST(Orderdate as date)

--Window Functions (Very Important)
--Rank customers by spending
select customerid, sum(amount) as TotalSpend,
RANK() over(order by sum(amount) desc) as Customer_Ranking
from advanced_customer_transactions_dataset
group by customerid
--Running total (cumulative revenue)
select orderdate,
       sum(amount) over(order by orderdate) as RunningRevenue
from advanced_customer_transactions_dataset

--Segmentation in SQL (Like RFM)
--High / Medium / Low spenders
select customerid, sum(amount) as TotalSpend,
       case
       when sum(amount) > 5000 then 'High Value'
       when sum(amount) > 2000 then 'Medium Value'
       else 'Low'
end as Segment
from advanced_customer_transactions_dataset
group by CustomerID

--Product & Business Insights
--Top selling category
select productcategory, SUM(Amount) as Total_Revenue
from advanced_customer_transactions_dataset
group by productcategory
order by Total_Revenue desc
--Region performance
select Region, count(orderid) as Total_Orders, sum(amount) as Total_Revenue
from advanced_customer_transactions_dataset
group by Region
order by sum(amount) desc

--Advanced Churn Insight
--Days since last purchase
select customerid,
       DATEDIFF(DAY, max(orderdate), (select max(Orderdate) from advanced_customer_transactions_dataset))
       as Days_Inactive
from advanced_customer_transactions_dataset
group by CustomerID
-- Less than 30 Days
select customerid, Days_Inactive
from (select customerid,
       DATEDIFF(DAY, max(orderdate), (select max(Orderdate) from advanced_customer_transactions_dataset))
       as Days_Inactive
from advanced_customer_transactions_dataset
group by CustomerID) as T
where Days_Inactive < 30

--Cohort Analysis
select customerid,
       min(format(orderdate, 'yyyy-MM')) as FirstPurchaseMonth
from advanced_customer_transactions_dataset
group by CustomerID
--Calculate Monthly Revenue Trend here
select FORMAT(orderdate, 'yyyy-MM') as Month_,
       SUM(Amount) as Monthly_Revenue
from advanced_customer_transactions_dataset
group by FORMAT(orderdate, 'yyyy-MM')
order by Month_


