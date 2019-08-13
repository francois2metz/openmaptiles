

-- etldoc: osm_border_linestring_gen8 -> boundary_z6
CREATE OR REPLACE VIEW boundary_z6 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_border_linestring_gen8
    WHERE admin_level <= 4
);

-- etldoc: osm_border_linestring_gen7 -> boundary_z7
CREATE OR REPLACE VIEW boundary_z7 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_border_linestring_gen7
    WHERE admin_level <= 4
);

-- etldoc: osm_border_linestring_gen6 -> boundary_z8
CREATE OR REPLACE VIEW boundary_z8 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_border_linestring_gen6
    WHERE admin_level <= 4
);

-- etldoc: osm_border_linestring_gen5 -> boundary_z9
CREATE OR REPLACE VIEW boundary_z9 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_border_linestring_gen5
    WHERE admin_level <= 6
);

-- etldoc: osm_border_linestring_gen4 -> boundary_z10
CREATE OR REPLACE VIEW boundary_z10 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_border_linestring_gen4
    WHERE admin_level <= 6
);

-- etldoc: osm_border_linestring_gen3 -> boundary_z11
CREATE OR REPLACE VIEW boundary_z11 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_border_linestring_gen3
    WHERE admin_level <= 8
);

-- etldoc: osm_border_linestring_gen2 -> boundary_z12
CREATE OR REPLACE VIEW boundary_z12 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_border_linestring_gen2
);

-- etldoc: osm_border_linestring_gen1 -> boundary_z13
CREATE OR REPLACE VIEW boundary_z13 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_border_linestring_gen1
);

-- etldoc: layer_boundary[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_boundary |<z0> z0 |<z1_2> z1_2 | <z3> z3 | <z4> z4 | <z5> z5 | <z6> z6 | <z7> z7 | <z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13+"]

CREATE OR REPLACE FUNCTION layer_boundary (bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, admin_level int, disputed int, maritime int) AS $$
    SELECT geometry, admin_level, disputed::int, maritime::int FROM (
        -- etldoc: boundary_z8 ->  layer_boundary:z8
        SELECT * FROM boundary_z8 WHERE geometry && bbox AND zoom_level = 8
        UNION ALL
        -- etldoc: boundary_z9 ->  layer_boundary:z9
        SELECT * FROM boundary_z9 WHERE geometry && bbox AND zoom_level = 9
        UNION ALL
        -- etldoc: boundary_z10 ->  layer_boundary:z10
        SELECT * FROM boundary_z10 WHERE geometry && bbox AND zoom_level = 10
        UNION ALL
        -- etldoc: boundary_z11 ->  layer_boundary:z11
        SELECT * FROM boundary_z11 WHERE geometry && bbox AND zoom_level = 11
        UNION ALL
        -- etldoc: boundary_z12 ->  layer_boundary:z12
        SELECT * FROM boundary_z12 WHERE geometry && bbox AND zoom_level = 12
        UNION ALL
        -- etldoc: boundary_z13 -> layer_boundary:z13
        SELECT * FROM boundary_z13 WHERE geometry && bbox AND zoom_level >= 13
    ) AS zoom_levels;
$$ LANGUAGE SQL IMMUTABLE;
