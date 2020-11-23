create user [asaga.sql.highperf] for login [asaga.sql.highperf]
execute sp_addrolemember 'db_owner', 'asaga.sql.highperf' 
execute sp_addrolemember 'staticrc80', 'asaga.sql.highperf' 