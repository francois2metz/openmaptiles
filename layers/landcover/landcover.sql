--TODO: Find a way to nicely generalize landcover
--CREATE TABLE IF NOT EXISTS landcover_grouped_gen2 AS (
--	SELECT osm_id, ST_Simplify((ST_Dump(geometry)).geom, 600) AS geometry, landuse, "natural", wetland
--	FROM (
--	  SELECT max(osm_id) AS osm_id, ST_Union(ST_Buffer(geometry, 600)) AS geometry, landuse, "natural", wetland
--	  FROM osm_landcover_polygon_gen1
--	  GROUP BY LabelGrid(geometry, 15000000), landuse, "natural", wetland
--	) AS grouped_measurements
--);
--CREATE INDEX IF NOT EXISTS landcover_grouped_gen2_geometry_idx ON landcover_grouped_gen2 USING gist(geometry);

CREATE OR REPLACE FUNCTION landcover_class(subclass VARCHAR) RETURNS TEXT AS $$
    SELECT CASE
        WHEN subclass IN ('farmland', 'farm', 'orchard', 'vineyard', 'plant_nursery') THEN 'farmland'
        WHEN subclass IN ('glacier', 'ice_shelf') THEN 'ice'
        WHEN subclass IN ('wood', 'forest') THEN 'wood'
        WHEN subclass IN ('bare_rock', 'scree') THEN 'rock'
        WHEN subclass IN ('grassland', 'grass', 'meadow', 'allotments', 'grassland', 'fitness_station',
                          'park', 'village_green', 'recreation_ground', 'park', 'garden') THEN 'grass'
        WHEN subclass IN ('wetland', 'bog', 'swamp', 'wet_meadow', 'marsh', 'reedbed',
                          'saltern', 'tidalflat', 'saltmarsh', 'mangrove') THEN 'wetland'
        WHEN subclass IN ('beach', 'sand') THEN 'sand'
        WHEN subclass IN ('parking_space', 'parking', 'bicycle_parking', 'motorcycle_parking') THEN 'parking'
        ELSE NULL
    END;
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE VIEW landcover_z14 AS (
    -- etldoc: osm_landcover_polygon ->  landcover_z14
    SELECT osm_id, geometry, subclass FROM osm_landcover_polygon
);

-- etldoc: layer_landcover[shape=record fillcolor=lightpink, style="rounded, filled", label="layer_landcover | <z0_1> z0-z1 | <z2_4> z2-z4 | <z5_6> z5-z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_landcover(bbox geometry, zoom_level int)
RETURNS TABLE(osm_id bigint, geometry geometry, class text, subclass text) AS $$
    SELECT osm_id, geometry,
        landcover_class(subclass) AS class,
        subclass
        FROM (
        -- etldoc:  landcover_z14 -> layer_landcover:z14_
        SELECT *
        FROM landcover_z14 WHERE zoom_level >= 14 AND geometry && bbox
    ) AS zoom_levels;
$$ LANGUAGE SQL IMMUTABLE;
