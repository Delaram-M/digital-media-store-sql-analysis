-- Question 6: Which 5 countries generate the most revenue, and what is the average revenue per customer in each?

SELECT Country, CountryRevenue, CountryCustomerCount,  ROUND(CountryRevenue / CountryCustomerCount, 2)  AS CountryRevenuePerCustomer
FROM 
	(SELECT Customer.Country AS Country, SUM(Invoice.Total) AS CountryRevenue, COUNT(DISTINCT Customer.CustomerId) AS CountryCustomerCount
	FROM Customer
	LEFT JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
	GROUP BY Country)
ORDER BY CountryRevenue DESC, Country ASC
LIMIT 5;