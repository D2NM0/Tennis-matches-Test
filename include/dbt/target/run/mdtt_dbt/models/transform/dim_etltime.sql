
  
    

    create or replace table `able-rarity-417913`.`modeo_tt`.`dim_etltime`
      
    
    

    OPTIONS()
    as (
      WITH datetime_cte AS (  
  SELECT DISTINCT
    etl_time AS datetime_id,
    etl_time AS date_part,
  FROM `able-rarity-417913`.`modeo_tt`.`raw_matches`
)
SELECT
  datetime_id,
  date_part as datetime,
  EXTRACT(YEAR FROM date_part) AS year,
  EXTRACT(MONTH FROM date_part) AS month,
  EXTRACT(DAY FROM date_part) AS day,
  EXTRACT(HOUR FROM date_part) AS hour,
  EXTRACT(MINUTE FROM date_part) AS minute,
FROM datetime_cte
    );
  