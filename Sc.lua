local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local runService = game:GetService("RunService")
local isHolding = false

local jumpSpeed = 0.02  -- Minimum 90ms
local waitTime = 0.5  -- Bekleme süresi 0.5s olarak ayarlandı

-- Alt tuşuna basılı tutma ve zıplama
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt and not isHolding then
        isHolding = true
        local lastJumpTime = 0
        while isHolding do
            -- Zıplama için koşul: Her 90ms'de bir
            local currentTime = tick()
            if currentTime - lastJumpTime >= jumpSpeed then
                -- 2 kez zıpla
                for i = 1, 2 do
                    VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    lastJumpTime = currentTime
                    task.wait(0.06)  -- Kısa bekleme
                end
                task.wait(waitTime)  -- Bekleme süresi
            end
            runService.Heartbeat:Wait()  -- Daha hassas zamanlama için Heartbeat kullanıyoruz
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        isHolding = false
    end
end)

local plr = game:GetService"Players".LocalPlayer
local m = plr:GetMouse()
m.KeyDown:connect(function(k)
	if k == "v" then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
		wait()
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Seated")
	end
end)

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local boostMultiplier = 2 -- Hızı artırma katsayısı

local function setupCharacter(character)
    local rootPart = character:WaitForChild("HumanoidRootPart")

    local function onKeyPress(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Space and not gameProcessed then -- Space tuşuna basınca
            local currentVelocity = rootPart.Velocity
            local direction = rootPart.CFrame.LookVector -- Karakterin baktığı yön
            local newVelocity = direction * (math.sqrt(currentVelocity.X^2 + currentVelocity.Z^2) * boostMultiplier)
            rootPart.Velocity = Vector3.new(newVelocity.X, currentVelocity.Y, newVelocity.Z)
        end
    end

    userInputService.InputBegan:Connect(onKeyPress)
end

-- Mevcut karakteri al ve fonksiyonu çalıştır
if player.Character then
    setupCharacter(player.Character)
end

-- Yeni karakter spawn olduğunda tekrar çalıştır
player.CharacterAdded:Connect(setupCharacter)
