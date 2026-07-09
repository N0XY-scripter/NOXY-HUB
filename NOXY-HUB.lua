-- [[ N0XY MASTER ENGINE V7 — PART 1 ]] --
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "N0XY MASTER ENGINE 💀 (v7)",
   LoadingTitle = "Загрузка N0XY CORE...",
   LoadingSubtitle = "by N0XY",
   ConfigurationSaving = { Enabled = false }
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
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
local jerkAnim = false
local spinBot = false
local sizeRandomizer = false

_G.Aim = false
_G.AutoClick = false

local SkyTypes = {
    ["Space"] = "http://www.roblox.com/asset/?id=600831435",
    ["Fire"] = "http://www.roblox.com/asset/?id=580873633",
    ["Night"] = "http://www.roblox.com/asset/?id=600831435"
}

local function getTarget()
   for _, p in pairs(Players:GetPlayers()) do
      if p.Name:lower():sub(1, #targetPlayerName) == targetPlayerName or p.DisplayName:lower():sub(1, #targetPlayerName) == targetPlayerName then
         return p
      end
   end
   return nil
end

local MainTab = Window:CreateTab("Главная & PvP ⚔️", 0)
local WorldTab = Window:CreateTab("Мир & Небо 🌌", 0)

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

WorldTab:CreateDropdown({
    Name = "Выбрать кастомное небо (Skybox)",
    Options = {"Space", "Fire", "Night"},
    Callback = function(Option)
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
        sky.SkyboxBk = SkyTypes[Option]; sky.SkyboxDn = SkyTypes[Option]; sky.SkyboxFt = SkyTypes[Option]
        sky.SkyboxLf = SkyTypes[Option]; sky.SkyboxRt = SkyTypes[Option]; sky.SkyboxUp = SkyTypes[Option]
    end
})

WorldTab:CreateButton({ Name = "Fog Disable (Убрать туман)", Callback = function() Lighting.FogEnd = 100000 end })
WorldTab:CreateSlider({ Name = "Гравитация Мира 🌍", Range = {0, 400}, Increment = 10, CurrentValue = 196, Callback = function(Value) workspace.Gravity = Value end })
WorldTab:CreateButton({ Name = "Включить Вечную Ночь 🌙", Callback = function() Lighting.TimeOfDay = "00:00:00" end })
WorldTab:CreateButton({ Name = "Включить Вечный День ☀️", Callback = function() Lighting.TimeOfDay = "12:00:00" end })

-- [[ ПОДКЛЮЧАЕМ ВТОРУЮ ЧАСТЬ НАПРЯМУЮ ИЗ ТВОЕГО ГИТХАБА ]] --
-- ТУТ МЫ СЕЙЧАС СДЕЛАЕМ ЗАГРУЗКУ. ПОКА СКОПИРУЙ ЭТОТ КУСОК!
