select * from customer limit 20

--Q1 What is the  total_revenue by male VS female customers?

select gender,SUM(purchase_amount) as revenue from customer
group by gender;

--Q2 Which Customer used a discount still spend more than average purchase amount ?

select customer_id , purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount 
 >=(select AVG(purchase_amount) from customer)

 --Q3 what are the 5 top product  with highest average review rating ?

 select item_purchased , ROUND(AVG(review_rating :: numeric),2) as "Average Review Rating"
 from customer
 group by item_purchased 
 order by AVG(review_rating) desc
 limit 5;

--Q4 Compare the average purchase Amounts between Standard and Express Shipping ?

select shipping_type,
ROUND(AVG(purchase_amount),2)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type

--Q5 Do Suscribed customer spend more? Compare average spend and
--    total revenue between suscribe or non-suscribed?

select subscription_status , COUNT(customer_id) as total_customer ,
ROUND(AVG(purchase_amount),2) as average_spend,
ROUND(SUM(purchase_amount),2) as revenue
from customer 
group by subscription_status
order by revenue, average_spend desc;


-- Q6 which 5 product had the highest percentage of purchases with discount applied?

select item_purchased,
ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELse 0 End)/count(*),2) as discount_rate
from customer 
group by item_purchased
order by discount_rate desc
limit 5

--Q7 Segment Customer into new , loyal and returning based on their total number of previous purchase
--and show the count of  each segment?

with customer_type as (
select customer_id,previous_purchases,
case
    when previous_purchases =1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
	else 'loyal'
	end as customer_segment
	from customer 
)	
select customer_segment, count(*) as "Number of Customer"
from customer_type
group by customer_segment;


--Q8 what are the top 3  most purchased product  within each category ?

with item_count as (
select category , item_purchased,
count(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id)desc) as item_rank
from customer
group by category , item_purchased
)

select item_rank, category,item_purchased,total_orders
from item_count
where item_rank<= 3;


--Q9 Are customer who are repeat buyers(more than 5 previous purchase) Also likely to subscriber?

select subscription_status,
count(customer_id) as repeat_buyers
from customer 
where previous_purchases >5
group by subscription_status

--Q10 What is the revenue contribution of each age_group ?

select age_group,Sum(purchase_amount) as total_revenue
from customer 
group by age_group
order by total_revenue desc;














 