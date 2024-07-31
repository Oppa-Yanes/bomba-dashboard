create or replace view level_air as (
select 
	pwl.date tanggal,
	case
		when pe.name like '%MUSI%' then 'MME'
		when pe.name like '%LEMATANG%' then 'LME'
		when pe.name like 'PLASMA%' and pe.name like '%1' then 'PAM1'
		when pe.name like 'PLASMA%' and pe.name like '%2' then 'PAM2'
	end estate,
	plp.name block,
	coalesce (pwll.level_standard_from, 0) level_standard_from,
	coalesce (pwll.level_standard_to, 0) level_standard_to,
	coalesce (pwll.level_air_parit, 0) level_air_parit,
	coalesce (pwll.level_air_blok, 0) level_air_blok,
	case
		when pwll.level_air_blok < 30 then 'banjir'
		when pwll.level_air_blok > 40 then 'kering'
		else 'normal'
	end keterangan
from 
	plantation_wms_levelair pwl  
left join
	plantation_wms_levelair_line pwll on pwll.parent_id = pwl.id  
left join 
	plantation_land_planted plp on plp.id = pwll.block_id_ori 
left join 
	plantation_division pd on pd.id = pwll.division_id 
left join 
	plantation_estate pe on pe.id = pd.estate_id  
where
	pwll.division_id notnull and pwll.block_id_ori notnull
)