WITH account_cte AS (
	SELECT DISTINCT
	    kindred_id as account_id
	FROM {{ source('modeo_tt', 'raw_matches') }}
)
SELECT
    t.*
FROM account_cte t