-- BluuGUI.lua | Pronto para Delta Executor em celular

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local chr = player.Character or player.CharacterAdded:Wait()
local humanoid = chr:WaitForChild("Humanoid")

-- Configs
local menuOpen = false
local flyEnabled = false
local flySpeed = 50
local bodyVel, bodyGyro

-- ================= GUI =================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BluuGUI"
screenGui.Parent = game:GetService("CoreGui") -- Delta Executor

-- Menu principal
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0,380,0,440)
mainFrame.Position = UDim2.new(0.5,-190,0.5,-220)
mainFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)

-- Title Bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundColor3 = Color3.fromRGB(50,50,50)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1,0,1,0)
titleText.BackgroundTransparency = 1
titleText.Text = "BluuGUI"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 22
titleText.TextColor3 = Color3.fromRGB(255,255,255)

-- Dragging (adaptado para toque)
local dragging, dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

local function updateDrag(input)
    if dragging and input then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

UIS.InputChanged:Connect(function(input)
    if input == dragInput then
        updateDrag(input)
    end
end)

-- ================= Botão para abrir/fechar menu =================
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0.9, -50, 0.9, -20)
toggleButton.Text = "Menu"
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextSize = 18
toggleButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.BorderSizePixel = 0
toggleButton.AnchorPoint = Vector2.new(0.5,0.5)

toggleButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    mainFrame.Visible = menuOpen
end)

-- ================= Botões internos =================
local flyButton = Instance.new("TextButton", mainFrame)
flyButton.Size = UDim2.new(0, 150, 0, 40)
flyButton.Position = UDim2.new(0, 15, 0, 60)
flyButton.Text = "Fly: OFF"
flyButton.Font = Enum.Font.Gotham
flyButton.TextSize = 18
flyButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
flyButton.TextColor3 = Color3.fromRGB(255,255,255)
flyButton.BorderSizePixel = 0

flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyButton.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
    
    if flyEnabled then
        bodyVel = Instance.new("BodyVelocity", chr.PrimaryPart)
        bodyGyro = Instance.new("BodyGyro", chr.PrimaryPart)
        bodyVel.MaxForce = Vector3.new(400000,400000,400000)
        bodyGyro.MaxTorque = Vector3.new(400000,400000,400000)
        bodyVel.Velocity = Vector3.new(0,0,0)
    else
        if bodyVel then bodyVel:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end)

-- ================= Fly via toque =================
RunService.RenderStepped:Connect(function()
    if flyEnabled and bodyVel and bodyGyro then
        local moveVector = Vector3.new(0,0,0)
        local camera = workspace.CurrentCamera
        local touches = UIS:GetTouches()

        for _, touch in pairs(touches) do
            local delta = touch.Position - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
            moveVector = moveVector + Vector3.new(delta.X/100, 0, delta.Y/100)
        end

        bodyVel.Velocity = moveVector * flySpeed
        bodyGyro.CFrame = CFrame.new(chr.PrimaryPart.Position, chr.PrimaryPart.Position + moveVector)
    end
end)
