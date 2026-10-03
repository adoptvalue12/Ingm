--[[
    YUNO HUB v12.2 — CUSTOM BACKGROUND
    Universal · MM2 Auto · YT Music · Themes · Music · Pins · Cursor
]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local SoundService     = game:GetService("SoundService")
local StarterGui       = game:GetService("StarterGui")

local LP = Players.LocalPlayer
local RS = RunService

if _G.YunoHubV12Running then
    pcall(function()
        if _G.YunoHubV12Gui then _G.YunoHubV12Gui:Destroy() end
        if _G.YunoHubV12Cursor then _G.YunoHubV12Cursor:Destroy() end
    end)
end
_G.YunoHubV12Running = true

local function getSafeParent()
    if gethui then local ok,h = pcall(gethui); if ok and h then return h end end
    if get_hidden_gui then local ok,h = pcall(get_hidden_gui); if ok and h then return h end end
    local ok2, cg = pcall(function() return CoreGui end)
    if ok2 and cg then return cg end
    return LP:WaitForChild("PlayerGui")
end
local safeParent = getSafeParent()
local gui
local floatLayer

--═══════════════════════════════════════════════════════════════
-- ASSETS
--═══════════════════════════════════════════════════════════════
local A = {
    LOGO="rbxassetid://11322093471", SHIELD="rbxassetid://11322093471",
    CROWN="rbxassetid://95046902556786", STAR="rbxassetid://6031075931",
    SPARKLE="rbxassetid://280259692", LIGHTNING="rbxassetid://4907816507",
    FIRE="rbxassetid://4934971481", WING="rbxassetid://7708223964",
    CROSS="rbxassetid://6047530871", CHECK="rbxassetid://6031091004",
    DIAMOND="rbxassetid://6034684930", SKULL="rbxassetid://6047530871",
    HOME="rbxassetid://6031075931", SETTINGS="rbxassetid://6034684930",
    MUSIC="rbxassetid://1837879082", PALETTE="rbxassetid://6031091004",
    GUN="rbxassetid://4913393055", KNIFE="rbxassetid://4913393055",
    TARGET="rbxassetid://4907816507", PLANE="rbxassetid://7708223964",
    PERSON="rbxassetid://6031075931", SEARCH="rbxassetid://6031091004",
    PIN="rbxassetid://6031091004", HEART="rbxassetid://6031075931",
    CLOCK="rbxassetid://6034684930", MOON="rbxassetid://6034684930",
    SUN="rbxassetid://6034684930", GEM="rbxassetid://6034684930",
    CLOUD="rbxassetid://6031075931", WATER="rbxassetid://6034684930",
    ORB="rbxassetid://280259692", LEAF="rbxassetid://6031075931",
    RAIN="rbxassetid://6034684930", SNOW="rbxassetid://6034684930",
    CHERRY="rbxassetid://6031075931", COFFEE="rbxassetid://6034684930",
    DRAGON="rbxassetid://4934971481",
    CURSOR="rbxassetid://10769687353", ROCKET="rbxassetid://7708223964",
    BOLT="rbxassetid://4907816507", POTION="rbxassetid://6034684930",
    BOOK="rbxassetid://6031091004", EYE="rbxassetid://6031075931",
    KEY="rbxassetid://6031091004", LOCK="rbxassetid://6047530871",
    COMPASS="rbxassetid://6034684930", ANCHOR="rbxassetid://6031075931",
    SMILE="rbxassetid://6031075931", FLAME="rbxassetid://4934971481",
    GHOST="rbxassetid://6047530871", BOMB="rbxassetid://4934971481",
    MEDAL="rbxassetid://6034684930", TROPHY="rbxassetid://6034684930",
    WAND="rbxassetid://4907816507", CUBE="rbxassetid://6034684930",
    CIRCLE="rbxassetid://6031075931", TRIANGLE="rbxassetid://6031091004",
    ROBOT="rbxassetid://6034684930", BRAIN="rbxassetid://6031091004",
    CAMERA="rbxassetid://6034684930", POWER="rbxassetid://4907816507",
    INFO="rbxassetid://6031075931", WARN="rbxassetid://6047530871",
    MUSICNOTE="rbxassetid://1837879082", PLAY="rbxassetid://110560238983134",
    SPEAKER="rbxassetid://6034684930", MAGIC="rbxassetid://4907816507",
    BG2="rbxassetid://11176073582",
}

local S = {
    CLICK="rbxassetid://876939830", HOVER="rbxassetid://6042053626",
    TICK="rbxassetid://9125402604", SUCCESS="rbxassetid://2865227271",
    OPEN="rbxassetid://6895079853", CLOSE="rbxassetid://6042053626",
    TAB="rbxassetid://5150307161", WARN="rbxassetid://6114958611",
    YES="rbxassetid://9120387183", NO="rbxassetid://6042053626",
    PIN="rbxassetid://9125402604", UNPIN="rbxassetid://6042053626",
    TAP="rbxassetid://876939830",
    NOTIFY="rbxassetid://129485210015224",
    AUTO_ON="rbxassetid://9120387183",
    AUTO_OFF="rbxassetid://6042053626",
    SWITCH="rbxassetid://5150307161",
}

--═══════════════════════════════════════════════════════════════
-- MUSIC (36 tracks)
--═══════════════════════════════════════════════════════════════
local MUSIC = {
    { name="Dreamy Piano",   id="rbxassetid://1837879082", vol=0.15, icon=A.MUSIC },
    { name="Soft Ambient",   id="rbxassetid://1836315732", vol=0.15, icon=A.CLOUD },
    { name="Gentle Tunes",   id="rbxassetid://1836337928", vol=0.15, icon=A.STAR },
    { name="Calm Theme",     id="rbxassetid://1836375780", vol=0.15, icon=A.GEM },
    { name="Peaceful Loop",  id="rbxassetid://1836404901", vol=0.15, icon=A.LEAF },
    { name="Serene Mood",    id="rbxassetid://1836478453", vol=0.15, icon=A.WATER },
    { name="Reflective",     id="rbxassetid://1836519141", vol=0.15, icon=A.MOON },
    { name="Slow Dream",     id="rbxassetid://1836542410", vol=0.15, icon=A.SPARKLE },
    { name="Soft Waves",     id="rbxassetid://1836564540", vol=0.15, icon=A.RAIN },
    { name="Warm Glow",      id="rbxassetid://1836670297", vol=0.15, icon=A.SUN },
    { name="Chill Zone",     id="rbxassetid://1836697631", vol=0.15, icon=A.CLOUD },
    { name="Nostalgia",      id="rbxassetid://1836735382", vol=0.15, icon=A.HEART },
    { name="Twilight",       id="rbxassetid://1836772730", vol=0.15, icon=A.MOON },
    { name="Drifting",       id="rbxassetid://1836827152", vol=0.15, icon=A.ORB },
    { name="Cozy Vibes",     id="rbxassetid://1836905330", vol=0.15, icon=A.FIRE },
    { name="Winter Breeze",  id="rbxassetid://1836947178", vol=0.15, icon=A.SNOW },
    { name="Cozy Lofi",       id="rbxassetid://1836992136", vol=0.15, icon=A.COFFEE },
    { name="Chill Hop",       id="rbxassetid://1837039271", vol=0.15, icon=A.CLOUD },
    { name="Rainy Day",       id="rbxassetid://1837086412", vol=0.15, icon=A.RAIN },
    { name="Study Session",   id="rbxassetid://1837133586", vol=0.15, icon=A.BOOK },
    { name="Midnight Jazz",   id="rbxassetid://1837180741", vol=0.15, icon=A.MOON },
    { name="Funk Groove",     id="rbxassetid://1837227905", vol=0.15, icon=A.LIGHTNING },
    { name="Coffee Shop",     id="rbxassetid://1837275058", vol=0.15, icon=A.COFFEE },
    { name="Sunset Drive",    id="rbxassetid://1837322214", vol=0.15, icon=A.SUN },
    { name="Deep Focus",      id="rbxassetid://1837369352", vol=0.15, icon=A.TARGET },
    { name="Ambient Dreams",  id="rbxassetid://1837416501", vol=0.15, icon=A.ORB },
    { name="Warm Nights",     id="rbxassetid://1837463647", vol=0.15, icon=A.FIRE },
    { name="Summer Chill",    id="rbxassetid://1837510794", vol=0.15, icon=A.SUN },
    { name="Slow Morning",    id="rbxassetid://1837557938", vol=0.15, icon=A.CLOUD },
    { name="Blue Hour",       id="rbxassetid://1837605081", vol=0.15, icon=A.WATER },
    { name="Dreamy Clouds",   id="rbxassetid://1837652229", vol=0.15, icon=A.CLOUD },
    { name="Night Study",     id="rbxassetid://1837699375", vol=0.15, icon=A.MOON },
    { name="Late Night Drive", id="rbxassetid://1837746521", vol=0.15, icon=A.ROCKET },
    { name="City Lights",      id="rbxassetid://1837793669", vol=0.15, icon=A.STAR },
    { name="Ocean Waves",      id="rbxassetid://1837840815", vol=0.15, icon=A.WATER },
    { name="Forest Walk",      id="rbxassetid://1837887961", vol=0.15, icon=A.LEAF },
}

local THEMES = {
    GOLDEN  = { name="Golden",      icon=A.CROWN,    accent=Color3.fromRGB(255,200,50),  accent2=Color3.fromRGB(255,230,130), text=Color3.fromRGB(255,240,210), textDim=Color3.fromRGB(180,165,130), bg1=Color3.fromRGB(30,24,14),  bg2=Color3.fromRGB(14,12,8),  panel=Color3.fromRGB(24,20,14), panelHover=Color3.fromRGB(40,32,20), section=Color3.fromRGB(32,26,16) },
    NEON    = { name="Cyber Neon",  icon=A.LIGHTNING,accent=Color3.fromRGB(0,255,220),   accent2=Color3.fromRGB(130,255,240), text=Color3.fromRGB(220,255,255), textDim=Color3.fromRGB(130,180,190), bg1=Color3.fromRGB(14,22,32),  bg2=Color3.fromRGB(5,10,18),  panel=Color3.fromRGB(12,20,30), panelHover=Color3.fromRGB(20,40,55), section=Color3.fromRGB(18,30,42) },
    BLOOD   = { name="Blood Moon",  icon=A.FIRE,     accent=Color3.fromRGB(220,30,40),   accent2=Color3.fromRGB(255,100,100), text=Color3.fromRGB(255,220,220), textDim=Color3.fromRGB(180,120,120), bg1=Color3.fromRGB(32,10,12),  bg2=Color3.fromRGB(15,5,8),   panel=Color3.fromRGB(26,10,12), panelHover=Color3.fromRGB(50,15,20), section=Color3.fromRGB(38,14,18) },
    OCEAN   = { name="Ocean Deep",  icon=A.WATER,    accent=Color3.fromRGB(80,180,255),  accent2=Color3.fromRGB(160,220,255), text=Color3.fromRGB(220,240,255), textDim=Color3.fromRGB(130,160,190), bg1=Color3.fromRGB(12,22,40),  bg2=Color3.fromRGB(5,10,22),  panel=Color3.fromRGB(12,22,38), panelHover=Color3.fromRGB(22,42,68), section=Color3.fromRGB(18,32,52) },
    GALAXY  = { name="Galaxy",      icon=A.STAR,     accent=Color3.fromRGB(180,100,255), accent2=Color3.fromRGB(220,170,255), text=Color3.fromRGB(240,220,255), textDim=Color3.fromRGB(170,140,200), bg1=Color3.fromRGB(25,14,40),  bg2=Color3.fromRGB(10,6,22),  panel=Color3.fromRGB(22,14,36), panelHover=Color3.fromRGB(42,26,68), section=Color3.fromRGB(32,20,50) },
    PINK    = { name="Neon Pink",   icon=A.SPARKLE,  accent=Color3.fromRGB(255,60,180),  accent2=Color3.fromRGB(255,140,220), text=Color3.fromRGB(255,220,240), textDim=Color3.fromRGB(200,130,170), bg1=Color3.fromRGB(32,12,28),  bg2=Color3.fromRGB(15,5,15),  panel=Color3.fromRGB(28,12,26), panelHover=Color3.fromRGB(50,20,45), section=Color3.fromRGB(38,16,34) },
    EMERALD = { name="Emerald",     icon=A.CHECK,    accent=Color3.fromRGB(60,220,130),  accent2=Color3.fromRGB(140,255,180), text=Color3.fromRGB(220,255,230), textDim=Color3.fromRGB(130,180,150), bg1=Color3.fromRGB(12,28,20),  bg2=Color3.fromRGB(5,15,10),  panel=Color3.fromRGB(12,26,20), panelHover=Color3.fromRGB(20,45,35), section=Color3.fromRGB(18,36,26) },
    ICE     = { name="Ice Blue",    icon=A.DIAMOND,  accent=Color3.fromRGB(140,220,255), accent2=Color3.fromRGB(200,240,255), text=Color3.fromRGB(230,245,255), textDim=Color3.fromRGB(150,180,200), bg1=Color3.fromRGB(18,28,38),  bg2=Color3.fromRGB(8,14,22),  panel=Color3.fromRGB(18,28,42), panelHover=Color3.fromRGB(30,48,68), section=Color3.fromRGB(24,36,52) },
    SUNSET  = { name="Sunset",      icon=A.SUN,      accent=Color3.fromRGB(255,120,60),  accent2=Color3.fromRGB(255,180,120), text=Color3.fromRGB(255,235,220), textDim=Color3.fromRGB(200,150,120), bg1=Color3.fromRGB(38,20,14),  bg2=Color3.fromRGB(20,8,5),   panel=Color3.fromRGB(32,18,12), panelHover=Color3.fromRGB(58,30,20), section=Color3.fromRGB(42,24,16) },
    FOREST  = { name="Forest",      icon=A.LEAF,     accent=Color3.fromRGB(120,180,80),  accent2=Color3.fromRGB(180,220,140), text=Color3.fromRGB(230,245,220), textDim=Color3.fromRGB(150,180,130), bg1=Color3.fromRGB(18,28,14),  bg2=Color3.fromRGB(8,15,6),   panel=Color3.fromRGB(18,28,16), panelHover=Color3.fromRGB(30,45,24), section=Color3.fromRGB(24,36,20) },
    MONO    = { name="Mono",        icon=A.CROSS,    accent=Color3.fromRGB(220,220,220), accent2=Color3.fromRGB(255,255,255), text=Color3.fromRGB(240,240,240), textDim=Color3.fromRGB(150,150,150), bg1=Color3.fromRGB(22,22,22),  bg2=Color3.fromRGB(10,10,10), panel=Color3.fromRGB(22,22,22), panelHover=Color3.fromRGB(45,45,45), section=Color3.fromRGB(32,32,32) },
    LAVA    = { name="Lava",        icon=A.FIRE,     accent=Color3.fromRGB(255,80,20),   accent2=Color3.fromRGB(255,150,60),  text=Color3.fromRGB(255,225,200), textDim=Color3.fromRGB(200,140,100), bg1=Color3.fromRGB(35,12,8),   bg2=Color3.fromRGB(18,5,3),   panel=Color3.fromRGB(32,12,8),  panelHover=Color3.fromRGB(60,22,12), section=Color3.fromRGB(42,16,10) },
    TOXIC   = { name="Toxic",       icon=A.SKULL,    accent=Color3.fromRGB(180,255,40),  accent2=Color3.fromRGB(220,255,120), text=Color3.fromRGB(230,255,180), textDim=Color3.fromRGB(150,180,100), bg1=Color3.fromRGB(20,28,10),  bg2=Color3.fromRGB(10,15,5),  panel=Color3.fromRGB(20,28,12), panelHover=Color3.fromRGB(36,45,20), section=Color3.fromRGB(28,38,16) },
    MIDNIGHT= { name="Midnight",    icon=A.MOON,     accent=Color3.fromRGB(90,120,255),  accent2=Color3.fromRGB(150,180,255), text=Color3.fromRGB(220,230,255), textDim=Color3.fromRGB(130,150,190), bg1=Color3.fromRGB(12,14,30),  bg2=Color3.fromRGB(6,7,18),   panel=Color3.fromRGB(14,16,32), panelHover=Color3.fromRGB(26,30,55), section=Color3.fromRGB(20,24,44) },
    ROSE    = { name="Rose Gold",   icon=A.HEART,    accent=Color3.fromRGB(255,150,160), accent2=Color3.fromRGB(255,200,210), text=Color3.fromRGB(255,230,235), textDim=Color3.fromRGB(200,160,170), bg1=Color3.fromRGB(35,20,22),  bg2=Color3.fromRGB(18,10,12), panel=Color3.fromRGB(32,18,20), panelHover=Color3.fromRGB(55,30,34), section=Color3.fromRGB(42,24,26) },
    MINT    = { name="Mint",        icon=A.CLOUD,    accent=Color3.fromRGB(100,255,200), accent2=Color3.fromRGB(170,255,220), text=Color3.fromRGB(220,255,240), textDim=Color3.fromRGB(140,200,180), bg1=Color3.fromRGB(12,28,24),  bg2=Color3.fromRGB(5,14,12),  panel=Color3.fromRGB(12,26,22), panelHover=Color3.fromRGB(20,45,38), section=Color3.fromRGB(18,36,30) },
    SAND    = { name="Desert Sand", icon=A.SUN,      accent=Color3.fromRGB(230,180,100), accent2=Color3.fromRGB(255,215,150), text=Color3.fromRGB(255,240,215), textDim=Color3.fromRGB(190,160,120), bg1=Color3.fromRGB(35,28,18),  bg2=Color3.fromRGB(18,14,9),  panel=Color3.fromRGB(32,26,16), panelHover=Color3.fromRGB(55,45,28), section=Color3.fromRGB(42,34,20) },
    VOID    = { name="Void Black",  icon=A.DIAMOND,  accent=Color3.fromRGB(140,60,255),  accent2=Color3.fromRGB(200,140,255), text=Color3.fromRGB(230,215,255), textDim=Color3.fromRGB(150,120,180), bg1=Color3.fromRGB(10,8,20),   bg2=Color3.fromRGB(4,3,10),   panel=Color3.fromRGB(12,10,22), panelHover=Color3.fromRGB(26,20,42), section=Color3.fromRGB(20,14,32) },
    CHERRY  = { name="Cherry Blossom", icon=A.CHERRY, accent=Color3.fromRGB(255,170,200), accent2=Color3.fromRGB(255,215,230), text=Color3.fromRGB(255,235,245), textDim=Color3.fromRGB(200,160,180), bg1=Color3.fromRGB(40,22,30),  bg2=Color3.fromRGB(20,10,16), panel=Color3.fromRGB(38,20,28), panelHover=Color3.fromRGB(60,32,44), section=Color3.fromRGB(46,26,36) },
    ROYAL   = { name="Royal Blue",   icon=A.CROWN,    accent=Color3.fromRGB(70,130,255),  accent2=Color3.fromRGB(150,190,255), text=Color3.fromRGB(220,235,255), textDim=Color3.fromRGB(130,160,200), bg1=Color3.fromRGB(10,18,42),  bg2=Color3.fromRGB(5,9,24),   panel=Color3.fromRGB(12,20,46), panelHover=Color3.fromRGB(24,38,80), section=Color3.fromRGB(18,28,58) },
    COFFEE  = { name="Coffee",       icon=A.COFFEE,   accent=Color3.fromRGB(190,140,90),  accent2=Color3.fromRGB(230,190,150), text=Color3.fromRGB(245,230,215), textDim=Color3.fromRGB(180,150,120), bg1=Color3.fromRGB(35,25,18),  bg2=Color3.fromRGB(18,12,8),  panel=Color3.fromRGB(32,22,15), panelHover=Color3.fromRGB(55,38,26), section=Color3.fromRGB(42,30,20) },
    WINTER  = { name="Winter",       icon=A.SNOW,     accent=Color3.fromRGB(190,230,255), accent2=Color3.fromRGB(240,250,255), text=Color3.fromRGB(235,245,255), textDim=Color3.fromRGB(160,190,215), bg1=Color3.fromRGB(20,28,38),  bg2=Color3.fromRGB(10,15,22), panel=Color3.fromRGB(20,30,42), panelHover=Color3.fromRGB(35,50,68), section=Color3.fromRGB(26,38,52) },
    VAMPIRE = { name="Vampire",      icon=A.DRAGON,   accent=Color3.fromRGB(200,20,60),   accent2=Color3.fromRGB(255,80,120),  text=Color3.fromRGB(255,215,225), textDim=Color3.fromRGB(180,110,130), bg1=Color3.fromRGB(20,5,10),   bg2=Color3.fromRGB(10,2,5),   panel=Color3.fromRGB(22,6,12),  panelHover=Color3.fromRGB(42,12,22), section=Color3.fromRGB(30,10,16) },
    AURORA     = { name="Aurora",       icon=A.SPARKLE, accent=Color3.fromRGB(90,255,180),  accent2=Color3.fromRGB(180,150,255), text=Color3.fromRGB(220,255,240), textDim=Color3.fromRGB(140,180,180), bg1=Color3.fromRGB(10,22,28),  bg2=Color3.fromRGB(6,12,22),  panel=Color3.fromRGB(10,22,30), panelHover=Color3.fromRGB(20,42,55), section=Color3.fromRGB(16,32,42) },
    LOFI       = { name="Lofi",         icon=A.COFFEE,  accent=Color3.fromRGB(210,160,120), accent2=Color3.fromRGB(240,200,160), text=Color3.fromRGB(250,235,220), textDim=Color3.fromRGB(180,150,125), bg1=Color3.fromRGB(32,24,20),  bg2=Color3.fromRGB(15,11,9),  panel=Color3.fromRGB(30,22,18), panelHover=Color3.fromRGB(55,42,32), section=Color3.fromRGB(40,30,24) },
    HOLO       = { name="Holographic",  icon=A.DIAMOND, accent=Color3.fromRGB(255,120,220), accent2=Color3.fromRGB(120,220,255), text=Color3.fromRGB(250,230,250), textDim=Color3.fromRGB(180,170,200), bg1=Color3.fromRGB(28,16,40),  bg2=Color3.fromRGB(12,8,22),  panel=Color3.fromRGB(26,16,38), panelHover=Color3.fromRGB(48,30,68), section=Color3.fromRGB(38,24,52) },
    SAKURA     = { name="Sakura",       icon=A.CHERRY,  accent=Color3.fromRGB(255,200,220), accent2=Color3.fromRGB(255,230,240), text=Color3.fromRGB(255,245,250), textDim=Color3.fromRGB(210,180,190), bg1=Color3.fromRGB(36,24,30),  bg2=Color3.fromRGB(18,12,16), panel=Color3.fromRGB(34,22,28), panelHover=Color3.fromRGB(58,38,48), section=Color3.fromRGB(46,30,38) },
    CYBERYLW   = { name="Cyber Yellow", icon=A.BOLT,    accent=Color3.fromRGB(255,220,0),   accent2=Color3.fromRGB(255,245,140), text=Color3.fromRGB(255,250,200), textDim=Color3.fromRGB(190,180,120), bg1=Color3.fromRGB(20,20,8),   bg2=Color3.fromRGB(10,10,4),  panel=Color3.fromRGB(20,20,8),  panelHover=Color3.fromRGB(40,40,16), section=Color3.fromRGB(30,30,12) },
    NEONGREEN  = { name="Neon Green",   icon=A.LEAF,    accent=Color3.fromRGB(0,255,80),    accent2=Color3.fromRGB(140,255,180), text=Color3.fromRGB(220,255,230), textDim=Color3.fromRGB(130,180,140), bg1=Color3.fromRGB(8,22,12),   bg2=Color3.fromRGB(4,12,6),   panel=Color3.fromRGB(10,26,14), panelHover=Color3.fromRGB(20,45,26), section=Color3.fromRGB(16,34,20) },
    DEEPPURP   = { name="Deep Purple",  icon=A.GEM,     accent=Color3.fromRGB(180,90,255),  accent2=Color3.fromRGB(220,160,255), text=Color3.fromRGB(240,225,255), textDim=Color3.fromRGB(170,140,200), bg1=Color3.fromRGB(22,12,32),  bg2=Color3.fromRGB(10,5,18),  panel=Color3.fromRGB(24,14,36), panelHover=Color3.fromRGB(42,24,60), section=Color3.fromRGB(32,18,46) },
    OCEANBRZ   = { name="Ocean Breeze", icon=A.WATER,   accent=Color3.fromRGB(120,220,240), accent2=Color3.fromRGB(190,240,250), text=Color3.fromRGB(230,250,255), textDim=Color3.fromRGB(150,190,200), bg1=Color3.fromRGB(14,30,36),  bg2=Color3.fromRGB(6,15,20),  panel=Color3.fromRGB(14,30,40), panelHover=Color3.fromRGB(26,50,62), section=Color3.fromRGB(20,40,50) },
    CHERRYRED  = { name="Cherry Red",   icon=A.CHERRY,  accent=Color3.fromRGB(230,30,60),   accent2=Color3.fromRGB(255,120,140), text=Color3.fromRGB(255,220,230), textDim=Color3.fromRGB(190,130,140), bg1=Color3.fromRGB(32,10,16),  bg2=Color3.fromRGB(15,4,8),   panel=Color3.fromRGB(30,10,16), panelHover=Color3.fromRGB(55,18,28), section=Color3.fromRGB(40,14,22) },
    GOLDROSE   = { name="Golden Rose",  icon=A.CROWN,   accent=Color3.fromRGB(255,190,150), accent2=Color3.fromRGB(255,225,190), text=Color3.fromRGB(255,240,225), textDim=Color3.fromRGB(200,170,145), bg1=Color3.fromRGB(36,24,20),  bg2=Color3.fromRGB(18,11,9),  panel=Color3.fromRGB(34,22,18), panelHover=Color3.fromRGB(58,38,30), section=Color3.fromRGB(44,28,22) },
    MAGMA      = { name="Magma",        icon=A.FLAME,   accent=Color3.fromRGB(255,90,20),   accent2=Color3.fromRGB(255,180,60),  text=Color3.fromRGB(255,230,200), textDim=Color3.fromRGB(190,130,90),  bg1=Color3.fromRGB(28,8,4),    bg2=Color3.fromRGB(14,4,2),   panel=Color3.fromRGB(28,8,4),   panelHover=Color3.fromRGB(55,16,8),  section=Color3.fromRGB(38,12,6) },
    NEONORNG   = { name="Neon Orange",  icon=A.BOLT,    accent=Color3.fromRGB(255,140,0),   accent2=Color3.fromRGB(255,200,100), text=Color3.fromRGB(255,240,210), textDim=Color3.fromRGB(200,150,110), bg1=Color3.fromRGB(22,14,6),   bg2=Color3.fromRGB(12,7,3),   panel=Color3.fromRGB(22,14,6),  panelHover=Color3.fromRGB(45,28,12), section=Color3.fromRGB(32,20,10) },
    PASTBLUE   = { name="Pastel Blue",  icon=A.CLOUD,   accent=Color3.fromRGB(160,200,255), accent2=Color3.fromRGB(210,230,255), text=Color3.fromRGB(240,245,255), textDim=Color3.fromRGB(170,190,215), bg1=Color3.fromRGB(22,28,40),  bg2=Color3.fromRGB(12,16,24), panel=Color3.fromRGB(22,28,42), panelHover=Color3.fromRGB(38,48,68), section=Color3.fromRGB(30,38,54) },
    MINTGREEN  = { name="Mint Green",   icon=A.LEAF,    accent=Color3.fromRGB(120,255,180), accent2=Color3.fromRGB(180,255,220), text=Color3.fromRGB(230,255,240), textDim=Color3.fromRGB(150,200,175), bg1=Color3.fromRGB(12,26,20),  bg2=Color3.fromRGB(6,14,11),  panel=Color3.fromRGB(12,26,20), panelHover=Color3.fromRGB(24,45,34), section=Color3.fromRGB(18,36,28) },
    CORAL      = { name="Coral",        icon=A.HEART,   accent=Color3.fromRGB(255,130,120), accent2=Color3.fromRGB(255,180,175), text=Color3.fromRGB(255,235,230), textDim=Color3.fromRGB(210,165,155), bg1=Color3.fromRGB(32,18,18),  bg2=Color3.fromRGB(16,9,9),   panel=Color3.fromRGB(30,17,17), panelHover=Color3.fromRGB(55,30,30), section=Color3.fromRGB(42,24,24) },
    INDIGO     = { name="Indigo",       icon=A.MOON,    accent=Color3.fromRGB(100,110,255), accent2=Color3.fromRGB(160,170,255), text=Color3.fromRGB(230,235,255), textDim=Color3.fromRGB(140,150,200), bg1=Color3.fromRGB(14,16,34),  bg2=Color3.fromRGB(7,8,18),   panel=Color3.fromRGB(16,18,36), panelHover=Color3.fromRGB(30,34,62), section=Color3.fromRGB(22,26,48) },
    GLITCH     = { name="Glitch",       icon=A.LIGHTNING, accent=Color3.fromRGB(0,255,120), accent2=Color3.fromRGB(255,0,180),  text=Color3.fromRGB(220,255,240), textDim=Color3.fromRGB(120,180,150), bg1=Color3.fromRGB(8,18,14),   bg2=Color3.fromRGB(4,8,7),    panel=Color3.fromRGB(10,22,18), panelHover=Color3.fromRGB(20,42,34), section=Color3.fromRGB(16,32,26) },
    INFRARED   = { name="Infrared",     icon=A.FIRE,      accent=Color3.fromRGB(255,50,50),   accent2=Color3.fromRGB(255,120,120), text=Color3.fromRGB(255,210,210), textDim=Color3.fromRGB(200,120,120), bg1=Color3.fromRGB(22,8,8),    bg2=Color3.fromRGB(12,4,4),   panel=Color3.fromRGB(24,10,10), panelHover=Color3.fromRGB(46,16,16), section=Color3.fromRGB(32,14,14) },
    SMOKE      = { name="Smoke",        icon=A.CLOUD,     accent=Color3.fromRGB(180,180,190), accent2=Color3.fromRGB(220,220,230), text=Color3.fromRGB(240,240,245), textDim=Color3.fromRGB(150,150,160), bg1=Color3.fromRGB(20,20,24),  bg2=Color3.fromRGB(12,12,15), panel=Color3.fromRGB(22,22,26), panelHover=Color3.fromRGB(40,40,46), section=Color3.fromRGB(30,30,36) },
    MOCHI      = { name="Mochi",        icon=A.HEART,     accent=Color3.fromRGB(255,200,180), accent2=Color3.fromRGB(255,230,215), text=Color3.fromRGB(255,245,240), textDim=Color3.fromRGB(210,180,170), bg1=Color3.fromRGB(36,26,24),  bg2=Color3.fromRGB(18,13,12), panel=Color3.fromRGB(34,24,22), panelHover=Color3.fromRGB(58,42,38), section=Color3.fromRGB(44,32,30) },
    VAPORWAVE  = { name="Vaporwave",    icon=A.SPARKLE,   accent=Color3.fromRGB(255,120,200), accent2=Color3.fromRGB(120,220,255), text=Color3.fromRGB(250,225,245), textDim=Color3.fromRGB(180,160,200), bg1=Color3.fromRGB(30,18,40),  bg2=Color3.fromRGB(15,8,22),  panel=Color3.fromRGB(28,16,38), panelHover=Color3.fromRGB(52,30,68), section=Color3.fromRGB(40,24,52) },
}

local currentTheme = "GOLDEN"
local T = THEMES[currentTheme]
local ASMR_ON = true
local PARTICLES_ON = true
local BACKGROUND_ON = true
local BACKGROUND2_ON = true
local BG2_OPACITY = 0.7
local CURSOR_ON = true
local CURSOR_RGB = true

local State = {
    flyOn=false, flySpeed=50, infJump=false, ws=16, fov=70, loopFovWs=false,
    hitboxSize=1, loopHitbox=false,
    targetPlayer=nil, antiFling=false, noclipOn=false,
    playerESP=false, gunDropESP=false, trapDetection=false, hideMeEsp=false,
    autoShooting=false, shootOffset=2.8, loopThrow=false,
    autoGetGun=false, killAura=false,
    currentCrosshair=nil,
    instakillshoot=false, spawnAtPlayer=false, roundTimerOn=false,
    autoFlingSheriff=false, autoFlingMurderer=false, autoFlingClosest=false,
    autoFlingAny=false, autoEquipKnife=false, autoEquipGun=false,
    autoKnifeOnMurderer=false, autoGunOnSheriff=false, autoKillClosest=false,
    autoKillEveryone=false, autoTPMap=false, autoTPLobby=false,
    autoAntiflingPermanent=false, autoUnfreeze=false, autoSendRoles=false,
    autoRoundInfo=false, autoCameraLock=false, autoJumpSpam=false,
    autoStabAura=false, autoAttackSheriff=false, autoEverything=false,
    ytLoaded=false,
}

local connections = {}
local function track(c)
    if c then table.insert(connections, c) end
    return c
end

--═══════════════════════════════════════════════════════════════
-- UTIL
--═══════════════════════════════════════════════════════════════
local function playSound(id, vol, pitch)
    if not ASMR_ON then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id; s.Volume = vol or 0.4; s.PlaybackSpeed = pitch or 1
        s.Parent = SoundService; s:Play()
        s.Ended:Connect(function() pcall(function() s:Destroy() end) end)
        task.delay(5, function() pcall(function() if s and s.Parent then s:Destroy() end end) end)
    end)
end

local function notify(title, text, dur, soundId)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = dur or 3 })
    end)
    playSound(soundId or S.NOTIFY, 0.5, 1.0 + math.random()*0.2)
end

local function mkImage(parent, id, size, pos, color)
    local i = Instance.new("ImageLabel", parent)
    i.BackgroundTransparency = 1; i.Image = id
    i.ImageColor3 = color or T.accent; i.ScaleType = Enum.ScaleType.Fit
    if size then i.Size = size end
    if pos then i.Position = pos end
    return i
end

local function onTap(obj, callback)
    local lastFire = 0
    local function fire()
        if os.clock() - lastFire < 0.15 then return end
        lastFire = os.clock()
        pcall(callback)
    end
    obj.MouseButton1Click:Connect(fire)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then fire() end
    end)
end

--═══════════════════════════════════════════════════════════════
-- HOLD TRACKER
--═══════════════════════════════════════════════════════════════
local _activeHold = nil
local HOLD_MOVE_THRESHOLD = 10

UserInputService.InputChanged:Connect(function(input)
    if not _activeHold then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
       or input.UserInputType == Enum.UserInputType.Touch then
        local d = (input.Position - _activeHold.start).Magnitude
        if d > HOLD_MOVE_THRESHOLD then
            if _activeHold.cancel then pcall(_activeHold.cancel) end
            _activeHold = nil
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        if _activeHold and _activeHold.cancel then pcall(_activeHold.cancel) end
        _activeHold = nil
    end
end)

--═══════════════════════════════════════════════════════════════
-- CONFIRM DIALOG
--═══════════════════════════════════════════════════════════════
local function showConfirm(title, subtitle, desc, onConfirm, onCancel)
    if not gui then return end
    local overlay = Instance.new("TextButton", gui)
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.6
    overlay.Text = ""; overlay.AutoButtonColor = false
    overlay.ZIndex = 200; overlay.Modal = true

    local box = Instance.new("Frame", overlay)
    box.Size = UDim2.new(0,0,0,190); box.Position = UDim2.new(0.5,0,0.5,-95)
    box.BackgroundColor3 = T.panel; box.BorderSizePixel = 0
    box.ZIndex = 201; box.ClipsDescendants = true
    local bc = Instance.new("UICorner", box); bc.CornerRadius = UDim.new(0,14)
    local bs = Instance.new("UIStroke", box); bs.Color = T.accent; bs.Thickness = 2

    local iconBg = Instance.new("Frame", box)
    iconBg.Size = UDim2.new(0,44,0,44); iconBg.Position = UDim2.new(0.5,-22,0,14)
    iconBg.BackgroundColor3 = T.panelHover; iconBg.BorderSizePixel = 0; iconBg.ZIndex = 202
    local ibc = Instance.new("UICorner", iconBg); ibc.CornerRadius = UDim.new(0,11)
    mkImage(iconBg, A.PIN, UDim2.new(0,26,0,26), UDim2.new(0.5,-13,0.5,-13), T.accent2)

    local tLbl = Instance.new("TextLabel", box)
    tLbl.Size = UDim2.new(1,-20,0,22); tLbl.Position = UDim2.new(0,10,0,64)
    tLbl.BackgroundTransparency = 1; tLbl.Text = title
    tLbl.TextColor3 = T.accent; tLbl.Font = Enum.Font.GothamBlack
    tLbl.TextSize = 16; tLbl.ZIndex = 202

    local sLbl = Instance.new("TextLabel", box)
    sLbl.Size = UDim2.new(1,-20,0,18); sLbl.Position = UDim2.new(0,10,0,86)
    sLbl.BackgroundTransparency = 1; sLbl.Text = subtitle or ""
    sLbl.TextColor3 = T.text; sLbl.Font = Enum.Font.GothamBold
    sLbl.TextSize = 13; sLbl.ZIndex = 202

    local dLbl = Instance.new("TextLabel", box)
    dLbl.Size = UDim2.new(1,-20,0,28); dLbl.Position = UDim2.new(0,10,0,106)
    dLbl.BackgroundTransparency = 1; dLbl.Text = desc or ""
    dLbl.TextColor3 = T.textDim; dLbl.Font = Enum.Font.GothamMedium
    dLbl.TextSize = 11; dLbl.TextWrapped = true; dLbl.ZIndex = 202

    local yes = Instance.new("TextButton", box)
    yes.Size = UDim2.new(0.5,-20,0,40); yes.Position = UDim2.new(0,12,1,-52)
    yes.BackgroundColor3 = T.panelHover; yes.BorderSizePixel = 0
    yes.Text = "✓ Yes, pin it"; yes.TextColor3 = T.accent
    yes.Font = Enum.Font.GothamBold; yes.TextSize = 12
    yes.AutoButtonColor = false; yes.ZIndex = 202
    local yc = Instance.new("UICorner", yes); yc.CornerRadius = UDim.new(0,10)
    local ys = Instance.new("UIStroke", yes); ys.Color = T.accent; ys.Thickness = 1; ys.Transparency = 0.3

    local no = Instance.new("TextButton", box)
    no.Size = UDim2.new(0.5,-20,0,40); no.Position = UDim2.new(0.5,8,1,-52)
    no.BackgroundColor3 = T.panelHover; no.BorderSizePixel = 0
    no.Text = "✕ Cancel"; no.TextColor3 = T.text
    no.Font = Enum.Font.GothamBold; no.TextSize = 12
    no.AutoButtonColor = false; no.ZIndex = 202
    local nc = Instance.new("UICorner", no); nc.CornerRadius = UDim.new(0,10)
    local ns = Instance.new("UIStroke", no); ns.Color = T.textDim; ns.Thickness = 1; ns.Transparency = 0.5

    TweenService:Create(box, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0,320,0,190), Position = UDim2.new(0.5,-160,0.5,-95)
    }):Play()

    local closing = false
    local function close(cb)
        if closing then return end
        closing = true
        local t2 = TweenService:Create(box, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0,0,0,190), Position = UDim2.new(0.5,0,0.5,-95)
        })
        t2:Play()
        t2.Completed:Connect(function() pcall(function() overlay:Destroy() end); if cb then pcall(cb) end end)
    end

    onTap(yes, function() playSound(S.YES,0.5,1.2); close(function() if onConfirm then onConfirm() end end) end)
    onTap(no, function() playSound(S.NO,0.4,0.95); close(function() if onCancel then onCancel() end end) end)
    onTap(overlay, function() playSound(S.NO,0.3,0.9); close(function() if onCancel then onCancel() end end) end)
end

--═══════════════════════════════════════════════════════════════
-- FLOATING BUTTONS
--═══════════════════════════════════════════════════════════════
local floatingButtons = {}

local function spawnFloatingButton(key, name, iconId, callback)
    if not floatLayer then return end
    if floatingButtons[key] then
        playSound(S.UNPIN, 0.4)
        local fb = floatingButtons[key]
        TweenService:Create(fb, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Size = UDim2.new(0,0,0,0) }):Play()
        task.wait(0.3); pcall(function() fb:Destroy() end); floatingButtons[key] = nil
        return
    end
    playSound(S.PIN, 0.5, 1.3)

    local shadowHolder = Instance.new("Frame", floatLayer)
    shadowHolder.Size = UDim2.new(0,0,0,0)
    shadowHolder.Position = UDim2.new(0,22,0.5, math.random(-150,150))
    shadowHolder.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shadowHolder.BackgroundTransparency = 0.55
    shadowHolder.BorderSizePixel = 0; shadowHolder.ZIndex = 49
    local shc = Instance.new("UICorner", shadowHolder); shc.CornerRadius = UDim.new(1,0)

    local fb = Instance.new("TextButton", floatLayer)
    fb.Name = "FB_"..key; fb.Size = UDim2.new(0,0,0,0)
    fb.Position = UDim2.new(0,20,0.5, shadowHolder.Position.Y.Offset - 2)
    fb.BackgroundColor3 = T.panel; fb.BackgroundTransparency = 0.05
    fb.BorderSizePixel = 0; fb.Text = ""; fb.AutoButtonColor = false
    fb.ZIndex = 51; fb.ClipsDescendants = false

    local c = Instance.new("UICorner", fb); c.CornerRadius = UDim.new(1,0)
    local s = Instance.new("UIStroke", fb); s.Color = T.accent; s.Thickness = 2
    local glow = Instance.new("UIStroke", fb); glow.Color = T.accent2; glow.Thickness = 1; glow.Transparency = 0.65

    task.spawn(function()
        while fb.Parent do
            pcall(function()
                TweenService:Create(glow, TweenInfo.new(1.5), { Transparency = 0.9 }):Play()
            end)
            task.wait(1.5)
            if not fb.Parent then break end
            pcall(function()
                TweenService:Create(glow, TweenInfo.new(1.5), { Transparency = 0.4 }):Play()
            end)
            task.wait(1.5)
        end
    end)

    local iconBg = Instance.new("Frame", fb)
    iconBg.Size = UDim2.new(0,40,0,40); iconBg.Position = UDim2.new(0.5,-20,0.5,-24)
    iconBg.BackgroundColor3 = T.panelHover; iconBg.BorderSizePixel = 0; iconBg.ZIndex = 52
    local ibc = Instance.new("UICorner", iconBg); ibc.CornerRadius = UDim.new(0,10)
    mkImage(iconBg, iconId, UDim2.new(0,26,0,26), UDim2.new(0.5,-13,0.5,-13), T.accent2)

    local lbl = Instance.new("TextLabel", fb)
    lbl.Size = UDim2.new(1,-6,0,14); lbl.Position = UDim2.new(0,3,1,6)
    lbl.BackgroundTransparency = 1; lbl.Text = name
    lbl.TextColor3 = T.text; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9; lbl.TextStrokeTransparency = 0.5
    lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    lbl.TextTruncate = Enum.TextTruncate.AtEnd; lbl.ZIndex = 55

    local xBtn = Instance.new("TextButton", fb)
    xBtn.Size = UDim2.new(0,20,0,20); xBtn.Position = UDim2.new(1,-10,0,-6)
    xBtn.BackgroundColor3 = Color3.fromRGB(220,60,60); xBtn.BorderSizePixel = 0
    xBtn.Text = "✕"; xBtn.TextColor3 = Color3.fromRGB(255,255,255)
    xBtn.Font = Enum.Font.GothamBlack; xBtn.TextSize = 11
    xBtn.AutoButtonColor = false; xBtn.ZIndex = 56
    local xc = Instance.new("UICorner", xBtn); xc.CornerRadius = UDim.new(1,0)
    local xs = Instance.new("UIStroke", xBtn); xs.Color = Color3.fromRGB(255,255,255); xs.Thickness = 1; xs.Transparency = 0.5

    onTap(xBtn, function()
        playSound(S.UNPIN, 0.4); fb:Destroy(); shadowHolder:Destroy(); floatingButtons[key] = nil
    end)

    TweenService:Create(fb, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0,72,0,72) }):Play()
    TweenService:Create(shadowHolder, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0,76,0,76) }):Play()

    local dragging = false; local dragStart = nil; local startPos = nil; local startTime = 0; local moved = false

    fb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; moved = false
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            startPos = fb.Position; startTime = os.clock()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not fb.Parent then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch then
            local cur = Vector2.new(input.Position.X, input.Position.Y)
            local d = cur - dragStart
            if d.Magnitude > 6 then moved = true end
            if moved then
                local newX = startPos.X.Offset + d.X
                local newY = startPos.Y.Offset + d.Y
                fb.Position = UDim2.new(0,newX,0,newY)
                shadowHolder.Position = UDim2.new(0,newX+2,0,newY+2)
            end
        end
    end)

    fb.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
           and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = false
        local held = os.clock() - (startTime or 0)
        if not moved then
            if held > 0.6 then
                playSound(S.UNPIN, 0.4); fb:Destroy(); shadowHolder:Destroy(); floatingButtons[key] = nil
            else
                playSound(S.TAP, 0.5, 0.95 + math.random()*0.1)
                TweenService:Create(fb, TweenInfo.new(0.1), { Size = UDim2.new(0,64,0,64) }):Play()
                task.delay(0.15, function()
                    if fb.Parent then TweenService:Create(fb, TweenInfo.new(0.15), { Size = UDim2.new(0,72,0,72) }):Play() end
                end)
                pcall(callback)
            end
        end
    end)

    floatingButtons[key] = fb
    notify("YunoHub", "📌 Pinned: "..name, 3)
end

--═══════════════════════════════════════════════════════════════
-- CURSOR SYSTEM
--═══════════════════════════════════════════════════════════════
local cursorGui = Instance.new("ScreenGui")
cursorGui.Name = "YunoCursor"
cursorGui.IgnoreGuiInset = true
cursorGui.ResetOnSpawn = false
cursorGui.DisplayOrder = 99999
pcall(function() cursorGui.Parent = safeParent end)
if not cursorGui.Parent then cursorGui.Parent = LP:WaitForChild("PlayerGui") end
_G.YunoHubV12Cursor = cursorGui

local cursorImg = Instance.new("ImageLabel", cursorGui)
cursorImg.Name = "CursorImage"; cursorImg.BackgroundTransparency = 1
cursorImg.Image = A.CURSOR
cursorImg.Size = UDim2.new(0, 32, 0, 32)
cursorImg.AnchorPoint = Vector2.new(0.5, 0.5)
cursorImg.ImageColor3 = T.accent2; cursorImg.ZIndex = 99998

local cursorText = Instance.new("TextLabel", cursorGui)
cursorText.Name = "CursorText"; cursorText.BackgroundTransparency = 1
cursorText.Text = "✦ Yuno Hub ✦"
cursorText.TextColor3 = T.accent
cursorText.TextStrokeTransparency = 0
cursorText.TextStrokeColor3 = Color3.fromRGB(0,0,0)
cursorText.Font = Enum.Font.GothamBlack
cursorText.TextSize = 15
cursorText.Size = UDim2.new(0, 150, 0, 20)
cursorText.AnchorPoint = Vector2.new(0.5, 0)
cursorText.ZIndex = 99999

local cursorConn = nil
local function updateCursor()
    if cursorConn then pcall(function() cursorConn:Disconnect() end); cursorConn = nil end
    if not CURSOR_ON then
        pcall(function() UserInputService.MouseIconEnabled = true end)
        cursorImg.Visible = false; cursorText.Visible = false; return
    end
    cursorImg.Visible = true; cursorText.Visible = true
    pcall(function() UserInputService.MouseIconEnabled = false end)
    cursorConn = RunService.RenderStepped:Connect(function()
        pcall(function()
            UserInputService.MouseIconEnabled = false
            local loc = UserInputService:GetMouseLocation()
            cursorImg.Position = UDim2.new(0, loc.X, 0, loc.Y)
            cursorImg.Rotation = cursorImg.Rotation + 2.5
            cursorText.Position = UDim2.new(0, loc.X, 0, loc.Y + 20)
            if CURSOR_RGB then
                local hue = (tick() % 5) / 5
                cursorImg.ImageColor3 = Color3.fromHSV(hue, 1, 1)
                cursorText.TextColor3 = Color3.fromHSV(hue, 1, 1)
            else
                cursorImg.ImageColor3 = T.accent2; cursorText.TextColor3 = T.accent
            end
        end)
    end)
end
updateCursor()

--═══════════════════════════════════════════════════════════════
-- LOADING SCREEN
--═══════════════════════════════════════════════════════════════
local function loadingScreen()
    local g = Instance.new("ScreenGui")
    g.IgnoreGuiInset = true; g.ResetOnSpawn = false
    pcall(function() g.Parent = safeParent end)
    if not g.Parent then g.Parent = LP:WaitForChild("PlayerGui") end
    local bg = Instance.new("Frame", g)
    bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(0,0,0); bg.BackgroundTransparency = 1
    local logo = mkImage(g, A.SHIELD, UDim2.new(0,120,0,120), UDim2.new(0.5,-60,0.4,-120), T.accent2)
    logo.ImageTransparency = 1
    local label = Instance.new("TextLabel", g)
    label.Size = UDim2.new(0,400,0,70); label.Position = UDim2.new(0.5,-200,0.5,-20)
    label.BackgroundTransparency = 1; label.TextColor3 = T.accent
    label.Font = Enum.Font.GothamBlack; label.TextScaled = true; label.TextTransparency = 1
    local line = Instance.new("Frame", g)
    line.Size = UDim2.new(0,0,0,2); line.Position = UDim2.new(0.5,0,0.5,55)
    line.AnchorPoint = Vector2.new(0.5,0.5); line.BackgroundColor3 = T.accent; line.BorderSizePixel = 0
    TweenService:Create(bg, TweenInfo.new(0.8), { BackgroundTransparency = 0.35 }):Play()
    TweenService:Create(logo, TweenInfo.new(0.8), { ImageTransparency = 0 }):Play()
    TweenService:Create(label, TweenInfo.new(0.8), { TextTransparency = 0 }):Play()
    TweenService:Create(line, TweenInfo.new(1.5, Enum.EasingStyle.Quint), { Size = UDim2.new(0,360,0,2) }):Play()
    task.wait(0.9)
    local txt = "YUNO HUB"
    for i = 1, #txt do
        label.Text = string.sub(txt,1,i)
        playSound(S.TICK, 0.28, 0.8 + math.random()*0.4)
        task.wait(0.07)
    end
    task.wait(0.3)
    local sub = Instance.new("TextLabel", g)
    sub.Size = UDim2.new(0,400,0,22); sub.Position = UDim2.new(0.5,-200,0.5,62)
    sub.BackgroundTransparency = 1; sub.Text = "✦ Mobile · v12.2 CUSTOM BG ✦"
    sub.TextColor3 = T.accent2; sub.Font = Enum.Font.GothamBold
    sub.TextSize = 13; sub.TextTransparency = 1
    TweenService:Create(sub, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
    task.wait(1.2)
    TweenService:Create(label, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
    TweenService:Create(sub, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
    TweenService:Create(logo, TweenInfo.new(0.5), { ImageTransparency = 1 }):Play()
    TweenService:Create(bg, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(line, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    task.wait(0.6); pcall(function() g:Destroy() end)
end
loadingScreen()

--═══════════════════════════════════════════════════════════════
-- MAIN GUI
--═══════════════════════════════════════════════════════════════
pcall(function()
    if safeParent:FindFirstChild("YunoHubV12") then safeParent.YunoHubV12:Destroy() end
    if safeParent:FindFirstChild("YunoHubV11") then safeParent.YunoHubV11:Destroy() end
end)

gui = Instance.new("ScreenGui")
gui.Name = "YunoHubV12"; gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 500
pcall(function() gui.Parent = safeParent end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end
_G.YunoHubV12Gui = gui

floatLayer = Instance.new("Frame", gui)
floatLayer.Size = UDim2.new(1,0,1,0); floatLayer.BackgroundTransparency = 1
floatLayer.ZIndex = 10

--═══════════════════════════════════════════════════════════════
-- MENU FRAME
--═══════════════════════════════════════════════════════════════
local viewportW = workspace.CurrentCamera.ViewportSize.X
local winW = math.min(440, viewportW - 30)
local winH = 330

local Menu = Instance.new("Frame", gui)
Menu.Name = "Menu"
Menu.Size = UDim2.new(0,winW,0,winH)
Menu.Position = UDim2.new(0.5,-winW/2,0,20)
Menu.BackgroundColor3 = T.bg1; Menu.BorderSizePixel = 0
Menu.Active = true; Menu.ClipsDescendants = true; Menu.ZIndex = 20

local MenuCorner = Instance.new("UICorner", Menu); MenuCorner.CornerRadius = UDim.new(0,16)
local MenuGrad = Instance.new("UIGradient", Menu)
MenuGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0,T.bg1), ColorSequenceKeypoint.new(1,T.bg2) })
MenuGrad.Rotation = 90
local MenuStroke = Instance.new("UIStroke", Menu); MenuStroke.Color = T.accent; MenuStroke.Thickness = 2
local MenuStrokeGrad = Instance.new("UIGradient", MenuStroke)
MenuStrokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,T.bg1), ColorSequenceKeypoint.new(0.2,T.accent),
    ColorSequenceKeypoint.new(0.5,T.accent2), ColorSequenceKeypoint.new(0.8,T.accent),
    ColorSequenceKeypoint.new(1,T.bg1)
})
MenuStrokeGrad.Rotation = 180

-- ═══ BACKGROUND IMAGE 1 (original) ═══
local MenuBG = Instance.new("ImageLabel", Menu)
MenuBG.Name = "BackgroundImage"
MenuBG.Size = UDim2.new(1,0,1,0); MenuBG.Position = UDim2.new(0,0,0,0)
MenuBG.BackgroundTransparency = 1
MenuBG.Image = "rbxassetid://1049060234"
MenuBG.ImageTransparency = 0.75
MenuBG.ScaleType = Enum.ScaleType.Crop; MenuBG.ZIndex = 0
local MenuBGCorner = Instance.new("UICorner", MenuBG); MenuBGCorner.CornerRadius = UDim.new(0,16)

-- ═══ BACKGROUND IMAGE 2 (NEW - custom added) ═══
local MenuBG2 = Instance.new("ImageLabel", Menu)
MenuBG2.Name = "BackgroundImage2"
MenuBG2.Size = UDim2.new(1,0,1,0); MenuBG2.Position = UDim2.new(0,0,0,0)
MenuBG2.BackgroundTransparency = 1
MenuBG2.Image = "rbxassetid://11176073582"
MenuBG2.ImageTransparency = 0.7
MenuBG2.ScaleType = Enum.ScaleType.Crop; MenuBG2.ZIndex = 0
MenuBG2.ImageColor3 = T.accent2
local MenuBG2Corner = Instance.new("UICorner", MenuBG2); MenuBG2Corner.CornerRadius = UDim.new(0,16)

-- Slow rotation effect for the new background
task.spawn(function()
    while Menu.Parent and MenuBG2.Parent do
        pcall(function()
            local t = TweenService:Create(MenuBG2, TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = MenuBG2.Rotation + 8
            })
            t:Play()
            t.Completed:Wait()
        end)
        task.wait(0.5)
    end
end)

task.spawn(function()
    while Menu.Parent do
        pcall(function()
            TweenService:Create(MenuStrokeGrad, TweenInfo.new(6, Enum.EasingStyle.Linear),
                { Rotation = MenuStrokeGrad.Rotation + 360 }):Play()
        end)
        task.wait(6)
    end
end)

task.spawn(function()
    while Menu.Parent do
        if PARTICLES_ON then
            pcall(function()
                local p = Instance.new("Frame", Menu)
                p.Size = UDim2.new(0, math.random(3,5), 0, math.random(3,5))
                p.BackgroundColor3 = T.accent; p.BorderSizePixel = 0
                p.BackgroundTransparency = 0.4; p.ZIndex = 1
                local pc = Instance.new("UICorner", p); pc.CornerRadius = UDim.new(1,0)
                local sx = math.random(0, winW); local ex = sx + math.random(-80,80)
                p.Position = UDim2.new(0,sx,1,0)
                TweenService:Create(p, TweenInfo.new(math.random(8,14), Enum.EasingStyle.Linear), {
                    Position = UDim2.new(0,ex,0,-30), BackgroundTransparency = 1,
                }):Play()
                task.delay(15, function() pcall(function() if p.Parent then p:Destroy() end end) end)
            end)
        end
        task.wait(math.random(6,14)/10)
    end
end)

local hubNameIcon = mkImage(Menu, A.CROWN, UDim2.new(0,22,0,22), UDim2.new(0,14,0,10), T.accent)
hubNameIcon.ZIndex = 25

local hubName = Instance.new("TextLabel", Menu)
hubName.Size = UDim2.new(0,220,0,26); hubName.Position = UDim2.new(0,40,0,8)
hubName.BackgroundTransparency = 1; hubName.Text = "YunoHub"
hubName.TextColor3 = T.accent; hubName.Font = Enum.Font.GothamBlack
hubName.TextSize = 22; hubName.TextXAlignment = Enum.TextXAlignment.Left; hubName.ZIndex = 25

local version = Instance.new("TextLabel", Menu)
version.Size = UDim2.new(0,200,0,14); version.Position = UDim2.new(0,42,0,34)
version.BackgroundTransparency = 1; version.Text = "✦ v12.2 · CUSTOM BG + AUTO + YT Music"
version.TextColor3 = T.textDim; version.Font = Enum.Font.GothamMedium
version.TextSize = 9; version.TextXAlignment = Enum.TextXAlignment.Left; version.ZIndex = 25

local hubDescIcon = mkImage(Menu, A.SPARKLE, UDim2.new(0,14,0,14), UDim2.new(1,-135,0,13), T.accent2)
hubDescIcon.ZIndex = 25

local hubDesc = Instance.new("TextLabel", Menu)
hubDesc.Size = UDim2.new(0,120,0,16); hubDesc.Position = UDim2.new(1,-120,0,12)
hubDesc.BackgroundTransparency = 1; hubDesc.Text = "universal + mm2 auto"
hubDesc.TextColor3 = T.textDim; hubDesc.Font = Enum.Font.GothamBold
hubDesc.TextSize = 10; hubDesc.TextXAlignment = Enum.TextXAlignment.Right; hubDesc.ZIndex = 25

local closeBtn = Instance.new("TextButton", Menu)
closeBtn.Size = UDim2.new(0,28,0,28); closeBtn.Position = UDim2.new(1,-38,0,10)
closeBtn.BackgroundColor3 = T.panel; closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"; closeBtn.TextColor3 = T.accent
closeBtn.Font = Enum.Font.GothamBlack; closeBtn.TextSize = 14
closeBtn.AutoButtonColor = false; closeBtn.ZIndex = 26
local cbc = Instance.new("UICorner", closeBtn); cbc.CornerRadius = UDim.new(0,8)

local closeArea = Instance.new("TextButton", Menu)
closeArea.Size = UDim2.new(0.35,0,0,6)
closeArea.Position = UDim2.new(0.5,-closeArea.Size.X.Offset/2,0,4)
closeArea.AnchorPoint = Vector2.new(0.5,0)
closeArea.BackgroundColor3 = T.accent; closeArea.BorderSizePixel = 0
closeArea.Text = ""; closeArea.AutoButtonColor = false; closeArea.ZIndex = 25
local cac = Instance.new("UICorner", closeArea); cac.CornerRadius = UDim.new(1,0)

local opener = Instance.new("TextButton", floatLayer)
opener.Size = UDim2.new(0,54,0,54); opener.Position = UDim2.new(0,15,0.5,-27)
opener.BackgroundColor3 = T.panel; opener.BorderSizePixel = 0
opener.Text = ""; opener.AutoButtonColor = false; opener.ZIndex = 40
opener.Visible = false
local opc = Instance.new("UICorner", opener); opc.CornerRadius = UDim.new(1,0)
local opStroke = Instance.new("UIStroke", opener); opStroke.Color = T.accent; opStroke.Thickness = 2
mkImage(opener, A.SHIELD, UDim2.new(0,36,0,36), UDim2.new(0.5,-18,0.5,-18), T.accent2)

task.spawn(function()
    while opener.Parent do
        pcall(function() TweenService:Create(opStroke, TweenInfo.new(1), { Transparency = 0.7 }):Play() end)
        task.wait(1)
        if not opener.Parent then break end
        pcall(function() TweenService:Create(opStroke, TweenInfo.new(1), { Transparency = 0 }):Play() end)
        task.wait(1)
    end
end)

local function minimizeHub()
    playSound(S.CLOSE, 0.5)
    TweenService:Create(Menu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)
    }):Play()
    task.wait(0.3); Menu.Visible = false; opener.Visible = true
end
local function openHub()
    playSound(S.OPEN, 0.5)
    Menu.Visible = true
    Menu.Size = UDim2.new(0,0,0,0); Menu.Position = UDim2.new(0.5,0,0.5,0)
    TweenService:Create(Menu, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0,winW,0,winH), Position = UDim2.new(0.5,-winW/2,0,20)
    }):Play()
    task.wait(0.4); opener.Visible = false
end
onTap(closeArea, minimizeHub); onTap(closeBtn, minimizeHub); onTap(opener, openHub)

local dragging, dragStart, startPos
Menu.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Menu.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                  startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

local List = Instance.new("Frame", Menu)
List.Size = UDim2.new(0,130,1,-70); List.Position = UDim2.new(0,8,0,56)
List.BackgroundColor3 = T.panel; List.BorderSizePixel = 0; List.ZIndex = 21
local lc = Instance.new("UICorner", List); lc.CornerRadius = UDim.new(0,12)

local listScroll = Instance.new("ScrollingFrame", List)
listScroll.Size = UDim2.new(1,-8,1,-8); listScroll.Position = UDim2.new(0,4,0,4)
listScroll.BackgroundTransparency = 1; listScroll.BorderSizePixel = 0
listScroll.ScrollBarThickness = 0; listScroll.CanvasSize = UDim2.new(0,0,0,0)
listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; listScroll.ZIndex = 22

local listLayout = Instance.new("UIListLayout", listScroll)
listLayout.Padding = UDim.new(0,4); listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Area = Instance.new("Frame", Menu)
Area.Size = UDim2.new(1,-154,1,-70); Area.Position = UDim2.new(0,146,0,56)
Area.BackgroundColor3 = T.panel; Area.BackgroundTransparency = 0.4
Area.BorderSizePixel = 0; Area.ZIndex = 21
local ac = Instance.new("UICorner", Area); ac.CornerRadius = UDim.new(0,12)

local areaScroll = Instance.new("ScrollingFrame", Area)
areaScroll.Size = UDim2.new(1,-8,1,-8); areaScroll.Position = UDim2.new(0,4,0,4)
areaScroll.BackgroundTransparency = 1; areaScroll.BorderSizePixel = 0
areaScroll.ScrollBarThickness = 4; areaScroll.ScrollBarImageColor3 = T.accent
areaScroll.CanvasSize = UDim2.new(0,0,0,0); areaScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
areaScroll.ZIndex = 22

local areaLayout = Instance.new("UIListLayout", areaScroll)
areaLayout.Padding = UDim.new(0,5); areaLayout.SortOrder = Enum.SortOrder.LayoutOrder

local footer = Instance.new("Frame", Menu)
footer.Size = UDim2.new(1,0,0,18); footer.Position = UDim2.new(0,0,1,-18)
footer.BackgroundColor3 = T.bg2; footer.BorderSizePixel = 0; footer.ZIndex = 21
local fLine = Instance.new("Frame", footer)
fLine.Size = UDim2.new(1,0,0,1); fLine.BackgroundColor3 = T.accent
fLine.BorderSizePixel = 0; fLine.BackgroundTransparency = 0.5
local fLbl = Instance.new("TextLabel", footer)
fLbl.Size = UDim2.new(1,0,1,0); fLbl.BackgroundTransparency = 1
fLbl.Text = "✦ v12.2 · Long-press to pin · Drag to move ✦"
fLbl.TextColor3 = T.accent2; fLbl.Font = Enum.Font.GothamBold; fLbl.TextSize = 9

--═══════════════════════════════════════════════════════════════
-- ESP
--═══════════════════════════════════════════════════════════════
local espGui = Instance.new("ScreenGui", gui)
espGui.Name = "ESP"; espGui.IgnoreGuiInset = true
espGui.ResetOnSpawn = false; espGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function clearESP()
    for _, obj in ipairs(espGui:GetChildren()) do pcall(function() obj:Destroy() end) end
end

local function addESP(target, color, label)
    if not target then return end
    pcall(function()
        local hl = Instance.new("Highlight")
        hl.FillColor = color; hl.OutlineColor = color
        hl.FillTransparency = 0.55; hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = target; hl.Parent = espGui
        if label then
            local bb = Instance.new("BillboardGui", espGui)
            bb.AlwaysOnTop = true; bb.Size = UDim2.new(0,80,0,20)
            bb.StudsOffset = Vector3.new(0, 2.8, 0); bb.MaxDistance = 500
            bb.Adornee = target:FindFirstChild("Head") or target:FindFirstChildWhichIsA("BasePart") or target
            local tl = Instance.new("TextLabel", bb)
            tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1
            tl.Text = label; tl.TextColor3 = color
            tl.Font = Enum.Font.GothamBlack; tl.TextSize = 13
            tl.TextStrokeTransparency = 0
        end
    end)
end

--═══════════════════════════════════════════════════════════════
-- UNIVERSAL LOGIC
--═══════════════════════════════════════════════════════════════
local flyBV, flyBG, flyConn
local function startFly()
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    if flyConn then flyConn:Disconnect() end
    local char = LP.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
    flyBV.Velocity = Vector3.zero; flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
    flyBG.P = 1000; flyBG.D = 50
    flyBG.CFrame = hrp.CFrame; flyBG.Parent = hrp
    flyConn = RunService.RenderStepped:Connect(function()
        if not State.flyOn or not flyBV or not flyBG then return end
        pcall(function()
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
        or string.sub(string.lower(p.DisplayName),1,#name) == name) then
            return p
        end
    end
end

local noclipConn
local function startNoclip()
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        if not State.noclipOn or not LP.Character then return end
        pcall(function()
            for _, p in ipairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
            end
        end)
    end)
end

local hitboxConn
local function startLoopHitbox()
    if hitboxConn then hitboxConn:Disconnect() end
    hitboxConn = RunService.Heartbeat:Connect(function()
        if not State.loopHitbox then return end
        pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(State.hitboxSize, State.hitboxSize, State.hitboxSize)
                        hrp.Transparency = 0.3; hrp.CanCollide = false
                    end
                end
            end
        end)
    end)
end

--═══════════════════════════════════════════════════════════════
-- SKID FLING
--═══════════════════════════════════════════════════════════════
local function skidFling(targetPlayer)
    if not targetPlayer then notify("⚠️ YunoHub","No target selected",2) return end
    if not targetPlayer.Character then notify("⚠️ YunoHub","Target has no character",2) return end

    local Character = LP.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    if not Character or not Humanoid or not RootPart then
        notify("⚠️ YunoHub","Invalid local character",2); return
    end

    local TCharacter = targetPlayer.Character
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if not getgenv().FPDH then getgenv().FPDH = workspace.FallenPartsDestroyHeight end
    if RootPart.Velocity.Magnitude < 50 then getgenv().OldPos = RootPart.CFrame end
    if THead then workspace.CurrentCamera.CameraSubject = THead
    elseif Handle then workspace.CurrentCamera.CameraSubject = Handle
    elseif THumanoid and TRootPart then workspace.CurrentCamera.CameraSubject = THumanoid end
    if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

    local function FPos(BasePart, Pos, Ang)
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end

    local function SFBasePart(BasePart)
        local TimeToWait = 2; local Time = tick(); local Angle = 0
        repeat
            if RootPart and THumanoid then
                if BasePart.Velocity.Magnitude < 50 then
                    Angle = Angle + 100
                    FPos(BasePart, CFrame.new(0,1.5,0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,-1.5,0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(2.25,1.5,-2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(-2.25,-1.5,2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,1.5,0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,-1.5,0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                else
                    FPos(BasePart, CFrame.new(0,1.5,THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,-1.5,-THumanoid.WalkSpeed), CFrame.Angles(0,0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,1.5,THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,1.5,TRootPart.Velocity.Magnitude/1.25), CFrame.Angles(math.rad(90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,-1.5,-TRootPart.Velocity.Magnitude/1.25), CFrame.Angles(0,0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,1.5,TRootPart.Velocity.Magnitude/1.25), CFrame.Angles(math.rad(90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,-1.5,0), CFrame.Angles(math.rad(90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,-1.5,0), CFrame.Angles(0,0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,-1.5,0), CFrame.Angles(math.rad(-90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0,-1.5,0), CFrame.Angles(0,0,0)); task.wait()
                end
            else break end
        until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= targetPlayer.Character
        or targetPlayer.Parent ~= Players or targetPlayer.Character ~= TCharacter
        or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
    end

    workspace.FallenPartsDestroyHeight = 0/0
    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"; BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    if TRootPart and THead then
        if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then SFBasePart(THead) else SFBasePart(TRootPart) end
    elseif TRootPart and not THead then SFBasePart(TRootPart)
    elseif not TRootPart and THead then SFBasePart(THead)
    elseif not TRootPart and not THead and Accessory and Handle then SFBasePart(Handle)
    else notify("⚠️ YunoHub","Can't find valid part to fling",2) end

    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = Humanoid
    repeat
        RootPart.CFrame = getgenv().OldPos * CFrame.new(0,.5,0)
        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0,.5,0))
        Humanoid:ChangeState("GettingUp")
        for _, x in pairs(Character:GetChildren()) do
            if x:IsA("BasePart") then x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new() end
        end
        task.wait()
    until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
    workspace.FallenPartsDestroyHeight = getgenv().FPDH
end

--═══════════════════════════════════════════════════════════════
-- MM2 LOGIC
--═══════════════════════════════════════════════════════════════
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
local function getClosestPlayer(exclude)
    exclude = exclude or {}
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil, math.huge end
    local closest, minD = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and not exclude[p] then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - myHRP.Position).Magnitude
                if d < minD then minD = d; closest = p end
            end
        end
    end
    return closest, minD
end

local function reloadESP()
    clearESP()
    if not State.playerESP then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            if p == findMurderer() then
                addESP(p.Character, Color3.fromRGB(255,60,60), "🗡 Murderer")
            elseif p == findSheriff() then
                addESP(p.Character, Color3.fromRGB(60,150,255), "🔫 Sheriff")
            else
                addESP(p.Character, Color3.fromRGB(80,220,120))
            end
        end
    end
end

local function getPredictedPosition(targetPlayer, offset)
    if not targetPlayer or not targetPlayer.Character then return Vector3.zero end
    local char = targetPlayer.Character
    local playerHRP = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
    local playerHum = char:FindFirstChild("Humanoid")
    if not playerHRP or not playerHum then return Vector3.zero end
    local velocity = playerHRP.AssemblyLinearVelocity
    local moveDir = playerHum.MoveDirection
    return playerHRP.Position + (velocity * Vector3.new(0.75,0.5,0.75)) * (offset/15) + moveDir * offset
end

local function shootMurderer()
    if findSheriff() ~= LP then notify("⚠️ YunoHub","You're not sheriff",2) return end
    local murderer = findMurderer(); if not murderer or not murderer.Character then return end
    if not LP.Character:FindFirstChild("Gun") then
        if LP.Backpack:FindFirstChild("Gun") then
            LP.Character:FindFirstChildOfClass("Humanoid"):EquipTool(LP.Backpack:FindFirstChild("Gun"))
        else return end
    end
    task.wait(0.05)
    local mHRP = murderer.Character:FindFirstChild("HumanoidRootPart"); if not mHRP then return end
    local predPos = getPredictedPosition(murderer, State.shootOffset)
    pcall(function()
        if State.instakillshoot then
            LP.Character:WaitForChild("Gun"):WaitForChild("Shoot"):FireServer(
                CFrame.new(mHRP.Position + Vector3.new(0,1,0)),
                CFrame.new(mHRP.Position)
            )
        else
            LP.Character:WaitForChild("Gun"):WaitForChild("Shoot"):FireServer(
                CFrame.new(LP.Character:FindFirstChild("RightHand").Position),
                CFrame.new(predPos)
            )
        end
    end)
end

local function knifeThrow(silent)
    if findMurderer() ~= LP then
        if silent then return end
        notify("⚠️ YunoHub","Not murderer",2); return
    end
    if not LP.Character:FindFirstChild("Knife") then
        if LP.Backpack:FindFirstChild("Knife") then
            LP.Character:FindFirstChildOfClass("Humanoid"):EquipTool(LP.Backpack:FindFirstChild("Knife"))
        else
            if silent then return end
            notify("⚠️ YunoHub","No knife",2); return
        end
    end
    task.wait(0.05)
    local closest = getClosestPlayer()
    if closest and closest.Character then
        local tHRP = closest.Character:FindFirstChild("HumanoidRootPart"); if not tHRP then return end
        local argsThrowRemote = {
            CFrame.new(LP.Character.RightHand.Position),
            CFrame.new(getPredictedPosition(closest, State.shootOffset + 1)),
        }
        if State.spawnAtPlayer then
            argsThrowRemote[1] = CFrame.new(tHRP.Position + (tHRP.CFrame.LookVector * 5))
        end
        pcall(function()
            LP.Character:WaitForChild("Knife"):WaitForChild("Events"):WaitForChild("KnifeThrown"):FireServer(unpack(argsThrowRemote))
        end)
    end
end

local function killClosest()
    if findMurderer() ~= LP then notify("⚠️ YunoHub","Not murderer",2) return end
    if not LP.Character:FindFirstChild("Knife") and LP.Backpack:FindFirstChild("Knife") then
        LP.Character:FindFirstChildOfClass("Humanoid"):EquipTool(LP.Backpack:FindFirstChild("Knife"))
    end
    task.wait(0.05)
    local closest = getClosestPlayer()
    if not closest then return end
    local nearestHRP = closest.Character:FindFirstChild("HumanoidRootPart"); if not nearestHRP then return end
    nearestHRP.Anchored = true
    nearestHRP.CFrame = LP.Character.HumanoidRootPart.CFrame + LP.Character.HumanoidRootPart.CFrame.LookVector * 2
    task.wait(0.08)
    pcall(function() LP.Character.Knife.Stab:FireServer("Slash") end)
    task.wait(0.08)
    nearestHRP.Anchored = false
end

local function killEveryone()
    if findMurderer() ~= LP then notify("⚠️ YunoHub","Not murderer",2) return end
    if not LP.Character:FindFirstChild("Knife") and LP.Backpack:FindFirstChild("Knife") then
        LP.Character:FindFirstChildOfClass("Humanoid"):EquipTool(LP.Backpack:FindFirstChild("Knife"))
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LP then
            player.Character.HumanoidRootPart.Anchored = true
            player.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + LP.Character.HumanoidRootPart.CFrame.LookVector * 1
        end
    end
    task.wait(0.1)
    pcall(function() LP.Character.Knife.Stab:FireServer("Slash") end)
    task.wait(0.1)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LP then
            player.Character.HumanoidRootPart.Anchored = false
        end
    end
end

local function holdEveryoneHostage()
    if findMurderer() ~= LP then notify("⚠️ YunoHub","Not murderer",2) return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LP then
            player.Character.HumanoidRootPart.Anchored = true
            player.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + LP.Character.HumanoidRootPart.CFrame.LookVector * 5
        end
    end
    notify("YunoHub","Everyone anchored in one point",3)
end

local function godMode()
    local Cam = workspace.CurrentCamera
    local Pos, Char = Cam.CFrame, LP.Character
    if not Char then return end
    local Human = Char:FindFirstChildWhichIsA("Humanoid")
    if not Human then return end
    local nHuman = Human:Clone()
    nHuman.Parent, LP.Character = Char, nil
    nHuman:SetStateEnabled(15, false)
    nHuman:SetStateEnabled(1, false)
    nHuman:SetStateEnabled(0, false)
    nHuman.BreakJointsOnDeath, Human = true, Human:Destroy()
    LP.Character, Cam.CameraSubject, Cam.CFrame = Char, nHuman, Pos
    nHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    local Script = Char:FindFirstChild("Animate")
    if Script then Script.Disabled = true; task.wait(); Script.Disabled = false end
    nHuman.Health = nHuman.MaxHealth
    notify("YunoHub","God mode enabled (unstable)",3)
end

local function sendRolesInChat()
    local tc = game:GetService("TextChatService")
    if not tc then return end
    local m = findMurderer(); local s = findSheriff()
    local msg = string.format("Murderer: %s | Sheriff: %s | <<YunoHub>>", m and m.Name or "-", s and s.Name or "-")
    for _, ch in ipairs(tc:WaitForChild("TextChannels"):GetChildren()) do
        if ch.Name ~= "RBXSystem" then pcall(function() ch:SendAsync(msg) end) end
    end
end

--═══════════════════════════════════════════════════════════════
-- AUTO LOOPS
--═══════════════════════════════════════════════════════════════
local _autoLocks = {}
local function canRun(key, cooldown)
    cooldown = cooldown or 2
    local now = tick()
    if not _autoLocks[key] or now - _autoLocks[key] >= cooldown then
        _autoLocks[key] = now
        return true
    end
    return false
end

task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if State.autoFlingSheriff then
                local s = findSheriff()
                if s and s ~= LP and canRun("autoFlingSheriff", 4) then
                    task.spawn(skidFling, s)
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if State.autoFlingMurderer then
                local m = findMurderer()
                if m and m ~= LP and canRun("autoFlingMurderer", 4) then
                    task.spawn(skidFling, m)
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if State.autoFlingClosest then
                local c = getClosestPlayer()
                if c and canRun("autoFlingClosest", 4) then
                    task.spawn(skidFling, c)
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if State.autoFlingAny then
                local target = findMurderer() or findSheriff() or getClosestPlayer()
                if target and target ~= LP and canRun("autoFlingAny", 4) then
                    task.spawn(skidFling, target)
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            if State.autoEquipKnife and findMurderer() == LP then
                if not LP.Character:FindFirstChild("Knife") and LP.Backpack:FindFirstChild("Knife") then
                    pcall(function()
                        LP.Character:FindFirstChildOfClass("Humanoid"):EquipTool(LP.Backpack:FindFirstChild("Knife"))
                    end)
                end
            end
            if State.autoEquipGun and findSheriff() == LP then
                if not LP.Character:FindFirstChild("Gun") and LP.Backpack:FindFirstChild("Gun") then
                    pcall(function()
                        LP.Character:FindFirstChildOfClass("Humanoid"):EquipTool(LP.Backpack:FindFirstChild("Gun"))
                    end)
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        pcall(function()
            if State.autoKnifeOnMurderer and findMurderer() == LP then
                pcall(knifeThrow, true)
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.4)
        pcall(function()
            if State.autoGunOnSheriff and findSheriff() == LP then
                pcall(shootMurderer)
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.4)
        pcall(function()
            if State.autoKillClosest and findMurderer() == LP then
                local c, d = getClosestPlayer()
                if c and d < 15 then pcall(killClosest) end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if State.autoKillEveryone and findMurderer() == LP then
                pcall(killEveryone)
            end
        end)
    end
end)

local lastMapTP = 0
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if State.autoTPMap then
                local map = getMap()
                if map and map:FindFirstChild("Spawns") and LP.Character and tick() - lastMapTP > 15 then
                    local sps = map.Spawns:GetChildren()
                    if #sps > 0 then
                        lastMapTP = tick()
                        local sp = sps[math.random(1,#sps)]
                        pcall(function()
                            LP.Character:PivotTo(CFrame.new(sp.Position + Vector3.new(0,3,0)))
                        end)
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if State.autoGetGun then
                local map = getMap()
                if map and map:FindFirstChild("GunDrop") and LP.Character then
                    pcall(function()
                        local prev = LP.Character:GetPivot()
                        LP.Character:PivotTo(map.GunDrop:GetPivot())
                        task.wait(0.3)
                        if LP.Backpack:FindFirstChild("Gun") then
                            LP.Character:FindFirstChildOfClass("Humanoid"):EquipTool(LP.Backpack.Gun)
                        end
                        LP.Character:PivotTo(prev)
                    end)
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        pcall(function()
            if State.autoUnfreeze and LP.Character then
                local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                if hum then
                    if hum.PlatformStand then hum.PlatformStand = false end
                    if hum.WalkSpeed < 8 then hum.WalkSpeed = 16 end
                    if hum.JumpPower < 30 then hum.JumpPower = 50 end
                end
                if hrp and hrp.Anchored then
                    if not State.killAura and not State.autoKillClosest then
                        hrp.Anchored = false
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        pcall(function()
            if State.autoAntiflingPermanent and LP.Character then
                local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if hrp.AssemblyLinearVelocity.Magnitude > 250 or hrp.AssemblyAngularVelocity.Magnitude > 250 then
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
        end)
    end
end)

local lastRoleSent = nil
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if State.autoSendRoles then
                local m = findMurderer()
                if m and m.Name ~= lastRoleSent then
                    lastRoleSent = m.Name
                    pcall(sendRolesInChat)
                elseif not m then
                    lastRoleSent = nil
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        pcall(function()
            if State.autoJumpSpam and LP.Character then
                local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            if State.autoCameraLock then
                local m = findMurderer()
                if m and m.Character then
                    local hrp = m.Character:FindFirstChild("HumanoidRootPart")
                    local cam = workspace.CurrentCamera
                    if hrp and cam then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, hrp.Position)
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            if State.autoStabAura and findMurderer() == LP and LP.Character:FindFirstChild("Knife") then
                local myHRP = LP.Character:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then
                            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - myHRP.Position).Magnitude < 8 then
                                pcall(function() LP.Character.Knife.Stab:FireServer("Slash") end)
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            if State.autoAttackSheriff and findMurderer() == LP then
                local s = findSheriff()
                if s and s.Character then
                    local hrp = s.Character:FindFirstChild("HumanoidRootPart")
                    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and myHRP and (hrp.Position - myHRP.Position).Magnitude < 30 then
                        pcall(knifeThrow, true)
                    end
                end
            end
        end)
    end
end)

local lastRoundInfo = nil
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if State.autoRoundInfo then
                local m = findMurderer()
                local s = findSheriff()
                if m and (not lastRoundInfo or lastRoundInfo ~= m.Name) then
                    lastRoundInfo = m.Name
                    notify("🎮 ROUND INFO", 
                        "🗡 Murderer: "..(m and m.Name or "?").."  |  🔫 Sheriff: "..(s and s.Name or "?"), 8)
                elseif not m then
                    lastRoundInfo = nil
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if State.autoEverything then
                State.autoFlingSheriff = true
                State.autoFlingMurderer = true
                State.autoEquipKnife = true
                State.autoEquipGun = true
                State.autoKnifeOnMurderer = true
                State.autoGunOnSheriff = true
                State.autoUnfreeze = true
                State.autoAntiflingPermanent = true
                State.autoGetGun = true
            end
        end)
    end
end)

local flingDetectionCon, flingNeutralizerCon
local detectedPlayers = {}
local antiFlingLastPos = Vector3.zero
local function startAntiFling()
    if flingDetectionCon then flingDetectionCon:Disconnect() end
    if flingNeutralizerCon then flingNeutralizerCon:Disconnect() end
    flingDetectionCon = RunService.Heartbeat:Connect(function()
        pcall(function()
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LP and pl.Character and pl.Character:IsDescendantOf(workspace) then
                    local root = pl.Character.PrimaryPart or pl.Character:FindFirstChild("HumanoidRootPart")
                    if root and (root.AssemblyAngularVelocity.Magnitude > 50 or root.AssemblyLinearVelocity.Magnitude > 100) then
                        if not detectedPlayers[pl.Name] then
                            notify("🛡 Anti-Fling","Flinger detected: "..pl.Name,3)
                            detectedPlayers[pl.Name] = true
                        end
                        for _, p in ipairs(pl.Character:GetDescendants()) do
                            if p:IsA("BasePart") then
                                p.CanCollide = false
                                p.AssemblyAngularVelocity = Vector3.zero
                                p.AssemblyLinearVelocity = Vector3.zero
                                p.CustomPhysicalProperties = PhysicalProperties.new(0,0,0)
                            end
                        end
                    end
                end
            end
        end)
    end)
    flingNeutralizerCon = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LP.Character
            if char and char.PrimaryPart then
                if char.PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or char.PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
                    notify("🛡 Anti-Fling","You were flung. Neutralizing!",2)
                    char.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
                    char.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
                    if antiFlingLastPos ~= Vector3.zero then
                        char.PrimaryPart.CFrame = CFrame.new(antiFlingLastPos)
                    end
                else
                    antiFlingLastPos = char.PrimaryPart.Position
                end
            end
        end)
    end)
end
local function stopAntiFling()
    if flingDetectionCon then flingDetectionCon:Disconnect() end
    if flingNeutralizerCon then flingNeutralizerCon:Disconnect() end
    detectedPlayers = {}
end

--═══════════════════════════════════════════════════════════════
-- UI BUILDERS
--═══════════════════════════════════════════════════════════════
local activePage = "universal"
local pages = {}

local function clearArea()
    for _, c in ipairs(areaScroll:GetChildren()) do
        if not c:IsA("UIListLayout") then pcall(function() c:Destroy() end) end
    end
end

local function makeSection(title, iconId)
    local s = Instance.new("Frame", areaScroll)
    s.Size = UDim2.new(1,-6,0,28); s.BackgroundTransparency = 1
    s.LayoutOrder = #areaScroll:GetChildren()
    local bg = Instance.new("Frame", s)
    bg.Size = UDim2.new(0,180,1,0); bg.Position = UDim2.new(0,4,0,0)
    bg.BackgroundColor3 = T.bg1; bg.BorderSizePixel = 0
    local c = Instance.new("UICorner", bg); c.CornerRadius = UDim.new(0,6)
    if iconId then mkImage(bg, iconId, UDim2.new(0,16,0,16), UDim2.new(0,5,0.5,-8), T.accent) end
    local l = Instance.new("TextLabel", bg)
    l.Size = UDim2.new(1,-26,1,0); l.Position = UDim2.new(0,26,0,0)
    l.BackgroundTransparency = 1; l.Text = title
    l.TextColor3 = T.accent; l.Font = Enum.Font.GothamBlack
    l.TextSize = 10; l.TextXAlignment = Enum.TextXAlignment.Left
end

local function addRipple(parent, x, y)
    local r = Instance.new("Frame", parent)
    r.Size = UDim2.new(0,0,0,0); r.Position = UDim2.new(0,x,0,y)
    r.AnchorPoint = Vector2.new(0.5,0.5)
    r.BackgroundColor3 = T.accent2; r.BackgroundTransparency = 0.6
    r.BorderSizePixel = 0; r.ZIndex = 5
    local rc = Instance.new("UICorner", r); rc.CornerRadius = UDim.new(1,0)
    TweenService:Create(r, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
        Size = UDim2.new(0,120,0,120), BackgroundTransparency = 1,
    }):Play()
    task.delay(0.55, function() pcall(function() if r.Parent then r:Destroy() end end) end)
end

local function requestPin(key, name, iconId, action)
    playSound(S.WARN, 0.35, 1.2)
    showConfirm("📌 Pin this button?", name, "It will become a floating draggable button.",
        function() spawnFloatingButton(key, name, iconId or A.STAR, action) end,
        function() playSound(S.NO, 0.3, 0.9) end)
end

local function makeBtn(key, name, iconId, callback)
    local b = Instance.new("TextButton", areaScroll)
    b.Size = UDim2.new(1,-6,0,42); b.BackgroundColor3 = T.section
    b.BorderSizePixel = 0; b.Text = ""; b.AutoButtonColor = false
    b.ClipsDescendants = true; b.LayoutOrder = #areaScroll:GetChildren()
    local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,10)
    local st = Instance.new("UIStroke", b); st.Color = T.accent; st.Thickness = 1; st.Transparency = 0.55

    local iconBg = Instance.new("Frame", b)
    iconBg.Size = UDim2.new(0,28,0,28); iconBg.Position = UDim2.new(0,7,0.5,-14)
    iconBg.BackgroundColor3 = T.panelHover; iconBg.BorderSizePixel = 0
    local ibc = Instance.new("UICorner", iconBg); ibc.CornerRadius = UDim.new(0,7)
    if iconId then mkImage(iconBg, iconId, UDim2.new(0,18,0,18), UDim2.new(0.5,-9,0.5,-9), T.accent2) end

    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.new(1,-56,1,0); l.Position = UDim2.new(0,42,0,0)
    l.BackgroundTransparency = 1; l.Text = name
    l.TextColor3 = T.text; l.Font = Enum.Font.GothamBold
    l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 3

    local pinHint = mkImage(b, A.PIN, UDim2.new(0,14,0,14), UDim2.new(1,-20,0.5,-7), T.textDim)
    pinHint.ImageTransparency = 0.55; pinHint.ZIndex = 3

    local holding = false; local holdTask = nil; local lastFire = 0
    local function fireAction()
        if os.clock() - lastFire < 0.15 then return end
        lastFire = os.clock()
        playSound(S.CLICK, 0.4, 0.95 + math.random()*0.1)
        pcall(callback)
    end
    local function startHold(startVec)
        holding = true
        holdTask = task.delay(0.55, function()
            if holding then holding = false; requestPin(key, name, iconId, callback) end
        end)
        _activeHold = { start = startVec, cancel = function()
            holding = false
            if holdTask then task.cancel(holdTask); holdTask = nil end
        end }
    end
    local function cancelHold()
        holding = false
        if holdTask then task.cancel(holdTask); holdTask = nil end
        _activeHold = nil
    end

    b.MouseEnter:Connect(function()
        playSound(S.HOVER, 0.07, 1.5)
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.panelHover }):Play()
        TweenService:Create(st, TweenInfo.new(0.15), { Transparency = 0.15 }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.section }):Play()
        TweenService:Create(st, TweenInfo.new(0.15), { Transparency = 0.55 }):Play()
    end)
    b.MouseButton1Down:Connect(function(x,y)
        startHold(Vector2.new(x, y))
        addRipple(b, x - b.AbsolutePosition.X, y - b.AbsolutePosition.Y)
    end)
    b.MouseButton1Up:Connect(function() if holding then cancelHold(); fireAction() end end)
    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            startHold(Vector2.new(input.Position.X, input.Position.Y))
        end
    end)
    b.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and holding then
            cancelHold(); fireAction()
        end
    end)
    return b
end

local function makeToggle(key, name, iconId, default, callback)
    local b = Instance.new("TextButton", areaScroll)
    b.Size = UDim2.new(1,-6,0,42); b.BackgroundColor3 = T.section
    b.BorderSizePixel = 0; b.Text = ""; b.AutoButtonColor = false
    b.ClipsDescendants = true; b.LayoutOrder = #areaScroll:GetChildren()
    local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,10)
    local st = Instance.new("UIStroke", b)
    st.Color = T.accent; st.Thickness = 1
    st.Transparency = default and 0.15 or 0.55

    local iconBg = Instance.new("Frame", b)
    iconBg.Size = UDim2.new(0,28,0,28); iconBg.Position = UDim2.new(0,7,0.5,-14)
    iconBg.BackgroundColor3 = T.panelHover; iconBg.BorderSizePixel = 0
    local ibc = Instance.new("UICorner", iconBg); ibc.CornerRadius = UDim.new(0,7)
    if iconId then mkImage(iconBg, iconId, UDim2.new(0,18,0,18), UDim2.new(0.5,-9,0.5,-9), T.accent2) end

    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.new(1,-100,1,0); l.Position = UDim2.new(0,42,0,0)
    l.BackgroundTransparency = 1; l.Text = name
    l.TextColor3 = T.text; l.Font = Enum.Font.GothamBold
    l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 3

    local pinHint = mkImage(b, A.PIN, UDim2.new(0,12,0,12), UDim2.new(1,-60,0.5,-6), T.textDim)
    pinHint.ImageTransparency = 0.6; pinHint.ZIndex = 3

    local sw = Instance.new("Frame", b)
    sw.Size = UDim2.new(0,38,0,20); sw.Position = UDim2.new(1,-46,0.5,-10)
    sw.BackgroundColor3 = default and Color3.fromRGB(80,180,100) or Color3.fromRGB(60,55,45)
    sw.BorderSizePixel = 0; sw.ZIndex = 3
    local sc = Instance.new("UICorner", sw); sc.CornerRadius = UDim.new(1,0)
    local knob = Instance.new("Frame", sw)
    knob.Size = UDim2.new(0,16,0,16)
    knob.Position = default and UDim2.new(1,-18,0,2) or UDim2.new(0,2,0,2)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0; knob.ZIndex = 4
    local kc = Instance.new("UICorner", knob); kc.CornerRadius = UDim.new(1,0)

    local state = default
    local function setState(v, silent)
        state = v
        if not silent then playSound(state and S.AUTO_ON or S.AUTO_OFF, 0.4, state and 1.2 or 0.9) end
        if state then
            TweenService:Create(knob, TweenInfo.new(0.2), { Position = UDim2.new(1,-18,0,2) }):Play()
            TweenService:Create(sw, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(80,180,100) }):Play()
            TweenService:Create(st, TweenInfo.new(0.2), { Transparency = 0.15 }):Play()
        else
            TweenService:Create(knob, TweenInfo.new(0.2), { Position = UDim2.new(0,2,0,2) }):Play()
            TweenService:Create(sw, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(60,55,45) }):Play()
            TweenService:Create(st, TweenInfo.new(0.2), { Transparency = 0.55 }):Play()
        end
    end

    local holding = false; local holdTask = nil; local lastFire = 0
    local toggleCallback = function()
        if os.clock() - lastFire < 0.15 then return end
        lastFire = os.clock()
        setState(not state)
        if callback then callback(state) end
    end
    local function startHold(startVec)
        holding = true
        holdTask = task.delay(0.55, function()
            if holding then holding = false; requestPin(key, name, iconId, toggleCallback) end
        end)
        _activeHold = { start = startVec, cancel = function()
            holding = false
            if holdTask then task.cancel(holdTask); holdTask = nil end
        end }
    end
    local function cancelHold()
        holding = false
        if holdTask then task.cancel(holdTask); holdTask = nil end
        _activeHold = nil
    end

    b.MouseEnter:Connect(function() playSound(S.HOVER, 0.07, 1.5) end)
    b.MouseButton1Down:Connect(function(x,y)
        startHold(Vector2.new(x, y))
        addRipple(b, x - b.AbsolutePosition.X, y - b.AbsolutePosition.Y)
    end)
    b.MouseButton1Up:Connect(function() if holding then cancelHold(); toggleCallback() end end)
    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            startHold(Vector2.new(input.Position.X, input.Position.Y))
        end
    end)
    b.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and holding then
            cancelHold(); toggleCallback()
        end
    end)
    return { set = function(v) setState(v, true); if callback then callback(v) end end }
end

local function makeInput(placeholder, buttonText, callback)
    local row = Instance.new("Frame", areaScroll)
    row.Size = UDim2.new(1,-6,0,44); row.BackgroundColor3 = T.section
    row.BorderSizePixel = 0; row.LayoutOrder = #areaScroll:GetChildren()
    local c = Instance.new("UICorner", row); c.CornerRadius = UDim.new(0,10)
    local st = Instance.new("UIStroke", row); st.Color = T.accent; st.Thickness = 1; st.Transparency = 0.55
    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(1,-100,0,32); box.Position = UDim2.new(0,6,0.5,-16)
    box.BackgroundColor3 = T.bg2; box.BorderSizePixel = 0; box.Text = ""
    box.PlaceholderText = placeholder; box.PlaceholderColor3 = T.textDim
    box.TextColor3 = T.text; box.Font = Enum.Font.GothamMedium
    box.TextSize = 11; box.ClearTextOnFocus = false
    local bc = Instance.new("UICorner", box); bc.CornerRadius = UDim.new(0,6)
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0,84,0,32); btn.Position = UDim2.new(1,-90,0.5,-16)
    btn.BackgroundColor3 = T.panelHover; btn.BorderSizePixel = 0
    btn.Text = buttonText or "Set"; btn.TextColor3 = T.accent
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.AutoButtonColor = false
    local bc2 = Instance.new("UICorner", btn); bc2.CornerRadius = UDim.new(0,6)
    local bs = Instance.new("UIStroke", btn); bs.Color = T.accent; bs.Thickness = 1; bs.Transparency = 0.5
    box.Focused:Connect(function() playSound(S.HOVER, 0.13, 1.4) end)
    onTap(btn, function() callback(box.Text) end)
end

local function makeRange(name, minV, maxV, default, callback)
    local row = Instance.new("Frame", areaScroll)
    row.Size = UDim2.new(1,-6,0,54); row.BackgroundColor3 = T.section
    row.BorderSizePixel = 0; row.LayoutOrder = #areaScroll:GetChildren()
    local c = Instance.new("UICorner", row); c.CornerRadius = UDim.new(0,10)
    local st = Instance.new("UIStroke", row); st.Color = T.accent; st.Thickness = 1; st.Transparency = 0.55
    local l = Instance.new("TextLabel", row)
    l.Size = UDim2.new(1,-80,0,16); l.Position = UDim2.new(0,10,0,6)
    l.BackgroundTransparency = 1; l.Text = name
    l.TextColor3 = T.text; l.Font = Enum.Font.GothamBold
    l.TextSize = 11; l.TextXAlignment = Enum.TextXAlignment.Left
    local vl = Instance.new("TextLabel", row)
    vl.Size = UDim2.new(0,55,0,16); vl.Position = UDim2.new(1,-60,0,6)
    vl.BackgroundTransparency = 1; vl.Text = tostring(default)
    vl.TextColor3 = T.accent; vl.Font = Enum.Font.GothamBold
    vl.TextSize = 11; vl.TextXAlignment = Enum.TextXAlignment.Right
    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1,-20,0,10); track.Position = UDim2.new(0,10,1,-18)
    track.BackgroundColor3 = T.bg2; track.BorderSizePixel = 0
    local tc = Instance.new("UICorner", track); tc.CornerRadius = UDim.new(1,0)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((default - minV)/(maxV - minV),0,1,0)
    fill.BackgroundColor3 = T.accent; fill.BorderSizePixel = 0
    local fc = Instance.new("UICorner", fill); fc.CornerRadius = UDim.new(1,0)
    local dragging2 = false
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging2 = true; playSound(S.HOVER, 0.1, 1.5)
        end
    end)
    track.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging2 = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging2 and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local relX = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = minV + relX * (maxV - minV)
            if maxV - minV <= 5 then val = math.round(val) else val = math.floor(val) end
            fill.Size = UDim2.new(relX,0,1,0); vl.Text = tostring(val)
            if callback then callback(val) end
        end
    end)
end

--═══════════════════════════════════════════════════════════════
-- PAGES
--═══════════════════════════════════════════════════════════════

pages.universal = function()
    clearArea()
    makeSection("✈ Flight", A.PLANE)
    makeToggle("op_fly", "OP Fly", A.PLANE, State.flyOn, function(v)
        State.flyOn = v
        if v then startFly() else stopFly() end
    end)
    makeRange("Fly speed", 20, 300, State.flySpeed, function(v) State.flySpeed = v end)

    makeSection("⚡ Movement", A.LIGHTNING)
    makeToggle("inf_jump", "Infinite Jump", A.LIGHTNING, State.infJump, function(v) State.infJump = v end)
    makeInput("Walkspeed", "Set", function(v)
        local n = tonumber(v)
        if n and LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = n; State.ws = n end
        end
    end)
    makeBtn("ws_up", "Walkspeed +2", A.STAR, function()
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then State.ws = State.ws + 2; h.WalkSpeed = State.ws end
    end)
    makeBtn("ws_down", "Walkspeed -2", A.CROSS, function()
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then State.ws = State.ws - 2; h.WalkSpeed = State.ws end
    end)
    makeInput("FOV", "Set", function(v)
        local n = tonumber(v)
        if n then workspace.CurrentCamera.FieldOfView = n; State.fov = n end
    end)
    makeToggle("loop_fov_ws", "Loop WS + FOV", A.LIGHTNING, State.loopFovWs, function(v) State.loopFovWs = v end)

    makeSection("💀 Hitbox", A.SKULL)
    makeInput("Hitbox size (1 = normal)", "Set", function(v)
        local n = tonumber(v) or 1; State.hitboxSize = n
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Size = Vector3.new(n,n,n); hrp.Transparency = 0.3; hrp.CanCollide = false end
            end
        end
    end)
    makeToggle("loop_hitbox", "Loop Hitbox", A.SKULL, State.loopHitbox, function(v)
        State.loopHitbox = v; if v then startLoopHitbox() end
    end)

    makeSection("🛡 Protection", A.SHIELD)
    makeToggle("anti_fling", "Anti-Fling", A.SHIELD, State.antiFling, function(v)
        State.antiFling = v
        if v then startAntiFling() else stopAntiFling() end
    end)
    makeToggle("noclip", "Noclip", A.WING, State.noclipOn, function(v)
        State.noclipOn = v; if v then startNoclip() end
    end)

    makeSection("⚙ Misc", A.SETTINGS)
    makeBtn("anti_afk", "Anti-AFK", A.SHIELD, function()
        local vu = game:GetService("VirtualUser")
        track(LP.Idled:Connect(function() vu:CaptureController(); vu:ClickButton2(Vector2.new()) end))
        notify("YunoHub","✓ Anti-AFK enabled",2)
    end)
    makeBtn("fps_boost", "FPS Boost", A.LIGHTNING, function()
        local t = workspace:FindFirstChildOfClass("Terrain")
        if t then t.WaterWaveSize=0; t.WaterWaveSpeed=0; t.WaterReflectance=0; t.WaterTransparency=0 end
        game.Lighting.GlobalShadows = false; game.Lighting.FogEnd = 9e9
        pcall(function() settings().Rendering.QualityLevel = 1 end)
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0) end
        end
        notify("YunoHub","✓ FPS Boost applied",2)
    end)
    makeBtn("get_ping", "Get Ping", A.LIGHTNING, function()
        notify("YunoHub","📡 Ping: "..math.floor(LP:GetNetworkPing()*1000).." ms",3)
    end)
end

pages.auto = function()
    clearArea()

    makeSection("⭐ MASTER SWITCH", A.POWER)
    makeToggle("auto_everything", "🟢 AUTO EVERYTHING (activates all)", A.POWER, State.autoEverything, function(v)
        State.autoEverything = v
        if v then
            notify("YunoHub", "🔥 AUTO EVERYTHING ACTIVATED !", 5)
            playSound(S.AUTO_ON, 0.8, 0.9)
        end
    end)

    makeSection("🔥 Fling Auto", A.FIRE)
    makeToggle("auto_fling_sheriff", "Auto Fling Sheriff", A.FIRE, State.autoFlingSheriff, function(v) State.autoFlingSheriff = v end)
    makeToggle("auto_fling_murderer", "Auto Fling Murderer", A.FIRE, State.autoFlingMurderer, function(v) State.autoFlingMurderer = v end)
    makeToggle("auto_fling_closest", "Auto Fling Closest", A.FIRE, State.autoFlingClosest, function(v) State.autoFlingClosest = v end)
    makeToggle("auto_fling_any", "Auto Fling ANY (role priority)", A.TARGET, State.autoFlingAny, function(v) State.autoFlingAny = v end)

    makeSection("🔫 Weapons Auto", A.GUN)
    makeToggle("auto_equip_knife", "Auto equip Knife (murd)", A.KNIFE, State.autoEquipKnife, function(v) State.autoEquipKnife = v end)
    makeToggle("auto_equip_gun", "Auto equip Gun (sheriff)", A.GUN, State.autoEquipGun, function(v) State.autoEquipGun = v end)
    makeToggle("auto_knife_murd", "Auto Knife Throw (if murd)", A.KNIFE, State.autoKnifeOnMurderer, function(v) State.autoKnifeOnMurderer = v end)
    makeToggle("auto_gun_sher", "Auto Shoot Murderer (if sheriff)", A.GUN, State.autoGunOnSheriff, function(v) State.autoGunOnSheriff = v end)
    makeToggle("auto_shoot_murd", "Auto Shoot murderer (legacy)", A.TARGET, State.autoShooting, function(v)
        State.autoShooting = v
        if v then
            task.spawn(function()
                while State.autoShooting do
                    task.wait(1); pcall(shootMurderer)
                end
            end)
        end
    end)
    makeToggle("auto_knife_legacy", "Auto knife throw (legacy)", A.KNIFE, State.loopThrow, function(v)
        State.loopThrow = v
        if v then
            task.spawn(function()
                while State.loopThrow do
                    task.wait(1.5); pcall(function() knifeThrow(true) end)
                end
            end)
        end
    end)
    makeRange("Shoot offset", 1, 5, State.shootOffset, function(v) State.shootOffset = v end)

    makeSection("💀 Attacks Auto", A.SKULL)
    makeToggle("auto_kill_closest", "Auto Kill Closest (murd)", A.SKULL, State.autoKillClosest, function(v) State.autoKillClosest = v end)
    makeToggle("auto_kill_everyone", "Auto Kill EVERYONE (spam)", A.SKULL, State.autoKillEveryone, function(v) State.autoKillEveryone = v end)
    makeToggle("auto_stab_aura", "Auto Stab Aura (radius 8)", A.FIRE, State.autoStabAura, function(v) State.autoStabAura = v end)
    makeToggle("auto_attack_sheriff", "Auto Attack Sheriff (murd)", A.TARGET, State.autoAttackSheriff, function(v) State.autoAttackSheriff = v end)
    makeToggle("kill_aura_legacy", "Kill Aura (legacy)", A.FIRE, State.killAura, function(v)
        State.killAura = v
        if v then
            task.spawn(function()
                while State.killAura do
                    task.wait(0.15)
                    pcall(function()
                        if findMurderer() == LP and LP.Character and LP.Character:FindFirstChild("Knife") then
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LP then
                                    local hrp = player.Character.HumanoidRootPart
                                    if (hrp.Position - LP.Character.HumanoidRootPart.Position).Magnitude < 7 then
                                        hrp.Anchored = true
                                        hrp.CFrame = LP.Character.HumanoidRootPart.CFrame + LP.Character.HumanoidRootPart.CFrame.LookVector * 2
                                        task.wait(0.1)
                                        pcall(function() LP.Character.Knife.Stab:FireServer("Slash") end)
                                        task.wait(0.1)
                                        hrp.Anchored = false
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end)

    makeSection("✈ Teleport Auto", A.PLANE)
    makeToggle("auto_tp_map", "Auto TP to Map", A.PLANE, State.autoTPMap, function(v) State.autoTPMap = v end)
    makeToggle("auto_get_gun", "Auto Get Gun on Drop", A.GUN, State.autoGetGun, function(v) State.autoGetGun = v end)
    makeToggle("auto_tp_lobby", "Auto TP to Lobby on Death", A.HOME, State.autoTPLobby, function(v)
        State.autoTPLobby = v
        if v then
            track(LP.CharacterAdded:Connect(function()
                if State.autoTPLobby then
                    task.wait(3)
                    pcall(function()
                        local lobby = workspace:FindFirstChild("Lobby")
                        if lobby and lobby:FindFirstChild("Spawns") and LP.Character then
                            local sp = lobby.Spawns:FindFirstChildWhichIsA("SpawnLocation")
                            if sp then LP.Character:PivotTo(CFrame.new(sp.Position + Vector3.new(0,3,0))) end
                        end
                    end)
                end
            end))
        end
    end)

    makeSection("🛡 Protection Auto", A.SHIELD)
    makeToggle("auto_antifling", "Auto Anti-Fling PERMANENT", A.SHIELD, State.autoAntiflingPermanent, function(v) State.autoAntiflingPermanent = v end)
    makeToggle("auto_unfreeze", "Auto Unfreeze / Anti-Stun", A.LIGHTNING, State.autoUnfreeze, function(v) State.autoUnfreeze = v end)
    makeToggle("auto_jump_spam", "Auto Jump Spam (anti-trap)", A.LIGHTNING, State.autoJumpSpam, function(v) State.autoJumpSpam = v end)

    makeSection("📢 Info Auto", A.SEARCH)
    makeToggle("auto_send_roles", "Auto Send Roles in Chat", A.SEARCH, State.autoSendRoles, function(v) State.autoSendRoles = v end)
    makeToggle("auto_round_info", "Auto Round Info Notification", A.SEARCH, State.autoRoundInfo, function(v) State.autoRoundInfo = v end)
    makeToggle("auto_camera_lock", "Auto Camera Lock on Murderer", A.TARGET, State.autoCameraLock, function(v) State.autoCameraLock = v end)

    makeSection("🛑 Danger Zone", A.SKULL)
    makeBtn("reset_all_auto", "🛑 Disable ALL Auto Features", A.CROSS, function()
        State.autoEverything = false
        State.autoFlingSheriff = false; State.autoFlingMurderer = false
        State.autoFlingClosest = false; State.autoFlingAny = false
        State.autoEquipKnife = false; State.autoEquipGun = false
        State.autoKnifeOnMurderer = false; State.autoGunOnSheriff = false
        State.autoShooting = false; State.loopThrow = false
        State.autoKillClosest = false; State.autoKillEveryone = false
        State.autoStabAura = false; State.autoAttackSheriff = false
        State.killAura = false
        State.autoTPMap = false; State.autoGetGun = false; State.autoTPLobby = false
        State.autoAntiflingPermanent = false; State.autoUnfreeze = false
        State.autoJumpSpam = false
        State.autoSendRoles = false; State.autoRoundInfo = false; State.autoCameraLock = false
        notify("YunoHub", "🛑 All Auto disabled", 4)
        playSound(S.AUTO_OFF, 0.7, 0.9)
        pages.auto()
    end)
end

pages.ytmusic = function()
    clearArea()

    makeSection("🎵 YouTube Music Player", A.MUSIC)
    local infoBox = Instance.new("Frame", areaScroll)
    infoBox.Size = UDim2.new(1,-6,0,150); infoBox.BackgroundColor3 = T.section
    infoBox.BorderSizePixel = 0; infoBox.LayoutOrder = #areaScroll:GetChildren()
    local ibc = Instance.new("UICorner", infoBox); ibc.CornerRadius = UDim.new(0,10)
    local infoIcon = mkImage(infoBox, A.MUSICNOTE, UDim2.new(0,20,0,20), UDim2.new(0,8,0,8), T.accent2)
    local il = Instance.new("TextLabel", infoBox)
    il.Size = UDim2.new(1,-40,1,-16); il.Position = UDim2.new(0,34,0,8)
    il.BackgroundTransparency = 1
    il.Text = "🎧 Listen to any YouTube music in Roblox\n\n• YouTube search (title or link)\n• MP3 download + in-game playback\n• Equalizer, audio effects, MiniPlayer\n• Full draggable interface\n\nTap the green button to open the YMP UI !"
    il.TextColor3 = T.text; il.Font = Enum.Font.GothamBold
    il.TextSize = 11; il.TextXAlignment = Enum.TextXAlignment.Left
    il.TextYAlignment = Enum.TextYAlignment.Top; il.TextWrapped = true

    makeBtn("yt_launch", "▶ OPEN YouTube Music Player", A.MUSIC, function()
        if State.ytLoaded then
            notify("YunoHub", "✓ YMP already loaded", 3)
            return
        end
        notify("YunoHub", "⏳ Loading YouTube Music Player...", 3)
        task.spawn(function()
            local ok, err = pcall(function()
                loadstring(game:HttpGet(
                    "https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/YoutubeMusicPlayer.lua"
                ))()
            end)
            if not ok then
                notify("YunoHub", "❌ YMP error: " .. tostring(err), 5)
            else
                State.ytLoaded = true
                notify("YunoHub", "✓ YouTube Music Player launched !", 3)
                playSound(S.SUCCESS, 0.8, 1.2)
            end
        end)
    end)

    makeBtn("yt_reload", "🔄 Reload YMP", A.LIGHTNING, function()
        State.ytLoaded = false
        _G.YMP = false
        notify("YunoHub", "⏳ Reloading...", 3)
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(
                    "https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/YoutubeMusicPlayer.lua"
                ))()
            end)
            State.ytLoaded = true
            notify("YunoHub", "✓ YMP reloaded", 3)
        end)
    end)

    makeSection("🔍 Custom Script", A.SEARCH)
    makeInput("Script URL (raw.githubusercontent...)", "Load", function(url)
        if not url or url == "" then
            notify("YunoHub", "⚠ Empty URL", 2); return
        end
        notify("YunoHub", "⏳ Loading...", 3)
        task.spawn(function()
            local ok, err = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if not ok then
                notify("YunoHub", "❌ Error: " .. tostring(err), 5)
            else
                notify("YunoHub", "✓ Script loaded", 3)
            end
        end)
    end)

    makeSection("⏹ Control", A.CROSS)
    makeBtn("yt_stop", "⏹ Stop ALL Music", A.CROSS, function()
        local stopped = 0
        for _, obj in ipairs(SoundService:GetChildren()) do
            if obj:IsA("Sound") and obj.Playing then
                pcall(function() obj:Stop() end); stopped = stopped + 1
            end
        end
        if _G.YunoMusic then
            _G.YunoMusic:Destroy(); _G.YunoMusic = nil; stopped = stopped + 1
        end
        notify("YunoHub", "⏹ " .. stopped .. " sound(s) stopped", 3)
    end)

    makeSection("💖 Credits", A.HEART)
    local infoBox2 = Instance.new("Frame", areaScroll)
    infoBox2.Size = UDim2.new(1,-6,0,60); infoBox2.BackgroundColor3 = T.section
    infoBox2.BorderSizePixel = 0; infoBox2.LayoutOrder = #areaScroll:GetChildren()
    local ibc2 = Instance.new("UICorner", infoBox2); ibc2.CornerRadius = UDim.new(0,10)
    local il2 = Instance.new("TextLabel", infoBox2)
    il2.Size = UDim2.new(1,-20,1,0); il2.Position = UDim2.new(0,10,0,0)
    il2.BackgroundTransparency = 1
    il2.Text = "🎧 YouTube Music Player by @Termux_404\nDiscord: discord.gg/kbh2dEdnYP"
    il2.TextColor3 = T.text; il2.Font = Enum.Font.GothamBold
    il2.TextSize = 10; il2.TextXAlignment = Enum.TextXAlignment.Left
    il2.TextYAlignment = Enum.TextYAlignment.Center; il2.TextWrapped = true
end

pages.mm2 = function()
    clearArea()

    makeSection("👁 ESP", A.SEARCH)
    makeToggle("esp_players", "Player ESP", A.PERSON, State.playerESP, function(v)
        State.playerESP = v; reloadESP()
    end)
    makeToggle("esp_gun", "Dropped Gun ESP", A.GUN, State.gunDropESP, function(v)
        State.gunDropESP = v
        if v then
            local map = getMap()
            if map and map:FindFirstChild("GunDrop") then addESP(map.GunDrop, Color3.fromRGB(255,240,20), "🔫 Dropped Gun!") end
        else
            for _, c in ipairs(espGui:GetChildren()) do
                if c:IsA("Highlight") and c.FillColor == Color3.fromRGB(255,240,20) then c:Destroy() end
            end
        end
    end)
    makeToggle("esp_trap", "Trap Detection", A.SKULL, State.trapDetection, function(v)
        State.trapDetection = v
        if v then
            for _, o in ipairs(workspace:GetDescendants()) do
                if o.Name == "Trap" then addESP(o, Color3.fromRGB(255,60,60), "⚠ Trap") end
            end
        end
    end)
    makeToggle("hide_me_esp", "Hide My Own ESP", A.EYE, State.hideMeEsp, function(v)
        State.hideMeEsp = v; reloadESP()
    end)
    makeBtn("esp_reload", "Reload ESP", A.STAR, function() reloadESP() end)

    makeSection("🔫 Weapons", A.GUN)
    makeBtn("shoot_instant", "Shoot murderer (instant)", A.GUN, shootMurderer)
    makeBtn("shoot_delayed", "Shoot murderer (delayed)", A.TARGET, function()
        if findSheriff() ~= LP then notify("YunoHub","Not sheriff",2) return end
        task.spawn(function()
            for i = 1, 60 do task.wait(0.5); pcall(shootMurderer) end
        end)
    end)
    makeBtn("knife_throw", "Knife throw to closest", A.KNIFE, function() knifeThrow(false) end)
    makeToggle("instakill", "Instakill murderer as sheriff", A.SKULL, State.instakillshoot, function(v) State.instakillshoot = v end)
    makeToggle("spawn_at_player", "Spawn knife throw near player", A.KNIFE, State.spawnAtPlayer, function(v) State.spawnAtPlayer = v end)

    makeSection("💀 Attacks", A.FIRE)
    makeBtn("kill_closest", "Kill closest (murderer)", A.SKULL, killClosest)
    makeBtn("kill_everyone", "Kill EVERYONE (murderer)", A.SKULL, killEveryone)

    makeSection("🔥 Fling (manual)", A.FIRE)
    makeBtn("fling_sheriff", "Fling Sheriff (real)", A.FIRE, function()
        local s = findSheriff()
        if s then task.spawn(skidFling, s) else notify("YunoHub","No sheriff",2) end
    end)
    makeBtn("fling_murderer", "Fling Murderer (real)", A.FIRE, function()
        local m = findMurderer()
        if m then task.spawn(skidFling, m) else notify("YunoHub","No murderer",2) end
    end)
    makeBtn("fling_closest", "Fling Closest", A.FIRE, function()
        local c = getClosestPlayer()
        if c then task.spawn(skidFling, c) end
    end)

    makeSection("✈ Teleport", A.TARGET)
    makeBtn("tp_lobby", "TP to Lobby", A.HOME, function()
        pcall(function()
            local lobby = workspace:FindFirstChild("Lobby")
            if lobby and lobby:FindFirstChild("Spawns") and LP.Character then
                local sp = lobby.Spawns:FindFirstChildWhichIsA("SpawnLocation")
                if sp then LP.Character:PivotTo(CFrame.new(sp.Position + Vector3.new(0,3,0))) end
            end
        end)
    end)
    makeBtn("tp_map", "TP to Map", A.PLANE, function()
        pcall(function()
            local map = getMap()
            if map and map:FindFirstChild("Spawns") and LP.Character then
                local sps = map.Spawns:GetChildren()
                if #sps > 0 then
                    local sp = sps[math.random(1,#sps)]
                    LP.Character:PivotTo(CFrame.new(sp.Position + Vector3.new(0,3,0)))
                end
            end
        end)
    end)
    makeBtn("tp_gun", "TP to dropped gun", A.GUN, function()
        pcall(function()
            local map = getMap()
            if map and map:FindFirstChild("GunDrop") and LP.Character then
                local prev = LP.Character:GetPivot()
                LP.Character:PivotTo(map.GunDrop:GetPivot())
                task.wait(0.2)
                if LP.Backpack:FindFirstChild("Gun") then
                    LP.Character:FindFirstChildOfClass("Humanoid"):EquipTool(LP.Backpack.Gun)
                end
                LP.Character:PivotTo(prev)
            end
        end)
    end)

    makeSection("🎉 Fun", A.STAR)
    makeBtn("hold_hostage", "Hold everyone hostage", A.PERSON, holdEveryoneHostage)
    makeBtn("god_mode", "God mode (unstable)", A.SHIELD, godMode)
    makeBtn("chat_roles", "Send roles in chat", A.SEARCH, sendRolesInChat)
    makeBtn("copy_murd", "Copy murderer name", A.CROSS, function()
        local m = findMurderer()
        if m and setclipboard then setclipboard(m.Name); notify("YunoHub","📋 Copied: "..m.Name,3) end
    end)
    makeBtn("copy_sher", "Copy sheriff name", A.CROSS, function()
        local s = findSheriff()
        if s and setclipboard then setclipboard(s.Name); notify("YunoHub","📋 Copied: "..s.Name,3) end
    end)
    makeToggle("round_timer", "Round Timer HUD", A.CLOCK, State.roundTimerOn, function(v)
        State.roundTimerOn = v
        if v then
            local hud = Instance.new("TextLabel", gui)
            hud.Name = "YunoRoundTimer"
            hud.Size = UDim2.new(0,200,0,40)
            hud.Position = UDim2.new(0.5,-100,0,60)
            hud.BackgroundTransparency = 0.5
            hud.BackgroundColor3 = T.bg2
            hud.TextColor3 = T.accent
            hud.Font = Enum.Font.GothamBlack
            hud.TextSize = 22
            hud.ZIndex = 100
            local hc = Instance.new("UICorner", hud); hc.CornerRadius = UDim.new(0,8)
            local hs = Instance.new("UIStroke", hud); hs.Color = T.accent; hs.Thickness = 2
            task.spawn(function()
                while State.roundTimerOn do
                    task.wait(0.5)
                    pcall(function()
                        local part = workspace:FindFirstChild("RoundTimerPart")
                        if part then
                            local t2 = part:GetAttribute("Time")
                            if t2 then
                                local m = math.floor(t2 / 60); local s = t2 % 60
                                hud.Text = "⏱ " .. string.format("%d:%02d", m, s)
                            end
                        end
                    end)
                end
                pcall(function() if hud then hud:Destroy() end end)
            end)
        end
    end)
end

pages.themes = function()
    clearArea()
    makeSection("🎨 Themes ("..#THEMES..")", A.PALETTE)
    for key, th in pairs(THEMES) do
        local b = Instance.new("TextButton", areaScroll)
        b.Size = UDim2.new(1,-6,0,42); b.BackgroundColor3 = th.section
        b.BorderSizePixel = 0; b.Text = ""; b.AutoButtonColor = false
        b.LayoutOrder = #areaScroll:GetChildren()
        local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,10)
        local s = Instance.new("UIStroke", b)
        s.Color = th.accent; s.Thickness = 2
        s.Transparency = (key == currentTheme) and 0 or 0.6
        mkImage(b, th.icon, UDim2.new(0,24,0,24), UDim2.new(0,8,0.5,-12), th.accent)
        local tl = Instance.new("TextLabel", b)
        tl.Size = UDim2.new(1,-110,1,0); tl.Position = UDim2.new(0,40,0,0)
        tl.BackgroundTransparency = 1; tl.Text = th.name
        tl.TextColor3 = th.text; tl.Font = Enum.Font.GothamBlack
        tl.TextSize = 12; tl.TextXAlignment = Enum.TextXAlignment.Left
        for i = 1, 3 do
            local dot = Instance.new("Frame", b)
            dot.Size = UDim2.new(0,12,0,12)
            dot.Position = UDim2.new(1,-55 + (i-1)*16, 0.5, -6)
            dot.BorderSizePixel = 0
            dot.BackgroundColor3 = i == 1 and th.accent or (i == 2 and th.accent2 or th.bg1)
            local dc = Instance.new("UICorner", dot); dc.CornerRadius = UDim.new(1,0)
            local ds = Instance.new("UIStroke", dot)
            ds.Color = th.text; ds.Thickness = 1; ds.Transparency = 0.5
        end
        onTap(b, function()
            playSound(S.SUCCESS, 0.5, 1.2)
            applyTheme(key)
            notify("YunoHub","🎨 Theme: "..th.name,2)
            pages.themes()
        end)
    end
end

local currentMusicIdx = nil
pages.music = function()
    clearArea()
    makeSection("🎶 ASMR Music ("..#MUSIC.." tracks)", A.MUSIC)
    for i, track in ipairs(MUSIC) do
        local b = Instance.new("TextButton", areaScroll)
        b.Size = UDim2.new(1,-6,0,40); b.BackgroundColor3 = T.section
        b.BorderSizePixel = 0; b.Text = ""; b.AutoButtonColor = false
        b.LayoutOrder = #areaScroll:GetChildren()
        local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,10)
        local s = Instance.new("UIStroke", b)
        s.Color = T.accent; s.Thickness = 1
        s.Transparency = (currentMusicIdx == i) and 0 or 0.6
        mkImage(b, track.icon or A.MUSIC, UDim2.new(0,20,0,20), UDim2.new(0,8,0.5,-10), T.accent2)
        local l = Instance.new("TextLabel", b)
        l.Size = UDim2.new(1,-40,1,0); l.Position = UDim2.new(0,36,0,0)
        l.BackgroundTransparency = 1; l.Text = "♪ "..track.name
        l.TextColor3 = T.text; l.Font = Enum.Font.GothamBold
        l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
        onTap(b, function()
            if currentMusicIdx == i then
                if _G.YunoMusic then _G.YunoMusic:Destroy(); _G.YunoMusic = nil end
                currentMusicIdx = nil; playSound(S.CLOSE, 0.4)
            else
                if _G.YunoMusic then _G.YunoMusic:Destroy() end
                local mus = Instance.new("Sound")
                mus.SoundId = track.id; mus.Volume = track.vol
                mus.Looped = true; mus.Parent = SoundService
                mus:Play()
                _G.YunoMusic = mus
                currentMusicIdx = i
                playSound(S.SUCCESS, 0.5, 1.2)
            end
            pages.music()
        end)
    end
    makeSection("⚙ Options", A.LIGHTNING)
    makeToggle("asmr_on", "ASMR UI sounds", A.SPARKLE, ASMR_ON, function(v) ASMR_ON = v end)
    makeToggle("particles_on", "Golden particles", A.SPARKLE, PARTICLES_ON, function(v) PARTICLES_ON = v end)
    makeBtn("stop_music", "Stop all music", A.CROSS, function()
        if _G.YunoMusic then _G.YunoMusic:Destroy(); _G.YunoMusic = nil end
        currentMusicIdx = nil
        notify("YunoHub","⏹ Music stopped",2)
    end)
end

pages.settings = function()
    clearArea()
    makeSection("📌 Pinned Buttons", A.PIN)
    local info = Instance.new("Frame", areaScroll)
    info.Size = UDim2.new(1,-6,0,105); info.BackgroundColor3 = T.section
    info.BorderSizePixel = 0; info.LayoutOrder = #areaScroll:GetChildren()
    local ic = Instance.new("UICorner", info); ic.CornerRadius = UDim.new(0,10)
    local il = Instance.new("TextLabel", info)
    il.Size = UDim2.new(1,-16,1,0); il.Position = UDim2.new(0,8,0,0)
    il.BackgroundTransparency = 1
    il.Text = "Tap = trigger\nLong-press WITHOUT MOVING = confirm pin\n(if you scroll/move +10px → cancelled)\nTapping ✕ on a pinned button = remove it\nDrag pins anywhere"
    il.TextColor3 = T.text; il.Font = Enum.Font.GothamBold
    il.TextSize = 11; il.TextXAlignment = Enum.TextXAlignment.Left
    il.TextYAlignment = Enum.TextYAlignment.Center; il.TextWrapped = true
    makeBtn("clear_all_floats", "Remove all pinned", A.CROSS, function()
        for k, fb in pairs(floatingButtons) do
            if fb.Parent then fb:Destroy() end
            floatingButtons[k] = nil
        end
        notify("YunoHub","✓ All pinned removed",2)
    end)

    makeSection("🖼 Background", A.SPARKLE)
    makeToggle("background_on", "Background image 1 (original)", A.SPARKLE, BACKGROUND_ON, function(v)
        BACKGROUND_ON = v; MenuBG.Visible = v
    end)
    makeToggle("background2_on", "Background image 2 (custom NEW)", A.SPARKLE, BACKGROUND2_ON, function(v)
        BACKGROUND2_ON = v; MenuBG2.Visible = v
    end)
    makeRange("BG2 opacity", 0, 100, 70, function(v)
        BG2_OPACITY = v / 100
        if MenuBG2 then MenuBG2.ImageTransparency = BG2_OPACITY end
    end)

    makeSection("🖱 Cursor", A.CURSOR)
    makeToggle("cursor_on", "Custom cursor (follows finger)", A.CURSOR, CURSOR_ON, function(v)
        CURSOR_ON = v; updateCursor()
    end)
    makeToggle("cursor_rgb", "Cursor RGB effect", A.SPARKLE, CURSOR_RGB, function(v)
        CURSOR_RGB = v
        if not v then
            cursorImg.ImageColor3 = T.accent2
            cursorText.TextColor3 = T.accent
        end
    end)

    makeSection("ℹ Info", A.SETTINGS)
    makeBtn("open_console", "Open dev console", A.SEARCH, function()
        game.StarterGui:SetCore("DevConsoleVisible", true)
    end)
    makeBtn("hide_hub", "Hide hub", A.CROSS, minimizeHub)
end

function applyTheme(key)
    local th = THEMES[key]; if not th then return end
    currentTheme = key; T = th

    Menu.BackgroundColor3 = T.bg1
    MenuGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0,T.bg1), ColorSequenceKeypoint.new(1,T.bg2) })
    MenuStroke.Color = T.accent
    MenuStrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,T.bg1), ColorSequenceKeypoint.new(0.2,T.accent),
        ColorSequenceKeypoint.new(0.5,T.accent2), ColorSequenceKeypoint.new(0.8,T.accent),
        ColorSequenceKeypoint.new(1,T.bg1)
    })
    hubName.TextColor3 = T.accent
    hubNameIcon.ImageColor3 = T.accent
    version.TextColor3 = T.textDim
    hubDesc.TextColor3 = T.textDim
    hubDescIcon.ImageColor3 = T.accent2
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

    -- Update custom background color with theme
    if MenuBG2 then
        MenuBG2.ImageColor3 = T.accent2
    end

    if not CURSOR_RGB then
        cursorImg.ImageColor3 = T.accent2
        cursorText.TextColor3 = T.accent
    end

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

local function createTabButton(pageId, label, iconId)
    local b = Instance.new("TextButton", listScroll)
    b.Size = UDim2.new(1,0,0,36); b.BackgroundColor3 = T.section
    b.BorderSizePixel = 0; b.Text = ""; b.AutoButtonColor = false
    b.LayoutOrder = #listScroll:GetChildren()
    b:SetAttribute("pageId", pageId)
    local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,8)
    local s = Instance.new("UIStroke", b); s.Color = T.accent; s.Thickness = 1; s.Transparency = 1
    mkImage(b, iconId, UDim2.new(0,18,0,18), UDim2.new(0,6,0.5,-9), T.textDim)
    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.new(1,-28,1,0); l.Position = UDim2.new(0,26,0,0)
    l.BackgroundTransparency = 1; l.Text = label
    l.TextColor3 = T.textDim; l.Font = Enum.Font.GothamBold
    l.TextSize = 11; l.TextXAlignment = Enum.TextXAlignment.Left

    local function activate()
        if activePage == pageId then return end
        playSound(S.TAB, 0.4, 1.1 + math.random()*0.1)
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
    onTap(b, activate)
end

createTabButton("universal", "Universal", A.STAR)
createTabButton("auto",      "⚡ Auto",   A.POWER)
createTabButton("mm2",       "MM2",       A.KNIFE)
createTabButton("ytmusic",   "🎵 YT Music", A.MUSIC)
createTabButton("themes",    "Themes",    A.PALETTE)
createTabButton("music",     "Music",     A.MUSIC)
createTabButton("settings",  "Settings",  A.SETTINGS)

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
    pcall(function()
        if State.infJump and LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end))

track(RunService.RenderStepped:Connect(function()
    pcall(function()
        if State.loopFovWs and LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = State.ws end
            workspace.CurrentCamera.FieldOfView = State.fov
        end
    end)
end))

track(Players.PlayerAdded:Connect(function() task.wait(1); pcall(function() if State.playerESP then reloadESP() end end) end))
track(Players.PlayerRemoving:Connect(function() task.wait(0.5); pcall(function() if State.playerESP then reloadESP() end end) end))

track(workspace.DescendantAdded:Connect(function(ch)
    pcall(function()
        if State.gunDropESP and ch.Name == "GunDrop" then
            addESP(ch, Color3.fromRGB(255,240,20), "🔫 Dropped Gun!")
            notify("YunoHub","🔫 Gun dropped !",2)
        end
        if State.trapDetection and ch.Name == "Trap" then
            ch.Transparency = 0
            addESP(ch, Color3.fromRGB(255,60,60), "⚠ Trap")
        end
    end)
end))

track(LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    pcall(function()
        if State.flyOn then startFly() end
        if State.playerESP then reloadESP() end
    end)
end))

--═══════════════════════════════════════════════════════════════
-- START
--═══════════════════════════════════════════════════════════════
notify("✦ YUNO HUB v12.2 ✦", "⚡ AUTO + 🎵 YT Music + 🖼 CUSTOM BG + 36 tracks !", 5, S.SUCCESS)
playSound(S.SUCCESS, 0.8, 1.2)

print([[
╔════════════════════════════════════════════════════════════╗
║  YUNO HUB v12.2 — CUSTOM BACKGROUND                        ║
╠════════════════════════════════════════════════════════════╣
║  🖼  NEW: Custom background image (11176073582)           ║
║      • Slow rotation effect                                ║
║      • Follows theme color                                 ║
║      • Opacity slider in Settings                          ║
║      • Toggle on/off in Settings                           ║
║  ✨ 100% English interface                                ║
║  🎨 Icons everywhere                                       ║
║  🔊 ASMR sounds on every interaction                       ║
║  🛡️  Full pcall protection                                 ║
║  ⚡ Tab "Auto" : ~25 auto features + MASTER SWITCH        ║
║  🎵 Tab "YT Music" : launch YMP in 1 click                ║
║  🎶 36 ASMR music tracks                                   ║
║  🎨 44 polished themes                                     ║
║  📌 Draggable pins · Cursor "Yuno Hub"                    ║
╚════════════════════════════════════════════════════════════╝
]])