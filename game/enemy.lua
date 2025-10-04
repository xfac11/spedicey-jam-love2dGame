local Entity = require "entity"
local Enemy = Entity:extend()

local Transform = require "transform"
local ImageComponent = require "imageComponent"
local TargetComponent = require "targetComponent"
local HealthComponent = require "healthComponent"

local ENEMY_HEALTH = 100
local ENEMY_SPEED = 100
local ENEMY_CLOSENES = 50

function Enemy:new(player, x, y)
  Enemy.super.new(self)

  local transform = Transform(self, x , y)
  local imageComponent = ImageComponent(self, "assets/enemy.png")
  local targetComponent = TargetComponent(self, player, ENEMY_SPEED, ENEMY_CLOSENES)
  local healthComponent = HealthComponent(self, ENEMY_HEALTH)

  self:addComponent("Transform", transform)
  self:addComponent("ImageComponent", imageComponent)
  self:addComponent("TargetComponent", targetComponent)
  self:addComponent("HealthComponent", healthComponent)


end

return Enemy
