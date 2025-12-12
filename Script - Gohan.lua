--// GUI COMPLETO - SCRIPT GOHAN (Refatorado e Organizado)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- =====================================
-- CONFIGURAÇÕES GLOBAIS
-- =====================================
local espEnabled = false
local espHighlights = {}
local aimbotValue = 0
local aiming = false
local imortal = false

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
-- FUNÇÃO PARA SLIDERS (Removido o parâmetro 'offset' para organização automática)
-- =====================================
local function createSlider(parent, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 70) -- Tamanho total (100% da largura do pai)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    -- Adiciona um padding interno de 10px em cada lado para estética
    local innerFrame = Instance.new("Frame")
    innerFrame.Size = UDim2.new(1, -20, 1, 0)
    innerFrame.Position = UDim2.new(0, 10, 0, 0)
    innerFrame.BackgroundTransparency = 1
    innerFrame.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,20)
    label.Position = UDim2.new(0,0,0,0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.Parent = innerFrame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.7,0,0,22)
    sliderFrame.Position = UDim2.new(0,0,0,30)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    sliderFrame.Parent = innerFrame
    -- Adiciona cantos arredondados
    Instance.new("UICorner", sliderFrame)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
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

    -- Lógica de arrastar
    local draggingSlider = false
    local function updateSlider(input)
        local x = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X,0,sliderFrame.AbsoluteSize.X)
        local pct = x/sliderFrame.AbsoluteSize.X
        sliderFill.Size = UDim2.new(pct,0,1,0)
        local val = math.floor(min + (max-min)*pct)
        valueLabel.Text = val
        callback(val)
    end

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            draggingSlider = true 
            updateSlider(input) -- Atualiza imediatamente ao clicar
        end
    end)
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            draggingSlider = false 
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)


    -- Botão + e - (Posicionado dentro do frame pai, ao lado do sliderFrame)
    local plus = Instance.new("TextButton")
    plus.Size = UDim2.new(0,25,0,25)
    plus.Position = UDim2.new(0.7, 50, 0, 28) -- Ajustado para ficar à direita
    plus.Text = "+"
    plus.BackgroundColor3 = Color3.fromRGB(40,40,40)
    plus.TextColor3 = Color3.new(1,1,1)
    plus.Font = Enum.Font.GothamBold
    plus.TextSize = 20
    plus.Parent = innerFrame
    plus.MouseButton1Click:Connect(function()
        local newVal = math.min(max, tonumber(valueLabel.Text)+1)
        valueLabel.Text = newVal
        sliderFill.Size = UDim2.new((newVal-min)/(max-min),0,1,0)
        callback(newVal)
    end)

    local minus = Instance.new("TextButton")
    minus.Size = UDim2.new(0,25,0,25)
    minus.Position = UDim2.new(0.7, 10, 0, 28) -- Ajustado para ficar à direita
    minus.Text = "-"
    minus.BackgroundColor3 = Color3.fromRGB(40,40,40)
    minus.TextColor3 = Color3.new(1,1,1)
    minus.Font = Enum.Font.GothamBold
    minus.TextSize = 20
    minus.Parent = innerFrame
    minus.MouseButton1Click:Connect(function()
        local newVal = math.max(min, tonumber(valueLabel.Text)-1)
        valueLabel.Text = newVal
        sliderFill.Size = UDim2.new((newVal-min)/(max-min),0,1,0)
        callback(newVal)
    end)
    
    Instance.new("UICorner", plus)
    Instance.new("UICorner", minus)
end


-- =====================================
-- FUNÇÕES ESP E PERSISTÊNCIA (Corrigido)
-- =====================================

local function createHighlight(char)
    -- Evita recriar se já existe um highlight no char
    if espHighlights[char] and espHighlights[char].Parent then
        espHighlights[char]:Destroy()
    end
    
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0,255,255)
    hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char
    espHighlights[char] = hl
end

local function removeHighlight(char)
    if espHighlights[char] and espHighlights[char].Parent then
        espHighlights[char]:Destroy()
        espHighlights[char] = nil
    end
end

local function setupPlayerESP(player)
    player.CharacterAdded:Connect(function(char)
        if espEnabled then
            createHighlight(char)
        else
            removeHighlight(char)
        end
        -- Remove o Highlight do char anterior (se o novo char tiver o mesmo endereço de memória do antigo, o que é raro, mas garante a limpeza)
        -- O Highlight antigo é destruído junto com o Character antigo, então basta recriar.
    end)

    -- Para lidar com o Character que já existe quando o script carrega.
    if player.Character and espEnabled then
        createHighlight(player.Character)
    end
end

local function toggleESP(state)
    espEnabled = state
    if espEnabled then
        espButton.Text = "ESP (ON)"
        espButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                createHighlight(player.Character)
            end
        end
    else
        espButton.Text = "ESP (OFF)"
        espButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
        for _, hl in pairs(espHighlights) do
            if hl and hl.Parent then hl:Destroy() end
        end
        espHighlights = {}
    end
end

-- Configura ESP para jogadores existentes e futuros
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        setupPlayerESP(player)
    end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        setupPlayerESP(player)
    end
end)


-- =====================================
-- SCREEN GUI
-- =====================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GohanGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- BOTÃO CÍRCULO (Launcher)
local buttonCircle = Instance.new("ImageButton")
buttonCircle.Size = UDim2.new(0, 80, 0, 80)
buttonCircle.Position = UDim2.new(1, -100, 0, 20)
buttonCircle.BackgroundColor3 = Color3.fromRGB(0,0,0)
buttonCircle.Image = "rbxassetid://631940830" -- Ícone de exemplo
buttonCircle.BorderSizePixel = 3
buttonCircle.BorderColor3 = Color3.new(0,0,0)
buttonCircle.Parent = screenGui
local circleCorner = Instance.new("UICorner", buttonCircle)
circleCorner.CornerRadius = UDim.new(1,0)
makeDraggable(buttonCircle)

-- MENU RETANGULAR
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 320, 0, 450)
menuFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
menuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30) -- Um pouco mais claro para contraste
menuFrame.BorderColor3 = Color3.new(1,1,1)
menuFrame.BorderSizePixel = 2
menuFrame.Visible = false
menuFrame.Parent = screenGui
makeDraggable(menuFrame)

-- TÍTULO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Fundo sólido no título
title.Text = "Script - Gohan"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = menuFrame

-- SCROLLING FRAME para o Conteúdo (Organizador principal)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, 0, 1, -35) -- 100% da largura, e -35 do topo para o título
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = menuFrame

-- LAYOUT: O Segredo da Organização em Fileiras!
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5) -- Espaço entre os itens
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = contentFrame

-- =====================================
-- ITENS DA GUI
-- =====================================

-- ESP CONFIGURAÇÕES (TextButton de Liga/Desliga)
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(1,0,0,50)
espButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
espButton.Text = "ESP (OFF)"
espButton.TextColor3 = Color3.new(1,1,1)
espButton.Font = Enum.Font.GothamBold
espButton.TextSize = 20
espButton.Parent = contentFrame
Instance.new("UICorner", espButton)

espButton.MouseButton1Click:Connect(function()
    toggleESP(not espEnabled)
end)


-- FOV (Field of View) - SLIDER
createSlider(contentFrame, "FOV", 1, 120, 70, function(val)
    Camera.FieldOfView = val
end)


-- HEAD SIZE - SLIDER
createSlider(contentFrame, "Head Size", 0.5, 5, 1, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        LocalPlayer.Character.Head.Size = Vector3.new(val*2, val*2, val*2)
        -- OBS: A cabeça geralmente é 2x2x2 no roblox, então val*2 garante que 1 é o tamanho padrão.
    end
end)


-- AIMBOT - SLIDER
createSlider(contentFrame,"Aimbot",0,100,0,function(val)
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
                Camera.CFrame = Camera.CFrame:Lerp(newCF,aimbotValue/100)
            end
        end)
    end
end)


-- IMORTAL ON/OFF - TextButton
local imortalBtn = Instance.new("TextButton")
imortalBtn.Size = UDim2.new(1,0,0,50)
imortalBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
imortalBtn.Text = "Imortal (OFF)"
imortalBtn.TextColor3 = Color3.new(1,1,1)
imortalBtn.Font = Enum.Font.GothamBold
imortalBtn.TextSize = 20
imortalBtn.Parent = contentFrame
Instance.new("UICorner", imortalBtn)

imortalBtn.MouseButton1Click:Connect(function()
    imortal = not imortal
    if imortal then
        imortalBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
        imortalBtn.Text = "Imortal (ON)"
        task.spawn(function()
            while imortal do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.Health = 1000 -- Valor alto para imortalidade
                end
                task.wait(0.1) -- Reduzi um pouco a frequência para ser mais eficiente
            end
        end)
    else
        imortalBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
        imortalBtn.Text = "Imortal (OFF)"
    end
end)


-- ABRIR / FECHAR MENU
buttonCircle.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)
