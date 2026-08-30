local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local MountUI = require(ReplicatedStorage.Shared.Core.UI:WaitForChild("Mount"))

local loadedModules = {}

local function loadFolder(folder: Instance)
	for _, child in folder:GetDescendants() do
		if child:IsA("ModuleScript") then
			local ok, module = pcall(require, child)

			if not ok then
				warn(`Failed to require {child:GetFullName()}: {module}`)
				continue
			end

			table.insert(loadedModules, module)
		end
	end
end

loadFolder(Shared.Features)
MountUI.Mount()

-- Init phase
for _, module in loadedModules do
	if type(module) == "table" and type(module.OnInit) == "function" then
		module.OnInit()
	end
end

-- Start phase
for _, module in loadedModules do
	if type(module) == "table" and type(module.OnStart) == "function" then
		task.spawn(module.OnStart)
	end
end