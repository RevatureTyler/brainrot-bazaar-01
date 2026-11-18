-- Base lock: an owner pays to make their base unstealable for a while. Owns the lock rule only.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Config = require(ReplicatedStorage.Shared.Config)
local State = require(script.Parent.State)
local BaseService = require(script.Parent.BaseService)
local Notify = require(script.Parent.Notify)
local Prompts = require(script.Parent.Prompts)

local BaseLock = {}

function BaseLock.secondsLeft(record)
	return math.max(0, math.ceil(record.lockUntil - Workspace:GetServerTimeNow()))
end

function BaseLock.isLocked(record)
	return BaseLock.secondsLeft(record) > 0
end

local function buy(player, base)
	if BaseService.ownerOf(base) ~= player then
		Notify.send(player, "That lock pad belongs to another base.")
		return
	end
	local record = State.get(player)
	if record.money < Config.BASE_LOCK_PRICE then
		Notify.send(player, string.format("A base lock costs $%d.", Config.BASE_LOCK_PRICE))
		return
	end
	State.update(player, {
		money = record.money - Config.BASE_LOCK_PRICE,
		lockUntil = Workspace:GetServerTimeNow() + Config.BASE_LOCK_SECONDS,
	})
	Notify.send(player, string.format("Base locked for %d s.", Config.BASE_LOCK_SECONDS))
end

function BaseLock.start(bases)
	for _, base in bases do
		local prompt = Prompts.attach(base.lockPad, "Lock base", "Base lock", 0)
		prompt.Triggered:Connect(function(player)
			buy(player, base)
		end)
	end
end

return BaseLock
