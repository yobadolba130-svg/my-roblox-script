local player = game:GetService("Players").LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local playersService = game:GetService("Players")

local infJumpEnabled, noclipEnabled, flyEnabled, swimFlyEnabled = false, false, false, false
local espEnabled, chamsEnabled, autoClickerEnabled, antiAfkEnabled = false, false, false, false
local infOxygenEnabled, clickTpEnabled = false, false
local currentSpeed, currentJumpPower, scriptActive = 16, 50, true

local flyConnection, bodyVelocity, bodyGyro

local function stopFly()
    flyEnabled = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    pcall(function() if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false end end)
end

local function startFly()
    stopFly()
    if swimFlyEnabled then swimFlyEnabled = false end
    flyEnabled = true
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not hum then return end
    hum.PlatformStand = true
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = root.CFrame
    bodyGyro.Parent = root
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = root
    local camera = workspace.CurrentCamera
    flyConnection = runService.RenderStepped:Connect(function()
        if not flyEnabled or not root or not player.Character then stopFly() return end
        local moveDirection = Vector3.new(0, 0, 0)
        if userInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
        if userInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        bodyGyro.cframe = camera.CFrame
        if moveDirection.Magnitude > 0 then bodyVelocity.velocity = moveDirection.Unit * currentSpeed else bodyVelocity.velocity = Vector3.new(0, 0, 0) end
    end)
end

local function clearEsp()
    for _, p in ipairs(playersService:GetPlayers()) do
        if p.Character then
            local b = p.Character:FindFirstChild("EspBox") if b then b:Destroy() end
            local c = p.Character:FindFirstChild("ChamsHighlight") if c then c:Destroy() end
        end
    end
end

_G.CloseMenuSignal:Connect(function()
    scriptActive = false infJumpEnabled = false noclipEnabled = false swimFlyEnabled = false
    espEnabled = false chamsEnabled = false autoClickerEnabled = false antiAfkEnabled = false
    infOxygenEnabled = false clickTpEnabled = false stopFly() clearEsp()
    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 hum.PlatformStand = false if hum.UseJumpPower then hum.JumpPower = 50 else hum.JumpHeight = 50 / 3.5 end hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
            for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
        end
    end)
    _G.DestroyGui()
end)

_G.CreateTpBox(function(text)
    local targetName = text:lower()
    if targetName ~= "" then
        for _, p in ipairs(playersService:GetPlayers()) do
            if p ~= player and (p.Name:lower():find(targetName) or p.DisplayName:lower():find(targetName)) then
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2) break
                end
            end
        end
    end
end)

_G.CreateInput("Speed", currentSpeed, function(v) currentSpeed = v end)
_G.CreateInput("Jump", currentJumpPower, function(v) currentJumpPower = v end)
_G.CreateToggle("Inf Jump", function(s) infJumpEnabled = s end)
_G.CreateToggle("Noclip", function(s) noclipEnabled = s end)
_G.CreateToggle("Normal Fly", function(s) if s then startFly() else stopFly() end end)
_G.CreateToggle("Swim Fly", function(s) swimFlyEnabled = s if s then stopFly() end end)
_G.CreateToggle("Player ESP", function(s) espEnabled = s if not s then clearEsp() end end)
_G.CreateToggle("Chams (Fill)", function(s) chamsEnabled = s if not s then clearEsp() end end)
_G.CreateToggle("Auto Clicker", function(s) autoClickerEnabled = s end)
_G.CreateToggle("Click TP (Ctrl+LClick)", function(s) clickTpEnabled = s end)
_G.CreateToggle("Infinite Oxygen", function(s) infOxygenEnabled = s end)
_G.CreateToggle("Anti-AFK Avoid", function(s) antiAfkEnabled = s end)

userInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and clickTpEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 and userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = player:GetMouse()
        if mouse and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p) + Vector3.new(0, 3, 0) end
    end
end)

userInputService.JumpRequest:Connect(function()
    if infJumpEnabled and not flyEnabled then pcall(function() local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid") if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end) end
end)

pcall(function() player.Idled:Connect(function() if antiAfkEnabled then local vu = game:GetService("VirtualUser") vu:CaptureController() vu:ClickButton2(Vector2.new(0, 0)) end end) end)

task.spawn(function()
    while scriptActive and task.wait(0.05) do
        pcall(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if swimFlyEnabled then hum:ChangeState(Enum.HumanoidStateType.Swimming) end
                    if not flyEnabled then
                        if hum.WalkSpeed ~= currentSpeed then hum.WalkSpeed = currentSpeed end
                        if hum.UseJumpPower then if hum.JumpPower ~= currentJumpPower then hum.JumpPower = currentJumpPower end else local conv = currentJumpPower / 3.5 if hum.JumpHeight ~= conv then hum.JumpHeight = conv end end
                    end
                    if infOxygenEnabled and hum:GetAttribute("Oxygen") then hum:SetAttribute("Oxygen", 100) end
                end
                if noclipEnabled then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end end
            end
            if autoClickerEnabled then local vu = game:GetService("VirtualUser") vu:Button1Down(Vector2.new(0, 0)) vu:Button1Up(Vector2.new(0, 0)) end
            if espEnabled or chamsEnabled then
                for _, p in ipairs(playersService:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local pChar = p.Character
                        if espEnabled and not pChar:FindFirstChild("EspBox") then
                            local b = Instance.new("BoxHandleAdornment") b.Name = "EspBox" b.Size = pChar:GetExtentsSize() + Vector3.new(0.5, 0.5, 0.5) b.AlwaysOnTop = true b.ZIndex = 5 b.Color3 = Color3.fromRGB(255, 0, 0) b.Adornee = pChar b.Transparency = 0.5 b.Parent = pChar
                        end
                        if chamsEnabled and not pChar:FindFirstChild("ChamsHighlight") then
                            local h = Instance.new("Highlight") h.Name = "ChamsHighlight" h.FillColor = Color3.fromRGB(140, 0, 255) h.OutlineColor = Color3.fromRGB(255, 255, 255) h.FillTransparency = 0.4 h.AlwaysOnTop = true h.Parent = pChar
                        end
                    end
                end
            end
        end)
    end
end)
