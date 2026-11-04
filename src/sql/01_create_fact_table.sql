CREATE TABLE dbo.Fact_Sales_Consolidated (
    ItemCode        VARCHAR(50)     NOT NULL,
    SaleDate        DATE            NOT NULL,
    Qty             INT             NOT NULL,
    Val             DECIMAL(18, 2)  NOT NULL,
    TotalAmount     DECIMAL(18, 2)  NOT NULL,
    SourceFile      VARCHAR(100)    NOT NULL,
    LoadDate        DATETIME        DEFAULT GETDATE()
);
