create user [asaga.sql.highperf] for login [asaga.sql.highperf]
execute sp_addrolemember 'db_owner', 'asaga.sql.highperf' 
execute sp_addrolemember 'staticrc80', 'asaga.sql.highperf' 
    
CREATE USER [#USER_NAME#] FROM EXTERNAL PROVIDER;
EXEC sp_addrolemember 'db_owner', '#USER_NAME#'