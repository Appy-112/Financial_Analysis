CREATE DATABASE FinancialDB;
GO
USE FinancialDB;

CREATE TABLE FinancialData (
    Date DATE,
    Year INT,
    Month INT,
    Quarter NVARCHAR(10),
    Branch NVARCHAR(50),
    ProductCategory NVARCHAR(100),
    ProductName NVARCHAR(200),
    UnitsSold INT,
    UnitPrice DECIMAL(18,2),
    TotalSales DECIMAL(18,2),
    COGS DECIMAL(18,2),
    ProfitMargin DECIMAL(5,2),
    GrossProfit DECIMAL(18,2),
    OperatingExpenses DECIMAL(18,2),
    ExpenseRatio DECIMAL(5,2),
    NetProfit DECIMAL(18,2),
    PaymentMethod NVARCHAR(50),
    Region NVARCHAR(50)
);


ALTER TABLE FinancialData
DROP COLUMN Year, Month, Quarter, ProfitMargin, ExpenseRatio, ProductName;


SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

EXEC sp_rename 'dbo.[Cleaned financial data]', 'CleanedFinancialData';

--Total Revenue and profit
SELECT 
    YEAR([Date]) AS Year,
    SUM([TotalSales]) AS TotalRevenue,
    SUM([GrossProfit]) AS TotalProfit
FROM dbo.CleanedFinancialData
GROUP BY YEAR([Date])
ORDER BY Year;

--Top 5 branches by total revenue
SELECT TOP 5
    [Branch],
    SUM([TotalSales]) AS TotalRevenue
FROM dbo.Cleanedfinancialdata
GROUP BY [Branch]
ORDER BY TotalRevenue DESC;

--Profit margin by product
SELECT 
    ProductCategory,
    ROUND(SUM(GrossProfit) * 100.0 / NULLIF(SUM(TotalSales), 0), 2) AS ProfitMarginPct
FROM dbo.Cleanedfinancialdata
GROUP BY ProductCategory
ORDER BY ProfitMarginPct DESC;


--Monthly sales trend
SELECT
    YEAR([Date]) AS Year,
    MONTH([Date]) AS Month,
   ROUND(SUM([TotalSales]),2) AS MonthlySales
FROM dbo.Cleanedfinancialdata
GROUP BY YEAR([Date]), MONTH([Date])
ORDER BY Year, Month;


--Sales by region
SELECT
    [Region],
    ROUND(SUM([TotalSales]),2) AS TotalRevenue
FROM dbo.Cleanedfinancialdata
GROUP BY [Region]
ORDER BY TotalRevenue DESC;

--Payment method popularity
SELECT
    PaymentMethod,
    COUNT(*) AS Transactions,
    CAST(
        ROUND(
            COUNT(*) * 100.0 /
            (SELECT COUNT(*) FROM dbo.Cleanedfinancialdata),
        2) AS DECIMAL(5,2)
    ) AS PercentageOfTotal
FROM dbo.Cleanedfinancialdata
GROUP BY PaymentMethod
ORDER BY Transactions DESC;




