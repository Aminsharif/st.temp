alter table CustomerInformation
    add
        DefaultKeyNumberingType int
Go

update CustomerInformation
set DefaultKeyNumberingType = 0
where DefaultKeyNumberingType is null

Go