local S = Instance.new("ScreenGui")
S.Name = "GrandpaESPMenu"
S.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
S.ResetOnSpawn = false

local M = Instance.new("Frame")
M.Size = UDim2.new(0, 200, 0, 160) -- Сделал компактнее, так как убрали лишний ввод
M.Position = UDim2.new(0.3, 0, 0.1, 0) -- Сдвинуто правее основного меню
M.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
M.Active = true
M.Draggable = true
M.Parent = S

local T = Instance.new("TextLabel")
T.Size = UDim2.new(1, 0, 0, 30)
T.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
T.Text = "Rostov ESP (L Key)"
T.TextColor3 = Color3.fromRGB(255, 255, 255)
T.Parent = M

local p = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local ps = game:GetService("Players")

local esp, skel = false, false
local aCol = Color3.fromRGB(0, 255, 0) -- Союзники (Зеленый)
local eCol = Color3.fromRGB(255, 0, 0) -- Враги (Красный)
local scriptActive = true

local function clearEsp()
    for _, pl in ipairs(ps:GetPlayers()) do
        if pl.Character then 
            local f = pl.Character:FindFirstChild("GrandpaESP") 
            if f then f:Destroy() end 
        end
    end
end

local function createTgl(name, y, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = M
    local en = false
    btn.MouseButton1Click:Connect(function()
        en = not en
        btn.Text = en and name .. ": ON" or name .. ": OFF"
        btn.BackgroundColor3 = en and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(100, 50, 50)
        cb(en)
    end)
end

createTgl("Advanced 3D ESP", 50, function(s) esp = s if not s then clearEsp() end end)
createTgl("Show Skeletons", 90, function(s) skel = s if not s then clearEsp() end end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = M
CloseBtn.MouseButton1Click:Connect(function()
    scriptActive = false esp = false skel = false
    clearEsp()
    S:Destroy()
end)

-- Детекция скрытия именно на клавишу L [1, 2]
uis.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.L then
        M.Visible = not M.Visible
    end
end)

local function drawBone(pChar, folder, partA, partB, color) 
    local a, b = pChar:FindFirstChild(partA), pChar:FindFirstChild(partB)
    if a and b then 
        local line = folder:FindFirstChild(partA .. "_" .. partB) or Instance.new("LineHandleAdornment")
        line.Name = partA .. "_" .. partB 
        line.Length = (a.Position - b.Position).Magnitude 
        line.CFrame = CFrame.lookAt(a.Position, b.Position) 
        line.Color3 = color 
        line.AlwaysOnTop = true 
        line.Thickness = 2 
        line.ZIndex = 4 
        line.Adornee = a 
        line.Parent = folder 
    end 
end

game:GetService("RunService").Heartbeat:Connect(function()
    if not scriptActive then return end
    pcall(function()
        if esp or skel then
            for _, pl in ipairs(ps:GetPlayers()) do
                if pl ~= p and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") and pl.Character:FindFirstChildOfClass("Humanoid") then
                    local pChar = pl.Character 
                    local pHum = pChar:FindFirstChildOfClass("Humanoid") 
                    local root = pChar.HumanoidRootPart
                    local isAlly = (pl.Team == p.Team and p.Team ~= nil) 
                    local color = isAlly and aCol or eCol
                    local folder = pChar:FindFirstChild("GrandpaESP") or Instance.new("Folder", pChar) 
                    folder.Name = "GrandpaESP"
                    
                    if esp then 
                        local box = folder:FindFirstChild("3DBox") or Instance.new("BoxHandleAdornment", folder) 
                        box.Name = "3DBox" box.Size = pChar:GetExtentsSize() + Vector3.new(0.2, 0.2, 0.2) box.AlwaysOnTop = true box.ZIndex = 3 box.Color3 = color box.Adornee = pChar box.Transparency = 0.6
                        local dist = math.floor((p.Character and p.Character:FindFirstChild("HumanoidRootPart") and (p.Character.HumanoidRootPart.Position - root.Position).Magnitude) or 0)
                        local tag = folder:FindFirstChild("ESPTag") or Instance.new("BillboardGui", folder) 
                        tag.Name = "ESPTag" tag.Size = UDim2.new(0, 200, 0, 50) tag.AlwaysOnTop = true tag.ExtentsOffset = Vector3.new(0, 3, 0) tag.Adornee = root
                        local txt = tag:FindFirstChild("ESPText") or Instance.new("TextLabel", tag) 
                        txt.Name = "ESPText" txt.BackgroundTransparency = 1 txt.Size = UDim2.new(1, 0, 1, 0) txt.Font = Enum.Font.SourceSansBold txt.TextSize = 14 txt.TextColor3 = color txt.TextStrokeTransparency = 0 txt.Text = string.format("%s\nHP: %d | Dist: %d", pl.Name, math.floor(pHum.Health), dist)
                    else 
                        local b = folder:FindFirstChild("3DBox") if b then b:Destroy() end 
                        local t = folder:FindFirstChild("ESPTag") if t then t:Destroy() end 
                    end
                    
                    if skel then
                        if pChar:FindFirstChild("Left Upper Leg") then
                            drawBone(pChar, folder, "Head", "UpperTorso", color) drawBone(pChar, folder, "UpperTorso", "LowerTorso", color) drawBone(pChar, folder, "UpperTorso", "LeftUpperArm", color) drawBone(pChar, folder, "LeftUpperArm", "LeftLowerArm", color) drawBone(pChar, folder, "UpperTorso", "RightUpperArm", color) drawBone(pChar, folder, "RightUpperArm", "RightLowerArm", color) drawBone(pChar, folder, "LowerTorso", "LeftUpperLeg", color) drawBone(pChar, folder, "LeftUpperLeg", "LeftLowerLeg", color) drawBone(pChar, folder, "LowerTorso", "RightUpperLeg", color) drawBone(pChar, folder, "RightUpperLeg", "RightLowerLeg", color)
                        else
                            drawBone(pChar, folder, "Head", "Torso", color) drawBone(pChar, folder, "Torso", "Left Arm", color) drawBone(pChar, folder, "Torso", "Right Arm", color) drawBone(pChar, folder, "Torso", "Left Leg", color) drawBone(pChar, folder, "Torso", "Right Leg", color)
                        end
                    else
                        for _, item in ipairs(folder:GetChildren()) do if item:IsA("LineHandleAdornment") then item:Destroy() end end
                    end
                end
            end
        end
    end)
end)
