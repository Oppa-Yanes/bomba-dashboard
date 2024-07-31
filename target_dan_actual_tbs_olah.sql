create or replace view target_tbs_olah_kg as (
with target_tbs_olah as (
	select 
		hmtoait.year as tahun,
		'01' as bulan,
		hmtoaitil.target_januari as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'02' as bulan,
		hmtoaitil.target_februari as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'03' as bulan,
		hmtoaitil.target_maret as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'04' as bulan,
		hmtoaitil.target_april as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'05' as bulan,
		hmtoaitil.target_mei as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'06' as bulan,
		hmtoaitil.target_juni as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'07' as bulan,
		hmtoaitil.target_juli as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'08' as bulan,
		hmtoaitil.target_agustus as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'09' as bulan,
		hmtoaitil.target_september as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'10' as bulan,
		hmtoaitil.target_oktober as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'11' as bulan,
		hmtoaitil.target_november as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
	union all
	select 
		hmtoait.year as tahun,
		'12' as bulan,
		hmtoaitil.target_desember as target
	from
		hit_mill_target_olah_after_import_to hmtoait 
	left join
		hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
	where hmtoaitil.target like 'TBS Olah'
	and hmtoait.active = True
),
actual_tbs_olah as (
select
	extract (year from hmdp.datetime_production)::text tahun,
	to_char(extract(month from hmdp.datetime_production),'fm00') bulan,
	hmdp.datetime_production::date tanggal,
	hmdptl.daily daily
from 
	hit_mill_dailyreport_produksi hmdp 
left join
	hit_mill_dailyreport_produksi_tbs_line hmdptl on hmdptl.produksi_id = hmdp.id
where 
	hmdptl.uraian = 'TBS Olah'
)
select
	tto.tahun,
	tto.bulan,
	ato.tanggal,
	tto.target,
	ato.daily
from
	target_tbs_olah tto
left join
	actual_tbs_olah ato on ato.tahun = tto.tahun and ato.bulan = tto.bulan
)