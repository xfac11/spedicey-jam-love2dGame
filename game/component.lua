local object = require "lib.classic"

local Component = object.extend(object)

function Component:new(parent)
  self.parent = parent
end

function Component:update(dt)
end

function Component:draw()
end

function Component:load()
end

return Component
