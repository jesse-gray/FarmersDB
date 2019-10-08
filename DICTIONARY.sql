SELECT
isc.table_name,
isc.ordinal_position::integer AS ordinal_position,
isc.column_name::character varying AS column_name,
isc.column_default::character varying AS column_default,
isc.data_type::character varying AS data_type,
isc.character_maximum_length::integer AS str_length,
        CASE
            WHEN isc.udt_name::text = 'int4'::text OR isc.udt_name::text =
'bool'::text THEN isc.data_type::character varying
            ELSE isc.udt_name::character varying
        END AS udt_name
  FROM information_schema.columns isc
  WHERE isc.table_schema::text = 'public'::text
  ORDER BY isc.table_name, isc.ordinal_position;