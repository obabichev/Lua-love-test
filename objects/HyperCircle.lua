HyperCircle = Circle:extend()

function HyperCircle:new(x, y, radius, lineWidth, outerRadius)
    HyperCircle.super.new(self, x, y, radius)
    self.lineWidth = lineWidth
    self.outerRadius = outerRadius
end

function HyperCircle:draw()
    HyperCircle.super.draw(self)
    love.graphics.setLineWidth(self.lineWidth)
    love.graphics.ellipse("line", self.x, self.y, self.outerRadius, self.outerRadius)
end

