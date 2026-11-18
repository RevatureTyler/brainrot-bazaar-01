-- Key bindings. Uses ContextActionService so the default camera's arrow-key handling never swallows them.

local ContextActionService = game:GetService("ContextActionService")

local Keys = {}

local ACTION_TOGGLE_CARRIED = "ToggleCarried"

function Keys.start(onToggleCarried)
	ContextActionService:BindAction(ACTION_TOGGLE_CARRIED, function(_, inputState)
		if inputState == Enum.UserInputState.Begin then
			onToggleCarried()
		end
		return Enum.ContextActionResult.Pass
	end, false, Enum.KeyCode.C)
end

return Keys
