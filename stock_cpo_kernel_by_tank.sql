create view stock_cpo_pk_storage_tank as (
select 
	hmds.datetime_production::date tanggal,
	hmdscl.storage penyimpanan,
	hmdscl.total_volume total_volume 
from 
	hit_mill_dailyreport_sounding hmds 
left join
	hit_mill_dailyreport_sounding_cpo_line hmdscl on hmdscl.sounding_id = hmds.id
where
	hmds.state = 'done'
union all
select 
	hmds.datetime_production::date tanggal,
	hmdskl.bungker penyimpanan,
	hmdskl.besar_total total_volume 
from 
	hit_mill_dailyreport_sounding hmds 
left join
	hit_mill_dailyreport_sounding_kernel_line hmdskl on hmdskl.sounding_id = hmds.id
where
	hmds.state = 'done'
)