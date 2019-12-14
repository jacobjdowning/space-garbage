local loadAtlas = require "loaders.LoadAtlas"
local Sprite = require "sprites.Sprite"
local anims = require "assets.anims"

function love.load()
	hex = love.graphics.newImage('assets/hex.png', format)
	love.graphics.setBackgroundColor(0, 1, 1, 1)
	local success = love.window.setMode(1920, 1020)
	hexWidth, hexHeight = hex:getDimensions() 
end

function love.draw()
	for l=0,1 do
		for j=0,5 do
			for i=0,9 do
				love.graphics.draw(hex,
					-- hexWidth*3/4
					l*(29*3)+100+(i*hexWidth*1.5),
					l*(hexHeight/2) +200 + j * hexHeight)
			end
		end
	end 
	-- batch:clear()
	-- 	-- Draw here
	-- love.graphics.draw(batch)
end

function love.update(dt)
end

