CREATE PROCEDURE [HumanResourcesTests].[test gender check constraint]
AS
	
	--Assemble
	--  This section is for code that sets up the environment. It often
	--  contains calls to methods such as tSQLt.FakeTable and tSQLt.SpyProcedure
	--  along with INSERTs of relevant data.
	--  For more information, see http://tsqlt.org/user-guide/isolating-dependencies/
	declare @BusinessEntityID [int] = 1980; 
	
	exec tSQLt.FakeTable 'Person.Person'

	EXEC tSQLt.ApplyConstraint 'HumanResources.Employee','CK_Employee_Gender';
    
	EXEC tSQLt.ExpectException
	--Act
	--  Execute the code under test like a stored procedure, function or view
	--  and capture the results in variables or tables.
  
	insert into [HumanResources].[Employee]([BusinessEntityID], [Gender])
	select @BusinessEntityID, 'G'

	--Assert
	--  Compare the expected and actual values, or call tSQLt.Fail in an IF statement.  
	--  Available Asserts: tSQLt.AssertEquals, tSQLt.AssertEqualsString, tSQLt.AssertEqualsTable
	--  For a complete list, see: http://tsqlt.org/user-guide/assertions/
RETURN 0
