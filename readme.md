# SQL Server database copy utility

It is dockerized utility that allows to copy database schema and data between two servers SQL Servers

It doesn not require `sysadmin` permissions, used need to have `GRANT`-ed permission for database `CONTROL`.

## Why not use bacpac, bak? 

Please read my question on stackoverflow: [HERE]([https://link](https://stackoverflow.com/questions/62877740/copy-content-of-sql-server-2016-db))

If you know other soultion give me a message!

## Tested version:

SQL Server 2016

## How it works?

 1. It uses [sqlpackage](https://docs.microsoft.com/en-us/sql/tools/sqlpackage?view=sql-server-ver15) to make `dacpac` containg schema of source database.
 2. It uses [bcp](https://docs.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-ver15) to save all source tables data.
 3. Then, it try to publish schema via [sqlpackage] to target database, removing all non existing objects on target, and objects that are blocking migration. (All `sqlpackage` `properties` can be checked [execute.sh](execute.sh))
 4. All data are removed from target tables.
 5. Then [bcp](https://docs.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-ver15) is used to bulk insert all data.
