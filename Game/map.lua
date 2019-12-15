local map = {
	grid = {},
	tiles = {},
	tileNames = {21, 31, 32, 41, 42, 43, 51, 52, 53, 54, 61, 62, 63, 64},
	hexGrid = nil,
}

function map.load(quads, hexGrid)
	for i=1,#map.tileNames do
		map.tiles[map.tileNames[i]] = quads['Tiles/'..map.tileNames[i]..'.png']
	end
	map.hexGrid = hexGrid
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
			if map.grid[q] ~=nil and type(map.grid[q][r]) == 'table' then
				batch:add(map.tiles[map.grid[q][r]['tile']], x, y)
			end
		end
	end
end

return map