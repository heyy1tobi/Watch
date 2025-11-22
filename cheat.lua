local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Einstellungen
local toggleKey = Enum.KeyCode.G
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "WatchMenu"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false

-- GUI Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0,300,0,400)
frame.Position = UDim2.new(0,50,0,50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- Titel
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-40,0,40)
title.Position = UDim2.new(0,20,0,10)
title.Text = "Watch Menu"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- X-Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-40,0,10)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,5)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    Camera.CameraType = Enum.CameraType.Custom -- zurück zur normalen Kamera
end)

-- ScrollFrame für Spieler
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1,-40,1,-80)
scrollFrame.Position = UDim2.new(0,20,0,60)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.ScrollBarThickness = 8

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,5)

local targetPlayer = nil

-- Spielerbutton erstellen
local function createPlayerButton(player)
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = player.Name
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(function()
        targetPlayer = player
    end)
end

local function refreshPlayers()
    scrollFrame:ClearAllChildren()
    listLayout.Parent = scrollFrame
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createPlayerButton(player)
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0,0,listLayout.AbsoluteContentSize.Y,0)
end

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

-- Kamera folgen
RunService.RenderStepped:Connect(function()
    if screenGui.Enabled and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Camera.CameraType = Enum.CameraType.Scriptable
        Camera.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,6)
    elseif not targetPlayer then
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Drag-Funktion
local dragging, dragInput, dragStartPos, startPos = false,nil,Vector3.new(),UDim2.new()
local function updatePosition(input)
    local delta = input.Position - dragStartPos
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                               startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = input.Position
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

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updatePosition(input)
    end
end)

-- Keybind zum Öffnen/Schließen
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == toggleKey then
            screenGui.Enabled = not screenGui.Enabled
            if not screenGui.Enabled then
                targetPlayer = nil
                Camera.CameraType = Enum.CameraType.Custom
            end
        end
    end
end)
