local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local running = true -- Scriptin çalışmasını kontrol eden değişken

local colors = {
    Color3.fromRGB(255, 0, 0),    -- Kırmızı
    Color3.fromRGB(255, 165, 0),  -- Turuncu
    Color3.fromRGB(255, 255, 0),  -- Sarı
    Color3.fromRGB(0, 255, 0),    -- Yeşil
    Color3.fromRGB(0, 0, 255),    -- Mavi
    Color3.fromRGB(75, 0, 130),   -- Çivit Mavisi
    Color3.fromRGB(148, 0, 211),  -- Mor
    Color3.fromRGB(255, 192, 203), -- Pembe
    Color3.fromRGB(0, 255, 255),  -- Camgöbeği
    Color3.fromRGB(128, 0, 128),  -- Eflatun
    Color3.fromRGB(255, 140, 0)   -- Koyu Turuncu
}

local function getPlayerMagnet(player)
    local character = player.Character
    if character then
        local magRope = character:FindFirstChild("MagRope")
        local magRail = character:FindFirstChild("MagRail")
        return magRope or magRail
    end
    return nil
end

local function updateTextures(magnet)
    if magnet then
        for _, part in pairs({"Primary", "Secondary"}) do
            local section = magnet:FindFirstChild(part)
            if section then
                for _, texture in pairs(section:GetChildren()) do
                    if texture:IsA("Texture") then
                        texture.Texture = "http://www.roblox.com/asset/?id=1304449184"
                    end
                end
            end
        end
    end
end

local function changeColors()
    local index = 1
    while running do
        local color = colors[index]
        index = (index % #colors) + 1  -- Renkleri sırayla döndür
        
        for _, player in pairs(Players:GetPlayers()) do
            local character = player.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local magnet = getPlayerMagnet(player)
                if rootPart and rootPart:FindFirstChild("Light") then
                    local light = rootPart.Light
                    light.Color = color
                    light.Brightness = 7  -- Brightness değerini 7 yap
                end
                if magnet then
                    updateTextures(magnet)
                    for _, part in pairs({"Primary", "Secondary"}) do
                        local section = magnet:FindFirstChild(part)
                        if section then
                            section.Color = color
                        end
                    end
                    local gripUnion = magnet:FindFirstChild("GripUnion")
                    if gripUnion then
                        gripUnion.Color = color
                    end
                end
            end
        end
        wait(5) -- Renk değişim süresini 5 saniye olarak ayarla
    end
end

spawn(changeColors) -- Bu şekilde fonksiyon başlatılır

-- Scripti durdurmak için aşağıdaki fonksiyonu çağırabilirsin
local function stopScript()
    running = false
end
