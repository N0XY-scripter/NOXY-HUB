-- [[ N0XY MASTER ENGINE V7 — ULTIMATE CLEAN FIX ]] --
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "N0XY MASTER ENGINE 💀 (v7)",
   LoadingTitle = "Загрузка полного пака хаоса...",
   LoadingSubtitle = "by N0XY",
   ConfigurationSaving = { Enabled = false }
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- ВСЕ ПЕРЕМЕННЫЕ
local flying = false
local flySpeedSetting = 50
local noclip = false
local antiFling = false
local walkSpeedValue = 16
local jumpPowerValue = 50

local targetPlayerName = ""
local loopFlinging = false
local orbitPlayer = false
local killAura = false
local spammingChat = false
local jerkAnim = false
local jerkAll = false
local spinBot = false
local sizeRandomizer = false

_G.Aim = false
_G.AutoClick = false

-- ТЕКСТУРЫ ДЛЯ КАСТОМНОГО НЕБА
local SkyTypes = {
    ["Space"] = "http://www.roblox.com/asset/?id=600831435",
    ["Fire"] = "http://www.roblox.com/asset/?id=580873633",
    ["Night"] = "http://www.roblox.com/asset/?id=600831435"
}

-- [[ ВКЛАДКИ (Иконки установлены в 0 для исключения вылетов) ]]
local MainTab = Window:CreateTab("Главная & PvP ⚔️", 0)
local WorldTab = Window:CreateTab("Мир & Небо 🌌", 0)
local TrollTab = Window:CreateTab("Троллинг Цели 😈", 0)
local ChaosTab = Window:CreateTab("Хаос Сервера 💥", 0)
local FunTab = Window:CreateTab("Веселье & Чат 🤖", 0)

-- ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ ДЛЯ ПОИСКА ЖЕРТВЫ
local function getTarget()
   for _, p in pairs(Players:GetPlayers()) do
      if p.Name:lower():sub(1, #targetPlayerName) == targetPlayerName or p.DisplayName:lower():sub(1, #targetPlayerName) == targetPlayerName then
         return p
      end
   end
   return nil
end

-- ==========================================
--        1. ВКЛАДКА: ГЛАВНАЯ & PvP ⚔️
-- ==========================================

local FlyConnection
MainTab:CreateToggle({
   Name = "Fly (Полёт по камере)",
   CurrentValue = false,
   Flag = "FlyFlag",
   Callback = function(Value)
      flying = Value
      if flying then
         local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
         local HRP = Character:WaitForChild("HumanoidRootPart")
         local Humanoid = Character:WaitForChild("Humanoid")
         local Camera = workspace.CurrentCamera
         Humanoid.PlatformStand = true
         FlyConnection = RunService.Heartbeat:Connect(function(deltaTime)
            if not flying or not Character or not HRP.Parent then if FlyConnection then FlyConnection:Disconnect() end return end
            local moveDir = Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
               local flyDir = (Camera.CFrame * CFrame.new(Vector3.new(moveDir.X, 0, moveDir.Z))).LookVector
               HRP.CFrame = HRP.CFrame + (flyDir * (flySpeedSetting * deltaTime))
            end
            HRP.Velocity = Vector3.new(0, 0, 0)
         end)
      else
         if FlyConnection then FlyConnection:Disconnect() end
         pcall(function() LocalPlayer.Character.Humanoid.PlatformStand = false end)
      end
   end,
})

MainTab:CreateInput({
   Name = "Скорость Полета",
   PlaceholderText = "Стандарт: 50",
   Callback = function(Text) local num = tonumber(Text) if num then flySpeedSetting = num end end,
})

MainTab:CreateSlider({
   Name = "Скорость Бега (WalkSpeed)",
   Range = {16, 250},
   Increment = 5,
   CurrentValue = 16,
   Callback = function(Value) walkSpeedValue = Value end,
})

MainTab:CreateSlider({
   Name = "Сила Прыжка (JumpPower)",
   Range = {50, 300},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value) jumpPowerValue = Value end,
})

MainTab:CreateToggle({
   Name = "Noclip (Сквозь стены)",
   CurrentValue = false,
   Flag = "NoclipFlag",
   Callback = function(Value) noclip = Value end,
})

MainTab:CreateToggle({
   Name = "Anti-Fling (Защита от толчков)",
   CurrentValue = false,
   Flag = "AntiFlingFlag",
   Callback = function(Value) antiFling = Value end,
})

MainTab:CreateToggle({
   Name = "Aim-Lock (Наводка на игроков)",
   CurrentValue = false,
   Callback = function(Value) _G.Aim = Value end,
})

MainTab:CreateToggle({
   Name = "Auto-Clicker (Авто-удар тулом)",
   CurrentValue = false,
   Callback = function(Value) _G.AutoClick = Value end
})


-- ==========================================
--        2. ВКЛАДКА: МИР & НЕБО 🌌
-- ==========================================

WorldTab:CreateDropdown({
    Name = "Выбрать кастомное небо (Skybox)",
    Options = {"Space", "Fire", "Night"},
    Callback = function(Option)
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
        sky.SkyboxBk = SkyTypes[Option]; sky.SkyboxDn = SkyTypes[Option]; sky.SkyboxFt = SkyTypes[Option]
        sky.SkyboxLf = SkyTypes[Option]; sky.SkyboxRt = SkyTypes[Option]; sky.SkyboxUp = SkyTypes[Option]
    end
})

WorldTab:CreateButton({
   Name = "Fog Disable (Убрать туман)",
   Callback = function() Lighting.FogEnd = 100000 end
})

WorldTab:CreateSlider({
   Name = "Гравитация Мира 🌍",
   Range = {0, 400},
   Increment = 10,
   CurrentValue = 196,
   Callback = function(Value) workspace.Gravity = Value end,
})

WorldTab:CreateButton({
   Name = "Включить Вечную Ночь 🌙",
   Callback = function() Lighting.TimeOfDay = "00:00:00" end,
})

WorldTab:CreateButton({
   Name = "Включить Вечный День ☀️",
   Callback = function() Lighting.TimeOfDay = "12:00:00" end,
})


-- ==========================================
--        3. ВКЛАДКА: ТРОЛЛИНГ ЦЕЛИ 😈
-- ==========================================

TrollTab:CreateInput({
   Name = "Ник жертвы",
   PlaceholderText = "Можно первые буквы...",
   Callback = function(Text) targetPlayerName = Text:lower() end,
})

TrollTab:CreateButton({
   Name = "Посадить в РЕАЛЬНУЮ клетку! 🧱",
   Callback = function()
      local p = getTarget()
      if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
         local targetHRP = p.Character.HumanoidRootPart
         if workspace:FindFirstChild("RealCage_" .. p.Name) then workspace["RealCage_" .. p.Name]:Destroy() end
         
         local CageModel = Instance.new("Model", workspace)
         CageModel.Name = "RealCage_" .. p.Name
         
         local floor = Instance.new("Part", CageModel) floor.Size = Vector3.new(8, 0.5, 8) floor.CFrame = targetHRP.CFrame * CFrame.new(0, -3.5, 0) floor.Anchored = true floor.Material = Enum.Material.CorrodedMetal
         local roof = Instance.new("Part", CageModel) roof.Size = Vector3.new(8, 0.5, 8) roof.CFrame = targetHRP.CFrame * CFrame.new(0, 4.5, 0) roof.Anchored = true roof.Material = Enum.Material.CorrodedMetal
         
         local function spawnBar(offsetCFrame)
            local bar = Instance.new("Part", CageModel)
            bar.Size = Vector3.new(0.2, 8, 0.2)
            bar.CFrame = targetHRP.CFrame * offsetCFrame
            bar.Anchored = true
            bar.Material = Enum.Material.Iron
            bar.Color = Color3.fromRGB(100, 100, 100)
         end
         
         for i = -3.5, 3.5, 1.2 do
            spawnBar(CFrame.new(i, 0.5, -3.5))
            spawnBar(CFrame.new(i, 0.5, 3.5))
            spawnBar(CFrame.new(-3.5, 0.5, i))
            spawnBar(CFrame.new(3.5, 0.5, i))
         end
         Rayfield:Notify({Title = "N0XY HUB", Content = p.Name .. " за решёткой!", Duration = 3})
      end
   end,
})

TrollTab:CreateButton({
   Name = "Удалить все клетки ❌",
   Callback = function()
      for _, v in pairs(workspace:GetChildren()) do if v.Name:sub(1, 9) == "RealCage_" then v:Destroy() end end
   end,
})

TrollTab:CreateToggle({
   Name = "Loop Fling (Кошмарить вечно)",
   CurrentValue = false,
   Callback = function(Value)
      loopFlinging = Value
      task.spawn(function()
         while loopFlinging do
            pcall(function()
               local p = getTarget()
               if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  local myHRP = LocalPlayer.Character.HumanoidRootPart
                  myHRP.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
                  myHRP.Velocity = Vector3.new(7000, 7000, 7000)
                  myHRP.RotVelocity = Vector3.new(7000, 7000, 7000)
               end
            end)
            task.wait(0.01)
         end
      end)
   end,
})

TrollTab:CreateToggle({
   Name = "Orbit (Летать вокруг кругами)",
   CurrentValue = false,
   Callback = function(Value)
      orbitPlayer = Value
      task.spawn(function()
         local angle = 0
         while orbitPlayer do
            pcall(function()
               local p = getTarget()
               if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  angle = angle + 0.1
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(p.Character.HumanoidRootPart.Position + Vector3.new(math.sin(angle)*6, 2, math.cos(angle)*6), p.Character.HumanoidRootPart.Position)
               end
            end)
            task.wait(0.01)
         end
      end)
   end,
})

TrollTab:CreateButton({
   Name = "Void Fling (Скинуть под карту) 🕳️",
   Callback = function()
      local p = getTarget()
      if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0) end
   end,
})

local frozenTarget = false
TrollTab:CreateToggle({
   Name = "Freeze Target (Заморозить цель) ❄️",
   CurrentValue = false,
   Callback = function(Value)
      frozenTarget = Value
      task.spawn(function()
         while frozenTarget do
            local p = getTarget()
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Anchored = true end
            task.wait(0.1)
         end
         local p = getTarget()
         if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Anchored = false end
      end)
   end,
})

TrollTab:CreateButton({
   Name = "Сделать цель ГИГАНТОМ ⬆️",
   Callback = function()
      local p = getTarget()
      if p and p.Character and p.Character:FindFirstChild("Humanoid") then
         local hum = p.Character.Humanoid
         if hum:FindFirstChild("BodyHeightScale") then hum.BodyHeightScale.Value = 5 end
         if hum:FindFirstChild("BodyWidthScale") then hum.BodyWidthScale.Value = 5 end
      end
   end,
})

TrollTab:CreateButton({
   Name = "Сделать цель КАРЛИКОМ ⬇️",
   Callback = function()
      local p = getTarget()
      if p and p.Character and p.Character:FindFirstChild("Humanoid") then
         local hum = p.Character.Humanoid
         if hum:FindFirstChild("BodyHeightScale") then hum.BodyHeightScale.Value = 0.3 end
         if hum:FindFirstChild("BodyWidthScale") then hum.BodyWidthScale.Value = 0.3 end
      end
   end,
})


-- ==========================================
--        4. ВКЛАДКА: ХАОС СЕРВЕРА 💥
-- ==========================================

ChaosTab:CreateToggle({
   Name = "Ломаная Анимация (Тряска себя) 💀",
   CurrentValue = false,
   Callback = function(Value)
      jerkAnim = Value
      local char = LocalPlayer.Character
      if not char then return end
      
      if jerkAnim then
         local anim = char:FindFirstChild("Animate")
         if anim then anim:Destroy() end
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hum then for _, track in pairs(hum:GetPlayingAnimationTracks()) do track:Stop() end end
         
         task.spawn(function()
            while jerkAnim and char and char:Parent do
               pcall(function()
                  for _, joint in pairs(char:GetDescendants()) do
                     if joint:IsA("Motor6D") then
                        joint.C0 = joint.C0 * CFrame.Angles(math.rad(math.random(-20, 20)), math.rad(math.random(-20, 20)), math.rad(math.random(-20, 20)))
                     end
                  end
               end)
               task.wait(0.01)
            end
         end)
      else
         Rayfield:Notify({Title = "N0XY HUB", Content = "Чтобы вернуть анимации, сделай Reset персонажа!", Duration = 4})
      end
   end,
})

ChaosTab:CreateToggle({
   Name = "Jerk All (Эпилепсия ВСЕМУ серверу)",
   CurrentValue = false,
   Callback = function(Value)
      jerkAll = Value
      task.spawn(function()
         while jerkAll do
            pcall(function()
               for _, p in pairs(Players:GetPlayers()) do
                  if p ~= LocalPlayer and p.Character then
                     for _, v in pairs(p.Character:GetDescendants()) do
                        if v:IsA("Motor6D") and v.Name ~= "RootJoint" then v.Transform = CFrame.Angles(math.random(-2,2), math.random(-2,2), math.random(-2,2)) end
                     end
                  end
               end
            end)
            task.wait(0.02)
         end
      end)
   end,
})

ChaosTab:CreateButton({
   Name = "Уничтожитель предметов (Destructor) 🗑️",
   Callback = function()
      for _, v in pairs(workspace:GetDescendants()) do
         if v:IsA("Part") and not v.Anchored and not v:IsDescendantOf(LocalPlayer.Character) then v:Destroy() end
      end
   end,
})

ChaosTab:CreateToggle({
   Name = "Kill Aura (Дамаг вокруг)",
   CurrentValue = false,
   Callback = function(Value)
      killAura = Value
      task.spawn(function()
         while killAura do
            pcall(function()
               local myHRP = LocalPlayer.Character.HumanoidRootPart
               for _, p in pairs(Players:GetPlayers()) do
                  if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                     if (myHRP.Position - p.Character.HumanoidRootPart.Position).Magnitude < 15 then
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                     end
                  end
               end
            end)
            task.wait(0.1)
         end
      end)
   end,
})

ChaosTab:CreateButton({
   Name = "Стянуть все физические блоки к себе 🧲",
   Callback = function()
      local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if myHRP then
         for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(LocalPlayer.Character) then part.CFrame = myHRP.CFrame + Vector3.new(0, 2, 0) end
         end
      end
   end
})


-- ==========================================
--        5. ВКЛАДКА: ВЕСЕЛЬЕ & ЧАТ 🤖
-- ==========================================

FunTab:CreateToggle({
   Name = "Spin Bot (Вращение) 🌀",
   CurrentValue = false,
   Callback = function(Value)
      spinBot = Value
      task.spawn(function()
         while spinBot do
            pcall(function()
               if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                  LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
               end
            end)
            task.wait(0.01)
         end
      end)
   end,
})

FunTab:CreateToggle({
   Name = "Size Randomizer (Мутант) 🧬",
   CurrentValue = false,
   Callback = function(Value)
      sizeRandomizer = Value
      task.spawn(function()
         while sizeRandomizer do
            pcall(function()
               local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
               if hum then
                  if hum:FindFirstChild("BodyHeightScale") then hum.BodyHeightScale.Value = math.random(3, 15) / 10 end
                  if hum:FindFirstChild("BodyWidthScale") then hum.BodyWidthScale.Value = math.random(3, 15) / 10 end
               end
            end)
            task.wait(1)
         end
      end)
   end,
})

FunTab:CreateButton({
   Name = "Фейк Сообщение в Чат 💬",
   Callback = function()
      local text = "[SYSTEM]: N0XY HUB зафиксирован на сервере. Права администратора переданы N0XY."
      pcall(function()
         local chatService = game:GetService("TextChatService")
         if chatService.ChatVersion == Enum.ChatVersion.TextChatService then 
            chatService.TextChannels.RBXGeneral:SendAsync(text) 
         else 
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All") 
         end
      end)
   end,
})

FunTab:CreateButton({
   Name = "Headless Mode (Убрать голову)",
   Callback = function()
      pcall(function()
         local head = LocalPlayer.Character:FindFirstChild("Head")
         if head then head.Transparency = 1 if head:FindFirstChildOfClass("Decal") then head:FindFirstChildOfClass("Decal"):Destroy() end end
      end)
   end,
})

FunTab:CreateButton({
   Name = "Invisible (Невидимость тела)",
   Callback = function()
      pcall(function()
         for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 1 end end
      end)
   end,
})

FunTab:CreateToggle({
   Name = "Авто-Спам в Чат фраз хакера",
   CurrentValue = false,
   Callback = function(Value)
      spammingChat = Value
      task.spawn(function()
         local Phrases = {"N0XY HUB контролирует этот сервер! 😎", "EZ! Слишком просто для N0XY HUB 🌟", "Скачивай N0XY HUB прямо сейчас!"}
         while spammingChat do
            local text = Phrases[math.random(1, #Phrases)]
            pcall(function()
               local chatService = game:GetService("TextChatService")
               if chatService.ChatVersion == Enum.ChatVersion.TextChatService then 
                  chatService.TextChannels.RBXGeneral:SendAsync(text) 
               else 
                  game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All") 
               end
            end)
            task.wait(4)
         end
      end)
   end,
})


-- ==========================================
--        ФОНОВЫЕ ПОТОКИ (PvP, НОУКЛИП И СКОРОСТЬ)
-- ==========================================
RunService.RenderStepped:Connect(function()
    if _G.Aim then
        local nearest = nil; local dist = math.huge
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local d = (p.Character.Head.Position - LocalPlayer.Character.Head.Position).Magnitude
                if d < dist then nearest = p.Character.Head; dist = d end
            end
        end
        if nearest then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, nearest.Position) end
    end
    if _G.AutoClick then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end
end)

RunService.Stepped:Connect(function()
   if noclip and LocalPlayer.Character then
      for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
   end
   if antiFling and LocalPlayer.Character then
      pcall(function()
         for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Velocity = Vector3.new(0,0,0) part.RotVelocity = Vector3.new(0,0,0) end
         end
      end)
   end
end)

task.spawn(function()
   while true do
      pcall(function()
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if hum.WalkSpeed ~= walkSpeedValue and not flying then hum.WalkSpeed = walkSpeedValue end
            if hum.JumpPower ~= jumpPowerValue then hum.UseJumpPower = true hum.JumpPower = jumpPowerValue end
         end
      end)
      task.wait(0.1)
   end
end)
