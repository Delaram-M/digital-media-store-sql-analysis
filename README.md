# Digital Media Store SQL Analysis

In this project, multiple questions about a digital media store is addressed through analyzing data in a SQLite database with SQL queries.


## Data Source

The SQLite database used for this project is from the
<a href="https://github.com/lerocha/chinook-database">Chinook Database</a> <a href="https://github.com">GitHub</a> repostiory of <a href="https://github.com/lerocha">Luis Rocha</a>.


## Queries and Outputs

The queries and query outputs of each question are included in the `queries-and-outputs` folder. For example, the query for the first question is `queries-and-outputs\query1.sql` and the query output for the first question is `queries-and-outputs\query1-output.csv`.


## Questions

In this project, we address the following questions using SQL queries:

1. Who are the top 5 highest-spending customers, and how much has each spent in total?
2. What is total revenue by genre?
3. Which employees generated the most revenue through their assigned customers, and who is each employee's manager?
4. What is the running cumulative total of revenue, month by month, over the store's history?
5. Which tracks have never been purchased?
6. Which 5 countries generate the most revenue, and what is the average revenue per customer in each?
7. For each customer, what is their top genre by amount spent?

<br>

### Question 1: Who are the top 5 highest-spending customers, and how much has each spent in total?

SQL query:

```sql
SELECT Customer.CustomerId, Customer.FirstName, Customer.LastName, SUM(Invoice.Total) AS InvoicesSum
FROM Customer
LEFT JOIN Invoice
ON Invoice.CustomerID = Customer.CustomerId
GROUP BY Customer.CustomerId
ORDER BY InvoicesSum DESC, LastName ASC, FirstName ASC
LIMIT 5;
```

Query output:

| CustomerId | FirstName | LastName | InvoicesSum |
|---|---|---|---|
| 6 | Helena | Holý | 49.62 |
| 26 | Richard | Cunningham | 47.62 |
| 57 | Luis | Rojas | 46.62 |
| 45 | Ladislav | Kovács | 45.62 |
| 46 | Hugh | O'Reilly | 45.62 |

Question response:

The top 5 highest-spending customers are the following:
- Helena Holý (with 49.62 total spending)
- Richard Cunningham (with 47.62 total spending)
- Luis Rojas (with 46.62 total spending)
- Ladislav Kovács (with 45.62 total spending)
- Hugh O'Reilly (with 45.62 total spending)

The top 5 highest-spending customers have close total spendings ranging from 49.62 to 45.62.

<br>

### Question 2: What is total revenue by genre?

SQL query:
```sql
SELECT Genre.GenreId, Genre.Name, COALESCE(SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity), 0)  AS GenreRevenue
FROM Genre
LEFT JOIN Track ON Genre.GenreId = Track.GenreId
LEFT JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Genre.Name
ORDER BY GenreRevenue DESC, Genre.Name ASC;
```


Query output:

| GenreId | Name | GenreRevenue |
|---|---|---|
| 1 | Rock | 826.65 |
| 7 | Latin | 382.14 |
| 3 | Metal | 261.36 |
| 4 | Alternative & Punk | 241.56 |
| 19 | TV Shows | 93.53 |
| 2 | Jazz | 79.2 |
| 6 | Blues | 60.39 |
| 21 | Drama | 57.71 |
| 24 | Classical | 40.59 |
| 14 | R&B/Soul | 40.59 |
| 20 | Sci Fi & Fantasy | 39.8 |
| 8 | Reggae | 29.7 |
| 9 | Pop | 27.72 |
| 10 | Soundtrack | 19.8 |
| 22 | Comedy | 17.91 |
| 17 | Hip Hop/Rap | 16.83 |
| 11 | Bossa Nova | 14.85 |
| 23 | Alternative | 13.86 |
| 16 | World | 12.87 |
| 18 | Science Fiction | 11.94 |
| 15 | Electronica/Dance | 11.88 |
| 13 | Heavy Metal | 11.88 |
| 12 | Easy Listening | 9.9 |
| 5 | Rock And Roll | 5.94 |
| 25 | Opera | 0 |

Question response:

Each genre and its total revenue are indicated in the above table. Opera is the only genre with no revenue. Rock is by far the genre with highest revenue; Rock has more than twice the revenue of the second highest genre in terms of total revenue.

<br>

### Question 3: Which employees generated the most revenue through their assigned customers, and who is each employee's manager?


SQL query: 

```sql
SELECT employee.FirstName AS EmployeeFirstName, employee.LastName AS EmployeeLastName,
manager.FirstName AS ManagerFirstName, manager.LastName AS ManagerLastName,
COALESCE(SUM(invoice.Total), 0) AS EmployeeRevenue
FROM Employee AS employee
LEFT JOIN Employee AS manager ON employee.ReportsTo = manager.EmployeeId
LEFT JOIN Customer AS customer ON customer.SupportRepId = employee.EmployeeId
LEFT JOIN Invoice AS invoice ON invoice.CustomerId = customer.CustomerId
GROUP BY employee.EmployeeId
ORDER BY EmployeeRevenue DESC, employee.LastName ASC, employee.FirstName ASC;
```

Query output: 

| EmployeeFirstName | EmployeeLastName | ManagerFirstName | ManagerLastName | EmployeeRevenue |
|---|---|---|---|---|
| Jane | Peacock | Nancy | Edwards | 833.04 |
| Margaret | Park | Nancy | Edwards | 775.4 |
| Steve | Johnson | Nancy | Edwards | 720.16 |
| Andrew | Adams |  |  | 0 |
| Laura | Callahan | Michael | Mitchell | 0 |
| Nancy | Edwards | Andrew | Adams | 0 |
| Robert | King | Michael | Mitchell | 0 |
| Michael | Mitchell | Andrew | Adams | 0 |


Question response:

The following are the 3 revenue-generating employees along with their manager sorted based on total revenue generated:

1. Jane Peacock reporting to Nancy Edwards with 833.04 revenue generated
2. Margaret Park reporting to Nancy Edwards with 775.4 revenue generated
3. Steve Johnson reporting to Nancy Edwards with 720.16 revenue generated


<br>

### Question 4: What is the running cumulative total of revenue, month by month, over the store's history?

SQL query:

```sql
SELECT Month, MonthRevenue, SUM(MonthRevenue) OVER (ORDER BY Month) AS CumulativeRevenue
FROM
	(SELECT strftime('%Y-%m', InvoiceDate) AS Month, SUM(Invoice.Total) AS MonthRevenue
	FROM Invoice
	GROUP BY Month)
ORDER BY Month;
```

Query output:

| Month | MonthRevenue | CumulativeRevenue |
|---|---|---|
| 2009-01 | 35.64 | 35.64 |
| 2009-02 | 37.62 | 73.26 |
| 2009-03 | 37.62 | 110.88 |
| 2009-04 | 37.62 | 148.5 |
| 2009-05 | 37.62 | 186.12 |
| 2009-06 | 37.62 | 223.74 |
| 2009-07 | 37.62 | 261.36 |
| 2009-08 | 37.62 | 298.98 |
| 2009-09 | 37.62 | 336.6 |
| 2009-10 | 37.62 | 374.22 |
| 2009-11 | 37.62 | 411.84 |
| 2009-12 | 37.62 | 449.46 |
| 2010-01 | 52.62 | 502.08 |
| 2010-02 | 46.62 | 548.7 |
| 2010-03 | 44.62 | 593.32 |
| 2010-04 | 37.62 | 630.94 |
| 2010-05 | 37.62 | 668.56 |
| 2010-06 | 37.62 | 706.18 |
| 2010-07 | 37.62 | 743.8 |
| 2010-08 | 37.62 | 781.42 |
| 2010-09 | 36.63 | 818.05 |
| 2010-10 | 37.62 | 855.67 |
| 2010-11 | 37.62 | 893.29 |
| 2010-12 | 37.62 | 930.91 |
| 2011-01 | 37.62 | 968.53 |
| 2011-02 | 37.62 | 1006.15 |
| 2011-03 | 37.62 | 1043.77 |
| 2011-04 | 51.62 | 1095.39 |
| 2011-05 | 42.62 | 1138.01 |
| 2011-06 | 50.62 | 1188.63 |
| 2011-07 | 37.62 | 1226.25 |
| 2011-08 | 37.62 | 1263.87 |
| 2011-09 | 37.62 | 1301.49 |
| 2011-10 | 37.62 | 1339.11 |
| 2011-11 | 23.76 | 1362.87 |
| 2011-12 | 37.62 | 1400.49 |
| 2012-01 | 37.62 | 1438.11 |
| 2012-02 | 37.62 | 1475.73 |
| 2012-03 | 37.62 | 1513.35 |
| 2012-04 | 37.62 | 1550.97 |
| 2012-05 | 37.62 | 1588.59 |
| 2012-06 | 37.62 | 1626.21 |
| 2012-07 | 39.62 | 1665.83 |
| 2012-08 | 47.62 | 1713.45 |
| 2012-09 | 46.71 | 1760.16 |
| 2012-10 | 42.62 | 1802.78 |
| 2012-11 | 37.62 | 1840.4 |
| 2012-12 | 37.62 | 1878.02 |
| 2013-01 | 37.62 | 1915.64 |
| 2013-02 | 27.72 | 1943.36 |
| 2013-03 | 37.62 | 1980.98 |
| 2013-04 | 33.66 | 2014.64 |
| 2013-05 | 37.62 | 2052.26 |
| 2013-06 | 37.62 | 2089.88 |
| 2013-07 | 37.62 | 2127.5 |
| 2013-08 | 37.62 | 2165.12 |
| 2013-09 | 37.62 | 2202.74 |
| 2013-10 | 37.62 | 2240.36 |
| 2013-11 | 49.62 | 2289.98 |
| 2013-12 | 38.62 | 2328.6 |


Question response:

The above table shows each month's revenue and the cumulative revenue. Most months have a revenue of 37.62, and the highest revenue is 52.62 in 2010-01.


<br>

### Question 5: Which tracks have never been purchased?


SQL query:

```sql
SELECT Track.TrackId, Track.Name, COUNT(InvoiceLine.Quantity) AS PurchaseCount
FROM Track
LEFT JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Track.TrackId
HAVING PurchaseCount = 0
ORDER BY Track.Name ASC, Track.TrackId ASC;
```

The following table is the truncated output of the query:

| TrackId | Name | PurchaseCount |
|---|---|---|
| 3027 | "40" | 0 |
| 3412 | "Eine Kleine Nachtmusik" Serenade In G, K. 525: I. Allegro | 0 |
| 109 | #1 Zero | 0 |
| 570 | (Da Le) Yaleo | 0 |
| 3045 | (I Can't Help) Falling In Love With You | 0 |
| 3057 | (Oh) Pretty Woman | 0 |
| 3471 | (There Is) No Greater Love (Teo Licks) | 0 |
| 1947 | (We Are) The Road Crew | 0 |
| 2906 | ...In Translation | 0 |
| 3166 | .07% | 0 |
| ... | ... | ... |
| 2238 | ZeroVinteUm | 0 |
| 968 | Zombie Eaters | 0 |
| 2926 | Zoo Station | 0 |
| 314 | À Francesa | 0 |
| 388 | À Vontade (Live Mix) | 0 |
| 2817 | É Preciso Saber Viver | 0 |
| 2461 | É Uma Partida De Futebol | 0 |
| 333 | É que Nessa Encarnação Eu Nasci Manga | 0 |
| 1073 | Óia Eu Aqui De Novo | 0 |
| 1077 | Último Pau-De-Arara | 0 |

Question response:

The query outputs a list of more than 1500 tracks never purchased saved in `queries-and-outputs\query5-output.csv`.

<br>

### Question 6: Which 5 countries generate the most revenue, and what is the average revenue per customer in each?

SQL query:

```sql
SELECT Country, CountryRevenue, CountryCustomerCount,  ROUND(CountryRevenue / CountryCustomerCount, 2)  AS CountryRevenuePerCustomer
FROM 
	(SELECT Customer.Country AS Country, SUM(Invoice.Total) AS CountryRevenue, COUNT(DISTINCT Customer.CustomerId) AS CountryCustomerCount
	FROM Customer
	LEFT JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
	GROUP BY Country)
ORDER BY CountryRevenue DESC, Country ASC
LIMIT 5;
```

Query output:

| Country | CountryRevenue | CountryCustomerCount | CountryRevenuePerCustomer |
|---|---|---|---|
| USA | 523.06 | 13 | 40.24 |
| Canada | 303.96 | 8 | 37.99 |
| France | 195.1 | 5 | 39.02 |
| Brazil | 190.1 | 5 | 38.02 |
| Germany | 156.48 | 4 | 39.12 |


Question response:

The table above shows a list of top 5 countries in terms of total revenue along with their revenue per customer; USA and Canada have by far the highest revenue, but the revenue per customer of the 5 countries are close.

<br>

### Question 7: For each customer, what is their top genre by amount spent?


SQL query:

```sql
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
```

Query output: 

| CustomerId | FirstName | LastName | TopGenre | GenreTotalSpent |
|---|---|---|---|---|
| 1 | Luís | Gonçalves | Rock | 13.86 |
| 2 | Leonie | Köhler | Rock | 16.83 |
| 3 | François | Tremblay | Metal | 9.9 |
| 4 | Bjørn | Hansen | Rock | 16.83 |
| 5 | František | Wichterlová | Rock | 14.85 |
| 6 | Helena | Holý | TV Shows | 11.94 |
| 7 | Astrid | Gruber | Rock | 14.85 |
| 8 | Daan | Peeters | Rock | 20.79 |
| 9 | Kara | Nielsen | Rock | 20.79 |
| 10 | Eduardo | Martins | Rock | 28.71 |
| 11 | Alexandre | Rocha | Latin | 15.84 |
| 12 | Roberto | Almeida | Latin | 15.84 |
| 13 | Fernanda | Ramos | Rock | 10.89 |
| 14 | Mark | Philips | Rock | 12.87 |
| 15 | Jennifer | Peterson | Rock | 11.88 |
| 16 | Frank | Harris | Metal | 11.88 |
| 17 | Jack | Smith | Rock | 7.92 |
| 18 | Michelle | Brooks | Rock | 18.81 |
| 19 | Tim | Goyer | Rock | 14.85 |
| 20 | Dan | Miller | Latin | 13.86 |
| 21 | Kathy | Chase | Rock | 8.91 |
| 22 | Heather | Leacock | Metal | 11.88 |
| 23 | John | Gordon | Latin | 11.88 |
| 24 | Frank | Ralston | Rock | 11.88 |
| 25 | Victor | Stevens | Rock | 13.86 |
| 26 | Richard | Cunningham | Rock | 13.86 |
| 27 | Patrick | Gray | Rock | 15.84 |
| 28 | Julia | Barnett | Rock | 16.83 |
| 29 | Robert | Brown | Rock | 24.75 |
| 30 | Edward | Francis | Rock | 18.81 |
| 31 | Martha | Silk | Latin | 12.87 |
| 32 | Aaron | Mitchell | Latin | 13.86 |
| 33 | Ellie | Sullivan | Rock | 18.81 |
| 34 | João | Fernandes | Rock | 14.85 |
| 35 | Madalena | Sampaio | Rock | 15.84 |
| 36 | Hannah | Schneider | Metal | 17.82 |
| 37 | Fynn | Zimmermann | Rock | 10.89 |
| 38 | Niklas | Schröder | Rock | 20.79 |
| 39 | Camille | Bernard | Rock | 12.87 |
| 40 | Dominique | Lefebvre | Rock | 16.83 |
| 41 | Marc | Dubois | Rock | 9.9 |
| 42 | Wyatt | Girard | Metal | 13.86 |
| 43 | Isabelle | Mercier | Rock | 17.82 |
| 44 | Terhi | Hämäläinen | Rock | 17.82 |
| 45 | Ladislav | Kovács | Rock | 10.89 |
| 46 | Hugh | O'Reilly | TV Shows | 13.93 |
| 47 | Lucas | Mancini | Rock | 17.82 |
| 48 | Johannes | Van der Berg | Rock | 17.82 |
| 49 | Stanisław | Wójcik | Rock | 21.78 |
| 50 | Enrique | Muñoz | Rock | 21.78 |
| 51 | Joakim | Johansson | Latin | 11.88 |
| 52 | Emma | Jones | Latin | 14.85 |
| 53 | Phil | Hughes | Rock | 17.82 |
| 54 | Steve | Murray | Rock | 10.89 |
| 55 | Mark | Taylor | Rock | 21.78 |
| 56 | Diego | Gutiérrez | Alternative & Punk | 8.91 |
| 57 | Luis | Rojas | Rock | 8.91 |
| 58 | Manoj | Pareek | Rock | 12.87 |
| 59 | Puja | Srivastava | Rock | 11.88 |

Question response:

The above table shows the top genre in terms of total spending for each customer. Rock seems to be the most frequent genre, which is unsurprising considering it was the genre with the highest revenue.




## Attributions

The database used for this project is from the
<a href="https://github.com/lerocha/chinook-database">Chinook Database</a> <a href="https://github.com">GitHub</a> repostiory of <a href="https://github.com/lerocha">Luis Rocha</a>.

The following is the <a href="https://github.com/lerocha/chinook-database?tab=License-1-ov-file#chinook-database">Chinook Database License</a>:


> Copyright (c) 2008-2024 Luis Rocha
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


