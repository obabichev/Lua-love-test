Player = GameObject:extend()

function Player:new(area, x, y, opts)
    print("CONSTRUCTOR PLAYER")
    Player.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)

    self.r = -math.pi / 2
    self.rv = 1.66 * math.pi
    self.v = 0
    self.base_max_v = 100
    self.max_v = self.base_max_v
    self.a = 100

    self.timer:every(0.24, function()
        self:shoot()
    end)

    input:bind('f3', function() self:die() end)

    self.timer:every(5, function() self:tick() end)

    self:createTrail()
end

function Player:createTrail()
    self.trail_color = skill_point_color
    self.timer:every(0.01, function()
        self.area:addGameObject('TrailParticle',
            self.x - self.w * math.cos(self.r),
            self.y - self.h * math.sin(self.r),
            { parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color })
    end)
end

function Player:shoot()
    local d = 1.2 * self.w

    self.area:addGameObject('ShootEffect',
        self.x + d * math.cos(self.r),
        self.y + d * math.sin(self.r),
        { player = self, d = d })

    self.area:addGameObject('Projectile',
        self.x + 1.5 * d * math.cos(self.r),
        self.y + 1.5 * d * math.sin(self.r),
        { r = self.r })
end

function Player:update(dt)
    Player.super.update(self, dt)

    if input:down('left') then self.r = self.r - self.rv * dt end
    if input:down('right') then self.r = self.r + self.rv * dt end

    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end

    self.max_v = self.base_max_v
    self.boosting = false
    if input:down('up') then
        self.boosting = true
        self.max_v = 1.5 * self.base_max_v
    end
    if input:down('down') then
        self.boosting = true
        self.max_v = 0.5 * self.base_max_v
    end
    self.trail_color = skill_point_color
    if self.boosting then self.trail_color = boost_color end

    self.v = math.min(self.v + self.a * dt, self.max_v)
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.line(self.x, self.y, self.x + 2 * self.w * math.cos(self.r), self.y + 2 * self.w * math.sin(self.r))
end

function Player:destroy()
    Player.super.destroy(self)
end

function Player:die()
    slow(0.15, 1)
    flash(4)
    camera:shake(6, 60, 0.4)
    self.dead = true
    for i = 1, love.math.random(8, 12) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y)
    end
end

function Player:tick()
    self.area:addGameObject('TickEffect', self.x, self.y, { parent = self })
end
