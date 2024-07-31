create or replace view total_panen_bulan_ton_per_ha as (
with luas_panen_ha as (
select 
	case
		when pe.name like '%MUSI%' then 'MME'
		when pe.name like '%LEMATANG%' then 'LME'
		when pe.name like 'PLASMA%' and pe.name like '%1' then 'PAM1'
		when pe.name like 'PLASMA%' and pe.name like '%2' then 'PAM2'
	end estate,
	sum(coalesce(plp.planted_area,0)) area,
	case
		when plp.state = 'immature_plant' then 'TBM'
		else 'TM'
	end status
from 
	plantation_land_block plb 
left join 
	plantation_land_planted plp on plp.block_id = plb.id
left join
	plantation_estate pe on pe.id = plp.estate_id
where
	pe.id is not null
group by
	estate, status
),
berat_panen_ton as (
	select 
	extract(year from wt.date_in)::text tahun,
	to_char(extract(month from wt.date_in),'fm00') as bulan,
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
	(bpt.bulan || '-' || '01' ||  '-' || bpt.tahun)::date tgl,
	bpt.estate,
	bpt.realisasi_berat/1000 ton_berat,
	lph.area ha_luas,
	bpt.realisasi_berat/1000/lph.area ton_per_ha
from
	berat_panen_ton bpt
left join
	luas_panen_ha lph on lph.estate = bpt.estate
)