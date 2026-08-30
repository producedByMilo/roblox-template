local ServerScriptService = game:GetService("ServerScriptService")
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

loadFolder(script.Parent.Features)

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