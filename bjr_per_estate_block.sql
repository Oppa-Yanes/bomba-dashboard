create or replace view bjr_per_estate_block as (
select 
	paf.date tanggal,
	case
		when pe.name like '%MUSI%' then 'MME'
		when pe.name like '%LEMATANG%' then 'LME'
		when pe.name like 'PLASMA%' and pe.name like '%1' then 'PAM1'
		when pe.name like 'PLASMA%' and pe.name like '%2' then 'PAM2'
	end estate,
	plp.name block,
	paf.avg_weight bjr
from 
	plantation_average_ffb paf 
left join
	plantation_land_planted plp on plp.id = paf.planted_block_id 
left join
	plantation_estate pe on pe.id = plp.estate_id 
order by tanggal,estate,plp.name
)