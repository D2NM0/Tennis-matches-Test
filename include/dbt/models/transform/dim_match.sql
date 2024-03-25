WITH match_cte AS (
	SELECT DISTINCT
        {{ dbt_utils.generate_surrogate_key(['id','has_started']) }} as match_id,
		has_started
	FROM {{ source('modeo_tt', 'raw_matches') }}
)
SELECT
    t.*
FROM match_cte t