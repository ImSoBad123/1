repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
wait(1)
repeat task.wait() until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Loading")
local Player = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
print("WebHook Loaded")
while true do
task.wait(Delaysend)
local current_snow = Player.PlayerGui.CrossPlatform.Christmas2024.Container.EventFrames.BattlePass.Info.Tokens.Container.TextLabel.Text
current_snow = string.gsub(current_snow, ",", "")
local Data =
{
    ["embeds"]= {
        {            
            ["title"]= "Stats Check";
            ["color"]= tonumber(0x7269da);
            
            ["fields"]= {
                {
                    ["name"]= "Frag Check",
                    ["value"]= "```"..game.Players.LocalPlayer.Data.Fragments.Value.. "```",
                    ["inline"]= true
                },
                {
                    ["name"]= "Beli Check",
                    ["value"]= "```"..game.Players.LocalPlayer.Data.Beli.Value.. "```",
                    ["inline"]= true
                },
            }              
        }
    }
}

Request = http_request or request or HttpPost or syn.request
local Final1 = {Url = getgenv().Webhook , Body = HttpService:JSONEncode(Data), Method = "POST", Headers = {["Content-Type"]="application/json"}}

Request(Final1)
end
