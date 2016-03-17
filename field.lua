function get_field_at(pos)
    if pos.x >= field_start.x and pos.y >= field_start.y and
      pos.x < field_start.x + field_width * field_size.x and
      pos.y < field_start.y + field_height * field_size.y then
        local tile_x = math.floor( (pos.x - field_start.x) / field_size.x ) + 1
        local tile_y = math.floor( (pos.y - field_start.y) / field_size.y ) + 1
        return Vector(tile_x, tile_y)
    end

    return nil
end

function load_field(map_table)
    assert(map_table.width == 20 and map_table.height == 11 and
            map_table.tilewidth == 50 and map_table.tileheight == 50,
            "Map must be a 20x11 grid of 50x50 pixel tiles")

    -- Constructs an associative table mapping tile ids to their table of 
    -- properties by looping through all tiles in all tilesets.
    local tile_properties = {}
    for i, tileset in ipairs(map_table.tilesets) do
        for i, tile in ipairs(tileset.tiles) do
            tile_properties[tile.id + tileset.firstgid] = tile.properties
        end
    end

    -- Constructs field_grid so each position on the field is associated with
    -- the properties of the tile at that position like so:
    -- field_grid[1][1] = {"walkable_path" = "true", "start" = "true"}
    for y = 1, field_height do
        field_grid[y] = {}
        for x = 1, field_width do
            tile_id = map_table.layers[1].data[(y-1) * field_width + x]
            field_grid[y][x] = tile_properties[tile_id] or {}
            is_start_tile = tile_properties[tile_id] and 
                            tile_properties[tile_id].start
            if is_start_tile then
                start_pos = Vector(x, y)
            end
        end
    end

    start_pos = start_pos or Vector(1, 1) 
    map = sti.new("maps/lua/" .. current_map .. ".lua", nil,
                   field_start.x, field_start.y)
end

function closest_tower(pos)

    local closest_dist = 100000.0
    local closest = nil

    for i = 1, #towers do
        local tower = towers[i]
        if tower ~= nil then
            local dist = Vector.distance(pos, tower:get_pos())
            if dist < closest_dist then
                closest_dist = dist
                closest = tower
            end
        end
    end
    return closest
end


