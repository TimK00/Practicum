SELECT
  op.parameter_id
, f.[name] AS folder_name
, p.[name] AS project_name
, CASE op.object_type
    WHEN 20 THEN 'Project'
    WHEN 30 THEN 'Package'
  END AS ParameterType
, op.[object_name]
, op.parameter_name
, CASE op.value_type
    WHEN 'V' THEN 'Literal'
    WHEN 'R' THEN 'Env var reference'
    ELSE op.value_type
  END AS SpecifiedAs
, op.design_default_value AS DesignTimeValue -- value set in Visual Studio at deployment time
, op.sensitive
--**************************************************************************
-- values as displayed in SSMS configure dialog
, IIF(LEFT(op.[parameter_name], 3) = 'CM.', 'Connection Managers', 'Parameters') AS [ConfigurationPage]
, op.[object_name] AS Container
, IIF(
    LEFT(op.[parameter_name], 3) = 'CM.'
  , SUBSTRING(op.[parameter_name], 4, CHARINDEX('.', op.[parameter_name], 4) - 4)
  , op.[parameter_name]
  ) AS [Name]
, IIF(
    LEFT(op.[parameter_name], 3) = 'CM.'
  , SUBSTRING(op.[parameter_name], CHARINDEX('.', op.[parameter_name], 4) + 1, LEN(op.[parameter_name]))
  , ''
  ) AS [PropertyName]
, op.default_value AS [ConfiguredValue]  -- value set in catalog post-deployment
--**************************************************************************
-- values for use in catalog.set_object_parameter_value 
-- https://docs.microsoft.com/en-us/sql/integration-services/system-stored-procedures/catalog-set-object-parameter-value-ssisdb-database
, op.[object_type]
, f.[name] AS folder_name
, p.[name] AS project_name
, op.[parameter_name]
, op.[object_name]
, op.value_type
--, op.*
FROM SSISDB.[catalog].[object_parameters] op
  INNER JOIN SSISDB.[catalog].projects p  ON p.project_id = op.project_id
  INNER JOIN SSISDB.[catalog].folders f ON f.folder_id = p.folder_id
--WHERE op.value_set = 1  -- design-time value overridden post-deployment
ORDER BY
  [ConfigurationPage] DESC
, op.object_type
, op.[object_name]
, [Name]