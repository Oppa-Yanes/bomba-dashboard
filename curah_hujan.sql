create or replace view curah_hujan as (
select 
	pwc.date tanggal,
	pe.name estate,
	pwcl.curah_hujan curah_hujan
from 
	plantation_wms_curahhujan pwc 
left join
	plantation_wms_curahhujan_line pwcl on pwcl.parent_id = pwc.id 
left join 
	plantation_estate pe on pe.id = pwcl.estate_id_ori 
)