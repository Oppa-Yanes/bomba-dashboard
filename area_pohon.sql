with area_pohon as (
  select 
    ou.name operating_unit, 
    sum(coalesce(plp.planted_area, 0)) area, 
    sum(coalesce(plp.plant_total, 0)) pohon, 
    case when plp.state = 'immature_plant' then 'TBM' else 'TM' end status 
  from 
    plantation_land_block plb 
    left join plantation_land_planted plp on plp.block_id = plb.id 
    left join operating_unit ou on ou.id = plb.operating_unit_id 
  group by 
    ou.name, 
    status
) 
select 
  ap.operating_unit, 
  ap.area, 
  ap.pohon, 
  ap.pohon / (case when ap.area != 0 then ap.area else 1 end) pohon_per_hektare, 
  ap.status 
from 
  area_pohon ap
;
