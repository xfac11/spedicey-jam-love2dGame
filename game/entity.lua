local object = require "lib.classic"

local Entity = object:extend()

function Entity:new()
  self.id = ENTITY_ID
  ENTITY_ID = ENTITY_ID + 1
  self.components = {}
  self.enabled = true
end

function Entity:getComponent(componentID)
  return self.components[componentID]
end

--- Adds the component to the components of this entity
---@param componentID any
---@param component Component
function Entity:addComponent(componentID, component)
  self.components[componentID] = component
end

function Entity:update(dt)
  if self.enabled then
    for k, component in pairs(self.components) do
      component:update(dt)
    end
  end

end

function Entity:draw()
  if self.enabled then
    for k, component in pairs(self.components) do
      component:draw()
    end
  end

end

function Entity:load()
  for k, component in pairs(self.components) do
    component:load()
  end
end

return Entity
