-- BluuGUI.lua | Pronto para Delta Executor via loadstring

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

-- Dragging
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input
