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
    Color3.fromRGB(148, 0, 211)   -- Mor
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
                end
                if magnet then
                    if magnet:FindFirstChild("Primary") then
                        magnet.Primary.Color = color
                    end
                    if magnet:FindFirstChild("Secondary") then
                        magnet.Secondary.Color = color
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
