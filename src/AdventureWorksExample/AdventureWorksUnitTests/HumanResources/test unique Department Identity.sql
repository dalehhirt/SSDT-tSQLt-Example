CREATE PROCEDURE [HumanResourcesTests].[test unique Department Identity]
AS
	
	--Assemble
	--  This section is for code that sets up the environment. It often
	--  contains calls to methods such as tSQLt.FakeTable and tSQLt.SpyProcedure
	--  along with INSERTs of relevant data.
	--  For more information, see http://tsqlt.org/user-guide/isolating-dependencies/
  
    declare @DepartmentName [nvarchar](50) = 'Department numero uno';
	declare @DepartmentId int = 20
	 
	exec tSQLt.FakeTable 'HumanResources.Department' --, @Identity=1

	exec tSQLt.ExpectException

	--Act
	--  Execute the code under test like a stored procedure, function or view
	--  and capture the results in variables or tables.
  
	insert into [HumanResources].Department([DepartmentID],[Name])
	select @DepartmentId, @DepartmentName

	--Assert
	--  Compare the expected and actual values, or call tSQLt.Fail in an IF statement.  
	--  Available Asserts: tSQLt.AssertEquals, tSQLt.AssertEqualsString, tSQLt.AssertEqualsTable
	--  For a complete list, see: http://tsqlt.org/user-guide/assertions/
