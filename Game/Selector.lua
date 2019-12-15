local Sprite = require("sprites.Sprite")

local Selector = {
	pos = {q = 5, r = 5},
	hexGrid = nil,
	hide = false,
	color = {},
}

Selector.__index = Selector

setmetatable(Selector, {
	__index = Sprite,
	__call = function(cls, ...)
				return cls.new(...)
			 end
})

local direction = {
	{q = -1, r = 0},
	{q = -1, r = 1},
	{q = 0, r = 1},
	{q = 1, r = 0},
	{q = 1, r = -1},
	{q = 0, r = -1}
}

function Selector.new(quad, hexGrid, q, r, color)
	self = setmetatable(Sprite.new(quad, 0, 0), Selector)
	if q ~= nil then self.pos.q = q end
	if r ~= nil then self.pos.r = r end
	local x,y = hexGrid.CoordsToPixels(self.pos.q,self.pos.r)
	self:setPos(x,y)
	self.oy = 2
	self.color = color
	return self
end

function Selector:draw(batch)
	batch:setColor(unpack(self.color))
	Sprite.draw(self, batch)
	batch:setColor(1,1,1,1)
end

function Selector:move(directionIndex)
	self.pos.q = self.pos.q + direction[directionIndex]['q']
	self.pos.r = self.pos.r + direction[directionIndex]['r']
	local x,y = hexGrid.CoordsToPixels(self.pos.q,self.pos.r)
	self:setPos(x,y)
end

function Selector:getPos()
	return self.pos
end

return Selector