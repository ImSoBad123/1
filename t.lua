--getgenv().username = "ayipky"

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.ReplicatedStorage and game.ReplicatedStorage:FindFirstChild("MultiboxFramework") 
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("FrameworkElements") and game:GetService("Players").LocalPlayer.PlayerGui.FrameworkElements:FindFirstChild("ScreenBarrier") and game:GetService("Players").LocalPlayer.PlayerGui.FrameworkElements.ScreenBarrier:FindFirstChild("LoadingTitle") and game:GetService("Players").LocalPlayer.PlayerGui.FrameworkElements.ScreenBarrier.LoadingTitle.Visible

local framework = require(game:GetService("ReplicatedStorage").MultiboxFramework)
repeat task.wait() until framework and framework.Loaded

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

getgenv().userId = Players:GetUserIdFromNameAsync(getgenv().username)

if game.PlaceId == 13775256536 then
    print("Sending gift...")
        local args = {
            [1] = {
                [1] = {
                    [1] = "\226\129\130l",
                    [2] = "GoldenGladiatorCrate",
                    [3] = "Buy1",
                    [4] = getgenv().userId
                }
            }
        }
        ReplicatedStorage:WaitForChild("NetworkingContainer"):WaitForChild("DataRemote"):FireServer(unpack(args))
    task.wait(1.5)
        local args = {
            [1] = {
                [1] = {
                    [1] = "\226\129\130g",
                    [2] = "GoldenGladiatorCrate",
                    [3] = "Buy1",
                    [4] = getgenv().userId
                }
            }
        }
        ReplicatedStorage:WaitForChild("NetworkingContainer"):WaitForChild("DataRemote"):FireServer(unpack(args))

    LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Zones.Lobby.RankedPVPZone.CFrame
    task.wait(10)

    print("Joining PVP...")

    local args = {
        [1] = {
            [1] = {
                [1] = ReplicatedStorage.IdentifiersContainer
                    .RE_bacaa09b0bc2b34d6affc074dc2a7edf73be273551968fa3cb6753be80e46eb3.Value
            }
        }
    }
    
    ReplicatedStorage:WaitForChild("NetworkingContainer"):WaitForChild("DataRemote"):FireServer(unpack(args))
else
    spawn(function()
        while true do
            local args = {
                [1] = {
                    [1] = {
                        [1] = "\226\129\130^"
                    }
                }
            }
            ReplicatedStorage:WaitForChild("NetworkingContainer"):WaitForChild("DataRemote"):FireServer(unpack(args))
            task.wait()
        end
    end)

    print("Ingame")

    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    repeat task.wait() until LocalPlayer.PlayerGui.FinishUI.MatchFinish.Visible
    repeat task.wait() until LocalPlayer.PlayerGui.Match.MatchInfo.AutoSkip.OnAndOff

    local VirtualInputManager = game:GetService("VirtualInputManager")
    local GuiService = game:GetService("GuiService")

    spawn(function()
        while task.wait(0.3) do
            local returnButton = LocalPlayer.PlayerGui.FinishUI.MatchFinish.MatchFinishFrame.EndOptions.ReturnToLobby.ButtonFrame.ReturnToLobbyButton
            if returnButton then
                GuiService.SelectedObject = returnButton
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                task.wait(0)
                GuiService.SelectedObject = nil
            end
        end
    end)
end
