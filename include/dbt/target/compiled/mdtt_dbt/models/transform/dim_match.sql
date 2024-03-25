WITH match_cte AS (
	SELECT DISTINCT
        to_hex(md5(cast(coalesce(cast(id as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(has_started as string), '_dbt_utils_surrogate_key_null_') as string))) as match_id,
		has_started
	FROM `able-rarity-417913`.`modeo_tt`.`raw_matches`
)
SELECT
    t.*
FROM match_cte t