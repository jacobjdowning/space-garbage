local Store = {
	tiles = {},
	x = 0,
	y = 0,
	currentTiles = {},
	image = nil,
}
Store.__index = Store

setmetatable(Store, {
	__call = function(cls, ...)
				return cls.new(...)
			 end
})

local tileNames = {42, 46, 51, 53}

function Store.new(image, tiles)
	local self = setmetatable({}, Store)
	local winWidth = love.graphics.getWidth()
	local imgWidth, _ = image:getDimensions()
	winWidth = 1920
	self.x = winWidth/2 - imgWidth/2
	self.image = image
	self.tiles = tiles
	return self
end

function Store:draw(batch)
	love.graphics.draw(self.image, self.x, self.y)
	local imgWidth, _ = self.image:getDimensions()
	for i=1,#self.currentTiles do
		if self.currentTiles[i] ~= nil then
			love.graphics.draw(self.tiles[self.currentTiles[i]], self.x + (i-1) * imgWidth/4, self.y)
		end
	end
end

function Store:fill()
	self.currentTiles = {}
	for i=1,4 do
		table.insert(self.currentTiles, tileNames[love.math.random(#tileNames)])
	end
end

function Store:select(index)
	local picked = self.currentTiles[index]
	self.currentTiles[index] = nil
	return picked
end

return Store