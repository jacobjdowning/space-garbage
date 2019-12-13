Sprite = require("sprites.Sprite")
SimpleUtils = require("libs.SimpleUtils")

local AnimSprite = {
	anims = nil,
	animDuration = 1,
	animCurrentTime = 0,
	currentAnim = nil,
	loop = true,
}
AnimSprite.__index = AnimSprite

setmetatable(AnimSprite, {
	__index = Sprite,
	__call = function(cls, ...)
				return cls.new(...)
			 end
})

function AnimSprite.new(anims, x, y, currentAnim, loop)
	local self = setmetatable({}, AnimSprite)
	if loop ~= nil then self.loop = loop end
	self.anims = anims
	self.currentAnim = currentAnim
	self.x = x
	self.y = y
	self.quad = anims[self.currentAnim].frames[1]
	_, _, self.w, self.h = self.quad:getViewport()
	return self
end

function AnimSprite:setCurrentTime(t)
	self.animCurrentTime = t
end

function AnimSprite:setCurrentAnim(state)
	self:setCurrentTime(0)
	self.currentAnim = state
end

function AnimSprite:update(dt)
	Sprite.update(self, dt)
	self.animCurrentTime = self.animCurrentTime + dt
	local duration = self.anims[self.currentAnim].duration
	if self.animCurrentTime > duration then
		if self.loop == true then
			self.animCurrentTime = self.animCurrentTime - duration
		else
			self.animCurrentTime = duration * (1 - 1/#self.anims[self.currentAnim].frames)
		end
	end
	local frameIndex = math.floor(self.animCurrentTime / duration * #self.anims[self.currentAnim].frames) + 1
	self.quad = self.anims[self.currentAnim].frames[frameIndex]
	_, _, self.w, self.h = self.quad:getViewport()
end

function AnimSprite.buildAnims(quads, storedAnims)
	local anims = SimpleUtils.deepcopy(storedAnims)
	for _, anim in pairs(anims) do
		for i, frame in ipairs(anim.frames) do
			anim.frames[i] = quads[frame]
		end
	end
	return anims
end

return AnimSprite