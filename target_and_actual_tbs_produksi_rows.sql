--create table target_and_actual_tbs_produksi_rows (
--	id serial4 primary key,
--	tahun varchar,
--	bulan int4,
--	target float8,
--	actual float8
--);

--insert into target_and_actual_tbs_produksi_rows (
--	tahun,
--	bulan
--)
--select 
--	hmtoait.year as tahun,
--	1 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--union all
--select 
--	hmtoait.year as tahun,
--	2 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--union all
--select 
--	hmtoait.year as tahun,
--	3 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--union all
--select 
--	hmtoait.year as tahun,
--	4 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--union all
--select 
--	hmtoait.year as tahun,
--	5 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--union all
--select 
--	hmtoait.year as tahun,
--	6 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--union all
--select 
--	hmtoait.year as tahun,
--	7 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--union all
--select 
--	hmtoait.year as tahun,
--	8 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--union all
--select 
--	hmtoait.year as tahun,
--	9 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--union all
--select 
--	hmtoait.year as tahun,
--	10 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--union all
--select 
--	hmtoait.year as tahun,
--	11 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait 
--union all
--select 
--	hmtoait.year as tahun,
--	12 as bulan
--from
--	hit_mill_target_olah_after_import_to hmtoait; 
	
--UPDATE target_and_actual_tbs_produksi_rows as taapr
--SET
--    actual = coalesce(subquery.actual,0)
--from (
--	select sum(pt.activity_result_qty2) as actual, extract(year from pt.date)::text as tahun, extract(month from pt.date) as bulan
--	from plantation_timesheet pt
--	join plantation_daily_activity pda on pda.id = pt.daily_activity_id
--	where pda.state like 'done'
--	group by extract(year from pt.date), extract(month from pt.date)
--	) as subquery
--where taapr.tahun = subquery.tahun and taapr.bulan = subquery.bulan;

--select
--	extract(month from wt.date_posting) as bulan,
--	sum(wt.weight) as terima_tbs 
--from 
--	weighbridge_ticket wt 
--where
--	wt.transaction_type = 'incoming'
--	and wt.net_weight != wt.weight 
--	and wt.state = 'valid'
--group by
--	bulan

--with act as (
--select
--	mt.date_posting,
--	mt.estate,
--	mt.blok_id,
--	mt.blok,
--	mt.petak_id,
--	mt.petak,
--	mt.berat_timbang,
--	mt.berat_proporsi,
--	mt.janjang_total,
--	to_char(mt.date_in,'MM') as mth,
--	extract(YEAR from mt.date_in) as thn
--from mv_timbanghasilpanen mt
--),
--bud as (
--select
--	pba.estate_id,
--	pe.name as estate,
--	pba.planted_id,
--	plp.name as petak,
--	pba.division_id,
--	pd.name as division,
--	pba.budget_month as bln,
--	pba.budget_year as thn,
--	pba.budget_year || pba.budget_month as tbq,
--	pba.budget_berat,
--	pba.budget_janjang
--from plantation_budget_allocation pba
--left join plantation_land_planted plp on plp.id = pba.planted_id
--left join plantation_estate pe on pe.id = pba.estate_id
--left join plantation_division pd on pd.id = pba.division_id
--),
--tbd as (
--select
--	tb.time_by_month,
--	tb.time_by_quarter,
--	tb.quarter
--from time_by_day tb
--group by 1,2,3
--)
--select
----	ROW_NUMBER() OVER() as id, 
--	sub.tahun as tahun,
--	sub.bulan as bulan,
--	sum(sub.budget_berat)::int as target,
--	sum(sub.brt)::int as actual
--from (
--	select
--		bud.thn as tahun,
--		bud.bln as bulan,
--		bud.estate as estate,
--		bud.petak,
--		bud.division,
--		tbd.quarter,
--		act.blok,
--		act.petak as petak_act,
--		bud.budget_berat as budget_berat,
--		bud.budget_janjang,
--		sum(act.berat_proporsi) as brt,
--		sum(act.janjang_total) as jjg,
--		round((sum(act.berat_proporsi) / (case when bud.budget_berat != 0 then bud.budget_berat else 1 end))*100) || '%%' as persen_kg,
--		round((sum(act.janjang_total) / (case when bud.budget_janjang != 0 then bud.budget_janjang else 1 end))*100) || '%%' as persen_jjg,
--		bud.budget_berat - sum(act.berat_proporsi) as sisa_kg,
--		bud.budget_janjang - sum(act.janjang_total) as sisa_jjg
--	from bud
--	left join act on act.mth = bud.bln and act.thn = bud.thn and bud.planted_id = act.petak_id
--	join tbd on tbd.time_by_month = bud.tbq
--	group by bud.thn, bud.bln, bud.estate, bud.petak, bud.division, tbd.quarter, act.blok, act.petak, bud.budget_berat, bud.budget_janjang
--) as sub
--group by
--	tahun,bulan
--order by
--	tahun,bulan

with sum1 as (
                select 
                    ms.spb_id as spb_id,
                    plb.id as blok_id, --NEW
                    plb.name as blok,
                    plp.id as petak_id, --NEW
                    plp.name as petak,
                    pe.name as estate,
                    sum(ms.jumlah_janjang) as t1
                from
                    mill_spb ms
                left join plantation_estate pe on pe.id = ms.estate_id 
                left join plantation_land_planted plp on plp.id = ms.blok_id 
                left join plantation_land_block plb on plb.id = plp.block_id
                group by
                    1,2,3,4,5,6 --NEW
                ),
                sum2 as (
                select
                    wt.id as wt_id,
                    wt.transaction_type_id,
                    wt.state as status,
                    wt.date_posting as date_posting,
                --	ms.jumlah_janjang,
                    sum(ms.jumlah_janjang) as t2
                from
                    weighbridge_ticket wt
                join mill_spb ms on ms.spb_id = wt.id
                left join weighbridge_transaction_type wtt on wtt.id = wt.transaction_type_id
                where wtt.code = '111'
                group by
                    1 
                ),
                wt as 
                (
                select 
                    wt.id as wt1_id,
                    wt.name,
                    wt.vehicle_number,
                    wt.date_in,
                    wt.date_out,
                    wt.weight as berat_timbang
                from weighbridge_ticket wt
                )
                select 
                    nextval('wt_id') id,
                    wt.wt1_id,
                    wt.name,
                    wt.vehicle_number,
                    wt.date_in,
                    wt.date_out,
                    sum2.date_posting,
                    wt.berat_timbang,
                    sum2.status,
                    sum1.estate,
                    sum1.spb_id,
                    sum1.blok_id,--NEW
                    sum1.blok,
                    sum1.petak_id,--NEW
                    sum1.petak,
                    sum2.t2 as janjang_total,
                    sum1.t1 as janjang,
                    round((sum1.t1/case when sum2.t2 != 0 then sum2.t2 else 1 end)*100)|| '%%' as proporsi,
                    (sum1.t1/case when sum2.t2 != 0 then sum2.t2 else 1 end)* wt.berat_timbang as berat_proporsi
                from wt
                left join sum1 on sum1.spb_id = wt.wt1_id
                left join sum2 on sum2.wt_id = wt.wt1_id
                where sum2.status='valid'
