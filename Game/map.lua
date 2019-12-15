local levels = require "levels"
local map = {
	grid = {},
	tiles = {},
	tileNames = {21, 31, 32, 41, 42, 43, 51, 52, 53, 54, 61, 62, 63, 64},
	hexGrid = nil,
	canisters = {},
	nogoQuad = nil,
	canisterQuad = nil,
	finishQuad = nil
}

function map.set(quads, hexGrid)
	for i=1,#map.tileNames do
		map.tiles[map.tileNames[i]] = quads['Tiles/'..map.tileNames[i]..'.png']
	end
	for i=1, 6 do
		map.tiles[i] = quads['Tiles/S'..i..'.png']
	end
	map.hexGrid = hexGrid
	map.nogoQuad = quads['Sprites/Pop.png']
	map.canisterQuad = quads['Tiles/Garbage.png']
	map.finishQuad = quads['Tiles/Dump.png'] 
end

function map.load(levelIndex, trucks)
	local level = levels[levelIndex]
	map.grid = {}
	for i,nogo in ipairs(level.nogo) do
		if map.grid[nogo.q] == nil then map.grid[nogo.q] = {} end
		map.grid[nogo.q][nogo.r] = 'nogo' -- random others or defined in level
	end
	for i,start in ipairs(level.starters) do
		if map.grid[start.q] == nil then map.grid[start.q] = {} end
		map.grid[start.q][start.r] = {player = i, tile = start.s}
		trucks[i]:setQR(start.q, start.r)
	end

	map.canisters = level.canisters
	
	if map.grid[level.finish.q] == nil then map.grid[level.finish.q] = {} end
	map.grid[level.finish.q][level.finish.r] = 'finish'
end

function map.roundCorners(rows, columns, left, right)
	for i=0, rows do
		for j=0, columns do
			if i+j < left or i+j > right then
				if map.grid[i] == nil then map.grid[i]={} end
			    map.grid[i][j] = 'hidden'
			end
		end
	end
end

function map.check(truck)
	local tq, tr = truck:getQR()
	for i,canister in ipairs(map.canisters) do
		if canister.q == tq and canister.r == tr then
		    table.remove(map.canisters, i)
		    return "canister"
		end
	end
	if map.grid[tq] == nil or map.grid[tq][tr] == nil then return "loss" end
	if map.grid[tq][tr] == 'finish' then return 'finish' end
	return 'path'
end

function map.draw(batch)
	for q=0,10 do
		for r=0,10 do
			local x, y = map.hexGrid.CoordsToPixels(q,r)
			if map.grid[q] == nil or map.grid[q][r] ~= 'hidden' then
				text:set({{0,0,0,1},"" .. q .. "," .. r})
				batch:add(hex, x, y)
				love.graphics.draw(text, 
					x + map.hexGrid.hexWidth/2, 
					y + map.hexGrid.hexHeight/2)
			end
			if map.grid[q] ~=nil then 
				if type(map.grid[q][r]) == 'table' then
					batch:add(map.tiles[map.grid[q][r]['tile']], x, y)
				elseif map.grid[q][r] == 'nogo' then
					batch:add(map.nogoQuad, x, y)
				elseif map.grid[q][r] == 'finish' then
					batch:add(map.finishQuad, x, y, 0, 1, 1, 0, 6)
				end
			end
		end
	end
	for i,canister in ipairs(map.canisters) do
		local x,y = map.hexGrid.CoordsToPixels(canister.q, canister.r)
		batch:add(map.canisterQuad, x, y, 0, 1, 1, 0, 34)
	end
end

return map