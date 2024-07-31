create or replace view panen_ton_per_hektare as (
with luas_panen_ha as (
select 
	pbh.date,
	hfg.name mandor_grup,
	pd.name divisi,
	case
		when pe.name like '%MUSI%' then 'MME'
		when pe.name like '%LEMATANG%' then 'LME'
		when pe.name like 'PLASMA%' and pe.name like '%1' then 'PAM1'
		when pe.name like 'PLASMA%' and pe.name like '%2' then 'PAM2'
	end estate,
	ph.harvest_area luas_panen_ha,
	pbh.state
from 
	plantation_batch_harvest pbh 
left join
	hr_foreman_group hfg on hfg.id = pbh.foreman_group_id 
left join 
	hr_department hd on hd.id = hfg.department_id 
left join 
	plantation_division pd on pd.id = hd.division_id 
left join 
	plantation_estate pe on pe.id = pd.estate_id 
left join
	plantation_harvest ph on ph.harvest_batch_id = pbh.id
where
	pbh.state = 'done'
),
hasil_panen_ton as (
select
	pda.id,
	pda.date,
	hfg.name mandor_grup,
	pd.name divisi,
	case
		when pe.name like '%MUSI%' then 'MME'
		when pe.name like '%LEMATANG%' then 'LME'
		when pe.name like 'PLASMA%' and pe.name like '%1' then 'PAM1'
		when pe.name like 'PLASMA%' and pe.name like '%2' then 'PAM2'
	end estate,
	pt.activity_result_qty2/1000 hasil_panen_ton,
	pda.state,
	pda.type,
	he.name emp
from 
	plantation_daily_activity pda 
left join
	hr_foreman_group hfg on hfg.id = pda.foreman_group_id 
left join 
	hr_department hd on hd.id = hfg.department_id 
left join 
	plantation_division pd on pd.id = hd.division_id 
left join 
	plantation_estate pe on pe.id = pd.estate_id 
left join
	plantation_timesheet pt on pt.daily_activity_id = pda.id 
left join 
	hr_employee he on he.id = pt.employee_id 
where
	pda.type = 'harvest'
and 
	pda.state = 'done'
)
select
	hpt.date,
	hpt.estate,
	coalesce (sum(hpt.hasil_panen_ton),0) hasil_panen_ton,
	coalesce (sum(lph.luas_panen_ha),0) luas_panen_ha,
	coalesce (case 
		when sum(lph.luas_panen_ha) != 0 then sum(hpt.hasil_panen_ton)/sum(lph.luas_panen_ha)
		else sum(hpt.hasil_panen_ton)/1
	end, 0) ton_per_ha
from
	hasil_panen_ton hpt
left join
	luas_panen_ha lph on lph.date = hpt.date
group by
	hpt.date,hpt.estate
)