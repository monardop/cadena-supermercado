-- source: https://stackoverflow.com/questions/14544221/how-to-enable-ad-hoc-distributed-queries
USE [master] 
GO 

EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO

-- source: https://www.aspsnippets.com/Articles/96/The-OLE-DB-provider-Microsoft.Ace.OLEDB.12.0-for-linked-server-null/

USE [master] 
GO 

EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 
GO 

EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 
GO 