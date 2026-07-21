-- Question 1: Who are the top 5 highest-spending customers, and how much has each spent in total?

SELECT Customer.CustomerId, Customer.FirstName, Customer.LastName, SUM(Invoice.Total) AS InvoicesSum
FROM Customer
LEFT JOIN Invoice
ON Invoice.CustomerID = Customer.CustomerId
GROUP BY Customer.CustomerId
ORDER BY InvoicesSum DESC, LastName ASC, FirstName ASC
LIMIT 5;