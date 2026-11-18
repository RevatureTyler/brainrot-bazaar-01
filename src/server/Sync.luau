-- Copies each player's public numbers to attributes, and their carried list to their client, after every change.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local State = require(script.Parent.State)
local Economy = require(script.Parent.Economy)
local BaseLock = require(script.Parent.BaseLock)

local Sync = {}

local function carriedLines(record)
	local lines = {}
	for _, entry in record.carried do
		table.insert(lines, string.format("%s (%s) $%d/s", entry.character.name, entry.mutation.name, entry.income))
	end
	return lines
end

function Sync.push(player, record)
	player:SetAttribute("Money", math.floor(record.money))
	player:SetAttribute("PerSecond", math.floor(Economy.perSecond(record) * 10) / 10)
	player:SetAttribute("Rebirths", record.rebirths)
	player:SetAttribute("UpgradeLevel", record.upgradeLevel)
	player:SetAttribute("LockSeconds", BaseLock.secondsLeft(record))
	Remotes.get("Carried"):FireClient(player, carriedLines(record))
end

function Sync.start()
	State.changed:Connect(function(player)
		local record = State.get(player)
		if record ~= nil then
			Sync.push(player, record)
		end
	end)
end

return Sync
