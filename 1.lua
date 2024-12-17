AntiAfkState = true
AutofarmStarted = true
ImproveFPSenabled = true
CoinTypes = {"Candy", "Coin"}
CurrentCoinType = "Coin"
PositionOfCoinType = 1
AutofarmDelay = 3
ResetWhenFullBag = true
AutofarmIN = true

if not game:IsLoaded() then
	game.Loaded:Wait()
end
SettingsAutofarm = {}
if _G.AutofarmSettings then
	SettingsAutofarm = _G.AutofarmSettings
else
	_G.AutofarmSettings = {}
	SettingsAutofarm = {AntiAfk = true, DelayFarm = 3}
end
if _G.AutoFarmMM2IsLoaded then return end
_G.AutoFarmMM2IsLoaded = true

if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("DeviceSelect") then
    for i,t in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.DeviceSelect.Container.Tablet.Button["MouseButton1Click"])) do
        t:Fire()
    end
end

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


function StartAutofarm()
	if not AutofarmStarted then
		AutofarmStarted = true
		AutofarmIN = true
	else
		AutofarmStarted = false
	end
end

-- Disable 3D Rendering

function Disable3DRender()
	if not D3RenderingDisabled then
		D3RenderingDisabled = true
		RunService:Set3dRenderingEnabled(false)
	else
		D3RenderingDisabled = false
		RunService:Set3dRenderingEnabled(true)
	end
end

-- Improve FPS

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


function ChangeCoinType(cointype)
	if cointype then
		if table.find(CoinTypes, cointype) then
			CurrentCoinType = cointype
			PositionOfCoinType = table.find(CoinTypes, cointype)
			return
		end
		return
	end
	if PositionOfCoinType ~= table.maxn(CoinTypes) then
		PositionOfCoinType += 1
		CurrentCoinType = CoinTypes[PositionOfCoinType]
	else
		PositionOfCoinType = 1
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

-- FPS Optimization
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
Disable3DRender()
