--// GUI COMPLETO - SCRIPT GOHAN

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- ScreenGui
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
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

-- CÍRCULO BOTÃO
local buttonCircle = Instance.new("ImageButton")
buttonCircle.Size = UDim2.new(0, 80, 0, 80)
buttonCircle.Position = UDim2.new(1, -100, 0, 20) -- canto superior direito
buttonCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
buttonCircle.Image = "rbxassetid://631940830"
buttonCircle.BorderSizePixel = 3
buttonCircle.BorderColor3 = Color3.new(0,0,0)
buttonCircle.Parent = screenGui
buttonCircle.ZIndex = 10
local circleCorner = Instance.new("UICorner", buttonCircle)
circleCorner.CornerRadius = UDim.new(1,0)
makeDraggable(buttonCircle)

-- MENU RETANGULAR
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 320, 0, 420)
menuFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
menuFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
menuFrame.BorderColor3 = Color3.new(1,1,1)
menuFrame.BorderSizePixel = 2
menuFrame.Visible = false
menuFrame.Parent = screenGui
makeDraggable(menuFrame)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Script - Gohan"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = menuFrame

-- FUNÇÃO SLIDER COM + e -
local function createSlider(parent, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 70)
    frame.Position = UDim2.new(0,10,0,#parent:GetChildren()*70)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,20)
    label.Position = UDim2.new(0,0,0,0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.7,0,0,22)
    sliderFrame.Position = UDim2.new(0,0,0,30)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    sliderFrame.Parent = frame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(200,200,200)
    sliderFill.Parent = sliderFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0,50,1,0)
    valueLabel.Position = UDim2.new(1,10,0,0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.new(1,1,1)
    valueLabel.Font = Enum.Font.Gotham
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
        if dragging then
            local x = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X,0,sliderFrame.AbsoluteSize.X)
            local pct = x/sliderFrame.AbsoluteSize.X
            sliderFill.Size = UDim2.new(pct,0,1,0)
            local val = math.floor(min + (max-min)*pct)
            valueLabel.Text = val
            callback(val)
        end
    end)

    local plus = Instance.new("TextButton")
    plus.Size = UDim2.new(0,25,0,25)
    plus.Position = UDim2.new(0.75,45,0,28)
    plus.Text = "+"
    plus.BackgroundColor3 = Color3.fromRGB(40,40,40)
    plus.TextColor3 = Color3.new(1,1,1)
    plus.Font = Enum.Font.GothamBold
    plus.TextSize = 20
    plus.Parent = frame
    plus.MouseButton1Click:Connect(function()
        local newVal = math.min(max, tonumber(valueLabel.Text)+1)
        valueLabel.Text = newVal
        sliderFill.Size = UDim2.new((newVal-min)/(max-min),0,1,0)
        callback(newVal)
    end)

    local minus = Instance.new("TextButton")
    minus.Size = UDim2.new(0,25,0,25)
    minus.Position = UDim2.new(0.75,10,0,28)
    minus.Text = "-"
    minus.BackgroundColor3 = Color3.fromRGB(40,40,40)
    minus.TextColor3 = Color3.new(1,1,1)
    minus.Font = Enum.Font.GothamBold
    minus.TextSize = 20
    minus.Parent = frame
    minus.MouseButton1Click:Connect(function()
        local newVal = math.max(min, tonumber(valueLabel.Text)-1)
        valueLabel.Text = newVal
        sliderFill.Size = UDim2.new((newVal-min)/(max-min),0,1,0)
        callback(newVal)
    end)
end

-- SPEED
createSlider(menuFrame, "Speed", 16, 500, 16, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

-- SIZE
createSlider(menuFrame, "Size", 1, 10, 1, function(val)
    if LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetChildren()) do
            if p:IsA("BasePart") then
                p.Size = Vector3.new(val,val,val)
            end
        end
    end
end)

-- AIMBOT
local aimbotValue = 0
local aiming = false
local function closest()
    local cam = workspace.CurrentCamera
    local target, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local screenPos, onScreen = cam:WorldToViewportPoint(head.Position)
            if onScreen then
                local d = (Vector2.new(screenPos.X,screenPos.Y)-(cam.ViewportSize/2)).Magnitude
                if d<dist then
                    dist = d
                    target = p
                end
            end
        end
    end
    return target
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
        RunService:BindToRenderStep("Aimbot",1,function()
            local tgt = closest()
            if tgt and tgt.Character and tgt.Character:FindFirstChild("Head") then
                local newCF = CFrame.new(Camera.CFrame.Position, tgt.Character.Head.Position)
                Camera.CFrame = Camera.CFrame:Lerp(newCF, aimbotValue/100)
            end
        end)
    end
end)

-- IMORTAL ON/OFF
local imortal = false
local function toggleImortal()
    imortal = not imortal
    if imortal then
        task.spawn(function()
            while imortal do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.Health = 1000
                end
                task.wait(0.001)
            end
        end)
    end
end

local function createButton(parent,name,callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,45)
    btn.Position = UDim2.new(0,10,0,#parent:GetChildren()*60)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.BorderColor3 = Color3.new(1,1,1)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
end

createButton(menuFrame,"Imortal (ON/OFF)",toggleImortal)

-- ABRIR / FECHAR MENU
buttonCircle.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)
