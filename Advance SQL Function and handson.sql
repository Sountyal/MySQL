use market_star_schema;

-- Module: Advanced SQL
-- Session: Window Functions	
-- Window Functions in Detail

-- Rank Function
-- rank() over 
-- (partition by <expression>
-- order by <expression> desc <expression>)

select customer_name , ord_id, round(sales) as Rounded_sales, 
rank() over (order by sales desc) as Sales_Rank
from market_fact_full m
inner join
cust_dimen c
on m.cust_id = c.cust_id
where  customer_name = "Rick wilson"
limit 10
;

-- Top 10 Sales from a customer
with rank_info as(
select customer_name , ord_id, round(sales) as Rounded_sales, 
rank() over (order by sales desc) as Sales_Rank
from market_fact_full m
inner join
cust_dimen c
on m.cust_id = c.cust_id
where  customer_name = "Rick wilson"
)
select * from rank_info
where sales_rank <=10;



-- 1. Rank the orders made by Aaron Smayling in the decreasing order of the resulting sales.

with rank_info as(
select customer_name , ord_id, round(sales) as Rounded_sales, 
rank() over (order by sales desc) as Sales_Rank
from market_fact_full m
inner join
cust_dimen c
on m.cust_id = c.cust_id
where  customer_name = "Aaron Smayling"
)
select * from rank_info
where sales_rank <=10;


-- 2. For the above customer, rank the orders in the increasing order of the discounts provided. Also display the
-- dense ranks.

select Ord_id, Discount,Customer_Name
,rank() over ( order by Discount) as Discount_Rank
,dense_rank() over ( order by Discount) as Discount_denseRank
,percent_rank() over ( order by Discount) as Discount_percentRank
from market_fact_full m
inner join
cust_dimen c
on m.cust_id = c.cust_id
where Customer_Name = "Rick wilson"
;



-- 3. Rank the customers in the decreasing order of the number of orders placed.
select customer_name, count(distinct ord_id) as count_ord,
rank() over (order by count(distinct ord_id) desc) as order_rank
,dense_rank() over (order by count(distinct ord_id) desc) as order_denserank
,row_number() over (order by count(distinct ord_id) desc) as row_number_
from market_fact_full m
inner join
cust_dimen c
on m.cust_id = c.cust_id
-- where Customer_Name = "Rick wilson"
group by customer_name
;

-- 4. Create a ranking of the number of orders for each mode of shipment based on the months in which they were
-- shipped. 
with shipping_summary as(
select ship_mode,
		month(ship_date) as shipping_month,
        count(*) as shipments
from 
shipping_dimen
group by Ship_Mode, shipping_month)

select *, rank() over (partition by ship_mode order by shipments desc) as shipping_Rank
from shipping_summary;


-- -----------------------------------------------------------------------------------------------------------------
-- Named Windows

-- 1. Rank the orders in the increasing order of the shipping costs for all orders placed by Aaron Smayling. Also
-- display the row number for each order.
select Ord_id, Discount,Customer_Name
,rank() over w as Discount_Rank
,dense_rank() over w as Discount_denseRank
,row_number() over w as Discount_rowNumber
from market_fact_full m
inner join cust_dimen c 
on m.cust_id = c.cust_id
window w as (partition by customer_name  order by Discount desc);


-- -----------------------------------------------------------------------------------------------------------------
-- Frames

-- 1. Calculate the month-wise moving average shipping costs of all orders shipped in the year 2011.

with daily_shippig_summary as 
( select ship_date,
		sum(shipping_cost) as daily_total
from market_fact_full as m
inner join
shipping_dimen as s
on m.ship_id = s.ship_id
group by ship_date)

select *, 
		sum(daily_total) over w1 as running_total,
        avg(daily_total) over w2 as moving_average
from daily_shippig_summary
window w1 as (  order by ship_date  rows unbounded preceding )
, w2 as (  order by ship_date rows 6 preceding );


with cust_order as (
select c.customer_name, 
		m.ord_id, 
        o.order_date
from 
cust_dimen as c
inner join
market_fact_full as m
on c.cust_id = m.cust_id
inner join
orders_dimen as o
on o.ord_id = m.ord_id
where customer_name = 'rick wilson'
group by c.customer_name, 
		m.ord_id, 
        o.order_date
), 
next_date_summry as (
select *,
		lead(order_date, 1,"2015-01-01") over(order by order_date, ord_id) as next_order_date
from 
cust_order
order by customer_name, order_date, ord_id
)

select *, datediff(next_order_date,order_date) as days_diff
from next_date_summry
;


with cust_order as (
select c.customer_name, 
		m.ord_id, 
        o.order_date
from 
cust_dimen as c
inner join
market_fact_full as m
on c.cust_id = m.cust_id
inner join
orders_dimen as o
on o.ord_id = m.ord_id
where customer_name = 'rick wilson'
group by c.customer_name, 
		m.ord_id, 
        o.order_date), 
next_date_summry as (
select *,
		lag(order_date, 1,"2009-06-01") over(order by order_date, ord_id) as next_order_date
from 
cust_order
order by customer_name, order_date, ord_id
)
select *, datediff(next_order_date,order_date) as days_diff
from next_date_summry
;

-- -----------------------------------------------------------------------------------------------------------------
-- Session: Programming Constructs in Stored Functions and Procedures
-- IF Statements

-- 1. Classify an order as 'Profitable' or 'Not Profitable'.





-- -----------------------------------------------------------------------------------------------------------------
-- CASE Statements

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

select market_fact_id,
		profit,
        case
			when profit <500 then 'Huge loss'
            when profit <500 then 'Bearable loss '
            when profit <500 then 'Decent profit'
            else 'Great profit'
            end as Profit_Type
from 
	market_fact_full;            

-- 2. Classify the customers on the following criteria (TODO)
--    Top 20% of customers: Gold
--    Next 35% of customers: Silver
--    Next 45% of customers: Bronze

with customer_summary as (
select m.cust_id, 
		c.customer_name, 
		round(sum(m.sales)) as total_sales,
        percent_rank() over ( order by round(sum(m.sales)) desc) as perc_rank
from market_fact_full as m
left join
cust_dimen as c 
on m.cust_id = c.cust_id
group by cust_id)

select *,
		case 
			when perc_rank < 0.2 then 'Gold'
			when perc_rank < 0.35 then 'Silver'
			else 'Bronze'
        end as Customer_category        
from customer_summary;
  
-- -----------------------------------------------------------------------------------------------------------------
-- Stored Functions

-- 1. Create and use a stored function to classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit



-- -----------------------------------------------------------------------------------------------------------------
-- Stored Procedures

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

-- The market facts with ids '1234', '5678' and '90' belong to which categories of profits?


