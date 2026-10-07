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
    BaseURL = "https://raw.githubusercontent.com/AREXANS/uiarexans/main/asset/",
    APIURL = "https://api.github.com/repos/AREXANS/uiarexans/contents/asset?ref=main",
    Folder = "ArexansUI_Assets",
    Files = {},
    Cache = {},
    Ready = false,
    Loading = false,
    -- Hardcoded asset list to bypass GitHub API rate limits
    AssetList = {
        "button.png", "button_hover.png",
        "containers/badge.png", "containers/card.png", "containers/card_selected.png",
        "containers/divider.png", "containers/panel.png", "containers/panel_header.png",
        "containers/section.png", "containers/section_header.png", "containers/separator.png",
        "containers/tooltip.png", "controls/checkbox_hover.png", "controls/checkbox_off.png",
        "controls/checkbox_on.png", "controls/progress_bar.png", "controls/progress_fill.png",
        "controls/radio_hover.png", "controls/radio_off.png", "controls/radio_on.png",
        "controls/slider_active.png", "controls/slider_fill.png", "controls/slider_knob.png",
        "controls/slider_normal.png", "controls/slider_track.png", "controls/stepper_minus.png",
        "controls/stepper_plus.png", "dark_compact_left.png", "decorative/bottom_decor.png",
        "decorative/corner_decor.png", "decorative/energy_corner.png", "decorative/energy_line.png",
        "decorative/glow_dot.png", "decorative/glow_line.png", "decorative/particle_blue.png",
        "decorative/particle_gold.png", "decorative/side_decor.png", "decorative/spark_large.png",
        "decorative/spark_medium.png", "decorative/spark_small.png", "decorative/top_decor.png",
        "dropdown_after.png", "dropdown_before.png", "dropdown_selected_bg.png",
        "electric_compact_left.png", "frame_profile.png", "hue_gradient.png",
        "icons/add_circle.png", "icons/autowalk.png", "icons/battery_energy.png",
        "icons/calendar_clock.png", "icons/calendar_energy.png", "icons/camera_energy.png",
        "icons/chat_energy.png", "icons/checklist_energy.png", "icons/clean_broom.png",
        "icons/clock.png", "icons/cloud_energy.png", "icons/coin_star.png", "icons/cold_shield.png",
        "icons/compass.png", "icons/crown.png", "icons/database_energy.png", "icons/delete_energy.png",
        "icons/document_check.png", "icons/documents_energy.png", "icons/download.png",
        "icons/edit_pen.png", "icons/energy_shield.png", "icons/fast_forward.png",
        "icons/file_add.png", "icons/file_cancel.png", "icons/file_check.png",
        "icons/file_download.png", "icons/file_energy.png", "icons/file_upload.png",
        "icons/filter_sliders.png", "icons/fire.png", "icons/folder_download.png",
        "icons/folder_energy.png", "icons/folder_favorite.png", "icons/folder_minus.png",
        "icons/folder_upload.png", "icons/gamepad.png", "icons/gift.png", "icons/globe_ring.png",
        "icons/group_add.png", "icons/hand_heart.png", "icons/heart_energy.png",
        "icons/home_energy.png", "icons/leaf.png", "icons/lightbulb.png", "icons/link_broken.png",
        "icons/location_pin.png", "icons/lock_energy.png", "icons/map.png", "icons/map_pin.png",
        "icons/medal_star.png", "icons/microphone.png", "icons/moon_stars.png",
        "icons/mountain_flag.png", "icons/mute.png", "icons/notification_bell.png",
        "icons/pause.png", "icons/planet_ring.png", "icons/potion.png", "icons/refresh.png",
        "icons/remove_circle.png", "icons/rewind.png", "icons/rocket.png", "icons/scroll_star.png",
        "icons/search.png", "icons/search_glow.png", "icons/security_shield.png", "icons/send.png",
        "icons/server_global.png", "icons/settings.png", "icons/settings_energy.png",
        "icons/share.png", "icons/shield_star.png", "icons/shield_star_wings.png",
        "icons/star_energy.png", "icons/stop.png", "icons/sun.png", "icons/sync.png",
        "icons/target.png", "icons/target_add.png", "icons/teleport_portal.png",
        "icons/ticket_star.png", "icons/trophy.png", "icons/unlink.png", "icons/unlock_energy.png",
        "icons/upload.png", "icons/user_add.png", "icons/user_crown.png", "icons/user_group.png",
        "icons/user_shield_add.png", "icons/video_energy.png", "icons/visibility_eye.png",
        "icons/volume.png", "icons/warning.png", "icons/water_drop.png", "icons/wifi.png",
        "icons/wind.png", "loading/loading_bar.png", "loading/loading_ring.png",
        "loading/loading_spinner.png", "loading/skeleton.png", "loading/skeleton_box.png",
        "loading/skeleton_text.png", "logo.png", "navigation/sidebar_separator.png",
        "navigation/tab_disabled.png", "navigation/tab_selected.png",
        "navigation/utility_button_active_left.png", "navigation/utility_button_normal_blue.png",
        "navigation/utility_button_normal_left.png", "notification/notification_error.png",
        "notification/notification_info.png", "notification/notification_progress.png",
        "notification/notification_success.png", "notification/notification_warning.png",
        "notification/panel_container.png", "notification/tab_shape_01.png",
        "notification/tab_shape_02.png", "notification/tab_shape_03.png",
        "notification/tab_shape_04.png", "notification/toast_background.png", "off.png", "on.png",
        "player/avatar_away.png", "player/avatar_frame.png", "player/avatar_offline.png",
        "player/avatar_online.png", "player/player_card.png", "player/player_card_selected.png",
        "player/rank_badge.png", "player/server_card.png", "player/server_card_selected.png",
        "popup/confirm_dialog.png", "popup/context_menu.png", "popup/dialog_frame.png",
        "popup/menu_item.png", "popup/menu_item_hover.png", "popup/modal_background.png",
        "saturation_value_gradient.png", "scroll/scrollbar_arrow_down.png",
        "scroll/scrollbar_arrow_up.png", "scroll/scrollbar_thumb.png",
        "scroll/scrollbar_thumb_hover.png", "scroll/scrollbar_track.png", "search.png",
        "window/close_button.png", "window/collapse_button.png", "window/expand_button.png",
        "window/maximize_button.png", "window/minimize_button.png", "window/restore_button.png",
        "window/window_background.png", "window/window_frame.png", "window/window_humanoid.png",
        "window/window_humanoid_sleep.png"
    }
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
        -- Direct iteration bypasses API rate limits
        for _, path in ipairs(self.AssetList) do
            self:_register(path)
        end

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

    -- Main shell background image
    local root = new("ImageLabel", {
        Name = "Root",
        AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(512, 241),
        BackgroundTransparency = 1,
        ZIndex = 1,
    }, screen)

    self:SetIcon(root, "window/window_background.png")
    self.Root = root

    -- Window Frame (borders and header shape) overlaying the background
    local windowFrame = new("ImageLabel", {
        Name = "WindowFrame",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(-2, -10),
        Size = UDim2.fromOffset(557, 299),
        ZIndex = 10,
    }, root)
    self:SetIcon(windowFrame, "window/window_frame.png")

    -- Window Humanoid (decorative sleeping robot overlay)
    local humanoidOverlay = new("ImageLabel", {
        Name = "WindowHumanoid",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(-2, -144),
        Size = UDim2.fromOffset(618, 149),
        ZIndex = 11,
    }, root)
    self:SetIcon(humanoidOverlay, "window/window_humanoid.png")

    -- Drag handle header area (invisible, for grabbing)
    local header = new("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        ZIndex = 12,
    }, root)

    -- Custom title text placed precisely
    local title = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(30, 8),
        Size = UDim2.new(0, 300, 0, 28),
        Font = Enum.Font.GothamBold,
        Text = self.Name,
        TextColor3 = theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13,
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

        local function begin(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
               input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            dragging = true
            dragStart = input.Position
            startPos = root.Position

            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if conn then conn:Disconnect() end
                end
            end)
        end

        local function move(input)
            if not dragging then return end

            local delta = input.Position - dragStart
            root.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        header.InputBegan:Connect(begin)
        header.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or
               input.UserInputType == Enum.UserInputType.Touch then
                table.insert(self.Connections, input.Changed:Connect(function()
                    move(input)
                end))
            end
        end)
    end

    -- Body container overlaid precisely inside the background texture bounds
    local body = new("Frame", {
        Name = "Body",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(25, 45),
        Size = UDim2.new(1, -50, 1, -55),
        ZIndex = 2,
    }, root)

    -- Sidebar for Tabs (invisible layout wrapper)
    local tabScroll = new("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, 126, 1, 0),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ZIndex = 3,
    }, body)

    new("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, tabScroll)

    -- Content for pages
    local content = new("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 140, 0, 0),
        Size = UDim2.new(1, -140, 1, 0),
        ZIndex = 2,
    }, body)

    self.Content = content
    self.TabScroll = tabScroll
    self.Pages = content

    --==========================================================
    -- METHODS
    --==========================================================

    function self:SelectTab(tab)
        for _, t in pairs(self.Tabs) do
            local selected = t == tab

            if selected then
                self:SetIcon(t.Button, "navigation/tab_selected.png")
            else
                self:SetIcon(t.Button, "navigation/tab_disabled.png")
            end

            t.Page.Visible = selected
        end

        self.ActiveTab = tab
    end

    function self:AddTab(tabConfig)
        tabConfig = tabConfig or {}

        local tab = {
            Name = tabConfig.Name or ("Tab " .. tostring(#self.Tabs + 1)),
            Icon = tabConfig.Icon,
            Components = {},
        }

        local button = new("ImageButton", {
            Name = tab.Name,
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(126, 42),
            AutoButtonColor = false,
            ZIndex = 7,
        }, tabScroll)
        self:SetIcon(button, "navigation/tab_disabled.png")

        local icon = new("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(17, 10),
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
        tab.IconObject = icon

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

            local item = new("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(342, 50),
            }, page)
            self:SetIcon(item, state and "electric_compact_left.png" or "dark_compact_left.png")

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

            local toggleBtn = new("ImageButton", {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -61, 0.5, -12),
                Size = UDim2.fromOffset(44, 23),
            }, item)
            self:SetIcon(toggleBtn, state and "on.png" or "off.png")

            local function setState(value, fire)
                state = value == true
                self:SetIcon(toggleBtn, state and "on.png" or "off.png")
                self:SetIcon(item, state and "electric_compact_left.png" or "dark_compact_left.png")

                if fire and type(options.Callback) == "function" then
                    task.spawn(options.Callback, state)
                end
            end

            toggleBtn.MouseButton1Click:Connect(function()
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
