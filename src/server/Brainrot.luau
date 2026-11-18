-- Builds the 3D body and the name tag of one placed brainrot. Visuals only: it changes no state.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Catalog = require(ReplicatedStorage.Shared.Catalog)

local Brainrot = {}

local SHAPES = {
	Ball = Enum.PartType.Ball,
	Block = Enum.PartType.Block,
	Cylinder = Enum.PartType.Cylinder,
}

local function buildLabel(body, entry)
	local rarity = Catalog.rarity(entry.character.rarity)
	local gui = Instance.new("BillboardGui")
	gui.Name = "NameTag"
	gui.Size = UDim2.fromOffset(200, 52)
	gui.StudsOffset = Vector3.new(0, 3.5, 0)
	gui.AlwaysOnTop = true
	gui.Parent = body

	local nameLine = Instance.new("TextLabel")
	nameLine.Name = "Name"
	nameLine.Size = UDim2.new(1, 0, 0.55, 0)
	nameLine.BackgroundTransparency = 1
	nameLine.Text = entry.character.name
	nameLine.TextColor3 = rarity.color
	nameLine.TextStrokeTransparency = 0
	nameLine.TextScaled = true
	nameLine.Font = Enum.Font.GothamBold
	nameLine.Parent = gui

	local infoLine = Instance.new("TextLabel")
	infoLine.Name = "Info"
	infoLine.Position = UDim2.new(0, 0, 0.55, 0)
	infoLine.Size = UDim2.new(1, 0, 0.45, 0)
	infoLine.BackgroundTransparency = 1
	infoLine.Text = string.format("%s · %s · $%d/s", rarity.name, entry.mutation.name, entry.income)
	infoLine.TextColor3 = Color3.fromRGB(255, 255, 255)
	infoLine.TextStrokeTransparency = 0
	infoLine.TextScaled = true
	infoLine.Font = Enum.Font.Gotham
	infoLine.Parent = gui
end

function Brainrot.build(entry)
	local model = Instance.new("Model")
	model.Name = entry.character.name

	local body = Instance.new("Part")
	body.Name = "Body"
	body.Shape = SHAPES[entry.character.shape]
	body.Size = Vector3.new(4, 4, 4)
	body.Color = entry.character.color
	body.Material = Enum.Material.SmoothPlastic
	body.Anchored = true
	body.CanCollide = false
	body.Parent = model
	model.PrimaryPart = body

	if entry.mutation.color ~= nil then
		local highlight = Instance.new("Highlight")
		highlight.FillColor = entry.mutation.color
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.35
		highlight.Parent = model
	end

	buildLabel(body, entry)
	model:SetAttribute("EntryId", entry.id)
	return model
end

return Brainrot
