-- Question 3: Which employees generated the most revenue through their assigned customers, and who is each employee's manager?

SELECT employee.FirstName AS EmployeeFirstName, employee.LastName AS EmployeeLastName,
manager.FirstName AS ManagerFirstName, manager.LastName AS ManagerLastName,
COALESCE(SUM(invoice.Total), 0) AS EmployeeRevenue
FROM Employee AS employee
LEFT JOIN Employee AS manager ON employee.ReportsTo = manager.EmployeeId
LEFT JOIN Customer AS customer ON customer.SupportRepId = employee.EmployeeId
LEFT JOIN Invoice AS invoice ON invoice.CustomerId = customer.CustomerId
GROUP BY employee.EmployeeId
ORDER BY EmployeeRevenue DESC, employee.LastName ASC, employee.FirstName ASC;