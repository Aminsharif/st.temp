Alter Table Orders
    drop column
        ShippingAddress_Street
Go

        sp_rename 'Orders.ShippingAddress_AddressLine', 'ShippingAddress_Street', 'COLUMN'
Go