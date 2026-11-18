-- The brainrot cast, its rarities and its mutations, plus the weighted rolls that pick from them.

local Catalog = {}

Catalog.RARITIES = {
	{ name = "Common", weight = 45, color = Color3.fromRGB(190, 190, 190) },
	{ name = "Uncommon", weight = 28, color = Color3.fromRGB(90, 220, 110) },
	{ name = "Rare", weight = 14, color = Color3.fromRGB(80, 160, 255) },
	{ name = "Epic", weight = 8, color = Color3.fromRGB(190, 100, 255) },
	{ name = "Legendary", weight = 4, color = Color3.fromRGB(255, 190, 40) },
	{ name = "Mythic", weight = 1, color = Color3.fromRGB(255, 70, 130) },
}

Catalog.MUTATIONS = {
	{ name = "Normal", multiplier = 1, weight = 70, color = nil },
	{ name = "Gold", multiplier = 2, weight = 20, color = Color3.fromRGB(255, 215, 0) },
	{ name = "Diamond", multiplier = 5, weight = 8, color = Color3.fromRGB(120, 230, 255) },
	{ name = "Rainbow", multiplier = 10, weight = 2, color = Color3.fromRGB(255, 120, 255) },
}

-- income is money per second for one brainrot before its mutation and the player's multipliers.
Catalog.CHARACTERS = {
	{ name = "Bonk Potato", rarity = "Common", income = 2, shape = "Ball", color = Color3.fromRGB(196, 150, 90) },
	{ name = "Lint Goose", rarity = "Common", income = 3, shape = "Block", color = Color3.fromRGB(240, 240, 235) },
	{ name = "Sock Gremlin", rarity = "Common", income = 2, shape = "Block", color = Color3.fromRGB(200, 60, 60) },
	{ name = "Toast Ferret", rarity = "Common", income = 3, shape = "Cylinder", color = Color3.fromRGB(230, 190, 120) },
	{ name = "Waffle Moth", rarity = "Uncommon", income = 8, shape = "Ball", color = Color3.fromRGB(245, 205, 110) },
	{ name = "Jelly Crab", rarity = "Uncommon", income = 10, shape = "Ball", color = Color3.fromRGB(255, 110, 150) },
	{ name = "Pickle Yeti", rarity = "Uncommon", income = 9, shape = "Block", color = Color3.fromRGB(110, 190, 90) },
	{ name = "Mud Pigeon", rarity = "Uncommon", income = 7, shape = "Block", color = Color3.fromRGB(120, 95, 70) },
	{ name = "Neon Walrus", rarity = "Rare", income = 30, shape = "Cylinder", color = Color3.fromRGB(60, 230, 230) },
	{ name = "Cloud Frog", rarity = "Rare", income = 26, shape = "Ball", color = Color3.fromRGB(170, 220, 255) },
	{ name = "Gizmo Llama", rarity = "Rare", income = 34, shape = "Block", color = Color3.fromRGB(150, 110, 200) },
	{ name = "Velvet Bat", rarity = "Rare", income = 28, shape = "Block", color = Color3.fromRGB(70, 40, 90) },
	{ name = "Turbo Noodle", rarity = "Epic", income = 90, shape = "Cylinder", color = Color3.fromRGB(255, 230, 120) },
	{ name = "Sir Crumbsworth", rarity = "Epic", income = 110, shape = "Ball", color = Color3.fromRGB(160, 110, 60) },
	{ name = "Glitch Narwhal", rarity = "Epic", income = 100, shape = "Block", color = Color3.fromRGB(30, 30, 60) },
	{ name = "Chonky Monarch", rarity = "Legendary", income = 300, shape = "Ball", color = Color3.fromRGB(255, 140, 40) },
	{ name = "Hyper Donut Dragon", rarity = "Legendary", income = 340, shape = "Cylinder", color = Color3.fromRGB(255, 120, 200) },
	{ name = "Vanta Hamster", rarity = "Legendary", income = 280, shape = "Block", color = Color3.fromRGB(40, 40, 40) },
	{ name = "Omega Pizza Sphinx", rarity = "Mythic", income = 1200, shape = "Block", color = Color3.fromRGB(255, 80, 60) },
	{ name = "The Unpaid Intern", rarity = "Mythic", income = 1500, shape = "Ball", color = Color3.fromRGB(250, 250, 250) },
}

local function weightedPick(options)
	local total = 0
	for _, option in options do
		total += option.weight
	end
	local roll = math.random() * total
	local running = 0
	for _, option in options do
		running += option.weight
		if roll <= running then
			return option
		end
	end
	return options[#options]
end

function Catalog.rarity(name)
	for _, rarity in Catalog.RARITIES do
		if rarity.name == name then
			return rarity
		end
	end
	return nil
end

function Catalog.rollRarity()
	return weightedPick(Catalog.RARITIES)
end

function Catalog.rollMutation()
	return weightedPick(Catalog.MUTATIONS)
end

function Catalog.rollCharacter(rarityName)
	local pool = {}
	for _, character in Catalog.CHARACTERS do
		if character.rarity == rarityName then
			table.insert(pool, character)
		end
	end
	return pool[math.random(#pool)]
end

return Catalog
