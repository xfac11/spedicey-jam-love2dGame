https = nil
local overlayStats = require("lib.overlayStats")
local runtimeLoader = require("runtime.loader")
local player = {}
player.imagePath = "assets/player.png"
player.image = nil
player.position = {x = 0, y = 0}

function love.load()
  https = runtimeLoader.loadHTTPS()
  -- Your game load here
  player.image = love.graphics.newImage(player.imagePath)


  overlayStats.load() -- Should always be called last
end

function love.draw()
  -- Your game draw here
  love.graphics.draw(player.image, player.position.x, player.position.y);

  overlayStats.draw() -- Should always be called last
end

function love.update(dt)
  -- Your game update here


  overlayStats.update(dt) -- Should always be called last
end

function love.keypressed(key)
  if key == "escape" and love.system.getOS() ~= "Web" then
    love.event.quit()
  else
    overlayStats.handleKeyboard(key) -- Should always be called last
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  overlayStats.handleTouch(id, x, y, dx, dy, pressure) -- Should always be called last
end
