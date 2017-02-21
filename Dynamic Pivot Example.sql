CREATE TABLE DBO.DynamicPivot
(
DynamicPivotID INT IDENTITY(1,1),
SurveyName  VARCHAR(200),
ColumnName  VARCHAR(200),
Value		VARCHAR(5000),
CreateDate  DATETIME,
ModifyDate  DATETIME
)


INSERT INTO DBO.DynamicPivot(SurveyName,ColumnName,Value,CreateDate,ModifyDate)
VALUES ('TEST 1', 'CustomerID','1548',GETDATE(),GETDATE())


INSERT INTO DBO.DynamicPivot(SurveyName,ColumnName,Value,CreateDate,ModifyDate)
VALUES ('TEST 1', 'SurveyQuestion 1','How is it going today ?',GETDATE(),GETDATE())



INSERT INTO DBO.DynamicPivot(SurveyName,ColumnName,Value,CreateDate,ModifyDate)
VALUES ('TEST 1', 'SurveyQuestion 2','How is the weather today ?',GETDATE(),GETDATE())



--Regular Pivot -- 

 select * from (
 SELECT SurveyName, ColumnName,value
    FROM dbo.DynamicPivot
)src
    PIVOT(
	max(Value) 
    FOR ColumnName IN ([CustomerID],[SurveyQuestion 1],[SurveyQuestion 2]) 
	     )PVTTable





--Dyanmic Pivot

DECLARE @DynamicPivotQuery AS NVARCHAR(MAX)
DECLARE @ColumnName AS VARCHAR(MAX)
 
--Get distinct values of the PIVOT Column 
SELECT @ColumnName= ISNULL(@ColumnName + ',','') 
       + QUOTENAME(ColumnName)
FROM (SELECT DISTINCT ColumnName FROM dbo.amanDynamicPivot) AS ColumnName


--Prepare the PIVOT query using the dynamic 
SET @DynamicPivotQuery = 
  N'SELECT SurveyName, ' + @ColumnName + '
    FROM
	(SELECT surveyName, ColumnName,Value
    FROM dbo.DynamicPivot) a
    PIVOT(max(Value) 
          FOR ColumnName IN (' + @ColumnName + ')) AS PVTTable'
--PRINT @DynamicPivotQuery
--Execute the Dynamic Pivot Query
EXEC sp_executesql @DynamicPivotQuery



 
