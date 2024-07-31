create or replace view areal_ditanami_tm_tbm as (
select 
	case 
		when ou.name is not null then ou.name
		else 'PT Golden Blossom Sumatra'
	end operating_unit,
	sum(coalesce(plp.planted_area,0)) area,
	plant_stat.valueName status
from 
	(values (1, 'immature_plant','TBM'),(2, 'mature_plant','TM')) plant_stat(plant_statId, keyName, valueName)
left join
	plantation_land_planted plp on plp.state = plant_stat.keyName
left join
	operating_unit ou on ou.id = plp.operating_unit_id 
group by
	operating_unit, status
)