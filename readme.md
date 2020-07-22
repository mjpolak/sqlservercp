# SQL Server database copy utility

It is dockerized utility that allows to copy database schema and data between two servers SQL Servers

It does not require `sysadmin` permissions, user only need to have `GRANT`-ed permission for database `CONTROL`.

## Why not use bacpac, bak? 

Please read my question on stackoverflow: [HERE](https://stackoverflow.com/questions/62877740/copy-content-of-sql-server-2016-db)

If you know other soultion give me a message!

## Tested version:

|  Source\Target| 2016 SP2      | 2019          
| ------------- | ------------- |:-------------:
| *2016 SP2*    | Yes           | Yes
| *2019         | No            | Yes      

## Docker

https://hub.docker.com/repository/docker/mjpolak/sqlservercp

## How it works?

 1. It uses [sqlpackage](https://docs.microsoft.com/en-us/sql/tools/sqlpackage?view=sql-server-ver15) to make `dacpac` containg schema of source database.
 2. It uses [bcp](https://docs.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-ver15) to save all source tables data.
 3. Then, it try to publish schema via [sqlpackage] to target database, removing all non existing objects on target, and objects that are blocking migration. (All `sqlpackage` `properties` can be checked [execute.sh](execute.sh))
 4. All data are removed from target tables.
 5. Then [bcp](https://docs.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-ver15) is used to bulk insert all data.

## How to use it?

### Enviroment variables
Image require to fill enviroment variables:
 - `SOURCE_DB_HOST`= Source host
 - `SOURCE_DB_NAME`= Source database name
 - `SOURCE_DB_PASSWORD`= Source user password
 - `SOURCE_DB_USER`= Source user name
 - `SOURCE_DB_PORT`= Source db port
 - `TARGET_DB_HOST`= Target host
 - `TARGET_DB_NAME`= Target database name
 - `TARGET_DB_PASSWORD`= Target user password
 - `TARGET_DB_USER`= Target user
 - `TARGET_DB_PORT`= Target port

### Docker compose 

Easies way of running util is to copy environment config `.env_template`, fill all varaibles, save it as `.env`.

Then just execute `docker-compose up`