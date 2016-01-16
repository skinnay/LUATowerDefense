
LaserTower = Tower.create()
LaserTower.__index = LaserTower
LaserTower.radius = 190
LaserTower.cost = 900
LaserTower.name = "Laser Tower"
LaserTower.shoot_speed = 3.0

function LaserTower.create()
    local instance = {}
    setmetatable(instance, LaserTower)
    return instance
end

function LaserTower.draw_inner_shape(x, y, upgrade)

    love.graphics.setColor(229, 213, 31, 255)
    love.graphics.rectangle("fill", x - 10, y - 10, 20, 20)

    love.graphics.setColor(30,30,30, 120)
    -- love.graphics.polygon("fill", x, y - 6,  x - 6, y + 6, x + 6, y + 6)
    -- love.graphics.polygon("fill", x - 10, y - 10,  x - 5, y - 10, x - 10, y - 5)
    -- love.graphics.polygon("fill", x + 10, y + 5, x + 10, y + 10, x + 5, y + 10)
    love.graphics.line(x - 5, y, x + 5, y)
    love.graphics.line(x, y + 5, x, y - 5)
    love.graphics.line(x - 5, y - 5, x + 5, y + 5)
    love.graphics.line(x + 5, y - 5, x - 5, y + 5)

    love.graphics.setColor(30,30,30, 255)
    love.graphics.rectangle("line", x - 11, y - 11, 22, 22)

end

function LaserTower:shoot_projectile()
    local proj = Tower.shoot_projectile(self)
    proj.laserProjectile = true

    local dir = self.target:get_pos() - self:get_pos()
    dir = dir / dir:len()
    proj.pos = proj.pos + dir * 20

    return proj
end



function LaserTower:do_internal_upgrade()
    self.damage = self.damage + self.upgrade * self.upgrade + 2
    self.radius = self.radius + 5
    self.shoot_frequency = self.shoot_frequency * 0.99
end


function LaserTower:get_upgrade_cost()
    return 300 + self.upgrade * self.upgrade * 100
end

