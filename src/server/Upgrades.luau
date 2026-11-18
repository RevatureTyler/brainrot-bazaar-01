-- Income upgrades bought at the upgrade pad. Each level adds a fixed share to all income, at a rising price.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local State = require(script.Parent.State)
local Notify = require(script.Parent.Notify)
local Prompts = require(script.Parent.Prompts)

local Upgrades = {}

function Upgrades.cost(level)
	return math.floor(Config.UPGRADE_BASE_COST * Config.UPGRADE_COST_GROWTH ^ level)
end

local function buy(player)
	local record = State.get(player)
	local cost = Upgrades.cost(record.upgradeLevel)
	if record.money < cost then
		Notify.send(player, string.format("Next upgrade costs $%d.", cost))
		return
	end
	State.update(player, {
		money = record.money - cost,
		upgradeLevel = record.upgradeLevel + 1,
	})
	Notify.send(player, string.format("Income up to +%d%%.", math.floor((record.upgradeLevel + 1) * Config.UPGRADE_STEP * 100)))
end

function Upgrades.start(pad)
	local prompt = Prompts.attach(pad, "Upgrade income", "Income upgrade", 0)
	prompt.Triggered:Connect(buy)
end

return Upgrades
