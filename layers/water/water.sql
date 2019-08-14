CREATE OR REPLACE FUNCTION water_class(waterway TEXT) RETURNS TEXT AS $$
    SELECT CASE
           WHEN waterway='' THEN 'lake'
           WHEN waterway='lake' THEN 'lake'
           WHEN waterway='dock' THEN 'dock'
           ELSE 'river'
   END;
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE VIEW water_z14 AS (
    -- etldoc:  osm_water_polygon ->  water_z14
    SELECT geometry, water_class(waterway) AS class, is_intermittent FROM osm_water_polygon
    WHERE "natural" != 'bay'
);

-- etldoc: layer_water [shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water |<z0> z0|<z1>z1|<z2>z2|<z3>z3 |<z4> z4|<z5>z5|<z6>z6|<z7>z7| <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_water (bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, class text, intermittent int) AS $$
    SELECT geometry, class::text, is_intermittent::int AS intermittent FROM (
        -- etldoc: water_z14 ->  layer_water:z14_
        SELECT * FROM water_z14 WHERE zoom_level >= 14
    ) AS zoom_levels
    WHERE geometry && bbox;
$$ LANGUAGE SQL IMMUTABLE;
