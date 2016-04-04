﻿CREATE PROCEDURE [HumanResourcesTests].[test uspUpdateEmployeeHireInfo_currentflag_is_set_to_true_when_hired]
AS
	
	--Assemble
	--  This section is for code that sets up the environment. It often
	--  contains calls to methods such as tSQLt.FakeTable and tSQLt.SpyProcedure
	--  along with INSERTs of relevant data.
	--  For more information, see http://tsqlt.org/user-guide/isolating-dependencies/
  
	declare @BusinessEntityID [int] = 1980; 
    declare @JobTitle [nvarchar](50) = 'employee numero uno';
    declare @HireDate [datetime] = '2014-01-01 10:10:59.59'
    declare @RateChangeDate [datetime] = '2014-07-01'
    declare @Rate [money] = 24.87
    declare @PayFrequency [tinyint] = 7
    declare @CurrentFlag [tinyint] = 0
	declare @InsertedCurrentFlag [tinyint] = 1
	
	insert into [HumanResources].[Employee]([BusinessEntityID], [CurrentFlag])
	select @BusinessEntityID, 0

	--Act
	--  Execute the code under test like a stored procedure, function or view
	--  and capture the results in variables or tables.
  
	exec [HumanResources].[uspUpdateEmployeeHireInfo] @BusinessEntityID, @JobTitle, @HireDate, @RateChangeDate, @Rate, @PayFrequency, @InsertedCurrentFlag

	--Assert
	--  Compare the expected and actual values, or call tSQLt.Fail in an IF statement.  
	--  Available Asserts: tSQLt.AssertEquals, tSQLt.AssertEqualsString, tSQLt.AssertEqualsTable
	--  For a complete list, see: http://tsqlt.org/user-guide/assertions/
	declare @actual_CurrentFlag tinyint
	
	select @actual_CurrentFlag = CurrentFlag from HumanResources.Employee 
		where BusinessEntityID = @BusinessEntityID

	exec tSQLt.AssertEquals @Expected = @CurrentFlag, @Actual = @actual_CurrentFlag, @Message = 'Wrong Flag Value.'




	