local Entity = require "entity"
local Enemy = Entity:extend()

local Transform = require "transform"
local ImageComponent = require "imageComponent"
local TargetComponent = require "targetComponent"
local HealthComponent = require "healthComponent"
local BodyComponent = require "bodyComponent"

local ENEMY_HEALTH = 100
local ENEMY_SPEED = 100
local ENEMY_CLOSENES = 50

function Enemy:new(player, x, y)
  Enemy.super.new(self)

  self.player = player
  self.damage = 10
  self.cooldown = 0
  self.coolDownTime = 1
  local transform = Transform(self, x , y)
  local imageComponent = ImageComponent(self, "assets/enemy.png")
  local targetComponent = TargetComponent(self, player, ENEMY_SPEED, ENEMY_CLOSENES)
  local healthComponent = HealthComponent(self, ENEMY_HEALTH)
  local bodyComponent = BodyComponent(self, 0, 0)

  self:addComponent("Transform", transform)
  self:addComponent("ImageComponent", imageComponent)
  self:addComponent("TargetComponent", targetComponent)
  self:addComponent("HealthComponent", healthComponent)
  self:addComponent("BodyComponent", bodyComponent)


end

function Enemy:load()
  Enemy.super.load(self)
  local bodyComponent = self:getComponent("BodyComponent")
  local imageComponent = self:getComponent("ImageComponent")
  bodyComponent:setHeight(imageComponent.height * 0.8)
  bodyComponent:setWidth(imageComponent.width * 0.8)
  bodyComponent:setDrawBoundaries(true)
  bodyComponent:setOrigin(imageComponent.origin_x_zoomed, imageComponent.origin_y_zoomed)
end

function Enemy:update(dt)
  Enemy.super.update(self, dt)
  self.cooldown = self.cooldown - dt
  local bodyComponent = self:getComponent("BodyComponent")
  if bodyComponent:checkCollision(self.player:getComponent("BodyComponent")) and self.cooldown < 0 then
    self.cooldown = self.coolDownTime
    self.player:getComponent("HealthComponent"):decreaseHealth(self.damage)
  end
end

return Enemy
