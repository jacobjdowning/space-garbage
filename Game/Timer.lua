local Sprite = require("sprites.Sprite")

local Timer = {
	time = 0,
	handQuad = nil,
	faceQuad = nil,
	w = 0,
	h = 0,
	speed = 10,
	handWidth = 0,
	handHeight = 0
}

Timer.__index = Timer

setmetatable(Timer,{
	__call = function(cls, ...)
				return cls.new(...)
			end
	})

function Timer.new(handQuad, faceQuad, x, y)
	local self = setmetatable({}, Timer)
	self.handQuad = handQuad
	self.faceQuad = faceQuad
	self.x = x
	self.y = y
	_,_, self.w, self.h = self.faceQuad:getViewport()
	_,_, self.handWidth, self.handHeight = self.handQuad:getViewport()
	return self
end


function Timer:update(dt)
	self.time = self.time + dt * self.speed
end

function Timer:draw(spriteBatch)
	spriteBatch:add(self.faceQuad, self.x, self.y)
	spriteBatch:add(self.handQuad, self.x + self.w/2.0, self.y + self.h/2.0, self.time, 1, 1, self.handWidth/2.0, self.handHeight/2.0)
end

return Timer