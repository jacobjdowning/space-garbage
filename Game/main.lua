local loadAtlas = require "loaders.LoadAtlas"
local anims = require "assets.anims"
local Store = require "Store"
local Truck = require "Truck"
local hexGrid = require "hexGrid"
local Selector = require "Selector"
local Timer = require "Timer"
local map = require "map"
local store = nil
local timer = nil
local selectedTile = nil
local trucks = {}
local selectors = {}
local score = 0
local playerColors = {{1,0,1,1}, {0,0,1,1}}

function love.load()
	batch, quads = loadAtlas('assets/sheet.xml')

	map.set(quads, hexGrid, playerColors)

	store = Store(quads['Sprites/Shop.png'], map, quads['Tiles/IsoEmpty.png'], quads['Tiles/Center.png'], playerColors)

	hex = quads["Tiles/IsoEmpty.png"]
	hexGrid.set(hex)

	trucks[1] = Truck(Truck.buildAnims(quads, anims['truckp']), 5, 5, hexGrid)	
	trucks[2] = Truck(Truck.buildAnims(quads, anims['truckb']), 5, 5, hexGrid)

	map.load(1, trucks)

	selectors[1] = Selector(quads['Sprites/Selector.png'], hexGrid, 5, 5, playerColors[1], 1)
	selectors[2] = Selector(quads['Sprites/Selector.png'], hexGrid, 5, 5, playerColors[2], 2)


	timer = Timer(quads['Sprites/TimerHand.png'], quads['Sprites/Timer.png'], 20, 20)

	love.graphics.setBackgroundColor(0, 0, 0, 1)
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
		if(selectors[1]:getPos().q == selectors[2]:getPos().q and 
			selectors[1]:getPos().r == selectors[2]:getPos().r) then
			selectors[1]:drawColor(batch, {0, 1, 0})
		else
			for i,v in ipairs(selectors) do
				v:draw(batch)			
			end
		end

		timer:draw(batch)
		for i,v in ipairs(trucks) do
			v:draw(batch)
		end
	love.graphics.draw(batch)
end

function love.update(dt)
	timer:update(dt)
	if timer.time == 0  and timer.enabled then
		step()
	end
	for i,v in ipairs(trucks) do
		v:update(dt)
	end
end

function love.keypressed(key, code, isRepeat)
	if 	   key == 'up'		then selectors[1]:move(1)
	elseif key == 'down' 	then selectors[1]:move(4)
	elseif key == 'right' 	then selectors[1]:move(3)
	elseif key == 'left' 	then selectors[1]:move(6)
	elseif key == 'space' 	then place(1, selectors[1], store)
	elseif key == 'escape'  then love.event.push('quit')
	elseif key == 'f' 		then store:fill()
	elseif key == '7' 		then selectedTile = store:select(1, 1)
	elseif key == '8' 		then selectedTile = store:select(2, 1)
	elseif key == '9' 		then selectedTile = store:select(3, 1)
	elseif key == '0' 		then selectedTile = store:select(4, 1)
	elseif key == '1' 		then selectedTile = store:select(1, 2)
	elseif key == '2' 		then selectedTile = store:select(2, 2)
	elseif key == '3' 		then selectedTile = store:select(3, 2)
	elseif key == '4' 		then selectedTile = store:select(4, 2)
	elseif key == 'm' 		then step()
	elseif key == 'w'		then selectors[2]:move(1)
	elseif key == 's'		then selectors[2]:move(4)
	elseif key == 'd'		then selectors[2]:move(3)
	elseif key == 'a'		then selectors[2]:move(6)
	elseif key == 'z'		then place(2, selectors[2], store)
	end
end

function step()
	local result
	for i,iTruck in ipairs(trucks) do
		iTruck:advance(map.grid)
		result = map.check(iTruck)
		if result == 'canister' then
			score = score + 1
		elseif result == 'finish' then
			iTruck.hide = true
		elseif result == 'loss' then
			-- LOSS
			print("Loss")
			timer.enabled = false
		end
	end
	if checkForWin() then print("WIN!") end
end

function checkForWin()
	local bothTrucksOut = true
	for i,v in ipairs(trucks) do
		bothTrucksOut = bothTrucksOut and v.hide
	end
	return bothTrucksOut and score >= #map.canisters
end

function place(player, selector, store)
	local selectorLoc = selector:getPos()
	if map.grid[selectorLoc['q']] == nil then map.grid[selectorLoc['q']] = {} end
	if map.grid[selectorLoc['q']][selectorLoc['r']] ~= nil then return end
	if store.selectedTiles[player] ~= nil and selector:canPlace(store.selectedTiles[player], map.grid) then
		map.grid[selectorLoc['q']][selectorLoc['r']] = {player = player, tile = store.selectedTiles[player]}
		store.selectedTiles[player] = nil
	end
end
