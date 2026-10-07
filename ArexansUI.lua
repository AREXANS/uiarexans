--[[
    AREXANS UI v1.0
    Asset-ID-less UI Library
    - Downloads PNG assets from the Arexans GitHub repository
    - Converts them to local custom assets through getcustomasset/getsynasset
    - Automatically searches Workspace.Delta for existing Image/Decal assets
    - Never assigns nil to Image
    - Responsive / draggable / mobile friendly
]]

local ArexansUI = {}
ArexansUI.__index = ArexansUI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--// Executor compatibility
local getAsset = getcustomasset or getsynasset
local getHiddenGui = gethui or get_hidden_gui

local function protectGui(gui)
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        end
    end)
end

local function getGuiParent()
    if getHiddenGui then
        local ok, gui = pcall(getHiddenGui)
        if ok and gui then
            return gui
        end
    end
    return CoreGui
end

local function tween(obj, time, props, style, direction)
    local info = TweenInfo.new(
        time or .2,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() obj[k] = v end)
    end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    return new("UICorner", {
        CornerRadius = UDim.new(0, radius or 10)
    }, parent)
end

local function stroke(parent, color, transparency, thickness)
    return new("UIStroke", {
        Color = color or Color3.fromRGB(45, 65, 100),
        Transparency = transparency or .35,
        Thickness = thickness or 1
    }, parent)
end

local function gradient(parent, c1, c2, rotation)
    return new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(1, c2)
        }),
        Rotation = rotation or 0
    }, parent)
end

local function normalizeName(s)
    s = tostring(s or "")
    s = s:gsub("\\", "/")
    s = s:match("([^/]+)$") or s
    s = s:gsub("%.[Pp][Nn][Gg]$", "")
    s = s:gsub("%.[Jj][Pp][Gg]$", "")
    s = s:gsub("%.[Jj][Pp][Ee][Gg]$", "")
    s = s:lower()
    s = s:gsub("[%s_%-]+", "")
    return s
end

local function safeHttp(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and type(result) == "string" and #result > 0 then
        return result
    end
end

--==============================================================
-- ASSET MANAGER
--==============================================================

local Assets = {
    BaseURL = "https://raw.githubusercontent.com/AREXANS/uiarexans/feature/ui-structural-assets-7323372619121539655/asset/",
    APIURL = "https://api.github.com/repos/AREXANS/uiarexans/contents/asset?ref=feature/ui-structural-assets-7323372619121539655",
    Folder = "ArexansUI_Assets",
    Files = {},
    Cache = {},
    Ready = false,
    Loading = false,
}

function Assets:_ensureFolder()
    if not makefolder or not isfolder then
        return false
    end
    if not isfolder(self.Folder) then
        pcall(function() makefolder(self.Folder) end)
    end
    return isfolder(self.Folder)
end

function Assets:_localFile(path)
    return self.Folder .. "/" .. path:gsub("/", "_")
end

function Assets:_register(path)
    local key = normalizeName(path)
    if key ~= "" then
        self.Files[key] = path
    end
end

function Assets:ScanGitHub()
    if self.Ready or self.Loading then return end
    self.Loading = true

    task.spawn(function()
        local function scan(url, depth)
            if depth > 5 then return end

            local body = safeHttp(url)
            if not body then return end

            local ok, list = pcall(function()
                return HttpService:JSONDecode(body)
            end)
            if not ok or type(list) ~= "table" then return end

            for _, item in ipairs(list) do
                if item.type == "file" then
                    local name = tostring(item.name or "")
                    if name:lower():match("%.png$") or
                       name:lower():match("%.jpg$") or
                       name:lower():match("%.jpeg$") or
                       name:lower():match("%.webp$") then
                        self:_register(item.path or name)
                    end
                elseif item.type == "dir" and item.url then
                    scan(item.url, depth + 1)
                end
            end
        end

        scan(self.APIURL, 0)
        self.Ready = true
        self.Loading = false
    end)
end

function Assets:ScanWorkspace()
    local delta = workspace:FindFirstChild("Delta")
    if not delta then return end

    for _, obj in ipairs(delta:GetDescendants()) do
        local n = normalizeName(obj.Name)

        if n ~= "" then
            if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                local image = obj.Image
                if type(image) == "string" and image ~= "" then
                    self.Cache[n] = image
                end
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                local image = obj.Texture
                if type(image) == "string" and image ~= "" then
                    self.Cache[n] = image
                end
            end
        end
    end
end

function Assets:_download(path)
    if not self:_ensureFolder() or not getAsset then
        return nil
    end

    local localPath = self:_localFile(path)

    if not isfile(localPath) then
        local data = safeHttp(self.BaseURL .. path)
        if not data then
            return nil
        end

        local ok = pcall(function()
            writefile(localPath, data)
        end)
        if not ok then
            return nil
        end
    end

    local ok, asset = pcall(function()
        return getAsset(localPath)
    end)

    if ok and type(asset) == "string" and asset ~= "" then
        return asset
    end
end

function Assets:Get(name)
    local key = normalizeName(name)
    if key == "" then return nil end

    if self.Cache[key] then
        return self.Cache[key]
    end

    self:ScanWorkspace()

    if self.Cache[key] then
        return self.Cache[key]
    end

    local path = self.Files[key]

    if not path then
        -- Common filename fallbacks.
        local candidates = {
            key .. ".png",
            tostring(name) .. ".png",
            tostring(name):gsub("%s+", "_") .. ".png",
            tostring(name):gsub("%s+", "-") .. ".png",
        }

        for _, candidate in ipairs(candidates) do
            for registeredKey, registeredPath in pairs(self.Files) do
                if normalizeName(candidate) == registeredKey then
                    path = registeredPath
                    break
                end
            end
            if path then break end
        end
    end

    if path then
        local asset = self:_download(path)
        if asset then
            self.Cache[key] = asset
            return asset
        end
    end

    return nil
end

function Assets:Apply(imageObject, iconName)
    local asset = self:Get(iconName)

    if asset then
        imageObject.Image = asset
        imageObject.Visible = true
        return true
    end

    -- Important: never assign nil to Image.
    imageObject.Image = ""
    imageObject.Visible = false
    return false
end

function Assets:WaitForReady(timeout)
    local start = os.clock()
    self:ScanGitHub()

    while not self.Ready and os.clock() - start < (timeout or 8) do
        task.wait(.05)
    end

    return self.Ready
end

ArexansUI.Assets = Assets

--==============================================================
-- ICON RESOLVER
--==============================================================

local IconAliases = {
    home = {"home", "house", "dashboard"},
    menu = {"menu", "hamburger"},
    settings = {"settings", "setting", "gear", "pengaturan"},
    player = {"player", "user", "users"},
    server = {"server", "servers"},
    teleport = {"teleport", "location", "map-pin", "map"},
    autowalk = {"autowalk", "walk", "walking"},
    shop = {"shop", "store", "cart"},
    search = {"search", "magnifying-glass"},
    notification = {"notification", "notifications", "bell"},
    info = {"info", "circle-info"},
    close = {"close", "x"},
    check = {"check", "done"},
    arrow = {"arrow", "chevron-right"},
    back = {"back", "chevron-left"},
    refresh = {"refresh", "reload"},
    copy = {"copy", "clipboard"},
    link = {"link", "chain"},
    lock = {"lock"},
    unlock = {"unlock"},
    play = {"play"},
    pause = {"pause"},
    stop = {"stop"},
}

function ArexansUI:GetIcon(name)
    if not name then return nil end

    local direct = Assets:Get(name)
    if direct then return direct end

    local aliases = IconAliases[normalizeName(name)]
    if aliases then
        for _, alias in ipairs(aliases) do
            local asset = Assets:Get(alias)
            if asset then return asset end
        end
    end

    return nil
end

function ArexansUI:SetIcon(imageObject, name)
    if not imageObject then return false end
    local asset = self:GetIcon(name)

    if asset then
        imageObject.Image = asset
        imageObject.Visible = true
        return true
    end

    imageObject.Image = ""
    imageObject.Visible = false
    return false
end

--==============================================================
-- WINDOW
--==============================================================

function ArexansUI:CreateWindow(config)
    config = config or {}

    local self = setmetatable({}, ArexansUI)
    self.Name = config.Name or "AREXANS"
    self.Subtitle = config.Subtitle or "AREXANS UI"
    self.Size = config.Size or UDim2.fromOffset(850, 535)
    self.Tabs = {}
    self.ActiveTab = nil
    self.Connections = {}
    self.Destroyed = false

    local theme = {
        Background = Color3.fromRGB(7, 9, 15),
        Panel = Color3.fromRGB(12, 16, 25),
        Panel2 = Color3.fromRGB(17, 22, 34),
        Item = Color3.fromRGB(21, 27, 41),
        ItemHover = Color3.fromRGB(28, 37, 56),
        Text = Color3.fromRGB(245, 248, 255),
        SubText = Color3.fromRGB(150, 163, 185),
        Accent = Color3.fromRGB(30, 145, 255),
        Accent2 = Color3.fromRGB(77, 205, 255),
        Good = Color3.fromRGB(55, 220, 145),
        Danger = Color3.fromRGB(255, 85, 105),
        Stroke = Color3.fromRGB(48, 72, 105),
    }

    self.Theme = theme

    local screen = new("ScreenGui", {
        Name = "ArexansUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    }, getGuiParent())

    protectGui(screen)
    self.ScreenGui = screen

    local scale = new("UIScale", {
        Scale = 1
    }, screen)

    self.UIScale = scale

    -- responsive scale
    local function updateScale()
        local camera = workspace.CurrentCamera
        if not camera then return end

        local viewport = camera.ViewportSize
        local factor = math.min(viewport.X / 1000, viewport.Y / 650)
        factor = math.clamp(factor, .62, 1)
        scale.Scale = factor
    end

    updateScale()

    table.insert(self.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale))

    -- Main shell
    local root = new("Frame", {
        Name = "Root",
        AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .52),
        Size = self.Size,
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = .03,
    }, screen)

    self.Root = root
    corner(root, 18)
    stroke(root, theme.Stroke, .15, 1)

    -- Structural Image Elements
    local windowBackground = new("ImageLabel", {
        Name = "WindowBackground",
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1),
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 1,
    }, root)
    self.WindowBackground = windowBackground
    self:SetIcon(windowBackground, "asset/window/window_frame.png")
    corner(windowBackground, 18)

    local windowFrame = new("ImageLabel", {
        Name = "WindowFrame",
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1),
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 2,
    }, root)
    self.WindowFrame = windowFrame
    self:SetIcon(windowFrame, "asset/window/window_frame.png")
    corner(windowFrame, 18)

    local windowDecoration = new("ImageLabel", {
        Name = "WindowDecoration",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 0, 15),
        Size = UDim2.fromOffset(250, 200),
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 10,
    }, root)
    self.WindowDecoration = windowDecoration
    self:SetIcon(windowDecoration, "asset/window/window_humanoid.png")

    -- Show/hide toggle button
    local toggleUI = new("ImageButton", {
        Name = "ToggleUI",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(20, 20),
        Size = UDim2.fromOffset(46, 46),
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 50,
        Active = true
    }, screen)

    self.ToggleUI = toggleUI
    self:SetIcon(toggleUI, "asset/logo.png")

    toggleUI.MouseButton1Click:Connect(function()
        root.Visible = not root.Visible
    end)

    -- Drag logic for toggleUI
    do
        local btnDragging = false
        local btnDragStart
        local btnStartPos

        toggleUI.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                btnDragging = true
                btnDragStart = input.Position
                btnStartPos = toggleUI.Position
            end
        end)

        table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
            if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - btnDragStart
                toggleUI.Position = UDim2.new(
                    btnStartPos.X.Scale,
                    btnStartPos.X.Offset + delta.X,
                    btnStartPos.Y.Scale,
                    btnStartPos.Y.Offset + delta.Y
                )
            end
        end))

        table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                btnDragging = false
            end
        end))
    end

    -- subtle blue border
    local border = new("Frame", {
        Name = "AccentBorder",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.fromOffset(1, 1),
        ZIndex = 3,
    }, root)
    corner(border, 17)
    stroke(border, theme.Accent, .82, 1)

    -- Header
    local header = new("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 72),
        BackgroundColor3 = Color3.fromRGB(9, 13, 21),
        BackgroundTransparency = .08,
        ZIndex = 5,
    }, root)
    corner(header, 18)

    local headerMask = new("Frame", {
        BackgroundColor3 = Color3.fromRGB(9, 13, 21),
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 35),
        Size = UDim2.new(1, 0, 0, 37),
        ZIndex = 5,
    }, header)

    local logo = new("ImageLabel", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(20, 13),
        Size = UDim2.fromOffset(46, 46),
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 7,
    }, header)

    self:SetIcon(logo, config.Logo or "logo")

    local title = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(78, 10),
        Size = UDim2.new(0, 300, 0, 28),
        Font = Enum.Font.GothamBold,
        Text = self.Name,
        TextColor3 = theme.Text,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
    }, header)

    local subtitle = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(79, 36),
        Size = UDim2.new(0, 350, 0, 18),
        Font = Enum.Font.Gotham,
        Text = self.Subtitle,
        TextColor3 = theme.SubText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
    }, header)

    -- Header buttons
    local minimize = new("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = theme.Item,
        Position = UDim2.new(1, -92, 0, 18),
        Size = UDim2.fromOffset(30, 30),
        Text = "—",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = theme.Text,
        AutoButtonColor = false,
        ZIndex = 8,
    }, header)
    corner(minimize, 9)

    local close = new("TextButton", {
        Name = "Close",
        BackgroundColor3 = theme.Item,
        Position = UDim2.new(1, -52, 0, 18),
        Size = UDim2.fromOffset(30, 30),
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = theme.Text,
        AutoButtonColor = false,
        ZIndex = 8,
    }, header)
    corner(close, 9)

    local minimized = false

    minimize.MouseButton1Click:Connect(function()
        minimized = not minimized

        if minimized then
            tween(root, .25, {
                Size = UDim2.fromOffset(self.Size.X.Offset, 72)
            })
        else
            tween(root, .25, {
                Size = self.Size
            })
        end
    end)

    close.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    -- Drag
    do
        local dragging = false
        local dragStart
        local startPos

        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = root.Position
            end
        end)

        table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                root.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end))

        table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end))
    end

    -- Body
    local body = new("Frame", {
        Name = "Body",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 72),
        Size = UDim2.new(1, 0, 1, -72),
        ZIndex = 4,
    }, root)

    -- Sidebar
    local sidebar = new("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = theme.Panel,
        BackgroundTransparency = .03,
        Position = UDim2.fromOffset(10, 10),
        Size = UDim2.new(0, 190, 1, -20),
        ZIndex = 5,
    }, body)
    corner(sidebar, 14)
    stroke(sidebar, theme.Stroke, .55, 1)

    local tabScroll = new("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(8, 12),
        Size = UDim2.new(1, -16, 1, -24),
        ScrollBarThickness = 2,
        ScrollBarImageTransparency = .5,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ZIndex = 6,
    }, sidebar)

    new("UIListLayout", {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, tabScroll)

    -- Content
    local content = new("Frame", {
        Name = "Content",
        BackgroundColor3 = theme.Panel,
        BackgroundTransparency = .03,
        Position = UDim2.new(0, 210, 0, 10),
        Size = UDim2.new(1, -220, 1, -20),
        ZIndex = 5,
    }, body)
    corner(content, 14)
    stroke(content, theme.Stroke, .55, 1)

    self.Content = content
    self.TabScroll = tabScroll

    local pages = new("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(10, 10),
        Size = UDim2.new(1, -20, 1, -20),
    }, content)

    self.Pages = pages

    -- Welcome splash
    local splash = new("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = true,
    }, pages)

    local splashImage = new("ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .40),
        Size = UDim2.fromOffset(280, 160),
        ScaleType = Enum.ScaleType.Fit,
    }, splash)

    self:SetIcon(splashImage, config.HeroImage or "arexans")

    local splashTitle = new("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .68),
        Size = UDim2.new(1, -30, 0, 38),
        Font = Enum.Font.GothamBold,
        Text = "AREXANS",
        TextColor3 = theme.Text,
        TextSize = 28,
    }, splash)

    local splashSub = new("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .76),
        Size = UDim2.new(1, -60, 0, 40),
        Font = Enum.Font.Gotham,
        Text = "Pilih menu di sebelah kiri untuk mulai.",
        TextColor3 = theme.SubText,
        TextSize = 13,
        TextWrapped = true,
    }, splash)

    self.Splash = splash

    --==========================================================
    -- METHODS
    --==========================================================

    function self:SelectTab(tab)
        for _, t in pairs(self.Tabs) do
            local selected = t == tab

            tween(t.Button, .16, {
                BackgroundColor3 = selected and theme.ItemHover or theme.Panel,
                TextColor3 = selected and theme.Text or theme.SubText
            })

            if t.Indicator then
                tween(t.Indicator, .16, {
                    BackgroundTransparency = selected and 0 or 1
                })
            end

            t.Page.Visible = selected
        end

        self.ActiveTab = tab
        self.Splash.Visible = false
    end

    function self:AddTab(tabConfig)
        tabConfig = tabConfig or {}

        local tab = {
            Name = tabConfig.Name or ("Tab " .. tostring(#self.Tabs + 1)),
            Icon = tabConfig.Icon,
            Components = {},
        }

        local button = new("TextButton", {
            Name = tab.Name,
            BackgroundColor3 = theme.Panel,
            BackgroundTransparency = 0,
            Size = UDim2.new(1, 0, 0, 44),
            Text = "",
            AutoButtonColor = false,
            ZIndex = 7,
        }, tabScroll)
        corner(button, 11)

        local indicator = new("Frame", {
            BackgroundColor3 = theme.Accent,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(4, 8),
            Size = UDim2.fromOffset(3, 28),
            ZIndex = 8,
        }, button)
        corner(indicator, 2)

        local icon = new("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(17, 11),
            Size = UDim2.fromOffset(22, 22),
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 8,
        }, button)
        self:SetIcon(icon, tab.Icon)

        local textLabel = new("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(49, 0),
            Size = UDim2.new(1, -58, 1, 0),
            Font = Enum.Font.GothamSemibold,
            Text = tab.Name,
            TextColor3 = theme.SubText,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 8,
        }, button)

        local page = new("ScrollingFrame", {
            Name = tab.Name .. "_Page",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ScrollBarThickness = 3,
            ScrollBarImageTransparency = .45,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            Visible = false,
        }, pages)

        new("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, page)

        tab.Button = button
        tab.Page = page
        tab.Indicator = indicator
        tab.IconObject = icon

        button.MouseEnter:Connect(function()
            if self.ActiveTab ~= tab then
                tween(button, .12, {BackgroundColor3 = theme.Item})
            end
        end)

        button.MouseLeave:Connect(function()
            if self.ActiveTab ~= tab then
                tween(button, .12, {BackgroundColor3 = theme.Panel})
            end
        end)

        button.MouseButton1Click:Connect(function()
            self:SelectTab(tab)
        end)

        table.insert(self.Tabs, tab)

        --======================================================
        -- Section
        --======================================================
        function tab:AddSection(titleText)
            local section = new("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -2, 0, 32),
            }, page)

            new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(4, 0),
                Size = UDim2.new(1, -8, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = tostring(titleText or "Section"),
                TextColor3 = theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, section)

            return section
        end

        --======================================================
        -- Button
        --======================================================
        function tab:AddButton(options)
            options = options or {}

            local item = new("TextButton", {
                BackgroundColor3 = theme.Item,
                Size = UDim2.new(1, -2, 0, 54),
                Text = "",
                AutoButtonColor = false,
            }, page)
            corner(item, 12)
            stroke(item, theme.Stroke, .75, 1)

            local iconObj = new("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 16),
                Size = UDim2.fromOffset(22, 22),
                ScaleType = Enum.ScaleType.Fit,
            }, item)
            self:SetIcon(iconObj, options.Icon or "arrow")

            new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(48, 7),
                Size = UDim2.new(1, -62, 0, 23),
                Font = Enum.Font.GothamSemibold,
                Text = options.Name or "Button",
                TextColor3 = theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, item)

            if options.Description then
                new("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(48, 29),
                    Size = UDim2.new(1, -62, 0, 17),
                    Font = Enum.Font.Gotham,
                    Text = options.Description,
                    TextColor3 = theme.SubText,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                }, item)
            end

            item.MouseEnter:Connect(function()
                tween(item, .12, {BackgroundColor3 = theme.ItemHover})
            end)

            item.MouseLeave:Connect(function()
                tween(item, .12, {BackgroundColor3 = theme.Item})
            end)

            item.MouseButton1Click:Connect(function()
                tween(item, .07, {Size = UDim2.new(1, -7, 0, 52)})
                task.delay(.08, function()
                    if item.Parent then
                        tween(item, .09, {Size = UDim2.new(1, -2, 0, 54)})
                    end
                end)

                if type(options.Callback) == "function" then
                    task.spawn(options.Callback)
                end
            end)

            return item
        end

        --======================================================
        -- Toggle
        --======================================================
        function tab:AddToggle(options)
            options = options or {}

            local state = options.Default == true

            local item = new("Frame", {
                BackgroundColor3 = theme.Item,
                Size = UDim2.new(1, -2, 0, 58),
            }, page)
            corner(item, 12)
            stroke(item, theme.Stroke, .75, 1)

            new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 7),
                Size = UDim2.new(1, -90, 0, 24),
                Font = Enum.Font.GothamSemibold,
                Text = options.Name or "Toggle",
                TextColor3 = theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, item)

            if options.Description then
                new("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(14, 30),
                    Size = UDim2.new(1, -90, 0, 18),
                    Font = Enum.Font.Gotham,
                    Text = options.Description,
                    TextColor3 = theme.SubText,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, item)
            end

            local toggle = new("TextButton", {
                BackgroundColor3 = state and theme.Accent or Color3.fromRGB(42, 48, 61),
                Position = UDim2.new(1, -61, .5, -12),
                Size = UDim2.fromOffset(46, 24),
                Text = "",
                AutoButtonColor = false,
            }, item)
            corner(toggle, 12)

            local knob = new("Frame", {
                BackgroundColor3 = Color3.fromRGB(245, 248, 255),
                Position = state and UDim2.new(1, -22, .5, -8) or UDim2.new(0, 6, .5, -8),
                Size = UDim2.fromOffset(16, 16),
            }, toggle)
            corner(knob, 8)

            local function setState(value, fire)
                state = value == true
                tween(toggle, .16, {
                    BackgroundColor3 = state and theme.Accent or Color3.fromRGB(42, 48, 61)
                })
                tween(knob, .16, {
                    Position = state and UDim2.new(1, -22, .5, -8) or UDim2.new(0, 6, .5, -8)
                })

                if fire and type(options.Callback) == "function" then
                    task.spawn(options.Callback, state)
                end
            end

            toggle.MouseButton1Click:Connect(function()
                setState(not state, true)
            end)

            local api = {}
            function api:Set(value) setState(value, true) end
            function api:Get() return state end
            api.Instance = item

            return api
        end

        --======================================================
        -- Slider
        --======================================================
        function tab:AddSlider(options)
            options = options or {}

            local min = tonumber(options.Min) or 0
            local max = tonumber(options.Max) or 100
            local value = math.clamp(tonumber(options.Default) or min, min, max)

            local item = new("Frame", {
                BackgroundColor3 = theme.Item,
                Size = UDim2.new(1, -2, 0, 74),
            }, page)
            corner(item, 12)
            stroke(item, theme.Stroke, .75, 1)

            local title = new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 8),
                Size = UDim2.new(1, -90, 0, 22),
                Font = Enum.Font.GothamSemibold,
                Text = options.Name or "Slider",
                TextColor3 = theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, item)

            local valueText = new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -80, 0, 8),
                Size = UDim2.fromOffset(65, 22),
                Font = Enum.Font.GothamBold,
                Text = tostring(value),
                TextColor3 = theme.Accent2,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
            }, item)

            local bar = new("Frame", {
                BackgroundColor3 = Color3.fromRGB(35, 42, 56),
                Position = UDim2.new(0, 14, 1, -26),
                Size = UDim2.new(1, -28, 0, 7),
            }, item)
            corner(bar, 4)

            local fill = new("Frame", {
                BackgroundColor3 = theme.Accent,
                Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0),
            }, bar)
            corner(fill, 4)

            local dragging = false

            local function setValue(v, fire)
                value = math.clamp(v, min, max)
                local alpha = (value - min) / math.max(max - min, 1)
                fill.Size = UDim2.new(alpha, 0, 1, 0)
                valueText.Text = tostring(math.floor(value * 100) / 100)

                if fire and type(options.Callback) == "function" then
                    task.spawn(options.Callback, value)
                end
            end

            local function updateFromX(x)
                local alpha = math.clamp(
                    (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
                    0, 1
                )
                setValue(min + (max - min) * alpha, true)
            end

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or
                   input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateFromX(input.Position.X)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (
                    input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
                ) then
                    updateFromX(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or
                   input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            local api = {}
            function api:Set(v) setValue(tonumber(v) or min, true) end
            function api:Get() return value end
            api.Instance = item

            return api
        end

        --======================================================
        -- Dropdown
        --======================================================
        function tab:AddDropdown(options)
            options = options or {}

            local values = options.Values or {}
            local current = options.Default or values[1]

            local item = new("Frame", {
                BackgroundColor3 = theme.Item,
                Size = UDim2.new(1, -2, 0, 58),
                ClipsDescendants = true,
            }, page)
            corner(item, 12)
            stroke(item, theme.Stroke, .75, 1)

            local button = new("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                AutoButtonColor = false,
            }, item)

            new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 7),
                Size = UDim2.new(1, -170, 0, 20),
                Font = Enum.Font.GothamSemibold,
                Text = options.Name or "Dropdown",
                TextColor3 = theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, button)

            local selected = new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -160, 0, 7),
                Size = UDim2.fromOffset(130, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(current or "Select"),
                TextColor3 = theme.Accent2,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
            }, button)

            local arrow = new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -27, 0, 7),
                Size = UDim2.fromOffset(18, 20),
                Font = Enum.Font.GothamBold,
                Text = "⌄",
                TextColor3 = theme.SubText,
                TextSize = 15,
            }, button)

            local list = new("Frame", {
                BackgroundColor3 = theme.Panel2,
                Position = UDim2.fromOffset(8, 55),
                Size = UDim2.new(1, -16, 0, 0),
                Visible = false,
            }, item)
            corner(list, 10)

            local listLayout = new("UIListLayout", {
                Padding = UDim.new(0, 4),
            }, list)

            local open = false

            local function rebuild()
                for _, child in ipairs(list:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end

                for _, value in ipairs(values) do
                    local option = new("TextButton", {
                        BackgroundColor3 = theme.Item,
                        Size = UDim2.new(1, 0, 0, 34),
                        Text = tostring(value),
                        Font = Enum.Font.Gotham,
                        TextSize = 11,
                        TextColor3 = theme.Text,
                        AutoButtonColor = false,
                    }, list)
                    corner(option, 8)

                    option.MouseEnter:Connect(function()
                        tween(option, .1, {BackgroundColor3 = theme.ItemHover})
                    end)
                    option.MouseLeave:Connect(function()
                        tween(option, .1, {BackgroundColor3 = theme.Item})
                    end)

                    option.MouseButton1Click:Connect(function()
                        current = value
                        selected.Text = tostring(value)
                        open = false
                        list.Visible = false
                        tween(item, .18, {Size = UDim2.new(1, -2, 0, 58)})

                        if type(options.Callback) == "function" then
                            task.spawn(options.Callback, value)
                        end
                    end)
                end
            end

            rebuild()

            button.MouseButton1Click:Connect(function()
                open = not open

                if open then
                    list.Visible = true
                    local count = math.min(#values, 5)
                    local height = count * 38 + 6
                    tween(item, .18, {
                        Size = UDim2.new(1, -2, 0, 58 + height)
                    })
                    tween(list, .18, {
                        Size = UDim2.new(1, -16, 0, height)
                    })
                else
                    tween(item, .18, {Size = UDim2.new(1, -2, 0, 58)})
                    task.delay(.18, function()
                        if not open then list.Visible = false end
                    end)
                end
            end)

            local api = {}
            function api:Set(v)
                current = v
                selected.Text = tostring(v)
                if type(options.Callback) == "function" then
                    task.spawn(options.Callback, v)
                end
            end
            function api:Get() return current end
            api.Instance = item

            return api
        end

        --======================================================
        -- Textbox
        --======================================================
        function tab:AddTextbox(options)
            options = options or {}

            local item = new("Frame", {
                BackgroundColor3 = theme.Item,
                Size = UDim2.new(1, -2, 0, 68),
            }, page)
            corner(item, 12)
            stroke(item, theme.Stroke, .75, 1)

            new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 7),
                Size = UDim2.new(1, -28, 0, 18),
                Font = Enum.Font.GothamSemibold,
                Text = options.Name or "Textbox",
                TextColor3 = theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, item)

            local box = new("TextBox", {
                BackgroundColor3 = Color3.fromRGB(14, 19, 29),
                Position = UDim2.fromOffset(12, 31),
                Size = UDim2.new(1, -24, 0, 28),
                Text = options.Default or "",
                PlaceholderText = options.Placeholder or "Ketik di sini...",
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextColor3 = theme.Text,
                PlaceholderColor3 = theme.SubText,
                ClearTextOnFocus = false,
            }, item)
            corner(box, 8)
            stroke(box, theme.Stroke, .6, 1)

            box.FocusLost:Connect(function(enter)
                if type(options.Callback) == "function" then
                    task.spawn(options.Callback, box.Text, enter)
                end
            end)

            return {
                Instance = item,
                Textbox = box,
                Set = function(_, text) box.Text = tostring(text or "") end,
                Get = function() return box.Text end
            }
        end

        --======================================================
        -- Label
        --======================================================
        function tab:AddLabel(text)
            local label = new("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -2, 0, 28),
                Font = Enum.Font.Gotham,
                Text = tostring(text or ""),
                TextColor3 = theme.SubText,
                TextSize = 11,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, page)

            return label
        end

        --======================================================
        -- Notification
        --======================================================
        function self:Notify(options)
            options = options or {}

            local holder = screen:FindFirstChild("Notifications")
            if not holder then
                holder = new("Frame", {
                    Name = "Notifications",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.new(1, -18, 1, -18),
                    Size = UDim2.fromOffset(340, 400),
                    ZIndex = 100,
                }, screen)

                new("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Bottom,
                }, holder)
            end

            local note = new("Frame", {
                BackgroundColor3 = theme.Panel2,
                Size = UDim2.fromOffset(320, 70),
                BackgroundTransparency = .02,
                ZIndex = 101,
            }, holder)
            corner(note, 12)
            stroke(note, theme.Accent, .55, 1)

            local bar = new("Frame", {
                BackgroundColor3 = theme.Accent,
                Size = UDim2.fromOffset(3, 48),
                Position = UDim2.fromOffset(8, 11),
                ZIndex = 102,
            }, note)
            corner(bar, 2)

            local icon = new("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(20, 17),
                Size = UDim2.fromOffset(30, 30),
                ScaleType = Enum.ScaleType.Fit,
                ZIndex = 102,
            }, note)
            self:SetIcon(icon, options.Icon or "notification")

            new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(60, 10),
                Size = UDim2.new(1, -72, 0, 22),
                Font = Enum.Font.GothamBold,
                Text = options.Title or "AREXANS",
                TextColor3 = theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 102,
            }, note)

            new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(60, 31),
                Size = UDim2.new(1, -72, 0, 30),
                Font = Enum.Font.Gotham,
                Text = options.Content or "",
                TextColor3 = theme.SubText,
                TextSize = 10,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 102,
            }, note)

            note.Position = UDim2.new(1, 30, 0, 0)
            tween(note, .25, {Position = UDim2.new(0, 0, 0, 0)})

            task.delay(tonumber(options.Duration) or 4, function()
                if note.Parent then
                    tween(note, .22, {
                        Position = UDim2.new(1, 30, 0, 0),
                        BackgroundTransparency = 1
                    })
                    task.wait(.25)
                    note:Destroy()
                end
            end)
        end

        return tab
    end

    function self:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true

        for _, conn in ipairs(self.Connections) do
            pcall(function() conn:Disconnect() end)
        end

        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end
    end

    -- Load assets in background. UI itself appears immediately.
    task.spawn(function()
        Assets:ScanWorkspace()
        Assets:ScanGitHub()
        Assets:WaitForReady(10)

        -- Refresh common icons after manifest is ready.
        pcall(function()
            self:SetIcon(logo, config.Logo or "logo")
            self:SetIcon(splashImage, config.HeroImage or "arexans")

            if self.ToggleUI then
                self:SetIcon(self.ToggleUI, "asset/logo.png")
            end
            if self.WindowBackground then
                self:SetIcon(self.WindowBackground, "asset/window/window_frame.png")
            end
            if self.WindowFrame then
                self:SetIcon(self.WindowFrame, "asset/window/window_frame.png")
            end
            if self.WindowDecoration then
                self:SetIcon(self.WindowDecoration, "asset/window/window_humanoid.png")
            end
        end)
    end)

    return self
end

-- Start background asset discovery even before CreateWindow.
task.spawn(function()
    pcall(function()
        Assets:ScanWorkspace()
        Assets:ScanGitHub()
    end)
end)

return ArexansUI
