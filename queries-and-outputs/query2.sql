-- Question 2: What is total revenue by genre?

SELECT Genre.GenreId, Genre.Name, COALESCE(SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity), 0)  AS GenreRevenue
FROM Genre
LEFT JOIN Track ON Genre.GenreId = Track.GenreId
LEFT JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Genre.Name
ORDER BY GenreRevenue DESC, Genre.Name ASC;