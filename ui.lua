if not game:IsLoaded() then game.Loaded:Wait() end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "GrandpaMegaMenu"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 420)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BorderSizePixel = 0

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Rostov God Menu v7"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(160, 45, 45)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.BorderSizePixel = 0

ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -45)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 520)
ScrollingFrame.ScrollBarThickness = 6

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

_G.CreateToggle = function(name, callback)
    local button = Instance.new("TextButton")
    button.Parent = ScrollingFrame
    button.Size = UDim2.new(0, 230, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    button.Font = Enum.Font.SourceSans
    button.Text = name .. ": OFF"
    button.TextColor3 = Color3.fromRGB(240, 100, 100)
    button.TextSize = 14
    button.BorderSizePixel = 0
    local enabled = false
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            button.BackgroundColor3 = Color3.fromRGB(70, 110, 70)
            button.TextColor3 = Color3.fromRGB(100, 240, 100)
            button.Text = name .. ": ON"
        else
            button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            button.TextColor3 = Color3.fromRGB(240, 100, 100)
            button.Text = name .. ": OFF"
        end
        callback(enabled)
    end)
end

_G.CreateInput = function(placeholder, defaultValue, callback)
    local container = Instance.new("Frame")
    container.Parent = ScrollingFrame
    container.Size = UDim2.new(0, 230, 0, 32)
    container.BackgroundTransparency = 1
    local textBox = Instance.new("TextBox")
    textBox.Parent = container
    textBox.Size = UDim2.new(0, 150, 1, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    textBox.Font = Enum.Font.SourceSans
    textBox.Text = tostring(defaultValue)
    textBox.PlaceholderText = placeholder
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 14
    textBox.BorderSizePixel = 0
    local okButton = Instance.new("TextButton")
    okButton.Parent = container
    okButton.Position = UDim2.new(0, 160, 0, 0)
    okButton.Size = UDim2.new(0, 70, 1, 0)
    okButton.BackgroundColor3 = Color3.fromRGB(40, 100, 160)
    okButton.Font = Enum.Font.SourceSansBold
    okButton.Text = "OKAY"
    okButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    okButton.TextSize = 12
    okButton.BorderSizePixel = 0
    okButton.MouseButton1Click:Connect(function()
        local num = tonumber(textBox.Text)
        if num then callback(num) end
    end)
end

_G.CreateTpBox = function(callback)
    local tpContainer = Instance.new("Frame")
    tpContainer.Parent = ScrollingFrame
    tpContainer.Size = UDim2.new(0, 230, 0, 32)
    tpContainer.BackgroundTransparency = 1
    local tpTextBox = Instance.new("TextBox")
    tpTextBox.Parent = tpContainer
    tpTextBox.Size = UDim2.new(0, 150, 1, 0)
    tpTextBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    tpTextBox.Font = Enum.Font.SourceSans
    tpTextBox.Text = ""
    tpTextBox.PlaceholderText = "Player Nickname"
    tpTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpTextBox.TextSize = 14
    tpTextBox.BorderSizePixel = 0
    local tpButton = Instance.new("TextButton")
    tpButton.Parent = tpContainer
    tpButton.Position = UDim2.new(0, 160, 0, 0)
    tpButton.Size = UDim2.new(0, 70, 1, 0)
    tpButton.BackgroundColor3 = Color3.fromRGB(120, 60, 160)
    tpButton.Font = Enum.Font.SourceSansBold
    tpButton.Text = "TP"
    tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpButton.TextSize = 12
    tpButton.BorderSizePixel = 0
    tpButton.MouseButton1Click:Connect(function()
        callback(tpTextBox.Text)
    end)
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K and MainFrame then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

_G.CloseMenuSignal = CloseButton.MouseButton1Click
_G.DestroyGui = function() ScreenGui:Destroy() end
