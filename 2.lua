print("Loading Config: " .. (_G.cfig or "Unknown"))
local url
local main = {"Username"}  -- Nếu 'Username' là một chuỗi, cần chuyển thành bảng

wait(0.3)

--editted
local function isInMain(playerName)
    for _, name in ipairs(main) do
        if name == playerName then
            return true
        end
    end
    return false
end

if isInMain(game.Players.LocalPlayer.Name) then
    print("main acc")
    url = "https://raw.githubusercontent.com/Milleu830/BFcfig/main/main.json"
else
    if _G.cfig == "Frag" then
        print("not main")
        url = "https://raw.githubusercontent.com/sonlamv1/BF/main/frag.json"
    elseif _G.cfig == "Cybord" then
        print("not main")
        url = "https://raw.githubusercontent.com/Milleu830/config/main/cy.json"
    end
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerName = player.Name  -- Lấy tên của người chơi

-- Thiết lập thư mục và tên file
local folder = "True W-azure V2_Beta/ConfigMain"
local filename = playerName .. ".json"
local filename2 = playerName .. ".txt"
local main = "True W-azure V2_Beta/Main"

-- Tạo thư mục nếu chưa tồn tại
if not isfolder(folder) then
    makefolder(folder)
    makefolder("True W-azure V2_Beta/Cache")
    makefolder(main)
    makefolder("True W-azure V2_Beta/SameAcc")
    makefolder("True W-azure V2_Beta/Theme")
end

writefile(main .. "/" .. filename2, "True W-azure V2_Beta/ConfigMain/" .. playerName .. ".json")

-- Kiểm tra nếu URL đã được thiết lập trước khi thực hiện
if url then
    local response = game:HttpGet(url)
    
    -- Giải mã JSON thành bảng Lua
    local config = HttpService:JSONDecode(response)
    
    wait(0.3)
    print("write cfig")
    -- Ghi file cấu hình
    writefile(folder .. "/" .. filename, HttpService:JSONEncode(config))
else
    warn("URL not set. Configuration may not have been loaded.")
end

wait(0.2)
print("loading script")
