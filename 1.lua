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
wait(1)
game:GetService("RunService"):Set3dRenderingEnabled(false)
ImproveFPSenabled = true
CurrentCoinType = "SnowToken"
tweenspeed = 25
ResetWhenFullBag = true

Player = game.Players.LocalPlayer
Players = game.Players
RunService = game:GetService("RunService")
CoinCollectedEvent = game.ReplicatedStorage.Remotes.Gameplay.CoinCollected
RoundStartEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundStart
RoundEndEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundEndFade

AutofarmIN = false
AutofarmStarted = false

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

function Tween(targetCFrame, tweenSpeed)
    local player = game.Players.LocalPlayer
    -- Kiểm tra xem người chơi và HumanoidRootPart có tồn tại không
    if player.Character and player.Character:WaitForChild("HumanoidRootPart") then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local target = player.Character.HumanoidRootPart
        -- Lấy vị trí hiện tại của HumanoidRootPart
        local currentPosition = target.CFrame.Position
        -- Tính toán khoảng cách giữa vị trí hiện tại và vị trí mục tiêu
        local distance = (targetCFrame.Position - currentPosition).magnitude
        -- Tính toán thời gian cần thiết để di chuyển với tốc độ cho trước (tốc độ là stud/s)
        local time = distance / tweenSpeed

        -- Tạo tween cho HumanoidRootPart
        local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local tween = game:GetService("TweenService"):Create(target, tweenInfo, {CFrame = targetCFrame})

        target.CanCollide = false
        target.Anchored = true

        -- Bắt đầu tween
        tween:Play()

        -- Khi tween kết thúc, phục hồi lại các giá trị ban đầu
        tween.Completed:Connect(function()
            target.CanCollide = true
            target.Anchored = false
        end)
    end
end

function returncoincontainer()
    for _, v in workspace:GetChildren() do
        if v:FindFirstChild("CoinContainer") and v:IsA("Model") then
            return v:FindFirstChild("CoinContainer")
        end
    end
    return nil  -- Trả về nil khi không tìm thấy CoinContainer
end

-- New function to return the closest CoinContainer
function returnClosestCoinContainer()
    local coinContainer = returncoincontainer()
    if coinContainer then
        local closestContainer = nil
        local closestDistance = math.huge
        for _, v in pairs(coinContainer:GetChildren()) do
            if v:GetAttribute("CoinID") == CurrentCoinType and v:FindFirstChild("TouchInterest") then
                local distance = (Player.Character.HumanoidRootPart.Position - v.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestContainer = v
                end
            end
        end
        return closestContainer
    end
    return nil  -- Trả về nil nếu không có container gần nhất
end

spawn(function()
    while true do
        if AutofarmStarted and AutofarmIN and Player.Character then
            local closestContainer = returnClosestCoinContainer()
            if closestContainer then
                -- Thực hiện tween chỉ 1 lần
                Tween(closestContainer.CFrame, tweenspeed)
            end
        end
        wait(0.1)
    end
end)

local previousCurrent = 0  -- Biến lưu giá trị current trước đó

CoinCollectedEvent.OnClientEvent:Connect(function(cointype, current, max)
    AutofarmIN = true
    if cointype == CurrentCoinType then
        -- Kiểm tra nếu current đã tăng thêm 1 giá trị so với giá trị trước đó
        if tonumber(current) == tonumber(previousCurrent) + 1 then
            local closestContainer = returnClosestCoinContainer()
            if closestContainer then
                Tween(closestContainer.CFrame, tweenspeed)
            end
        end

        -- Cập nhật giá trị current trước đó
        previousCurrent = tonumber(current)

        -- Nếu current đạt max, reset lại và xử lý hết vòng chơi
        if tonumber(current) == tonumber(max) then
            AutofarmIN = false
            Player.Character.Humanoid.Health = 0
        end
    end
end)

RoundStartEvent.OnClientEvent:Connect(function()
    AutofarmStarted = true 
    AutofarmIN = true
end)

-- Lắng nghe sự kiện RoundEnd
RoundEndEvent.OnClientEvent:Connect(function()
    AutofarmStarted = false 
    AutofarmIN = false
end)

-- Cải thiện FPS khi nhân vật mới gia nhập
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

-- Phòng ngừa AFK
wait(0.5)
print("Activate Anti AFK")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    print("Roblox tried kicking you but I didn't let them!")
end)
