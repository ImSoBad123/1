repeat wait() until game:IsLoaded() and game.ReplicatedStorage and game.ReplicatedStorage:FindFirstChild("MultiboxFramework")
task.wait(5)
repeat wait() until require(game:GetService("ReplicatedStorage").MultiboxFramework).Loaded
if game.PlaceId == 13775256536 then
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
local VirtualUser = game:service "VirtualUser"
game:service("Players").LocalPlayer.Idled:connect(
    function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
)
repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui.FinishUI.MatchFinish.Visible
repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui.Match.MatchInfo.AutoSkip.OnAndOff
local VirtualInputManager = game:GetService('VirtualInputManager')
local GuiService = game:GetService('GuiService')

task.wait(0.3)
GuiService.SelectedObject = game:GetService("Players").LocalPlayer.PlayerGui.Match.MatchInfo.AutoSkip.OnAndOff
VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
task.wait(0)
GuiService.SelectedObject = nil
while true do
    task.wait(0.3)

    GuiService.SelectedObject = game:GetService("Players").LocalPlayer.PlayerGui.FinishUI.MatchFinish.MatchFinishFrame.EndOptions.ReturnToLobby.ButtonFrame.ReturnToLobbyButton
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    task.wait(0)
    GuiService.SelectedObject = nil
end
end
