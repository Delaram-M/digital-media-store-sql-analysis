-- Question 5: Which tracks have never been purchased?

SELECT Track.TrackId, Track.Name, COUNT(InvoiceLine.Quantity) AS PurchaseCount
FROM Track
LEFT JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Track.TrackId
HAVING PurchaseCount = 0
ORDER BY Track.Name ASC, Track.TrackId ASC;