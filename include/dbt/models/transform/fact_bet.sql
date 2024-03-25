WITH fct_bet_cte AS (
    SELECT
        id AS bet_id,
        {{ dbt_utils.generate_surrogate_key(['id','has_started']) }} as match_id,
        kindred_id AS account_id,
        etl_time AS datetime_id,
        bet_offer_name,
        home_odd,
        away_odd,
    FROM {{ source('modeo_tt', 'raw_matches') }}
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
INNER JOIN {{ ref('dim_etltime') }} dt ON fi.datetime_id = dt.datetime_id
INNER JOIN {{ ref('dim_account') }} da ON fi.account_id = da.account_id
INNER JOIN {{ ref('dim_match') }} dm ON fi.match_id = dm.match_id