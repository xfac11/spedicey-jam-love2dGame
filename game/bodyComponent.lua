local Component = require "component"
local BodyComponent = Component:extend()
local love = require "love"
SHAPES = {
  AABB = 1,
  --CIRCLE = 2
}

function BodyComponent:new(parent, x, y)
  BodyComponent.super.new(self, parent)
  self.shape = SHAPES.AABB
  self.height = 0
  self.width = 0
  self.x = 0
  self.y = 0
  self.originX = 0
  self.originY = 0
  self.followParent = true
  self.parentTransform = nil
  self.radius = 0
  self.drawBoundaries = false
end

local function checkAABB(a, b)
  local a_left = a.x
  local a_right = a.x + a.width
  local a_top = a.y
  local a_bottom = a.y + a.height

  local b_left = b.x
  local b_right = b.x + b.width
  local b_top = b.y
  local b_bottom = b.y + b.height

  return  a_right > b_left
      and a_left < b_right
      and a_bottom > b_top
      and a_top < b_bottom
end

function BodyComponent:checkCollision(anotherBody)
  if self.shape == SHAPES.AABB and anotherBody.shape == SHAPES.AABB then
    local is_colliding = checkAABB(self, anotherBody)
    if is_colliding then
      return true
    else
      return false
    end
  end
end

function BodyComponent:setOrigin(x, y)
  self.originX = x
  self.originY = y
end

function BodyComponent:setPosition(x, y)
  self.x = x - self.originX
  self.y = y - self.originY
end

function BodyComponent:setHeight(height)
  self.height = height
end

function BodyComponent:setWidth(width)
  self.width = width
end

function BodyComponent:setDrawBoundaries(shouldDraw)
  self.drawBoundaries = shouldDraw
end

function BodyComponent:load()
  self.parentTransform = self.parent:getComponent("Transform")
end

function BodyComponent:draw()
  if self.drawBoundaries then
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
  end
end

function BodyComponent:update(dt)
  if self.followParent then
    self:setPosition(self.parentTransform.position.x, self.parentTransform.position.y)
  end
end

return BodyComponent
