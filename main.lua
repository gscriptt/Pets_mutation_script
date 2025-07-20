-- 🧬 Pet Mutation Finder Script
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- 🔁 Mutation Types
local mutations = {
    "Shiny", "Inverted", "Frozen", "Windy", "Golden", "Mega", "Tiny",
    "Tranquil", "IronSkin", "Radiant", "Rainbow", "Shocked", "Ascended"
}
local currentMutation = mutations[math.random(#mutations)]
local espVisible = true

-- 🌀 Loading Screen (Centered Text)
local loadingScreen = Instance.new("ScreenGui", PlayerGui)
loadingScreen.Name = "LoadingScreen"

-- 🖋 Container for all loading text
local container = Instance.new("Frame", loadingScreen)
container.Size = UDim2.new(1, 0, 1, 0)
container.BackgroundTransparency = 1

-- 🖋 Main Loading Label
local loadingLabel = Instance.new("TextLabel", container)
loadingLabel.Size = UDim2.new(1, 0, 0, 50)
loadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)
loadingLabel.Position = UDim2.new(0.5, 0, 0.43, 0)
loadingLabel.BackgroundTransparency = 1
loadingLabel.TextColor3 = Color3.new(1, 1, 1)
loadingLabel.Font = Enum.Font.GothamBold
loadingLabel.TextSize = 32
loadingLabel.Text = "Loading For The Pet Mutation"

-- 🕒 Wait Message (below loadingLabel)
local waitMessage = Instance.new("TextLabel", container)
waitMessage.Size = UDim2.new(1, 0, 0, 25)
waitMessage.AnchorPoint = Vector2.new(0.5, 0.5)
waitMessage.Position = UDim2.new(0.5, 0, 0.50, 0)
waitMessage.BackgroundTransparency = 1
waitMessage.TextColor3 = Color3.new(1, 1, 1)
waitMessage.Font = Enum.Font.Gotham
waitMessage.TextSize = 20
waitMessage.Text = "Please wait for 25 seconds, thank you."

-- 📝 Credit Text (below waitMessage)
local credit = Instance.new("TextLabel", container)
credit.Size = UDim2.new(1, 0, 0, 20)
credit.AnchorPoint = Vector2.new(0.5, 0.5)
credit.Position = UDim2.new(0.5, 0, 0.56, 0)
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.new(1, 1, 1)
credit.Font = Enum.Font.SourceSans -- ✅ Plain font
credit.TextSize = 16
credit.Text = "Created by gcscriptt"

-- 🔄 Animate Loading Dots
task.spawn(function()
    while loadingScreen do
        for i = 1, 3 do
            loadingLabel.Text = "Loading For The Pet Mutation" .. string.rep(".", i)
            wait(0.5)
        end
    end
end)

-- ⏳ Wait 25 seconds before showing Main GUI
task.wait(25)
loadingScreen:Destroy()

-- 🖥 Main GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "PetMutationFinder"
gui.ResetOnSpawn = false

-- 📦 Frame Setup
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 185)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BorderColor3 = Color3.fromRGB(80, 80, 90)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

-- 📐 Frame Styling
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(100, 100, 110)

-- 📖 Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Text = "🔍 Pet Mutation Finder"

-- 📌 Function to Create Buttons (NORMAL FONT + HORIZONTAL)
local function createButton(text, yPos, color)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.SourceSans -- ✅ Plain horizontal font
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.AutoButtonColor = false

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 1.2

    -- Hover Effects
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.2)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)

    return btn
end

-- 🎲 Buttons
local reroll = createButton("🎲 Mutation Reroll", 45, Color3.fromRGB(140, 200, 255))
local toggle = createButton("👁️ Toggle Mutation", 90, Color3.fromRGB(180, 255, 180))

-- 📝 Credit Label (Plain Font)
local credit2 = Instance.new("TextLabel", frame)
credit2.Size = UDim2.new(1, 0, 0, 20)
credit2.Position = UDim2.new(0, 0, 1, -20)
credit2.BackgroundTransparency = 1
credit2.TextColor3 = Color3.fromRGB(200, 200, 200)
credit2.Font = Enum.Font.SourceSans -- ✅ Plain font for GUI credit
credit2.TextSize = 13
credit2.Text = "Made by gcscriptt"

-- 🔍 Find Mutation Machine
local function findMachine()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("mutation") then
            return obj
        end
    end
end

local machine = findMachine()
if not machine or not machine:FindFirstChildWhichIsA("BasePart") then
    warn("Pet Mutation Machine not found.")
    return
end

-- 🎯 ESP Setup
local basePart = machine:FindFirstChildWhichIsA("BasePart")
local espGui = Instance.new("BillboardGui", basePart)
espGui.Name = "MutationESP"
espGui.Adornee = basePart
espGui.Size = UDim2.new(0, 200, 0, 40)
espGui.StudsOffset = Vector3.new(0, 3, 0)
espGui.AlwaysOnTop = true

local espLabel = Instance.new("TextLabel", espGui)
espLabel.Size = UDim2.new(1, 0, 1, 0)
espLabel.BackgroundTransparency = 1
espLabel.Font = Enum.Font.GothamBold
espLabel.TextSize = 24
espLabel.TextStrokeTransparency = 0.3
espLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
espLabel.Text = currentMutation

-- 🌈 Rainbow ESP Text Animation
local hue = 0
RunService.RenderStepped:Connect(function()
    if espVisible then
        hue = (hue + 0.01) % 1
        espLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
    end
end)

-- 🔄 Mutation Reroll Function
local function animateMutationReroll()
    reroll.Text = "⏳ Rerolling..."
    local duration, interval = 2, 0.1
    for _ = 1, math.floor(duration / interval) do
        espLabel.Text = mutations[math.random(#mutations)]
        wait(interval)
    end
    currentMutation = mutations[math.random(#mutations)]
    espLabel.Text = currentMutation
    reroll.Text = "🎲 Mutation Reroll"
end

-- 🖱 Button Events
reroll.MouseButton1Click:Connect(animateMutationReroll)
toggle.MouseButton1Click:Connect(function()
    espVisible = not espVisible
    espGui.Enabled = espVisible
end)
