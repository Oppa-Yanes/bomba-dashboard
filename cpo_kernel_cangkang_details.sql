create or replace view cpo_kernel_cangkang_details as (
select
	extract (year from hmdp.datetime_production) tahun,
	extract (month from hmdp.datetime_production) bulan,
	hmdp.datetime_production::date tanggal,
	'cpo' tipe,
	hmdpcl.uraian uraian,
	hmdpcl.daily daily
from 
	hit_mill_dailyreport_produksi hmdp 
left join
	hit_mill_dailyreport_produksi_cpo_line hmdpcl on hmdpcl.produksi_id = hmdp.id
where
	hmdpcl.uraian in ('Pengiriman CPO','Stok Kemarin CPO','Total Produksi CPO','OER')
and 
	hmdp.state = 'done'
union all	
select
	extract (year from hmdp.datetime_production) tahun,
	extract (month from hmdp.datetime_production) bulan,
	hmdp.datetime_production::date tanggal,
	'kernel' tipe,
	hmdpkl.uraian uraian,
	hmdpkl.daily daily
from 
	hit_mill_dailyreport_produksi hmdp 
left join
	hit_mill_dailyreport_produksi_kernel_line hmdpkl on hmdpkl.produksi_id = hmdp.id
where
	hmdpkl.uraian in ('Pengiriman Kernel','Stok Kemarin Kernel','Total Produksi Kernel','KER')
union all
select
	extract (year from hmdp.datetime_production) tahun,
	extract (month from hmdp.datetime_production) bulan,
	hmdp.datetime_production::date tanggal,
	'cangkang' tipe,
	hmdpcl2.uraian uraian,
	hmdpcl2.daily daily
from 
	hit_mill_dailyreport_produksi hmdp 
left join
	hit_mill_dailyreport_produksi_cangkang_line hmdpcl2 on hmdpcl2.produksi_id = hmdp.id
where
	hmdpcl2.uraian in ('Pengiriman Cangkang','Stok Kemarin Cangkang','Total Produksi Cangkang')
and 
	hmdp.state = 'done'
)
