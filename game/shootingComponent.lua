local Component = require "component"
local ShootingComponent = Component:extend()

local love = require "love"

local Projectile = require "projectile"
local EntityContainer = require "entityContainer"


function ShootingComponent:new(parent)
  ShootingComponent.super.new(self, parent)
  self.cooldown = 0.0
  self.cooldownTime = 0.2
  self.soundPath = "assets/146725__leszek_szary__laser.wav"
  self.projectilePool = EntityContainer()
  self.shootSound = nil
  local projectile = Projectile()
  self.projectilePool:addEntities(projectile, 50)
end

function ShootingComponent:load()
  self.shootSound = love.audio.newSource(self.soundPath, "stream")
  for k, v in pairs(self.projectilePool.container) do
    v:load()
  end
end

function ShootingComponent:update(dt)
  self.cooldown = self.cooldown - dt
  self.cooldown = math.max(0.0, self.cooldown)

  local mouse_x, mouse_y = love.mouse.getPosition()

  local transform = self.parent:getComponent("Transform")

  local direction = {x = mouse_x - transform.position.x, y = mouse_y - transform.position.y}
  local length = math.sqrt((direction.x*direction.x + direction.y * direction.y))
  direction.x = direction.x / length
  direction.y = direction.y / length

  if love.mouse.isDown(1) and self.cooldown == 0.0 then
    for k, v in pairs(self.projectilePool.container) do
      if not v.enabled then
        v.enabled = true
        v.direction_x = direction.x
        v.direction_y = direction.y
        local projTransform = v:getComponent("Transform")
        if self.shootSound:isPlaying() then
          self.shootSound:stop()
        end
        self.shootSound:play()
        projTransform.position.x = transform.position.x + direction.x * 5
        projTransform.position.y = transform.position.y + direction.y * 5
        projTransform.rotation = math.atan2(mouse_y - transform.position.y, mouse_x - transform.position.x)
        self.cooldown = self.cooldownTime
        v:getComponent("Timer"):start()
        break
      end
    end
  end

  for k, v in pairs(self.projectilePool.container) do
    v:update(dt)
  end
end

function ShootingComponent:draw()
  for k, v in pairs(self.projectilePool.container) do
    v:draw()
  end
end

return ShootingComponent
