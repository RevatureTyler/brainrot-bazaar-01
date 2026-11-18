-- Sends a short line of text to one player's notice feed.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)

local Notify = {}

function Notify.send(player, text)
	Remotes.get("Notice"):FireClient(player, text)
end

return Notify
