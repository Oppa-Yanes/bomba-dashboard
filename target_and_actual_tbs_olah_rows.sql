--create table target_and_actual_tbs_olah_rows (
--	id serial4 primary key,
--	tahun varchar,
--	bulan int4,
--	target float8,
--	actual float8
--);

--insert into target_and_actual_tbs_olah_rows (
--	tahun,
--	bulan,
--	target
--)
--select 
--	hmtoait.year as tahun,
--	1 as bulan,
--	hmtoaitil.target_januari as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah'
--union all
--select 
--	hmtoait.year as tahun,
--	2 as bulan,
--	hmtoaitil.target_febuari as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah'
--union all
--select 
--	hmtoait.year as tahun,
--	3 as bulan,
--	hmtoaitil.target_maret as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah'
--union all
--select 
--	hmtoait.year as tahun,
--	4 as bulan,
--	hmtoaitil.target_april as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah'
--union all
--select 
--	hmtoait.year as tahun,
--	5 as bulan,
--	hmtoaitil.target_mei as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah'
--union all
--select 
--	hmtoait.year as tahun,
--	6 as bulan,
--	hmtoaitil.target_juni as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah'
--union all
--select 
--	hmtoait.year as tahun,
--	7 as bulan,
--	hmtoaitil.target_juli as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah'
--union all
--select 
--	hmtoait.year as tahun,
--	8 as bulan,
--	hmtoaitil.target_agustus as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah'
--union all
--select 
--	hmtoait.year as tahun,
--	9 as bulan,
--	hmtoaitil.target_september as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah'
--union all
--select 
--	hmtoait.year as tahun,
--	10 as bulan,
--	hmtoaitil.target_oktober as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah'
--union all
--select 
--	hmtoait.year as tahun,
--	11 as bulan,
--	hmtoaitil.target_november as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah'
--union all
--select 
--	hmtoait.year as tahun,
--	12 as bulan,
--	hmtoaitil.target_desember as target
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--left join
--	hit_mill_target_olah_after_import_to_item_line hmtoaitil on hmtoaitil.import_to_id = hmtoait.id
--where hmtoaitil.target like 'TBS Olah';

--UPDATE target_and_actual_tbs_olah_rows as taator
--SET
--    actual = coalesce(subquery.actual,0)
--from (
--	select sum(hmdptl.daily) as actual, extract(year from hmdp.datetime_production)::text as tahun, extract(month from hmdp.datetime_production) as bulan
--	from hit_mill_dailyreport_produksi_tbs_line hmdptl
--	join hit_mill_dailyreport_produksi hmdp on hmdp.id = hmdptl.produksi_id
--	where hmdptl.uraian like 'TBS Olah'
--	group by extract(year from hmdp.datetime_production), extract(month from hmdp.datetime_production)
--	) as subquery
--where taator.tahun = subquery.tahun and taator.bulan = subquery.bulan;

--select 
--	*
--from
--	(
--	select 
--		extract(year from hmdp.datetime_production) as tahun,
--		extract(month from hmdp.datetime_production) as bulan,
--		sum(hmdptl.daily) as actual_tbs_olah
--	from
--		hit_mill_dailyreport_produksi hmdp 
--	left join
--		hit_mill_dailyreport_produksi_tbs_line hmdptl on hmdptl.produksi_id = hmdp.id
--	where
--		hmdptl.uraian = 'TBS Olah'
--	group by 
--		tahun,bulan
--	) as actual_tbs_olah

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
		hmtoaitil.target_febuari as target
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
actual_tbs_olah as(
	select 
		extract(year from hmdp.datetime_production)::text as tahun,
		to_char(extract(month from hmdp.datetime_production), 'fm00') as bulan,
		sum(hmdptl.daily) as actual
	from
		hit_mill_dailyreport_produksi hmdp 
	left join
		hit_mill_dailyreport_produksi_tbs_line hmdptl on hmdptl.produksi_id = hmdp.id
	where
		hmdptl.uraian = 'TBS Olah'
	group by 
		tahun,bulan
)
select 
	tbs.*
from 
	(
	select
		target_tbs_olah.tahun,
		target_tbs_olah.bulan,
		target_tbs_olah.target,
		actual_tbs_olah.actual::int
	from
		target_tbs_olah
	left join
		actual_tbs_olah on actual_tbs_olah.tahun = target_tbs_olah.tahun and actual_tbs_olah.bulan = target_tbs_olah.bulan
	) as tbs
order by tbs.tahun asc, tbs.bulan asc