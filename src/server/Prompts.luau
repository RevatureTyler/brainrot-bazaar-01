-- Creates the ProximityPrompts the game uses, so every prompt has the same reach and no line-of-sight rule.

local Prompts = {}

function Prompts.attach(parent, actionText, objectText, holdSeconds)
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = actionText
	prompt.ObjectText = objectText
	prompt.HoldDuration = holdSeconds
	prompt.MaxActivationDistance = 9
	prompt.RequiresLineOfSight = false
	prompt.Parent = parent
	return prompt
end

return Prompts
