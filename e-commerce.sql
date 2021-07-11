USE sql_store;

SELECT*
FROM customers WHERE state IN ('VA', 'FL', 'GA');

/* identifying customers that have more than 1000 points and compiling it as a stored procedure for reference*/
USE sql_store;

DELIMITER $$
CREATE PROCEDURE get_highestpoints_customers()
BEGIN
SELECT*
FROM customers
WHERE points >= 1000;
END $$

DELIMITER $$ 


/*identifying the orders that are not shipped. It is given by orders that do not have a shipper id yet.*/

SELECT*
FROM orders
WHERE shipper_id IS NULL;

/*getting the top 5 customers with maximum points*/

SELECT*
FROM customers ORDER BY points DESC
LIMIT 5;
/*extracting the date of order and its status for the customers*/

USE sql_store;

SELECT
o.order_id,
o.order_date,
c.first_name,
c.last_name,
os.name AS status
FROM orders o 
JOIN customers c 
ON o.customer_id = c.customer_id
JOIN order_statuses os
ON o.status = os.order_status_id;

/*getting the list of customers whether or not they have an order*/

USE sql_store;

SELECT
c.customer_id,
c.first_name,
o.order_id
FROM orders o
RIGHT JOIN customers c
ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

/*setting orders that have been placed in 2019 as active and remainig as archived to have clarity
 and then compiling it inot a new table named updated_status*/
USE sql_store;

CREATE TABLE updated_status(
SELECT
order_id,
order_date,
'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT
order_id,
order_date,
'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01');

/*marking customers with points > 3000 as Gold customers*/
USE sql_store;
UPDATE orders
SET comments = 'Gold customer'
WHERE customer_id IN
(SELECT customer_id
FROM customers
WHERE points > 3000);

/*getting customers located in Virginia who have spent more than 100$*/
USE sql_store;
SELECT
   c.customer_id,
   c.first_name,
   c.last_name,
   SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers C
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE state = 'VA'
GROUP BY
    c.customer_id,
   c.first_name,
   c.last_name
HAVING total_sales > 100; /*only one customer named Ines retrieved*/

/*finding the products that have never been ordered*/

USE sql_store;
SELECT*
FROM products
WHERE product_id NOT IN (
SELECT DISTINCT product_id
FROM order_items
);
/*customers who ordered product having id =3*/
USE sql_store;
SELECT*
FROM customers
WHERE customer_id IN(
	SELECT
    o.customer_id
    from order_items oi
    JOIN orders o USING (order_id)
    WHERE product_id = 3 
    );
    
/* extracting the phone records of the customers in the database*/    

USE sql_store;

SELECT
    CONCAT(first_name, '', last_name) as customer,
    COALESCE(phone, 'Unkown') AS phone
FROM customers    


   









