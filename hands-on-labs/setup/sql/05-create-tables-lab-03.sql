
IF OBJECT_ID(N'[wwi].[SaleStatistic]', N'U') IS NOT NULL   
DROP TABLE [wwi].[SaleStatistic]

CREATE TABLE [wwi].[SaleStatistic]
( 
	[CustomerId] [int] NOT NULL,
	[TransactionId] [uniqueidentifier]  NOT NULL,
	[TransactionDate] [datetime]  NOT NULL,
	[TotalClicksToPurchase] [int]  NOT NULL,
    [TotalSecondsToPurchase] [int] NOT NULL,
    [Age] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE
)