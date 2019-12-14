local loadAtlas = require "loaders.LoadAtlas"
local Sprite = require "sprites.Sprite"
local anims = require "assets.anims"

function love.load()
	hex = love.graphics.newImage('assets/41.png', format)
	love.graphics.setBackgroundColor(1, 1, 1, 1)
end

function love.draw()
	love.graphics.draw(hex, 100, 100)
	-- batch:clear()
	-- 	-- Draw here
	-- love.graphics.draw(batch)
end

function love.update(dt)
end

