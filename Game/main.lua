local loadAtlas = require "loaders.LoadAtlas"
local anims = require "assets.anims"
local Store = require "Store"
local Truck = require "Truck"
local hexGrid = require "hexGrid"
local Selector = require "Selector"
local map = require "map"
local store = nil
local selectedTile = nil
local truck = nil

function love.load()
	batch, quads = loadAtlas('assets/sheet.xml')

	map.set(quads, hexGrid)

	store = Store(quads['UI/store.png'], map)

	hex = quads["Tiles/IsoEmpty.png"]
	hexGrid.set(hex)

	truck = Truck(Truck.buildAnims(quads, anims['truck']), 5, 5, hexGrid)

	map.load(1, {truck})

	selector = Selector(quads['Sprites/Selector.png'], hexGrid) -- center this**

	love.graphics.setBackgroundColor(0, 1, 1, 1)
	local success = love.window.setMode(1920, 1020)

	font = love.graphics.newFont('assets/UniversCondensed.ttf', 16)
	text = love.graphics.newText(font, "")

	map.roundCorners(10, 10, 5, 15)

	store:fill()
end

function love.draw()
	batch:clear()
		-- Draw here
		store:draw(batch)
		map.draw(batch)
		selector:draw(batch)
		truck:draw(batch)
	love.graphics.draw(batch)
end

function love.update(dt)
	truck:update(dt)
end

function love.keypressed(key, code, isRepeat)
	if 	   key == 'up'		then selector:move(1)
	elseif key == 'down' 	then selector:move(4)
	elseif key == 'right' 	then selector:move(3)
	elseif key == 'left' 	then selector:move(6)
	elseif key == 'space' 	then place(1, selector, store)
	elseif key == 'escape'  then love.event.push('quit')
	elseif key == 'f' 		then store:fill()
	elseif key == '7' 		then selectedTile = store:select(1)
	elseif key == '8' 		then selectedTile = store:select(2)
	elseif key == '9' 		then selectedTile = store:select(3)
	elseif key == '0' 		then selectedTile = store:select(4)
	elseif key == 'm' 		then truck:advance(map.grid)
	end
end

function place(player, selector, store)
	local selectorLoc = selector:getPos()
	if map.grid[selectorLoc['q']] == nil then map.grid[selectorLoc['q']] = {} end
	if map.grid[selectorLoc['q']][selectorLoc['r']] ~= nil then return end
	if store.selectedTiles[player] ~= nil then
		map.grid[selectorLoc['q']][selectorLoc['r']] = {player = 1, tile = store.selectedTiles[player]}
		store.selectedTiles[player] = nil
	end
end
