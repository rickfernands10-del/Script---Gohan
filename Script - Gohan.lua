--// GOHAN ULTIMATE SCRIPT (UNIFICADO + MELHORADO)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- 🛡️ ANTIFLING
--==================================================
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart

        if hrp.AssemblyLinearVelocity.Magnitude > 100 then
            hrp.AssemblyLinearVelocity = Vector3.zero
        end

        if hrp.AssemblyAngularVelocity.Magnitude > 50 then
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end
end)

--==================================================
-- 💀 IMORTAL (MELHORADO)
--==================================================
local imortal = false

local function applyImmortal()
    while imortal do
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge

                -- remove estados de morte/dano
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end
        task.wait()
    end
end

--==================================================
-- 🎯 ESP MELHORADO
--==================================================
local espActive = false
local espData = {}

local function applyESP(player)
    if player == LocalPlayer then return end

    local function create(char)
        if not espActive then return end

        if espData[char] then
            espData[char]:Destroy()
        end

        local hl = Instance.new("Highlight")
        hl.FillColor = Color3.fromRGB(0,255,255)
        hl.OutlineColor = Color3.fromRGB(255,255,255)
        hl.FillTransparency = 0.5
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = char
        hl.Parent = char

        espData[char] = hl
    end

    if player.Character then
        create(player.Character)
    end

    player.CharacterAdded:Connect(create)
end

for _,p in pairs(Players:GetPlayers()) do
    applyESP(p)
end

Players.PlayerAdded:Connect(applyESP)

--==================================================
-- 🧲 BRING (ESTABILIZADO)
--==================================================
local bringActive = false

RunService.RenderStepped:Connect(function()
    if bringActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = LocalPlayer.Character.HumanoidRootPart.Position + (Camera.CFrame.LookVector * 6)

        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart

                -- suaviza ao invés de teleportar seco
                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(myPos), 0.4)
            end
        end
    end
end)

--==================================================
-- 🧠 BOTÕES (INTEGRAÇÃO COM SEU MENU)
--==================================================

-- IMORTAL BUTTON (substitui o antigo)
imortalBtn.MouseButton1Click:Connect(function()
    imortal = not imortal

    if imortal then
        imortalBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
        imortalBtn.Text = "Immortal (ON)"
        task.spawn(applyImmortal)
    else
        imortalBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
        imortalBtn.Text = "Immortal (OFF)"
    end
end)

-- ESP BUTTON
espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive

    espBtn.BackgroundColor3 = espActive and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)

    if espActive then
        for _,p in pairs(Players:GetPlayers()) do
            if p.Character then
                applyESP(p)
            end
        end
    else
        for _,v in pairs(espData) do
            v:Destroy()
        end
        espData = {}
    end
end)

-- BRING BUTTON
bringBtn.MouseButton1Click:Connect(function()
    bringActive = not bringActive
    bringBtn.BackgroundColor3 = bringActive and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)

--==================================================
-- 📦 DROPKICK (ADICIONADO)
--==================================================
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LolnotaKid/JkDropKuck/refs/heads/main/Protected_3923618848403366.txt"))()
end)
