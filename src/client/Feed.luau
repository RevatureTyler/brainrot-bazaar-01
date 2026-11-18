-- Notice feed under the HUD and the wave countdown banner. Shows what the server tells this player.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)

local Feed = {}

local NOTICE_SECONDS = 3.5

local function newLabel(parent, name, position, size)
	local text = Instance.new("TextLabel")
	text.Name = name
	text.AnchorPoint = Vector2.new(0.5, 0)
	text.Position = position
	text.Size = size
	text.BackgroundTransparency = 0.3
	text.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	text.TextColor3 = Color3.fromRGB(255, 255, 255)
	text.TextStrokeTransparency = 0.5
	text.TextScaled = true
	text.Font = Enum.Font.GothamBold
	text.Visible = false
	text.Parent = parent
	return text
end

function Feed.start()
	local player = Players.LocalPlayer
	local gui = Instance.new("ScreenGui")
	gui.Name = "FeedGui"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local notice = newLabel(gui, "Notice", UDim2.new(0.5, 0, 1, -90), UDim2.fromOffset(520, 34))
	local banner = newLabel(gui, "WaveBanner", UDim2.new(0.5, 0, 0, 122), UDim2.fromOffset(520, 40))
	banner.BackgroundColor3 = Color3.fromRGB(150, 50, 20)

	local noticeToken = 0
	Remotes.get("Notice").OnClientEvent:Connect(function(text)
		noticeToken += 1
		local myToken = noticeToken
		notice.Text = text
		notice.Visible = true
		task.delay(NOTICE_SECONDS, function()
			if noticeToken == myToken then
				notice.Visible = false
			end
		end)
	end)

	local bannerToken = 0
	Remotes.get("Wave").OnClientEvent:Connect(function(seconds)
		bannerToken += 1
		local myToken = bannerToken
		task.spawn(function()
			for remaining = seconds, 1, -1 do
				if bannerToken ~= myToken then
					return
				end
				banner.Text = string.format("WAVE in %d s: get home to your base!", remaining)
				banner.Visible = true
				task.wait(1)
			end
			if bannerToken == myToken then
				banner.Text = "WAVE! Stay in your base!"
				task.wait(4)
				if bannerToken == myToken then
					banner.Visible = false
				end
			end
		end)
	end)
end

return Feed
