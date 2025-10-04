https = nil
ENTITY_ID = 0
local love = require "love"
local initLuis = require("luis.init")
local luis = initLuis("luis/widgets")
luis.flux = require("luis.3rdparty.flux")
local overlayStats = require("lib.overlayStats")
local runtimeLoader = require("runtime.loader")
local push = require("lib.push") ---For resolution handling
local Player = require "player"
local Enemy = require "enemy"
local player = Player()

local EntityContainer = require "entityContainer"
local enemyContainer = EntityContainer()
for i=1,10 do
  local enemy = Enemy(player, math.random(0,1920), math.random(0,1080))
  enemyContainer:addEntity(enemy)
end
local gameWidth, gameHeight = 1920, 1080
local windowWidth, windowHeight = love.window.getDesktopDimensions()

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})




function love.load()
  https = runtimeLoader.loadHTTPS()
  -- Your game load here
  player:load()
  for k, v in pairs(enemyContainer.container) do
    v:load()
  end
  player:getComponent("Transform").position.x = gameWidth/2
  player:getComponent("Transform").position.y = gameHeight/2

  local progressBar = {
    backgroundColor = {0.15, 0.15, 0.15, 1},
    fillColor = {1.0, 0.2, 0.2, 1},
    borderColor = {1, 1, 1, 1},
  }

  local testBar = luis.newProgressBar(1, 10, 1, 2, 2, progressBar)

  player:getComponent("HealthComponent").onDamage = function ()
    local hp = player:getComponent("HealthComponent")
    local value = hp:getCurrentHealth() / hp:getMaxHealth()
    testBar:setValue(value)
  end

  luis.newLayer("main")
  luis.setCurrentLayer("main")
  luis.insertElement("main", testBar)



  overlayStats.load() -- Should always be called last
end

function love.draw()
  push:start()
  -- Your game draw here
  player:draw()
  for k, v in pairs(enemyContainer.container) do
    v:draw()
  end

  luis.draw()
  overlayStats.draw() -- Should always be called last

  push:finish()
end

local time = 0
function love.update(dt)
  time = time + dt
  if time >= 1/60 then
		luis.flux.update(time)
		time = 0
	end

  luis.update(dt)
  -- Your game update here
  player:update(dt)
  for k, v in pairs(enemyContainer.container) do
    v:update(dt)
  end

  overlayStats.update(dt) -- Should always be called last
end

function love.keypressed(key)

  if key == "escape" then
    if luis.currentLayer == "main" then
      love.event.quit()
    end
  elseif key == "m" then
    player:getComponent("HealthComponent"):decreaseHealth(10)
  elseif key == "tab" then -- Debug View
    luis.showGrid = not luis.showGrid
    luis.showLayerNames = not luis.showLayerNames
    luis.showElementOutlines = not luis.showElementOutlines
  else
    luis.keypressed(key)
    overlayStats.handleKeyboard(key) -- Should always be called last
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  overlayStats.handleTouch(id, x, y, dx, dy, pressure) -- Should always be called last
end

function love.mousepressed(x, y, button, istouch)
  luis.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
  luis.mousereleased(x, y, button, istouch)
end

