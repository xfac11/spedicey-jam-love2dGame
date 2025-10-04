local Component = require "component"
local love = require "love"
local ImageComponent = Component:extend()

function ImageComponent:new(parent, path)
  ImageComponent.super.new(self, parent)
  self.imagePath = path
  self.image = nil
  self.origin_x = 0
  self.origin_y = 0
end

function ImageComponent:load()
  self.image = love.graphics.newImage(self.imagePath)
  self.origin_x = self.image:getWidth()/2
  self.origin_y = self.image:getHeight()/2

end

function ImageComponent:draw()
  local transform = self.parent:getComponent("Transform")
  love.graphics.draw(self.image, transform.position.x, transform.position.y, transform.rotation, 0.5*transform.scale.x, 0.5*transform.scale.y, self.origin_x, self.origin_y)
end

return ImageComponent
