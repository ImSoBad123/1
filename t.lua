--[[getgenv().username = "ayipky"]]
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.ReplicatedStorage and game.ReplicatedStorage:FindFirstChild("MultiboxFramework") and game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("FrameworkElements"):WaitForChild("ScreenBarrier"):WaitForChild("LoadingTitle").Visible
repeat task.wait() until game.Players and game.Players.LocalPlayer
local framework = require(game:GetService("ReplicatedStorage").MultiboxFramework)
repeat task.wait() until framework and framework.Loaded

if game.PlaceId == 13775256536 then
    local Players = game:GetService("Players")
    getgenv().userId = Players:GetUserIdFromNameAsync(getgenv().username)
    print("send gift")
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

    game:GetService("ReplicatedStorage"):WaitForChild("NetworkingContainer"):WaitForChild("DataRemote"):FireServer(unpack(args))
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

    game:GetService("ReplicatedStorage"):WaitForChild("NetworkingContainer"):WaitForChild("DataRemote"):FireServer(unpack(args))
    task.wait(1)    
    print("Join PVP")
    local args = {
        [1] = {
            [1] = {
                [1] = game:GetService("ReplicatedStorage").IdentifiersContainer
                    .RE_bacaa09b0bc2b34d6affc074dc2a7edf73be273551968fa3cb6753be80e46eb3.Value
            }
        }
    }

    game:GetService("ReplicatedStorage"):WaitForChild("NetworkingContainer"):WaitForChild("DataRemote"):FireServer(unpack(args))
else
    print("Ingame")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")

    local MatchTimer = ReplicatedStorage:WaitForChild("MatchData"):WaitForChild("MatchTimer")

    local function checkTimer()
        local initialValue = MatchTimer.Value
        task.wait(5)

        -- Kiểm tra nếu MatchTimer.Value lớn hơn 0 mới thực hiện teleport
        if MatchTimer.Value > 0 and MatchTimer.Value == initialValue then
            for _, player in ipairs(Players:GetPlayers()) do
                if player and player:IsA("Player") then
                    TeleportService:Teleport(13775256536, player)
                end
            end
        end
    end

    while true do
        checkTimer()
        task.wait(5)
    end
end
