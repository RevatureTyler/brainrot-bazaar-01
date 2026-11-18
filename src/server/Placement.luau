-- Puts a carried brainrot onto an empty slot of the player's own base, and clears placed ones when asked.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local State = require(script.Parent.State)
local BaseService = require(script.Parent.BaseService)
local Brainrot = require(script.Parent.Brainrot)
local Notify = require(script.Parent.Notify)
local Prompts = require(script.Parent.Prompts)
local Stealing = require(script.Parent.Stealing)

local Placement = {}

local SLOT_LIFT = Vector3.new(0, 2.6, 0)

local function place(player, base, slot)
	local record = State.get(player)
	if BaseService.ownerOf(base) ~= player then
		Notify.send(player, "That is not your base.")
		return
	end
	if slot:GetAttribute("Occupied") then
		Notify.send(player, "That slot is taken.")
		return
	end
	if #record.carried == 0 then
		Notify.send(player, "Roll a brainrot at the market first.")
		return
	end

	local entry = record.carried[1]
	local remaining = {}
	for index = 2, #record.carried do
		table.insert(remaining, record.carried[index])
	end

	local model = Brainrot.build(entry)
	model:PivotTo(CFrame.new(slot.Position + SLOT_LIFT))
	model:SetAttribute("OwnerId", player.UserId)
	model.Parent = base.model
	Stealing.attach(model)
	slot:SetAttribute("Occupied", true)

	local placed = table.clone(record.placed)
	table.insert(placed, {
		id = entry.id,
		character = entry.character,
		mutation = entry.mutation,
		income = entry.income,
		slot = slot,
	})
	State.update(player, { carried = remaining, placed = placed })
	Notify.send(player, string.format("Placed %s.", entry.character.name))
end

function Placement.init(bases)
	for _, base in bases do
		for _, slot in base.slots do
			local prompt = Prompts.attach(slot, "Place brainrot", "Base slot", 0)
			prompt.Triggered:Connect(function(player)
				place(player, base, slot)
			end)
		end
	end
end

-- Destroys every placed brainrot of a player and frees their slots. Used on rebirth and on leaving.
function Placement.clearPlaced(player)
	local record = State.get(player)
	if record == nil then
		return
	end
	for _, entry in record.placed do
		entry.slot:SetAttribute("Occupied", nil)
	end
	for _, model in workspace:GetDescendants() do
		if model:IsA("Model") and model:GetAttribute("OwnerId") == player.UserId and model:GetAttribute("EntryId") ~= nil then
			model:Destroy()
		end
	end
	State.update(player, { placed = {} })
end

return Placement
