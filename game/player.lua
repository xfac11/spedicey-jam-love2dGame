local Entity = require "entity"
local Player = Entity:extend()
local MoveComponent = require "moveComponent"
local Transform = require "transform"
local ImageComponent = require "imageComponent"
local ShootingComponent = require "shootingComponent"
local HealthComponent = require "healthComponent"
local BodyComponent = require "bodyComponent"

local PLAYER_SPEED = 300
local PLAYER_HEALTH = 100

function Player:new()
  Player.super.new(self)
  local transform = Transform(self, 0, 0)
  local moveComponent = MoveComponent(self)
  local imageComponent = ImageComponent(self, "assets/player.png")
  local shootingComponent = ShootingComponent(self)
  local healthComponent = HealthComponent(self, PLAYER_HEALTH)
  local bodyComponent = BodyComponent(self, 0, 0)

  moveComponent:setSpeed(PLAYER_SPEED)

  self:addComponent("HealthComponent", healthComponent)
  self:addComponent("Transform", transform)
  self:addComponent("MoveComponent", moveComponent)
  self:addComponent("ImageComponent", imageComponent)
  self:addComponent("ShootingComponent", shootingComponent)
  self:addComponent("BodyComponent", bodyComponent)


  self.entityPipe = Entity()
  local transformPipe = Transform(self.entityPipe, 0, 0)
  local imageComponent2 = ImageComponent(self.entityPipe, "assets/laserPipeOnly.png")
  self.entityPipe:addComponent("Transform", transformPipe)
  self.entityPipe:addComponent("ImageComponent", imageComponent2)

  self.entityPartRight = Entity()
  local transformPartRight = Transform(self.entityPartRight, 0, 0)
  local partRightIC = ImageComponent(self.entityPartRight, "assets/playerPartRight.png")
  self.entityPartRight:addComponent("Transform", transformPartRight)
  self.entityPartRight:addComponent("ImageComponent", partRightIC)

  self.entityPartLeft = Entity()
  local transformPartLeft = Transform(self.entityPartLeft, 0, 0)
  local partLeftIC = ImageComponent(self.entityPartLeft, "assets/playerPartLeft.png")
  self.entityPartLeft:addComponent("Transform", transformPartLeft)
  self.entityPartLeft:addComponent("ImageComponent", partLeftIC)

  self.entityPartTop = Entity()
  local transformPartTop = Transform(self.entityPartTop, 0, 0)
  local partTopIC = ImageComponent(self.entityPartTop, "assets/playerPartTop.png")
  self.entityPartTop:addComponent("Transform", transformPartTop)
  self.entityPartTop:addComponent("ImageComponent", partTopIC)

  self.entityPartBot = Entity()
  local transformPartBot = Transform(self.entityPartBot, 0, 0)
  local partBotIC = ImageComponent(self.entityPartBot, "assets/playerPartBot.png")
  self.entityPartBot:addComponent("Transform", transformPartBot)
  self.entityPartBot:addComponent("ImageComponent", partBotIC)

  self.entityPartCore = Entity()
  local transformPartCore = Transform(self.entityPartCore, 0, 0)
  local partCoreIC = ImageComponent(self.entityPartCore, "assets/playerCore.png")
  self.entityPartCore:addComponent("Transform", transformPartCore)
  self.entityPartCore:addComponent("ImageComponent", partCoreIC)

  self.entityPartBot.enabled = false
  self.entityPartLeft.enabled = false
  self.entityPartRight.enabled = false
  self.entityPartTop.enabled = false
  self.entityPartCore.enabled = true

  healthComponent.onDeath = function ()
    self:shatter()
  end
end


function Player:load()
  Player.super.load(self)
  self.entityPipe:load()
  self.entityPartRight:load()
  self.entityPartLeft:load()
  self.entityPartTop:load()
  self.entityPartBot:load()
  self.entityPartCore:load()
  self.entityPipe:getComponent("ImageComponent").origin_x = 0

  local bodyComponent = self:getComponent("BodyComponent")
  local imageComponent = self:getComponent("ImageComponent")
  bodyComponent:setHeight(imageComponent.height)
  bodyComponent:setWidth(imageComponent.width)
  bodyComponent:setDrawBoundaries(true)
  bodyComponent:setOrigin(imageComponent.origin_x_zoomed, imageComponent.origin_y_zoomed)
end

function Player:update(dt)
  Player.super.update(self, dt)
  self.entityPipe:update(dt)
  self.entityPartRight:update(dt)
  self.entityPartLeft:update(dt)
  self.entityPartTop:update(dt)
  self.entityPartBot:update(dt)
  self.entityPartCore:update(dt)
  local transform = self.entityPipe:getComponent("Transform")
  local mx, my = love.mouse.getPosition()
  transform.position = self:getComponent("Transform").position
  transform.rotation = math.atan2(my - transform.position.y, mx - transform.position.x)

  self.entityPartLeft:getComponent("Transform").position = self:getComponent("Transform").position
  self.entityPartRight:getComponent("Transform").position = self:getComponent("Transform").position
  self.entityPartTop:getComponent("Transform").position = self:getComponent("Transform").position
  self.entityPartBot:getComponent("Transform").position = self:getComponent("Transform").position
  self.entityPartCore:getComponent("Transform").position = self:getComponent("Transform").position
end

function Player:draw()
  self.entityPipe:draw()
  Player.super.draw(self)
  self.entityPartRight:draw()
  self.entityPartLeft:draw()
  self.entityPartTop:draw()
  self.entityPartBot:draw()
  self.entityPartCore:draw()
end

function Player:shatter()
end

return Player
