-- =====================================================================
-- FAKE PLAYER SPAWNER — Username + Fake Chat + Emotes + Movement
-- Version standalone extraite du gros script + ajouts chat & animations
-- =====================================================================
local Players           = game:GetService("Players")
local HttpService       = game:GetService("HttpService")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fsys = require(ReplicatedStorage:WaitForChild("Fsys"))
local load = Fsys.load
local UIManager   = load("UIManager")
local InventoryDB = load("InventoryDB")
local ClientData  = load("ClientData")
local HintApp     = UIManager.apps.HintApp

-- =====================================================================
-- REGISTRY
-- =====================================================================
local FakePlayers      = {}   -- folders
local FakePlayerByName = {}   -- [name] = entry
local FakePlayerById   = {}   -- [userId] = entry
local fakePlayerIds    = {}
_G.fakePlayerIds       = fakePlayerIds

local function hint(text, len)
    if HintApp then HintApp:hint({ text = text, length = len or 3, overridable = true }) end
end

-- =====================================================================
-- CHAT BUBBLE
-- =====================================================================
local function showChatBubble(entry, message, duration)
    duration = duration or 5
    local char = entry.character
    if not char or not char.Parent then return end
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return end

    local existing = head:FindFirstChild("FakeChatBubble")
    if existing then existing:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name               = "FakeChatBubble"
    bb.Size               = UDim2.new(0, 220, 0, 60)
    bb.StudsOffsetWorldSpace = Vector3.new(0, 3.4, 0)
    bb.AlwaysOnTop        = true
    bb.ResetOnSpawn       = false
    bb.Adornee            = head
    bb.Parent             = head

    local frame = Instance.new("Frame")
    frame.Size               = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel    = 0
    frame.Parent             = bb
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color        = Color3.fromRGB(120, 120, 140)
    stroke.Thickness    = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent       = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size              = UDim2.new(1, -20, 1, -16)
    textLabel.Position          = UDim2.new(0, 10, 0, 8)
    textLabel.BackgroundTransparency = 1
    textLabel.Text              = message
    textLabel.TextColor3        = Color3.fromRGB(25, 25, 35)
    textLabel.Font              = Enum.Font.GothamMedium
    textLabel.TextSize          = 14
    textLabel.TextWrapped       = true
    textLabel.TextXAlignment    = Enum.TextXAlignment.Left
    textLabel.TextYAlignment    = Enum.TextYAlignment.Center
    textLabel.Parent            = frame

    -- Pop-in
    bb.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(bb, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 220, 0, 60)
    }):Play()

    -- Pop-out
    task.delay(duration, function()
        if bb.Parent then
            local t = TweenService:Create(bb, TweenInfo.new(0.15), { Size = UDim2.new(0, 0, 0, 0) })
            t:Play()
            t.Completed:Connect(function() if bb.Parent then bb:Destroy() end end)
        end
    end)
end

-- =====================================================================
-- EMOTE / ANIMATION SYSTEM
-- =====================================================================
local EMOTES = {
    { name = "Wave",     id = "507770239" },
    { name = "Point",    id = "507770453" },
    { name = "Dance",    id = "507771019" },
    { name = "Dance 2",  id = "507776043" },
    { name = "Dance 3",  id = "182435998" },
    { name = "Cheer",    id = "507770677" },
    { name = "Laugh",    id = "507770818" },
    { name = "Salute",   id = "10921347701" },
    { name = "Kung Fu",  id = "10921342345" },
    { name = "Ninja",    id = "10921344001" },
    { name = "Flex",     id = "10921340795" },
    { name = "Ghost",    id = "10921336642" },
    { name = "Sit",      id = "2506281703" },
    { name = "Lay Down", id = "2825746228" },
    { name = "Backflip", id = "507777826" },
    { name = "Zombie",   id = "507771656" },
}

local function playEmote(entry, animId, looped)
    local char = entry.character
    if not char or not char.Parent then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end

    if entry.emoteTrack then
        pcall(function() entry.emoteTrack:Stop() end)
        entry.emoteTrack = nil
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(animId)
    local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
    if not ok or not track then return end
    track.Looped = looped and true or false
    track.Priority = Enum.AnimationPriority.Action
    track:Play()
    entry.emoteTrack = track

    if not looped then
        track.Stopped:Connect(function()
            if entry.emoteTrack == track then entry.emoteTrack = nil end
        end)
    end
end

local function stopEmote(entry)
    if entry.emoteTrack then
        pcall(function() entry.emoteTrack:Stop() end)
        entry.emoteTrack = nil
    end
end

-- =====================================================================
-- MOVEMENT
-- =====================================================================
local function movePlayerTo(entry, targetPos)
    local char = entry.character
    if not char or not char.Parent then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum:MoveTo(targetPos)
end

-- =====================================================================
-- SETUP HELPERS (client data / interact engine / name app)
-- =====================================================================
local function updateData(key, action)
    pcall(function() setthreadidentity(2) end)
    local cur = ClientData.get(key)
    local cloned = table.clone(cur or {})
    local result = action(cloned)
    ClientData.predict(key, result)
    pcall(function() setthreadidentity(8) end)
end

-- Patch SettingsHelper so fake user IDs never crash server calls
pcall(function()
    local SH = load("SettingsHelper")
    local orig = SH.get_setting_server
    SH.get_setting_server = function(player, settingName, ...)
        if player and player.UserId then
            if fakePlayerIds[player.UserId] then return false end
            if not Players:GetPlayerByUserId(player.UserId) then return false end
        end
        local args = {...}
        local ok, r = pcall(function() return orig(player, settingName, table.unpack(args)) end)
        return ok and r or false
    end
end)

-- Patch FamilyHelper
pcall(function()
    local FH = load("FamilyHelper")
    local oAFF, oIMFF, oAFBF, oIMFBF = FH.are_friends_family, FH.is_my_friend_or_family, FH.are_family_because_friends, FH.is_my_family_because_friend
    FH.are_friends_family = function(a,b)
        if a and b and (fakePlayerIds[a.UserId] or fakePlayerIds[b.UserId]) then return false end
        return oAFF(a,b)
    end
    FH.is_my_friend_or_family = function(p)
        if p and fakePlayerIds[p.UserId] then return false end
        return oIMFF(p)
    end
    FH.are_family_because_friends = function(a,b)
        if a and b and (fakePlayerIds[a.UserId] or fakePlayerIds[b.UserId]) then return false end
        return oAFBF(a,b)
    end
    FH.is_my_family_because_friend = function(p)
        if p and fakePlayerIds[p.UserId] then return false end
        return oIMFBF(p)
    end
end)

-- =====================================================================
-- FAKE PET OWNER META
-- =====================================================================
local function createFakePetOwner(char, name, uid)
    return setmetatable({Name=name, DisplayName=name, UserId=uid, Character=char}, {
        __index = function(t,k)
            if k=="Parent" then return Players end
            if k=="IsA" then return function(_,c) return c=="Player" end end
            if k=="GetChildren" then return function() return {} end end
            return rawget(t,k)
        end,
        __tostring = function() return name end,
    })
end

-- =====================================================================
-- SPAWN / REMOVE
-- =====================================================================
local function spawnFakePlayer(partnerName, partnerId, fakePetData, petFlags)
    if not partnerName or partnerName == "" then
        hint("Username required.", 3)
        return false
    end
    if FakePlayerByName[partnerName] then
        hint("Already spawned: " .. partnerName, 3)
        return false
    end

    if not partnerId then
        local ok, rid = pcall(function() return Players:GetUserIdFromNameAsync(partnerName) end)
        partnerId = ok and rid or math.random(100000000, 999999999)
    end

    fakePlayerIds[partnerId] = true
    _G.fakePlayerIds[partnerId] = true

    local folder = Instance.new("Folder")
    folder.Name = "fake_folder_" .. partnerName
    folder.Parent = workspace

    local character
    local ok, err = pcall(function()
        character = Players:CreateHumanoidModelFromUserId(partnerId)
    end)
    if not ok or not character then
        folder:Destroy()
        fakePlayerIds[partnerId] = nil
        hint("Failed to create character for " .. partnerName, 4)
        return false
    end

    local localChar = Players.LocalPlayer.Character
    if localChar and localChar.PrimaryPart then
        character:SetPrimaryPartCFrame(
            localChar.HumanoidRootPart.CFrame * CFrame.new(math.random(-12,12), 0, math.random(-12,12))
        )
    end

    local hum = character:WaitForChild("Humanoid", 5)
    if hum then
        hum.DisplayDistanceType    = Enum.HumanoidDisplayDistanceType.None
        hum.HealthDisplayType      = Enum.HumanoidHealthDisplayType.AlwaysOff
        hum.HealthDisplayDistance  = 0
    end
    character.Parent = folder

    -- Optional fake pet
    if fakePetData ~= nil then
        pcall(function()
            local kind = fakePetData.kind
            local petModel = load("DownloadClient").promise_download_copy("Pets", kind):expect()
            if not petModel then return end
            petModel = petModel:Clone()
            petModel:SetAttribute("IsFakePet", true)
            petModel.Parent = folder
            petModel:SetPrimaryPartCFrame(character.HumanoidRootPart.CFrame)
            pcall(function() petModel:ScaleTo(2) end)
            for _, p in ipairs(petModel:GetDescendants()) do
                if p:IsA("BasePart") then p:SetAttribute("IsFakePet", true) end
            end
            -- Ride constraint
            local ridePos = petModel:FindFirstChild("RidePosition", true)
            if ridePos then
                local att = Instance.new("Attachment")
                att.Parent = ridePos; att.Position = Vector3.new(0,1.237,0); att.Name = "SourceAttachment"
                local rc = Instance.new("RigidConstraint")
                rc.Name = "StateConnection"; rc.Attachment0 = att
                rc.Attachment1 = character.PrimaryPart.RootAttachment; rc.Parent = character
            end
            local ridingAnim
            local ok2, AM = pcall(load, "AnimationManager")
            if ok2 and AM then
                ridingAnim = character.Humanoid.Animator:LoadAnimation(AM.get_track("PlayerRidingPet"))
                ridingAnim.Looped = true; ridingAnim:Play()
            end
            character.Humanoid.Sit = true
        end)
    end

    -- Noclip
    for _, p in ipairs(character:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = false
            p.CanTouch  = false
            p.CanQuery  = false
            pcall(function() p.CollisionGroup = "Noclip" end)
        end
    end

    -- Name label
    pcall(function() UIManager.apps.PlayerNameApp:add_npc_id(character, partnerName) end)

    -- Interaction menu
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function()
            local ok3, IE = pcall(load, "InteractionsEngine")
            if not ok3 or not IE then return end
            IE:register({
                text = partnerName, part = hrp,
                on_selected = {
                    { text = "Profile", on_selected = function()
                        pcall(function() UIManager.apps.PlayerProfileApp:open_player_profile_for_user_id(partnerId) end)
                    end },
                    { text = "Trade", on_selected = function()
                        hint("Trade request sent to " .. partnerName, 3)
                    end },
                    { text = "Give Item...", on_selected = function() end },
                    { text = "Mute",        on_selected = function() end },
                },
            })
        end)
    end

    table.insert(FakePlayers, folder)
    folder:SetAttribute("IsFakePlayer", true)
    folder:SetAttribute("PartnerName",  partnerName)
    folder:SetAttribute("PartnerId",    partnerId)

    local entry = {
        name       = partnerName,
        userId     = partnerId,
        folder     = folder,
        character  = character,
        emoteTrack = nil,
    }
    FakePlayerByName[partnerName] = entry
    FakePlayerById[partnerId]     = entry

    hint("Spawned: " .. partnerName, 2)
    return true
end

local function removeFakePlayer(nameOrId)
    local entry = FakePlayerByName[nameOrId] or FakePlayerById[nameOrId]
    if not entry then return false end
    fakePlayerIds[entry.userId] = nil
    if _G.fakePlayerIds then _G.fakePlayerIds[entry.userId] = nil end
    if entry.folder and entry.folder.Parent then entry.folder:Destroy() end
    FakePlayerByName[entry.name] = nil
    FakePlayerById[entry.userId] = nil
    for i, f in ipairs(FakePlayers) do
        if f == entry.folder then table.remove(FakePlayers, i); break end
    end
    hint("Removed: " .. entry.name, 2)
    return true
end

local function deleteAllFakePlayers()
    for _, entry in pairs(FakePlayerByName) do
        if entry.folder and entry.folder.Parent then entry.folder:Destroy() end
    end
    FakePlayers      = {}
    FakePlayerByName = {}
    FakePlayerById   = {}
    fakePlayerIds    = {}
    _G.fakePlayerIds = {}
    hint("All fake players removed.", 3)
end

-- =====================================================================
-- PUBLIC API (_G.FakePlayerSpawner)
-- =====================================================================
_G.FakePlayerSpawner = {
    spawn       = spawnFakePlayer,
    remove      = removeFakePlayer,
    removeAll   = deleteAllFakePlayers,

    chat = function(name, message, duration)
        local e = FakePlayerByName[name]
        if e then showChatBubble(e, message, duration) end
    end,

    emote = function(name, animId, looped)
        local e = FakePlayerByName[name]
        if e then playEmote(e, animId, looped) end
    end,

    stopEmote = function(name)
        local e = FakePlayerByName[name]
        if e then stopEmote(e) end
    end,

    walkTo = function(name, position)
        local e = FakePlayerByName[name]
        if e then movePlayerTo(e, position) end
    end,

    walkOffset = function(name, offset)
        local e = FakePlayerByName[name]
        if not e or not e.character then return end
        local hrp = e.character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        movePlayerTo(e, hrp.Position + (offset or Vector3.new(0,0,-10)))
    end,

    list = function()
        local names = {}
        for n in pairs(FakePlayerByName) do table.insert(names, n) end
        return names
    end,
}

-- =====================================================================
-- UI
-- =====================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakePlayerControl"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 460)
main.Position = UDim2.new(0, 20, 0.5, -230)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
main.BorderSizePixel = 0
main.Parent = screenGui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(108,75,171)
mainStroke.Thickness = 1.5
mainStroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,24)
title.Position = UDim2.new(0,0,0,4)
title.BackgroundTransparency = 1
title.Text = "Fake Player Control"
title.Font = Enum.Font.FredokaOne
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(240,240,255)
title.Parent = main

-- Drag
local dragging, dragStart, startPos
title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = i.Position; startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if not dragging then return end
    if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
    local d = i.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = main
local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 32)
pad.PaddingLeft = UDim.new(0, 10)
pad.PaddingRight = UDim.new(0, 10)
pad.PaddingBottom = UDim.new(0, 10)
pad.Parent = main

local function sectionLabel(text, order)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,0,0,14)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.SourceSansSemibold
    l.TextSize = 11
    l.TextColor3 = Color3.fromRGB(180,180,190)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.LayoutOrder = order
    l.Parent = main
    return l
end

local function makeBox(placeholder, default, order)
    local b = Instance.new("TextBox")
    b.Size = UDim2.new(1,0,0,26)
    b.BackgroundColor3 = Color3.fromRGB(40,40,52)
    b.Text = default or ""
    b.PlaceholderText = placeholder or ""
    b.PlaceholderColor3 = Color3.fromRGB(110,110,130)
    b.Font = Enum.Font.SourceSans
    b.TextSize = 12
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.ClearTextOnFocus = false
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.LayoutOrder = order
    b.Parent = main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
    local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0,6); p.PaddingRight = UDim.new(0,6); p.Parent = b
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(80,80,100); s.Thickness = 1; s.Parent = b
    return b
end

local function makeBtn(text, order, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,24)
    b.BackgroundColor3 = color or Color3.fromRGB(35,35,48)
    b.Text = text
    b.Font = Enum.Font.FredokaOne
    b.TextSize = 11
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.LayoutOrder = order
    b.Parent = main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(108,75,171); s.Thickness = 1.5; s.Transparency = 0.3; s.Parent = b
    return b
end

-- === Section: Spawn ===
sectionLabel("▸ Spawn", 1)
local usernameBox = makeBox("Username (or leave blank for preset)", "", 2)
local userIdBox   = makeBox("User ID (optional)", "", 3)
local spawnBtn    = makeBtn("Spawn Fake Player", 4)
local deleteAllBtn= makeBtn("Delete All Fake Players", 5, Color3.fromRGB(60,30,30))

-- === Section: Select ===
sectionLabel("▸ Target Player", 6)
local targetBtn = makeBtn("Target: (none)", 7)
local targetList = Instance.new("ScrollingFrame")
targetList.Size = UDim2.new(1,0,0,80)
targetList.BackgroundColor3 = Color3.fromRGB(25,25,35)
targetList.BackgroundTransparency = 0.3
targetList.BorderSizePixel = 0
targetList.ScrollBarThickness = 3
targetList.CanvasSize = UDim2.new(0,0,0,0)
targetList.AutomaticCanvasSize = Enum.AutomaticSize.Y
targetList.Visible = false
targetList.LayoutOrder = 8
targetList.Parent = main
Instance.new("UICorner", targetList).CornerRadius = UDim.new(0,4)
local tlLayout = Instance.new("UIListLayout"); tlLayout.SortOrder = Enum.SortOrder.LayoutOrder; tlLayout.Padding = UDim.new(0,2); tlLayout.Parent = targetList
local tlPad = Instance.new("UIPadding"); tlPad.PaddingTop = UDim.new(0,4); tlPad.PaddingLeft = UDim.new(0,4); tlPad.PaddingRight = UDim.new(0,4); tlPad.PaddingBottom = UDim.new(0,4); tlPad.Parent = targetList

local selectedName = nil

local function rebuildTargetList()
    for _, c in ipairs(targetList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local i = 0
    for name in pairs(FakePlayerByName) do
        i = i + 1
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,-4,0,20)
        b.BackgroundColor3 = Color3.fromRGB(40,40,55)
        b.Text = "  " .. name
        b.Font = Enum.Font.SourceSans
        b.TextSize = 11
        b.TextColor3 = Color3.fromRGB(220,220,235)
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.LayoutOrder = i
        b.Parent = targetList
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,3)
        b.MouseButton1Click:Connect(function()
            selectedName = name
            targetBtn.Text = "Target: " .. name
            targetList.Visible = false
        end)
    end
end

targetBtn.MouseButton1Click:Connect(function()
    rebuildTargetList()
    targetList.Visible = not targetList.Visible
end)

-- === Section: Chat ===
sectionLabel("▸ Fake Chat", 9)
local chatBox = makeBox("Message to send...", "", 10)
local chatBtn = makeBtn("Send Chat Message", 11)

-- === Section: Emotes ===
sectionLabel("▸ Emotes", 12)
local emoteBtn = makeBtn("Emote: Wave", 13)
local emoteList = Instance.new("ScrollingFrame")
emoteList.Size = UDim2.new(1,0,0,140)
emoteList.BackgroundColor3 = Color3.fromRGB(25,25,35)
emoteList.BackgroundTransparency = 0.3
emoteList.BorderSizePixel = 0
emoteList.ScrollBarThickness = 3
emoteList.CanvasSize = UDim2.new(0,0,0,0)
emoteList.AutomaticCanvasSize = Enum.AutomaticSize.Y
emoteList.Visible = false
emoteList.LayoutOrder = 14
emoteList.Parent = main
Instance.new("UICorner", emoteList).CornerRadius = UDim.new(0,4)
local elLayout = Instance.new("UIListLayout"); elLayout.SortOrder = Enum.SortOrder.LayoutOrder; elLayout.Padding = UDim.new(0,2); elLayout.Parent = emoteList
local elPad = Instance.new("UIPadding"); elPad.PaddingTop = UDim.new(0,4); elPad.PaddingLeft = UDim.new(0,4); elPad.PaddingRight = UDim.new(0,4); elPad.PaddingBottom = UDim.new(0,4); elPad.Parent = emoteList

local selectedEmote = EMOTES[1]

for i, e in ipairs(EMOTES) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-4,0,20)
    b.BackgroundColor3 = Color3.fromRGB(40,40,55)
    b.Text = "  " .. e.name
    b.Font = Enum.Font.SourceSans
    b.TextSize = 11
    b.TextColor3 = Color3.fromRGB(220,220,235)
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.LayoutOrder = i
    b.Parent = emoteList
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,3)
    b.MouseButton1Click:Connect(function()
        selectedEmote = e
        emoteBtn.Text = "Emote: " .. e.name
        emoteList.Visible = false
    end)
end

emoteBtn.MouseButton1Click:Connect(function()
    emoteList.Visible = not emoteList.Visible
end)

local loopToggle = Instance.new("TextButton")
loopToggle.Size = UDim2.new(1,0,0,22)
loopToggle.BackgroundColor3 = Color3.fromRGB(35,35,48)
loopToggle.Text = "Loop: OFF"
loopToggle.Font = Enum.Font.FredokaOne
loopToggle.TextSize = 10
loopToggle.TextColor3 = Color3.fromRGB(255,255,255)
loopToggle.LayoutOrder = 15
loopToggle.Parent = main
Instance.new("UICorner", loopToggle).CornerRadius = UDim.new(0,4)
local lStroke = Instance.new("UIStroke"); lStroke.Color = Color3.fromRGB(108,75,171); lStroke.Thickness = 1.5; lStroke.Transparency = 0.3; lStroke.Parent = loopToggle
local looped = false
loopToggle.MouseButton1Click:Connect(function()
    looped = not looped
    loopToggle.Text = "Loop: " .. (looped and "ON" or "OFF")
    loopToggle.BackgroundColor3 = looped and Color3.fromRGB(55,45,75) or Color3.fromRGB(35,35,48)
end)

local playEmoteBtn = makeBtn("Play Emote", 16)
local stopEmoteBtn = makeBtn("Stop Emote", 17)

-- === Section: Move ===
sectionLabel("▸ Movement", 18)
local walkFwdBtn = makeBtn("Walk Forward (near player)", 19)
local walkRandBtn = makeBtn("Walk Random", 20)

-- =====================================================================
-- HANDLERS
-- =====================================================================
local PRESET_USERS = {
    'Agusmareborn', 'Kellyvault', 'J3llynoah', 'Rainbowriley321', 'Bobazmalibu',
    'H3llSANG3LX', 'Xcallmeholly', 'Niniko_201999', 'Hugso09', 'ruthjavxn',
    'bwpico', 'Hugeinvestor', 'Barborich2', 'Underthechemtrailss', 'Bunzvii',
}
local presetIdx = 0

spawnBtn.MouseButton1Click:Connect(function()
    local name = usernameBox.Text
    if name == "" then
        presetIdx = (presetIdx % #PRESET_USERS) + 1
        name = PRESET_USERS[presetIdx]
        usernameBox.Text = name
    end
    local uid = tonumber(userIdBox.Text)
    spawnFakePlayer(name, uid, nil, nil)
    rebuildTargetList()
end)

deleteAllBtn.MouseButton1Click:Connect(function()
    deleteAllFakePlayers()
    selectedName = nil
    targetBtn.Text = "Target: (none)"
    rebuildTargetList()
end)

chatBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry then hint("Player no longer exists.", 3); return end
    if chatBox.Text == "" then return end
    showChatBubble(entry, chatBox.Text, 6)
    chatBox.Text = ""
end)

playEmoteBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry then hint("Player no longer exists.", 3); return end
    playEmote(entry, selectedEmote.id, looped)
end)

stopEmoteBtn.MouseButton1Click:Connect(function()
    if not selectedName then return end
    local entry = FakePlayerByName[selectedName]
    if entry then stopEmote(entry) end
end)

walkFwdBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry or not entry.character then return end
    local lhrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if lhrp then
        local target = (lhrp.CFrame * CFrame.new(0, 0, -6)).Position
        movePlayerTo(entry, target)
    end
end)

walkRandBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry or not entry.character then return end
    local hrp = entry.character:FindFirstChild("HumanoidRootPart")
    if hrp then
        movePlayerTo(entry, hrp.Position + Vector3.new(math.random(-15,15), 0, math.random(-15,15)))
    end
end)

-- =====================================================================
-- DONE
-- =====================================================================
hint("Fake Player Control loaded.", 3)