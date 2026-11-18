-- The carried list: brainrots bought or stolen but not yet placed. Lives on the right edge; toggled with C.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)

local Carried = {}

local panel = nil
local listLabel = nil

function Carried.toggle()
	if panel ~= nil then
		panel.Visible = not panel.Visible
	end
end

local function show(lines)
	if listLabel == nil then
		return
	end
	if #lines == 0 then
		listLabel.Text = "Carried: none\nRoll at the market, then place on your base."
		return
	end
	listLabel.Text = "Carried (" .. #lines .. ")\n" .. table.concat(lines, "\n")
end

function Carried.start()
	local player = Players.LocalPlayer
	local gui = Instance.new("ScreenGui")
	gui.Name = "CarriedGui"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	panel = Instance.new("Frame")
	panel.Name = "Panel"
	panel.AnchorPoint = Vector2.new(1, 0.5)
	panel.Position = UDim2.new(1, -12, 0.5, 0)
	panel.Size = UDim2.fromOffset(260, 280)
	panel.BackgroundTransparency = 0.3
	panel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	panel.Parent = gui

	listLabel = Instance.new("TextLabel")
	listLabel.Name = "List"
	listLabel.Size = UDim2.new(1, -16, 1, -16)
	listLabel.Position = UDim2.fromOffset(8, 8)
	listLabel.BackgroundTransparency = 1
	listLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	listLabel.TextXAlignment = Enum.TextXAlignment.Left
	listLabel.TextYAlignment = Enum.TextYAlignment.Top
	listLabel.TextSize = 14
	listLabel.TextWrapped = true
	listLabel.Font = Enum.Font.Gotham
	listLabel.Parent = panel

	Remotes.get("Carried").OnClientEvent:Connect(show)
	show({})
end

return Carried
