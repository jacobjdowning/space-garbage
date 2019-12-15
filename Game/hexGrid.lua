hexGrid = {}

function hexGrid.set(hex)
	local hexWidth, hexHeight = hex:getDimensions()
	hexWidth, hexHeight = hexWidth + 8, hexHeight + 8
	hexGrid.hexWidth, hexGrid.hexHeight = hexWidth, hexHeight
	hexGrid.units = {q = {0, hexHeight},
				r = {hexWidth*3/4, hexHeight/2}}
end

function hexGrid.CoordsToPixels(q, r)
	local x = q * hexGrid.units['q'][1] + r * hexGrid.units['r'][1] + 425
	local y = q * hexGrid.units['q'][2] + r * hexGrid.units['r'][2] + -50
	return x,y			
end

return hexGrid