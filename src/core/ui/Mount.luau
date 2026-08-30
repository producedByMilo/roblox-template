local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

local UI = {}

function UI.Mount()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local container = Instance.new("ScreenGui")
	container.Name = "App"
	container.IgnoreGuiInset = true
	container.ResetOnSpawn = false
	container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	container.ClipToDeviceSafeArea = false
	container.Parent = playerGui

	local children = {}

	for _, module in ipairs(script.Parent:GetChildren()) do
		if module:IsA("ModuleScript") then
			local component = require(module)
			children[module.Name] = React.createElement(component)
		end
	end

	local app = React.createElement(React.Fragment, nil, children)

	local root = ReactRoblox.createRoot(container)
	root:render(app)
end

return UI