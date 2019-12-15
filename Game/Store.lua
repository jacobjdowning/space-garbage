local Store = {
	tiles = {},
	x = 0,
	y = 0,
	currentTiles = {},
	image = nil,
	selectedTiles = {},
	bg = nil,
	center = nil,
	playercolors = {},
}
Store.__index = Store

setmetatable(Store, {
	__call = function(cls, ...)
				return cls.new(...)
			 end
})

function Store.new(image, map, bg, center, playercolors)
	local self = setmetatable({}, Store)
	local winWidth = love.graphics.getWidth()
	local _,_,imgWidth, _ = image:getViewport()
	winWidth = 1920
	self.x = winWidth/2 - imgWidth/2
	self.image = image
	self.tiles = map.tiles
	self.tileNames = map.tileNames
	self.bg = bg
	self.center = center
	self.playercolors = playercolors
	return self
end

function Store:draw(batch)
	if self.selectedTiles[1] ~= nil then
		local x, y = 200, 150
		batch:setColor(unpack(self.playercolors[1]))
		batch:add(self.tiles[self.selectedTiles[1]], 200, 150)
		batch:setColor(1,1,1,1)
		batch:add(self.bg, x,y)
		batch:add(self.center, x, y, 0, 1, 1, -44, -25)
	end
	batch:add(self.image, self.x, self.y)
	local _,_,imgWidth, _ = self.image:getViewport()
	for i=1,#self.currentTiles do
		if self.currentTiles[i] ~= nil then
			local x, y = self.x + (i-1) * imgWidth/4 + 11, self.y + 15
			batch:add(self.tiles[self.currentTiles[i]], x,y)
			batch:add(self.bg, x,y)
			batch:add(self.center, x, y, 0, 1, 1, -44, -25)
		end
	end
end

function Store:fill()
	self.currentTiles = {}
	for i=1,4 do
		table.insert(self.currentTiles, self.tileNames[love.math.random(#self.tileNames)])
	end
end

function Store:select(index)
	if self.selectedTiles[1] ~= nil then return end
	self.selectedTiles[1] = self.currentTiles[index]
	self.currentTiles[index] = nil
end

return Store