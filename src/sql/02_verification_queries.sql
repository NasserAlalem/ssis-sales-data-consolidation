SELECT 
    SourceFile,
    COUNT(*) AS TotalRows,
    SUM(Qty) AS TotalQuantity,
    SUM(Val) AS SumUnitVal,
    SUM(TotalAmount) AS TotalRevenue,
    MIN(SaleDate) AS EarliestDate,
    MAX(SaleDate) AS LatestDate
FROM dbo.Fact_Sales_Consolidated
GROUP BY SourceFile
WITH ROLLUP;

SELECT 
    COUNT(*) AS CalculationMismatchCount
FROM dbo.Fact_Sales_Consolidated
WHERE ABS(TotalAmount - (Qty * Val)) > 0.01;

SELECT TOP 5 * FROM dbo.Fact_Sales_Consolidated WHERE SourceFile = 'Distributor 1'
UNION ALL
SELECT TOP 5 * FROM dbo.Fact_Sales_Consolidated WHERE SourceFile = 'Distributor 2'
UNION ALL
SELECT TOP 5 * FROM dbo.Fact_Sales_Consolidated WHERE SourceFile = 'Distributor 3';