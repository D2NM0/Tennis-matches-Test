WITH account_cte AS (
	SELECT DISTINCT
	    kindred_id as account_id
	FROM `able-rarity-417913`.`modeo_tt`.`raw_matches`
)
SELECT
    t.*
FROM account_cte t