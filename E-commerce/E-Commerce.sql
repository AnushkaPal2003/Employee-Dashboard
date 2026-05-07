---E-Commerce SQL Project Questions---

create database ecommerce;
use ecommerce;
select * from orders;
select * from order_items;
select * from customers;
select * from products;


-----------------------A. Customer Analysis-----------------------------------


--- Find total number of customers.
select count(customer_id) as [Total Customers] from customers;

--- Identify customers who have placed at least one order.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

--- Find customers who have never placed any order.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
 where o.order_id is Null;

--- Calculate total number of orders per customer.
select 
CONCAT(c.first_name, ' ', c.last_name) AS name,  
count(o.order_id) as [Total Orders]
from customers c 
left join 
orders o 
on c.customer_id=o.customer_id
group by c.customer_id, c.first_name,c.last_name

--- Identify repeat customers (more than 1 order).
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
having count(o.order_id)>1;

--- Find top 5 customers based on total spending.
select top 5 c.customer_id, concat(c.first_name,' ',c.last_name) as [Name], 
sum(oi.quantity * oi.list_price * (1 - oi.discount)) as [Total Amount] 
from customers c
inner join 
orders o on c.customer_id=o.customer_id
inner join 
order_items oi on o.order_id=oi.order_id group by c.customer_id, 
concat(c.first_name,' ',c.last_name) 
order by 
sum(oi.quantity*oi.list_price) desc;

--- Calculate average spending per customer.
select c.customer_id, concat(c.first_name,' ',c.last_name) as [Name], 
avg(oi.quantity * oi.list_price * (1 - oi.discount)) as [Total Average Spending] 
from customers c
inner join 
orders o on c.customer_id=o.customer_id
inner join 
order_items oi on o.order_id=oi.order_id group by c.customer_id, 
concat(c.first_name,' ',c.last_name) 
order by 
avg(oi.quantity*oi.list_price) desc;

--- Segment customers into High, Medium, Low spenders based on total purchase.
select c.customer_id, concat(c.first_name,' ',c.last_name) as [Name], 
sum(oi.quantity * oi.list_price * (1 - oi.discount)) as [Total Amount], case
when sum(oi.quantity * oi.list_price * (1 - oi.discount))>5000 then 'High'
when sum(oi.quantity * oi.list_price * (1 - oi.discount)) Between 2000 and 5000 then 'Medium'
else 'Low' end as 'segment'
from customers c
inner join 
orders o on c.customer_id=o.customer_id
inner join 
order_items oi on o.order_id=oi.order_id group by c.customer_id, 
concat(c.first_name,' ',c.last_name);


----------------------------B. Sales Analysis-----------------------------------


--- Calculate total revenue generated.
select 
sum(oi.quantity * oi.list_price * (1 - oi.discount)) as [Total Revenue] 
from customers c
inner join 
orders o on c.customer_id=o.customer_id
inner join 
order_items oi on o.order_id=oi.order_id;
select * from orders;
select * from order_items;
select * from customers;
select * from products;
--- Find total number of orders placed.
select count(order_id) as [Total Orders] from orders;

--- Calculate average order value (AOV).
select avg(quantity*list_price-(1-discount)) as [AOV] from order_items;
--- Find total revenue per month.
select sum(case 
when o.order_status<>4 then 0
else oi.quantity*oi.list_price*(1-oi.discount) END) 
as [Total revenue], Month(o.order_date) 
as [Month] from 
orders o inner join order_items oi on
o.order_id=oi.order_id group by MONTH(o.order_date);

--- Count number of orders per month.
select Month(o.order_date) as [Month], count(o.order_id) as [Total orders] 
from orders o 
inner join 
order_items oi on 
o.order_id=oi.order_id 
group by Month(o.order_date);

--- Identify the month with highest sales.
select top 1 month(o.order_date) as [Month], 
sum(oi.quantity*oi.list_price*(1-oi.discount)) as [Revenue]
from orders o 
inner join 
order_items oi on
o.order_id=oi.order_id 
group by month(o.order_date) 
order by sum(oi.quantity*oi.list_price*(1-oi.discount)) desc;

--- Find daily revenue trend.
select o.order_date, oi.quantity*oi.list_price*(1-oi.discount) as [Revenue]
from orders o inner join order_items oi
on o.order_id=oi.order_id
group by o.order_date, oi.quantity*oi.list_price*(1-oi.discount)
order by o.order_date;


------------------------- C. Product Analysis --------------------------------


select * from orders;
select * from order_items;
select * from customers;
select * from products;
select * from categories;
--- Find total number of products sold.
select sum(oi.quantity) as [Total products sold] from order_items oi inner join products p on oi.product_id=p.product_id;

--- Identify top 5 best-selling products (by quantity).
select top 5 p.product_name, sum(oi.quantity) as [Total Quantity] 
from products p inner join order_items oi on
p.product_id=oi.product_id group by 
p.product_name order by sum(oi.quantity) desc;

--- Identify top 5 products by revenue.
select top 5 p.product_name, sum(oi.quantity*oi.list_price*(1-oi.discount)) as [Total Revenue] 
from products p inner join order_items oi on
p.product_id=oi.product_id group by 
p.product_name order by sum(oi.quantity*oi.list_price*(1-oi.discount)) desc;

--- Find least-selling products.
select top 5 p.product_name, sum(oi.quantity) as [Total Quantity] 
from products p inner join order_items oi on
p.product_id=oi.product_id group by 
p.product_name order by sum(oi.quantity) asc;

--- Find products that were never ordered.
select top 5 p.product_name, sum(oi.quantity) as [Total Quantity] 
from products p inner join order_items oi on
p.product_id=oi.product_id group by 
p.product_name having sum(oi.quantity)<1;

--- Calculate total revenue generated by each product.
select p.product_name, sum(oi.quantity*oi.list_price*(1-oi.discount)) as [Total Revenue] 
from products p inner join order_items oi on
p.product_id=oi.product_id group by 
p.product_name;

--- Find average price of products sold.
select p.product_name, avg(oi.quantity*oi.list_price*(1-oi.discount)) as [Average Revenue]
from products p inner join order_items oi on
p.product_id=oi.product_id group by 
p.product_name;


-----------------------D. Order Analysis-------------------------

select * from orders;
select * from order_items;
select * from customers;
select * from products;
select * from categories;

--- Find total items per order.
select order_id, sum(quantity) as [total items] from order_items group by order_id;

--- Calculate total order value for each order.
select order_id, sum(quantity*list_price*(1-discount)) as [Order value] from order_items group by order_id order by sum(quantity*list_price*(1-discount)) desc;

--- Identify high-value orders (value > 5000).
select order_id, sum(quantity*list_price*(1-discount)) as [Order value] from order_items group by order_id having(sum(quantity*list_price*(1-discount))>18000) order by sum(quantity*list_price*(1-discount)) desc;

--- Find orders with more than 8 items.
select order_id, sum(quantity) as [Total items] from order_items group by order_id having(sum(quantity))>8;

--- Find most recent order for each customer.
select customer_id,Name, order_date from(
select concat(c.first_name,' ',c.last_name) as [Name], c.customer_id, 
o.order_date, row_number() 
over
(partition by c.customer_id order by o.order_date desc) 
as rnk from customers c 
inner join
orders o on c.customer_id=o.customer_id) t
where rnk=1;

--- Calculate time taken to ship each order.
select order_id, DATEDIFF(day,order_date, shipped_date) as [Days to ship] from orders;

--- Identify delayed orders (shipped after required date).
select order_id, required_date, shipped_date from orders where shipped_date>required_date;


----------------------E. Advanced SQL (important for interviews)-----------------------------

select * from orders;
select * from order_items;
select * from customers;
select * from products;
select * from categories;

--- Rank customers based on total spending.
select c.customer_id, concat(c.first_name,' ',c.last_name) as [Name], 
sum(oi.quantity*oi.list_price*(1-oi.discount)) as 
[Total Spending], rank() 
over(order by 
sum(oi.quantity*oi.list_price*(1-oi.discount)) desc) as [Rank]
from customers c 
inner join 
orders o on c.customer_id=o.customer_id
inner join order_items oi on o.order_id=oi.order_id group by c.customer_id, concat(c.first_name,' ',c.last_name);

--- Find top 3 products in each month.
select product_name, Mon, Rnn from (
select p.product_name, Month(o.order_date) as [Mon],
sum(oi.quantity) as [Total quantity], 
rank() over(partition by Month(o.order_date) 
order by sum(oi.quantity) desc)
as [Rnn] from products p 
inner join 
order_items oi on
p.product_id=oi.product_id inner join orders o on 
oi.order_id=o.order_id GROUP BY p.product_name, 
MONTH(o.order_date)) t where Rnn<=3;

--- Calculate cumulative revenue over time.
WITH daily_revenue AS (
    SELECT 
        o.order_date,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY o.order_date
)

SELECT 
    order_date,
    revenue,
    SUM(revenue) OVER (
        ORDER BY order_date
    ) AS cumulative_revenue
FROM daily_revenue;


----------------------- From orders and orders_items-------------------------

select * from orders;
select * from order_items;

--- Find total revenue generated.
select sum(quantity*list_price*(1-discount)) as [Total Revenue] from order_items;

--- Calculate total order value for each order.
select order_id, sum(quantity*list_price*(1-discount)) as [Total Order Value] from order_items 
group by order_id;

--- Find average order value.
select 
    sum(quantity * list_price * (1 - discount)) 
    / count(distinct order_id) as average_order_value
from order_items;

--- Identify highest value order.
select top 1 order_id, sum(quantity*list_price*(1-discount)) as 
[Total Order Value] from order_items 
group by order_id order by 
sum(quantity*list_price*(1-discount)) desc;

--- Find orders with more than 5 items.
select order_id, sum(quantity) as [Total items] from order_items group by order_id having sum(quantity)>5;

--- Calculate total quantity sold per order.
select order_id, sum(quantity) as [Total items] from order_items group by order_id;

--- Find delayed orders with their order value.
select oi.order_id, sum(oi.quantity*oi.list_price*(1-oi.discount)) 
as [Order Value]
from orders o inner join order_items oi on
o.order_id=oi.order_id 
where o.shipped_date>o.required_date group by oi.order_id;

--- Find cumulative revenue over time.
with dailyrevenue as (
select oi.order_id, o.order_date, sum(oi.quantity*oi.list_price*(1-oi.discount)) as [Revenue]
from orders o inner join order_items oi on o.order_id=oi.order_id group by o.order_date, oi.order_id)
select order_id, sum(Revenue) over(order by order_date) as [Cummulative Revenue] from dailyrevenue;

--- Find monthly revenue trend.
select month(o.order_date) as [Month], 
sum(oi.quantity*oi.list_price*(1-oi.discount)) as [Revenue]
from orders o inner join order_items oi 
on o.order_id=oi.order_id 
group by month(o.order_date);

--- Identify top 10 revenue-generating orders.
select top 10 oi.order_id, sum(oi.quantity*oi.list_price*(1-oi.discount)) 
as [Revenue]
from orders o inner join
order_items oi on o.order_id=oi.order_id 
group by oi.order_id order by 
sum(oi.quantity*oi.list_price*(1-oi.discount)) desc;


--------------------------- From orders and customers-----------------------------

select * from orders;
select * from customers;

--- Find customers who placed at least one order.
select c.customer_id, concat(c.first_name,' ',c.last_name) as [Name], 
count(o.order_id) as [Total Order]
from customers c 
inner join orders o 
on c.customer_id=o.customer_id 
group by c.customer_id, concat(c.first_name,' ',c.last_name);

--- Find customers who never placed an order.
select c.customer_id, concat(c.first_name,' ',c.last_name) as [Name], 
count(o.order_id) as [Total Order]
from customers c left join orders o on 
c.customer_id=o.customer_id where o.order_id is null group by c.customer_id, 
concat(c.first_name,' ',c.last_name);

--- Count total orders per customer.
select c.customer_id, concat(c.first_name,' ',c.last_name) as [Name], 
count(order_id) as [Total orders]
from customers c inner join orders o on c.customer_id=o.customer_id 
group by c.customer_id, concat(c.first_name,' ',c.last_name);

--- Identify repeat customers.
select c.customer_id, concat(c.first_name,' ',c.last_name) as [Name], 
count(order_id) as [Total orders]
from customers c inner join orders o 
on c.customer_id=o.customer_id 
group by c.customer_id, concat
(c.first_name,' ',c.last_name)
having count(o.order_id)>1;

--- Find most recent order for each customer.
select customer_id, Name, order_date,rnk from (
select c.customer_id,o.order_date, 
concat(c.first_name,' ',c.last_name) as [Name],
rank() over(partition by c.customer_id
order by o.order_date desc) as rnk
from customers c inner join 
orders o on c.customer_id=o.customer_id) t
where rnk=1;

--- Find customers with highest number of orders.
SELECT TOP 1
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS [Name],
    COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC;

--- Find customers who ordered in multiple months.
select c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS [Name],count(distinct(month(o.order_date))) as [Month] from customers c inner join orders o
    on c.customer_id=o.customer_id group by c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) having count(distinct(month(o.order_date)))>1;

--- Find inactive customers (no orders after a date).
select c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS [Name],
    count(distinct(datepart(day,o.order_date))) as [Day] 
    from customers c inner join orders o
    on c.customer_id=o.customer_id 
    group by c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) 
    having count(distinct(datepart(day,o.order_date)))=1;

--- Rank customers based on order count.
select c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS [Name], 
count(o.order_id) as [order count],dense_rank()
over(order by count(o.order_id) desc) as [Rank] from customers c
inner join orders o on c.customer_id=o.customer_id group by 
c.customer_id, CONCAT(c.first_name, ' ', c.last_name)

--- Find first order date for each customer.
select customer_id, Name, order_date,rnk from (
select c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS [Name], o.order_date, 
rank() over(partition by c.customer_id order by o.order_date asc) as [rnk] from
customers c inner join orders o on c.customer_id=o.customer_id) t where rnk=1;

 
---------------------------products + order_items--------------------------------------

select * from order_items;
select * from products;

--- Find top-selling products by quantity.
select p.product_name, sum(oi.quantity) as [Total quantity] from products p inner join order_items oi 
on p.product_id=oi.product_id group by p.product_name order by sum(oi.quantity) desc;

--- Find top-selling products by revenue.
select p.product_name, sum(oi.quantity*oi.list_price*(1-oi.discount)) as [Total Revenue]
from products p inner join order_items oi on p.product_id=oi.product_id group by
p.product_name order by sum(oi.quantity*oi.list_price*(1-oi.discount)) desc;

--- Find least-selling products.
select p.product_name, sum(oi.quantity) as [Total Quantity]
from products p inner join order_items oi on p.product_id=oi.product_id group by
p.product_name order by sum(oi.quantity) asc;

--- Calculate total revenue generated by each product.
select p.product_name, sum(oi.quantity*oi.list_price*(1-oi.discount)) as [Total Revenue]
from products p inner join order_items oi on p.product_id=oi.product_id
group by p.product_name;

--- Find average quantity sold per product.
select p.product_name, avg(oi.quantity) as [Average Quantity]
from products p inner join order_items oi on p.product_id=oi.product_id
group by p.product_name;

--- Find products with highest discount given.
select p.product_name, sum(oi.discount) as [Max discount] from products p inner join order_items oi on
p.product_id=oi.product_id group by p.product_name order by sum(oi.discount) desc;

--- Rank products based on sales quantity.
select p.product_name, sum(oi.quantity) as [Sales Quantity], rank() over(order by sum(oi.quantity) desc)
as [Rank] from products p inner join order_items oi on
p.product_id=oi.product_id group by p.product_name order by sum(oi.quantity) desc;

--- Find products contributing most revenue.
select p.product_name, sum(oi.quantity*oi.list_price*(1-oi.discount)) as [Total Revenue]
from products p inner join order_items oi on p.product_id=oi.product_id
group by p.product_name order by sum(oi.quantity*oi.list_price*(1-oi.discount)) desc;

--- Find products sold in highest number of orders.
select p.product_name, count(order_id) as [Orders Placed] from products p inner join order_items oi 
on p.product_id=oi.product_id group by p.product_name order by count(order_id) desc;

--- Find products never sold.
select p.product_name, count(order_id) as [Orders Placed] from products p inner join order_items oi 
on p.product_id=oi.product_id group by p.product_name having count(order_id)<1;
