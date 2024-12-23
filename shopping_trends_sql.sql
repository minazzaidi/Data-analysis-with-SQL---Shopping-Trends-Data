CREATE DATABASE Cart;
USE Cart;
SELECT * FROM shopping_trends;

SELECT COUNT(*) FROM shopping_trends;
SELECT COUNT(DISTINCT Customer_ID) FROM shopping_trends;

--There are 3900 unique records and there are no null values. 

--*Customer Insights:
--1.Which age group has the highest purchase frequency?
SELECT DISTINCT Frequency_of_Purchases FROM shopping_trends;
--From the list of frequency of purchases highest frequency of purchase is Bi-weekly.
SELECT MIN(Age), MAX(Age) FROM shopping_trends;
--From the list Minimum Age is 18 and Maximum Age is 70. 
--Bifurcating the age group in 3 (18-29) as Young Adults, (30-45) as Middle Aged Adults and (45 Above) as Old Adults.

WITH CTE AS 
(SELECT Frequency_of_Purchases, 
       CASE 
			WHEN Age BETWEEN 18 AND 29 THEN 'Young Adults'
			WHEN Age BETWEEN 30 AND 45 THEN 'Middle Aged Adults'
			WHEN Age > 45 THEN 'Old Adults'
			END AS Age_bins
			FROM shopping_trends)
SELECT Age_bins, Frequency_of_Purchases, COUNT(Frequency_of_Purchases) AS cnt 
				FROM CTE GROUP BY Age_bins, Frequency_of_Purchases 
				HAVING Frequency_of_Purchases = 'Bi-Weekly';

--Solution1. We have Old Adults as age group with highest frequency of purchase that is Bi-weekly with a total count of 254.
--Middle Aged Adults	Bi-Weekly	146
--Old Adults	Bi-Weekly	254
--Young Adults	Bi-Weekly	147


--2. What is the average purchase amount by gender?
SELECT gender, AVG(Purchase_Amount_USD) as avg_purchase 
		FROM shopping_trends 
		GROUP BY gender;
--Solution 2. Average of Purchase amount for Male is 59 and for Female is 60


--3. How does subscription status affect purchase amounts?
SELECT * FROM shopping_trends;

SELECT Subscription_Status, COUNT(Subscription_Status) AS cnt, 
COUNT(Subscription_Status)*100/SUM(COUNT(Subscription_Status)) OVER() AS pct 
FROM shopping_trends GROUP BY Subscription_Status;

--From the record 27% of customers are subscribers and 73% of customers are not subscribers.
SELECT Subscription_Status, SUM(Purchase_Amount_USD) as sum_amount, 
SUM(Purchase_Amount_USD)*100/SUM(SUM(Purchase_Amount_USD)) OVER() as pct_amount
FROM shopping_trends GROUP BY Subscription_Status;
--Solution 3. From the record percentage of amount spend on purchase for subscribed and unsubscribed customers is 26% and 73%. 
--This is proportional to the percentage of subscribed and unsubscribed customers. 
--So we can say that there is no significant affect on purchase amount on customers based on their subscription status.


--*Product Performance:
--4. Which item in each category generates the highest revenue?
SELECT Category, Item_Purchased, SUM(Purchase_Amount_USD) as Sum_Revenue
	FROM shopping_trends 
		GROUP BY Category, Item_Purchased 
		ORDER BY Category, SUM(Purchase_Amount_USD) DESC ;
--Solution 4. In Accessories - Jewellery is the product that generates the highest revenue (10010 USD),
--			  In Clothing - Blouse is the product that generates the highest revenue (10410 USD),
--			  In Footwear - Shoes is the product that generates the highest revenue (9240 USD) ,
--		      In Outerwear - Coat is the product that generates the highest revenue (9275 USD)


--5. What are the top 5 best-selling products across all categories during each season?
WITH CTE AS 
(
SELECT Season, Category, Item_Purchased, 
SUM(Purchase_Amount_USD) AS Sum_Revenue,
DENSE_RANK() OVER(PARTITION BY SEASON ORDER BY SUM(Purchase_Amount_USD) DESC) as rnk 
FROM shopping_trends 
GROUP BY Season, Category, Item_Purchased
)
SELECT Season, Category, Item_Purchased, Sum_Revenue, rnk FROM CTE WHERE rnk <= 5;

--Solution5. Fall - (Hat, Jacket, Handbag, Sandals, Blouse)
--			Spring - (Sweater, Skirt, Blouse, Shorts, Shirt)
--			Summer - (Jewelry, Pants, Shoes, Backpack, Scarf)
--			Winter - (Shirt, Sunglasses, Pants, Hoodie, Jewelry)


--6. How does product size or color preference vary by gender?
SELECT Gender, Size, COUNT(Size) AS no_of_orders, 
COUNT(Size)*100/ SUM(COUNT(Size)) OVER() as pct
FROM shopping_trends 
GROUP BY Gender, Size
ORDER BY Gender, COUNT(Size) DESC;

---Solution 6. In Both Male and Female, highest number of orders received are for Size M followed by L, S and XL

WITH CTE AS 
(
SELECT DISTINCT Color, Gender, 
COUNT(Color) as cnt,
RANK() OVER(PARTITION BY Gender ORDER BY COUNT(Color) DESC) as rnk
FROM shopping_trends
GROUP BY Color, Gender
)
SELECT Color, Gender, cnt, rnk FROM CTE 
WHERE rnk <= 5;
-- Solution 6. For Female most number of orders were received for products of Color (Yellow, Olive,Pink,Magenta,Green) And For Male (Silver,Teal,Cyan,Olive,Yellow)

--*Revenue Analysis:
--7. What is the total revenue generated in each location. Also find top 5 location by revenue?
SELECT Location, SUM(Purchase_Amount_USD) as sum_of_revenue
FROM shopping_trends
GROUP BY Location
ORDER BY SUM(Purchase_Amount_USD) DESC;

--Solution 7. Top 5 location by Revenue is (Montana,Illinois,California,Idaho,Nevada)


--8. What is the impact of discount application on purchase amounts?
SELECT Discount_Applied, 
COUNT(Purchase_Amount_USD) as cnt,
AVG(Purchase_Amount_USD) as avg_amount, 
SUM(Purchase_Amount_USD) as sum_amount
FROM shopping_trends
GROUP BY Discount_Applied;

--Solution 8: A summary of average amount does not show any significant difference but the sum of amount 
--				and count of orders is more for those orders where discount is not applied.


--*Promotional Analysis:
--9. How many purchases were made using promo codes?
SELECT Promo_Code_Used, 
COUNT(Promo_Code_Used) as cnt,
COUNT(Promo_Code_Used)*100/SUM(COUNT(Promo_Code_Used)) OVER() as pct
FROM shopping_trends
GROUP BY Promo_Code_Used;
--Solution 9. Using Promo Codes 1677 purchases are made which amounts to 43% of total purchases.

--10. What is the average purchase amount for customers who used promo codes versus those who didn’t?
SELECT Promo_Code_Used,
AVG(Purchase_Amount_USD) as avg_spend 
FROM shopping_trends
GROUP BY Promo_Code_Used;
--Solution 10. Avg spend of customers who used Promo code is 59$ whereas who didnt is 60$.

--*Customer Loyalty:
--11. Who are the top 10 customers based on their total purchase amount?
SELECT Top 10 (Customer_ID),
Purchase_Amount_USD
FROM shopping_trends
ORDER BY Purchase_Amount_USD DESC;

--Solution 11. Top 10 Customers based on their purchase amount is with Customer IDs (43, 96, 194, 205, 244, 249, 456, 519, 582, 616)


--*Payment Insights:
--12. What is the most commonly used payment method?
SELECT Payment_Method, COUNT(Payment_Method) as cnt
FROM shopping_trends
GROUP BY Payment_Method
ORDER BY COUNT(Payment_Method) DESC;
--Solution 12. Most commonly used payment method is by Credit Card.

--*Shipping Analysis:
--13. Which shipping type is most frequently used?
SELECT Shipping_Type, COUNT(Shipping_Type) as cnt
FROM shopping_trends
GROUP BY Shipping_Type
ORDER BY COUNT(Shipping_Type) DESC;
--Free Shipping is the most frequently used shipping method.

--Is there a relationship between shipping type and review ratings?
SELECT Shipping_Type, AVG(Review_Rating) FROM shopping_trends
GROUP BY Shipping_Type;
--No. All Shipping type have average rating of 3.7

--*Seasonal Trends:
--Which season drives the highest sales in terms of purchase amount?
SELECT Season, SUM(Purchase_Amount_USD) as sum_of_revenue
FROM shopping_trends
GROUP BY Season
ORDER BY SUM(Purchase_Amount_USD) DESC;
--Highest sales is recorded in the Fall season

--Find 5 Top rated Items based on Customer reviews?
SELECT Item_Purchased, AVG(Review_Rating) 
FROM shopping_trends
GROUP BY Item_Purchased
ORDER BY AVG(Review_Rating) DESC;
---Solution 14. (Gloves,Sandals,Boots,Hat,T-shirt)
