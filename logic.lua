local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrandpaWill"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 280)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Rostov Mega Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

local p = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local ij, nc, ctp = false, false, false
local speed, jump = 16, 50

local function createInp(ph, dv, y, cb)
    local con = Instance.new("Frame")
    con.Size = UDim2.new(0, 180, 0, 30)
    con.Position = UDim2.new(0, 10, 0, y)
    con.BackgroundTransparency = 1
    con.Parent = MainFrame
    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(0, 110, 1, 0)
    tb.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    tb.Text = tostring(dv)
    tb.PlaceholderText = ph
    tb.TextColor3 = Color3.fromRGB(255, 255, 255)
    tb.Parent = con
    local ok = Instance.new("TextButton")
    ok.Size = UDim2.new(0, 60, 1, 0)
    ok.Position = UDim2.new(0, 120, 0, 0)
    ok.BackgroundColor3 = Color3.fromRGB(40, 100, 160)
    ok.Text = "OKAY"
    ok.TextColor3 = Color3.fromRGB(255, 255, 255)
    ok.Parent = con
    ok.MouseButton1Click:Connect(function()
        local n = tonumber(tb.Text)
        if n then cb(n) end
    end)
end

local function createTgl(name, y, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = MainFrame
    local en = false
    btn.MouseButton1Click:Connect(function()
        en = not en
        btn.Text = en and name .. ": ON" or name .. ": OFF"
        btn.BackgroundColor3 = en and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(100, 50, 50)
        cb(en)
    end)
end

createInp("Speed", speed, 40, function(v) speed = v end)
createInp("Jump", jump, 80, function(v) jump = v end)

createTgl("Inf Jump", 120, function(s) ij = s end)
createTgl("Noclip", 160, function(s) nc = s end)
createTgl("Ctrl + Click TP", 200, function(s) ctp = s end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    ij = false nc = false ctp = false
    pcall(function() p.Character.Humanoid.WalkSpeed = 16 end)
    ScreenGui:Destroy()
end)

uis.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
    if not gpe and ctp and input.UserInputType == Enum.UserInputType.MouseButton1 and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = p:GetMouse()
        if mouse and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p) + Vector3.new(0, 3, 0)
        end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.WalkSpeed = speed
            if p.Character.Humanoid.UseJumpPower then
                p.Character.Humanoid.JumpPower = jump
            else
                p.Character.Humanoid.JumpHeight = jump / 3.5
            end
            if nc then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)
end)

uis.JumpRequest:Connect(function()
    if ij and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
        p.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
