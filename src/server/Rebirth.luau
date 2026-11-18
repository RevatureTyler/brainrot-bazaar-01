-- Rebirth: spend the cash to reset the run for a permanent income multiplier. Clears cash, upgrades, placed and carried brainrots.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local State = require(script.Parent.State)
local Notify = require(script.Parent.Notify)
local Prompts = require(script.Parent.Prompts)
local Placement = require(script.Parent.Placement)

local Rebirth = {}

function Rebirth.cost(rebirths)
	return math.floor(Config.REBIRTH_BASE_COST * Config.REBIRTH_COST_GROWTH ^ rebirths)
end

local function perform(player)
	local record = State.get(player)
	local cost = Rebirth.cost(record.rebirths)
	if record.money < cost then
		Notify.send(player, string.format("Rebirth costs $%d.", cost))
		return
	end
	Placement.clearPlaced(player)
	State.update(player, {
		money = Config.START_MONEY,
		rebirths = record.rebirths + 1,
		upgradeLevel = 0,
		carried = {},
		placed = {},
		lockUntil = 0,
	})
	Notify.send(player, string.format("Rebirth %d! Income x%d now.", record.rebirths + 1, record.rebirths + 2))
end

function Rebirth.start(pad)
	local prompt = Prompts.attach(pad, "Rebirth", "Rebirth shrine", 0)
	prompt.Triggered:Connect(perform)
end

return Rebirth
