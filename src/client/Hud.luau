-- Money, income and rebirth readout across the top centre of the screen. Kept clear of the top-left corner.

local Players = game:GetService("Players")

local Hud = {}

local function formatMoney(amount)
	if amount >= 1000000 then
		return string.format("%.2fM", amount / 1000000)
	elseif amount >= 1000 then
		return string.format("%.1fK", amount / 1000)
	end
	return tostring(amount)
end

local function label(parent, name, position, size, textSize)
	local text = Instance.new("TextLabel")
	text.Name = name
	text.AnchorPoint = Vector2.new(0.5, 0)
	text.Position = position
	text.Size = size
	text.BackgroundTransparency = 0.35
	text.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	text.TextColor3 = Color3.fromRGB(255, 255, 255)
	text.TextStrokeTransparency = 0.4
	text.TextSize = textSize
	text.Font = Enum.Font.GothamBold
	text.Parent = parent
	return text
end

local function refresh(player, moneyLabel, incomeLabel, rankLabel)
	moneyLabel.Text = "$" .. formatMoney(player:GetAttribute("Money") or 0)
	incomeLabel.Text = string.format("+$%s / s", tostring(player:GetAttribute("PerSecond") or 0))
	rankLabel.Text = string.format(
		"Rebirths %d  ·  Upgrades %d  ·  Base lock %ds",
		player:GetAttribute("Rebirths") or 0,
		player:GetAttribute("UpgradeLevel") or 0,
		player:GetAttribute("LockSeconds") or 0
	)
end

function Hud.start()
	local player = Players.LocalPlayer
	local gui = Instance.new("ScreenGui")
	gui.Name = "HudGui"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local moneyLabel = label(gui, "Money", UDim2.new(0.5, 0, 0, 12), UDim2.fromOffset(260, 40), 28)
	local incomeLabel = label(gui, "Income", UDim2.new(0.5, 0, 0, 56), UDim2.fromOffset(260, 26), 18)
	local rankLabel = label(gui, "Status", UDim2.new(0.5, 0, 0, 86), UDim2.fromOffset(420, 24), 14)

	local function update()
		refresh(player, moneyLabel, incomeLabel, rankLabel)
	end
	for _, attribute in { "Money", "PerSecond", "Rebirths", "UpgradeLevel", "LockSeconds" } do
		player:GetAttributeChangedSignal(attribute):Connect(update)
	end
	update()
end

return Hud
