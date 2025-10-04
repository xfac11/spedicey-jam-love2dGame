local Object = require "lib.classic"
local EntityContainer = Object:extend()
local Projectile = require "projectile"
function EntityContainer:new()
  self.container = {}
end

function EntityContainer:addEntity(entity)
  table.insert(self.container, entity)
end
--- This function creates a copy of the entity each time it adds.
---@param entity Entity
---@param count number of entites to add
function EntityContainer:addEntities(entity, count)
  for i=1,count do
    local copyEntity = Projectile()
    table.insert(self.container, copyEntity)
  end
end

function EntityContainer:removeEntity(entityID)
  local entityIndex = -1
  for index, entity in pairs(self.container) do
    if entity.entityID == entityID then
      entityIndex = index
      break
    end
  end

  if entityIndex == -1 then
    print("Could not find the entity with the id:", entityID)
    return
  end
  table.remove(self.container, entityIndex)
end


return EntityContainer
