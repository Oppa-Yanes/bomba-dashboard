create table harga_cpo (
	id serial4,
	date_from date,
	date_to date,
	date date,
	harga_cpo float8
)
INSERT INTO harga_cpo (date_from, date_to, date, harga_cpo)
SELECT '2024-01-16', '2024-01-31', i::date, 8500.0
FROM generate_series('2024-01-01'::date, '2024-01-15'::date, interval '1 day') AS t(i);

create table harga_kernel (
	id serial4,
	date_from date,
	date_to date,
	date date,
	harga_kernel float8
)
INSERT INTO harga_kernel (date_from, date_to, date, harga_kernel)
SELECT '2024-01-15', '2024-01-31', i::date, 6500.0
FROM generate_series('2024-01-01'::date, '2024-01-15'::date, interval '1 day') AS t(i);