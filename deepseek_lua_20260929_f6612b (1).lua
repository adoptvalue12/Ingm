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
    ║                     H U B   v 1 . 0                          ║
    ║                                                               ║
    ║   Fusion COMPLÈTE de 6 anti-fling scripts                    ║
    ║   Anti-Fling · Anti-Walkfling · Anti-Hacker · Fly · Fling    ║
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
local VirtualUser      = game:GetService("VirtualUser")

local LP     = Players.LocalPlayer
local Mouse  = LP:GetMouse()
local Camera = workspace.CurrentCamera

--═══════════════════════════════════════════════════════════════
-- CONFIG GLOBAL
--═══════════════════════════════════════════════════════════════
local CFG = {
    -- Anti-Fling
    MAX_VELOCITY         = 80,
    MAX_ANGULAR          = 30,
    SPIKE_THRESHOLD      = 200,
    ANCHOR_DURATION      = 0.15,
    HACKER_LIN_VEL       = 300,
    HACKER_ANG_VEL       = 100,
    VELOCITY_LIMIT       = 60,
    REMOVE_BODY_MOVERS   = true,
    NOCLIP_ON_FLING      = true,
    -- Fling
    FLING_FORCE          = 9e5,
    FLING_RADIUS         = 30,
    FLING_SPIN_SPEED     = 100,
    -- Fly
    FLY_SPEED            = 80,
    FLY_SPEED_FAST       = 200,
    -- Sons
    CLICK_SOUND          = "rbxassetid://6895079853",
    SHIELD_SOUND         = "rbxassetid://2865227271",
    ALERT_SOUND          = "rbxassetid://6114958611",
    -- UI
    GOLD                 = Color3.fromRGB(255, 200, 50),
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
}

local flaggedPlayers = {}
local lastSafeCFrame = nil
local lastSafePosition = Vector3.new()
local heartConn, stepConn = nil, nil
local flyBV, flyBG, flyConn = nil, nil, nil
local flingConn = nil
local connections = {}

--═══════════════════════════════════════════════════════════════
-- UTILS
--═══════════════════════════════════════════════════════════════
local function playSound(id, vol)
    if not State.SoundEnabled then return end
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = vol or 1
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
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

--═══════════════════════════════════════════════════════════════
-- LOADING ANIMATION (depuis script #1)
--═══════════════════════════════════════════════════════════════
local function playLoadingAnimation()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "YunoHubLoading"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    pcall(function() screenGui.Parent = CoreGui end)
    if not screenGui.Parent then screenGui.Parent = LP:WaitForChild("PlayerGui") end

    local bg = Instance.new("Frame", screenGui)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 1

    -- Ligne dorée décorative
    local line = Instance.new("Frame", screenGui)
    line.Size = UDim2.new(0, 0, 0, 2)
    line.Position = UDim2.new(0.5, 0, 0.5, 40)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = CFG.GOLD
    line.BorderSizePixel = 0

    local label = Instance.new("TextLabel", screenGui)
    label.Size = UDim2.new(0, 500, 0, 100)
    label.Position = UDim2.new(0.5, -250, 0.5, -50)
    label.BackgroundTransparency = 1
    label.Text = ""
    label.TextColor3 = CFG.GOLD
    label.TextScaled = true
    label.Font = Enum.Font.GothamBlack
    label.TextTransparency = 1

    local shadow = Instance.new("TextLabel", screenGui)
    shadow.Size = UDim2.new(0, 500, 0, 100)
    shadow.Position = UDim2.new(0.5, -248, 0.5, -48)
    shadow.BackgroundTransparency = 1
    shadow.Text = ""
    shadow.TextColor3 = CFG.GOLD_DARK
    shadow.TextScaled = true
    shadow.Font = Enum.Font.GothamBlack
    shadow.TextTransparency = 1
    shadow.ZIndex = 0

    TweenService:Create(bg, TweenInfo.new(0.8), {BackgroundTransparency = 0.4}):Play()
    TweenService:Create(label, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    TweenService:Create(shadow, TweenInfo.new(0.8), {TextTransparency = 0.6}):Play()
    TweenService:Create(line, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 400, 0, 2)}):Play()

    task.wait(0.9)

    local text = "YUNO HUB"
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        shadow.Text = string.sub(text, 1, i)
        task.wait(0.08)
    end

    task.wait(0.3)

    -- Sous-titre
    local sub = Instance.new("TextLabel", screenGui)
    sub.Size = UDim2.new(0, 500, 0, 30)
    sub.Position = UDim2.new(0.5, -250, 0.5, 60)
    sub.BackgroundTransparency = 1
    sub.Text = "Fusion · 6 Scripts · Protection Max"
    sub.TextColor3 = CFG.TEXT_GOLD
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = 16
    sub.TextTransparency = 1
    TweenService:Create(sub, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

    task.wait(1.2)

    TweenService:Create(label, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(shadow, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(sub, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(bg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(line, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    task.wait(0.7)
    screenGui:Destroy()
end

--═══════════════════════════════════════════════════════════════
-- TECHNIQUE #1 : NoCollisionConstraint (depuis script #5)
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
                -- Nettoyer
                for _, v in ipairs(character:GetDescendants()) do
                    if v:IsA("NoCollisionConstraint") then v:Destroy() end
                end
                -- Appliquer sur toutes les parts
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
                -- Surveiller les nouvelles parts
                local descConn = character.DescendantAdded:Connect(function(v)
                    if v:IsA("BasePart") then
                        task.wait(0.05)
                        v.CanCollide = false
                        v.Massless = true
                        applyNoCollision(v)
                    end
                end)
                track(descConn)
            end)
        end)
    end

    if target.Character then setup(target.Character) end
    track(target.CharacterAdded:Connect(setup))
end

-- Init tous les joueurs
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LP then protectFromPlayer(p) end
end
track(Players.PlayerAdded:Connect(protectFromPlayer))

--═══════════════════════════════════════════════════════════════
-- DÉTECTION HACKER + ISOLATION (depuis script #3)
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
-- EFFET BOUCLIER (depuis script #3)
--═══════════════════════════════════════════════════════════════
local function spawnShieldEffect(character)
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = CFG.GOLD
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.4
    highlight.Parent = CoreGui

    local attachment = Instance.new("Attachment", hrp)
    local particle = Instance.new("ParticleEmitter", attachment)
    particle.Texture = "rbxassetid://243098098"
    particle.Color = ColorSequence.new(CFG.GOLD)
    particle.LightEmission = 1
    particle.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.2, 3),
        NumberSequenceKeypoint.new(1, 0)
    })
    particle.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    particle.Lifetime = NumberRange.new(1)
    particle.Speed = NumberRange.new(0)
    particle.Rate = 0
    particle:Emit(15)

    playSound(CFG.SHIELD_SOUND, 0.7)

    TweenService:Create(highlight, TweenInfo.new(1.3), {
        FillTransparency = 1,
        OutlineTransparency = 1
    }):Play()

    task.delay(1.5, function()
        highlight:Destroy()
        attachment:Destroy()
    end)
end

--═══════════════════════════════════════════════════════════════
-- BOUCLE PRINCIPALE ANTI-FLING
--═══════════════════════════════════════════════════════════════
local function startAntiFling()
    if heartConn then heartConn:Disconnect() end
    if stepConn then stepConn:Disconnect() end

    heartConn = RunService.Heartbeat:Connect(function()
        if not State.AntiFling then return end

        -- ─── PROTECTION PERSONNELLE ───
        local char = LP.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")

            if hrp and hum and hum.Health > 0 then
                local vel = hrp.AssemblyLinearVelocity
                local angVel = hrp.AssemblyAngularVelocity
                local horizontalVel = Vector3.new(vel.X, 0, vel.Z).Magnitude

                -- Raycast sol (depuis script #6)
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {char}
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -5, 0), rayParams)

                if hum.FloorMaterial ~= Enum.Material.Air 
                and horizontalVel < 20 
                and math.abs(vel.Y) < 15 then
                    lastSafeCFrame = hrp.CFrame
                    lastSafePosition = hrp.Position
                end

                -- Spike de vitesse = reset
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

        -- ─── DÉTECTION HACKER ───
        if State.AntiHacker then
            for _, other in ipairs(Players:GetPlayers()) do
                if other ~= LP and other.Character 
                and not flaggedPlayers[other] then
                    
                    local isHacker = false
                    for _, part in ipairs(other.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            local linV = part.AssemblyLinearVelocity.Magnitude
                            local angV = part.AssemblyAngularVelocity.Magnitude
                            if linV > CFG.HACKER_LIN_VEL 
                            or angV > CFG.HACKER_ANG_VEL then
                                isHacker = true
                                break
                            end
                        end
                    end

                    if isHacker then
                        flaggedPlayers[other] = true
                        playSound(CFG.ALERT_SOUND, 1)
                        notify("⚠️ Hacker Détecté !", 
                            "'" .. other.Name .. "' — Anti-Walkfling activé")
                        isolateHacker(other)
                    end
                end
            end
        end
    end)

    stepConn = RunService.Stepped:Connect(function()
        if not State.AntiWalkFling then return end

        -- Force CanCollide = false en continu
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

        -- Hackers flaggés : force encore
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
-- FLY (depuis UniversalFling)
--═══════════════════════════════════════════════════════════════
local function stopFly()
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
    if flyConn then flyConn:Disconnect(); flyConn = nil end

    local char = LP.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj.Name == "YunoFlyBV" or obj.Name == "YunoFlyBG" then
                    obj:Destroy()
                end
            end
        end
    end
end

local function startFly()
    stopFly()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flyBV = Instance.new("BodyVelocity")
    flyBV.Name = "YunoFlyBV"
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp

    flyBG = Instance.new("BodyGyro")
    flyBG.Name = "YunoFlyBG"
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
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            flyBV.Velocity = moveDir.Unit * speed
        else
            flyBV.Velocity = Vector3.zero
        end
        flyBG.CFrame = camera.CFrame
    end)
end

--═══════════════════════════════════════════════════════════════
-- FLING ATTACK (depuis UniversalFling)
--═══════════════════════════════════════════════════════════════
local function runFlingAttack()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= LP and other.Character then
            local targetHRP = other.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local dist = (targetHRP.Position - hrp.Position).Magnitude
                if dist <= CFG.FLING_RADIUS then
                    local bv = Instance.new("BodyAngularVelocity")
                    bv.AngularVelocity = Vector3.new(
                        CFG.FLING_SPIN_SPEED,
                        CFG.FLING_SPIN_SPEED,
                        CFG.FLING_SPIN_SPEED)
                    bv.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    bv.P = 9e5
                    bv.Parent = targetHRP

                    task.delay(0.4, function()
                        if bv and bv.Parent then bv:Destroy() end
                    end)
                end
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
-- YUNO HUB UI (dorée, stylée, trop tuff)
--═══════════════════════════════════════════════════════════════
pcall(function() CoreGui.YunoHub:Destroy() end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YunoHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = LP:WaitForChild("PlayerGui") end

-- ─── CADRE PRINCIPAL ───
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 480, 0, 380)
main.Position = UDim2.new(0.5, -240, 0.5, -190)
main.BackgroundColor3 = CFG.BG_DARK
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = screenGui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = CFG.GOLD
mainStroke.Thickness = 2

local mainGradient = Instance.new("UIGradient", main)
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 26, 18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 12, 8))
})
mainGradient.Rotation = 90

-- ─── TOP BAR ───
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 52)
topBar.BackgroundColor3 = Color3.fromRGB(25, 20, 12)
topBar.BorderSizePixel = 0

local topBarGradient = Instance.new("UIGradient", topBar)
topBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 40, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 12))
})
topBarGradient.Rotation = 90

local topBarLine = Instance.new("Frame", topBar)
topBarLine.Size = UDim2.new(1, 0, 0, 2)
topBarLine.Position = UDim2.new(0, 0, 1, -2)
topBarLine.BackgroundColor3 = CFG.GOLD
topBarLine.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "✦  YUNO HUB  ✦"
titleLabel.TextColor3 = CFG.GOLD
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 24
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local subtitleLabel = Instance.new("TextLabel", topBar)
subtitleLabel.Size = UDim2.new(1, -200, 0, 14)
subtitleLabel.Position = UDim2.new(0, 22, 1, -20)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "v1.0 · Fusion 6 Scripts"
subtitleLabel.TextColor3 = CFG.TEXT_GOLD
subtitleLabel.Font = Enum.Font.GothamMedium
subtitleLabel.TextSize = 10
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Boutons top bar
local function makeTopButton(text, xPos, callback)
    local btn = Instance.new("TextButton", topBar)
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, xPos, 0, 11)
    btn.BackgroundColor3 = Color3.fromRGB(40, 32, 18)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = CFG.GOLD
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.AutoButtonColor = false

    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 8)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(70, 55, 25)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 32, 18)
        }):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        playSound(CFG.CLICK_SOUND, 0.5)
        callback()
    end)
    return btn
end

makeTopButton("—", -72, function()
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), 
        {Size = UDim2.new(0, 480, 0, 52)}):Play()
end)

local minimizeToggle = false
makeTopButton("✕", -36, function()
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.wait(0.4)
    main.Visible = false
    -- Bouton restore
    local restore = Instance.new("TextButton", screenGui)
    restore.Size = UDim2.new(0, 60, 0, 60)
    restore.Position = UDim2.new(0, 20, 0.5, -30)
    restore.BackgroundColor3 = CFG.BG_DARK
    restore.Text = "✦\nYUNO"
    restore.TextColor3 = CFG.GOLD
    restore.Font = Enum.Font.GothamBlack
    restore.TextSize = 12
    restore.AutoButtonColor = false
    restore.BorderSizePixel = 0

    local rc = Instance.new("UICorner", restore)
    rc.CornerRadius = UDim.new(0, 12)
    local rs = Instance.new("UIStroke", restore)
    rs.Color = CFG.GOLD
    rs.Thickness = 2

    restore.MouseButton1Click:Connect(function()
        playSound(CFG.CLICK_SOUND, 0.6)
        main.Visible = true
        main.Size = UDim2.new(0, 0, 0, 0)
        main.Position = UDim2.new(0.5, -240, 0.5, -190)
        TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 480, 0, 380)}):Play()
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
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
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

-- ─── CONTENU SCROLL ───
local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, -20, 1, -72)
content.Position = UDim2.new(0, 10, 0, 62)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = CFG.GOLD
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local contentLayout = Instance.new("UIListLayout", content)
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ─── FONCTIONS UI ───
local function makeSection(title)
    local section = Instance.new("Frame", content)
    section.Size = UDim2.new(1, -10, 0, 30)
    section.BackgroundTransparency = 1
    section.LayoutOrder = #content:GetChildren()

    local line = Instance.new("Frame", section)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 6)
    line.BackgroundColor3 = CFG.GOLD_DARK
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 0.5

    local lbl = Instance.new("TextLabel", section)
    lbl.Size = UDim2.new(0, 150, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, -3)
    lbl.BackgroundColor3 = CFG.BG_DARK
    lbl.BorderSizePixel = 0
    lbl.Text = "  ✦ " .. title .. "  "
    lbl.TextColor3 = CFG.GOLD
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local c = Instance.new("UICorner", lbl)
    c.CornerRadius = UDim.new(0, 4)
end

local function makeToggle(name, description, defaultState, callback)
    local row = Instance.new("Frame", content)
    row.Size = UDim2.new(1, -10, 0, 52)
    row.BackgroundColor3 = CFG.BG_SECTION
    row.BorderSizePixel = 0

    local rc = Instance.new("UICorner", row)
    rc.CornerRadius = UDim.new(0, 8)

    local rs = Instance.new("UIStroke", row)
    rs.Color = CFG.GOLD_DARK
    rs.Thickness = 1
    rs.Transparency = 0.6

    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.Size = UDim2.new(1, -90, 0, 22)
    nameLbl.Position = UDim2.new(0, 14, 0, 6)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = CFG.TEXT_WHITE
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 14
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left

    local descLbl = Instance.new("TextLabel", row)
    descLbl.Size = UDim2.new(1, -90, 0, 14)
    descLbl.Position = UDim2.new(0, 14, 0, 28)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = description
    descLbl.TextColor3 = Color3.fromRGB(180, 170, 140)
    descLbl.Font = Enum.Font.GothamMedium
    descLbl.TextSize = 10
    descLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Switch
    local switchBg = Instance.new("Frame", row)
    switchBg.Size = UDim2.new(0, 46, 0, 22)
    switchBg.Position = UDim2.new(1, -58, 0.5, -11)
    switchBg.BackgroundColor3 = defaultState 
        and Color3.fromRGB(80, 160, 60) 
        or Color3.fromRGB(60, 55, 45)
    switchBg.BorderSizePixel = 0

    local sc = Instance.new("UICorner", switchBg)
    sc.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switchBg)
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = defaultState 
        and UDim2.new(1, -20, 0, 2) 
        or UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0

    local kc = Instance.new("UICorner", knob)
    kc.CornerRadius = UDim.new(1, 0)

    local state = defaultState

    local function update()
        if state then
            TweenService:Create(knob, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -20, 0, 2)
            }):Play()
            TweenService:Create(switchBg, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(80, 160, 60)
            }):Play()
        else
            TweenService:Create(knob, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0, 2)
            }):Play()
            TweenService:Create(switchBg, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 55, 45)
            }):Play()
        end
    end

    local click = Instance.new("TextButton", row)
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.AutoButtonColor = false

    click.MouseButton1Click:Connect(function()
        state = not state
        playSound(CFG.CLICK_SOUND, 0.5)
        update()
        if callback then callback(state) end
    end)

    return {set = function(v) state = v; update() end}
end

--═══════════════════════════════════════════════════════════════
-- SECTIONS UI
--═══════════════════════════════════════════════════════════════

makeSection("PROTECTION")

makeToggle("Anti-Fling", "Bloque velocity/CFrame fling", State.AntiFling, function(v)
    State.AntiFling = v
    notify("Yuno Hub", v and "Anti-Fling activé" or "Anti-Fling désactivé", 2)
end)

makeToggle("Anti-Walkfling", "Force CanCollide=false en boucle", State.AntiWalkFling, function(v)
    State.AntiWalkFling = v
end)

makeToggle("NoCollisionConstraint", "Méthode la plus puissante", State.NoCollision, function(v)
    State.NoCollision = v
    if v then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        applyNoCollision(part)
                    end
                end
            end
        end
    end
end)

makeToggle("Anti-Hacker", "Détecte et isole les flingeurs", State.AntiHacker, function(v)
    State.AntiHacker = v
end)

makeSection("ATTAQUE")

makeToggle("Fly", "Vol libre (WASD + Space/Ctrl)", State.Fly, function(v)
    State.Fly = v
    if v then startFly() else stopFly() end
end)

makeToggle("Fling Attack", "Envoie les joueurs proches en l'air", State.FlingAttack, function(v)
    State.FlingAttack = v
    if v then startFlingAttack() end
end)

makeSection("OPTIONS")

makeToggle("Sons", "Effets sonores du hub", State.SoundEnabled, function(v)
    State.SoundEnabled = v
end)

makeToggle("Notifications", "Alertes Roblox en haut", State.Notifications, function(v)
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
footerLbl.Text = "✦ RightShift = Toggle UI · F9 = Anti-Fling · F11 = Fly ✦"
footerLbl.TextColor3 = CFG.TEXT_GOLD
footerLbl.Font = Enum.Font.GothamBold
footerLbl.TextSize = 10

--═══════════════════════════════════════════════════════════════
-- RACCOURCIS CLAVIER
--═══════════════════════════════════════════════════════════════
track(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
        if main.Visible then
            main.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 480, 0, 380)}):Play()
        end
    elseif input.KeyCode == Enum.KeyCode.F9 then
        State.AntiFling = not State.AntiFling
        State.AntiWalkFling = State.AntiFling
        notify("Yuno Hub", State.AntiFling and "🛡️ Anti-Fling ON" or "❌ Anti-Fling OFF", 2)
    elseif input.KeyCode == Enum.KeyCode.F11 then
        State.Fly = not State.Fly
        if State.Fly then startFly() else stopFly() end
        notify("Yuno Hub", State.Fly and "✈️ Fly ON" or "❌ Fly OFF", 2)
    elseif input.KeyCode == Enum.KeyCode.F10 then
        State.FlingAttack = not State.FlingAttack
        if State.FlingAttack then startFlingAttack() end
        notify("Yuno Hub", State.FlingAttack and "💥 Fling Attack ON" or "❌ Fling Attack OFF", 2)
    end
end))

--═══════════════════════════════════════════════════════════════
-- RESPAWN HANDLING
--═══════════════════════════════════════════════════════════════
track(LP.CharacterAdded:Connect(function(char)
    lastSafeCFrame = nil
    lastSafePosition = Vector3.new()
    task.wait(0.5)
    -- Re-appliquer NCC
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    applyNoCollision(part)
                end
            end
        end
    end
    -- Relancer fly si actif
    if State.Fly then
        task.wait(0.5)
        startFly()
    end
end))

track(Players.PlayerRemoving:Connect(function(p)
    flaggedPlayers[p] = nil
end))

--═══════════════════════════════════════════════════════════════
-- LANCEMENT
--═══════════════════════════════════════════════════════════════
playLoadingAnimation()
startAntiFling()
if State.FlingAttack then startFlingAttack() end

notify("✦ YUNO HUB ✦", "Fusion de 6 scripts · Protection MAX", 5)
playSound(CFG.SHIELD_SOUND, 0.6)

print([[
╔══════════════════════════════════════════╗
║         YUNO HUB v1.0 — LOADED           ║
║   ✦ Anti-Fling + Anti-Walkfling          ║
║   ✦ NoCollisionConstraint (script #5)    ║
║   ✦ Hacker Detection (script #3)         ║
║   ✦ Velocity Clamp + Raycast             ║
║   ✦ Fly + Fling Attack                   ║
║   Raccourcis: RightShift, F9, F10, F11   ║
╚══════════════════════════════════════════╝
]])