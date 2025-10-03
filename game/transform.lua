local Component = require "component"

local Transform = Component:extend()

function Transform:new(parent, posX, posY)
  Transform.super.new(self, parent)
  self.position = {x = posX, y = posY}
  self.rotation = 0
  self.scale = {x = 1, y = 1}
end

function Transform:move(x, y)
  self.position.x = self.position.x + x
  self.position.y = self.position.y + y
end

return Transform
