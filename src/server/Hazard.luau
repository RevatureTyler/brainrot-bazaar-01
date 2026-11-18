-- The timed wave: a warning, then a band of fire sweeps the map. Anyone outside their own base when it passes loses what they carried.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local State = require(script.Parent.State)
local BaseService = require(script.Parent.BaseService)
local Notify = require(script.Parent.Notify)

local Hazard = {}

local function loseCarried(player)
	local record = State.get(player)
	if record == nil or #record.carried == 0 then
		return
	end
	State.update(player, { carried = {} })
	Notify.send(player, "The wave caught you outside your base and took your carried brainrots!")
end

local function checkHits(waveZ, alreadyHit)
	for _, player in Players:GetPlayers() do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root and not alreadyHit[player] and math.abs(root.Position.Z - waveZ) <= Config.WAVE_HALF_THICKNESS then
			if not BaseService.isHome(player, root.Position) then
				alreadyHit[player] = true
				loseCarried(player)
			end
		end
	end
end

local function sweep()
	local wave = Instance.new("Part")
	wave.Name = "Wave"
	wave.Anchored = true
	wave.CanCollide = false
	wave.Size = Vector3.new(600, 12, Config.WAVE_HALF_THICKNESS * 2)
	wave.Color = Color3.fromRGB(255, 120, 40)
	wave.Material = Enum.Material.Neon
	wave.Transparency = 0.2
	wave.Parent = Workspace

	local startTime = Workspace:GetServerTimeNow()
	local alreadyHit = {}
	local progress = 0
	while progress < 1 do
		progress = math.min((Workspace:GetServerTimeNow() - startTime) / Config.WAVE_TRAVEL_SECONDS, 1)
		local waveZ = -Config.WAVE_LIMIT + progress * Config.WAVE_LIMIT * 2
		wave.CFrame = CFrame.new(0, 6, waveZ)
		checkHits(waveZ, alreadyHit)
		task.wait(Config.WAVE_CHECK_SECONDS)
	end
	wave:Destroy()
end

function Hazard.start()
	local waveRemote = Remotes.get("Wave")
	task.spawn(function()
		while true do
			task.wait(Config.WAVE_INTERVAL_SECONDS - Config.WAVE_WARNING_SECONDS)
			waveRemote:FireAllClients(Config.WAVE_WARNING_SECONDS)
			task.wait(Config.WAVE_WARNING_SECONDS)
			sweep()
		end
	end)
end

return Hazard
