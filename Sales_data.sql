 
use sales_data;

SELECT * FROM sales_data;



-- Total Revenue
SELECT 
		SUM(sales) as Total_Sales
 
FROM sales_data



-- Total Unit Cost
;
(
	SELECT 
		SUM(Price_Each) as Total_Unit_Cost

	FROM Sales_data
)
-- Total Order Quantity
(
	SELECT 
			SUM(Quantity_Ordered) as Total_Order_Quantity

	FROM Sales_data
)



-- Total Ordered_Products per Day
SELECT 
		Product,
		SUM(Quantity_Ordered) as Total_Ordered,
		Year(Order_Date) as Year,
		DATENAME(MONTH, Order_Date) as Month_NAME,
		DATENAME(DAY, Order_Date) as Day,
		City
FROM sales_data 
GROUP BY Product, DATENAME(MONTH, Order_Date), YEAR(Order_Date), DATENAME(DAY, Order_Date), City
ORDER BY Product, DATENAME(MONTH, Order_Date), YEAR(Order_Date), DATENAME(DAY, Order_Date), CIty


-- 
SELECT 
		Product,
		SUM(Quantity_Ordered) as Total_Ordered,
		DATENAME(MONTH, Sales) as Month_NAME,
		Year(Order_Date) as Year
FROM sales_data
GROUP BY Product, Year(Order_Date), DATENAME(MONTH, Sales)
ORDER BY Product, YEAR(Order_Date), DATENAME(MONTH, Sales) DESC


-- Total sales per products in each year

SELECT	 
		DISTINCT(Product), 
		Year(Order_Date) as Year,
		SUM(Sales) as [Total_Sales],
		City
FROM sales_data
GROUP BY Product, Year(Order_Date), City
ORDER BY Product, Year(Order_Date), City, Total_Sales DESC



-- AVG Sales of ALL & Distinct Products

SELECT 
		AVG(Sales) as [Avg Sales],
		AVG(DISTINCT Sales) as [Avg Sales(All Product)]
FROM sales_data



-- TOTAL SALES PER PRODUCTS EACH MONTH

SELECT	
		DISTINCT(Product), 
		SUM(Sales) as [Monthly_sales],		
		DATENAME(Month, Sales) as Month_Name,
		Year(Order_Date) as Year,
		City
FROM sales_data
GROUP BY Product, DATENAME(Month, Sales), Year(Order_Date), City
ORDER BY Product, DATENAME(Month, Sales), Year(Order_Date), City DESC



-- Average Sales per products in each month

SELECT 
		DISTINCT(Product), DATENAME(MONTH, Sales) as Month_Name,
		AVG(Sales) as [Avg Sales],
		SUM(Sales) as [Total Sales],
		City
FROM sales_data
GROUP BY Product, DATENAME(MONTH, Sales), City
ORDER BY Product, DATENAME(MONTH, Sales), City DESC

		
-- PRODUCT sold below average price

SELECT 
		DISTINCT(Product), DATENAME(MONTH, Sales) as Month_Name,
		COUNT(DISTINCT Product) as [Product Sold],
		AVG(Sales) as [Sales Below Avg]
FROM sales_data
WHERE Sales < (SELECT AVG(Sales) FROM sales_data)
GROUP BY Product, DATENAME(MONTH, Sales)
ORDER BY Product, DATENAME(MONTH, Sales) DESC

   
-- Month-On-Month Profit Margin

;with Month_sales as
(
	SELECT
			DATENAME(Month, Sales) as Month_Name,
			DATEPART(Month, Sales) as Month_Number,
			SUM(Sales) as Total_Sales
	FROM sales_data
	Group by DATENAME(Month, Sales), DATEPART(Month, Sales)
),
-- LAG is used in calculating previous month
-- The Figure 1 is to indicate by each month

prev_sales_Amount as
(
	SELECT 
			Month_name,
			Total_Sales,
			lag(Total_Sales,1,Total_Sales)over(order by Month_Number) as prev_sales_Amount
	FROM Month_sales
)
-- CAST is used to convert 
-- DECIMAL is used to determine the decimal point. Example: either to two(2) or three(3) decimal point.
(
	SELECT 
			psA.*,
			CAST((psA.Total_Sales - psA.prev_sales_Amount) / prev_sales_Amount * 100 as DECIMAL(7,2)) as MOM_Growth
	FROM prev_sales_Amount psA
);


SELECT * FROM sales_data


SELECT 
		DISTINCT Product, DATENAME(Month, Sales) as Month_Name,
		Sales,
		City,
		RANK() OVER(ORDER BY Quantity_Ordered) as Monthly_Qty_Rank
FROM sales_data
ORDER BY DATENAME(Month, Sales), Product, City DESC

 


 SELECT 
		Product,
		SUM(Quantity_Ordered) as Order_by_State,
		Order_Date,
		City
FROM sales_data
GROUP BY Product, Order_Date, City
ORDER BY Product, Order_Date, CIty


SELECT 
		SUM(Quantity_Ordered)
FROM sales_data


SELECT
		COUNT(DISTINCT Product) as Total Items
FROM sales_data