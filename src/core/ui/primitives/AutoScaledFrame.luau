local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

local STUDIO_SIZE = Vector2.new(1500, 803)

type AutoScaledFrameConstructor = (props: AutoScaledFrameProps) -> React.ReactNode?

export type AutoScaledFrameProps = {
	ScaleFactor: number?,
	MinSize: Vector2?,
	Size: UDim2,
	Position: UDim2?,
	Rotation: number?,
	AnchorPoint: Vector2?,
	BackgroundTransparency: number?,
	BackgroundColor3: Color3?,
	LayoutOrder: number?,
	ZIndex: number?,
	Visible: boolean?,
	children: React.ReactNode?,
}

local AutoScaledFrame = React.forwardRef(function(props: AutoScaledFrameProps, ref: React.Ref<any>)
	local screenSize, setScreenSize = React.useBinding(workspace.CurrentCamera.ViewportSize)
	local minSize = props.MinSize or Vector2.zero
	local scaleFactor = props.ScaleFactor or 1
	local scaleBinding, setScale = React.useBinding(scaleFactor)

	React.useEffect(function()
		local camera = workspace.CurrentCamera

		if not camera then
			return
		end

		local connection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			setScreenSize(camera.ViewportSize)
		end)

		setScreenSize(camera.ViewportSize)

		return function()
			connection:Disconnect()
		end
	end, {})

	local minScale = React.useMemo(function()
		return math.max(minSize.X / props.Size.X.Offset, minSize.Y / props.Size.Y.Offset)
	end, { screenSize, minSize, props.Size })

	React.useEffect(function()
		local newScale = scaleFactor * math.min(screenSize:getValue().X / STUDIO_SIZE.X, screenSize:getValue().Y / STUDIO_SIZE.Y)
		setScale(math.max(newScale, minScale))
	end, { screenSize, minSize, scaleFactor, minScale })

	return e("Frame", {
		Visible = props.Visible,
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		Rotation = props.Rotation,
		ZIndex = props.ZIndex,
		BackgroundTransparency = props.BackgroundTransparency or 1,
		BackgroundColor3 = props.BackgroundColor3,
		LayoutOrder = props.LayoutOrder,
		ref = ref,
	}, {
		e("UIScale", {
			Scale = scaleBinding,
		}),
		props.children,
	})
end)

return (AutoScaledFrame :: any) :: AutoScaledFrameConstructor