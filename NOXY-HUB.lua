-- [[ N0XY MASTER ENGINE V13 — THE ULTIMATE FULL EDITION ]] --
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
local Window = Rayfield:CreateWindow({
   Name = "N0XY MASTER ENGINE 💀 (v13)",
   LoadingTitle = "Загрузка N0XY CORE...",
   LoadingSubtitle = "by N0XY",
   ConfigurationSaving = {Enabled = false}
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Базовые переменные
local flying, noclip, antiFling, infJump = false, false, false, false
local flySpeed, wsVal, jpVal = 50, 16, 50
local targetName = ""
local loopFling, orbit, kAu, jrk, fz, gravStorm, godModeActive = false, false, false, false, false, false, false
local stalkLoop, discoMapActive, discoBallsActive, trailActive = false, false, false, false
local cageLoop, cagePart = false, nil
local discoBallsList, myTrail, a0, a1 = {}, nil, nil, nil
local musicId = ""
_G.Aim, _G.AutoClick = false, false

local function getT()
   for _, p in pairs(Players:GetPlayers()) do
      if p.Name:lower():sub(1, #targetName) == targetName or p.DisplayName:lower():sub(1, #targetName) == targetName then return p end
   end
   return nil
end

-- Вкладки
local T1 = Window:CreateTab("Главная & PvP ⚔️", 0)
local T8 = Window:CreateTab("Фан & Веселье 🎪", 0)
local T7 = Window:CreateTab("Дискотека 🪩", 0)
local T3 = Window:CreateTab("Троллинг Цели 😈", 0)
local T4 = Window:CreateTab("Хаос Сервера 💥", 0)
local T6 = Window:CreateTab("Радио 🎵", 0)

-- ==========================================
-- ВКЛАДКА 1: ГЛАВНАЯ & PVP
-- ==========================================
local FlyC
T1:CreateToggle({Name = "Fly (Полёт по камере)", CurrentValue = false, Callback = function(v)
   flying = v
   if flying then
      local C = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
      local H, Hum, Cam = C:WaitForChild("HumanoidRootPart"), C:WaitForChild("Humanoid"), workspace.CurrentCamera
      Hum.PlatformStand = true
      FlyC = RunService.Heartbeat:Connect(function(dt)
         if not flying or not C or not H.Parent then if FlyC then FlyC:Disconnect() end return end
         local md = Hum.MoveDirection
         if md.Magnitude > 0 then H.CFrame = H.CFrame + ((Cam.CFrame * CFrame.new(Vector3.new(md.X, 0, md.Z))).LookVector * (flySpeed * dt)) end
         H.Velocity = Vector3.new(0, 0, 0)
      end)
   else
      if FlyC then FlyC:Disconnect() end pcall(function() LocalPlayer.Character.Humanoid.PlatformStand = false end)
   end
end})
T1:CreateInput({Name = "Скорость Полета", PlaceholderText = "50", Callback = function(t) if tonumber(t) then flySpeed = tonumber(t) end end})
T1:CreateSlider({Name = "WalkSpeed (Скорость)", Range = {16, 250}, Increment = 5, CurrentValue = 16, Callback = function(v) wsVal = v end})
T1:CreateSlider({Name = "JumpPower (Прыжок)", Range = {50, 300}, Increment = 5, CurrentValue = 50, Callback = function(v) jpVal = v end})
T1:CreateToggle({Name = "Infinite Jump (Прыжки в воздухе)", CurrentValue = false, Callback = function(v) infJump = v end})
UserInputService.JumpRequest:Connect(function() if infJump and LocalPlayer.Character then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)
T1:CreateButton({Name = "Speed Dash (Рывок вперед) ⚡", Callback = function() local c = LocalPlayer.Character if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame + (c.HumanoidRootPart.CFrame.LookVector * 100) end end})
T1:CreateToggle({Name = "Noclip (Сквозь стены)", CurrentValue = false, Callback = function(v) noclip = v end})
T1:CreateToggle({Name = "Anti-Fling (Защита)", CurrentValue = false, Callback = function(v) antiFling = v end})
T1:CreateButton({Name = "Вкл/Выкл GOD MODE 🛡️", Callback = function()
   pcall(function()
      local c = LocalPlayer.Character local h = c:FindFirstChildOfClass("Humanoid")
      if not godModeActive and h then
         godModeActive = true local cl = h:Clone() cl.Name, cl.Parent = "N0XY_Humanoid", c
         LocalPlayer.Character = nil h:Destroy() LocalPlayer.Character = c
         workspace.CurrentCamera.CameraSubject = c:WaitForChild("HumanoidRootPart")
         cl.MaxHealth, cl.Health = math.huge, math.huge
      elseif godModeActive then
         godModeActive = false local fH = c:FindFirstChild("N0XY_Humanoid")
         if fH then
            local nH = Instance.new("Humanoid", c) nH.Name = "Humanoid"
            LocalPlayer.Character = nil fH:Destroy() LocalPlayer.Character = c
            workspace.CurrentCamera.CameraSubject = nH
         end
      end
   end)
end})
T1:CreateButton({Name = "Invisibility (Невидимка) 👻", Callback = function() pcall(function() for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end end end) end})
T1:CreateButton({Name = "Включить Вечный День ☀️", Callback = function() Lighting.TimeOfDay = "12:00:00" end})
T1:CreateButton({Name = "Включить Вечную Ночь 🌙", Callback = function() Lighting.TimeOfDay = "00:00:00" end})
T1:CreateToggle({Name = "ESP (Видеть игроков) 👁️", CurrentValue = false, Callback = function(v)
   for _, p in pairs(Players:GetPlayers()) do
      if p ~= LocalPlayer and p.Character then
         local hl = p.Character:FindFirstChild("N0XY_ESP") or Instance.new("Highlight", p.Character)
         hl.Name, hl.Enabled = "N0XY_ESP", v
      end
   end
end})

-- ==========================================
-- ВКЛАДКА 8: ФАН & ВЕСЕЛЬЕ
-- ==========================================
local anims = {
   ["Танец 1 (Базовый)"] = "507777826",
   ["Танец 2 (Клубный)"] = "507776043",
   ["Танец 3 (Ритмичный)"] = "507777268",
   ["Радость (Прыжки)"] = "507771019",
   ["Смех (Ржать)"] = "507770818"
}
local selectedAnimId = anims["Танец 1 (Базовый)"]

T8:CreateDropdown({
   Name = "Выбрать анимацию 🕺",
   Options = {"Танец 1 (Базовый)", "Танец 2 (Клубный)", "Танец 3 (Ритмичный)", "Радость (Прыжки)", "Смех (Ржать)"},
   CurrentOption = {"Танец 1 (Базовый)"},
   Callback = function(Option)
      selectedAnimId = anims[Option[1]]
   end,
})

T8:CreateButton({
   Name = "Запустить выбранную анимацию для всех 🎬",
   Callback = function()
      for _, p in pairs(Players:GetPlayers()) do
         if p.Character and p.Character:FindFirstChild("Humanoid") then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. selectedAnimId
            p.Character.Humanoid:LoadAnimation(anim):Play()
         end
      end
      Rayfield:Notify({Title = "N0XY HUB", Content = "Анимация запущена для всех!", Duration = 3})
   end
})

T8:CreateToggle({Name = "Гигантские головы 🤡", CurrentValue = false, Callback = function(v)
   task.spawn(function()
      while v do
         pcall(function()
            for _, p in pairs(Players:GetPlayers()) do
               if p.Character then
                  local hs = p.Character:FindFirstChild("HeadScale", true) if hs and hs:IsA("NumberValue") then hs.Value = 3 end
                  local h = p.Character:FindFirstChild("Head") if h and h:FindFirstChildOfClass("SpecialMesh") then h:FindFirstChildOfClass("SpecialMesh").Scale = Vector3.new(3,3,3) end
               end
            end
         end)
         if not v then break end
         task.wait(1)
      end
      for _, p in pairs(Players:GetPlayers()) do
         pcall(function()
            local hs = p.Character:FindFirstChild("HeadScale", true) if hs then hs.Value = 1 end
            local h = p.Character:FindFirstChild("Head") if h and h:FindFirstChildOfClass("SpecialMesh") then h:FindFirstChildOfClass("SpecialMesh").Scale = Vector3.new(1.25, 1.25, 1.25) end
         end)
      end
   end)
end})
T8:CreateToggle({Name = "Неоновый персонаж (Радуга) 🌈", CurrentValue = false, Callback = function(v)
   local rbw = v
   task.spawn(function()
      local hue = 0
      while rbw do
         hue = (hue + 0.05) % 1
         pcall(function() if LocalPlayer.Character then for _, pt in pairs(LocalPlayer.Character:GetChildren()) do if pt:IsA("BasePart") then pt.Color = Color3.fromHSV(hue, 1, 1) pt.Material = Enum.Material.Neon end end end end)
         task.wait(0.1)
      end
   end)
end})
T8:CreateToggle({Name = "Лунная Гравитация 🌕", CurrentValue = false, Callback = function(v) if v then workspace.Gravity = 40 else workspace.Gravity = 196.2 end end})
T8:CreateButton({Name = "Попкорн (Подкинуть всех) 🍿", Callback = function() for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Velocity = Vector3.new(math.random(-50,50), 300, math.random(-50,50)) end end end})

-- ==========================================
-- ВКЛАДКА 7: ДИСКОТЕКА
-- ==========================================
T7:CreateToggle({Name = "Дискотека по карте", CurrentValue = false, Callback = function(v)
   discoMapActive = v
   if discoMapActive then
      task.spawn(function()
         local hue = 0
         while discoMapActive do pcall(function() hue = (hue + 0.01) % 1 Lighting.Ambient = Color3.fromHSV(hue, 1, 1) Lighting.OutdoorAmbient = Color3.fromHSV(hue, 1, 1) end) task.wait(0.01) end
      end)
   else
      Lighting.Ambient = Color3.fromRGB(128, 128, 128) Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
   end
end})
T7:CreateToggle({Name = "Шары дискотеки", CurrentValue = false, Callback = function(v)
   discoBallsActive = v
   if discoBallsActive then
      local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
      local numBalls, radius, rotationSpeed, floatSpeed, floatAmplitude = 10, 8, 2, 3, 1
      discoBallsList = {}
      for i = 1, numBalls do
         local orb = Instance.new("Part") orb.Shape, orb.Size, orb.Anchored, orb.CanCollide, orb.Material = Enum.PartType.Ball, Vector3.new(2, 2, 2), true, false, Enum.Material.Neon orb.Parent = workspace
         local light = Instance.new("PointLight") light.Brightness, light.Parent = 5, orb table.insert(discoBallsList, orb)
      end
      local timePassed = 0
      discoBallsConnection = RunService.Heartbeat:Connect(function(dt)
         if not hrp or not hrp.Parent or not discoBallsActive then return end
         timePassed = timePassed + dt
         for i, orb in ipairs(discoBallsList) do
            if orb and orb.Parent then
               local angle = (timePassed * rotationSpeed) + (i * (math.pi * 2 / numBalls))
               orb.Position = hrp.Position + Vector3.new(math.cos(angle) * radius, math.sin(timePassed * floatSpeed + i) * floatAmplitude + 2, math.sin(angle) * radius)
               local hue = (timePassed * 0.2 + (i/numBalls)) % 1 local color = Color3.fromHSV(hue, 0.8, 1)
               orb.Color = color if orb:FindFirstChild("PointLight") then orb.PointLight.Color = color end
            end
         end
      end)
   else
      if discoBallsConnection then discoBallsConnection:Disconnect() end
      for _, orb in pairs(discoBallsList) do if orb then orb:Destroy() end end discoBallsList = {}
   end
end})
T7:CreateToggle({Name = "Световой меч (RGB Trail) 🌈", CurrentValue = false, Callback = function(v)
   trailActive = v
   local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end
   if trailActive then
      a0 = Instance.new("Attachment", hrp) a0.Position = Vector3.new(0, 1, 0)
      a1 = Instance.new("Attachment", hrp) a1.Position = Vector3.new(0, -1, 0)
      myTrail = Instance.new("Trail", hrp) myTrail.Attachment0, myTrail.Attachment1 = a0, a1 myTrail.Lifetime, myTrail.LightEmission = 0.5, 1
      task.spawn(function() local h = 0 while trailActive and myTrail and myTrail.Parent do h = (h + 0.02) % 1 myTrail.Color = ColorSequence.new(Color3.fromHSV(h, 1, 1)) task.wait(0.05) end end)
   else
      if myTrail then myTrail:Destroy() end if a0 then a0:Destroy() end if a1 then a1:Destroy() end
   end
end})

-- ==========================================
-- ВКЛАДКА 3: ТРОЛЛИНГ ЦЕЛИ
-- ==========================================
T3:CreateInput({Name = "Ник жертвы", PlaceholderText = "Имя...", Callback = function(t) targetName = t:lower() end})
T3:CreateButton({Name = "ТП за спину цели 🎯", Callback = function() local p = getT() if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end end})
T3:CreateToggle({Name = "Наглый угон (Stalk) 👀", CurrentValue = false, Callback = function(v) stalkLoop = v end})
T3:CreateButton({Name = "Жесткий Красный Куб 🟥", Callback = function()
   local p = getT()
   if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
      local h = p.Character.HumanoidRootPart
      cageLoop = false task.wait(0.05)
      if workspace:FindFirstChild("Cage_" .. p.Name) then workspace["Cage_" .. p.Name]:Destroy() end
      cagePart = Instance.new("Part", workspace) cagePart.Name, cagePart.Size, cagePart.CFrame, cagePart.Anchored, cagePart.Material, cagePart.Color, cagePart.Transparency, cagePart.CanCollide = "Cage_" .. p.Name, Vector3.new(12, 12, 12), h.CFrame, true, Enum.Material.ForceField, Color3.fromRGB(255, 0, 0), 0.4, true
      cageLoop = true local cf = h.CFrame
      task.spawn(function() while cageLoop and cagePart and cagePart.Parent do pcall(function() if (p.Character.HumanoidRootPart.Position - cagePart.Position).Magnitude > 5 then p.Character.HumanoidRootPart.CFrame = cf end end) task.wait(0.01) end end)
   end
end})
T3:CreateButton({Name = "Удалить все кубы ❌", Callback = function() cageLoop = false for _, v in pairs(workspace:GetChildren()) do if v.Name:sub(1, 5) == "Cage_" then v:Destroy() end end end})
T3:CreateToggle({Name = "Loop Fling", CurrentValue = false, Callback = function(v) loopFling = v end})
T3:CreateToggle({Name = "Orbit (Орбита)", CurrentValue = false, Callback = function(v) orbit = v end})
T3:CreateButton({Name = "Void Fling (Под карту)", Callback = function() local p = getT() if p and p.Character then p.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0) end end})
T3:CreateToggle({Name = "Freeze (Заморозить)", CurrentValue = false, Callback = function(v) fz = v pcall(function() if not fz then getT().Character.HumanoidRootPart.Anchored = false end end) end})

-- ==========================================
-- ВКЛАДКА 4: ХАОС СЕРВЕРА
-- ==========================================
T4:CreateButton({Name = "Crash Server 🛑", Callback = function() task.spawn(function() while task.wait(0.001) do pcall(function() local f = Instance.new("Folder", workspace) for i = 1, 500 do local p = Instance.new("Part", f) p.Size = Vector3.new(1, 1, 1) p.Transparency = 1 p.CanCollide = false end end) end end) end})
T4:CreateToggle({Name = "Гравитационный шторм 🌪️", CurrentValue = false, Callback = function(v) gravStorm = v end})
T4:CreateToggle({Name = "Ломаная Анимация 💀", CurrentValue = false, Callback = function(v)
   jrk = v local c = LocalPlayer.Character
   if jrk and c then
      local an = c:FindFirstChild("Animate") if an then an:Destroy() end
      for _, t in pairs(c:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks()) do t:Stop() end
      task.spawn(function() while jrk and c and c.Parent do pcall(function() for _, j in pairs(c:GetDescendants()) do if j:IsA("Motor6D") then j.C0 = j.C0 * CFrame.Angles(math.rad(math.random(-20, 20)), math.rad(math.random(-20, 20)), math.rad(math.random(-20, 20))) end end end) task.wait(0.01) end end)
   end
end})
T4:CreateButton({Name = "Уничтожитель предметов 🗑️", Callback = function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Part") and not v.Anchored and not v:IsDescendantOf(LocalPlayer.Character) then v:Destroy() end end end})
T4:CreateToggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) kAu = v end})
T4:CreateButton({Name = "Стянуть все blocks к себе 🧲", Callback = function() local mH = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if mH then for _, pt in pairs(workspace:GetDescendants()) do if pt:IsA("BasePart") and not pt.Anchored and not pt:IsDescendantOf(LocalPlayer.Character) then pt.CFrame = mH.CFrame + Vector3.new(0, 2, 0) end end end end})

-- ==========================================
-- ВКЛАДКА 6: РАДИО
-- ==========================================
T6:CreateInput({Name = "ID Музыки", PlaceholderText = "ID...", Callback = function(t) musicId = t end})
T6:CreateButton({Name = "Включить музыку 🔊", Callback = function() pcall(function() local s = workspace:FindFirstChild("N0XY_Radio") or Instance.new("Sound", workspace) s.Name, s.SoundId, s.Volume, s.Looped = "N0XY_Radio", "rbxassetid://" .. musicId, 2, true s:Play() end) end})
T6:CreateButton({Name = "Остановить 🔇", Callback = function() pcall(function() local s = workspace:FindFirstChild("N0XY_Radio") if s then s:Stop() s:Destroy() end end) end})

-- ==========================================
-- СИСТЕМНЫЕ ПОТОКИ
-- ==========================================
RunService.RenderStepped:Connect(function()
   if stalkLoop then pcall(function() local p = getT() if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end end) end
end)

RunService.Stepped:Connect(function()
   if noclip and LocalPlayer.Character then for _, pt in pairs(LocalPlayer.Character:GetDescendants()) do if pt:IsA("BasePart") then pt.CanCollide = false end end end
   if antiFling and LocalPlayer.Character then
      pcall(function()
         for _, pt in pairs(LocalPlayer.Character:GetDescendants()) do if pt:IsA("BasePart") then pt.RotVelocity = Vector3.new(0, 0, 0) end end
         for _, o in pairs(Players:GetPlayers()) do if o ~= LocalPlayer and o.Character then for _, pt in pairs(o.Character:GetDescendants()) do if pt:IsA("BasePart") then pt.CanCollide = false end end end end
      end)
   end
end)

task.spawn(function()
   local a = 0
   while true do
      pcall(function()
         if LocalPlayer.Character then
            local hu = LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer.Character:FindFirstChild("N0XY_Humanoid")
            if hu then if hu.WalkSpeed ~= wsVal and not flying then hu.WalkSpeed = wsVal end if hu.JumpPower ~= jpVal then hu.UseJumpPower = true hu.JumpPower = jpVal end end
         end
         if fz then getT().Character.HumanoidRootPart.Anchored = true end
         if orbit then local p = getT() if p and p.Character then a = a + 0.1 LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(p.Character.HumanoidRootPart.Position + Vector3.new(math.sin(a) * 6, 2, math.cos(a) * 6), p.Character.HumanoidRootPart.Position) end end
         if loopFling then local p = getT() if p and p.Character then local mH = LocalPlayer.Character.HumanoidRootPart mH.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-1, 1), 0, math.random(-1, 1)) mH.Velocity, mH.RotVelocity = Vector3.new(7000, 7000, 7000), Vector3.new(7000, 7000, 7000) end end
         if kAu then local mH = LocalPlayer.Character.HumanoidRootPart for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and (mH.Position - p.Character.HumanoidRootPart.Position).Magnitude < 15 then local tl = LocalPlayer.Character:FindFirstChildOfClass("Tool") if tl then tl:Activate() end end end end
         if gravStorm then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and not v.Anchored and not v:IsDescendantOf(LocalPlayer.Character) then v.Velocity = Vector3.new(math.random(-50, 50), math.random(50, 150), math.random(-50, 50)) end end end
      end)
      task.wait(0.1)
   end
end)
