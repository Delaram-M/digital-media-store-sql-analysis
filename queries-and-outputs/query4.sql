-- Question 4: What is the running cumulative total of revenue, month by month, over the store's history?

SELECT Month, MonthRevenue, SUM(MonthRevenue) OVER (ORDER BY Month) AS CumulativeRevenue
FROM
	(SELECT strftime('%Y-%m', InvoiceDate) AS Month, SUM(Invoice.Total) AS MonthRevenue
	FROM Invoice
	GROUP BY Month)
ORDER BY Month;