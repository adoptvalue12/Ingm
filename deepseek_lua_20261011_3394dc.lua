-- =====================================================================
-- FAKE PLAYER SPAWNER v2 — Adopt Me style chat + working emotes + follow
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

local hint = function(t, l) if HintApp then HintApp:hint({ text = t, length = l or 3, overridable = true }) end end

-- =====================================================================
-- REGISTRIES
-- =====================================================================
local FakePlayers      = {}
local FakePlayerByName = {}
local FakePlayerById   = {}
local fakePlayerIds    = {}
_G.fakePlayerIds = fakePlayerIds

-- =====================================================================
-- ADOPT ME STYLE CHAT BUBBLE
-- =====================================================================
local function showChatBubble(entry, message, duration)
    duration = duration or 5
    local char = entry.character
    if not char or not char.Parent then return end
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return end

    local existing = head:FindFirstChild("FakeChatBubble")
    if existing then existing:Destroy() end

    -- Outer billboard (holds name + bubble + tail)
    local bb = Instance.new("BillboardGui")
    bb.Name = "FakeChatBubble"
    bb.Size = UDim2.new(0, 240, 0, 90)
    bb.StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false
    bb.Adornee = head
    bb.Parent = head

    -- Name label above bubble
    local nameTag = Instance.new("TextLabel")
    nameTag.Size = UDim2.new(1, 0, 0, 16)
    nameTag.Position = UDim2.new(0, 0, 0, 0)
    nameTag.BackgroundTransparency = 1
    nameTag.Font = Enum.Font.GothamBold
    nameTag.TextSize = 13
    nameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameTag.TextStrokeTransparency = 0
    nameTag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameTag.Text = entry.name
    nameTag.Parent = bb

    -- Bubble container
    local bubble = Instance.new("Frame")
    bubble.Name = "Bubble"
    bubble.Size = UDim2.new(1, 0, 1, -22)
    bubble.Position = UDim2.new(0, 0, 0, 18)
    bubble.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bubble.BackgroundTransparency = 0.03
    bubble.BorderSizePixel = 0
    bubble.Parent = bb
    Instance.new("UICorner", bubble).CornerRadius = UDim.new(0, 14)

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(210, 210, 220)
    bStroke.Thickness = 1.5
    bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    bStroke.Parent = bubble

    -- Speech tail (triangle pointing down using rotation trick with 4x4 frame)
    local tail = Instance.new("Frame")
    tail.Name = "Tail"
    tail.Size = UDim2.new(0, 16, 0, 16)
    tail.Position = UDim2.new(0.5, -8, 1, -8)
    tail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tail.BorderSizePixel = 0
    tail.Rotation = 45
    tail.ZIndex = 0
    tail.Parent = bubble

    local tailStroke = Instance.new("UIStroke")
    tailStroke.Color = Color3.fromRGB(210, 210, 220)
    tailStroke.Thickness = 1.5
    tailStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    tailStroke.Parent = tail

    -- Message text
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -20, 1, -12)
    msg.Position = UDim2.new(0, 10, 0, 6)
    msg.BackgroundTransparency = 1
    msg.Font = Enum.Font.GothamMedium
    msg.TextSize = 14
    msg.TextColor3 = Color3.fromRGB(35, 35, 45)
    msg.Text = message
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Center
    msg.TextYAlignment = Enum.TextYAlignment.Center
    msg.ZIndex = 2
    msg.Parent = bubble

    -- Pop-in animation
    local baseSize = bb.Size
    bb.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(bb, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = baseSize
    }):Play()

    -- Pop-out after duration
    task.delay(duration, function()
        if bb.Parent then
            local t = TweenService:Create(bb, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            })
            t:Play()
            t.Completed:Connect(function() if bb.Parent then bb:Destroy() end end)
        end
    end)
end

-- =====================================================================
-- ADOPT ME STYLE CHAT LOG (visible panel on right side)
-- =====================================================================
local chatLogGui = Instance.new("ScreenGui")
chatLogGui.Name = "FakeChatLog"
chatLogGui.ResetOnSpawn = false
chatLogGui.DisplayOrder = 999
chatLogGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local chatLogFrame = Instance.new("Frame")
chatLogFrame.Size = UDim2.new(0, 280, 0, 320)
chatLogFrame.Position = UDim2.new(1, -300, 0.5, -160)
chatLogFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
chatLogFrame.BackgroundTransparency = 0.15
chatLogFrame.BorderSizePixel = 0
chatLogFrame.Parent = chatLogGui
Instance.new("UICorner", chatLogFrame).CornerRadius = UDim.new(0, 10)

local clStroke = Instance.new("UIStroke")
clStroke.Color = Color3.fromRGB(108, 75, 171)
clStroke.Thickness = 1.5
clStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
clStroke.Parent = chatLogFrame

local clTitle = Instance.new("TextLabel")
clTitle.Size = UDim2.new(1, 0, 0, 22)
clTitle.BackgroundTransparency = 1
clTitle.Font = Enum.Font.FredokaOne
clTitle.TextSize = 12
clTitle.TextColor3 = Color3.fromRGB(220, 200, 255)
clTitle.Text = "💬 Chat Log"
clTitle.Parent = chatLogFrame

local clScroll = Instance.new("ScrollingFrame")
clScroll.Size = UDim2.new(1, -10, 1, -30)
clScroll.Position = UDim2.new(0, 5, 0, 25)
clScroll.BackgroundTransparency = 1
clScroll.BorderSizePixel = 0
clScroll.ScrollBarThickness = 3
clScroll.ScrollBarImageColor3 = Color3.fromRGB(108, 75, 171)
clScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
clScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
clScroll.Parent = chatLogFrame

local clLayout = Instance.new("UIListLayout")
clLayout.SortOrder = Enum.SortOrder.LayoutOrder
clLayout.Padding = UDim.new(0, 4)
clLayout.Parent = clScroll
local clPad = Instance.new("UIPadding")
clPad.PaddingTop = UDim.new(0, 4)
clPad.PaddingLeft = UDim.new(0, 4)
clPad.PaddingRight = UDim.new(0, 4)
clPad.Parent = clScroll

local chatLogCounter = 0
local function addToChatLog(speakerName, message)
    chatLogCounter = chatLogCounter + 1

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 0)
    row.AutomaticSize = Enum.AutomaticSize.Y
    row.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
    row.BackgroundTransparency = 0.2
    row.BorderSizePixel = 0
    row.LayoutOrder = chatLogCounter
    row.Parent = clScroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local rowPad = Instance.new("UIPadding")
    rowPad.PaddingTop = UDim.new(0, 5)
    rowPad.PaddingBottom = UDim.new(0, 5)
    rowPad.PaddingLeft = UDim.new(0, 8)
    rowPad.PaddingRight = UDim.new(0, 8)
    rowPad.Parent = row

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = Color3.fromRGB(108, 75, 171)
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.7
    rowStroke.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.BackgroundTransparency = 1
    lbl.RichText = true
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3 = Color3.fromRGB(220, 220, 235)
    lbl.Text = '<font color="#DD99FF"><b>' .. speakerName .. '</b></font>  ' .. message
    lbl.Parent = row

    -- Pop-in
    row.BackgroundTransparency = 1
    rowStroke.Transparency = 1
    TweenService:Create(row, TweenInfo.new(0.2), { BackgroundTransparency = 0.2 }):Play()
    TweenService:Create(rowStroke, TweenInfo.new(0.2), { Transparency = 0.7 }):Play()

    -- Auto-scroll bottom
    task.defer(function()
        clScroll.CanvasPosition = Vector2.new(0, clScroll.AbsoluteCanvasSize.Y)
    end)

    -- Keep only last 30
    local count = 0
    for _, c in ipairs(clScroll:GetChildren()) do if c:IsA("Frame") then count = count + 1 end end
    if count > 30 then
        for _, c in ipairs(clScroll:GetChildren()) do
            if c:IsA("Frame") then c:Destroy(); break end
        end
    end

    -- Auto-remove after 30s
    task.delay(30, function()
        if row.Parent then
            TweenService:Create(row, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(rowStroke, TweenInfo.new(0.4), { Transparency = 1 }):Play()
            TweenService:Create(lbl, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
            task.wait(0.5)
            if row.Parent then row:Destroy() end
        end
    end)
end

-- =====================================================================
-- EMOTE SYSTEM — IDs validés R15 Roblox
-- =====================================================================
local EMOTES = {
    { name = "Wave",       id = 507770239  },
    { name = "Point",      id = 507770453  },
    { name = "Dance 1",    id = 507771019  },
    { name = "Dance 2",    id = 507776043  },
    { name = "Dance 3",    id = 507777826  },
    { name = "Cheer",      id = 507770677  },
    { name = "Laugh",      id = 507770818  },
    { name = "Shrug",      id = 507770971  },
    { name = "Stadium",    id = 507771217  },
    { name = "Sit",        id = 2506281703 },
    { name = "Lay Down",   id = 2825746228 },
    { name = "Kick",       id = 3360693088 },
    { name = "Idle 1",     id = 507766666  },
    { name = "Idle 2",     id = 507766951  },
    { name = "Idle 3",     id = 507766388  },
    { name = "Walk",       id = 507777268  },
    { name = "Run",        id = 507767714  },
    { name = "Jump",       id = 507765000  },
    { name = "Climb",      id = 507765644  },
    { name = "Fall",       id = 507767968  },
    { name = "Swim",       id = 507784897  },
    { name = "SwimIdle",   id = 507785072  },
}

local function playEmote(entry, animId, looped)
    local char = entry.character
    if not char or not char.Parent then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    -- Ensure Animator exists
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end

    -- Stop previous custom emote
    if entry.emoteTrack then
        pcall(function() entry.emoteTrack:Stop(0) end)
        entry.emoteTrack = nil
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(animId)

    local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
    if not ok or not track then return false end

    track.Looped = looped and true or false
    track.Priority = Enum.AnimationPriority.Action4
    track:Play(0.15)
    entry.emoteTrack = track

    if not looped then
        track.Stopped:Connect(function()
            if entry.emoteTrack == track then entry.emoteTrack = nil end
        end)
    end
    return true
end

local function stopEmote(entry)
    if entry.emoteTrack then
        pcall(function() entry.emoteTrack:Stop(0.2) end)
        entry.emoteTrack = nil
    end
end

-- =====================================================================
-- FOLLOW SYSTEM
-- =====================================================================
local followThreads = {}

local function stopFollow(entry)
    if followThreads[entry.userId] then
        task.cancel(followThreads[entry.userId])
        followThreads[entry.userId] = nil
    end
    if entry.character then
        local hum = entry.character:FindFirstChildOfClass("Humanoid")
        if hum then hum:MoveTo(entry.character.PrimaryPart.Position) end
    end
end

local function startFollow(entry)
    stopFollow(entry)
    followThreads[entry.userId] = task.spawn(function()
        while entry.character and entry.character.Parent do
            local myChar = Players.LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local hrp = entry.character:FindFirstChild("HumanoidRootPart")
            local hum = entry.character:FindFirstChildOfClass("Humanoid")
            if myHrp and hrp and hum then
                local dist = (myHrp.Position - hrp.Position).Magnitude
                if dist > 6 then
                    hum:MoveTo(myHrp.Position)
                end
            end
            task.wait(0.25)
        end
    end)
end

-- =====================================================================
-- MOVEMENT
-- =====================================================================
local function movePlayerTo(entry, pos)
    local char = entry.character
    if not char or not char.Parent then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum:MoveTo(pos) end
end

local function lookAtPlayer(entry)
    local char = entry.character
    local myChar = Players.LocalPlayer.Character
    if not char or not myChar then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if hrp and myHrp then
        local pos = Vector3.new(myHrp.Position.X, hrp.Position.Y, myHrp.Position.Z)
        hrp.CFrame = CFrame.new(hrp.Position, pos)
    end
end

-- =====================================================================
-- HELPERS
-- =====================================================================
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

pcall(function()
    local FH = load("FamilyHelper")
    local oAFF, oIMFF = FH.are_friends_family, FH.is_my_friend_or_family
    FH.are_friends_family = function(a,b)
        if a and b and (fakePlayerIds[a.UserId] or fakePlayerIds[b.UserId]) then return false end
        return oAFF(a,b)
    end
    FH.is_my_friend_or_family = function(p)
        if p and fakePlayerIds[p.UserId] then return false end
        return oIMFF(p)
    end
end)

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
        hint("Username required.", 3); return false
    end
    if FakePlayerByName[partnerName] then
        hint("Already spawned: " .. partnerName, 3); return false
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
    local ok = pcall(function()
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
            local ridePos = petModel:FindFirstChild("RidePosition", true)
            if ridePos then
                local att = Instance.new("Attachment")
                att.Parent = ridePos; att.Position = Vector3.new(0,1.237,0); att.Name = "SourceAttachment"
                local rc = Instance.new("RigidConstraint")
                rc.Name = "StateConnection"; rc.Attachment0 = att
                rc.Attachment1 = character.PrimaryPart.RootAttachment; rc.Parent = character
            end
            local ok2, AM = pcall(load, "AnimationManager")
            if ok2 and AM then
                local track = character.Humanoid.Animator:LoadAnimation(AM.get_track("PlayerRidingPet"))
                track.Looped = true; track:Play()
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

    pcall(function() UIManager.apps.PlayerNameApp:add_npc_id(character, partnerName) end)

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
        name = partnerName, userId = partnerId,
        folder = folder, character = character,
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
    stopFollow(entry)
    stopEmote(entry)
    fakePlayerIds[entry.userId] = nil
    if _G.fakePlayerIds then _G.fakePlayerIds[entry.userId] = nil end
    if entry.folder and entry.folder.Parent then entry.folder:Destroy() end
    FakePlayerByName[entry.name] = nil
    FakePlayerById[entry.userId] = nil
    for i, f in ipairs(FakePlayers) do if f == entry.folder then table.remove(FakePlayers, i); break end end
    hint("Removed: " .. entry.name, 2)
    return true
end

local function deleteAllFakePlayers()
    for _, entry in pairs(FakePlayerByName) do
        stopFollow(entry); stopEmote(entry)
        if entry.folder and entry.folder.Parent then entry.folder:Destroy() end
    end
    FakePlayers = {}; FakePlayerByName = {}; FakePlayerById = {}
    fakePlayerIds = {}; _G.fakePlayerIds = {}
    hint("All fake players removed.", 3)
end

-- =====================================================================
-- PUBLIC API
-- =====================================================================
_G.FakePlayerSpawner = {
    spawn = spawnFakePlayer,
    remove = removeFakePlayer,
    removeAll = deleteAllFakePlayers,

    chat = function(name, message, duration)
        local e = FakePlayerByName[name]
        if not e then return end
        showChatBubble(e, message, duration)
        addToChatLog(name, message)
    end,

    emote       = function(name, animId, looped) local e = FakePlayerByName[name]; if e then return playEmote(e, animId, looped) end end,
    stopEmote   = function(name) local e = FakePlayerByName[name]; if e then stopEmote(e) end end,
    walkTo      = function(name, pos) local e = FakePlayerByName[name]; if e then movePlayerTo(e, pos) end end,
    walkOffset  = function(name, off)
        local e = FakePlayerByName[name]; if not e or not e.character then return end
        local hrp = e.character:FindFirstChild("HumanoidRootPart")
        if hrp then movePlayerTo(e, hrp.Position + (off or Vector3.new(0,0,-10))) end
    end,
    follow      = function(name) local e = FakePlayerByName[name]; if e then startFollow(e) end end,
    stopFollow  = function(name) local e = FakePlayerByName[name]; if e then stopFollow(e) end end,
    lookAtMe    = function(name) local e = FakePlayerByName[name]; if e then lookAtPlayer(e) end end,
    list        = function() local n = {}; for k in pairs(FakePlayerByName) do table.insert(n, k) end; return n end,
}

-- =====================================================================
-- UI (draggable + minimize)
-- =====================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakePlayerControl"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 270, 0, 500)
main.Position = UDim2.new(0, 30, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
main.BorderSizePixel = 0
main.Active = true
main.Parent = screenGui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(108, 75, 171)
mainStroke.Thickness = 1.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = main

-- Top bar (drag handle)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 28)
topBar.BackgroundColor3 = Color3.fromRGB(40, 32, 60)
topBar.BackgroundTransparency = 0.3
topBar.BorderSizePixel = 0
topBar.Parent = main
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎭 Fake Player Control"
title.Font = Enum.Font.FredokaOne
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(240, 230, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 24, 0, 20)
minimizeBtn.Position = UDim2.new(1, -28, 0, 4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
minimizeBtn.Text = "—"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Parent = topBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 4)
local minStroke = Instance.new("UIStroke"); minStroke.Color = Color3.fromRGB(140, 100, 200); minStroke.Thickness = 1; minStroke.Parent = minimizeBtn

-- Content container
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, 0, 1, -32)
content.Position = UDim2.new(0, 0, 0, 32)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = Color3.fromRGB(108, 75, 171)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = content
local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 8)
pad.PaddingLeft = UDim.new(0, 10)
pad.PaddingRight = UDim.new(0, 10)
pad.PaddingBottom = UDim.new(0, 12)
pad.Parent = content

-- Drag from entire main frame
local dragging, dragStart, startPos
local function beginDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end
main.InputBegan:Connect(function(input)
    -- Only drag from topBar or if not on a button
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local mx, my = input.Position.X, input.Position.Y
        local ap = topBar.AbsolutePosition
        local as = topBar.AbsoluteSize
        if mx >= ap.X and mx <= ap.X + as.X and my >= ap.Y and my <= ap.Y + as.Y then
            beginDrag(input)
        end
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

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.new(0, 270, 0, 32) or UDim2.new(0, 270, 0, 500)
    minimizeBtn.Text = minimized and "+" or "—"
end)

-- =====================================================================
-- UI HELPERS
-- =====================================================================
local function sectionLabel(text, order)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 16)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.FredokaOne
    l.TextSize = 11
    l.TextColor3 = Color3.fromRGB(200, 180, 240)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.LayoutOrder = order
    l.Parent = content
    return l
end

local function makeBox(placeholder, default, order)
    local b = Instance.new("TextBox")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    b.Text = default or ""
    b.PlaceholderText = placeholder or ""
    b.PlaceholderColor3 = Color3.fromRGB(110, 110, 130)
    b.Font = Enum.Font.SourceSans
    b.TextSize = 12
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.ClearTextOnFocus = false
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.LayoutOrder = order
    b.Parent = content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0, 6); p.PaddingRight = UDim.new(0, 6); p.Parent = b
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(80, 80, 100); s.Thickness = 1; s.Parent = b
    return b
end

local function makeBtn(text, order, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = color or Color3.fromRGB(40, 40, 55)
    b.Text = text
    b.Font = Enum.Font.FredokaOne
    b.TextSize = 11
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.LayoutOrder = order
    b.Parent = content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(108, 75, 171); s.Thickness = 1.5; s.Transparency = 0.3; s.Parent = b
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(
            math.min(b.BackgroundColor3.R * 255 + 20, 255) / 255,
            math.min(b.BackgroundColor3.G * 255 + 20, 255) / 255,
            math.min(b.BackgroundColor3.B * 255 + 25, 255) / 255
        ) }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = color or Color3.fromRGB(40, 40, 55) }):Play()
    end)
    return b
end

-- =====================================================================
-- SPAWN SECTION
-- =====================================================================
sectionLabel("▸ Spawn", 1)
local usernameBox = makeBox("Username (blank = preset)", "", 2)
local userIdBox   = makeBox("User ID (optional)", "", 3)
local spawnBtn    = makeBtn("Spawn Fake Player", 4)
local deleteAllBtn= makeBtn("🗑 Delete All Fake Players", 5, Color3.fromRGB(70, 30, 30))

-- =====================================================================
-- TARGET SECTION
-- =====================================================================
sectionLabel("▸ Target Player", 6)
local targetBtn = makeBtn("Target: (none)", 7)
local targetList = Instance.new("ScrollingFrame")
targetList.Size = UDim2.new(1, 0, 0, 90)
targetList.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
targetList.BorderSizePixel = 0
targetList.ScrollBarThickness = 3
targetList.ScrollBarImageColor3 = Color3.fromRGB(108, 75, 171)
targetList.CanvasSize = UDim2.new(0, 0, 0, 0)
targetList.AutomaticCanvasSize = Enum.AutomaticSize.Y
targetList.Visible = false
targetList.LayoutOrder = 8
targetList.Parent = content
Instance.new("UICorner", targetList).CornerRadius = UDim.new(0, 4)
local tlLayout = Instance.new("UIListLayout"); tlLayout.SortOrder = Enum.SortOrder.LayoutOrder; tlLayout.Padding = UDim.new(0, 2); tlLayout.Parent = targetList
local tlPad = Instance.new("UIPadding"); tlPad.PaddingTop = UDim.new(0, 4); tlPad.PaddingLeft = UDim.new(0, 4); tlPad.PaddingRight = UDim.new(0, 4); tlPad.PaddingBottom = UDim.new(0, 4); tlPad.Parent = targetList

local selectedName = nil

local function rebuildTargetList()
    for _, c in ipairs(targetList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local i = 0
    for name in pairs(FakePlayerByName) do
        i = i + 1
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -4, 0, 22)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        b.Text = "  " .. name
        b.Font = Enum.Font.SourceSans
        b.TextSize = 11
        b.TextColor3 = Color3.fromRGB(220, 220, 235)
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.LayoutOrder = i
        b.Parent = targetList
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
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

-- =====================================================================
-- CHAT SECTION
-- =====================================================================
sectionLabel("▸ Fake Chat (Adopt Me style)", 9)
local chatBox = makeBox("Type a message...", "", 10)
local chatBtn = makeBtn("💬 Send Chat Bubble", 11)

-- =====================================================================
-- EMOTE SECTION
-- =====================================================================
sectionLabel("▸ Emotes (R15 working)", 12)
local emoteBtn = makeBtn("Emote: Wave  ▾", 13)
local emoteList = Instance.new("ScrollingFrame")
emoteList.Size = UDim2.new(1, 0, 0, 160)
emoteList.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
emoteList.BorderSizePixel = 0
emoteList.ScrollBarThickness = 3
emoteList.ScrollBarImageColor3 = Color3.fromRGB(108, 75, 171)
emoteList.CanvasSize = UDim2.new(0, 0, 0, 0)
emoteList.AutomaticCanvasSize = Enum.AutomaticSize.Y
emoteList.Visible = false
emoteList.LayoutOrder = 14
emoteList.Parent = content
Instance.new("UICorner", emoteList).CornerRadius = UDim.new(0, 4)
local elLayout = Instance.new("UIListLayout"); elLayout.SortOrder = Enum.SortOrder.LayoutOrder; elLayout.Padding = UDim.new(0, 2); elLayout.Parent = emoteList
local elPad = Instance.new("UIPadding"); elPad.PaddingTop = UDim.new(0, 4); elPad.PaddingLeft = UDim.new(0, 4); elPad.PaddingRight = UDim.new(0, 4); elPad.PaddingBottom = UDim.new(0, 4); elPad.Parent = emoteList

local selectedEmote = EMOTES[1]

for i, e in ipairs(EMOTES) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, 22)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    b.Text = "  " .. e.name
    b.Font = Enum.Font.SourceSans
    b.TextSize = 11
    b.TextColor3 = Color3.fromRGB(220, 220, 235)
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.LayoutOrder = i
    b.Parent = emoteList
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(60, 55, 85) }):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(40, 40, 55) }):Play() end)
    b.MouseButton1Click:Connect(function()
        selectedEmote = e
        emoteBtn.Text = "Emote: " .. e.name .. "  ▾"
        emoteList.Visible = false
    end)
end

emoteBtn.MouseButton1Click:Connect(function()
    emoteList.Visible = not emoteList.Visible
end)

local loopToggle = Instance.new("TextButton")
loopToggle.Size = UDim2.new(1, 0, 0, 24)
loopToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
loopToggle.Text = "Loop Emote: OFF"
loopToggle.Font = Enum.Font.FredokaOne
loopToggle.TextSize = 10
loopToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
loopToggle.LayoutOrder = 15
loopToggle.Parent = content
Instance.new("UICorner", loopToggle).CornerRadius = UDim.new(0, 4)
local lStroke = Instance.new("UIStroke"); lStroke.Color = Color3.fromRGB(108, 75, 171); lStroke.Thickness = 1.5; lStroke.Transparency = 0.3; lStroke.Parent = loopToggle
local looped = false
loopToggle.MouseButton1Click:Connect(function()
    looped = not looped
    loopToggle.Text = "Loop Emote: " .. (looped and "ON" or "OFF")
    loopToggle.BackgroundColor3 = looped and Color3.fromRGB(55, 45, 75) or Color3.fromRGB(40, 40, 55)
end)

local emoteRow = Instance.new("Frame")
emoteRow.Size = UDim2.new(1, 0, 0, 26)
emoteRow.BackgroundTransparency = 1
emoteRow.LayoutOrder = 16
emoteRow.Parent = content
local elRowLayout = Instance.new("UIListLayout"); elRowLayout.FillDirection = Enum.FillDirection.Horizontal; elRowLayout.Padding = UDim.new(0, 4); elRowLayout.SortOrder = Enum.SortOrder.LayoutOrder; elRowLayout.Parent = emoteRow

local function makeHalfBtn(text, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.5, -2, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    b.Text = text
    b.Font = Enum.Font.FredokaOne
    b.TextSize = 10
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.LayoutOrder = order
    b.Parent = emoteRow
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(108, 75, 171); s.Thickness = 1.5; s.Transparency = 0.3; s.Parent = b
    return b
end
local playEmoteBtn = makeHalfBtn("▶ Play", 1)
local stopEmoteBtn = makeHalfBtn("⏹ Stop", 2)

-- =====================================================================
-- MOVEMENT SECTION
-- =====================================================================
sectionLabel("▸ Movement", 17)
local walkFwdBtn = makeBtn("🚶 Walk to Me", 18)
local walkRandBtn = makeBtn("🎲 Walk Random", 19)
local followBtn = makeBtn("👣 Follow Me: OFF", 20)
local stopFollowBtn = makeBtn("⏹ Stop Follow", 21)
local lookAtBtn = makeBtn("👁 Look at Me", 22)

-- =====================================================================
-- QUICK ACTIONS
-- =====================================================================
sectionLabel("▸ Quick Actions", 23)
local quickRow = Instance.new("Frame")
quickRow.Size = UDim2.new(1, 0, 0, 26)
quickRow.BackgroundTransparency = 1
quickRow.LayoutOrder = 24
quickRow.Parent = content
local qrLayout = Instance.new("UIListLayout"); qrLayout.FillDirection = Enum.FillDirection.Horizontal; qrLayout.Padding = UDim.new(0, 4); qrLayout.SortOrder = Enum.SortOrder.LayoutOrder; qrLayout.Parent = quickRow

local function makeQuickBtn(text, order, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.33, -3, 1, 0)
    b.BackgroundColor3 = color or Color3.fromRGB(40, 40, 55)
    b.Text = text
    b.Font = Enum.Font.FredokaOne
    b.TextSize = 9
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.LayoutOrder = order
    b.Parent = quickRow
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(108, 75, 171); s.Thickness = 1.5; s.Transparency = 0.3; s.Parent = b
    return b
end
local waveBtn = makeQuickBtn("👋 Wave", 1)
local danceBtn = makeQuickBtn("💃 Dance", 2)
local sitBtn = makeQuickBtn("🪑 Sit", 3)

-- =====================================================================
-- HANDLERS
-- =====================================================================
local PRESET_USERS = {
    'Agusmareborn', 'Kellyvault', 'J3llynoah', 'Rainbowriley321', 'Bobazmalibu',
    'H3llSANG3LX', 'Xcallmeholly', 'Niniko_201999', 'Hugso09', 'ruthjavxn',
    'bwpico', 'Hugeinvestor', 'Barborich2', 'Underthechemtrailss', 'Bunzvii',
    'Sparklingorangelol', 'Tr3ndzyy', 'Jellycmt', 'Ex4clusiv3', 'Killersana66',
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
    addToChatLog(selectedName, chatBox.Text)
    chatBox.Text = ""
end)

playEmoteBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry then hint("Player no longer exists.", 3); return end
    local ok = playEmote(entry, selectedEmote.id, looped)
    if ok then hint("Playing: " .. selectedEmote.name, 2) end
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
        movePlayerTo(entry, (lhrp.CFrame * CFrame.new(0, 0, -5)).Position)
    end
end)

walkRandBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry or not entry.character then return end
    local hrp = entry.character:FindFirstChild("HumanoidRootPart")
    if hrp then
        movePlayerTo(entry, hrp.Position + Vector3.new(math.random(-15, 15), 0, math.random(-15, 15)))
    end
end)

followBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry then return end
    if followThreads[entry.userId] then
        stopFollow(entry)
        followBtn.Text = "👣 Follow Me: OFF"
        followBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    else
        startFollow(entry)
        followBtn.Text = "👣 Follow Me: ON"
        followBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 60)
    end
end)

stopFollowBtn.MouseButton1Click:Connect(function()
    if not selectedName then return end
    local entry = FakePlayerByName[selectedName]
    if entry then
        stopFollow(entry)
        followBtn.Text = "👣 Follow Me: OFF"
        followBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end
end)

lookAtBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if entry then lookAtPlayer(entry) end
end)

waveBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if entry then
        playEmote(entry, 507770239, false)
        showChatBubble(entry, "Hey there!", 3)
        addToChatLog(selectedName, "Hey there!")
    end
end)

danceBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if entry then playEmote(entry, 507771019, true) end
end)

sitBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if entry then playEmote(entry, 2506281703, true) end
end)

-- =====================================================================
hint("Fake Player Control v2 loaded.", 3)