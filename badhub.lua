--// Roblox Script Hub GUI - Full Script //--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "ScriptHubGUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 1.5

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Tab holder
local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Size = UDim2.new(0, 130, 1, 0)
TabHolder.Position = UDim2.new(0, 0, 0, 0)
TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", TabHolder).CornerRadius = UDim.new(0, 10)

-- Content holder
local ContentHolder = Instance.new("Frame", MainFrame)
ContentHolder.Size = UDim2.new(1, -130, 1, 0)
ContentHolder.Position = UDim2.new(0, 130, 0, 0)
ContentHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", ContentHolder).CornerRadius = UDim.new(0, 10)

local scriptTabs = {
    ["Fun"] = {
        {Name="Spin Bot", Url="https://pastebin.com/raw/SpinBot"},
        {Name="Epik Emotes (R6)", Url="https://raw.githubusercontent.com/.../Epik-R6-Dancezz.lua"}
    },
    ["Utility"] = {
        {Name="Fly", Url="https://pastebin.com/raw/FlyScript"},
        {Name="Infinite Yield", Url="https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
        {Name="Anti-Idle", Url="https://pastebin.com/raw/AntiIdle"}
    },
    ["ESP"] = {
        {Name="Basic ESP", Url="https://pastebin.com/raw/ESPscript"}
    },
    ["Reanimations"] = {
        {Name="R6 Reanimate", Url="https://raw.githubusercontent.com/GelatekWasTaken/Reanimations/main/UniversalR6.lua"}
    }
}

-- Game-specific
local supportedGames = {
    [2753915549] = {
        {Name="Alchemy Hub", Url="https://arceusx.com/alchemy.lua"},
        {Name="Flame Boomer", Url="https://arceusx.com/flowhub.lua"}
    },
    [6872274489] = {
        {Name="Beta BedWars Script", Url="https://pastebin.com/raw/BedWarsHub"}
    }
}

local function CreateButton(name, parent, callback)
    local Button = Instance.new("TextButton", parent)
    Button.Size = UDim2.new(1, -10, 0, 30)
    Button.Position = UDim2.new(0, 5, 0, #parent:GetChildren() * 35)
    Button.Text = name
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamSemibold
    Button.TextSize = 14
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    Button.MouseButton1Click:Connect(callback)
end

-- Generate Tabs and Script Buttons
local function SwitchContent(contentList)
    ContentHolder:ClearAllChildren()
    for i, scriptData in pairs(contentList) do
        CreateButton(scriptData.Name, ContentHolder, function()
            if scriptData.Url then
                loadstring(game:HttpGet(scriptData.Url))()
            else
                warn("No URL provided for", scriptData.Name)
            end
        end)
    end
end

local function CreateTab(name, scripts)
    CreateButton(name, TabHolder, function()
        SwitchContent(scripts)
    end)
end

-- Auto-detect game section
local gameSpecific = supportedGames[game.PlaceId]
if gameSpecific then
    scriptTabs["Game-Specific"] = gameSpecific
else
    scriptTabs["Game-Specific"] = {
        {Name="Game Unsupported", Url=nil}
    }
end

-- Build GUI
for tabName, scriptList in pairs(scriptTabs) do
    CreateTab(tabName, scriptList)
end
