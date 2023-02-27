/*Which brand saw the most dollars spent in the month of June*/

SELECT b.BRAND_CODE, 
       SUM(i.TOTAL_FINAL_PRICE) AS dollars_spent
FROM brands b
join receipt_items i ON b.BRAND_CODE = i.BRAND_CODE
JOIN receipts r ON r.ID = i.REWARDS_RECEIPT_ID
WHERE EXTRACT(MONTH FROM r.PURCHASE_DATE) = 06
GROUP BY b.BRAND_CODE
ORDER BY dollars_spent DESC
LIMIT 1;

/* Which user spent the most money in the month of August */

SELECT user_id , 
       SUM(total_spent) AS total_amount
FROM receipts
WHERE EXTRACT(MONTH FROM PURCHASE_DATE) = 08
GROUP BY user_id
ORDER BY total_amount DESC
LIMIT 1;

/* What user bought the most ecxpensive item */

/*First_Method*/
SELECT r.user_id, r.id AS receipts_id, 
       i.REWARDS_RECEIPT_ITEM_ID AS receipt_item_id, 
	   SUM(TOTAL_FINAL_PRICE/QUANTITY_PURCHASED) AS item_price
FROM RECEIPTS r
JOIN receipt_items i ON r.ID = i.REWARDS_RECEIPT_ID
GROUP BY  r.user_id, r.id, i.REWARDS_RECEIPT_ITEM_ID
HAVING sum(QUANTITY_PURCHASED) > 0
ORDER BY item_price DESC
LIMIT 1;

/*Second_Method*/
WITH item_price AS(
SELECT REWARDS_RECEIPT_ID, ITEM_INDEX, TOTAL_FINAL_PRICE/QUANTITY_PURCHASED AS item_price
FROM receipt_items
GROUP BY REWARDS_RECEIPT_ID, ITEM_INDEX)

SELECT r.user_id, MAX(p.item_price)
FROM receipts r
JOIN item_price p ON r.ID = p.REWARDS_RECEIPT_ID;

/*What is the name of the most expensive item purchased*/ 

/*First_Method*/
SELECT r.id AS receipts_id, 
	   i.ITEM_INDEX AS item_index,
       i.REWARDS_RECEIPT_ITEM_ID AS receipt_item_id, 
	   SUM(TOTAL_FINAL_PRICE/QUANTITY_PURCHASED) AS item_price,
       description
FROM RECEIPTS r
JOIN receipt_items i ON r.ID = i.REWARDS_RECEIPT_ID
GROUP BY  r.id, i.item_index, i.REWARDS_RECEIPT_ITEM_ID
HAVING sum(QUANTITY_PURCHASED) > 0
ORDER BY item_price DESC
LIMIT 1;

/*Second_Method*/
WITH item_price AS(
SELECT REWARDS_RECEIPT_ID, ITEM_INDEX, TOTAL_FINAL_PRICE/QUANTITY_PURCHASED AS item_price, description
FROM receipt_items
GROUP BY REWARDS_RECEIPT_ITEM_ID, ITEM_INDEX)

SELECT *
FROM item_price
ORDER BY item_price DESC
LIMIT 1;

/*How many users scanned in each month*/

SELECT EXTRACT(YEAR FROM date_scanned) AS year,
	   EXTRACT(month from date_scanned) AS month,
       COUNT(DISTINCT USER_ID)
FROM receipts
GROUP BY year, month
ORDER BY year, month;
