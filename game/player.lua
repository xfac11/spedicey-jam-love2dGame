local Entity = require "entity"
local Player = Entity:extend()
local MoveComponent = require "moveComponent"
local Transform = require "transform"
local ImageComponent = require "imageComponent"
local ShootingComponent = require "shootingComponent"
local PLAYER_SPEED = 300

function Player:new()
  Player.super.new(self)
  local transform = Transform(self, 0, 0)
  local moveComponent = MoveComponent(self)
  local imageComponent = ImageComponent(self, "assets/player.png")
  local shootingComponent = ShootingComponent(self)
  moveComponent:setSpeed(PLAYER_SPEED)

  self:addComponent("Transform", transform)
  self:addComponent("MoveComponent", moveComponent)
  self:addComponent("ImageComponent", imageComponent)
  self:addComponent("ShootingComponent", shootingComponent)
end

function Player:update(dt)
  for k, component in pairs(self.components) do
    component:update(dt)
  end
end

function Player:draw()
  for k, component in pairs(self.components) do
    component:draw()
  end
end

function Player:load()
  for k, component in pairs(self.components) do
    component:load()
  end
end

return Player
