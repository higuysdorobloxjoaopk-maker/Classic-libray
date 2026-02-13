local library = {}
local windowCount = 0
local sizes = {}
local listOffset = {}
local windows = {}
local pastSliders = {}
local dropdowns = {}
local dropdownSizes = {}
local destroyed

local colorPickers = {}

if game.CoreGui:FindFirstChild('TurtleUiLib') then
    game.CoreGui:FindFirstChild('TurtleUiLib'):Destroy()
    destroyed = true
end

function Lerp(a, b, c)
    return a + ((b - a) * c)
end

local players = game:service('Players');
local player = players.LocalPlayer;
local mouse = player:GetMouse();
local run = game:service('RunService');
local stepped = run.Stepped;

function Dragify(obj)
	spawn(function()
		local minitial;
		local initial;
		local isdragging;
	    obj.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				isdragging = true;
				minitial = input.Position;
				initial = obj.Position;
				local con;
                con = stepped:Connect(function()
        			if isdragging then
						local delta = Vector3.new(mouse.X, mouse.Y, 0) - minitial;
						obj.Position = UDim2.new(initial.X.Scale, initial.X.Offset + delta.X, initial.Y.Scale, initial.Y.Offset + delta.Y);
					else
						con:Disconnect();
					end;
                end);
                input.Changed:Connect(function()
    			    if input.UserInputState == Enum.UserInputState.End then
					    isdragging = false;
				    end;
			    end);
		end;
	end);
end)
end

local function protect_gui(obj) 
    if destroyed then
       obj.Parent = game.CoreGui
       return
    end
    if syn and syn.protect_gui then
        syn.protect_gui(obj)
        obj.Parent = game.CoreGui
    elseif PROTOSMASHER_LOADED then
        obj.Parent = get_hidden_gui()
    else
        obj.Parent = game.CoreGui
    end
end

local TurtleUiLib = Instance.new("ScreenGui")
TurtleUiLib.Name = "TurtleUiLib"
protect_gui(TurtleUiLib)

local xOffset = 20
local uis = game:GetService("UserInputService")
local keybindConnection

function library:Destroy()
    TurtleUiLib:Destroy()
    if keybindConnection then
        keybindConnection:Disconnect()
    end
end

function library:Hide()
   TurtleUiLib.Enabled = not TurtleUiLib.Enabled
end	

function library:Keybind(key)
    if keybindConnection then keybindConnection:Disconnect() end
    keybindConnection = uis.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode[key] then
            TurtleUiLib.Enabled = not TurtleUiLib.Enabled
        end
    end)
end

function library:Window(name) 
    windowCount = windowCount + 1
    local winCount = windowCount
    local zindex = winCount * 7
    local UiWindow = Instance.new("Frame")

    UiWindow.Name = "UiWindow"
    UiWindow.Parent = TurtleUiLib
    UiWindow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UiWindow.BackgroundTransparency = 0.5 -- Top bar transparência solicitada
    UiWindow.BorderSizePixel = 0
    UiWindow.Position = UDim2.new(0, xOffset, 0, 20)
    UiWindow.Size = UDim2.new(0, 207, 0, 33)
    UiWindow.ZIndex = 4 + zindex
    UiWindow.Active = true
    Dragify(UiWindow)

    xOffset = xOffset + 230

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = UiWindow
    Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Header.BackgroundTransparency = 0.5
    Header.BorderSizePixel = 0
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.Size = UDim2.new(0, 207, 0, 26)
    Header.ZIndex = 5 + zindex

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Name = "HeaderText"
    HeaderText.Parent = Header
    HeaderText.BackgroundTransparency = 1.000
    HeaderText.Position = UDim2.new(0, 5, 0, 0)
    HeaderText.Size = UDim2.new(0, 150, 0, 26)
    HeaderText.ZIndex = 6 + zindex
    HeaderText.Font = Enum.Font.SourceSansBold
    HeaderText.Text = name or "Window"
    HeaderText.TextColor3 = Color3.fromRGB(0, 0, 0)
    HeaderText.TextSize = 17.000
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left

    -- Botão de Minimizar
    local Minimise = Instance.new("TextButton")
    Minimise.Name = "Minimise"
    Minimise.Parent = Header
    Minimise.BackgroundTransparency = 1
    Minimise.Position = UDim2.new(0, 160, 0, 2)
    Minimise.Size = UDim2.new(0, 22, 0, 22)
    Minimise.ZIndex = 7 + zindex
    Minimise.Font = Enum.Font.SourceSansBold
    Minimise.Text = "-"
    Minimise.TextColor3 = Color3.fromRGB(0, 0, 0)
    Minimise.TextSize = 20.000

    -- Botão de Fechar (X) solicitado
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = Header
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(0, 182, 0, 2)
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.ZIndex = 7 + zindex
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
    CloseBtn.TextSize = 18.000
    CloseBtn.MouseButton1Up:Connect(function()
        TurtleUiLib:Destroy()
    end)

    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.Parent = Header
    Window.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Window.BackgroundTransparency = 0.75 -- Fundo transparência solicitada
    Window.BorderSizePixel = 0
    Window.Position = UDim2.new(0, 0, 0, 26)
    Window.Size = UDim2.new(0, 207, 0, 33)
    Window.ZIndex = 1 + zindex

    Minimise.MouseButton1Up:connect(function()
        Window.Visible = not Window.Visible
        Minimise.Text = Window.Visible and "-" or "+"
    end)

    local functions = {}
    functions.__index = functions
    functions.Ui = UiWindow

    sizes[winCount] = 0
    listOffset[winCount] = 0

    function functions:Button(name, callback)
        local callback = callback or function() end
        sizes[winCount] = sizes[winCount] + 32
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)
        
        local Button = Instance.new("TextButton")
        listOffset[winCount] = listOffset[winCount] + 32
        Button.Name = "Button"
        Button.Parent = Window
        Button.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        Button.BorderColor3 = Color3.fromRGB(200, 200, 200)
        Button.Position = UDim2.new(0, 12, 0, listOffset[winCount] - 25)
        Button.Size = UDim2.new(0, 182, 0, 26)
        Button.ZIndex = 2 + zindex
        Button.Font = Enum.Font.SourceSans
        Button.TextColor3 = Color3.fromRGB(0, 0, 0)
        Button.TextSize = 16.000
        Button.Text = name or "Button"
        Button.MouseButton1Down:Connect(callback)
    end

    function functions:Toggle(text, on, callback)
        local callback = callback or function() end
        sizes[winCount] = sizes[winCount] + 32
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)
        listOffset[winCount] = listOffset[winCount] + 32

        local ToggleDescription = Instance.new("TextLabel")
        local ToggleButton = Instance.new("TextButton")
        local ToggleFiller = Instance.new("Frame")

        ToggleDescription.Name = "ToggleDescription"
        ToggleDescription.Parent = Window
        ToggleDescription.BackgroundTransparency = 1.000
        ToggleDescription.Position = UDim2.new(0, 14, 0, listOffset[winCount] - 25)
        ToggleDescription.Size = UDim2.new(0, 131, 0, 26)
        ToggleDescription.Font = Enum.Font.SourceSans
        ToggleDescription.Text = text or "Toggle"
        ToggleDescription.TextColor3 = Color3.fromRGB(0, 0, 0)
        ToggleDescription.TextSize = 16.000
        ToggleDescription.TextXAlignment = Enum.TextXAlignment.Left
        ToggleDescription.ZIndex = 2 + zindex

        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleDescription
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.BorderColor3 = Color3.fromRGB(150, 150, 150)
        ToggleButton.Position = UDim2.new(1.2, 0, 0.1, 0)
        ToggleButton.Size = UDim2.new(0, 22, 0, 22)
        ToggleButton.Text = ""
        ToggleButton.ZIndex = 2 + zindex

        ToggleFiller.Name = "ToggleFiller"
        ToggleFiller.Parent = ToggleButton
        ToggleFiller.BackgroundColor3 = Color3.fromRGB(68, 189, 50)
        ToggleFiller.BorderSizePixel = 0
        ToggleFiller.Position = UDim2.new(0, 4, 0, 4)
        ToggleFiller.Size = UDim2.new(0, 14, 0, 14)
        ToggleFiller.Visible = on
        ToggleFiller.ZIndex = 3 + zindex

        local function toggle()
            ToggleFiller.Visible = not ToggleFiller.Visible
            callback(ToggleFiller.Visible)
        end

        ToggleButton.MouseButton1Up:Connect(toggle)

        -- Função para definir via script solicitada
        local toggleFuncs = {}
        function toggleFuncs:Set(state)
            ToggleFiller.Visible = state
            callback(state)
        end
        return toggleFuncs
    end

    function functions:Label(text)
        sizes[winCount] = sizes[winCount] + 32
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)
        listOffset[winCount] = listOffset[winCount] + 32
        
        local Label = Instance.new("TextLabel")
        Label.Parent = Window
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 0, 0, listOffset[winCount] - 25)
        Label.Size = UDim2.new(0, 207, 0, 26)
        Label.Font = Enum.Font.SourceSans
        Label.TextColor3 = Color3.fromRGB(0, 0, 0)
        Label.Text = text or "Label"
        Label.TextSize = 16.000
        Label.ZIndex = 2 + zindex
    end

    function functions:Box(text, callback)
        local callback = callback or function() end
        sizes[winCount] = sizes[winCount] + 32
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)
        listOffset[winCount] = listOffset[winCount] + 32

        local TextBox = Instance.new("TextBox")
        TextBox.Parent = Window
        TextBox.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        TextBox.Position = UDim2.new(0, 99, 0, listOffset[winCount] - 25)
        TextBox.Size = UDim2.new(0, 95, 0, 26)
        TextBox.Font = Enum.Font.SourceSans
        TextBox.PlaceholderText = "..."
        TextBox.Text = ""
        TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
        TextBox.ZIndex = 2 + zindex
        
        TextBox.FocusLost:Connect(function()
            callback(TextBox.Text)
        end)
    end

    return functions
end

return library
