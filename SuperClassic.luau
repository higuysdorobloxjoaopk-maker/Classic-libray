local SuperClassicLib = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Função auxiliar para arrastar a GUI
local function MakeDraggable(topBar, mainFrame)
	local dragging, dragStart, startPos
	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

function SuperClassicLib:CreateWindow(name, customPos)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "SuperClassic_" .. name
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Size = UDim2.new(0, 480, 0, 320)
	Main.Position = customPos or UDim2.new(0.5, -240, 0.5, -160)
	Main.BackgroundColor3 = Color3.new(1, 1, 1)
	Main.BackgroundTransparency = 0.75
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Parent = ScreenGui

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 30)
	TopBar.BackgroundColor3 = Color3.new(1, 1, 1)
	TopBar.BackgroundTransparency = 0.75
	TopBar.BorderSizePixel = 0
	TopBar.Parent = Main

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -60, 1, 0)
	Title.Position = UDim2.new(0, 10, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = name:upper()
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 13
	Title.TextColor3 = Color3.new(0, 0, 0)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TopBar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 30, 1, 0)
	CloseBtn.Position = UDim2.new(1, -30, 0, 0)
	CloseBtn.Text = "X"
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextColor3 = Color3.new(0,0,0)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Parent = TopBar
	CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 110, 1, -30)
	Sidebar.Position = UDim2.new(0, 0, 0, 30)
	Sidebar.BackgroundColor3 = Color3.new(1, 1, 1)
	Sidebar.BackgroundTransparency = 0.85
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = Main

	local SidebarLayout = Instance.new("UIListLayout")
	SidebarLayout.Parent = Sidebar
	SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.Size = UDim2.new(1, -120, 1, -40)
	Container.Position = UDim2.new(0, 115, 0, 35)
	Container.BackgroundTransparency = 1
	Container.Parent = Main

	MakeDraggable(TopBar, Main)

	local Tabs = { ActiveTab = nil }

	function Tabs:CreateTab(tabName)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, 0, 0, 35)
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = tabName
		TabBtn.Font = Enum.Font.Gotham
		TabBtn.TextSize = 12
		TabBtn.TextColor3 = Color3.new(0, 0, 0)
		TabBtn.BorderSizePixel = 0
		TabBtn.Parent = Sidebar

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.Parent = Container

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Parent = Page
		PageLayout.Padding = UDim.new(0, 5)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
		end)

		TabBtn.MouseButton1Click:Connect(function()
			for _, v in pairs(Container:GetChildren()) do v.Visible = false end
			for _, v in pairs(Sidebar:GetChildren()) do 
				if v:IsA("TextButton") then 
					TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 1, BackgroundColor3 = Color3.new(1,1,1)}):Play()
				end 
			end
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.4, BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
		end)

		if not Tabs.ActiveTab then
			Page.Visible = true
			TabBtn.BackgroundTransparency = 0.4
			TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
			Tabs.ActiveTab = tabName
		end

		local Sections = {}

		function Sections:CreateSection(secName)
			local SectionFrame = Instance.new("Frame")
			SectionFrame.Size = UDim2.new(1, -5, 0, 30)
			SectionFrame.BackgroundColor3 = Color3.new(1,1,1)
			SectionFrame.BackgroundTransparency = 0.9
			SectionFrame.ClipsDescendants = true
			SectionFrame.Parent = Page

			local SecBtn = Instance.new("TextButton")
			SecBtn.Size = UDim2.new(1, 0, 0, 30)
			SecBtn.BackgroundTransparency = 1
			SecBtn.Text = "  [+] " .. secName
			SecBtn.Font = Enum.Font.GothamBold
			SecBtn.TextSize = 12
			SecBtn.TextColor3 = Color3.fromRGB(0, 100, 200)
			SecBtn.TextXAlignment = Enum.TextXAlignment.Left
			SecBtn.Parent = SectionFrame

			local SecContent = Instance.new("Frame")
			SecContent.Position = UDim2.new(0, 0, 0, 30)
			SecContent.Size = UDim2.new(1, 0, 0, 0)
			SecContent.BackgroundTransparency = 1
			SecContent.Parent = SectionFrame

			local SecLayout = Instance.new("UIListLayout")
			SecLayout.Parent = SecContent
			SecLayout.Padding = UDim.new(0, 5)
			SecLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

			local isOpen = false
			SecBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetHeight = isOpen and (SecLayout.AbsoluteContentSize.Y + 35) or 30
				TweenService:Create(SectionFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -5, 0, targetHeight)}):Play()
				SecBtn.Text = isOpen and "  [-] " .. secName or "  [+] " .. secName
			end)

			local Elements = {}

			-- Botão que pisca azul (Free Button)
			function Elements:CreateButton(text, callback)
				local Btn = Instance.new("TextButton")
				Btn.Size = UDim2.new(0.95, 0, 0, 28)
				Btn.BackgroundColor3 = Color3.new(1, 1, 1)
				Btn.BackgroundTransparency = 0.6
				Btn.Text = text
				Btn.Font = Enum.Font.Gotham
				Btn.TextSize = 12
				Btn.TextColor3 = Color3.new(0, 0, 0)
				Btn.Parent = SecContent

				Btn.MouseButton1Click:Connect(function()
					local oldColor = Btn.BackgroundColor3
					Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
					task.wait(0.15)
					Btn.BackgroundColor3 = oldColor
					callback()
				end)
			end

			-- Toggle (Fica azul quando ativo)
			function Elements:CreateToggle(text, callback)
				local TglFrame = Instance.new("Frame")
				TglFrame.Size = UDim2.new(0.95, 0, 0, 28)
				TglFrame.BackgroundTransparency = 1
				TglFrame.Parent = SecContent

				local TglBtn = Instance.new("TextButton")
				TglBtn.Size = UDim2.new(0, 45, 0, 22)
				TglBtn.Position = UDim2.new(0, 5, 0.5, -11)
				TglBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
				TglBtn.Text = ""
				TglBtn.BorderSizePixel = 0
				TglBtn.Parent = TglFrame

				local Ball = Instance.new("Frame")
				Ball.Size = UDim2.new(0, 18, 0, 18)
				Ball.Position = UDim2.new(0, 2, 0.5, -9)
				Ball.BackgroundColor3 = Color3.new(1, 1, 1)
				Ball.BorderSizePixel = 0
				Ball.Parent = TglBtn

				local Lbl = Instance.new("TextLabel")
				Lbl.Position = UDim2.new(0, 55, 0, 0)
				Lbl.Size = UDim2.new(1, -55, 1, 0)
				Lbl.BackgroundTransparency = 1
				Lbl.Text = text
				Lbl.Font = Enum.Font.Gotham
				Lbl.TextSize = 12
				Lbl.TextColor3 = Color3.new(0,0,0)
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Lbl.Parent = TglFrame

				local active = false
				TglBtn.MouseButton1Click:Connect(function()
					active = not active
					TweenService:Create(TglBtn, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(200, 200, 200)}):Play()
					TweenService:Create(Ball, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
					callback(active)
				end)
			end

			-- Slider
			function Elements:CreateSlider(text, min, max, default, callback)
				local SldFrame = Instance.new("Frame")
				SldFrame.Size = UDim2.new(0.95, 0, 0, 45)
				SldFrame.BackgroundTransparency = 1
				SldFrame.Parent = SecContent

				local Lbl = Instance.new("TextLabel")
				Lbl.Size = UDim2.new(1, 0, 0, 20)
				Lbl.BackgroundTransparency = 1
				Lbl.Text = text .. ": " .. default
				Lbl.Font = Enum.Font.Gotham
				Lbl.TextSize = 11
				Lbl.TextColor3 = Color3.new(0,0,0)
				Lbl.Parent = SldFrame

				local BarBG = Instance.new("Frame")
				BarBG.Size = UDim2.new(0.9, 0, 0, 6)
				BarBG.Position = UDim2.new(0.05, 0, 0, 28)
				BarBG.BackgroundColor3 = Color3.fromRGB(200,200,200)
				BarBG.BorderSizePixel = 0
				BarBG.Parent = SldFrame

				local Fill = Instance.new("Frame")
				Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
				Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
				Fill.BorderSizePixel = 0
				Fill.Parent = BarBG

				local function Update(input)
					local pos = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
					local val = math.floor(min + (max - min) * pos)
					Fill.Size = UDim2.new(pos, 0, 1, 0)
					Lbl.Text = text .. ": " .. val
					callback(val)
				end

				local sliding = false
				SldFrame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
				end)
			end

			return Elements
		end
		return Sections
	end
	return Tabs
end

return SuperClassicLib
