require "util"
require "vector"
require "number_format"
require "globals"
require "field"
require "entity"
require "directed_projectile"
require "line_projectile"
require "freeze_projectile"
require "entities"
require "tower"
require "gui"
require "buttons"
require "sound"
require "laser_tower"
require "freeze_tower"
require "sniper_tower"
sti = require "sti"

tower_types = { 
    Tower,
    FreezeTower,
    SniperTower,
    LaserTower
}


function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        tower_under_cursor = nil
        selected_tower = nil
    end

    if key == "m" then
        toggleMute()
    end

    if key == "f9" then
        magic = not magic
    end
end


function love.mousepressed(x, y, button, istouch)
    print(x, y, button, istouch)
    if button == 1 then
        check_button_actions()
        on_gui_click(x, y)
    end
end


function love.load(arg)

    desktopW,desktopH = love.window.getDesktopDimensions(1)
    love.window.setMode(desktopW, desktopH, 
                       {fullscreen=true, fullscreentype="desktop", vsync=true})

    playMusic("music")
    toggleMute()

    font = love.graphics.newFont("images/font.ttf", 14)
    love.graphics.setFont(font)

    big_font = love.graphics.newFont("images/font.ttf", 23)
    very_big_font = love.graphics.newFont("images/font.ttf", 45)

    img_star = love.graphics.newImage("images/star.png")

    logo = love.graphics.newImage("images/logo-wip.png")
    background = love.graphics.newImage("images/background.png")
    img_slow = love.graphics.newImage("images/slow.png")
    load_field(maps[current_map])

    pointer_cursor = love.mouse.getSystemCursor("hand")

end


function love.update(dt)
    map:update(dt)
    if player_lifes < 1 then
        return
    end

    mouse = Vector(love.mouse.getX(), love.mouse.getY())


    if simulation_running then 
        local any_entities_left = false
        local diff = (love.timer.getTime() - last_entity_spawned) * time_factor

        -- Neuen Entity spawnen?
        if diff > wave_spawn_rate then
            entity = table.remove(entity_queue, 1)
            table.insert(entities, entity)
            last_entity_spawned = love.timer.getTime()
        end

        -- Entities updaten
        for i = 1, #entities do
            local entity = entities[i]
            if entity ~= nil then
                entity:update(dt * time_factor)
                any_entities_left = true
                if entity.destroyed then
                    table.remove(entities, i)

                elseif entity:is_finished() then
                    entity.destroyed = true
                    table.remove(entities, i)
                    player_lifes = player_lifes - 1
                end 
            end
        end

        -- Projektile updaten
        for i = 1, #projectiles do
            local proj = projectiles[i]
            if proj ~= nil and proj:update(dt * time_factor) == false then
                table.remove(projectiles, i)
            end
        end

        -- Tower updaten
        for i = 1, #towers do
            local tower = towers[i]
            tower:update(dt * time_factor)
        end
        
        -- Evt. wave stoppen
        if any_entities_left == false and #entity_queue == 0 then
            stop_wave()
        end
    else
        -- IDLE Tower updaten
        for i = 1, #towers do
            local tower = towers[i]
            tower:update_idle(dt * time_factor)
        end
        


    end
end


function love.draw()

    anything_hovered = false
	scale = {x = love.graphics.getWidth()/1280,
             y = love.graphics.getHeight()/900}
	love.graphics.scale(scale.x, scale.y)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(logo, 50, -25)
    love.graphics.setColor(100, 100, 100, 255)
    -- love.graphics.rectangle("fill", 0, 0, 10000, 10000)

    -- Field area
    love.graphics.setScissor(field_start.x * scale.x, 
                             field_start.y * scale.y, 
                             field_size.x * scale.x * field_width,
                             field_size.y * scale.y * field_height)
    map:draw()

    -- Draw projectiles
    for i = 1, #projectiles do
        local projectile = projectiles[i]
        projectile:draw()
    end

    -- Draw entities
    for i = 1, #entities do
        local entity = entities[i]
        entity:draw()
    end

    -- Draw Towers
    for i = 1, #towers do
        local tower = towers[i]
        towers[i]:draw()
    end

    love.graphics.setScissor()

    -- Draw Field borders
    love.graphics.setColor(100, 100, 100, 255)
    love.graphics.rectangle("line", field_start.x, field_start.y, 
                            field_width * field_size.x,
                            field_height * field_size.y)
    draw_gui()


    if player_lifes < 1 then
        love.graphics.setColor(128, 10, 10, 200)
        love.graphics.rectangle("fill", 0, 0, 10000, 10000)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setFont(very_big_font)
        love.graphics.print("GAME OVER!", love.graphics.getWidth() / 2 - 120,
                            love.graphics.getHeight() / 2 - 30)
        love.graphics.setFont(font)
    end

    if anything_hovered then
        love.mouse.setCursor(pointer_cursor)
    else
        love.mouse.setCursor()
    end

end
