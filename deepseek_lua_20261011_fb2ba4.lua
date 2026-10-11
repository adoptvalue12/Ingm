-- =====================================================================
-- FAKE PLAYER v4 — Small bubble + real drag + working triggers + torso stick
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
local TableUtil   = load("TableUtil")
local KindDB      = load("KindDB")
local HintApp     = UIManager.apps.HintApp

local hint = function(t, l) if HintApp then HintApp:hint({ text = t, length = l or 3, overridable = true }) end end

local FakePlayerByName = {}
local FakePlayerById   = {}
local fakePlayerIds    = {}
_G.fakePlayerIds = fakePlayerIds

-- =====================================================================
-- SMALL CHAT BUBBLE (like Roblox's, ~80x30)
-- =====================================================================
local function showChatBubble(entry, message, duration)
    duration = duration or 4
    local char = entry.character
    if not char or not char.Parent then return end
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return end
    local existing = head:FindFirstChild("FakeChatBubble")
    if existing then existing:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FakeChatBubble"
    bb.Size = UDim2.new(0, 90, 0, 30)
    bb.StudsOffsetWorldSpace = Vector3.new(0, 2.6, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false
    bb.Adornee = head
    bb.Parent = head

    local bubble = Instance.new("Frame")
    bubble.Size = UDim2.new(1, 0, 1, -8)
    bubble.Position = UDim2.new(0, 0, 0, 0)
    bubble.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bubble.BorderSizePixel = 0
    bubble.Parent = bb
    Instance.new("UICorner", bubble).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 80)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = bubble

    local tail = Instance.new("Frame")
    tail.Size = UDim2.new(0, 10, 0, 10)
    tail.Position = UDim2.new(0.5, -5, 1, -5)
    tail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tail.BorderSizePixel = 0
    tail.Rotation = 45
    tail.ZIndex = 0
    tail.Parent = bubble

    local tailStroke = Instance.new("UIStroke")
    tailStroke.Color = Color3.fromRGB(80, 80, 80)
    tailStroke.Thickness = 1
    tailStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    tailStroke.Parent = tail

    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -8, 1, -4)
    msg.Position = UDim2.new(0, 4, 0, 2)
    msg.BackgroundTransparency = 1
    msg.Font = Enum.Font.SourceSansBold
    msg.TextSize = 12
    msg.TextColor3 = Color3.fromRGB(10, 10, 10)
    msg.Text = message
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Center
    msg.TextYAlignment = Enum.TextYAlignment.Center
    msg.ZIndex = 2
    msg.Parent = bubble

    local baseSize = bb.Size
    bb.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(bb, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = baseSize
    }):Play()

    task.delay(duration, function()
        if bb.Parent then
            local t = TweenService:Create(bb, TweenInfo.new(0.12), { Size = UDim2.new(0, 0, 0, 0) })
            t:Play()
            t.Completed:Connect(function() if bb.Parent then bb:Destroy() end end)
        end
    end)
end

-- =====================================================================
-- EMOTES
-- =====================================================================
local EMOTES = {
    { name = "Wave",     id = 507770239  },
    { name = "Point",    id = 507770453  },
    { name = "Dance 1",  id = 507771019  },
    { name = "Dance 2",  id = 507776043  },
    { name = "Dance 3",  id = 507777826  },
    { name = "Cheer",    id = 507770677  },
    { name = "Laugh",    id = 507770818  },
    { name = "Shrug",    id = 507770971  },
    { name = "Sit",      id = 2506281703 },
    { name = "Lay Down", id = 2825746228 },
    { name = "Kick",     id = 3360693088 },
}

-- =====================================================================
-- TORSO ATTACH + PAINT SPLASH
-- =====================================================================
local function attachToTorso(entry)
    local myChar = Players.LocalPlayer.Character
    if not myChar then return end
    local myTorso = myChar:FindFirstChild("UpperTorso") or myChar:FindFirstChild("Torso")
    local theirChar = entry.character
    if not theirChar then return end
    local theirHrp = theirChar:FindFirstChild("HumanoidRootPart")
    if not myTorso or not theirHrp then return end

    -- Cleanup old
    if entry.torsoWeld then entry.torsoWeld:Destroy() end

    -- Stop their movement so weld wins
    local hum = theirChar:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = theirHrp
    weld.Part1 = myTorso
    weld.Parent = theirHrp
    entry.torsoWeld = weld
end

local function detachFromTorso(entry, withPaint)
    if entry.torsoWeld then
        entry.torsoWeld:Destroy()
        entry.torsoWeld = nil
    end
    if entry.character then
        local hum = entry.character:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end
    if withPaint then
        -- White paint splash
        local char = entry.character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pe = Instance.new("ParticleEmitter")
                pe.Texture = "rbxassetid://243660364"
                pe.Color = ColorSequence.new(Color3.new(1, 1, 1))
                pe.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0),
                })
                pe.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.7, 0.2),
                    NumberSequenceKeypoint.new(1, 1),
                })
                pe.Lifetime = NumberRange.new(0.8, 1.4)
                pe.Speed = NumberRange.new(12, 22)
                pe.SpreadAngle = Vector2.new(180, 180)
                pe.Rate = 0
                pe.Parent = hrp
                pe:Emit(60)
                task.delay(2.5, function() if pe.Parent then pe:Destroy() end end)

                -- Extra white blobs
                for _ = 1, 10 do
                    local ball = Instance.new("Part")
                    ball.Shape = Enum.PartType.Ball
                    ball.Size = Vector3.new(0.4, 0.4, 0.4)
                    ball.Material = Enum.Material.SmoothPlastic
                    ball.Color = Color3.new(1, 1, 1)
                    ball.Anchored = true
                    ball.CanCollide = false
                    ball.CanTouch = false
                    ball.CanQuery = false
                    ball.CFrame = hrp.CFrame * CFrame.new(math.random(-10, 10)/10, math.random(0, 5)/10, math.random(-10, 10)/10)
                    ball.Parent = workspace
                    local target = ball.CFrame * CFrame.new(math.random(-4, 4), math.random(0, 3), math.random(-4, 4))
                    TweenService:Create(ball, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CFrame = target }):Play()
                    TweenService:Create(ball, TweenInfo.new(0.9), { Transparency = 1, Size = Vector3.new(0.05, 0.05, 0.05) }):Play()
                    task.delay(1.1, function() if ball.Parent then ball:Destroy() end end)
                end
            end
        end
    end
end

-- =====================================================================
-- PLAY EMOTE (optional attach)
-- =====================================================================
local function playEmote(entry, animId, looped, attach)
    local char = entry.character
    if not char or not char.Parent then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then animator = Instance.new("Animator"); animator.Parent = hum end
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
    entry.attachedToMe = attach and true or false
    if attach then attachToTorso(entry) end
    if not looped then
        track.Stopped:Connect(function()
            if entry.emoteTrack == track then
                entry.emoteTrack = nil
                if entry.attachedToMe then
                    detachFromTorso(entry, true)
                    entry.attachedToMe = false
                end
            end
        end)
    end
    return true
end

local function stopEmote(entry)
    if entry.emoteTrack then
        pcall(function() entry.emoteTrack:Stop(0.2) end)
        entry.emoteTrack = nil
    end
    if entry.attachedToMe then
        detachFromTorso(entry, true)
        entry.attachedToMe = false
    end
end

-- =====================================================================
-- FOLLOW + MOVE
-- =====================================================================
local followThreads = {}
local function stopFollow(entry)
    if followThreads[entry.userId] then task.cancel(followThreads[entry.userId]); followThreads[entry.userId] = nil end
end
local function startFollow(entry)
    stopFollow(entry)
    followThreads[entry.userId] = task.spawn(function()
        while entry.character and entry.character.Parent do
            if not entry.attachedToMe then
                local myChar = Players.LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local hrp = entry.character:FindFirstChild("HumanoidRootPart")
                local hum = entry.character:FindFirstChildOfClass("Humanoid")
                if myHrp and hrp and hum and not entry.torsoWeld then
                    if (myHrp.Position - hrp.Position).Magnitude > 6 then hum:MoveTo(myHrp.Position) end
                end
            end
            task.wait(0.25)
        end
    end)
end
local function movePlayerTo(entry, pos)
    if not entry.character or entry.attachedToMe then return end
    local hum = entry.character:FindFirstChildOfClass("Humanoid")
    if hum then hum:MoveTo(pos) end
end
local function lookAtPlayer(entry)
    if not entry.character or entry.attachedToMe then return end
    local myChar = Players.LocalPlayer.Character
    if not myChar then return end
    local hrp = entry.character:FindFirstChild("HumanoidRootPart")
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if hrp and myHrp then
        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(myHrp.Position.X, hrp.Position.Y, myHrp.Position.Z))
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

-- =====================================================================
-- MOCK TRADE SYSTEM (with inventory transfer + partner auto mirror)
-- =====================================================================
local TradeApp  = UIManager.apps.TradeApp
local DialogApp = UIManager.apps.DialogApp

local CONFIG = {
    PARTNER_NAME = "Player123", PARTNER_USER_ID = 0,
    AUTO_ACCEPT_DELAY = 1.2, AUTO_CONFIRM_DELAY = 1.2,
    SPECTATOR_COUNT = 3, NEGOTIATION_LOCK = 3, CONFIRMATION_LOCK_PER_ITEM = 2,
}
local mockState = {
    active = false, trade = nil, tradeCompleting = false,
    partnerActionPending = false, originalFunctions = {}, scamWarningShown = true,
}
local mockPartner
local function createMockPartner()
    mockPartner = setmetatable({
        Name = CONFIG.PARTNER_NAME, DisplayName = CONFIG.PARTNER_NAME,
        UserId = CONFIG.PARTNER_USER_ID, ClassName = "Player", AccountAge = 365,
        MembershipType = Enum.MembershipType.None,
        CharacterAdded = Instance.new("BindableEvent"),
        CharacterRemoving = Instance.new("BindableEvent"),
    }, {
        __index = function(t, k)
            if k == "Parent" then return Players end
            if k == "IsA" then return function(_, c) return c == "Player" or c == "Instance" end end
            if k == "GetAttribute" then return function() return nil end end
            if k == "FindFirstChild" then return function() return nil end end
            if k == "WaitForChild" then return function() return nil end end
            return rawget(t, k)
        end,
        __tostring = function() return CONFIG.PARTNER_NAME end,
    })
    return mockPartner
end
createMockPartner()

local function createMockTrade()
    return {
        trade_id = "MOCK_" .. tick(),
        sender = Players.LocalPlayer, recipient = mockPartner,
        sender_offer = { items = {}, player_name = Players.LocalPlayer.Name, negotiated = false, confirmed = false },
        recipient_offer = { items = {}, player_name = CONFIG.PARTNER_NAME, negotiated = false, confirmed = false },
        current_stage = "negotiation", offer_version = 1,
        sender_has_trade_license = true, recipient_has_trade_license = true,
        busy_indicators = {}, subscriber_count = CONFIG.SPECTATOR_COUNT,
    }
end

local function storeOriginals()
    local names = { "_get_local_trade_state", "_overwrite_local_trade_state", "_change_local_trade_state",
        "_get_my_offer", "_get_partner_offer", "_get_my_player", "_get_partner", "_get_current_trade_stage",
        "_lock_trade_for_appropriate_time", "_get_lock_time", "refresh_all",
        "_on_accept_pressed", "_on_confirm_pressed", "_decline_trade", "_render_message_in_trade_chat" }
    for _, n in ipairs(names) do if TradeApp[n] then mockState.originalFunctions[n] = TradeApp[n] end end
end
storeOriginals()

local function completeTrade()
    if mockState.tradeCompleting then return end
    mockState.tradeCompleting = true
    local received = {}
    local sent = {}
    if mockState.trade then
        for _, item in ipairs(mockState.trade.recipient_offer.items) do
            table.insert(received, { kind = item.kind, properties = table.clone(item.properties or {}) })
        end
        for _, item in ipairs(mockState.trade.sender_offer.items) do
            if item.unique then table.insert(sent, item.unique) end
        end
    end
    task.spawn(function()
        pcall(setthreadidentity, 2)
        local inv = ClientData.get("inventory")
        pcall(setthreadidentity, 8)
        if inv and inv.pets then
            for _, uid in ipairs(sent) do inv.pets[uid] = nil end
        end
        for _, item in ipairs(received) do
            local kindKey = item.kind
            if kindKey then
                local kd = KindDB[kindKey]
                local shortKind = (kd and kd.kind) or kindKey
                local props = item.properties or {}
                if props.xp == nil then props.xp = 0 end
                if props.rp_name == nil then props.rp_name = "" end
                local uid = HttpService:GenerateGUID(false)
                local itemData = {
                    unique = uid, category = "pets", id = kindKey, kind = shortKind,
                    newness_order = math.huge, properties = props,
                }
                pcall(setthreadidentity, 2)
                local inv2 = ClientData.get("inventory")
                if inv2 and inv2.pets then inv2.pets[uid] = itemData end
                pcall(setthreadidentity, 8)
            end
        end
        pcall(function() UIManager.apps.BackpackApp:refresh_rendered_items() end)
    end)
    mockState.active = false; mockState.trade = nil; mockState.tradeCompleting = false
    mockState.partnerActionPending = false
    UIManager.set_app_visibility("TradeApp", false)
    if HintApp then HintApp:hint({ text = "The trade was successful!", length = 4, overridable = true }) end
end

-- Partner mirrors our accept/confirm
local function partnerAutoAction()
    if not mockState.active or not mockState.trade or mockState.partnerActionPending then return end
    mockState.partnerActionPending = true
    if mockState.trade.current_stage == "negotiation" then
        task.wait(CONFIG.AUTO_ACCEPT_DELAY)
        if mockState.active and mockState.trade then
            mockState.trade.recipient_offer.negotiated = true
            if mockState.trade.sender_offer.negotiated then
                mockState.trade.current_stage = "confirmation"
            end
            mockState.trade.offer_version = mockState.trade.offer_version + 1
            TradeApp:_overwrite_local_trade_state(mockState.trade)
            pcall(function() TradeApp:_lock_trade_for_appropriate_time() end)
        end
    elseif mockState.trade.current_stage == "confirmation" then
        task.wait(CONFIG.AUTO_CONFIRM_DELAY)
        if mockState.active and mockState.trade then
            mockState.trade.recipient_offer.confirmed = true
            mockState.trade.offer_version = mockState.trade.offer_version + 1
            TradeApp:_overwrite_local_trade_state(mockState.trade)
            if mockState.trade.sender_offer.confirmed then
                task.wait(2)
                completeTrade()
            end
        end
    end
    mockState.partnerActionPending = false
end

local function hookTradeFunctions()
    TradeApp._get_local_trade_state = function(self)
        if mockState.active and mockState.trade then return TableUtil.deep_copy(mockState.trade) end
        return mockState.originalFunctions._get_local_trade_state(self)
    end
    TradeApp._overwrite_local_trade_state = function(self, newState)
        if mockState.active then
            if newState then
                mockState.trade = newState; self.local_trade_state = newState
                if mockState.trade then mockState.trade.subscriber_count = CONFIG.SPECTATOR_COUNT end
                if self._on_local_trade_state_changed then pcall(function() self:_on_local_trade_state_changed(newState, newState) end) end
                if self.refresh_all then pcall(function() self:refresh_all() end) end
            else
                mockState.trade = nil; mockState.active = false; self.local_trade_state = nil
            end
        else return mockState.originalFunctions._overwrite_local_trade_state(self, newState) end
    end
    TradeApp._change_local_trade_state = function(self, changes)
        if mockState.active then
            local function merge(t, s) for k, v in pairs(s) do if type(v) == "table" and t[k] and type(t[k]) == "table" then merge(t[k], v) else t[k] = v end end return t end
            self:_overwrite_local_trade_state(merge(self:_get_local_trade_state(), changes))
        else return mockState.originalFunctions._change_local_trade_state(self, changes) end
    end
    TradeApp._get_my_offer = function(self)
        local state = self:_get_local_trade_state()
        if mockState.active and state then
            if Players.LocalPlayer == state.sender then return state.sender_offer, "sender_offer" else return state.recipient_offer, "recipient_offer" end
        end
        return mockState.originalFunctions._get_my_offer(self)
    end
    TradeApp._get_partner_offer = function(self)
        local state = self:_get_local_trade_state()
        if mockState.active and state then
            if Players.LocalPlayer == state.sender then return state.recipient_offer, "recipient_offer" else return state.sender_offer, "sender_offer" end
        end
        return mockState.originalFunctions._get_partner_offer(self)
    end
    TradeApp._get_my_player = function(self)
        if mockState.active then return Players.LocalPlayer end
        return mockState.originalFunctions._get_my_player(self)
    end
    TradeApp._get_partner = function(self)
        if mockState.active and mockState.trade then return mockState.trade.recipient end
        return mockState.originalFunctions._get_partner(self)
    end
    TradeApp._get_current_trade_stage = function(self)
        if mockState.active and mockState.trade then return mockState.trade.current_stage end
        return mockState.originalFunctions._get_current_trade_stage(self)
    end
    TradeApp._get_lock_time = function(self)
        if mockState.active and mockState.trade then
            if self:_get_current_trade_stage() == "negotiation" then return CONFIG.NEGOTIATION_LOCK
            else return math.clamp(CONFIG.CONFIRMATION_LOCK_PER_ITEM * (#mockState.trade.sender_offer.items + #mockState.trade.recipient_offer.items), 3, 15) end
        end
        return mockState.originalFunctions._get_lock_time(self)
    end
    TradeApp._lock_trade_for_appropriate_time = function(self)
        if mockState.active then pcall(function()
            if self.lock_countdown then self.lock_countdown:stop(); self.lock_countdown:set_duration(self:_get_lock_time()); self.lock_countdown:start() end
        end)
        else return mockState.originalFunctions._lock_trade_for_appropriate_time(self) end
    end
    -- MIRROR ACCEPT
    TradeApp._on_accept_pressed = function(self)
        if mockState.active and mockState.trade then
            if mockState.trade.sender_offer.negotiated then
                mockState.trade.sender_offer.negotiated = false
            else
                mockState.trade.sender_offer.negotiated = true
                if mockState.trade.recipient_offer.negotiated then
                    mockState.trade.current_stage = "confirmation"
                end
            end
            mockState.trade.offer_version = mockState.trade.offer_version + 1
            self:_overwrite_local_trade_state(mockState.trade)
            pcall(function() self:_lock_trade_for_appropriate_time() end)
            if not mockState.trade.recipient_offer.negotiated or mockState.trade.current_stage == "confirmation" then
                task.spawn(partnerAutoAction)
            end
        else return mockState.originalFunctions._on_accept_pressed(self) end
    end
    -- MIRROR CONFIRM
    TradeApp._on_confirm_pressed = function(self)
        if mockState.active and mockState.trade then
            mockState.trade.sender_offer.confirmed = true
            mockState.trade.offer_version = mockState.trade.offer_version + 1
            self:_overwrite_local_trade_state(mockState.trade)
            if not mockState.trade.recipient_offer.confirmed then task.spawn(partnerAutoAction) end
        else return mockState.originalFunctions._on_confirm_pressed(self) end
    end
    TradeApp._decline_trade = function(self, silent)
        if mockState.active then
            mockState.active = false; mockState.trade = nil
            mockState.tradeCompleting = false; mockState.partnerActionPending = false
            self:_overwrite_local_trade_state(nil)
            UIManager.set_app_visibility("TradeApp", false)
        else return mockState.originalFunctions._decline_trade(self, silent) end
    end
end
hookTradeFunctions()

local function startMockTradeWith(partnerName, partnerUserId)
    if mockState.active then return false end
    if not TradeApp then hint("TradeApp not available.", 3); return false end
    CONFIG.PARTNER_NAME = partnerName
    CONFIG.PARTNER_USER_ID = partnerUserId or math.random(100000000, 999999999)
    createMockPartner()
    mockState.active = false; mockState.trade = nil; mockState.tradeCompleting = false
    mockState.partnerActionPending = false; mockState.scamWarningShown = true
    mockState.trade = createMockTrade()
    mockState.active = true
    pcall(function() UIManager.set_app_visibility("TradeApp", false) end)
    task.wait(0.05)
    pcall(function() TradeApp:_overwrite_local_trade_state(mockState.trade) end)
    pcall(function() UIManager.set_app_visibility("TradeApp", true) end)
    task.wait(0.05)
    pcall(function() if TradeApp.refresh_all then TradeApp:refresh_all() end end)
    return true
end

local function addPetToPartnerOffer(petName, flags)
    if not mockState.active or not mockState.trade then return false end
    if #mockState.trade.recipient_offer.items >= 18 then return false end
    if not flags then
        local roll = math.random(1, 10)
        if roll <= 2 then flags = { F=false, R=false, N=false, M=false }
        elseif roll <= 4 then flags = { F=true, R=false, N=false, M=false }
        elseif roll <= 6 then flags = { F=true, R=true, N=false, M=false }
        elseif roll <= 8 then flags = { F=true, R=true, N=true, M=false }
        else flags = { F=true, R=true, N=false, M=true } end
    end
    for catName, catTable in pairs(InventoryDB) do
        if catName == "pets" then
            for id, item in pairs(catTable) do
                if item.name == petName then
                    table.insert(mockState.trade.recipient_offer.items, {
                        category = "pets", kind = id,
                        unique = HttpService:GenerateGUID(),
                        properties = { flyable = flags.F, rideable = flags.R, neon = flags.N, mega_neon = flags.M, age = 6, xp = 0, rp_name = "" }
                    })
                    mockState.trade.sender_offer.negotiated = false
                    mockState.trade.recipient_offer.negotiated = false
                    mockState.trade.offer_version = mockState.trade.offer_version + 1
                    TradeApp:_overwrite_local_trade_state(mockState.trade)
                    pcall(function() TradeApp:_lock_trade_for_appropriate_time() end)
                    return true
                end
            end
        end
    end
    return false
end

-- Send a chat message that shows in trade chat
local function sendFakeChat(entry, message, duration)
    showChatBubble(entry, message, duration or 4)
    -- Show in trade chat if active
    pcall(function()
        if mockState.active and TradeApp and TradeApp._render_message_in_trade_chat then
            TradeApp:_render_message_in_trade_chat(nil, CONFIG.PARTNER_NAME .. ": " .. message, true)
        end
    end)
end

-- =====================================================================
-- SPAWN / REMOVE
-- =====================================================================
local function spawnFakePlayer(partnerName, partnerId)
    if not partnerName or partnerName == "" then hint("Username required.", 3); return false end
    if FakePlayerByName[partnerName] then hint("Already spawned: " .. partnerName, 3); return false end
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
    local ok = pcall(function() character = Players:CreateHumanoidModelFromUserId(partnerId) end)
    if not ok or not character then
        folder:Destroy(); fakePlayerIds[partnerId] = nil
        hint("Failed to create character.", 4); return false
    end
    local localChar = Players.LocalPlayer.Character
    if localChar and localChar.PrimaryPart then
        character:SetPrimaryPartCFrame(localChar.HumanoidRootPart.CFrame * CFrame.new(math.random(-8, 8), 0, math.random(-8, 8)))
    end
    local hum = character:WaitForChild("Humanoid", 5)
    if hum then
        hum.DisplayDistanceType   = Enum.HumanoidDisplayDistanceType.None
        hum.HealthDisplayType     = Enum.HumanoidHealthDisplayType.AlwaysOff
        hum.HealthDisplayDistance = 0
    end
    character.Parent = folder
    for _, p in ipairs(character:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = false; p.CanTouch = false; p.CanQuery = false
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
                    { text = "Trade", on_selected = function() startMockTradeWith(partnerName, partnerId) end },
                    { text = "Give Item...", on_selected = function() end },
                    { text = "Mute",        on_selected = function() end },
                },
            })
        end)
    end
    folder:SetAttribute("IsFakePlayer", true)
    folder:SetAttribute("PartnerName", partnerName)
    folder:SetAttribute("PartnerId", partnerId)
    local entry = { name = partnerName, userId = partnerId, folder = folder, character = character, emoteTrack = nil, attachedToMe = false }
    FakePlayerByName[partnerName] = entry
    FakePlayerById[partnerId]     = entry
    hint("Spawned: " .. partnerName, 2)
    return true
end

local function removeFakePlayer(nameOrId)
    local entry = FakePlayerByName[nameOrId] or FakePlayerById[nameOrId]
    if not entry then return false end
    stopFollow(entry); stopEmote(entry); detachFromTorso(entry, false)
    fakePlayerIds[entry.userId] = nil
    if _G.fakePlayerIds then _G.fakePlayerIds[entry.userId] = nil end
    if entry.folder and entry.folder.Parent then entry.folder:Destroy() end
    FakePlayerByName[entry.name] = nil
    FakePlayerById[entry.userId] = nil
    hint("Removed: " .. entry.name, 2)
    return true
end

local function deleteAllFakePlayers()
    for _, entry in pairs(FakePlayerByName) do
        stopFollow(entry); stopEmote(entry); detachFromTorso(entry, false)
        if entry.folder and entry.folder.Parent then entry.folder:Destroy() end
    end
    FakePlayerByName = {}; FakePlayerById = {}
    fakePlayerIds = {}; _G.fakePlayerIds = {}
    hint("All fake players removed.", 3)
end

-- =====================================================================
-- HIGH TIER LIST + give pet
-- =====================================================================
local HIGH_TIER_PETS = {
    "Bat Dragon", "Shadow Dragon", "Giraffe", "Frost Dragon",
    "Owl", "Parrot", "Balloon Unicorn", "Crow",
    "African Wild Dog", "Giant Panda", "HaeTae", "Cryptid",
    "Evil Unicorn", "Blazing Lion", "Hedgehog", "Orchid Butterfly",
    "Diamond Butterfly", "Dalmatian", "Arctic Reindeer", "Mini Pig",
    "Jekyll Hydra", "Hot Doggo", "Mermicorn", "Pelican",
    "Cow", "Strawberry Shortcake Bat Dragon", "Goose",
    "Chocolate Chip Bat Dragon", "Cabbit", "Turtle",
    "Peppermint Penguin", "Monkey King", "Undead Jousting Horse",
    "Flamingo", "Kangaroo",
}

local function givePetFromFakePlayer(partnerName, partnerId, petName)
    petName = petName or HIGH_TIER_PETS[math.random(1, #HIGH_TIER_PETS)]
    if not mockState.active then
        startMockTradeWith(partnerName, partnerId)
        task.wait(0.3)
    else
        CONFIG.PARTNER_NAME = partnerName
        CONFIG.PARTNER_USER_ID = partnerId
        createMockPartner()
        mockState.trade.recipient = mockPartner
        mockState.trade.recipient_offer.player_name = partnerName
    end
    local count = math.random(1, 3)
    for i = 1, count do
        local pname = i == 1 and petName or HIGH_TIER_PETS[math.random(1, #HIGH_TIER_PETS)]
        addPetToPartnerOffer(pname)
        task.wait(0.15)
    end
    pcall(function() if TradeApp.refresh_all then TradeApp:refresh_all() end end)
    return true
end

-- =====================================================================
-- CHAT TRIGGER SYSTEM (real chat hooks)
-- =====================================================================
local lastTriggeredTarget = nil

local CHAT_TRIGGERS = {
    { pattern = "^hi$",                 responses = { "hi mommy" } },
    { pattern = "^hello$",              responses = { "hi mommy" } },
    { pattern = "^hey$",                responses = { "hi mommy" } },
    { pattern = "let loka loka",        responses = { "sure babe" } },
    { pattern = "loka loka",            responses = { "sure babe" } },
    { pattern = "dada spoil me",        responses = { "sure" }, action = "trade" },
    { pattern = "dada give me pet",     responses = { "sure" }, action = "trade" },
    { pattern = "dada give me a pet",   responses = { "sure" }, action = "trade" },
    { pattern = "dada pet",             responses = { "sure" }, action = "trade" },
}

local function matchesPattern(msg, pattern)
    if pattern:sub(1, 1) == "^" then
        return msg:match(pattern) ~= nil
    end
    return msg:find(pattern, 1, true) ~= nil
end

local function onLocalPlayerChat(message)
    if not message or message == "" then return end
    local lower = message:lower():gsub("^%s+", ""):gsub("%s+$", "")

    local responderName = lastTriggeredTarget
    if not responderName or not FakePlayerByName[responderName] then
        for name in pairs(FakePlayerByName) do responderName = name; break end
    end
    if not responderName then return end
    local entry = FakePlayerByName[responderName]
    if not entry or not entry.character or not entry.character.Parent then return end

    for _, trigger in ipairs(CHAT_TRIGGERS) do
        if matchesPattern(lower, trigger.pattern) then
            local reply = trigger.responses[math.random(1, #trigger.responses)]
            task.spawn(function()
                task.wait(0.5)
                sendFakeChat(entry, reply, 4)
                if trigger.action == "trade" then
                    task.wait(1.0)
                    local myHrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myHrp then movePlayerTo(entry, (myHrp.CFrame * CFrame.new(0, 0, -4)).Position) end
                    task.wait(1.2)
                    givePetFromFakePlayer(entry.name, entry.userId)
                end
            end)
            return
        end
    end
end

-- Hook both Chatted and TextChatService
Players.LocalPlayer.Chatted:Connect(onLocalPlayerChat)

pcall(function()
    local TCS = game:GetService("TextChatService")
    if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
        TCS.MessageReceived:Connect(function(tcm)
            pcall(function()
                if tcm.TextSource and tcm.TextSource.UserId == Players.LocalPlayer.UserId then
                    onLocalPlayerChat(tcm.Text)
                end
            end)
        end)
    end
end)

-- =====================================================================
-- PUBLIC API
-- =====================================================================
_G.FakePlayerSpawner = {
    spawn       = spawnFakePlayer,
    remove      = removeFakePlayer,
    removeAll   = deleteAllFakePlayers,
    chat        = function(name, msg, d) local e = FakePlayerByName[name]; if e then sendFakeChat(e, msg, d) end end,
    emote       = function(name, id, looped, attach) local e = FakePlayerByName[name]; if e then return playEmote(e, id, looped, attach) end end,
    stopEmote   = function(name) local e = FakePlayerByName[name]; if e then stopEmote(e) end end,
    attach      = function(name) local e = FakePlayerByName[name]; if e then attachToTorso(e); e.attachedToMe = true end end,
    detach      = function(name) local e = FakePlayerByName[name]; if e then detachFromTorso(e, true); e.attachedToMe = false end end,
    walkTo      = function(name, pos) local e = FakePlayerByName[name]; if e then movePlayerTo(e, pos) end end,
    follow      = function(name) local e = FakePlayerByName[name]; if e then startFollow(e) end end,
    stopFollow  = function(name) local e = FakePlayerByName[name]; if e then stopFollow(e) end end,
    lookAtMe    = function(name) local e = FakePlayerByName[name]; if e then lookAtPlayer(e) end end,
    givePet     = givePetFromFakePlayer,
    startTrade  = startMockTradeWith,
    triggerChat = onLocalPlayerChat,
    list        = function() local n = {}; for k in pairs(FakePlayerByName) do table.insert(n, k) end; return n end,
}

-- =====================================================================
-- UI (draggable from first file + mobile friendly)
-- =====================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakePlayerControl"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 540)
mainFrame.Position = UDim2.new(0, 20, 0.5, -270)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
mainFrame.BorderSizePixel = 0
mainFrame.Active = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(108, 75, 171)
mainStroke.Thickness = 1.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 32, 60)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎭 Fake Player"
title.Font = Enum.Font.FredokaOne
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(240, 230, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- ===== DRAG TOGGLE (from first file) =====
local dragEnabled = true
local dragToggleBtn = Instance.new("TextButton")
dragToggleBtn.Size = UDim2.new(0, 36, 0, 18)
dragToggleBtn.Position = UDim2.new(1, -80, 0, 5)
dragToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 50)
dragToggleBtn.Text = "drag"
dragToggleBtn.Font = Enum.Font.GothamBold
dragToggleBtn.TextSize = 9
dragToggleBtn.TextColor3 = Color3.fromRGB(80, 255, 130)
dragToggleBtn.ZIndex = 10
dragToggleBtn.Parent = titleBar
Instance.new("UICorner", dragToggleBtn).CornerRadius = UDim.new(0, 4)
local dragToggleStroke = Instance.new("UIStroke")
dragToggleStroke.Color = Color3.fromRGB(0, 200, 80)
dragToggleStroke.Thickness = 1
dragToggleStroke.Parent = dragToggleBtn

dragToggleBtn.MouseButton1Click:Connect(function()
    dragEnabled = not dragEnabled
    if dragEnabled then
        dragToggleBtn.Text = "drag"
        dragToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 50)
        dragToggleBtn.TextColor3 = Color3.fromRGB(80, 255, 130)
        dragToggleStroke.Color = Color3.fromRGB(0, 200, 80)
    else
        dragToggleBtn.Text = "lock"
        dragToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
        dragToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        dragToggleStroke.Color = Color3.fromRGB(160, 50, 50)
    end
end)

-- Minimize + hide
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 24, 0, 20)
minimizeBtn.Position = UDim2.new(1, -44, 0, 4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
minimizeBtn.Text = "—"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 4)

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 20, 0, 20)
hideBtn.Position = UDim2.new(1, -22, 0, 4)
hideBtn.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
hideBtn.Text = "✕"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 12
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.Parent = titleBar
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 4)

local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 52, 0, 52)
floatBtn.Position = UDim2.new(0, 14, 0.5, -26)
floatBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
floatBtn.Text = "🎭"
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextSize = 24
floatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatBtn.Visible = false
floatBtn.Parent = screenGui
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0)
local fStroke = Instance.new("UIStroke"); fStroke.Color = Color3.fromRGB(140, 100, 200); fStroke.Thickness = 2; fStroke.Parent = floatBtn

-- Content
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, 0, 1, -32)
content.Position = UDim2.new(0, 0, 0, 32)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(108, 75, 171)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 7)
layout.Parent = content
local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 8)
pad.PaddingLeft = UDim.new(0, 10)
pad.PaddingRight = UDim.new(0, 10)
pad.PaddingBottom = UDim.new(0, 12)
pad.Parent = content

-- ===== REAL DRAG (from first file) =====
local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if not dragEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- When drag is enabled, we need mainFrame.Active=true to catch inputs.
-- Use a RunService to keep Active synced
RunService.Heartbeat:Connect(function()
    if mainFrame.Active ~= dragEnabled then
        mainFrame.Active = dragEnabled
    end
end)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    mainFrame.Size = minimized and UDim2.new(0, 280, 0, 28) or UDim2.new(0, 280, 0, 540)
    minimizeBtn.Text = minimized and "+" or "—"
end)

hideBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatBtn.Visible = true
end)
floatBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatBtn.Visible = false
end)

-- ===== UI HELPERS =====
local function sectionLabel(text, order)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 14)
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
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    b.Text = default or ""
    b.PlaceholderText = placeholder or ""
    b.PlaceholderColor3 = Color3.fromRGB(110, 110, 130)
    b.Font = Enum.Font.SourceSans
    b.TextSize = 13
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.ClearTextOnFocus = false
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.LayoutOrder = order
    b.Parent = content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0, 8); p.PaddingRight = UDim.new(0, 8); p.Parent = b
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(80, 80, 100); s.Thickness = 1; s.Parent = b
    return b
end

local function makeBtn(text, order, color, height)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, height or 34)
    b.BackgroundColor3 = color or Color3.fromRGB(40, 40, 55)
    b.Text = text
    b.Font = Enum.Font.FredokaOne
    b.TextSize = 12
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.LayoutOrder = order
    b.Parent = content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(108, 75, 171); s.Thickness = 1.5; s.Transparency = 0.3; s.Parent = b
    return b
end

-- ===== SECTIONS =====
sectionLabel("▸ Spawn", 1)
local usernameBox = makeBox("Username (blank = preset)", "", 2)
local userIdBox   = makeBox("User ID (optional)", "", 3)
local spawnBtn    = makeBtn("➕ Spawn", 4)
local deleteAllBtn = makeBtn("🗑 Delete All", 5, Color3.fromRGB(70, 30, 30))

sectionLabel("▸ Target", 6)
local targetBtn = makeBtn("Target: (none)", 7)
local selectedName = nil

sectionLabel("▸ Send Chat Bubble", 8)
local chatBox = makeBox("Type a message...", "", 9)
local chatBtn = makeBtn("💬 Send", 10)

sectionLabel("▸ Emotes", 11)
local emoteBtn = makeBtn("Emote: Wave  ▾", 12)
local emoteList = Instance.new("ScrollingFrame")
emoteList.Size = UDim2.new(1, 0, 0, 160)
emoteList.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
emoteList.BorderSizePixel = 0
emoteList.ScrollBarThickness = 3
emoteList.ScrollBarImageColor3 = Color3.fromRGB(108, 75, 171)
emoteList.CanvasSize = UDim2.new(0, 0, 0, 0)
emoteList.AutomaticCanvasSize = Enum.AutomaticSize.Y
emoteList.Visible = false
emoteList.LayoutOrder = 13
emoteList.Parent = content
Instance.new("UICorner", emoteList).CornerRadius = UDim.new(0, 5)
local elLayout = Instance.new("UIListLayout"); elLayout.SortOrder = Enum.SortOrder.LayoutOrder; elLayout.Padding = UDim.new(0, 2); elLayout.Parent = emoteList
local elPad = Instance.new("UIPadding"); elPad.PaddingTop = UDim.new(0, 4); elPad.PaddingLeft = UDim.new(0, 4); elPad.PaddingRight = UDim.new(0, 4); elPad.PaddingBottom = UDim.new(0, 4); elPad.Parent = emoteList

local selectedEmote = EMOTES[1]
for i, e in ipairs(EMOTES) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -6, 0, 26)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    b.Text = "  " .. e.name
    b.Font = Enum.Font.SourceSans
    b.TextSize = 12
    b.TextColor3 = Color3.fromRGB(220, 220, 235)
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.LayoutOrder = i
    b.Parent = emoteList
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function()
        selectedEmote = e
        emoteBtn.Text = "Emote: " .. e.name .. "  ▾"
        emoteList.Visible = false
    end)
end
emoteBtn.MouseButton1Click:Connect(function()
    emoteList.Visible = not emoteList.Visible
end)

local loopToggle = makeBtn("Loop Emote: OFF", 14)
local looped = false
loopToggle.MouseButton1Click:Connect(function()
    looped = not looped
    loopToggle.Text = "Loop Emote: " .. (looped and "ON" or "OFF")
    loopToggle.BackgroundColor3 = looped and Color3.fromRGB(55, 45, 75) or Color3.fromRGB(40, 40, 55)
end)

local attachToggle = makeBtn("Attach to Torso: OFF", 15)
local attachOn = false
attachToggle.MouseButton1Click:Connect(function()
    attachOn = not attachOn
    attachToggle.Text = "Attach to Torso: " .. (attachOn and "ON" or "OFF")
    attachToggle.BackgroundColor3 = attachOn and Color3.fromRGB(50, 90, 60) or Color3.fromRGB(40, 40, 55)
end)

local emoteRow = Instance.new("Frame")
emoteRow.Size = UDim2.new(1, 0, 0, 34)
emoteRow.BackgroundTransparency = 1
emoteRow.LayoutOrder = 16
emoteRow.Parent = content
local elRowLayout = Instance.new("UIListLayout")
elRowLayout.FillDirection = Enum.FillDirection.Horizontal
elRowLayout.Padding = UDim.new(0, 5)
elRowLayout.SortOrder = Enum.SortOrder.LayoutOrder
elRowLayout.Parent = emoteRow

local function makeHalfBtn(text, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.5, -3, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    b.Text = text
    b.Font = Enum.Font.FredokaOne
    b.TextSize = 12
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.LayoutOrder = order
    b.Parent = emoteRow
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(108, 75, 171); s.Thickness = 1.5; s.Transparency = 0.3; s.Parent = b
    return b
end
local playEmoteBtn = makeHalfBtn("▶ Play", 1)
local stopEmoteBtn = makeHalfBtn("⏹ Stop", 2)

sectionLabel("▸ Movement", 17)
local walkFwdBtn = makeBtn("🚶 Walk to Me", 18)
local walkRandBtn = makeBtn("🎲 Walk Random", 19)
local followBtn = makeBtn("👣 Follow: OFF", 20)
local stopFollowBtn = makeBtn("⏹ Stop Follow", 21)
local lookAtBtn = makeBtn("👁 Look at Me", 22)

sectionLabel("▸ Trade & Pet", 23)
local givePetBtn = makeBtn("🐾 Give Random High Tier Pet", 24, Color3.fromRGB(50, 90, 60))

-- ===== HANDLERS =====
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
    if spawnFakePlayer(name, uid) then
        lastTriggeredTarget = name
        selectedName = name
        targetBtn.Text = "Target: " .. name
    end
end)

deleteAllBtn.MouseButton1Click:Connect(function()
    deleteAllFakePlayers()
    selectedName = nil
    targetBtn.Text = "Target: (none)"
end)

targetBtn.MouseButton1Click:Connect(function()
    -- Cycle through spawned players
    local names = {}
    for name in pairs(FakePlayerByName) do table.insert(names, name) end
    if #names == 0 then hint("No fake players spawned.", 2); return end
    local idx = 1
    for i, n in ipairs(names) do if n == selectedName then idx = i + 1; break end end
    if idx > #names then idx = 1 end
    selectedName = names[idx]
    targetBtn.Text = "Target: " .. selectedName
end)

chatBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry then hint("Player no longer exists.", 3); return end
    if chatBox.Text == "" then return end
    sendFakeChat(entry, chatBox.Text, 5)
    -- Also trigger the auto-response system (so your own typed message triggers a reply)
    onLocalPlayerChat(chatBox.Text)
    chatBox.Text = ""
end)

playEmoteBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry then hint("Player no longer exists.", 3); return end
    if playEmote(entry, selectedEmote.id, looped, attachOn) then
        hint("Playing: " .. selectedEmote.name .. (attachOn and " (attached)" or ""), 2)
    end
end)

stopEmoteBtn.MouseButton1Click:Connect(function()
    if not selectedName then return end
    local entry = FakePlayerByName[selectedName]
    if entry then
        local wasAttached = entry.attachedToMe
        stopEmote(entry)
        if wasAttached then hint("Released with paint splash!", 2) end
    end
end)

walkFwdBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry or not entry.character then return end
    local lhrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if lhrp then movePlayerTo(entry, (lhrp.CFrame * CFrame.new(0, 0, -5)).Position) end
end)

walkRandBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry or not entry.character then return end
    local hrp = entry.character:FindFirstChild("HumanoidRootPart")
    if hrp then movePlayerTo(entry, hrp.Position + Vector3.new(math.random(-15,15), 0, math.random(-15,15))) end
end)

followBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry then return end
    if followThreads[entry.userId] then
        stopFollow(entry)
        followBtn.Text = "👣 Follow: OFF"
        followBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    else
        startFollow(entry)
        followBtn.Text = "👣 Follow: ON"
        followBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 60)
    end
end)

stopFollowBtn.MouseButton1Click:Connect(function()
    if not selectedName then return end
    local entry = FakePlayerByName[selectedName]
    if entry then
        stopFollow(entry)
        followBtn.Text = "👣 Follow: OFF"
        followBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end
end)

lookAtBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if entry then lookAtPlayer(entry) end
end)

givePetBtn.MouseButton1Click:Connect(function()
    if not selectedName then hint("Select a target first.", 3); return end
    local entry = FakePlayerByName[selectedName]
    if not entry then return end
    givePetFromFakePlayer(entry.name, entry.userId)
end)

-- =====================================================================
hint("Fake Player v4 loaded!", 4)