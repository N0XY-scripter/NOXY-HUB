-- [[ N0XY Hub - Финальная рабочая версия с кнопками ]] --

if game:GetService("CoreGui"):FindFirstChild("N0XY_Hub") then
    game:GetService("CoreGui"):FindFirstChild("N0XY_Hub"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")
local ToggleBtn = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
local MainCorner = Instance.new("UICorner")

ScreenGui.Name = "N0XY_Hub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Круглая кнопка для открытия/закрытия
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 70)
ToggleBtn.Text = "N0XY"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true

ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Главное окно (Увеличили ширину и высоту для кнопок)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.35, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 420) -- Больше места
MainFrame.Active = true
MainFrame.Draggable = true

MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 180, 70)
UIStroke.Parent = MainFrame

-- Заголовок
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "N0XY Hub | Universal"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- ИСПРАВЛЕНО: Список прикреплен прямо к главному окну с отступами!
UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Добавим пустой элемент сверху, чтобы кнопки не налезали на заголовок
local PaddingFrame = Instance.new("Frame")
PaddingFrame.Size = UDim2.new(1, 0, 0, 45)
PaddingFrame.BackgroundTransparency = 1
PaddingFrame.Parent = MainFrame
PaddingFrame.LayoutOrder = 0

-- Функция создания кнопок напрямую в окне
local function CreateButton(text, callback, order)
    local Btn = Instance.new("TextButton")
    Btn.Parent = MainFrame -- Прямая привязка к окну!
    Btn.Size = UDim2.new(1, -30, 0, 36)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.SourceSansBold
    Btn.LayoutOrder = order

    -- Отцентровка кнопок внутри контейнера
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 15)
    UIPadding.Parent = MainFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1
    Stroke.Color = Color3.fromRGB(45, 45, 45)
    Stroke.Parent = Btn

    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local Players = game:Service("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:Service("RunService")

-- 1. GOD MODE
CreateButton("⚡ Активировать God Mode", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        LocalPlayer.Character.Humanoid.Health = math.huge
    end
end, 1)

-- 2. NOCLIP
local noclip = false
local noclipBtn = CreateButton("🧱 Noclip: ВЫКЛ", function()
    noclip = not noclip
end, 2)
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        noclipBtn.Text = "🧱 Noclip: ВКЛ"
        noclipBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    else
        noclipBtn.Text = "🧱 Noclip: ВЫКЛ"
        noclipBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    end
end)

-- 3. FLY
local fly = false
local flyBtn = CreateButton("✈️ Fly: ВЫКЛ", function()
    fly = not fly
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local Root = Character.HumanoidRootPart
    
    if fly then
        flyBtn.Text = "✈️ Fly: ВКЛ"
        flyBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
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
        flyBtn.Text = "✈️ Fly: ВЫКЛ"
        flyBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    end
end, 3)

-- 4. INFINITE JUMP
local infJump = false
local jumpBtn = CreateButton("🦘 Inf Jump: ВЫКЛ", function()
    infJump = not infJump
    if infJump then
        jumpBtn.Text = "🦘 Inf Jump: ВКЛ"
        jumpBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        jumpBtn.Text = "🦘 Inf Jump: ВЫКЛ"
        jumpBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    end
end, 4)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 5. FLING DROPKICK
CreateButton("💥 Fling Dropkick", function()
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    local target = nil
    local maxDist = 100
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (Root.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < maxDist then maxDist = dist; target = p.Character.HumanoidRootPart end
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
        task.wait(0.5)
        bAV:Destroy() bV:Destroy()
    end
end, 5)

-- 6. ANTI FLING
local antiFling = false
local antiBtn = CreateButton("🛡️ Anti Fling: ВЫКЛ", function()
    antiFling = not antiFling
    if antiFling then
        antiBtn.Text = "🛡️ Anti Fling: ВКЛ"
        antiBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        antiBtn.Text = "🛡️ Anti Fling: ВЫКЛ"
        antiBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    end
end, 6)
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

-- 7. ESP (Зеленый)
local esp = false
local espHighlights = {}
local espBtn = CreateButton("👁️ ESP: ВЫКЛ", function()
    esp = not esp
    if not esp then
        espBtn.Text = "👁️ ESP: ВЫКЛ"
        espBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
        for _, h in pairs(espHighlights) do pcall(function() h:Destroy() end) end
        table.clear(espHighlights)
    else
        espBtn.Text = "👁️ ESP: ВКЛ"
        espBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        local function addESP(p)
            if p ~= LocalPlayer and p.Character then
                local h = Instance.new("Highlight")
                h.Parent = p.Character
                h.FillColor = Color3.fromRGB(0, 255, 0)
                h.FillTransparency = 0.5
                espHighlights[p.Name] = h
            end
        end
        for _, p in pairs(Players:GetPlayers()) do addESP(p) end
    end
end, 7)

-- Кнопка закрытия
CreateButton("❌ Полностью закрыть чит", function()
    ScreenGui:Destroy()
end, 8)
