getgenv().SilentAimVeilSettings = getgenv().SilentAimVeilSettings or {}
getgenv().SilentAimPistolSettings = getgenv().SilentAimPistolSettings or {}

getgenv().ArexansParryLightStance = false
getgenv().ArexansParryStanceHoldTime = 0.65
-- AREXANS EXECUTE GUARD PATCH
-- Patch ini hanya menambah pengaman error runtime agar script tidak berhenti diam-diam.
local __arexans_boot_error_handler
__arexans_boot_error_handler = function(err)
    local msg = tostring(err)
    local traceback = msg
    pcall(function()
        if debug and debug.traceback then
            traceback = debug.traceback(msg, 2)
        end
    end)
    pcall(function() warn("[ArexansTools] Runtime error: " .. tostring(traceback)) end)
    pcall(function() print("[ArexansTools] Runtime error: " .. tostring(traceback)) end)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ArexansTools Error",
            Text = string.sub(msg, 1, 180),
            Duration = 10
        })
    end)
    return traceback
end

local __arexans_ok, __arexans_err = xpcall(function()

if type(getgenv) ~= "function" then
    local __arexans_env = _G or {}
    getgenv = function()
        return __arexans_env
    end
end

local function __arexans_boot_notice(title, text, duration)
    title = tostring(title or "ArexansTools")
    text = tostring(text or "")
    duration = tonumber(duration) or 8

    pcall(function() warn("[" .. title .. "] " .. text) end)
    pcall(function() print("[" .. title .. "] " .. text) end)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration,
        })
    end)
    pcall(function()
        local players = game:GetService("Players")
        local lp = players and players.LocalPlayer
        if not lp then return end
        task.spawn(function()
            local pg = lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui", 5)
            if not pg then return end

            local old = pg:FindFirstChild("ArexansBootNotice")
            if old then old:Destroy() end

            local gui = Instance.new("ScreenGui")
            gui.Name = "ArexansBootNotice"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 999999
            gui.Parent = pg

            local label = Instance.new("TextLabel")
            label.Name = "Message"
            label.AnchorPoint = Vector2.new(0.5, 0)
            label.Position = UDim2.new(0.5, 0, 0, 35)
            label.Size = UDim2.new(0, 520, 0, 72)
            label.BackgroundColor3 = Color3.fromRGB(5, 16, 31)
            label.BackgroundTransparency = 0.08
            label.BorderSizePixel = 0
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.TextWrapped = true
            label.TextColor3 = Color3.fromRGB(248, 250, 252)
            label.Text = title .. "\n" .. text
            label.Parent = gui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = label

            task.delay(duration, function()
                if gui and gui.Parent then
                    gui:Destroy()
                end
            end)
        end)
    end)
end

local _version = "3.0.3-spear-no-hold-gui"

-- Safe WindUI loader: mencegah script berhenti diam-diam kalau request/compile UI gagal.
local WindUI
do
    pcall(function()
        if getgenv and getgenv().WindUI then
            WindUI = getgenv().WindUI
        end
    end)

    local urls = {
        "https://github.com/Footagesus/WindUI/releases/download/1.6.64-fix/main.lua",
    }

    local lastError = "unknown error"
    if not WindUI then
    for _, url in ipairs(urls) do
        local ok, lib = pcall(function()
            local source = game:HttpGet(url, true)
            if type(source) ~= "string" or source == "" then
                error("empty WindUI source")
            end

            if type(loadstring) ~= "function" then
                error("loadstring is not available in this executor")
            end

            local fn, compileErr = loadstring(source)
            if not fn then
                error(tostring(compileErr))
            end

            return fn()
        end)

        if ok and lib then
            WindUI = lib
            break
        end

        lastError = tostring(lib)
    end
    end

    if not WindUI then
        __arexans_boot_notice("ArexansTools", "WindUI gagal dimuat. Cek HTTP Request / executor. Error: " .. tostring(lastError), 10)
        return
    end
end

-- =========================================================
-- GRADIENT FUNCTION
-- =========================================================
local function gradient(text, startColor, endColor, timeOffset)
    if type(text) ~= "string" or text == "" then return "" end

    local function colorToHex(color)
        local ok, hex = pcall(function()
            return color:ToHex()
        end)
        if ok and type(hex) == "string" and hex ~= "" then
            return hex
        end

        local r = math.clamp(math.floor(((color and color.R) or 1) * 255 + 0.5), 0, 255)
        local g = math.clamp(math.floor(((color and color.G) or 1) * 255 + 0.5), 0, 255)
        local b = math.clamp(math.floor(((color and color.B) or 1) * 255 + 0.5), 0, 255)
        return string.format("%02X%02X%02X", r, g, b)
    end

    local chars, result = {}, {}
    local okUtf8 = pcall(function()
        for _, c in utf8.codes(text) do chars[#chars+1] = utf8.char(c) end
    end)
    if not okUtf8 or #chars == 0 then
        for i = 1, #text do chars[#chars+1] = text:sub(i, i) end
    end

    local len = #chars
    local div = math.max(len - 1, 1)
    timeOffset = tonumber(timeOffset) or 0

    for i = 1, len do
        local t = math.abs((((i - 1) / div) + timeOffset) % 2 - 1)
        local okLerp, color = pcall(function()
            return startColor:Lerp(endColor, t)
        end)
        if not okLerp or not color then
            color = startColor or endColor or Color3.new(1, 1, 1)
        end
        result[i] = string.format('<font color="#%s">%s</font>', colorToHex(color), chars[i])
    end

    return table.concat(result)
end

-- =========================================================
-- ADD THEME
-- =========================================================
pcall(function()
    WindUI:AddTheme({
        Name = "Arexans",
        Accent = "#1E90FF",
        Dialog = "#0a1e3a",
        Outline = "#00BFFF",
        Text = "#f8fafc",
        Placeholder = "#94a3b8",
        Background = "#05101f",
        Button = "#0a2240",
        Icon = "#f8fafc"
    })
end)

pcall(function()
    WindUI:SetTheme("Arexans")
end)

-- =========================================================
-- EXECUTOR DETECTION
-- =========================================================
local executorName = "Unknown"
if identifyexecutor then executorName = identifyexecutor()
elseif getexecutorname then executorName = getexecutorname()
elseif executor then executorName = executor end

-- =========================================================
-- SERVICES
-- =========================================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- =========================================================
-- FPS UNLOCK
-- =========================================================
if setfpscap then
    pcall(function()
        -- Anti-lag default: 60 FPS lebih stabil untuk gameplay.
        -- Bisa diubah sebelum load script dengan: getgenv().ArexansFpsCap = 120
        local cap = tonumber(getgenv().ArexansFpsCap) or 60
        cap = math.clamp(cap, 30, 144)
        setfpscap(cap)
    end)
end


-- =========================================================
-- UI SAFETY WRAPPER
-- =========================================================
local __ArexansDummyUI
__ArexansDummyUI = setmetatable({}, {
    __index = function(_, key)
        if key == "Set" or key == "Refresh" or key == "SetTitle" or key == "SetColor" then
            return function() return __ArexansDummyUI end
        end
        return function() return __ArexansDummyUI end
    end,
    __newindex = function() end,
})

local function __ArexansWrapUI(obj, label)
    local objType = type(obj)
    if objType ~= "table" and objType ~= "userdata" then
        return __ArexansDummyUI
    end

    return setmetatable({}, {
        __index = function(_, key)
            local ok, value = pcall(function()
                return obj[key]
            end)
            if not ok then
                pcall(function() warn("[ArexansTools] UI read failed: " .. tostring(label) .. "." .. tostring(key) .. " | " .. tostring(value)) end)
                return nil
            end

            if type(value) == "function" then
                return function(_, ...)
                    local callOk, result = pcall(value, obj, ...)
                    if not callOk then
                        pcall(function() warn("[ArexansTools] UI call failed: " .. tostring(label) .. "." .. tostring(key) .. " | " .. tostring(result)) end)
                        return __ArexansDummyUI
                    end
                    return __ArexansWrapUI(result, tostring(label) .. "." .. tostring(key))
                end
            end

            return value
        end,
        __newindex = function(_, key, value)
            pcall(function()
                obj[key] = value
            end)
        end,
    })
end

local function __ArexansNotify(title, text, duration)
    __arexans_boot_notice(title or "ArexansTools", text or "", duration or 6)
end

-- =========================================================
-- WINDOW UTAMA (STYLE AREXANS)
-- =========================================================
local __ArexansRawWindow
local __ArexansWindowOk, __ArexansWindowResult = pcall(function()
    return WindUI:CreateWindow({
    Title = "<b>" .. gradient("ArexansTools", Color3.fromHex("#1E90FF"), Color3.fromHex("#00BFFF")) .. "</b>", 
    Author = gradient("Violence District", Color3.fromHex("#E0E0E0"), Color3.fromHex("#A1A1A1")),
    Icon = "rbxassetid://122503252139031",
    Theme = "Arexans", 
    Size = UDim2.fromOffset(550, 450), 
    Resizable = true,
    MinSize = Vector2.new(450, 350),
    MaxSize = Vector2.new(650, 550),
    Transparent = true,
    IgnoreAlerts = true,
    HideSearchBar = false,
    SideBarWidth = 180, 
    TopBarButtonIconSize = 18,
    Folder = "ArexansTools",
    ToggleKey = Enum.KeyCode.V,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            -- Nothing
        end,
    },
    OpenButton = {
        Title = gradient("ArexansTools", Color3.fromHex("#1E90FF"), Color3.fromHex("#00BFFF")),
        Icon = "rbxassetid://122503252139031",
        CornerRadius = UDim.new(1, 0), 
        StrokeThickness = 2.2,
        Draggable = true,
        Enabled = true,
        OnlyMobile = false,
        Scale = 0.85,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromHex("#1E90FF")),
            ColorSequenceKeypoint.new(0.50, Color3.fromHex("#00BFFF")),
            ColorSequenceKeypoint.new(1.00, Color3.fromHex("#0000CD"))
        })
    },
    Topbar = { Height = 45, ButtonsType = "Default" },
    })
end)

if __ArexansWindowOk and __ArexansWindowResult then
    __ArexansRawWindow = __ArexansWindowResult
else
    __ArexansNotify("ArexansTools", "Window gagal dibuat: " .. tostring(__ArexansWindowResult), 10)
    return
end

local Window = __ArexansWrapUI(__ArexansRawWindow, "Window")

local PingTag = Window:Tag({ Title = "Ping: 0ms", Color = Color3.fromRGB(100,200,255) })
task.spawn(function()
    while true do
        local ok, ping = pcall(function()
            return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if ok and ping then
            PingTag:SetTitle("Ping: "..ping.."ms")
            if ping <= 50 then PingTag:SetColor(Color3.fromRGB(0,255,0))
            elseif ping <= 100 then PingTag:SetColor(Color3.fromRGB(255,200,0))
            elseif ping <= 200 then PingTag:SetColor(Color3.fromRGB(255,150,0))
            else PingTag:SetColor(Color3.fromRGB(255,0,0)) end
        end
        task.wait(2)
    end
end)

pcall(function()
    Window:CreateTopbarButton("TransparencyToggle", "eye", function()
        if getgenv().TransparencyEnabled then
            getgenv().TransparencyEnabled = false
            pcall(function() Window:ToggleTransparency(false) end)
        else
            getgenv().TransparencyEnabled = true
            pcall(function() Window:ToggleTransparency(true) end)
        end
    end, 990)
end)

Window:Tag({ 
    Title = "<b>" .. gradient("@Arexans", Color3.fromHex("#1E90FF"), Color3.fromHex("#00BFFF")) .. "</b>", 
    Icon = "rbxassetid://122503252139031", 
    Border = true, 
    Color = Color3.fromHex("#0a1a33") 
})
Window:Divider()

---------------------------------------------------
--== CREATE TABS ==--
---------------------------------------------------
local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local SurvivorTab = Window:Tab({ Title = "Survivor", Icon = "user-check" })
local KillerTab = Window:Tab({ Title = "Killer", Icon = "swords" })
local ESPTab = Window:Tab({ Title = "ESP", Icon = "eye" })
local VisualTab = Window:Tab({ Title = "Visual", Icon = "sun" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "navigation" })
local ConfigTab = Window:Tab({ Title = "Config", Icon = "folder" })

--// ================= INFO TAB =================
InfoTab:Divider()


-- Roblox Account Information
pcall(function()
    local accountAge = LocalPlayer.AccountAge or 0
    local userId = LocalPlayer.UserId or 0

    local friendCount = "N/A"
    local followersCount = "N/A"
    local followingCount = "N/A"

    pcall(function()
        friendCount = #Players:GetFriendsAsync(userId):GetCurrentPage()
    end)

    local avatarImage = string.format(
        "https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=420&height=420&format=png",
        tostring(userId)
    )

    InfoTab:Paragraph({
        Title = "Roblox Account Information",
        Desc = string.format(
            "â€¢ Username : %s\nâ€¢ User ID : %s\nâ€¢ Account Age : %d Days\nâ€¢ Friends : %s\nâ€¢ Followers : %s\nâ€¢ Following : %s",
            LocalPlayer.Name,
            tostring(userId),
            accountAge,
            tostring(friendCount),
            tostring(followersCount),
            tostring(followingCount)
        ),
        Image = avatarImage,
        ImageSize = 60,
    })
end)



-- Developer Information Section
local DevSection = InfoTab:Section({
    Title = "Developer Information",
    Box = true,
    BoxBorder = true,
    Icon = "code",
    Opened = true
})

DevSection:Paragraph({
    Title = "ArexansTools | Dev Ai",
    Desc = "â€¢ Developer of ArexansTools\nâ€¢ Script Creator since 2024\nâ€¢ Focus on Quality & Free Scripts\nâ€¢ Trusted by 10,000+ Users Worldwide",
    Image = "rbxassetid://122503252139031",
    ImageSize = 50,
})

-- Social Media Section
local ListFeature = InfoTab:Section({
    Title = "List Feature",
    Box = true,
    BoxBorder = true,
    Icon = "users",
    Opened = false
})

ListFeature:Paragraph({
    Title = "Complete Features List",
    Desc = "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n" ..
           "ã€ SURVIVOR FEATURES ã€‘\n" ..
           "â€¢ No Skillcheck - Auto perfect skillcheck\n" ..
           "â€¢ Bypass Gate - Walk through gates\n" ..
           "â€¢ Auto Lever - Auto pull exit lever\n" ..
           "â€¢ Auto Pallet - Auto drop pallet at the right chase momentum\n" ..
           "â€¢ Auto Crouch Spin Attack - Crouch during spinning sword skill\n" ..
           "â€¢ Auto Heal (Perfect/Neutral) - Auto healing\n" ..
           "â€¢ Auto Generator (Perfect/Neutral) - Auto repair\n" ..
           "â€¢ Auto Parry - Auto parry killer attacks\n" ..
           "â€¢ Auto Shoot - Auto shoot with ranged weapons\n" ..
           "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n" ..
           "ã€ KILLER FEATURES ã€‘\n" ..
           "â€¢ Kill All - Kill all survivors (Risk ban!)\n" ..
           "â€¢ Auto Attack - Auto attack nearby survivors\n" ..
           "â€¢ No Flashlight - Remove blind effect\n" ..
           "â€¢ The Veil Aimbot (Normal/Charge)\n" ..
           "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n" ..
           "ã€ OTHER FEATURES ã€‘\n" ..
           "â€¢ Walk Speed + Noclip + God Mode\n" ..
           "â€¢ No Fall + Anti Stun + MoonWalk\n" ..
           "â€¢ Anti AFK + ESP System\n" ..
           "â€¢ Fullbright + Time of Day + Custom FOV\n" ..
           "â€¢ Teleport System",
})

-- Social Media Section
local SocialSection = InfoTab:Section({
    Title = "Social Media & Support",
    Box = true,
    BoxBorder = true,
    Icon = "users",
    Opened = true
})

local SupportLink = "https://chat.whatsapp.com/LGyajryoaB5BIZaZyQMUzW"

SocialSection:Paragraph({
    Title = "Follow & Support",
    Desc = "â€¢ Support Link: " .. SupportLink,
})

SocialSection:Button({
    Title = "Copy Support Link",
    Icon = "copy",
    Desc = "Copy the support link to clipboard",
    Callback = function()
        if setclipboard then
            setclipboard(SupportLink)
            -- Console normal dibuat silent agar tidak spam log.
        end
    end
})

-- Credits Section
local CreditsSection = InfoTab:Section({
    Title = "Credits & Partnership",
    Box = true,
    BoxBorder = true,
    Icon = "heart",
    Opened = true
})

CreditsSection:Paragraph({
    Title = "Special Thanks",
    Desc = "â€¢ WindUI Library\nâ€¢ Roblox Community\nâ€¢ All Script Contributors\nâ€¢ Beta Testers",
})

CreditsSection:Divider()

CreditsSection:Paragraph({
    Title = "Partnership",
    Desc = "â€¢ Makasih semuanya..",
})

---------------------------------------------------
--== UTILITY FUNCTIONS ==--
---------------------------------------------------
function safeNotify(title, content, duration)
    -- Silent untuk info normal/toggle agar console tidak spam.
    -- Error/gagal/saran perbaikan tetap dicetak. Struktur fungsi dibuat sederhana agar tidak mengganggu startup UI.
    local msg = (tostring(title or "") .. " " .. tostring(content or "")):lower()
    if msg:find("error", 1, true)
        or msg:find("failed", 1, true)
        or msg:find("fail", 1, true)
        or msg:find("gagal", 1, true)
        or msg:find("warning", 1, true)
        or msg:find("warn", 1, true)
        or msg:find("saran", 1, true)
        or msg:find("perbaikan", 1, true)
        or msg:find("fix", 1, true)
    then
        print("[ArexansTools] " .. tostring(title or "Info") .. ": " .. tostring(content or ""))
    end
end

-- =========================================================
-- GUI TRANSITION SAFETY
-- =========================================================
-- Jangan pernah menyembunyikan / menghancurkan GUI bawaan game secara otomatis.
-- Guard ini hanya dipakai untuk GUI milik script supaya tidak ikut hilang ketika
-- game memutar video, berpindah round, respawn, atau teleport lobby/gameplay.
ArexansGuiGuards = {}

function registerArexansGuiGuard(name, guiGetter, enabledGetter, repairCallback)
    ArexansGuiGuards[name] = {
        GuiGetter = guiGetter,
        EnabledGetter = enabledGetter,
        RepairCallback = repairCallback,
    }
end

function runArexansGuiGuards()
    local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    for _, guard in pairs(ArexansGuiGuards) do
        pcall(function()
            local gui = guard.GuiGetter and guard.GuiGetter()
            if gui and gui:IsA("ScreenGui") then
                gui.ResetOnSpawn = false
                if gui.Parent ~= playerGui then
                    gui.Parent = playerGui
                end
                if guard.EnabledGetter then
                    gui.Enabled = guard.EnabledGetter() == true
                end
            end
            if guard.RepairCallback then
                guard.RepairCallback(gui, playerGui)
            end
        end)
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        runArexansGuiGuards()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.delay(0.25, runArexansGuiGuards)
    task.delay(1.25, runArexansGuiGuards)
end)

function alive(i)
    if not i then return false end
    local ok = pcall(function() return i.Parent end)
    return ok and i.Parent ~= nil
end

function validPart(p) return p and alive(p) and p:IsA("BasePart") end
function clamp(n,lo,hi) if n<lo then return lo elseif n>hi then return hi else return n end end
function dist(a,b) return (a-b).Magnitude end

function firstBasePart(inst)
    if not alive(inst) then return nil end
    if inst:IsA("BasePart") then return inst end
    if inst:IsA("Model") then
        if inst.PrimaryPart and inst.PrimaryPart:IsA("BasePart") and alive(inst.PrimaryPart) then return inst.PrimaryPart end
        local p = inst:FindFirstChildWhichIsA("BasePart", true)
        if validPart(p) then return p end
    end
    if inst:IsA("Tool") then
        local h = inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart")
        if validPart(h) then return h end
    end
    return nil
end

---------------------------------------------------
--== FEATURE STATES (LENGKAP) ==--
---------------------------------------------------
featureStates = {
    -- Player
    WalkSpeed = false,
    WalkSpeedValue = 16,
    Noclip = false,
    AntiAFK = false,
    GodMode = false,
    NoFall = false,
    AntiStun = false,
    MoonWalk = false, -- status fitur asli; hanya berubah saat icon layar diklik
    MoonWalkIconVisible = false, -- status tampil/sembunyi icon layar
    ZiggleMoonwalkCombo = false,
    ZiggleMoonwalkComboIconVisible = false,
    Ziggle = false, -- status fitur asli; hanya berubah saat icon layar diklik
    ZiggleIconVisible = false, -- status tampil/sembunyi icon layar
    ZigglePower = 1.55,
    ZiggleSpeed = 40,
    ZiggleMode = "Pro",
    ZiggleAutoFaceKiller = false,
    ZiggleAutoFaceDistance = 25,
    
    -- Survivor
    NoSkillcheck = false,
    BypassGate = false,
    AutoLever = false,
    AutoPallet = false,
    AutoPalletDistance = 11.5,
    AutoPalletKillerDistance = 31,
    AutoSpinCrouch = false,
    AutoSpinCrouchDistance = 42,
    AutoHealPerfect = false,
    AutoHealNeutral = false,
    AutoGeneratorPerfect = false,
    AutoGeneratorNeutral = false,
    AutoParry = false,
    AutoShoot = false,
    
    -- Killer
    KillAll = false,
    AutoAttack = false,
    NoFlashlight = false,
    
    -- The Veil Aimbot
    VeilAimbotEnabled = false,
    VeilAimbotChargeEnabled = false,
    VeilToughWall = true,
    VeilMinPitch = -1,
    VeilMaxPitch = 30,
    
    -- Spear Trajectory Line
    SpearTrajectoryEnabled = false,
    SpearMinSpeed = 120,
    SpearMaxSpeed = 850,
    SpearAutoHoldGui = false,
    
    -- ESP Settings
    ESPFillTransparency = 0.7,
    ESPOutlineTransparency = 0,
    ESPTextSize = 14,
    
    -- Player ESP
    SurvivorESP = false,
    KillerESP = false,
    Nametags = false,
    DistanceESP = false,
    SurvivorColor = Color3.fromRGB(0, 255, 0),
    KillerColor = Color3.fromRGB(0, 120, 255),
    SurvivorItemsESP = false,
    SurvivorItemsColor = Color3.fromRGB(0, 170, 255),
    
    -- World ESP
    GeneratorESP = false,
    HookESP = false,
    GateESP = false,
    WindowESP = false,
    PalletESP = false,
    GeneratorColor = Color3.fromRGB(0, 170, 255),
    HookColor = Color3.fromRGB(0, 120, 255),
    GateColor = Color3.fromRGB(255, 225, 0),
    WindowColor = Color3.fromRGB(255, 255, 255),
    PalletColor = Color3.fromRGB(255, 140, 0),
    
    -- Visual
    FullBright = false,
    TimeOfDay = Lighting.ClockTime,
    FOVEnabled = false,
    FOVValue = 95,
    
    -- Aimbot
    AimbotEnabled = false,
    AimbotTeamCheck = false,
    AimbotShowFOV = false,
    AimbotFOVRadius = 50,
    AimbotPart = "Head",
    AimbotFOVThickness = 2,
    AimbotFOVTransparency = 0.4,
}

---------------------------------------------------
--== STORE ORIGINAL LIGHTING ==--
---------------------------------------------------
originalLighting = {
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
}

---------------------------------------------------
--== SPEED SYSTEM ==--
---------------------------------------------------
speedHumanoid = nil
speedConnChanged, speedConnAncestry = nil, nil
speedBound = false

function setWalkSpeed(h, v)
    if h and h.Parent then
        pcall(function() h.WalkSpeed = v end)
    end
end

function isInteractionActive()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return false end
    local sc = pg:FindFirstChild("SkillCheckPromptGui")
    if not sc then return false end
    local check = sc:FindFirstChild("Check")
    return check and check.Visible
end

function bindSpeedLoop()
    if speedBound then return end
    speedBound = true
    RunService:BindToRenderStep("VD_SpeedEnforcer", 300, function()
        if not speedHumanoid or not speedHumanoid.Parent then return end
        if isInteractionActive() or getgenv().ParryDebounce then return end
        
        -- Constant Speed Application: Avoids WalkSpeed stuttering
        if featureStates.WalkSpeed and math.abs(speedHumanoid.WalkSpeed - featureStates.WalkSpeedValue) > 0.1 then
            setWalkSpeed(speedHumanoid, featureStates.WalkSpeedValue)
        end
    end)
end

function unbindSpeedLoop()
    if speedBound then
        speedBound = false
        pcall(function() RunService:UnbindFromRenderStep("VD_SpeedEnforcer") end)
    end
end

function hookHumanoid(h)
    if speedConnChanged then speedConnChanged:Disconnect() speedConnChanged=nil end
    if speedConnAncestry then speedConnAncestry:Disconnect() speedConnAncestry=nil end
    speedHumanoid = h
    if featureStates.WalkSpeed then
        setWalkSpeed(h, featureStates.WalkSpeedValue)
        bindSpeedLoop()
    end
    speedConnChanged = h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if h.Parent and featureStates.WalkSpeed and h.WalkSpeed ~= featureStates.WalkSpeedValue then
            setWalkSpeed(h, featureStates.WalkSpeedValue)
        end
    end)
    speedConnAncestry = h.AncestryChanged:Connect(function(_, parent)
        if not parent then
            unbindSpeedLoop()
            speedHumanoid = nil
        end
    end)
end

function onCharacterAdded(char)
    local h = char:WaitForChild("Humanoid", 10) or char:FindFirstChildOfClass("Humanoid")
    if h then hookHumanoid(h) end
    char.ChildAdded:Connect(function(ch) if ch:IsA("Humanoid") then hookHumanoid(ch) end end)
end

---------------------------------------------------
--== NOCLIP SYSTEM ==--
---------------------------------------------------
noclipConn = nil

function setNoclip(state)
    if state and not noclipConn then
        featureStates.Noclip = true
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif not state and noclipConn then
        featureStates.Noclip = false
        noclipConn:Disconnect()
        noclipConn = nil
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

---------------------------------------------------
--== ANTI AFK SYSTEM ==--
---------------------------------------------------
antiAFKConn = nil

function startAntiAFK()
    antiAFKConn = LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end

function stopAntiAFK()
    if antiAFKConn then
        antiAFKConn:Disconnect()
        antiAFKConn = nil
    end
end

---------------------------------------------------
--== GOD MODE SYSTEM ==--
---------------------------------------------------
godModeEnabled = false
godModeConnection = nil
characterAddedConnection = nil

function enableGodMode()
    godModeEnabled = true
    local function refreshGodMode()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            if hum.MaxHealth < 100 then hum.MaxHealth = 100 end
            hum.BreakJointsOnDeath = false
        end
    end
    
    refreshGodMode()
    characterAddedConnection = LocalPlayer.CharacterAdded:Connect(refreshGodMode)
    godModeConnection = RunService.Heartbeat:Connect(refreshGodMode)
end

function disableGodMode()
    godModeEnabled = false
    if godModeConnection then godModeConnection:Disconnect() godModeConnection = nil end
    if characterAddedConnection then characterAddedConnection:Disconnect() characterAddedConnection = nil end
end

---------------------------------------------------
--== NO FALL SYSTEM (FIXED) ==--
---------------------------------------------------
FallRemote = nil
pcall(function()
    FallRemote = ReplicatedStorage:FindFirstChild("Remotes") and 
                 ReplicatedStorage.Remotes:FindFirstChild("Mechanics") and 
                 ReplicatedStorage.Remotes.Mechanics:FindFirstChild("Fall")
end)

NoFallEnabled = false
NoFallMT = nil
NoFallOriginalNamecall = nil

function setupNoFall()
    if NoFallMT then return end
    if not FallRemote then return end
    
    local success, mt = pcall(getrawmetatable, game)
    if not success then return end
    
    NoFallMT = mt
    NoFallOriginalNamecall = NoFallMT.__namecall
    setreadonly(NoFallMT, false)
    
    NoFallMT.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if NoFallEnabled and self == FallRemote and method == "FireServer" then
            return nil
        end
        return NoFallOriginalNamecall(self, ...)
    end)
    
    setreadonly(NoFallMT, true)
end

function enableNoFall()
    NoFallEnabled = true
    featureStates.NoFall = true
    setupNoFall()
end

function disableNoFall()
    NoFallEnabled = false
    featureStates.NoFall = false
end

-- =========================================================
-- NO SKILLCHECK SYSTEM (DIPERBAIKI)
-- =========================================================
noSkillcheckEnabled = false
originalNamecall = nil
hookedMetatable = false

function setupNoSkillcheck()
    if noSkillcheckEnabled then return end
    noSkillcheckEnabled = true
    
    local success, mt = pcall(getrawmetatable, game)
    if not success then
        safeNotify("No Skillcheck", "Failed to get metatable", 3)
        return
    end
    
    originalNamecall = mt.__namecall
    
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if noSkillcheckEnabled and method == "FireServer" then
            local selfName = tostring(self):lower()
            
            if selfName:find("skill") or selfName:find("check") or 
               selfName:find("healing") or selfName:find("generator") then
               
                if args[1] and type(args[1]) == "string" then
                    args[1] = "success"
                end
                if args[2] then
                    args[2] = 1 -- Perfect score
                end
            end
        end
        return originalNamecall(self, unpack(args))
    end)
    setreadonly(mt, true)
    hookedMetatable = true
end

function disableNoSkillcheck()
    if not noSkillcheckEnabled then return end
    noSkillcheckEnabled = false
    if hookedMetatable then
        local success, mt = pcall(getrawmetatable, game)
        if success and mt and originalNamecall then
            setreadonly(mt, false)
            mt.__namecall = originalNamecall
            setreadonly(mt, true)
        end
        hookedMetatable = false
    end
end

---------------------------------------------------
--== BYPASS GATE SYSTEM ==--
---------------------------------------------------
function getMapFolders()
    local folders = {}
    local mainMap = Workspace:FindFirstChild("Map")
    if not mainMap then return folders end
    table.insert(folders, mainMap)
    
    local rooftop = mainMap:FindFirstChild("Rooftop")
    if rooftop then 
        table.insert(folders, rooftop)
        local rooftopModel = rooftop:FindFirstChild("Model")
        if rooftopModel then table.insert(folders, rooftopModel) end
    end
    
    local maze2 = mainMap:FindFirstChild("Maze2")
    if maze2 then table.insert(folders, maze2) end
    
    local model = mainMap:FindFirstChild("Model")
    if model then table.insert(folders, model) end
    
    local hooks = mainMap:FindFirstChild("Hooks")
    if hooks then table.insert(folders, hooks) end
    
    local pallets = mainMap:FindFirstChild("Pallets")
    if pallets then table.insert(folders, pallets) end
    
    local vaults = mainMap:FindFirstChild("Vaults")
    if vaults then table.insert(folders, vaults) end
    
    local gens = mainMap:FindFirstChild("Gens")
    if gens then table.insert(folders, gens) end
    
    return folders
end

function gatherGates()
    local gates = {}
    for _, folder in pairs(getMapFolders()) do
        for _, gate in pairs(folder:GetChildren()) do
            if gate.Name == "Gate" then table.insert(gates, gate) end
        end
    end
    return gates
end

function setBypassGate(state)
    featureStates.BypassGate = state
    local gates = gatherGates()
    for _, gate in pairs(gates) do
        local leftGate = gate:FindFirstChild("LeftGate")
        local rightGate = gate:FindFirstChild("RightGate")
        local leftEnd = gate:FindFirstChild("LeftGate-end")
        local rightEnd = gate:FindFirstChild("RightGate-end")
        local box = gate:FindFirstChild("Box")
        
        if state then
            if leftGate then leftGate.Transparency = 1 leftGate.CanCollide = false end
            if rightGate then rightGate.Transparency = 1 rightGate.CanCollide = false end
            if leftEnd then leftEnd.Transparency = 0 leftEnd.CanCollide = true end
            if rightEnd then rightEnd.Transparency = 0 rightEnd.CanCollide = true end
            if box then box.CanCollide = false end
        else
            if leftGate then leftGate.Transparency = 0 leftGate.CanCollide = true end
            if rightGate then rightGate.Transparency = 0 rightGate.CanCollide = true end
            if leftEnd then leftEnd.Transparency = 1 leftEnd.CanCollide = true end
            if rightEnd then rightEnd.Transparency = 1 rightEnd.CanCollide = true end
            if box then box.CanCollide = true end
        end
    end
end

---------------------------------------------------
--== AUTO LEVER SYSTEM ==--
---------------------------------------------------
autoLeverRunning = false

function startAutoLever()
    autoLeverRunning = true
    
    local leverRemote = nil
    pcall(function()
        leverRemote = ReplicatedStorage:FindFirstChild("Remotes") and
                      ReplicatedStorage.Remotes:FindFirstChild("Exit") and
                      ReplicatedStorage.Remotes.Exit:FindFirstChild("LeverEvent")
    end)
    
    task.spawn(function()
        local isTouching = false
        local lastPosition = nil
        
        UserInputService.TouchStarted:Connect(function() isTouching = true end)
        UserInputService.TouchEnded:Connect(function() isTouching = false end)
        
        while autoLeverRunning and featureStates.AutoLever do
            task.wait(0.15)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            
            if root and humanoid then
                local nearestMain = nil
                local shortestDist = 20
                
                for _, folder in pairs(getMapFolders()) do
                    for _, gate in pairs(folder:GetChildren()) do
                        if gate.Name == "Gate" and gate:FindFirstChild("ExitLever") then
                            local main = gate.ExitLever:FindFirstChild("Main")
                            if main and main:IsA("BasePart") then
                                local d = (root.Position - main.Position).Magnitude
                                if d < shortestDist then
                                    shortestDist = d
                                    nearestMain = main
                                end
                            end
                        end
                    end
                end
                
                local moved = lastPosition and (root.Position - lastPosition).Magnitude > 0.5
                local tryingToMove = false
                
                if UserInputService.KeyboardEnabled then
                    local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space}
                    for _, key in ipairs(keys) do
                        if UserInputService:IsKeyDown(key) then
                            tryingToMove = true
                            break
                        end
                    end
                end
                if UserInputService.TouchEnabled and isTouching then tryingToMove = true end
                
                if (moved or tryingToMove) and nearestMain and leverRemote then
                    pcall(function() leverRemote:FireServer(nearestMain, false) end)
                elseif nearestMain and shortestDist <= 10 and leverRemote then
                    pcall(function() leverRemote:FireServer(nearestMain, true) end)
                end
                lastPosition = root.Position
            end
        end
    end)
end

function stopAutoLever()
    autoLeverRunning = false
end

---------------------------------------------------
--== AUTO PALLET SYSTEM ==--
---------------------------------------------------
autoPalletRunning = false
autoPalletLastDrop = 0
autoPalletLastAttempt = 0
autoPalletDroppedCache = {}
autoPalletKillerDistanceCache = {}
autoPalletRemoteCache = {}
autoPalletRemoteCacheAt = 0
autoPalletCache = {}
autoPalletCacheAt = 0
autoPalletDeepScanAt = 0
autoPalletPartCache = setmetatable({}, {__mode = "k"})
autoPalletPartCacheAt = setmetatable({}, {__mode = "k"})
autoPalletGuiButtonCache = nil
autoPalletGuiButtonCacheAt = 0
autoPalletPlayerLastPos = nil
autoPalletPlayerLastPosAt = 0

AUTO_PALLET_DEFAULT_RANGE = 11.5
AUTO_PALLET_DEFAULT_KILLER_RANGE = 31
AUTO_PALLET_COOLDOWN = 0.82
AUTO_PALLET_RETRY_DELAY = 0.18
AUTO_PALLET_CACHE_INTERVAL = 1.15
AUTO_PALLET_PART_CACHE_INTERVAL = 1.4
AUTO_PALLET_GUI_CACHE_INTERVAL = 0.45
AUTO_PALLET_REMOTE_CACHE_INTERVAL = 4.0
AUTO_PALLET_DEEP_SCAN_INTERVAL = 3.0
AUTO_PALLET_KILLER_PALLET_TRIGGER = 8.75
AUTO_PALLET_KILLER_PALLET_PANIC = 5.25
AUTO_PALLET_PLAYER_PALLET_MAX = 12.5
AUTO_PALLET_BETWEEN_DOT = 0.18

local function autoPalletFlatVector(v)
    if typeof(v) ~= "Vector3" then return Vector3.new(0, 0, 0) end
    return Vector3.new(v.X, 0, v.Z)
end

local function autoPalletPartVelocity(part)
    if not part then return Vector3.new(0, 0, 0) end

    local ok, vel = pcall(function() return part.AssemblyLinearVelocity end)
    if ok and typeof(vel) == "Vector3" then return vel end

    ok, vel = pcall(function() return part.Velocity end)
    if ok and typeof(vel) == "Vector3" then return vel end

    return Vector3.new(0, 0, 0)
end

local function autoPalletNameLower(inst)
    return tostring(inst and inst.Name or ""):lower()
end

local function autoPalletHasAncestorNamed(inst, name)
    if not inst then return false end
    name = tostring(name or ""):lower()
    local cur = inst
    local depth = 0
    while cur and depth < 12 do
        if autoPalletNameLower(cur) == name then return true end
        cur = cur.Parent
        depth += 1
    end
    return false
end

local function autoPalletIsInPalletFolder(inst)
    if not inst then return false end
    local cur = inst.Parent
    local depth = 0
    while cur and depth < 12 do
        local n = autoPalletNameLower(cur)
        if n == "pallets" or n:find("pallets", 1, true) then
            return true
        end
        cur = cur.Parent
        depth += 1
    end
    return false
end

local function autoPalletLooksUsedByNameOrAttr(pallet)
    if not alive(pallet) then return true end

    local name = autoPalletNameLower(pallet)
    if name:find("broken", 1, true) or name:find("destroy", 1, true)
        or name:find("used", 1, true) or name:find("dropped", 1, true)
        or name:find("fallen", 1, true) then
        return true
    end

    local attrSaysUsed = false
    pcall(function()
        for attrName, attrValue in pairs(pallet:GetAttributes()) do
            local attr = tostring(attrName or ""):lower()
            if attrValue == true and (attr:find("used", 1, true)
                or attr:find("broken", 1, true) or attr:find("dropped", 1, true)
                or attr:find("fallen", 1, true) or attr:find("destroy", 1, true)) then
                attrSaysUsed = true
            end
        end
    end)

    return attrSaysUsed
end

local function autoPalletPartPriority(part)
    if not part or not part:IsA("BasePart") then return -999 end
    local n = autoPalletNameLower(part)
    local score = 0
    if n == "main" then score += 14 end
    if n:find("hitbox", 1, true) then score += 12 end
    if n:find("pallet", 1, true) then score += 10 end
    if n:find("board", 1, true) or n:find("wood", 1, true) then score += 7 end
    if n:find("prompt", 1, true) or n:find("interact", 1, true) or n:find("trigger", 1, true) then score += 8 end
    if part.CanCollide then score += 1 end
    return score
end

local function autoPalletTargetParts(pallet, force)
    local parts = {}
    if not alive(pallet) then return parts end

    local now = os.clock()
    local cached = autoPalletPartCache[pallet]
    local cachedAt = autoPalletPartCacheAt[pallet] or 0
    if not force and cached and (now - cachedAt) < AUTO_PALLET_PART_CACHE_INTERVAL then
        local valid = {}
        for _, part in ipairs(cached) do
            if part and part:IsA("BasePart") and alive(part) then
                valid[#valid + 1] = part
            end
        end
        if #valid > 0 then return valid end
    end

    if pallet:IsA("BasePart") then
        parts[#parts + 1] = pallet
    else
        local preferredNames = {
            "Main", "Hitbox", "HumanoidRootPart", "Root", "Prompt", "PromptPart",
            "Interact", "Interaction", "Trigger", "Pallet", "Board", "Wood"
        }

        for _, name in ipairs(preferredNames) do
            local found = nil
            pcall(function() found = pallet:FindFirstChild(name, true) end)
            if found and found:IsA("BasePart") then
                parts[#parts + 1] = found
            end
        end

        pcall(function()
            for _, obj in ipairs(pallet:GetDescendants()) do
                if obj:IsA("BasePart") then
                    parts[#parts + 1] = obj
                end
                if #parts >= 16 then break end
            end
        end)
    end

    local seen = {}
    local unique = {}
    for _, part in ipairs(parts) do
        if part and part:IsA("BasePart") and alive(part) and not seen[part] then
            seen[part] = true
            unique[#unique + 1] = part
        end
    end

    autoPalletPartCache[pallet] = unique
    autoPalletPartCacheAt[pallet] = now
    return unique
end

local function autoPalletBestPart(pallet, nearPosition)
    local parts = autoPalletTargetParts(pallet)
    local best, bestScore = nil, -math.huge

    for _, part in ipairs(parts) do
        local score = autoPalletPartPriority(part)
        if typeof(nearPosition) == "Vector3" then
            score -= (part.Position - nearPosition).Magnitude * 0.22
        end
        if score > bestScore then
            bestScore = score
            best = part
        end
    end

    return best
end

local function isAutoPalletUsable(pallet)
    if not alive(pallet) then return false end
    if autoPalletLooksUsedByNameOrAttr(pallet) then return false end
    return autoPalletBestPart(pallet) ~= nil
end

local function addAutoPalletCandidate(list, seen, inst)
    if not inst or seen[inst] then return end
    if not (inst:IsA("Model") or inst:IsA("Folder") or inst:IsA("BasePart")) then return end

    local lowerName = autoPalletNameLower(inst)
    local fromPalletFolder = autoPalletIsInPalletFolder(inst)
    local looksLikePallet = lowerName:find("pallet", 1, true) ~= nil
        or lowerName == "palletwrong"
        or fromPalletFolder

    if not looksLikePallet then return end
    if not isAutoPalletUsable(inst) then return end

    seen[inst] = true
    list[#list + 1] = inst
end

function gatherAutoPallets(force)
    local now = os.clock()
    if not force and autoPalletCache and (now - autoPalletCacheAt) < AUTO_PALLET_CACHE_INTERVAL then
        return autoPalletCache
    end

    local previousCount = (type(autoPalletCache) == "table") and #autoPalletCache or 0
    local doDeepScan = force or previousCount == 0 or (now - autoPalletDeepScanAt) >= AUTO_PALLET_DEEP_SCAN_INTERVAL
    local pallets = {}
    local seen = {}

    local function scanPalletFolder(folder)
        if not alive(folder) then return end
        for _, obj in ipairs(folder:GetChildren()) do
            local candidate = obj
            if not (candidate:IsA("Model") or candidate:IsA("Folder") or candidate:IsA("BasePart")) then
                candidate = obj:FindFirstAncestorOfClass("Model") or obj
            end
            addAutoPalletCandidate(pallets, seen, candidate)
        end
    end

    local function scanRoot(root)
        if not alive(root) then return end

        addAutoPalletCandidate(pallets, seen, root)

        local rootName = autoPalletNameLower(root)
        if rootName == "pallets" or rootName:find("pallets", 1, true) then
            scanPalletFolder(root)
        end

        for _, obj in ipairs(root:GetChildren()) do
            addAutoPalletCandidate(pallets, seen, obj)
            local childName = autoPalletNameLower(obj)
            if childName == "pallets" or childName:find("pallets", 1, true) then
                scanPalletFolder(obj)
            end
        end

        -- Deep scan tetap ada, tapi tidak dijalankan terlalu sering karena inilah sumber lag terbesar.
        if doDeepScan then
            pcall(function()
                for _, obj in ipairs(root:GetDescendants()) do
                    local lowerName = autoPalletNameLower(obj)
                    if lowerName:find("pallet", 1, true) or autoPalletIsInPalletFolder(obj) then
                        local model = obj:FindFirstAncestorOfClass("Model") or obj
                        addAutoPalletCandidate(pallets, seen, model)
                    end
                end
            end)
        end
    end

    for _, folder in pairs(getMapFolders()) do
        scanRoot(folder)
    end

    local map = Workspace:FindFirstChild("Map")
    if map then scanRoot(map) end

    if doDeepScan then autoPalletDeepScanAt = now end
    autoPalletCache = pallets
    autoPalletCacheAt = now
    return pallets
end

local function autoPalletGetKillerRoot(model)
    if not alive(model) then return nil end
    if model:IsA("Model") then
        return model.PrimaryPart
            or model:FindFirstChild("HumanoidRootPart")
            or model:FindFirstChild("Torso")
            or model:FindFirstChild("UpperTorso")
            or model:FindFirstChildWhichIsA("BasePart")
    end
    if model:IsA("BasePart") then return model end
    return firstBasePart(model)
end

local function getAutoPalletKillers()
    local killers = {}
    local ok, result = pcall(function()
        if getKillerModels then return getKillerModels(false) end
        return {}
    end)
    if ok and type(result) == "table" then killers = result end
    return killers
end

local function autoPalletOppositeSides(playerPos, killerPos, palletPos)
    local a = autoPalletFlatVector(playerPos - palletPos)
    local b = autoPalletFlatVector(killerPos - palletPos)
    if a.Magnitude < 0.25 or b.Magnitude < 0.25 then return true end
    return a.Unit:Dot(b.Unit) <= AUTO_PALLET_BETWEEN_DOT
end

local function autoPalletGetMoveDir(root)
    local rootVel = autoPalletFlatVector(autoPalletPartVelocity(root))
    if rootVel.Magnitude >= 1.15 then
        return rootVel.Unit
    end

    if autoPalletPlayerLastPos and (root.Position - autoPalletPlayerLastPos).Magnitude >= 0.2 then
        local delta = autoPalletFlatVector(root.Position - autoPalletPlayerLastPos)
        if delta.Magnitude >= 0.2 then return delta.Unit end
    end

    local look = autoPalletFlatVector(root.CFrame.LookVector)
    if look.Magnitude >= 0.05 then return look.Unit end
    return nil
end

local function autoPalletKillerPressure(root, pallet, palletPart)
    if not root or not palletPart then return false end

    local moveDir = autoPalletGetMoveDir(root)
    local maxKillerDistance = math.clamp(tonumber(featureStates.AutoPalletKillerDistance) or AUTO_PALLET_DEFAULT_KILLER_RANGE, 8, 48)
    local playerPalletDist = autoPalletFlatVector(root.Position - palletPart.Position).Magnitude
    if playerPalletDist > AUTO_PALLET_PLAYER_PALLET_MAX then return false end

    local bestTriggered = false
    local bestKiller, bestKillerDistance, bestReason = nil, math.huge, nil

    for _, killerModel in ipairs(getAutoPalletKillers()) do
        local killerRoot = autoPalletGetKillerRoot(killerModel)
        if killerRoot and killerRoot ~= root then
            local flatPlayerToKiller = autoPalletFlatVector(killerRoot.Position - root.Position)
            local killerDistance = flatPlayerToKiller.Magnitude
            local killerPalletVector = autoPalletFlatVector(palletPart.Position - killerRoot.Position)
            local killerPalletDistance = killerPalletVector.Magnitude

            if killerDistance >= 1 and killerDistance <= maxKillerDistance and killerPalletDistance <= (maxKillerDistance + 3) then
                local killerVel = autoPalletFlatVector(autoPalletPartVelocity(killerRoot))
                local rootVel = autoPalletFlatVector(autoPalletPartVelocity(root))
                local killerToPlayerDir = autoPalletFlatVector(root.Position - killerRoot.Position)
                local towardPlayer = 0
                if killerToPlayerDir.Magnitude > 0.05 then
                    towardPlayer = killerVel:Dot(killerToPlayerDir.Unit)
                end

                local towardPallet = 0
                if killerPalletVector.Magnitude > 0.05 then
                    towardPallet = killerVel:Dot(killerPalletVector.Unit)
                end

                local playerAwaySpeed = 0
                if flatPlayerToKiller.Magnitude > 0.05 then
                    playerAwaySpeed = rootVel:Dot((-flatPlayerToKiller).Unit)
                end

                local previous = autoPalletKillerDistanceCache[killerModel]
                autoPalletKillerDistanceCache[killerModel] = killerDistance
                local shrinking = previous and (previous - killerDistance) >= 0.04

                local behindMovement = false
                if moveDir and flatPlayerToKiller.Magnitude > 0.05 then
                    behindMovement = moveDir:Dot(flatPlayerToKiller.Unit) <= 0.22
                end

                local oppositeSides = autoPalletOppositeSides(root.Position, killerRoot.Position, palletPart.Position)
                local closingFast = towardPlayer >= 2.1 or towardPallet >= 1.55 or shrinking
                local panicClose = killerPalletDistance <= AUTO_PALLET_KILLER_PALLET_PANIC or killerDistance <= 7.2

                local predictedSoon = false
                if towardPallet > 2 then
                    predictedSoon = (killerPalletDistance / math.max(towardPallet, 0.1)) <= 0.78
                end

                local playerJustPassed = oppositeSides and playerPalletDist <= 10.5
                local timingWindow = killerPalletDistance <= AUTO_PALLET_KILLER_PALLET_TRIGGER
                    or predictedSoon
                    or (panicClose and playerPalletDist <= AUTO_PALLET_PLAYER_PALLET_MAX)

                local chaseShapeOk = oppositeSides or behindMovement or killerPalletDistance <= 6.8
                local pressureOk = closingFast or panicClose or (killerDistance <= 9.5 and playerAwaySpeed >= -1.5)

                if timingWindow and chaseShapeOk and pressureOk and playerJustPassed then
                    bestTriggered = true
                    if killerDistance < bestKillerDistance then
                        bestKiller = killerModel
                        bestKillerDistance = killerDistance
                        bestReason = "between"
                    end
                elseif timingWindow and behindMovement and pressureOk and playerPalletDist <= 7.8 then
                    bestTriggered = true
                    if killerDistance < bestKillerDistance then
                        bestKiller = killerModel
                        bestKillerDistance = killerDistance
                        bestReason = "behind"
                    end
                elseif panicClose and oppositeSides and playerPalletDist <= 12 then
                    bestTriggered = true
                    if killerDistance < bestKillerDistance then
                        bestKiller = killerModel
                        bestKillerDistance = killerDistance
                        bestReason = "panic"
                    end
                end
            end
        end
    end

    return bestTriggered, bestKiller, bestKillerDistance, bestReason
end

local function getBestAutoPallet(root)
    if not root then return nil, nil, math.huge end

    local maxDistance = math.clamp(tonumber(featureStates.AutoPalletDistance) or AUTO_PALLET_DEFAULT_RANGE, 5, 18)
    local bestPallet, bestPart, bestScore = nil, nil, math.huge

    for _, pallet in ipairs(gatherAutoPallets(false)) do
        local part = autoPalletBestPart(pallet, root.Position)
        if part then
            local playerDist = autoPalletFlatVector(root.Position - part.Position).Magnitude
            if playerDist <= (maxDistance + 2.5) then
                local triggered, _, killerDistance = autoPalletKillerPressure(root, pallet, part)
                if triggered then
                    local score = playerDist + ((killerDistance or 30) * 0.06)
                    if score < bestScore then
                        bestPallet = pallet
                        bestPart = part
                        bestScore = score
                    end
                end
            end
        end
    end

    return bestPallet, bestPart, bestScore
end

local function autoPalletIsRemote(obj)
    local ok, isRemote = pcall(function()
        return obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("UnreliableRemoteEvent")
    end)
    return ok and isRemote
end

local function autoPalletObjectPathLower(obj)
    local parts = {}
    local cur = obj
    local depth = 0
    while cur and depth < 10 do
        parts[#parts + 1] = tostring(cur.Name or "")
        cur = cur.Parent
        depth += 1
    end
    return table.concat(parts, " "):lower()
end

local function autoPalletRemoteScore(remote)
    local hay = autoPalletObjectPathLower(remote)
    local score = 0

    if hay:find("pallet", 1, true) then score += 14 end
    if hay:find("drop", 1, true) or hay:find("slam", 1, true)
        or hay:find("fall", 1, true) or hay:find("push", 1, true) then score += 9 end
    if hay:find("interact", 1, true) or hay:find("interaction", 1, true)
        or hay:find("use", 1, true) or hay:find("action", 1, true)
        or hay:find("activate", 1, true) or hay:find("trigger", 1, true) then score += 7 end
    if hay:find("map", 1, true) or hay:find("object", 1, true)
        or hay:find("prop", 1, true) or hay:find("game", 1, true) then score += 2 end

    if hay:find("generator", 1, true) or hay:find("healing", 1, true)
        or hay:find("heal", 1, true) or hay:find("attack", 1, true)
        or hay:find("parry", 1, true) or hay:find("shoot", 1, true)
        or hay:find("spear", 1, true) or hay:find("flashlight", 1, true)
        or hay:find("lever", 1, true) or hay:find("exit", 1, true) then
        score -= 12
    end

    return score
end

local function getAutoPalletRemotes(force)
    local now = os.clock()
    if not force and autoPalletRemoteCache and (now - autoPalletRemoteCacheAt) < AUTO_PALLET_REMOTE_CACHE_INTERVAL then
        return autoPalletRemoteCache
    end

    local scored = {}
    local scanRoots = {}

    local remotesRoot = ReplicatedStorage:FindFirstChild("Remotes")
    if remotesRoot then scanRoots[#scanRoots + 1] = remotesRoot end
    scanRoots[#scanRoots + 1] = ReplicatedStorage

    local seen = {}
    for _, root in ipairs(scanRoots) do
        if alive(root) then
            for _, obj in ipairs(root:GetDescendants()) do
                if not seen[obj] and autoPalletIsRemote(obj) then
                    seen[obj] = true
                    local score = autoPalletRemoteScore(obj)
                    if score >= 8 then
                        scored[#scored + 1] = {remote = obj, score = score}
                    end
                end
            end
        end
    end

    table.sort(scored, function(a, b) return a.score > b.score end)

    local remotesFound = {}
    for i, item in ipairs(scored) do
        if i > 3 then break end
        remotesFound[#remotesFound + 1] = item.remote
    end

    autoPalletRemoteCache = remotesFound
    autoPalletRemoteCacheAt = now
    return remotesFound
end

local function tryAutoPalletPrompt(pallet)
    if not alive(pallet) then return false end

    local fired = false
    local prompts = {}
    pcall(function()
        if pallet:IsA("ProximityPrompt") then prompts[#prompts + 1] = pallet end
        for _, obj in ipairs(pallet:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then prompts[#prompts + 1] = obj end
        end
    end)

    for _, prompt in ipairs(prompts) do
        pcall(function() prompt.Enabled = true end)
        pcall(function()
            if prompt.MaxActivationDistance < 12 then prompt.MaxActivationDistance = 12 end
        end)

        if fireproximityprompt then
            local ok = pcall(function() fireproximityprompt(prompt) end)
            fired = ok or fired
            ok = pcall(function() fireproximityprompt(prompt, 1) end)
            fired = ok or fired
            ok = pcall(function() fireproximityprompt(prompt, 1, true) end)
            fired = ok or fired
        end

        local okBegin = pcall(function() prompt:InputHoldBegin() end)
        if okBegin then
            fired = true
            task.wait(0.015)
            pcall(function() prompt:InputHoldEnd() end)
        end
    end

    return fired
end

local function tryAutoPalletClickDetector(pallet)
    if not fireclickdetector or not alive(pallet) then return false end

    local fired = false
    local detectors = {}
    pcall(function()
        if pallet:IsA("ClickDetector") then detectors[#detectors + 1] = pallet end
        for _, obj in ipairs(pallet:GetDescendants()) do
            if obj:IsA("ClickDetector") then detectors[#detectors + 1] = obj end
        end
    end)

    for _, detector in ipairs(detectors) do
        local ok = pcall(function() fireclickdetector(detector) end)
        fired = ok or fired
        ok = pcall(function() fireclickdetector(detector, 0) end)
        fired = ok or fired
        ok = pcall(function() fireclickdetector(detector, 1) end)
        fired = ok or fired
    end

    return fired
end

local function autoPalletGuiText(obj)
    if not obj then return "" end
    local parts = { tostring(obj.Name or "") }

    pcall(function()
        if obj:IsA("TextButton") or obj:IsA("TextLabel") or obj:IsA("TextBox") then
            parts[#parts + 1] = tostring(obj.Text or "")
        end
    end)

    pcall(function()
        if obj:IsA("ImageButton") or obj:IsA("ImageLabel") then
            parts[#parts + 1] = tostring(obj.Image or "")
            parts[#parts + 1] = tostring(obj.HoverImage or "")
            parts[#parts + 1] = tostring(obj.PressedImage or "")
        end
    end)

    pcall(function()
        if obj:IsA("GuiButton") then parts[#parts + 1] = tostring(obj.ToolTip or "") end
    end)

    pcall(function()
        for key, value in pairs(obj:GetAttributes()) do
            parts[#parts + 1] = tostring(key)
            parts[#parts + 1] = tostring(value)
        end
    end)

    local cur = obj.Parent
    local depth = 0
    while cur and depth < 4 do
        parts[#parts + 1] = tostring(cur.Name or "")
        pcall(function()
            if cur:IsA("TextButton") or cur:IsA("TextLabel") or cur:IsA("TextBox") then
                parts[#parts + 1] = tostring(cur.Text or "")
            end
        end)
        cur = cur.Parent
        depth += 1
    end

    return table.concat(parts, " "):lower()
end

local function autoPalletGuiVisible(obj)
    if not obj or not obj:IsA("GuiObject") then return false end

    local current = obj
    while current do
        if current:IsA("GuiObject") then
            local ok, visible = pcall(function() return current.Visible end)
            if ok and visible == false then return false end
        end
        if current:IsA("ScreenGui") then
            local ok, enabled = pcall(function() return current.Enabled end)
            if ok and enabled == false then return false end
        end
        if current == LocalPlayer:FindFirstChild("PlayerGui") then break end
        current = current.Parent
    end

    local okSize, size = pcall(function() return obj.AbsoluteSize end)
    if okSize and size and (size.X <= 4 or size.Y <= 4) then return false end

    return true
end

local function autoPalletButtonScore(button)
    if not button or not button:IsA("GuiObject") then return -999 end
    local hay = autoPalletGuiText(button)
    local score = 0

    if hay:find("pallet", 1, true) or hay:find("palletwrong", 1, true) then score += 16 end
    if hay:find("drop", 1, true) or hay:find("slam", 1, true)
        or hay:find("push", 1, true) or hay:find("fall", 1, true) then score += 9 end
    if hay:find("interact", 1, true) or hay:find("interaction", 1, true)
        or hay:find("use", 1, true) or hay:find("action", 1, true)
        or hay:find("gui%-mob", 1, false) or hay:find("guimob", 1, true) then score += 5 end

    if hay:find("attack", 1, true) or hay:find("parry", 1, true)
        or hay:find("dagger", 1, true) or hay:find("shoot", 1, true)
        or hay:find("spear", 1, true) or hay:find("run", 1, true)
        or hay:find("sprint", 1, true) or hay:find("jump", 1, true)
        or hay:find("crouch", 1, true) or hay:find("camera", 1, true)
        or hay:find("shift", 1, true) then
        score -= 14
    end

    if button:IsA("TextButton") or button:IsA("ImageButton") then score += 2 end

    return score
end

local function autoPalletFindGuiButton()
    local now = os.clock()
    if autoPalletGuiButtonCache and (now - autoPalletGuiButtonCacheAt) < AUTO_PALLET_GUI_CACHE_INTERVAL then
        if alive(autoPalletGuiButtonCache) and autoPalletGuiVisible(autoPalletGuiButtonCache) then
            return autoPalletGuiButtonCache
        end
    end

    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end

    local roots = {}
    local survivor = pg:FindFirstChild("Survivor-mob")
    if survivor then
        local controls = survivor:FindFirstChild("Controls")
        if controls then roots[#roots + 1] = controls end
        roots[#roots + 1] = survivor
    else
        roots[#roots + 1] = pg
    end

    local bestButton, bestScore = nil, -999
    for _, rootGui in ipairs(roots) do
        local scan = {}
        if rootGui:IsA("GuiObject") then scan[#scan + 1] = rootGui end
        pcall(function()
            for _, obj in ipairs(rootGui:GetDescendants()) do
                scan[#scan + 1] = obj
            end
        end)

        for _, obj in ipairs(scan) do
            if obj and (obj:IsA("TextButton") or obj:IsA("ImageButton")) and autoPalletGuiVisible(obj) then
                local score = autoPalletButtonScore(obj)
                if score > bestScore then
                    bestScore = score
                    bestButton = obj
                end
            end
        end

        if bestButton and bestScore >= 12 then break end
    end

    if bestButton and bestScore >= 6 then
        autoPalletGuiButtonCache = bestButton
        autoPalletGuiButtonCacheAt = now
        return bestButton
    end

    autoPalletGuiButtonCache = nil
    autoPalletGuiButtonCacheAt = now
    return nil
end

local function autoPalletClickGuiButton(button)
    if not button then return false end
    local fired = false

    pcall(function()
        if button:IsA("GuiButton") then
            button:Activate()
            fired = true
        end
    end)

    for _, ev in ipairs({"MouseButton1Down", "Activated", "MouseButton1Click", "MouseButton1Up"}) do
        local signal = nil
        pcall(function() signal = button[ev] end)
        if signal then
            if firesignal then
                local ok = pcall(function() firesignal(signal) end)
                fired = ok or fired
            end
            if getconnections then
                pcall(function()
                    for _, sig in pairs(getconnections(signal)) do
                        if sig then
                            if sig.Function then pcall(sig.Function) end
                            if sig.Fire then pcall(function() sig:Fire() end) end
                            fired = true
                        end
                    end
                end)
            end
        end
    end

    local center = nil
    pcall(function()
        local pos, size = button.AbsolutePosition, button.AbsoluteSize
        if size and size.X > 4 and size.Y > 4 then
            center = Vector2.new(pos.X + size.X * 0.5, pos.Y + size.Y * 0.5)
        end
    end)

    if center then
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            vim:SendMouseMoveEvent(center.X, center.Y, game)
            vim:SendMouseButtonEvent(center.X, center.Y, 0, true, game, 1)
            vim:SendMouseButtonEvent(center.X, center.Y, 0, false, game, 1)
            fired = true
        end)
        pcall(function()
            local vu = game:GetService("VirtualUser")
            local cam = workspace.CurrentCamera
            vu:Button1Down(center, cam and cam.CFrame or CFrame.new())
            vu:Button1Up(center, cam and cam.CFrame or CFrame.new())
            fired = true
        end)
    end

    return fired
end

local function tryAutoPalletGui()
    local fired = false

    pcall(function()
        if getgenv().pressSpecialButton then
            fired = getgenv().pressSpecialButton("pallet") or fired
            fired = getgenv().pressSpecialButton("Palletwrong") or fired
            fired = getgenv().pressSpecialButton("drop") or fired
            fired = getgenv().pressSpecialButton("interact") or fired
            fired = getgenv().pressSpecialButton("use") or fired
        end
    end)

    local button = autoPalletFindGuiButton()
    if button then
        fired = autoPalletClickGuiButton(button) or fired
    end

    return fired
end

local function tryAutoPalletTouch(pallet, root)
    if not firetouchinterest or not root or not alive(pallet) then return false end

    local fired = false
    local checked = 0
    for _, part in ipairs(autoPalletTargetParts(pallet)) do
        checked += 1
        if checked > 6 then break end

        local name = autoPalletNameLower(part)
        local likelyTrigger = name:find("hitbox", 1, true)
            or name:find("trigger", 1, true)
            or name:find("touch", 1, true)
            or name:find("prompt", 1, true)
            or name:find("interact", 1, true)
            or name:find("main", 1, true)
        if likelyTrigger or (part.Position - root.Position).Magnitude <= 6.5 then
            local ok = pcall(function()
                firetouchinterest(root, part, 0)
                task.wait(0.006)
                firetouchinterest(root, part, 1)
            end)
            fired = ok or fired
        end
    end

    return fired
end

local function tryAutoPalletRemote(pallet, part)
    local remotes = getAutoPalletRemotes(false)
    if #remotes == 0 then return false end

    local fired = false
    local payload = {
        Object = pallet,
        Target = pallet,
        Instance = pallet,
        Part = part,
        Action = "Drop",
        Type = "Pallet",
        Name = tostring(pallet and pallet.Name or "Pallet"),
    }

    local argSets = {
        {pallet},
        {part},
        {pallet, true},
        {"Drop", pallet},
        {"Interact", pallet},
        {payload},
    }

    if part then
        argSets[#argSets + 1] = {pallet, part.Position}
    end

    local maxRemoteTries = math.min(#remotes, 2)
    for i = 1, maxRemoteTries do
        local remote = remotes[i]
        for _, args in ipairs(argSets) do
            local ok = pcall(function()
                if remote:IsA("RemoteFunction") then
                    remote:InvokeServer(unpack(args))
                else
                    remote:FireServer(unpack(args))
                end
            end)
            fired = ok or fired
        end
    end

    return fired
end

local function autoPalletLooksDroppedNow(pallet, part)
    if not alive(pallet) then return true end
    if autoPalletLooksUsedByNameOrAttr(pallet) then return true end

    local checkPart = part or autoPalletBestPart(pallet)
    if checkPart then
        local upY = math.abs(checkPart.CFrame.UpVector.Y)
        local size = checkPart.Size
        local flatSize = math.max(size.X, size.Z)
        local tallSize = size.Y
        if upY < 0.38 and flatSize >= tallSize then
            return true
        end
    end

    return false
end

local function dropAutoPallet(pallet, part, root)
    if not alive(pallet) then return false end
    part = part or autoPalletBestPart(pallet, root and root.Position or nil)

    local fired = false
    for attempt = 1, 2 do
        fired = tryAutoPalletPrompt(pallet) or fired
        fired = tryAutoPalletGui() or fired

        if not fired or attempt == 2 then
            fired = tryAutoPalletClickDetector(pallet) or fired
            fired = tryAutoPalletTouch(pallet, root) or fired
        end

        -- Remote fallback adalah bagian paling berat, jadi hanya dipakai kalau cara normal belum menembak.
        if not fired then
            fired = tryAutoPalletRemote(pallet, part) or fired
        end

        if autoPalletLooksDroppedNow(pallet, part) then
            return true
        end

        if attempt < 2 then task.wait(0.025) end
    end

    return fired
end

function startAutoPallet()
    if autoPalletRunning then return end
    autoPalletRunning = true
    autoPalletLastAttempt = 0
    autoPalletPlayerLastPos = nil

    task.spawn(function()
        while autoPalletRunning and featureStates.AutoPallet do
            task.wait(0.08)

            local ok = pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not char or not root or not hum or hum.Health <= 0 then return end

                if char:GetAttribute("IsHooked") or char:GetAttribute("IsCarried")
                    or char:GetAttribute("Knocked") then
                    return
                end

                local nowClock = os.clock()
                local pallet, part = getBestAutoPallet(root)
                autoPalletPlayerLastPos = root.Position
                autoPalletPlayerLastPosAt = nowClock
                if not pallet or not part then return end

                local now = tick()
                if autoPalletDroppedCache[pallet] and now - autoPalletDroppedCache[pallet] < 1.8 then return end

                local sinceDrop = now - autoPalletLastDrop
                local sinceAttempt = now - autoPalletLastAttempt
                if sinceDrop < AUTO_PALLET_COOLDOWN then return end
                if sinceAttempt < AUTO_PALLET_RETRY_DELAY then return end

                autoPalletLastAttempt = now
                local fired = dropAutoPallet(pallet, part, root)

                if fired or autoPalletLooksDroppedNow(pallet, part) then
                    autoPalletLastDrop = now
                    -- Jangan kunci terlalu lama. Jika remote yang dicoba ternyata tidak cocok,
                    -- loop masih bisa mencoba lagi pada window pallet berikutnya.
                    autoPalletDroppedCache[pallet] = now
                    task.delay(0.35, function()
                        if alive(pallet) and not autoPalletLooksDroppedNow(pallet, part) then
                            autoPalletDroppedCache[pallet] = nil
                        end
                    end)
                end
            end)

            if not ok then
                task.wait(0.16)
            end
        end
    end)
end

function stopAutoPallet()
    autoPalletRunning = false
    autoPalletGuiButtonCache = nil
end


---------------------------------------------------
--== AUTO HEAL SYSTEM ==--
---------------------------------------------------
autoHealPerfectRunning = false
autoHealNeutralRunning = false

function startAutoHealPerfect()
    autoHealPerfectRunning = true
    
    local healRemote = nil
    pcall(function()
        healRemote = ReplicatedStorage:FindFirstChild("Remotes") and
                     ReplicatedStorage.Remotes:FindFirstChild("Healing") and
                     ReplicatedStorage.Remotes.Healing:FindFirstChild("SkillCheckResultEvent")
    end)
    
    task.spawn(function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local lastHealTarget = nil
        
        local function getHealth(plr)
            if not plr.Character then return 100 end
            local hum = plr.Character:FindFirstChild("Humanoid")
            return hum and hum.Health or 100
        end
        
        while autoHealPerfectRunning and featureStates.AutoHealPerfect do
            task.wait(0.15)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if root and hum then
                local closest = nil
                local closestDist = 8
                
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and getHealth(plr) <= 60 and getHealth(plr) > 0 then
                            local d = (root.Position - hrp.Position).Magnitude
                            if d < closestDist then
                                closest = plr
                                closestDist = d
                            end
                        end
                    end
                end
                
                if not lastHealTarget and closest then lastHealTarget = closest end
                if hum.MoveDirection.Magnitude > 0.05 then lastHealTarget = nil end
                
                local gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                if gui then
                    local check = gui:FindFirstChild("Check")
                    if check and check.Visible and lastHealTarget and healRemote then
                        if getHealth(lastHealTarget) <= 60 then
                            pcall(function() healRemote:FireServer("success", 1, lastHealTarget.Character) end)
                            check.Visible = false
                        end
                    end
                end
            end
        end
    end)
end

function startAutoHealNeutral()
    autoHealNeutralRunning = true
    
    local healRemote = nil
    pcall(function()
        healRemote = ReplicatedStorage:FindFirstChild("Remotes") and
                     ReplicatedStorage.Remotes:FindFirstChild("Healing") and
                     ReplicatedStorage.Remotes.Healing:FindFirstChild("SkillCheckResultEvent")
    end)
    
    task.spawn(function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local lastHealTarget = nil
        
        local function getHealth(plr)
            if not plr.Character then return 100 end
            local hum = plr.Character:FindFirstChild("Humanoid")
            return hum and hum.Health or 100
        end
        
        while autoHealNeutralRunning and featureStates.AutoHealNeutral do
            task.wait(0.15)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if root and hum then
                local closest = nil
                local closestDist = 8
                
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and getHealth(plr) <= 60 and getHealth(plr) > 0 then
                            local d = (root.Position - hrp.Position).Magnitude
                            if d < closestDist then
                                closest = plr
                                closestDist = d
                            end
                        end
                    end
                end
                
                if not lastHealTarget and closest then lastHealTarget = closest end
                if hum.MoveDirection.Magnitude > 0.05 then lastHealTarget = nil end
                
                local gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                if gui then
                    local check = gui:FindFirstChild("Check")
                    if check and check.Visible and lastHealTarget and healRemote then
                        if getHealth(lastHealTarget) <= 60 then
                            pcall(function() healRemote:FireServer("neutral", 0, lastHealTarget.Character) end)
                            check.Visible = false
                        end
                    end
                end
            end
        end
    end)
end

---------------------------------------------------
--== AUTO GENERATOR SYSTEM ==--
---------------------------------------------------
autoGeneratorPerfectRunning = false
autoGeneratorNeutralRunning = false

function getFolderGenerator()
    local generators = {}
    local map = Workspace:FindFirstChild("Map")
    if map then
        local function scanFolders(parent)
            for _, child in ipairs(parent:GetChildren()) do
                if child.Name == "Generator" and child:IsA("Model") then
                    table.insert(generators, child)
                elseif child:IsA("Model") then
                    scanFolders(child)
                end
            end
        end
        scanFolders(map)
    end
    if #generators == 0 then
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            if descendant.Name == "Generator" and descendant:IsA("Model") then
                table.insert(generators, descendant)
            end
        end
    end
    return generators
end

function startAutoGeneratorPerfect()
    autoGeneratorPerfectRunning = true
    
    local skillRemote = nil
    local repairRemote = nil
    pcall(function()
        local gen = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Generator")
        if gen then
            skillRemote = gen:FindFirstChild("SkillCheckResultEvent")
            repairRemote = gen:FindFirstChild("RepairEvent")
        end
    end)
    
    task.spawn(function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local lastGenPoint = nil
        local lastGenModel = nil
        
        while autoGeneratorPerfectRunning and featureStates.AutoGeneratorPerfect do
            task.wait(0.15)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if root and hum then
                local generators = getFolderGenerator()
                local closestGen, closestPoint, closestDist = nil, nil, 10
                
                for _, gen in ipairs(generators) do
                    for i = 1, 4 do
                        local point = gen:FindFirstChild("GeneratorPoint" .. i)
                        if point and point:IsA("BasePart") then
                            local d = (root.Position - point.Position).Magnitude
                            if d < closestDist then
                                closestDist = d
                                closestGen = gen
                                closestPoint = point
                            end
                        end
                    end
                end
                
                if not lastGenPoint and closestPoint and closestDist < 6 then
                    lastGenModel = closestGen
                    lastGenPoint = closestPoint
                end
                
                if hum.MoveDirection.Magnitude > 0.05 then
                    if lastGenPoint and repairRemote then
                        pcall(function() repairRemote:FireServer(lastGenPoint, false) end)
                        task.wait(0.2)
                        lastGenPoint = nil
                        lastGenModel = nil
                    end
                end
                
                local gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                if gui then
                    local check = gui:FindFirstChild("Check")
                    if check and check.Visible and lastGenPoint and skillRemote then
                        local stillClose = false
                        if lastGenPoint and root then
                            local d = (root.Position - lastGenPoint.Position).Magnitude
                            if d < 6 then stillClose = true end
                        end
                        if stillClose and lastGenModel and lastGenPoint then
                            pcall(function() skillRemote:FireServer("success", 1, lastGenModel, lastGenPoint) end)
                            check.Visible = false
                        end
                    end
                end
            end
        end
    end)
end

function startAutoGeneratorNeutral()
    autoGeneratorNeutralRunning = true
    
    local skillRemote = nil
    local repairRemote = nil
    pcall(function()
        local gen = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Generator")
        if gen then
            skillRemote = gen:FindFirstChild("SkillCheckResultEvent")
            repairRemote = gen:FindFirstChild("RepairEvent")
        end
    end)
    
    task.spawn(function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local lastGenPoint = nil
        local lastGenModel = nil
        
        while autoGeneratorNeutralRunning and featureStates.AutoGeneratorNeutral do
            task.wait(0.15)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if root and hum then
                local generators = getFolderGenerator()
                local closestGen, closestPoint, closestDist = nil, nil, 10
                
                for _, gen in ipairs(generators) do
                    for i = 1, 4 do
                        local point = gen:FindFirstChild("GeneratorPoint" .. i)
                        if point and point:IsA("BasePart") then
                            local d = (root.Position - point.Position).Magnitude
                            if d < closestDist then
                                closestDist = d
                                closestGen = gen
                                closestPoint = point
                            end
                        end
                    end
                end
                
                if not lastGenPoint and closestPoint and closestDist < 6 then
                    lastGenModel = closestGen
                    lastGenPoint = closestPoint
                end
                
                if hum.MoveDirection.Magnitude > 0.05 then
                    if lastGenPoint and repairRemote then
                        pcall(function() repairRemote:FireServer(lastGenPoint, false) end)
                        task.wait(0.2)
                        lastGenPoint = nil
                        lastGenModel = nil
                    end
                end
                
                local gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                if gui then
                    local check = gui:FindFirstChild("Check")
                    if check and check.Visible and lastGenPoint and skillRemote then
                        local stillClose = false
                        if lastGenPoint and root then
                            local d = (root.Position - lastGenPoint.Position).Magnitude
                            if d < 6 then stillClose = true end
                        end
                        if stillClose and lastGenModel and lastGenPoint then
                            pcall(function() skillRemote:FireServer("neutral", 0, lastGenModel, lastGenPoint) end)
                            check.Visible = false
                        end
                    end
                end
            end
        end
    end)
end

---------------------------------------------------
--== AUTO PARRY SYSTEM (REBUILT dari vd2) ==--
---------------------------------------------------

-- Tabel ID animasi serangan killer (sama persis dengan vd2)
lungeanims = {
    [110355011987939] = true,
    [105374834496520] = true,
    [122812055447896] = true,
    [118907603246885] = true,
    [113255068724446] = true,
    [129784271201071] = true,
    [117042998468241] = true,
    [106871536134254] = true,
}
attackanims = {
    [139369275981139] = true,
    [111920872708571] = true,
    [78935059863801]  = true,
    [78432063483146]  = true,
    [74968262036854]  = true,
    [132817836308238] = true,
    [133963973694098] = true,
    [98163597193511]  = true,
    [106871536134254] = true,
    [82666958311998]  = true,
    -- The Hidden & killer lain
    [136204815989431] = true,
    [118500783397811] = true,
    [141302044152761] = true,
    [121764388471903] = true,
    [135916778054213] = true,
    [118640823082741] = true,
    [127382913091842] = true,
}
-- Keyword nama animasi serangan (fallback, mencakup The Hidden + The Cure)
PARRY_ATTACK_KW = {
    "slash","attack","lunge","swing","stab","knife","throw",
    "smash","grab","strike","kill","chain","claw","special",
    "ability","skill","charge","pounce","leap","dash","hidden",
    "vanish","appear","emerge","ambush","burst","punch","kick",
    -- The Hidden / killer dash lurus berkecepatan tinggi
    "thrust","pierce","piercing","impale","spear","rush","brutal",
    -- The Cure / killer baru: banyak animasi memakai istilah medis/infeksi, bukan "attack".
    "cure","the cure","thecure","needle","syringe","inject","injection",
    "serum","vial","virus","infect","infection","poison","toxin",
    "mutate","mutation","plague","contagion","dose","jab",
}
-- Keyword animasi NON-serangan yang harus di-skip (perhatikan: "hit" dihapus supaya tidak memblokir "hit_kill" dll)
PARRY_SKIP_KW = {
    "walk","idle","run","equip","stun","death","spawn","stand",
    "hit_react","hit_stun","hitstun","getup","ragdoll","climb",
}

-- Nama/marker khusus The Cure. Dibuat terpisah agar killer baru tetap terbaca walau tidak punya marker lama.
PARRY_THE_CURE_MODEL_KW = {
    "the cure", "thecure", "cure", "cured", "doctor", "medic", "plague",
    "infection", "infected", "syringe", "needle", "serum", "vial",
}
PARRY_THE_CURE_ATTACK_KW = {
    "cure", "the cure", "thecure", "needle", "syringe", "inject", "injection",
    "jab", "dose", "serum", "vial", "virus", "infect", "infection", "toxin",
    "poison", "plague", "contagion", "mutate", "mutation", "slash", "stab",
    "m1", "m2", "basic", "combo", "ability", "skill", "special",
}

-- Deteksi tambahan untuk tusukan lurus The Hidden / dash brutal yang sering tidak membawa animasi standar.
-- Fokusnya bukan spam parry, tapi membaca momentum: arah gerak, closing speed, lateral miss, dan time-to-impact.
PARRY_FAST_STAB_MIN_SPEED = 34
PARRY_FAST_STAB_MIN_CLOSING = 24
PARRY_FAST_STAB_BASE_LEAD = 0.14
PARRY_FAST_STAB_MAX_EXTRA_RANGE = 28

local function safeVectorUnit(v)
    if typeof(v) ~= "Vector3" or v.Magnitude <= 0.001 then
        return Vector3.new(0, 0, 0)
    end
    return v.Unit
end

local function getPartLinearVelocity(part)
    if not part then return Vector3.new(0, 0, 0) end
    local ok, value = pcall(function()
        return part.AssemblyLinearVelocity
    end)
    if ok and typeof(value) == "Vector3" then return value end
    ok, value = pcall(function()
        return part.Velocity
    end)
    if ok and typeof(value) == "Vector3" then return value end
    return Vector3.new(0, 0, 0)
end

local function getAimDot(part, toTargetDir)
    if not part or typeof(toTargetDir) ~= "Vector3" then return 0 end
    local look = Vector3.new(0, 0, 0)
    pcall(function() look = part.CFrame.LookVector end)
    if look.Magnitude <= 0.001 then return 0 end
    return look.Unit:Dot(toTargetDir)
end

local function compactParryText(text)
    return tostring(text or ""):lower():gsub("[^%w]+", "")
end

local function parryTextHasKeyword(text, keywords)
    local hay = tostring(text or ""):lower()
    local compactHay = compactParryText(hay)
    for _, kw in ipairs(keywords or {}) do
        local rawKw = tostring(kw or ""):lower()
        local compactKw = compactParryText(rawKw)
        if rawKw ~= "" and hay:find(rawKw, 1, true) then
            return true
        end
        if compactKw ~= "" and compactHay:find(compactKw, 1, true) then
            return true
        end
    end
    return false
end

local function appendParryAttributeText(parts, inst)
    if not inst then return end
    local ok, attrs = pcall(function()
        return inst:GetAttributes()
    end)
    if ok and type(attrs) == "table" then
        for k, v in pairs(attrs) do
            local tv = type(v)
            if tv == "string" or tv == "number" or tv == "boolean" then
                parts[#parts + 1] = tostring(k)
                parts[#parts + 1] = tostring(v)
            end
        end
    end
end

local function getKillerIdentityText(model)
    local parts = {}
    if not model then return "" end

    parts[#parts + 1] = tostring(model.Name or "")
    appendParryAttributeText(parts, model)

    local hum = model:FindFirstChildOfClass("Humanoid")
    if hum then
        parts[#parts + 1] = tostring(hum.Name or "")
        pcall(function() parts[#parts + 1] = tostring(hum.DisplayName or "") end)
    end

    -- Cukup cek child level atas supaya ringan di Heartbeat, tapi tetap menangkap Weapon/Config The Cure.
    for _, child in ipairs(model:GetChildren()) do
        parts[#parts + 1] = tostring(child.Name or "")
        appendParryAttributeText(parts, child)
    end

    return table.concat(parts, " "):lower()
end

local function isTheCureModel(model)
    if not model then return false end
    return parryTextHasKeyword(getKillerIdentityText(model), PARRY_THE_CURE_MODEL_KW)
end

local function isActionPriorityTrack(track)
    local ok, value = pcall(function()
        return track.Priority.Value
    end)
    if ok and tonumber(value) then
        return tonumber(value) >= Enum.AnimationPriority.Action.Value
    end
    return false
end

local function getTrackTimePosition(track)
    local ok, value = pcall(function()
        return track.TimePosition
    end)
    if ok and tonumber(value) then return tonumber(value) end
    return 0
end

local function getTrackLength(track)
    local ok, value = pcall(function()
        return track.Length
    end)
    if ok and tonumber(value) then return tonumber(value) end
    return 0
end

local function detectFastStraightStab(killerRoot, survivorRoot, ping, touchEnabled)
    if not killerRoot or not survivorRoot then return false, nil end

    local offset = survivorRoot.Position - killerRoot.Position
    local distance = offset.Magnitude
    if distance <= 0.001 then
        return true, { reason = "overlap", distance = distance, timeToImpact = 0, closingSpeed = 999 }
    end

    local velocity = getPartLinearVelocity(killerRoot)
    local speed = velocity.Magnitude
    local toPlayerDir = safeVectorUnit(offset)
    local velocityDir = safeVectorUnit(velocity)
    local closingSpeed = velocity:Dot(toPlayerDir)
    local facingDot = getAimDot(killerRoot, toPlayerDir)

    -- The Hidden kadang menggeser CFrame/RootPart sangat cepat sehingga animasinya belum masuk GetPlayingAnimationTracks().
    -- Syaratnya tetap ketat: harus cepat, menuju survivor, dan jalurnya hampir lurus.
    if speed < PARRY_FAST_STAB_MIN_SPEED and closingSpeed < PARRY_FAST_STAB_MIN_CLOSING then
        return false, nil
    end
    if closingSpeed < PARRY_FAST_STAB_MIN_CLOSING and facingDot < 0.72 then
        return false, nil
    end

    local projectedDistance = offset:Dot(velocityDir)
    local lateralDistance = (offset - (velocityDir * projectedDistance)).Magnitude
    local directness = velocityDir:Dot(toPlayerDir)

    -- Kalau root sedang dash tapi velocity belum sinkron, arah hadap killer boleh menjadi fallback.
    if directness < 0.58 and facingDot >= 0.78 and closingSpeed >= (PARRY_FAST_STAB_MIN_CLOSING * 0.85) then
        directness = facingDot
        lateralDistance = math.min(lateralDistance, distance * math.max(0, 1 - facingDot))
    end

    local leadWindow = math.clamp((tonumber(ping) or 0.05) + PARRY_FAST_STAB_BASE_LEAD, 0.14, 0.34)
    if touchEnabled then leadWindow = leadWindow + 0.06 end
    if speed >= 85 or closingSpeed >= 70 then leadWindow = leadWindow + 0.05 end
    if speed >= 125 or closingSpeed >= 105 then leadWindow = leadWindow + 0.04 end

    local timeToImpact = distance / math.max(closingSpeed, 1)
    local lateralLimit = math.clamp(3.8 + (speed * 0.045), 5.2, 10.5)
    local predictiveRange = (tonumber(ParryDistance) or 20) + math.clamp(closingSpeed * leadWindow, 6, PARRY_FAST_STAB_MAX_EXTRA_RANGE)

    local aligned = directness >= 0.62 or facingDot >= 0.78
    local onLine = lateralDistance <= lateralLimit
    local closeEnough = distance <= predictiveRange
    local impactSoon = timeToImpact <= leadWindow + 0.055

    if aligned and onLine and closeEnough and impactSoon then
        return true, {
            reason = "fast_straight_stab",
            distance = distance,
            speed = speed,
            closingSpeed = closingSpeed,
            directness = directness,
            facingDot = facingDot,
            lateralDistance = lateralDistance,
            lateralLimit = lateralLimit,
            leadWindow = leadWindow,
            timeToImpact = timeToImpact,
            predictiveRange = predictiveRange,
        }
    end

    return false, {
        reason = "not_ready",
        distance = distance,
        speed = speed,
        closingSpeed = closingSpeed,
        directness = directness,
        facingDot = facingDot,
        lateralDistance = lateralDistance,
        lateralLimit = lateralLimit,
        leadWindow = leadWindow,
        timeToImpact = timeToImpact,
        predictiveRange = predictiveRange,
    }
end

local function getParryMomentumReady(distance, closingSpeed, ping, killerFacingDot, highSpeedApproach, touchEnabled)
    distance = tonumber(distance) or 999
    closingSpeed = tonumber(closingSpeed) or 0
    killerFacingDot = tonumber(killerFacingDot) or 0
    ping = tonumber(ping) or 0.05

    -- Lead window dibuat ketat supaya parry tidak keluar terlalu awal.
    -- PC diberi sedikit lead karena input/GUI parry biasanya masuk 1-2 frame lebih lambat.
    local leadWindow = ping + (touchEnabled and 0.115 or ((PARRY_PC_INPUT_LEAD or 0.065) + 0.055))
    if highSpeedApproach then leadWindow = leadWindow + 0.06 end
    leadWindow = math.clamp(leadWindow, 0.14, highSpeedApproach and 0.36 or 0.28)

    local timeToImpact = math.huge
    if closingSpeed > 1 then
        timeToImpact = distance / closingSpeed
    end

    local baseRange = tonumber(ParryDistance) or 20
    local closeCommitRange = math.max(7.5, baseRange - (highSpeedApproach and 0.75 or 3.0))
    local facingCommitRange = math.max(8.5, baseRange - 1.25)

    local impactSoon = closingSpeed > 1 and timeToImpact <= (leadWindow + 0.045)
    local closeCommit = distance <= closeCommitRange
    local closeFacingCommit = distance <= facingCommitRange and killerFacingDot >= 0.58

    return (impactSoon or closeCommit or closeFacingCommit), {
        leadWindow = leadWindow,
        timeToImpact = timeToImpact,
        closeCommit = closeCommit,
        closeFacingCommit = closeFacingCommit,
        impactSoon = impactSoon,
    }
end

local function doSmartFacePulse(char, hum, root, killerRoot)
    if not (SmartFace and featureStates.AutoParry and root and killerRoot and char and hum) then return end
    if char:GetAttribute("IsCarried") or char:GetAttribute("IsHooked") or char:GetAttribute("Knocked") then return end

    getgenv().ArexansSmartFaceActiveUntil = tick() + (PARRY_SMARTFACE_WINDOW_SECONDS or 0.10)

    local oldAutoRotate
    pcall(function() oldAutoRotate = hum.AutoRotate end)

    local lookPos = Vector3.new(killerRoot.Position.X, root.Position.Y, killerRoot.Position.Z)
    if (lookPos - root.Position).Magnitude > 0.1 then
        pcall(function()
            -- Satu kali snap tepat sebelum input parry; tidak ada loop yang terus menarik badan ke killer.
            root.CFrame = CFrame.lookAt(root.Position, lookPos)
        end)
    end

    task.delay((PARRY_SMARTFACE_WINDOW_SECONDS or 0.10) + 0.02, function()
        if tick() >= (getgenv().ArexansSmartFaceActiveUntil or 0) then
            getgenv().ArexansSmartFaceActiveUntil = 0
            if hum and hum.Parent and oldAutoRotate ~= nil then
                -- Restore hanya jika fitur rotasi lain tidak sedang aktif.
                local movementOwnsRotation = featureStates and (featureStates.MoonWalk == true or (featureStates.Ziggle == true and featureStates.ZiggleAutoFaceKiller == true))
                if not movementOwnsRotation then
                    pcall(function() hum.AutoRotate = oldAutoRotate end)
                end
            end
        end
    end)
end

function spawnAutoParrySlashEffect(root, killerRoot)
    if getgenv().ArexansAutoParrySlashFX == false then return end
    if not root or not root.Parent then return end

    pcall(function()
        local TweenService = game:GetService("TweenService")
        local Debris = game:GetService("Debris")

        local dir
        if killerRoot and killerRoot.Parent then
            local flat = Vector3.new(killerRoot.Position.X - root.Position.X, 0, killerRoot.Position.Z - root.Position.Z)
            dir = safeVectorUnit(flat)
        end
        if not dir or dir.Magnitude <= 0.001 then
            dir = root.CFrame.LookVector
        end
        dir = Vector3.new(dir.X, 0, dir.Z)
        if dir.Magnitude <= 0.001 then dir = Vector3.new(0, 0, -1) end
        dir = dir.Unit

        local center = root.Position + dir * 3.15 + Vector3.new(0, 1.45, 0)
        local baseCF = CFrame.lookAt(center, center + dir)

        local folder = Workspace:FindFirstChild("ArexansParryEffects")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "ArexansParryEffects"
            folder.Parent = Workspace
        end

        for i = -2, 2 do
            local slash = Instance.new("Part")
            slash.Name = "AutoParrySlash"
            slash.Anchored = true
            slash.CanCollide = false
            slash.CanQuery = false
            slash.CanTouch = false
            slash.Material = Enum.Material.Neon
            slash.Color = (i % 2 == 0) and Color3.fromRGB(0, 225, 255) or Color3.fromRGB(255, 255, 255)
            slash.Transparency = 0.18 + (math.abs(i) * 0.08)
            slash.Size = Vector3.new(3.1 - (math.abs(i) * 0.28), 0.065, 0.065)
            slash.CFrame = baseCF * CFrame.new(0, i * 0.18, -math.abs(i) * 0.06) * CFrame.Angles(0, 0, math.rad(18 + (i * 9)))
            slash.Parent = folder

            TweenService:Create(
                slash,
                TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Transparency = 1,
                    Size = Vector3.new(slash.Size.X + 1.2, 0.025, 0.025),
                    CFrame = slash.CFrame * CFrame.new(0, 0, -0.55)
                }
            ):Play()

            Debris:AddItem(slash, 0.22)
        end
    end)
end

-- State global parry (ikuti pola vd2 agar tidak conflict)
getgenv().ParryDebounce     = getgenv().ParryDebounce or false
getgenv().NextAllowedParry  = getgenv().NextAllowedParry or 0
getgenv().LastParryTime     = getgenv().LastParryTime or 0
getgenv().ArexansAutoParryUsingNow = false

SmartFace      = false
ParryDistance  = 20
getgenv().ParryVisualsEnabled = false
ParryVisual    = nil
ParryVisualSegments = ParryVisualSegments or {}
ParryVisualRenderConn = nil
ParryVisualSegmentCount = 32
ParryDelay     = 0   -- bisa diubah dari UI jika diperlukan
PARRY_COOLDOWN_SECONDS = 1.35
-- PC memakai jalur input mouse/Tool yang kadang masuk 1-2 frame lebih lambat dari tombol mobile.
-- Bonus kecil ini hanya untuk kompensasi input, bukan memperbesar spam parry.
PARRY_PC_INPUT_LEAD = 0.065
-- Smart Face hanya boleh aktif di momen Auto Parry benar-benar mengeksekusi.
-- Nilai window pendek ini mencegah karakter terus dipaksa menghadap killer setelah parry selesai.
PARRY_SMARTFACE_WINDOW_SECONDS = 0.10
PARRY_INPUT_LOCK_SECONDS = 0.24

if getgenv().ArexansSmartFaceOnlyDuringParry == nil then
    getgenv().ArexansSmartFaceOnlyDuringParry = true
end
if getgenv().ArexansParryMomentumMode == nil then
    getgenv().ArexansParryMomentumMode = true
end
getgenv().ArexansSmartFaceActiveUntil = 0
getgenv().ArexansAutoParryActionLockUntil = 0

-- =========================================================
-- ANTI-LAG DEFAULTS
-- =========================================================
-- Auto Parry tetap responsif, tapi tidak lagi scan berat setiap frame.
getgenv().ArexansAutoParryScanInterval = tonumber(getgenv().ArexansAutoParryScanInterval) or (1 / 45)
-- Cache killer agar workspace:GetChildren() + scan player tidak jalan setiap Heartbeat.
getgenv().ArexansKillerCacheInterval = tonumber(getgenv().ArexansKillerCacheInterval) or 0.18
-- Visual radius dibuat halus mengikuti kamera/karakter.
-- Versi lama 0.05 (20 FPS) terlihat seperti patah-patah/ketarik ke belakang saat bergerak.
do
    local currentVisualInterval = tonumber(getgenv().ArexansParryVisualUpdateInterval)
    if currentVisualInterval == nil or currentVisualInterval >= 0.045 then
        getgenv().ArexansParryVisualUpdateInterval = 1 / 60
    else
        getgenv().ArexansParryVisualUpdateInterval = math.max(0, currentVisualInterval)
    end
end
-- Default baru: jangan potong garis radius di area badan karakter.
-- Kalau ingin mode lama yang membuat gap di avatar: getgenv().ArexansParryVisualCharacterCutout = true
if getgenv().ArexansParryVisualCharacterCutout == nil then
    getgenv().ArexansParryVisualCharacterCutout = false
end
-- Rotasi fitur Ziggle/MoonWalk dibuat aman agar tidak spam CFrame setiap RenderStepped.
if getgenv().ArexansSafeMovementRotation == nil then
    getgenv().ArexansSafeMovementRotation = true
end
if getgenv().ArexansMovementRotationInterval == nil then
    getgenv().ArexansMovementRotationInterval = 1 / 30
end
if getgenv().ArexansMovementRotationLerp == nil then
    getgenv().ArexansMovementRotationLerp = 0.32
end
-- Efek slash lokal dimatikan default karena hanya kosmetik dan bisa bikin spike saat parry.
if getgenv().ArexansAutoParrySlashFX == nil then
    getgenv().ArexansAutoParrySlashFX = false
end

-- Anti-lag khusus dash/tusukan cepat: jalur ini memotong scan animasi/raycast berat
-- saat killer bergerak sangat cepat, dan menahan script agar tidak memaksa WalkSpeed/Crouch.
if getgenv().ArexansDashAntiLag == nil then
    getgenv().ArexansDashAntiLag = true
end
-- PC sebelumnya dibuat "light stance" untuk anti-lag, tetapi efek sampingnya animasi
-- jongkok/kuda-kuda tidak muncul. Default baru: stance visual tetap aktif,
-- namun tidak lagi memaksa WalkSpeed = 0 agar tidak menimbulkan rubberband.
if getgenv().ArexansParryLightStance == nil then
    getgenv().ArexansParryLightStance = false
end
if getgenv().ArexansParryFreezeOnStance == nil then
    getgenv().ArexansParryFreezeOnStance = false
end
if getgenv().ArexansParryStanceHoldTime == nil then
    -- PC diberi hold sedikit lebih lama supaya pose kuda-kuda sempat terlihat.
    getgenv().ArexansParryStanceHoldTime = UserInputService.TouchEnabled and 0.32 or 0.55
end
-- Overlay cooldown tambahan hanya diperlukan di PC, karena PC kadang tidak
-- memicu cooldown bar bawaan. Di mobile, tombol parry sudah punya bar asli,
-- jadi overlay buatan dimatikan agar tidak muncul bar tambahan dekat tombol parry.
if UserInputService.TouchEnabled then
    getgenv().ArexansParryCooldownOverlay = false
elseif getgenv().ArexansParryCooldownOverlay == nil then
    getgenv().ArexansParryCooldownOverlay = true
end
if getgenv().ArexansPCParryKeyFallback == nil then
    getgenv().ArexansPCParryKeyFallback = true
end
if getgenv().ArexansPCParryKeys == nil then
    -- Banyak layout PC memakai F untuk block/parry. Jika game kamu beda, ubah dari luar:
    -- getgenv().ArexansPCParryKeys = {"E"} atau {Enum.KeyCode.E}
    getgenv().ArexansPCParryKeys = {Enum.KeyCode.F}
end
if getgenv().ArexansPCParryRemoteFallback == nil then
    -- true = parry tetap aman bila input lokal gagal.
    -- false = paksa jalur lokal PC saja agar animasi/cooldown bawaan lebih murni.
    getgenv().ArexansPCParryRemoteFallback = true
end
getgenv().ArexansNormalAnimationScanInterval = tonumber(getgenv().ArexansNormalAnimationScanInterval) or 0.055
getgenv().ArexansDashAnimationScanInterval   = tonumber(getgenv().ArexansDashAnimationScanInterval) or 0.12
getgenv().ArexansNormalRaycastInterval       = tonumber(getgenv().ArexansNormalRaycastInterval) or 0.075
getgenv().ArexansDashRaycastInterval         = tonumber(getgenv().ArexansDashRaycastInterval) or 0.14

local ArexansParryAnimCache = setmetatable({}, { __mode = "k" })
local ArexansParryRayCache  = setmetatable({}, { __mode = "k" })

getgenv().ArexansParryCooldownToken = getgenv().ArexansParryCooldownToken or 0
getgenv().ArexansForcedParryCooldownToken = getgenv().ArexansForcedParryCooldownToken or 0
getgenv().ArexansParryVisualCooldownUntil = getgenv().ArexansParryVisualCooldownUntil or 0
getgenv().ArexansParryVisualCooldownToken = getgenv().ArexansParryVisualCooldownToken or 0

function markParryVisualCooldown(duration)
    duration = tonumber(duration) or PARRY_COOLDOWN_SECONDS

    local cooldownUntil = tick() + duration
    getgenv().ArexansParryVisualCooldownUntil = math.max(
        tonumber(getgenv().ArexansParryVisualCooldownUntil) or 0,
        cooldownUntil
    )

    local token = (getgenv().ArexansParryVisualCooldownToken or 0) + 1
    getgenv().ArexansParryVisualCooldownToken = token

    -- Paksa visual langsung putih polos tepat setelah parry digunakan.
    pcall(function()
        if updateParryVisual then updateParryVisual() end
    end)

    task.delay(duration, function()
        if getgenv().ArexansParryVisualCooldownToken ~= token then return end

        local remaining = (tonumber(getgenv().ArexansParryVisualCooldownUntil) or 0) - tick()
        if remaining > 0.03 then
            task.delay(remaining, function()
                if getgenv().ArexansParryVisualCooldownToken ~= token then return end
                getgenv().ArexansParryVisualCooldownUntil = 0
                pcall(function()
                    if updateParryVisual then updateParryVisual() end
                end)
            end)
            return
        end

        getgenv().ArexansParryVisualCooldownUntil = 0

        -- Setelah cooldown selesai, visual baru balik biru/gradient kalau dagger benar-benar ready.
        pcall(function()
            if updateParryVisual then updateParryVisual() end
        end)
    end)
end

-- VirtualInputManager untuk backup input (sama dengan vd2)
VIM = pcall(function() return game:GetService("VirtualInputManager") end) and game:GetService("VirtualInputManager") or nil

local function getParryToolTextureIdForGui()
    local texture = ""
    pcall(function()
        local char = LocalPlayer.Character
        local tool = (char and char:FindFirstChild("Parrying Dagger"))
            or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Parrying Dagger"))
        if tool and tool:IsA("Tool") then
            texture = tostring(tool.TextureId or tool.TextureID or ""):lower()
        end
    end)
    return texture
end

local function getGuiSearchText(obj)
    if not obj then return "" end

    local parts = { tostring(obj.Name or "") }

    pcall(function()
        if obj:IsA("TextButton") or obj:IsA("TextLabel") or obj:IsA("TextBox") then
            parts[#parts + 1] = tostring(obj.Text or "")
        end
    end)

    pcall(function()
        if obj:IsA("ImageButton") or obj:IsA("ImageLabel") then
            parts[#parts + 1] = tostring(obj.Image or "")
            parts[#parts + 1] = tostring(obj.HoverImage or "")
            parts[#parts + 1] = tostring(obj.PressedImage or "")
        end
    end)

    pcall(function()
        if obj:IsA("GuiButton") then
            parts[#parts + 1] = tostring(obj.ToolTip or "")
        end
    end)

    pcall(function()
        for key, value in pairs(obj:GetAttributes()) do
            parts[#parts + 1] = tostring(key)
            parts[#parts + 1] = tostring(value)
        end
    end)

    -- PC sering menaruh nama item di parent slot, bukan langsung di ImageButton.
    local parent = obj.Parent
    local depth = 0
    while parent and depth < 3 do
        parts[#parts + 1] = tostring(parent.Name or "")
        pcall(function()
            if parent:IsA("TextButton") or parent:IsA("TextLabel") or parent:IsA("TextBox") then
                parts[#parts + 1] = tostring(parent.Text or "")
            end
        end)
        parent = parent.Parent
        depth += 1
    end

    -- Ambil nama child ringan saja. Ini membantu slot PC yang memakai Frame generik
    -- dengan TextLabel kecil berisi nama item.
    pcall(function()
        local count = 0
        for _, child in ipairs(obj:GetDescendants()) do
            count += 1
            if count > 25 then break end
            parts[#parts + 1] = tostring(child.Name or "")
            if child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("TextBox") then
                parts[#parts + 1] = tostring(child.Text or "")
            end
        end
    end)

    return table.concat(parts, " "):lower()
end

local function scoreParryGuiObject(obj, requested)
    if not obj or not obj:IsA("GuiObject") then return -1 end

    local hay = getGuiSearchText(obj)
    local score = 0
    requested = requested and tostring(requested):lower() or ""

    if requested ~= "" and hay:find(requested, 1, true) then score = score + 7 end
    if hay:find("parry", 1, true) then score = score + 10 end
    if hay:find("dagger", 1, true) then score = score + 8 end
    if hay:find("gui-mob", 1, true) or hay:find("guimob", 1, true) then score = score + 5 end
    if hay:find("block", 1, true) or hay:find("counter", 1, true) then score = score + 2 end

    local texture = getParryToolTextureIdForGui and getParryToolTextureIdForGui() or ""
    if texture ~= "" then
        pcall(function()
            if obj:IsA("ImageButton") or obj:IsA("ImageLabel") then
                local imageText = tostring(obj.Image or ""):lower()
                if imageText ~= "" and imageText == texture then
                    -- PC hotbar kadang tidak bernama "parry", tetapi ikon slot sama
                    -- dengan TextureId tool Parrying Dagger.
                    score = score + 16
                end
            end
        end)
    end

    -- Bonus button hanya boleh berlaku jika nama/text-nya memang cocok, supaya tidak salah klik tombol lain.
    if score > 0 and (obj:IsA("TextButton") or obj:IsA("ImageButton")) then score = score + 2 end

    return score
end

local function isGuiObjectVisibleInHierarchy(obj)
    if not obj or not obj:IsA("GuiObject") then return false end

    local current = obj
    while current do
        if current:IsA("GuiObject") then
            local ok, visible = pcall(function() return current.Visible end)
            if ok and visible == false then return false end
        end

        if current:IsA("ScreenGui") then
            local ok, enabled = pcall(function() return current.Enabled end)
            if ok and enabled == false then return false end
        end

        if current == LocalPlayer:FindFirstChild("PlayerGui") then break end
        current = current.Parent
    end

    local okSize, size = pcall(function() return obj.AbsoluteSize end)
    if okSize and size and (size.X <= 2 or size.Y <= 2) then return false end

    return true
end

function findParryGuiButton(requested)
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end

    local roots = {}
    local survivor = pg:FindFirstChild("Survivor-mob")
    if survivor then
        local controls = survivor:FindFirstChild("Controls")
        if controls then roots[#roots + 1] = controls end
        roots[#roots + 1] = survivor
    end
    roots[#roots + 1] = pg

    local bestButton, bestScore = nil, -1
    for _, rootGui in ipairs(roots) do
        local scan = {}
        if rootGui:IsA("GuiObject") then scan[#scan + 1] = rootGui end
        for _, obj in ipairs(rootGui:GetDescendants()) do
            scan[#scan + 1] = obj
        end

        for _, obj in ipairs(scan) do
            if obj and (obj:IsA("TextButton") or obj:IsA("ImageButton"))
                and isGuiObjectVisibleInHierarchy(obj) then
                local score = scoreParryGuiObject(obj, requested)
                if score > bestScore then
                    bestScore = score
                    bestButton = obj
                end
            end
        end

        if bestButton and bestScore >= 10 then
            break
        end
    end

    if bestScore > 1 then return bestButton end
    return nil
end

function findParryGuiContainer(requested)
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end

    local roots = {}
    local survivor = pg:FindFirstChild("Survivor-mob")
    if survivor then
        local controls = survivor:FindFirstChild("Controls")
        if controls then roots[#roots + 1] = controls end
        roots[#roots + 1] = survivor
    end
    roots[#roots + 1] = pg

    local bestObj, bestScore = nil, -1
    for _, rootGui in ipairs(roots) do
        local scan = {}
        if rootGui:IsA("GuiObject") then scan[#scan + 1] = rootGui end
        for _, obj in ipairs(rootGui:GetDescendants()) do
            if obj:IsA("GuiObject") then
                scan[#scan + 1] = obj
            end
        end

        for _, obj in ipairs(scan) do
            if isGuiObjectVisibleInHierarchy(obj) then
                local score = scoreParryGuiObject(obj, requested)
                if score > bestScore then
                    bestScore = score
                    bestObj = obj
                end
            end
        end

        if bestObj and bestScore >= 12 then
            break
        end
    end

    if bestScore > 1 then return bestObj end
    return nil
end

function pressSpecialButton(args)
    local button = findParryGuiButton(args)
    if not button then return false end

    local fired = false
    for _, ev in ipairs({"MouseButton1Down", "Activated", "MouseButton1Click", "MouseButton1Up"}) do
        local signal
        pcall(function() signal = button[ev] end)
        if signal then
            if firesignal then
                local ok = pcall(function() firesignal(signal) end)
                if ok then fired = true end
            end
            if getconnections then
                pcall(function()
                    for _, sig in pairs(getconnections(signal)) do
                        if sig and sig.Function then
                            pcall(sig.Function)
                            fired = true
                        end
                    end
                end)
            end
        end
    end

    return fired
end
getgenv().pressSpecialButton = pressSpecialButton

local function isGuiClickableNow(obj)
    if not obj or not obj:IsA("GuiObject") then return false end
    if isGuiObjectVisibleInHierarchy and not isGuiObjectVisibleInHierarchy(obj) then return false end

    local current = obj
    while current do
        if current:IsA("GuiObject") then
            local okVisible, visible = pcall(function() return current.Visible end)
            if okVisible and visible == false then return false end
        end
        if current == LocalPlayer:FindFirstChild("PlayerGui") then break end
        current = current.Parent
    end

    local okSize, size = pcall(function() return obj.AbsoluteSize end)
    return okSize and size and size.X > 2 and size.Y > 2
end

local function getGuiCenterPosition(obj)
    if not obj or not obj:IsA("GuiObject") then return nil end

    local ok, pos, size = pcall(function()
        return obj.AbsolutePosition, obj.AbsoluteSize
    end)
    if not ok or not pos or not size or size.X <= 2 or size.Y <= 2 then return nil end

    return Vector2.new(pos.X + (size.X * 0.5), pos.Y + (size.Y * 0.5))
end

local function virtualLeftClickAtPosition(pos)
    if typeof(pos) ~= "Vector2" then return false end

    local fired = false
    if VIM then
        local ok = pcall(function()
            pcall(function() VIM:SendMouseMoveEvent(pos.X, pos.Y, game) end)
            VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
            VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
        end)
        fired = ok or fired

        if not ok then
            ok = pcall(function()
                VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
                VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
            end)
            fired = ok or fired
        end
    end

    if not fired then
        pcall(function()
            local cam = workspace.CurrentCamera
            VirtualUser:Button1Down(pos, cam and cam.CFrame or CFrame.new())
            VirtualUser:Button1Up(pos, cam and cam.CFrame or CFrame.new())
            fired = true
        end)
    end

    return fired
end

function clickParryGuiButton(requested)
    local button = findParryGuiButton(requested)
    if not isGuiClickableNow(button) then return false end

    local fired = false
    pcall(function()
        if button:IsA("GuiButton") then
            button:Activate()
            fired = true
        end
    end)

    local center = getGuiCenterPosition(button)
    if center then
        fired = virtualLeftClickAtPosition(center) or fired
    end

    return fired
end

local function clickToolAtScreenCenter()
    local cam = workspace.CurrentCamera
    local viewport = cam and cam.ViewportSize
    if not viewport then return false end
    return virtualLeftClickAtPosition(Vector2.new(viewport.X * 0.5, viewport.Y * 0.5))
end

local function virtualKeyTap(keyCode)
    if not VIM or not keyCode then return false end
    local ok = pcall(function()
        VIM:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.018)
        VIM:SendKeyEvent(false, keyCode, false, game)
    end)
    return ok
end

local function resolveKeyCode(raw)
    if typeof(raw) == "EnumItem" then return raw end
    local text = tostring(raw or "")
    text = text:gsub("Enum.KeyCode.", "")
    local ok, key = pcall(function() return Enum.KeyCode[text] end)
    if ok then return key end
    return nil
end

local function runPCParryKeyFallback()
    if UserInputService.TouchEnabled then return false end
    if getgenv().ArexansPCParryKeyFallback == false then return false end

    local fired = false
    local keys = getgenv().ArexansPCParryKeys or {Enum.KeyCode.F}
    for _, raw in ipairs(keys) do
        local key = resolveKeyCode(raw)
        if key then
            fired = virtualKeyTap(key) or fired
            task.wait(0.012)
        end
    end
    return fired
end


local function cleanupParryCooldownOverlay()
    local pg = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return end

    pcall(function()
        local gui = pg:FindFirstChild("ArexansParryCooldownGui")
        if gui then gui:Destroy() end
    end)

    pcall(function()
        for _, obj in ipairs(pg:GetDescendants()) do
            if obj.Name == "ArexansParryCooldownDrain" then
                obj:Destroy()
            end
        end
    end)
end

-- Bersihkan sisa overlay dari versi lama tanpa perlu menunggu cooldown selesai.
if UserInputService.TouchEnabled then
    cleanupParryCooldownOverlay()
end

local function ensureParryCooldownOverlay(rootObj)
    if UserInputService.TouchEnabled then
        cleanupParryCooldownOverlay()
        return nil
    end
    if getgenv().ArexansParryCooldownOverlay == false then return nil end
    if not rootObj or not rootObj:IsA("GuiObject") then return nil end

    local bar = rootObj:FindFirstChild("ArexansParryCooldownDrain")
    if not bar then
        bar = Instance.new("Frame")
        bar.Name = "ArexansParryCooldownDrain"
        bar.BorderSizePixel = 0
        bar.BackgroundTransparency = 0.05
        bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        bar.Position = UDim2.new(0, 0, 0.86, 0)
        bar.Size = UDim2.new(1, 0, 0.14, 0)
        bar.Visible = false
        pcall(function() bar.ZIndex = math.max((rootObj.ZIndex or 1) + 20, 999991) end)
        bar.Parent = rootObj
    end

    return bar
end

local function getFallbackParryCooldownRoot()
    if UserInputService.TouchEnabled then
        cleanupParryCooldownOverlay()
        return nil
    end
    if getgenv().ArexansParryCooldownOverlay == false then return nil end

    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end

    local gui = pg:FindFirstChild("ArexansParryCooldownGui")
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "ArexansParryCooldownGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Enabled = true
        pcall(function() gui.DisplayOrder = 999999 end)
        gui.Parent = pg
    end

    local root = gui:FindFirstChild("CooldownRoot")
    if not root then
        root = Instance.new("Frame")
        root.Name = "CooldownRoot"
        root.AnchorPoint = Vector2.new(0.5, 1)
        root.Position = UDim2.new(0.5, 0, 0.92, 0)
        root.Size = UDim2.new(0, 150, 0, 18)
        root.BackgroundTransparency = 0.35
        root.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        root.BorderSizePixel = 0
        root.Visible = true
        pcall(function() root.ZIndex = 999990 end)
        root.Parent = gui
    end

    return root
end

function beginParryCooldownVisual(duration)
    duration = tonumber(duration) or PARRY_COOLDOWN_SECONDS

    -- Mobile memakai cooldown bar bawaan tombol parry. Jangan ubah/menambah bar lokal,
    -- karena itu yang menyebabkan ada visual bar tambahan di dekat tombol parry.
    if UserInputService.TouchEnabled then
        cleanupParryCooldownOverlay()
        return false
    end

    local button = findParryGuiButton("parry")
        or findParryGuiButton("dagger")
        or findParryGuiButton("Gui-mob")
        or findParryGuiButton("Parrying Dagger")
    local cooldownRoot = button
        or findParryGuiContainer("parry")
        or findParryGuiContainer("dagger")
        or findParryGuiContainer("Gui-mob")
        or findParryGuiContainer("Parrying Dagger")
    if not cooldownRoot then
        -- Fallback terakhir: jika PC UI tidak bisa ditemukan/namanya acak, tampilkan bar kecil
        -- hanya saat cooldown agar user tetap mendapat indikator parry.
        cooldownRoot = getFallbackParryCooldownRoot()
    end
    if not cooldownRoot then return false end

    local bars = {}
    local function addBarCandidate(obj)
        if not obj or not obj:IsA("GuiObject") then return end
        if obj.Name == "ArexansParryCooldownDrain" then return end
        local name = tostring(obj.Name or ""):lower()
        if name:find("cool", 1, true)
           or name:find("bar", 1, true)
           or name:find("fill", 1, true)
           or name:find("progress", 1, true)
           or name == "cd" then
            bars[#bars + 1] = obj
        end
    end

    for _, obj in ipairs(cooldownRoot:GetDescendants()) do
        addBarCandidate(obj)
    end

    -- Fallback ringan: beberapa UI PC menaruh bar cooldown sebagai sibling slot,
    -- bukan descendant tombol. Tetap dibatasi ke container item/parry.
    if #bars == 0 and cooldownRoot.Parent then
        local parentText = getGuiSearchText(cooldownRoot.Parent)
        local parentIsParrySlot = parentText:find("parry", 1, true)
            or parentText:find("dagger", 1, true)
            or parentText:find("gui-mob", 1, true)
            or parentText:find("guimob", 1, true)

        if parentIsParrySlot then
            for _, obj in ipairs(cooldownRoot.Parent:GetDescendants()) do
                addBarCandidate(obj)
            end
        else
            for _, sibling in ipairs(cooldownRoot.Parent:GetChildren()) do
                local text = getGuiSearchText(sibling)
                if text:find("parry", 1, true) or text:find("dagger", 1, true) or text:find("gui-mob", 1, true) then
                    addBarCandidate(sibling)
                    for _, obj in ipairs(sibling:GetDescendants()) do
                        addBarCandidate(obj)
                    end
                end
            end
        end
    end

    -- Jika bar bawaan PC tidak punya nama yang jelas, buat overlay kecil di slot parry.
    -- Ini hanya visual lokal agar cooldown terlihat berkurang seperti mobile.
    local overlay = ensureParryCooldownOverlay(cooldownRoot)
    if #bars == 0 and not overlay then return false end

    local token = (getgenv().ArexansParryCooldownToken or 0) + 1
    getgenv().ArexansParryCooldownToken = token

    local originals = {}
    for _, bar in ipairs(bars) do
        if bar and bar.Parent then
            originals[bar] = {Size = bar.Size, Visible = bar.Visible}
            pcall(function()
                bar.Visible = true
                -- Bar bawaan tetap memakai pola recover 0 -> penuh seperti versi sebelumnya.
                bar.Size = UDim2.new(0, 0, bar.Size.Y.Scale, bar.Size.Y.Offset)
            end)
        end
    end

    if overlay then
        pcall(function()
            overlay.Visible = true
            overlay.Size = UDim2.new(1, 0, 0.14, 0)
        end)
    end

    task.spawn(function()
        local startTime = tick()
        while getgenv().ArexansParryCooldownToken == token do
            local alpha = math.clamp((tick() - startTime) / duration, 0, 1)
            for bar, data in pairs(originals) do
                if bar and bar.Parent then
                    pcall(function()
                        bar.Visible = true
                        bar.Size = UDim2.new(
                            data.Size.X.Scale * alpha,
                            data.Size.X.Offset * alpha,
                            data.Size.Y.Scale,
                            data.Size.Y.Offset
                        )
                    end)
                end
            end

            -- Overlay baru dibuat menurun penuh -> kosong, supaya secara visual jelas
            -- bahwa parry sedang cooldown di PC.
            if overlay and overlay.Parent then
                pcall(function()
                    overlay.Visible = true
                    overlay.Size = UDim2.new(math.max(0, 1 - alpha), 0, 0.14, 0)
                end)
            end

            if alpha >= 1 then break end
            task.wait(0.03)
        end

        for bar, data in pairs(originals) do
            if bar and bar.Parent then
                pcall(function()
                    bar.Size = data.Size
                    bar.Visible = data.Visible
                end)
            end
        end

        if overlay and overlay.Parent then
            pcall(function()
                overlay.Visible = false
                overlay.Size = UDim2.new(1, 0, 0.14, 0)
            end)
        end
    end)

    return true
end
function beginParryLocalCooldown(tool, duration)
    duration = tonumber(duration) or PARRY_COOLDOWN_SECONDS
    getgenv().NextAllowedParry = tick() + duration
    markParryVisualCooldown(duration)
    beginParryCooldownVisual(duration)

    if tool and tool:IsA("Tool") then
        local token = (getgenv().ArexansForcedParryCooldownToken or 0) + 1
        getgenv().ArexansForcedParryCooldownToken = token

        pcall(function() tool.Enabled = false end)
        task.delay(duration, function()
            if getgenv().ArexansForcedParryCooldownToken == token and tool and tool.Parent then
                pcall(function() tool.Enabled = true end)
            end
        end)
    end
end

function applyParryStance(char, hum)
    if not char or not hum then return end

    -- Bila user sengaja mengaktifkan LightStance, stance visual ikut dimatikan.
    if getgenv().ArexansParryLightStance == true then
        return
    end

    local token = (getgenv().ArexansParryStanceToken or 0) + 1
    getgenv().ArexansParryStanceToken = token

    -- Jangan paksa WalkSpeed = 0 secara default. Ini sumber nyangkut/rubberband
    -- pada dash cepat, tetapi attribute crouch tetap cukup untuk memunculkan kuda-kuda.
    if getgenv().ArexansParryFreezeOnStance == true then
        pcall(function() hum.WalkSpeed = 0 end)
    end

    local function setCrouchState(state)
        pcall(function() char:SetAttribute("Crouchingserver", state) end)

        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local mechanics = remotes:FindFirstChild("Mechanics")
            local changeAttribute = mechanics and mechanics:FindFirstChild("ChangeAttribute")
            if changeAttribute then
                pcall(function() changeAttribute:FireServer("Crouchingserver", state) end)
            end

            if state then
                local chase = remotes:FindFirstChild("Chase")
                local runEvent = chase and chase:FindFirstChild("Runevent")
                if runEvent then
                    pcall(function() runEvent:FireServer(char, false) end)
                end
            end
        end
    end

    setCrouchState(true)

    local holdTime = tonumber(getgenv().ArexansParryStanceHoldTime) or 0.32
    task.delay(math.clamp(holdTime, 0.16, 0.75), function()
        if getgenv().ArexansParryStanceToken == token and char and char.Parent then
            setCrouchState(false)
        end
    end)
end
local function fireRBXSignalConnections(signal)
    if not signal then return false end

    local fired = false
    if firesignal then
        local ok = pcall(function() firesignal(signal) end)
        fired = ok or fired
    end

    if getconnections then
        pcall(function()
            for _, sig in pairs(getconnections(signal)) do
                if sig then
                    if sig.Fire then
                        pcall(function() sig:Fire() end)
                        fired = true
                    elseif sig.Function then
                        pcall(sig.Function)
                        fired = true
                    end
                end
            end
        end)
    end

    return fired
end

function runAutoParryUse(currentTool)
    local guiFired = false
    local localInputFired = false
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    local function resolveDaggerTool()
        local tool = nil
        pcall(function()
            tool = char and char:FindFirstChild("Parrying Dagger") or nil
        end)
        if not tool then
            pcall(function()
                tool = LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Parrying Dagger") or nil
            end)
        end
        return tool or currentTool
    end

    currentTool = resolveDaggerTool()

    -- PC sering gagal kalau dagger masih di Backpack lalu klik virtual dikirim terlalu cepat.
    -- Pastikan Tool sudah pindah ke Character sebelum jalur mouse/Tool.Activate dijalankan.
    if currentTool and currentTool:IsA("Tool") and char and hum and currentTool.Parent ~= char then
        pcall(function() hum:EquipTool(currentTool) end)
        local equipStart = tick()
        while currentTool and currentTool.Parent ~= char and tick() - equipStart < 0.14 do
            RunService.Heartbeat:Wait()
        end
        currentTool = resolveDaggerTool()
    end

    local function activateCurrentTool()
        local fired = false
        pcall(function()
            if currentTool and currentTool:IsA("Tool") and currentTool.Parent == char then
                currentTool:Activate()
            end
        end)

        -- Fix PC: beberapa executor tidak memicu LocalScript game hanya dari Tool:Activate().
        -- Firesignal/getconnections memanggil listener lokal Tool.Activated sehingga animasi + cooldown UI bawaan ikut hidup.
        pcall(function()
            if currentTool and currentTool:IsA("Tool") then
                fired = fireRBXSignalConnections(currentTool.Activated) or fired
            end
        end)

        return fired
    end

    -- Jalur lokal dulu supaya animasi stance + cooldown bar bawaan game ikut terpanggil.
    localInputFired = activateCurrentTool() or localInputFired

    pcall(function()
        guiFired = getgenv().pressSpecialButton("Parrying Dagger") or guiFired
        guiFired = getgenv().pressSpecialButton("parry") or guiFired
        guiFired = getgenv().pressSpecialButton("Gui-mob") or guiFired
    end)
    localInputFired = guiFired or localInputFired

    -- Fix PC: sebelumnya pencarian tombol bisa kena GUI mobile tersembunyi.
    -- Sekarang findParryGuiButton/findParryGuiContainer hanya memilih GUI yang benar-benar terlihat.
    if not UserInputService.TouchEnabled then
        pcall(function()
            local clicked = false
            clicked = clickParryGuiButton("Parrying Dagger") or clicked
            clicked = clickParryGuiButton("parry") or clicked
            clicked = clickParryGuiButton("Gui-mob") or clicked
            guiFired = clicked or guiFired
            localInputFired = clicked or localInputFired
        end)

        pcall(function()
            localInputFired = clickToolAtScreenCenter() or localInputFired
        end)

        -- PC native input fallback: beberapa versi game tidak mengikat parry ke Mouse1/Tool.Activate,
        -- tetapi ke keybind block/parry. Ini membantu jalur lokal agar animasi + cooldown UI ikut hidup.
        pcall(function()
            localInputFired = runPCParryKeyFallback() or localInputFired
        end)

        -- Ulangi Tool:Activate setelah virtual click agar executor PC yang mengabaikan
        -- aktivasi pertama tetap mendapat trigger lokal.
        localInputFired = activateCurrentTool() or localInputFired
    else
        pcall(function()
            local clicked = false
            clicked = clickParryGuiButton("Parrying Dagger") or clicked
            clicked = clickParryGuiButton("parry") or clicked
            clicked = clickParryGuiButton("Gui-mob") or clicked
            guiFired = clicked or guiFired
            localInputFired = clicked or localInputFired
        end)
    end

    -- Remote hanya fallback terakhir. Pada PC, jangan langsung menimpa jalur lokal,
    -- karena remote server-only bisa membuat parry berhasil tetapi animasi/cooldown lokal tidak ikut jalan.
    local shouldFireRemote = true
    if not UserInputService.TouchEnabled then
        if getgenv().ArexansPCParryRemoteFallback == false then
            shouldFireRemote = false
        elseif currentTool and currentTool:IsA("Tool") and localInputFired then
            -- Beri 1-2 frame agar LocalScript game sempat mematikan tool / memulai cooldown.
            local waitStart = tick()
            while tick() - waitStart < 0.045 do
                RunService.Heartbeat:Wait()
            end
            pcall(function()
                if currentTool.Enabled == false then
                    shouldFireRemote = false
                end
            end)
        end
    end

    if shouldFireRemote then
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local items = remotes and remotes:FindFirstChild("Items")
            local daggerRemoteFolder = items and items:FindFirstChild("Parrying Dagger")
            local parryRemote = daggerRemoteFolder and daggerRemoteFolder:FindFirstChild("parry")
            if parryRemote then
                parryRemote:FireServer()
            end
        end)
    end

    beginParryLocalCooldown(currentTool, PARRY_COOLDOWN_SECONDS)
    return guiFired or localInputFired
end

-- Deteksi killer dari workspace (diperluas untuk The Hidden & killer tanpa marker standar)
function isKillerModel(obj)
    if not obj or not obj:IsA("Model") then return false end
    if obj:FindFirstChild("Killerost") then return true end
    if obj:FindFirstChild("Lookscriptkiller") then return true end
    if obj:FindFirstChild("Weapon") and Players:GetPlayerFromCharacter(obj) == nil then return true end
    if obj:FindFirstChild("KillerTag") then return true end
    if obj:FindFirstChild("KillerScript") then return true end
    if obj:FindFirstChild("IsKiller") then return true end
    if isTheCureModel(obj) and obj:FindFirstChildOfClass("Humanoid") then return true end
    local n = obj.Name:lower()
    local compactName = compactParryText(n)
    if (n:find("killer",1,true) or n:find("thehidden",1,true)
        or compactName:find("thecure",1,true) or n:find("the cure",1,true))
        and obj:FindFirstChildOfClass("Humanoid") then
        return true
    end
    return false
end

-- Cari semua model killer di workspace
function getKillerModels()
    local killers = {}
    local seen    = {}

    -- Scan workspace objects langsung
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj ~= LocalPlayer.Character and not seen[obj] and isKillerModel(obj) then
            table.insert(killers, obj)
            seen[obj] = true
        end
    end

    -- Scan karakter player (by team / by marker)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and not seen[plr.Character] then
            local pchar = plr.Character
            local hasMarker = pchar:FindFirstChild("Weapon") or pchar:FindFirstChild("Killerost")
                or pchar:FindFirstChild("Lookscriptkiller") or pchar:FindFirstChild("KillerTag")
                or pchar:FindFirstChild("IsKiller") or isTheCureModel(pchar)
            local isKillerTeam = plr.Team and plr.Team.Name:lower():find("killer",1,true)
            if hasMarker or isKillerTeam then
                table.insert(killers, pchar)
                seen[pchar] = true
            end
        end
    end

    -- Fallback jika masih kosong: ambil player terdekat yang bukan survivor
    if #killers == 0 then
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if myRoot then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and not seen[plr.Character] then
                    local pchar    = plr.Character
                    local proot    = pchar:FindFirstChild("HumanoidRootPart")
                    local isSurvivor = plr.Team and plr.Team.Name:lower():find("survivor",1,true)
                    if proot and not isSurvivor and (proot.Position - myRoot.Position).Magnitude <= 60 then
                        table.insert(killers, pchar)
                        seen[pchar] = true
                    end
                end
            end
        end
    end

    return killers
end

-- Cache killer supaya Auto Parry tidak scan workspace/player setiap frame.
local ArexansRawGetKillerModels = getKillerModels
local ArexansKillerCache = {}
local ArexansKillerCacheAt = 0
function getKillerModels(force)
    local now = os.clock()
    local interval = tonumber(getgenv().ArexansKillerCacheInterval) or 0.18
    if not force and ArexansKillerCache and (now - ArexansKillerCacheAt) < interval then
        return ArexansKillerCache
    end

    local ok, result = pcall(ArexansRawGetKillerModels)
    if ok and type(result) == "table" then
        ArexansKillerCache = result
    else
        ArexansKillerCache = {}
    end
    ArexansKillerCacheAt = now
    return ArexansKillerCache
end

-- Cek apakah dagger ada & ready (tidak sedang cooldown)
function getDagger()
    local char = LocalPlayer.Character
    if not char then return nil end
    local dagger = char:FindFirstChild("Parrying Dagger")
        or LocalPlayer.Backpack:FindFirstChild("Parrying Dagger")
    return dagger
end

local function removeParryDrawingVisual()
    if ParryVisualSegments then
        for _, line in pairs(ParryVisualSegments) do
            if line then
                pcall(function() line.Visible = false end)
                pcall(function() line:Remove() end)
            end
        end
        table.clear(ParryVisualSegments)
    end
end

local function hideParryDrawingVisual()
    if ParryVisualSegments then
        for _, line in pairs(ParryVisualSegments) do
            if line then
                pcall(function() line.Visible = false end)
            end
        end
    end
end

local function ensureParryDrawingVisual()
    if not (Drawing and Drawing.new) then return false end
    ParryVisualSegments = ParryVisualSegments or {}
    for i = 1, ParryVisualSegmentCount do
        if not ParryVisualSegments[i] then
            local line = Drawing.new("Line")
            line.Thickness = 2
            line.Transparency = 0.95
            line.Visible = false
            ParryVisualSegments[i] = line
        end
    end
    return true
end

local function getParryDaggerForVisual()
    local dagger = nil
    pcall(function()
        dagger = getDagger and getDagger() or nil
    end)
    return dagger
end

local function isParryCoolingDownForVisual()
    -- Selama Auto Parry baru dipakai / masih cooldown, radius harus tetap putih polos.
    if getgenv().ParryDebounce then return true end
    if tick() < (tonumber(getgenv().NextAllowedParry) or 0) then return true end
    if tick() < (tonumber(getgenv().ArexansParryVisualCooldownUntil) or 0) then return true end

    local dagger = getParryDaggerForVisual()
    if dagger and dagger:IsA("Tool") and not dagger.Enabled then
        return true
    end

    return false
end

local function isParryReadyForVisual()
    if not featureStates.AutoParry then return false end
    if isParryCoolingDownForVisual() then return false end

    local dagger = getParryDaggerForVisual()
    if not dagger then
        return false
    end

    return true
end

function updateParryVisual()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local active = featureStates.AutoParry and getgenv().ParryVisualsEnabled and root ~= nil
    local ready = active and isParryReadyForVisual()
    local cam = workspace.CurrentCamera

    -- Drawing dipakai agar garis lingkaran bisa benar-benar gradient/animated.
    -- Jika executor tidak mendukung Drawing, fallback tetap memakai CylinderHandleAdornment.
    if active and cam and ensureParryDrawingVisual() then
        if ParryVisual then
            ParryVisual:Destroy()
            ParryVisual = nil
        end

        -- Ring diturunkan mendekati kaki. Default baru tidak membuat gap di badan karakter,
        -- supaya radius tidak terlihat patah/terpotong saat kamera bergerak.
        local center = root.Position + Vector3.new(0, -3.65, 0)
        local radius = tonumber(ParryDistance) or 20
        local now = tick()
        local baseBlue = Color3.fromRGB(0, 92, 255)
        local cyanBlue = Color3.fromRGB(0, 225, 255)
        local deepBlue = Color3.fromRGB(0, 38, 180)
        local useCharacterCutout = getgenv().ArexansParryVisualCharacterCutout == true

        local rootScreen, rootOnScreen = cam:WorldToViewportPoint(root.Position)
        local head = char and char:FindFirstChild("Head")
        local headPos = head and (head.Position + Vector3.new(0, 0.65, 0)) or (root.Position + Vector3.new(0, 2.6, 0))
        local footPos = root.Position + Vector3.new(0, -3.1, 0)
        local headScreen = cam:WorldToViewportPoint(headPos)
        local footScreen = cam:WorldToViewportPoint(footPos)
        local bodyHeight = math.abs(footScreen.Y - headScreen.Y)
        local shieldHalfWidth = math.clamp(bodyHeight * 0.42, 26, 76)
        local shieldTop = math.min(headScreen.Y, footScreen.Y) - 10
        local shieldBottom = math.max(headScreen.Y, footScreen.Y) + 20

        local function segmentHitsCharacterShield(s1, s2)
            if not rootOnScreen or rootScreen.Z <= 0 then return false end
            local midX = (s1.X + s2.X) * 0.5
            local midY = (s1.Y + s2.Y) * 0.5
            return midX >= (rootScreen.X - shieldHalfWidth)
               and midX <= (rootScreen.X + shieldHalfWidth)
               and midY >= shieldTop
               and midY <= shieldBottom
        end

        for i = 1, ParryVisualSegmentCount do
            local line = ParryVisualSegments[i]
            local a1 = ((i - 1) / ParryVisualSegmentCount) * math.pi * 2
            local a2 = (i / ParryVisualSegmentCount) * math.pi * 2
            local p1 = center + Vector3.new(math.cos(a1) * radius, 0, math.sin(a1) * radius)
            local p2 = center + Vector3.new(math.cos(a2) * radius, 0, math.sin(a2) * radius)
            local s1, v1 = cam:WorldToViewportPoint(p1)
            local s2, v2 = cam:WorldToViewportPoint(p2)

            if line and v1 and v2 and s1.Z > 0 and s2.Z > 0
               and not (useCharacterCutout and segmentHitsCharacterShield(s1, s2)) then
                local wave = ((i / ParryVisualSegmentCount) + now * 0.85) % 1
                local pulse = (math.sin((wave * math.pi * 2)) + 1) * 0.5

                if ready then
                    line.Color = deepBlue:Lerp(cyanBlue, pulse):Lerp(baseBlue, 0.25)
                    line.Thickness = 2.2 + (pulse * 1.25)
                    line.Transparency = 0.92
                else
                    -- Saat cooldown/tidak siap, visual kembali putih biasa tanpa gradient.
                    line.Color = Color3.fromRGB(255, 255, 255)
                    line.Thickness = 1.45
                    line.Transparency = 0.55
                end

                line.From = Vector2.new(s1.X, s1.Y)
                line.To = Vector2.new(s2.X, s2.Y)
                line.Visible = true
            elseif line then
                line.Visible = false
            end
        end
        return
    else
        hideParryDrawingVisual()
    end

    if active then
        if not ParryVisual then
            ParryVisual = Instance.new("CylinderHandleAdornment")
            ParryVisual.Height = 0.04
            ParryVisual.CFrame = CFrame.new(0, -3.65, 0) * CFrame.Angles(math.rad(90), 0, 0)
            pcall(function() ParryVisual.AlwaysOnTop = true end)
            pcall(function() ParryVisual.ZIndex = 1 end)
        end

        local pulse = (math.sin(tick() * 4) + 1) * 0.5
        if ready then
            ParryVisual.Color3 = Color3.fromRGB(0, 90, 255):Lerp(Color3.fromRGB(0, 225, 255), pulse)
            ParryVisual.Transparency = 0.22
        else
            -- Saat cooldown/tidak siap, visual kembali putih biasa tanpa gradient.
            ParryVisual.Color3 = Color3.fromRGB(255, 255, 255)
            ParryVisual.Transparency = 0.72
        end

        ParryVisual.Radius      = ParryDistance
        ParryVisual.InnerRadius = math.max(0, ParryDistance - 0.18)
        ParryVisual.Adornee     = root
        ParryVisual.Parent      = root
        ParryVisual.Visible     = true
    elseif ParryVisual then
        ParryVisual:Destroy()
        ParryVisual = nil
    end
end

local function startParryVisualLoop()
    if ParryVisualRenderConn then
        ParryVisualRenderConn:Disconnect()
        ParryVisualRenderConn = nil
    end

    local lastVisualUpdate = 0
    ParryVisualRenderConn = RunService.RenderStepped:Connect(function()
        local now = os.clock()
        local visualInterval = tonumber(getgenv().ArexansParryVisualUpdateInterval) or 0.05
        if visualInterval > 0 and (now - lastVisualUpdate) < visualInterval then
            return
        end
        lastVisualUpdate = now
        updateParryVisual()
    end)
end

local function stopParryVisualLoop()
    if ParryVisualRenderConn then
        ParryVisualRenderConn:Disconnect()
        ParryVisualRenderConn = nil
    end

    if ParryVisual then
        ParryVisual:Destroy()
        ParryVisual = nil
    end
    removeParryDrawingVisual()
end

local function getCachedParryObstruction(obj, char, root, killerRoot, interval)
    if not root or not killerRoot then return false end

    local now = os.clock()
    interval = tonumber(interval) or 0.075
    local cached = ArexansParryRayCache[obj]
    if cached and (now - (cached.t or 0)) < interval then
        local rootStable = cached.rootPos and (root.Position - cached.rootPos).Magnitude <= 2.5
        local killerStable = cached.killerPos and (killerRoot.Position - cached.killerPos).Magnitude <= 5.5
        if rootStable and killerStable then
            return cached.hit == true
        end
    end

    local hit = false
    pcall(function()
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = { char, obj }
        local result = workspace:Raycast(root.Position, killerRoot.Position - root.Position, rayParams)
        hit = result ~= nil
    end)

    ArexansParryRayCache[obj] = {
        t = now,
        hit = hit,
        rootPos = root.Position,
        killerPos = killerRoot.Position,
    }
    return hit
end

-- Main parry loop â€” dipasang ke RunService.Heartbeat seperti vd2
parryHeartbeatConn = nil

function startAutoParry()
    if getgenv().ParryVisualsEnabled then
        startParryVisualLoop()
    else
        stopParryVisualLoop()
    end

    if parryHeartbeatConn then
        parryHeartbeatConn:Disconnect()
        parryHeartbeatConn = nil
    end

    local lastAutoParryScan = 0

    parryHeartbeatConn = RunService.Heartbeat:Connect(function()
        if not featureStates.AutoParry then return end

        local nowScan = os.clock()
        local scanInterval = tonumber(getgenv().ArexansAutoParryScanInterval) or (1 / 45)
        if scanInterval > 0 and (nowScan - lastAutoParryScan) < scanInterval then
            return
        end
        lastAutoParryScan = nowScan

        local char = LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root then return end

        -- Jangan parry saat di-hook, digendong, atau sudah mati
        if char:GetAttribute("IsHooked") or char:GetAttribute("IsCarried")
           or char:GetAttribute("Knocked") then
            return
        end

        local dagger = getDagger()
        if not dagger then return end

        -- Cek dagger enabled (cooldown selesai)
        if dagger:IsA("Tool") and not dagger.Enabled then return end

        -- Cooldown fallback aman untuk kasus Parrying Dagger muncul sebagai Model, bukan Tool.
        -- Ini menjaga SmartFace tidak menghadap killer terus saat parry sebenarnya masih cooldown.
        if tick() < (getgenv().NextAllowedParry or 0) then return end

        -- Global debounce/action lock. Debounce dibuat pendek agar parry berikutnya tidak macet,
        -- sedangkan cooldown sebenarnya tetap dijaga oleh NextAllowedParry/tool.Enabled.
        if tick() < (getgenv().ArexansAutoParryActionLockUntil or 0) then return end
        if getgenv().ParryDebounce then
            if tick() - (getgenv().LastParryTime or 0) > (PARRY_INPUT_LOCK_SECONDS or 0.24) then
                getgenv().ParryDebounce = false
            else
                return
            end
        end

        local killers = getKillerModels()
        for _, obj in ipairs(killers) do
            if not (obj and obj.Parent) then continue end

            local killerHum  = obj:FindFirstChildOfClass("Humanoid")
            local killerRoot = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")
            if not killerHum or not killerRoot then continue end

            local isTheCureKiller = isTheCureModel(obj)
            local dist = (killerRoot.Position - root.Position).Magnitude
            local scanRange = ParryDistance + (PARRY_FAST_STAB_MAX_EXTRA_RANGE or 28) + (isTheCureKiller and 18 or 8)
            if dist > scanRange then continue end

            -- ---- Cek apakah killer sedang animasi serangan ----
            local ping         = math.clamp(LocalPlayer:GetNetworkPing(), 0.01, 0.3)
            local killerVel    = getPartLinearVelocity(killerRoot)
            local offsetToPlayer = root.Position - killerRoot.Position
            local toPlayer     = safeVectorUnit(offsetToPlayer)
            local closingSpeed = killerVel:Dot(toPlayer)

            -- Prediction adaptif: dash/tusukan lurus The Hidden butuh range ekstra, tapi tetap dikunci oleh time-to-impact.
            local predictionTime = ping + 0.08
            if UserInputService.TouchEnabled then
                predictionTime = predictionTime + 0.18
            else
                predictionTime = predictionTime + (PARRY_PC_INPUT_LEAD or 0.065)
            end
            local facingDot = root.CFrame.LookVector:Dot(toPlayer)
            if facingDot > 0 then predictionTime = predictionTime + 0.06 end

            local killerFacingDot = getAimDot(killerRoot, toPlayer)
            local fastStabDetected, fastStabInfo = detectFastStraightStab(killerRoot, root, ping, UserInputService.TouchEnabled)
            local highSpeedApproach = closingSpeed >= 38 or (fastStabInfo and (fastStabInfo.speed or 0) >= 55)
            local dashAntiLagActive = getgenv().ArexansDashAntiLag ~= false and highSpeedApproach
            local dashOffLine = false
            if dashAntiLagActive and fastStabInfo and fastStabInfo.reason == "not_ready" then
                local lateralDistance = tonumber(fastStabInfo.lateralDistance) or 0
                local lateralLimit = tonumber(fastStabInfo.lateralLimit) or 6
                local directness = tonumber(fastStabInfo.directness) or 0
                -- Jika dash cepat jelas meleset dari jalur player, jangan scan animasi/raycast berat.
                dashOffLine = lateralDistance > (lateralLimit + 2.25) and directness < 0.55 and dist > ((tonumber(ParryDistance) or 20) + 3)
            end
            local skipAnimationScanForDash = dashAntiLagActive and (fastStabDetected or dashOffLine)
            local approachDist    = closingSpeed > 0 and (closingSpeed * predictionTime) or 0
            local maxApproachBonus = highSpeedApproach and 18 or 6
            local effectiveRange  = ParryDistance + math.clamp(approachDist, 0, maxApproachBonus)
            local panicMode       = dist < (ParryDistance - (highSpeedApproach and 1 or 3))
            local isExtremelyClose = dist <= (highSpeedApproach and 14 or 10)
            local cureLeadWindow = math.clamp(ping + 0.12 + (UserInputService.TouchEnabled and 0.08 or (PARRY_PC_INPUT_LEAD or 0.065)), 0.16, 0.40)
            local cureApproachBonus = math.clamp(math.max(closingSpeed, 0) * cureLeadWindow, 0, 16)
            local cureEffectiveRange = ParryDistance + 3 + cureApproachBonus
            local cureFacingThreat = isTheCureKiller and (killerFacingDot >= 0.54 or closingSpeed >= 8 or dist <= ParryDistance + 1.5)
            local parryMomentumReady, parryMomentumInfo = getParryMomentumReady(
                dist,
                closingSpeed,
                ping,
                killerFacingDot,
                highSpeedApproach,
                UserInputService.TouchEnabled
            )

            -- Scan animasi killer dibuat adaptif.
            -- Saat dash cepat sudah terbaca dari momentum, kita tidak perlu terus membaca semua AnimationTrack.
            local isAttacking = false
            local cureAttackDetected = false
            local cureAttackTimingReady = false

            if skipAnimationScanForDash and fastStabDetected then
                isAttacking = true
            elseif skipAnimationScanForDash and dashOffLine then
                isAttacking = false
            else
                local animScanInterval = dashAntiLagActive
                    and (tonumber(getgenv().ArexansDashAnimationScanInterval) or 0.12)
                    or  (tonumber(getgenv().ArexansNormalAnimationScanInterval) or 0.055)
                local animCache = ArexansParryAnimCache[obj]
                if animCache and (nowScan - (animCache.t or 0)) < animScanInterval then
                    isAttacking = animCache.isAttacking or false
                    cureAttackDetected = animCache.cureAttackDetected or false
                    cureAttackTimingReady = animCache.cureAttackTimingReady or false
                else
                    pcall(function()
                        for _, track in ipairs(killerHum:GetPlayingAnimationTracks()) do
                            if track.Speed <= 0 then continue end

                            -- Ambil nama & id dengan aman
                            local rawName  = ""
                            local rawAnimId = ""
                            pcall(function() rawName   = tostring(track.Name or "") end)
                            pcall(function() rawAnimId = tostring(track.Animation and track.Animation.AnimationId or "") end)

                            local name    = rawName:lower()
                            local combined = name .. " " .. rawAnimId

                            -- Skip animasi non-serangan
                            local skip = false
                            for _, kw in ipairs(PARRY_SKIP_KW) do
                                if combined:find(kw,1,true) then skip = true; break end
                            end
                            if skip then continue end

                            -- Cek ID di tabel (paling akurat)
                            local id = tonumber(rawAnimId:match("%d+"))
                            if id and (attackanims[id] or lungeanims[id]) then
                                isAttacking = true; break
                            end

                            -- Cek keyword nama (fallback untuk killer baru / The Hidden / The Cure)
                            if parryTextHasKeyword(combined, PARRY_ATTACK_KW) then
                                if isTheCureKiller then
                                    local timePos = getTrackTimePosition(track)
                                    local length = getTrackLength(track)
                                    cureAttackDetected = true
                                    cureAttackTimingReady = (timePos <= 0.58) or (length > 0 and timePos <= math.min(length * 0.48, 0.72))
                                end
                                isAttacking = true; break
                            end

                            -- Jalur khusus The Cure: beberapa animasi barunya memakai nama medis/skill pendek
                            -- dan priority Action, sehingga tidak selalu mengandung kata "attack".
                            if isTheCureKiller then
                                local timePos = getTrackTimePosition(track)
                                local length = getTrackLength(track)
                                local earlyOrHitWindow = (timePos <= 0.58) or (length > 0 and timePos <= math.min(length * 0.48, 0.72))
                                local actionLike = isActionPriorityTrack(track)
                                if parryTextHasKeyword(combined, PARRY_THE_CURE_ATTACK_KW) then
                                    cureAttackDetected = true
                                    cureAttackTimingReady = earlyOrHitWindow
                                    isAttacking = true; break
                                elseif actionLike and earlyOrHitWindow and dist <= (ParryDistance + 9) and cureFacingThreat then
                                    cureAttackDetected = true
                                    cureAttackTimingReady = true
                                    isAttacking = true; break
                                end
                            end

                            if isAttacking then break end
                        end
                    end)

                    ArexansParryAnimCache[obj] = {
                        t = nowScan,
                        isAttacking = isAttacking,
                        cureAttackDetected = cureAttackDetected,
                        cureAttackTimingReady = cureAttackTimingReady,
                    }
                end
            end

            -- Momentum fallback: The Hidden bisa menusuk lurus sangat cepat tanpa animasi standar sempat terbaca.
            -- Jika trajectory menunjukkan impact dalam window parry, anggap sebagai serangan valid.
            if not isAttacking and fastStabDetected then
                isAttacking = true
            end

            -- Panic fallback tetap ada, tapi dinaikkan syarat closing speed agar tidak spam saat killer cuma berdiri dekat.
            if not isAttacking and isExtremelyClose and closingSpeed > (highSpeedApproach and 10 or 14) then
                isAttacking = true
            end

            -- Raycast obstruction check dibuat cache agar dash cepat tidak memicu raycast berulang tiap scan.
            local isObstructed = false
            if isAttacking and not isExtremelyClose then
                if dashAntiLagActive and fastStabDetected then
                    -- Dash lurus yang sudah masuk window impact tidak perlu raycast berat berulang.
                    isObstructed = false
                else
                    local rayInterval = dashAntiLagActive
                        and (tonumber(getgenv().ArexansDashRaycastInterval) or 0.14)
                        or  (tonumber(getgenv().ArexansNormalRaycastInterval) or 0.075)
                    isObstructed = getCachedParryObstruction(obj, char, root, killerRoot, rayInterval)
                end
            end

            local shouldParry = false
            if fastStabDetected and not isObstructed then
                -- Jalur khusus The Hidden: detectFastStraightStab sudah memakai time-to-impact,
                -- jadi parry keluar saat dash benar-benar masuk window benturan.
                shouldParry = true
            elseif isTheCureKiller and cureAttackDetected and not isObstructed then
                -- Jalur khusus The Cure: jangan parry sejak animasi baru mulai dari jauh.
                -- Harus masuk momentum impact / sudah sangat dekat / killer jelas menghadap dan berada di jarak hit.
                if (dist <= cureEffectiveRange and cureFacingThreat and cureAttackTimingReady and parryMomentumReady)
                    or isExtremelyClose
                    or (dist <= ParryDistance + 1.25 and killerFacingDot >= 0.68) then
                    shouldParry = true
                end
            elseif isAttacking and not isObstructed then
                -- Mode momentum: serangan animasi saja belum cukup.
                -- Tunggu sampai killer mendekat ke window hit agar tangkisan tidak terlalu cepat habis cooldown.
                if isExtremelyClose
                    or (dist <= effectiveRange and parryMomentumReady)
                    or (panicMode and killerFacingDot >= 0.52) then
                    shouldParry = true
                end
            elseif isTheCureKiller and dist <= ParryDistance + 1.25 and cureFacingThreat and closingSpeed > 6 and not isObstructed then
                -- The Cure kadang melakukan short step/instant jab tanpa animasi terbaca di client.
                shouldParry = parryMomentumReady or dist <= (ParryDistance - 1)
            elseif isExtremelyClose and closingSpeed > 12 and not isObstructed then
                -- The Hidden dash/muncul tiba-tiba tanpa animasi terdeteksi
                shouldParry = true
            end

            if not shouldParry then continue end

            -- Cek apakah sedang di-rescue/unhook
            local isBeingRescued = false
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                local name = track.Name:lower()
                if name:find("rescue") or name:find("unhook") or name:find("save") or name:find("help") then
                    isBeingRescued = true
                    break
                end
            end
            if isBeingRescued then continue end

            -- ---- Eksekusi Parry ----
            local function executeParry()
                -- Double-check cooldown/action lock sebelum eksekusi tertunda.
                if tick() < (getgenv().NextAllowedParry or 0) then return end
                if tick() < (getgenv().ArexansAutoParryActionLockUntil or 0) then return end
                if getgenv().ParryDebounce then
                    if tick() - (getgenv().LastParryTime or 0) > (PARRY_INPUT_LOCK_SECONDS or 0.24) then
                        getgenv().ParryDebounce = false
                    else
                        return
                    end
                end

                -- Double-check kondisi player
                if char:GetAttribute("IsHooked") or char:GetAttribute("IsCarried")
                   or char:GetAttribute("Knocked") then return end

                -- Auto-equip dagger jika di backpack
                local tool = char:FindFirstChild("Parrying Dagger")
                if not tool then
                    tool = LocalPlayer.Backpack:FindFirstChild("Parrying Dagger")
                    if tool then
                        hum:EquipTool(tool)
                        -- Beri satu momen sangat pendek agar Tool benar-benar pindah ke Character.
                        -- Ini memperbaiki kasus parry server aktif tetapi animasi/effect tebasan lokal tidak muncul.
                        local equipStart = tick()
                        while tool and tool.Parent ~= char and tick() - equipStart < 0.075 do
                            RunService.Heartbeat:Wait()
                        end
                    end
                end

                -- Abort jika tool tidak siap
                if not tool or not tool.Parent or (tool:IsA("Tool") and not tool.Enabled) then
                    return
                end

                -- Pasang lock hanya setelah dagger benar-benar siap.
                -- ParryDebounce sekarang pendek: fungsinya mencegah double-fire frame yang sama,
                -- bukan menahan Auto Parry sepanjang cooldown. Cooldown tetap dijaga oleh NextAllowedParry.
                local fireNow = tick()
                getgenv().ParryDebounce = true
                getgenv().LastParryTime = fireNow
                getgenv().ArexansAutoParryActionLockUntil = fireNow + (PARRY_INPUT_LOCK_SECONDS or 0.24)
                getgenv().NextAllowedParry = fireNow + PARRY_COOLDOWN_SECONDS
                markParryVisualCooldown(PARRY_COOLDOWN_SECONDS)
                getgenv().ArexansAutoParryUsingNow = true

                -- KUDA-KUDA (Stance): selalu dipakai saat Auto Parry mengeksekusi, baik PC maupun mobile.
                local oldWS = hum.WalkSpeed
                applyParryStance(char, hum)
                spawnAutoParrySlashEffect(root, killerRoot)

                -- SMART FACE: hanya satu pulse tepat di momen Auto Parry bereaksi.
                -- Tidak ada loop/hold yang terus memaksa badan menghadap killer saat parry tidak sedang dieksekusi.
                doSmartFacePulse(char, hum, root, killerRoot)

                task.delay(PARRY_INPUT_LOCK_SECONDS or 0.24, function()
                    if tick() >= (getgenv().ArexansAutoParryActionLockUntil or 0) then
                        getgenv().ParryDebounce = false
                    end
                end)

                -- Thread terpisah: activate tool + VIM backup + tunggu cooldown selesai
                task.spawn(function()
                    local ok, err = pcall(function()
                        local currentTool = char:FindFirstChild("Parrying Dagger")
                            or LocalPlayer.Backpack:FindFirstChild("Parrying Dagger")
                            or tool

                        -- Pakai jalur lokal + GUI dulu agar bar cooldown bawaan ikut bereaksi, lalu remote sebagai fallback.
                        applyParryStance(char, hum)
                        runAutoParryUse(currentTool)

                        -- Tunggu cooldown selesai dengan aman.
                        -- Jika Parrying Dagger terbaca sebagai Model, jangan baca .Enabled agar tidak error.
                        task.wait(0.2)
                        local waitStart = tick()
                        while tick() - waitStart < 4 do
                            local t = char:FindFirstChild("Parrying Dagger")
                                or LocalPlayer.Backpack:FindFirstChild("Parrying Dagger")
                            if not t or not t.Parent then break end
                            if t:IsA("Tool") then
                                if t.Enabled then break end  -- cooldown selesai
                            else
                                -- Fallback cooldown untuk model visual dagger.
                                if tick() - waitStart >= PARRY_COOLDOWN_SECONDS then break end
                            end
                            task.wait(0.1)
                        end
                    end)

                    if not ok then
                        local errText = tostring(err)
                        -- Jangan tampilkan log normal dari objek Parrying Dagger yang berupa Model.
                        -- Ini hanya filter console; alur Auto Parry/UI tetap sama seperti versi stabil.
                        if not errText:find("Enabled is not a valid member", 1, true) then
                            warn("[AutoParry ArexansTools] " .. errText)
                        end
                    end

                    -- Restore state â€” selalu jalan meski ada error
                    pcall(function()
                        if featureStates.WalkSpeed then
                            hum.WalkSpeed = featureStates.WalkSpeedValue
                        else
                            hum.WalkSpeed = (oldWS < 16) and 16 or oldWS
                        end
                        char:SetAttribute("Crouchingserver", false)
                        game.ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", false)
                    end)

                    if tick() >= (getgenv().ArexansAutoParryActionLockUntil or 0) then
                        getgenv().ParryDebounce = false
                    end
                    getgenv().ArexansAutoParryUsingNow = false
                end)
            end

            if ParryDelay > 0 and not isExtremelyClose then
                task.delay(ParryDelay, executeParry)
            else
                executeParry()
            end

            break -- hanya proses satu killer per frame
        end

        if getgenv().ParryVisualsEnabled then
            updateParryVisual()
        end
    end)
end

function stopAutoParry()
    if parryHeartbeatConn then
        parryHeartbeatConn:Disconnect()
        parryHeartbeatConn = nil
    end
    getgenv().ParryDebounce    = false
    getgenv().ArexansAutoParryUsingNow = false
    getgenv().ArexansAutoParryActionLockUntil = 0
    getgenv().ArexansSmartFaceActiveUntil = 0
    getgenv().NextAllowedParry = 0
    getgenv().ArexansParryVisualCooldownUntil = 0
    stopParryVisualLoop()
    updateParryVisual()
end


---------------------------------------------------
--== AUTO SHOOT SYSTEM ==--
---------------------------------------------------
autoShootRunning = false
lastShootTime = 0
SHOOT_COOLDOWN = 0.3
SHOOT_RANGE = 20

function getShootRemote()
    local success, remotes = pcall(function() return ReplicatedStorage:FindFirstChild("Remotes") end)
    if not success or not remotes then return nil end
    
    local items = remotes:FindFirstChild("Items")
    if items then
        for _, item in ipairs(items:GetChildren()) do
            local name = item.Name:lower()
            if name:find("gun") or name:find("pistol") or name:find("ranged") then
                local shoot = item:FindFirstChild("shoot") or item:FindFirstChild("fire")
                if shoot then return shoot end
            end
        end
    end
    return nil
end

function hasRangedWeapon()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, item in pairs(char:GetChildren()) do
        local name = item.Name:lower()
        if name:find("gun") or name:find("pistol") or name:find("ranged") or name:find("shoot") then
            return true
        end
    end
    return false
end

function startAutoShoot()
    autoShootRunning = true
    local shootRemote = getShootRemote()
    
    task.spawn(function()
        while autoShootRunning and featureStates.AutoShoot do
            task.wait(0.05)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if root and hasRangedWeapon() then
                local now = tick()
                if now - lastShootTime >= SHOOT_COOLDOWN then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and isKiller(plr) then
                            local targetRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                            if targetRoot then
                                local d = (root.Position - targetRoot.Position).Magnitude
                                if d <= SHOOT_RANGE then
                                    if shootRemote then
                                        pcall(function() shootRemote:FireServer() end)
                                        lastShootTime = now
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

function stopAutoShoot()
    autoShootRunning = false
end

---------------------------------------------------
--== KILLER SYSTEMS ==--
---------------------------------------------------
killAllRunning = false
autoAttackRunning = false
noFlashlightRunning = false

function startKillAll()
    killAllRunning = true
    
    local attackRemote = nil
    pcall(function()
        local attacks = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Attacks")
        if attacks then
            attackRemote = attacks:FindFirstChild("BasicAttack")
        end
    end)
    
    task.spawn(function()
        local startCFrame = nil
        
        while killAllRunning and featureStates.KillAll do
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                if not startCFrame then startCFrame = root.CFrame end
                
                for _, plr in ipairs(Players:GetPlayers()) do
                    if not killAllRunning then break end
                    if plr ~= LocalPlayer and plr.Character then
                        local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                        
                        if targetRoot and humanoid and humanoid.Health > 20 then
                            root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
                            if attackRemote then
                                pcall(function() attackRemote:FireServer() end)
                            end
                            task.wait(0.15)
                        end
                    end
                end
                task.wait(0.2)
            else
                task.wait(0.2)
            end
        end
    end)
end

function stopKillAll()
    killAllRunning = false
end

function startAutoAttack()
    autoAttackRunning = true
    
    local attackRemote = nil
    pcall(function()
        local attacks = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Attacks")
        if attacks then
            attackRemote = attacks:FindFirstChild("BasicAttack")
        end
    end)
    
    task.spawn(function()
        while autoAttackRunning and featureStates.AutoAttack do
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        local distToTarget = targetRoot and (root.Position - targetRoot.Position).Magnitude
                        if distToTarget and distToTarget <= 10 and attackRemote then
                            pcall(function() attackRemote:FireServer() end)
                            break
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

function stopAutoAttack()
    autoAttackRunning = false
end

function startNoFlashlight()
    noFlashlightRunning = true
    task.spawn(function()
        while noFlashlightRunning and featureStates.NoFlashlight do
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, descendant in pairs(playerGui:GetDescendants()) do
                    if descendant:IsA("GuiObject") and descendant.Name == "Blind" then
                        pcall(function() descendant:Destroy() end)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

function stopNoFlashlight()
    noFlashlightRunning = false
end

---------------------------------------------------
--== ANTI STUN SYSTEM ==--
---------------------------------------------------
antiStunConnection = nil

function toggleAntiStun(enabled)
    featureStates.AntiStun = enabled
    if enabled then
        if antiStunConnection then antiStunConnection:Disconnect() end
        antiStunConnection = RunService.Heartbeat:Connect(function()
            if not featureStates.AntiStun then
                if antiStunConnection then antiStunConnection:Disconnect() end
                antiStunConnection = nil
                return
            end
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    if humanoid.PlatformStand then humanoid.PlatformStand = false end
                    if humanoid.Sit then humanoid.Sit = false end
                    if humanoid:GetState() == Enum.HumanoidStateType.FallingDown or
                       humanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end
        end)
        safeNotify("AntiStun", "AntiStun activated", 3)
    else
        if antiStunConnection then
            antiStunConnection:Disconnect()
            antiStunConnection = nil
        end
        safeNotify("AntiStun", "AntiStun deactivated", 3)
    end
end

---------------------------------------------------
--== MOBILE FEATURE ICON HELPERS + MOONWALK/ZIGGLE VISUAL SYSTEM ==--
---------------------------------------------------
do
    local ZiggleMoonwalkComboMobileGui = nil
    local ZiggleMoonwalkComboMobileButton = nil
    -- FIX: forward declaration. Tanpa ini, refresh combo membaca global setMobileIconVisible (nil)
    -- karena fungsi refresh dibuat sebelum fungsi setMobileIconVisible didefinisikan.
    local setMobileIconVisible

    local function refreshZiggleMoonwalkComboMobileIcon()
        setMobileIconVisible(ZiggleMoonwalkComboMobileGui, ZiggleMoonwalkComboMobileButton, featureStates.ZiggleMoonwalkComboIconVisible, 3, featureStates.ZiggleMoonwalkCombo)
    end

    local ZiggleMobileGui = nil
    local ZiggleMobileButton = nil
    local MoonwalkMobileGui = nil
    local MoonwalkMobileButton = nil

    local movementVisualConn = nil
    local ziggleSide = 1
    local ziggleLastSwitch = 0
    local ziggleWaveStart = os.clock()
    local ziggleStableLook = nil
    local ziggleLastRoot = nil
    local movementLastRootRotationAt = 0
    local movementLastRootRotationLook = nil
    local ziggleCharacter = nil
    local ziggleOriginalC0 = {}
    local lastHumanoid = nil
    local savedAutoRotate = nil

    -- Ukuran icon dibuat kecil agar mendekati ukuran tombol lari bawaan.
    local MINI_ICON_SIZE = 40
    local DRAG_HOLD_SECONDS = 5
    local manualFeatureIconOffset = Vector2.new(0, 0)
    -- Geser default ketiga icon sedikit ke kiri agar tidak menutupi bar skill/parry.
    local FEATURE_ICON_LEFT_SHIFT = 18
    local holdFeatureToken = 0
    local holdCountdownGui = nil
    local holdCountdownLabel = nil
    local featureDragActive = false
    local featureDragStartPos = nil
    local featureHoldLatestPos = nil
    local featureDragStartOffset = Vector2.new(0, 0)
    local suppressFeatureClickUntil = 0
    local attachedFeatureDragButtons = {}
    local featureDragGlobalHooked = false
    local refreshFeatureMobilePositions
    local setButtonVisual

    -- Optimasi drag: jangan scan semua PlayerGui setiap jari bergerak karena itu bisa bikin freeze.
    local cachedRunButtonRect = nil
    local cachedRunButtonRectAt = 0
    local lockRunButtonRectDuringDrag = nil
    local lastDragUiUpdateAt = 0
    local DRAG_UPDATE_INTERVAL = 1 / 45

    local function inputToVector(input)
        if input and input.Position then
            return Vector2.new(input.Position.X, input.Position.Y)
        end
        local ok, mousePos = pcall(function()
            return UserInputService:GetMouseLocation()
        end)
        if ok and mousePos then
            return Vector2.new(mousePos.X, mousePos.Y)
        end
        return Vector2.new(0, 0)
    end

    local function ensureHoldCountdownGui()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return nil, nil end

        if holdCountdownGui and holdCountdownGui.Parent ~= playerGui then
            holdCountdownGui.Parent = playerGui
        end

        if holdCountdownGui and holdCountdownLabel then
            return holdCountdownGui, holdCountdownLabel
        end

        local oldGui = playerGui:FindFirstChild("ArexansFeatureHoldCountdown")
        if oldGui then oldGui:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "ArexansFeatureHoldCountdown"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 1000000
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = playerGui

        local label = Instance.new("TextLabel")
        label.Name = "Countdown"
        label.Size = UDim2.fromOffset(210, 44)
        label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        label.BackgroundTransparency = 0.18
        label.BorderSizePixel = 0
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.TextStrokeTransparency = 0.2
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Visible = false
        label.ZIndex = 1000000
        label.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = label

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.5
        stroke.Transparency = 0.08
        stroke.Color = Color3.fromRGB(0, 191, 255)
        stroke.Parent = label

        holdCountdownGui = gui
        holdCountdownLabel = label
        return gui, label
    end

    local function showHoldCountdown(button, second)
        local _, label = ensureHoldCountdownGui()
        if not label then return end

        local camera = workspace.CurrentCamera
        local screenSize = camera and camera.ViewportSize or Vector2.new(1536, 681)
        local labelW, labelH = 210, 44
        local x, y = 8, 8

        pcall(function()
            local absPos = button.AbsolutePosition
            local absSize = button.AbsoluteSize
            x = absPos.X + (absSize.X * 0.5) - (labelW * 0.5)
            y = absPos.Y - labelH - 8
            if y < 8 then
                y = absPos.Y + absSize.Y + 8
            end
        end)

        x = math.clamp(math.floor(x + 0.5), 8, math.max(8, screenSize.X - labelW - 8))
        y = math.clamp(math.floor(y + 0.5), 8, math.max(8, screenSize.Y - labelH - 8))

        label.Position = UDim2.fromOffset(x, y)
        label.Text = "Tahan " .. tostring(second) .. " / " .. tostring(DRAG_HOLD_SECONDS) .. " detik"
        label.Visible = true
    end

    local function showDragReady(button)
        local _, label = ensureHoldCountdownGui()
        if not label then return end
        showHoldCountdown(button, DRAG_HOLD_SECONDS)
        label.Text = "Geser sekarang"
    end

    local function hideHoldCountdown()
        if holdCountdownLabel then
            holdCountdownLabel.Visible = false
        end
    end

    local function isMoveInput(input)
        if not input then return false end
        return input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.MouseButton1
    end

    getgenv().ArexansShouldSuppressFeatureIconClick = function()
        return os.clock() < suppressFeatureClickUntil
    end

    getgenv().ArexansAttachLongPressDragToFeatureButton = function(button)
        if not button or attachedFeatureDragButtons[button] then return end
        attachedFeatureDragButtons[button] = true

        if not featureDragGlobalHooked then
            featureDragGlobalHooked = true

            UserInputService.InputChanged:Connect(function(input)
                if not isMoveInput(input) then return end
                local currentPos = inputToVector(input)
                featureHoldLatestPos = currentPos
                if not featureDragActive then return end

                -- Smooth drag: update UI dibatasi Â±45 FPS dan posisi tombol lari dikunci saat drag.
                -- Ini menghindari lag/freeze karena tidak scan PlayerGui ratusan kali per detik.
                local now = os.clock()
                if (now - lastDragUiUpdateAt) < DRAG_UPDATE_INTERVAL then
                    return
                end
                lastDragUiUpdateAt = now

                manualFeatureIconOffset = featureDragStartOffset + (currentPos - featureDragStartPos)
                if refreshFeatureMobilePositions then
                    refreshFeatureMobilePositions()
                end
                suppressFeatureClickUntil = now + 1.25
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return
                end

                holdFeatureToken = holdFeatureToken + 1
                hideHoldCountdown()
                if featureDragActive then
                    suppressFeatureClickUntil = os.clock() + 1.25
                end
                featureDragActive = false
                featureHoldLatestPos = nil
                lockRunButtonRectDuringDrag = nil

                task.defer(function()
                    if refreshFeatureMobilePositions then
                        refreshFeatureMobilePositions()
                    end
                    if setButtonVisual then
                        if ZiggleMobileButton then setButtonVisual(ZiggleMobileButton, featureStates.Ziggle) end
                        if MoonwalkMobileButton then setButtonVisual(MoonwalkMobileButton, featureStates.MoonWalk) end
                        if ZiggleMoonwalkComboMobileButton then setButtonVisual(ZiggleMoonwalkComboMobileButton, featureStates.ZiggleMoonwalkCombo) end
                    end
                end)
            end)
        end

        button.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return
            end

            holdFeatureToken = holdFeatureToken + 1
            local myToken = holdFeatureToken
            featureDragActive = false
            featureDragStartPos = inputToVector(input)
            featureHoldLatestPos = featureDragStartPos
            featureDragStartOffset = manualFeatureIconOffset

            task.spawn(function()
                -- Countdown jangan langsung muncul saat hanya tap/klik biasa.
                -- Label baru muncul setelah jari/mouse benar-benar ditahan 1 detik,
                -- jadi tap singkat tetap terasa seperti klik ON/OFF tanpa visual 1/5.
                for second = 1, DRAG_HOLD_SECONDS do
                    task.wait(1)
                    if myToken ~= holdFeatureToken then
                        hideHoldCountdown()
                        return
                    end
                    showHoldCountdown(button, second)
                end

                if myToken ~= holdFeatureToken then
                    hideHoldCountdown()
                    return
                end

                lockRunButtonRectDuringDrag = cachedRunButtonRect
                featureDragActive = true
                lastDragUiUpdateAt = 0
                suppressFeatureClickUntil = os.clock() + 2
                featureDragStartPos = featureHoldLatestPos or inputToVector(input)
                featureDragStartOffset = manualFeatureIconOffset
                showDragReady(button)

                pcall(function()
                    local stroke = button:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        stroke.Thickness = 2
                        stroke.Transparency = 0
                    end
                end)
            end)
        end)

        button.InputChanged:Connect(function(input)
            if not isMoveInput(input) then return end
            -- Jangan update posisi dari sini karena sudah ditangani global InputChanged.
            -- Kalau dua handler sama-sama menggeser icon, HP bisa lag/freeze.
            featureHoldLatestPos = inputToVector(input)
        end)

        button.InputEnded:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return
            end

            holdFeatureToken = holdFeatureToken + 1
            hideHoldCountdown()
            if featureDragActive then
                suppressFeatureClickUntil = os.clock() + 1.25
            end
            featureDragActive = false
            featureHoldLatestPos = nil
            lockRunButtonRectDuringDrag = nil

            -- Kembalikan visual stroke sesuai status aktif/tidak aktif.
            task.defer(function()
                if refreshFeatureMobilePositions then
                    refreshFeatureMobilePositions()
                end
                if ZiggleMobileButton then setButtonVisual(ZiggleMobileButton, featureStates.Ziggle) end
                if MoonwalkMobileButton then setButtonVisual(MoonwalkMobileButton, featureStates.MoonWalk) end
                if ZiggleMoonwalkComboMobileButton then setButtonVisual(ZiggleMoonwalkComboMobileButton, featureStates.ZiggleMoonwalkCombo) end
            end)
        end)
    end

    local function isTouchDevice()
        -- Selalu kembalikan true agar user di PC juga bisa menggunakan icon mobile 
        -- jika mereka menginginkannya (atau menggunakan emulator yang tidak terbaca touch).
        return true
    end

    setButtonVisual = function(button, active)
        if not button then return end
        pcall(function()
            button.Size = UDim2.fromOffset(MINI_ICON_SIZE, MINI_ICON_SIZE)
            button.ImageTransparency = active and 0 or 0.12
            button.BackgroundTransparency = active and 0.22 or 0.55
            local stroke = button:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Thickness = active and 1.15 or 0.75
                stroke.Transparency = active and 0.08 or 0.55
                stroke.Color = active and Color3.fromRGB(0, 191, 255) or Color3.fromRGB(150, 150, 150)
            end
        end)
    end

    setMobileIconVisible = function(gui, button, visible, orderIndex, visualActive)
        visible = visible == true
        visualActive = visualActive == true
        if gui then
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                gui.ResetOnSpawn = false
                if playerGui and gui.Parent ~= playerGui then
                    gui.Parent = playerGui
                end
                gui.Enabled = isTouchDevice() and visible
            end)
        end
        if button then
            button.Visible = visible
            -- Visual aktif mengikuti status fitur, bukan status tampil/sembunyi icon.
            setButtonVisual(button, visualActive)
            if visible and getgenv().ArexansPositionFeatureButtonNearSkill then
                getgenv().ArexansPositionFeatureButtonNearSkill(button, orderIndex)
            end
        end
    end

    local function refreshZiggleMobileIcon()
        setMobileIconVisible(ZiggleMobileGui, ZiggleMobileButton, featureStates.ZiggleIconVisible, 1, featureStates.Ziggle)
    end

    local function refreshMoonwalkMobileIcon()
        setMobileIconVisible(MoonwalkMobileGui, MoonwalkMobileButton, featureStates.MoonWalkIconVisible, 2, featureStates.MoonWalk)
    end

    local function findZiggleMotors(character)
        local motors = {}
        if not character then return motors end

        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("Motor6D") then
                local name = string.lower(obj.Name or "")
                -- R6: RootJoint. R15: Root + Waist.
                -- Motor ini hanya untuk efek badan/torso, bukan untuk menggeser posisi player.
                if name == "rootjoint" or name == "root" or name == "waist" then
                    table.insert(motors, obj)
                end
            end
        end

        -- Fallback rig custom: ambil motor torso/root yang paling dekat dengan HRP.
        if #motors == 0 then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            for _, obj in ipairs(character:GetDescendants()) do
                if obj:IsA("Motor6D") and (obj.Part0 == rootPart or obj.Part1 == rootPart) then
                    table.insert(motors, obj)
                    break
                end
            end
        end

        return motors
    end

    local function resetZiggleBody()
        for motor, originalC0 in pairs(ziggleOriginalC0) do
            pcall(function()
                if motor and motor.Parent and originalC0 then
                    motor.C0 = originalC0
                end
            end)
        end
        ziggleOriginalC0 = {}
        ziggleCharacter = nil
        ziggleStableLook = nil
        ziggleLastRoot = nil
        movementLastRootRotationAt = 0
        movementLastRootRotationLook = nil
        ziggleWaveStart = os.clock()
    end

    local function getZiggleMotorsWithOriginals(character)
        if ziggleCharacter ~= character then
            resetZiggleBody()
            ziggleCharacter = character
        end

        local motors = findZiggleMotors(character)
        for _, motor in ipairs(motors) do
            if motor and motor.Parent and not ziggleOriginalC0[motor] then
                ziggleOriginalC0[motor] = motor.C0
            end
        end
        return motors
    end

    getgenv().ArexansSetFeatureMobileIconRefs = function(zGui, zButton, mGui, mButton, cGui, cButton)
        ZiggleMoonwalkComboMobileGui = cGui
        ZiggleMoonwalkComboMobileButton = cButton
        refreshZiggleMoonwalkComboMobileIcon()
        ZiggleMobileGui = zGui
        ZiggleMobileButton = zButton
        MoonwalkMobileGui = mGui
        MoonwalkMobileButton = mButton

        -- Icon tidak langsung muncul saat execute. Toggle window hanya mengatur icon tampil/sembunyi.
        refreshZiggleMobileIcon()
        refreshMoonwalkMobileIcon()
    end

    getgenv().ArexansIsInsideFeatureMobileGui = function(obj)
        if ZiggleMobileGui and obj:IsDescendantOf(ZiggleMobileGui) then return true end
        if MoonwalkMobileGui and obj:IsDescendantOf(MoonwalkMobileGui) then return true end
        if ZiggleMoonwalkComboMobileGui and obj:IsDescendantOf(ZiggleMoonwalkComboMobileGui) then return true end
        return false
    end

    getgenv().ArexansPositionFeatureButtonNearSkill = function(button, orderIndex)
        if not button then return end

        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local camera = workspace.CurrentCamera
        if not playerGui or not camera then return end

        local screenSize = camera.ViewportSize
        local sizePx = MINI_ICON_SIZE
        pcall(function()
            local absSize = button.AbsoluteSize
            if absSize.X > 0 then sizePx = math.clamp(math.floor(absSize.X), 34, 44) end
        end)

        local function makeRect(x, y, w, h)
            return {x = x, y = y, w = w, h = h}
        end

        local function findRunButtonRect()
            -- Saat drag aktif, pakai posisi tombol lari yang sudah dikunci.
            -- Ini bagian paling penting agar geser icon tidak freeze.
            if featureDragActive and lockRunButtonRectDuringDrag then
                return lockRunButtonRectDuringDrag
            end

            local now = os.clock()
            if cachedRunButtonRect and (now - cachedRunButtonRectAt) < 1.25 then
                return cachedRunButtonRect
            end

            local fallbackCx = screenSize.X * 0.75
            local fallbackCy = screenSize.Y * 0.80
            local bestRect = nil
            local bestScore = -math.huge

            pcall(function()
                for _, obj in ipairs(playerGui:GetDescendants()) do
                    if obj:IsA("GuiObject")
                        and obj.Visible
                        and obj ~= button
                        and not getgenv().ArexansIsInsideFeatureMobileGui(obj) then

                        local absPos = obj.AbsolutePosition
                        local absSize = obj.AbsoluteSize
                        local w, h = absSize.X, absSize.Y
                        local cx, cy = absPos.X + (w * 0.5), absPos.Y + (h * 0.5)

                        -- Cari tombol lari/sprint di area kanan-bawah/tengah, tapi hindari tombol atas/menu.
                        local validSize = w >= 30 and h >= 30 and w <= 150 and h <= 150
                        local validArea = cx >= (screenSize.X * 0.48) and cy >= (screenSize.Y * 0.42)
                        if validSize and validArea then
                            local lowerName = ((obj.Name or "") .. " " .. (obj.Parent and obj.Parent.Name or "")):lower()
                            local dx, dy = cx - fallbackCx, cy - fallbackCy
                            local dist = math.sqrt(dx * dx + dy * dy)
                            local score = 0

                            if lowerName:find("run") or lowerName:find("sprint") or lowerName:find("lari") then
                                score = score + 1000
                            end
                            if lowerName:find("speed") or lowerName:find("stamina") or lowerName:find("move") then
                                score = score + 180
                            end
                            if obj:IsA("ImageButton") or obj:IsA("TextButton") then
                                score = score + 120
                            end
                            if lowerName:find("jump") or lowerName:find("chat") or lowerName:find("menu") or lowerName:find("backpack") then
                                score = score - 400
                            end

                            -- Fallback bila nama tombol lari tidak terbaca: ambil tombol yang paling dekat
                            -- dengan posisi umum tombol lari pada layar landscape Roblox mobile.
                            if dist < 260 then
                                score = score + (260 - dist)
                            else
                                score = score - dist
                            end

                            if score > bestScore then
                                bestScore = score
                                bestRect = makeRect(absPos.X, absPos.Y, w, h)
                            end
                        end
                    end
                end
            end)

            if not bestRect then
                -- Fallback tetap dicache supaya saat drag tidak mencoba scan PlayerGui terus-menerus.
                bestRect = makeRect(fallbackCx - 28, fallbackCy - 28, 56, 56)
            end

            cachedRunButtonRect = bestRect
            cachedRunButtonRectAt = now

            return bestRect
        end

        local runRect = findRunButtonRect()
        local runCx, runCy, runW, runH
        if runRect then
            runCx = runRect.x + (runRect.w * 0.5)
            runCy = runRect.y + (runRect.h * 0.5)
            runW = runRect.w
            runH = runRect.h
        else
            -- Fallback dari posisi tombol lari di screenshot: kanan-tengah bagian bawah.
            runCx = screenSize.X * 0.75
            runCy = screenSize.Y * 0.80
            runW = 56
            runH = 56
        end

        -- Susunan setengah lingkaran di kiri tombol lari:
        -- tombol lari tetap jadi pusat, 3 icon fitur mengikuti lengkungan rapat di sisinya.
        local idx = math.clamp(orderIndex or 1, 1, 3)
        local runRadius = math.max(runW, runH) * 0.5
        local iconRadius = sizePx * 0.5
        local radius = runRadius + iconRadius + 4 -- celah tipis dari tombol lari
        local angles = {230, 180, 130}
        local angle = math.rad(angles[idx] or 180)

        local centerX = runCx + (math.cos(angle) * radius) + manualFeatureIconOffset.X - FEATURE_ICON_LEFT_SHIFT
        local centerY = runCy + (math.sin(angle) * radius) + manualFeatureIconOffset.Y
        local x = centerX - iconRadius
        local y = centerY - iconRadius

        x = math.clamp(math.floor(x + 0.5), 8, math.max(8, screenSize.X - sizePx - 8))
        y = math.clamp(math.floor(y + 0.5), 8, math.max(8, screenSize.Y - sizePx - 8))

        button.AnchorPoint = Vector2.new(0, 0)
        button.Size = UDim2.fromOffset(sizePx, sizePx)
        button.Position = UDim2.fromOffset(x, y)
    end

    refreshFeatureMobilePositions = function()
        if getgenv().ArexansPositionFeatureButtonNearSkill then
            if ZiggleMobileButton and featureStates.ZiggleIconVisible then
                getgenv().ArexansPositionFeatureButtonNearSkill(ZiggleMobileButton, 1)
            end
            if MoonwalkMobileButton and featureStates.MoonWalkIconVisible then
                getgenv().ArexansPositionFeatureButtonNearSkill(MoonwalkMobileButton, 2)
            end
            if ZiggleMoonwalkComboMobileButton and featureStates.ZiggleMoonwalkComboIconVisible then
                getgenv().ArexansPositionFeatureButtonNearSkill(ZiggleMoonwalkComboMobileButton, 3)
            end

        end
    end

    task.spawn(function()
        while true do
            task.wait(2.5)
            if featureStates.ZiggleIconVisible or featureStates.MoonWalkIconVisible or featureStates.ZiggleMoonwalkComboIconVisible then
                -- Re-enable/re-parent icon script setelah cutscene, respawn, round transition, atau teleport.
                refreshZiggleMobileIcon()
                refreshMoonwalkMobileIcon()
                refreshFeatureMobilePositions()
            end
        end
    end)


    getgenv().ArexansRefreshZiggleMoonwalkComboMobileIcon = refreshZiggleMoonwalkComboMobileIcon

    getgenv().ArexansSetZiggleMoonwalkComboMobileIconVisible = function(visible)
        featureStates.ZiggleMoonwalkComboIconVisible = visible == true
        refreshZiggleMoonwalkComboMobileIcon()
    end

    getgenv().ArexansRefreshZiggleMobileIcon = refreshZiggleMobileIcon
    getgenv().ArexansRefreshMoonwalkMobileIcon = refreshMoonwalkMobileIcon

    getgenv().ArexansSetZiggleMobileIconVisible = function(visible)
        -- Toggle window hanya tampil/sembunyi icon; tidak mengaktifkan/menonaktifkan fitur.
        featureStates.ZiggleIconVisible = visible == true
        refreshZiggleMobileIcon()
    end

    getgenv().ArexansSetMoonwalkMobileIconVisible = function(visible)
        -- Toggle window hanya tampil/sembunyi icon; tidak mengaktifkan/menonaktifkan fitur.
        featureStates.MoonWalkIconVisible = visible == true
        refreshMoonwalkMobileIcon()
    end

    local function restoreAutoRotateIfNeeded()
        if lastHumanoid and lastHumanoid.Parent then
            pcall(function()
                if not featureStates.MoonWalk and not featureStates.Ziggle then
                    lastHumanoid.AutoRotate = savedAutoRotate ~= nil and savedAutoRotate or true
                end
            end)
        end
        if not featureStates.MoonWalk and not featureStates.Ziggle then
            lastHumanoid = nil
            savedAutoRotate = nil
        end
    end

    local ZIGGLE_MODE_PRESETS = {
        -- speed dipakai sebagai tempo gelombang halus. Preset hanya mengubah nilai awal speed/power.
        -- Slider tetap boleh diubah manual; pilih mode lain untuk reset speed sesuai preset.
        ["Santai"] = {speed = 12, power = 0.65, yaw = 14, roll = 6, speedDivisor = 10, minHz = 0.30, maxHz = 4.00},
        ["Sedang"] = {speed = 24, power = 1.15, yaw = 18, roll = 12, speedDivisor = 9.5, minHz = 0.45, maxHz = 5.00},
        ["Pro"] = {speed = 40, power = 1.55, yaw = 26, roll = 16, speedDivisor = 9, minHz = 0.60, maxHz = 6.50},
        ["Brutal"] = {speed = 60, power = 2.10, yaw = 34, roll = 20, speedDivisor = 8, minHz = 0.75, maxHz = 8.00},
    }

    local function getZigglePreset()
        local mode = tostring(featureStates.ZiggleMode or "Pro")
        return ZIGGLE_MODE_PRESETS[mode] or ZIGGLE_MODE_PRESETS["Pro"]
    end

    local function syncZiggleValuesFromMode()
        local preset = getZigglePreset()
        featureStates.ZigglePower = tonumber(featureStates.ZigglePower) or preset.power
        featureStates.ZiggleSpeed = tonumber(featureStates.ZiggleSpeed) or preset.speed
        return preset
    end

    local function getSmoothZiggleSide(now, preset)
        local rawSpeed = math.clamp(tonumber(featureStates.ZiggleSpeed) or preset.speed or 12, 2, 120)
        local divisor = tonumber(preset.speedDivisor) or 10
        local minHz = tonumber(preset.minHz) or 0.30
        local maxHz = tonumber(preset.maxHz) or 1.50
        local hz = math.clamp(rawSpeed / divisor, minHz, maxHz)

        -- Sine wave membuat transisi kanan-kiri lembut. Tidak ada flip instan yang bikin getar.
        local side = math.sin((now - ziggleWaveStart) * math.pi * 2 * hz)
        if math.abs(side) < 0.015 then side = 0 end
        return side
    end

    local function getNearestKillerRoot(maxDistance)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end

        local closestRoot = nil
        local closestDistance = math.min(tonumber(maxDistance) or 25, 25)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local ok, killer = pcall(function()
                    local teamName = plr.Team and plr.Team.Name and plr.Team.Name:lower() or ""
                    if teamName:find("killer") then return true end
                    if teamName:find("survivor") then return false end
                    return isKiller(plr)
                end)
                if ok and killer and plr.Character then
                    local killerRoot = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChildWhichIsA("BasePart")
                    if killerRoot then
                        local d = (root.Position - killerRoot.Position).Magnitude
                        if d <= closestDistance then
                            closestDistance = d
                            closestRoot = killerRoot
                        end
                    end
                end
            end
        end
        return closestRoot
    end

    local function applyZiggleBody(character, side)
        local preset = getZigglePreset()
        local power = math.clamp(tonumber(featureStates.ZigglePower) or preset.power or 1.15, 0.25, 2.5)
        local roll = math.rad((preset.roll or 13) * power) * side
        local yaw = math.rad(6 * power) * side
        local motors = getZiggleMotorsWithOriginals(character)

        for _, motor in ipairs(motors) do
            local originalC0 = ziggleOriginalC0[motor]
            if motor and motor.Parent and originalC0 then
                local name = string.lower(motor.Name or "")
                local offset
                if name == "waist" then
                    offset = CFrame.Angles(0, -yaw * 0.55, roll * 0.70)
                else
                    offset = CFrame.Angles(0, yaw * 0.45, -roll * 0.45)
                end
                pcall(function()
                    motor.C0 = originalC0 * offset
                end)
            end
        end
    end

    local function ensureMovementVisualLoop()
        if movementVisualConn then return end

        ziggleSide = 1
        ziggleLastSwitch = os.clock()
        ziggleWaveStart = os.clock()
        ziggleStableLook = nil
        ziggleLastRoot = nil
        movementLastRootRotationAt = 0
        movementLastRootRotationLook = nil

        movementVisualConn = RunService.RenderStepped:Connect(function()
            if not featureStates.MoonWalk and not featureStates.Ziggle then
                if movementVisualConn then
                    movementVisualConn:Disconnect()
                    movementVisualConn = nil
                end
                resetZiggleBody()
                restoreAutoRotateIfNeeded()
                return
            end

            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not char or not humanoid or not root or humanoid.Health <= 0 then
                resetZiggleBody()
                return
            end

            if char:GetAttribute("Knocked") or char:GetAttribute("IsCarried") or char:GetAttribute("IsHooked") or char:GetAttribute("Crouchingserver") then
                if getgenv().ArexansToggleZiggle then getgenv().ArexansToggleZiggle(false) end
                if getgenv().ArexansToggleMoonwalk then getgenv().ArexansToggleMoonwalk(false) end
                if getgenv().ArexansToggleZiggleMoonwalkCombo then getgenv().ArexansToggleZiggleMoonwalkCombo(false) end
                resetZiggleBody()
                return
            end

            if lastHumanoid ~= humanoid then
                if lastHumanoid and lastHumanoid.Parent and savedAutoRotate ~= nil then
                    pcall(function() lastHumanoid.AutoRotate = savedAutoRotate end)
                end
                lastHumanoid = humanoid
                savedAutoRotate = humanoid.AutoRotate
            end

            -- MoonWalk/AutoFace memang perlu mengatur arah badan.
            -- Pure Ziggle tidak lagi mematikan AutoRotate agar gerak normal tidak rubberband.
            local allowRootRotation = featureStates.MoonWalk == true
                or (featureStates.Ziggle == true
                    and featureStates.ZiggleAutoFaceKiller == true
                    and not SmartFace
                    and not featureStates.AutoParry
                    and not getgenv().ParryDebounce)

            if allowRootRotation then
                humanoid.AutoRotate = false
            else
                humanoid.AutoRotate = savedAutoRotate ~= nil and savedAutoRotate or true
            end

            if ziggleLastRoot ~= root then
                ziggleLastRoot = root
                ziggleStableLook = nil
                ziggleWaveStart = os.clock()
            end

            local moveDir = humanoid.MoveDirection
            local flatLook = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
            if flatLook.Magnitude < 0.05 then flatLook = Vector3.new(0, 0, -1) end

            local baseLook = flatLook.Unit
            if moveDir.Magnitude > 0.05 then
                if featureStates.MoonWalk then
                    baseLook = Vector3.new(-moveDir.X, 0, -moveDir.Z).Unit
                else
                    baseLook = Vector3.new(moveDir.X, 0, moveDir.Z).Unit
                end
                ziggleStableLook = baseLook
            elseif featureStates.Ziggle then
                -- Saat diam, jangan ambil LookVector yang sudah kena yaw ziggle.
                -- Ini mencegah feedback loop yang bikin badan bergetar/spin kecil.
                if not ziggleStableLook or ziggleStableLook.Magnitude < 0.05 then
                    ziggleStableLook = flatLook.Unit
                end
                baseLook = ziggleStableLook
            end

            local yawOffset = 0
            if featureStates.Ziggle then
                local now = os.clock()
                local preset = syncZiggleValuesFromMode()
                local smoothSide = getSmoothZiggleSide(now, preset)
                ziggleSide = smoothSide

                local power = math.clamp(tonumber(featureStates.ZigglePower) or preset.power or 1.15, 0.25, 2.5)
                -- Ziggle halus kanan-kiri: orientasi saja, tidak menggeser posisi karakter.
                yawOffset = math.rad((preset.yaw or 18) * power) * smoothSide
                applyZiggleBody(char, smoothSide)

                -- Jangan biarkan Ziggle Auto Face mengambil alih arah badan saat Auto Parry aktif/cooldown.
                -- Arah ke killer untuk parry hanya dilakukan oleh SmartFace di executeParry().
                if featureStates.ZiggleAutoFaceKiller and not SmartFace and not featureStates.AutoParry and not getgenv().ParryDebounce then
                    local killerRoot = getNearestKillerRoot(featureStates.ZiggleAutoFaceDistance or 25)
                    if killerRoot then
                        local killerLook = Vector3.new(killerRoot.Position.X - root.Position.X, 0, killerRoot.Position.Z - root.Position.Z)
                        if killerLook.Magnitude > 0.05 then
                            baseLook = killerLook.Unit
                            ziggleStableLook = baseLook
                        end
                    end
                end
            else
                resetZiggleBody()
            end

            if allowRootRotation and baseLook.Magnitude > 0.05 then
                local nowRotate = os.clock()
                local rotateInterval = math.max(0, tonumber(getgenv().ArexansMovementRotationInterval) or (1 / 30))

                if rotateInterval <= 0 or (nowRotate - movementLastRootRotationAt) >= rotateInterval then
                    movementLastRootRotationAt = nowRotate

                    local cleanLook = Vector3.new(baseLook.X, 0, baseLook.Z)
                    if cleanLook.Magnitude > 0.05 then
                        cleanLook = cleanLook.Unit
                        movementLastRootRotationLook = cleanLook

                        local target = CFrame.lookAt(root.Position, root.Position + cleanLook)

                        -- Mode aman tidak menambahkan yaw Ziggle ke HumanoidRootPart.
                        -- Ziggle tetap terlihat dari Motor6D, sementara posisi root tidak terus dipaksa.
                        local safeRotation = getgenv().ArexansSafeMovementRotation ~= false
                        local strength = math.clamp(tonumber(getgenv().ArexansMovementRotationLerp) or 0.32, 0.08, 1)
                        if not safeRotation and featureStates.Ziggle then
                            target = target * CFrame.Angles(0, yawOffset, 0)
                            strength = 1
                        end

                        pcall(function()
                            if strength >= 0.99 then
                                root.CFrame = target
                            else
                                root.CFrame = root.CFrame:Lerp(target, strength)
                            end
                            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end)
                    end
                end
            end
        end)
    end

    getgenv().ArexansToggleZiggle = function(enable)
        -- Fungsi ini hanya dipanggil dari icon layar untuk ON/OFF fitur Ziggle.
        enable = enable == true
        featureStates.Ziggle = enable

        if enable then
            ensureMovementVisualLoop()
            safeNotify("Ziggle", "Ziggle body activated", 3)
        else
            resetZiggleBody()
            restoreAutoRotateIfNeeded()
            safeNotify("Ziggle", "Ziggle body deactivated", 3)
        end

        refreshZiggleMobileIcon()
    end

    
    getgenv().ArexansToggleZiggleMoonwalkCombo = function(enable)
        enable = enable == true
        featureStates.ZiggleMoonwalkCombo = enable
        if getgenv().ArexansToggleZiggle then getgenv().ArexansToggleZiggle(enable) end
        if getgenv().ArexansToggleMoonwalk then getgenv().ArexansToggleMoonwalk(enable) end
        if getgenv().ArexansRefreshZiggleMoonwalkComboMobileIcon then
            getgenv().ArexansRefreshZiggleMoonwalkComboMobileIcon()
        end
    end

    getgenv().ArexansToggleMoonwalk = function(enable)
        -- Fungsi ini hanya dipanggil dari icon layar untuk ON/OFF fitur MoonWalk.
        enable = enable == true
        featureStates.MoonWalk = enable

        if enable then
            ensureMovementVisualLoop()
            safeNotify("MoonWalk", "MoonWalk activated", 3)
        else
            restoreAutoRotateIfNeeded()
            safeNotify("MoonWalk", "MoonWalk deactivated", 3)
        end

        refreshMoonwalkMobileIcon()
    end
end

---------------------------------------------------
--== MOONWALK SYSTEM ==--
---------------------------------------------------
function toggleMoonwalk(enable)
    if getgenv().ArexansToggleMoonwalk then
        getgenv().ArexansToggleMoonwalk(enable)
    end
end

---------------------------------------------------
--== THE VEIL AIMBOT SYSTEM ==--
---------------------------------------------------
VeilAimbotEnabled = false
VeilAimbotChargeEnabled = false
VeilPredictionTime = 0.14
VeilMinDistance = 1
VeilMaxDistance = 250
VeilMinPitch = -1
VeilMaxPitch = 30
VeilLowHPIgnore = 20
VeilToughWall = true

function VeilGetLocalRoot()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

function VeilHPOK(plr)
    local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
    return hum and hum.Health > VeilLowHPIgnore
end

function VeilGetClosestInScreen()
    local closest = nil
    local minDist = math.huge
    local mouse = UserInputService:GetMouseLocation()
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and VeilHPOK(plr) then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = plr
                    end
                end
            end
        end
    end
    return closest
end

function VeilGetClosestByDistance()
    local root = VeilGetLocalRoot()
    if not root then return nil end
    local closest, distMin = nil, math.huge
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and VeilHPOK(plr) then
            local r = plr.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local d = (root.Position - r.Position).Magnitude
                if d < distMin then
                    distMin = d
                    closest = plr
                end
            end
        end
    end
    return closest, distMin
end

function VeilGetChargeSoftTarget()
    local root = VeilGetLocalRoot()
    if not root or not Camera then return nil end

    local vp = Camera.ViewportSize
    local aimPoint2D
    if UserInputService.TouchEnabled then
        aimPoint2D = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    else
        local ok, mouse = pcall(function() return UserInputService:GetMouseLocation() end)
        aimPoint2D = ok and mouse or Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    end

    local best, bestScore = nil, math.huge
    local looseRadius = math.max(190, math.min(vp.X, vp.Y) * 0.42)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and VeilHPOK(plr) then
            local head = plr.Character:FindFirstChild("Head")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if head and hrp then
                local screen, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen and screen.Z > 0 then
                    local screenDist = (Vector2.new(screen.X, screen.Y) - aimPoint2D).Magnitude
                    local worldDist = (root.Position - hrp.Position).Magnitude
                    local viewDir = (head.Position - Camera.CFrame.Position)
                    local anglePenalty = 0
                    if viewDir.Magnitude > 0.1 then
                        local dot = math.clamp(Camera.CFrame.LookVector:Dot(viewDir.Unit), -1, 1)
                        anglePenalty = (1 - dot) * 165
                    end

                    if screenDist <= looseRadius or anglePenalty < 92 then
                        local score = screenDist + worldDist * 0.085 + anglePenalty

                        -- Bias target lama dibuat kecil saja, supaya aim gampang pindah ketika kamera digeser.
                        if VeilChargeLastTarget == plr then
                            score -= 8
                        end

                        if score < bestScore then
                            bestScore = score
                            best = plr
                        end
                    end
                end
            end
        end
    end

    VeilChargeLastTarget = best
    VeilChargeLastTargetTime = tick()
    return best
end

function VeilCanSeeTarget(target)
    if VeilToughWall then return true end
    local head = target.Character and target.Character:FindFirstChild("Head")
    local root = VeilGetLocalRoot()
    if not head or not root then return false end
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { LocalPlayer.Character or {}, target.Character }
    local result = workspace:Raycast(root.Position + Vector3.new(0, 2, 0), head.Position - root.Position, params)
    return not result
end

function VeilGetAutoPitchMax(distance)
    if distance >= 190 and distance <= 300 then return 45.5
    elseif distance >= 150 and distance <= 185 then return 40.5
    elseif distance >= 90 and distance <= 145 then return 36.5
    else return 30.5 end
end

function VeilGetPitchByDistance(dist)
    if dist < 1 then return 0.09
    elseif dist < 10 then return 0.90
    elseif dist < 20 then return 1.9
    elseif dist < 30 then return 2.9
    elseif dist < 40 then return 3.9
    elseif dist < 50 then return 4.9
    elseif dist < 60 then return 5.9
    elseif dist < 70 then return 6.9
    elseif dist < 80 then return 7.9
    elseif dist < 90 then return 8.9
    elseif dist < 100 then return 10.9
    elseif dist < 110 then return 11.9
    elseif dist < 120 then return 12.9
    elseif dist < 130 then return 13.9
    elseif dist < 140 then return 14.9
    elseif dist < 150 then return 15.9
    elseif dist < 160 then return 16.9
    elseif dist < 170 then return 17.9
    elseif dist < 180 then return 18.9
    elseif dist < 190 then return 20.3
    elseif dist < 200 then return 22.3
    else return 23.3 end
end

-- Smart charge aim dibuat lebih lembut dan mengikuti parabola tombak, bukan aim lurus seperti senjata api.
VeilChargeAimStrength = 0.068
VeilChargeManualUntil = 0
VeilChargeLastTarget = nil
VeilChargeLastTargetTime = 0

function VeilChargeSkyClear(origin, lookDir)
    if not origin or not lookDir then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.IgnoreWater = true
    params.FilterDescendantsInstances = { LocalPlayer.Character or {} }

    local upHit = workspace:Raycast(origin, Vector3.new(0, 92, 0), params)
    if upHit then return false end

    local forwardUp = (lookDir.Unit * 75) + Vector3.new(0, 46, 0)
    local frontHit = workspace:Raycast(origin, forwardUp, params)
    return frontHit == nil
end

function VeilGetSpearChargeAlphaApprox()
    local a = tonumber(getgenv().ArexansVeilSpearChargeAlpha)
    if a then return math.clamp(a, 0, 1) end
    return 0.62
end

function VeilGetSpearSpeedApprox()
    local minSpd = 120
    local maxSpd = 850
    pcall(function()
        if featureStates then
            minSpd = tonumber(featureStates.SpearMinSpeed) or minSpd
            maxSpd = tonumber(featureStates.SpearMaxSpeed) or maxSpd
        end
    end)
    minSpd = math.clamp(minSpd, 60, 320)
    maxSpd = math.clamp(maxSpd, minSpd, 1400)
    local chargeT = VeilGetSpearChargeAlphaApprox()
    return minSpd + (maxSpd - minSpd) * chargeT, chargeT
end

function VeilGetSpearGravityApprox()
    local scale = tonumber(getgenv().ArexansVeilSpearGravityScale) or 0.34
    return math.abs(workspace.Gravity ~= 0 and workspace.Gravity or 196.2) * scale
end

function VeilComputeArcAimPoint(fromPos, targetPos, targetVelocity)
    if not fromPos or not targetPos then return targetPos end
    local speed, chargeT = VeilGetSpearSpeedApprox()
    local gravity = VeilGetSpearGravityApprox()
    targetVelocity = targetVelocity or Vector3.new(0, 0, 0)

    local delta = targetPos - fromPos
    local flat = Vector3.new(delta.X, 0, delta.Z)
    local flatDist = flat.Magnitude
    if flatDist <= 0.1 then return targetPos end

    -- Waktu terbang mengikuti speed charge. Charge kecil = lebih jatuh/melengkung.
    local travelTime = math.clamp(flatDist / math.max(speed * 0.84, 45), 0.10, 3.85)
    local predicted = targetPos + targetVelocity * math.clamp(travelTime * 0.45, 0, 0.55)

    local compensation = 0.5 * gravity * travelTime * travelTime
    local skyClear = Camera and VeilChargeSkyClear(fromPos, Camera.CFrame.LookVector)

    -- Low arc untuk dekat/ada atap, arc lebih tinggi untuk jauh atau saat arah kamera memang ke langit.
    local farArc = math.clamp((flatDist - 35) / 180, 0, 1)
    local lowChargeArc = (1 - chargeT) * 0.38
    local skyArc = 0
    if skyClear then
        skyArc = farArc * (0.42 + lowChargeArc)
        if Camera and Camera.CFrame.LookVector.Y > 0.16 then
            skyArc += math.clamp(Camera.CFrame.LookVector.Y * 0.26, 0, 0.18)
        end
    else
        skyArc = farArc * 0.13
    end

    local lift = math.clamp(compensation * (0.82 + skyArc), 0, skyClear and 72 or 26)
    return predicted + Vector3.new(0, lift, 0)
end

function VeilSoftLookAt(targetPos, strength)
    if not Camera or not targetPos then return end
    strength = tonumber(strength) or VeilChargeAimStrength or 0.068

    local manualMag = 0
    pcall(function()
        local d = UserInputService:GetMouseDelta()
        manualMag = math.max(math.abs(d.X), math.abs(d.Y))
    end)

    if manualMag > 1.65 then
        VeilChargeManualUntil = tick() + 0.30
    end

    -- Saat kamera sedang digeser, aim melemah drastis supaya target mudah dipindahkan.
    if tick() < (VeilChargeManualUntil or 0) then
        strength = strength * 0.09
    end

    local camPos = Camera.CFrame.Position
    local delta = targetPos - camPos
    if delta.Magnitude <= 0.1 then return end

    strength = math.clamp(strength, 0.004, 0.095)
    local desired = CFrame.lookAt(camPos, camPos + delta.Unit)
    Camera.CFrame = Camera.CFrame:Lerp(desired, strength)
end

function VeilAimAtNormal(target)
    if not target.Character then return end
    local head = target.Character:FindFirstChild("Head")
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    local localRoot = VeilGetLocalRoot()
    if not head or not hrp or not localRoot then return end
    
    local predictedPos = head.Position + (hrp.Velocity * VeilPredictionTime)
    local distance = (localRoot.Position - predictedPos).Magnitude
    local autoPitchMax = VeilGetAutoPitchMax(distance)
    local alpha = math.clamp((distance - VeilMinDistance) / (VeilMaxDistance - VeilMinDistance), 0, 1)
    local pitch = VeilMinPitch + (autoPitchMax - VeilMinPitch) * alpha
    
    local dir = (predictedPos - Camera.CFrame.Position).Unit
    local yaw = math.atan2(dir.X, dir.Z)
    local pitchRad = math.rad(pitch)
    local look = Vector3.new(math.sin(yaw) * math.cos(pitchRad), math.sin(pitchRad), math.cos(yaw) * math.cos(pitchRad))
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + look)
end

function VeilAimAtCharge(target)
    if not target.Character then return end
    local head = target.Character:FindFirstChild("Head")
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    local localRoot = VeilGetLocalRoot()
    if not head or not hrp or not localRoot or not Camera then return end

    local camPos = Camera.CFrame.Position
    local baseTarget = head.Position + (hrp.Velocity * VeilPredictionTime)
    local toTarget = baseTarget - camPos
    local dist = toTarget.Magnitude
    if dist <= 0.1 then return end

    -- Charge spear memakai aim parabola. Titik aim dinaikkan sesuai speed charge dan gravitasi garis spear.
    local aimPoint = VeilComputeArcAimPoint(camPos, baseTarget, hrp.Velocity)
    local distanceAlpha = math.clamp((dist - 28) / 180, 0, 1)
    local chargeT = VeilGetSpearChargeAlphaApprox()
    local strength = (VeilChargeAimStrength or 0.068) * (0.62 + distanceAlpha * 0.20 + chargeT * 0.10)
    VeilSoftLookAt(aimPoint, strength)
end

---------------------------------------------------
--== AIMBOT SYSTEM (REGULAR) ==--
---------------------------------------------------
fovGui = nil
fovCircleFrame = nil

function getAimPart(character, partName)
    if partName == "Head" then return character:FindFirstChild("Head") end
    if partName == "Torso" then return character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso") end
    if partName == "Left Arm" then return character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm") end
    if partName == "Right Arm" then return character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm") end
    if partName == "Left Leg" then return character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftUpperLeg") end
    if partName == "Right Leg" then return character:FindFirstChild("Right Leg") or character:FindFirstChild("RightUpperLeg") end
    if partName == "HumanoidRootPart" then return character:FindFirstChild("HumanoidRootPart") end
    return character:FindFirstChild("Head")
end

function findBestTarget()
    local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local radius = featureStates.AimbotShowFOV and featureStates.AimbotFOVRadius or 25
    local bestTarget = nil
    local bestDist = radius
    local myRole = getRole(LocalPlayer)

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            if featureStates.AimbotTeamCheck then
                local targetRole = getRole(pl)
                if targetRole == myRole then end
            end
            local part = getAimPart(pl.Character, featureStates.AimbotPart)
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if dist <= radius and dist < bestDist then
                        bestDist = dist
                        bestTarget = pl
                    end
                end
            end
        end
    end
    return bestTarget
end

function aimAtTarget(target)
    local part = getAimPart(target.Character, featureStates.AimbotPart)
    if part then
        local camPos = Camera.CFrame.Position
        local targetPos = part.Position
        local direction = (targetPos - camPos).Unit
        Camera.CFrame = CFrame.lookAt(camPos, camPos + direction)
    end
end

function aimbotStep()
    if featureStates.AimbotEnabled then
        local target = findBestTarget()
        if target then aimAtTarget(target) end
    end
end

function destroyFOVCircle()
    if fovGui then
        pcall(function() fovGui:Destroy() end)
        fovGui = nil
        fovCircleFrame = nil
    end
end

function createFOVCircle()
    if fovGui then return end
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end
    
    fovGui = Instance.new("ScreenGui")
    fovGui.Name = "ArexansTools_FOV"
    fovGui.ResetOnSpawn = false
    fovGui.IgnoreGuiInset = true
    fovGui.Parent = playerGui
    
    registerArexansGuiGuard("AimbotFOV", function()
        return fovGui
    end, function()
        return featureStates.AimbotEnabled and featureStates.AimbotShowFOV
    end)
    
    fovCircleFrame = Instance.new("Frame")
    fovCircleFrame.Name = "FOVCircle"
    fovCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircleFrame.BackgroundTransparency = 1
    fovCircleFrame.BorderSizePixel = 0
    fovCircleFrame.Parent = fovGui
    
    local stroke = Instance.new("UIStroke")
    stroke.Name = "Stroke"
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = fovCircleFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = fovCircleFrame
end

function updateFOVCircle()
    if not featureStates.AimbotEnabled or not featureStates.AimbotShowFOV then
        destroyFOVCircle()
        return
    end
    if not fovGui then createFOVCircle() end
    if fovGui then
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        pcall(function()
            if playerGui and fovGui.Parent ~= playerGui then
                fovGui.Parent = playerGui
            end
            fovGui.Enabled = true
        end)
    end
    if not fovCircleFrame then return end
    
    local radius = featureStates.AimbotFOVRadius
    local diameter = radius * 2
    local viewportSize = Camera.ViewportSize
    
    fovCircleFrame.Size = UDim2.new(0, diameter, 0, diameter)
    fovCircleFrame.Position = UDim2.new(0, viewportSize.X / 2, 0, viewportSize.Y / 2)
    
    local stroke = fovCircleFrame:FindFirstChild("Stroke")
    if stroke then
        stroke.Thickness = featureStates.AimbotFOVThickness
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Transparency = featureStates.AimbotFOVTransparency
    end
end

---------------------------------------------------
--== GET ROLE FUNCTION ==--
---------------------------------------------------
function getRole(p)
    local tn = p.Team and p.Team.Name and p.Team.Name:lower() or ""
    if tn:find("killer") then return "Killer" end
    if tn:find("survivor") then return "Survivor" end
    return "Survivor"
end

---------------------------------------------------
--== ESP SYSTEM ==--
---------------------------------------------------
espObjects = {}

function removeESP(obj)
    if espObjects[obj] then
        if espObjects[obj].highlight then espObjects[obj].highlight:Destroy() end
        espObjects[obj] = nil
    end
end

function createESP(obj, baseColor)
    if not obj or obj.Name == "Lobby" then return end
    if espObjects[obj] then
        if espObjects[obj].highlight then
            espObjects[obj].highlight.FillColor = baseColor
            espObjects[obj].highlight.OutlineColor = baseColor
        end
        return
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = obj
    highlight.FillColor = baseColor
    highlight.FillTransparency = 0.9
    highlight.OutlineColor = baseColor
    highlight.OutlineTransparency = 0.1
    highlight.Parent = obj
    
    espObjects[obj] = {highlight = highlight, color = baseColor}
end

function updateESP()
    if not (featureStates.SurvivorESP or featureStates.KillerESP) then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local role = getRole(player)
            
            if role == "Survivor" and featureStates.SurvivorESP then
                createESP(player.Character, featureStates.SurvivorColor)
            elseif role == "Killer" and featureStates.KillerESP then
                createESP(player.Character, featureStates.KillerColor)
            else
                removeESP(player.Character)
            end
        end
    end
end

---------------------------------------------------
--== LIGHTING SYSTEMS ==--
---------------------------------------------------
fbConn = nil

function updateFullBright()
    if featureStates.FullBright then
        if not fbConn then
            fbConn = RunService.RenderStepped:Connect(function()
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 100000
                Lighting.Brightness = 2
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end)
        end
    else
        if fbConn then
            fbConn:Disconnect()
            fbConn = nil
            Lighting.GlobalShadows = originalLighting.GlobalShadows
            Lighting.FogEnd = originalLighting.FogEnd
            Lighting.Brightness = originalLighting.Brightness
            Lighting.Ambient = originalLighting.Ambient
            Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        end
    end
end

todActive = false

function bindTimeLock()
    if featureStates.TimeOfDay then
        if not todActive then
            todActive = true
            RunService:BindToRenderStep("VD_TimeLock", 200, function()
                Lighting.ClockTime = featureStates.TimeOfDay
            end)
        end
    else
        if todActive then
            todActive = false
            RunService:UnbindFromRenderStep("VD_TimeLock")
            Lighting.ClockTime = originalLighting.ClockTime
        end
    end
end

function applyFOV()
    if featureStates.FOVEnabled and Camera and Camera.FieldOfView ~= featureStates.FOVValue then
        Camera.FieldOfView = featureStates.FOVValue
    end
end

---------------------------------------------------
--== TELEPORT FUNCTIONS ==--
---------------------------------------------------
function tpCFrame(cf)
    local char = LocalPlayer.Character
    if not (char and char.Parent) then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local was = featureStates.Noclip
    setNoclip(true)
    hrp.CFrame = cf
    task.delay(0.7, function() if not was then setNoclip(false) end end)
end

function teleportToRandomSurvivor()
    local survivors = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and getRole(pl) == "Survivor" then
            table.insert(survivors, pl)
        end
    end
    if #survivors > 0 then
        local randomSurvivor = survivors[math.random(1, #survivors)]
        local hrp = randomSurvivor.Character and randomSurvivor.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            tpCFrame(hrp.CFrame * CFrame.new(0, 0, -3) + Vector3.new(0, 3, 0))
            safeNotify("Teleport", "Teleported to: " .. randomSurvivor.Name, 3)
        end
    else
        safeNotify("Teleport", "No survivors found", 3)
    end
end

function teleportToKiller()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and getRole(pl) == "Killer" then
            local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                tpCFrame(hrp.CFrame * CFrame.new(0, 0, -3) + Vector3.new(0, 3, 0))
                safeNotify("Teleport", "Teleported to Killer: " .. pl.Name, 3)
                return
            end
        end
    end
    safeNotify("Teleport", "No killer found", 3)
end

---------------------------------------------------
--== FIX CAMERA ==--
---------------------------------------------------
function fixCamera()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = humanoid
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 400
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        local head = character:FindFirstChild("Head")
        if head then head.Anchored = false end
        safeNotify("Camera", "Camera fixed to 3rd person", 3)
    end
end

---------------------------------------------------
--== ESP UPDATE LOOP ==--
---------------------------------------------------
task.spawn(function()
    while true do
        updateESP()
        task.wait(0.25)
    end
end)

---------------------------------------------------
--== AIMBOT LOOP ==--
---------------------------------------------------
task.spawn(function()
    while true do
        if featureStates.VeilAimbotEnabled then
            local target = VeilGetClosestInScreen()
            if target and VeilCanSeeTarget(target) then
                VeilAimAtNormal(target)
            end
        elseif featureStates.VeilAimbotChargeEnabled then
            local target = VeilGetChargeSoftTarget()
            if target and VeilCanSeeTarget(target) then
                VeilAimAtCharge(target)
            end
        end
        task.wait()
    end
end)

---------------------------------------------------
--== INITIALIZE CHARACTER ==--
---------------------------------------------------
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

---------------------------------------------------
--== CAMERA CHANGE HANDLER ==--
---------------------------------------------------
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    task.wait(0.1)
    Camera = workspace.CurrentCamera
    if featureStates.FOVEnabled then applyFOV() end
end)

---------------------------------------------------
--== RENDER LOOP ==--
---------------------------------------------------
RunService.RenderStepped:Connect(function()
    if featureStates.FOVEnabled then applyFOV() end
    aimbotStep()
    updateFOVCircle()
end)

---------------------------------------------------
--== CLEANUP ON SCRIPT REMOVAL ==--
---------------------------------------------------
game:GetService("ScriptContext").DescendantRemoving:Connect(function(descendant)
    if descendant == script then
        disableNoSkillcheck()
        stopKillAll()
        stopAutoAttack()
        stopAutoLever()
        stopAutoPallet()
        if stopAutoSpinCrouch then pcall(stopAutoSpinCrouch) end
        stopAutoParry()
        stopAutoShoot()
        disableGodMode()
        setNoclip(false)
        stopAntiAFK()
        disableNoFall()
        destroyFOVCircle()
    end
end)

---------------------------------------------------
--== SETUP NO FALL ==--
---------------------------------------------------
setupNoFall()

---------------------------------------------------
--== WORLD ESP SYSTEM (SEDERHANA) ==--
---------------------------------------------------
worldLoopThread = nil
worldReg = {Generator = {}, Hook = {}, Gate = {}, Window = {}, Palletwrong = {}}

function clearChild(o, n)
    if o and alive(o) then
        local c = o:FindFirstChild(n)
        if c then pcall(function() c:Destroy() end) end
    end
end

function clearHighlight(model)
    if model and model:FindFirstChild("VD_HL") then
        pcall(function() model.VD_HL:Destroy() end)
    end
end

function ensureHighlight(model, fill, isPlayer)
    if not (model and model:IsA("Model") and alive(model)) then return end
    local hl = model:FindFirstChild("VD_HL")
    if not hl then
        local ok, obj = pcall(function()
            local h = Instance.new("Highlight")
            h.Name = "VD_HL"
            h.Adornee = model
            h.FillTransparency = 0.95
            h.OutlineTransparency = 0.3
            h.Parent = model
            return h
        end)
        if ok then hl = obj else return end
    end
    hl.FillColor = fill
    hl.OutlineColor = fill
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

function makeBillboard(text, color3)
    local g = Instance.new("BillboardGui")
    g.Name = "VD_Tag"
    g.AlwaysOnTop = true
    g.Size = UDim2.new(0, 200, 0, 20)
    g.StudsOffset = Vector3.new(0, 2.5, 0)
    g.MaxDistance = 0
    local l = Instance.new("TextLabel")
    l.Name = "Label"
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(1, 0, 1, 0)
    l.Font = Enum.Font.GothamBold
    l.Text = text
    l.TextSize = featureStates.ESPTextSize
    l.TextColor3 = color3
    l.TextStrokeTransparency = 0.3
    l.TextStrokeColor3 = Color3.new(0,0,0)
    l.BorderSizePixel = 0
    l.Parent = g
    return g
end

function startWorldLoop()
    if worldLoopThread then return end
    worldLoopThread = task.spawn(function()
        while featureStates.GeneratorESP or featureStates.HookESP or featureStates.GateESP or 
              featureStates.WindowESP or featureStates.PalletESP do
            -- Lebih ringan: scan world ESP tidak perlu terlalu sering saat gameplay.
            task.wait(1.25)
            
            local myChar = LocalPlayer.Character
            if not myChar then continue end

            -- Scan for world objects
            local map = Workspace:FindFirstChild("Map")
            if map then
                for _, obj in ipairs(map:GetDescendants()) do
                    if obj:IsA("Model") then
                        local color = nil
                        local enabled = false
                        
                        if obj.Name == "Generator" and featureStates.GeneratorESP then
                            color = featureStates.GeneratorColor
                            enabled = true
                        elseif obj.Name == "Hook" and featureStates.HookESP then
                            color = featureStates.HookColor
                            enabled = true
                        elseif obj.Name == "Gate" and featureStates.GateESP then
                            color = featureStates.GateColor
                            enabled = true
                        elseif obj.Name == "Window" and featureStates.WindowESP then
                            color = featureStates.WindowColor
                            enabled = true
                        elseif obj.Name == "Palletwrong" and featureStates.PalletESP then
                            color = featureStates.PalletColor
                            enabled = true
                        end
                        
                        if enabled and color then
                            ensureHighlight(obj, color, false)
                            local part = firstBasePart(obj)
                            if part then
                                -- Label bawaan ESP tetap ditampilkan. Progress bar hanya menambah persen/bar kecil, bukan mengganti tulisan Generator.
                                local bb = part:FindFirstChild("VD_Text")
                                if not bb then
                                    bb = makeBillboard(obj.Name, color)
                                    bb.Name = "VD_Text"
                                    bb.Adornee = part
                                    bb.Parent = part
                                end
                                local lbl = bb:FindFirstChild("Label")
                                -- Khusus Generator: turunkan teks ESP agar dekat dengan objeknya.
                                -- Object ESP lain tetap memakai posisi default.
                                if obj.Name == "Generator" then
                                    bb.StudsOffset = Vector3.new(0, 1.55, 0)
                                end
                                if lbl then
                                    lbl.TextSize = featureStates.ESPTextSize
                                    lbl.TextColor3 = color
                                    lbl.Text = obj.Name
                                end
                            end
                        elseif not enabled and obj:FindFirstChild("VD_HL") then
                            clearHighlight(obj)
                            local part = firstBasePart(obj)
                            if part then clearChild(part, "VD_Text") end
                        end
                    end
                end
            end
        end
        worldLoopThread = nil
    end)
end

---------------------------------------------------
--== PLAYER TAB ==--
---------------------------------------------------
MovementSection = PlayerTab:Section({ Title = "Movement", Box = true, BoxBorder = true, Icon = "activity", Opened = true })

MovementSection:Toggle({
    Title = "Walk Speed",
    Desc = "Enable custom walk speed",
    Value = false,
    Callback = function(state)
        featureStates.WalkSpeed = state
        if state and speedHumanoid then
            setWalkSpeed(speedHumanoid, featureStates.WalkSpeedValue)
            bindSpeedLoop()
        elseif not state and speedHumanoid then
            unbindSpeedLoop()
            setWalkSpeed(speedHumanoid, 16)
        end
    end
})

MovementSection:Slider({
    Title = "Walk Speed Value",
    Desc = "Set walk speed value",
    Step = 1,
    Value = {Min = 0, Max = 200, Default = featureStates.WalkSpeedValue},
    Callback = function(value)
        featureStates.WalkSpeedValue = value
        if featureStates.WalkSpeed and speedHumanoid then
            setWalkSpeed(speedHumanoid, value)
        end
    end
})

MovementSection:Toggle({
    Title = "Noclip",
    Desc = "Enable noclip mode (Walk through walls)",
    Value = false,
    Callback = function(state) setNoclip(state) end
})

MovementSection:Toggle({
    Title = "God Mode",
    Desc = "Auto heal, anti death",
    Value = false,
    Callback = function(state)
        featureStates.GodMode = state
        if state then enableGodMode() else disableGodMode() end
    end
})


MovementSection:Toggle({
    Title = "Ziggle + Moonwalk Combo",
    Desc = "Hanya tampil/sembunyikan icon Combo. Klik icon layar untuk ON/OFF kedua fitur.",
    Value = false,
    Callback = function(state)
        if getgenv().ArexansSetZiggleMoonwalkComboMobileIconVisible then
            getgenv().ArexansSetZiggleMoonwalkComboMobileIconVisible(state)
        end
    end
})

MovementSection:Toggle({
    Title = "MoonWalk",
    Desc = "Hanya tampil/sembunyikan icon MoonWalk. Klik icon layar untuk ON/OFF fitur.",
    Value = false,
    Callback = function(state)
        if getgenv().ArexansSetMoonwalkMobileIconVisible then
            getgenv().ArexansSetMoonwalkMobileIconVisible(state)
        end
    end
})

MovementSection:Toggle({
    Title = "Ziggle",
    Desc = "Hanya tampil/sembunyikan icon Ziggle. Klik icon layar untuk ON/OFF fitur.",
    Value = false,
    Callback = function(state)
        if getgenv().ArexansSetZiggleMobileIconVisible then
            getgenv().ArexansSetZiggleMobileIconVisible(state)
        end
    end
})

MovementSection:Dropdown({
    Title = "Ziggle Mode",
    Desc = "Pilih preset ziggle. Memilih mode akan reset speed sesuai jenisnya.",
    Values = {"Santai", "Sedang", "Pro", "Brutal"},
    Default = featureStates.ZiggleMode,
    Callback = function(value)
        featureStates.ZiggleMode = value or "Pro"
        local presetMap = {
            ["Santai"] = {power = 0.65, speed = 12},
            ["Sedang"] = {power = 1.15, speed = 24},
            ["Pro"] = {power = 1.55, speed = 40},
            ["Brutal"] = {power = 2.10, speed = 60},
        }
        local preset = presetMap[featureStates.ZiggleMode] or presetMap["Pro"]
        featureStates.ZigglePower = preset.power
        featureStates.ZiggleSpeed = preset.speed
    end
})

MovementSection:Slider({
    Title = "Ziggle Speed",
    Desc = "Atur cepat-lambat ziggle manual. Pilih mode lain untuk reset ke preset.",
    Step = 1,
    Value = {Min = 2, Max = 120, Default = 40},
    Callback = function(value)
        featureStates.ZiggleSpeed = math.clamp(tonumber(value) or 40, 2, 120)
    end
})

MovementSection:Toggle({
    Title = "Ziggle Auto Face Killer",
    Desc = "Opsional: saat Ziggle aktif, badan otomatis menghadap killer dalam jarak tertentu.",
    Value = false,
    Callback = function(state)
        featureStates.ZiggleAutoFaceKiller = state == true
        -- retain existing distance setting
    end
})

MovementSection:Slider({
    Title = "Ziggle Radius",
    Desc = "Radius jarak maksimal Ziggle Auto Face Killer.",
    Step = 1,
    Value = {Min = 5, Max = 100, Default = featureStates.ZiggleAutoFaceDistance or 25},
    Callback = function(value)
        featureStates.ZiggleAutoFaceDistance = value
    end
})

UtilitySection = PlayerTab:Section({ Title = "Utilities", Box = true, BoxBorder = true, Icon = "settings", Opened = true })

UtilitySection:Toggle({
    Title = "Anti AFK",
    Desc = "Prevent being kicked for AFK",
    Value = false,
    Callback = function(state)
        featureStates.AntiAFK = state
        if state then startAntiAFK() else stopAntiAFK() end
    end
})

UtilitySection:Toggle({
    Title = "No Fall",
    Desc = "Remove fall damage and stun",
    Value = false,
    Callback = function(state)
        if state then enableNoFall() else disableNoFall() end
    end
})

UtilitySection:Toggle({
    Title = "Anti Stun",
    Desc = "Prevent stun, ragdoll, and platform stand",
    Value = false,
    Callback = function(state) toggleAntiStun(state) end
})

-- Aimbot Section
AimbotSection = PlayerTab:Section({ Title = "Aimbot", Box = true, BoxBorder = true, Icon = "crosshair", Opened = true })

AimbotSection:Toggle({
    Title = "Aimbot Enabled",
    Desc = "Enable aimbot",
    Value = false,
    Callback = function(state)
        featureStates.AimbotEnabled = state
        if not state then destroyFOVCircle() end
    end
})

AimbotSection:Toggle({
    Title = "Team Check",
    Desc = "Only target enemies",
    Value = false,
    Callback = function(state) featureStates.AimbotTeamCheck = state end
})

AimbotSection:Toggle({
    Title = "Show FOV",
    Desc = "Show aim FOV circle on screen",
    Value = false,
    Callback = function(state)
        featureStates.AimbotShowFOV = state
        if not state then destroyFOVCircle() end
    end
})

AimbotSection:Slider({
    Title = "FOV Radius",
    Desc = "Size of the FOV circle",
    Step = 1,
    Value = {Min = 10, Max = 500, Default = featureStates.AimbotFOVRadius},
    Callback = function(value) featureStates.AimbotFOVRadius = value end
})

AimbotSection:Dropdown({
    Title = "Aim Part",
    Desc = "Body part to aim at",
    Values = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"},
    Value = "Head",
    Callback = function(value) featureStates.AimbotPart = value end
})

AimbotSection:Slider({
    Title = "FOV Thickness",
    Step = 1,
    Value = {Min = 1, Max = 10, Default = featureStates.AimbotFOVThickness},
    Callback = function(value) featureStates.AimbotFOVThickness = value end
})

AimbotSection:Slider({
    Title = "FOV Transparency",
    Step = 0.05,
    Value = {Min = 0, Max = 1, Default = featureStates.AimbotFOVTransparency},
    Callback = function(value) featureStates.AimbotFOVTransparency = value end
})

---------------------------------------------------
--== SURVIVOR TAB ==--
---------------------------------------------------
SurvivorMainSection = SurvivorTab:Section({ Title = "Survivor Main", Box = true, BoxBorder = true, Icon = "user-check", Opened = true })

SurvivorMainSection:Toggle({
    Title = "No Skillcheck",
    Desc = "Auto perfect skillcheck for generator & healing",
    Value = false,
    Callback = function(state)
        featureStates.NoSkillcheck = state
        if state then setupNoSkillcheck() else disableNoSkillcheck() end
    end
})

SurvivorMainSection:Toggle({
    Title = "Bypass Gate",
    Desc = "Walk through gates without opening",
    Value = false,
    Callback = function(state) setBypassGate(state) end
})

SurvivorMainSection:Toggle({
    Title = "Auto Lever",
    Desc = "Automatically pull exit lever when nearby",
    Value = false,
    Callback = function(state)
        featureStates.AutoLever = state
        if state then startAutoLever() else stopAutoLever() end
    end
})

SurvivorMainSection:Toggle({
    Title = "Auto Pallet",
    Desc = "Drop pallet at the right chase momentum when killer reaches it",
    Value = false,
    Callback = function(state)
        featureStates.AutoPallet = state
        if state then startAutoPallet() else stopAutoPallet() end
    end
})

HealSection = SurvivorTab:Section({ Title = "Healing System", Box = true, BoxBorder = true, Icon = "heart", Opened = true })

HealSection:Toggle({
    Title = "Auto Heal (Perfect)",
    Desc = "Perfect skillcheck when healing",
    Value = false,
    Callback = function(state)
        featureStates.AutoHealPerfect = state
        if state then startAutoHealPerfect() end
    end
})

HealSection:Toggle({
    Title = "Auto Heal (Neutral)",
    Desc = "Neutral skillcheck when healing",
    Value = false,
    Callback = function(state)
        featureStates.AutoHealNeutral = state
        if state then startAutoHealNeutral() end
    end
})

GenSection = SurvivorTab:Section({ Title = "Generator System", Box = true, BoxBorder = true, Icon = "zap", Opened = true })

GenSection:Toggle({
    Title = "Auto Generator (Perfect)",
    Desc = "Perfect skillcheck on generators",
    Value = false,
    Callback = function(state)
        featureStates.AutoGeneratorPerfect = state
        if state then startAutoGeneratorPerfect() end
    end
})

GenSection:Toggle({
    Title = "Auto Generator (Neutral)",
    Desc = "Neutral skillcheck on generators",
    Value = false,
    Callback = function(state)
        featureStates.AutoGeneratorNeutral = state
        if state then startAutoGeneratorNeutral() end
    end
})

CombatSection = SurvivorTab:Section({ Title = "Combat System", Box = true, BoxBorder = true, Icon = "swords", Opened = true })

CombatSection:Toggle({
    Title = "Auto Parry",
    Desc = "Automatically parry killer attacks (requires Parrying Dagger)",
    Value = false,
    Callback = function(state)
        featureStates.AutoParry = state
        if getgenv().AutoParrySettings then getgenv().AutoParrySettings.Enabled = state end
        if state then
            startAutoParry()
            if startAutoSpinCrouch then pcall(startAutoSpinCrouch) end
        else
            stopAutoParry()
            if not featureStates.AutoSpinCrouch and stopAutoSpinCrouch then pcall(stopAutoSpinCrouch) end
        end
    end
})

CombatSection:Toggle({
    Title = "Auto Crouch Spin Attack",
    Desc = "Auto crouch during killer spinning sword skill, then stand again",
    Value = false,
    Callback = function(state)
        featureStates.AutoSpinCrouch = state
        if state then
            if startAutoSpinCrouch then pcall(startAutoSpinCrouch) end
        else
            if not featureStates.AutoParry and stopAutoSpinCrouch then pcall(stopAutoSpinCrouch) end
        end
    end
})

SmartFaceToggle = CombatSection:Toggle({
    Title = "Smart Face",
    Desc = "Auto face killer when parrying",
    Value = false,
    Callback = function(state) SmartFace = state end
})

VisualParryToggle = CombatSection:Toggle({
    Title = "Visual Radius",
    Desc = "Show parry radius",
    Value = false,
    Callback = function(state)
        getgenv().ParryVisualsEnabled = state
        if state and featureStates.AutoParry then
            startParryVisualLoop()
        else
            stopParryVisualLoop()
        end
        updateParryVisual()
    end
})

RadiusSlider = CombatSection:Slider({
    Title = "Parry Radius",
    Value = {Min = 5, Max = 30, Default = 20},
    Callback = function(v)
        ParryDistance = tonumber(v)
        if getgenv().AutoParrySettings then getgenv().AutoParrySettings.Range = tonumber(v) or 20 end
        updateParryVisual()
    end
})

CombatSection:Toggle({
    Title = "Auto Shoot",
    Desc = "Automatically shoot killer (requires ranged weapon)",
    Value = false,
    Callback = function(state)
        featureStates.AutoShoot = state
        if getgenv().SilentAimPistolSettings then getgenv().SilentAimPistolSettings.Enabled = state end
        if state then startAutoShoot() else stopAutoShoot() end
    end
})

CombatSection:Toggle({
    Title = "Pistol Show FOV",
    Desc = "Tampilkan FOV Silent Aim Pistol",
    Value = false,
    Callback = function(state)
        if getgenv().SilentAimPistolSettings then getgenv().SilentAimPistolSettings.ShowFOV = state end
    end
})

CombatSection:Toggle({
    Title = "Laser Target Lock",
    Desc = "Tampilkan Laser Tracer Silent Aim Pistol",
    Value = false,
    Callback = function(state)
        if getgenv().SilentAimPistolSettings then getgenv().SilentAimPistolSettings.Laser = state end
    end
})

CombatSection:Toggle({
    Title = "ESP Stunned Detect",
    Desc = "Tampilkan status ESP Stunned saat killer ter-stun",
    Value = false,
    Callback = function(state)
        if getgenv().SilentAimPistolSettings then getgenv().SilentAimPistolSettings.StunESP = state end
    end
})

---------------------------------------------------
--== KILLER TAB ==--
---------------------------------------------------
KillerMainSection = KillerTab:Section({ Title = "Killer Main", Box = true, BoxBorder = true, Icon = "swords", Opened = true })

KillerMainSection:Toggle({
    Title = "Kill All",
    Desc = "âš ï¸ WARNING: May get you banned! âš ï¸",
    Value = false,
    Callback = function(state)
        featureStates.KillAll = state
        if state then startKillAll() else stopKillAll() end
    end
})

KillerMainSection:Toggle({
    Title = "Auto Attack",
    Desc = "Automatically attack nearby survivors",
    Value = false,
    Callback = function(state)
        featureStates.AutoAttack = state
        if state then startAutoAttack() else stopAutoAttack() end
    end
})

KillerMainSection:Toggle({
    Title = "No Flashlight",
    Desc = "Remove flashlight blinding effect",
    Value = false,
    Callback = function(state)
        featureStates.NoFlashlight = state
        if state then startNoFlashlight() else stopNoFlashlight() end
    end
})

VeilSection = KillerTab:Section({ Title = "The Veil Aimbot", Box = true, BoxBorder = true, Icon = "target", Opened = true })

VeilSection:Paragraph({
    Title = "Information",
    Desc = "â€¢ Aimbot for The Veil killer\nâ€¢ Normal mode: Screen-based targeting\nâ€¢ Charge mode: Distance-based targeting\nâ€¢ Both modes cannot be active simultaneously",
})

VeilSection:Toggle({
    Title = "Enable Aimbot (Normal)",
    Desc = "Screen-based targeting",
    Value = false,
    Callback = function(state)
        featureStates.VeilAimbotEnabled = state
        if state and featureStates.VeilAimbotChargeEnabled then
            featureStates.VeilAimbotChargeEnabled = false
        end
    end
})

VeilSection:Toggle({
    Title = "Enable Aimbot (Charge)",
    Desc = "Distance-based targeting for charge attack",
    Value = false,
    Callback = function(state)
        featureStates.VeilAimbotChargeEnabled = state
        if state and featureStates.VeilAimbotEnabled then
            featureStates.VeilAimbotEnabled = false
        end
    end
})

SilentAimVeilSection = KillerTab:Section({ Title = "Silent Aim Veil", Box = true, BoxBorder = true, Icon = "target", Opened = true })

SilentAimVeilSection:Toggle({
    Title = "Silent Aim (Veil Spear)",
    Desc = "Otomatis melempar tombak ke target dalam FOV saat charge",
    Value = false,
    Callback = function(state)
        if getgenv().SilentAimVeilSettings then getgenv().SilentAimVeilSettings.Enabled = state end
    end
})

SilentAimVeilSection:Toggle({
    Title = "Show FOV Veil",
    Desc = "Tampilkan lingkaran FOV Silent Aim Veil",
    Value = true,
    Callback = function(state)
        if getgenv().SilentAimVeilSettings then getgenv().SilentAimVeilSettings.ShowFOV = state end
    end
})

SilentAimVeilSection:Toggle({
    Title = "ESP Khusus Veil",
    Desc = "Tampilkan ESP khusus untuk Silent Aim Veil",
    Value = false,
    Callback = function(state)
        if getgenv().SilentAimVeilSettings then getgenv().SilentAimVeilSettings.ESP = state end
    end
})

SilentAimVeilSection:Toggle({
    Title = "Crosshair Veil",
    Desc = "Tampilkan Crosshair khusus Veil",
    Value = false,
    Callback = function(state)
        if getgenv().SilentAimVeilSettings then getgenv().SilentAimVeilSettings.Crosshair = state end
    end
})

VeilSection:Toggle({
    Title = "Tough Wall",
    Desc = "Ignore walls when aiming",
    Value = true,
    Callback = function(state)
        featureStates.VeilToughWall = state
        VeilToughWall = state
    end
})

VeilSection:Input({
    Title = "Min Pitch",
    Desc = "Minimum pitch angle (-90 to 90)",
    Default = tostring(VeilMinPitch),
    Callback = function(v) 
        local n = tonumber(v) 
        if n then 
            featureStates.VeilMinPitch = n
            VeilMinPitch = n
        end 
    end
})

VeilSection:Input({
    Title = "Max Pitch",
    Desc = "Maximum pitch angle (-90 to 90)",
    Default = tostring(VeilMaxPitch),
    Callback = function(v) 
        local n = tonumber(v) 
        if n then 
            featureStates.VeilMaxPitch = n
            VeilMaxPitch = n
        end 
    end
})

VeilSection:Divider()

VeilSection:Toggle({
    Title = "Veil Spear Charge Line",
    Desc = "Garis 3D tombak hanya aktif saat The Veil benar-benar hold/charge untuk melempar, bukan saat jalan atau tap biasa",
    Value = false,
    Callback = function(state)
        featureStates.SpearTrajectoryEnabled = state
    end
})

VeilSection:Slider({
    Title = "Spear Min Speed",
    Desc = "Kecepatan tombak saat power minimum",
    Step = 5,
    Value = {Min = 60, Max = 260, Default = 120},
    Callback = function(v) featureStates.SpearMinSpeed = v end
})

VeilSection:Slider({
    Title = "Spear Max Speed",
    Desc = "Kecepatan tombak saat power penuh",
    Step = 5,
    Value = {Min = 250, Max = 1200, Default = 850},
    Callback = function(v) featureStates.SpearMaxSpeed = v end
})

KillerUtilitySection = KillerTab:Section({ Title = "Killer Utility", Box = true, BoxBorder = true, Icon = "settings", Opened = false })

KillerUtilitySection:Button({
    Title = "Fix Camera",
    Desc = "Reset camera to 3rd person",
    Callback = fixCamera
})


---------------------------------------------------
--== INTEGRATED FEATURES (integrasi.lua) ==--
---------------------------------------------------

local IntegratedSurvivorSection = SurvivorTab:Section({
    Title = "Integrated Survivor",
    Box = true,
    BoxBorder = true,
    Icon = "shield",
    Opened = true
})

IntegratedSurvivorSection:Toggle({
    Title = "Auto Crouch",
    Desc = "Crouch automatically when the slasher attack animation is detected nearby.",
    Value = false,
    Callback = function(state)
        getgenv().SilentAimVeilSettings.SURV_AutoCrouch = state == true
        getgenv().SilentAimVeilSettings.AutoCrouch = state == true
    end
})

IntegratedSurvivorSection:Slider({
    Title = "Auto Crouch Radius",
    Desc = "Detection radius for the automatic crouch.",
    Step = 1,
    Value = {Min = 5, Max = 50, Default = tonumber(getgenv().SilentAimVeilSettings.AutoCrouchRadius) or 18},
    Callback = function(value)
        local n = tonumber(value) or 18
        getgenv().SilentAimVeilSettings.SURV_AutoCrouchRadius = n
        getgenv().SilentAimVeilSettings.AutoCrouchRadius = n
    end
})

IntegratedSurvivorSection:Toggle({
    Title = "Integrated Auto Parry",
    Desc = "Automatically parry supported killer attack animations when a dagger is equipped.",
    Value = false,
    Callback = function(state)
        getgenv().SilentAimVeilSettings.SURV_AutoParry = state == true
        getgenv().SilentAimVeilSettings.AutoParry = state == true
    end
})

IntegratedSurvivorSection:Slider({
    Title = "Parry Range",
    Desc = "Maximum distance used by integrated auto parry.",
    Step = 1,
    Value = {Min = 5, Max = 30, Default = tonumber(getgenv().SilentAimVeilSettings.ParryRange) or 12},
    Callback = function(value)
        local n = tonumber(value) or 12
        getgenv().SilentAimVeilSettings.SURV_ParryRange = n
        getgenv().SilentAimVeilSettings.ParryRange = n
    end
})

local IntegratedPistolSection = SurvivorTab:Section({
    Title = "Pistol Silent Aim",
    Box = true,
    BoxBorder = true,
    Icon = "crosshair",
    Opened = false
})

IntegratedPistolSection:Toggle({
    Title = "Pistol Silent Aim",
    Desc = "Enable the integrated survivor pistol targeting system.",
    Value = false,
    Callback = function(state)
        local s = getgenv().SilentAimPistolSettings
        s.Enabled = state == true
        s.SilentAimPistol = state == true
    end
})

IntegratedPistolSection:Dropdown({
    Title = "Pistol Target Part",
    Desc = "Body part selected by the pistol targeter.",
    Values = {"HumanoidRootPart", "Head", "Torso", "Left Arm", "Right Arm", "Any Shoulder"},
    Default = getgenv().SilentAimPistolSettings.TargetPart or "HumanoidRootPart",
    Callback = function(value)
        local s = getgenv().SilentAimPistolSettings
        s.TargetPart = value or "HumanoidRootPart"
        s.PistolTargetPart = value or "HumanoidRootPart"
    end
})

IntegratedPistolSection:Slider({
    Title = "Pistol FOV",
    Desc = "Screen-space target radius.",
    Step = 5,
    Value = {Min = 25, Max = 600, Default = tonumber(getgenv().SilentAimPistolSettings.FovRadius) or 300},
    Callback = function(value)
        local n = tonumber(value) or 300
        local s = getgenv().SilentAimPistolSettings
        s.FovRadius = n
        s.PistolFovRadius = n
    end
})

IntegratedPistolSection:Toggle({
    Title = "Pistol FOV Circle",
    Value = false,
    Callback = function(state)
        local s = getgenv().SilentAimPistolSettings
        s.ShowFOV = state == true
        s.PistolShowFOV = state == true
    end
})

IntegratedPistolSection:Toggle({
    Title = "Pistol Laser",
    Desc = "Show the integrated target tracer while shooting.",
    Value = false,
    Callback = function(state)
        local s = getgenv().SilentAimPistolSettings
        s.Laser = state == true
        s.PistolShowLaser = state == true
    end
})

IntegratedPistolSection:Toggle({
    Title = "Pistol Stun ESP",
    Desc = "Show the killer stun status used by the integrated pistol system.",
    Value = false,
    Callback = function(state)
        local s = getgenv().SilentAimPistolSettings
        s.StunESP = state == true
        s.PistolESPStun = state == true
    end
})

IntegratedPistolSection:Toggle({
    Title = "Pistol Safe Shot",
    Desc = "Use the integrated safe-shot handling.",
    Value = false,
    Callback = function(state)
        local s = getgenv().SilentAimPistolSettings
        s.SafeShot = state == true
        s.SafeShotEnabled = state == true
    end
})

local IntegratedVeilSection = KillerTab:Section({
    Title = "Integrated Veil Settings",
    Box = true,
    BoxBorder = true,
    Icon = "sliders-horizontal",
    Opened = false
})

IntegratedVeilSection:Dropdown({
    Title = "Veil Target Part",
    Values = {"HumanoidRootPart", "Head", "Torso", "Left Arm", "Right Arm", "Any Shoulder"},
    Default = getgenv().SilentAimVeilSettings.TargetPart or "HumanoidRootPart",
    Callback = function(value)
        local s = getgenv().SilentAimVeilSettings
        s.TargetPart = value or "HumanoidRootPart"
        s.VeilTargetPart = value or "HumanoidRootPart"
    end
})

IntegratedVeilSection:Toggle({
    Title = "Auto Predict",
    Desc = "Use target movement prediction for the integrated spear solver.",
    Value = getgenv().SilentAimVeilSettings.AutoPredict == true,
    Callback = function(state)
        getgenv().SilentAimVeilSettings.AutoPredict = state == true
    end
})

IntegratedVeilSection:Slider({
    Title = "Veil FOV",
    Step = 5,
    Value = {Min = 25, Max = 600, Default = tonumber(getgenv().SilentAimVeilSettings.FovRadius) or 300},
    Callback = function(value)
        local n = tonumber(value) or 300
        local s = getgenv().SilentAimVeilSettings
        s.FovRadius = n
        s.FOV = n
    end
})

IntegratedVeilSection:Slider({
    Title = "Veil Max Distance",
    Step = 1,
    Value = {Min = 25, Max = 500, Default = tonumber(getgenv().SilentAimVeilSettings.MaxTargetDistance) or 286},
    Callback = function(value)
        local n = tonumber(value) or 286
        local s = getgenv().SilentAimVeilSettings
        s.MaxTargetDistance = n
        s.MaxDist = n
    end
})

IntegratedVeilSection:Slider({
    Title = "Spear Speed",
    Step = 1,
    Value = {Min = 60, Max = 1200, Default = tonumber(getgenv().SilentAimVeilSettings.CustomSpearSpeed) or 165},
    Callback = function(value)
        local n = tonumber(value) or 165
        local s = getgenv().SilentAimVeilSettings
        s.CustomSpearSpeed = n
        s.SpearSpeed = n
    end
})

IntegratedVeilSection:Slider({
    Title = "Spear Gravity",
    Step = 1,
    Value = {Min = 1, Max = 250, Default = tonumber(getgenv().SilentAimVeilSettings.CustomSpearGravity) or 103},
    Callback = function(value)
        local n = tonumber(value) or 103
        local s = getgenv().SilentAimVeilSettings
        s.CustomSpearGravity = n
        s.Gravity = n
    end
})

IntegratedVeilSection:Slider({
    Title = "Lead Multiplier",
    Step = 0.05,
    Value = {Min = 0, Max = 3, Default = tonumber(getgenv().SilentAimVeilSettings.LeadMultiplier) or 1.4},
    Callback = function(value)
        getgenv().SilentAimVeilSettings.LeadMultiplier = tonumber(value) or 1.4
    end
})

IntegratedVeilSection:Toggle({
    Title = "Target Tracker",
    Value = getgenv().SilentAimVeilSettings.ShowTracker == true,
    Callback = function(state)
        getgenv().SilentAimVeilSettings.ShowTracker = state == true
    end
})

IntegratedVeilSection:Toggle({
    Title = "Hide Player Names",
    Desc = "Replace detected player names/avatar icons and restore them when disabled.",
    Value = getgenv().SilentAimVeilSettings.HideName == true,
    Callback = function(state)
        local enabled = state == true
        getgenv().SilentAimVeilSettings.HideName = enabled
        if getgenv().SetHideName then
            pcall(getgenv().SetHideName, enabled)
        end
    end
})

IntegratedVeilSection:Toggle({
    Title = "Veil ESP HP",
    Value = getgenv().SilentAimVeilSettings.ESP_ShowHP == true,
    Callback = function(state)
        getgenv().SilentAimVeilSettings.ESP_ShowHP = state == true
    end
})

IntegratedVeilSection:Toggle({
    Title = "Veil ESP Distance",
    Value = getgenv().SilentAimVeilSettings.ESP_ShowDistance == true,
    Callback = function(state)
        getgenv().SilentAimVeilSettings.ESP_ShowDistance = state == true
    end
})

IntegratedVeilSection:Button({
    Title = "Apply 286m Preset",
    Desc = "Apply the integration preset for 286m target distance and spear speed.",
    Callback = function()
        if getgenv().ApplySetting286m then
            pcall(getgenv().ApplySetting286m)
        end
    end
})

IntegratedVeilSection:Button({
    Title = "Reset Integrated Silent Aim",
    Desc = "Restore integration defaults and clear its visual lock state.",
    Callback = function()
        if getgenv().ResetDefaultSilentAim then
            pcall(getgenv().ResetDefaultSilentAim)
        end
    end
})

---------------------------------------------------
--== ESP TAB ==--
---------------------------------------------------
PlayerESPSection = ESPTab:Section({ Title = "Player ESP", Box = true, BoxBorder = true, Icon = "users", Opened = true })

PlayerESPSection:Toggle({
    Title = "Survivor ESP",
    Value = false,
    Callback = function(state) featureStates.SurvivorESP = state end
})

PlayerESPSection:Toggle({
    Title = "Killer ESP",
    Value = false,
    Callback = function(state) featureStates.KillerESP = state end
})

PlayerESPSection:Colorpicker({
    Title = "Survivor Color",
    Default = featureStates.SurvivorColor,
    Callback = function(color) featureStates.SurvivorColor = color end
})

PlayerESPSection:Colorpicker({
    Title = "Killer Color",
    Default = featureStates.KillerColor,
    Callback = function(color) featureStates.KillerColor = color end
})

---------------------------------------------------
--== WORLD ESP ==--
---------------------------------------------------
WorldTogglesSection = ESPTab:Section({ Title = "World ESP", Box = true, BoxBorder = true, Icon = "toggle-left", Opened = true })

WorldTogglesSection:Slider({
    Title = "ESP Text Size",
    Step = 1,
    Value = {Min = 8, Max = 20, Default = featureStates.ESPTextSize},
    Callback = function(value) featureStates.ESPTextSize = value end
})

WorldTogglesSection:Toggle({
    Title = "Generators",
    Value = false,
    Callback = function(state)
        featureStates.GeneratorESP = state
        if state then startWorldLoop() end
    end
})

WorldTogglesSection:Toggle({
    Title = "Hooks",
    Value = false,
    Callback = function(state)
        featureStates.HookESP = state
        if state then startWorldLoop() end
    end
})

WorldTogglesSection:Toggle({
    Title = "Gates",
    Value = false,
    Callback = function(state)
        featureStates.GateESP = state
        if state then startWorldLoop() end
    end
})

WorldTogglesSection:Toggle({
    Title = "Windows",
    Value = false,
    Callback = function(state)
        featureStates.WindowESP = state
        if state then startWorldLoop() end
    end
})

WorldTogglesSection:Toggle({
    Title = "Pallets",
    Value = false,
    Callback = function(state)
        featureStates.PalletESP = state
        if state then startWorldLoop() end
    end
})

WorldTogglesSection:Colorpicker({
    Title = "Generator Color",
    Default = featureStates.GeneratorColor,
    Callback = function(color) featureStates.GeneratorColor = color end
})

WorldTogglesSection:Colorpicker({
    Title = "Hook Color",
    Default = featureStates.HookColor,
    Callback = function(color) featureStates.HookColor = color end
})

WorldTogglesSection:Colorpicker({
    Title = "Gate Color",
    Default = featureStates.GateColor,
    Callback = function(color) featureStates.GateColor = color end
})

WorldTogglesSection:Colorpicker({
    Title = "Window Color",
    Default = featureStates.WindowColor,
    Callback = function(color) featureStates.WindowColor = color end
})

WorldTogglesSection:Colorpicker({
    Title = "Pallet Color",
    Default = featureStates.PalletColor,
    Callback = function(color) featureStates.PalletColor = color end
})

---------------------------------------------------
--== VISUAL TAB ==--
---------------------------------------------------
VisualTab:Toggle({
    Title = "Potato Grafik",
    Description = "Mengurangi kualitas grafik untuk meningkatkan FPS.",
    Default = false,
    Callback = function(state)
        getgenv().SilentAimVeilSettings.PotatoMode = state == true
        if getgenv().AREXANS_SetPotatoGrafik then pcall(getgenv().AREXANS_SetPotatoGrafik, state == true) end
    end
})
local LightingSection = VisualTab:Section({ Title = "Lighting", Box = true, BoxBorder = true, Icon = "sun", Opened = true })

LightingSection:Toggle({
    Title = "Fullbright",
    Value = false,
    Callback = function(state)
        featureStates.FullBright = state
        updateFullBright()
    end
})

LightingSection:Slider({
    Title = "Time of Day",
    Step = 1,
    Value = {Min = 0, Max = 24, Default = featureStates.TimeOfDay},
    Callback = function(value)
        featureStates.TimeOfDay = value
        Lighting.ClockTime = value
        bindTimeLock()
    end
})

FOVSection = VisualTab:Section({ Title = "FOV", Box = true, BoxBorder = true, Icon = "maximize", Opened = false })

FOVSection:Toggle({
    Title = "Custom FOV",
    Value = false,
    Callback = function(state)
        featureStates.FOVEnabled = state
        if state then applyFOV() end
    end
})

FOVSection:Slider({
    Title = "FOV Value",
    Step = 1,
    Value = {Min = 70, Max = 120, Default = featureStates.FOVValue},
    Callback = function(value)
        featureStates.FOVValue = value
        if featureStates.FOVEnabled then applyFOV() end
    end
})

---------------------------------------------------
--== TELEPORT TAB ==--
---------------------------------------------------
PlayerTeleportSection = TeleportTab:Section({ Title = "Player Teleport", Box = true, BoxBorder = true, Icon = "users", Opened = true })

PlayerTeleportSection:Button({
    Title = "Teleport to Random Survivor",
    Callback = teleportToRandomSurvivor
})

PlayerTeleportSection:Button({
    Title = "Teleport to Killer",
    Callback = teleportToKiller
})

WorldTeleportSection = TeleportTab:Section({ Title = "World Teleport", Box = true, BoxBorder = true, Icon = "globe", Opened = true })

WorldTeleportSection:Button({
    Title = "Teleport to Random Generator",
    Callback = function()
        local generators = getFolderGenerator()
        if #generators > 0 then
            local randomGen = generators[math.random(1, #generators)]
            local part = firstBasePart(randomGen)
            if part then tpCFrame(part.CFrame + Vector3.new(0, 3, 0)) end
        end
    end
})

---------------------------------------------------
--== CONFIG TAB ==--
---------------------------------------------------
ConfigSection = ConfigTab:Section({ Title = "Config System", Box = true, BoxBorder = true, Icon = "folder", Opened = true })

ConfigManager = Window.ConfigManager
ConfigName = "default"

if type(ConfigManager) ~= "table" and type(ConfigManager) ~= "userdata" then
    __ArexansNotify("Config", "ConfigManager tidak tersedia, config dinonaktifkan.", 5)
    local __dummyConfig = { Save = function() end, Load = function() end }
    ConfigManager = {
        AllConfigs = function() return {"default"} end,
        Config = function() return __dummyConfig end,
        CreateConfig = function() return __dummyConfig end,
        DeleteConfig = function() end,
    }
end

ConfigNameInput = ConfigSection:Input({
    Title = "Config Name",
    Callback = function(value) ConfigName = value end,
})

local __allConfigsOk, __allConfigsResult = pcall(function()
    return ConfigManager:AllConfigs()
end)
AllConfigs = (__allConfigsOk and type(__allConfigsResult) == "table" and __allConfigsResult) or {"default"}

AllConfigsDropdown = ConfigSection:Dropdown({
    Title = "All Configs",
    Values = AllConfigs,
    Value = "default",
    Callback = function(value)
        ConfigName = value
        pcall(function() ConfigNameInput:Set(value) end)
    end,
})

ConfigSection:Divider()

ActionGroup = ConfigSection:Group({})

ActionGroup:Button({
    Title = "Save",
    Icon = "save",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:Config(ConfigName)
        pcall(function() Window.CurrentConfig:Save() end)
        pcall(function() AllConfigsDropdown:Refresh(ConfigManager:AllConfigs()) end)
        safeNotify("Config", "Saved: " .. ConfigName, 2)
    end,
})

ActionGroup:Button({
    Title = "Load",
    Icon = "download",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
        pcall(function() Window.CurrentConfig:Load() end)
        safeNotify("Config", "Loaded: " .. ConfigName, 2)
    end,
})

ConfigSection:Button({
    Title = "Delete",
    Icon = "trash",
    Callback = function()
        pcall(function() ConfigManager:DeleteConfig(ConfigName) end)
        ConfigName = "default"
        pcall(function() ConfigNameInput:Set("default") end)
        pcall(function() AllConfigsDropdown:Refresh(ConfigManager:AllConfigs()) end)
        safeNotify("Config", "Deleted config", 2)
    end,
})

---------------------------------------------------
--== INITIALIZE WORLD LOOP ==--
---------------------------------------------------
if anyWorldEnabled then
    startWorldLoop()
end

---------------------------------------------------
--== FINAL INITIALIZATION ==--
---------------------------------------------------
WindUI:Notify({
    Title = "ArexansTools | Violence District",
    Content = "Script loaded! Press V to toggle UI.\nExecutor: " .. executorName,
    Duration = 5,
    Icon = "bell"
})

pcall(function() Window:SelectTab(1) end)
pcall(function()
    if Window.UnlockAll then
        Window:UnlockAll()
    end
end)

local windowOpened = pcall(function()
    Window:Open()
end)
if not windowOpened then
    pcall(function()
        if Window.Toggle then
            Window:Toggle(true)
        end
    end)
end

---------------------------------------------------
--== CROSSHAIR SYSTEM ==--
---------------------------------------------------
crosshairMap = {
    ["crosshair dot"] = "rbxassetid://15240614328",
    ["crosshair dot 2"] = "rbxassetid://125887405613260",
    ["crosshair square"] = "rbxassetid://95081014476249",
    ["crosshair +â€¢"] = "rbxassetid://13011888817",
    ["crosshair +"] = "rbxassetid://6587895205",
    ["crosshair O+"] = "rbxassetid://14599258630",
    ["crosshair O+ 2"] = "rbxassetid://96025442253083",
    ["Croshair (+)"] = "rbxassetid://135489154238728",
    ["Crosshair [ â€¢ ]"] = "rbxassetid://101370742207347",
    ["Crosshair [O+]"] = "rbxassetid://92175000437419",
    ["Crosshair star"] = "rbxassetid://16575721101"
}

CrosshairEnabled = false
CrosshairType = "crosshair dot"
CrosshairGui, CrosshairImage = nil

function CreateCrosshair()
    local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    if CrosshairGui then
        CrosshairGui:Destroy()
    end

    CrosshairGui = Instance.new("ScreenGui")
    CrosshairGui.Name = "ArexansCrosshair"
    CrosshairGui.ResetOnSpawn = false
    CrosshairGui.IgnoreGuiInset = true
    CrosshairGui.Parent = pg

    CrosshairImage = Instance.new("ImageLabel")
    CrosshairImage.Name = "Crosshair"
    CrosshairImage.AnchorPoint = Vector2.new(0.5,0.5)
    CrosshairImage.Position = UDim2.new(0.5,0,0.5,0)
    CrosshairImage.Size = UDim2.fromOffset(42,42)
    CrosshairImage.BackgroundTransparency = 1
    CrosshairImage.Image = crosshairMap[CrosshairType] or "rbxassetid://15240614328"
    CrosshairImage.Visible = false
    CrosshairImage.ZIndex = 999999
    CrosshairImage.Parent = CrosshairGui
end

function UpdateCrosshair()
    if not CrosshairImage then CreateCrosshair() end
    CrosshairImage.Image = crosshairMap[CrosshairType] or "rbxassetid://15240614328"
    CrosshairImage.Visible = CrosshairEnabled
end

CreateCrosshair()

registerArexansGuiGuard("Crosshair", function()
    return CrosshairGui
end, function()
    -- ScreenGui crosshair harus tetap Enabled; ImageLabel-nya yang mengikuti toggle.
    return true
end, function()
    if CrosshairImage then
        CrosshairImage.Visible = CrosshairEnabled
    end
end)

pcall(function()
    local CrosshairSection = VisualTab:Section({
        Title = "Crosshair",
        Icon = "crosshair",
        Opened = true
    })

    CrosshairSection:Toggle({
        Title = "Crosshair ON/OFF",
        Value = false,
        Callback = function(v)
            CrosshairEnabled = v
            UpdateCrosshair()
        end
    })

    CrosshairSection:Dropdown({
        Title = "Crosshair Type",
        Values = {
            "crosshair dot",
            "crosshair dot 2",
            "crosshair square",
            "crosshair +â€¢",
            "crosshair +",
            "crosshair O+",
            "crosshair O+ 2",
            "Croshair (+)",
            "Crosshair [ â€¢ ]",
            "Crosshair [O+]",
            "Crosshair star"
        },
        Default = "crosshair dot",
        Callback = function(v)
            CrosshairType = v
            UpdateCrosshair()
        end
    })
end)


---------------------------------------------------
--== MOBILE JUMP BUTTON ==--
---------------------------------------------------
playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Bersihkan semua ArexansJumpButton dari execute sebelumnya, bukan hanya 1 instance.
for _, oldGui in ipairs(playerGui:GetChildren()) do
    if oldGui.Name == "ArexansJumpButton" then
        oldGui:Destroy()
    end
end

JumpButtonGuiVisibleState = false
JumpGui = nil
JumpButton = nil

-- Icon yang dilingkari biasanya adalah JumpButton bawaan Roblox/TouchGui.
-- Sembunyikan juga supaya saat toggle OFF tidak ada icon jump yang tersisa/duplikat.
HIDE_NATIVE_JUMP_BUTTON = false
function hideForeignJumpButtons()
    if not HIDE_NATIVE_JUMP_BUTTON then return end

    local pg = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return end

    for _, obj in ipairs(pg:GetDescendants()) do
        if obj:IsA("GuiButton") then
            local ownGui = obj:FindFirstAncestor("ArexansJumpButton")
            local name = tostring(obj.Name):lower()
            local parentName = tostring(obj.Parent and obj.Parent.Name or ""):lower()

            -- Target umum: PlayerGui.TouchGui.TouchControlFrame.JumpButton
            -- dan variasi nama tombol jump dari game/emulator.
            local isJumpButton = name == "jumpbutton"
                or name:find("jump") ~= nil
                or parentName:find("jump") ~= nil

            if isJumpButton and not ownGui then
                pcall(function() obj.Visible = false end)
                pcall(function() obj.Active = false end)
                pcall(function() obj.Selectable = false end)
                pcall(function() obj.AutoButtonColor = false end)
            end
        end
    end
end

hideForeignJumpButtons()

-- Kalau TouchGui dibuat ulang setelah respawn/teleport/cutscene, langsung sembunyikan lagi.
playerGui.DescendantAdded:Connect(function(obj)
    task.defer(function()
        if obj and obj.Parent then
            hideForeignJumpButtons()
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(2)
        hideForeignJumpButtons()
    end
end)

JumpGui = Instance.new("ScreenGui")
JumpGui.Name = "ArexansJumpButton"
JumpGui.ResetOnSpawn = false
JumpGui.IgnoreGuiInset = true
JumpGui.Enabled = false -- hidden on execute
JumpGui.Parent = playerGui

JumpButton = Instance.new("ImageButton")
JumpButton.Size = UDim2.fromOffset(70,70)
JumpButton.AnchorPoint = Vector2.new(1,1)
JumpButton.Position = UDim2.new(1,-20,1,-20) -- locked to bottom-right corner
JumpButton.BackgroundTransparency = 1
JumpButton.Image = "rbxassetid://120976481677763"
JumpButton.Visible = false -- jangan tampil saat pertama execute
JumpButton.Parent = JumpGui

registerArexansGuiGuard("JumpButton", function()
    return JumpGui
end, function()
    return JumpButtonGuiVisibleState
end, function()
    if JumpButton then
        JumpButton.Visible = JumpButtonGuiVisibleState == true
    end
    hideForeignJumpButtons()
end)

JumpButton.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and JumpButtonGuiVisibleState then
        pcall(function()
            hum.UseJumpPower = true
            hum.JumpPower = 40
            hum.JumpHeight = 15
        end)
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        hum.Jump = true
    end
end)


---------------------------------------------------
--== MOBILE ZIGGLE + MOONWALK ICONS ==--
---------------------------------------------------
pcall(function()
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local ContentProvider = game:GetService("ContentProvider")

    for _, guiName in ipairs({"ArexansZiggleButton", "ArexansMoonwalkButton", "ArexansZiggleMoonwalkComboButton"}) do
        local oldGui = playerGui:FindFirstChild(guiName)
        if oldGui then oldGui:Destroy() end
    end

    local function buildIconCandidates(assetInfo)
        if type(assetInfo) == "table" then
            local candidates = {}
            if assetInfo.TextureId then
                table.insert(candidates, "rbxassetid://" .. tostring(assetInfo.TextureId))
            end
            if assetInfo.AssetId then
                table.insert(candidates, "rbxassetid://" .. tostring(assetInfo.AssetId))
                table.insert(candidates, "rbxthumb://type=Asset&id=" .. tostring(assetInfo.AssetId) .. "&w=150&h=150")
            end
            return candidates
        end
        return { "rbxassetid://" .. tostring(assetInfo) }
    end

    local function applyIconImage(button, assetInfo)
        local candidates = buildIconCandidates(assetInfo)
        button.Image = candidates[1] or ""

        -- Coba texture ID dulu. Jika image belum berhasil dimuat, coba asset ID dan thumbnail asset.
        task.spawn(function()
            for _, image in ipairs(candidates) do
                pcall(function()
                    button.Image = image
                    ContentProvider:PreloadAsync({ image })
                end)
                task.wait(0.25)

                local loaded = false
                pcall(function()
                    loaded = button.IsLoaded or (button.ContentImageSize and button.ContentImageSize.X > 0)
                end)
                if loaded then
                    break
                end
            end
        end)
    end

    local function createMobileFeatureIcon(guiName, assetId, orderIndex, clickCallback)
        local gui = Instance.new("ScreenGui")
        gui.Name = guiName
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 999999
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Enabled = false -- tidak langsung muncul saat execute
        gui.Parent = playerGui

        local button = Instance.new("ImageButton")
        button.Name = guiName .. "Icon"
        button.Size = UDim2.fromOffset(40, 40)
        button.Visible = false
        button.AnchorPoint = Vector2.new(1, 1)
        button.BackgroundColor3 = Color3.fromRGB(10, 30, 58)
        button.BackgroundTransparency = 0.22
        applyIconImage(button, assetId)
        button.ScaleType = Enum.ScaleType.Fit
        button.AutoButtonColor = true
        button.Active = true
        button.ZIndex = 999999
        button.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = button

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.15
        stroke.Color = Color3.fromRGB(0, 191, 255)
        stroke.Transparency = 0.08
        stroke.Parent = button


        if getgenv().ArexansAttachLongPressDragToFeatureButton then
            getgenv().ArexansAttachLongPressDragToFeatureButton(button)
        end

        button.MouseButton1Click:Connect(function()
            if getgenv().ArexansShouldSuppressFeatureIconClick and getgenv().ArexansShouldSuppressFeatureIconClick() then
                return
            end
            pcall(clickCallback)
        end)

        return gui, button
    end

    local ZiggleMobileGui, ZiggleMobileButton = createMobileFeatureIcon("ArexansZiggleButton", "13372604596", 1, function()
        -- Tap icon layar untuk ON/OFF fitur asli. Toggle window hanya show/hide icon.
        getgenv().ArexansToggleZiggle(not featureStates.Ziggle)
    end)

    local MoonwalkMobileGui, MoonwalkMobileButton = createMobileFeatureIcon("ArexansMoonwalkButton", {
        TextureId = "119610527815470",
        AssetId = "130761387850637",
    }, 2, function()
        -- Tap icon layar untuk ON/OFF fitur asli. Toggle window hanya show/hide icon.
        toggleMoonwalk(not featureStates.MoonWalk)
    end)


    local ZiggleMoonwalkComboMobileGui, ZiggleMoonwalkComboMobileButton = createMobileFeatureIcon("ArexansZiggleMoonwalkComboButton", "122503252139031", 3, function()
        getgenv().ArexansToggleZiggleMoonwalkCombo(not featureStates.ZiggleMoonwalkCombo)
    end)

    getgenv().ArexansSetFeatureMobileIconRefs(ZiggleMobileGui, ZiggleMobileButton, MoonwalkMobileGui, MoonwalkMobileButton, ZiggleMoonwalkComboMobileGui, ZiggleMoonwalkComboMobileButton)

    registerArexansGuiGuard("ZiggleMobile", function()
        return ZiggleMobileGui
    end, function()
        return featureStates.ZiggleIconVisible
    end, function()
        if getgenv().ArexansRefreshZiggleMobileIcon then
            getgenv().ArexansRefreshZiggleMobileIcon()
        end
    end)

    registerArexansGuiGuard("MoonwalkMobile", function()
        return MoonwalkMobileGui
    end, function()
        return featureStates.MoonWalkIconVisible
    end, function()
        if getgenv().ArexansRefreshMoonwalkMobileIcon then
            getgenv().ArexansRefreshMoonwalkMobileIcon()
        end
    end)


    registerArexansGuiGuard("ZiggleMoonwalkComboMobile", function()
        return ZiggleMoonwalkComboMobileGui
    end, function()
        return featureStates.ZiggleMoonwalkComboIconVisible
    end, function()
        if getgenv().ArexansRefreshZiggleMoonwalkComboMobileIcon then
            getgenv().ArexansRefreshZiggleMoonwalkComboMobileIcon()
        end
    end)

    getgenv().ArexansSetZiggleMoonwalkComboMobileIconVisible(featureStates.ZiggleMoonwalkComboIconVisible)
    getgenv().ArexansSetZiggleMobileIconVisible(featureStates.ZiggleIconVisible)
    getgenv().ArexansSetMoonwalkMobileIconVisible(featureStates.MoonWalkIconVisible)
end)


---------------------------------------------------
--== LINE ESP + HSV COLOR ==--
---------------------------------------------------
featureStates.LineESP = false
featureStates.LineESPColor = Color3.fromHSV(0,1,1)

lineEspObjects = {}

function clearLineESP()
    for _,v in pairs(lineEspObjects) do
        pcall(function() v:Remove() end)
    end
    table.clear(lineEspObjects)
end


pcall(function()
    local LineESPSection = ESPTab:Section({
        Title = "Line ESP",
        Icon = "scan",
        Opened = true
    })

    LineESPSection:Toggle({
        Title = "Enable Line ESP",
        Callback = function(v)
            featureStates.LineESP = v
        end
    })

    LineESPSection:Slider({
        Title = "HSV Color",
        Step = 0.01,
        Value = {Min = 0, Max = 1, Default = 0},
        Callback = function(h)
            featureStates.LineESPColor = Color3.fromHSV(h,1,1)
        end
    })
end)

---------------------------------------------------
--== GENERATOR PROGRESS ESP ==--
---------------------------------------------------
function UpdateGeneratorPercentESP()
    -- Legacy progress ESP dimatikan default agar tidak double-scan map.
    -- Aktifkan manual jika benar-benar perlu: getgenv().ArexansLegacyGeneratorPercentESP = true
    if getgenv().ArexansLegacyGeneratorPercentESP ~= true then
        return
    end

    -- Progress bar patch di bawah sudah menampilkan persen generator.
    -- Jangan scan seluruh map berulang-ulang saat patch baru aktif karena itu bikin gameplay patah-patah.
    if getgenv().ArexansGeneratorProgressBar ~= false then
        return
    end

    if not featureStates.GeneratorESP then return end

    local myChar = LocalPlayer.Character
    if not myChar then return end

    local map = workspace:FindFirstChild("Map")
    if not map then return end

    for _,obj in ipairs(map:GetDescendants()) do
        if obj.Name == "Generator" and obj:IsA("Model") then
            local progress = obj:FindFirstChild("Progress")

            if progress and progress:IsA("NumberValue") then
                local billboard = obj:FindFirstChild("GeneratorPercentESP")

                if not billboard then
                    billboard = Instance.new("BillboardGui")
                    billboard.Name = "GeneratorPercentESP"
                    billboard.Size = UDim2.fromOffset(120,40)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = obj

                    local label = Instance.new("TextLabel")
                    label.Name = "Text"
                    label.Size = UDim2.fromScale(1,1)
                    label.BackgroundTransparency = 1
                    label.TextScaled = true
                    label.TextColor3 = Color3.new(1,1,1)
                    label.Parent = billboard
                end

                local percent = math.clamp(math.floor(progress.Value),0,100)
                billboard.Text.Text = "âš¡ "..percent.."%"
            end
        end
    end
end

task.spawn(function()
    while true do
        pcall(UpdateGeneratorPercentESP)
        task.wait(1)
    end
end)



--[[ AREXANS PATCH: Jump Toggle + Improved Line ESP + HSV Notes ]]
pcall(function()
    if JumpButton and PlayerTab then

        -- NOTE: WindUI's real init parameter is "Value", not "Default".
        -- "Default" is silently ignored by the library, so the toggle was
        -- always falling back to WindUI's own internal default (true/ON),
        -- which is exactly why the custom jump button kept appearing by
        -- itself the instant the script was executed.
        --
        -- This toggle ONLY shows/hides our own ArexansJumpButton GUI.
        -- It never touches position and never swaps with anything else,
        -- so the button always stays locked in the bottom-right corner
        -- and just fades in/out when switched on/off.
        PlayerTab:Toggle({
            Title = "Show Jump Button",
            Value = false,
            Callback = function(state)
                JumpButtonGuiVisibleState = state == true
                if JumpGui then
                    JumpGui.Enabled = JumpButtonGuiVisibleState
                end
                if JumpButton then
                    JumpButton.Visible = JumpButtonGuiVisibleState
                end
                hideForeignJumpButtons()

                -- Blokir atau pulihkan kemampuan lompat sesuai state
                local char = game.Players.LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if JumpButtonGuiVisibleState then
                        -- Aktifkan jump dengan power yang disesuaikan
                        pcall(function()
                            hum.UseJumpPower = true
                            hum.JumpPower = 40
                            hum.JumpHeight = 15
                        end)
                    else
                        -- Matikan jump sama sekali agar tidak bisa lompat otomatis
                        pcall(function()
                            hum.UseJumpPower = true
                            hum.JumpPower = 0
                            hum.JumpHeight = 0
                        end)
                    end
                end
            end
        })

        local function applyJumpBlock()
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum.UseJumpPower = true
                    hum.JumpPower = 0
                    hum.JumpHeight = 0
                end)
            end
        end

        applyJumpBlock()
        game.Players.LocalPlayer.CharacterAdded:Connect(function()
            task.wait(1)
            if not JumpButtonGuiVisibleState then
                applyJumpBlock()
            end
        end)

        -- Paksa JumpPower tetap 0 selama Show Jump Button OFF
        -- Ini mencegah auto-jump saat mendekati objek pendek
        task.spawn(function()
            while true do
                task.wait(0.5)
                if not JumpButtonGuiVisibleState then
                    local char2 = game.Players.LocalPlayer.Character
                    local hum2 = char2 and char2:FindFirstChildOfClass("Humanoid")
                    if hum2 then
                        pcall(function()
                            if hum2.JumpPower ~= 0 then hum2.JumpPower = 0 end
                            if hum2.JumpHeight ~= 0 then hum2.JumpHeight = 0 end
                        end)
                    end
                end
            end
        end)
    end
end)

-- Improved Line ESP update

-- HSV slider already uses Color3.fromHSV(h,1,1).
-- UI gradient coloring must be supported by the UI library itself.



-- =========================================================
-- PATCH v2 : Line ESP
-- =========================================================
-- NOTE: Duplicate Jump click-handler removed here.
-- JumpButton already has its click logic connected once,
-- right where it was created (see "MOBILE JUMP BUTTON" section).
-- Connecting MouseButton1Click a second time made every tap
-- fire the jump action twice and served no real purpose
-- (the local "jumpEnabled" flag here was never wired to the
-- actual "Show Jump Button" toggle, so it always stayed true).

-- Improved Line ESP
getgenv().LineESPUseHSV = true
getgenv().LineESPMatchObjectColor = false

pcall(function()
    RunService.RenderStepped:Connect(function()
        if not featureStates.LineESP then
            clearLineESP()
            return
        end

        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local myPos, myVisible = Camera:WorldToViewportPoint(myRoot.Position)
        if not myVisible then return end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then

                    lineEspObjects = lineEspObjects or {}

                    if not lineEspObjects[plr] then
                        local line = Drawing.new("Line")
                        line.Thickness = 2
                        line.Transparency = 0.55 -- sedikit pudar
                        lineEspObjects[plr] = line
                    end

                    local line = lineEspObjects[plr]
                    local pos, visible = Camera:WorldToViewportPoint(root.Position)

                    if visible then
                        line.Visible = true

                        -- garis menempel dari tubuh player sendiri
                        line.From = Vector2.new(myPos.X, myPos.Y)
                        line.To = Vector2.new(pos.X, pos.Y)

                        if getgenv().LineESPMatchObjectColor then
                            local espData = espObjects and espObjects[plr.Character]
                            if espData and espData.color then
                                line.Color = espData.color
                            end
                        elseif getgenv().LineESPUseHSV then
                            local h = (tick() * 0.08) % 1
                            line.Color = Color3.fromHSV(h,1,1)
                        elseif featureStates.LineESPColor then
                            line.Color = featureStates.LineESPColor
                        end
                    else
                        line.Visible = false
                    end
                end
            end
        end
    end)
end)
-- =========================================================
-- THE VEIL SPEAR TRAJECTORY LINE SYSTEM v7 TRUE-CHARGE 3D
-- Garis tombak dibuat charge-only:
-- 1) Tidak aktif dari sentuhan joystick/kamera biasa.
-- 2) Baru muncul saat input throw/skill di-hold atau state/animasi charge terbaca.
-- 3) Arah memakai ray kamera/crosshair -> titik bidik 3D, lalu diproyeksikan ke layar.
-- 4) World Beam 3D + Drawing overlay dibuat sekali dan hanya di-update ketika charge.
-- =========================================================
pcall(function()
    local token = tostring(tick()) .. "_" .. tostring(math.random(100000, 999999))
    getgenv().ArexansVeilSpearTrajectoryToken = token

    local SEG_COUNT          = 72
    local SEG_THICKNESS      = 2.0
    local UPDATE_INTERVAL    = 0
    local CACHE_INTERVAL     = 0.025
    local CHARGE_DURATION    = 1.55
    local CHARGE_ARM_DELAY   = 0.065
    local RELEASE_GRACE      = 0.08
    local MAX_AIM_DISTANCE   = 6200
    local RAYCAST_EVERY      = 1
    -- Anchor layar dibuat dari sisi kanan-bawah supaya garis tidak lagi keluar dari tengah layar,
    -- tetapi sejajar dengan posisi lengan/tombak The Veil di viewmodel.
    local SCREEN_LAUNCH_X    = 0.735
    local SCREEN_LAUNCH_Y    = 0.685
    local SCREEN_LAUNCH_DEPTH = 3.75
    local FIRST_PERSON_DIST  = 4.2
    -- Gravitasi visual dibuat lebih nyata supaya garis tombak tidak lurus seperti peluru.
    local TRAJECTORY_GRAVITY_SCALE = 0.34
    getgenv().ArexansVeilSpearGravityScale = TRAJECTORY_GRAVITY_SCALE
    -- Radius dibuat lebih ketat supaya warna biru hanya muncul saat jalur tombak benar-benar layak kena.
    local PLAYER_HIT_RADIUS = 0.45
    local PROJECTILE_RADIUS = 0.34
    local MOVING_TARGET_LEAD_CAP = 0.62
    local COLOR_LOW_POWER    = Color3.fromRGB(255, 0, 0)
    local COLOR_FULL_POWER   = Color3.fromRGB(255, 0, 0)
    local COLOR_PLAYER_HIT   = Color3.fromRGB(0, 110, 255)

    local GuiService
    pcall(function() GuiService = game:GetService("GuiService") end)

    local VirtualInputManager
    pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

    local activeChargeInputs = {}
    local chargeStartTime    = nil
    local lastReleaseTime    = 0
    local lastUpdate         = 0
    local lastCacheUpdate    = 0
    local cachedWeapon       = nil
    local cachedLaunchPart   = nil
    local cachedAllowed      = false
    local cachedActualCharge = false
    local smoothedOrigin     = nil
    local smoothedDirection  = nil
    local cachedViewmodelPart = nil
    local lastViewmodelScan  = 0

    local autoHoldGui        = nil
    local autoHoldButton     = nil
    local autoHoldActive     = false
    local autoHoldPressPos   = nil
    local autoHoldVirtualDown = false
    local autoHoldSyntheticInput = { __arexansVeilSpearAutoHold = true }

    local canDraw = (type(Drawing) == "table" and type(Drawing.new) == "function")
    local screenLines = {}
    if canDraw then
        for i = 1, SEG_COUNT do
            local ln = Drawing.new("Line")
            ln.Thickness = SEG_THICKNESS
            ln.Color = COLOR_LOW_POWER
            ln.Transparency = 1
            ln.Visible = false
            screenLines[i] = ln
        end
    end

    local worldFolderName = "__ArexansVeilSpearTrajectory3D"
    pcall(function()
        local old = workspace:FindFirstChild(worldFolderName)
        if old then old:Destroy() end
    end)

    local worldFolder = Instance.new("Folder")
    worldFolder.Name = worldFolderName
    worldFolder.Parent = workspace

    local worldBeams = table.create(SEG_COUNT)
    local terrain = workspace:FindFirstChildOfClass("Terrain") or workspace.Terrain
    pcall(function()
        if terrain then
            for _, child in ipairs(terrain:GetChildren()) do
                if tostring(child.Name):find("__ArexansVeilSpearTrajectory3D_", 1, true) then
                    child:Destroy()
                end
            end
        end
    end)

    for i = 1, SEG_COUNT do
        local a0 = Instance.new("Attachment")
        a0.Name = "__ArexansVeilSpearTrajectory3D_A0_" .. i
        a0.Parent = terrain

        local a1 = Instance.new("Attachment")
        a1.Name = "__ArexansVeilSpearTrajectory3D_A1_" .. i
        a1.Parent = terrain

        local beam = Instance.new("Beam")
        beam.Name = "VeilSpear3D_" .. i
        beam.Attachment0 = a0
        beam.Attachment1 = a1
        beam.FaceCamera = true
        beam.LightEmission = 0.25
        beam.LightInfluence = 0
        beam.Width0 = 0.065
        beam.Width1 = 0.065
        beam.Color = ColorSequence.new(COLOR_LOW_POWER)
        beam.Transparency = NumberSequence.new(0.20)
        beam.Enabled = false
        beam.Parent = worldFolder

        worldBeams[i] = { beam = beam, a0 = a0, a1 = a1 }
    end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.IgnoreWater = true

    local function hideAllLines()
        smoothedOrigin = nil
        smoothedDirection = nil

        if canDraw then
            for i = 1, SEG_COUNT do
                if screenLines[i] then screenLines[i].Visible = false end
            end
        end
        for i = 1, SEG_COUNT do
            local item = worldBeams[i]
            if item and item.beam then item.beam.Enabled = false end
        end
    end

    local function lowerText(v)
        return string.lower(tostring(v or ""))
    end

    local function containsAny(text, words)
        text = lowerText(text)
        for _, w in ipairs(words) do
            if text:find(w, 1, true) then
                return true
            end
        end
        return false
    end

    local weaponWords = {
        "veil", "spear", "tombak", "lance", "javelin", "harpoon", "trident", "skewer", "impale"
    }

    local chargeWords = {
        "charge", "charging", "charged", "hold", "holding", "aim", "aiming", "power",
        "windup", "wind up", "prepare", "ready", "throw", "throwspear", "spear throw",
        "projectile", "cast", "shoot", "fire"
    }

    local auraWords = {
        "aura", "aurora", "glow", "glowing", "charged", "fullcharge", "full charge",
        "empower", "empowered", "energy", "pierce", "piercing", "penetrate", "wall",
        "phase", "through", "breakwall", "wallbang", "veil aura"
    }

    local badGuiWords = {
        "joystick", "thumbstick", "move", "walk", "sprint", "shift", "camera", "menu",
        "chat", "backpack", "inventory", "emote", "jump", "crouch", "setting", "settings",
        "arexans", "windui", "aimbot", "esp", "teleport", "visual", "config",
        "toggle", "slider", "dropdown", "section", "tab", "window", "min speed", "max speed"
    }

    local goodGuiWords = {
        "veil", "spear", "tombak", "throw", "charge", "attack", "slash", "stab", "skill",
        "ability", "m1", "shoot", "fire", "use", "activate", "weapon"
    }

    local function nameLooksVeilSpear(name)
        return containsAny(name, weaponWords)
    end

    local function readGuiText(obj)
        local text = tostring(obj and obj.Name or "")
        pcall(function()
            if obj.Text then text = text .. " " .. tostring(obj.Text) end
        end)
        pcall(function()
            if obj.ContentText then text = text .. " " .. tostring(obj.ContentText) end
        end)
        pcall(function()
            if obj.ToolTip then text = text .. " " .. tostring(obj.ToolTip) end
        end)
        return lowerText(text)
    end

    local function guiObjectLooksChargeButton(obj)
        local current = obj
        for _ = 1, 7 do
            if not current then break end
            local currentName = lowerText(current.Name)
            if currentName == "arexansveilspearautoholdgui"
                or currentName == "arexansveilspearautoholdbutton"
                or currentName:find("arexansautohold", 1, true) then
                return false
            end
            local text = readGuiText(current)
            if containsAny(text, badGuiWords) then return false end
            if containsAny(text, goodGuiWords) then return true end
            current = current.Parent
        end
        return false
    end

    local function getGuiObjectsAtPosition(pos)
        local objects = {}
        pcall(function()
            local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if pg and pg.GetGuiObjectsAtPosition then
                objects = pg:GetGuiObjectsAtPosition(pos.X, pos.Y)
            elseif GuiService and GuiService.GetGuiObjectsAtPosition then
                objects = GuiService:GetGuiObjectsAtPosition(pos.X, pos.Y)
            end
        end)
        return objects
    end

    local function inputPosition(input)
        if input and input.Position then
            return Vector2.new(input.Position.X, input.Position.Y)
        end
        local ok, mousePos = pcall(function()
            return UserInputService:GetMouseLocation()
        end)
        if ok and mousePos then return Vector2.new(mousePos.X, mousePos.Y) end
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
        return Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    end

    local function positionIsChargeZone(pos)
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
        -- Mobile: tombol throw/skill biasanya di area kanan bawah/tengah kanan.
        -- Area kiri, topbar, dan joystick tidak dianggap sebagai charge.
        return pos.X >= (vp.X * 0.58)
            and pos.Y >= (vp.Y * 0.32)
            and pos.Y <= (vp.Y * 0.96)
    end

    local function inputStartedOnChargeControl(input, gpe)
        if not input then return false end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- PC: click biasa tidak langsung menampilkan garis; harus hold melewati CHARGE_ARM_DELAY.
            return true
        end

        if input.UserInputType == Enum.UserInputType.Touch then
            local pos = inputPosition(input)
            local guiObjects = getGuiObjectsAtPosition(pos)
            for _, obj in ipairs(guiObjects) do
                if autoHoldGui and obj and obj:IsDescendantOf(autoHoldGui) then
                    return false
                end
                if guiObjectLooksChargeButton(obj) then
                    return true
                end
            end
            return positionIsChargeZone(pos)
        end

        if input.UserInputType == Enum.UserInputType.Gamepad1 then
            return input.KeyCode == Enum.KeyCode.ButtonR2
                or input.KeyCode == Enum.KeyCode.ButtonR1
                or input.KeyCode == Enum.KeyCode.ButtonL2
                or input.KeyCode == Enum.KeyCode.ButtonL1
        end

        if input.UserInputType == Enum.UserInputType.Keyboard then
            return input.KeyCode == Enum.KeyCode.Q
                or input.KeyCode == Enum.KeyCode.E
                or input.KeyCode == Enum.KeyCode.R
                or input.KeyCode == Enum.KeyCode.F
                or input.KeyCode == Enum.KeyCode.One
                or input.KeyCode == Enum.KeyCode.Two
                or input.KeyCode == Enum.KeyCode.Three
        end

        return false
    end

    local function getEquippedVeilSpearWeapon()
        local char = LocalPlayer and LocalPlayer.Character
        if not char then return nil end

        local tool = char:FindFirstChildWhichIsA("Tool")
        if tool and nameLooksVeilSpear(tool.Name) then
            return tool
        end

        local directFolders = {
            char:FindFirstChild("Weapon"),
            char:FindFirstChild("Weapons"),
            char:FindFirstChild("KillerWeapon"),
            char:FindFirstChild("Knife"),
            char:FindFirstChild("Spear"),
        }

        for _, folder in ipairs(directFolders) do
            if folder then
                if nameLooksVeilSpear(folder.Name) then return folder end
                for _, child in ipairs(folder:GetChildren()) do
                    if nameLooksVeilSpear(child.Name) then return child end
                end
            end
        end

        for _, child in ipairs(char:GetChildren()) do
            if nameLooksVeilSpear(child.Name) then
                return child
            end
        end

        -- Fallback terakhir: cari descendant yang jelas-jelas model tombak/veil, tetapi batasi supaya ringan.
        local scanned = 0
        for _, obj in ipairs(char:GetDescendants()) do
            scanned += 1
            if scanned > 160 then break end
            if nameLooksVeilSpear(obj.Name) and (obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart")) then
                return obj
            end
        end

        return nil
    end

    local function findFirstNamedPart(root, names)
        if not root then return nil end
        for _, n in ipairs(names) do
            local found = root:FindFirstChild(n, true)
            if found and found:IsA("BasePart") then
                return found
            end
        end
        return nil
    end

    local function findBestLaunchPart(root)
        if not root then return nil end
        if root:IsA("BasePart") then return root end

        local priority = {
            "Tip", "SpearTip", "TombakTip", "ProjectileSpawn", "ThrowPoint", "FirePoint",
            "Muzzle", "AimPoint", "AimPart", "Point", "ArrowTip", "ArrowHead",
            "BladeTip", "SpearHead", "Head", "Handle", "Shaft", "Blade"
        }

        local byName = findFirstNamedPart(root, priority)
        if byName then return byName end

        if root:IsA("Tool") then
            local handle = root:FindFirstChild("Handle") or root:FindFirstChildWhichIsA("BasePart")
            if handle and handle:IsA("BasePart") then return handle end
        end

        return root:FindFirstChildWhichIsA("BasePart", true)
    end

    local function localPlayerLooksLikeVeilKiller(weapon)
        local char = LocalPlayer and LocalPlayer.Character
        if not char then return false end
        if weapon and nameLooksVeilSpear(weapon.Name) then return true end

        local okRole, role = pcall(function()
            return getRole and getRole(LocalPlayer)
        end)
        if okRole and lowerText(role) == "killer" then return true end

        if LocalPlayer.Team and lowerText(LocalPlayer.Team.Name):find("killer", 1, true) then return true end
        if char:FindFirstChild("Killerost") or char:FindFirstChild("Lookscriptkiller") then return true end

        return weapon ~= nil
    end

    local function valueObjectIndicatesCharge(obj)
        local name = lowerText(obj and obj.Name)
        if not containsAny(name, chargeWords) then return false end

        local ok, value = pcall(function() return obj.Value end)
        if not ok then return false end

        if typeof(value) == "boolean" then return value == true end
        if typeof(value) == "number" then return value > 0 end
        if typeof(value) == "string" then
            local v = lowerText(value)
            if v == "" or v == "false" or v == "idle" or v == "none" or v == "0" then return false end
            return containsAny(v, chargeWords) or v == "true"
        end

        return false
    end

    local function attributesIndicateCharge(obj)
        if not obj or not obj.GetAttributes then return false end
        local ok, attrs = pcall(function() return obj:GetAttributes() end)
        if not ok or not attrs then return false end
        for k, v in pairs(attrs) do
            local name = lowerText(k)
            if containsAny(name, chargeWords) then
                if typeof(v) == "boolean" and v == true then return true end
                if typeof(v) == "number" and v > 0 then return true end
                if typeof(v) == "string" and containsAny(v, chargeWords) then return true end
            end
        end
        return false
    end

    local function descendantsIndicateCharge(root, limit)
        if not root then return false end
        if attributesIndicateCharge(root) then return true end
        local scanned = 0
        for _, obj in ipairs(root:GetDescendants()) do
            scanned += 1
            if scanned > (limit or 180) then break end
            if attributesIndicateCharge(obj) then return true end
            if obj:IsA("BoolValue") or obj:IsA("NumberValue") or obj:IsA("IntValue") or obj:IsA("StringValue") then
                if valueObjectIndicatesCharge(obj) then return true end
            end
        end
        return false
    end

    local function playingAnimationIndicatesCharge()
        local char = LocalPlayer and LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end

        local tracks = {}
        pcall(function() tracks = hum:GetPlayingAnimationTracks() end)
        for _, track in ipairs(tracks) do
            local name = lowerText(track.Name)
            pcall(function()
                if track.Animation then
                    name = name .. " " .. lowerText(track.Animation.Name) .. " " .. lowerText(track.Animation.AnimationId)
                end
            end)

            local hasCharge = containsAny(name, {"charge", "hold", "aim", "wind", "prepare", "ready", "power"})
            local hasWeapon = containsAny(name, {"veil", "spear", "tombak", "throw", "projectile", "javelin"})
            local blocked = containsAny(name, {"idle", "walk", "run", "jump", "fall", "land"})
            if track.IsPlaying and not blocked and (hasCharge or (hasWeapon and containsAny(name, {"throw", "aim"}))) then
                return true
            end
        end
        return false
    end

    local function actualChargeStateDetected()
        local char = LocalPlayer and LocalPlayer.Character
        if not char then return false end
        if playingAnimationIndicatesCharge() then return true end
        if descendantsIndicateCharge(cachedWeapon, 140) then return true end
        if descendantsIndicateCharge(char, 220) then return true end
        return false
    end

    local function refreshWeaponCache(force)
        local now = tick()
        if not force and (now - lastCacheUpdate) < CACHE_INTERVAL then return end
        lastCacheUpdate = now
        cachedWeapon = getEquippedVeilSpearWeapon()
        cachedLaunchPart = findBestLaunchPart(cachedWeapon)
        cachedAllowed = localPlayerLooksLikeVeilKiller(cachedWeapon)
        cachedActualCharge = actualChargeStateDetected()
    end

    local function isValidVeilSpearWeapon()
        return cachedWeapon ~= nil
            and cachedWeapon.Parent ~= nil
            and cachedLaunchPart ~= nil
            and cachedLaunchPart.Parent ~= nil
            and cachedAllowed == true
    end

    local function heldChargeInputReady()
        local now = tick()
        local ready = false
        for input, data in pairs(activeChargeInputs) do
            if not input or not data then
                activeChargeInputs[input] = nil
            elseif (now - (data.startedAt or now)) >= CHARGE_ARM_DELAY then
                ready = true
            end
        end
        return ready
    end

    local function shouldShowChargeLine()
        refreshWeaponCache(false)
        if not isValidVeilSpearWeapon() then return false end

        -- Tombol GUI auto-hold: sekali klik dianggap hold sampai tombol dipencet lagi.
        if autoHoldActive then
            if not chargeStartTime then chargeStartTime = tick() end
            return true
        end

        -- Prioritas pertama: state/animasi charge asli dari game.
        if cachedActualCharge then
            if not chargeStartTime then chargeStartTime = tick() end
            return true
        end

        -- Fallback: input throw/skill sedang di-hold cukup lama.
        if heldChargeInputReady() then
            if not chargeStartTime then chargeStartTime = tick() end
            return true
        end

        if tick() - lastReleaseTime <= RELEASE_GRACE then
            return true
        end

        chargeStartTime = nil
        return false
    end

    local function startChargeInput(input, gpe)
        if not inputStartedOnChargeControl(input, gpe) then return end
        refreshWeaponCache(true)
        if not isValidVeilSpearWeapon() then return end
        activeChargeInputs[input] = {
            startedAt = tick(),
            pos = inputPosition(input)
        }
    end

    local function stopChargeInput(input)
        local wasTracked = false
        if input and activeChargeInputs[input] then
            wasTracked = true
            activeChargeInputs[input] = nil
        end
        if not wasTracked then return end

        lastReleaseTime = tick()
        if next(activeChargeInputs) == nil and not cachedActualCharge then
            chargeStartTime = nil
        end
    end

    local function currentChargeAlpha()
        if not chargeStartTime then return 0 end
        return math.clamp((tick() - chargeStartTime) / CHARGE_DURATION, 0, 1)
    end

    local function makeIgnoreList()
        local ignore = {}
        if LocalPlayer and LocalPlayer.Character then
            table.insert(ignore, LocalPlayer.Character)
        end
        if cachedWeapon then table.insert(ignore, cachedWeapon) end
        if worldFolder then table.insert(ignore, worldFolder) end
        return ignore
    end

    local function getAimRay(cam)
        local vp = cam.ViewportSize
        local ray

        if UserInputService.TouchEnabled then
            -- Mobile: arah projectile selalu mengikuti kamera/crosshair.
            -- GetMouseLocation di mobile sering ikut posisi tombol skill, sehingga garis terlihat miring
            -- dan tidak sejajar dengan tombak.
            ray = cam:ViewportPointToRay(vp.X * 0.5, vp.Y * 0.5)
        else
            local mousePos = UserInputService:GetMouseLocation()
            ray = cam:ViewportPointToRay(mousePos.X, mousePos.Y)
        end

        if not ray then
            ray = Ray.new(cam.CFrame.Position, cam.CFrame.LookVector)
        end
        return ray
    end

    local function getCameraArmScreenOrigin(cam)
        local vp = cam.ViewportSize
        local armRay = cam:ViewportPointToRay(vp.X * SCREEN_LAUNCH_X, vp.Y * SCREEN_LAUNCH_Y)
        return armRay.Origin + armRay.Direction.Unit * SCREEN_LAUNCH_DEPTH
    end

    local function isFirstPersonCamera(cam, char)
        if not cam or not char then return false end
        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not head or not head:IsA("BasePart") then return false end
        return (cam.CFrame.Position - head.Position).Magnitude <= FIRST_PERSON_DIST
    end

    local function findCameraViewmodelLaunchPart(cam)
        if not cam then return nil end

        local now = tick()
        if cachedViewmodelPart
            and cachedViewmodelPart.Parent
            and (now - lastViewmodelScan) < 0.025
            and (cachedViewmodelPart.Position - cam.CFrame.Position).Magnitude <= 38 then
            return cachedViewmodelPart
        end
        lastViewmodelScan = now

        local vp = cam.ViewportSize
        local bestPart, bestScore = nil, -math.huge
        local scanned = 0

        for _, part in ipairs(cam:GetDescendants()) do
            scanned += 1
            if scanned > 220 then break end
            if part and part:IsA("BasePart") then
                local dist = (part.Position - cam.CFrame.Position).Magnitude
                if dist <= 38 then
                    local text = lowerText(part.Name .. " " .. (part.Parent and part.Parent.Name or ""))
                    if containsAny(text, {
                        "tip", "spear", "tombak", "veil", "handle", "blade", "head",
                        "right", "hand", "arm", "viewmodel", "muzzle", "firepoint", "throwpoint", "projectilespawn"
                    }) then
                        local screen, visible = cam:WorldToViewportPoint(part.Position)
                        if visible and screen.Z > 0 then
                            local nx = screen.X / math.max(vp.X, 1)
                            local ny = screen.Y / math.max(vp.Y, 1)
                            local desiredDist = math.abs(nx - SCREEN_LAUNCH_X) + math.abs(ny - SCREEN_LAUNCH_Y)
                            local score = 100 - desiredDist * 90 - dist
                            if containsAny(text, {"tip", "speartip", "tombaktip", "projectilespawn", "throwpoint", "firepoint", "muzzle"}) then
                                score += 55
                            end
                            if containsAny(text, {"right", "hand", "arm"}) then
                                score += 16
                            end
                            if nx >= 0.50 and ny >= 0.36 then
                                score += 34
                            end
                            if score > bestScore then
                                bestScore = score
                                bestPart = part
                            end
                        end
                    end
                end
            end
        end

        cachedViewmodelPart = bestPart
        return bestPart
    end

    local function launchPartLooksAlignedWithRightArm(cam, part)
        if not cam or not part or not part:IsA("BasePart") then return false end
        local vp = cam.ViewportSize
        local screen, visible = cam:WorldToViewportPoint(part.Position)
        if not visible or screen.Z <= 0 then return false end
        local nx = screen.X / math.max(vp.X, 1)
        local ny = screen.Y / math.max(vp.Y, 1)
        return nx >= 0.48 and ny >= 0.34
    end

    local function getTrajectoryGravity()
        return math.abs(workspace.Gravity ~= 0 and workspace.Gravity or 196.2) * TRAJECTORY_GRAVITY_SCALE
    end

    local function getPingLeadSeconds()
        local pingMs = 0
        pcall(function()
            pingMs = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        pingMs = tonumber(pingMs) or 0
        -- Pakai sebagian ping saja; terlalu besar malah membuat prediksi biru palsu pada target zig-zag.
        return math.clamp((pingMs / 1000) * 0.50 + 0.025, 0.025, 0.16)
    end

    local function getPartVelocity(part, fallbackRoot)
        if part and part:IsA("BasePart") then
            local okAssembly, assemblyVel = pcall(function() return part.AssemblyLinearVelocity end)
            if okAssembly and typeof(assemblyVel) == "Vector3" then return assemblyVel end
            local okVel, vel = pcall(function() return part.Velocity end)
            if okVel and typeof(vel) == "Vector3" then return vel end
        end
        if fallbackRoot and fallbackRoot:IsA("BasePart") then
            local okRootAssembly, rootAssemblyVel = pcall(function() return fallbackRoot.AssemblyLinearVelocity end)
            if okRootAssembly and typeof(rootAssemblyVel) == "Vector3" then return rootAssemblyVel end
            local okRootVel, rootVel = pcall(function() return fallbackRoot.Velocity end)
            if okRootVel and typeof(rootVel) == "Vector3" then return rootVel end
        end
        return Vector3.new(0, 0, 0)
    end

    local function solveSpearArcDirection(origin, targetPoint, speed, gravity, chargeT, preferSkyArc)
        -- Akurasi garis diutamakan mengikuti arah lempar asli: kamera/crosshair menentukan arah awal,
        -- lalu gravitasi yang membuat tombak turun. Solver high-arc lama bisa membuat garis biru palsu.
        if not origin or not targetPoint then return nil end
        local delta = targetPoint - origin
        if delta.Magnitude <= 0.1 then return nil end
        return delta.Unit
    end

    local function getLaunchOriginAndDirection(cam, speed, chargeT)
        refreshWeaponCache(false)

        local char = LocalPlayer and LocalPlayer.Character
        local origin
        local firstPerson = isFirstPersonCamera(cam, char)
        local viewmodelPart = findCameraViewmodelLaunchPart(cam)

        -- Saat first-person, part tombak asli sering tidak ada di Character, sehingga fallback lama
        -- jatuh ke HumanoidRootPart/RightHand dan garis terlihat keluar dari tengah layar.
        -- Urutan baru: part viewmodel kamera -> anchor kanan layar -> part karakter.
        if viewmodelPart and launchPartLooksAlignedWithRightArm(cam, viewmodelPart) then
            origin = viewmodelPart.Position
        elseif firstPerson then
            origin = getCameraArmScreenOrigin(cam)
        elseif cachedLaunchPart and launchPartLooksAlignedWithRightArm(cam, cachedLaunchPart) then
            origin = cachedLaunchPart.Position
        elseif cachedLaunchPart and not firstPerson then
            origin = cachedLaunchPart.Position
        else
            origin = getCameraArmScreenOrigin(cam)
        end

        local aimRay = getAimRay(cam)
        local ignore = makeIgnoreList()
        rayParams.FilterDescendantsInstances = ignore

        local targetPoint = aimRay.Origin + (aimRay.Direction.Unit * MAX_AIM_DISTANCE)
        local ok, hit = pcall(function()
            return workspace:Raycast(aimRay.Origin, aimRay.Direction.Unit * MAX_AIM_DISTANCE, rayParams)
        end)
        if ok and hit then
            targetPoint = hit.Position
        end

        local noWorldHit = not (ok and hit)
        local skyClear = false
        if noWorldHit then
            rayParams.FilterDescendantsInstances = ignore
            local okSky, roofHit = pcall(function()
                return workspace:Raycast(aimRay.Origin, aimRay.Direction.Unit * 96 + Vector3.new(0, 70, 0), rayParams)
            end)
            skyClear = okSky and roofHit == nil
        end

        local gravity = getTrajectoryGravity()
        local dir
        if noWorldHit and aimRay.Direction.Magnitude > 0.01 then
            -- Arah langit/tidak ada hit: jangan dipaksa menuju titik 6200 stud di udara.
            -- Simulasikan arah lempar kamera agar garis jatuh tepat di tempat tombak akan mendarat.
            dir = aimRay.Direction.Unit
        else
            dir = solveSpearArcDirection(origin, targetPoint, tonumber(speed) or 650, gravity, tonumber(chargeT) or currentChargeAlpha(), skyClear)
        end
        if not dir then
            dir = targetPoint - origin
            if dir.Magnitude < 1 then
                dir = cam.CFrame.LookVector
            end
            dir = dir.Unit
        end

        -- Offset kecil dari pangkal lengan supaya garis mulai tepat dari ujung/arah tombak kanan.
        origin = origin + dir.Unit * 0.35

        -- Tidak memakai smoothing arah supaya garis tidak terasa delay ketika kamera digeser.
        smoothedOrigin = origin
        smoothedDirection = dir

        return origin, dir
    end

    local function pointToSegmentDistance(point, a, b)
        local ab = b - a
        local abLenSq = ab:Dot(ab)
        if abLenSq <= 0.0001 then
            return (point - a).Magnitude, a
        end
        local t = math.clamp((point - a):Dot(ab) / abLenSq, 0, 1)
        local closest = a + ab * t
        return (point - closest).Magnitude, closest
    end

    local function bodyPartCanCountAsHit(part)
        if not part or not part:IsA("BasePart") then return false end
        local n = lowerText(part.Name)
        if containsAny(n, {"handle", "accessory", "hitbox", "hurtbox", "trigger", "sensor", "ragdoll", "effect", "vfx"}) then
            return false
        end
        local canQueryOk, canQuery = pcall(function() return part.CanQuery end)
        if canQueryOk and canQuery == false then return false end
        if part.Transparency >= 0.98 and part.CanCollide == false then return false end
        return containsAny(n, {
            "head", "torso", "humanoidrootpart", "root", "chest", "body",
            "arm", "hand", "leg", "foot", "upper", "lower"
        })
    end

    local function segmentTouchesPlayerBody(a, b, t0, t1, pingLead)
        local players = Players:GetPlayers()
        local segTime = math.max((tonumber(t1) or 0) - (tonumber(t0) or 0), 0)
        local arrivalTime = math.clamp(((tonumber(t0) or 0) + (tonumber(t1) or 0)) * 0.5 + (tonumber(pingLead) or 0.035), 0, MOVING_TARGET_LEAD_CAP)

        for _, plr in ipairs(players) do
            if plr ~= LocalPlayer then
                local char = plr.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 then
                    local checked = 0
                    for _, bodyPart in ipairs(char:GetDescendants()) do
                        if bodyPartCanCountAsHit(bodyPart) then
                            checked += 1
                            local vel = getPartVelocity(bodyPart, root)
                            local predictedPos = bodyPart.Position + vel * arrivalTime
                            local dist, closest = pointToSegmentDistance(predictedPos, a, b)
                            local bodyRadius = math.max(bodyPart.Size.X, bodyPart.Size.Y, bodyPart.Size.Z) * 0.50
                            local movementPad = math.clamp(vel.Magnitude * segTime * 0.40, 0, 0.58)
                            local radius = bodyRadius + PLAYER_HIT_RADIUS + PROJECTILE_RADIUS + movementPad
                            if dist <= radius then
                                return true, closest, plr
                            end
                            if checked >= 18 then break end
                        end
                    end
                end
            end
        end
        return false, nil, nil
    end

    local function valueObjectIndicatesAura(obj)
        local name = lowerText(obj and obj.Name)
        if not containsAny(name, auraWords) then return false end

        local ok, value = pcall(function() return obj.Value end)
        if not ok then return false end

        if typeof(value) == "boolean" then return value == true end
        if typeof(value) == "number" then return value > 0 end
        if typeof(value) == "string" then
            local v = lowerText(value)
            if v == "" or v == "false" or v == "idle" or v == "none" or v == "0" then return false end
            return containsAny(v, auraWords) or v == "true"
        end

        return false
    end

    local function attributesIndicateAura(obj)
        if not obj or not obj.GetAttributes then return false end
        local ok, attrs = pcall(function() return obj:GetAttributes() end)
        if not ok or not attrs then return false end
        for k, v in pairs(attrs) do
            local name = lowerText(k)
            if containsAny(name, auraWords) then
                if typeof(v) == "boolean" and v == true then return true end
                if typeof(v) == "number" and v > 0 then return true end
                if typeof(v) == "string" then
                    local text = lowerText(v)
                    if text == "true" or containsAny(text, auraWords) then return true end
                end
            end
        end
        return false
    end

    local function visualObjectIndicatesAura(obj)
        if not obj then return false end
        local text = lowerText((obj.Name or "") .. " " .. (obj.Parent and obj.Parent.Name or ""))
        if not containsAny(text, auraWords) then return false end

        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            local ok, enabled = pcall(function() return obj.Enabled end)
            return ok and enabled == true
        end
        if obj:IsA("Highlight") then
            local ok, enabled = pcall(function() return obj.Enabled end)
            return ok and enabled ~= false
        end
        if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            local ok, enabled = pcall(function() return obj.Enabled end)
            return ok and enabled == true
        end

        return false
    end

    local function descendantsIndicateAura(root, limit)
        if not root then return false end
        if attributesIndicateAura(root) then return true end
        local scanned = 0
        for _, obj in ipairs(root:GetDescendants()) do
            scanned += 1
            if scanned > (limit or 220) then break end
            if attributesIndicateAura(obj) then return true end
            if obj:IsA("BoolValue") or obj:IsA("NumberValue") or obj:IsA("IntValue") or obj:IsA("StringValue") then
                if valueObjectIndicatesAura(obj) then return true end
            elseif visualObjectIndicatesAura(obj) then
                return true
            end
        end
        return false
    end

    local function spearAuraActiveDetected()
        local char = LocalPlayer and LocalPlayer.Character
        if descendantsIndicateAura(cachedWeapon, 220) then return true end
        if descendantsIndicateAura(char, 280) then return true end
        return false
    end

    local function playerFromHitInstance(inst)
        if not inst then return nil end
        local model = inst:FindFirstAncestorOfClass("Model")
        if not model then return nil end
        local plr = Players:GetPlayerFromCharacter(model)
        if plr and plr ~= LocalPlayer then
            return plr
        end
        return nil
    end

    local function shouldSkipTrajectoryHit(inst)
        if not inst then return true end
        if LocalPlayer and LocalPlayer.Character and inst:IsDescendantOf(LocalPlayer.Character) then return true end
        if cachedWeapon and inst:IsDescendantOf(cachedWeapon) then return true end
        if worldFolder and inst:IsDescendantOf(worldFolder) then return true end

        if inst:IsA("BasePart") then
            local canQueryOk, canQuery = pcall(function() return inst.CanQuery end)
            if canQueryOk and canQuery == false then return true end

            local parentName = inst.Parent and inst.Parent.Name or ""
            local text = lowerText(inst.Name .. " " .. parentName)
            if inst.Transparency >= 0.96 and inst.CanCollide == false then return true end
            if inst.CanCollide == false and containsAny(text, {
                "hitbox", "hurtbox", "trigger", "zone", "sensor", "detector", "range", "prompt", "effect", "vfx"
            }) then
                return true
            end
        end

        return false
    end

    local function raycastTrajectoryCollision(fromPos, toPos, ignoreList)
        local delta = toPos - fromPos
        if delta.Magnitude <= 0.001 then return nil end

        local dynamicIgnore = {}
        for _, item in ipairs(ignoreList or {}) do
            dynamicIgnore[#dynamicIgnore + 1] = item
        end

        local startPos = fromPos
        local endPos = toPos
        for _ = 1, 8 do
            local dir = endPos - startPos
            if dir.Magnitude <= 0.02 then return nil end

            rayParams.FilterDescendantsInstances = dynamicIgnore
            local ok, hit = pcall(function()
                return workspace:Raycast(startPos, dir, rayParams)
            end)
            if not ok or not hit then return nil end

            if shouldSkipTrajectoryHit(hit.Instance) then
                dynamicIgnore[#dynamicIgnore + 1] = hit.Instance
                startPos = hit.Position + dir.Unit * 0.035
            else
                return hit
            end
        end

        return nil
    end

    local function buildTrajectoryPoints(origin, direction, speed, maxTime, segmentCount, ignoreList, pierceWalls)
        ignoreList = ignoreList or {}
        rayParams.FilterDescendantsInstances = ignoreList

        local gravity = getTrajectoryGravity()
        local pts = table.create(segmentCount + 1)
        local count = 1
        pts[1] = origin
        local pingLead = getPingLeadSeconds()

        local prevT = 0
        for i = 1, segmentCount do
            local t = (i / segmentCount) * maxTime
            local nextPoint = origin + (direction * speed * t) + Vector3.new(0, -0.5 * gravity * t * t, 0)
            local currentPoint = pts[count]

            -- Normal: garis berhenti di tembok/map.
            -- Aura aktif/full charge: garis boleh menembus tembok seperti skill tombaknya.
            if not pierceWalls then
                local wallHit = raycastTrajectoryCollision(currentPoint, nextPoint, ignoreList)
                if wallHit then
                    count += 1
                    pts[count] = wallHit.Position
                    return pts, count, playerFromHitInstance(wallHit.Instance), true
                end
            end

            local touchedPlayer, hitPoint, hitPlayer = segmentTouchesPlayerBody(currentPoint, nextPoint, prevT, t, pingLead)
            if touchedPlayer and hitPoint then
                if pierceWalls then
                    count += 1
                    pts[count] = hitPoint
                    return pts, count, hitPlayer, true
                end

                -- Fallback radius player tetap tidak boleh mengabaikan tembok saat aura belum aktif.
                local block = raycastTrajectoryCollision(currentPoint, hitPoint, ignoreList)
                local blockPlayer = block and playerFromHitInstance(block.Instance)
                if not block or blockPlayer == hitPlayer then
                    count += 1
                    pts[count] = hitPoint
                    return pts, count, hitPlayer, true
                end
            end

            count += 1
            pts[count] = nextPoint
            prevT = t
        end

        return pts, count, nil, false
    end

    local function updateWorldTrajectory(pts, pointCount, color)
        for i = 1, SEG_COUNT do
            local item = worldBeams[i]
            local p1 = pts[i]
            local p2 = pts[i + 1]
            if item and item.beam and p1 and p2 and i < pointCount then
                item.a0.WorldPosition = p1
                item.a1.WorldPosition = p2
                item.beam.Color = ColorSequence.new(color)
                local fade = (i - 1) / SEG_COUNT
                item.beam.Width0 = math.max(0.030, 0.068 * (1 - fade * 0.30))
                item.beam.Width1 = math.max(0.030, 0.068 * (1 - fade * 0.30))
                item.beam.Transparency = NumberSequence.new(math.clamp(0.20 + fade * 0.22, 0.20, 0.46))
                item.beam.Enabled = true
            elseif item and item.beam then
                item.beam.Enabled = false
            end
        end
    end

    local function updateScreenTrajectory(cam, pts, pointCount, color)
        if not canDraw then return end
        for i = 1, SEG_COUNT do
            local ln = screenLines[i]
            local p1 = pts[i]
            local p2 = pts[i + 1]
            if ln and p1 and p2 and i < pointCount then
                local s1, v1 = cam:WorldToViewportPoint(p1)
                local s2, v2 = cam:WorldToViewportPoint(p2)
                if v1 and v2 and s1.Z > 0 and s2.Z > 0 then
                    local fade = (i - 1) / SEG_COUNT
                    ln.Color = color
                    ln.Transparency = math.clamp(0.92 - fade * 0.20, 0.62, 0.92)
                    ln.Thickness = math.max(1.15, SEG_THICKNESS * (1 - fade * 0.24))
                    ln.From = Vector2.new(s1.X, s1.Y)
                    ln.To = Vector2.new(s2.X, s2.Y)
                    ln.Visible = true
                else
                    ln.Visible = false
                end
            elseif ln then
                ln.Visible = false
            end
        end
    end

    -- Auto Hold GUI tombak dihapus total agar tidak membuat ScreenGui/tombol tambahan
    -- dan tidak melakukan scan PlayerGui berulang yang bisa menyebabkan lag.
    local function destroyAutoHoldGui()
        autoHoldVirtualDown = false
        autoHoldActive = false
        autoHoldPressPos = nil
        activeChargeInputs[autoHoldSyntheticInput] = nil

        local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pg then
            local old = pg:FindFirstChild("ArexansVeilSpearAutoHoldGui")
            if old then
                pcall(function() old:Destroy() end)
            end
        end

        autoHoldGui = nil
        autoHoldButton = nil
    end

    local function setAutoHoldActive(_state)
        destroyAutoHoldGui()
    end

    local function setAutoHoldGuiVisible(_visible)
        destroyAutoHoldGui()
    end

    getgenv().ArexansSetVeilSpearAutoHoldGuiVisible = setAutoHoldGuiVisible

    destroyAutoHoldGui()

    UserInputService.InputBegan:Connect(function(input, gpe)
        startChargeInput(input, gpe)
    end)

    UserInputService.InputEnded:Connect(function(input)
        stopChargeInput(input)
    end)

    if LocalPlayer and LocalPlayer.CharacterAdded then
        LocalPlayer.CharacterAdded:Connect(function()
            setAutoHoldActive(false)
            activeChargeInputs = {}
            chargeStartTime = nil
            cachedWeapon = nil
            cachedLaunchPart = nil
            cachedAllowed = false
            cachedActualCharge = false
            smoothedOrigin = nil
            smoothedDirection = nil
            cachedViewmodelPart = nil
            lastViewmodelScan = 0
            lastCacheUpdate = 0
            hideAllLines()
        end)
    end

    RunService.RenderStepped:Connect(function()
        if getgenv().ArexansVeilSpearTrajectoryToken ~= token then
            hideAllLines()
            return
        end

        local now = tick()
        if (now - lastUpdate) < UPDATE_INTERVAL then return end
        lastUpdate = now

        if not featureStates or not featureStates.SpearTrajectoryEnabled then
            hideAllLines()
            return
        end

        if not shouldShowChargeLine() then
            hideAllLines()
            return
        end

        local cam = workspace.CurrentCamera
        if not cam then
            hideAllLines()
            return
        end

        local chargeT = currentChargeAlpha()
        local minSpd = tonumber(featureStates.SpearMinSpeed) or 120
        local maxSpd = tonumber(featureStates.SpearMaxSpeed) or 850
        minSpd = math.clamp(minSpd, 60, 320)
        maxSpd = math.clamp(maxSpd, minSpd, 1400)

        local speed = minSpd + (maxSpd - minSpd) * chargeT
        getgenv().ArexansVeilSpearChargeAlpha = chargeT
        getgenv().ArexansVeilSpearCurrentSpeed = speed

        local origin, dir = getLaunchOriginAndDirection(cam, speed, chargeT)

        -- Garis pendek saat awal hold, lalu memanjang halus mengikuti power sampai full.
        -- Saat kamera diarahkan ke langit, waktu simulasi ditambah agar lengkungan turun/jatuh tetap terlihat jauh.
        local upwardAmount = math.clamp(dir.Y, 0, 1)
        local upwardBonus = upwardAmount * (1.25 + chargeT * 5.65)
        local fullPowerBonus = math.clamp((chargeT - 0.82) / 0.18, 0, 1) * 1.40
        local maxTime = 0.72 + chargeT * 5.95 + upwardBonus + fullPowerBonus
        maxTime = math.clamp(maxTime, 0.72, upwardAmount > 0.28 and 12.2 or 8.4)
        getgenv().ArexansVeilSpearLastDirection = dir

        local auraActive = spearAuraActiveDetected() or chargeT >= 0.985
        local pts, pointCount, hitPlayer = buildTrajectoryPoints(origin, dir, speed, maxTime, SEG_COUNT, makeIgnoreList(), auraActive)
        local color = hitPlayer and COLOR_PLAYER_HIT or COLOR_LOW_POWER

        updateWorldTrajectory(pts, pointCount, color)
        updateScreenTrajectory(cam, pts, pointCount, color)
    end)

    pcall(function()
        game.DescendantRemoving:Connect(function(obj)
            if obj == LocalPlayer then
                setAutoHoldActive(false)
                hideAllLines()
                if canDraw then
                    for _, ln in ipairs(screenLines) do
                        pcall(function() ln:Remove() end)
                    end
                end
                for _, item in ipairs(worldBeams) do
                    pcall(function() if item.beam then item.beam:Destroy() end end)
                    pcall(function() if item.a0 then item.a0:Destroy() end end)
                    pcall(function() if item.a1 then item.a1:Destroy() end end)
                end
                pcall(function() worldFolder:Destroy() end)
            end
        end)
    end)
end)

---------------------------------------------------
--== AREXANS LAST SAFE PATCH: CUSTOM JUMP STARTS OFF ==--
---------------------------------------------------
-- Patch ini sengaja ditempel di AKHIR script supaya tidak mengganggu startup WindUI.
-- Basis file ini adalah versi yang sudah terbukti muncul dan tidak freeze saat balik lobby.
-- Tujuan:
-- 1) Custom Jump tetap ada dan bisa dinyalakan dari toggle "Show Jump Button".
-- 2) Saat execute, Custom Jump dipaksa OFF dulu supaya tidak muncul otomatis.
-- 3) Jump bawaan Roblox/TouchGui disembunyikan ringan tanpa scan seluruh PlayerGui.

pcall(function()
    local PlayersService = game:GetService("Players")
    local LP = PlayersService.LocalPlayer
    if not LP then return end

    local function getPlayerGuiSafe()
        return LP:FindFirstChild("PlayerGui")
    end

    local function forceCustomJumpOffAtStart()
        pcall(function()
            JumpButtonGuiVisibleState = false
        end)

        pcall(function()
            if JumpGui then
                JumpGui.Enabled = false
            end
        end)

        pcall(function()
            if JumpButton then
                JumpButton.Visible = false
                JumpButton.Active = false
                JumpButton.Selectable = false
            end
        end)

        local pg = getPlayerGuiSafe()
        if not pg then return end

        local customGui = pg:FindFirstChild("ArexansJumpButton")
        if customGui and customGui:IsA("ScreenGui") then
            pcall(function()
                customGui.Enabled = false
            end)

            -- GUI ini milik script sendiri dan jumlah descendant-nya kecil, aman discan.
            for _, obj in ipairs(customGui:GetDescendants()) do
                if obj:IsA("GuiButton") then
                    pcall(function()
                        obj.Visible = false
                        obj.Active = false
                        obj.Selectable = false
                    end)
                end
            end
        end
    end

    local function hideNativeRobloxJumpOnly()
        local pg = getPlayerGuiSafe()
        if not pg then return end

        -- Target spesifik saja: PlayerGui.TouchGui.TouchControlFrame.JumpButton.
        -- Tidak scan seluruh PlayerGui supaya fix freeze lobby tetap aman.
        local touchGui = pg:FindFirstChild("TouchGui")
        if not touchGui then return end

        local touchFrame = touchGui:FindFirstChild("TouchControlFrame")
        if not touchFrame then return end

        local nativeJump = touchFrame:FindFirstChild("JumpButton")
        if nativeJump and nativeJump:IsA("GuiButton") then
            pcall(function()
                nativeJump.Visible = false
                nativeJump.Active = false
                nativeJump.Selectable = false
                nativeJump.AutoButtonColor = false
            end)
        end
    end

    forceCustomJumpOffAtStart()
    hideNativeRobloxJumpOnly()

    local pg = getPlayerGuiSafe()
    if pg then
        pg.ChildAdded:Connect(function(child)
            if child and child.Name == "TouchGui" then
                task.defer(hideNativeRobloxJumpOnly)
                task.delay(1, hideNativeRobloxJumpOnly)
            elseif child and child.Name == "ArexansJumpButton" then
                task.defer(forceCustomJumpOffAtStart)
            end
        end)
    end

    task.spawn(function()
        -- Fase awal: beberapa UI library/config kadang memanggil callback setelah window dibuat.
        -- Jadi custom jump dipaksa OFF sebentar hanya saat startup.
        local startClock = os.clock()
        while os.clock() - startClock < 3 do
            forceCustomJumpOffAtStart()
            hideNativeRobloxJumpOnly()
            task.wait(0.25)
        end

        -- Setelah startup selesai, toggle Show Jump Button boleh menyalakan custom jump normal.
        -- Loop berikut hanya menyembunyikan JumpButton bawaan Roblox, bukan custom jump.
        while true do
            hideNativeRobloxJumpOnly()
            task.wait(3)
        end
    end)
end)


---------------------------------------------------
--== AREXANS SAFE PATCH: GENERATOR PROGRESS BAR ESP 0-100 ==--
---------------------------------------------------
-- Versi ringan: cache generator supaya tidak scan seluruh map setiap frame/tick.
pcall(function()
    local WorkspaceService = game:GetService("Workspace")
    local PlayersService = game:GetService("Players")
    local LP = PlayersService.LocalPlayer

    getgenv().ArexansGeneratorProgressBar = (getgenv().ArexansGeneratorProgressBar == true)
    getgenv().ArexansGeneratorProgressDebug = false
    getgenv().ArexansGeneratorProgressBarShowDistance = getgenv().ArexansGeneratorProgressBarShowDistance or 65

    local progressNames = {
        "Progress", "progress", "RepairProgress", "RepairingProgress",
        "GeneratorProgress", "GenProgress", "CurrentProgress", "Percent",
        "RepairPercent", "Completion", "Completed", "Value"
    }

    local maxNames = {
        "MaxProgress", "MaximumProgress", "RequiredProgress", "ProgressMax",
        "Max", "MaxValue", "TotalProgress", "Goal", "Required"
    }

    local generatorCache = {}
    local progressCache = {}
    local lastCacheRefresh = 0
    local cacheRefreshInterval = 2.5
    local uiUpdateInterval = 0.90
    local lastHiddenCleanup = 0

    local function clampNumber(n, lo, hi)
        n = tonumber(n)
        if not n or n ~= n then return nil end
        if n < lo then return lo end
        if n > hi then return hi end
        return n
    end

    local function normalizePercent(value, maxValue)
        if type(value) == "boolean" then
            return value and 100 or 0
        end

        if type(value) == "string" then
            local cur, max = value:match("([%d%.]+)%s*/%s*([%d%.]+)")
            if cur and max then
                value = tonumber(cur)
                maxValue = tonumber(max)
            else
                value = value:match("[%d%.]+")
            end
        end

        local n = tonumber(value)
        if not n or n ~= n then return nil end

        local maxN = tonumber(maxValue)
        if maxN and maxN > 0 and maxN ~= 100 then
            n = (n / maxN) * 100
        elseif n >= 0 and n <= 1 then
            n = n * 100
        end

        n = clampNumber(n, 0, 100)
        if not n then return nil end
        return math.floor(n + 0.5)
    end

    local function readValue(inst)
        if not inst then return nil end
        local ok, value = pcall(function()
            return inst.Value
        end)
        if ok then return value end
        return nil
    end

    local function getAttr(inst, names)
        if not inst then return nil end
        for _, name in ipairs(names) do
            local ok, value = pcall(function()
                return inst:GetAttribute(name)
            end)
            if ok and value ~= nil then return value end
        end
        return nil
    end

    local function childValue(inst, names)
        if not inst then return nil end
        for _, name in ipairs(names) do
            local child = inst:FindFirstChild(name)
            local value = readValue(child)
            if value ~= nil then return value, child end
        end
        return nil, nil
    end

    local function nameLooksLikeProgress(name)
        local s = tostring(name or ""):lower():gsub("[%s_%-%./]", "")
        return s:find("progress", 1, true)
            or s:find("percent", 1, true)
            or s:find("completion", 1, true)
            or s:find("repair", 1, true)
            or s == "completed"
    end

    local function isGeneratorModel(obj)
        if not obj or not obj:IsA("Model") then return false end
        local n = tostring(obj.Name):lower()
        return n == "generator" or n:find("generator", 1, true) ~= nil
    end

    local function generatorPart(gen)
        if not gen then return nil end
        local pp = nil
        pcall(function() pp = gen.PrimaryPart end)
        if pp and pp:IsA("BasePart") then return pp end

        local preferred = gen:FindFirstChild("GeneratorPoint1") or gen:FindFirstChild("Main") or gen:FindFirstChild("HumanoidRootPart")
        if preferred and preferred:IsA("BasePart") then return preferred end

        for _, child in ipairs(gen:GetChildren()) do
            if child:IsA("BasePart") then
                return child
            end
        end
        for _, desc in ipairs(gen:GetDescendants()) do
            if desc:IsA("BasePart") then
                return desc
            end
        end
        return nil
    end

    local function findProgressSource(gen)
        if not gen then return nil end

        local raw = getAttr(gen, progressNames)
        if raw ~= nil then
            return {kind = "attr", inst = gen, maxKind = "attr"}
        end

        local value, child = childValue(gen, progressNames)
        if value ~= nil and child then
            return {kind = "value", inst = child, maxKind = "child"}
        end

        -- Fallback scan hanya saat cache refresh, bukan setiap update UI.
        for _, desc in ipairs(gen:GetDescendants()) do
            raw = getAttr(desc, progressNames)
            if raw ~= nil then
                return {kind = "attr", inst = desc, maxKind = "attr"}
            end
            if nameLooksLikeProgress(desc.Name) then
                local v = readValue(desc)
                if v ~= nil then
                    return {kind = "value", inst = desc, maxKind = "child"}
                end
            end
        end

        return nil
    end

    local function getMaxValue(gen, source)
        if not gen then return nil end
        local maxRaw = getAttr(gen, maxNames)
        if maxRaw ~= nil then return maxRaw end
        maxRaw = childValue(gen, maxNames)
        if maxRaw ~= nil then return maxRaw end

        if source and source.inst and source.inst ~= gen then
            maxRaw = getAttr(source.inst, maxNames)
            if maxRaw ~= nil then return maxRaw end
            maxRaw = childValue(source.inst, maxNames)
            if maxRaw ~= nil then return maxRaw end
        end

        return nil
    end

    local function getGeneratorPercent(gen)
        if not gen then return 0 end

        local source = progressCache[gen]
        if not source or not source.inst or not source.inst.Parent then
            source = findProgressSource(gen)
            progressCache[gen] = source
        end

        if source and source.inst then
            local raw = nil
            if source.kind == "attr" then
                raw = getAttr(source.inst, progressNames)
            else
                raw = readValue(source.inst)
            end
            local pct = normalizePercent(raw, getMaxValue(gen, source))
            if pct then return pct end
        end

        local raw = getAttr(gen, progressNames)
        local pct = normalizePercent(raw, getMaxValue(gen, source))
        if pct then return pct end

        return 0
    end

    local function createProgressBillboard(part)
        local gui = Instance.new("BillboardGui")
        gui.Name = "VD_GeneratorProgressBar"
        gui.Adornee = part
        gui.AlwaysOnTop = true
        -- Horizontal kecil dan dekat objek: dari jauh hanya persen, bar muncul saat sudah dekat.
        gui.Size = UDim2.new(0, 70, 0, 22)
        gui.StudsOffset = Vector3.new(0, 1.15, 0)
        gui.MaxDistance = 0
        gui.Parent = part

        local text = Instance.new("TextLabel")
        text.Name = "Text"
        text.BackgroundTransparency = 1
        text.BorderSizePixel = 0
        text.Position = UDim2.new(0, 0, 0, 0)
        text.Size = UDim2.new(1, 0, 0, 12)
        text.Font = Enum.Font.GothamBold
        text.Text = "0%"
        text.TextSize = 9
        text.TextColor3 = Color3.new(1, 1, 1)
        text.TextStrokeTransparency = 0.25
        text.TextStrokeColor3 = Color3.new(0, 0, 0)
        text.Parent = gui

        local bg = Instance.new("Frame")
        bg.Name = "BarBG"
        bg.BorderSizePixel = 0
        bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        bg.BackgroundTransparency = 0.18
        bg.Position = UDim2.new(0.5, -22, 0, 14)
        bg.Size = UDim2.new(0, 44, 0, 5)
        bg.Parent = gui

        local bgCorner = Instance.new("UICorner")
        bgCorner.CornerRadius = UDim.new(1, 0)
        bgCorner.Parent = bg

        local stroke = Instance.new("UIStroke")
        stroke.Name = "Stroke"
        stroke.Thickness = 1
        stroke.Transparency = 0.12
        stroke.Color = Color3.fromRGB(0, 170, 255)
        stroke.Parent = bg

        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.BorderSizePixel = 0
        fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        fill.AnchorPoint = Vector2.new(0, 0)
        fill.Position = UDim2.new(0, 0, 0, 0)
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.Parent = bg

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill

        return gui
    end

    local function removeProgressGuiFromPart(part)
        if not part then return end
        local gui = part:FindFirstChild("VD_GeneratorProgressBar")
        if gui then
            pcall(function() gui:Destroy() end)
        end
    end

    local function removeAllProgressBars()
        local now = os.clock()
        if now - lastHiddenCleanup < 1.25 then return end
        lastHiddenCleanup = now

        for gen, part in pairs(generatorCache) do
            removeProgressGuiFromPart(part)
            generatorCache[gen] = nil
            progressCache[gen] = nil
        end
    end

    local function refreshGeneratorCache(force)
        local now = os.clock()
        if not force and now - lastCacheRefresh < cacheRefreshInterval then return end
        lastCacheRefresh = now

        for gen, part in pairs(generatorCache) do
            if not gen or not gen.Parent or not part or not part.Parent then
                generatorCache[gen] = nil
                progressCache[gen] = nil
            end
        end

        local root = WorkspaceService:FindFirstChild("Map") or WorkspaceService
        for _, obj in ipairs(root:GetDescendants()) do
            if isGeneratorModel(obj) and not generatorCache[obj] then
                local part = generatorPart(obj)
                if part then
                    generatorCache[obj] = part
                    progressCache[obj] = findProgressSource(obj)
                end
            end
        end
    end

    local function updateProgressBars()
        local enabled = getgenv().ArexansGeneratorProgressBar ~= false
        local generatorEspEnabled = featureStates and featureStates.GeneratorESP == true

        if not enabled or not generatorEspEnabled then
            removeAllProgressBars()
            return
        end

        refreshGeneratorCache(false)

        local cam = WorkspaceService.CurrentCamera or workspace.CurrentCamera
        local camPos = nil
        if cam then camPos = cam.CFrame.Position end

        local color = Color3.fromRGB(0, 170, 255)
        pcall(function()
            if featureStates and featureStates.GeneratorColor then
                color = featureStates.GeneratorColor
            end
        end)

        local limit = tonumber(getgenv().ArexansGeneratorProgressBarShowDistance) or 65
        local textSize = 9
        pcall(function()
            local size = tonumber(featureStates and featureStates.ESPTextSize) or 10
            textSize = math.clamp(size, 8, 9)
        end)

        for gen, part in pairs(generatorCache) do
            if not gen or not gen.Parent or not part or not part.Parent then
                generatorCache[gen] = nil
                progressCache[gen] = nil
            else
                local gui = part:FindFirstChild("VD_GeneratorProgressBar")
                if not gui then
                    gui = createProgressBillboard(part)
                end

                local percent = getGeneratorPercent(gen)
                gui.Enabled = true
                gui.Adornee = part
                gui.Size = UDim2.new(0, 70, 0, 22)
                gui.StudsOffset = Vector3.new(0, 1.15, 0)

                local showBar = true
                if camPos then
                    showBar = (camPos - part.Position).Magnitude <= limit
                end

                local text = gui:FindFirstChild("Text")
                if text then
                    text.Text = tostring(percent) .. "%"
                    text.TextColor3 = color
                    text.Position = UDim2.new(0, 0, 0, 0)
                    text.Size = UDim2.new(1, 0, 0, 12)
                    text.TextSize = textSize
                end

                local bg = gui:FindFirstChild("BarBG")
                if bg then
                    bg.Visible = showBar
                    bg.Position = UDim2.new(0.5, -22, 0, 14)
                    bg.Size = UDim2.new(0, 44, 0, 5)

                    local stroke = bg:FindFirstChild("Stroke")
                    if stroke then stroke.Color = color end

                    local fill = bg:FindFirstChild("Fill")
                    if fill then
                        fill.BackgroundColor3 = color
                        fill.AnchorPoint = Vector2.new(0, 0)
                        fill.Position = UDim2.new(0, 0, 0, 0)
                        fill.Size = UDim2.new(percent / 100, 0, 1, 0)
                    end
                end
            end
        end
    end

    if getgenv().ArexansGeneratorProgressBar == true and featureStates and featureStates.GeneratorESP == true then
        refreshGeneratorCache(true)
    end

    task.spawn(function()
        while true do
            pcall(updateProgressBars)
            task.wait(uiUpdateInterval)
        end
    end)

    -- Console normal dibuat silent; patch progress bar tetap aktif.
end)


-- =========================================================
-- AUTO CROUCH SPIN ATTACK PATCH
-- Jongkok otomatis saat killer memakai skill pedang memutar, lalu berdiri lagi setelah serangan selesai.
-- Tetap aktif jika Auto Crouch Spin Attack ON. Untuk kompatibilitas, juga ikut aktif saat Auto Parry ON.
-- =========================================================
pcall(function()
    local SpinCrouchDefaultDistance = 42
    local SpinCrouchReleaseDelay = 0.82
    local SpinCrouchScanInterval = 0.055
    local SpinCrouchSlowScanInterval = 0.18
    local spinCrouchRunning = false
    local spinCrouching = false
    local spinWasCrouching = false
    local spinLastSeen = 0
    local spinCrouchCharacter = nil
    local spinIdentityCache = setmetatable({}, {__mode = "k"})
    local spinStateCache = setmetatable({}, {__mode = "k"})
    local spinObjectCache = setmetatable({}, {__mode = "k"})

    -- Jika nanti sudah ketemu ID animasi pasti dari skill pedang memutar, isi lewat:
    -- getgenv().ArexansSpinCrouchAnimIds = {[1234567890] = true}
    local BuiltInSpinAnimIds = {
        -- [1234567890] = true,
    }

    if getgenv().ArexansSpinCrouchWithAutoParry == nil then
        getgenv().ArexansSpinCrouchWithAutoParry = true
    end

    local function safeLower(value)
        return string.lower(tostring(value or ""))
    end

    local function textHasAny(text, words)
        text = safeLower(text)
        if text == "" then return false end
        for _, word in ipairs(words) do
            if text:find(word, 1, true) then
                return true
            end
        end
        return false
    end

    local SpinWords = {
        "spin", "spinning", "whirl", "whirlwind", "rotate", "rotation", "rotating",
        "twirl", "cyclone", "tornado", "bladestorm", "blade storm", "roundslash",
        "round slash", "circle slash", "circular", "aoe", "putar", "memutar",
    }

    local SwordAttackWords = {
        "sword", "blade", "katana", "slash", "swing", "attack", "strike", "skill",
        "ability", "special", "ult", "ultimate", "hitbox", "damage", "abyss",
    }

    local SkipWords = {
        "idle", "walk", "run", "sprint", "equip", "spawn", "death", "dead",
        "stun", "ragdoll", "getup", "jump", "fall", "land", "emote",
    }

    local function autoSpinCrouchEnabled()
        if not featureStates then return false end
        if featureStates.AutoSpinCrouch == true then return true end
        return featureStates.AutoParry == true and getgenv().ArexansSpinCrouchWithAutoParry ~= false
    end

    local function textLooksAbysswalker(value)
        local s = safeLower(value)
        if s == "" then return false end
        return s:find("abysswalker", 1, true) ~= nil
            or s:find("the abysswalker", 1, true) ~= nil
            or (s:find("abyss", 1, true) ~= nil and s:find("walker", 1, true) ~= nil)
    end

    local function modelLooksSpinSwordKiller(model)
        if not model or not model.Parent then return false end

        local now = tick()
        local cached = spinIdentityCache[model]
        if cached and cached.expire and cached.expire > now then
            return cached.value == true, cached.abyss == true
        end

        local found = false
        local abyss = textLooksAbysswalker(model.Name)
        local combined = safeLower(model.Name)

        local attrs = {
            "Killer", "KillerName", "Character", "CharacterName", "Fighter", "FighterName",
            "Class", "DisplayName", "SkinName", "Ability", "AbilityName", "Skill", "SkillName",
        }

        for _, attrName in ipairs(attrs) do
            local ok, value = pcall(function()
                return model:GetAttribute(attrName)
            end)
            if ok and value ~= nil then
                local text = safeLower(value)
                combined = combined .. " " .. text
                if textLooksAbysswalker(text) then abyss = true end
            end
        end

        if abyss then
            found = true
        elseif textHasAny(combined, SpinWords) and textHasAny(combined, SwordAttackWords) then
            found = true
        end

        if not found or not abyss then
            local checked = 0
            pcall(function()
                for _, d in ipairs(model:GetDescendants()) do
                    checked = checked + 1
                    if checked > 85 then break end
                    local dText = safeLower(d.Name)
                    if d:IsA("StringValue") then
                        dText = dText .. " " .. safeLower(d.Value)
                    end
                    if textLooksAbysswalker(dText) then
                        abyss = true
                        found = true
                        break
                    end
                    if textHasAny(dText, SpinWords) and textHasAny(dText, SwordAttackWords) then
                        found = true
                    end
                end
            end)
        end

        spinIdentityCache[model] = {
            value = found == true,
            abyss = abyss == true,
            expire = now + ((found or abyss) and 10 or 1.25),
        }
        return found == true, abyss == true
    end

    local function valueLooksActive(value)
        local t = typeof(value)
        if t == "boolean" then return value == true end
        if t == "number" then return value ~= 0 end
        if t == "string" then
            local s = safeLower(value)
            return s ~= "" and s ~= "false" and s ~= "off" and s ~= "none" and s ~= "nil"
        end
        return value ~= nil
    end

    local function modelHasActiveSpinState(model)
        if not model or not model.Parent then return false end

        local now = tick()
        local cached = spinStateCache[model]
        if cached and cached.expire and cached.expire > now then
            return cached.value == true
        end

        local found = false
        pcall(function()
            for attrName, attrValue in pairs(model:GetAttributes()) do
                local attrText = safeLower(attrName .. " " .. tostring(attrValue))
                if valueLooksActive(attrValue) and textHasAny(attrText, SpinWords) and textHasAny(attrText, SwordAttackWords) then
                    found = true
                    break
                end
            end
        end)

        if not found then
            local checked = 0
            pcall(function()
                for _, d in ipairs(model:GetDescendants()) do
                    checked = checked + 1
                    if checked > 100 then break end

                    local name = safeLower(d.Name)
                    if textHasAny(name, SpinWords) and textHasAny(name, SwordAttackWords) then
                        if d:IsA("BoolValue") then
                            if d.Value == true then found = true; break end
                        elseif d:IsA("NumberValue") or d:IsA("IntValue") then
                            if tonumber(d.Value) and tonumber(d.Value) ~= 0 then found = true; break end
                        elseif d:IsA("StringValue") then
                            if valueLooksActive(d.Value) then found = true; break end
                        else
                            found = true
                            break
                        end
                    end
                end
            end)
        end

        spinStateCache[model] = {value = found == true, expire = now + 0.12}
        return found == true
    end

    local function trackLooksSpinAttack(track, abyss)
        if not track then return false end

        local speed = 0
        pcall(function()
            speed = tonumber(track.Speed) or 0
        end)
        if speed <= 0 then return false end

        local rawAnimId = ""
        local animName = ""
        local trackName = ""
        local priorityText = ""
        pcall(function() trackName = tostring(track.Name or "") end)
        pcall(function()
            if track.Animation then
                rawAnimId = tostring(track.Animation.AnimationId or "")
                animName = tostring(track.Animation.Name or "")
            end
        end)
        pcall(function() priorityText = tostring(track.Priority or "") end)

        local id = tonumber(rawAnimId:match("%d+"))
        if id then
            local custom = getgenv().ArexansSpinCrouchAnimIds
            if type(custom) == "table" and custom[id] then return true end
            if BuiltInSpinAnimIds[id] then return true end
        end

        local combined = safeLower(trackName .. " " .. animName .. " " .. rawAnimId .. " " .. priorityText)
        if textHasAny(combined, SkipWords) then return false end

        local hasSpin = textHasAny(combined, SpinWords)
        local hasSwordAttack = textHasAny(combined, SwordAttackWords)
        if hasSpin and (hasSwordAttack or abyss or isActionPriorityTrack(track)) then
            return true
        end

        -- Fallback khusus Abysswalker: beberapa client hanya memberi nama animasi generic/Action.
        -- Tetap dibatasi kata skill/sword/attack agar tidak jongkok saat idle/run.
        if abyss and hasSwordAttack and (combined:find("action", 1, true) or isActionPriorityTrack(track)) then
            local timePos = getTrackTimePosition(track)
            local length = getTrackLength(track)
            if length <= 0 then return true end
            return timePos <= math.min(length * 0.92, 1.65)
        end

        return false
    end

    local function objectLooksActiveSpin(obj)
        if not obj then return false end
        local name = safeLower(obj.Name)
        local className = safeLower(obj.ClassName)
        local combined = name .. " " .. className

        if not (textHasAny(combined, SpinWords) and textHasAny(combined, SwordAttackWords)) then
            return false
        end

        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            local ok, enabled = pcall(function()
                return obj.Enabled
            end)
            return ok and enabled == true
        end

        if obj:IsA("BoolValue") then
            return obj.Value == true
        end

        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
            return tonumber(obj.Value) and tonumber(obj.Value) ~= 0
        end

        if obj:IsA("StringValue") then
            return valueLooksActive(obj.Value)
        end

        if obj:IsA("BasePart") then
            local transparency = 0
            pcall(function() transparency = obj.Transparency end)
            return transparency < 1
        end

        if obj:IsA("Sound") then
            local ok, playing = pcall(function() return obj.IsPlaying end)
            return ok and playing == true
        end

        -- Folder/Model/Animation/Remote yang statis jangan dihitung aktif,
        -- karena banyak killer menyimpan asset skill walau skill belum dipakai.
        return false
    end

    local function modelHasSpinObject(model)
        if not model or not model.Parent then return false end
        local now = tick()
        local cached = spinObjectCache[model]
        if cached and cached.expire and cached.expire > now then
            return cached.value == true
        end

        local found = false
        local checked = 0
        pcall(function()
            for _, d in ipairs(model:GetDescendants()) do
                checked = checked + 1
                if checked > 120 then break end
                if objectLooksActiveSpin(d) then
                    found = true
                    break
                end
            end
        end)

        spinObjectCache[model] = {value = found == true, expire = now + 0.12}
        return found == true
    end

    local function killerIsUsingSpinSword(model, humanoid)
        local looksRelevant, abyss = modelLooksSpinSwordKiller(model)

        if modelHasActiveSpinState(model) then
            return true
        end

        if humanoid then
            local ok, tracks = pcall(function()
                return humanoid:GetPlayingAnimationTracks()
            end)
            if ok and tracks then
                for _, track in ipairs(tracks) do
                    if trackLooksSpinAttack(track, abyss) then
                        return true
                    end
                end
            end
        end

        if modelHasSpinObject(model) then
            return true
        end

        return false
    end

    local function fireCrouch(character, value)
        if not character or not character.Parent then return end

        pcall(function()
            character:SetAttribute("Crouchingserver", value == true)
        end)

        pcall(function()
            local remotes = ReplicatedStorage and ReplicatedStorage:FindFirstChild("Remotes")
            local mechanics = remotes and remotes:FindFirstChild("Mechanics")
            local changeAttr = mechanics and mechanics:FindFirstChild("ChangeAttribute")
            if changeAttr then
                changeAttr:FireServer("Crouchingserver", value == true)
            end
        end)

        if value == true then
            pcall(function()
                local remotes = ReplicatedStorage and ReplicatedStorage:FindFirstChild("Remotes")
                local chase = remotes and remotes:FindFirstChild("Chase")
                local runEvent = chase and chase:FindFirstChild("Runevent")
                if runEvent then
                    runEvent:FireServer(character, false)
                end
            end)
        end
    end

    local function beginSpinCrouch(character)
        if not character or not character.Parent then return end
        spinLastSeen = tick()

        if spinCrouching and spinCrouchCharacter == character then
            return
        end

        spinCrouching = true
        spinCrouchCharacter = character
        spinWasCrouching = character:GetAttribute("Crouchingserver") == true
        fireCrouch(character, true)
    end

    local function finishSpinCrouch(character, force)
        if not spinCrouching then return end
        if not force and tick() - spinLastSeen < SpinCrouchReleaseDelay then return end

        local target = character or spinCrouchCharacter
        spinCrouching = false
        spinCrouchCharacter = nil

        if target and target.Parent and not spinWasCrouching then
            fireCrouch(target, false)
        end
    end

    function startAutoSpinCrouch()
        if spinCrouchRunning then return end
        spinCrouchRunning = true

        task.spawn(function()
            while spinCrouchRunning do
                local waitTime = SpinCrouchScanInterval
                local ok = pcall(function()
                    local character = LocalPlayer and LocalPlayer.Character

                    if not autoSpinCrouchEnabled() then
                        finishSpinCrouch(character, true)
                        waitTime = SpinCrouchSlowScanInterval
                        return
                    end

                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    if not character or not humanoid or not root or humanoid.Health <= 0 then
                        finishSpinCrouch(character, true)
                        waitTime = SpinCrouchSlowScanInterval
                        return
                    end

                    if character:GetAttribute("IsHooked") or character:GetAttribute("IsCarried") or character:GetAttribute("Knocked") then
                        finishSpinCrouch(character, true)
                        waitTime = SpinCrouchSlowScanInterval
                        return
                    end

                    local maxDistance = math.clamp(tonumber(featureStates.AutoSpinCrouchDistance) or SpinCrouchDefaultDistance, 18, 65)
                    local foundSpin = false
                    local killers = {}
                    local okKillers, result = pcall(function()
                        return getKillerModels(false)
                    end)
                    if okKillers and type(result) == "table" then
                        killers = result
                    end

                    for _, killerModel in ipairs(killers) do
                        if killerModel and killerModel.Parent then
                            local killerHum = killerModel:FindFirstChildOfClass("Humanoid")
                            local killerRoot = killerModel.PrimaryPart or killerModel:FindFirstChild("HumanoidRootPart") or killerModel:FindFirstChildWhichIsA("BasePart")
                            if killerHum and killerRoot then
                                local distance = (killerRoot.Position - root.Position).Magnitude
                                if distance <= maxDistance and killerIsUsingSpinSword(killerModel, killerHum) then
                                    foundSpin = true
                                    beginSpinCrouch(character)
                                    break
                                end
                            end
                        end
                    end

                    if not foundSpin then
                        finishSpinCrouch(character, false)
                    end
                end)

                if not ok then
                    waitTime = 0.35
                end
                task.wait(waitTime)
            end

            finishSpinCrouch(LocalPlayer and LocalPlayer.Character, true)
        end)
    end

    function stopAutoSpinCrouch()
        spinCrouchRunning = false
        finishSpinCrouch(LocalPlayer and LocalPlayer.Character, true)
    end
end)

end, __arexans_boot_error_handler)
-- =========================================================
-- AREXANS INTEGRATION.LUA MERGE (isolated scope)
-- =========================================================
do
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if type(getgenv) ~= "function" then
    getgenv = function() return _G end
end

-- ==========================================
-- GLOBAL CONFIG BRIDGES
-- ==========================================
getgenv().SilentAimVeilSettings = getgenv().SilentAimVeilSettings or {}
local VeilSettings = getgenv().SilentAimVeilSettings

local DefaultVeil = {
    Enabled             = false,
    TargetPart          = "HumanoidRootPart",
    VeilTargetPart      = "HumanoidRootPart",
    AutoPredict         = false,
    FovRadius           = 300,
    FOV                 = 300,
    MaxTargetDistance   = 286,
    ShowTracker         = false,
    ShowFOV             = false,
    CustomSpearSpeed    = 165,
    CustomSpearGravity  = 103,
    LeadMultiplier      = 1.4,
    AuraSpearSpeed      = 165,
    AuraSpearGravity    = 96.5,
    ESP                 = false,
    Crosshair           = false,
    ESP_Enable          = false,
    ESP_ShowHP          = false,
    ESP_ShowDistance    = false,
    HideName            = false,
    PotatoMode          = false,
}

for k, v in pairs(DefaultVeil) do
    if VeilSettings[k] == nil then VeilSettings[k] = v end
end

getgenv().SilentAimPistolSettings = getgenv().SilentAimPistolSettings or {}
local PistolSettings = getgenv().SilentAimPistolSettings

local DefaultPistol = {
    Enabled             = false,
    TargetPart          = "HumanoidRootPart",
    PistolTargetPart    = "HumanoidRootPart",
    ShowFOV             = false,
    PistolShowFOV       = false,
    FovRadius           = 300, 
    PistolFovRadius     = 300,
    Laser               = false,
    PistolShowLaser     = false,
    StunESP             = false,
    PistolESPStun       = false,
    SafeShot            = false,
}

for k, v in pairs(DefaultPistol) do
    if PistolSettings[k] == nil then PistolSettings[k] = v end
end

local function GetVeilVal(key, altKey, defaultVal)
    local vs = getgenv().SilentAimVeilSettings or VeilSettings
    if vs then
        if vs[key] ~= nil then return vs[key] end
        if altKey and vs[altKey] ~= nil then return vs[altKey] end
    end
    if getgenv().VD_Config then
        if getgenv().VD_Config[key] ~= nil then return getgenv().VD_Config[key] end
        if altKey and getgenv().VD_Config[altKey] ~= nil then return getgenv().VD_Config[altKey] end
    end
    if getgenv().VD then
        if getgenv().VD[key] ~= nil then return getgenv().VD[key] end
        if altKey and getgenv().VD[altKey] ~= nil then return getgenv().VD[altKey] end
    end
    return defaultVal
end

local function GetPistolVal(key, altKey, defaultVal)
    local ps = getgenv().SilentAimPistolSettings or PistolSettings
    if ps then
        if ps[key] ~= nil then return ps[key] end
        if altKey and ps[altKey] ~= nil then return ps[altKey] end
    end
    if getgenv().VD_Config then
        if getgenv().VD_Config[key] ~= nil then return getgenv().VD_Config[key] end
        if altKey and getgenv().VD_Config[altKey] ~= nil then return getgenv().VD_Config[altKey] end
    end
    if getgenv().VD then
        if getgenv().VD[key] ~= nil then return getgenv().VD[key] end
        if altKey and getgenv().VD[altKey] ~= nil then return getgenv().VD[altKey] end
    end
    return defaultVal
end

-- ==========================================
-- SAFE UTILITY FUNCTIONS
-- ==========================================
local function SafeGet(parent, childName)
    if parent and typeof(parent) == "Instance" then return parent:FindFirstChild(childName) end
    return nil
end

local function IsKiller(player)
    if not player then return false end
    if player.Team and player.Team.Name then
        local tName = string.lower(tostring(player.Team.Name))
        if string.find(tName, "killer") or string.find(tName, "slasher") or string.find(tName, "murder") then return true end
    end
    local c = player.Character
    if c and typeof(c) == "Instance" then
        if c:FindFirstChild("Lookscriptkiller", true) or c:FindFirstChild("Killerost", true) or c:FindFirstChild("spearmode", true) or c:GetAttribute("spearmode") ~= nil then
            return true
        end
    end
    return false
end

local function IsSurvivor(player)
    if not player then return false end
    if player.Team and player.Team.Name then
        local tName = string.lower(tostring(player.Team.Name))
        if string.find(tName, "survivor") or string.find(tName, "victim") then return true end
    end
    return not IsKiller(player)
end

local function ResolveTargetPart(char, partName)
    if not char or typeof(char) ~= "Instance" then return nil end
    local hrp = SafeGet(char, "HumanoidRootPart") or SafeGet(char, "Torso") or SafeGet(char, "UpperTorso")
    
    if partName == "HumanoidRootPart" or partName == "Root" then return hrp
    elseif partName == "Head" or partName == "Kepala" then return SafeGet(char, "Head") or hrp
    elseif partName == "Left Shoulder" or partName == "Left Arm" then return SafeGet(char, "LeftUpperArm") or SafeGet(char, "Left Arm") or hrp
    elseif partName == "Right Shoulder" or partName == "Right Arm" then return SafeGet(char, "RightUpperArm") or SafeGet(char, "Right Arm") or hrp
    elseif partName == "Any Shoulder" then
        local left = SafeGet(char, "LeftUpperArm") or SafeGet(char, "Left Arm")
        local right = SafeGet(char, "RightUpperArm") or SafeGet(char, "Right Arm")
        if left and right then
            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            local lp, lOn = Camera:WorldToViewportPoint(left.Position)
            local rp, rOn = Camera:WorldToViewportPoint(right.Position)
            local lDist = lOn and (Vector2.new(lp.X, lp.Y) - center).Magnitude or math.huge
            local rDist = rOn and (Vector2.new(rp.X, rp.Y) - center).Magnitude or math.huge
            if lDist < rDist then return left else return right end
        end
        return left or right or hrp
    elseif partName == "Torso" or partName == "Badan" then return SafeGet(char, "Torso") or SafeGet(char, "UpperTorso") or hrp end
    return hrp
end

-- ==========================================
-- SAFE GUI SETUP FOR ESP
-- ==========================================
local SafeGuiParent = nil
pcall(function() SafeGuiParent = gethui and gethui() end)
if not SafeGuiParent then pcall(function() SafeGuiParent = game:GetService("CoreGui") end) end
if not SafeGuiParent then SafeGuiParent = LocalPlayer:WaitForChild("PlayerGui") end

local ESPFolder = SafeGet(SafeGuiParent, "ArexansTerrainESP_UI")
if not ESPFolder then ESPFolder = Instance.new("Folder") ESPFolder.Name = "ArexansTerrainESP_UI" ESPFolder.Parent = SafeGuiParent end

local KillerESPFolder_Pistol = SafeGet(SafeGuiParent, "KillerESPFolder_Pistol")
if not KillerESPFolder_Pistol then KillerESPFolder_Pistol = Instance.new("Folder") KillerESPFolder_Pistol.Name = "KillerESPFolder_Pistol" KillerESPFolder_Pistol.Parent = SafeGuiParent end

-- ==========================================
-- HIDENAME SYSTEM (STRICT DETECTION & RESTORABLE)
-- ==========================================
local TARGET_NAME = "AREXANS"
local TARGET_IMAGE = "rbxassetid://111967366195505"

local OriginalUI = setmetatable({}, {__mode = "k"})

local function RestoreUI()
    for instance, props in pairs(OriginalUI) do
        pcall(function()
            if props.Text and (instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox")) then
                instance.Text = props.Text
            end
            if props.Image and (instance:IsA("ImageLabel") or instance:IsA("ImageButton")) then
                instance.Image = props.Image
            end
        end)
    end
    table.clear(OriginalUI)
end

-- Mengecek spesifik apakah teks tersebut memuat nama asli/display name pemain
local function FilterPlayerName(text)
    if not text or text == "" or text == TARGET_NAME then return false, text end
    local lowerText = string.lower(text)
    local shouldReplace = false
    local newText = text

    for _, player in ipairs(Players:GetPlayers()) do
        local pName = player.Name
        local dName = player.DisplayName

        if pName ~= "" and string.find(lowerText, string.lower(pName), 1, true) then
            shouldReplace = true
            -- Hilangkan nama spesifik pemain tersebut
            newText = string.gsub(newText, pName, TARGET_NAME)
            newText = string.gsub(newText, string.lower(pName), TARGET_NAME)
        end
        if dName ~= "" and string.find(lowerText, string.lower(dName), 1, true) then
            shouldReplace = true
            newText = string.gsub(newText, dName, TARGET_NAME)
            newText = string.gsub(newText, string.lower(dName), TARGET_NAME)
        end
    end
    return shouldReplace, newText
end

-- Mengecek spesifik apakah URL gambar adalah API Avatar Roblox
local function IsPlayerAvatarIcon(instance, imageStr)
    local imgLower = string.lower(tostring(imageStr or ""))
    if imgLower == "" or imgLower == string.lower(TARGET_IMAGE) then return false end

    -- 1. Deteksi API Thumbnail Roblox (100% Akurat untuk foto profil)
    if string.find(imgLower, "rbxthumb://") and (string.find(imgLower, "avatar") or string.find(imgLower, "headshot")) then
        return true
    end

    -- 2. Fallback untuk game yg pakai UI spesifik tapi gambar biasa
    local instName = string.lower(instance.Name)
    if instName == "avatar" or instName == "playericon" or instName == "profile" or instName == "headshot" then
        -- Cek ekstra: Pastikan ukurannya kecil, mencegah tergantinya background
        local isSmall = true
        pcall(function()
            if instance:IsA("GuiObject") and (instance.AbsoluteSize.X > 200 or instance.AbsoluteSize.Y > 200) then
                isSmall = false
            end
        end)
        if isSmall then return true end
    end

    return false
end

local function processTextElement(instance)
    if not instance or typeof(instance) ~= "Instance" then return end
    pcall(function()
        if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
            local currentText = instance.Text
            local shouldReplace, newText = FilterPlayerName(currentText)
            
            if shouldReplace then
                if not OriginalUI[instance] then OriginalUI[instance] = {} end
                if not OriginalUI[instance].Text then OriginalUI[instance].Text = currentText end
                instance.Text = newText
            end
        end
    end)
end

local function processImageElement(instance)
    if not instance or typeof(instance) ~= "Instance" then return end
    pcall(function()
        if instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
            local currentImage = instance.Image
            if IsPlayerAvatarIcon(instance, currentImage) then
                if not OriginalUI[instance] then OriginalUI[instance] = {} end
                if not OriginalUI[instance].Image then OriginalUI[instance].Image = currentImage end
                instance.Image = TARGET_IMAGE
            end
        end
    end)
end

local function sweepExistingUI()
    task.spawn(function()
        local function scanAndReplace(parentGui)
            if not parentGui or typeof(parentGui) ~= "Instance" then return end
            for _, instance in ipairs(parentGui:GetDescendants()) do 
                processTextElement(instance)
                processImageElement(instance)
            end
        end
        local playerGui = SafeGet(LocalPlayer, "PlayerGui")
        if playerGui then scanAndReplace(playerGui) end
        pcall(function() scanAndReplace(CoreGui) end)
    end)
end

local HideNameConnections = {}
local function SetupUIListeners()
    for _, conn in ipairs(HideNameConnections) do pcall(function() conn:Disconnect() end) end
    table.clear(HideNameConnections)

    local function attach(instance)
        if not GetVeilVal("HideName", nil, false) then return end
        processTextElement(instance)
        processImageElement(instance)

        if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
            table.insert(HideNameConnections, instance:GetPropertyChangedSignal("Text"):Connect(function()
                if GetVeilVal("HideName", nil, false) then processTextElement(instance) end
            end))
        elseif instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
            table.insert(HideNameConnections, instance:GetPropertyChangedSignal("Image"):Connect(function()
                if GetVeilVal("HideName", nil, false) then processImageElement(instance) end
            end))
        end
    end

    local function listenGui(parentGui)
        if not parentGui or typeof(parentGui) ~= "Instance" then return end
        for _, descendant in ipairs(parentGui:GetDescendants()) do attach(descendant) end
        table.insert(HideNameConnections, parentGui.DescendantAdded:Connect(function(descendant)
            if GetVeilVal("HideName", nil, false) then attach(descendant) end
        end))
    end

    local pg = SafeGet(LocalPlayer, "PlayerGui")
    if pg then listenGui(pg) end
    pcall(function() listenGui(CoreGui) end)
end

local function SetupNameHooks()
    local oldNewIndex
    if hookmetamethod then
        oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(t, k, v)
            if GetVeilVal("HideName", nil, false) and type(v) == "string" then
                if k == "Text" then
                    local shouldReplace, newText = FilterPlayerName(v)
                    if shouldReplace then 
                        if not OriginalUI[t] then OriginalUI[t] = {} end
                        OriginalUI[t].Text = v
                        return oldNewIndex(t, k, newText) 
                    end
                elseif k == "Image" then
                    if IsPlayerAvatarIcon(t, v) then
                        if not OriginalUI[t] then OriginalUI[t] = {} end
                        OriginalUI[t].Image = v
                        return oldNewIndex(t, k, TARGET_IMAGE)
                    end
                end
            end
            return oldNewIndex(t, k, v)
        end))
    else
        local mt = getrawmetatable and getrawmetatable(game)
        if mt and setreadonly then
            oldNewIndex = mt.__newindex
            setreadonly(mt, false)
            mt.__newindex = newcclosure(function(t, k, v)
                if GetVeilVal("HideName", nil, false) and type(v) == "string" then
                    if k == "Text" then
                        local shouldReplace, newText = FilterPlayerName(v)
                        if shouldReplace then 
                            if not OriginalUI[t] then OriginalUI[t] = {} end
                            OriginalUI[t].Text = v
                            return oldNewIndex(t, k, newText) 
                        end
                    elseif k == "Image" then
                        if IsPlayerAvatarIcon(t, v) then
                            if not OriginalUI[t] then OriginalUI[t] = {} end
                            OriginalUI[t].Image = v
                            return oldNewIndex(t, k, TARGET_IMAGE)
                        end
                    end
                end
                return oldNewIndex(t, k, v)
            end)
            setreadonly(mt, true)
        end
    end
end
pcall(SetupNameHooks)

task.spawn(function()
    SetupUIListeners()
    while task.wait(0.5) do
        if GetVeilVal("HideName", nil, false) then sweepExistingUI() end
    end
end)

-- ==========================================
-- SILENT AIM STATE & DRAWING API
-- ==========================================
local SpearState = { target = nil, lookVector = nil, velHistory = {} }
local defaultColor = Color3.fromRGB(0, 150, 255)
local lockedColor = Color3.fromRGB(0, 255, 120)
local blockedColor = Color3.fromRGB(255, 50, 50)

local SpearVisuals = {}
pcall(function()
    SpearVisuals.FOVCircle = Drawing.new("Circle") SpearVisuals.FOVCircle.Color = defaultColor SpearVisuals.FOVCircle.Thickness = 1.5 SpearVisuals.FOVCircle.Filled = false SpearVisuals.FOVCircle.Transparency = 1 SpearVisuals.FOVCircle.Visible = false
    SpearVisuals.TrackerCircle = Drawing.new("Circle") SpearVisuals.TrackerCircle.Color = lockedColor SpearVisuals.TrackerCircle.Thickness = 2 SpearVisuals.TrackerCircle.Filled = true SpearVisuals.TrackerCircle.Transparency = 0.8 SpearVisuals.TrackerCircle.Visible = false
    SpearVisuals.TrackerLine = Drawing.new("Line") SpearVisuals.TrackerLine.Color = lockedColor SpearVisuals.TrackerLine.Thickness = 1.5 SpearVisuals.TrackerLine.Transparency = 0.7 SpearVisuals.TrackerLine.Visible = false
end)

-- ==========================================
-- SURVIVOR PISTOL STATE & VISUALS
-- ==========================================
local isShooting = false
local KILLER_MARKER_NAME = "Lookscriptkiller"

local tracerStart = Instance.new("Part")
tracerStart.Size = Vector3.new(0.1, 0.1, 0.1) tracerStart.Transparency = 1 tracerStart.Anchored = true tracerStart.CanCollide = false tracerStart.Parent = workspace
local tracerEnd = tracerStart:Clone() tracerEnd.Parent = workspace
local att0 = Instance.new("Attachment", tracerStart) local att1 = Instance.new("Attachment", tracerEnd)
local tracerBeam = Instance.new("Beam") tracerBeam.Attachment0 = att0 tracerBeam.Attachment1 = att1 tracerBeam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255)) tracerBeam.Width0 = 0.15 tracerBeam.Width1 = 0.15 tracerBeam.LightEmission = 1 tracerBeam.LightInfluence = 0 tracerBeam.FaceCamera = true tracerBeam.Enabled = false tracerBeam.Parent = tracerStart

local PistolFOVCircle = Drawing.new("Circle") PistolFOVCircle.Color = Color3.fromRGB(255, 255, 255) PistolFOVCircle.Thickness = 1.5 PistolFOVCircle.Transparency = 0.8 PistolFOVCircle.Filled = false PistolFOVCircle.Visible = false

local function GetEquippedGun(rightArm)
    if not rightArm or typeof(rightArm) ~= "Instance" then return nil end
    for _, child in ipairs(rightArm:GetChildren()) do
        if (child:IsA("Model") or child:IsA("BasePart")) and not string.find(child.Name, "Weld") and not string.find(child.Name, "Grip") then
            return child
        end
    end
    return rightArm:FindFirstChildWhichIsA("Model")
end

local function GetKillerTarget()
    local myChar = LocalPlayer.Character
    local myHRP = SafeGet(myChar, "HumanoidRootPart")
    if not myHRP then return nil end

    local pistolFov = GetPistolVal("FovRadius", "PistolFovRadius", 300)
    local pistolPart = GetPistolVal("TargetPart", "PistolTargetPart", "HumanoidRootPart")
    local nearestBody = nil
    local nearestScreenDistance = pistolFov 
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and typeof(char) == "Instance" and (char:FindFirstChild(KILLER_MARKER_NAME, true) or IsKiller(player)) then
                local body = ResolveTargetPart(char, pistolPart)
                if body then
                    local sp, on = Camera:WorldToViewportPoint(body.Position)
                    if on and sp.Z > 0 then
                        local screenDist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if screenDist <= nearestScreenDistance then
                            nearestScreenDistance = screenDist
                            nearestBody = body
                        end
                    end
                end
            end
        end
    end
    return nearestBody
end

-- ==========================================
-- SURVIVOR PISTOL (SAFE SHOT & INPUT)
-- ==========================================
local connectedShootButtons = {}
local function ConnectShootButton(button)
    if not button or connectedShootButtons[button] then return end
    connectedShootButtons[button] = true
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isShooting = true 
        end
    end)
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isShooting = false
        end
    end)
end

local function ScanForShootButton()
    local playerGui = SafeGet(LocalPlayer, "PlayerGui")
    if not playerGui then return end
    local survivorMob = SafeGet(playerGui, "Survivor-mob") if not survivorMob then return end
    for _, object in ipairs(survivorMob:GetDescendants()) do
        if object:IsA("ImageButton") and object.Name == "Gui-mob" then ConnectShootButton(object) end
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isShooting = true end
end)
UserInputService.InputEnded:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isShooting = false end
end)
LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5) ScanForShootButton() end)

task.spawn(function()
    local FireRemote = nil
    pcall(function() FireRemote = ReplicatedStorage.Remotes.Items["Twist of Fate"].Fire end)
    if FireRemote and getconnections then
        for _, Connection in pairs(getconnections(FireRemote.OnClientEvent)) do
            local oldFunc = Connection.Function
            hookfunction(oldFunc, function(...)
                if GetPistolVal("SafeShot", "SafeShotEnabled", false) then
                    return
                end
                return oldFunc(...)
            end)
        end
    end
end)

-- ==========================================
-- ESP SYSTEM
-- ==========================================
local ESPObjects = {}

local function createESP(player, folderToUse)
    if ESPObjects[player] then return end
    local highlight = Instance.new("Highlight") highlight.Name = player.Name .. "_Highlight" highlight.FillColor = defaultColor highlight.OutlineColor = defaultColor highlight.FillTransparency = 0.4 highlight.OutlineTransparency = 0 highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    local billboard = Instance.new("BillboardGui") billboard.Name = player.Name .. "_Billboard" billboard.Size = UDim2.new(0, 150, 0, 20) billboard.StudsOffset = Vector3.new(0, 3.5, 0) billboard.AlwaysOnTop = true billboard.Parent = folderToUse
    local container = Instance.new("Frame") container.Name = "Container" container.Size = UDim2.new(1, 0, 1, 0) container.BackgroundTransparency = 1 container.Parent = billboard
    local layout = Instance.new("UIListLayout") layout.FillDirection = Enum.FillDirection.Horizontal layout.HorizontalAlignment = Enum.HorizontalAlignment.Center layout.VerticalAlignment = Enum.VerticalAlignment.Center layout.SortOrder = Enum.SortOrder.LayoutOrder layout.Padding = UDim.new(0, 4) layout.Parent = container

    local hpIcon = Instance.new("ImageLabel") hpIcon.Name = "HPIcon" hpIcon.Size = UDim2.new(0, 15, 0, 15) hpIcon.BackgroundTransparency = 1 hpIcon.Image = "rbxassetid://98303439166077" hpIcon.LayoutOrder = 1 hpIcon.Parent = container
    local hpText = Instance.new("TextLabel") hpText.Name = "HPText" hpText.Size = UDim2.new(0, 0, 1, 0) hpText.AutomaticSize = Enum.AutomaticSize.X hpText.BackgroundTransparency = 1 hpText.Font = Enum.Font.GothamBold hpText.TextSize = 13 hpText.TextStrokeTransparency = 0 hpText.LayoutOrder = 2 hpText.Parent = container
    local sep = Instance.new("TextLabel") sep.Name = "Separator" sep.Size = UDim2.new(0, 0, 1, 0) sep.AutomaticSize = Enum.AutomaticSize.X sep.BackgroundTransparency = 1 sep.Font = Enum.Font.GothamBold sep.TextSize = 13 sep.Text = "|" sep.TextColor3 = Color3.fromRGB(200, 200, 200) sep.TextStrokeTransparency = 0 sep.LayoutOrder = 3 sep.Parent = container
    local distIcon = Instance.new("ImageLabel") distIcon.Name = "DistIcon" distIcon.Size = UDim2.new(0, 15, 0, 15) distIcon.BackgroundTransparency = 1 distIcon.Image = "rbxassetid://105157482942446" distIcon.LayoutOrder = 4 distIcon.Parent = container
    local distText = Instance.new("TextLabel") distText.Name = "DistText" distText.Size = UDim2.new(0, 0, 1, 0) distText.AutomaticSize = Enum.AutomaticSize.X distText.BackgroundTransparency = 1 distText.Font = Enum.Font.GothamBold distText.TextSize = 13 distText.TextStrokeTransparency = 0 distText.LayoutOrder = 5 distText.Parent = container
    
    ESPObjects[player] = { Highlight = highlight, Billboard = billboard, Container = container }
end

local function removeESP(player)
    if ESPObjects[player] then
        if ESPObjects[player].Highlight then ESPObjects[player].Highlight:Destroy() end
        if ESPObjects[player].Billboard then ESPObjects[player].Billboard:Destroy() end
        ESPObjects[player] = nil
    end
end

-- ==========================================
-- MATH & UTILS (PARABOLA PHYSICS)
-- ==========================================
local function IsVisible(targetPart, originPart)
    if not targetPart or not originPart then return false end
    local origin = originPart.Position
    local direction = (targetPart.Position - origin)
    local raycastParams = RaycastParams.new()
    local filterList = {targetPart.Parent}
    if LocalPlayer.Character then table.insert(filterList, LocalPlayer.Character) end
    raycastParams.FilterDescendantsInstances = filterList
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    if raycastResult then return false end
    return true
end

local function solvePitch(p, d, dy)
    d = math.max(d, 0.1)
    local s2 = p.v0 * p.v0
    local root = s2 * s2 - p.g * (p.g * d * d + 2 * dy * s2)
    local outOfRange = false
    if root < 0 then root = 0; outOfRange = true end
    local tanTheta = (s2 - math.sqrt(root)) / (p.g * d)
    local theta = math.atan(tanTheta)
    local t = d / (p.v0 * math.cos(theta))
    return theta, outOfRange, t
end

local function getCharacterVelocity(char)
    if not char or typeof(char) ~= "Instance" then return Vector3.zero end
    local root = SafeGet(char, "HumanoidRootPart") or SafeGet(char, "Torso")
    if not root or not root:IsA("BasePart") then return Vector3.zero end
    
    local now = os.clock()
    local last = SpearState.velHistory[char]
    local measured = Vector3.zero
    if last and now - last.t > 0.02 then
        measured = (root.Position - last.pos) / (now - last.t)
        if measured.Magnitude > 150 then measured = last.smooth or Vector3.zero end
    end
    local smooth = last and last.smooth or measured
    smooth = smooth:Lerp(measured, 0.65)
    SpearState.velHistory[char] = { pos = root.Position, t = now, smooth = smooth }
    if smooth.Magnitude < 1 then return Vector3.zero end
    return Vector3.new(smooth.X, 0, smooth.Z)
end

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
    if player.Character then SpearState.velHistory[player.Character] = nil end
end)

-- ==========================================
-- MAIN RENDER LOOP (KILLER & SURVIVOR)
-- ==========================================
RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local isPlayingKiller = IsKiller(LocalPlayer)
    local isPlayingSurvivor = IsSurvivor(LocalPlayer)
    local char = LocalPlayer.Character
    local myRoot = SafeGet(char, "HumanoidRootPart")
    
    local veilEnabled        = GetVeilVal("Enabled", "EnableSilentVeil", false)
    local veilTargetPartName = GetVeilVal("TargetPart", "VeilTargetPart", "HumanoidRootPart")
    local veilAutoPredict    = GetVeilVal("AutoPredict", nil, false)
    local veilFovRadius      = GetVeilVal("FovRadius", "FOV", 300)
    local veilMaxDist        = GetVeilVal("MaxTargetDistance", "MaxDist", 286)
    local veilShowTracker    = GetVeilVal("ShowTracker", "Tracker", false)
    local veilShowFOV        = GetVeilVal("ShowFOV", nil, false)
    local veilSpearSpeed     = GetVeilVal("CustomSpearSpeed", "SpearSpeed", 165)
    local veilSpearGravity   = GetVeilVal("CustomSpearGravity", "Gravity", 103)
    local veilLeadMult       = GetVeilVal("LeadMultiplier", nil, 1.4)
    local veilAuraSpeed      = GetVeilVal("AuraSpearSpeed", nil, 165)
    local veilAuraGravity    = GetVeilVal("AuraSpearGravity", nil, 96.5)

    local pistolEnabled      = GetPistolVal("Enabled", "SilentAimPistol", false)
    local pistolShowFOV      = GetPistolVal("ShowFOV", "PistolShowFOV", false)
    local pistolFovRadius    = GetPistolVal("FovRadius", "PistolFovRadius", 300)
    local pistolShowLaser    = GetPistolVal("Laser", "PistolShowLaser", false)
    local pistolESPStun      = GetPistolVal("StunESP", "PistolESPStun", false)

    local espEnable          = GetVeilVal("ESP_Enable", "ESP", false)
    local espShowHP          = GetVeilVal("ESP_ShowHP", nil, false)
    local espShowDist        = GetVeilVal("ESP_ShowDistance", nil, false)

    if isPlayingKiller and veilEnabled then
        if veilShowFOV and SpearVisuals.FOVCircle then
            SpearVisuals.FOVCircle.Position = center SpearVisuals.FOVCircle.Radius = veilFovRadius SpearVisuals.FOVCircle.Visible = true
        elseif SpearVisuals.FOVCircle then SpearVisuals.FOVCircle.Visible = false end

        if myRoot then
            local nearest = nil
            local bestDist = veilFovRadius
            local bestStudDist = veilMaxDist

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and IsSurvivor(p) then
                    local pc = p.Character
                    if pc and typeof(pc) == "Instance" then
                        local isDown = pc:GetAttribute("Knocked") == true or pc:GetAttribute("HookProgressDepleting") == true
                        if not isDown then
                            local hum = pc:FindFirstChildOfClass("Humanoid")
                            local targetPart = ResolveTargetPart(pc, veilTargetPartName)
                            if hum and hum.Health > 0 and targetPart then
                                local sp, on = Camera:WorldToViewportPoint(targetPart.Position)
                                if on and sp.Z > 0 then
                                    local sd = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                                    if sd < bestDist then
                                        local studDist = (targetPart.Position - myRoot.Position).Magnitude
                                        if studDist <= bestStudDist then
                                            bestDist = sd
                                            nearest = p
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if nearest then
                local nChar = nearest.Character
                if nChar and typeof(nChar) == "Instance" then
                    local tpPart = ResolveTargetPart(nChar, veilTargetPartName)
                    if tpPart then
                        local tp = tpPart.Position
                        local hand = SafeGet(char, "Right Arm") or SafeGet(char, "RightHand")
                        local origin = (hand and hand:IsA("BasePart")) and hand.Position or myRoot.Position
                        local dir = tp - origin
                        local dist = dir.Magnitude

                        if dist > 0.1 and dist <= veilMaxDist then
                            local isAuraActive = char:GetAttribute("special") == true
                            local prof = isAuraActive and { v0 = veilAuraSpeed, g = veilAuraGravity, windup = 0.10, latency = 0.04, maxlead = 25, scale = veilLeadMult } or { v0 = veilSpearSpeed, g = veilSpearGravity, windup = 0.10, latency = 0.04, maxlead = 45, scale = veilLeadMult }
                            local aimPoint = tp
                            if veilAutoPredict then
                                local vel = getCharacterVelocity(nChar)
                                if vel.Magnitude > 0.5 then
                                    local h0 = Vector3.new(dir.X, 0, dir.Z)
                                    local _, _, tFlight = solvePitch(prof, h0.Magnitude, dir.Y)
                                    local ping = 0.08 pcall(function() ping = math.clamp(LocalPlayer:GetNetworkPing(), 0, 0.35) end)
                                    local delay = tFlight + prof.windup + ping + prof.latency
                                    for i = 1, 2 do
                                        local lead = vel * delay * prof.scale
                                        local maxLead = math.clamp(dist * 0.6, 3, prof.maxlead)
                                        if lead.Magnitude > maxLead then lead = lead.Unit * maxLead end
                                        aimPoint = tp + lead
                                        local ad = aimPoint - origin
                                        local ah = Vector3.new(ad.X, 0, ad.Z)
                                        local _, _, t2 = solvePitch(prof, math.max(ah.Magnitude, 0.1), ad.Y)
                                        delay = t2 + prof.windup + ping + prof.latency
                                    end
                                end
                            end
                            local adir = aimPoint - origin
                            local ah = Vector3.new(adir.X, 0, adir.Z)
                            local ahDist = ah.Magnitude
                            local pitch = solvePitch(prof, ahDist, adir.Y)
                            if ahDist > 0.001 then SpearState.lookVector = ah.Unit * math.cos(pitch) + Vector3.new(0, math.sin(pitch), 0) else SpearState.lookVector = adir.Unit end
                            SpearState.target = nearest
                        else SpearState.target = nil SpearState.lookVector = nil end
                    else SpearState.target = nil SpearState.lookVector = nil end
                else SpearState.target = nil SpearState.lookVector = nil end
            else SpearState.target = nil SpearState.lookVector = nil end
        else SpearState.target = nil SpearState.lookVector = nil end
    else
        SpearState.target = nil SpearState.lookVector = nil
        if SpearVisuals.FOVCircle then SpearVisuals.FOVCircle.Visible = false end
    end

    if isPlayingKiller and SpearState.target and veilShowTracker then
        local targetChar = SpearState.target.Character
        if targetChar and typeof(targetChar) == "Instance" then
            local tpPart = ResolveTargetPart(targetChar, veilTargetPartName)
            if tpPart then
                local sp, vis = Camera:WorldToViewportPoint(tpPart.Position)
                if vis and sp.Z > 0 then
                    local screenDist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if screenDist <= veilFovRadius then
                        local isClear = IsVisible(tpPart, myRoot)
                        local tColor = isClear and lockedColor or blockedColor

                        if SpearVisuals.TrackerLine then SpearVisuals.TrackerLine.From = center SpearVisuals.TrackerLine.To = Vector2.new(sp.X, sp.Y) SpearVisuals.TrackerLine.Color = tColor SpearVisuals.TrackerLine.Visible = true end
                        if SpearVisuals.TrackerCircle then local dist = myRoot and (myRoot.Position - tpPart.Position).Magnitude or 100 SpearVisuals.TrackerCircle.Position = Vector2.new(sp.X, sp.Y) SpearVisuals.TrackerCircle.Radius = math.clamp(1000 / dist, 10, 40) SpearVisuals.TrackerCircle.Color = tColor SpearVisuals.TrackerCircle.Visible = true end
                    else
                        if SpearVisuals.TrackerLine then SpearVisuals.TrackerLine.Visible = false end if SpearVisuals.TrackerCircle then SpearVisuals.TrackerCircle.Visible = false end
                    end
                else
                    if SpearVisuals.TrackerLine then SpearVisuals.TrackerLine.Visible = false end if SpearVisuals.TrackerCircle then SpearVisuals.TrackerCircle.Visible = false end
                end
            else
                if SpearVisuals.TrackerLine then SpearVisuals.TrackerLine.Visible = false end if SpearVisuals.TrackerCircle then SpearVisuals.TrackerCircle.Visible = false end
            end
        else
            if SpearVisuals.TrackerLine then SpearVisuals.TrackerLine.Visible = false end if SpearVisuals.TrackerCircle then SpearVisuals.TrackerCircle.Visible = false end
        end
    else
        if SpearVisuals.TrackerLine then SpearVisuals.TrackerLine.Visible = false end if SpearVisuals.TrackerCircle then SpearVisuals.TrackerCircle.Visible = false end
    end

    if isPlayingSurvivor then
        local targetBody = GetKillerTarget()
        
        if pistolEnabled and pistolShowFOV then
            PistolFOVCircle.Position = center 
            PistolFOVCircle.Radius = pistolFovRadius 
            PistolFOVCircle.Visible = true
        else PistolFOVCircle.Visible = false end

        if isShooting and pistolEnabled and pistolShowLaser and myRoot and targetBody then
            local twist = SafeGet(char, "Twist of Fate")
            local rightArm = twist and SafeGet(twist, "Right Arm")
            local gun = rightArm and GetEquippedGun(rightArm)
            tracerStart.Position = (gun and gun:GetPivot().Position) or (myRoot.Position + Vector3.new(0, 1, 0))
            tracerEnd.Position = targetBody.Position
            tracerBeam.Enabled = true
        else tracerBeam.Enabled = false end

        if pistolESPStun then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local pChar = player.Character
                    if pChar and typeof(pChar) == "Instance" and (pChar:FindFirstChild(KILLER_MARKER_NAME, true) or IsKiller(player)) then
                        local head = SafeGet(pChar, "Head")
                        local hum = SafeGet(pChar, "Humanoid")
                        if head and hum and hum.Health > 0 then
                            local espUI = SafeGet(KillerESPFolder_Pistol, player.Name)
                            if not espUI then
                                espUI = Instance.new("BillboardGui") espUI.Name = player.Name espUI.Size = UDim2.new(0, 200, 0, 50) espUI.StudsOffset = Vector3.new(0, 2.5, 0) espUI.AlwaysOnTop = true espUI.Parent = KillerESPFolder_Pistol
                                local textLabel = Instance.new("TextLabel") textLabel.Name = "StatusText" textLabel.Size = UDim2.new(1, 0, 1, 0) textLabel.BackgroundTransparency = 1 textLabel.Font = Enum.Font.GothamBlack textLabel.TextStrokeTransparency = 0 textLabel.Parent = espUI
                            end
                            espUI.Adornee = head
                            
                            local isStunned = false
                            if hum.WalkSpeed < 6 then isStunned = true
                            elseif pChar:GetAttribute("Stunned") == true or pChar:GetAttribute("IsStunned") == true then isStunned = true
                            elseif SafeGet(pChar, "Stunned") ~= nil or SafeGet(pChar, "Stun") ~= nil then isStunned = true end
                            
                            local txt = espUI.StatusText
                            if isStunned then txt.Text = "⚡ STUNNED ⚡" txt.TextColor3 = Color3.fromRGB(255, 255, 0) txt.TextStrokeColor3 = Color3.fromRGB(200, 0, 0) txt.TextSize = 12 
                            else txt.Text = "💀 KILLER 💀" txt.TextColor3 = Color3.fromRGB(255, 50, 50) txt.TextStrokeColor3 = Color3.fromRGB(150, 0, 0) txt.TextSize = 18 end
                        else
                            local espUI = SafeGet(KillerESPFolder_Pistol, player.Name) if espUI then espUI:Destroy() end
                        end
                    else
                        local espUI = SafeGet(KillerESPFolder_Pistol, player.Name) if espUI then espUI:Destroy() end
                    end
                end
            end
        else
            KillerESPFolder_Pistol:ClearAllChildren()
        end
    else
        PistolFOVCircle.Visible = false
        tracerBeam.Enabled = false
        KillerESPFolder_Pistol:ClearAllChildren()
    end

    if isPlayingKiller then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsSurvivor(player) then
                local pChar = player.Character
                if espEnable and pChar and typeof(pChar) == "Instance" then
                    local targetHRP = SafeGet(pChar, "HumanoidRootPart")
                    local hum = SafeGet(pChar, "Humanoid")
                    
                    if targetHRP and hum and hum.Health > 0 then
                        createESP(player, ESPFolder)
                        local esp = ESPObjects[player]
                        local container = esp.Container
                        
                        if esp.Highlight.Parent ~= pChar then esp.Highlight.Parent = pChar end
                        local head = SafeGet(pChar, "Head") if head then esp.Billboard.Adornee = head end
                        if esp.Billboard.Parent ~= ESPFolder then esp.Billboard.Parent = ESPFolder end
                        
                        local isClear = IsVisible(targetHRP, myRoot)
                        local isLocked = (player == SpearState.target)
                        local espHighlightColor = defaultColor 
                        
                        if isLocked then espHighlightColor = isClear and lockedColor or blockedColor
                        else espHighlightColor = isClear and defaultColor or blockedColor end
                        
                        esp.Highlight.FillColor = espHighlightColor
                        esp.Highlight.OutlineColor = espHighlightColor
                        
                        local dist = myRoot and math.floor((myRoot.Position - targetHRP.Position).Magnitude) or 0
                        local hp = math.floor(hum.Health)
                        
                        local hpColor = Color3.fromRGB(0, 191, 255) if hp <= 20 then hpColor = Color3.fromRGB(255, 69, 0) elseif hp <= 60 then hpColor = Color3.fromRGB(255, 165, 0) end
                        local distColor = Color3.fromRGB(0, 191, 255) if dist > 210 then distColor = Color3.fromRGB(255, 69, 0) elseif dist >= 111 then distColor = Color3.fromRGB(255, 165, 0) end
                        
                        if espShowHP then
                            container.HPIcon.Visible = true container.HPText.Visible = true container.HPIcon.ImageColor3 = hpColor container.HPText.TextColor3 = hpColor container.HPText.Text = tostring(hp)
                        else container.HPIcon.Visible = false container.HPText.Visible = false end
                        
                        if espShowDist then
                            container.DistIcon.Visible = true container.DistText.Visible = true container.DistIcon.ImageColor3 = distColor container.DistText.TextColor3 = distColor container.DistText.Text = tostring(dist) .. "m"
                        else container.DistIcon.Visible = false container.DistText.Visible = false end
                        
                        container.Separator.Visible = (espShowHP and espShowDist)
                    else
                        removeESP(player)
                    end
                else
                    removeESP(player)
                end
            else
                removeESP(player)
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do removeESP(player) end
    end
end)

-- ==========================================
-- NAMECALL HOOK (SPEAR & PISTOL SILENT AIM)
-- ==========================================
local function SetupNamecallHook()
    local oldNamecall
    if hookmetamethod then
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = { ... }

            if method == "FireServer" and typeof(self) == "Instance" then
                local selfName = string.lower(self.Name)
                
                if selfName == "spearthrow" and IsKiller(LocalPlayer) then
                    local veilEnabled = GetVeilVal("Enabled", "EnableSilentVeil", false)
                    if veilEnabled and SpearState.lookVector and typeof(SpearState.lookVector) == "Vector3" then
                        if SpearState.lookVector.X == SpearState.lookVector.X and SpearState.lookVector.Magnitude > 0 then
                            args[1] = SpearState.lookVector
                        end
                    end
                    return oldNamecall(self, unpack(args, 1, select("#", ...)))
                end

                local pistolEnabled = GetPistolVal("Enabled", "SilentAimPistol", false)
                if selfName == "fire" and pistolEnabled and self.Parent and self.Parent.Name == "Twist of Fate" then
                    local myChar = LocalPlayer.Character
                    local myHRP = SafeGet(myChar, "HumanoidRootPart")
                    local targetBody = GetKillerTarget()
                    if targetBody and myHRP then
                        local rawDirection = targetBody.Position - myHRP.Position
                        if rawDirection.Magnitude > 0.001 then
                            args[2] = rawDirection.Unit
                            return oldNamecall(self, unpack(args, 1, select("#", ...)))
                        end
                    end
                end
            end
            return oldNamecall(self, ...)
        end))
    else
        local mt = getrawmetatable and getrawmetatable(game)
        if mt and setreadonly then
            oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = { ... }

                if method == "FireServer" and typeof(self) == "Instance" then
                    local selfName = string.lower(self.Name)
                    
                    if selfName == "spearthrow" and IsKiller(LocalPlayer) then
                        local veilEnabled = GetVeilVal("Enabled", "EnableSilentVeil", false)
                        if veilEnabled and SpearState.lookVector and typeof(SpearState.lookVector) == "Vector3" then
                            if SpearState.lookVector.X == SpearState.lookVector.X and SpearState.lookVector.Magnitude > 0 then
                                args[1] = SpearState.lookVector
                            end
                        end
                        return oldNamecall(self, unpack(args, 1, select("#", ...)))
                    end

                    local pistolEnabled = GetPistolVal("Enabled", "SilentAimPistol", false)
                    if selfName == "fire" and pistolEnabled and self.Parent and self.Parent.Name == "Twist of Fate" then
                        local myChar = LocalPlayer.Character
                        local myHRP = SafeGet(myChar, "HumanoidRootPart")
                        local targetBody = GetKillerTarget()
                        if targetBody and myHRP then
                            local rawDirection = targetBody.Position - myHRP.Position
                            if rawDirection.Magnitude > 0.001 then
                                args[2] = rawDirection.Unit
                                return oldNamecall(self, unpack(args, 1, select("#", ...)))
                            end
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
        end
    end
end
pcall(SetupNamecallHook)

-- ==========================================
-- AUTO CROUCH (ABYSS)
-- ==========================================
local activeSlashers = {}
local animConns = {}
local currentCrouchState = false

local function GetCrouchButton()
    local gui = SafeGet(LocalPlayer, "PlayerGui")
    if not gui then return nil end
    local survivorMob = SafeGet(gui, "Survivor-mob")
    if not survivorMob then return nil end
    local controls = SafeGet(survivorMob, "Controls")
    if not controls then return nil end
    return SafeGet(controls, "crouch")
end

local function SetCrouchSync(state)
    if currentCrouchState == state then return end
    currentCrouchState = state

    local char = LocalPlayer.Character
    if char then
        char:SetAttribute("Crouching", state)
        char:SetAttribute("Crouchingserver", state)

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if state then
                humanoid.WalkSpeed = 2
            else
                humanoid.WalkSpeed = 16
            end
        end
    end

    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local mech = remotes:FindFirstChild("Mechanics")
            if mech then
                local ca = mech:FindFirstChild("ChangeAttribute")
                if ca then
                    ca:FireServer("Crouching", state)
                    ca:FireServer("Crouchingserver", state)
                end
            end
        end
    end)

    local isPC = not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled
    if isPC then
        pcall(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(state, Enum.KeyCode.LeftControl, false, game)
        end)
    else
        local btn = GetCrouchButton()
        if btn and type(firesignal) == "function" then
            if state then
                firesignal(btn.MouseButton1Down)
                if btn.MouseButton1Click then firesignal(btn.MouseButton1Click) end
            else
                firesignal(btn.MouseButton1Up)
                if btn.MouseButton1Click then firesignal(btn.MouseButton1Click) end
            end
        end
    end
end

local function HookSlasherAnimation(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if animConns[humanoid] then return end

    animConns[humanoid] = humanoid.AnimationPlayed:Connect(function(animTrack)
        local enabled = GetVeilVal("SURV_AutoCrouch", "AutoCrouch", false)
        if not enabled then return end
        local anim = animTrack.Animation
        if not anim then return end
        local animId = tostring(anim.AnimationId):match("%d+") or ""
        if animId == "80411309607666" then
            activeSlashers[character] = true
            animTrack.Stopped:Connect(function()
                task.wait(0.2)
                activeSlashers[character] = nil
            end)
        end
    end)

    humanoid.Died:Connect(function()
        activeSlashers[character] = nil
    end)
end

local function UpdateAutoCrouch()
    local enabled = GetVeilVal("SURV_AutoCrouch", "AutoCrouch", false)
    if not enabled then
        if currentCrouchState then SetCrouchSync(false) end
        return
    end

    local char = LocalPlayer.Character
    local playerPos = char and char:FindFirstChild("HumanoidRootPart")
    if not playerPos then
        if currentCrouchState then SetCrouchSync(false) end
        return
    end

    local radius = GetVeilVal("SURV_AutoCrouchRadius", "AutoCrouchRadius", 18)
    local shouldCrouch = false

    for slasherChar, _ in pairs(activeSlashers) do
        if slasherChar and slasherChar.Parent then
            local root = slasherChar:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (root.Position - playerPos.Position).Magnitude
                if dist <= radius then
                    shouldCrouch = true
                    break
                end
            end
        else
            activeSlashers[slasherChar] = nil
        end
    end

    if currentCrouchState ~= shouldCrouch then
        SetCrouchSync(shouldCrouch)
    end
end

task.spawn(function()
    while task.wait(0.15) do
        pcall(UpdateAutoCrouch)
    end
end)

local function HookNewPlayer(player)
    if player == LocalPlayer then return end
    if player.Character then HookSlasherAnimation(player.Character) end
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        HookSlasherAnimation(char)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then HookNewPlayer(player) end
end
Players.PlayerAdded:Connect(HookNewPlayer)

-- ==========================================
-- AUTO PARRY
-- ==========================================
local ParryATTACK_ANIMS = {
    ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://74968262036854"] = true,
    ["rbxassetid://110355011987939"] = true,
    ["rbxassetid://139369275981139"] = true,
    ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://133963973694098"] = true,
    ["rbxassetid://117042998468241"] = true,
    ["rbxassetid://105374834496520"] = true,
    ["rbxassetid://111920872708571"] = true,
    ["rbxassetid://78432063483146"] = true,
    ["rbxassetid://118907603246885"] = true,
    ["rbxassetid://138720291317243"] = true,
    ["rbxassetid://115244153053858"] = true,
    ["rbxassetid://130593238885843"] = true,
    ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"] = true,
    ["rbxassetid://135002183282873"] = true,
    ["rbxassetid://121216847022485"] = true,
}

local function HasDagger()
    local char = LocalPlayer.Character
    if not char then return false end
    return char:FindFirstChild("Parrying Dagger") ~= nil or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Parrying Dagger") ~= nil)
end

local function DoAutoParry()
    local parryRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Items") and ReplicatedStorage.Remotes.Items:FindFirstChild("Parrying Dagger") and ReplicatedStorage.Remotes.Items["Parrying Dagger"]:FindFirstChild("parry")
    if parryRemote then
        pcall(function() parryRemote:FireServer() end)
    end
end

local ParryAttached = {}
local function AttachParrySensor(kChar)
    if not kChar or ParryAttached[kChar] then return end
    ParryAttached[kChar] = true
    local humanoid = kChar:FindFirstChildOfClass("Humanoid") or kChar:WaitForChild("Humanoid", 3)
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator", 3)
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        local autoParry = GetVeilVal("SURV_AutoParry", "AutoParry", false) or (getgenv().AutoParrySettings and getgenv().AutoParrySettings.AutoParryEnabled)
        if not autoParry then return end
        if not HasDagger() then return end

        local animId = track.Animation and track.Animation.AnimationId or ""
        if not ParryATTACK_ANIMS[animId] then return end

        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local kHRP = kChar:FindFirstChild("HumanoidRootPart")
        if not myHRP or not kHRP then return end

        local parryRange = GetVeilVal("SURV_ParryRange", "ParryRange", 12) or 12
        local dist = (myHRP.Position - kHRP.Position).Magnitude
        if dist <= parryRange then
            DoAutoParry()
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        if p.Character then AttachParrySensor(p.Character) end
        p.CharacterAdded:Connect(function(c) task.wait(0.5) AttachParrySensor(c) end)
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function(c) task.wait(0.5) AttachParrySensor(c) end)
    end
end)

-- ==========================================
-- GLOBAL HELPER FUNCTIONS
-- ==========================================
getgenv().ApplySetting286m = function()
    local speedNormal_286m = 175
    local speedAura_286m = 170

    VeilSettings.MaxTargetDistance = 286
    VeilSettings.CustomSpearSpeed = speedNormal_286m
    VeilSettings.AuraSpearSpeed = speedAura_286m
    VeilSettings.MaxDist = 286
    VeilSettings.SpearSpeed = speedNormal_286m
end

getgenv().ResetDefaultSilentAim = function()
    for key, val in pairs(DefaultVeil) do VeilSettings[key] = val end
    for key, val in pairs(DefaultPistol) do PistolSettings[key] = val end
    pcall(RestoreUI)
    SpearState.target = nil
    SpearState.lookVector = nil
    if SpearVisuals.FOVCircle then SpearVisuals.FOVCircle.Visible = false end
    if SpearVisuals.TrackerCircle then SpearVisuals.TrackerCircle.Visible = false end
    if SpearVisuals.TrackerLine then SpearVisuals.TrackerLine.Visible = false end
end

-- =====================================================
-- POTATO GRAFIK / LOW-END HP MODE
-- =====================================================
-- Fast cooperative optimizer: aggressively lowers rendering cost while
-- yielding frequently enough to prevent sudden gameplay freezes.
getgenv().SilentAimVeilSettings.PotatoMode = (getgenv().SilentAimVeilSettings.PotatoMode == true)

local AREXANS_PerfClock = {}
local function AREXANS_PerfDue(key, interval)
    local now = os.clock()
    local last = AREXANS_PerfClock[key] or 0
    if now - last < interval then return false end
    AREXANS_PerfClock[key] = now
    return true
end

local AREXANS_Potato = {
    Active = false,
    Busy = false,
    RestoreBusy = false,
    Connections = {},
    Changed = {},
    NewObjectQueue = {},
    QueueHead = 1,
}

-- Higher throughput than the old 40-object batch, but capped by time.
local POTATO_BATCH_SIZE = 700
local POTATO_FRAME_BUDGET = 0.0040 -- about 4 ms per work slice
local POTATO_MAX_PER_HEARTBEAT = 900

local function AREXANS_PotatoSave(obj, prop)
    if not AREXANS_Potato.Changed[obj] then
        AREXANS_Potato.Changed[obj] = {}
    end
    if AREXANS_Potato.Changed[obj][prop] == nil then
        local ok, value = pcall(function() return obj[prop] end)
        if ok then AREXANS_Potato.Changed[obj][prop] = value end
    end
end

local function AREXANS_PotatoSet(obj, prop, value)
    if not obj or not obj.Parent then return end
    AREXANS_PotatoSave(obj, prop)
    pcall(function() obj[prop] = value end)
end

local function AREXANS_PotatoOptimize(obj)
    if not AREXANS_Potato.Active or not obj then return end

    if obj:IsA("BasePart") then
        AREXANS_PotatoSet(obj, "CastShadow", false)
        AREXANS_PotatoSet(obj, "Reflectance", 0)
        pcall(function() AREXANS_PotatoSet(obj, "Material", Enum.Material.Plastic) end)
        if obj:IsA("MeshPart") then
            pcall(function()
                AREXANS_PotatoSet(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
            end)
        end
    end

    if obj:IsA("Texture") or obj:IsA("Decal") then
        AREXANS_PotatoSet(obj, "Transparency", 1)
    end

    if obj:IsA("SurfaceAppearance") then
        pcall(function() AREXANS_PotatoSet(obj, "Enabled", false) end)
        pcall(function()
            AREXANS_PotatoSet(obj, "ColorMap", "")
            AREXANS_PotatoSet(obj, "MetalnessMap", "")
            AREXANS_PotatoSet(obj, "NormalMap", "")
            AREXANS_PotatoSet(obj, "RoughnessMap", "")
        end)
    end

    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Smoke")
    or obj:IsA("Fire")
    or obj:IsA("Sparkles") then
        AREXANS_PotatoSet(obj, "Enabled", false)
    end

    if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        AREXANS_PotatoSet(obj, "Enabled", false)
        pcall(function() AREXANS_PotatoSet(obj, "Shadows", false) end)
    end

    if obj:IsA("Atmosphere") then
        AREXANS_PotatoSet(obj, "Density", 0)
        AREXANS_PotatoSet(obj, "Haze", 0)
        AREXANS_PotatoSet(obj, "Glare", 0)
    end

    if obj:IsA("Clouds") then
        AREXANS_PotatoSet(obj, "Cover", 0)
        AREXANS_PotatoSet(obj, "Density", 0)
    end

    if obj:IsA("PostEffect") then
        AREXANS_PotatoSet(obj, "Enabled", false)
    end
end

local function AREXANS_PotatoForceRenderQuality()
    -- Executor-compatible best-effort Roblox render quality clamp.
    -- Not all executors expose settings(), so every write is protected.
    pcall(function()
        local gs = settings()
        local rendering = gs and gs.Rendering
        if rendering then
            AREXANS_PotatoSet(rendering, "QualityLevel", Enum.QualityLevel.Level01)
        end
    end)
    pcall(function()
        local us = UserSettings()
        local gameSettings = us and us.GameSettings
        if gameSettings then
            AREXANS_PotatoSet(gameSettings, "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
        end
    end)
end

local function AREXANS_PotatoDisablePostFX()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("PostEffect") then
            AREXANS_PotatoSet(child, "Enabled", false)
        end
    end
end

local function AREXANS_PotatoLowLighting()
    AREXANS_PotatoSet(Lighting, "GlobalShadows", false)
    AREXANS_PotatoSet(Lighting, "Brightness", 1)
    pcall(function()
        AREXANS_PotatoSet(Lighting, "EnvironmentDiffuseScale", 0)
        AREXANS_PotatoSet(Lighting, "EnvironmentSpecularScale", 0)
    end)
    pcall(function()
        AREXANS_PotatoSet(Lighting, "Technology", Enum.Technology.Compatibility)
    end)

    -- Remove expensive post-processing immediately.
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("PostEffect") or child:IsA("Atmosphere") or child:IsA("Clouds") then
            AREXANS_PotatoOptimize(child)
        end
    end
end

local function AREXANS_PotatoLowTerrain()
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    if not Terrain then return end

    -- Critical for Terrain grass/decorations: disable them immediately.
    AREXANS_PotatoSet(Terrain, "Decoration", false)
    AREXANS_PotatoSet(Terrain, "WaterWaveSize", 0)
    AREXANS_PotatoSet(Terrain, "WaterWaveSpeed", 0)
    AREXANS_PotatoSet(Terrain, "WaterReflectance", 0)
    pcall(function() AREXANS_PotatoSet(Terrain, "WaterTransparency", 1) end)
end

local function AREXANS_PotatoProcessMap()
    if AREXANS_Potato.Busy then return end
    AREXANS_Potato.Busy = true

    local objects = Workspace:GetDescendants()
    local total = #objects
    local index = 1

    while AREXANS_Potato.Active and index <= total do
        local sliceStart = os.clock()
        local processed = 0

        while AREXANS_Potato.Active and index <= total and processed < POTATO_BATCH_SIZE do
            AREXANS_PotatoOptimize(objects[index])
            index += 1
            processed += 1
            if processed >= 20 and os.clock() - sliceStart >= POTATO_FRAME_BUDGET then
                break
            end
        end

        -- Yield every slice so movement/input/rendering stay responsive.
        if AREXANS_Potato.Active then
            RunService.Heartbeat:Wait()
        end
    end

    AREXANS_Potato.Busy = false
end

local function AREXANS_PotatoProcessNewObjects()
    while AREXANS_Potato.Active do
        local sliceStart = os.clock()
        local processed = 0

        while AREXANS_Potato.Active
        and AREXANS_Potato.QueueHead <= #AREXANS_Potato.NewObjectQueue
        and processed < POTATO_BATCH_SIZE do
            local obj = AREXANS_Potato.NewObjectQueue[AREXANS_Potato.QueueHead]
            AREXANS_Potato.NewObjectQueue[AREXANS_Potato.QueueHead] = nil
            AREXANS_Potato.QueueHead += 1
            if obj then AREXANS_PotatoOptimize(obj) end
            processed += 1
            if processed >= 20 and os.clock() - sliceStart >= POTATO_FRAME_BUDGET then
                break
            end
        end

        if AREXANS_Potato.QueueHead > 200
        and AREXANS_Potato.QueueHead > (#AREXANS_Potato.NewObjectQueue / 2) then
            local fresh = {}
            for i = AREXANS_Potato.QueueHead, #AREXANS_Potato.NewObjectQueue do
                fresh[#fresh + 1] = AREXANS_Potato.NewObjectQueue[i]
            end
            AREXANS_Potato.NewObjectQueue = fresh
            AREXANS_Potato.QueueHead = 1
        end

        RunService.Heartbeat:Wait()
    end
end

local function AREXANS_PotatoStartHandler()
    if AREXANS_Potato.Connections.NewObject then return end
    AREXANS_Potato.Connections.NewObject = Workspace.DescendantAdded:Connect(function(obj)
        if AREXANS_Potato.Active then
            AREXANS_Potato.NewObjectQueue[#AREXANS_Potato.NewObjectQueue + 1] = obj
        end
    end)
    AREXANS_Potato.Connections.LightingObject = Lighting.DescendantAdded:Connect(function(obj)
        if AREXANS_Potato.Active then
            task.defer(function()
                if AREXANS_Potato.Active then AREXANS_PotatoOptimize(obj) end
            end)
        end
    end)
end

local function AREXANS_PotatoEnable()
    if AREXANS_Potato.Active then return end
    AREXANS_Potato.Active = true
    getgenv().SilentAimVeilSettings.PotatoMode = true

    -- Global lighting and Terrain grass are changed immediately.
    AREXANS_PotatoLowLighting()
    AREXANS_PotatoLowTerrain()
    AREXANS_PotatoStartHandler()

    -- Map scan is cooperative and runs independently from the new-object queue.
    task.spawn(AREXANS_PotatoProcessMap)
    task.spawn(AREXANS_PotatoProcessNewObjects)
end

local function AREXANS_PotatoDisable()
    if not AREXANS_Potato.Active and next(AREXANS_Potato.Changed) == nil then
        getgenv().SilentAimVeilSettings.PotatoMode = false
        return
    end

    AREXANS_Potato.Active = false
    getgenv().SilentAimVeilSettings.PotatoMode = false

    for name, connection in pairs(AREXANS_Potato.Connections) do
        pcall(function() connection:Disconnect() end)
        AREXANS_Potato.Connections[name] = nil
    end

    if AREXANS_Potato.RestoreBusy then return end
    AREXANS_Potato.RestoreBusy = true

    task.spawn(function()
        local count = 0
        local sliceStart = os.clock()

        for obj, properties in pairs(AREXANS_Potato.Changed) do
            if obj and obj.Parent then
                for prop, value in pairs(properties) do
                    pcall(function() obj[prop] = value end)
                    count += 1
                    if count >= 20 and os.clock() - sliceStart >= POTATO_FRAME_BUDGET then
                        count = 0
                        sliceStart = os.clock()
                        RunService.Heartbeat:Wait()
                    end
                end
            end
        end

        table.clear(AREXANS_Potato.Changed)
        table.clear(AREXANS_Potato.NewObjectQueue)
        AREXANS_Potato.QueueHead = 1
        AREXANS_Potato.RestoreBusy = false
    end)
end

function AREXANS_SetPotatoGrafik(state)
    if state then
        AREXANS_PotatoEnable()
    else
        AREXANS_PotatoDisable()
    end
end

getgenv().SetHideName = function(state)
    VeilSettings.HideName = state
    if state then
        SetupUIListeners()
        sweepExistingUI()
    else
        RestoreUI()
    end
end
    -- Export integration controls used by the main VD UI.
    getgenv().AREXANS_SetPotatoGrafik = AREXANS_SetPotatoGrafik
end
