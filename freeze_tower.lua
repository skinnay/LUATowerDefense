

FreezeTower = Tower.create()
FreezeTower.__index = FreezeTower
FreezeTower.radius = 100
FreezeTower.cost = 500
FreezeTower.name = "Freeze Tower"
FreezeTower.shoot_frequency = 1.5
FreezeTower.damage = 0
FreezeTower.freeze_factor = 0.75
FreezeTower.single_target = false

function FreezeTower:shoot_projectile()
    local proj = FreezeProjectile.create()
    proj.speed = self.shoot_speed
    proj.damage = 0
    proj.pos = self:get_pos()
    proj.radius = self.radius
    proj.freeze_factor = self.freeze_factor
    return proj
end

function FreezeTower:create()
    local instance = {}
    setmetatable(instance, FreezeTower)
    return instance
end

function FreezeTower:do_internal_upgrade()
    self.radius = self.radius + 3
    self.shoot_frequency = self.shoot_frequency * 0.995
    self.freeze_factor = self.freeze_factor * 0.97 + 0.03
end

function FreezeTower.draw_inner_shape(x, y, upgrade)
    big_ugprade = math.floor(upgrade / 7)
    upgrade = upgrade % 7

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(img_slow, x - 10, y - 10)

    love.graphics.setColor(30,30,30, 255)
    love.graphics.rectangle("line", x - 11, y - 11, 22, 22)
end


