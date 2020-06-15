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
	local placeable = true
	for i,side in ipairs(placeSides) do
		local nextTileShift = direction[side]
		local nextTile = grid[self.pos.q+nextTileShift['q']][self.pos.r+nextTileShift['r']]
		print("Next Tile: ", nextTile)
		if nextTile ~= nil and type(nextTile.tile) == 'number' then
			print("Checked tile: ", nextTile.tile, " Placed Tile: ", side, " opSide: ", opSide(side))
		    local nextTileSides = {math.floor(nextTile.tile/10.0), nextTile.tile%10}
		    print("TileSides: ", nextTileSides[1], ',', nextTileSides[2])
		    placeable = placeable and (nextTileSides[1] == opSide(side) or nextTileSides[2] == opSide(side))
		end
	end
	return placeable
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