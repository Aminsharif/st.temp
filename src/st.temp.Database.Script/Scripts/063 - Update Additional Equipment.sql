Alter table AdditionalEquipments
    add
        Inactive bit not null default 0,
        Description nvarchar(max)
Go