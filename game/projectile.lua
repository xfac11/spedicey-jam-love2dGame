local Entity = require "entity"
local Projectile = Entity:extend()
local love = require "love"
local Transform = require "transform"
local ImageComponent = require "imageComponent"

function Projectile:new()
  Projectile.super.new(self)
  self.speed = 1000
  self.direction_x = 0
  self.direction_y = 0
  self.damageNumber = 1
  self.enabled = false

  local transform = Transform(self, 0, 0)
  local imageComponent = ImageComponent(self, "assets/projectile.png")
  self:addComponent("Transform", transform)
  self:addComponent("ImageComponent", imageComponent)
end

function Projectile:load()
  for k, component in pairs(self.components) do
    component:load()
  end
end

function Projectile:draw()
  if self.enabled then
    for k, component in pairs(self.components) do
      component:draw()
    end
  end
  local transform = self:getComponent("Transform")
  --love.graphics.print(tostring(self.id), transform.position.x, transform.position.y)
  love.graphics.print(transform.rotation, transform.position.x, transform.position.y)
end

function Projectile:update(dt)
  if self.enabled then
    for k, component in pairs(self.components) do
      component:update(dt)
    end
    local transform = self:getComponent("Transform")
    transform:move(self.direction_x * dt * self.speed, self.direction_y * dt * self.speed)
  end
end

return Projectile

