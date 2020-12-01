
IF OBJECT_ID(N'[wwi].[SaleStatistic]', N'U') IS NOT NULL   
DROP TABLE [wwi].[SaleStatistic]

CREATE TABLE [wwi].[SaleStatistic]
( 
	[CustomerId] [bigint] NOT NULL,
	[TransactionId] [uniqueidentifier]  NOT NULL,
	[TransactionDate] [datetime]  NOT NULL,
	[TotalClicksToPurchase] [bigint]  NOT NULL,
    [TotalSecondsToPurchase] [bigint] NOT NULL,
    [Age] [bigint] NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE
)