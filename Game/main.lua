local loadAtlas = require "loaders.LoadAtlas"
local Sprite = require "sprites.Sprite"
local anims = require "assets.anims"
local hexUnits
local grid = {}
local selectorLoc ={q = 5, r = 5} 

function love.load()
	hex = love.graphics.newImage('assets/IsoHex.png')
	selector = love.graphics.newImage('assets/Selector2.png')
	love.graphics.setBackgroundColor(0, 1, 1, 1)
	local success = love.window.setMode(1920, 1020)
	hexWidth, hexHeight = hex:getDimensions()
	hexWidth, hexHeight = hexWidth + 8, hexHeight + 8
	hexUnits = {q = {0, hexHeight},
				r = {hexWidth*3/4, hexHeight/2}}
	font = love.graphics.newFont('assets/UniversCondensed.ttf', 16)
	text = love.graphics.newText(font, "")
	roundCorners(grid, 10, 10, 0)
end

function love.draw()
	for q=0,10 do
		for r=0,10 do
			if grid[q] == nil or grid[q][r] ~= 'hidden' then
				text:set({{0,0,0,1},"" .. q .. "," .. r})
				local x = q * hexUnits['q'][1] + r * hexUnits['r'][1] + 410
				local y = q * hexUnits['q'][2] + r * hexUnits['r'][2] + -50
				love.graphics.draw(hex, x, y)
				love.graphics.draw(text, x + hexWidth/2, y + hexHeight/2)
				-- love.graphics.draw(hex, 
				-- 		q * hexUnits['q'][1] + r * hexUnits['r'][1] + 0,
				-- 		q * hexUnits['q'][2] + r * hexUnits['r'][2] + 0)
			end
		end
	end
	local sx = selectorLoc['q'] * hexUnits['q'][1] + selectorLoc['r'] * hexUnits['r'][1] + 410
	local sy = selectorLoc['q'] * hexUnits['q'][2] + selectorLoc['r'] * hexUnits['r'][2] + -50
	love.graphics.draw(selector, sx, sy)		

	-- batch:clear()
	-- 	-- Draw here
	-- love.graphics.draw(batch)
end

function love.update(dt)
end

function love.keypressed(key, code, isRepeat)
	if 	   key == 'up' then selectorLoc['q'] = selectorLoc['q'] - 1
	elseif key == 'down' then selectorLoc['q'] = selectorLoc['q'] + 1
	elseif key == 'right' then selectorLoc['r'] = selectorLoc['r'] + 1
	elseif key == 'left' then selectorLoc['r'] = selectorLoc['r'] - 1
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