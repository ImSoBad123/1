local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
local deviceSelect = playerGui:FindFirstChild("DeviceSelect")
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer and playerGui and deviceSelect
wait(2)


repeat wait(1) until deviceSelect
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

D3RenderingDisabled = true
ImproveFPSenabled = true
CurrentCoinType = "Coin"
AutofarmDelay = 2
ResetWhenFullBag = true


Player = game.Players.LocalPlayer
Players = game.Players
RunService = game:GetService("RunService")
CoinCollectedEvent = game.ReplicatedStorage.Remotes.Gameplay.CoinCollected
RoundStartEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundStart
RoundEndEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundEndFade

local function activateSpin(args, speaker)
    local spinSpeed = tonumber(args[1]) or 20
    local character = speaker.Character or speaker.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    for _, v in pairs(rootPart:GetChildren()) do
        if v.Name == "Spinning" then v:Destroy() end
    end

    local Spin = Instance.new("BodyAngularVelocity")
    Spin.Name, Spin.Parent, Spin.MaxTorque, Spin.AngularVelocity = "Spinning", rootPart, Vector3.new(0, math.huge, 0), Vector3.new(0, spinSpeed, 0)
end

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

bringpose = CFrame.new(math.random(-5, 5), -100, math.random(-5, 5))
safepart = Instance.new("Part")
safepart.Anchored = true
safepart.Massless = true
safepart.Transparency = 1
safepart.Size = Vector3.new(2048, 0.5, 2048)
safepart.CFrame = bringpose * CFrame.new(0, -1.2, 0)
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
	if Player.Character then
		if Player.Character:FindFirstChild("HumanoidRootPart") then
			Player.Character.HumanoidRootPart.CFrame = Position
		end
	end
end


spawn(function()
	while true do
		if AutofarmStarted and AutofarmIN and Player.Character and returncoincontaier() then
			PcallTP(bringpose)
			for _, v in pairs(returncoincontaier():GetChildren()) do
				if v:GetAttribute("CoinID") == CurrentCoinType and v:FindFirstChild("TouchInterest") then
                    activateSpin({15}, game.Players.LocalPlayer)
					PcallTP(v.CFrame)
					break
				end
			end
            wait(0.2)
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

for _, player1 in pairs(Players:GetChildren()) do
	player1.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		if ImproveFPSenabled then
			for _, part in pairs(char:GetChildren()) do
				if part:IsA("Accessory") then
					part:Destroy()
				end
				if part.Name == "Radio" then
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
				if part:IsA("Accessory") then
					part:Destroy()
				end
				if part.Name == "Radio" then
					part:DestAroy()
				end
			end
		end
	end)
end)
wait(0.5)print("Activate Anti AFK")game:service('Players').LocalPlayer.Idled:connect(function()game:service('VirtualUser'):CaptureController()game:service('VirtualUser'):ClickButton2(Vector2.new())print("Roblox tried kicking you but I didn't let them!")end)

if D3RenderingDisabled then
    game:GetService("RunService"):Set3dRenderingEnabled(false)
else
    game:GetService("RunService"):Set3dRenderingEnabled(false)
end

