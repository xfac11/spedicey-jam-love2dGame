local Component = require "component"
local ShootingComponent = Component:extend()

local love = require "love"

local Projectile = require "projectile"
local EntityContainer = require "entityContainer"


function ShootingComponent:new(parent)
  ShootingComponent.super.new(self, parent)
  self.bulletImage = nil
  self.cooldown = 0.0
  self.cooldownTime = 0.2
  self.bulletImagePath = "assets/bullet.png"
  self.projectilePool = EntityContainer()
  local projectile = Projectile()
  self.projectilePool:addEntities(projectile, 50)
end

function ShootingComponent:load()
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
        projTransform.position.x = transform.position.x
        projTransform.position.y = transform.position.y
        self.cooldown = self.cooldownTime
        break
      end
    end
  end

  for k, v in pairs(self.projectilePool.container) do
    v:update(dt)
  end
end

function ShootingComponent:draw()
  local mouse_x, mouse_y = love.mouse.getPosition()

  local transform = self.parent:getComponent("Transform")
  love.graphics.line(transform.position.x, transform.position.y, mouse_x, mouse_y)

  for k, v in pairs(self.projectilePool.container) do
    v:draw()
  end
end

return ShootingComponent
