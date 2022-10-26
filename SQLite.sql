--TASK 1--
--Write query which will show those customers with contacts and with orders (all columns)

-- first udenstanding: id of customers who have at least one order and address is filled
SELECT
	orders.customer_id,
    orders.order_id,
    contacts.address
FROM orders
LEFT JOIN contacts ON contacts.customer_id = orders.customer_id 
WHERE NOT contacts.address ISNULL
	and NOT orders.order_id ISNULL
order by orders.customer_id
;


--TASK 2--
-- There is  suspision that some orders were wrongly inserted more times. Check if there are any duplicated orders. If so, return unique duplicates with the following details:
-- first name, last name, email, order id and item

SELECT
	customers.first_name,
    customers.last_name,
    contacts.email,
    orders.order_id,
    orders.item
from orders
left join contacts on contacts.customer_id = orders.customer_id 
left join customers on customers.customer_id = orders.customer_id 
GROUP BY orders.order_id
having count(orders.order_id) > 1
order by order_id;


--TASK 3-	
-- As you found out, there are some duplicated order which are incorrect, adjust query so it does following:
-- Show first name, last name, email, order id and item
-- Does not show duplicates
-- Order result by customer last name

SELECT
	customers.first_name,
    customers.last_name,
    contacts.email,
    orders.order_id,
    orders.item
from orders
left join contacts on contacts.customer_id = orders.customer_id 
left join customers on customers.customer_id = orders.customer_id 
GROUP BY orders.order_id
order by customers.last_name;


--TASK 4--
--Our company distinguishes orders to sizes by value like so:
--order with value less or equal to 25 euro is marked as SMALL
--order with value more than 25 euro but less or equal to 100 euro is marked as MEDIUM
--order with value more than 100 euro is marked as BIG
--Write query which shows only three columns: full_name (first and last name divided by space), order_id and order_size
--Make sure the duplicated values are not shown
--Sort by order ID (ascending)

select 
	customers.first_name || ' ' || customers.last_name AS full_name,
	orders.order_id,
    case 
    	when orders.order_value <= 25 then 'SMALL'
        when orders.order_value <= 100 then 'MEDIUM'
        else 'BIG'
	end as order_size
from orders
left join customers on customers.customer_id = orders.customer_id 
group by orders.order_id
order by orders.order_id ASC;

--TASK 5--
-- Show all items from orders table which containt in their name 'ea' or start with 'Key'

SELECT
	item
from orders
where item like '%ea%'
	or item like 'Key%'
group by item;

--TASK 6--
-- Please find out if some customer was referred by already existing customer
-- Return results in following format "Customer Last name Customer First name" "Last name First name of customer who recomended the new customer"
-- Sort/Order by customer last name (ascending)


select 
	--customers.customer_id,
    customers.last_name,
    customers.first_name,
    --customers.referred_by_id,
    ref.last_name || ' ' || ref.first_name AS referred_by
from customers
left join customers AS ref ON ref.customer_id = customers.referred_by_id
where customers.referred_by_id in(
	SELECT
  		customer_id
	from customers)
order by customers.last_name ASC
;


