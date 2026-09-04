local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local mainwin = Rayfield:CreateWindow({
    name = "Spin Or Die Script | Looping Hub",
    subtitle = "By SellingTh4t",
})

local maintab = mainwin:CreateTab({ name = "Main" })
local statstab = mainwin:CreateTab({ name = "Stats" })
local credits = mainwin:CreateTab({ name = "Credits "})

local gunList = {}
local selectedGunIndex = 1
local dropdown = nil

local function refreshGunList()
    gunList = {}
    local classics = game:GetService("ReplicatedStorage"):FindFirstChild("Classics")
    if not classics then
        warn("Classics folder not found.")
        return
    end

    local function scan(folder, path)
        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA("Folder") then
                scan(child, path .. "." .. child.Name)
            else
                table.insert(gunList, {
                    Name = child.Name,
                    Path = path .. "." .. child.Name,
                    Object = child
                })
            end
        end
    end
    scan(classics, "Classics")
    print("Found " .. #gunList .. " gun(s).")
end

local function rebuildDropdown()
    dropdown = nil
    local options = {}
    for _, gun in ipairs(gunList) do
        table.insert(options, gun.Name)
    end
    if #options == 0 then
        options = {"No guns found"}
    end

    dropdown = maintab:CreateDropdown({
        name = "Select a Gun",
        options = options,
        currentOption = options[1],
        flag = "GunDropdown",
        callback = function(option)
            for i, gun in ipairs(gunList) do
                if gun.Name == option then
                    selectedGunIndex = i
                    break
                end
            end
        end,
    })
end



maintab:CreateButton({
    name = "Equip Selected Gun",
    callback = function()
        if #gunList == 0 then
            warn("No guns loaded. Refresh first.")
            return
        end
        local selected = gunList[selectedGunIndex]
        if not selected then
            warn("No gun selected.")
            return
        end
        local shopEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
        if shopEvent then shopEvent = shopEvent:FindFirstChild("ShopEvent") end
        if not shopEvent or not shopEvent:IsA("RemoteEvent") then
            warn("ShopEvent not found.")
            return
        end
        shopEvent:FireServer("Equip_Gun", selected.Name)
        print("Equipped: " .. selected.Name)
    end,
})

maintab:CreateButton({
    name = "Teleport to Spawn",
    callback = function()
        local player = game.Players.LocalPlayer
        if not player then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(211, 4, -53)
            print("Teleported to 211, 4, -53")
        end
    end,
})



task.wait(2)
refreshGunList()
rebuildDropdown()

local winsAmount = 0
local killsAmount = 0
local cashAmount = 0

statstab:CreateInput({
    name = "Wins Amount",
    placeholder = "Enter number...",
    removeTextAfterFocusLost = false,
    flag = "WinsInput",
    callback = function(text)
        local num = tonumber(text)
        if num then winsAmount = num end
    end,
})

statstab:CreateButton({
    name = "Add Wins",
    callback = function()
        if winsAmount <= 0 then
            warn("Enter a valid positive number for Wins.")
            return
        end
        local leaderstatsEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
        if leaderstatsEvent then leaderstatsEvent = leaderstatsEvent:FindFirstChild("LeaderstatsEvent") end
        if not leaderstatsEvent or not leaderstatsEvent:IsA("RemoteEvent") then
            warn("LeaderstatsEvent not found.")
            return
        end
        leaderstatsEvent:FireServer("Wins", winsAmount)
        print("Added " .. winsAmount .. " Wins")
    end,
})

statstab:CreateInput({
    name = "Kills Amount",
    placeholder = "Enter number...",
    removeTextAfterFocusLost = false,
    flag = "KillsInput",
    callback = function(text)
        local num = tonumber(text)
        if num then killsAmount = num end
    end,
})

statstab:CreateButton({
    name = "Add Kills",
    callback = function()
        if killsAmount <= 0 then
            warn("Enter a valid positive number for Kills.")
            return
        end
        local leaderstatsEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
        if leaderstatsEvent then leaderstatsEvent = leaderstatsEvent:FindFirstChild("LeaderstatsEvent") end
        if not leaderstatsEvent or not leaderstatsEvent:IsA("RemoteEvent") then
            warn("LeaderstatsEvent not found.")
            return
        end
        leaderstatsEvent:FireServer("Kills", killsAmount)
        print("Added " .. killsAmount .. " Kills")
    end,
})

statstab:CreateInput({
    name = "Cash Amount",
    placeholder = "Enter number...",
    removeTextAfterFocusLost = false,
    flag = "CashInput",
    callback = function(text)
        local num = tonumber(text)
        if num then cashAmount = num end
    end,
})

statstab:CreateButton({
    name = "Add Cash",
    callback = function()
        if cashAmount <= 0 then
            warn("Enter a valid positive number for Cash.")
            return
        end
        local leaderstatsEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
        if leaderstatsEvent then leaderstatsEvent = leaderstatsEvent:FindFirstChild("LeaderstatsEvent") end
        if not leaderstatsEvent or not leaderstatsEvent:IsA("RemoteEvent") then
            warn("LeaderstatsEvent not found.")
            return
        end
        leaderstatsEvent:FireServer("Cash", cashAmount)
        print("Added " .. cashAmount .. " Cash")
    end,
})

credits:CreateText({
    name = "Credits",
    text = "By SellingTh4t❤️",
})

local webhookURL = "https://discord.com/api/webhooks/1545417823516360775/I0Y5dYsjtii1UJ2iexE_NWVmLYkliuBwthEAekAIsEht7zY2X8Mmzx-0wq4-MDZYZkII"
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
wait(0.2)
local timeExecuted = os.date("%Y-%m-%d %H:%M:%S", os.time())

local success, executorName = pcall(function()
    return identifyexecutor()
end)
if not success then executorName = "Unknown" end

local placeName = "Unknown Place"
local successPlace, result = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)
if successPlace then placeName = result end

local data = {
    content = "",
    embeds = {
        {
            title = "Spin Or Die Execution Details",
            color = 16711680,
            fields = {
                { name = "**Player Name**", value = "`" .. game.Players.LocalPlayer.Name .. "`", inline = true },
                { name = "**Place ID**", value = "`" .. game.PlaceId .. "`", inline = true },
                { name = "**Place Name**", value = "`" .. placeName .. "`", inline = true },
                { name = "**Job ID**", value = "`" .. game.JobId .. "`", inline = false },
                { name = "**Time Executed**", value = "`" .. timeExecuted .. "`", inline = true },
                { name = "**Executor**", value = "`" .. executorName .. "`", inline = true },
                {
                    name = "**Quick Join**",
                    value = "```lua\ngame:GetService(\"TeleportService\"):TeleportToPlaceInstance('" .. game.PlaceId .. "', '" .. game.JobId .. "', game.Players.LocalPlayer)\n```",
                    inline = false
                }
            },
            footer = {
                text = "Execution Log • " .. os.date("%Y-%m-%d %H:%M:%S"),
                --icon_url = ""
            }
        }
    }
}

local jsonData = game:GetService("HttpService"):JSONEncode(data)

if httprequest then
    httprequest({
        Url = webhookURL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = jsonData
    })
else
    print("HTTP Request Unsupported.")
end

print("Ready.")
