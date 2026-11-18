-- Hands out bases (one per player) and answers who owns which base and whether a position is home.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)

local BaseService = {}

local bases = {}
local ownerByIndex = {}

function BaseService.init(list)
	bases = list
end

function BaseService.list()
	return bases
end

function BaseService.claim(player)
	for _, base in bases do
		if ownerByIndex[base.index] == nil then
			ownerByIndex[base.index] = player
			base.model:SetAttribute("OwnerId", player.UserId)
			return base
		end
	end
	return nil
end

function BaseService.release(player)
	for _, base in bases do
		if ownerByIndex[base.index] == player then
			ownerByIndex[base.index] = nil
			base.model:SetAttribute("OwnerId", nil)
			return
		end
	end
end

function BaseService.baseOf(player)
	for _, base in bases do
		if ownerByIndex[base.index] == player then
			return base
		end
	end
	return nil
end

function BaseService.ownerOf(base)
	return ownerByIndex[base.index]
end

-- True when a position sits within the player's own base radius (measured flat, ignoring height).
function BaseService.isHome(player, position)
	local base = BaseService.baseOf(player)
	if base == nil then
		return false
	end
	local offset = Vector3.new(position.X - base.center.X, 0, position.Z - base.center.Z)
	return offset.Magnitude <= Config.BASE_RADIUS
end

return BaseService
