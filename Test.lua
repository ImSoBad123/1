repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
print("Load 1st")
local waitload = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("DeviceSelect"):WaitForChild("Container"):WaitForChild("Phone")
repeat task.wait() until waitload
print("Device Select Loaded")
wait(1)
local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
local deviceSelect = playerGui:FindFirstChild("DeviceSelect")
if deviceSelect then
    local button = deviceSelect.Container.Tablet:FindFirstChild("Button")
    if button then
        for _, v in ipairs(getconnections(button.MouseButton1Click)) do
            if v.Function then
                v.Function()
            end
        end
    end
end
local gameload = playerGui:FindFirstChild("Loading")
repeat task.wait() until not gameload
print("Game Loaded")
ImproveFPSenabled = true
CurrentCoinType = "SnowToken"
tweenspeed = 30
ResetWhenFullBag = true

Player = game.Players.LocalPlayer
Players = game.Players
RunService = game:GetService("RunService")
CoinCollectedEvent = game.ReplicatedStorage.Remotes.Gameplay.CoinCollected
RoundStartEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundStart
RoundEndEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundEndFade

AutofarmIN = true
AutofarmStarted = true

function StartAutofarm()
    if not AutofarmStarted then
        AutofarmStarted = true
        AutofarmIN = true
    else
        AutofarmStarted = false
    end
end

function ImproveFPS()
    if not ImproveFPSenabled then
        ImproveFPSenabled = true
        for _, player in pairs(Players:GetChildren()) do
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("Accessory") then
                        part:Destroy()
                    end
                    if part.Name == "Radio" then
                        part:Destroy()
                    end
                end
            end
        end
    else
        ImproveFPSenabled = false
    end
end

function returncoincontainer()
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
        Player.Character.Humanoid.Health = 0
    end
end)

local player = game.Players.LocalPlayer
local platform

local function createPlatform()
    if platform then
        platform:Destroy()
    end

    platform = Instance.new("Part")
    platform.Size = Vector3.new(4, 1, 4)
    platform.Anchored = true
    platform.CanCollide = true
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Parent = workspace
end
createPlatform()

local function updatePlatformPosition(humanoidRootPart)
    while task.wait() do
        if humanoidRootPart and humanoidRootPart.Parent then
            platform.Position = humanoidRootPart.Position - Vector3.new(0, 3.95, 0) -- Giữ ô dưới chân
        end
    end
end

function TweenTP(TargetPosition, Speed)
    local TweenService = game:GetService("TweenService")
    local player = game.Players.LocalPlayer

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character.HumanoidRootPart

        -- Hàm bật/tắt trạng thái đi xuyên vật thể
        local function setCollision(character, canCollide)
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = canCollide
                end
            end
        end

        -- Tính toán thời gian dựa trên khoảng cách và tốc độ
        local function calculateDuration(startPos, endPos, speed)
            local distance = (endPos - startPos).Magnitude
            return distance / speed
        end

        -- Cấu hình Tween
        local duration = calculateDuration(humanoidRootPart.Position, TargetPosition, Speed)
        local goal = {CFrame = CFrame.new(TargetPosition)}
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)

        -- Bật chế độ đi xuyên vật thể
        setCollision(player.Character, false)

        -- Kích hoạt Tween
        tween:Play()
        -- Kích hoạt trạng thái bình thường khi Tween kết thúc
        tween.Completed:Connect(function()
            setCollision(player.Character, true) -- Bật lại va chạm
        end)
    end
end

spawn(function()
    while true do
        if AutofarmStarted and AutofarmIN and Player.Character and returncoincontainer() then
            TweenTP(returncoincontainer, tweenspeed)
            updatePlatformPosition(humanoidRootPart)
            wait(0.2)
        end
    end
end)
