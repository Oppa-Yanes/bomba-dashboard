with area_pohon as (
  select 
    ou.name operating_unit, 
    sum(
      coalesce(plp.planted_area, 0)
    ) area, 
    sum(
      coalesce(plp.plant_total, 0)
    ) pohon, 
    case when plp.state = 'immature_plant' then 'TBM' else 'TM' end status 
  from 
    plantation_land_block plb 
    left join operating_unit ou on ou.id = plb.operating_unit_id 
    left join plantation_land_planted plp on plp.block_id = plb.id 
  group by 
    ou.name, 
    status
) 
select 
  ap.operating_unit, 
  ap.area, 
  ap.pohon, 
  case when ap.area != 0 then ap.pohon / ap.area else ap.pohon / 1 end pohon_per_hektare, 
  status 
from 
  area_pohon ap
