create or replace view budget_vs_realisasi_produksi_tbs as (
with budget_produksi_tbs as (
select 
	pbat.budget_year::text tahun,
	trim(leading '0' from pbat.budget_month)::text bulan,
	case
		when pe.name like '%MUSI%' then 'MME'
		when pe.name like '%LEMATANG%' then 'LME'
		when pe.name like 'PLASMA%' and pe.name like '%1' then 'PAM1'
		when pe.name like 'PLASMA%' and pe.name like '%2' then 'PAM2'
	end estate,
	sum(pbat.budget_berat) budget_berat
from
	plantation_budget_allocation_temporary pbat 
left join
	plantation_estate pe on pe.id = pbat.estate_id
group by
	tahun, bulan, estate
order by
	tahun, bulan, estate
),
realisasi_produksi_tbs as (
select 
	extract(year from wt.date_in)::text tahun,
	extract(month from wt.date_in)::text bulan,
	case
		when pe.name like '%MUSI%' then 'MME'
		when pe.name like '%LEMATANG%' then 'LME'
		when pe.name like 'PLASMA%' and pe.name like '%1' then 'PAM1'
		when pe.name like 'PLASMA%' and pe.name like '%2' then 'PAM2'
	end estate,
	sum(wt.weight) realisasi_berat
from
	weighbridge_ticket wt 
left join
	plantation_division pd on pd.id = wt.plantation_division_id
left join 
	plantation_estate pe on pe.id = pd.estate_id
left join
	weighbridge_transaction_type wtt on wtt.id = wt.transaction_type_id
where
	wt.state = 'valid' 
	and wt.transaction_type = 'incoming' 
	and wt.plantation_division_id notnull 
	and wt.supplier_id is null 
	and wtt.name like '%TERIMA%' and wtt.name like '%INTERNAL'
group by
	tahun, bulan, estate
order by 
	tahun, bulan, estate
)
select 
	bpt.tahun tahun,
	bpt.bulan bulan,
	bpt.estate estate,
	bpt.budget_berat budget_berat,
	rpt.realisasi_berat realisasi_berat
from
	budget_produksi_tbs bpt
left join
	realisasi_produksi_tbs rpt on rpt.tahun = bpt.tahun and rpt.bulan = bpt.bulan and rpt.estate = bpt.estate
order by 
	bpt.tahun asc, length(bpt.bulan), bpt.bulan asc, bpt.estate asc
)