local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")

local minDistance = 100   -- 100m’den yakınsa kutu 2 kat büyüsün
local espEnabled = true   -- ESP başlangıçta açık

local function toggleESP()
    espEnabled = not espEnabled
    for _, gui in pairs(workspace:GetDescendants()) do
        if gui:IsA("BillboardGui") and gui.Name == "ESP" then
            gui.Enabled = espEnabled
        end
    end
end

-- 'Map' klasörü
local map = workspace:FindFirstChild("Map")
if not map then return end

for _, obj in pairs(map:GetChildren()) do
    -- Model adı 7 haneli sayı mı?
    if obj:IsA("Model") and obj.Name:match("^%d%d%d%d%d%d%d$") then
        local mainPart = obj:FindFirstChild("Main")
        if mainPart and mainPart:IsA("BasePart") then
            local renk = mainPart.Color
            local esp = Instance.new("BillboardGui")
            esp.Name = "ESP"
            esp.Parent = obj
            esp.Adornee = obj
            esp.AlwaysOnTop = true
            esp.Size = UDim2.new(0, 50, 0, 60)
            esp.StudsOffset = Vector3.new(0, 2, 0)
            esp.Enabled = espEnabled
            local frame = Instance.new("Frame")
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.Position = UDim2.new(0.5, 0, 0.2, 0)
            frame.Size = UDim2.new(0, 3, 0, 3)
            frame.BackgroundColor3 = renk
            frame.BorderSizePixel = 0
            frame.Parent = esp
            task.spawn(function()
                while esp.Parent do
                    local distance = (rootPart.Position - mainPart.Position).Magnitude
                    textLabel.Text = string.format("%.1f m", distance)
                    if distance <= minDistance then
                        frame.Size = UDim2.new(0, 10, 0, 10)
                    else
                        frame.Size = UDim2.new(0, 3, 0, 3)
                    end
                    esp.Enabled = espEnabled
                    task.wait(0.1)
                end
            end)
        end
    end
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        toggleESP()
    end
end)
