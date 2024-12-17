AutofarmDelay = 3
ResetWhenFullBag = true
AutofarmIN = true
AntiAfkState = true
D3RenderingDisabled = true
ImproveFPSenabled = true
CurrentCoinType = "Coin"
PositionOfCoinType = 1
AutofarmStarted = true
CoinTypes = {"Candy", "Coin"}
SettingsAutofarm = _G.AutofarmSettings or {AntiAfk = true, DelayFarm = 3}

if not game:IsLoaded() then
    game.Loaded:Wait()
end
if _G.AutoFarmMM2IsLoaded then return end
_G.AutoFarmMM2IsLoaded = true

Player = game.Players.LocalPlayer
Players = game.Players
RunService = game:GetService("RunService")
CoinCollectedEvent = game.ReplicatedStorage.Remotes.Gameplay.CoinCollected
RoundStartEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundStart
RoundEndEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundEndFade

-- Anti AFK Function
function AntiAFK()
    local GC = getconnections or get_signal_cons
    if GC then
        for _,v in pairs(GC(Player.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
    else
        local VirtualUser = cloneref(game:GetService("VirtualUser"))
        Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end

function StartAutofarm()
    AutofarmStarted = not AutofarmStarted
    AutofarmIN = AutofarmStarted
end

function Disable3DRender()
    D3RenderingDisabled = not D3RenderingDisabled
    RunService:Set3dRenderingEnabled(not D3RenderingDisabled)
end

function ImproveFPS()
    ImproveFPSenabled = not ImproveFPSenabled
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

function ChangeCoinType(cointype)
    if cointype and table.find(CoinTypes, cointype) then
        CurrentCoinType = cointype
        PositionOfCoinType = table.find(CoinTypes, cointype)
    else
        PositionOfCoinType = (PositionOfCoinType % #CoinTypes) + 1
        CurrentCoinType = CoinTypes[PositionOfCoinType]
    end
end

bringpose = CFrame.new(math.random(-5, 5), -100, math.random(-5, 5))
safepart = Instance.new("Part")
safepart.Anchored = true
safepart.Massless = true
safepart.Transparency = 1
safepart.Size = Vector3.new(2048, 0.5, 2048)
safepart.CFrame = bringpose * CFrame.new(0, -0.9, 0)
safepart.Parent = workspace

function returncoincontaier()
    for _, v in workspace:GetChildren() do
        if v:FindFirstChild("CoinContainer") and v:IsA("Model") then
            return v:FindFirstChild("CoinContainer")
        end
    end
    return false
end

CoinCollectedEvent.OnClientEvent:Connect(function(cointype, current, max)
    AutofarmIN = true
    if cointype == CurrentCoinType and tonumber(current) == tonumber(max) then
        AutofarmIN = false
        if ResetWhenFullBag then
            Player.Character.Humanoid.Health = 0
        end
    end
end)

function PcallTP(Position)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = Position
    end
end

spawn(function()
    while true do
        if AutofarmStarted and AutofarmIN and Player.Character and returncoincontaier() then
            PcallTP(bringpose)
            for _, v in pairs(returncoincontaier():GetChildren()) do
                if v:GetAttribute("CoinID") == CurrentCoinType and v:FindFirstChild("TouchInterest") then
                    for _ = 1,7 do
                        PcallTP(v.CFrame)
                        task.wait(0.03)
                    end
                    break
                end
            end
            PcallTP(bringpose)
        end
        task.wait(AutofarmDelay)
    end
end)

RoundStartEvent.OnClientEvent:Connect(function()
    if AutofarmStarted then Player.Character.HumanoidRootPart.CFrame = bringpose end
    AutofarmIN = true
end)

RoundEndEvent.OnClientEvent:Connect(function()
    AutofarmIN = false
end)

-- FPS Optimization
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

-- Configurations
for Configname, Configvalue in pairs(SettingsAutofarm) do
    if Configname == "AntiAfk" and Configvalue == true then
        AntiAFK()
    elseif Configname == "DelayFarm" and tonumber(Configvalue) and tonumber(Configvalue) < 8 then
        AutofarmDelay = tonumber(Configvalue)
    elseif Configname == "StartAutofarm" and Configvalue == true then
        StartAutofarm()
    elseif Configname == "ImproveFPS" and Configvalue == true then
        ImproveFPS()
    elseif Configname == "Disable3DRendering" and Configvalue == true then
        Disable3DRender()
    elseif Configname == "CoinType" and Configvalue then
        ChangeCoinType(Configvalue)
    elseif Configname == "ResetWhenFullBag" and Configvalue == true then
        ResetWhenFullBag = true
    end
end

wait(1)
