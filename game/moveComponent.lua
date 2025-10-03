local object = require "lib.classic"
local Component = require "component"

local MoveComponent = Component:extend()

function MoveComponent:new(parent)
  MoveComponent.super.new(self, parent)
  self.speed = 100.0
end

function MoveComponent:update(dt)
  local transform = self.parent:getComponent("Transform")
  local directionInput = {x = 0, y = 0}
  directionInput.x = 0
  directionInput.y = 0
  if love.keyboard.isDown("w") then
    directionInput.y = -1
  elseif love.keyboard.isDown("s") then
    directionInput.y = 1
  end
  if love.keyboard.isDown("a") then
    directionInput.x = -1
  elseif love.keyboard.isDown("d") then
    directionInput.x = 1
  end
  transform:move(directionInput.x * self.speed * dt,  directionInput.y * self.speed * dt)
end

function MoveComponent:setSpeed(speed)
  self.speed = speed
end

return MoveComponent
