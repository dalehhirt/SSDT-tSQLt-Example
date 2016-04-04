CREATE PROCEDURE  [HumanResourcesTests].[Setup]
AS

	exec tSQLt.FakeTable 'HumanResources.Employee'
	exec tSQLt.FakeTable 'HumanResources.Department', @Identity=1

RETURN 0
