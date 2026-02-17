local SuperClassicLib = {}
SuperClassicLib.__index = SuperClassicLib

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Funções Utilitárias Internas
local function CreateCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UDim.new(0, 8)
	corner.Parent = parent
end

-- Criar a Janela Principal
function SuperClassicLib.new(libName)
	local self = setmetatable({}, SuperClassicLib)
	
	-- GUI Base
	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "SuperClassic_" .. (libName or "Lib")
	self.ScreenGui.Parent = game:GetService("CoreGui") -- Para não sumir ao morrer
	self.ScreenGui.ResetOnSpawn = false

	-- Frame Principal
	self.Main = Instance.new("Frame")
	self.Main.Size = UDim2.new(0, 500, 0, 350)
	self.Main.Position = UDim2.new(0.5, -250, 0.5, -175)
	self.Main.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
	self.Main.BorderSizePixel = 0
	self.Main.Parent = self.ScreenGui
	self.Main.ClipsDescendants = true
	CreateCorner(self.Main, UDim.new(0, 12))

	-- Barra de Topo (Arraste)
	self.TopBar = Instance.new("Frame")
	self.TopBar.Size = UDim2.new(1, 0, 0, 40)
	self.TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.TopBar.Parent = self.Main
	
	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -20, 1, 0)
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.Text = libName or "Super Classic Lib"
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 16
	Title.TextColor3 = Color3.fromRGB(40, 40, 40)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.BackgroundTransparency = 1
	Title.Parent = self.TopBar

	-- Sidebar (Abas)
	self.Sidebar = Instance.new("Frame")
	self.Sidebar.Size = UDim2.new(0, 130, 1, -40)
	self.Sidebar.Position = UDim2.new(0, 0, 0, 40)
	self.Sidebar.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
	self.Sidebar.BorderSizePixel = 0
	self.Sidebar.Parent = self.Main

	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Parent = self.Sidebar
	SideLayout.Padding = UDim.new(0, 5)
	SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	-- Container de Conteúdo
	self.PageContainer = Instance.new("Frame")
	self.PageContainer.Size = UDim2.new(1, -140, 1, -50)
	self.PageContainer.Position = UDim2.new(0, 135, 0, 45)
	self.PageContainer.BackgroundTransparency = 1
	self.PageContainer.Parent = self.Main

	-- Arrastar Menu
	local dragging, dragInput, dragStart, startPos
	self.TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; dragStart = input.Position; startPos = self.Main.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	return self
end

-- Criar Aba
function SuperClassicLib:CreateTab(tabName)
	local TabBtn = Instance.new("TextButton")
	TabBtn.Size = UDim2.new(0, 115, 0, 35)
	TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabBtn.Text = tabName
	TabBtn.Font = Enum.Font.GothamMedium
	TabBtn.TextSize = 13
	TabBtn.Parent = self.Sidebar
	CreateCorner(TabBtn, UDim.new(0, 6))

	local Page = Instance.new("ScrollingFrame")
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.ScrollBarThickness = 2
	Page.CanvasSize = UDim2.new(0, 0, 0, 0)
	Page.Parent = self.PageContainer

	local PageLayout = Instance.new("UIListLayout")
	PageLayout.Parent = Page
	PageLayout.Padding = UDim.new(0, 8)
	PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

	PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
	end)

	TabBtn.MouseButton1Click:Connect(function()
		for _, v in pairs(self.Sidebar:GetChildren()) do
			if v:IsA("TextButton") then
				TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255,255,255), TextColor3 = Color3.new(0,0,0)}):Play()
			end
		end
		for _, v in pairs(self.PageContainer:GetChildren()) do v.Visible = false end
		
		TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 122, 255), TextColor3 = Color3.new(1,1,1)}):Play()
		Page.Visible = true
	end)

	local Elements = {}

	-- Botão Normal (Pisca Azul)
	function Elements:AddButton(text, callback)
		local Btn = Instance.new("TextButton")
		Btn.Size = UDim2.new(1, -10, 0, 35)
		Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Btn.Text = text
		Btn.Font = Enum.Font.Gotham
		Btn.TextSize = 14
		Btn.Parent = Page
		CreateCorner(Btn)

		Btn.MouseButton1Click:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 122, 255), TextColor3 = Color3.new(1,1,1)}):Play()
			task.wait(0.1)
			TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255), TextColor3 = Color3.new(0,0,0)}):Play()
			callback()
		end)
	end

	-- Toggle iOS Style
	function Elements:AddToggle(text, callback)
		local TFrame = Instance.new("Frame")
		TFrame.Size = UDim2.new(1, -10, 0, 40)
		TFrame.BackgroundColor3 = Color3.new(1, 1, 1)
		TFrame.Parent = Page
		CreateCorner(TFrame)

		local TLbl = Instance.new("TextLabel")
		TLbl.Size = UDim2.new(1, -60, 1, 0)
		TLbl.Position = UDim2.new(0, 10, 0, 0)
		TLbl.Text = text
		TLbl.BackgroundTransparency = 1
		TLbl.Font = Enum.Font.Gotham
		TLbl.TextXAlignment = Enum.TextXAlignment.Left
		TLbl.Parent = TFrame

		local Switch = Instance.new("TextButton")
		Switch.Size = UDim2.new(0, 44, 0, 22)
		Switch.Position = UDim2.new(1, -50, 0.5, -11)
		Switch.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
		Switch.Text = ""
		Switch.Parent = TFrame
		CreateCorner(Switch, UDim.new(1, 0))

		local Dot = Instance.new("Frame")
		Dot.Size = UDim2.new(0, 18, 0, 18)
		Dot.Position = UDim2.new(0, 2, 0.5, -9)
		Dot.BackgroundColor3 = Color3.new(1, 1, 1)
		Dot.Parent = Switch
		CreateCorner(Dot, UDim.new(1, 0))

		local toggled = false
		Switch.MouseButton1Click:Connect(function()
			toggled = not toggled
			local color = toggled and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(200, 200, 200)
			local pos = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
			TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
			TweenService:Create(Dot, TweenInfo.new(0.2), {Position = pos}):Play()
			callback(toggled)
		end)
	end

	-- Slider
	function Elements:AddSlider(text, min, max, callback)
		local SFrame = Instance.new("Frame")
		SFrame.Size = UDim2.new(1, -10, 0, 50)
		SFrame.BackgroundColor3 = Color3.new(1, 1, 1)
		SFrame.Parent = Page
		CreateCorner(SFrame)

		local SLbl = Instance.new("TextLabel")
		SLbl.Size = UDim2.new(1, -20, 0, 20)
		SLbl.Position = UDim2.new(0, 10, 0, 5)
		SLbl.Text = text .. ": " .. min
		SLbl.Font = Enum.Font.Gotham
		SLbl.BackgroundTransparency = 1
		SLbl.TextXAlignment = Enum.TextXAlignment.Left
		SLbl.Parent = SFrame

		local Bar = Instance.new("Frame")
		Bar.Size = UDim2.new(1, -20, 0, 6)
		Bar.Position = UDim2.new(0, 10, 0, 35)
		Bar.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
		Bar.Parent = SFrame
		CreateCorner(Bar)

		local Fill = Instance.new("Frame")
		Fill.Size = UDim2.new(0, 0, 1, 0)
		Fill.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
		Fill.Parent = Bar
		CreateCorner(Fill)

		local sliding = false
		local function update()
			local pos = math.clamp((Mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
			Fill.Size = UDim2.new(pos, 0, 1, 0)
			local value = math.floor(min + (max - min) * pos)
			SLbl.Text = text .. ": " .. value
			callback(value)
		end

		Bar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true update() end
		end)
		UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
		end)
		UIS.InputChanged:Connect(function(input)
			if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then update() end
		end)
	end

	return Elements
end

return SuperClassicLib
