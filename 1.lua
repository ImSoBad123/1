if not game:IsLoaded() then
	game.Loaded:Wait()
end

wait(5)
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("DeviceSelect") then
    for i,t in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.DeviceSelect.Container.Tablet.Button["MouseButton1Click"])) do
        t:Fire()
    end
end

D3RenderingDisabled = true
ImproveFPSenabled = true
CoinTypes = {"Coin"}
CurrentCoinType = "Coin"
PositionOfCoinType = 1
AutofarmDelay = 2
ResetWhenFullBag = true
AutofarmIN = true

Player = game.Players.LocalPlayer
Players = game.Players
RunService = game:GetService("RunService")
CoinCollectedEvent = game.ReplicatedStorage.Remotes.Gameplay.CoinCollected
RoundStartEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundStart
RoundEndEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundEndFade

function AntiAFK()
	local GC = getconnections or get_signal_cons
	if GC then
		for i,v in pairs(GC(Player.Idled)) do
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

AutofarmStarted = true
function StartAutofarm()
	if not AutofarmStarted then
		AutofarmStarted = true
		AutofarmIN = true
	else
		AutofarmStarted = false
	end
end


if D3RenderingDisabled then
	RunService:Set3dRenderingEnabled(false)
else
	RunService:Set3dRenderingEnabled(true)
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
					for i = 1,7 do
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
					part:Destroy()
				end
			end
		end
	end)
end)
