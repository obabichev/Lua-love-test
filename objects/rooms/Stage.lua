Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()

    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Projectile', { ignores = { 'Projectile' } })
    self.area.world:addCollisionClass('Collectable', { ignores = { 'Collectable', 'Projectile' } })

    self.main_canvas = love.graphics.newCanvas(gw, gh)

    self.player = nil
    input:bind('f4', function() self.player = self.area:addGameObject('Player', gw / 2, gh / 2) end)

    input:bind('p', function()
        self.area:addGameObject('Boost', random(0, gw), random(0, gh))
    end)

    self.player = self.area:addGameObject('Player', gw / 2, gh / 2)
end

function Stage:update(dt)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw / 2, gh / 2)

    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    self.area:draw()
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
end