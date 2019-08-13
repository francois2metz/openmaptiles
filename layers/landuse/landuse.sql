-- etldoc: osm_landuse_polygon -> landuse_z14
CREATE OR REPLACE VIEW landuse_z14 AS (
    SELECT osm_id, geometry, landuse, amenity, leisure, tourism, place, NULL::int as scalerank
    FROM osm_landuse_polygon
);

-- etldoc: layer_landuse[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_landuse |<z4> z4|<z5>z5|<z6>z6|<z7>z7| <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11|<z12> z12|<z13> z13|<z14> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_landuse(bbox geometry, zoom_level int)
RETURNS TABLE(osm_id bigint, geometry geometry, class text) AS $$
    SELECT osm_id, geometry,
        COALESCE(
            NULLIF(landuse, ''),
            NULLIF(amenity, ''),
            NULLIF(leisure, ''),
            NULLIF(tourism, ''),
            NULLIF(place, '')
        ) AS class
        FROM (
        SELECT * FROM landuse_z14 WHERE zoom_level >= 14
    ) AS zoom_levels
    WHERE geometry && bbox;
$$ LANGUAGE SQL IMMUTABLE;
