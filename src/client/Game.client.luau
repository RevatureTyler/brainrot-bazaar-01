-- Client bootstrap: starts the HUD, the notice feed, the carried panel and the key bindings.

local Hud = require(script.Parent.Hud)
local Feed = require(script.Parent.Feed)
local Carried = require(script.Parent.Carried)
local Keys = require(script.Parent.Keys)

Hud.start()
Feed.start()
Carried.start()
Keys.start(Carried.toggle)
