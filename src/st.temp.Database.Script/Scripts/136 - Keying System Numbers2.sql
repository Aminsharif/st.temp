alter table KeyingSystemNumbers
    add Created datetime2 default GETUTCDATE()