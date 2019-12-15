local loadAtlas = require "loaders.LoadAtlas"
local anims = require "assets.anims"
local Store = require "Store"
local Truck = require "Truck"
local hexGrid = require "hexGrid"
local hexUnits
local grid = {}
local selectorLoc = {q = 5, r = 5} 
local tiles = {}
local store = nil
local selectedTile = nil
local truck = nil

function love.load()
	batch, quads = loadAtlas('assets/sheet.xml')

	tiles[42] = love.graphics.newImage('assets/42.png')
	tiles[46] = love.graphics.newImage('assets/46.png')
	tiles[51] = love.graphics.newImage('assets/51.png')
	tiles[53] = love.graphics.newImage('assets/53.png')

	store = Store(love.graphics.newImage('assets/Store.png'), tiles)

	hex = love.graphics.newImage('assets/IsoHex.png')
	hexGrid.set(hex)

	truck = Truck(Truck.buildAnims(quads, anims['truck']), 5, 5, hexGrid)

	selector = love.graphics.newImage('assets/Selector2.png')

	love.graphics.setBackgroundColor(0, 1, 1, 1)
	local success = love.window.setMode(1920, 1020)

	font = love.graphics.newFont('assets/UniversCondensed.ttf', 16)
	text = love.graphics.newText(font, "")

	roundCorners(grid, 10, 10, 0)

	store:fill()
end

function love.draw()
	for q=0,10 do
		for r=0,10 do
			local x, y = hexGrid.CoordsToPixels(q,r)
			if grid[q] == nil or grid[q][r] ~= 'hidden' then
				text:set({{0,0,0,1},"" .. q .. "," .. r})
				love.graphics.draw(hex, x, y)
				love.graphics.draw(text, x + hexGrid.hexWidth/2, y + hexGrid.hexHeight/2)
			end
			if grid[q] ~=nil and type(grid[q][r]) == 'table' then
				love.graphics.draw(tiles[grid[q][r]['tile']], x, y)
			end
		end
	end
	local sx, sy = hexGrid.CoordsToPixels(selectorLoc['q'], selectorLoc['r'])
	love.graphics.draw(selector, sx, sy)

	store:draw()

	if selectedTile ~= nil then
		love.graphics.draw(tiles[selectedTile], 200, 150)
	end

	batch:clear()
		-- Draw here
		truck:draw(batch)
	love.graphics.draw(batch)
end

function love.update(dt)
	truck:update(dt)
end

function love.keypressed(key, code, isRepeat)
	if 	   key == 'up' then selectorLoc['q'] = selectorLoc['q'] - 1
	elseif key == 'down' then selectorLoc['q'] = selectorLoc['q'] + 1
	elseif key == 'right' then selectorLoc['r'] = selectorLoc['r'] + 1
	elseif key == 'left' then selectorLoc['r'] = selectorLoc['r'] - 1
	elseif key == 'space' then place(1, 42)
	elseif key == 'escape' then love.event.push('quit')
	elseif key == 'f' then store:fill()
	elseif key == '7' then selectedTile = store:select(1)
	elseif key == '8' then selectedTile = store:select(2)
	elseif key == '9' then selectedTile = store:select(3)
	elseif key == '0' then selectedTile = store:select(4)
	elseif key == 'm' then 
		print(grid)
		truck:advance(grid)
	end
end

function place(player)
	if grid[selectorLoc['q']] == nil then grid[selectorLoc['q']] = {} end
	if selectedTile ~= nil then
		print(grid)
		grid[selectorLoc['q']][selectorLoc['r']] = {player = 1, tile = selectedTile}
		selectedTile = nil
		print(grid)
	end
end

function roundCorners(grid, rows, columns, radius)
	for i=0, rows do
		for j=0, columns do
			if i+j < 5 or i+j > 15 then
				if grid[i] == nil then grid[i]={} end
			    grid[i][j] = 'hidden'
			end
		end
	end
end
