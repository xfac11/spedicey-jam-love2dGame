local object = require "lib.classic"

local Entity = object:extend()

function Entity:new()
  self.id = ENTITY_ID
  ENTITY_ID = ENTITY_ID + 1
  self.components = {}
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

return Entity
