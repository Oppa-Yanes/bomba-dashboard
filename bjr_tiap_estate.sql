create or replace view bjr_tiap_estate as (
with berat_janjang as (
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
),
jumlah_janjang as (
select 
	extract(year from wt.date_in)::text tahun,
	to_char(extract(month from wt.date_in),'fm00') as bulan,
	case
		when pe.name like '%MUSI%' then 'MME'
		when pe.name like '%LEMATANG%' then 'LME'
		when pe.name like 'PLASMA%' and pe.name like '%1' then 'PAM1'
		when pe.name like 'PLASMA%' and pe.name like '%2' then 'PAM2'
	end estate,
	sum(ms.jumlah_janjang) janjang
from
	mill_spb ms 
left join
	weighbridge_ticket wt on wt.id = ms.spb_id 
left join 
	plantation_estate pe on pe.id = ms.estate_id 
where 
	ms.estate_id is not null
group by 
	tahun, bulan, estate
)
select
	(bj.bulan || '-' || '01' ||  '-' || bj.tahun)::date tgl,
	bj.estate,
	bj.realisasi_berat,
	jj.janjang,
	case 
		when jj.janjang != 0 then bj.realisasi_berat/jj.janjang
		else bj.realisasi_berat/1
	end bjr
from
	berat_janjang bj
left join
	jumlah_janjang jj on jj.tahun = bj.tahun and jj.bulan = bj.bulan and jj.estate = bj.estate
)