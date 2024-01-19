Alter Table ProductConfigurator.Logs
    add CONSTRAINT Constraint_Message_Is_Json Check (ISJSON(Message) = 1)
Go