-- Question 7: For each customer, what is their top genre by amount spent?

SELECT CustomerId, FirstName, LastName, GenreName AS TopGenre, GenreTotalSpent
FROM
	(SELECT Customer.CustomerId AS CustomerID, Customer.FirstName AS FirstName, Customer.LastName AS LastName,
	Genre.Name AS GenreName, SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS GenreTotalSpent,
	RANK() OVER (PARTITION BY Customer.CustomerId ORDER BY SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) DESC, Genre.Name ASC) AS GenreRank
	FROM Customer
	LEFT JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
	LEFT JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
	LEFT JOIN Track ON InvoiceLine.TrackId = Track.TrackId
	LEFT JOIN Genre ON Track.GenreId = Genre.GenreId
	GROUP BY Customer.CustomerId, Genre.GenreId)
WHERE GenreRank = 1
ORDER BY CustomerId;