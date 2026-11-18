-- Server bootstrap: builds the world, starts each system once, and gives every joining player a base.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local State = require(script.State)
local WorldBuilder = require(script.WorldBuilder)
local BaseService = require(script.BaseService)
local Sync = require(script.Sync)
local Economy = require(script.Economy)
local Shop = require(script.Shop)
local Placement = require(script.Placement)
local Upgrades = require(script.Upgrades)
local Rebirth = require(script.Rebirth)
local BaseLock = require(script.BaseLock)
local Hazard = require(script.Hazard)

Remotes.createAll()

local world = WorldBuilder.build()
BaseService.init(world.bases)
Sync.start()
Economy.start()
Shop.start(world.market)
Placement.init(world.bases)
Upgrades.start(world.upgradePad)
Rebirth.start(world.rebirthPad)
BaseLock.start(world.bases)
Hazard.start()

local function joinPlayer(player)
	State.create(player)
	local base = BaseService.claim(player)
	if base == nil then
		player:Kick("Every base is taken right now. Try again soon.")
		return
	end
	player.CharacterAdded:Connect(function(character)
		character:PivotTo(CFrame.new(base.center + Vector3.new(0, 4, 8)))
	end)
	player:LoadCharacter()
end

local function leavePlayer(player)
	Placement.clearPlaced(player)
	BaseService.release(player)
	State.remove(player)
end

Players.PlayerAdded:Connect(joinPlayer)
Players.PlayerRemoving:Connect(leavePlayer)
for _, player in Players:GetPlayers() do
	task.spawn(joinPlayer, player)
end
