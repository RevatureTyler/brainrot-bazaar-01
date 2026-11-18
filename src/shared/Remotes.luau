-- Named RemoteEvents shared by server and client. The server creates them at startup; the client waits for them.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FOLDER_NAME = "Remotes"
local Remotes = {}

Remotes.NAMES = { "Notice", "Wave", "Carried" }

local function folder()
	if RunService:IsServer() then
		local existing = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
		if existing then
			return existing
		end
		local created = Instance.new("Folder")
		created.Name = FOLDER_NAME
		created.Parent = ReplicatedStorage
		return created
	end
	return ReplicatedStorage:WaitForChild(FOLDER_NAME)
end

-- Server only: creates every remote now, so clients never wait on one that is never made.
function Remotes.createAll()
	for _, name in Remotes.NAMES do
		Remotes.get(name)
	end
end

function Remotes.get(name)
	local remoteFolder = folder()
	if RunService:IsServer() then
		local existing = remoteFolder:FindFirstChild(name)
		if existing then
			return existing
		end
		local created = Instance.new("RemoteEvent")
		created.Name = name
		created.Parent = remoteFolder
		return created
	end
	return remoteFolder:WaitForChild(name)
end

return Remotes
