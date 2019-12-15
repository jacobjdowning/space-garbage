local AnimSprite = require("sprites.AnimSprite")

local Truck = {
	player = 1,
	cameFrom = 0,
	q = 0,
	r = 0,
	hexGrid = nil,
}

Truck.__index = Truck

setmetatable(Truck, {
	__index = AnimSprite,
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


function Truck.new(anims, q, r, hexGrid)
	local x,y = hexGrid.CoordsToPixels(q,r)
	local self = setmetatable(AnimSprite.new(anims, 0, 0, 'up', false), Truck)
	self.q, self.r = q, r
	x = x + hexGrid.hexWidth/2
	y = y + hexGrid.hexHeight/2
	self.hexGrid = hexGrid
	self:setPos(x,y)
	self.centerAnchor = true
	return self
end

function Truck:setQR(q, r)
	local x,y = hexGrid.CoordsToPixels(q,r)
	x = x + hexGrid.hexWidth/2
	y = y + hexGrid.hexHeight/2
	self:setPos(x,y)
end

function Truck:advance(grid)
	currentTile = grid[self.q][self.r]['tile']
	sides = {math.floor(currentTile/10.0), currentTile%10}
	for i,side in ipairs(sides) do
		if side ~= self.cameFrom then
			local q,r = self.q + direction[side]['q'], self.r + direction[side]['r'] 
			local x,y = hexGrid.CoordsToPixels(q,r)
			x = x + hexGrid.hexWidth/2
			y = y + hexGrid.hexHeight/2
			self.q, self.r = q, r
			self.cameFrom = Truck.opSide(side)
			self:setPos(x, y)
			return
		end
	end	
end

function Truck.opSide(side)
	nextSide = (side + 3) % 6
	if nextSide == 0 then nextSide = 6 end
	return nextSide
end

return Truck