local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI erstellen
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AvatarChangerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Hauptframe
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 320, 0, 220)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

-- Titel
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 20, 0, 10)
title.Text = "Avatar Changer"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- X-Button zum Schließen
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,5)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18

-- Funktion X-Button
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- TextBox für T-Shirt
local tshirtBox = Instance.new("TextBox", frame)
tshirtBox.Size = UDim2.new(1, -40, 0, 40)
tshirtBox.Position = UDim2.new(0, 20, 0, 70)
tshirtBox.PlaceholderText = "T-Shirt Asset ID"
tshirtBox.TextColor3 = Color3.new(1,1,1)
tshirtBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
tshirtBox.Font = Enum.Font.Gotham
tshirtBox.TextSize = 16
Instance.new("UICorner", tshirtBox).CornerRadius = UDim.new(0,8)

-- TextBox für Pants
local pantsBox = Instance.new("TextBox", frame)
pantsBox.Size = UDim2.new(1, -40, 0, 40)
pantsBox.Position = UDim2.new(0, 20, 0, 120)
pantsBox.PlaceholderText = "Pants Asset ID"
pantsBox.TextColor3 = Color3.new(1,1,1)
pantsBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
pantsBox.Font = Enum.Font.Gotham
pantsBox.TextSize = 16
Instance.new("UICorner", pantsBox).CornerRadius = UDim.new(0,8)

-- Apply-Button
local applyBtn = Instance.new("TextButton", frame)
applyBtn.Size = UDim2.new(1, -40, 0, 40)
applyBtn.Position = UDim2.new(0, 20, 0, 170)
applyBtn.Text = "Apply"
applyBtn.TextColor3 = Color3.new(1,1,1)
applyBtn.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0,8)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 18

-- Funktion zum Anwenden
local function applyClothes()
    local character = LocalPlayer.Character
    if not character then return end

    -- T-Shirt
    local tshirtID = tonumber(tshirtBox.Text)
    if tshirtID then
        local shirt = character:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", character)
        shirt.ShirtTemplate = "rbxassetid://"..tshirtID
    end

    -- Pants
    local pantsID = tonumber(pantsBox.Text)
    if pantsID then
        local pants = character:FindFirstChildOfClass("Pants") or Instance.new("Pants", character)
        pants.PantsTemplate = "rbxassetid://"..pantsID
    end
end

applyBtn.MouseButton1Click:Connect(applyClothes)

-- Drag-Funktion
local dragging = false
local dragInput, dragStartPos, startPos

local function updatePosition(input)
    local delta = input.Position - dragStartPos
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updatePosition(input)
    end
end)

-- Optional: Anwenden beim Respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    applyClothes()
end)
