--// GUI COMPLETO - SCRIPT GOHAN COM ESP PERSISTENTE + HEADSIZES

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- =====================================
-- FUNÇÃO PARA ARRASTAR GUI
-- =====================================
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

-- =====================================
-- SCREEN GUI
-- =====================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GohanGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- BOTÃO CÍRCULO PARA ABRIR MENU
local buttonCircle = Instance.new("ImageButton")
buttonCircle.Size = UDim2.new(0, 80, 0, 80)
buttonCircle.Position = UDim2.new(1, -100, 0, 20)
buttonCircle.BackgroundColor3 = Color3.fromRGB(0,0,0)
buttonCircle.Image = "rbxassetid://631940830"
buttonCircle.BorderSizePixel = 3
buttonCircle.BorderColor3 = Color3.new(0,0,0)
buttonCircle.Parent = screenGui
local circleCorner = Instance.new("UICorner", buttonCircle)
circleCorner.CornerRadius = UDim.new(1,0)
makeDraggable(buttonCircle)

-- MENU RETANGULAR
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 350, 0, 500)
menuFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
menuFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
menuFrame.BorderColor3 = Color3.new(1,1,1)
menuFrame.BorderSizePixel = 2
menuFrame.Visible = false
menuFrame.Parent = screenGui
makeDraggable(menuFrame)

-- TÍTULO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Script - Gohan"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = menuFrame

-- SCROLLING FRAME PARA CONTEÚDO
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -10, 1, -45)
contentFrame.Position = UDim2.new(0, 5, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = menuFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
listLayout.Parent = contentFrame

-- =====================================
-- ESP CONFIGURAÇÕES
-- =====================================
local espEnabled = false
local espHighlights = {}

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(1,-20,0,50)
espButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
espButton.Text = "ESP (OFF)"
espButton.TextColor3 = Color3.new(1,1,1)
espButton.Font = Enum.Font.GothamBold
espButton.TextSize = 20
espButton.Parent = contentFrame

local function createHighlight(char)
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0,255,255)
    hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char
    espHighlights[char] = hl
end

local function setupPlayerESP(player)
    player.CharacterAdded:Connect(function(char)
        -- Remove highlight antigo, se existir
        if espHighlights[char] then
            espHighlights[char]:Destroy()
            espHighlights[char] = nil
        end
        if espEnabled then
            createHighlight(char)
        end
    end)
end

local function toggleESP(state)
    espEnabled = state
    espButton.Text = state and "ESP (ON)" or "ESP (OFF)"
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                createHighlight(player.Character)
            end
        end
    else
        for _, hl in pairs(espHighlights) do
            if hl and hl.Parent then hl:Destroy() end
        end
        espHighlights = {}
    end
end

espButton.MouseButton1Click:Connect(function()
    toggleESP(not espEnabled)
end)

-- Configura ESP para jogadores existentes e novos
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        setupPlayerESP(player)
        if player.Character and espEnabled then
            createHighlight(player.Character)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        setupPlayerESP(player)
    end
end)

-- =====================================
-- HEADSIZES
-- =====================================
local headSizeSlider = Instance.new("Frame")
-- Slider será criado com a função createSlider abaixo
-- =====================================
local function createSlider(parent, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 70)
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
            local val = min + (max-min)*pct
            valueLabel.Text = string.format("%.2f",val)
            callback(val)
        end
    end)

    -- Botão + e -
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
        local newVal = math.min(max, tonumber(valueLabel.Text)+0.1)
        valueLabel.Text = string.format("%.2f", newVal)
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
        local newVal = math.max(min, tonumber(valueLabel.Text)-0.1)
        valueLabel.Text = string.format("%.2f", newVal)
        sliderFill.Size = UDim2.new((newVal-min)/(max-min),0,1,0)
        callback(newVal)
    end)
end

-- Adicionando HEADSIZES para inimigos
createSlider(contentFrame,"HeadSizes",0.5,3,1,function(val)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            p.Character.Head.Size = Vector3.new(val,val,val)
        end
    end
end)

-- FOV
createSlider(contentFrame,"FOV",1,200,70,function(val)
    Camera.FieldOfView = val
end)

-- ABRIR / FECHAR MENU
buttonCircle.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)
