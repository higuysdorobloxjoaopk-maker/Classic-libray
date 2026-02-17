local Lib = {}

Lib.Name = "super classic lib"
Lib.Version = "1.0"
Lib.Flags = {}
Lib.Connections = {}
Lib.Windows = {}

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local theme = {
	bg = Color3.new(1,1,1),
	transparency = 0.75,
	accent = Color3.fromRGB(0,120,255),
	text = Color3.new(0,0,0)
}

local function dragify(top, frame)
	local dragging, dragStart, startPos = false, nil, nil
	top.InputBegan:Connect(function(input)
		if input.UserInputType.Name:find("Mouse") or input.UserInputType.Name == "Touch" then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType.Name:find("Mouse") or input.UserInputType.Name == "Touch") then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType.Name:find("Mouse") or input.UserInputType.Name == "Touch" then
			dragging = false
		end
	end)
end

function Lib:CreateWindow(title, size)
	title = title or Lib.Name
	size = size or UDim2.new(0,400,0,300)

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local Main = Instance.new("Frame")
	Main.Size = size
	Main.Position = UDim2.new(0.5,-size.X.Offset/2,0.5,-size.Y.Offset/2)
	Main.BackgroundColor3 = theme.bg
	Main.BackgroundTransparency = theme.transparency
	Main.BorderSizePixel = 0
	Main.Parent = ScreenGui

	local Top = Instance.new("Frame")
	Top.Size = UDim2.new(1,0,0,30)
	Top.BackgroundColor3 = theme.bg
	Top.BackgroundTransparency = theme.transparency
	Top.BorderSizePixel = 0
	Top.Parent = Main

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1,0,1,0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 14
	TitleLabel.TextColor3 = theme.text
	TitleLabel.Parent = Top

	-- Close / Minimize Buttons
	local MinBtn = Instance.new("TextButton")
	MinBtn.Size = UDim2.new(0,30,1,0)
	MinBtn.Position = UDim2.new(1,-60,0,0)
	MinBtn.Text = "-"
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.TextSize = 18
	MinBtn.BackgroundTransparency = 1
	MinBtn.TextColor3 = theme.text
	MinBtn.Parent = Top

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0,30,1,0)
	CloseBtn.Position = UDim2.new(1,-30,0,0)
	CloseBtn.Text = "X"
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 14
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.TextColor3 = theme.text
	CloseBtn.Parent = Top

	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0,120,1,-30)
	Sidebar.Position = UDim2.new(0,0,0,30)
	Sidebar.BackgroundTransparency = 1
	Sidebar.Parent = Main

	local SideList = Instance.new("UIListLayout")
	SideList.Parent = Sidebar

	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1,-120,1,-30)
	Container.Position = UDim2.new(0,120,0,30)
	Container.BackgroundTransparency = 1
	Container.Parent = Main

	dragify(Top, Main)

	local minimized = false
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		for _,v in pairs(Container:GetChildren()) do v.Visible = not minimized end
		Main.Size = minimized and UDim2.new(0,size.X.Offset,0,30) or size
	end)
	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	local Window = {}
	Window.Tabs = {}

	function Window:CreateTab(name)
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1,0,0,30)
		TabButton.Text = name
		TabButton.Font = Enum.Font.Gotham
		TabButton.TextSize = 14
		TabButton.BackgroundColor3 = theme.bg
		TabButton.BackgroundTransparency = theme.transparency
		TabButton.TextColor3 = theme.text
		TabButton.Parent = Sidebar

		local TabFrame = Instance.new("ScrollingFrame")
		TabFrame.Size = UDim2.new(1,0,1,0)
		TabFrame.CanvasSize = UDim2.new(0,0,0,0)
		TabFrame.ScrollBarThickness = 4
		TabFrame.Visible = false
		TabFrame.BackgroundTransparency = 1
		TabFrame.Parent = Container

		local Layout = Instance.new("UIListLayout")
		Layout.Parent = TabFrame
		Layout.Padding = UDim.new(0,5)
		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabFrame.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y)
		end)

		TabButton.MouseButton1Click:Connect(function()
			for _,t in pairs(Container:GetChildren()) do
				if t:IsA("ScrollingFrame") then t.Visible = false end
			end
			for _,b in pairs(Sidebar:GetChildren()) do
				if b:IsA("TextButton") then b.BackgroundColor3 = theme.bg end
			end
			TabFrame.Visible = true
			TabButton.BackgroundColor3 = theme.accent
		end)

		local Tab = {}
		function Tab:CreateButton(text, callback)
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1,-10,0,30)
			Btn.Text = text
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 14
			Btn.BackgroundColor3 = theme.bg
			Btn.BackgroundTransparency = theme.transparency
			Btn.TextColor3 = theme.text
			Btn.Parent = TabFrame
			Btn.MouseButton1Click:Connect(function()
				Btn.BackgroundColor3 = theme.accent
				task.delay(0.2,function() Btn.BackgroundColor3 = theme.bg end)
				if callback then callback() end
			end)
			return Btn
		end

		function Tab:CreateToggle(text, callback)
			local state = false
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1,-10,0,30)
			Btn.Text = text
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 14
			Btn.BackgroundColor3 = theme.bg
			Btn.BackgroundTransparency = theme.transparency
			Btn.TextColor3 = theme.text
			Btn.Parent = TabFrame

			local Toggle = {}
			function Toggle:Set(value)
				state = value
				Btn.BackgroundColor3 = state and theme.accent or theme.bg
				if callback then callback(state) end
			end
			function Toggle:Get()
				return state
			end
			Btn.MouseButton1Click:Connect(function()
				Toggle:Set(not state)
			end)
			return Toggle
		end

		function Tab:CreateSlider(text, min, max, callback)
			local value = min
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1,-10,0,40)
			Frame.BackgroundTransparency = 1
			Frame.Parent = TabFrame
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1,0,1,0)
			Btn.Text = text..": "..value
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 14
			Btn.BackgroundColor3 = theme.bg
			Btn.BackgroundTransparency = theme.transparency
			Btn.TextColor3 = theme.text
			Btn.Parent = Frame
			local dragging = false
			Btn.InputBegan:Connect(function(input)
				if input.UserInputType.Name:find("Mouse") or input.UserInputType.Name == "Touch" then dragging = true end
			end)
			UIS.InputEnded:Connect(function() dragging = false end)
			UIS.InputChanged:Connect(function(input)
				if dragging then
					local percent = math.clamp((input.Position.X - Btn.AbsolutePosition.X)/Btn.AbsoluteSize.X,0,1)
					value = math.floor(min + (max-min)*percent)
					Btn.Text = text..": "..value
					if callback then callback(value) end
				end
			end)
			return Frame
		end

		function Tab:CreateDropdown(text, list, callback)
			local open = false
			local MainBtn = Instance.new("TextButton")
			MainBtn.Size = UDim2.new(1,-10,0,30)
			MainBtn.Text = text
			MainBtn.Font = Enum.Font.Gotham
			MainBtn.TextSize = 14
			MainBtn.BackgroundColor3 = theme.bg
			MainBtn.BackgroundTransparency = theme.transparency
			MainBtn.TextColor3 = theme.text
			MainBtn.Parent = TabFrame

			local DropFrame = Instance.new("Frame")
			DropFrame.Size = UDim2.new(1,-10,0,0)
			DropFrame.ClipsDescendants = true
			DropFrame.BackgroundTransparency = 1
			DropFrame.Parent = TabFrame

			local Layout = Instance.new("UIListLayout")
			Layout.Parent = DropFrame

			for _,v in pairs(list) do
				local Item = Instance.new("TextButton")
				Item.Size = UDim2.new(1,0,0,30)
				Item.Text = v
				Item.Font = Enum.Font.Gotham
				Item.TextSize = 14
				Item.BackgroundColor3 = theme.bg
				Item.BackgroundTransparency = theme.transparency
				Item.TextColor3 = theme.text
				Item.Parent = DropFrame

				Item.MouseButton1Click:Connect(function()
					if callback then callback(v) end
				end)
			end

			MainBtn.MouseButton1Click:Connect(function()
				open = not open
				DropFrame.Size = open and UDim2.new(1,-10,0,#list*30) or UDim2.new(1,-10,0,0)
			end)

			return DropFrame
		end

		if not Container:FindFirstChildWhichIsA("ScrollingFrame").Visible then
			TabFrame.Visible = true
			TabButton.BackgroundColor3 = theme.accent
		end

		return Tab
	end

	Lib.Windows[#Lib.Windows+1] = Window
	return Window
end

return Lib
