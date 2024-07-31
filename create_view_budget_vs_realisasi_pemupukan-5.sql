--select 
--	pda.id,
----	pt.id bb,
--	pdam.id aa,
--	extract(year from pda.date) tahun,
--	extract(month from pda.date) bulan,
--	pca.name activity, 
----	pt.activity_result_qty, uu1.name,
--	pt2.name,
--	pdam.consumed_qty 
--from
--	plantation_daily_activity pda 
----left join
----	plantation_timesheet pt on pt.daily_activity_id = pda.id
--left join
--	plantation_daily_activity_material pdam on pdam.daily_activity_id = pda.id
--left join
--	plantation_cost_activity pca on pca.id = pdam.cost_activity_id 
----left join 
----	uom_uom uu1 on uu1.id = pt.activity_result_uom_id 
--left join
--	product_product pp on pp.id = pdam.stock_product_id 
--left join
--	product_template pt2 on pt2.id = pp.product_tmpl_id 
--where 
--	pdam.id is not null 
--	and 
--	pca.name like 'PEMUPUKAN%'
----order by
----	uu1.name
create view budget_vs_realisasi_pemupukan as (
with realisasi_pemupukan as (
select
	extract(year from pdam.date)::text tahun,
	extract(month from pdam.date)::text bulan,
	case
		when pe.name like '%MUSI%' then 'MME'
		when pe.name like '%LEMATANG%' then 'LME'
		when pe.name like 'PLASMA%' and pe.name like '%1' then 'PAM1'
		when pe.name like 'PLASMA%' and pe.name like '%2' then 'PAM2'
	end estate,
	pt2.name material,
	pca.name kegiatan,
	sum(pdam.consumed_qty) realisasi_berat 
from
	plantation_daily_activity_material pdam 
left join
	plantation_cost_activity pca on pca.id = pdam.cost_activity_id
left join
	product_product pp on pp.id = pdam.stock_product_id 
left join
	product_template pt2 on pt2.id = pp.product_tmpl_id 
left join 
	hr_foreman_group hfg on hfg.id = pdam.foreman_group_id 
left join 
	hr_department hd on hd.id = hfg.department_id 
left join 
	plantation_division pd on pd.id = hd.division_id 
left join 
	plantation_estate pe on pe.id = pd.estate_id 
where 
	pca.name like 'PEMUPUKAN%'
group by
	tahun,bulan,estate,material,kegiatan
),
budget_pemupukan as (
select 
	pbanpt.budget_year::text tahun,
	trim(leading '0' from pbanpt.budget_month)::text bulan,
	case
		when pe.name like '%MUSI%' then 'MME'
		when pe.name like '%LEMATANG%' then 'LME'
		when pe.name like 'PLASMA%' and pe.name like '%1' then 'PAM1'
		when pe.name like 'PLASMA%' and pe.name like '%2' then 'PAM2'
	end estate,
	pca.name kegiatan,
	sum(pbanpt.budget_berat) budget_berat 
from 
	plantation_budget_allocation_non_panen_temporary pbanpt 
left join
	plantation_estate pe ON pe.id = pbanpt.estate_id 
left join
	plantation_cost_activity pca on pca.id = pbanpt.cost_activity_id 
where
	pca.name like 'PEMUPUKAN%'
group by
	tahun,bulan,estate,kegiatan
)
select
	bp.tahun,
	bp.bulan,
	bp.estate,
	bp.kegiatan,
	bp.budget_berat,
	case
		when rp.realisasi_berat notnull then rp.realisasi_berat
		else 0
	end realisai_berat
from 
	budget_pemupukan bp
left join
	realisasi_pemupukan rp on rp.tahun = bp.tahun and rp.bulan = bp.bulan and rp.estate = bp.estate and rp.kegiatan = bp.kegiatan
order by
	tahun asc,length(bp.bulan),bulan asc,estate asc
)