local Entity = require "entity"
local Projectile = Entity:extend()
local love = require "love"
local Transform = require "transform"
local ImageComponent = require "imageComponent"
local Timer = require "timer"
local BodyComponent = require "bodyComponent"


function Projectile:new()
  Projectile.super.new(self)
  self.speed = 1000
  self.direction_x = 0
  self.direction_y = 0
  self.damageNumber = 1
  self.lifetime = 2
  self.enabled = false

  local transform = Transform(self, 0, 0)
  local imageComponent = ImageComponent(self, "assets/projectile.png")
  local timer = Timer(self, self.lifetime)
  local bodyComponent = BodyComponent(self, 0, 0)
  timer.oneTime = true

  self:addComponent("Transform", transform)
  self:addComponent("ImageComponent", imageComponent)
  self:addComponent("Timer", timer)
  self:addComponent("BodyComponent", bodyComponent)
  self:getComponent("Timer").onTime = function ()
    self.enabled = false
  end
end

function Projectile:load()
  Projectile.super.load(self)
  local bodyComponent = self:getComponent("BodyComponent")
  local imageComponent = self:getComponent("ImageComponent")
  bodyComponent:setHeight(imageComponent.height*0.5)
  bodyComponent:setWidth(imageComponent.width*0.5)
  bodyComponent:setDrawBoundaries(true)
  bodyComponent:setOrigin(imageComponent.origin_x_zoomed, imageComponent.origin_y_zoomed)
end

function Projectile:draw()
  Projectile.super.draw(self)
end

function Projectile:update(dt)
  Projectile.super.update(self, dt)
  if self.enabled then
    local transform = self:getComponent("Transform")
    transform:move(self.direction_x * dt * self.speed, self.direction_y * dt * self.speed)
  end
end

return Projectile

