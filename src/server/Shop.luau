-- The market pad: rolling costs a fixed price and gives a random brainrot, which goes into the player's carried list.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Catalog = require(ReplicatedStorage.Shared.Catalog)
local State = require(script.Parent.State)
local Notify = require(script.Parent.Notify)
local Prompts = require(script.Parent.Prompts)

local Shop = {}

local nextEntryId = 0

local function roll(player)
	local record = State.get(player)
	if record.money < Config.ROLL_PRICE then
		Notify.send(player, string.format("A roll costs $%d.", Config.ROLL_PRICE))
		return
	end

	local rarity = Catalog.rollRarity()
	local character = Catalog.rollCharacter(rarity.name)
	local mutation = Catalog.rollMutation()
	nextEntryId += 1
	local entry = {
		id = nextEntryId,
		character = character,
		mutation = mutation,
		income = character.income * mutation.multiplier,
	}

	local carried = table.clone(record.carried)
	table.insert(carried, entry)
	State.update(player, { money = record.money - Config.ROLL_PRICE, carried = carried })
	Notify.send(player, string.format("Got %s (%s, %s)!", character.name, rarity.name, mutation.name))
end

function Shop.start(marketPad)
	local prompt = Prompts.attach(marketPad, "Roll", "Brainrot market", 0)
	prompt.Triggered:Connect(roll)
end

return Shop
