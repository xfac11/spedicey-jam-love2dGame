local Component = require "component"
local Timer = Component:extend()

function Timer:new(parent, timeInSeconds)
  Timer.super.new(self, parent)
  self.time = timeInSeconds
  self.currentTime = timeInSeconds
  self.started = false
  self.oneTime = false
  self.onTime = function () end
end

function Timer:start()
  self.started = true
end

function Timer:pause()
  self.started = false
end

function Timer:stop()
  self.started = false
  self.currentTime = self.time
end

function Timer:update(dt)
  if self.started then
    self.currentTime = self.currentTime - dt
    if self.currentTime < 0 then
      self.currentTime = self.time
      self.onTime()
      if self.oneTime then
        self.started = false
      end
    end
  end
end

return Timer
