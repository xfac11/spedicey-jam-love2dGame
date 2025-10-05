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

local directionUp = { x = 1, y = 1}
local directionBot = {x = -1, y = 1}
local directionLeft = {x = -1, y = -1}
local directionRight = {x = 1, y = -1}
local partSpeed = 50

local function lerp(a,b,t) return (1-t)*a + t*b end
local function dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

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
  self.entityPartCore.enabled = false

  self.shattered = false
  self.startRemerge = false
  self.tryRevive = false
  self.partDistance = {
    left = 0,
    right = 0,
    top = 0,
    bot = 0
  }

  self.partTransform = {
    left = self.entityPartLeft:getComponent("Transform"),
    right = self.entityPartRight:getComponent("Transform"),
    top = self.entityPartTop:getComponent("Transform"),
    bot = self.entityPartBot:getComponent("Transform")
  }

  self.timeToRemerge = 5
  self.currentTime = 0

  self.lerpTime = 0
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



  if self.shattered then
    self.partTransform.bot.position.y = self.partTransform.bot.position.y + directionBot.y * dt * partSpeed
    self.partTransform.bot.position.x = self.partTransform.bot.position.x + directionBot.x * dt * partSpeed

    self.partTransform.top.position.y = self.partTransform.top.position.y + directionUp.y * dt * partSpeed
    self.partTransform.top.position.x = self.partTransform.top.position.x + directionUp.x * dt * partSpeed

    self.partTransform.right.position.y = self.partTransform.right.position.y + directionRight.y * dt * partSpeed
    self.partTransform.right.position.x = self.partTransform.right.position.x + directionRight.x * dt * partSpeed

    self.partTransform.left.position.y = self.partTransform.left.position.y + directionLeft.y * dt * partSpeed
    self.partTransform.left.position.x = self.partTransform.left.position.x + directionLeft.x * dt * partSpeed
    self.currentTime = self.currentTime - dt
    if self.currentTime < 0 then
      ---Game over
    else
      if love.keyboard.isDown("space") then
        self:remerge()
      end
    end
  end

  if self.startRemerge then

    self.partTransform.left.position.x = lerp(self.partTransform.left.position.x, self:getComponent("Transform").position.x, self.lerpTime/self.partDistance.left)
    self.partTransform.left.position.y = lerp(self.partTransform.left.position.y, self:getComponent("Transform").position.y, self.lerpTime/self.partDistance.left)

    self.partTransform.right.position.x = lerp(self.partTransform.right.position.x, self:getComponent("Transform").position.x, self.lerpTime/self.partDistance.right)
    self.partTransform.right.position.y = lerp(self.partTransform.right.position.y, self:getComponent("Transform").position.y, self.lerpTime/self.partDistance.right)

    self.partTransform.bot.position.x = lerp(self.partTransform.bot.position.x, self:getComponent("Transform").position.x, self.lerpTime/self.partDistance.bot)
    self.partTransform.bot.position.y = lerp(self.partTransform.bot.position.y, self:getComponent("Transform").position.y, self.lerpTime/self.partDistance.bot)

    self.partTransform.top.position.x = lerp(self.partTransform.top.position.x, self:getComponent("Transform").position.x, self.lerpTime/self.partDistance.top)
    self.partTransform.top.position.y = lerp(self.partTransform.top.position.y, self:getComponent("Transform").position.y, self.lerpTime/self.partDistance.top)

    self.lerpTime = self.lerpTime + dt * 5
    if (self.lerpTime/self.partDistance.left) > 0.03 then
      self.tryRevive = true
    end

  end

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
function Player:revive()
  self.startRemerge = false
  self.entityPipe.enabled = true
  self.entityPartBot.enabled = false
  self.entityPartLeft.enabled = false
  self.entityPartRight.enabled = false
  self.entityPartTop.enabled = false
  self.entityPartCore.enabled = false
  self.enabled = true
  self:getComponent("HealthComponent").isDead = false
  self:getComponent("HealthComponent"):increaseHealth(100)
end
function Player:shatter()
  self.currentTime = self.timeToRemerge
  self.enabled = false
  self.entityPipe.enabled = false
  self.entityPartBot.enabled = true
  self.entityPartLeft.enabled = true
  self.entityPartRight.enabled = true
  self.entityPartTop.enabled = true
  self.entityPartCore.enabled = true
  self.entityPartCore:getComponent("Transform").position.x = self:getComponent("Transform").position.x
  self.entityPartCore:getComponent("Transform").position.y = self:getComponent("Transform").position.y

  self.shattered = true

  local offsetScale = 10
  self.partTransform.left.position.x = self:getComponent("Transform").position.x + directionLeft.x * offsetScale
  self.partTransform.right.position.x = self:getComponent("Transform").position.x + directionRight.x * offsetScale
  self.partTransform.bot.position.x = self:getComponent("Transform").position.x + directionBot.x * offsetScale
  self.partTransform.top.position.x = self:getComponent("Transform").position.x + directionUp.x * offsetScale

  self.partTransform.left.position.y = self:getComponent("Transform").position.y + directionLeft.y * offsetScale
  self.partTransform.right.position.y = self:getComponent("Transform").position.y + directionRight.y * offsetScale
  self.partTransform.bot.position.y = self:getComponent("Transform").position.y + directionBot.y * offsetScale
  self.partTransform.top.position.y = self:getComponent("Transform").position.y + directionUp.y * offsetScale

end
function Player:remerge()
  self.shattered = false
  self.startRemerge = true
  self.partDistance.bot = dist(self.partTransform.bot.position.x,self.partTransform.bot.position.y, self:getComponent("Transform").position.x, self:getComponent("Transform").position.y)
  self.partDistance.top = dist(self.partTransform.top.position.x,self.partTransform.top.position.y, self:getComponent("Transform").position.x, self:getComponent("Transform").position.y)
  self.partDistance.right = dist(self.partTransform.right.position.x,self.partTransform.right.position.y, self:getComponent("Transform").position.x, self:getComponent("Transform").position.y)
  self.partDistance.left = dist(self.partTransform.left.position.x,self.partTransform.left.position.y, self:getComponent("Transform").position.x, self:getComponent("Transform").position.y)
end

return Player
