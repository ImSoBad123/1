repeat task.wait() until game:IsLoaded() and game:GetService("Player").LocalPlayer
print("Activate Anti AFK")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    print("Roblox tried kicking you but I didn't let them!")
end)

wait(1)
ImproveFPSenabled = true
CurrentCoinType = "SnowToken"
AutofarmDelay = 2
ResetWhenFullBag = true
antibug = true


Player = game.Players.LocalPlayer
Players = game.Players
RunService = game:GetService("RunService")
CoinCollectedEvent = game.ReplicatedStorage.Remotes.Gameplay.CoinCollected
RoundStartEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundStart
RoundEndEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundEndFade
LastCurrent = 0 -- Initialize to prevent nil value

AutofarmIN = true
AutofarmStarted = true

function StartAutofarm()
    AutofarmStarted = not AutofarmStarted
    AutofarmIN = AutofarmStarted
end

function ImproveFPS()
    ImproveFPSenabled = not ImproveFPSenabled
    if ImproveFPSenabled then
        for _, player in pairs(Players:GetChildren()) do
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("Accessory") or part.Name == "Radio" then
                        part:Destroy()
                    end
                end
            end
        end
    end
end

bringpose = CFrame.new(math.random(-5, 5), -100, math.random(-5, 5))
safepart = Instance.new("Part")
safepart.Anchored = true
safepart.Massless = true
safepart.Transparency = 1
safepart.Size = Vector3.new(2048, 0.5, 2048)
safepart.CFrame = bringpose * CFrame.new(0, -1.2, 0)
safepart.Parent = workspace

function returncoincontainer()
    for _, v in workspace:GetChildren() do
        if v:FindFirstChild("CoinContainer") and v:IsA("Model") then
            return v:FindFirstChild("CoinContainer")
        end
    end
    return nil
end

local lastChangeTime = tick()
local rejoinDelay = 300 -- 5 minutes

CoinCollectedEvent.OnClientEvent:Connect(function(cointype, current, max)
    AutofarmIN = true
    if cointype == CurrentCoinType and tonumber(current) == tonumber(max) then
        AutofarmIN = false
        Player.Character.Humanoid.Health = 0
    end
end)

function PcallTP(Position)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = Position
    end
end

spawn(function()
    while true do
        if AutofarmStarted and AutofarmIN and Player.Character then
            local container = returncoincontainer()
            if container then
                PcallTP(bringpose)
                local children = container:GetChildren()
                if #children > 0 then
                    local randomIndex = math.random(1, #children)
                    local randomChild = children[randomIndex]
                    if randomChild:GetAttribute("CoinID") == CurrentCoinType and randomChild:FindFirstChild("TouchInterest") then
                        PcallTP(randomChild.CFrame)
                        while randomChild:FindFirstChild("TouchInterest") do
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, nil)
                            PcallTP(randomChild.CFrame)
                            task.wait()
                        end
                        PcallTP(bringpose)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.W, false, nil)
                        task.wait(AutofarmDelay)
                    end
                end
            end
        end
        task.wait(0.01)
    end
end)

local current_snow = game:GetService("Players").LocalPlayer.PlayerGui.CrossPlatform.Christmas2024.Container.EventFrames.BattlePass.Info.Tokens.Container.TextLabel.Text
current_snow = string.gsub(current_snow, ",", "")

spawn(function()
    while true do
        if antibug then
            local initial_snow = current_snow
            task.wait(300)
            local snow_now = game:GetService("Players").LocalPlayer.PlayerGui.CrossPlatform.Christmas2024.Container.EventFrames.BattlePass.Info.Tokens.Container.TextLabel.Text
            snow_now = string.gsub(snow_now, ",", "")
        
            if initial_snow == snow_now then
                print("Giá trị không thay đổi: ", snow_now)
                game.Players.LocalPlayer:kick("Server Bug")
                else
                print("giá trị đã thay đổi: ", snow_now)
            end
            current_snow = snow_now
        end
    end
end)

while not AutofarmIN do
    wait(1)
    PcallTP(CFrame.new(0, -97, 0)) -- Fixed invalid CFrame
end

RoundStartEvent.OnClientEvent:Connect(function()
    if AutofarmStarted then
        Player.Character.HumanoidRootPart.CFrame = bringpose
    end
    AutofarmIN = true
end)

RoundEndEvent.OnClientEvent:Connect(function()
    AutofarmIN = false
end)

for _, player1 in pairs(Players:GetChildren()) do
    player1.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if ImproveFPSenabled then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("Accessory") or part.Name == "Radio" then
                    part:Destroy()
                end
            end
        end
    end)
end

Players.PlayerAdded:Connect(function(player1)
    player1.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if ImproveFPSenabled then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("Accessory") or part.Name == "Radio" then
                    part:Destroy()
                end
            end
        end
    end)
end)
