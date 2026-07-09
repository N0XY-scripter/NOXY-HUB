-- [[ N0XY MASTER ENGINE V8 — GOD MODE & ANTI-FLING FIXED ]] --
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
local Window = Rayfield:CreateWindow({
   Name = "N0XY MASTER ENGINE 💀 (v8)",
   LoadingTitle = "Загрузка N0XY CORE...",
   LoadingSubtitle = "by N0XY",
   ConfigurationSaving = {Enabled = false}
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- Переменные состояний
local flying = false
local flySpeed = 50
local noclip = false
local antiFling = false
local wsVal = 16
local jpVal = 50
local targetName = ""
local loopFling = false
local orbit = false
local kAu = false
local jrk = false
local musicId = ""
local cageLoop = false
local cagePart = nil
local godModeActive = false -- Переменная для Вкл/Выкл бессмертия
_G.Aim = false
_G.AutoClick = false

local function getT()
   for _, p in pairs(Players:GetPlayers()) do
      if p.Name:lower():sub(1, #targetName) == targetName or p.DisplayName:lower():sub(1, #targetName) == targetName then
         return p
      end
   end
   return nil
end

-- Вкладки
local T1 = Window:CreateTab("Главная & PvP ⚔️", 0)
local T3 = Window:CreateTab("Троллинг Цели 😈", 0)
local T4 = Window:CreateTab("Хаос Сервера 💥", 0)
local T6 = Window:CreateTab("Радио 🎵", 0)

-- ==========================================
-- ВКЛАДКА 1: ГЛАВНАЯ & PVP
-- ==========================================
local FlyC
T1:CreateToggle({
   Name = "Fly (Полёт по камере)",
   CurrentValue = false,
   Callback = function(v)
      flying = v
      if flying then
         local C = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
         local H = C:WaitForChild("HumanoidRootPart")
         local Hum = C:WaitForChild("Humanoid")
         local Cam = workspace.CurrentCamera
         Hum.PlatformStand = true
         FlyC = RunService.Heartbeat:Connect(function(dt)
            if not flying or not C or not H.Parent then if FlyC then FlyC:Disconnect() end return end
            local md = Hum.MoveDirection
            if md.Magnitude > 0 then
               local fd = (Cam.CFrame * CFrame.new(Vector3.new(md.X, 0, md.Z))).LookVector
               H.CFrame = H.CFrame + (fd * (flySpeed * dt))
            end
            H.Velocity = Vector3.new(0, 0, 0)
         end)
      else
         if FlyC then FlyC:Disconnect() end
         pcall(function() LocalPlayer.Character.Humanoid.PlatformStand = false end)
      end
   end
})

T1:CreateInput({
   Name = "Скорость Полета",
   PlaceholderText = "Стандарт: 50",
   Callback = function(t)
      local n = tonumber(t)
      if n then flySpeed = n end
   end
})

T1:CreateSlider({
   Name = "WalkSpeed (Скорость)",
   Range = {16, 250},
   Increment = 5,
   CurrentValue = 16,
   Callback = function(v) wsVal = v end
})

T1:CreateSlider({
   Name = "JumpPower (Прыжок)",
   Range = {50, 300},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(v) jpVal = v end
})

T1:CreateToggle({Name = "Noclip (Сквозь стены)", CurrentValue = false, Callback = function(v) noclip = v end})
T1:CreateToggle({Name = "Anti-Fling (Защита)", CurrentValue = false, Callback = function(v) antiFling = v end})
T1:CreateToggle({Name = "Aim-Lock (Наводка)", CurrentValue = false, Callback = function(v) _G.Aim = v end})
T1:CreateToggle({Name = "Auto-Clicker (Авто-удар)", CurrentValue = false, Callback = function(v) _G.AutoClick = v end})

-- ИСПРАВЛЕННЫЙ И БЕЗОПАСНЫЙ GOD MODE (ВКЛ / ВЫКЛ)
T1:CreateButton({
   Name = "Вкл/Выкл GOD MODE (Бессмертие) 🛡️",
   Callback = function()
      pcall(function()
         local c = LocalPlayer.Character
         local h = c:FindFirstChildOfClass("Humanoid")
         
         if not godModeActive then
            -- Включение бессмертия без багов камеры
            if h then
               godModeActive = true
               local clone = h:Clone()
               clone.Name = "N0XY_Humanoid"
               clone.Parent = c
               LocalPlayer.Character = nil
               h:Destroy()
               LocalPlayer.Character = c
               workspace.CurrentCamera.CameraSubject = c:WaitForChild("HumanoidRootPart")
               clone.MaxHealth = math.huge
               clone.Health = math.huge
               Rayfield:Notify({Title = "N0XY HUB", Content = "God Mode: АКТИВИРОВАН!", Duration = 3})
            end
         else
            -- Выключение бессмертия (возврат нормального состояния)
            godModeActive = false
            local fakeH = c:FindFirstChild("N0XY_Humanoid")
            if fakeH then
               local normalH = Instance.new("Humanoid", c)
               normalH.Name = "Humanoid"
               LocalPlayer.Character = nil
               fakeH:Destroy()
               LocalPlayer.Character = c
               workspace.CurrentCamera.CameraSubject = normalH
               Rayfield:Notify({Title = "N0XY HUB", Content = "God Mode: ВЫКЛЮЧЕН (Сделай Reset для сброса)", Duration = 3})
            end
         end
      end)
   end
})

T1:CreateButton({
   Name = "Invisibility (Невидимка) 👻",
   Callback = function()
      pcall(function()
         for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end
         end
         Rayfield:Notify({Title = "N0XY HUB", Content = "Ты невидимка!", Duration = 3})
      end)
   end
})

T1:CreateButton({
   Name = "Включить Вечный День ☀️",
   Callback = function() Lighting.TimeOfDay = "12:00:00" end
})

T1:CreateButton({
   Name = "Включить Вечную Ночь 🌙",
   Callback = function() Lighting.TimeOfDay = "00:00:00" end
})

-- ==========================================
-- ВКЛАДКА 3: ТРОЛЛИНГ ЦЕЛИ
-- ==========================================
T3:CreateInput({
   Name = "Ник жертвы",
   PlaceholderText = "Имя...",
   Callback = function(t) targetName = t:lower() end
})

T3:CreateButton({
   Name = "Жесткий Красный Куб 🟥",
   Callback = function()
      local p = getT()
      if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
         local h = p.Character.HumanoidRootPart
         
         cageLoop = false
         task.wait(0.05)
         if workspace:FindFirstChild("Cage_" .. p.Name) then workspace["Cage_" .. p.Name]:Destroy() end
         
         cagePart = Instance.new("Part", workspace)
         cagePart.Name = "Cage_" .. p.Name
         cagePart.Size = Vector3.new(12, 12, 12)
         cagePart.CFrame = h.CFrame
         cagePart.Anchored = true
         cagePart.Material = Enum.Material.ForceField
         cagePart.Color = Color3.fromRGB(255, 0, 0)
         cagePart.Transparency = 0.4
         cagePart.CanCollide = true
         
         cageLoop = true
         local cf = h.CFrame
         task.spawn(function()
            while cageLoop and cagePart and cagePart.Parent do
               pcall(function()
                  if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                     if (p.Character.HumanoidRootPart.Position - cagePart.Position).Magnitude > 5 then
                        p.Character.HumanoidRootPart.CFrame = cf
                     end
                  end
               end)
               task.wait(0.01)
            end
         end)
         Rayfield:Notify({Title = "N0XY HUB", Content = p.Name .. " заперт в КУБ НАМЕРТВО!", Duration = 3})
      end
   end
})

T3:CreateButton({
   Name = "Удалить все кубы ❌",
   Callback = function()
      cageLoop = false
      for _, v in pairs(workspace:GetChildren()) do if v.Name:sub(1, 5) == "Cage_" then v:Destroy() end end
   end
})

T3:CreateToggle({
   Name = "Loop Fling (Кошмарить вечно)",
   CurrentValue = false,
   Callback = function(v)
      loopFling = v
      task.spawn(function()
         while loopFling do
            pcall(function()
               local p = getT()
               if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  local mH = LocalPlayer.Character.HumanoidRootPart
                  mH.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-1, 1), 0, math.random(-1, 1))
                  mH.Velocity = Vector3.new(7000, 7000, 7000)
                  mH.RotVelocity = Vector3.new(7000, 7000, 7000)
               end
            end)
            task.wait(0.01)
         end
      end)
   end
})

T3:CreateToggle({
   Name = "Orbit (Орбита вокруг цели)",
   CurrentValue = false,
   Callback = function(v)
      orbit = v
      task.spawn(function()
         local a = 0
         while orbit do
            pcall(function()
               local p = getT()
               if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  a = a + 0.1
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(p.Character.HumanoidRootPart.Position + Vector3.new(math.sin(a) * 6, 2, math.cos(a) * 6), p.Character.HumanoidRootPart.Position)
               end
            end)
            task.wait(0.01)
         end
      end)
   end
})

T3:CreateButton({
   Name = "Void Fling (Под карту) 🕳️",
   Callback = function()
      local p = getT()
      if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0) end
   end
})

local fz = false
T3:CreateToggle({
   Name = "Freeze Target (Заморозить) ❄️",
   CurrentValue = false,
   Callback = function(v)
      fz = v
      task.spawn(function()
         while fz do
            pcall(function() getT().Character.HumanoidRootPart.Anchored = true end)
            task.wait(0.1)
         end
         pcall(function() getT().Character.HumanoidRootPart.Anchored = false end)
      end)
   end
})

-- ==========================================
-- ВКЛАДКА 4: ХАОС СЕРВЕРА
-- ==========================================
T4:CreateButton({
   Name = "Crash Server (Повесить сервер) 🛑",
   Callback = function()
      Rayfield:Notify({Title = "N0XY HUB", Content = "Запуск крашера... Сервер ложится!", Duration = 5})
      task.spawn(function()
         while task.wait(0.001) do
            pcall(function()
               local f = Instance.new("Folder", workspace)
               for i = 1, 500 do
                  local p = Instance.new("Part", f)
                  p.Size = Vector3.new(1, 1, 1)
                  p.Transparency = 1
                  p.CanCollide = false
               end
            end)
         end
      end)
   end
})

T4:CreateToggle({
   Name = "Ломаная Анимация 💀",
   CurrentValue = false,
   Callback = function(v)
      jrk = v
      local c = LocalPlayer.Character
      if not c then return end
      if jrk then
         local an = c:FindFirstChild("Animate") if an then an:Destroy() end
         local hu = c:FindFirstChildOfClass("Humanoid") if hu then for _, t in pairs(hu:GetPlayingAnimationTracks()) do t:Stop() end end
         task.spawn(function()
            while jrk and c and c.Parent do
               pcall(function()
                  for _, j in pairs(c:GetDescendants()) do
                     if j:IsA("Motor6D") then
                        j.C0 = j.C0 * CFrame.Angles(math.rad(math.random(-20, 20)), math.rad(math.random(-20, 20)), math.rad(math.random(-20, 20)))
                     end
                  end
               end)
               task.wait(0.01)
            end
         end)
      else
         Rayfield:Notify({Title = "N0XY HUB", Content = "Сделай Reset персонажа!", Duration = 4})
      end
   end
})

T4:CreateButton({
   Name = "Уничтожитель предметов 🗑️",
   Callback = function()
      for _, v in pairs(workspace:GetDescendants()) do
         if v:IsA("Part") and not v.Anchored and not v:IsDescendantOf(LocalPlayer.Character) then v:Destroy() end
      end
   end
})

T4:CreateToggle({
   Name = "Kill Aura (Дамаг вокруг)",
   CurrentValue = false,
   Callback = function(v)
      kAu = v
      task.spawn(function()
         while kAu do
            pcall(function()
               local mH = LocalPlayer.Character.HumanoidRootPart
               for _, p in pairs(Players:GetPlayers()) do
                  if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                     if (mH.Position - p.Character.HumanoidRootPart.Position).Magnitude < 15 then
                        local tl = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tl then tl:Activate() end
                     end
                  end
               end
            end)
            task.wait(0.1)
         end
      end)
   end
})

T4:CreateButton({
   Name = "Стянуть все blocks к себе 🧲",
   Callback = function()
      local mH = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if mH then
         for _, pt in pairs(workspace:GetDescendants()) do
            if pt:IsA("BasePart") and not pt.Anchored and not pt:IsDescendantOf(LocalPlayer.Character) then pt.CFrame = mH.CFrame + Vector3.new(0, 2, 0) end
         end
      end
   end
})

-- ==========================================
-- ВКЛАДКА 6: РАДИО
-- ==========================================
T6:CreateInput({
   Name = "ID Музыки",
   PlaceholderText = "ID...",
   Callback = function(t) musicId = t end
})

T6:CreateButton({
   Name = "Включить музыку 🔊",
   Callback = function()
      pcall(function()
         local s = workspace:FindFirstChild("N0XY_Radio") or Instance.new("Sound", workspace)
         s.Name = "N0XY_Radio"
         s.SoundId = "rbxassetid://" .. musicId
         s.Volume = 2
         s.Looped = true
         s:Play()
      end)
   end
})

T6:CreateButton({
   Name = "Остановить 🔇",
   Callback = function()
      pcall(function()
         local s = workspace:FindFirstChild("N0XY_Radio")
         if s then s:Stop() s:Destroy() end
      end)
   end
})

-- Потоки обновлений
RunService.RenderStepped:Connect(function()
   if _G.Aim then
      local nr = nil
      local di = math.huge
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local d = (p.Character.Head.Position - LocalPlayer.Character.Head.Position).Magnitude
            if d < di then nr = p.Character.Head di = d end
         end
      end
      if nr then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, nr.Position) end
   end
   if _G.AutoClick then
      local tl = LocalPlayer.Character:FindFirstChildOfClass("Tool")
      if tl then tl:Activate() end
   end
end)

-- ИСПРАВЛЕННЫЙ АНТИ-ФЛИНГ (НЕ ЛОМАЕТ WALKSPEED)
RunService.Stepped:Connect(function()
   if noclip and LocalPlayer.Character then
      for _, pt in pairs(LocalPlayer.Character:GetDescendants()) do if pt:IsA("BasePart") then pt.CanCollide = false end end
   end
   if antiFling and LocalPlayer.Character then
      pcall(function()
         -- Безопасный режим: отключаем коллизию с другими игроками и гасим опасный угловой момент (вращение)
         for _, pt in pairs(LocalPlayer.Character:GetDescendants()) do 
            if pt:IsA("BasePart") then 
               pt.RotVelocity = Vector3.new(0, 0, 0) -- Убираем только закручивание, скорость не трогаем!
            end 
         end
         for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= LocalPlayer and otherPlayer.Character then
               for _, pt in pairs(otherPlayer.Character:GetDescendants()) do
                  if pt:IsA("BasePart") then pt.CanCollide = false end
               end
            end
         end
      end)
   end
end)

task.spawn(function()
   while true do
      pcall(function()
         if LocalPlayer.Character then
            -- Ищем активный гуманоид (оригинальный или кастомный от God Mode)
            local hu = LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer.Character:FindFirstChild("N0XY_Humanoid")
            if hu then
               if hu.WalkSpeed ~= wsVal and not flying then hu.WalkSpeed = wsVal end
               if hu.JumpPower ~= jpVal then hu.UseJumpPower = true hu.JumpPower = jpVal end
            end
         end
      end)
      task.wait(0.1)
   end
end)
