create or replace view produksi_tbs_per_wilayah as (
WITH volume_netto AS (
	select
		case 
			when wt.plantation_division_id notnull and wt.supplier_id isnull then 
				(case
					when pd.name like 'LME%' then 'LME' 
					when pd.name like 'MME%' then 'MME'
					when pd.name like 'PAM1%' then 'PAM1'
					when pd.name like 'PAM2%' then 'PAM2'
				end)
			when wt.plantation_division_id isnull and wt.supplier_id notnull then
				(case
					when rp.name like 'LARAS%' then 'LKK'
					when rp.name like '%ABU%' then 'Aburahmi'
					else 'Lainnya'
				end)
			else 'Lainnya'
		end as sources,
		case 
			when wt.plantation_division_id notnull and wt.supplier_id isnull then 
				(case
					when pd.name like 'LME%' or pd.name like 'MME%' or pd.name like 'PAM1%' or pd.name like 'PAM2%' then 'Internal'
				end)
			else 'Eksternal'
		end as sources_type,
		wt.date_posting tanggal,
		sum(wt.net_weight) netto1_kg,
		sum(wt.weight) netto2_kg,
		sum(wt.deduction_weight) sortasi_kg
	FROM
		weighbridge_ticket wt 
	left join
		plantation_division pd on pd.id = wt.plantation_division_id 
	left join
		res_partner rp on rp.id = wt.supplier_id 
	where
		wt.state = 'valid'
	group by 
		tanggal,sources_type,sources
)
select 
	vn.tanggal,
	vn.sources,
	vn.sources_type,
	vn.netto1_kg netto1_kg,
	vn.netto2_kg netto2_kg,
	vn.sortasi_kg sortasi_kg,
	0 as grading_kg
from
	volume_netto vn
order by 
	vn.tanggal asc
)