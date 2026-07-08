-- [[ N0XY Hub - ЧАСТЬ 2 ]] --

local B3 = Instance.new("TextButton")
B3.Parent = MainFrame
B3.Size = UDim2.new(1, -30, 0, 34)
B3.Position = UDim2.new(0, 15, 0, 139)
B3.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
B3.Text = "✈️ Fly: ВЫКЛ"
B3.TextColor3 = Color3.fromRGB(240, 240, 240)
B3.Font = Enum.Font.SourceSansBold
B3.TextSize = 14
Instance.new("UICorner", B3).CornerRadius = UDim.new(0, 8)

local fly = false
B3.MouseButton1Click:Connect(function()
    fly = not fly
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local Root = Character.HumanoidRootPart
    if fly then
        B3.Text = "✈️ Fly: ВКЛ"
        B3.TextColor3 = Color3.fromRGB(0, 255, 100)
        local BV = Instance.new("BodyVelocity")
        BV.Name = "NoxyFly"
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BV.Parent = Root
        task.spawn(function()
            while fly and task.wait() do
                BV.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
            end
            BV:Destroy()
        end)
    else
        B3.Text = "✈️ Fly: ВЫКЛ"
        B3.TextColor3 = Color3.fromRGB(240, 240, 240)
    end
end)

local B4 = Instance.new("TextButton")
B4.Parent = MainFrame
B4.Size = UDim2.new(1, -30, 0, 34)
B4.Position = UDim2.new(0, 15, 0, 181)
B4.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
B4.Text = "🦘 Inf Jump: ВЫКЛ"
B4.TextColor3 = Color3.fromRGB(240, 240, 240)
B4.Font = Enum.Font.SourceSansBold
B4.TextSize = 14
Instance.new("UICorner", B4).CornerRadius = UDim.new(0, 8)

local infJump = false
B4.MouseButton1Click:Connect(function() infJump = not infJump end)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local B5 = Instance.new("TextButton")
B5.Parent = MainFrame
B5.Size = UDim2.new(1, -30, 0, 34)
B5.Position = UDim2.new(0, 15, 0, 223)
B5.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
B5.Text = "💥 Fling Dropkick"
B5.TextColor3 = Color3.fromRGB(240, 240, 240)
B5.Font = Enum.Font.SourceSansBold
B5.TextSize = 14
Instance.new("UICorner", B5).CornerRadius = UDim.new(0, 8)
B5.MouseButton1Click:Connect(function()
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            target = p.Character.HumanoidRootPart
        end
    end
    if target then
        Root.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0), target.Position)
        local bAV = Instance.new("BodyAngularVelocity")
        bAV.AngularVelocity = Vector3.new(0, 99999, 0)
        bAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bAV.Parent = Root
        local bV = Instance.new("BodyVelocity")
        bV.Velocity = Root.CFrame.LookVector * 150
        bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bV.Parent = Root
        task.wait(0.5) bAV:Destroy() bV:Destroy()
    end
end)

local B6 = Instance.new("TextButton")
B6.Parent = MainFrame
B6.Size = UDim2.new(1, -30, 0, 34)
B6.Position = UDim2.new(0, 15, 0, 265)
B6.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
B6.Text = "🛡️ Anti Fling: ВЫКЛ"
B6.TextColor3 = Color3.fromRGB(240, 240, 240)
B6.Font = Enum.Font.SourceSansBold
B6.TextSize = 14
Instance.new("UICorner", B6).CornerRadius = UDim.new(0, 8)

local antiFling = false
B6.MouseButton1Click:Connect(function() antiFling = not antiFling end)
RunService.Heartbeat:Connect(function()
    if antiFling and LocalPlayer.Character then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Velocity = Vector3.new(0,0,0)
                        part.RotVelocity = Vector3.new(0,0,0)
                    end
                end
            end
        end
    end
end)

local B7 = Instance.new("TextButton")
B7.Parent = MainFrame
B7.Size = UDim2.new(1, -30, 0, 34)
B7.Position = UDim2.new(0, 15, 0, 307)
B7.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
B7.Text = "👁️ ESP: ВЫКЛ"
B7.TextColor3 = Color3.fromRGB(240, 240, 240)
B7.Font = Enum.Font.SourceSansBold
B7.TextSize = 14
Instance.new("UICorner", B7).CornerRadius = UDim.new(0, 8)

local esp = false
local espHighlights = {}
B7.MouseButton1Click:Connect(function()
    esp = not esp
    if not esp then
        for _, h in pairs(espHighlights) do pcall(function() h:Destroy() end) end
        table.clear(espHighlights)
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Color3.fromRGB(0, 255, 0)
                h.FillTransparency = 0.5
                espHighlights[p.Name] = h
            end
        end
    end
end)

local B8 = Instance.new("TextButton")
B8.Parent = MainFrame
B8.Size = UDim2.new(1, -30, 0, 34)
B8.Position = UDim2.new(0, 15, 0, 349)
B8.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
B8.Text = "❌ Полностью закрыть чит"
B8.TextColor3 = Color3.fromRGB(240, 240, 240)
B8.Font = Enum.Font.SourceSansBold
B8.TextSize = 14
Instance.new("UICorner", B8).CornerRadius = UDim.new(0, 8)
B8.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
