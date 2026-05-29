C.MouseButton1Click:Connect(function()
    act = false 
    ij = false 
    nc = false 
    swf = false 
    esp = false 
    skel = false 
    ClickTp = false 
    oxy = false 
    stopFly() 
    clearEsp()
    pcall(function()
        local char = p.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then 
                hum.WalkSpeed = 16 
                hum.PlatformStand = false 
                if hum.UseJumpPower then 
                    hum.JumpPower = 50 
                else 
                    hum.JumpHeight = 50 / 3.5 
                end 
                hum:ChangeState(Enum.HumanoidStateType.GettingUp) 
            end
            for _, part in ipairs(char:GetDescendants()) do 
                if part:IsA("BasePart") then part.CanCollide = true end 
            end
        end
    end)
    S:Destroy()
end)

local function createToggle(name, cb)
    local btn = Instance.new("TextButton") 
    btn.Parent = SF 
    btn.Size = UDim2.new(0, 230, 0, 32) 
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55) 
    btn.Font = Enum.Font.SourceSans 
    btn.Text = name .. ": OFF" 
    btn.TextColor3 = Color3.fromRGB(240, 100, 100) 
    btn.TextSize = 14 
    btn.BorderSizePixel = 0
    local en = false
    btn.MouseButton1Click:Connect(function()
        en = not en
        if en then 
            btn.BackgroundColor3 = Color3.fromRGB(70, 110, 70) 
            btn.TextColor3 = Color3.fromRGB(100, 240, 100) 
            btn.Text = name .. ": ON" 
        else 
            btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55) 
            btn.TextColor3 = Color3.fromRGB(240, 100, 100) 
            btn.Text = name .. ": OFF" 
        end
        cb(en)
    end)
end

local function createInput(ph, dv, cb)
    local con = Instance.new("Frame") 
    con.Parent = SF 
    con.Size = UDim2.new(0, 230, 0, 32) 
    con.BackgroundTransparency = 1
    local tb = Instance.new("TextBox") 
    tb.Parent = con 
    tb.Size = UDim2.new(0, 150, 1, 0) 
    tb.BackgroundColor3 = Color3.fromRGB(55, 55, 55) 
    tb.Font = Enum.Font.SourceSans 
    tb.Text = tostring(dv) 
    tb.PlaceholderText = ph 
    tb.TextColor3 = Color3.fromRGB(255, 255, 255) 
    tb.TextSize = 14 
    tb.BorderSizePixel = 0
    local ok = Instance.new("TextButton") 
    ok.Parent = con 
    ok.Position = UDim2.new(0, 160, 0, 0) 
    ok.Size = UDim2.new(0, 70, 1, 0) 
    ok.BackgroundColor3 = Color3.fromRGB(40, 100, 160) 
    ok.Font = Enum.Font.SourceSansBold 
    ok.Text = "OKAY" 
    ok.TextColor3 = Color3.fromRGB(255, 255, 255) 
    ok.TextSize = 12 
    ok.BorderSizePixel = 0
    ok.MouseButton1Click:Connect(function() cb(tb.Text) end)
end

local tc = Instance.new("Frame") 
tc.Parent = SF 
tc.Size = UDim2.new(0, 230, 0, 32) 
tc.BackgroundTransparency = 1

local ttb = Instance.new("TextBox") 
ttb.Parent = tc 
ttb.Size = UDim2.new(0, 150, 1, 0) 
ttb.BackgroundColor3 = Color3.fromRGB(55, 55, 55) 
ttb.Font = Enum.Font.SourceSans 
ttb.Text = "" 
ttb.PlaceholderText = "Player Nickname" 
ttb.TextColor3 = Color3.fromRGB(255, 255, 255) 
ttb.TextSize = 14 
ttb.BorderSizePixel = 0

local tbtn = Instance.new("TextButton") 
tbtn.Parent = tc 
tbtn.Position = UDim2.new(0, 160, 0, 0) 
tbtn.Size = UDim2.new(0, 70, 1, 0) 
tbtn.BackgroundColor3 = Color3.fromRGB(120, 60, 160) 
tbtn.Font = Enum.Font.SourceSansBold 
tbtn.Text = "TP" 
tbtn.TextColor3 = Color3.fromRGB(255, 255, 255) 
tbtn.TextSize = 12 
tbtn.BorderSizePixel = 0

tbtn.MouseButton1Click:Connect(function() 
    local tName = ttb.Text:lower()
    if tName ~= "" then 
        for _, pl in ipairs(ps:GetPlayers()) do 
            if pl ~= p and (pl.Name:lower():find(tName) or pl.DisplayName:lower():find(tName)) then 
                if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
                    p.Character.HumanoidRootPart.CFrame = pl.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2) 
                    break 
                end 
            end 
        end 
    end 
end)

createInput("Speed", speed, function(v) local n = tonumber(v) if n then speed = n end end)
createInput("Jump", jump, function(v) local n = tonumber(v) if n then jump = n end end)
createInput("Ally RGB (0 255 0)", "0 255 0", function(v) aCol = parseColor(v, aCol) clearEsp() end)
createInput("Enemy RGB (255 0 0)", "255 0 0", function(v) eCol = parseColor(v, eCol) clearEsp() end)

createToggle("Inf Jump", function(s) ij = s end)
createToggle("Noclip", function(s) nc = s end)
createToggle("Normal Fly", function(s) if s then startFly() else stopFly() end end)
createToggle("Swim Fly", function(s) swf = s if s then stopFly() end end)
createToggle("Advanced 3D ESP", function(s) esp = s if not s then clearEsp() end end)
createToggle("Show Skeletons", function(s) skel = s if not s then clearEsp() end end)
createToggle("Click TP (Ctrl+LClick)", function(s) ClickTp = s end)
createToggle("Infinite Oxygen", function(s) oxy = s end)

uis.InputBegan:Connect(function(i, gpe) 
    if not gpe and i.KeyCode == Enum.KeyCode.K and M then M.Visible = not M.Visible end
    if not gpe and ClickTp and i.UserInputType == Enum.UserInputType.MouseButton1 and uis:IsKeyDown(Enum.KeyCode.LeftControl) then 
        local ms = p:GetMouse() 
        if ms and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
            p.Character.HumanoidRootPart.CFrame = CFrame.new(ms.Hit.p) + Vector3.new(0, 3, 0) 
        end 
    end 
end)

uis.JumpRequest:Connect(function() 
    if ij and not fly then 
        pcall(function() 
            local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid") 
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end 
        end) 
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

task.spawn(function()
    while act and task.wait(0.05) do
        pcall(function()
            local char = p.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if swf then hum:ChangeState(Enum.HumanoidStateType.Swimming) end
                    if not fly then
                        if hum.WalkSpeed ~= speed then hum.WalkSpeed = speed end
                        if hum.UseJumpPower then 
                            if hum.JumpPower ~= jump then hum.JumpPower = jump end 
                        else 
                            local conv = jump / 3.5 
                            if hum.JumpHeight ~= conv then hum.JumpHeight = conv end 
                        end
                    end
                    if oxy and hum:GetAttribute("Oxygen") then hum:SetAttribute("Oxygen", 100) end
                end
                if nc then 
                    for _, part in ipairs(char:GetDescendants()) do 
                        if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end 
                    end 
                end
            end
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
                            box.Name = "3DBox" 
                            box.Size = pChar:GetExtentsSize() + Vector3.new(0.2, 0.2, 0.2) 
                            box.AlwaysOnTop = true 
                            box.ZIndex = 3 
                            box.Color3 = color 
                            box.Adornee = pChar 
                            box.Transparency = 0.6
                            local dist = math.floor((p.Character and p.Character:FindFirstChild("HumanoidRootPart") and (p.Character.HumanoidRootPart.Position - root.Position).Magnitude) or 0)
                            local tag = folder:FindFirstChild("ESPTag") or Instance.new("BillboardGui", folder) 
                            tag.Name = "ESPTag" 
                            tag.Size = UDim2.new(0, 200, 0, 50) 
                            tag.AlwaysOnTop = true 
                            tag.ExtentsOffset = Vector3.new(0, 3, 0) 
                            tag.Adornee = root
                            local txt = tag:FindFirstChild("ESPText") or Instance.new("TextLabel", tag) 
                            txt.Name = "ESPText" 
                            txt.BackgroundTransparency = 1 
                            txt.Size = UDim2.new(1, 0, 1, 0) 
                            txt.Font = Enum.Font.SourceSansBold 
                            txt.TextSize = 14 
                            txt.TextColor3 = color 
                            txt.TextStrokeTransparency = 0 
                            txt.Text = string.format("%s\nHP: %d | Dist: %d", pl.Name, math.floor(pHum.Health), dist)
                        else 
                            local b = folder:FindFirstChild("3DBox") if b then b:Destroy() end 
                            local t = folder:FindFirstChild("ESPTag") if t then t:Destroy() end 
                        end
                        if skel then
                            if pChar:FindFirstChild("Left Upper Leg") then
                                drawBone(pChar, folder, "Head", "UpperTorso", color) 
                                drawBone(pChar, folder, "UpperTorso", "LowerTorso", color) 
                                drawBone(pChar, folder, "UpperTorso", "LeftUpperArm", color) 
                                drawBone(pChar, folder, "LeftUpperArm", "LeftLowerArm", color) 
                                drawBone(pChar, folder, "UpperTorso", "RightUpperArm", color) 
                                drawBone(pChar, folder, "RightUpperArm", "RightLowerArm", color) 
                                drawBone(pChar, folder, "LowerTorso", "LeftUpperLeg", color) 
                                drawBone(pChar, folder, "LeftUpperLeg", "LeftLowerLeg", color) 
                                drawBone(pChar, folder, "LowerTorso", "RightUpperLeg", color) 
                                drawBone(pChar, folder, "RightUpperLeg", "RightLowerLeg", color)
                            else
                                drawBone(pChar, folder, "Head", "Torso", color) 
                                drawBone(pChar, folder, "Torso", "Left Arm", color) 
                                drawBone(pChar, folder, "Torso", "Right Arm", color) 
                                drawBone(pChar, folder, "Torso", "Left Leg", color) 
                                drawBone(pChar, folder, "Torso", "Right Leg", color)
                            end
                        else
                            for _, item in ipairs(folder:GetChildren()) do 
                                if item:IsA("LineHandleAdornment") then item:Destroy() end 
                            end
                        end
                    end
                end
            end
        end)
    end
end)
