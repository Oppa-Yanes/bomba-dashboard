create view hgu_luas_lahan as (
select 
	ou.name operating_unit,
	sum(plb.block_area) luas_lahan
from 
	plantation_land_block plb 
left join
	operating_unit ou on ou.id = plb.operating_unit_id
group by
	ou.name
)