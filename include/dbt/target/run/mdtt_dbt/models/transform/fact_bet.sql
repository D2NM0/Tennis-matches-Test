
  
    

    create or replace table `able-rarity-417913`.`modeo_tt`.`fact_bet`
      
    
    

    OPTIONS()
    as (
      WITH fct_bet_cte AS (
    SELECT
        id AS bet_id,
        to_hex(md5(cast(coalesce(cast(id as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(has_started as string), '_dbt_utils_surrogate_key_null_') as string))) as match_id,
        kindred_id AS account_id,
        etl_time AS datetime_id,
        bet_offer_name,
        home_odd,
        away_odd,
    FROM `able-rarity-417913`.`modeo_tt`.`raw_matches`
)
SELECT
    bet_id,
    dt.datetime_id,
    dm.match_id,
    da.account_id,
    bet_offer_name,
    home_odd,
    away_odd
FROM fct_bet_cte fi
INNER JOIN `able-rarity-417913`.`modeo_tt`.`dim_etltime` dt ON fi.datetime_id = dt.datetime_id
INNER JOIN `able-rarity-417913`.`modeo_tt`.`dim_account` da ON fi.account_id = da.account_id
INNER JOIN `able-rarity-417913`.`modeo_tt`.`dim_match` dm ON fi.match_id = dm.match_id
    );
  