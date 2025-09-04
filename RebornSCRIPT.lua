local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local jmper = 13

local function setupCharacter(character)
    local rootPart = character:WaitForChild("HumanoidRootPart")

    local function onKeyPress(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
            local currentVelocity = rootPart.Velocity
            local lookDirection = rootPart.CFrame.LookVector
            local newVelocity = currentVelocity + (lookDirection * jmper)
            rootPart.Velocity = newVelocity
        end
    end

    userInputService.InputBegan:Connect(onKeyPress)
end

if player.Character then
    setupCharacter(player.Character)
end






player.CharacterAdded:Connect(setupCharacter)
