create view areal_ditanami as (
select 
	ou.name operating_unit,
	sum(plb.planted_area) areal_ditanami
from 
	plantation_land_block plb 
left join
	operating_unit ou on ou.id = plb.operating_unit_id
group by
	ou.name
)