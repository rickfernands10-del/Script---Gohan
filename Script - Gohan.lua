--// GUI Script Completo - Script Gohan

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GohanGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- FUNÇÃO PARA ARRASTAR GUI
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

-- CÍRCULO BOTÃO
local buttonCircle = Instance.new("ImageButton")
buttonCircle.Size = UDim2.new(0, 80, 0, 80)
buttonCircle.Position = UDim2.new(0.5, -40, 0.5, -40)
buttonCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
buttonCircle.Image = "rbxassetid://631940830"
buttonCircle.BorderSizePixel = 3
buttonCircle.BorderColor3 = Color3.new(0,0,0)
buttonCircle.Parent = screenGui
buttonCircle.ZIndex = 2
makeDraggable(buttonCircle)

-- MENU
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 300, 0, 400)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
menuFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
menuFrame.BorderColor3 = Color3.new(1,1,1)
menuFrame.BorderSizePixel = 2
menuFrame.Visible = false
menuFrame.Parent = screenGui
makeDraggable(menuFrame)

-- TÍTULO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Script - Gohan"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.Parent = menuFrame

-----------------------------------------------------------------------
-- FUNÇÃO SLIDER COM BOTÕES
-----------------------------------------------------------------------
local function createSlider(parent, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 70)
    frame.Position = UDim2.new(0, 10, 0, (#parent:GetChildren()-1)*70)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,20)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 18
    label.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.7,0,0,20)
    sliderFrame.Position = UDim2.new(0,0,0,30)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sliderFrame.BorderColor3 = Color3.new(1,1,1)
    sliderFrame.BorderSizePixel = 1
    sliderFrame.Parent = frame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(200,200,200)
    sliderFill.Parent = sliderFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0,50,1,0)
    valueLabel.Position = UDim2.new(1,5,0,0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.new(1,1,1)
    valueLabel.Font = Enum.Font.SourceSans
    valueLabel.TextSize = 16
    valueLabel.Parent = sliderFrame

    local dragging = false

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)

    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X,0,sliderFrame.AbsoluteSize.X)
            local percent = relativeX/sliderFrame.AbsoluteSize.X
            sliderFill.Size = UDim2.new(percent,0,1,0)
            local value = math.floor(min + (max-min)*percent)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)

    -- Botão +
    local plus = Instance.new("TextButton")
    plus.Size = UDim2.new(0,25,0,25)
    plus.Position = UDim2.new(0.75,45,0,28)
    plus.Text = "+"
    plus.TextColor3 = Color3.new(1,1,1)
    plus.Font = Enum.Font.SourceSansBold
    plus.TextSize = 20
    plus.BackgroundColor3 = Color3.fromRGB(50,50,50)
    plus.BorderColor3 = Color3.new(1,1,1)
    plus.Parent = frame

    plus.MouseButton1Click:Connect(function()
        local newVal = math.min(max, tonumber(valueLabel.Text) + 1)
        valueLabel.Text = tostring(newVal)
        sliderFill.Size = UDim2.new((newVal-min)/(max-min),0,1,0)
        callback(newVal)
    end)

    -- Botão -
    local minus = Instance.new("TextButton")
    minus.Size = UDim2.new(0,25,0,25)
    minus.Position = UDim2.new(0.75,10,0,28)
    minus.Text = "-"
    minus.TextColor3 = Color3.new(1,1,1)
    minus.Font = Enum.Font.SourceSansBold
    minus.TextSize = 20
    minus.BackgroundColor3 = Color3.fromRGB(50,50,50)
    minus.BorderColor3 = Color3.new(1,1,1)
    minus.Parent = frame

    minus.MouseButton1Click:Connect(function()
        local newVal = math.max(min, tonumber(valueLabel.Text) - 1)
        valueLabel.Text = tostring(newVal)
        sliderFill.Size = UDim2.new((newVal-min)/(max-min),0,1,0)
        callback(newVal)
    end)
end

-----------------------------------------------------------------------
-- SPEED
-----------------------------------------------------------------------
createSlider(menuFrame, "Speed", 16, 500, 16, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

-----------------------------------------------------------------------
-- SIZE (SERVER-LIKE)
-----------------------------------------------------------------------
createSlider(menuFrame, "Size", 1, 10, 1, function(val)
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Size = Vector3.new(val, val, val)
            end
        end
    end
end)

-----------------------------------------------------------------------
-- AIMBOT MELHORADO
-----------------------------------------------------------------------
local aimbotValue = 0
local aiming = false

local function getClosestToCenter()
    local cam = workspace.CurrentCamera
    local closest = nil
    local closestDist = math.huge

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local screenPos, onScreen = cam:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) -
                    Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude

                local ray = Ray.new(cam.CFrame.Position, (head.Position - cam.CFrame.Position).Unit * 5000)
                local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character)

                if hit and hit:IsDescendantOf(p.Character) then
                    if dist < closestDist then
                        closestDist = dist
                        closest = p
                    end
                end
            end
        end
    end
    return closest
end

createSlider(menuFrame, "Aimbot", 0, 100, 0, function(val)
    aimbotValue = val

    if val == 0 then
        aiming = false
        RunService:UnbindFromRenderStep("Aimbot")
        return
    end

    if not aiming then
        aiming = true
        RunService:BindToRenderStep("Aimbot", 1, function()
            local target = getClosestToCenter()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local cam = workspace.CurrentCamera
                local headPos = target.Character.Head.Position
                local newCF = CFrame.new(cam.CFrame.Position, headPos)
                cam.CFrame = cam.CFrame:Lerp(newCF, aimbotValue/100)
            end
        end)
    end
end)

-----------------------------------------------------------------------
-- IMORTAL
-----------------------------------------------------------------------
local imortalAtivado = false

local function ativarImortal()
    if imortalAtivado then return end
    imortalAtivado = true

    task.spawn(function()
        while imortalAtivado do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = 1000
            end
            task.wait(0.001)
        end
    end)
end

local function createButton(parent, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,40)
    btn.Position = UDim2.new(0,10,0,(#parent:GetChildren()-1)*70)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.BorderColor3 = Color3.new(1,1,1)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
end

createButton(menuFrame, "Imortal", function()
    ativarImortal()
end)

-----------------------------------------------------------------------
-- ABRIR / FECHAR MENU
-----------------------------------------------------------------------
buttonCircle.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)
