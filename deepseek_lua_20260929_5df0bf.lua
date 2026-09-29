--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║              ██╗   ██╗██╗   ██╗███╗   ██╗ ██████╗            ║
    ║              ╚██╗ ██╔╝██║   ██║████╗  ██║██╔═══██╗           ║
    ║               ╚████╔╝ ██║   ██║██╔██╗ ██║██║   ██║           ║
    ║                ╚██╔╝  ██║   ██║██║╚██╗██║██║   ██║           ║
    ║                 ██║   ╚██████╔╝██║ ╚████║╚██████╔╝           ║
    ║                 ╚═╝    ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝            ║
    ║                                                               ║
    ║              H U B   ·   A S M R   E D I T I O N             ║
    ║                          v 2 . 0                              ║
    ║                                                               ║
    ║   ✦ Fusion 6 scripts · Images · Particules · Sons ASMR       ║
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
local StarterGui       = game:GetService("StarterGui")
local SoundService     = game:GetService("SoundService")
local Lighting         = game:GetService("Lighting")

local LP     = Players.LocalPlayer
local Mouse  = LP:GetMouse()
local Camera = workspace.CurrentCamera

--═══════════════════════════════════════════════════════════════
-- ASSETS (images + sons)
--═══════════════════════════════════════════════════════════════
local ASSETS = {
    -- IMAGES (rbxassetid)
    LOGO            = "rbxassetid://11322093471",     -- bouclier doré
    CROWN           = "rbxassetid://95046902556786",  -- couronne
    SHIELD          = "rbxassetid://11322093471",
    STAR            = "rbxassetid://6031075931",      -- étoile
    SPARKLE         = "rbxassetid://280259692",       -- étincelle
    LIGHTNING       = "rbxassetid://4907816507",      -- éclair
    FIRE            = "rbxassetid://4934971481",      -- flamme
    WING            = "rbxassetid://7708223964",      -- aile
    CROSS           = "rbxassetid://6047530871",      -- croix
    CHECK           = "rbxassetid://6031091004",      -- check
    ARROW           = "rbxassetid://6080169804",      -- flèche
    DIAMOND         = "rbxassetid://6034684930",      -- diamant
    SWORD           = "rbxassetid://4913393055",      -- épée

    -- SONS ASMR & UI
    ASMR_CLICK      = "rbxassetid://876939830",        -- soft click ASMR
    ASMR_TICK       = "rbxassetid://9125402604",       -- tick ASMR
    ASMR_WHOOSH     = "rbxassetid://5150307161",       -- whoosh doux
    ASMR_SUCCESS    = "rbxassetid://2865227271",       -- succès cristallin
    ASMR_SHIELD     = "rbxassetid://2865227271",       -- activation bouclier
    ASMR_OPEN       = "rbxassetid://6895079853",       -- ouverture UI
    ASMR_CLOSE      = "rbxassetid://6042053626",       -- fermeture UI
    ASMR_HOVER      = "rbxassetid://6042053626",       -- hover discret
    ASMR_ALERT      = "rbxassetid://6114958611",       -- alerte hacker
    ASMR_LOADING    = "rbxassetid://1837879082",       -- ambient ASMR
    ASMR_FLING      = "rbxassetid://131237241",        -- boom
    ASMR_FLY        = "rbxassetid://5150307161",       -- vol
}

--═══════════════════════════════════════════════════════════════
-- CONFIG
--═══════════════════════════════════════════════════════════════
local CFG = {
    MAX_VELOCITY         = 80,
    MAX_ANGULAR          = 30,
    SPIKE_THRESHOLD      = 200,
    HACKER_LIN_VEL       = 300,
    HACKER_ANG_VEL       = 100,
    FLING_FORCE          = 9e5,
    FLING_RADIUS         = 30,
    FLING_SPIN_SPEED     = 100,
    FLY_SPEED            = 80,
    FLY_SPEED_FAST       = 200,
    -- Couleurs dorées
    GOLD                 = Color3.fromRGB(255, 200, 50),
    GOLD_LIGHT           = Color3.fromRGB(255, 230, 130),
    GOLD_DARK            = Color3.fromRGB(200, 145, 20),
    BG_DARK              = Color3.fromRGB(18, 16, 12),
    BG_SECTION           = Color3.fromRGB(28, 24, 18),
    TEXT_WHITE           = Color3.fromRGB(255, 255, 255),
    TEXT_GOLD            = Color3.fromRGB(255, 215, 100),
}

--═══════════════════════════════════════════════════════════════
-- STATE
--═══════════════════════════════════════════════════════════════
local State = {
    AntiFling       = true,
    AntiHacker      = true,
    AntiWalkFling   = true,
    NoCollision     = true,
    Fly             = false,
    FlingAttack     = false,
    SoundEnabled    = true,
    Notifications   = true,
    Particles       = true,
}

local flaggedPlayers = {}
local lastSafeCFrame = nil
local heartConn, stepConn = nil, nil
local flyBV, flyBG, flyConn = nil, nil, nil
local flingConn = nil
local connections = {}
local ambientSound = nil

--═══════════════════════════════════════════════════════════════
-- UTILS
--═══════════════════════════════════════════════════════════════
local function playSound(id, vol, pitch)
    if not State.SoundEnabled then return end
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = vol or 0.5
    s.PlaybackSpeed = pitch or 1
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local function startAmbient()
    if ambientSound then return end
    ambientSound = Instance.new("Sound")
    ambientSound.SoundId = ASSETS.ASMR_LOADING
    ambientSound.Volume = 0.15
    ambientSound.Looped = true
    ambientSound.Parent = SoundService
    ambientSound:Play()
end

local function notify(title, text, duration)
    if not State.Notifications then return end
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 4,
        })
    end)
end

local function track(conn)
    table.insert(connections, conn)
    return conn
end

local function imageLabel(parent, imageId, size, pos)
    local img = Instance.new("ImageLabel", parent)
    img.Size = size
    img.Position = pos
    img.BackgroundTransparency = 1
    img.Image = imageId
    img.ImageColor3 = CFG.GOLD
    img.ScaleType = Enum.ScaleType.Fit
    return img
end

--═══════════════════════════════════════════════════════════════
-- NOCOLLISIONCONSTRAINT
--═══════════════════════════════════════════════════════════════
local function applyNoCollision(targetPart)
    if not State.NoCollision then return end
    if not targetPart or not targetPart:IsA("BasePart") then return end
    local myChar = LP.Character
    if not myChar then return end
    pcall(function()
        for _, myPart in ipairs(myChar:GetDescendants()) do
            if myPart:IsA("BasePart") then
                local ncc = Instance.new("NoCollisionConstraint")
                ncc.Part0 = targetPart
                ncc.Part1 = myPart
                ncc.Enabled = true
                ncc.Parent = targetPart
            end
        end
    end)
end

local function protectFromPlayer(target)
    if target == LP then return end
    local function setup(character)
        if not character then return end
        pcall(function()
            character:WaitForChild("Head", 5)
            character:WaitForChild("Humanoid", 5)
        end)
        task.spawn(function()
            pcall(function()
                for _, v in ipairs(character:GetDescendants()) do
                    if v:IsA("NoCollisionConstraint") then v:Destroy() end
                end
                for _, v in ipairs(character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                        v.Massless = true
                        pcall(function()
                            v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                        end)
                        applyNoCollision(v)
                    end
                end
                track(character.DescendantAdded:Connect(function(v)
                    if v:IsA("BasePart") then
                        task.wait(0.05)
                        v.CanCollide = false
                        v.Massless = true
                        applyNoCollision(v)
                    end
                end))
            end)
        end)
    end
    if target.Character then setup(target.Character) end
    track(target.CharacterAdded:Connect(setup))
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LP then protectFromPlayer(p) end
end
track(Players.PlayerAdded:Connect(protectFromPlayer))

--═══════════════════════════════════════════════════════════════
-- HACKER DETECTION
--═══════════════════════════════════════════════════════════════
local function isolateHacker(hacker)
    if not hacker.Character then return end
    local hl = Instance.new("Highlight")
    hl.Name = "YunoHackerMark"
    hl.Adornee = hacker.Character
    hl.FillColor = Color3.fromRGB(255, 40, 40)
    hl.OutlineColor = CFG.GOLD
    hl.FillTransparency = 0.5
    hl.Parent = hacker.Character
    for _, part in ipairs(hacker.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
            part.Transparency = 0.5
            applyNoCollision(part)
        end
    end
end

--═══════════════════════════════════════════════════════════════
-- SHIELD EFFECT (avec images + particules)
--═══════════════════════════════════════════════════════════════
local function spawnShieldEffect(character)
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = CFG.GOLD
    highlight.OutlineColor = CFG.GOLD_LIGHT
    highlight.FillTransparency = 0.4
    highlight.Parent = CoreGui

    -- Particules dorées
    local attachment = Instance.new("Attachment", hrp)
    local particle = Instance.new("ParticleEmitter", attachment)
    particle.Texture = ASSETS.SPARKLE
    particle.Color = ColorSequence.new(CFG.GOLD)
    particle.LightEmission = 1
    particle.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.3, 4),
        NumberSequenceKeypoint.new(1, 0)
    })
    particle.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    particle.Lifetime = NumberRange.new(1)
    particle.Speed = NumberRange.new(5)
    particle.SpreadAngle = Vector2.new(180, 180)
    particle.Rate = 0
    particle:Emit(20)

    -- Image billboard bouclier
    local billboard = Instance.new("BillboardGui", hrp)
    billboard.Size = UDim2.new(0, 120, 0, 120)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    local shieldImg = imageLabel(billboard, ASSETS.SHIELD, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
    shieldImg.ImageTransparency = 0.3
    shieldImg.ImageColor3 = CFG.GOLD_LIGHT

    playSound(ASSETS.ASMR_SHIELD, 0.6, 1.2)

    TweenService:Create(highlight, TweenInfo.new(1.3), {
        FillTransparency = 1, OutlineTransparency = 1
    }):Play()

    task.delay(1.4, function()
        highlight:Destroy()
        attachment:Destroy()
        billboard:Destroy()
    end)
end

--═══════════════════════════════════════════════════════════════
-- ANTI-FLING LOOP
--═══════════════════════════════════════════════════════════════
local function startAntiFling()
    if heartConn then heartConn:Disconnect() end
    if stepConn then stepConn:Disconnect() end

    heartConn = RunService.Heartbeat:Connect(function()
        if not State.AntiFling then return end
        local char = LP.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local vel = hrp.AssemblyLinearVelocity
                local angVel = hrp.AssemblyAngularVelocity
                local horizontalVel = Vector3.new(vel.X, 0, vel.Z).Magnitude

                if hum.FloorMaterial ~= Enum.Material.Air 
                and horizontalVel < 20 and math.abs(vel.Y) < 15 then
                    lastSafeCFrame = hrp.CFrame
                end

                local isJustFalling = (vel.Y < -40) and (horizontalVel < 20)

                if (vel.Magnitude > CFG.MAX_VELOCITY 
                or angVel.Magnitude > CFG.MAX_ANGULAR
                or vel.Magnitude > CFG.SPIKE_THRESHOLD)
                and not isJustFalling then
                    if lastSafeCFrame then
                        pcall(function() hrp.CFrame = lastSafeCFrame end)
                    end
                    hrp.AssemblyLinearVelocity  = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    hrp.Velocity = Vector3.zero
                    hrp.RotVelocity = Vector3.zero
                    task.spawn(spawnShieldEffect, char)
                end
            end
        end

        if State.AntiHacker then
            for _, other in ipairs(Players:GetPlayers()) do
                if other ~= LP and other.Character and not flaggedPlayers[other] then
                    local isHacker = false
                    for _, part in ipairs(other.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            local linV = part.AssemblyLinearVelocity.Magnitude
                            local angV = part.AssemblyAngularVelocity.Magnitude
                            if linV > CFG.HACKER_LIN_VEL or angV > CFG.HACKER_ANG_VEL then
                                isHacker = true
                                break
                            end
                        end
                    end
                    if isHacker then
                        flaggedPlayers[other] = true
                        playSound(ASSETS.ASMR_ALERT, 0.8)
                        notify("⚠️ Hacker Détecté !", "'" .. other.Name .. "' — Bloqué", 4)
                        isolateHacker(other)
                    end
                end
            end
        end
    end)

    stepConn = RunService.Stepped:Connect(function()
        if not State.AntiWalkFling then return end
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
        for hacker in pairs(flaggedPlayers) do
            if hacker.Character then
                for _, part in ipairs(hacker.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end

--═══════════════════════════════════════════════════════════════
-- FLY
--═══════════════════════════════════════════════════════════════
local function stopFly()
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
end

local function startFly()
    stopFly()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBG.P = 1000
    flyBG.D = 50
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp

    flyConn = RunService.RenderStepped:Connect(function()
        if not State.Fly then return end
        local camera = workspace.CurrentCamera
        if not camera or not flyBV or not flyBG then return end
        local speed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) 
            and CFG.FLY_SPEED_FAST or CFG.FLY_SPEED
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0,1,0) end
        flyBV.Velocity = moveDir.Magnitude > 0 and (moveDir.Unit * speed) or Vector3.zero
        flyBG.CFrame = camera.CFrame
    end)
end

--═══════════════════════════════════════════════════════════════
-- FLING ATTACK
--═══════════════════════════════════════════════════════════════
local function runFlingAttack()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= LP and other.Character then
            local targetHRP = other.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and (targetHRP.Position - hrp.Position).Magnitude <= CFG.FLING_RADIUS then
                local bv = Instance.new("BodyAngularVelocity")
                bv.AngularVelocity = Vector3.new(
                    CFG.FLING_SPIN_SPEED, CFG.FLING_SPIN_SPEED, CFG.FLING_SPIN_SPEED)
                bv.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bv.P = 9e5
                bv.Parent = targetHRP
                task.delay(0.4, function() if bv and bv.Parent then bv:Destroy() end end)
            end
        end
    end
end

local function startFlingAttack()
    if flingConn then flingConn:Disconnect() end
    flingConn = RunService.Heartbeat:Connect(function()
        if not State.FlingAttack then return end
        runFlingAttack()
    end)
end

--═══════════════════════════════════════════════════════════════
-- LOADING SCREEN ASMR
--═══════════════════════════════════════════════════════════════
local function playLoadingAnimation()
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

    -- Particules de fond
    local bgParticle = Instance.new("Frame", g)
    bgParticle.Size = UDim2.new(1, 0, 1, 0)
    bgParticle.BackgroundTransparency = 1
    local emitter = Instance.new("ParticleEmitter", bgParticle)
    emitter.Texture = ASSETS.SPARKLE
    emitter.Color = ColorSequence.new(CFG.GOLD)
    emitter.LightEmission = 1
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 1.5),
        NumberSequenceKeypoint.new(1, 0)
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    emitter.Lifetime = NumberRange.new(2)
    emitter.Rate = 30
    emitter.Speed = NumberRange.new(15)
    emitter.SpreadAngle = Vector2.new(360, 360)
    -- Need emitter in a viewport - use ScreenGui ParticleEmitter not supported; skip

    -- Logo
    local logo = imageLabel(g, ASSETS.SHIELD, UDim2.new(0, 200, 0, 200), UDim2.new(0.5, -100, 0.4, -180))
    logo.ImageTransparency = 1
    logo.ImageColor3 = CFG.GOLD_LIGHT

    local label = Instance.new("TextLabel", g)
    label.Size = UDim2.new(0, 600, 0, 100)
    label.Position = UDim2.new(0.5, -300, 0.5, -10)
    label.BackgroundTransparency = 1
    label.Text = ""
    label.TextColor3 = CFG.GOLD
    label.TextScaled = true
    label.Font = Enum.Font.GothamBlack
    label.TextTransparency = 1

    local shadow = Instance.new("TextLabel", g)
    shadow.Size = UDim2.new(0, 600, 0, 100)
    shadow.Position = UDim2.new(0.5, -298, 0.5, -8)
    shadow.BackgroundTransparency = 1
    shadow.Text = ""
    shadow.TextColor3 = CFG.GOLD_DARK
    shadow.TextScaled = true
    shadow.Font = Enum.Font.GothamBlack
    shadow.TextTransparency = 1
    shadow.ZIndex = 0

    local line = Instance.new("Frame", g)
    line.Size = UDim2.new(0, 0, 0, 2)
    line.Position = UDim2.new(0.5, 0, 0.5, 80)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = CFG.GOLD
    line.BorderSizePixel = 0

    TweenService:Create(bg, TweenInfo.new(0.8), {BackgroundTransparency = 0.3}):Play()
    TweenService:Create(logo, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
    TweenService:Create(label, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    TweenService:Create(shadow, TweenInfo.new(0.8), {TextTransparency = 0.6}):Play()
    TweenService:Create(line, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {
        Size = UDim2.new(0, 450, 0, 2)
    }):Play()

    task.wait(0.9)
    local text = "YUNO HUB"
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        shadow.Text = string.sub(text, 1, i)
        playSound(ASSETS.ASMR_TICK, 0.25, 0.8 + math.random() * 0.4)
        task.wait(0.08)
    end

    task.wait(0.4)

    local sub = Instance.new("TextLabel", g)
    sub.Size = UDim2.new(0, 500, 0, 30)
    sub.Position = UDim2.new(0.5, -250, 0.5, 100)
    sub.BackgroundTransparency = 1
    sub.Text = "✦ ASMR EDITION v2.0 ✦"
    sub.TextColor3 = CFG.TEXT_GOLD
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = 16
    sub.TextTransparency = 1
    TweenService:Create(sub, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

    task.wait(1.4)

    TweenService:Create(label, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(shadow, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(sub, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.6), {ImageTransparency = 1}):Play()
    TweenService:Create(bg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(line, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    task.wait(0.7)
    g:Destroy()
end

--═══════════════════════════════════════════════════════════════
-- YUNO HUB UI
--═══════════════════════════════════════════════════════════════
pcall(function() CoreGui.YunoHub:Destroy() end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YunoHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = LP:WaitForChild("PlayerGui") end

-- ─── MAIN FRAME ───
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 520, 0, 420)
main.Position = UDim2.new(0.5, -260, 0.5, -210)
main.BackgroundColor3 = CFG.BG_DARK
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = screenGui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = CFG.GOLD
mainStroke.Thickness = 2

local mainGradient = Instance.new("UIGradient", main)
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 30, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 12, 8))
})
mainGradient.Rotation = 90

-- ─── BORDURE DORÉE ANIMÉE ───
local glowStroke = Instance.new("UIStroke", main)
glowStroke.Color = CFG.GOLD_LIGHT
glowStroke.Thickness = 1
glowStroke.Transparency = 0.5
task.spawn(function()
    while main.Parent do
        TweenService:Create(glowStroke, TweenInfo.new(1.5), {Transparency = 0.9}):Play()
        task.wait(1.5)
        if not main.Parent then break end
        TweenService:Create(glowStroke, TweenInfo.new(1.5), {Transparency = 0.3}):Play()
        task.wait(1.5)
    end
end)

-- ─── TOP BAR ───
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 60)
topBar.BackgroundColor3 = Color3.fromRGB(28, 22, 14)
topBar.BorderSizePixel = 0

local topBarGradient = Instance.new("UIGradient", topBar)
topBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 48, 22)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 22, 14))
})
topBarGradient.Rotation = 90

local topBarLine = Instance.new("Frame", topBar)
topBarLine.Size = UDim2.new(1, 0, 0, 2)
topBarLine.Position = UDim2.new(0, 0, 1, -2)
topBarLine.BackgroundColor3 = CFG.GOLD
topBarLine.BorderSizePixel = 0

-- Logo dans le top bar
local topLogo = imageLabel(topBar, ASSETS.SHIELD, UDim2.new(0, 46, 0, 46), UDim2.new(0, 10, 0, 7))

-- Couronne décorative
local crownImg = imageLabel(topBar, ASSETS.CROWN, UDim2.new(0, 22, 0, 22), UDim2.new(0, 58, 0, 6))
crownImg.ImageColor3 = CFG.GOLD_LIGHT

-- Titre
local titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(1, -200, 0, 28)
titleLabel.Position = UDim2.new(0, 62, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "YUNO HUB"
titleLabel.TextColor3 = CFG.GOLD
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 26
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local subtitleLabel = Instance.new("TextLabel", topBar)
subtitleLabel.Size = UDim2.new(1, -200, 0, 14)
subtitleLabel.Position = UDim2.new(0, 64, 0, 36)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "✦ ASMR EDITION · v2.0 ✦"
subtitleLabel.TextColor3 = CFG.TEXT_GOLD
subtitleLabel.Font = Enum.Font.GothamBold
subtitleLabel.TextSize = 11
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Boutons top bar
local function makeTopButton(text, xPos, callback)
    local btn = Instance.new("TextButton", topBar)
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, xPos, 0, 15)
    btn.BackgroundColor3 = Color3.fromRGB(45, 36, 20)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = CFG.GOLD
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.AutoButtonColor = false

    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 8)

    btn.MouseEnter:Connect(function()
        playSound(ASSETS.ASMR_HOVER, 0.15, 1.4)
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(80, 62, 28)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 36, 20)
        }):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        playSound(ASSETS.ASMR_CLICK, 0.5, 1)
        callback()
    end)
    return btn
end

makeTopButton("—", -72, function()
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), 
        {Size = UDim2.new(0, 520, 0, 60)}):Play()
end)

makeTopButton("✕", -36, function()
    playSound(ASSETS.ASMR_CLOSE, 0.5, 1)
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.wait(0.4)
    main.Visible = false

    -- Bouton restore
    local restore = Instance.new("TextButton", screenGui)
    restore.Size = UDim2.new(0, 70, 0, 70)
    restore.Position = UDim2.new(0, 20, 0.5, -35)
    restore.BackgroundColor3 = CFG.BG_DARK
    restore.Text = ""
    restore.AutoButtonColor = false
    restore.BorderSizePixel = 0

    local rc = Instance.new("UICorner", restore)
    rc.CornerRadius = UDim.new(0, 14)
    local rs = Instance.new("UIStroke", restore)
    rs.Color = CFG.GOLD
    rs.Thickness = 2

    local restoreLogo = imageLabel(restore, ASSETS.SHIELD, UDim2.new(0, 50, 0, 50), UDim2.new(0.5, -25, 0.5, -25))
    restoreLogo.ImageColor3 = CFG.GOLD_LIGHT

    -- Pulse
    task.spawn(function()
        while restore.Parent do
            TweenService:Create(restoreLogo, TweenInfo.new(0.8), {ImageColor3 = CFG.GOLD}):Play()
            task.wait(0.8)
            if not restore.Parent then break end
            TweenService:Create(restoreLogo, TweenInfo.new(0.8), {ImageColor3 = CFG.GOLD_LIGHT}):Play()
            task.wait(0.8)
        end
    end)

    restore.MouseEnter:Connect(function()
        playSound(ASSETS.ASMR_HOVER, 0.2, 1.5)
    end)
    restore.MouseButton1Click:Connect(function()
        playSound(ASSETS.ASMR_OPEN, 0.6, 1)
        main.Visible = true
        main.Size = UDim2.new(0, 0, 0, 0)
        main.Position = UDim2.new(0.5, -260, 0.5, -210)
        TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 520, 0, 420)}):Play()
        restore:Destroy()
    end)
end)

-- ─── DRAG ───
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
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ─── CONTENT ───
local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, -20, 1, -82)
content.Position = UDim2.new(0, 10, 0, 70)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = CFG.GOLD
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local contentLayout = Instance.new("UIListLayout", content)
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ─── SECTION ───
local function makeSection(iconId, title)
    local section = Instance.new("Frame", content)
    section.Size = UDim2.new(1, -10, 0, 34)
    section.BackgroundTransparency = 1
    section.LayoutOrder = #content:GetChildren()

    local line = Instance.new("Frame", section)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 8)
    line.BackgroundColor3 = CFG.GOLD_DARK
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 0.5

    local lbl = Instance.new("Frame", section)
    lbl.Size = UDim2.new(0, 180, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundColor3 = CFG.BG_DARK
    lbl.BorderSizePixel = 0

    local lc = Instance.new("UICorner", lbl)
    lc.CornerRadius = UDim.new(0, 4)

    local icon = imageLabel(lbl, iconId, UDim2.new(0, 18, 0, 18), UDim2.new(0, 6, 0.5, -9))
    icon.ImageColor3 = CFG.GOLD

    local txt = Instance.new("TextLabel", lbl)
    txt.Size = UDim2.new(1, -30, 1, 0)
    txt.Position = UDim2.new(0, 28, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = title
    txt.TextColor3 = CFG.GOLD
    txt.Font = Enum.Font.GothamBlack
    txt.TextSize = 13
    txt.TextXAlignment = Enum.TextXAlignment.Left
end

-- ─── TOGGLE ───
local function makeToggle(iconId, name, description, defaultState, callback)
    local row = Instance.new("Frame", content)
    row.Size = UDim2.new(1, -10, 0, 56)
    row.BackgroundColor3 = CFG.BG_SECTION
    row.BorderSizePixel = 0

    local rc = Instance.new("UICorner", row)
    rc.CornerRadius = UDim.new(0, 10)

    local rs = Instance.new("UIStroke", row)
    rs.Color = CFG.GOLD_DARK
    rs.Thickness = 1
    rs.Transparency = 0.6

    -- Icon
    local iconBg = Instance.new("Frame", row)
    iconBg.Size = UDim2.new(0, 40, 0, 40)
    iconBg.Position = UDim2.new(0, 10, 0.5, -20)
    iconBg.BackgroundColor3 = Color3.fromRGB(45, 36, 20)
    iconBg.BorderSizePixel = 0

    local ic = Instance.new("UICorner", iconBg)
    ic.CornerRadius = UDim.new(0, 8)

    local icon = imageLabel(iconBg, iconId, UDim2.new(0, 24, 0, 24), UDim2.new(0.5, -12, 0.5, -12))
    icon.ImageColor3 = CFG.GOLD_LIGHT

    -- Text
    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.Size = UDim2.new(1, -170, 0, 22)
    nameLbl.Position = UDim2.new(0, 60, 0, 8)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = CFG.TEXT_WHITE
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 14
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left

    local descLbl = Instance.new("TextLabel", row)
    descLbl.Size = UDim2.new(1, -170, 0, 14)
    descLbl.Position = UDim2.new(0, 60, 0, 30)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = description
    descLbl.TextColor3 = Color3.fromRGB(180, 170, 140)
    descLbl.Font = Enum.Font.GothamMedium
    descLbl.TextSize = 10
    descLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Switch
    local switchBg = Instance.new("Frame", row)
    switchBg.Size = UDim2.new(0, 48, 0, 24)
    switchBg.Position = UDim2.new(1, -60, 0.5, -12)
    switchBg.BackgroundColor3 = defaultState 
        and Color3.fromRGB(80, 160, 60) 
        or Color3.fromRGB(60, 55, 45)
    switchBg.BorderSizePixel = 0

    local sc = Instance.new("UICorner", switchBg)
    sc.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switchBg)
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = defaultState 
        and UDim2.new(1, -22, 0, 2) 
        or UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0

    local kc = Instance.new("UICorner", knob)
    kc.CornerRadius = UDim.new(1, 0)

    local state = defaultState

    local function update()
        if state then
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0, 2)}):Play()
            TweenService:Create(switchBg, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(80, 160, 60)
            }):Play()
            TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = CFG.GOLD}):Play()
            TweenService:Create(rs, TweenInfo.new(0.2), {Color = CFG.GOLD, Transparency = 0.2}):Play()
        else
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
            TweenService:Create(switchBg, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 55, 45)
            }):Play()
            TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(120, 110, 90)}):Play()
            TweenService:Create(rs, TweenInfo.new(0.2), {Color = CFG.GOLD_DARK, Transparency = 0.6}):Play()
        end
    end

    local click = Instance.new("TextButton", row)
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.AutoButtonColor = false

    click.MouseEnter:Connect(function()
        playSound(ASSETS.ASMR_HOVER, 0.12, 1.6)
        TweenService:Create(row, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(38, 32, 24)
        }):Play()
    end)
    click.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), {
            BackgroundColor3 = CFG.BG_SECTION
        }):Play()
    end)
    click.MouseButton1Click:Connect(function()
        state = not state
        if state then
            playSound(ASSETS.ASMR_SUCCESS, 0.35, 1.3)
        else
            playSound(ASSETS.ASMR_CLICK, 0.35, 0.9)
        end
        update()
        if callback then callback(state) end
    end)

    return {set = function(v) state = v; update() end}
end

--═══════════════════════════════════════════════════════════════
-- SECTIONS & TOGGLES
--═══════════════════════════════════════════════════════════════

makeSection(ASSETS.SHIELD, "PROTECTION")

makeToggle(ASSETS.SHIELD, "Anti-Fling", "Bloque velocity/CFrame fling", State.AntiFling, function(v)
    State.AntiFling = v
    notify("Yuno Hub", v and "🛡️ Anti-Fling activé" or "Anti-Fling désactivé", 2)
end)

makeToggle(ASSETS.SPARKLE, "Anti-Walkfling", "Force CanCollide=false en boucle", State.AntiWalkFling, function(v)
    State.AntiWalkFling = v
end)

makeToggle(ASSETS.LIGHTNING, "NoCollisionConstraint", "Méthode la plus puissante", State.NoCollision, function(v)
    State.NoCollision = v
    if v then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then applyNoCollision(part) end
                end
            end
        end
    end
end)

makeToggle(ASSETS.STAR, "Anti-Hacker", "Détecte et isole les flingeurs", State.AntiHacker, function(v)
    State.AntiHacker = v
end)

makeSection(ASSETS.SWORD, "ATTAQUE")

makeToggle(ASSETS.WING, "Fly", "Vol libre (WASD + Space/Ctrl)", State.Fly, function(v)
    State.Fly = v
    if v then startFly(); playSound(ASSETS.ASMR_FLY, 0.4, 1.2) else stopFly() end
end)

makeToggle(ASSETS.FIRE, "Fling Attack", "Envoie les joueurs proches", State.FlingAttack, function(v)
    State.FlingAttack = v
    if v then startFlingAttack(); playSound(ASSETS.ASMR_FLING, 0.5) end
end)

makeSection(ASSETS.DIAMOND, "OPTIONS")

makeToggle(ASSETS.ASMR_TICK, "Sons ASMR", "Effets sonores du hub", State.SoundEnabled, function(v)
    State.SoundEnabled = v
    if not v and ambientSound then ambientSound.Volume = 0
    elseif v and ambientSound then ambientSound.Volume = 0.15 end
end)

makeToggle(ASSETS.CHECK, "Notifications", "Alertes Roblox en haut", State.Notifications, function(v)
    State.Notifications = v
end)

-- ─── FOOTER ───
local footer = Instance.new("Frame", main)
footer.Size = UDim2.new(1, 0, 0, 22)
footer.Position = UDim2.new(0, 0, 1, -22)
footer.BackgroundColor3 = Color3.fromRGB(15, 12, 8)
footer.BorderSizePixel = 0

local footerLine = Instance.new("Frame", footer)
footerLine.Size = UDim2.new(1, 0, 0, 1)
footerLine.BackgroundColor3 = CFG.GOLD
footerLine.BorderSizePixel = 0
footerLine.BackgroundTransparency = 0.5

local footerLbl = Instance.new("TextLabel", footer)
footerLbl.Size = UDim2.new(1, 0, 1, 0)
footerLbl.BackgroundTransparency = 1
footerLbl.Text = "✦ RightShift = Toggle · F9 = Anti-Fling · F10 = Fling · F11 = Fly ✦"
footerLbl.TextColor3 = CFG.TEXT_GOLD
footerLbl.Font = Enum.Font.GothamBold
footerLbl.TextSize = 10

--═══════════════════════════════════════════════════════════════
-- KEYBINDS
--═══════════════════════════════════════════════════════════════
track(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
        if main.Visible then
            playSound(ASSETS.ASMR_OPEN, 0.5, 1.1)
            main.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 520, 0, 420)}):Play()
        else
            playSound(ASSETS.ASMR_CLOSE, 0.4, 1)
        end
    elseif input.KeyCode == Enum.KeyCode.F9 then
        State.AntiFling = not State.AntiFling
        State.AntiWalkFling = State.AntiFling
        playSound(State.AntiFling and ASSETS.ASMR_SUCCESS or ASSETS.ASMR_CLICK, 0.4)
        notify("Yuno Hub", State.AntiFling and "🛡️ Anti-Fling ON" or "Anti-Fling OFF", 2)
    elseif input.KeyCode == Enum.KeyCode.F11 then
        State.Fly = not State.Fly
        if State.Fly then startFly(); playSound(ASSETS.ASMR_FLY, 0.5) else stopFly() end
        notify("Yuno Hub", State.Fly and "✈️ Fly ON" or "Fly OFF", 2)
    elseif input.KeyCode == Enum.KeyCode.F10 then
        State.FlingAttack = not State.FlingAttack
        if State.FlingAttack then startFlingAttack(); playSound(ASSETS.ASMR_FLING, 0.5) end
        notify("Yuno Hub", State.FlingAttack and "💥 Fling ON" or "Fling OFF", 2)
    end
end))

--═══════════════════════════════════════════════════════════════
-- RESPAWN
--═══════════════════════════════════════════════════════════════
track(LP.CharacterAdded:Connect(function()
    lastSafeCFrame = nil
    task.wait(0.5)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then applyNoCollision(part) end
            end
        end
    end
    if State.Fly then task.wait(0.5); startFly() end
end))

track(Players.PlayerRemoving:Connect(function(p)
    flaggedPlayers[p] = nil
end))

--═══════════════════════════════════════════════════════════════
-- LANCEMENT
--═══════════════════════════════════════════════════════════════
playLoadingAnimation()
startAntiFling()
startAmbient()
if State.FlingAttack then startFlingAttack() end

notify("✦ YUNO HUB ASMR ✦", "Fusion 6 scripts · v2.0", 5)
playSound(ASSETS.ASMR_SUCCESS, 0.6, 1.2)

print([[
╔══════════════════════════════════════════════════════╗
║      YUNO HUB v2.0 — ASMR EDITION — LOADED           ║
║   ✦ 6 scripts fusionnés                             ║
║   ✦ Images dorées + couronne                        ║
║   ✦ Sons ASMR (click, tick, whoosh, succès)         ║
║   ✦ Particules dorées sur bouclier                  ║
║   Raccourcis: RightShift, F9, F10, F11               ║
╚══════════════════════════════════════════════════════╝
]])