Circle = Object:extend()

function Circle:new(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.creation_time = love.timer.getTime()
end

function Circle:update(dt)
end

function Circle:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end