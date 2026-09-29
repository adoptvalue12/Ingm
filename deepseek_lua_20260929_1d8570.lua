--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║   YUNO HUB v6.0 — MOBILE · ORIGINAL STYLE                     ║
    ║   Universal · MM2 · Themes · Music · Floating pins            ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local SoundService     = game:GetService("SoundService")
local StarterGui       = game:GetService("StarterGui")

local LP = Players.LocalPlayer

--═══════════════════════════════════════════════════════════════
-- IMAGES
--═══════════════════════════════════════════════════════════════
local A = {
    LOGO      = "rbxassetid://11322093471",
    SHIELD    = "rbxassetid://11322093471",
    CROWN     = "rbxassetid://95046902556786",
    STAR      = "rbxassetid://6031075931",
    SPARKLE   = "rbxassetid://280259692",
    LIGHTNING = "rbxassetid://4907816507",
    FIRE      = "rbxassetid://4934971481",
    WING      = "rbxassetid://7708223964",
    CROSS     = "rbxassetid://6047530871",
    CHECK     = "rbxassetid://6031091004",
    DIAMOND   = "rbxassetid://6034684930",
    SWORD     = "rbxassetid://4913393055",
    SKULL     = "rbxassetid://6047530871",
    HOME      = "rbxassetid://6031075931",
    SETTINGS  = "rbxassetid://6034684930",
    MUSIC     = "rbxassetid://1837879082",
    PALETTE   = "rbxassetid://6031091004",
    GUN       = "rbxassetid://4913393055",
    KNIFE     = "rbxassetid://4913393055",
    TARGET    = "rbxassetid://4907816507",
    PLANE     = "rbxassetid://7708223964",
    PERSON    = "rbxassetid://6031075931",
    SEARCH    = "rbxassetid://6031091004",
    COIN      = "rbxassetid://6034684930",
    MEDKIT    = "rbxassetid://6047530871",
    PIN       = "rbxassetid://6031091004",
    HEART     = "rbxassetid://6031075931",
    CLOCK     = "rbxassetid://6034684930",
    MOON      = "rbxassetid://6034684930",
    SUN       = "rbxassetid://6034684930",
    GEM       = "rbxassetid://6034684930",
    ROCKET    = "rbxassetid://7708223964",
    POTION    = "rbxassetid://6047530871",
    SCROLL    = "rbxassetid://6034684930",
    ANCHOR    = "rbxassetid://6034684930",
    CLOUD     = "rbxassetid://6031075931",
    WATER     = "rbxassetid://6034684930",
    ORB       = "rbxassetid://280259692",
}

--═══════════════════════════════════════════════════════════════
-- SOUNDS
--═══════════════════════════════════════════════════════════════
local S = {
    CLICK      = "rbxassetid://876939830",
    HOVER      = "rbxassetid://6042053626",
    TICK       = "rbxassetid://9125402604",
    SUCCESS    = "rbxassetid://2865227271",
    OPEN       = "rbxassetid://6895079853",
    CLOSE      = "rbxassetid://6042053626",
    WHOOSH     = "rbxassetid://5150307161",
    ERROR      = "rbxassetid://6114958611",
    SPARKLE    = "rbxassetid://9125402604",
    TAB        = "rbxassetid://5150307161",
    ALERT      = "rbxassetid://6114958611",
    PIN        = "rbxassetid://9125402604",
    UNPIN      = "rbxassetid://6042053626",
    TAP        = "rbxassetid://876939830",
    DEEP       = "rbxassetid://1837879082",
    SHIMMER    = "rbxassetid://2865227271",
    CHIME      = "rbxassetid://1836375780",
    POP        = "rbxassetid://5545841056",
    BLIP       = "rbxassetid://6766425087",
    BEEP       = "rbxassetid://5153583335",
    BELL       = "rbxassetid://9120387183",
    SWOOSH     = "rbxassetid://4864130617",
    COIN       = "rbxassetid://131237241",
    FLY        = "rbxassetid://5150307161",
    BOOM       = "rbxassetid://131237241",
    CRYSTAL    = "rbxassetid://1842752035",
}

--═══════════════════════════════════════════════════════════════
-- MUSIC TRACKS
--═══════════════════════════════════════════════════════════════
local MUSIC = {
    { name = "Dreamy Piano",   id = "rbxassetid://1837879082", vol = 0.15, icon = A.MUSIC },
    { name = "Soft Pads",      id = "rbxassetid://1841647092", vol = 0.15, icon = A.CLOUD },
    { name = "Deep Focus",     id = "rbxassetid://9046817222", vol = 0.15, icon = A.GEM },
    { name = "Chill Lo-Fi",    id = "rbxassetid://1836375780", vol = 0.15, icon = A.MUSIC },
    { name = "Rainfall",       id = "rbxassetid://131886780",  vol = 0.20, icon = A.WATER },
    { name = "Crystal Chimes", id = "rbxassetid://1842752035", vol = 0.15, icon = A.DIAMOND },
    { name = "Night Ambience", id = "rbxassetid://1836315732", vol = 0.15, icon = A.MOON },
    { name = "Zen Garden",     id = "rbxassetid://1838461353", vol = 0.15, icon = A.STAR },
    { name = "Ocean Waves",    id = "rbxassetid://1836905330", vol = 0.18, icon = A.WATER },
    { name = "Wind Bells",     id = "rbxassetid://1844747665", vol = 0.15, icon = A.SPARKLE },
    { name = "Fireplace",      id = "rbxassetid://1842080199", vol = 0.18, icon = A.FIRE },
    { name = "Cosmic Hum",     id = "rbxassetid://1837725500", vol = 0.15, icon = A.ORB },
}

--═══════════════════════════════════════════════════════════════
-- THEMES
--═══════════════════════════════════════════════════════════════
local THEMES = {
    GOLDEN   = { name="Golden",      icon=A.CROWN,     accent=Color3.fromRGB(255,200,50),  accent2=Color3.fromRGB(255,230,130), text=Color3.fromRGB(255,240,210), textDim=Color3.fromRGB(180,165,130), bg1=Color3.fromRGB(30,24,14),  bg2=Color3.fromRGB(14,12,8),  panel=Color3.fromRGB(24,20,14), panelHover=Color3.fromRGB(40,32,20), section=Color3.fromRGB(32,26,16) },
    NEON     = { name="Cyber Neon",  icon=A.LIGHTNING, accent=Color3.fromRGB(0,255,220),   accent2=Color3.fromRGB(130,255,240), text=Color3.fromRGB(220,255,255), textDim=Color3.fromRGB(130,180,190), bg1=Color3.fromRGB(14,22,32),  bg2=Color3.fromRGB(5,10,18),  panel=Color3.fromRGB(12,20,30), panelHover=Color3.fromRGB(20,40,55), section=Color3.fromRGB(18,30,42) },
    BLOOD    = { name="Blood Moon",  icon=A.FIRE,      accent=Color3.fromRGB(220,30,40),   accent2=Color3.fromRGB(255,100,100), text=Color3.fromRGB(255,220,220), textDim=Color3.fromRGB(180,120,120), bg1=Color3.fromRGB(32,10,12),  bg2=Color3.fromRGB(15,5,8),   panel=Color3.fromRGB(26,10,12), panelHover=Color3.fromRGB(50,15,20), section=Color3.fromRGB(38,14,18) },
    OCEAN    = { name="Ocean Deep",  icon=A.WATER,     accent=Color3.fromRGB(80,180,255),  accent2=Color3.fromRGB(160,220,255), text=Color3.fromRGB(220,240,255), textDim=Color3.fromRGB(130,160,190), bg1=Color3.fromRGB(12,22,40),  bg2=Color3.fromRGB(5,10,22),  panel=Color3.fromRGB(12,22,38), panelHover=Color3.fromRGB(22,42,68), section=Color3.fromRGB(18,32,52) },
    GALAXY   = { name="Galaxy",      icon=A.STAR,      accent=Color3.fromRGB(180,100,255), accent2=Color3.fromRGB(220,170,255), text=Color3.fromRGB(240,220,255), textDim=Color3.fromRGB(170,140,200), bg1=Color3.fromRGB(25,14,40),  bg2=Color3.fromRGB(10,6,22),  panel=Color3.fromRGB(22,14,36), panelHover=Color3.fromRGB(42,26,68), section=Color3.fromRGB(32,20,50) },
    PINK     = { name="Neon Pink",   icon=A.SPARKLE,   accent=Color3.fromRGB(255,60,180),  accent2=Color3.fromRGB(255,140,220), text=Color3.fromRGB(255,220,240), textDim=Color3.fromRGB(200,130,170), bg1=Color3.fromRGB(32,12,28),  bg2=Color3.fromRGB(15,5,15),  panel=Color3.fromRGB(28,12,26), panelHover=Color3.fromRGB(50,20,45), section=Color3.fromRGB(38,16,34) },
    EMERALD  = { name="Emerald",     icon=A.CHECK,     accent=Color3.fromRGB(60,220,130),  accent2=Color3.fromRGB(140,255,180), text=Color3.fromRGB(220,255,230), textDim=Color3.fromRGB(130,180,150), bg1=Color3.fromRGB(12,28,20),  bg2=Color3.fromRGB(5,15,10),  panel=Color3.fromRGB(12,26,20), panelHover=Color3.fromRGB(20,45,35), section=Color3.fromRGB(18,36,26) },
    ICE      = { name="Ice Blue",    icon=A.DIAMOND,   accent=Color3.fromRGB(140,220,255), accent2=Color3.fromRGB(200,240,255), text=Color3.fromRGB(230,245,255), textDim=Color3.fromRGB(150,180,200), bg1=Color3.fromRGB(18,28,38),  bg2=Color3.fromRGB(8,14,22),  panel=Color3.fromRGB(18,28,42), panelHover=Color3.fromRGB(30,48,68), section=Color3.fromRGB(24,36,52) },
    SUNSET   = { name="Sunset",      icon=A.SUN,       accent=Color3.fromRGB(255,120,60),  accent2=Color3.fromRGB(255,180,120), text=Color3.fromRGB(255,235,220), textDim=Color3.fromRGB(200,150,120), bg1=Color3.fromRGB(38,20,14),  bg2=Color3.fromRGB(20,8,5),   panel=Color3.fromRGB(32,18,12), panelHover=Color3.fromRGB(58,30,20), section=Color3.fromRGB(42,24,16) },
    FOREST   = { name="Forest",      icon=A.STAR,      accent=Color3.fromRGB(120,180,80),  accent2=Color3.fromRGB(180,220,140), text=Color3.fromRGB(230,245,220), textDim=Color3.fromRGB(150,180,130), bg1=Color3.fromRGB(18,28,14),  bg2=Color3.fromRGB(8,15,6),   panel=Color3.fromRGB(18,28,16), panelHover=Color3.fromRGB(30,45,24), section=Color3.fromRGB(24,36,20) },
    MONO     = { name="Mono",        icon=A.CROSS,     accent=Color3.fromRGB(220,220,220), accent2=Color3.fromRGB(255,255,255), text=Color3.fromRGB(240,240,240), textDim=Color3.fromRGB(150,150,150), bg1=Color3.fromRGB(22,22,22),  bg2=Color3.fromRGB(10,10,10), panel=Color3.fromRGB(22,22,22), panelHover=Color3.fromRGB(45,45,45), section=Color3.fromRGB(32,32,32) },
    LAVA     = { name="Lava",        icon=A.FIRE,      accent=Color3.fromRGB(255,80,20),   accent2=Color3.fromRGB(255,150,60),  text=Color3.fromRGB(255,225,200), textDim=Color3.fromRGB(200,140,100), bg1=Color3.fromRGB(35,12,8),   bg2=Color3.fromRGB(18,5,3),   panel=Color3.fromRGB(32,12,8),  panelHover=Color3.fromRGB(60,22,12), section=Color3.fromRGB(42,16,10) },
    TOXIC    = { name="Toxic",       icon=A.SKULL,     accent=Color3.fromRGB(180,255,40),  accent2=Color3.fromRGB(220,255,120), text=Color3.fromRGB(230,255,180), textDim=Color3.fromRGB(150,180,100), bg1=Color3.fromRGB(20,28,10),  bg2=Color3.fromRGB(10,15,5),  panel=Color3.fromRGB(20,28,12), panelHover=Color3.fromRGB(36,45,20), section=Color3.fromRGB(28,38,16) },
    MIDNIGHT = { name="Midnight",    icon=A.MOON,      accent=Color3.fromRGB(90,120,255),  accent2=Color3.fromRGB(150,180,255), text=Color3.fromRGB(220,230,255), textDim=Color3.fromRGB(130,150,190), bg1=Color3.fromRGB(12,14,30),  bg2=Color3.fromRGB(6,7,18),   panel=Color3.fromRGB(14,16,32), panelHover=Color3.fromRGB(26,30,55), section=Color3.fromRGB(20,24,44) },
    ROSE     = { name="Rose Gold",   icon=A.HEART,     accent=Color3.fromRGB(255,150,160), accent2=Color3.fromRGB(255,200,210), text=Color3.fromRGB(255,230,235), textDim=Color3.fromRGB(200,160,170), bg1=Color3.fromRGB(35,20,22),  bg2=Color3.fromRGB(18,10,12), panel=Color3.fromRGB(32,18,20), panelHover=Color3.fromRGB(55,30,34), section=Color3.fromRGB(42,24,26) },
    MINT     = { name="Mint",        icon=A.CLOUD,     accent=Color3.fromRGB(100,255,200), accent2=Color3.fromRGB(170,255,220), text=Color3.fromRGB(220,255,240), textDim=Color3.fromRGB(140,200,180), bg1=Color3.fromRGB(12,28,24),  bg2=Color3.fromRGB(5,14,12),  panel=Color3.fromRGB(12,26,22), panelHover=Color3.fromRGB(20,45,38), section=Color3.fromRGB(18,36,30) },
    SAND     = { name="Desert Sand", icon=A.SUN,       accent=Color3.fromRGB(230,180,100), accent2=Color3.fromRGB(255,215,150), text=Color3.fromRGB(255,240,215), textDim=Color3.fromRGB(190,160,120), bg1=Color3.fromRGB(35,28,18),  bg2=Color3.fromRGB(18,14,9),  panel=Color3.fromRGB(32,26,16), panelHover=Color3.fromRGB(55,45,28), section=Color3.fromRGB(42,34,20) },
    VOID     = { name="Void Black",  icon=A.DIAMOND,   accent=Color3.fromRGB(140,60,255),  accent2=Color3.fromRGB(200,140,255), text=Color3.fromRGB(230,215,255), textDim=Color3.fromRGB(150,120,180), bg1=Color3.fromRGB(10,8,20),   bg2=Color3.fromRGB(4,3,10),   panel=Color3.fromRGB(12,10,22), panelHover=Color3.fromRGB(26,20,42), section=Color3.fromRGB(20,14,32) },
}

local currentTheme = "GOLDEN"
local T = THEMES[currentTheme]
local ASMR_ON = true
local PARTICLES_ON = true

--═══════════════════════════════════════════════════════════════
-- STATE
--═══════════════════════════════════════════════════════════════
local State = {
    flyOn=false, flySpeed=50, infJump=false, ws=16, fov=70, loopFovWs=false,
    hitboxSize=1, loopHitbox=false, targetPlayer=nil,
    antiFling=false, noclipOn=false,
    playerESP=false, gunDropESP=false, trapDetection=false,
    autoShooting=false, shootOffset=2.8, loopThrow=false,
    autoGetGun=false, killAura=false,
}

local connections = {}
local function track(c) table.insert(connections, c); return c end

--═══════════════════════════════════════════════════════════════
-- UTIL
--═══════════════════════════════════════════════════════════════
local function playSound(id, vol, pitch)
    if not ASMR_ON then return end
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = vol or 0.4
    s.PlaybackSpeed = pitch or 1
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local function notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = dur or 3 })
    end)
end

local function mkImage(parent, id, size, pos, color)
    local i = Instance.new("ImageLabel", parent)
    i.BackgroundTransparency = 1
    i.Image = id
    i.ImageColor3 = color or T.accent
    i.ScaleType = Enum.ScaleType.Fit
    if size then i.Size = size end
    if pos then i.Position = pos end
    return i
end

-- Universal click handler: works on PC AND mobile (touch)
local function onClick(obj, callback)
    local lastFire = 0
    local function fire()
        if os.clock() - lastFire < 0.15 then return end
        lastFire = os.clock()
        pcall(callback)
    end
    obj.MouseButton1Click:Connect(fire)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            fire()
        end
    end)
end

--═══════════════════════════════════════════════════════════════
-- FLOATING BUTTONS
--═══════════════════════════════════════════════════════════════
local floatLayer
local floatingButtons = {}

local function spawnFloatingButton(key, name, iconId, callback)
    if not floatLayer then return end
    if floatingButtons[key] then
        playSound(S.UNPIN, 0.4)
        local fb = floatingButtons[key]
        TweenService:Create(fb, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0,0,0,0)
        }):Play()
        task.wait(0.3)
        fb:Destroy()
        floatingButtons[key] = nil
        return
    end

    playSound(S.PIN, 0.5, 1.3)

    local fb = Instance.new("TextButton", floatLayer)
    fb.Name = "FB_" .. key
    fb.Size = UDim2.new(0, 0, 0, 0)
    fb.Position = UDim2.new(0, 20, 0.5, math.random(-150, 150))
    fb.BackgroundColor3 = T.panel
    fb.BorderSizePixel = 0
    fb.Text = ""
    fb.AutoButtonColor = false
    fb.ZIndex = 50

    local c = Instance.new("UICorner", fb)
    c.CornerRadius = UDim.new(1, 0)
    local s = Instance.new("UIStroke", fb)
    s.Color = T.accent
    s.Thickness = 2

    mkImage(fb, iconId, UDim2.new(0, 32, 0, 32), UDim2.new(0.5, -16, 0.5, -16), T.accent2)

    local lbl = Instance.new("TextLabel", fb)
    lbl.Size = UDim2.new(1, 0, 0, 14)
    lbl.Position = UDim2.new(0, 0, 1, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = T.text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextStrokeTransparency = 0.5

    TweenService:Create(fb, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 64, 0, 64)
    }):Play()

    local dragging, dragStart, startPos, startTime, moved
    fb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; moved = false
            dragStart = input.Position
            startPos = fb.Position
            startTime = os.clock()
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    fb.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then moved = true end
            fb.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                    startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    fb.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local held = os.clock() - (startTime or 0)
        if not moved then
            if held > 0.5 then
                playSound(S.UNPIN, 0.4)
                fb:Destroy()
                floatingButtons[key] = nil
            else
                playSound(S.TAP, 0.5, 0.95 + math.random() * 0.1)
                TweenService:Create(fb, TweenInfo.new(0.1), { Size = UDim2.new(0, 56, 0, 56) }):Play()
                task.delay(0.15, function()
                    if fb.Parent then
                        TweenService:Create(fb, TweenInfo.new(0.15), { Size = UDim2.new(0, 64, 0, 64) }):Play()
                    end
                end)
                pcall(callback)
            end
        end
    end)

    floatingButtons[key] = fb
    notify("YunoHub", "Pinned: " .. name, 3)
end

--═══════════════════════════════════════════════════════════════
-- LOADING SCREEN
--═══════════════════════════════════════════════════════════════
local function loadingScreen()
    local g = Instance.new("ScreenGui")
    g.IgnoreGuiInset = true
    g.ResetOnSpawn = false
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = LP:WaitForChild("PlayerGui") end

    local bg = Instance.new("Frame", g)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
    bg.BackgroundTransparency = 1

    local logo = mkImage(g, A.SHIELD, UDim2.new(0,120,0,120), UDim2.new(0.5,-60,0.4,-120), T.accent2)
    logo.ImageTransparency = 1

    local label = Instance.new("TextLabel", g)
    label.Size = UDim2.new(0, 400, 0, 70)
    label.Position = UDim2.new(0.5, -200, 0.5, -20)
    label.BackgroundTransparency = 1
    label.TextColor3 = T.accent
    label.Font = Enum.Font.GothamBlack
    label.TextScaled = true
    label.TextTransparency = 1

    local line = Instance.new("Frame", g)
    line.Size = UDim2.new(0, 0, 0, 2)
    line.Position = UDim2.new(0.5, 0, 0.5, 55)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = T.accent
    line.BorderSizePixel = 0

    TweenService:Create(bg, TweenInfo.new(0.8), { BackgroundTransparency = 0.35 }):Play()
    TweenService:Create(logo, TweenInfo.new(0.8), { ImageTransparency = 0 }):Play()
    TweenService:Create(label, TweenInfo.new(0.8), { TextTransparency = 0 }):Play()
    TweenService:Create(line, TweenInfo.new(1.5, Enum.EasingStyle.Quint), { Size = UDim2.new(0, 360, 0, 2) }):Play()

    task.wait(0.9)
    local txt = "YUNO HUB"
    for i = 1, #txt do
        label.Text = string.sub(txt, 1, i)
        playSound(S.TICK, 0.28, 0.8 + math.random() * 0.4)
        task.wait(0.07)
    end

    task.wait(0.3)

    local sub = Instance.new("TextLabel", g)
    sub.Size = UDim2.new(0, 400, 0, 22)
    sub.Position = UDim2.new(0.5, -200, 0.5, 62)
    sub.BackgroundTransparency = 1
    sub.Text = "✦ Mobile Edition · v6.0 ✦"
    sub.TextColor3 = T.accent2
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 13
    sub.TextTransparency = 1
    TweenService:Create(sub, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()

    task.wait(1.2)
    TweenService:Create(label, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
    TweenService:Create(sub, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
    TweenService:Create(logo, TweenInfo.new(0.5), { ImageTransparency = 1 }):Play()
    TweenService:Create(bg, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(line, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    task.wait(0.6)
    g:Destroy()
end

loadingScreen()

--═══════════════════════════════════════════════════════════════
-- MAIN GUI  (ORIGINAL YUNOHUB LAYOUT)
--═══════════════════════════════════════════════════════════════
pcall(function() CoreGui.YunoHubV6:Destroy() end)

local gui = Instance.new("ScreenGui")
gui.Name = "YunoHubV6"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

floatLayer = Instance.new("Frame", gui)
floatLayer.Name = "FloatLayer"
floatLayer.Size = UDim2.new(1,0,1,0)
floatLayer.BackgroundTransparency = 1
floatLayer.ZIndex = 10

local viewportW = workspace.CurrentCamera.ViewportSize.X
local winW = math.min(440, viewportW - 30)
local winH = 320

local Menu = Instance.new("Frame", gui)
Menu.Name = "Menu"
Menu.Size = UDim2.new(0, winW, 0, winH)
Menu.Position = UDim2.new(0.5, -winW/2, 0, 20)
Menu.BackgroundColor3 = T.bg1
Menu.BorderSizePixel = 0
Menu.Active = true
Menu.ClipsDescendants = true
Menu.ZIndex = 20

local MenuCorner = Instance.new("UICorner", Menu)
MenuCorner.CornerRadius = UDim.new(0, 16)

local MenuGrad = Instance.new("UIGradient", Menu)
MenuGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.bg1),
    ColorSequenceKeypoint.new(1, T.bg2)
})
MenuGrad.Rotation = 90

-- Original YunoHub colorful gradient stroke
local MenuStroke = Instance.new("UIStroke", Menu)
MenuStroke.Color = T.accent
MenuStroke.Thickness = 2

local MenuStrokeGrad = Instance.new("UIGradient", MenuStroke)
MenuStrokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.bg1),
    ColorSequenceKeypoint.new(0.2, T.accent),
    ColorSequenceKeypoint.new(0.5, T.accent2),
    ColorSequenceKeypoint.new(0.8, T.accent),
    ColorSequenceKeypoint.new(1, T.bg1)
})
MenuStrokeGrad.Rotation = 180

-- Animated rotation
task.spawn(function()
    while Menu.Parent do
        TweenService:Create(MenuStrokeGrad, TweenInfo.new(6, Enum.EasingStyle.Linear), { Rotation = MenuStrokeGrad.Rotation + 360 }):Play()
        task.wait(6)
    end
end)

-- Particles
task.spawn(function()
    while Menu.Parent do
        if PARTICLES_ON then
            local p = Instance.new("Frame", Menu)
            p.Size = UDim2.new(0, math.random(3,5), 0, math.random(3,5))
            p.BackgroundColor3 = T.accent
            p.BorderSizePixel = 0
            p.BackgroundTransparency = 0.4
            p.ZIndex = 1
            local pc = Instance.new("UICorner", p)
            pc.CornerRadius = UDim.new(1, 0)
            local sx = math.random(0, winW)
            local ex = sx + math.random(-80, 80)
            p.Position = UDim2.new(0, sx, 1, 0)
            TweenService:Create(p, TweenInfo.new(math.random(8,14), Enum.EasingStyle.Linear), {
                Position = UDim2.new(0, ex, 0, -30),
                BackgroundTransparency = 1,
            }):Play()
            task.delay(15, function() if p.Parent then p:Destroy() end end)
        end
        task.wait(math.random(6, 14) / 10)
    end
end)

--═══════════════════════════════════════════════════════════════
-- HEADER (HubName + HubDesc + Version)  — like original
--═══════════════════════════════════════════════════════════════
local hubName = Instance.new("TextLabel", Menu)
hubName.Name = "HubName"
hubName.Size = UDim2.new(0, 220, 0, 26)
hubName.Position = UDim2.new(0, 16, 0, 8)
hubName.BackgroundTransparency = 1
hubName.Text = "YunoHub"
hubName.TextColor3 = T.accent
hubName.Font = Enum.Font.GothamBlack
hubName.TextSize = 22
hubName.TextXAlignment = Enum.TextXAlignment.Left
hubName.ZIndex = 25

local version = Instance.new("TextLabel", Menu)
version.Size = UDim2.new(0, 120, 0, 14)
version.Position = UDim2.new(0, 18, 0, 34)
version.BackgroundTransparency = 1
version.Text = "✦ Mobile v6.0"
version.TextColor3 = T.textDim
version.Font = Enum.Font.GothamMedium
version.TextSize = 10
version.TextXAlignment = Enum.TextXAlignment.Left
version.ZIndex = 25

-- Original style: "yet another random hub menu" on right
local hubDesc = Instance.new("TextLabel", Menu)
hubDesc.Size = UDim2.new(0, 200, 0, 16)
hubDesc.Position = UDim2.new(1, -220, 0, 12)
hubDesc.BackgroundTransparency = 1
hubDesc.Text = "universal + mm2 · mobile"
hubDesc.TextColor3 = T.textDim
hubDesc.Font = Enum.Font.GothamBold
hubDesc.TextSize = 10
hubDesc.TextXAlignment = Enum.TextXAlignment.Right
hubDesc.ZIndex = 25

-- Close button (top-right, tuff style)
local closeBtn = Instance.new("TextButton", Menu)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 10)
closeBtn.BackgroundColor3 = T.panel
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = T.accent
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 14
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 26
local closeBtnCorner = Instance.new("UICorner", closeBtn)
closeBtnCorner.CornerRadius = UDim.new(0, 8)

onClick(closeBtn, function() end) -- replaced below

--═══════════════════════════════════════════════════════════════
-- CLOSE AREA (original: thin bar at top, "Tap here to minimize")
--═══════════════════════════════════════════════════════════════
local closeArea = Instance.new("TextButton", Menu)
closeArea.Name = "CloseArea"
closeArea.Size = UDim2.new(0.35, 0, 0, 6)
closeArea.Position = UDim2.new(0.5, -closeArea.Size.X.Offset/2, 0, 4)
closeArea.AnchorPoint = Vector2.new(0.5, 0)
closeArea.BackgroundColor3 = T.accent
closeArea.BorderSizePixel = 0
closeArea.Text = ""
closeArea.AutoButtonColor = false
closeArea.ZIndex = 25
local caCorner = Instance.new("UICorner", closeArea)
caCorner.CornerRadius = UDim.new(1, 0)
caCorner.CornerRadius = UDim.new(1, 0)

-- Persist opener
local opener = Instance.new("TextButton", floatLayer)
opener.Name = "Opener"
opener.Size = UDim2.new(0, 54, 0, 54)
opener.Position = UDim2.new(0, 15, 0.5, -27)
opener.BackgroundColor3 = T.panel
opener.BorderSizePixel = 0
opener.Text = ""
opener.AutoButtonColor = false
opener.ZIndex = 40
opener.Visible = false

local opCorner = Instance.new("UICorner", opener)
opCorner.CornerRadius = UDim.new(1, 0)
local opStroke = Instance.new("UIStroke", opener)
opStroke.Color = T.accent
opStroke.Thickness = 2
mkImage(opener, A.SHIELD, UDim2.new(0, 36, 0, 36), UDim2.new(0.5, -18, 0.5, -18), T.accent2)

task.spawn(function()
    while opener.Parent do
        TweenService:Create(opStroke, TweenInfo.new(1), { Transparency = 0.7 }):Play()
        task.wait(1)
        if not opener.Parent then break end
        TweenService:Create(opStroke, TweenInfo.new(1), { Transparency = 0 }):Play()
        task.wait(1)
    end
end)

local function minimizeHub()
    playSound(S.CLOSE, 0.5)
    TweenService:Create(Menu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.3)
    Menu.Visible = false
    opener.Visible = true
end

local function openHub()
    playSound(S.OPEN, 0.5)
    Menu.Visible = true
    Menu.Size = UDim2.new(0, 0, 0, 0)
    Menu.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(Menu, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, winW, 0, winH),
        Position = UDim2.new(0.5, -winW/2, 0, 20)
    }):Play()
    task.wait(0.4)
    opener.Visible = false
end

onClick(closeArea, minimizeHub)
onClick(closeBtn, minimizeHub)
onClick(opener, openHub)

--═══════════════════════════════════════════════════════════════
-- DRAG (whole Menu, like original)
--═══════════════════════════════════════════════════════════════
local dragging, dragStart, startPos
Menu.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Menu.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                  startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

--═══════════════════════════════════════════════════════════════
-- LIST (left sidebar with tabs)  — like original
--═══════════════════════════════════════════════════════════════
local List = Instance.new("Frame", Menu)
List.Name = "List"
List.Size = UDim2.new(0, 130, 1, -70)
List.Position = UDim2.new(0, 8, 0, 56)
List.BackgroundColor3 = T.panel
List.BorderSizePixel = 0
List.ZIndex = 21

local listCorner = Instance.new("UICorner", List)
listCorner.CornerRadius = UDim.new(0, 12)

local listScroll = Instance.new("ScrollingFrame", List)
listScroll.Size = UDim2.new(1, -8, 1, -8)
listScroll.Position = UDim2.new(0, 4, 0, 4)
listScroll.BackgroundTransparency = 1
listScroll.BorderSizePixel = 0
listScroll.ScrollBarThickness = 0
listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
listScroll.ZIndex = 22

local listLayout = Instance.new("UIListLayout", listScroll)
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

--═══════════════════════════════════════════════════════════════
-- AREA (right content)  — like original
--═══════════════════════════════════════════════════════════════
local Area = Instance.new("Frame", Menu)
Area.Name = "Area"
Area.Size = UDim2.new(1, -154, 1, -70)
Area.Position = UDim2.new(0, 146, 0, 56)
Area.BackgroundColor3 = T.panel
Area.BackgroundTransparency = 0.4
Area.BorderSizePixel = 0
Area.ZIndex = 21

local areaCorner = Instance.new("UICorner", Area)
areaCorner.CornerRadius = UDim.new(0, 12)

local areaScroll = Instance.new("ScrollingFrame", Area)
areaScroll.Size = UDim2.new(1, -8, 1, -8)
areaScroll.Position = UDim2.new(0, 4, 0, 4)
areaScroll.BackgroundTransparency = 1
areaScroll.BorderSizePixel = 0
areaScroll.ScrollBarThickness = 4
areaScroll.ScrollBarImageColor3 = T.accent
areaScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
areaScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
areaScroll.ZIndex = 22

local areaLayout = Instance.new("UIListLayout", areaScroll)
areaLayout.Padding = UDim.new(0, 5)
areaLayout.SortOrder = Enum.SortOrder.LayoutOrder

--═══════════════════════════════════════════════════════════════
-- FOOTER
--═══════════════════════════════════════════════════════════════
local footer = Instance.new("Frame", Menu)
footer.Size = UDim2.new(1, 0, 0, 18)
footer.Position = UDim2.new(0, 0, 1, -18)
footer.BackgroundColor3 = T.bg2
footer.BorderSizePixel = 0
footer.ZIndex = 21

local fLine = Instance.new("Frame", footer)
fLine.Size = UDim2.new(1, 0, 0, 1)
fLine.BackgroundColor3 = T.accent
fLine.BorderSizePixel = 0
fLine.BackgroundTransparency = 0.5

local fLbl = Instance.new("TextLabel", footer)
fLbl.Size = UDim2.new(1, 0, 1, 0)
fLbl.BackgroundTransparency = 1
fLbl.Text = "✦ Long-press any button to pin it on screen ✦"
fLbl.TextColor3 = T.accent2
fLbl.Font = Enum.Font.GothamBold
fLbl.TextSize = 9

--═══════════════════════════════════════════════════════════════
-- CONTENT BUILDERS  (used inside areaScroll)
--═══════════════════════════════════════════════════════════════
local function clearArea()
    for _, c in ipairs(areaScroll:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
end

local function section(title, iconId)
    local s = Instance.new("Frame", areaScroll)
    s.Size = UDim2.new(1, -6, 0, 26)
    s.BackgroundTransparency = 1
    s.LayoutOrder = #areaScroll:GetChildren()

    local bg = Instance.new("Frame", s)
    bg.Size = UDim2.new(0, 160, 1, 0)
    bg.Position = UDim2.new(0, 4, 0, 0)
    bg.BackgroundColor3 = T.bg1
    bg.BorderSizePixel = 0
    local c = Instance.new("UICorner", bg)
    c.CornerRadius = UDim.new(0, 4)

    if iconId then mkImage(bg, iconId, UDim2.new(0, 14, 0, 14), UDim2.new(0, 4, 0.5, -7), T.accent) end

    local l = Instance.new("TextLabel", bg)
    l.Size = UDim2.new(1, -24, 1, 0)
    l.Position = UDim2.new(0, 22, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = title
    l.TextColor3 = T.accent
    l.Font = Enum.Font.GothamBlack
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
end

-- BUTTON with long-press pin
local function btn(key, name, iconId, callback)
    local b = Instance.new("TextButton", areaScroll)
    b.Size = UDim2.new(1, -6, 0, 40)
    b.BackgroundColor3 = T.section
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.LayoutOrder = #areaScroll:GetChildren()

    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", b)
    st.Color = T.accent
    st.Thickness = 1
    st.Transparency = 0.6

    if iconId then mkImage(b, iconId, UDim2.new(0, 20, 0, 20), UDim2.new(0, 8, 0.5, -10), T.accent2) end

    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.new(1, -46, 1, 0)
    l.Position = UDim2.new(0, 36, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = T.text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left

    local pinHint = mkImage(b, A.PIN, UDim2.new(0, 14, 0, 14), UDim2.new(1, -20, 0.5, -7), T.textDim)
    pinHint.ImageTransparency = 0.55

    local holding = false
    local holdTask
    local lastFire = 0

    local function fireAction()
        if os.clock() - lastFire < 0.15 then return end
        lastFire = os.clock()
        playSound(S.CLICK, 0.4, 0.95 + math.random() * 0.1)
        pcall(callback)
    end

    local function startHold()
        holding = true
        holdTask = task.delay(0.5, function()
            if holding then
                holding = false
                spawnFloatingButton(key, name, iconId or A.STAR, callback)
                TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.accent }):Play()
                task.delay(0.2, function()
                    TweenService:Create(b, TweenInfo.new(0.2), { BackgroundColor3 = T.section }):Play()
                end)
            end
        end)
    end

    local function cancelHold()
        holding = false
        if holdTask then task.cancel(holdTask) end
    end

    b.MouseEnter:Connect(function()
        playSound(S.HOVER, 0.07, 1.5)
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.panelHover }):Play()
        TweenService:Create(st, TweenInfo.new(0.15), { Transparency = 0.2 }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.section }):Play()
        TweenService:Create(st, TweenInfo.new(0.15), { Transparency = 0.6 }):Play()
    end)

    b.MouseButton1Down:Connect(startHold)
    b.MouseButton1Up:Connect(function()
        if holding then
            cancelHold()
            fireAction()
        end
    end)
    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then startHold() end
    end)
    b.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if holding then
                cancelHold()
                fireAction()
            end
        end
    end)
    -- Also handle pure MouseButton1Click (fallback)
    b.MouseButton1Click:Connect(function()
        if not holding then fireAction() end
    end)

    return b
end

-- TOGGLE with long-press pin
local function toggle(key, name, iconId, default, callback)
    local b = Instance.new("TextButton", areaScroll)
    b.Size = UDim2.new(1, -6, 0, 40)
    b.BackgroundColor3 = T.section
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.LayoutOrder = #areaScroll:GetChildren()

    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", b)
    st.Color = T.accent
    st.Thickness = 1
    st.Transparency = default and 0.2 or 0.6

    if iconId then mkImage(b, iconId, UDim2.new(0, 20, 0, 20), UDim2.new(0, 8, 0.5, -10), T.accent2) end

    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.new(1, -92, 1, 0)
    l.Position = UDim2.new(0, 36, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = T.text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left

    local pinHint = mkImage(b, A.PIN, UDim2.new(0, 12, 0, 12), UDim2.new(1, -60, 0.5, -6), T.textDim)
    pinHint.ImageTransparency = 0.6

    local sw = Instance.new("Frame", b)
    sw.Size = UDim2.new(0, 36, 0, 18)
    sw.Position = UDim2.new(1, -44, 0.5, -9)
    sw.BackgroundColor3 = default and Color3.fromRGB(80,180,100) or Color3.fromRGB(60,55,45)
    sw.BorderSizePixel = 0
    local sc = Instance.new("UICorner", sw)
    sc.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", sw)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = default and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    local kc = Instance.new("UICorner", knob)
    kc.CornerRadius = UDim.new(1, 0)

    local state = default

    local function setState(v, silent)
        state = v
        if not silent then
            playSound(state and S.SUCCESS or S.CLICK, 0.4, state and 1.2 or 0.9)
        end
        if state then
            TweenService:Create(knob, TweenInfo.new(0.2), { Position = UDim2.new(1, -16, 0, 2) }):Play()
            TweenService:Create(sw, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(80,180,100) }):Play()
            TweenService:Create(st, TweenInfo.new(0.2), { Transparency = 0.2 }):Play()
        else
            TweenService:Create(knob, TweenInfo.new(0.2), { Position = UDim2.new(0, 2, 0, 2) }):Play()
            TweenService:Create(sw, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(60,55,45) }):Play()
            TweenService:Create(st, TweenInfo.new(0.2), { Transparency = 0.6 }):Play()
        end
    end

    local holding = false
    local holdTask
    local lastFire = 0
    local toggleCallback = function()
        if os.clock() - lastFire < 0.15 then return end
        lastFire = os.clock()
        setState(not state)
        if callback then callback(state) end
    end

    local function startHold()
        holding = true
        holdTask = task.delay(0.5, function()
            if holding then
                holding = false
                spawnFloatingButton(key, name, iconId or A.STAR, toggleCallback)
            end
        end)
    end
    local function cancelHold()
        holding = false
        if holdTask then task.cancel(holdTask) end
    end

    b.MouseEnter:Connect(function() playSound(S.HOVER, 0.07, 1.5) end)
    b.MouseButton1Down:Connect(startHold)
    b.MouseButton1Up:Connect(function()
        if holding then cancelHold(); toggleCallback() end
    end)
    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then startHold() end
    end)
    b.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and holding then
            cancelHold()
            toggleCallback()
        end
    end)
    b.MouseButton1Click:Connect(function() if not holding then toggleCallback() end end)

    return { set = function(v) setState(v, true); if callback then callback(v) end end }
end

local function input(placeholder, buttonText, callback)
    local row = Instance.new("Frame", areaScroll)
    row.Size = UDim2.new(1, -6, 0, 44)
    row.BackgroundColor3 = T.section
    row.BorderSizePixel = 0
    row.LayoutOrder = #areaScroll:GetChildren()

    local c = Instance.new("UICorner", row)
    c.CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", row)
    st.Color = T.accent
    st.Thickness = 1
    st.Transparency = 0.6

    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(1, -100, 0, 30)
    box.Position = UDim2.new(0, 6, 0.5, -15)
    box.BackgroundColor3 = T.bg2
    box.BorderSizePixel = 0
    box.Text = ""
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = T.textDim
    box.TextColor3 = T.text
    box.Font = Enum.Font.GothamMedium
    box.TextSize = 11
    box.ClearTextOnFocus = false
    local bc = Instance.new("UICorner", box)
    bc.CornerRadius = UDim.new(0, 6)

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 82, 0, 30)
    btn.Position = UDim2.new(1, -88, 0.5, -15)
    btn.BackgroundColor3 = T.panelHover
    btn.BorderSizePixel = 0
    btn.Text = buttonText or "Set"
    btn.TextColor3 = T.accent
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.AutoButtonColor = false
    local bc2 = Instance.new("UICorner", btn)
    bc2.CornerRadius = UDim.new(0, 6)
    local bs = Instance.new("UIStroke", btn)
    bs.Color = T.accent
    bs.Thickness = 1
    bs.Transparency = 0.5

    box.Focused:Connect(function() playSound(S.HOVER, 0.13, 1.4) end)
    onClick(btn, function() callback(box.Text) end)
end

local function range(name, minV, maxV, default, callback)
    local row = Instance.new("Frame", areaScroll)
    row.Size = UDim2.new(1, -6, 0, 52)
    row.BackgroundColor3 = T.section
    row.BorderSizePixel = 0
    row.LayoutOrder = #areaScroll:GetChildren()

    local c = Instance.new("UICorner", row)
    c.CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", row)
    st.Color = T.accent
    st.Thickness = 1
    st.Transparency = 0.6

    local l = Instance.new("TextLabel", row)
    l.Size = UDim2.new(1, -80, 0, 16)
    l.Position = UDim2.new(0, 10, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = T.text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left

    local vl = Instance.new("TextLabel", row)
    vl.Size = UDim2.new(0, 55, 0, 16)
    vl.Position = UDim2.new(1, -60, 0, 4)
    vl.BackgroundTransparency = 1
    vl.Text = tostring(default)
    vl.TextColor3 = T.accent
    vl.Font = Enum.Font.GothamBold
    vl.TextSize = 11
    vl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -20, 0, 10)
    track.Position = UDim2.new(0, 10, 1, -16)
    track.BackgroundColor3 = T.bg2
    track.BorderSizePixel = 0
    local tc = Instance.new("UICorner", track)
    tc.CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((default - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = T.accent
    fill.BorderSizePixel = 0
    local fc = Instance.new("UICorner", fill)
    fc.CornerRadius = UDim.new(1, 0)

    local dragging2 = false
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging2 = true
            playSound(S.HOVER, 0.1, 1.5)
        end
    end)
    track.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging2 = false
            playSound(S.CLICK, 0.3)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging2 and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local relX = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = minV + relX * (maxV - minV)
            if maxV - minV <= 5 then val = math.round(val) else val = math.floor(val) end
            fill.Size = UDim2.new(relX, 0, 1, 0)
            vl.Text = tostring(val)
            if callback then callback(val) end
        end
    end)
end

--═══════════════════════════════════════════════════════════════
-- LOGIC: UNIVERSAL + MM2 (unchanged from before)
--═══════════════════════════════════════════════════════════════
local flyBV, flyBG, flyConn
local function startFly()
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    if flyConn then flyConn:Disconnect() end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
    flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
    flyBG.P = 1000; flyBG.D = 50
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp
    flyConn = RunService.RenderStepped:Connect(function()
        if not State.flyOn or not flyBV or not flyBG then return end
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
        flyBV.Velocity = dir.Magnitude > 0 and (dir.Unit * State.flySpeed) or Vector3.zero
        flyBG.CFrame = cam.CFrame
    end)
end
local function stopFly()
    State.flyOn = false
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
end

local function getPlayerByName(name)
    name = string.lower(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and (string.sub(string.lower(p.Name),1,#name) == name
        or string.sub(string.lower(p.DisplayName),1,#name) == name) then return p end
    end
end

local function flingTarget(target)
    if not target or not target.Character then return end
    local myChar = LP.Character; if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP or not tHRP then return end
    for i = 1, 20 do
        myHRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, 3)
        task.wait()
    end
end

track(RunService.Heartbeat:Connect(function()
    if not State.antiFling then return end
    local char = LP.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if hrp.AssemblyLinearVelocity.Magnitude > 200 or hrp.AssemblyAngularVelocity.Magnitude > 200 then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false; part.Massless = true end
            end
        end
    end
end))

-- MM2
local espFolder
local function createESP(character, color, labelText)
    if not espFolder then espFolder = Instance.new("Folder", gui) end
    local hl = Instance.new("Highlight")
    hl.FillColor = color; hl.OutlineColor = color
    hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = character
    hl.Parent = espFolder
    if labelText then
        local bb = Instance.new("BillboardGui", espFolder)
        bb.Adornee = character:FindFirstChild("Head") or character
        bb.Size = UDim2.new(0, 80, 0, 20)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        local tl = Instance.new("TextLabel", bb)
        tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1
        tl.Text = labelText; tl.TextColor3 = color
        tl.Font = Enum.Font.GothamBlack; tl.TextSize = 12
        tl.TextStrokeTransparency = 0
    end
end
local function clearESP() if espFolder then for _, c in ipairs(espFolder:GetChildren()) do c:Destroy() end end end
local function findMurderer()
    for _, i in ipairs(Players:GetPlayers()) do if i.Backpack and i.Backpack:FindFirstChild("Knife") then return i end end
    for _, i in ipairs(Players:GetPlayers()) do if i.Character and i.Character:FindFirstChild("Knife") then return i end end
end
local function findSheriff()
    for _, i in ipairs(Players:GetPlayers()) do if i.Backpack and i.Backpack:FindFirstChild("Gun") then return i end end
    for _, i in ipairs(Players:GetPlayers()) do if i.Character and i.Character:FindFirstChild("Gun") then return i end end
end
local function getMap()
    for _, o in ipairs(workspace:GetChildren()) do
        if o:FindFirstChild("CoinContainer") and o:FindFirstChild("Spawns") then return o end
    end
end
local function reloadESP()
    clearESP()
    if not State.playerESP then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            if p == findMurderer() then createESP(p.Character, Color3.fromRGB(255,60,60), "Murderer")
            elseif p == findSheriff() then createESP(p.Character, Color3.fromRGB(60,150,255), "Sheriff")
            else createESP(p.Character, Color3.fromRGB(80,220,120)) end
        end
    end
end
local function shootMurderer()
    if findSheriff() ~= LP then notify("YunoHub", "You're not sheriff", 2) return end
    local murderer = findMurderer(); if not murderer or not murderer.Character then return end
    if not LP.Character:FindFirstChild("Gun") then
        if LP.Backpack:FindFirstChild("Gun") then LP.Character.Humanoid:EquipTool(LP.Backpack:FindFirstChild("Gun")) end
    end
    task.wait(0.1)
    local mHRP = murderer.Character:FindFirstChild("HumanoidRootPart"); if not mHRP then return end
    local pred = mHRP.Position + (mHRP.AssemblyLinearVelocity * (State.shootOffset / 15)) + (murderer.Character.Humanoid.MoveDirection * State.shootOffset)
    if LP.Character:FindFirstChild("Gun") then
        pcall(function() LP.Character.Gun.Shoot:FireServer(CFrame.new(LP.Character.RightHand.Position), CFrame.new(pred)) end)
    end
end
local function knifeThrow()
    if findMurderer() ~= LP then return end
    if not LP.Character:FindFirstChild("Knife") then
        if LP.Backpack:FindFirstChild("Knife") then LP.Character.Humanoid:EquipTool(LP.Backpack:FindFirstChild("Knife")) end
    end
    task.wait(0.1)
    local closest, minD = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                if d < minD then minD = d; closest = p end
            end
        end
    end
    if closest and closest.Character then
        local tHRP = closest.Character:FindFirstChild("HumanoidRootPart")
        pcall(function()
            LP.Character.Knife.Events.KnifeThrown:FireServer(
                CFrame.new(LP.Character.RightHand.Position),
                CFrame.new(tHRP.Position + tHRP.AssemblyLinearVelocity * (State.shootOffset / 15)))
        end)
    end
end
local function killClosest()
    if findMurderer() ~= LP then notify("YunoHub", "Not murderer", 2) return end
    if not LP.Character:FindFirstChild("Knife") and LP.Backpack:FindFirstChild("Knife") then
        LP.Character.Humanoid:EquipTool(LP.Backpack:FindFirstChild("Knife"))
    end
    task.wait(0.1)
    local closest, minD = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
            if d < minD then minD = d; closest = p end
        end
    end
    if closest then
        local hrp = closest.Character.HumanoidRootPart
        hrp.Anchored = true
        hrp.CFrame = LP.Character.HumanoidRootPart.CFrame + LP.Character.HumanoidRootPart.LookVector * 0
        hrp.CFrame = LP.Character.HumanoidRootPart.CFrame + LP.Character.HumanoidRootPart.CFrame.LookVector * 2
        task.wait(0.1)
        pcall(function() LP.Character.Knife.Stab:FireServer("Slash") end)
        task.wait(0.3)
        hrp.Anchored = false
    end
end

--═══════════════════════════════════════════════════════════════
-- PAGES (each renders into areaScroll)
--═══════════════════════════════════════════════════════════════
local activePage = "universal"
local pages = {}

pages.universal = function()
    clearArea()
    section("Flight", A.PLANE)
    toggle("op_fly", "OP Fly", A.PLANE, State.flyOn, function(v)
        State.flyOn = v
        if v then startFly() else stopFly() end
    end)
    range("Fly speed", 20, 300, State.flySpeed, function(v) State.flySpeed = v end)

    section("Movement", A.LIGHTNING)
    toggle("inf_jump", "Infinite Jump", A.LIGHTNING, State.infJump, function(v) State.infJump = v end)
    input("Walkspeed", "Set", function(v)
        local n = tonumber(v)
        if n and LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = n; State.ws = n end
        end
    end)
    btn("ws_up", "Walkspeed +2", A.STAR, function()
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then State.ws = State.ws + 2; h.WalkSpeed = State.ws end
    end)
    btn("ws_down", "Walkspeed -2", A.CROSS, function()
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then State.ws = State.ws - 2; h.WalkSpeed = State.ws end
    end)
    input("FOV", "Set", function(v)
        local n = tonumber(v)
        if n then workspace.CurrentCamera.FieldOfView = n; State.fov = n end
    end)
    toggle("loop_fov_ws", "Loop WS + FOV", A.LIGHTNING, State.loopFovWs, function(v) State.loopFovWs = v end)

    section("Hitbox", A.SKULL)
    input("Hitbox size (1 = normal)", "Set", function(v)
        local n = tonumber(v) or 1
        State.hitboxSize = n
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name == "HumanoidRootPart" then
                        part.Size = Vector3.new(n,n,n); part.Transparency = 0.3; part.CanCollide = false
                    end
                end
            end
        end
    end)
    toggle("loop_hitbox", "Loop Hitbox", A.SKULL, State.loopHitbox, function(v)
        State.loopHitbox = v
        if v then
            task.spawn(function()
                while State.loopHitbox do
                    task.wait(0.3)
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then
                            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.Size = Vector3.new(State.hitboxSize, State.hitboxSize, State.hitboxSize)
                                hrp.Transparency = 0.3
                            end
                        end
                    end
                end
            end)
        end
    end)

    section("Targets", A.TARGET)
    input("Player name to teleport", "TP", function(v)
        local t = getPlayerByName(v)
        if t and t.Character and LP.Character then
            LP.Character:PivotTo(CFrame.new(t.Character.HumanoidRootPart.Position + Vector3.new(0,3,0)))
        end
    end)
    input("Player name to fling", "Set target", function(v)
        local t = getPlayerByName(v)
        if t then State.targetPlayer = t; notify("YunoHub", "Target: "..t.Name, 3) end
    end)
    btn("fling", "Fling target", A.FIRE, function()
        if State.targetPlayer then
            task.spawn(flingTarget, State.targetPlayer)
            playSound(S.ALERT, 0.5)
        end
    end)

    section("Protection", A.SHIELD)
    toggle("anti_fling", "Anti-Fling", A.SHIELD, State.antiFling, function(v) State.antiFling = v end)
    toggle("noclip", "Noclip", A.WING, State.noclipOn, function(v)
        State.noclipOn = v
        if v then
            task.spawn(function()
                while State.noclipOn do
                    task.wait(0.15)
                    if LP.Character then
                        for _, p in ipairs(LP.Character:GetDescendants()) do
                            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                        end
                    end
                end
            end)
        end
    end)

    section("Misc", A.SETTINGS)
    btn("anti_afk", "Anti-AFK", A.SHIELD, function()
        local vu = game:GetService("VirtualUser")
        track(LP.Idled:Connect(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end))
        notify("YunoHub", "Anti-AFK enabled", 2)
    end)
    btn("fps_boost", "FPS Boost", A.LIGHTNING, function()
        local t = workspace:FindFirstChildOfClass("Terrain")
        if t then t.WaterWaveSize = 0; t.WaterWaveSpeed = 0; t.WaterReflectance = 0; t.WaterTransparency = 0 end
        game.Lighting.GlobalShadows = false
        game.Lighting.FogEnd = 9e9
        pcall(function() settings().Rendering.QualityLevel = 1 end)
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0) end
        end
        notify("YunoHub", "FPS Boost applied", 2)
    end)
    btn("get_ping", "Get ping", A.LIGHTNING, function()
        notify("YunoHub", "Ping: " .. math.floor(LP:GetNetworkPing() * 1000) .. " ms", 3)
    end)
end

pages.mm2 = function()
    clearArea()
    section("ESP", A.SEARCH)
    toggle("esp_players", "Player ESP", A.PERSON, State.playerESP, function(v)
        State.playerESP = v; reloadESP()
    end)
    toggle("esp_gun", "Dropped Gun ESP", A.GUN, State.gunDropESP, function(v) State.gunDropESP = v end)
    toggle("esp_trap", "Trap Detection", A.SKULL, State.trapDetection, function(v) State.trapDetection = v end)
    btn("esp_reload", "Reload ESP", A.STAR, function() reloadESP() end)

    section("Weapons", A.GUN)
    btn("shoot_instant", "Shoot murderer (instant)", A.GUN, function() shootMurderer() end)
    btn("shoot_delayed", "Shoot murderer (delayed)", A.TARGET, function()
        if findSheriff() ~= LP then notify("YunoHub", "Not sheriff", 2) return end
        task.spawn(function()
            for i = 1, 60 do
                task.wait(0.5)
                shootMurderer()
            end
        end)
    end)
    btn("knife_throw", "Knife throw to closest", A.KNIFE, function() knifeThrow() end)
    toggle("auto_knife", "Auto knife throw", A.KNIFE, State.loopThrow, function(v)
        State.loopThrow = v
        if v then
            task.spawn(function()
                while State.loopThrow do
                    task.wait(1.5)
                    pcall(knifeThrow)
                end
            end)
        end
    end)
    toggle("auto_shoot", "Auto-shoot murderer", A.TARGET, State.autoShooting, function(v)
        State.autoShooting = v
        if v then
            task.spawn(function()
                while State.autoShooting do
                    task.wait(1)
                    pcall(shootMurderer)
                end
            end)
        end
    end)
    range("Shoot offset", 1, 5, State.shootOffset, function(v) State.shootOffset = v end)

    section("Attacks", A.FIRE)
    btn("kill_closest", "Kill closest (murderer)", A.SKULL, function() killClosest() end)
    toggle("kill_aura", "Kill aura (murderer)", A.FIRE, State.killAura, function(v)
        State.killAura = v
        if v then
            task.spawn(function()
                while State.killAura do
                    task.wait(0.1)
                    if findMurderer() == LP and LP.Character:FindFirstChild("Knife") then
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local hrp = p.Character.HumanoidRootPart
                                if (hrp.Position - LP.Character.HumanoidRootPart.Position).Magnitude < 7 then
                                    hrp.Anchored = true
                                    hrp.CFrame = LP.Character.HumanoidRootPart.CFrame + LP.Character.HumanoidRootPart.CFrame.LookVector * 2
                                    task.wait(0.1)
                                    pcall(function() LP.Character.Knife.Stab:FireServer("Slash") end)
                                    task.wait(0.3)
                                    hrp.Anchored = false
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)

    section("Fling", A.FIRE)
    btn("fling_sheriff", "Fling Sheriff", A.FIRE, function()
        local s = findSheriff(); if s then task.spawn(flingTarget, s) end
    end)
    btn("fling_murderer", "Fling Murderer", A.FIRE, function()
        local m = findMurderer(); if m then task.spawn(flingTarget, m) end
    end)

    section("Teleport", A.TARGET)
    btn("tp_lobby", "TP to Lobby", A.HOME, function()
        local lobby = workspace:FindFirstChild("Lobby")
        if lobby and lobby:FindFirstChild("Spawns") then
            local sp = lobby.Spawns:FindFirstChildWhichIsA("SpawnLocation")
            if sp and LP.Character then LP.Character:PivotTo(CFrame.new(sp.Position + Vector3.new(0,3,0))) end
        end
    end)
    btn("tp_map", "TP to Map", A.PLANE, function()
        local map = getMap()
        if map and map:FindFirstChild("Spawns") and LP.Character then
            local sps = map.Spawns:GetChildren()
            if #sps > 0 then
                local sp = sps[math.random(1, #sps)]
                LP.Character:PivotTo(CFrame.new(sp.Position + Vector3.new(0,3,0)))
            end
        end
    end)
    btn("tp_gun", "TP to dropped gun", A.GUN, function()
        local map = getMap()
        if map and map:FindFirstChild("GunDrop") and LP.Character then
            local prev = LP.Character:GetPivot()
            LP.Character:PivotTo(map.GunDrop:GetPivot())
            task.wait(0.2)
            if LP.Backpack:FindFirstChild("Gun") then LP.Character.Humanoid:EquipTool(LP.Backpack.Gun) end
            LP.Character:PivotTo(prev)
        end
    end)
    toggle("auto_gun", "Auto get gun on drop", A.GUN, State.autoGetGun, function(v) State.autoGetGun = v end)

    section("Fun", A.STAR)
    btn("chat_roles", "Send roles in chat", A.SEARCH, function()
        local m = findMurderer(); local s = findSheriff()
        local txt = "Murderer: " .. (m and m.Name or "-") .. " | Sheriff: " .. (s and s.Name or "-")
        local tc = game:GetService("TextChatService")
        if tc then
            for _, ch in ipairs(tc:WaitForChild("TextChannels"):GetChildren()) do
                if ch.Name ~= "RBXSystem" then pcall(function() ch:SendAsync(txt) end) end
            end
        end
    end)
    btn("copy_murd", "Copy murderer name", A.CROSS, function()
        local m = findMurderer()
        if m and setclipboard then setclipboard(m.Name); notify("YunoHub", "Copied: "..m.Name, 3) end
    end)
    btn("copy_sher", "Copy sheriff name", A.CROSS, function()
        local s = findSheriff()
        if s and setclipboard then setclipboard(s.Name); notify("YunoHub", "Copied: "..s.Name, 3) end
    end)
end

pages.themes = function()
    clearArea()
    section("Themes", A.PALETTE)
    for key, th in pairs(THEMES) do
        local b = Instance.new("TextButton", areaScroll)
        b.Size = UDim2.new(1, -6, 0, 42)
        b.BackgroundColor3 = th.section
        b.BorderSizePixel = 0
        b.Text = ""
        b.AutoButtonColor = false
        b.LayoutOrder = #areaScroll:GetChildren()

        local c = Instance.new("UICorner", b)
        c.CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", b)
        s.Color = th.accent
        s.Thickness = 2
        s.Transparency = (key == currentTheme) and 0 or 0.6

        mkImage(b, th.icon, UDim2.new(0, 24, 0, 24), UDim2.new(0, 8, 0.5, -12), th.accent)

        local tl = Instance.new("TextLabel", b)
        tl.Size = UDim2.new(1, -110, 1, 0)
        tl.Position = UDim2.new(0, 40, 0, 0)
        tl.BackgroundTransparency = 1
        tl.Text = th.name
        tl.TextColor3 = th.text
        tl.Font = Enum.Font.GothamBlack
        tl.TextSize = 12
        tl.TextXAlignment = Enum.TextXAlignment.Left

        for i = 1, 3 do
            local dot = Instance.new("Frame", b)
            dot.Size = UDim2.new(0, 12, 0, 12)
            dot.Position = UDim2.new(1, -55 + (i-1)*16, 0.5, -6)
            dot.BorderSizePixel = 0
            dot.BackgroundColor3 = i == 1 and th.accent or (i == 2 and th.accent2 or th.bg1)
            local dc = Instance.new("UICorner", dot)
            dc.CornerRadius = UDim.new(1, 0)
            local ds = Instance.new("UIStroke", dot)
            ds.Color = th.text
            ds.Thickness = 1
            ds.Transparency = 0.5
        end

        onClick(b, function()
            playSound(S.SUCCESS, 0.5, 1.2)
            applyTheme(key)
            notify("YunoHub", "Theme: " .. th.name, 2)
            pages.themes()
        end)
    end
end

local currentMusicIdx = nil
pages.music = function()
    clearArea()
    section("ASMR Music", A.MUSIC)
    for i, track in ipairs(MUSIC) do
        local b = Instance.new("TextButton", areaScroll)
        b.Size = UDim2.new(1, -6, 0, 40)
        b.BackgroundColor3 = T.section
        b.BorderSizePixel = 0
        b.Text = ""
        b.AutoButtonColor = false
        b.LayoutOrder = #areaScroll:GetChildren()

        local c = Instance.new("UICorner", b)
        c.CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", b)
        s.Color = T.accent
        s.Thickness = 1
        s.Transparency = (currentMusicIdx == i) and 0 or 0.6

        mkImage(b, track.icon or A.MUSIC, UDim2.new(0, 20, 0, 20), UDim2.new(0, 8, 0.5, -10), T.accent2)

        local l = Instance.new("TextLabel", b)
        l.Size = UDim2.new(1, -40, 1, 0)
        l.Position = UDim2.new(0, 36, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = track.name
        l.TextColor3 = T.text
        l.Font = Enum.Font.GothamBold
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left

        onClick(b, function()
            if currentMusicIdx == i then
                if _G.YunoMusic then _G.YunoMusic:Destroy(); _G.YunoMusic = nil end
                currentMusicIdx = nil
                playSound(S.CLOSE, 0.4)
            else
                if _G.YunoMusic then _G.YunoMusic:Destroy() end
                local mus = Instance.new("Sound")
                mus.SoundId = track.id
                mus.Volume = track.vol
                mus.Looped = true
                mus.Parent = SoundService
                mus:Play()
                _G.YunoMusic = mus
                currentMusicIdx = i
                playSound(S.SUCCESS, 0.5, 1.2)
            end
            pages.music()
        end)
    end

    section("Sounds", A.LIGHTNING)
    toggle("asmr_on", "ASMR UI sounds", A.SPARKLE, ASMR_ON, function(v) ASMR_ON = v end)
    toggle("particles_on", "Golden particles", A.SPARKLE, PARTICLES_ON, function(v) PARTICLES_ON = v end)
    btn("stop_music", "Stop all music", A.CROSS, function()
        if _G.YunoMusic then _G.YunoMusic:Destroy(); _G.YunoMusic = nil end
        currentMusicIdx = nil
        notify("YunoHub", "Music stopped", 2)
    end)
end

pages.settings = function()
    clearArea()
    section("Pinned buttons", A.PIN)
    local info = Instance.new("Frame", areaScroll)
    info.Size = UDim2.new(1, -6, 0, 84)
    info.BackgroundColor3 = T.section
    info.BorderSizePixel = 0
    info.LayoutOrder = #areaScroll:GetChildren()
    local ic = Instance.new("UICorner", info)
    ic.CornerRadius = UDim.new(0, 8)

    local il = Instance.new("TextLabel", info)
    il.Size = UDim2.new(1, -16, 1, 0)
    il.Position = UDim2.new(0, 8, 0, 0)
    il.BackgroundTransparency = 1
    il.Text = "Tap = trigger\nLong-press button = pin it\nLong-press pin = remove it"
    il.TextColor3 = T.text
    il.Font = Enum.Font.GothamBold
    il.TextSize = 11
    il.TextXAlignment = Enum.TextXAlignment.Left
    il.TextYAlignment = Enum.TextYAlignment.Center
    il.TextWrapped = true

    btn("clear_all_floats", "Remove all pinned", A.CROSS, function()
        for k, fb in pairs(floatingButtons) do
            if fb.Parent then fb:Destroy() end
            floatingButtons[k] = nil
        end
        notify("YunoHub", "All pinned removed", 2)
    end)

    section("Info", A.SETTINGS)
    btn("open_console", "Open dev console", A.SEARCH, function()
        game.StarterGui:SetCore("DevConsoleVisible", true)
    end)
    btn("hide_hub", "Hide hub", A.CROSS, minimizeHub)
end

--═══════════════════════════════════════════════════════════════
-- APPLY THEME
--═══════════════════════════════════════════════════════════════
function applyTheme(key)
    local th = THEMES[key]
    if not th then return end
    currentTheme = key
    T = th

    Menu.BackgroundColor3 = T.bg1
    MenuGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, T.bg1), ColorSequenceKeypoint.new(1, T.bg2) })
    MenuStroke.Color = T.accent
    MenuStrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.bg1),
        ColorSequenceKeypoint.new(0.2, T.accent),
        ColorSequenceKeypoint.new(0.5, T.accent2),
        ColorSequenceKeypoint.new(0.8, T.accent),
        ColorSequenceKeypoint.new(1, T.bg1)
    })

    hubName.TextColor3 = T.accent
    version.TextColor3 = T.textDim
    hubDesc.TextColor3 = T.textDim
    closeBtn.BackgroundColor3 = T.panel
    closeBtn.TextColor3 = T.accent
    closeArea.BackgroundColor3 = T.accent

    List.BackgroundColor3 = T.panel
    Area.BackgroundColor3 = T.panel
    areaScroll.ScrollBarImageColor3 = T.accent

    footer.BackgroundColor3 = T.bg2
    fLine.BackgroundColor3 = T.accent
    fLbl.TextColor3 = T.accent2

    opener.BackgroundColor3 = T.panel
    opStroke.Color = T.accent

    -- Sidebar tab buttons
    for _, child in ipairs(listScroll:GetChildren()) do
        if child:IsA("TextButton") then
            local isActive = (child:GetAttribute("pageId") == activePage)
            local st = child:FindFirstChildWhichIsA("UIStroke")
            local lbl = child:FindFirstChildWhichIsA("TextLabel")
            local ic = child:FindFirstChildWhichIsA("ImageLabel")
            if isActive then
                child.BackgroundColor3 = T.panelHover
                if st then st.Color = T.accent; st.Transparency = 0 end
                if lbl then lbl.TextColor3 = T.accent end
                if ic then ic.ImageColor3 = T.accent2 end
            else
                child.BackgroundColor3 = T.section
                if st then st.Color = T.accent; st.Transparency = 1 end
                if lbl then lbl.TextColor3 = T.textDim end
                if ic then ic.ImageColor3 = T.textDim end
            end
        end
    end

    if pages[activePage] then pages[activePage]() end
end

--═══════════════════════════════════════════════════════════════
-- SIDEBAR TABS
--═══════════════════════════════════════════════════════════════
local function createTabButton(pageId, label, iconId)
    local b = Instance.new("TextButton", listScroll)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = T.section
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.LayoutOrder = #listScroll:GetChildren()
    b:SetAttribute("pageId", pageId)

    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Color = T.accent
    s.Thickness = 1
    s.Transparency = 1

    mkImage(b, iconId, UDim2.new(0, 18, 0, 18), UDim2.new(0, 6, 0.5, -9), T.textDim)

    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.new(1, -28, 1, 0)
    l.Position = UDim2.new(0, 26, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = T.textDim
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left

    local function activate()
        if activePage == pageId then return end
        playSound(S.TAB, 0.4, 1.1 + math.random() * 0.1)
        activePage = pageId
        for _, child in ipairs(listScroll:GetChildren()) do
            if child:IsA("TextButton") then
                local isA = (child:GetAttribute("pageId") == activePage)
                local st = child:FindFirstChildWhichIsA("UIStroke")
                local lbl = child:FindFirstChildWhichIsA("TextLabel")
                local ic = child:FindFirstChildWhichIsA("ImageLabel")
                if isA then
                    child.BackgroundColor3 = T.panelHover
                    if st then st.Transparency = 0 end
                    if lbl then lbl.TextColor3 = T.accent end
                    if ic then ic.ImageColor3 = T.accent2 end
                else
                    child.BackgroundColor3 = T.section
                    if st then st.Transparency = 1 end
                    if lbl then lbl.TextColor3 = T.textDim end
                    if ic then ic.ImageColor3 = T.textDim end
                end
            end
        end
        if pages[pageId] then pages[pageId]() end
    end

    onClick(b, activate)
end

createTabButton("universal", "Universal", A.STAR)
createTabButton("mm2", "MM2", A.KNIFE)
createTabButton("themes", "Themes", A.PALETTE)
createTabButton("music", "Music", A.MUSIC)
createTabButton("settings", "Settings", A.SETTINGS)

-- Activate first tab
activePage = "universal"
for _, child in ipairs(listScroll:GetChildren()) do
    if child:IsA("TextButton") and child:GetAttribute("pageId") == "universal" then
        child.BackgroundColor3 = T.panelHover
        local st = child:FindFirstChildWhichIsA("UIStroke"); if st then st.Transparency = 0 end
        local lbl = child:FindFirstChildWhichIsA("TextLabel"); if lbl then lbl.TextColor3 = T.accent end
        local ic = child:FindFirstChildWhichIsA("ImageLabel"); if ic then ic.ImageColor3 = T.accent2 end
    end
end
pages.universal()

--═══════════════════════════════════════════════════════════════
-- GLOBAL LOOPS
--═══════════════════════════════════════════════════════════════
track(UserInputService.JumpRequest:Connect(function()
    if State.infJump and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

track(RunService.RenderStepped:Connect(function()
    if State.loopFovWs and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = State.ws end
        workspace.CurrentCamera.FieldOfView = State.fov
    end
end))

track(LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.flyOn then startFly() end
    if State.playerESP then reloadESP() end
end))

--═══════════════════════════════════════════════════════════════
-- START
--═══════════════════════════════════════════════════════════════
notify("YUNO HUB v6.0", "Mobile Edition · ready", 4)
playSound(S.SUCCESS, 0.6, 1.2)

print([[
YUNO HUB v6.0 · Mobile Edition
- Original layout style, more tuff
- Universal + MM2 + Themes + Music
- Long-press any button to pin on screen
]])