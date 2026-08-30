local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local e: typeof(React.createElement) = React.createElement

export type ButtonProps = {
	hoverScale: number?,
	children: React.ReactNode?,
	Activated: (() -> ())?,
	OnEnter: (() -> ())?,
	OnLeave: (() -> ())?,
	OnDown: (() -> ())?,
	OnUp: (() -> ())?,
	[any]: any,
}

type ButtonConstructor = (props: ButtonProps) -> React.ReactNode?

local Button = React.forwardRef(function(props: ButtonProps, ref: any)
	local safeProps = {}

	for key, value in props do
		if key ~= "hoverScale" and key ~= "Activated" and key ~= "OnEnter" and key ~= "OnLeave" and key ~= "OnDown" and key ~= "OnUp" and key ~= "children" then
			safeProps[key] = value
		end
	end

	safeProps.ref = ref
	safeProps.BackgroundTransparency = props.BackgroundTransparency or 1
	safeProps.AutoButtonColor = props.AutoButtonColor or false

	safeProps[React.Event.MouseEnter] = function()
		if props.OnEnter then
			props.OnEnter()
		end
	end

	safeProps[React.Event.MouseLeave] = function()
		if props.OnLeave then
			props.OnLeave()
		end
	end

	safeProps[React.Event.MouseButton1Down] = function()
		if props.OnDown then
			props.OnDown()
		end
	end

	safeProps[React.Event.MouseButton1Up] = function()
		if props.OnUp then
			props.OnUp()
		end
	end

	safeProps[React.Event.Activated] = props.Activated

	return e("ImageButton", safeProps, props.children)
end)

return (Button :: any) :: ButtonConstructor