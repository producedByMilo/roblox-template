local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local e: typeof(React.createElement) = React.createElement

type CanBeBinding<T> = T | React.Binding<T>
type TextLabelConstructor = (props: TextLabelProps) -> React.ReactNode?

type Stroke = {
	Thickness: CanBeBinding<number>?,
	Color: CanBeBinding<Color3>?,
	Transparency: CanBeBinding<number>?,
	StrokeSizingMode: CanBeBinding<Enum.StrokeSizingMode>?,
}

type DropShadow = {
	Offset: UDim2?,
	Color: CanBeBinding<Color3>?,
	Transparency: CanBeBinding<number>?,
}

type Gradient = {
	Color: CanBeBinding<ColorSequence>?,
	Transparency: CanBeBinding<NumberSequence>?,
	Rotation: CanBeBinding<number>?,
}

type TextImage = {
	Image: CanBeBinding<string>?,
	Size: CanBeBinding<UDim2>?,
	HorizontalAlignment: CanBeBinding<Enum.HorizontalAlignment>?,
	Padding: CanBeBinding<UDim>?,
	SizeConstraint: CanBeBinding<Enum.SizeConstraint>?,
	ImageColor3: CanBeBinding<Color3>?,
	ImageTransparency: CanBeBinding<number>?,
}

export type TextLabelProps = {
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	Rotation: number?,
	BackgroundTransparency: number?,
	BackgroundColor3: Color3?,
	LayoutOrder: number?,
	ZIndex: number?,
	Visible: boolean?,
	SizeConstraint: Enum.SizeConstraint?,
	AutomaticSize: Enum.AutomaticSize?,
	Text: CanBeBinding<string>?,
	TextColor3: CanBeBinding<Color3>?,
	TextSize: CanBeBinding<number>?,
	TextTransparency: CanBeBinding<number>?,
	Font: CanBeBinding<Enum.Font>?,
	TextScaled: CanBeBinding<boolean>?,
	TextXAlignment: CanBeBinding<Enum.TextXAlignment>?,
	TextYAlignment: CanBeBinding<Enum.TextYAlignment>?,
	TextWrapped: CanBeBinding<boolean>?,
	RichText: CanBeBinding<boolean>?,
	Stroke: Stroke?,
	DropShadow: DropShadow?,
	Gradient: Gradient?,
	Prefix: TextImage?,
	Suffix: TextImage?,
	children: React.ReactNode?,
}

local function merge(defaults, values)
	local result = table.clone(defaults)
	for key, value in values do
		result[key] = value
	end
	return result
end

local TextLabel = React.forwardRef(function(props: TextLabelProps, ref: any)
	local hasImages = props.Prefix or props.Suffix

	local textProps = {
		Text = props.Text,
		TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255),
		TextSize = props.TextSize,
		TextScaled = if props.TextSize then false else (props.TextScaled ~= false),
		Font = props.Font or Enum.Font.BuilderSansExtraBold,
		TextTransparency = props.TextTransparency,
		TextXAlignment = props.TextXAlignment,
		TextYAlignment = props.TextYAlignment,
		TextWrapped = props.TextWrapped,
		AutomaticSize = props.AutomaticSize or (if hasImages then Enum.AutomaticSize.X else nil),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Size = if hasImages then UDim2.fromScale(0, 1) else UDim2.fromScale(1, 1),
		RichText = props.RichText,
		LayoutOrder = 1,
		ZIndex = 1,
		ref = ref,
	}

	return e("Frame", {
		Size = props.Size,
		Position = props.Position or UDim2.fromScale(0.5, 0.5),
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		Rotation = props.Rotation,
		BackgroundTransparency = props.BackgroundTransparency or 1,
		BackgroundColor3 = props.BackgroundColor3,
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex or 1,
		Visible = props.Visible,
		SizeConstraint = props.SizeConstraint,
		AutomaticSize = props.AutomaticSize,
	}, {
		Text = e("TextLabel", textProps, {
			Stroke = if props.Stroke then e("UIStroke", merge({ Thickness = 2, Color = Color3.new(), Transparency = 0 }, props.Stroke)) else nil,
			Gradient = if props.Gradient then e("UIGradient", props.Gradient) else nil,
		}, props.children),

		Shadow = if props.DropShadow then e("TextLabel", {
			Text = props.Text,
			TextColor3 = props.DropShadow.Color or Color3.new(),
			TextSize = props.TextSize,
			TextScaled = textProps.TextScaled,
			Font = textProps.Font,
			TextTransparency = props.DropShadow.Transparency or 0,
			Position = UDim2.fromScale(0.5, 0.5) + (props.DropShadow.Offset or UDim2.fromOffset(0, 4)),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 0,
			RichText = props.RichText,
		}) else nil,

		Layout = if hasImages then e("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4),
		}) else nil,

		Prefix = if props.Prefix then e("ImageLabel", {
			BackgroundTransparency = 1,
			Size = props.Prefix.Size or UDim2.fromScale(1, 1),
			SizeConstraint = props.Prefix.SizeConstraint or Enum.SizeConstraint.RelativeYY,
			LayoutOrder = 0,
			ScaleType = Enum.ScaleType.Fit,
			Image = props.Prefix.Image,
			ImageColor3 = props.Prefix.ImageColor3,
			ImageTransparency = props.Prefix.ImageTransparency,
		}) else nil,

		Suffix = if props.Suffix then e("ImageLabel", {
			BackgroundTransparency = 1,
			Size = props.Suffix.Size or UDim2.fromScale(1, 1),
			SizeConstraint = props.Suffix.SizeConstraint or Enum.SizeConstraint.RelativeYY,
			LayoutOrder = 2,
			ScaleType = Enum.ScaleType.Fit,
			Image = props.Suffix.Image,
			ImageColor3 = props.Suffix.ImageColor3,
			ImageTransparency = props.Suffix.ImageTransparency,
		}) else nil,
	})
end)

return (TextLabel :: any) :: TextLabelConstructor