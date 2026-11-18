-- Tuning numbers for the whole game. Data only: no behaviour lives here.

local Config = {}

Config.START_MONEY = 100
Config.ROLL_PRICE = 50
Config.INCOME_TICK_SECONDS = 1

Config.BASE_COUNT = 8
Config.BASE_RADIUS = 30 -- studs from a base's centre that still count as home
Config.STEAL_HOLD_SECONDS = 3
Config.BASE_LOCK_SECONDS = 45
Config.BASE_LOCK_PRICE = 250

Config.UPGRADE_BASE_COST = 200
Config.UPGRADE_COST_GROWTH = 2.2
Config.UPGRADE_STEP = 0.25 -- each income upgrade adds 25% to all income

Config.REBIRTH_BASE_COST = 5000
Config.REBIRTH_COST_GROWTH = 3

Config.WAVE_INTERVAL_SECONDS = 75
Config.WAVE_WARNING_SECONDS = 10
Config.WAVE_TRAVEL_SECONDS = 9
Config.WAVE_HALF_THICKNESS = 7
Config.WAVE_LIMIT = 230 -- the wave runs from -WAVE_LIMIT to +WAVE_LIMIT along Z
Config.WAVE_CHECK_SECONDS = 0.1

return Config
