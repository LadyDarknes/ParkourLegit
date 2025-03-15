
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

            -- BillboardGui
            local esp = Instance.new("BillboardGui")
            esp.Name = "ESP"
            esp.Parent = obj
            esp.Adornee = obj
            esp.AlwaysOnTop = true
            -- Daha geniş boyut veriyoruz ki TextLabel sığsın
            esp.Size = UDim2.new(0, 50, 0, 60)
            esp.StudsOffset = Vector3.new(0, 2, 0)
            esp.Enabled = espEnabled

            -- Kutu (Frame)
            local frame = Instance.new("Frame")
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.Position = UDim2.new(0.5, 0, 0.2, 0)
            frame.Size = UDim2.new(0, 10, 0, 10)
            frame.BackgroundColor3 = renk
            frame.BorderSizePixel = 0
            frame.Parent = esp

            -- Mesafe yazısı (TextLabel)
            local textLabel = Instance.new("TextLabel")
            textLabel.AnchorPoint = Vector2.new(0.5, 0)
            textLabel.Position = UDim2.new(0.5, 0, 0.6, 0)
            textLabel.Size = UDim2.new(1, 0, 0, 30)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextStrokeTransparency = 0
            textLabel.TextScaled = true
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.Parent = esp

            -- Mesafeyi sürekli güncelle
            task.spawn(function()
                while esp.Parent do
                    local distance = (rootPart.Position - mainPart.Position).Magnitude
                    textLabel.Text = string.format("%.1f m", distance)

                    -- 100m içindeyse kutu 2 kat büyüsün
                    if distance <= minDistance then
                        frame.Size = UDim2.new(0, 20, 0, 20)
                    else
                        frame.Size = UDim2.new(0, 10, 0, 10)
                    end

                    -- Sadece Insert tuşuyla aç/kapat
                    esp.Enabled = espEnabled
                    task.wait(0.1)
                end
            end)
        end
    end
end

-- Insert tuşuyla aç/kapat
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        toggleESP()
    end
end)
