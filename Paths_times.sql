/****** Script for SelectTopNRows command from SSMS  ******/
SELECT ex.executable_id
      ,[project_id]
      ,[project_version_lsn]
      ,[package_name]
      ,[package_location_type]
      ,[package_path_full]
      ,[executable_name]
      ,[executable_guid]
      ,[package_path]
	  ,es.execution_path
	  ,es.start_time
	  ,es.end_time
	  ,es.execution_duration

  FROM [SSISDB].[internal].[executables] ex
  INNER JOIN [internal].[executable_statistics] es
  ON ex.executable_id = es.executable_id

  where project_id = 7 