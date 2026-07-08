-- [[ N0XY Hub - Твой первый мощный скрипт ]] --

-- Загрузка библиотеки интерфейса Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

-- Создание главного окна
local Window = Rayfield:CreateWindow({
   Name = "N0XY Hub | Roblox",
   LoadingTitle = "Загрузка N0XY Hub...",
   LoadingSubtitle = "by Your Name",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "N0XYHub"
   },
   KeySystem = false -- Без ключа для удобства
})

-- Переменные для функций
local Players = game:Service("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:Service("RunService")

local noclipEnabled = false
local flyEnabled = false
local antiFlingEnabled = false
local infJumpEnabled = false
local espEnabled = false

local flySpeed = 50

-- ТАБЫ (ВКЛАДКИ)
local MainTab = Window:CreateTab("Основные", 4483362458)
local CombatTab = Window:CreateTab("Бой / Флинг", 4483362458)
local VisualsTab = Window:CreateTab("Визуалы", 4483362458)

-- =======================================================
-- 1. GOD MODE (Режим Бога)
-- =======================================================
MainTab:CreateButton({
   Name = "Активировать God Mode",
   Callback = function()
       local Character = LocalPlayer.Character
       if Character and Character:FindFirstChild("Humanoid") then
           local Humanoid = Character.Humanoid
           local Character2 = Character:Clone()
           Character2.Parent = workspace
           LocalPlayer.Character = Character2
           Character2:FindFirstChild("Humanoid"):Destroy()
           local NewHumanoid = Humanoid:Clone()
           NewHumanoid.Parent = Character2
           Character:Destroy()
           Rayfield:Notify({Title = "N0XY Hub", Content = "God Mode активирован! (До первой перезагрузки)", Duration = 5})
       end
   end,
})

-- =======================================================
-- 2. NOCLIP (Проход сквозь стены)
-- =======================================================
MainTab:CreateToggle({
   Name = "Noclip (Сквозь стены)",
   CurrentValue = false,
   Flag = "NoclipFlag",
   Callback = function(Value)
       noclipEnabled = Value
       if noclipEnabled then
           RunService.Stepped:Connect(function()
               if noclipEnabled and LocalPlayer.Character then
                   for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                       if part:IsA("BasePart") then
                           part.CanCollide = false
                       end
                   end
               end
           end)
       end
   end,
})

-- =======================================================
-- 3. FLY (Полет)
-- =======================================================
MainTab:CreateToggle({
   Name = "Fly (Полет)",
   CurrentValue = false,
   Flag = "FlyFlag",
   Callback = function(Value)
       flyEnabled = Value
       local Character = LocalPlayer.Character
       if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
       
       local Root = Character.HumanoidRootPart
       if flyEnabled then
           local BodyVelocity = Instance.new("BodyVelocity")
           BodyVelocity.Name = "N0XY_Fly"
           BodyVelocity.Velocity = Vector3.new(0, 0, 0)
           BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
           BodyVelocity.Parent = Root
           
           task.spawn(function()
               while flyEnabled and task.wait() do
                   local Camera = workspace.CurrentCamera
                   BodyVelocity.Velocity = Camera.CFrame.LookVector * flySpeed
               end
               if BodyVelocity then BodyVelocity:Destroy() end
           end)
       else
           if Root:FindFirstChild("N0XY_Fly") then
               Root.N0XY_Fly:Destroy()
           end
       end
   end,
})

-- Слайдер скорости полета
MainTab:CreateSlider({
   Name = "Скорость полета",
   Min = 10,
   Max = 200,
   Default = 50,
   Increment = 5,
   ValueName = "Speed",
   Callback = function(Value)
       flySpeed = Value
   end,
})

-- =======================================================
-- 7. INFINITE JUMP (Бесконечный прыжок)
-- =======================================================
MainTab:CreateToggle({
   Name = "Infinite Jump (Бесконечный прыжок)",
   CurrentValue = false,
   Flag = "InfJumpFlag",
   Callback = function(Value)
       infJumpEnabled = Value
       game:GetService("UserInputService").JumpRequest:Connect(function()
           if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
               LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
           end
       end)
   end,
})

-- =======================================================
-- 4. FLING DROPKICK (Влететь с ног)
-- =======================================================
CombatTab:CreateButton({
   Name = "Fling Dropkick (Удар с ног)",
   Callback = function()
       local Character = LocalPlayer.Character
       local Root = Character and Character:FindFirstChild("HumanoidRootPart")
       
       if not Root then return end
       
       local target = nil
       local maxDist = 100
       for _, p in pairs(Players:GetPlayers()) do
           if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
               local dist = (Root.Position - p.Character.HumanoidRootPart.Position).Magnitude
               if dist < maxDist then
                   maxDist = dist
                   target = p.Character.HumanoidRootPart
               end
           end
       end
       
       if target then
           Rayfield:Notify({Title = "Dropkick", Content = "Влетаем в цель!", Duration = 2})
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
           bAV:Destroy()
           bV:Destroy()
       else
           Rayfield:Notify({Title = "Dropkick Error", Content = "Игрок рядом не найден!", Duration = 3})
       end
   end,
})

-- =======================================================
-- 5. ANTI FLING (Защита от отбрасывания)
-- =======================================================
CombatTab:CreateToggle({
   Name = "Anti Fling (Защита)",
   CurrentValue = false,
   Flag = "AntiFlingFlag",
   Callback = function(Value)
       antiFlingEnabled = Value
       RunService.Heartbeat:Connect(function()
           if antiFlingEnabled and LocalPlayer.Character then
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
   end,
})

-- =======================================================
-- 6. ESP (Подсветка игроков зелёным цветом)
-- =======================================================
local espHighlights = {}

VisualsTab:CreateToggle({
   Name = "Включить ESP (Зелёный)",
   CurrentValue = false,
   Flag = "EspFlag",
   Callback = function(Value)
       espEnabled = Value
       
       if not espEnabled then
           for _, highlight in pairs(espHighlights) do
               if highlight then highlight:Destroy() end
           end
           table.clear(espHighlights)
       else
           local function addESP(player)
               if player ~= LocalPlayer then
                   player.CharacterAdded:Connect(function(char)
                       if espEnabled then
                           task.wait(0.5)
                           local highlight = Instance.new("Highlight")
                           highlight.Parent = char
                           highlight.FillColor = Color3.fromRGB(0, 255, 0)
                           highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                           highlight.FillTransparency = 0.5
                           espHighlights[player.Name] = highlight
                       end
                   end)
                   
                   if player.Character then
                       local highlight = Instance.new("Highlight")
                       highlight.Parent = player.Character
                       highlight.FillColor = Color3.fromRGB(0, 255, 0)
                       highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                       highlight.FillTransparency = 0.5
                       espHighlights[player.Name] = highlight
                   end
               end
           end
           
           for _, p in pairs(Players:GetPlayers()) do
               addESP(p)
           end
           
           Players.PlayerAdded:Connect(addESP)
       end
   end,
})

-- Уведомление об успешном запуске твоего первого хаба!
Rayfield:Notify({
   Name = "N0XY Hub",
   Content = "Скрипт успешно запущен! Приятной игры!",
   Duration = 5,
   Image = 4483362458,
})
