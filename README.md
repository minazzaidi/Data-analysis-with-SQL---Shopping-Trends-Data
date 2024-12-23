Shopping Trends Analysis with SQL
---

This repository contains SQL scripts used for analyzing shopping trends and customer behaviors based on transactional data. The analysis covers insights into purchase frequencies, customer demographics, and overall trends.
---
**Project Overview**

The project demonstrates the use of SQL for data analysis by exploring key questions about customer purchasing behaviors. Key objectives include:
* Identifying purchase frequencies across customer segments.
* Extracting age-related purchasing patterns.
* Analyzing customer uniqueness and trends.

  ---

**🖥️ Usage**
* Load the SQL file into a compatible database system like MySQL.
* Execute the queries step-by-step to analyze the dataset.
* Customize queries as needed to address specific analytical questions.

---
**Data Cleaning**

In the dataset, we have 3900 records and no record is null. Besides that there is only 1 column for which I need unique values which is customer ID which has no duplicates.
So there is no need to clean the data.

---

**📊 Key Insights**

**Question:  Which age group has the highest purchase frequency?**

* From the list of frequency of purchases highest frequency of purchase is Bi-weekly.

* From the list Minimum Age is 18 and Maximum Age is 70. 

* Bifurcating the age group in 3 (18-29) as Young Adults, (30-45) as Middle Aged Adults and (45 Above) as Old Adults.

**(Below is example of sql query used for the analysis. For more queries please navigate to the sql query file)**
```sql
SELECT DISTINCT Frequency_of_Purchases FROM shopping_trends;
                
SELECT MIN(Age), MAX(Age) FROM shopping_trends;

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
```

Refer below image for results

![image](https://github.com/user-attachments/assets/84375420-e415-4876-ae86-81a430afe984)

**Insights:**

      We have Old Adults as age group with highest frequency of purchase that is Bi-weekly with a total count of 254.

---

**Question: What is the average purchase amount by gender?**

![image](https://github.com/user-attachments/assets/ad00760d-ce55-40b8-9f49-7db233cbfdf3)

**Insights:**

    Average purchase amount by Gender is 59$ and 60$ for Male and Female respectively.
---

**Question: How does subscription status affect purchase amounts?**

![image](https://github.com/user-attachments/assets/8699144c-8304-42fd-bd27-f5cd497c1aa2)

    From the record 27% of customers are subscribers and 73% of customers are not subscribers.

![image](https://github.com/user-attachments/assets/efcbf3a0-55f6-41c6-b087-bf87b134d7b6)

**Insights:**

      * From the record percentage of amount spend on purchase for subscribed and unsubscribed customers is 26% and 73%. 
      * This is proportional to the percentage of subscribed and unsubscribed customers. 
      * So we can say that there is no significant affect on purchase amount on customers based on their subscription status.

---
**Question: Which item in each category generates the highest revenue?**

![image](https://github.com/user-attachments/assets/f59a2119-5eb2-4c21-896a-8c50f4568f66)

**Insights**

    In Accessories - Jewellery is the product that generates the highest revenue (10010 USD),
    In Clothing - Blouse is the product that generates the highest revenue (10410 USD),
    In Footwear - Shoes is the product that generates the highest revenue (9240 USD) ,
    In Outerwear - Coat is the product that generates the highest revenue (9275 USD).

---

**Question: What are the Top 5 locations by total revenue generated?**

![image](https://github.com/user-attachments/assets/bd852876-9cf3-443c-807a-1c7d84f2d779)

**Insights:**
  
    Top 5 location by Revenue is (Montana,Illinois,California,Idaho,Nevada)
---
**Question: How many purchases were made using promo codes?**

![image](https://github.com/user-attachments/assets/369069e9-78b6-4a27-96a0-a45ce2f7aed7)

**Insights:**
    Using Promo Codes 1677 purchases are made which amounts to 43% of total purchases

---
**Question: Who are the top 10 customers based on their total purchase amount?**

![image](https://github.com/user-attachments/assets/cd2f37b4-b54f-4154-aa92-4d4a22d4b07d)

**Insights:**
    Top 10 Customers based on their purchase amount is with Customer IDs (43, 96, 194, 205, 244, 249, 456, 519, 582, 616)

---
**Question: What is the most commonly used payment method?**

![image](https://github.com/user-attachments/assets/b0d044ce-c240-427a-90ce-8d23f6d5ff5f)

**Insights:**

    Most commonly used payment method is by Credit Card

---
**Question: Which shipping type is most frequently used by customers?**

![image](https://github.com/user-attachments/assets/01eb678f-b04a-4a44-b74f-642b33c43238)

**Insights**

    Free Shipping is the most frequently used shipping method.
---

**Question: Which season drives the highest sales in terms of purchase amount?**

![image](https://github.com/user-attachments/assets/417631e7-e497-472b-a905-3ee2cb149f08)

**Insights**

    Highest sales is recorded in the Fall season

---
**Question: Find 5 Top rated Items based on Customer reviews?**

![image](https://github.com/user-attachments/assets/58f215d5-3b84-477d-817a-fff856bc0278)

**Insights**

    Gloves,Sandals,Boots,Hat,T-shirt are the Top 5 rated products.

**THANK YOU FOR YOUR TIME!!!!**




