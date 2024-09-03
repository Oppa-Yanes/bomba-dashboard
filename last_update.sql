SELECT
	MAX(datetime_production)::date last_date
FROM
	hit_mill_dailyreport_sounding
WHERE
	state = 'done'
;
