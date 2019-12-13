local loadAtlas = require "loaders.LoadAtlas"
local AnimSprite = require "sprites.AnimSprite"
local anims = require "assets.anims"

function love.load()

end

function love.draw()
	batch:clear()
		-- Draw here
	love.graphics.draw(batch)
end

function love.update(dt)
end

