local Component = require "component"
local TargetComponent = Component:extend()

function TargetComponent:new(parent, targetToFollow, speed, distanceToTarget)
  TargetComponent.super.new(self, parent)
  self.target = targetToFollow
  self.speed = speed
  self.distanceToTarget = distanceToTarget
end

function TargetComponent:update(dt)
  local targetTransform = self.target:getComponent("Transform")
  local target_x = targetTransform.position.x
  local target_y = targetTransform.position.y

  local parenTransform = self.parent:getComponent("Transform")
  local direction_x = target_x - parenTransform.position.x
  local direction_y = target_y - parenTransform.position.y

  local length = math.sqrt((direction_x^2) + (direction_y^2))
  if length > self.distanceToTarget then
    direction_x = direction_x / length
    direction_y = direction_y / length
    parenTransform:move(direction_x * self.speed * dt, direction_y * self.speed * dt)
    parenTransform.rotation = math.atan2(direction_y, direction_x)
  end
end

return TargetComponent
