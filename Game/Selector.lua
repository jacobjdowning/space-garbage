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

function Selector:canPlace(placing, grid)
	local placeSides = {math.floor(placing/10.0), placing%10}
	for i, dir in ipairs(direction) do

		local isPlacedDir = (i == placeSides[1]) or (i == placeSides[2])

		if grid[self.pos.q+dir['q']] == nil then
			return false
		end
		
		local nextTile = grid[self.pos.q+dir['q']][self.pos.r+dir['r']]
	 	
		if nextTile == "hide" or nextTile == "nogo" then
			if isPlacedDir then
				return false
			end
		end


		if nextTile ~= nil and type(nextTile.tile) == 'number' then
			local nextTileSides = {math.floor(nextTile.tile/10.0), nextTile.tile%10}
			local nextHasOpposite = nextTileSides[1] == opSide(i) or nextTileSides[2] == opSide(i)
			if isPlacedDir ~= nextHasOpposite then --Used as xor
				return false
			end
		end
	end
	return true
end

function opSide(side)
	nextSide = (side + 3) % 6
	if nextSide == 0 then nextSide = 6 end
	return nextSide
end

function Selector:getPos()
	return self.pos
end

return Selector