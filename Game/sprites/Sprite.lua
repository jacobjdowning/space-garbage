local Sprite  = {
	x = 0,
	y = 0,
	quad = nil,
	vx = 0,
	vy = 0,
	centerAnchor = false,
	w = 0,
	h = 0,
}
Sprite.__index = Sprite

setmetatable(Sprite, {
	__call = function(cls, ...)
				return cls.new(...)
			 end
})

function Sprite.new(quad, x, y)
	local self = setmetatable({}, Sprite)
	self.quad = quad
	self.x = x
	self.y = y
	_, _, self.w, self.h = self.quad:getViewport()
	return self
end

function Sprite:setV(x, y)
	self.vx = x
	self.vy = y
end

function Sprite:setPos(x, y)
	self.x = x
	self.y = y
end

function Sprite:update(dt)
	self.x = dt*self.vx + self.x
	self.y = dt*self.vy + self.y
end

function Sprite:draw(spriteBatch)
	-- anchored at center
	local ox, oy = 0, 0
	if self.centerAnchor then
	    ox, oy = self.w/2.0, self.h/2.0
	end
	spriteBatch:add(self.quad, self.x, self.y, 0, 1, 1, ox, oy)
end

return Sprite