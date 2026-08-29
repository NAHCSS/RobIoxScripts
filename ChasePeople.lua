local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local LP = Players.LocalPlayer
local char = LP.Character or LP.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
---------- Noclip ----------
local function enableGhostMode(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end
enableGhostMode(char)
---------- Chat ----------
local function sendMessage(text)
    local textChannel = TextChatService.TextChannels:WaitForChild("RBXGeneral")
    textChannel:SendAsync(text)
end
---------- Chase state ----------
local chaseConn = nil
local currentTarget = nil
local function stopChase()
    if chaseConn then
        chaseConn:Disconnect()
        chaseConn = nil
    end
    currentTarget = nil
end
local function chasePlayer(plr)
    stopChase()
    local targChar = plr.Character
    if not targChar then return end
    local targRoot = targChar:FindFirstChild("HumanoidRootPart")
    if not targRoot then return end
    currentTarget = plr
    sendMessage("Chasing " .. currentTarget.Name)
    chaseConn = RunService.Heartbeat:Connect(function()
        if not hum.Parent or not targRoot.Parent or not plr.Parent then
            stopChase()
            return
        end
        hum:MoveTo(targRoot.Position)
    end)
end
---------- Auto target timer ----------
local autoTargetEnabled = false
local autoTargetThread = nil
local function getValidTargets()
    local targets = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(targets, plr)
        end
    end
    return targets
end
local function startAutoTarget()
    if autoTargetEnabled then return end
    autoTargetEnabled = true
    autoTargetThread = task.spawn(function()
        while autoTargetEnabled do
            local targets = getValidTargets()
            if #targets > 0 then
                local newTarget = targets[math.random(1, #targets)]
                chasePlayer(newTarget)
            end
            local waitTime = math.random(10, 30)
            task.wait(waitTime)
        end
    end)
end
local function stopAutoTarget()
    autoTargetEnabled = false
    if autoTargetThread then
        task.cancel(autoTargetThread)
        autoTargetThread = nil
    end
end
---------- GUI ----------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChaseGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LP:WaitForChild("PlayerGui")
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 360)
mainFrame.Position = UDim2.new(0, 20, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
title.BorderSizePixel = 0
title.Text = "Players"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -32, 0, 4)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.BorderSizePixel = 0
closeButton.ZIndex = 2
closeButton.Parent = title
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
titleFix.BorderSizePixel = 0
titleFix.ZIndex = 0
titleFix.Parent = title
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -16, 0, 20)
statusLabel.Position = UDim2.new(0, 8, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Not chasing anyone"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(1, -16, 0, 28)
stopButton.Position = UDim2.new(0, 8, 0, 62)
stopButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
stopButton.Text = "Stop chasing"
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.Font = Enum.Font.GothamBold
stopButton.TextSize = 13
stopButton.BorderSizePixel = 0
stopButton.Parent = mainFrame
local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopButton
local autoButton = Instance.new("TextButton")
autoButton.Size = UDim2.new(1, -16, 0, 28)
autoButton.Position = UDim2.new(0, 8, 0, 96)
autoButton.BackgroundColor3 = Color3.fromRGB(50, 130, 80)
autoButton.Text = "Auto-target: OFF"
autoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoButton.Font = Enum.Font.GothamBold
autoButton.TextSize = 13
autoButton.BorderSizePixel = 0
autoButton.Parent = mainFrame
local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 6)
autoCorner.Parent = autoButton
local function resetAutoButtonVisual()
    autoButton.Text = "Auto-target: OFF"
    autoButton.BackgroundColor3 = Color3.fromRGB(50, 130, 80)
end
stopButton.MouseButton1Click:Connect(function()
    stopAutoTarget()
    stopChase()
    resetAutoButtonVisual()
    statusLabel.Text = "Not chasing anyone"
end)
autoButton.MouseButton1Click:Connect(function()
    if autoTargetEnabled then
        stopAutoTarget()
        stopChase()
        resetAutoButtonVisual()
        statusLabel.Text = "Not chasing anyone"
    else
        startAutoTarget()
        autoButton.Text = "Auto-target: ON"
        autoButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 1, -136)
scrollFrame.Position = UDim2.new(0, 8, 0, 132)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame
---------- Button for each player ----------
local playerButtons = {}
local function createPlayerButton(plr)
    if plr == LP then return end
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 54)
    btn.Text = plr.Name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Parent = scrollFrame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(function()
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            statusLabel.Text = plr.Name .. " has no character"
            return
        end
        stopAutoTarget()
        resetAutoButtonVisual()
        chasePlayer(plr)
        statusLabel.Text = "Chasing: " .. plr.Name
    end)
    playerButtons[plr] = btn
end
local function removePlayerButton(plr)
    if playerButtons[plr] then
        playerButtons[plr]:Destroy()
        playerButtons[plr] = nil
    end
    if currentTarget == plr then
        stopChase()
        statusLabel.Text = "Target left — chase stopped"
    end
end
for _, plr in ipairs(Players:GetPlayers()) do
    createPlayerButton(plr)
end
Players.PlayerAdded:Connect(createPlayerButton)
Players.PlayerRemoving:Connect(removePlayerButton)
---------- Chat trigger ----------
local triggerWord = "-follow" -- fixed command
local chatConnections = {}
local function findMentionedPlayer(message)
    local msg = message:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        local name = plr.Name:lower()
        local displayName = plr.DisplayName:lower()
        if msg:find(name, 1, true) or msg:find(displayName, 1, true) then
            return plr
        end
    end
    return nil
end
local function onChatted(speaker, message)
    local msg = message:lower()
    local word = triggerWord:lower()
    if not msg:find(word, 1, true) then
        return
    end
    local mentionedPlayer = findMentionedPlayer(message)
    local target = mentionedPlayer or speaker
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    stopAutoTarget()
    resetAutoButtonVisual()
    chasePlayer(target)
    if mentionedPlayer then
        statusLabel.Text = "Chasing (chat, mentioned): " .. target.Name
    else
        statusLabel.Text = "Chasing (chat, called): " .. target.Name
    end
end
local function connectChat(plr)
    chatConnections[plr] = plr.Chatted:Connect(function(message)
        onChatted(plr, message)
    end)
end
local function disconnectChat(plr)
    if chatConnections[plr] then
        chatConnections[plr]:Disconnect()
        chatConnections[plr] = nil
    end
end
for _, plr in ipairs(Players:GetPlayers()) do
    connectChat(plr)
end
closeButton.MouseButton1Click:Connect(function()
    stopAutoTarget()
    stopChase()
    for _, plr in ipairs(Players:GetPlayers()) do
        disconnectChat(plr)
    end
    screenGui:Destroy()
end)
sendMessage("Made by SellingTh4t")
Players.PlayerAdded:Connect(connectChat)
Players.PlayerRemoving:Connect(disconnectChat)
LP.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = newChar:WaitForChild("Humanoid")
    enableGhostMode(newChar)
end)