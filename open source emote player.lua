-- lmao bro

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local humanoidDescription = humanoid:WaitForChild("HumanoidDescription")

-- Define emotes with display names and their UGC IDs
local customEmotes = {
    ["Hakari"] = {115380777754385},
    ["Griddy"] = {129149402922241},
    ["Carm"] = {87275228219621},
}

-- Apply and equip emotes
humanoidDescription:SetEmotes(customEmotes)

-- Order them how you want them to show up
local equippedOrder = {"Hakari", "Griddy", "Carm"}
humanoidDescription:SetEquippedEmotes(equippedOrder)

-- Build the GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UGCEmoteGUI"
screenGui.ResetOnSpawn = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local uiFrame = Instance.new("Frame")
uiFrame.Size = UDim2.new(0, 200, 0, 190)
uiFrame.Position = UDim2.new(0, 10, 0.5, -60)
uiFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
uiFrame.Active = true -- Required for dragging
uiFrame.Parent = screenGui

-- Make Frame Draggable
do
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        uiFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    uiFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = uiFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    uiFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Create buttons
for i, emoteName in ipairs(equippedOrder) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.Position = UDim2.new(0, 5, 0, (i-1)*55 + 5)
    btn.Text = "Play: " .. emoteName
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = uiFrame

    btn.MouseButton1Click:Connect(function()
        local success = humanoid:PlayEmote(emoteName)
        if not success then
            warn("Failed to play emote:", emoteName)
        end
    end)
end
