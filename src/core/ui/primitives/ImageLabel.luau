local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local e: typeof(React.createElement) = React.createElement

type ImageLabelProps = {
	BackgroundTransparency: number?,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	Rotation: number?,
	BackgroundColor3: Color3?,
	Image: string?,
	ImageColor3: Color3?,
	ImageTransparency: number?,
	ScaleType: Enum.ScaleType?,
	LayoutOrder: number?,
	ZIndex: number?,
	Visible: boolean?,
	children: React.ReactNode?,
}

return React.forwardRef(function(props: ImageLabelProps, ref: any)
	local imageProps = table.clone(props)
	imageProps.children = nil
	imageProps.ref = ref
	imageProps.BackgroundTransparency = props.BackgroundTransparency or 1
	imageProps.Size = props.Size or UDim2.fromScale(1, 1)

	return e("ImageLabel", imageProps, props.children)
end)