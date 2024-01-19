Create TABLE AppUsers
(
    Id                   uniqueidentifier not null primary key,
    UserName             nvarchar(255)    not null, 
    [Password]           nvarchar(255)    not null, 
    UserRole             nvarchar(255)    not null, 
    Created              datetime2        not null default GETUTCDATE(),
    CreatedBy            nvarchar(255),
    UpdatedBy            nvarchar(255),
    LastUpdated          datetime2,
)
