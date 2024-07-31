create or replace view target_dan_realisasi_cpo as (
with target_cpo_produksi as (
	select 
		hmtoait.year as tahun,
		'01' as bulan,
		hmtoaitpl.target_januari as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'02' as bulan,
		hmtoaitpl.target_februari as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'03' as bulan,
		hmtoaitpl.target_maret as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'04' as bulan,
		hmtoaitpl.target_april as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'05' as bulan,
		hmtoaitpl.target_mei as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'06' as bulan,
		hmtoaitpl.target_juni as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'07' as bulan,
		hmtoaitpl.target_juli as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'08' as bulan,
		hmtoaitpl.target_agustus as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'09' as bulan,
		hmtoaitpl.target_september as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'10' as bulan,
		hmtoaitpl.target_oktober as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'11' as bulan,
		hmtoaitpl.target_november as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'12' as bulan,
		hmtoaitpl.target_desember as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_produksi_line hmtoaitpl on hmtoaitpl.import_to_id = hmtoait.id
	where hmtoaitpl.target like 'Produksi  CPO / Bulan / Kg'
	and hmtoait.active = True
),
actual_cpo_produksi as(
	select 
		extract(year from hmdp.datetime_production)::text as tahun,
		to_char(extract(month from hmdp.datetime_production),'fm00') as bulan,
		hmdp.datetime_production::date tanggal,
		hmdpcl.daily as daily
	from
		hit_mill_dailyreport_produksi hmdp 
	left join
		hit_mill_dailyreport_produksi_cpo_line hmdpcl on hmdpcl.produksi_id = hmdp.id
	where
		hmdpcl.uraian = 'Total Produksi CPO'
)
select 
	cpo.*
from 
	(
	select
		target_cpo_produksi.tahun, 
		target_cpo_produksi.bulan,
		actual_cpo_produksi.tanggal,
		target_cpo_produksi.target,
		actual_cpo_produksi.daily
	from
		target_cpo_produksi
	left join
		actual_cpo_produksi on actual_cpo_produksi.tahun = target_cpo_produksi.tahun and actual_cpo_produksi.bulan = target_cpo_produksi.bulan
	) as cpo
order by cpo.tahun asc, cpo.bulan asc
)