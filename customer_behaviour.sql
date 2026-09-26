select gender, sum(purchase_amount) as revneue
from customer
group by gender;

select customer_id, purchase_amount
from customer
where discount_applied = 'yes' and purchase_amount >= (select AVG(purchase_amount) from customer);

select item_purchased, AVG(review_rating) as "Average Product Rating"
from customer 
group by item_purchased
order by avg(review_rating) desc
limit 5;

select shipping_type, AVG(purchase_amount)
from customer
where shipping_type in ('standard', 'express')
group by shipping_type;

select subscription_status,
count(customer_id) as total_customer,
Round(AVG(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;

select item_purchased, round(sum(case when discount_applied = 'Yes' Then 1 Else 0 end )/count(*) *100,2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

WITH customer_type AS (
    SELECT customer_id, previous_purchases, 
    CASE
        WHEN previous_purchases = 1 THEN 'new'
        WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
        ELSE 'loyal'
    END AS customer_segment
    FROM customer
)
SELECT customer_segment, COUNT(*) AS "Number of Customers"
FROM customer_type
GROUP BY customer_segment;

WITH item_count AS (
    SELECT category, 
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer 
    GROUP BY category, item_purchased
)
SELECT item_rank, category, item_purchased, total_orders
FROM item_count
WHERE item_rank <= 3;

select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;

select age_group, sum(purchase_amount) as total_revenue
from customer
group by age_group 
order by total_revenue desc;
