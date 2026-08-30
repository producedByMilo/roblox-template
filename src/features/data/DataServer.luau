-- // Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataService = require(ReplicatedStorage.Packages:FindFirstChild("DataService")).server
local DataTemplate = require(ReplicatedStorage.Shared.Game.Modules:FindFirstChild("DataTemplate"))

local Store = "PlayerData"
if RunService:IsStudio() then
	Store = "Testing"
end

local Service = {}

-- // Helpers
local function createLeaderstats(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

		local tix = Instance.new("IntValue")
	    tix.Name = "Tix"
	    tix.Parent = leaderstats

	local xp = Instance.new("IntValue")
	xp.Name = "XP"
	xp.Parent = leaderstats

	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Parent = leaderstats
end

local function syncLeaderstats(player: Player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		return
	end

	local tixValue = leaderstats:FindFirstChild("Tix") :: IntValue?
	local levelValue = leaderstats:FindFirstChild("Level") :: IntValue?
	local xpValue = leaderstats:FindFirstChild("XP") :: IntValue?

	local syncing = false

	if tixValue then
		tixValue.Value = DataService:get(player, { "stats", "tix" }) or 0

		DataService:getChangedSignal(player, { "stats", "tix" }):Connect(function(newValue)
			syncing = true
			tixValue.Value = newValue or 0
			syncing = false
		end)

		tixValue:GetPropertyChangedSignal("Value"):Connect(function()
			if syncing then
				return
			end

			DataService:set(player, { "stats", "tix" }, tixValue.Value)
		end)
	end

	if levelValue then
		levelValue.Value = DataService:get(player, { "stats", "level" }) or 0

		DataService:getChangedSignal(player, { "stats", "level" }):Connect(function(newValue)
			syncing = true
			levelValue.Value = newValue or 0
			syncing = false
		end)

		levelValue:GetPropertyChangedSignal("Value"):Connect(function()
			if syncing then
				return
			end

			DataService:set(player, { "stats", "level" }, levelValue.Value)
		end)
	end

	if xpValue then
		xpValue.Value = DataService:get(player, { "stats", "xp" }) or 0

		DataService:getChangedSignal(player, { "stats", "xp" }):Connect(function(newValue)
			syncing = true
			xpValue.Value = newValue or 0
			syncing = false
		end)

		xpValue:GetPropertyChangedSignal("Value"):Connect(function()
			if syncing then
				return
			end

			DataService:set(player, { "stats", "xp" }, xpValue.Value)
		end)
	end
end

local function onPlayerAdded(player: Player)
	createLeaderstats(player)

	local start = tick()

	while true do
		local success, data = pcall(function()
			return DataService:get(player, {})
		end)

		if success and data then
			break
		end

		task.wait()

		if tick() - start > 10 then
			warn(`Failed to load data for {player.Name}`)
			return
		end
	end

	syncLeaderstats(player)
	task.wait(3)
	print(DataService:get(player, { "stats", "tix" }))
end

-- // Init
function Service.OnStart()
	DataService:init({
		template = DataTemplate,
		profileStoreIndex = Store,
	})

	for _, player in Players:GetPlayers() do
		task.spawn(onPlayerAdded, player)
	end

	Players.PlayerAdded:Connect(onPlayerAdded)
end

-- // API
function Service.getData(player: Player)
	local success, result = pcall(function()
		return DataService:get(player, {})
	end)

	if success then
		return result
	end

	return nil
end

function Service.getValue(player: Player, path: { string })
	local success, result = pcall(function()
		return DataService:get(player, path)
	end)

	if success then
		return result
	end

	return nil
end

function Service.setValue(player: Player, path: { string }, value: any)
	pcall(function()
		DataService:set(player, path, value)
	end)
end

function Service.incrementValue(player: Player, path: { string }, amount: number)
	local current = DataService:get(player, path) or 0
	DataService:set(player, path, current + amount)
end

-- Tix
function Service.addTix(player: Player, amount: number)
	Service.incrementValue(player, { "stats", "tix" }, amount)
end

function Service.setTix(player: Player, amount: number)
	DataService:set(player, { "stats", "tix" }, amount)
end

function Service.getTix(player: Player): number
	return DataService:get(player, { "stats", "tix" }) or 0
end

-- XP
function Service.addXP(player: Player, amount: number)
	Service.incrementValue(player, { "stats", "xp" }, amount)
end

function Service.setXP(player: Player, amount: number)
	DataService:set(player, { "stats", "xp" }, amount)
end

function Service.getXP(player: Player): number
	return DataService:get(player, { "stats", "xp" }) or 0
end

-- Level
function Service.addLevel(player: Player, amount: number)
	Service.incrementValue(player, { "stats", "level" }, amount)
end

function Service.setLevel(player: Player, amount: number)
	DataService:set(player, { "stats", "level" }, amount)
end

function Service.getLevel(player: Player): number
	return DataService:get(player, { "stats", "level" }) or 0
end

return Service