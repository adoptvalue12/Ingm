--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║   ██╗   ██╗██╗   ██╗███╗   ██╗ ██████╗                       ║
    ║   ╚██╗ ██╔╝██║   ██║████╗  ██║██╔═══██╗                      ║
    ║    ╚████╔╝ ██║   ██║██╔██╗ ██║██║   ██║                      ║
    ║     ╚██╔╝  ██║   ██║██║╚██╗██║██║   ██║                      ║
    ║      ██║   ╚██████╔╝██║ ╚████║╚██████╔╝                      ║
    ║      ╚═╝    ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝                       ║
    ║                                                               ║
    ║           H U B   v 3 . 0   ·   G O L D E N                   ║
    ║                  A S M R   E D I T I O N                      ║
    ║                                                               ║
    ║   Universal  ·  Murder Mystery 2  ·  Themes  ·  ASMR          ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

--═══════════════════════════════════════════════════════════════
-- SERVICES
--═══════════════════════════════════════════════════════════════
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local SoundService     = game:GetService("SoundService")
local StarterGui       = game:GetService("StarterGui")
local HttpService      = game:GetService("HttpService")

local LP    = Players.LocalPlayer
local Mouse = LP:GetMouse()

--═══════════════════════════════════════════════════════════════
-- ASSETS
--═══════════════════════════════════════════════════════════════
local A = {
    -- Images
    LOGO        = "rbxassetid://11322093471",
    SHIELD      = "rbxassetid://11322093471",
    CROWN       = "rbxassetid://95046902556786",
    STAR        = "rbxassetid://6031075931",
    SPARKLE     = "rbxassetid://280259692",
    LIGHTNING   = "rbxassetid://4907816507",
    FIRE        = "rbxassetid://4934971481",
    WING        = "rbxassetid://7708223964",
    CROSS       = "rbxassetid://6047530871",
    CHECK       = "rbxassetid://6031091004",
    DIAMOND     = "rbxassetid://6034684930",
    SWORD       = "rbxassetid://4913393055",
    SKULL       = "rbxassetid://6047530871",
    HOME        = "rbxassetid://6031075931",
    SETTINGS    = "rbxassetid://6034684930",
    MUSIC       = "rbxassetid://1837879082",
    PALETTE     = "rbxassetid://6031091004",
    GUN         = "rbxassetid://4913393055",
    KNIFE       = "rbxassetid://4913393055",
    TARGET      = "rbxassetid://4907816507",
    PLANE       = "rbxassetid://7708223964",
    PERSON      = "rbxassetid://6031075931",
    SEARCH      = "rbxassetid://6031091004",
    COIN        = "rbxassetid://6034684930",
    ROBLOX      = "rbxassetid://6031075931",
    MEDKIT      = "rbxassetid://6047530871",
    GEN         = "rbxassetid://4907816507",
    -- Sons ASMR
    CLICK       = "rbxassetid://876939830",
    HOVER       = "rbxassetid://6042053626",
    TICK        = "rbxassetid://9125402604",
    SUCCESS     = "rbxassetid://2865227271",
    OPEN        = "rbxassetid://6895079853",
    CLOSE       = "rbxassetid://6042053626",
    WHOOSH      = "rbxassetid://5150307161",
    ERROR       = "rbxassetid://6114958611",
    SPARKLE     = "rbxassetid://9125402604",
    TAB         = "rbxassetid://5150307161",
    ALERT       = "rbxassetid://6114958611",
}

-- Pistes ASMR (musique d'ambiance)
local MUSIC_TRACKS = {
    { name = "Dreamy Piano",   id = "rbxassetid://1837879082",  vol = 0.15 },
    { name = "Soft Pads",      id = "rbxassetid://1841647092",  vol = 0.15 },
    { name = "Deep Focus",     id = "rbxassetid://9046817222",  vol = 0.15 },
    { name = "Chill Lo-Fi",    id = "rbxassetid://1836375780",  vol = 0.15 },
    { name = "Rainfall",       id = "rbxassetid://131886780",   vol = 0.20 },
    { name = "Crystal Chimes", id = "rbxassetid://1842752035",  vol = 0.15 },
}

--═══════════════════════════════════════════════════════════════
-- THÈMES
--═══════════════════════════════════════════════════════════════
local THEMES = {
    GOLDEN_ROYAL = {
        name = "Golden Royal",
        icon = "rbxassetid://11322093471",
        accent = Color3.fromRGB(255, 200, 50),
        accent2 = Color3.fromRGB(255, 230, 130),
        text = Color3.fromRGB(255, 240, 210),
        textDim = Color3.fromRGB(180, 165, 130),
        bg1 = Color3.fromRGB(30, 24, 14),
        bg2 = Color3.fromRGB(14, 12, 8),
        panel = Color3.fromRGB(24, 20, 14),
        panelHover = Color3.fromRGB(40, 32, 20),
        section = Color3.fromRGB(32, 26, 16),
    },
    CYBER_NEON = {
        name = "Cyber Neon",
        icon = "rbxassetid://4907816507",
        accent = Color3.fromRGB(0, 255, 220),
        accent2 = Color3.fromRGB(130, 255, 240),
        text = Color3.fromRGB(220, 255, 255),
        textDim = Color3.fromRGB(130, 180, 190),
        bg1 = Color3.fromRGB(14, 22, 32),
        bg2 = Color3.fromRGB(5, 10, 18),
        panel = Color3.fromRGB(12, 20, 30),
        panelHover = Color3.fromRGB(20, 40, 55),
        section = Color3.fromRGB(18, 30, 42),
    },
    BLOOD_MOON = {
        name = "Blood Moon",
        icon = "rbxassetid://4934971481",
        accent = Color3.fromRGB(220, 30, 40),
        accent2 = Color3.fromRGB(255, 100, 100),
        text = Color3.fromRGB(255, 220, 220),
        textDim = Color3.fromRGB(180, 120, 120),
        bg1 = Color3.fromRGB(32, 10, 12),
        bg2 = Color3.fromRGB(15, 5, 8),
        panel = Color3.fromRGB(26, 10, 12),
        panelHover = Color3.fromRGB(50, 15, 20),
        section = Color3.fromRGB(38, 14, 18),
    },
    OCEAN_DEEP = {
        name = "Ocean Deep",
        icon = "rbxassetid://6034684930",
        accent = Color3.fromRGB(80, 180, 255),
        accent2 = Color3.fromRGB(160, 220, 255),
        text = Color3.fromRGB(220, 240, 255),
        textDim = Color3.fromRGB(130, 160, 190),
        bg1 = Color3.fromRGB(12, 22, 40),
        bg2 = Color3.fromRGB(5, 10, 22),
        panel = Color3.fromRGB(12, 22, 38),
        panelHover = Color3.fromRGB(22, 42, 68),
        section = Color3.fromRGB(18, 32, 52),
    },
    GALAXY_PURPLE = {
        name = "Galaxy Purple",
        icon = "rbxassetid://6031075931",
        accent = Color3.fromRGB(180, 100, 255),
        accent2 = Color3.fromRGB(220, 170, 255),
        text = Color3.fromRGB(240, 220, 255),
        textDim = Color3.fromRGB(170, 140, 200),
        bg1 = Color3.fromRGB(25, 14, 40),
        bg2 = Color3.fromRGB(10, 6, 22),
        panel = Color3.fromRGB(22, 14, 36),
        panelHover = Color3.fromRGB(42, 26, 68),
        section = Color3.fromRGB(32, 20, 50),
    },
    NEON_PINK = {
        name = "Neon Pink",
        icon = "rbxassetid://280259692",
        accent = Color3.fromRGB(255, 60, 180),
        accent2 = Color3.fromRGB(255, 140, 220),
        text = Color3.fromRGB(255, 220, 240),
        textDim = Color3.fromRGB(200, 130, 170),
        bg1 = Color3.fromRGB(32, 12, 28),
        bg2 = Color3.fromRGB(15, 5, 15),
        panel = Color3.fromRGB(28, 12, 26),
        panelHover = Color3.fromRGB(50, 20, 45),
        section = Color3.fromRGB(38, 16, 34),
    },
    EMERALD = {
        name = "Emerald",
        icon = "rbxassetid://6031091004",
        accent = Color3.fromRGB(60, 220, 130),
        accent2 = Color3.fromRGB(140, 255, 180),
        text = Color3.fromRGB(220, 255, 230),
        textDim = Color3.fromRGB(130, 180, 150),
        bg1 = Color3.fromRGB(12, 28, 20),
        bg2 = Color3.fromRGB(5, 15, 10),
        panel = Color3.fromRGB(12, 26, 20),
        panelHover = Color3.fromRGB(20, 45, 35),
        section = Color3.fromRGB(18, 36, 26),
    },
}

local currentTheme = "GOLDEN_ROYAL"
local T = THEMES[currentTheme]
local ASMR_ON = true
local PARTICLES_ON = true

--═══════════════════════════════════════════════════════════════
-- ÉTAT GLOBAL
--═══════════════════════════════════════════════════════════════
local State = {
    -- Universal
    flyOn = false,
    flySpeed = 50,
    infJump = false,
    infJumpOnlyTwo = false,
    hitboxSize = 1,
    loopHitbox = false,
    aggressiveHitbox = false,
    ws = 16,
    fov = 70,
    loopFovWs = false,
    ctrlClickTp = false,
    aimlockTarget = nil,
    aimlockOn = false,
    playerToFling = nil,
    antiFling = false,
    wsIncrement = 2,
    noclipOn = false,
    -- MM2
    playerESP = false,
    gunDropESP = false,
    trapDetection = false,
    hideMeESP = false,
    autoShooting = false,
    shootOffset = 2.8,
    offsetToPingMult = 1,
    instakill = false,
    spawnAtPlayer = false,
    loopThrow = false,
    autoGetGun = false,
    coinFarm = false,
    killAura = false,
    roundTimer = false,
}

local connections = {}
local function track(c) table.insert(connections, c); return c end

--═══════════════════════════════════════════════════════════════
-- UTILITAIRES
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
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = dur or 3,
        })
    end)
end

local function image(parent, id, size, pos, color)
    local i = Instance.new("ImageLabel", parent)
    i.BackgroundTransparency = 1
    i.Image = id
    i.ImageColor3 = color or T.accent
    i.ScaleType = Enum.ScaleType.Fit
    if size then i.Size = size end
    if pos then i.Position = pos end
    return i
end

--═══════════════════════════════════════════════════════════════
-- ANIMATION DE CHARGEMENT
--═══════════════════════════════════════════════════════════════
local function loadingScreen()
    local g = Instance.new("ScreenGui")
    g.Name = "YunoLoading"
    g.IgnoreGuiInset = true
    g.ResetOnSpawn = false
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = LP:WaitForChild("PlayerGui") end

    local bg = Instance.new("Frame", g)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 1

    local logo = image(g, A.SHIELD, UDim2.new(0, 160, 0, 160), UDim2.new(0.5, -80, 0.42, -160), T.accent2)
    logo.ImageTransparency = 1

    local label = Instance.new("TextLabel", g)
    label.Size = UDim2.new(0, 500, 0, 90)
    label.Position = UDim2.new(0.5, -250, 0.5, -15)
    label.BackgroundTransparency = 1
    label.Text = ""
    label.TextColor3 = T.accent
    label.Font = Enum.Font.GothamBlack
    label.TextScaled = true
    label.TextTransparency = 1

    local shadow = label:Clone()
    shadow.Position = UDim2.new(0.5, -248, 0.5, -13)
    shadow.TextColor3 = T.bg1
    shadow.ZIndex = 0
    shadow.Parent = g

    local line = Instance.new("Frame", g)
    line.Size = UDim2.new(0, 0, 0, 2)
    line.Position = UDim2.new(0.5, 0, 0.5, 70)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = T.accent
    line.BorderSizePixel = 0

    TweenService:Create(bg, TweenInfo.new(0.8), { BackgroundTransparency = 0.3 }):Play()
    TweenService:Create(logo, TweenInfo.new(0.8), { ImageTransparency = 0 }):Play()
    TweenService:Create(label, TweenInfo.new(0.8), { TextTransparency = 0 }):Play()
    TweenService:Create(shadow, TweenInfo.new(0.8), { TextTransparency = 0.7 }):Play()
    TweenService:Create(line, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {
        Size = UDim2.new(0, 420, 0, 2)
    }):Play()

    task.wait(0.9)

    local txt = "YUNO HUB"
    for i = 1, #txt do
        label.Text = string.sub(txt, 1, i)
        shadow.Text = string.sub(txt, 1, i)
        playSound(A.TICK, 0.3, 0.8 + math.random() * 0.4)
        task.wait(0.07)
    end

    task.wait(0.3)

    local sub = Instance.new("TextLabel", g)
    sub.Size = UDim2.new(0, 500, 0, 28)
    sub.Position = UDim2.new(0.5, -250, 0.5, 95)
    sub.BackgroundTransparency = 1
    sub.Text = "✦ Golden ASMR Edition · v3.0 ✦"
    sub.TextColor3 = T.accent2
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 15
    sub.TextTransparency = 1
    TweenService:Create(sub, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()

    task.wait(1.3)
    TweenService:Create(label, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
    TweenService:Create(shadow, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
    TweenService:Create(sub, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
    TweenService:Create(logo, TweenInfo.new(0.5), { ImageTransparency = 1 }):Play()
    TweenService:Create(bg, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(line, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    task.wait(0.6)
    g:Destroy()
end

loadingScreen()

--═══════════════════════════════════════════════════════════════
-- CRÉATION UI PRINCIPALE
--═══════════════════════════════════════════════════════════════
pcall(function() CoreGui.YunoHubV3:Destroy() end)

local gui = Instance.new("ScreenGui")
gui.Name = "YunoHubV3"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

-- Fenêtre principale
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 640, 0, 440)
main.Position = UDim2.new(0.5, -320, 0.5, -220)
main.BackgroundColor3 = T.bg1
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 16)

local mainGrad = Instance.new("UIGradient", main)
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.bg1),
    ColorSequenceKeypoint.new(1, T.bg2)
})
mainGrad.Rotation = 90

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = T.accent
mainStroke.Thickness = 2

local glowStroke = Instance.new("UIStroke", main)
glowStroke.Color = T.accent2
glowStroke.Thickness = 1
glowStroke.Transparency = 0.6

task.spawn(function()
    while main.Parent do
        TweenService:Create(glowStroke, TweenInfo.new(1.5), { Transparency = 0.9 }):Play()
        task.wait(1.5)
        if not main.Parent then break end
        TweenService:Create(glowStroke, TweenInfo.new(1.5), { Transparency = 0.3 }):Play()
        task.wait(1.5)
    end
end)

-- Particles background
local particles = {}
local function spawnParticle()
    if not PARTICLES_ON then return end
    local p = Instance.new("Frame", main)
    p.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
    p.BackgroundColor3 = T.accent
    p.BorderSizePixel = 0
    p.BackgroundTransparency = 0.4
    p.ZIndex = 0
    local pc = Instance.new("UICorner", p)
    pc.CornerRadius = UDim.new(1, 0)

    local sx = math.random(0, 640)
    local ex = sx + math.random(-100, 100)
    p.Position = UDim2.new(0, sx, 1, 0)

    TweenService:Create(p, TweenInfo.new(math.random(8, 15), Enum.EasingStyle.Linear), {
        Position = UDim2.new(0, ex, 0, -30),
        BackgroundTransparency = 1,
    }):Play()
    task.delay(16, function() if p.Parent then p:Destroy() end end)
end

task.spawn(function()
    while main.Parent do
        spawnParticle()
        task.wait(math.random(4, 10) / 10)
    end
end)

--═══════════════════════════════════════════════════════════════
-- TOP BAR
--═══════════════════════════════════════════════════════════════
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 58)
topBar.BackgroundColor3 = T.panel
topBar.BorderSizePixel = 0

local tbGrad = Instance.new("UIGradient", topBar)
tbGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.panelHover),
    ColorSequenceKeypoint.new(1, T.panel),
})
tbGrad.Rotation = 90

local tbLine = Instance.new("Frame", topBar)
tbLine.Size = UDim2.new(1, 0, 0, 2)
tbLine.Position = UDim2.new(0, 0, 1, -2)
tbLine.BackgroundColor3 = T.accent
tbLine.BorderSizePixel = 0

local topLogo = image(topBar, A.SHIELD, UDim2.new(0, 42, 0, 42), UDim2.new(0, 10, 0, 8), T.accent2)

local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Size = UDim2.new(0, 300, 0, 24)
titleLbl.Position = UDim2.new(0, 58, 0, 9)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "YUNO HUB"
titleLbl.TextColor3 = T.accent
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 22
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local subLbl = Instance.new("TextLabel", topBar)
subLbl.Size = UDim2.new(0, 300, 0, 14)
subLbl.Position = UDim2.new(0, 60, 0, 34)
subLbl.BackgroundTransparency = 1
subLbl.Text = "✦ Golden ASMR Edition ✦"
subLbl.TextColor3 = T.accent2
subLbl.Font = Enum.Font.GothamBold
subLbl.TextSize = 10
subLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Boutons topbar (minimize / close)
local function makeTopBtn(txt, xPos, callback)
    local b = Instance.new("TextButton", topBar)
    b.Size = UDim2.new(0, 30, 0, 30)
    b.Position = UDim2.new(1, xPos, 0, 14)
    b.BackgroundColor3 = T.panel
    b.BorderSizePixel = 0
    b.Text = txt
    b.TextColor3 = T.accent
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.AutoButtonColor = false
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Color = T.accent
    s.Thickness = 1
    s.Transparency = 0.5
    b.MouseEnter:Connect(function()
        playSound(A.HOVER, 0.12, 1.5)
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.panelHover }):Play()
        TweenService:Create(s, TweenInfo.new(0.15), { Transparency = 0 }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.panel }):Play()
        TweenService:Create(s, TweenInfo.new(0.15), { Transparency = 0.5 }):Play()
    end)
    b.MouseButton1Click:Connect(function()
        playSound(A.CLICK, 0.4)
        callback()
    end)
    return b
end

makeTopBtn("—", -72, function()
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Size = UDim2.new(0, 640, 0, 58)
    }):Play()
end)

makeTopBtn("✕", -36, function()
    playSound(A.CLOSE, 0.5)
    local restoreBtn = Instance.new("TextButton", gui)
    restoreBtn.Size = UDim2.new(0, 60, 0, 60)
    restoreBtn.Position = UDim2.new(0, 20, 0.5, -30)
    restoreBtn.BackgroundColor3 = T.panel
    restoreBtn.Text = ""
    restoreBtn.AutoButtonColor = false
    restoreBtn.BorderSizePixel = 0
    local rc = Instance.new("UICorner", restoreBtn)
    rc.CornerRadius = UDim.new(1, 0)
    local rs = Instance.new("UIStroke", restoreBtn)
    rs.Color = T.accent
    rs.Thickness = 2
    image(restoreBtn, A.SHIELD, UDim2.new(0, 40, 0, 40), UDim2.new(0.5, -20, 0.5, -20), T.accent2)

    task.spawn(function()
        while restoreBtn.Parent do
            TweenService:Create(rs, TweenInfo.new(1), { Transparency = 0.7 }):Play()
            task.wait(1)
            if not restoreBtn.Parent then break end
            TweenService:Create(rs, TweenInfo.new(1), { Transparency = 0 }):Play()
            task.wait(1)
        end
    end)

    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.4)
    main.Visible = false

    restoreBtn.MouseEnter:Connect(function() playSound(A.HOVER, 0.2, 1.4) end)
    restoreBtn.MouseButton1Click:Connect(function()
        playSound(A.OPEN, 0.5)
        main.Visible = true
        main.Size = UDim2.new(0, 0, 0, 0)
        main.Position = UDim2.new(0.5, -320, 0.5, -220)
        TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 640, 0, 440)
        }):Play()
        restoreBtn:Destroy()
    end)
end)

--═══════════════════════════════════════════════════════════════
-- DRAG
--═══════════════════════════════════════════════════════════════
local dragging, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                  startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

--═══════════════════════════════════════════════════════════════
-- SIDEBAR (tabs)
--═══════════════════════════════════════════════════════════════
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 140, 1, -86)
sidebar.Position = UDim2.new(0, 8, 0, 64)
sidebar.BackgroundColor3 = T.panel
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
local sbCorner = Instance.new("UICorner", sidebar)
sbCorner.CornerRadius = UDim.new(0, 12)

local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local sidebarPad = Instance.new("UIPadding", sidebar)
sidebarPad.PaddingTop = UDim.new(0, 8)

--═══════════════════════════════════════════════════════════════
-- CONTENT AREA
--═══════════════════════════════════════════════════════════════
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -156, 1, -86)
content.Position = UDim2.new(0, 148, 0, 64)
content.BackgroundColor3 = T.panel
content.BackgroundTransparency = 0.5
content.BorderSizePixel = 0
local cc = Instance.new("UICorner", content)
cc.CornerRadius = UDim.new(0, 12)

local scroll = Instance.new("ScrollingFrame", content)
scroll.Size = UDim2.new(1, -12, 1, -12)
scroll.Position = UDim2.new(0, 6, 0, 6)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = T.accent
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local scrollLayout = Instance.new("UIListLayout", scroll)
scrollLayout.Padding = UDim.new(0, 6)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder

--═══════════════════════════════════════════════════════════════
-- FOOTER
--═══════════════════════════════════════════════════════════════
local footer = Instance.new("Frame", main)
footer.Size = UDim2.new(1, 0, 0, 22)
footer.Position = UDim2.new(0, 0, 1, -22)
footer.BackgroundColor3 = T.bg2
footer.BorderSizePixel = 0

local fLine = Instance.new("Frame", footer)
fLine.Size = UDim2.new(1, 0, 0, 1)
fLine.BackgroundColor3 = T.accent
fLine.BorderSizePixel = 0
fLine.BackgroundTransparency = 0.5

local fLbl = Instance.new("TextLabel", footer)
fLbl.Size = UDim2.new(1, 0, 1, 0)
fLbl.BackgroundTransparency = 1
fLbl.Text = "✦ RightShift = Toggle UI  ·  Ctrl+A = Themes  ·  Ctrl+M = Music  ·  F9 = Anti-Fling  ✦"
fLbl.TextColor3 = T.accent2
fLbl.Font = Enum.Font.GothamBold
fLbl.TextSize = 10

--═══════════════════════════════════════════════════════════════
-- HELPERS UI (sections, buttons, toggles, inputs, ranges)
--═══════════════════════════════════════════════════════════════
local activeTab = "home"
local pages = {}

local function clearScroll()
    for _, c in ipairs(scroll:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
end

local function makeSection(title, iconId)
    local s = Instance.new("Frame", scroll)
    s.Size = UDim2.new(1, -6, 0, 32)
    s.BackgroundTransparency = 1
    s.LayoutOrder = #scroll:GetChildren()

    local line = Instance.new("Frame", s)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 8)
    line.BackgroundColor3 = T.accent
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 0.5

    local bg = Instance.new("Frame", s)
    bg.Size = UDim2.new(0, 200, 1, 0)
    bg.Position = UDim2.new(0, 6, 0, 0)
    bg.BackgroundColor3 = T.bg1
    bg.BorderSizePixel = 0
    local c = Instance.new("UICorner", bg)
    c.CornerRadius = UDim.new(0, 4)

    if iconId then
        image(bg, iconId, UDim2.new(0, 16, 0, 16), UDim2.new(0, 4, 0.5, -8), T.accent)
    end

    local l = Instance.new("TextLabel", bg)
    l.Size = UDim2.new(1, -26, 1, 0)
    l.Position = UDim2.new(0, 24, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = title
    l.TextColor3 = T.accent
    l.Font = Enum.Font.GothamBlack
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left

    return s
end

local function makeButton(name, iconId, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, -6, 0, 40)
    b.BackgroundColor3 = T.section
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.LayoutOrder = #scroll:GetChildren()

    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Color = T.accent
    s.Thickness = 1
    s.Transparency = 0.6

    if iconId then
        image(b, iconId, UDim2.new(0, 22, 0, 22), UDim2.new(0, 10, 0.5, -11), T.accent2)
    end

    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 42, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = T.text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left

    b.MouseEnter:Connect(function()
        playSound(A.HOVER, 0.1, 1.5)
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.panelHover }):Play()
        TweenService:Create(s, TweenInfo.new(0.15), { Transparency = 0.2 }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.section }):Play()
        TweenService:Create(s, TweenInfo.new(0.15), { Transparency = 0.6 }):Play()
    end)
    b.MouseButton1Click:Connect(function()
        playSound(A.CLICK, 0.4, 0.95 + math.random() * 0.1)
        callback()
    end)

    return b
end

local function makeToggle(name, iconId, defaultState, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, -6, 0, 42)
    b.BackgroundColor3 = T.section
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.LayoutOrder = #scroll:GetChildren()

    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Color = T.accent
    s.Thickness = 1
    s.Transparency = defaultState and 0.2 or 0.6

    if iconId then
        image(b, iconId, UDim2.new(0, 22, 0, 22), UDim2.new(0, 10, 0.5, -11), T.accent2)
    end

    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.new(1, -100, 1, 0)
    l.Position = UDim2.new(0, 42, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = T.text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("Frame", b)
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -50, 0.5, -10)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(80, 180, 100) or Color3.fromRGB(60, 55, 45)
    switch.BorderSizePixel = 0
    local sc = Instance.new("UICorner", switch)
    sc.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = defaultState and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    local kc = Instance.new("UICorner", knob)
    kc.CornerRadius = UDim.new(1, 0)

    local state = defaultState

    b.MouseEnter:Connect(function()
        playSound(A.HOVER, 0.1, 1.5)
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.panelHover }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.section }):Play()
    end)

    b.MouseButton1Click:Connect(function()
        state = not state
        playSound(state and A.SUCCESS or A.CLICK, 0.4, state and 1.2 or 0.9)
        if state then
            TweenService:Create(knob, TweenInfo.new(0.2), { Position = UDim2.new(1, -18, 0, 2) }):Play()
            TweenService:Create(switch, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(80, 180, 100) }):Play()
            TweenService:Create(s, TweenInfo.new(0.2), { Transparency = 0.2 }):Play()
        else
            TweenService:Create(knob, TweenInfo.new(0.2), { Position = UDim2.new(0, 2, 0, 2) }):Play()
            TweenService:Create(switch, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(60, 55, 45) }):Play()
            TweenService:Create(s, TweenInfo.new(0.2), { Transparency = 0.6 }):Play()
        end
        if callback then callback(state) end
    end)

    return { set = function(v) state = v end, button = b }
end

local function makeInput(placeholder, buttonText, callback)
    local row = Instance.new("Frame", scroll)
    row.Size = UDim2.new(1, -6, 0, 42)
    row.BackgroundColor3 = T.section
    row.BorderSizePixel = 0
    row.LayoutOrder = #scroll:GetChildren()

    local c = Instance.new("UICorner", row)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", row)
    s.Color = T.accent
    s.Thickness = 1
    s.Transparency = 0.6

    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(1, -110, 0, 30)
    box.Position = UDim2.new(0, 8, 0.5, -15)
    box.BackgroundColor3 = T.bg2
    box.BorderSizePixel = 0
    box.Text = ""
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = T.textDim
    box.TextColor3 = T.text
    box.Font = Enum.Font.GothamMedium
    box.TextSize = 12
    box.ClearTextOnFocus = false
    local bc = Instance.new("UICorner", box)
    bc.CornerRadius = UDim.new(0, 6)

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 92, 0, 30)
    btn.Position = UDim2.new(1, -100, 0.5, -15)
    btn.BackgroundColor3 = T.panelHover
    btn.BorderSizePixel = 0
    btn.Text = buttonText or "Set"
    btn.TextColor3 = T.accent
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    local bc2 = Instance.new("UICorner", btn)
    bc2.CornerRadius = UDim.new(0, 6)
    local bs = Instance.new("UIStroke", btn)
    bs.Color = T.accent
    bs.Thickness = 1
    bs.Transparency = 0.5

    box.Focused:Connect(function() playSound(A.HOVER, 0.15, 1.4) end)
    btn.MouseEnter:Connect(function() playSound(A.HOVER, 0.1, 1.6) end)
    btn.MouseButton1Click:Connect(function()
        playSound(A.CLICK, 0.4)
        callback(box.Text)
    end)

    return row
end

local function makeRange(name, minVal, maxVal, default, callback)
    local row = Instance.new("Frame", scroll)
    row.Size = UDim2.new(1, -6, 0, 56)
    row.BackgroundColor3 = T.section
    row.BorderSizePixel = 0
    row.LayoutOrder = #scroll:GetChildren()

    local c = Instance.new("UICorner", row)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", row)
    s.Color = T.accent
    s.Thickness = 1
    s.Transparency = 0.6

    local l = Instance.new("TextLabel", row)
    l.Size = UDim2.new(1, -100, 0, 18)
    l.Position = UDim2.new(0, 12, 0, 6)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = T.text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left

    local vl = Instance.new("TextLabel", row)
    vl.Size = UDim2.new(0, 60, 0, 18)
    vl.Position = UDim2.new(1, -70, 0, 6)
    vl.BackgroundTransparency = 1
    vl.Text = tostring(default)
    vl.TextColor3 = T.accent
    vl.Font = Enum.Font.GothamBold
    vl.TextSize = 12
    vl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -24, 0, 8)
    track.Position = UDim2.new(0, 12, 1, -18)
    track.BackgroundColor3 = T.bg2
    track.BorderSizePixel = 0
    local tc = Instance.new("UICorner", track)
    tc.CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = T.accent
    fill.BorderSizePixel = 0
    local fc = Instance.new("UICorner", fill)
    fc.CornerRadius = UDim.new(1, 0)

    local dragging2, lastX
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging2 = true
            playSound(A.HOVER, 0.1, 1.5)
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging2 = false
            playSound(A.CLICK, 0.3)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging2 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = minVal + relX * (maxVal - minVal)
            if maxVal - minVal <= 5 then val = math.round(val) else val = math.floor(val) end
            fill.Size = UDim2.new(relX, 0, 1, 0)
            vl.Text = tostring(val)
            if callback then callback(val) end
        end
    end)

    return row
end

--═══════════════════════════════════════════════════════════════
-- SYSTÈME DE TABS
--═══════════════════════════════════════════════════════════════
local tabButtons = {}

local function createTab(id, label, iconId)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(1, -12, 0, 42)
    b.BackgroundColor3 = T.bg2
    b.BackgroundTransparency = 0.6
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.LayoutOrder = #sidebar:GetChildren()

    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Color = T.accent
    s.Thickness = 1
    s.Transparency = 1

    local icon = image(b, iconId, UDim2.new(0, 20, 0, 20), UDim2.new(0, 10, 0.5, -10), T.accent2)

    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.new(1, -40, 1, 0)
    l.Position = UDim2.new(0, 38, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = T.textDim
    l.Font = Enum.Font.GothamBold
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left

    b.MouseEnter:Connect(function()
        if activeTab == id then return end
        playSound(A.HOVER, 0.08, 1.6)
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundTransparency = 0.3 }):Play()
    end)
    b.MouseLeave:Connect(function()
        if activeTab == id then return end
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundTransparency = 0.6 }):Play()
    end)

    b.MouseButton1Click:Connect(function()
        if activeTab == id then return end
        playSound(A.TAB, 0.4, 1.1 + math.random() * 0.1)
        -- désélection ancien
        if tabButtons[activeTab] then
            local old = tabButtons[activeTab]
            TweenService:Create(old.btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.6 }):Play()
            TweenService:Create(old.stroke, TweenInfo.new(0.2), { Transparency = 1 }):Play()
            TweenService:Create(old.label, TweenInfo.new(0.2), { TextColor3 = T.textDim }):Play()
        end
        activeTab = id
        TweenService:Create(b, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
        TweenService:Create(s, TweenInfo.new(0.2), { Transparency = 0 }):Play()
        TweenService:Create(l, TweenInfo.new(0.2), { TextColor3 = T.accent }):Play()
        if pages[id] then pages[id]() end
    end)

    tabButtons[id] = { btn = b, stroke = s, label = l }
    return b
end

--═══════════════════════════════════════════════════════════════
-- CODE LOGIQUE — UNIVERSAL
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
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBG.P = 1000
    flyBG.D = 50
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp
    flyConn = RunService.RenderStepped:Connect(function()
        if not State.flyOn or not flyBV or not flyBG then return end
        local cam = workspace.CurrentCamera
        local speed = State.flySpeed
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
        flyBV.Velocity = dir.Magnitude > 0 and (dir.Unit * speed) or Vector3.zero
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
        if p ~= LP and (string.sub(string.lower(p.Name), 1, #name) == name
        or string.sub(string.lower(p.DisplayName), 1, #name) == name) then
            return p
        end
    end
end

local function flingPlayer(target)
    if not target or not target.Character then return end
    local myChar = LP.Character
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP or not targetHRP then return end
    -- mini fling qui touche
    for i = 1, 20 do
        myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
        task.wait()
    end
end

local function setupAntiFling()
    track(RunService.Heartbeat:Connect(function()
        if not State.antiFling then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if hrp.AssemblyLinearVelocity.Magnitude > 200 or hrp.AssemblyAngularVelocity.Magnitude > 200 then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Massless = true
                    end
                end
            end
        end
    end))
end
setupAntiFling()

--═══════════════════════════════════════════════════════════════
-- CODE LOGIQUE — MM2
--═══════════════════════════════════════════════════════════════
local espFolder = nil
local function createESP(character, color, labelText)
    if not espFolder then
        espFolder = Instance.new("Folder", gui)
        espFolder.Name = "ESP"
    end
    local hl = Instance.new("Highlight")
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
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
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.BackgroundTransparency = 1
        tl.Text = labelText
        tl.TextColor3 = color
        tl.Font = Enum.Font.GothamBlack
        tl.TextSize = 12
        tl.TextStrokeTransparency = 0
        hl:SetAttribute("BBGUI", bb)
    end
    return hl
end

local function clearESP()
    if espFolder then
        for _, c in ipairs(espFolder:GetChildren()) do c:Destroy() end
    end
end

local function findMurderer()
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Backpack and i.Backpack:FindFirstChild("Knife") then return i end
    end
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Character and i.Character:FindFirstChild("Knife") then return i end
    end
end

local function findSheriff()
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Backpack and i.Backpack:FindFirstChild("Gun") then return i end
    end
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Character and i.Character:FindFirstChild("Gun") then return i end
    end
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
            if p == findMurderer() then
                createESP(p.Character, Color3.fromRGB(255, 60, 60), "Murderer")
            elseif p == findSheriff() then
                createESP(p.Character, Color3.fromRGB(60, 150, 255), "Sheriff")
            else
                createESP(p.Character, Color3.fromRGB(80, 220, 120))
            end
        end
    end
end

local function shootMurderer()
    if findSheriff() ~= LP then notify("YunoHub", "You're not sheriff", 2) return end
    local murderer = findMurderer()
    if not murderer or not murderer.Character then return end
    if not LP.Character:FindFirstChild("Gun") then
        if LP.Backpack:FindFirstChild("Gun") then
            LP.Character.Humanoid:EquipTool(LP.Backpack:FindFirstChild("Gun"))
        end
    end
    task.wait(0.1)
    local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
    if not murdererHRP then return end
    local predicted = murdererHRP.Position + (murdererHRP.AssemblyLinearVelocity * (State.shootOffset / 15)) + (murderer.Character.Humanoid.MoveDirection * State.shootOffset)
    if LP.Character:FindFirstChild("Gun") then
        pcall(function()
            LP.Character.Gun.Shoot:FireServer(CFrame.new(LP.Character.RightHand.Position), CFrame.new(predicted))
        end)
    end
end

local function knifeThrow()
    if findMurderer() ~= LP then return end
    if not LP.Character:FindFirstChild("Knife") then
        if LP.Backpack:FindFirstChild("Knife") then
            LP.Character.Humanoid:EquipTool(LP.Backpack:FindFirstChild("Knife"))
        end
    end
    task.wait(0.1)
    local closest, minDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                if d < minDist then minDist = d; closest = p end
            end
        end
    end
    if closest and closest.Character then
        local targetHRP = closest.Character:FindFirstChild("HumanoidRootPart")
        pcall(function()
            LP.Character.Knife.Events.KnifeThrown:FireServer(
                CFrame.new(LP.Character.RightHand.Position),
                CFrame.new(targetHRP.Position + targetHRP.AssemblyLinearVelocity * (State.shootOffset / 15))
            )
        end)
    end
end

--═══════════════════════════════════════════════════════════════
-- PAGES DES TABS
--═══════════════════════════════════════════════════════════════

-- ═══ HOME ═══
pages.home = function()
    clearScroll()
    makeSection("Bienvenue", A.CROWN)
    local welcome = Instance.new("Frame", scroll)
    welcome.Size = UDim2.new(1, -6, 0, 80)
    welcome.BackgroundColor3 = T.section
    welcome.BorderSizePixel = 0
    welcome.LayoutOrder = #scroll:GetChildren()
    local wc = Instance.new("UICorner", welcome)
    wc.CornerRadius = UDim.new(0, 10)
    local ws = Instance.new("UIStroke", welcome)
    ws.Color = T.accent
    ws.Thickness = 1
    ws.Transparency = 0.4

    local logo = image(welcome, A.SHIELD, UDim2.new(0, 60, 0, 60), UDim2.new(0, 10, 0.5, -30), T.accent2)

    local wt = Instance.new("TextLabel", welcome)
    wt.Size = UDim2.new(1, -90, 0, 24)
    wt.Position = UDim2.new(0, 78, 0, 14)
    wt.BackgroundTransparency = 1
    wt.Text = "YUNO HUB v3.0"
    wt.TextColor3 = T.accent
    wt.Font = Enum.Font.GothamBlack
    wt.TextSize = 18
    wt.TextXAlignment = Enum.TextXAlignment.Left

    local wd = Instance.new("TextLabel", welcome)
    wd.Size = UDim2.new(1, -90, 0, 34)
    wd.Position = UDim2.new(0, 78, 0, 40)
    wd.BackgroundTransparency = 1
    wd.Text = "Golden ASMR Edition · Universal + MM2\nFait avec ✦ pour toi"
    wd.TextColor3 = T.textDim
    wd.Font = Enum.Font.GothamMedium
    wd.TextSize = 11
    wd.TextXAlignment = Enum.TextXAlignment.Left
    wd.TextYAlignment = Enum.TextYAlignment.Top

    makeSection("Raccourcis clavier", A.LIGHTNING)
    makeButton("RightShift  ·  Toggle UI", A.HOME, function()
        main.Visible = not main.Visible
        playSound(main.Visible and A.OPEN or A.CLOSE, 0.5)
    end)
    makeButton("Ctrl + A  ·  Thèmes", A.PALETTE, function()
        if pages.themes then
            playSound(A.TAB, 0.4)
        end
    end)
    makeButton("Ctrl + M  ·  Musique ASMR", A.MUSIC, function()
        if pages.music then playSound(A.TAB, 0.4) end
    end)
    makeButton("F9  ·  Anti-Fling", A.SHIELD, function()
        State.antiFling = not State.antiFling
        notify("YunoHub", State.antiFling and "🛡️ Anti-Fling ON" or "Anti-Fling OFF", 2)
        playSound(A.SUCCESS, 0.5)
    end)
end

-- ═══ UNIVERSAL ═══
pages.universal = function()
    clearScroll()

    makeSection("Vol", A.PLANE)
    makeToggle("OP Fly", A.PLANE, State.flyOn, function(v)
        State.flyOn = v
        if v then startFly() else stopFly() end
    end)
    makeRange("Fly speed", 20, 300, State.flySpeed, function(v)
        State.flySpeed = v
    end)

    makeSection("Mouvement", A.LIGHTNING)
    makeToggle("Infinite Jump", A.LIGHTNING, State.infJump, function(v)
        State.infJump = v
    end)
    makeToggle("Limit Inf Jump (2x)", A.STAR, State.infJumpOnlyTwo, function(v)
        State.infJumpOnlyTwo = v
    end)
    makeInput("Walkspeed (default 16)", "Set", function(v)
        local n = tonumber(v)
        if n and LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = n; State.ws = n; notify("YunoHub", "WS = "..n, 2) end
        end
    end)
    makeButton("Increase walkspeed (+2)", A.STAR, function()
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then State.ws = State.ws + State.wsIncrement; h.WalkSpeed = State.ws end
    end)
    makeButton("Decrease walkspeed (-2)", A.CROSS, function()
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then State.ws = State.ws - State.wsIncrement; h.WalkSpeed = State.ws end
    end)
    makeInput("Walkspeed increment", "Set", function(v)
        local n = tonumber(v)
        if n then State.wsIncrement = n end
    end)
    makeInput("FOV", "Set", function(v)
        local n = tonumber(v)
        if n then workspace.CurrentCamera.FieldOfView = n; State.fov = n end
    end)
    makeToggle("Loop WS + FOV", A.LIGHTNING, State.loopFovWs, function(v)
        State.loopFovWs = v
    end)
    makeToggle("CTRL+Click Teleport", A.TARGET, State.ctrlClickTp, function(v)
        State.ctrlClickTp = v
    end)

    makeSection("Hitbox", A.SKULL)
    makeInput("Hitbox size (default 1)", "Set", function(v)
        local n = tonumber(v) or 1
        State.hitboxSize = n
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name == "HumanoidRootPart" then
                        part.Size = Vector3.new(n, n, n)
                        part.Transparency = 0.3
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
    makeToggle("Loop Hitbox", A.SKULL, State.loopHitbox, function(v)
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

    makeSection("Téléportation & Cible", A.TARGET)
    makeInput("Nom du joueur à TP", "TP", function(v)
        local t = getPlayerByName(v)
        if t and t.Character and LP.Character then
            LP.Character:PivotTo(CFrame.new(t.Character.HumanoidRootPart.Position + Vector3.new(0,3,0)))
        end
    end)
    makeInput("Nom du joueur à Fling", "Fling", function(v)
        local t = getPlayerByName(v)
        if t then
            State.playerToFling = t
            notify("YunoHub", "Cible fling : " .. t.Name, 3)
        end
    end)
    makeButton("Lancer le Fling", A.FIRE, function()
        if State.playerToFling then
            task.spawn(flingPlayer, State.playerToFling)
            playSound(A.ALERT, 0.5)
        else
            notify("YunoHub", "Sélectionne une cible d'abord", 3)
        end
    end)
    makeInput("Nom du joueur à aimlock", "Set target", function(v)
        local t = getPlayerByName(v)
        if t then State.aimlockTarget = t; notify("YunoHub", "Aimlock → "..t.Name, 3) end
    end)
    makeToggle("Aimlock", A.TARGET, State.aimlockOn, function(v)
        State.aimlockOn = v
        if v then
            task.spawn(function()
                while State.aimlockOn do
                    task.wait()
                    local t = State.aimlockTarget
                    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
                        workspace.CurrentCamera.CFrame = CFrame.new(
                            workspace.CurrentCamera.CFrame.Position,
                            t.Character.HumanoidRootPart.Position
                        )
                    end
                end
            end)
        end
    end)

    makeSection("Protection", A.SHIELD)
    makeToggle("Anti-Fling", A.SHIELD, State.antiFling, function(v)
        State.antiFling = v
    end)

    makeSection("Divers", A.SETTINGS)
    makeToggle("Noclip", A.WING, State.noclipOn, function(v)
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
    makeButton("Anti-AFK", A.SHIELD, function()
        local vu = game:GetService("VirtualUser")
        track(LP.Idled:Connect(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end))
        notify("YunoHub", "Anti-AFK activé", 2)
    end)
    makeButton("FPS Boost", A.LIGHTNING, function()
        local t = workspace:FindFirstChildOfClass("Terrain")
        if t then
            t.WaterWaveSize = 0; t.WaterWaveSpeed = 0; t.WaterReflectance = 0; t.WaterTransparency = 0
        end
        game.Lighting.GlobalShadows = false
        game.Lighting.FogEnd = 9e9
        pcall(function() settings().Rendering.QualityLevel = 1 end)
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0) end
        end
        notify("YunoHub", "FPS Boost appliqué", 2)
    end)
    makeButton("Get ping", A.LIGHTNING, function()
        notify("YunoHub", "Ping : " .. math.floor(LP:GetNetworkPing() * 1000) .. " ms", 3)
    end)
end

-- ═══ MM2 ═══
pages.mm2 = function()
    clearScroll()

    makeSection("ESP", A.SEARCH)
    makeToggle("Player ESP (Murderer/Sheriff)", A.PERSON, State.playerESP, function(v)
        State.playerESP = v
        reloadESP()
    end)
    makeToggle("Hide my own ESP", A.CROSS, State.hideMeESP, function(v)
        State.hideMeESP = v
    end)
    makeToggle("Dropped Gun ESP", A.GUN, State.gunDropESP, function(v)
        State.gunDropESP = v
        if not v then
            if espFolder then
                for _, c in ipairs(espFolder:GetChildren()) do
                    if c:IsA("Highlight") and c.FillColor == Color3.fromRGB(255, 240, 20) then c:Destroy() end
                end
            end
        end
    end)
    makeToggle("Trap detection", A.SKULL, State.trapDetection, function(v)
        State.trapDetection = v
    end)
    makeButton("Reload ESP", A.STAR, function() reloadESP() end)

    makeSection("Armes", A.GUN)
    makeButton("Shoot murderer (instant)", A.GUN, function()
        shootMurderer()
    end)
    makeButton("Shoot murderer (delayed)", A.TARGET, function()
        if findSheriff() ~= LP then notify("YunoHub", "Not sheriff", 2) return end
        task.spawn(function()
            for i = 1, 60 do
                task.wait(0.5)
                shootMurderer()
            end
        end)
    end)
    makeButton("Knife throw to closest", A.KNIFE, function() knifeThrow() end)
    makeToggle("Auto knife throw", A.KNIFE, State.loopThrow, function(v)
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
    makeToggle("Auto-shoot murderer", A.TARGET, State.autoShooting, function(v)
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
    makeRange("Shoot offset", 1, 5, State.shootOffset, function(v) State.shootOffset = v end)
    makeRange("Ping multiplier", 1, 5, State.offsetToPingMult, function(v) State.offsetToPingMult = v end)

    makeSection("Attaques", A.FIRE)
    makeButton("Kill closest (murderer)", A.SKULL, function()
        if findMurderer() ~= LP then notify("YunoHub", "Not murderer", 2) return end
        if not LP.Character:FindFirstChild("Knife") and LP.Backpack:FindFirstChild("Knife") then
            LP.Character.Humanoid:EquipTool(LP.Backpack:FindFirstChild("Knife"))
        end
        task.wait(0.1)
        local closest, minDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                if d < minDist then minDist = d; closest = p end
            end
        end
        if closest then
            local hrp = closest.Character.HumanoidRootPart
            hrp.Anchored = true
            hrp.CFrame = LP.Character.HumanoidRootPart.CFrame + LP.Character.HumanoidRootPart.CFrame.LookVector * 2
            task.wait(0.1)
            pcall(function() LP.Character.Knife.Stab:FireServer("Slash") end)
            task.wait(0.3)
            hrp.Anchored = false
        end
    end)
    makeToggle("Kill aura (murderer)", A.FIRE, State.killAura, function(v)
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
    makeButton("Hold everyone hostage", A.PERSON, function()
        if findMurderer() ~= LP then notify("YunoHub", "Not murderer", 2) return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                hrp.Anchored = true
                hrp.CFrame = LP.Character.HumanoidRootPart.CFrame + LP.Character.HumanoidRootPart.CFrame.LookVector * 4
            end
        end
    end)

    makeSection("Fling", A.FIRE)
    makeButton("Fling Sheriff", A.FIRE, function()
        local s = findSheriff()
        if s then task.spawn(flingPlayer, s) end
    end)
    makeButton("Fling Murderer", A.FIRE, function()
        local m = findMurderer()
        if m then task.spawn(flingPlayer, m) end
    end)

    makeSection("Téléportation", A.TARGET)
    makeButton("TP to Lobby", A.HOME, function()
        local lobby = workspace:FindFirstChild("Lobby")
        if lobby and lobby:FindFirstChild("Spawns") then
            local sp = lobby.Spawns:FindFirstChildWhichIsA("SpawnLocation")
            if sp and LP.Character then LP.Character:PivotTo(CFrame.new(sp.Position + Vector3.new(0,3,0))) end
        end
    end)
    makeButton("TP to Map", A.PLANE, function()
        local map = getMap()
        if map and map:FindFirstChild("Spawns") and LP.Character then
            local sps = map.Spawns:GetChildren()
            if #sps > 0 then
                local sp = sps[math.random(1, #sps)]
                LP.Character:PivotTo(CFrame.new(sp.Position + Vector3.new(0,3,0)))
            end
        end
    end)
    makeButton("TP to dropped gun", A.GUN, function()
        local map = getMap()
        if map and map:FindFirstChild("GunDrop") and LP.Character then
            local prev = LP.Character:GetPivot()
            LP.Character:PivotTo(map.GunDrop:GetPivot())
            task.wait(0.2)
            if LP.Backpack:FindFirstChild("Gun") then
                LP.Character.Humanoid:EquipTool(LP.Backpack.Gun)
            end
            LP.Character:PivotTo(prev)
        end
    end)
    makeToggle("Auto get gun on drop", A.GUN, State.autoGetGun, function(v)
        State.autoGetGun = v
    end)

    makeSection("Fun", A.STAR)
    makeButton("Send roles in chat", A.SEARCH, function()
        local murd = findMurderer()
        local sher = findSheriff()
        local txt = "Murderer: " .. (murd and murd.Name or "-") .. " | Sheriff: " .. (sher and sher.Name or "-")
        local tc = game:GetService("TextChatService")
        if tc then
            for _, ch in ipairs(tc:WaitForChild("TextChannels"):GetChildren()) do
                if ch.Name ~= "RBXSystem" then
                    pcall(function() ch:SendAsync(txt) end)
                end
            end
        end
    end)
    makeButton("Copy murderer username", A.CROSS, function()
        local m = findMurderer()
        if m and setclipboard then setclipboard(m.Name); notify("YunoHub", "Copié : "..m.Name, 3) end
    end)
    makeButton("Copy sheriff username", A.CROSS, function()
        local s = findSheriff()
        if s and setclipboard then setclipboard(s.Name); notify("YunoHub", "Copié : "..s.Name, 3) end
    end)
    makeToggle("Round timer HUD", A.STAR, State.roundTimer, function(v)
        State.roundTimer = v
        if v then
            local hud = Instance.new("TextLabel", gui)
            hud.Name = "RoundTimer"
            hud.Size = UDim2.new(0, 200, 0, 40)
            hud.Position = UDim2.new(0.5, -100, 0, 60)
            hud.BackgroundTransparency = 0.5
            hud.BackgroundColor3 = T.bg2
            hud.TextColor3 = T.accent
            hud.Font = Enum.Font.GothamBlack
            hud.TextSize = 22
            local hc = Instance.new("UICorner", hud)
            hc.CornerRadius = UDim.new(0, 8)
            track(RunService.Heartbeat:Connect(function()
                local part = workspace:FindFirstChild("RoundTimerPart")
                if part then
                    local t2 = part:GetAttribute("Time")
                    if t2 then
                        local m = math.floor(t2 / 60)
                        local s = t2 % 60
                        hud.Text = string.format("%d:%02d", m, s)
                    end
                end
            end))
            -- destroy on toggle off
            task.spawn(function()
                while State.roundTimer do task.wait(0.5) end
                if hud then hud:Destroy() end
            end)
        end
    end)
end

-- ═══ THEMES ═══
pages.themes = function()
    clearScroll()
    makeSection("Sélectionne ton thème", A.PALETTE)

    for key, theme in pairs(THEMES) do
        local b = Instance.new("TextButton", scroll)
        b.Size = UDim2.new(1, -6, 0, 50)
        b.BackgroundColor3 = theme.section
        b.BorderSizePixel = 0
        b.Text = ""
        b.AutoButtonColor = false
        b.LayoutOrder = #scroll:GetChildren()

        local c = Instance.new("UICorner", b)
        c.CornerRadius = UDim.new(0, 10)
        local s = Instance.new("UIStroke", b)
        s.Color = theme.accent
        s.Thickness = 2
        s.Transparency = (key == currentTheme) and 0 or 0.6

        local ic = image(b, theme.icon, UDim2.new(0, 30, 0, 30), UDim2.new(0, 10, 0.5, -15), theme.accent)

        local tl = Instance.new("TextLabel", b)
        tl.Size = UDim2.new(1, -120, 1, 0)
        tl.Position = UDim2.new(0, 50, 0, 0)
        tl.BackgroundTransparency = 1
        tl.Text = theme.name
        tl.TextColor3 = theme.text
        tl.Font = Enum.Font.GothamBlack
        tl.TextSize = 14
        tl.TextXAlignment = Enum.TextXAlignment.Left

        -- pastilles de couleur
        for i = 1, 3 do
            local dot = Instance.new("Frame", b)
            dot.Size = UDim2.new(0, 16, 0, 16)
            dot.Position = UDim2.new(1, -75 + (i - 1) * 20, 0.5, -8)
            dot.BorderSizePixel = 0
            dot.BackgroundColor3 = i == 1 and theme.accent or (i == 2 and theme.accent2 or theme.bg1)
            local dc = Instance.new("UICorner", dot)
            dc.CornerRadius = UDim.new(1, 0)
            local ds = Instance.new("UIStroke", dot)
            ds.Color = theme.text
            ds.Thickness = 1
            ds.Transparency = 0.5
        end

        b.MouseEnter:Connect(function()
            playSound(A.HOVER, 0.1, 1.5)
            TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = theme.panelHover }):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = theme.section }):Play()
        end)
        b.MouseButton1Click:Connect(function()
            playSound(A.SUCCESS, 0.5, 1.2)
            applyTheme(key)
            notify("YunoHub", "Thème : " .. theme.name, 2)
            if pages.themes then pages.themes() end
        end)
    end
end

-- ═══ ASMR MUSIC ═══
local currentMusic = nil
pages.music = function()
    clearScroll()
    makeSection("Musique ASMR d'ambiance", A.MUSIC)

    for i, track in ipairs(MUSIC_TRACKS) do
        local b = Instance.new("TextButton", scroll)
        b.Size = UDim2.new(1, -6, 0, 42)
        b.BackgroundColor3 = T.section
        b.BorderSizePixel = 0
        b.Text = ""
        b.AutoButtonColor = false
        b.LayoutOrder = #scroll:GetChildren()

        local c = Instance.new("UICorner", b)
        c.CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", b)
        s.Color = T.accent
        s.Thickness = 1
        s.Transparency = (currentMusic == i) and 0 or 0.6

        image(b, A.MUSIC, UDim2.new(0, 22, 0, 22), UDim2.new(0, 10, 0.5, -11), T.accent2)

        local l = Instance.new("TextLabel", b)
        l.Size = UDim2.new(1, -50, 1, 0)
        l.Position = UDim2.new(0, 42, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = track.name
        l.TextColor3 = T.text
        l.Font = Enum.Font.GothamBold
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left

        b.MouseEnter:Connect(function()
            playSound(A.HOVER, 0.08, 1.6)
            TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.panelHover }):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.section }):Play()
        end)
        b.MouseButton1Click:Connect(function()
            if currentMusic == i then
                -- stop
                if _G.YunoMusic then _G.YunoMusic:Destroy(); _G.YunoMusic = nil end
                currentMusic = nil
                notify("YunoHub", "Musique arrêtée", 2)
                playSound(A.CLOSE, 0.4)
            else
                if _G.YunoMusic then _G.YunoMusic:Destroy() end
                local mus = Instance.new("Sound")
                mus.SoundId = track.id
                mus.Volume = track.vol
                mus.Looped = true
                mus.Parent = SoundService
                mus:Play()
                _G.YunoMusic = mus
                currentMusic = i
                notify("YunoHub", "♪ " .. track.name, 2)
                playSound(A.SUCCESS, 0.5, 1.2)
            end
            if pages.music then pages.music() end
        end)
    end

    makeSection("Effets sonores", A.LIGHTNING)
    makeToggle("Sons ASMR UI", A.SPARKLE, ASMR_ON, function(v)
        ASMR_ON = v
    end)
    makeToggle("Particules dorées", A.SPARKLE, PARTICLES_ON, function(v)
        PARTICLES_ON = v
    end)
    makeButton("Stop toute musique", A.CROSS, function()
        if _G.YunoMusic then _G.YunoMusic:Destroy(); _G.YunoMusic = nil end
        currentMusic = nil
        notify("YunoHub", "Musique arrêtée", 2)
    end)
end

-- ═══ SETTINGS ═══
pages.settings = function()
    clearScroll()
    makeSection("Interface", A.SETTINGS)
    makeButton("Hide YunoHub", A.CROSS, function()
        TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.4)
        main.Visible = false
    end)
    makeButton("Open dev console", A.SEARCH, function()
        game.StarterGui:SetCore("DevConsoleVisible", true)
    end)

    makeSection("Raccourcis", A.LIGHTNING)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, -6, 0, 70)
    b.BackgroundColor3 = T.section
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.LayoutOrder = #scroll:GetChildren()
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    local t = Instance.new("TextLabel", b)
    t.Size = UDim2.new(1, -20, 1, 0)
    t.Position = UDim2.new(0, 10, 0, 0)
    t.BackgroundTransparency = 1
    t.Text = "RightShift  → Toggle UI\nCtrl + A  → Thèmes\nCtrl + M  → Musique\nF9  → Anti-Fling"
    t.TextColor3 = T.text
    t.Font = Enum.Font.GothamBold
    t.TextSize = 11
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    t.TextWrapped = true
end

--═══════════════════════════════════════════════════════════════
-- CRÉER LES TABS
--═══════════════════════════════════════════════════════════════
createTab("home",      "Accueil",    A.HOME)
createTab("universal", "Universal",  A.STAR)
createTab("mm2",       "MM2",        A.KNIFE)
createTab("themes",    "Thèmes",     A.PALETTE)
createTab("music",     "Musique",    A.MUSIC)
createTab("settings",  "Réglages",   A.SETTINGS)

-- activer home au démarrage
activeTab = "home"
local hb = tabButtons.home
if hb then
    hb.btn.BackgroundTransparency = 0
    hb.stroke.Transparency = 0
    hb.label.TextColor3 = T.accent
end
pages.home()

--═══════════════════════════════════════════════════════════════
-- APPLIQUER UN THÈME
--═══════════════════════════════════════════════════════════════
function applyTheme(key)
    local th = THEMES[key]
    if not th then return end
    currentTheme = key
    T = th

    -- main
    main.BackgroundColor3 = T.bg1
    mainGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, T.bg1), ColorSequenceKeypoint.new(1, T.bg2) })
    mainStroke.Color = T.accent
    glowStroke.Color = T.accent2

    -- topbar
    topBar.BackgroundColor3 = T.panel
    tbGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, T.panelHover), ColorSequenceKeypoint.new(1, T.panel) })
    tbLine.BackgroundColor3 = T.accent
    topLogo.ImageColor3 = T.accent2
    titleLbl.TextColor3 = T.accent
    subLbl.TextColor3 = T.accent2

    -- sidebar
    sidebar.BackgroundColor3 = T.panel

    -- content
    content.BackgroundColor3 = T.panel
    scroll.ScrollBarImageColor3 = T.accent

    -- footer
    footer.BackgroundColor3 = T.bg2
    fLine.BackgroundColor3 = T.accent
    fLbl.TextColor3 = T.accent2

    -- redraw active page
    if pages[activeTab] then pages[activeTab]() end

    -- redraw tabs icons
    for id, data in pairs(tabButtons) do
        data.stroke.Color = T.accent
        data.label.TextColor3 = (id == activeTab) and T.accent or T.textDim
        local ic = data.btn:FindFirstChildWhichIsA("ImageLabel")
        if ic then ic.ImageColor3 = T.accent2 end
    end
end

--═══════════════════════════════════════════════════════════════
-- KEYBINDS
--═══════════════════════════════════════════════════════════════
track(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
        playSound(main.Visible and A.OPEN or A.CLOSE, 0.5)
        if main.Visible then
            main.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 640, 0, 440)
            }):Play()
        end
    elseif input.KeyCode == Enum.KeyCode.F9 then
        State.antiFling = not State.antiFling
        notify("YunoHub", State.antiFling and "🛡️ Anti-Fling ON" or "Anti-Fling OFF", 2)
        playSound(A.SUCCESS, 0.5)
    end
end))

-- Ctrl+A / Ctrl+M redirige vers tab
track(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if input.KeyCode == Enum.KeyCode.A then
            activeTab = "themes"
            pages.themes()
        elseif input.KeyCode == Enum.KeyCode.M then
            activeTab = "music"
            pages.music()
        end
    end
end))

-- Ctrl+Click TP
track(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if State.ctrlClickTp and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
    and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local m = LP:GetMouse()
        local cam = workspace.CurrentCamera
        local ur = cam:ScreenPointToRay(m.X, m.Y)
        local ray = Ray.new(ur.Origin, ur.Direction * 1000)
        local part, pos = workspace:FindPartOnRay(ray, LP.Character)
        if pos and LP.Character then
            LP.Character:PivotTo(CFrame.new(pos + Vector3.new(0, 3, 0)))
        end
    end
end))

-- Infinite jump
track(UserInputService.JumpRequest:Connect(function()
    if State.infJump and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

-- Loop FOV + WS
track(RunService.RenderStepped:Connect(function()
    if State.loopFovWs and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = State.ws end
        workspace.CurrentCamera.FieldOfView = State.fov
    end
end))

--═══════════════════════════════════════════════════════════════
-- RESPAWN
--═══════════════════════════════════════════════════════════════
track(LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.flyOn then startFly() end
    if State.playerESP then reloadESP() end
end))

--═══════════════════════════════════════════════════════════════
-- DÉMARRAGE
--═══════════════════════════════════════════════════════════════
notify("✦ YUNO HUB v3.0 ✦", "Golden ASMR Edition chargé !", 5)
playSound(A.SUCCESS, 0.6, 1.2)

print([[
╔══════════════════════════════════════════════════╗
║     YUNO HUB v3.0 — GOLDEN ASMR EDITION          ║
║                                                  ║
║   ✦ Universal + MM2 fusionnés                    ║
║   ✦ 7 thèmes premium                             ║
║   ✦ 6 pistes ASMR sélectionnables                ║
║   ✦ Sons ASMR sur chaque clic                    ║
║   ✦ Particules dorées                            ║
║                                                  ║
║   RightShift → UI   Ctrl+A → Thèmes              ║
║   Ctrl+M     → Musique  F9 → Anti-Fling          ║
╚══════════════════════════════════════════════════╝
]])