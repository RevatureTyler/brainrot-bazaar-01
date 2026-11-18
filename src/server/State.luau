-- The one place player state lives. Server only. Each change stores a new record; a record is never edited in place.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)

local State = {}

local records = {}
local changedEvent = Instance.new("BindableEvent")
State.changed = changedEvent.Event

local function freshRecord()
	return {
		money = Config.START_MONEY,
		rebirths = 0,
		upgradeLevel = 0,
		lockUntil = 0,
		carried = {},
		placed = {},
	}
end

function State.create(player)
	records[player] = freshRecord()
	changedEvent:Fire(player)
end

function State.remove(player)
	records[player] = nil
end

function State.get(player)
	return records[player]
end

-- Merges the given fields into the player's record and announces the change.
function State.update(player, changes)
	local current = records[player]
	if current == nil then
		return nil
	end
	local nextRecord = table.clone(current)
	for key, value in changes do
		nextRecord[key] = value
	end
	records[player] = nextRecord
	changedEvent:Fire(player)
	return nextRecord
end

function State.players()
	local list = {}
	for player in records do
		table.insert(list, player)
	end
	return list
end

return State
