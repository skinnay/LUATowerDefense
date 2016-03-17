field_grid = {}
towers = {}
projectiles = {}
field_width = 20
field_height = 11
field_start = Vector(50, 100)
field_size = Vector(50, 50) --(50, 50)
wave_id = 0
wave_spawn_rate = 10.0
simulation_running = false
player_lifes = 50
player_money = 820
last_entity_spawned = 0.0
tower_under_cursor = nil
selected_tower = nil
time_factor = 1.0
fast_forward = false
mouse = Vector(0, 0)
magic = false

current_map = "map3"

-- Constructs table of maps by looping through the specified directory
-- mapdir must have trailing forward slash
local mapdir = "maps/lua/"
maps = {}
-- TODO: check if this works on windows (because of ls command)
for file in io.popen('ls ' .. mapdir):lines() do
    local filename = file:sub(1, #file - 4)
    maps[filename] = require(mapdir .. filename)
end
