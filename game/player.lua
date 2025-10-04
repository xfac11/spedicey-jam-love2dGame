local Entity = require "entity"
local Player = Entity:extend()
local MoveComponent = require "moveComponent"
local Transform = require "transform"
local ImageComponent = require "imageComponent"
local ShootingComponent = require "shootingComponent"
local HealthComponent = require "healthComponent"

local PLAYER_SPEED = 300
local PLAYER_HEALTH = 100

function Player:new()
  Player.super.new(self)
  local transform = Transform(self, 0, 0)
  local moveComponent = MoveComponent(self)
  local imageComponent = ImageComponent(self, "assets/player.png")
  local shootingComponent = ShootingComponent(self)
  local healthComponent = HealthComponent(self, PLAYER_HEALTH)
  moveComponent:setSpeed(PLAYER_SPEED)

  self:addComponent("HealthComponent", healthComponent)
  self:addComponent("Transform", transform)
  self:addComponent("MoveComponent", moveComponent)
  self:addComponent("ImageComponent", imageComponent)
  self:addComponent("ShootingComponent", shootingComponent)


  self.entityPipe = Entity()
  local transformPipe = Transform(self.entityPipe, 0, 0)
  local imageComponent2 = ImageComponent(self.entityPipe, "assets/laserPipeOnly.png")
  self.entityPipe:addComponent("Transform", transformPipe)
  self.entityPipe:addComponent("ImageComponent", imageComponent2)
end

function Player:update(dt)
  Player.super.update(self, dt)
  self.entityPipe:update(dt)
  local transform = self.entityPipe:getComponent("Transform")
  local mx, my = love.mouse.getPosition()
  transform.position = self:getComponent("Transform").position
  transform.rotation = math.atan2(my - transform.position.y, mx - transform.position.x)
end

function Player:draw()
  self.entityPipe:draw()
  Player.super.draw(self)
end

function Player:load()
  Player.super.load(self)
  self.entityPipe:load()
  self.entityPipe:getComponent("ImageComponent").origin_x = 0
end

return Player
