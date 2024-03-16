
-- MODIFYING EMAIL BY USING REPLACE
SELECT
       [EmailAddress]
	   --,[MODIFIED EMAIL] = REPLACE([EmailAddress], 'adventure-works', 'hotmail')
       ,[LENGTH] = LEN([EmailAddress]) - 20
	   ,[USERNAME] = LEFT([EmailAddress], LEN([EmailAddress]) - 20)
  FROM [AdventureWorks2019].[Person].[EmailAddress]

  -- SETTING AREA CODE AND PIN FROM [PhoneNumber] AND GETTING LENGTH OF [PhoneNumber]
  SELECT 
      [PhoneNumber]
	  ,[Area code] = LEFT([PhoneNumber],3)
	  ,[Area PIN] = RIGHT([PhoneNumber],4)
	  ,[LENGTH] = LEN([PhoneNumber])
      ,[PhoneNumberTypeID]
      ,[ModifiedDate]
  FROM [AdventureWorks2019].[Person].[PersonPhone]

  --WHERE [PhoneNumber] NOT LIKE '%(%'

  WHERE LEN([PhoneNumber]) = 12

  --DATE MATH

  SELECT 
      -- [ORDER YEAR] =  YEAR([OrderDate])
      
      [OrderDate],
	  [current date] = CAST('07-31-2013' AS DATE),
	  [ELAPSED DAYS] = DATEDIFF(DAY,[OrderDate], CAST('07-31-2013' AS DATE)),
	  [AGING BUCKET] = 
	  CASE 
	  WHEN  DATEDIFF(DAY,[OrderDate], CAST('07-31-2013' AS DATE)) < 10 THEN '<10'
	  WHEN  DATEDIFF(DAY,[OrderDate], CAST('07-31-2013' AS DATE)) BETWEEN 10 AND 19 THEN '10-19'
	  ELSE '20+'
	  END
      ,[TotalDue]
  FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]

  --WHERE [OrderDate] < DATEFROMPARTS(2011,6,1)
  -- WHERE [OrderDate] BETWEEN DATEFROMPARTS(2011,6,1) AND DATEFROMPARTS(2012,6,1)
  --WHERE YEAR([OrderDate]) = 2011
  
  --DATEMATH
 -- SELECT [CURRENT] = GETDATE(),
--[FIRST DAY OF MONTH] = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1),
--[FIRST DAY OF PREVIOUS MONTH] = DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))


-- AGGREGATED FUNCTIONS ONE
SELECT 
[JobTitle],
[Gender],
[EMPLOYEE COUNT] = COUNT(*),
[VACATION TIME] = SUM([VacationHours])

FROM [AdventureWorks2019].[HumanResources].[Employee]
GROUP BY [JobTitle], --PULLS DISTINCT JOB TITLES
[Gender]


SELECT COUNT(*) FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] --PULLS ALL ROWS


SELECT COUNT([CurrencyRateID]) FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] --EXCLUDES NULL VALUES FROM THE TABLE

SELECT SUM([TotalDue]) FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] 
WHERE [OnlineOrderFlag] = 1

SELECT MIN([TotalDue]) FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]

SELECT MAX([TotalDue]) FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]

SELECT AVG([TaxAmt] + [Freight]) FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] --IF THE VALUES ARE NON-DECIMAL THEN MULTIPLY BY 1.0


-- AGGREGATED FUNCTIONS TWO

 SELECT 
[PRODUCT COUNT] = COUNT(*),
[TOTAL SALES] = SUM(A.[LineTotal]),
[PRODUCT] = B.[Name],
B.Size

  FROM [AdventureWorks2019].[Sales].[SalesOrderDetail] A
  JOIN [AdventureWorks2019].[Production].[Product] B 
  ON A.ProductID = B.ProductID

  WHERE B.Size IS NOT NULL

  GROUP BY B.Name, B.Size
  HAVING SUM(A.[LineTotal]) > 10000

  --ORDER BY [TOTAL SALES] --BOTH ALIAS NAME AND CALCULATED REFERENCED VALUE CAN BE USED IN ORDER BY
  ORDER BY SUM(A.[LineTotal])
 
 
 
  SELECT 
  [LastName],
  [COUNT] = COUNT(*)

  FROM [AdventureWorks2019].[Person].[Person]

  GROUP BY [LastName]
  HAVING COUNT(*) > 1
   
   SELECT 
  [COUNT] = COUNT(*)

  FROM [AdventureWorks2019].[Person].[Person]
  WHERE [LastName] ='Adams'

  --THE DIFF BETWEEN HAVING AND WHERE IS THAT HAVING OPERATES ON AGGREGATED GROUPS OF OUR AGGREGATED QUERIES WHILE WHERE OPERATES ON INDIVIDUAL ROWS OF DATA
  --AGGREGATED FUNCTIONS LIKE GROUP BY AND HAVING ARE EXECUTED AFTER WHERE FUNCTION
  --1.SELECT
  --2.FROM
  --3.WHERE
  --4.GROUP BY
  --5.HAVING
  --6.ORDER BY


  -- JOIN
SELECT B.FirstName
      ,B.LastName
	  ,B.PersonType
      ,A.[BusinessEntityID]
      ,A.[TerritoryID]
      ,A.[SalesQuota]
      ,A.[Bonus]
      ,A.[CommissionPct]
      ,A.[SalesYTD]
      ,A.[SalesLastYear]
      ,A.[rowguid]
      ,A.[ModifiedDate]
	  ,C.[Group]
  FROM [AdventureWorks2019].[Sales].[SalesPerson] A
  JOIN [AdventureWorks2019].[Person].[Person] B
  ON A.[BusinessEntityID] = B.[BusinessEntityID]
  JOIN [AdventureWorks2019].[Sales].[SalesTerritory] C
  ON A.TerritoryID = C.TerritoryID
  WHERE C.[Group] = 'Europe'

  -- OUTER JOIN
SELECT
A.[BusinessEntityID],
A.[FirstName],
A.[LastName],
B.[JobTitle],
B.[VacationHours],
B.[SickLeaveHours],
C.EmailAddress


FROM [AdventureWorks2019].[Person].[Person] A
LEFT OUTER JOIN [AdventureWorks2019].[HumanResources].[Employee] B  --PULLS ALL RELEVANT RECORDS FROM  PRIMARY TABLE A(LEFT SIDE)
--LEFT JOIN IS USED MORE COMMONLY THAN RIGHT JOIN
ON A.BusinessEntityID = B.BusinessEntityID
AND B.VacationHours > 50  -- WE PUT THIS COMMAND HERE AND NOT AFTER WHERE STATEMENT, SO THAT WE GET ALL RECORDS FROM TABLE A
INNER JOIN [AdventureWorks2019].[Person].[EmailAddress] C
ON A.BusinessEntityID = C.BusinessEntityID --JOINING TO A INSTEAD OF B, SINCE WE NEED ALL RECORDS FROM TABLE A

WHERE A.FirstName = 'John'

-- UNION
SELECT [SalesOrderID]
,[ORDER TYPE] = 'CUSTOMER ORDER'  --TO DISTINGUISH BETWEEN PURCHASE AND SALES ORDERS
      
      ,[OrderDate]
      
  FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]
  
  where YEAR([OrderDate]) = 2013

  UNION

  SELECT  [PurchaseOrderID]
      ,[ORDER TYPE] = 'VENDOR ORDER' --TO DISTINGUISH BETWEEN PURCHASE AND SALES ORDERS
      ,[OrderDate]
      
  FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader]
  WHERE YEAR([OrderDate]) = 2013


  SELECT 
      [OrderDate]
      
  FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]
  
  where YEAR([OrderDate]) = 2013

  UNION ALL -- PULLS ALL VALUES WITHOUT DISTINGUISHING

  SELECT  
      [OrderDate]
      
  FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader]
  WHERE YEAR([OrderDate]) = 2013

