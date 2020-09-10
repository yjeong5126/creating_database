-- Q1
-- Select all orders for the 3rd quarter of 2004. (Select the columns for OrderNumber, OrderDate, CustomerName, and Status.)  
SELECT 
    o.OrderNumber, o.OrderDate, cu.CustomerName, s.Status
FROM
    orders o
        INNER JOIN
    customers cu ON cu.CustomerID = o.CustomerID
        INNER JOIN
    status s ON s.StatusID = o.StatusID
WHERE
    YEAR(OrderDate) = 2004
        AND QUARTER(OrderDate) = 3;

-- Q2
-- Select the orders from France, Swenden, or UK in 2005. (Select the columns for OrderNumber, OrderDate, CustomerName, Country, Sales) 
 
SELECT 
    o.OrderNumber,
    o.OrderDate,
    cu.CustomerName,
    co.Country,
    FORMAT(SUM(op.Sales), 0) AS Sales
FROM
    orders o
        INNER JOIN
    customers cu ON cu.CustomerID = o.CustomerID
        INNER JOIN
    cities ci ON ci.CityID = cu.CityID
        INNER JOIN
    countries co ON co.CountryID = ci.CountryID
        INNER JOIN
    orders_products op ON op.OrderID = o.OrderID
WHERE
    Country IN ('France' , 'Sweden', 'UK')
        AND YEAR(o.OrderDate) = 2005
GROUP BY o.OrderNumber
ORDER BY o.OrderNumber;

-- Q3
-- Select the average MSRP for all products with the name "avg_price".
SELECT 
    ROUND(AVG(MSRP), 2) AS avg_price
FROM
    products;
    
-- Q4
-- Select the average MSRP for each ProductLine with the descending order by the average price.
SELECT 
    pl.ProductLine, ROUND(AVG(p.MSRP), 2) AS avg_price
FROM
    products p
        INNER JOIN
    productlines pl ON p.ProductLineID = pl.ProductLineID
GROUP BY pl.ProductLine
ORDER BY AVG(p.MSRP) DESC;

-- Q5 
-- Select the productlines the average prices of which are greater than 100.
 SELECT 
    pl.ProductLine, ROUND(AVG(p.MSRP), 2) AS avg_price
FROM
    products p
        INNER JOIN
    productlines pl ON p.ProductLineID = pl.ProductLineID
GROUP BY pl.ProductLine
HAVING AVG(p.MSRP) > 100;

-- Q6
--  Select all the products with the number of orders for each product
SELECT 
    p.ProductCode, COUNT(DISTINCT op.OrderID) AS '# of Orders'
FROM
    products p
        INNER JOIN
    orders_products op ON op.ProductID = p.ProductID
GROUP BY p.ProductCode
ORDER BY COUNT(DISTINCT op.OrderID) DESC;

-- Q7 
-- Select customers and their phone numbers who are located in Spain or USA

/* Without Subqueries */
SELECT 
    cu.CustomerName, cu.Phone
FROM
    customers cu
        INNER JOIN
    cities ci ON ci.CityID = cu.CityID
        INNER JOIN
    countries co ON co.CountryID = ci.CountryID
WHERE
    co.Country IN ('Spain' , 'USA')
ORDER BY cu.CustomerName; 
    
/* With Subqueries with IN operator - this query is not as good as the query above. But it is shown for the purpose of practicing subqueries.*/
SELECT 
    cu.CustomerName, cu.Phone
FROM
    customers cu
WHERE
    cu.CityID IN (SELECT 
            ci.CityID
        FROM
            cities ci
                INNER JOIN
            countries co ON co.CountryID = ci.CountryID
        WHERE
            co.Country IN ('Spain' , 'USA'))
ORDER BY cu.CustomerName;
            
-- Q8
--  Select the top customers for each country with their total purchasing values
SELECT 
    A.CustomerName AS 'Top Customer',
    A.Country AS Country,
    FORMAT(MAX(A.sales), 0) AS Sales
FROM
    (SELECT 
        cu.CustomerName, co.Country, SUM(op.Sales) AS Sales
    FROM
        customers cu
    INNER JOIN cities ci ON cu.CityID = ci.CityID
    INNER JOIN countries co ON ci.CountryID = co.CountryID
    INNER JOIN orders o ON o.CustomerID = cu.CustomerID
    INNER JOIN orders_products op ON op.OrderID = o.OrderID
    GROUP BY cu.CustomerName) A
GROUP BY A.Country
ORDER BY MAX(A.sales) DESC;

-- Q9 
--  For each product, compare its MSRP and its actual price. 
-- (Use the weighted average price for the actual price. The weight for each order is the ratio of the quantity compared to the total quantity of the product)
 
SELECT 
    pl.ProductLine,
    p.ProductCode,
    p.MSRP,
    ROUND(SUM(p.MSRP * (op.PriceEach / 100) * (op.Quantity / A.Total_Quantity)),
            0) AS AVG_Price
FROM
    Orders_Products op
        JOIN
    Products p ON p.ProductID = op.ProductID
        JOIN
    ProductLines pl ON pl.ProductLineID = p.ProductLineID
        JOIN
    Orders o ON o.OrderID = op.OrderID
        JOIN
    (SELECT 
        p.ProductCode, SUM(op.Quantity) AS Total_Quantity
    FROM
        Products p
    JOIN Orders_Products op ON op.ProductID = p.ProductID
    GROUP BY p.ProductCode) A ON p.ProductCode = A.ProductCode
GROUP BY p.Productcode
ORDER BY pl.ProductLine , p.MSRP DESC;

-- Q10 
-- Calculate the average sales per customer in 2004

SELECT 
    FORMAT(AVG(A.Sales), 0) AS 'Average Sales'
FROM
    (SELECT 
        cu.CustomerName, SUM(op.Sales) AS Sales
    FROM
        orders_products op
    JOIN orders o ON o.OrderID = op.OrderID
    JOIN customers cu ON cu.CustomerID = o.CustomerID
    WHERE
        YEAR(o.OrderDate) = 2004
    GROUP BY cu.CustomerID) A;

-- Q11
-- Create a user-defined function to find the average sales per customer for the selected year and month.
-- Select the average sales per customer for October in 2004 using the user-defined function. 

DELIMITER $$
CREATE FUNCTION f_avg_sale(p_year INT, p_month INT) RETURNS DECIMAL(10,2)
DETERMINISTIC NO SQL READS SQL DATA 
BEGIN
DECLARE v_avg_sale DECIMAL(10,2);
SELECT 
    AVG(A.Sales)
INTO v_avg_sale FROM
    (SELECT 
        cu.CustomerName, SUM(op.Sales) AS Sales
    FROM
        orders_products op
    JOIN orders o ON o.OrderID = op.OrderID
    JOIN customers cu ON cu.CustomerID = o.CustomerID
    WHERE
        YEAR(o.OrderDate) = p_year
            AND MONTH(o.OrderDate) = p_month
    GROUP BY cu.CustomerID) A; 
RETURN v_avg_sale;
END$$
DELIMITER ;

SELECT f_avg_sale(2004, 10) AS avg_sales;

-- Q12
-- Select the CustomerNames and the contact names who purchased more than the average sales in 2004

SELECT 
    cu.CustomerName,
    CONCAT(cu.ContactFirstName,
            ' ',
            cu.ContactLastName) AS 'Contact Name',
    FORMAT(SUM(op.Sales), 0) AS Sales
FROM
    orders_products op
        JOIN
    orders o ON o.OrderID = op.OrderID
        JOIN
    customers cu ON cu.CustomerID = o.CustomerID
WHERE
    YEAR(o.OrderDate) = 2004
GROUP BY cu.CustomerID
HAVING SUM(op.Sales) > (SELECT 
        AVG(A.Sales) AS 'Average Sales'
    FROM
        (SELECT 
            cu.CustomerName, SUM(op.Sales) AS Sales
        FROM
            orders_products op
        JOIN orders o ON o.OrderID = op.OrderID
        JOIN customers cu ON cu.CustomerID = o.CustomerID
        WHERE
            YEAR(o.OrderDate) = 2004
        GROUP BY cu.CustomerID) A)
ORDER BY SUM(op.Sales) DESC;

-- Q13
-- Create a Stored Procedure to call the list of customers who purchased more than the selected values in the selected year.
-- Select the customers who purchased more than $100,000 in 2004 using the stored-procedure.

DELIMITER $$
CREATE PROCEDURE CustomerYearSales(IN p_year INT, IN p_sales Decimal(10,2))
BEGIN
SELECT 
    cu.CustomerName,
    FORMAT(SUM(op.Sales), 0) AS Sales
FROM
    orders_products op
        JOIN
    orders o ON o.OrderID = op.OrderID
        JOIN
    customers cu ON cu.CustomerID = o.CustomerID
WHERE 
	YEAR(o.OrderDate) = p_year
GROUP BY cu.CustomerID
HAVING SUM(op.Sales) > p_sales
ORDER BY SUM(op.Sales) DESC;
END $$
DELIMITER ;

CALL sample_sales_data.CustomerYearSales(2004, 100000);

-- Q14
-- Select the sales for each quarter in 2004 for each country.
-- (Create columns for sales for each quarter using CASE statement).
SELECT 
    co.Country,
    FORMAT(SUM(CASE
            WHEN
                YEAR(o.OrderDate) = 2004
                    AND QUARTER(o.OrderDate) = 1
            THEN
                op.Sales
            ELSE 0
        END),
        0) AS '2004Q1',
    FORMAT(SUM(CASE
            WHEN
                YEAR(o.OrderDate) = 2004
                    AND QUARTER(o.OrderDate) = 2
            THEN
                op.Sales
            ELSE 0
        END),
        0) AS '2004Q2',
    FORMAT(SUM(CASE
            WHEN
                YEAR(o.OrderDate) = 2004
                    AND QUARTER(o.OrderDate) = 3
            THEN
                op.Sales
            ELSE 0
        END),
        0) AS '2004Q3',
    FORMAT(SUM(CASE
            WHEN
                YEAR(o.OrderDate) = 2004
                    AND QUARTER(o.OrderDate) = 4
            THEN
                op.Sales
            ELSE 0
        END),
        0) AS '2004Q4'
FROM
    orders_products op
        JOIN
    orders o ON op.OrderID = o.OrderID
        JOIN
    customers cu ON cu.CustomerID = o.CustomerID
        JOIN
    cities ci ON ci.CityID = cu.CityID
        JOIN
    countries co ON co.CountryID = ci.CountryID
GROUP BY co.country
ORDER BY co.country; 

-- Q15
-- Create a trigger to insert a backup record to the backup table after the original table is updated.
-- (Create a backup table first and then create the trigger)
-- (To check if the trigger works well, update the MSRP = 200 for ProductID = 4)

CREATE TABLE products_backup (
    ProductID INT NOT NULL,
    ProductCode CHAR(9),
    MSRP INT,
    ProductLineID INT,
    PRIMARY KEY (ProductID)
);  

DELIMITER $$
create trigger trigger_products_backup
after update on products
for each row
begin
insert products_backup VALUES (OLD.ProductID, OLD.ProductCode, OLD.MSRP, OLD.ProductLineID);
end$$
DELIMITER ;

UPDATE products 
SET 
    MSRP = 200
WHERE
    ProductID = 4;

SELECT 
    *
FROM
    products
WHERE
    ProductID = 4;
    
SELECT 
    *
FROM
    products_backup;
    
