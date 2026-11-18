-- Builds the map's geometry: the market, the upgrade and rebirth pads, and eight bases with their slots and lock pads.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Config = require(ReplicatedStorage.Shared.Config)

local WorldBuilder = {}

local BASE_SIZE = 60
local BASE_SPACING = 80
local BASE_ROW_Z = 130
local SLOT_OFFSETS = {
	Vector3.new(-16, 0, -10),
	Vector3.new(0, 0, -10),
	Vector3.new(16, 0, -10),
	Vector3.new(-16, 0, 10),
	Vector3.new(0, 0, 10),
	Vector3.new(16, 0, 10),
}

local function block(parent, name, size, position, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.Position = position
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function buildMarket(map)
	block(map, "MarketFloor", Vector3.new(60, 1, 60), Vector3.new(0, 0.5, 0), Color3.fromRGB(230, 200, 140))
	for _, corner in { Vector3.new(-26, 0, -26), Vector3.new(26, 0, -26), Vector3.new(-26, 0, 26), Vector3.new(26, 0, 26) } do
		block(map, "Pillar", Vector3.new(3, 14, 3), Vector3.new(corner.X, 7, corner.Z), Color3.fromRGB(120, 90, 60))
	end
	local market = block(map, "MarketPad", Vector3.new(14, 0.4, 14), Vector3.new(0, 1.2, 0), Color3.fromRGB(255, 240, 120), Enum.Material.Neon)
	local upgrade = block(map, "UpgradePad", Vector3.new(12, 0.4, 12), Vector3.new(-50, 1.2, 0), Color3.fromRGB(80, 170, 255), Enum.Material.Neon)
	local rebirth = block(map, "RebirthPad", Vector3.new(12, 0.4, 12), Vector3.new(50, 1.2, 0), Color3.fromRGB(190, 90, 255), Enum.Material.Neon)
	return market, upgrade, rebirth
end

local function buildBase(folder, index, center)
	local model = Instance.new("Model")
	model.Name = "Base" .. index
	model.Parent = folder
	block(model, "Platform", Vector3.new(BASE_SIZE, 1, BASE_SIZE), center + Vector3.new(0, 0.5, 0), Color3.fromRGB(150, 210, 150))
	local slots = {}
	for slotIndex, offset in SLOT_OFFSETS do
		slots[slotIndex] = block(model, "Slot" .. slotIndex, Vector3.new(10, 0.4, 10), center + Vector3.new(offset.X, 1.2, offset.Z), Color3.fromRGB(90, 90, 110), Enum.Material.Neon)
	end
	local lockPad = block(model, "LockPad", Vector3.new(8, 0.4, 8), center + Vector3.new(-20, 1.2, 22), Color3.fromRGB(255, 80, 80), Enum.Material.Neon)
	return {
		index = index,
		center = center,
		model = model,
		slots = slots,
		lockPad = lockPad,
	}
end

function WorldBuilder.build()
	local map = Instance.new("Folder")
	map.Name = "Map"
	map.Parent = Workspace
	local market, upgradePad, rebirthPad = buildMarket(map)

	local basesFolder = Instance.new("Folder")
	basesFolder.Name = "Bases"
	basesFolder.Parent = map
	local bases = {}
	for index = 1, Config.BASE_COUNT do
		local column = (index - 1) % 4
		local row = if index <= 4 then -1 else 1
		local center = Vector3.new((column - 1.5) * BASE_SPACING, 0, row * BASE_ROW_Z)
		bases[index] = buildBase(basesFolder, index, center)
	end

	return {
		bases = bases,
		market = market,
		upgradePad = upgradePad,
		rebirthPad = rebirthPad,
	}
end

return WorldBuilder
