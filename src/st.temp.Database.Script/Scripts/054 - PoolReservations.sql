CREATE TABLE DeliveryDateTypes
(
    Id                    uniqueidentifier not null primary key,
    Caption               nvarchar(255) not null,
)
GO
CREATE TABLE PoolReservationRanges
(
    Id                    uniqueidentifier NOT NULL primary key,
    DeliveryDateTypeId    uniqueidentifier NOT NULL foreign key REFERENCES dbo.DeliveryDateTypes (Id),
    ValidFrom             datetime2 NOT NULL,
    ValidUntil            datetime2 NOT NULL,
    Capacity              decimal(10, 2)   NOT NULL,
    CreatedBy             nvarchar(255)    NOT NULL,
    Created               datetime2        NOT NULL default GETUTCDATE(),
    UpdatedBy             nvarchar(255),
    LastUpdated           datetime2, 
)
GO

CREATE TABLE DailyPoolReservations
(
    Id                         uniqueidentifier NOT NULL primary key,
    PoolReservationRangeId     uniqueidentifier NOT NULL foreign key REFERENCES dbo.PoolReservationRanges (Id),
    CalenderDay                date NOT NULL,
    DailyCapacity              decimal(10, 2),
    Booked                     decimal(10, 2),
    CreatedBy                  nvarchar(255)    NOT NULL,
    Created                    datetime2        NOT NULL default GETUTCDATE(),
    UpdatedBy                  nvarchar(255),
    LastUpdated                datetime2, 
    )
GO


insert into [dbo].[DeliveryDateTypes] values('AEB96C4C-AF77-4182-9610-7201F5FF4D82','Express')
insert into [dbo].[DeliveryDateTypes] values('98CABB78-EB62-438D-9015-DAD660C87DF3','Fixed')
insert into [dbo].[DeliveryDateTypes] values('911AB5A2-3131-4C15-A002-3C612F78E1D3','Automatic')
GO