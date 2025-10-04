local Component = require "component"
local HealthComponent = Component:extend()

function HealthComponent:new(parent, maximumHealth)
  HealthComponent.super.new(self, parent)
  self.currentHealth = maximumHealth
  self.maxHealth = maximumHealth
  self.isDead = false
  self.onDeath = function () end
  self.onDamage = function () end
  self.onHealed = function () end
  self.onHealedMax = function () end
end

function HealthComponent:getCurrentHealth()
  return self.currentHealth
end

function HealthComponent:getMaxHealth()
  return self.maxHealth
end

function HealthComponent:decreaseHealth(amount)
  self.currentHealth = math.max(self.currentHealth - amount, 0)
  self.onDamage()
  if self.currentHealth == 0 then
    self.isDead = true
    self.onDeath()
  end
end

function HealthComponent:increaseHealth(amount)
  self.currentHealth = math.min(self.maxHealth, self.currentHealth + amount)
  self.onHealed()
  if self.currentHealth == self.maxHealth then
    self.onHealedMax()
  end
end

return HealthComponent
