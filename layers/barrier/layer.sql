
-- etldoc: layer_barrier[shape=record fillcolor=lightpink,
-- etldoc:     style="rounded,filled", label="layer_barrier | <z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_barrier(bbox geometry, zoom_level integer, pixel_width numeric)
RETURNS TABLE(geometry geometry, barrier text) AS $$
   -- etldoc: osm_barrier -> layer_barrier:z14_
   SELECT geometry, barrier
   FROM osm_barrier
   WHERE zoom_level >= 14 AND geometry && bbox;

$$ LANGUAGE SQL IMMUTABLE;
