IF OBJECT_ID(N'[wwi].[Product]', N'U') IS NOT NULL   
DROP TABLE [wwi].[Product]

CREATE TABLE [wwi].[Product]
(
    ProductId SMALLINT NOT NULL,
    Seasonality TINYINT NOT NULL,
    Price DECIMAL(6,2),
    Profit DECIMAL(6,2)
)
WITH
(
    DISTRIBUTION = REPLICATE
)

IF OBJECT_ID(N'[wwi].[Date]', N'U') IS NOT NULL   
DROP TABLE [wwi].[Date]

CREATE TABLE [wwi].[Date]
(
	DateId int not null,
	Day tinyint not null,
	Month tinyint not null,
	Quarter tinyint not null,
	Year smallint not null
)
WITH
(
    DISTRIBUTION = REPLICATE
)


IF OBJECT_ID(N'[wwi].[Customer]', N'U') IS NOT NULL   
DROP TABLE [wwi].[Customer]  

CREATE TABLE wwi.Customer
(
    CustomerId INT NOT NULL
    ,FirstName NVARCHAR(50) NOT NULL
    ,MiddleInitial NVARCHAR(10) NULL
    ,LastName NVARCHAR(50) NOT NULL
    ,FullName NVARCHAR(110) NOT NULL
    ,Gender NVARCHAR(15) NULL
    ,Age INT NULL
    ,BirthDate DATE NULL
    ,Address_PostalCode NVARCHAR(200) NULL
    ,Address_Street NVARCHAR(2000) NULL
    ,Address_City NVARCHAR(2000) NULL
    ,Address_Country NVARCHAR(2000) NULL
    ,Mobile NVARCHAR(50) NULL
    ,Email NVARCHAR(50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE
)

IF OBJECT_ID(N'[wwi].[Sale]', N'U') IS NOT NULL   
DROP TABLE [wwi].[Sale]

CREATE TABLE [wwi].[Sale]
( 
	[TransactionId] [uniqueidentifier]  NOT NULL,
	[CustomerId] [int]  NOT NULL,
	[ProductId] [smallint]  NOT NULL,
	[Quantity] [tinyint]  NOT NULL,
	[Price] [decimal](9,2)  NOT NULL,
	[TotalAmount] [decimal](9,2)  NOT NULL,
	[TransactionDateId] [int]  NOT NULL,
	[ProfitAmount] [decimal](9,2)  NOT NULL,
	[Hour] [tinyint]  NOT NULL,
	[Minute] [tinyint]  NOT NULL,
	[StoreId] [smallint]  NOT NULL
)
WITH
(
	DISTRIBUTION = HASH ( [CustomerId] ),
	CLUSTERED COLUMNSTORE INDEX,
	PARTITION
	(
		[TransactionDateId] RANGE RIGHT FOR VALUES ( 
			20190101, 20190201, 20190301, 20190401, 20190501, 20190601, 20190701, 20190801, 20190901, 20191001, 20191101, 20191201)
	)
)

IF OBJECT_ID(N'[wwi].[ProductQuantityForecast]', N'U') IS NOT NULL   
DROP TABLE [wwi].[ProductQuantityForecast]

CREATE TABLE [wwi].[ProductQuantityForecast]
( 
	[ProductId] [int]  NOT NULL,
	[TransactionDate] [int]  NOT NULL,
	[Hour] [int]  NOT NULL,
	[TotalQuantity] [int]  NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE
)

INSERT INTO [wwi].[ProductQuantityForecast] VALUES (100, 20201209, 10, 0)
INSERT INTO [wwi].[ProductQuantityForecast] VALUES (200, 20201209, 10, 0)
INSERT INTO [wwi].[ProductQuantityForecast] VALUES (300, 20201209, 10, 0)
INSERT INTO [wwi].[ProductQuantityForecast] VALUES (400, 20201209, 10, 0)
INSERT INTO [wwi].[ProductQuantityForecast] VALUES (500, 20201209, 10, 0)
INSERT INTO [wwi].[ProductQuantityForecast] VALUES (600, 20201209, 10, 0)
INSERT INTO [wwi].[ProductQuantityForecast] VALUES (700, 20201209, 10, 0)
INSERT INTO [wwi].[ProductQuantityForecast] VALUES (800, 20201209, 10, 0)
INSERT INTO [wwi].[ProductQuantityForecast] VALUES (900, 20201209, 10, 0)
INSERT INTO [wwi].[ProductQuantityForecast] VALUES (1000, 20201209, 10, 0)
INSERT INTO [wwi].[ProductQuantityForecast] VALUES (1100, 20201209, 10, 0)
INSERT INTO [wwi].[ProductQuantityForecast] VALUES (1200, 20201209, 10, 0)


IF OBJECT_ID(N'[wwi].[ProductReview]', N'U') IS NOT NULL   
DROP TABLE [wwi].[ProductReview]

CREATE TABLE [wwi].[ProductReview]
( 
	[UserId] [int] NOT NULL,
	[ProductId] [int]  NOT NULL,
	[ReviewText] nvarchar(1000)  NOT NULL,
	[ReviewDate] [datetime]  NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE
)