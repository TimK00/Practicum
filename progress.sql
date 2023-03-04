USE SSISDB

SELECT 
	pr.name AS [ProjectName], 
	pr.last_deployed_time AS [ProjectLastValidated],
	pr.validation_status AS [ProjectValidationStatus],
	op.project_id AS [ProjectID],
	op.design_default_value AS [DefaultConnectionString],
	pa.name as [PackageName],
	pa.package_guid as [Package GUID],
	pa.entry_point,
	pa.last_validation_time

FROM [internal].[object_parameters] op
INNER JOIN [internal].[projects] pr
ON pr.project_id = op.project_id
AND pr.object_version_lsn = op.project_version_lsn
INNER JOIN [internal].[packages] pa
ON pr.project_id = pa.project_id
AND pr.object_version_lsn = pa.project_version_lsn


where op.object_name = 'DataWarehouse ETL' and pa.name like 'Master Common%'
--ORDER BY pa.name, op.design_default_value 