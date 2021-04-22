# Creating a Database and Practicing SQL Queries
This is the project to create a database using data in a spreadsheet in order to practice SQL queries.

## The Goal of this Project
The SQL skill for using a Relational Database Management System (RDMA) is required for many data-related positions these days. In the social media forums like Quora or Reddit, there are many people who search for a public database for practicing their SQL querying skills.

However, although there are many public data sets in a single spreadsheet, there are not many public databases online. Even if you found a data set for the topic you have interest in, the format of the data is usually just one spreadsheet, not a database for most cases. Therefore, it will be very useful to know how to convert a data set in one spreadsheet to a database with multiple tables fitting a relational database format. Knowing the process of this conversion can give us many chances to practice SQL querying skills with a variety of databases.

The goal of this project is to show how to convert a data in one spreadsheet to a relational database for SQL. After the database is created, I will perform several SQL queries using the database.

## Original Data Set
The original data set is Sample Sales Data (`sample_sales_data.csv`) from the Kaggle Datasets. It has 25 columns and 2824 rows. The explanation for each feature is as follows:
- ORDERNUMBER: the identification number for each order
- QUANTITYORDERED: the quantity ordered
- PRICEEACH: the actual price paid for the transaction in terms of percentage of the MSRP (variable across transactions)
- ORDERLINENUMBER: the number of the order line
- SALES: the amount of sales
- ORDERDATE: the order date
- STATUS: the shipping status (Shipped, Resolved, Cancelled, On Hold, Disputed, and In Progress)
- QTR_ID: the quarter of the order date
- MONTH_ID: the month of the order date
- YEAR_ID: the year of the order date
- PRODUCTLINE: the category of products
- MSRP: the manufacture’s suggested retail price (constant across transactions)
- PRODUCTCODE: the identification code for each product
- CUSTOMERNAME: the names of customers
- PHONE: the phone numbers of customers
- ADDRESSLINE1: addressline 1 for customers
- ADDRESSLINE2: address line 2 for customers
- CITY: city names for customers
- STATE: state names for customers (only for customers located in the US)
- POSTALCODE: postal codes for customers
- COUNTRY: countries for customers
- TERRITORY: the regional names of each country (NA, EMEA, Japan, and APAC)
- CONTACTLASTNAME and CONTACTFIRSTNAME: the last and first names of customers
- DEALSIZE: the deal sizes of orders

## Creating an Entity Relationship Diagram (ERD)
The explanation of how to create the Entity Relationship Diagram for this data set is in the following link: https://medium.com/swlh/creating-a-database-converting-a-spreadsheet-to-a-relational-database-part-1-2a9a228bf77a

The final version of the ERD for this data is as follows:

<img src="https://github.com/yjeong5126/sql_sample_sales_data/blob/master/images/final_erd.PNG" width="500" height="300">

## Creating Tables and Inserting Records in MySQL
How to create tables and insert records in MySQL is explained in detail here: https://medium.com/@yjeong5126/creating-a-database-converting-a-spreadsheet-to-a-relational-database-part-2-faf4fc83bae5

## Practicing SQL Queries
- The SQL query questions that I solved for this database are in `sql_queries_questions.txt`.
- The solutions for this questions are in `sql_queries_solutions.sql`.
