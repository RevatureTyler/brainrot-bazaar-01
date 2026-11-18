-- Income: works out what a player's placed brainrots earn per second, and pays it out every tick.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local State = require(script.Parent.State)

local Economy = {}

local function multiplier(record)
	return (1 + Config.UPGRADE_STEP * record.upgradeLevel) * (1 + record.rebirths)
end

function Economy.perSecond(record)
	local base = 0
	for _, entry in record.placed do
		base += entry.income
	end
	return base * multiplier(record)
end

function Economy.start()
	task.spawn(function()
		while true do
			task.wait(Config.INCOME_TICK_SECONDS)
			for _, player in State.players() do
				local record = State.get(player)
				local gain = Economy.perSecond(record) * Config.INCOME_TICK_SECONDS
				if gain > 0 then
					State.update(player, { money = record.money + gain })
				end
			end
		end
	end)
end

return Economy
