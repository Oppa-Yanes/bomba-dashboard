-- public.budget_vs_realisasi_produksi_tbs_perestate source

CREATE OR REPLACE VIEW public.budget_vs_realisasi_produksi_tbs_perestate
AS WITH bprod AS (
         WITH bp AS (
                 SELECT bp_1.budget_year::text AS tahun,
                    ltrim(bp_1.budget_month::text, '0'::text) AS bulan,
                        CASE
                            WHEN est.name::text ~~ '%MUSI%'::text THEN 'MME'::text
                            WHEN est.name::text ~~ '%LEMATANG%'::text THEN 'LME'::text
                            WHEN est.name::text ~~ 'PLASMA%'::text AND est.name::text ~~ '%1'::text THEN 'PAM1'::text
                            WHEN est.name::text ~~ 'PLASMA%'::text AND est.name::text ~~ '%2'::text THEN 'PAM2'::text
                            ELSE NULL::text
                        END AS estate,
                    est.name AS estate_name,
                    COALESCE(bp_1.budget_berat, 0::double precision) AS budget_berat,
                    COALESCE(bp_1.budget_janjang, 0::double precision) AS budget_janjang
                   FROM schema_gbs_replica.plantation_budget_allocation bp_1
                     LEFT JOIN schema_gbs_replica.plantation_estate est ON est.id = bp_1.estate_id
                )
         SELECT bp.tahun,
            bp.bulan,
            bp.estate,
            bp.estate_name,
            sum(bp.budget_berat) AS budget_berat,
            sum(bp.budget_janjang) AS budget_janjang,
            sum(bp.budget_berat) / sum(bp.budget_janjang) AS bjr
           FROM bp
          GROUP BY bp.tahun, bp.bulan, bp.estate, bp.estate_name
        ), aprod AS (
         WITH ap AS (
                 SELECT date_part('year'::text, wb.date_in)::text AS tahun,
                    date_part('month'::text, wb.date_in)::text AS bulan,
                        CASE
                            WHEN est.name::text ~~ '%MUSI%'::text THEN 'MME'::text
                            WHEN est.name::text ~~ '%LEMATANG%'::text THEN 'LME'::text
                            WHEN est.name::text ~~ 'PLASMA%'::text AND est.name::text ~~ '%1'::text THEN 'PAM1'::text
                            WHEN est.name::text ~~ 'PLASMA%'::text AND est.name::text ~~ '%2'::text THEN 'PAM2'::text
                            ELSE NULL::text
                        END AS estate,
                    est.name AS estate_name,
                    COALESCE(wb.weight, 0::double precision) AS realisasi_berat
                   FROM schema_gbs_replica.weighbridge_ticket wb
                     LEFT JOIN schema_gbs_replica.weighbridge_ticket_raw raw ON raw.weighbridge_ticket_id = wb.id
                     LEFT JOIN schema_gbs_replica.plantation_division div ON div.id = wb.plantation_division_id
                     LEFT JOIN schema_gbs_replica.plantation_estate est ON est.id = div.estate_id
                  WHERE wb.transaction_type_id = 86 AND (wb.state::text = ANY (ARRAY['valid'::text, 'generate_tbs_journal'::text]))
                     AND ((TO_CHAR(wb.date_in,'YYYYMM') = '202401')
		          OR (TO_CHAR(wb.date_in,'YYYYMM') <> '202401' AND raw.status_delete::text = '0'::text))
                     AND wb.date_in <= (( SELECT dash_last_update.last_update FROM dash_last_update))
                )
         SELECT ap.tahun,
            ap.bulan,
            ap.estate,
            ap.estate_name,
            sum(ap.realisasi_berat) AS realisasi_berat
           FROM ap
          GROUP BY ap.tahun, ap.bulan, ap.estate, ap.estate_name
        )
 SELECT bprod.tahun,
    bprod.bulan,
    bprod.estate,
    bprod.estate_name,
    COALESCE(bprod.budget_berat, 0::double precision) AS budget_berat,
    COALESCE(bprod.budget_janjang, 0::double precision) AS budget_janjang,
    COALESCE(bprod.bjr, 0::double precision) AS bjr,
    aprod.realisasi_berat
   FROM bprod
     LEFT JOIN aprod ON aprod.tahun = bprod.tahun AND aprod.bulan = bprod.bulan AND aprod.estate = bprod.estate
  ORDER BY bprod.tahun, ("right"('0'::text || TRIM(BOTH FROM bprod.bulan), 2)), bprod.estate;


---- cek summary
WITH bprod AS (
  WITH bp AS (
    SELECT 
      bp_1.budget_year :: text AS tahun, 
      ltrim(
        bp_1.budget_month :: text, '0' :: text
      ) AS bulan, 
      CASE WHEN est.name :: text ~~ '%MUSI%' :: text THEN 'MME' :: text WHEN est.name :: text ~~ '%LEMATANG%' :: text THEN 'LME' :: text WHEN est.name :: text ~~ 'PLASMA%' :: text 
      AND est.name :: text ~~ '%1' :: text THEN 'PAM1' :: text WHEN est.name :: text ~~ 'PLASMA%' :: text 
      AND est.name :: text ~~ '%2' :: text THEN 'PAM2' :: text ELSE NULL :: text END AS estate, 
      est.name AS estate_name, 
      COALESCE(
        bp_1.budget_berat, 0 :: double precision
      ) AS budget_berat, 
      COALESCE(
        bp_1.budget_janjang, 0 :: double precision
      ) AS budget_janjang 
    FROM 
      plantation_budget_allocation bp_1 
      LEFT JOIN plantation_estate est ON est.id = bp_1.estate_id
  ) 
  SELECT 
    bp.tahun, 
    bp.bulan, 
    bp.estate, 
    bp.estate_name, 
    sum(bp.budget_berat) AS budget_berat, 
    sum(bp.budget_janjang) AS budget_janjang, 
    sum(bp.budget_berat) / sum(bp.budget_janjang) AS bjr 
  FROM 
    bp 
  GROUP BY 
    bp.tahun, 
    bp.bulan, 
    bp.estate, 
    bp.estate_name
), 
aprod AS (
  WITH ap AS (
    SELECT 
      date_part('year' :: text, wb.date_in):: text AS tahun, 
      date_part('month' :: text, wb.date_in):: text AS bulan, 
      CASE WHEN est.name :: text ~~ '%MUSI%' :: text THEN 'MME' :: text WHEN est.name :: text ~~ '%LEMATANG%' :: text THEN 'LME' :: text WHEN est.name :: text ~~ 'PLASMA%' :: text 
      AND est.name :: text ~~ '%1' :: text THEN 'PAM1' :: text WHEN est.name :: text ~~ 'PLASMA%' :: text 
      AND est.name :: text ~~ '%2' :: text THEN 'PAM2' :: text ELSE NULL :: text END AS estate, 
      est.name AS estate_name, 
      COALESCE(wb.weight, 0 :: double precision) AS realisasi_berat 
    FROM 
      weighbridge_ticket wb 
      LEFT JOIN weighbridge_ticket_raw raw ON raw.weighbridge_ticket_id = wb.id 
      LEFT JOIN plantation_division div ON div.id = wb.plantation_division_id 
      LEFT JOIN plantation_estate est ON est.id = div.estate_id 
    WHERE 
      wb.transaction_type_id = 86 
      AND (
        wb.state :: text = ANY (
          ARRAY[ 'valid' :: text, 'generate_tbs_journal' :: text]
        )
      ) 
      AND raw.status_delete :: text = '0' :: text 
      AND wb.date_in <= '2024-09-19'
  ) 
  SELECT 
    ap.tahun, 
    ap.bulan, 
    ap.estate, 
    ap.estate_name, 
    sum(ap.realisasi_berat) AS realisasi_berat 
  FROM 
    ap 
  GROUP BY 
    ap.tahun, 
    ap.bulan, 
    ap.estate, 
    ap.estate_name
) 
SELECT 
  bprod.tahun, 
  bprod.bulan, 
  SUM(
    COALESCE(
      bprod.budget_berat, 0 :: double precision
    )
  ) AS budget_berat, 
  SUM(
    COALESCE(
      bprod.budget_janjang, 0 :: double precision
    )
  ) AS budget_janjang, 
  AVG(
    COALESCE(bprod.bjr, 0 :: double precision)
  ) AS bjr, 
  SUM(aprod.realisasi_berat) realisasi_berat 
FROM 
  bprod 
  LEFT JOIN aprod ON aprod.tahun = bprod.tahun 
  AND aprod.bulan = bprod.bulan 
  AND aprod.estate = bprod.estate 
GROUP BY 
  bprod.tahun, 
  bprod.bulan 
ORDER BY 
  bprod.tahun, 
  (
    "right"(
      '0' :: text || TRIM(
        BOTH 
        FROM 
          bprod.bulan
      ), 
      2
    )
  );
