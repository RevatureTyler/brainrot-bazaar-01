-- Steal and take-back for placed brainrots. Stealing needs a hold on the target and an unlocked owner base.
-- Taking back your own brainrot needs no hold check beyond the prompt itself and skips the lock.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local State = require(script.Parent.State)
local BaseLock = require(script.Parent.BaseLock)
local Notify = require(script.Parent.Notify)
local Prompts = require(script.Parent.Prompts)

local Stealing = {}

local function removePlaced(owner, entryId)
	local ownerRecord = State.get(owner)
	local remaining = {}
	local found = nil
	for _, entry in ownerRecord.placed do
		if entry.id == entryId then
			found = entry
		else
			table.insert(remaining, entry)
		end
	end
	if found ~= nil then
		State.update(owner, { placed = remaining })
	end
	return found
end

-- Moves one placed brainrot from its owner to the taker's carried list.
local function transfer(taker, owner, model)
	local entryId = model:GetAttribute("EntryId")
	local ownerRecord = State.get(owner)
	local target = nil
	for _, entry in ownerRecord.placed do
		if entry.id == entryId then
			target = entry
		end
	end
	if target == nil then
		return
	end

	removePlaced(owner, entryId)
	target.slot:SetAttribute("Occupied", nil)
	model:Destroy()

	local takerRecord = State.get(taker)
	local carried = table.clone(takerRecord.carried)
	table.insert(carried, { id = target.id, character = target.character, mutation = target.mutation, income = target.income })
	State.update(taker, { carried = carried })

	if taker == owner then
		Notify.send(taker, string.format("Took back %s.", target.character.name))
	else
		Notify.send(taker, string.format("Stole %s from %s!", target.character.name, owner.Name))
		Notify.send(owner, string.format("%s stole %s!", taker.Name, target.character.name))
	end
end

local function attempt(taker, model)
	local owner = Players:GetPlayerByUserId(model:GetAttribute("OwnerId") or 0)
	if owner == nil then
		return
	end
	if owner == taker then
		transfer(taker, owner, model)
		return
	end
	local ownerRecord = State.get(owner)
	if ownerRecord ~= nil and BaseLock.isLocked(ownerRecord) then
		Notify.send(taker, string.format("%s's base is locked.", owner.Name))
		return
	end
	transfer(taker, owner, model)
end

function Stealing.attach(model)
	local prompt = Prompts.attach(model.PrimaryPart, "Steal / take back", model.Name, Config.STEAL_HOLD_SECONDS)
	prompt.Triggered:Connect(function(taker)
		attempt(taker, model)
	end)
end

return Stealing
