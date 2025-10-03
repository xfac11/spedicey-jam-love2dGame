https = nil
ENTITY_ID = 0
local love = require "love"
local overlayStats = require("lib.overlayStats")
local runtimeLoader = require("runtime.loader")
local push = require("lib.push") ---For resolution handling
local Player = require "player"
local player = Player()
local EntityContainer = require "entityContainer"
local gameWidth, gameHeight = 1920, 1080
local windowWidth, windowHeight = love.window.getDesktopDimensions()

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})




function love.load()
  https = runtimeLoader.loadHTTPS()
  -- Your game load here
  player:load()


  overlayStats.load() -- Should always be called last
end

function love.draw()
  --push:start()
  -- Your game draw here
  player:draw()
  local transform = player:getComponent("Transform")
  love.graphics.print(tostring(player.id), transform.position.x, transform.position.y)
  overlayStats.draw() -- Should always be called last

  --push:finish()
end

function love.update(dt)
  -- Your game update here
  player:update(dt)


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
