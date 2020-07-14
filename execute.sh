#!/bin/bash
echo 'start extracting schema' &&
    sqlpackage /a:Extract /of:True /sdn:"${SOURCE_DB_NAME}" /sp:"${SOURCE_DB_PASSWORD}" /ssn:"${SOURCE_DB_HOST},${SOURCE_DB_PORT}" /su:"${SOURCE_DB_USER}" /tf:"dump.dacpac" \
        /p:IgnoreUserLoginMappings=True &&
    echo 'end of extracting schema' &&
    echo 'start of extracting data' &&
    mkdir tables &&
    tables=$(sqlcmd -d ${SOURCE_DB_NAME} -P ${SOURCE_DB_PASSWORD} -U ${SOURCE_DB_USER} -S "${SOURCE_DB_HOST},${SOURCE_DB_PORT}" -Q "SET NOCOUNT ON; SELECT name FROM sys.tables" -h -1 -b) &&
    echo "$tables" | while read line; do
        bcp "[dbo].[${line}]" OUT "/tables/${line}.bcp" -d ${SOURCE_DB_NAME} -P ${SOURCE_DB_PASSWORD} -U ${SOURCE_DB_USER} -S "${SOURCE_DB_HOST},${SOURCE_DB_PORT}" -n || exit 1
    done &&
    echo "end of extracting schema" &&
    echo 'start of importing schema' &&
    sqlpackage /a:Publish /of:True /tdn:"${TARGET_DB_NAME}" /tp:"${TARGET_DB_PASSWORD}" /tsn:"${TARGET_DB_HOST},${TARGET_DB_PORT}" /tu:"${TARGET_DB_USER}" /sf:"dump.dacpac" \
        /p:AllowDropBlockingAssemblies=True /p:BlockOnPossibleDataLoss=False /p:BlockWhenDriftDetected=False /p:CreateNewDatabase=False \
        /p:IgnorePermissions=True /p:IgnoreUserSettingsObjects=True /p:IgnoreRoleMembership=True /p:IgnorePartitionSchemes=True /p:IgnoreLoginSids=True \
        /p:ExcludeObjectType=Users /p:ExcludeObjectType=Logins /p:ExcludeObjectType=RoleMembership /p:DropObjectsNotInSource=True &&
    echo "end of importing schema" &&
    echo "start of removing old data" &&
    sqlcmd -d ${TARGET_DB_NAME} -P ${TARGET_DB_PASSWORD} -U ${TARGET_DB_USER} -S "${TARGET_DB_HOST},${TARGET_DB_PORT}" -i remove_all_data.sql &&
    echo "end of removing old data" &&
    echo "start of importing data" &&
    echo "$tables" | while read line; do
        bcp "[dbo].[${line}]" IN "/tables/${line}.bcp" -d ${TARGET_DB_NAME} -P ${TARGET_DB_PASSWORD} -U ${TARGET_DB_USER} -S "${TARGET_DB_HOST},${TARGET_DB_PORT}" -n || exit 1
    done &&
    echo 'All done'
