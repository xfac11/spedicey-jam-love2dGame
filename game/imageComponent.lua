local Component = require "component"
local love = require "love"
local ImageComponent = Component:extend()
local ZOOM = 0.3
function ImageComponent:new(parent, path)
  ImageComponent.super.new(self, parent)
  self.imagePath = path
  self.image = nil
  self.origin_x = 0
  self.origin_y = 0
  self.width = 0
  self.height = 0
  self.origin_x_zoomed = 0
  self.origin_y_zoomed = 0
end

function ImageComponent:load()
  self.image = love.graphics.newImage(self.imagePath)
  self.origin_x = self.image:getWidth()/2
  self.origin_y = self.image:getHeight()/2

  self.width = self.image:getWidth() * ZOOM
  self.height = self.image:getHeight() * ZOOM
  self.origin_x_zoomed = self.origin_x * ZOOM
  self.origin_y_zoomed = self.origin_y * ZOOM

end

function ImageComponent:draw()
  local transform = self.parent:getComponent("Transform")
  love.graphics.draw(self.image, transform.position.x, transform.position.y, transform.rotation, ZOOM*transform.scale.x, ZOOM*transform.scale.y, self.origin_x, self.origin_y)
end


return ImageComponent
