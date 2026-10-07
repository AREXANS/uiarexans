-- ==============================================================================
-- AREXANS UI LIBRARY - ULTRA PRECISE ALIGNMENT
-- ==============================================================================
local ArexansUI = {}

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local BaseURL = "https://raw.githubusercontent.com/AREXANS/uiarexans/main/asset/"
local FolderName = "ArexansUI_Assets"

if not isfolder(FolderName) then
    makefolder(FolderName)
end

-- Hardcoded asset list to bypass GitHub API rate limits
local AssetList = {
    "button.png",
    "button_hover.png",
    "containers/badge.png",
    "containers/card.png",
    "containers/card_selected.png",
    "containers/divider.png",
    "containers/panel.png",
    "containers/panel_header.png",
    "containers/section.png",
    "containers/section_header.png",
    "containers/separator.png",
    "containers/tooltip.png",
    "controls/checkbox_hover.png",
    "controls/checkbox_off.png",
    "controls/checkbox_on.png",
    "controls/progress_bar.png",
    "controls/progress_fill.png",
    "controls/radio_hover.png",
    "controls/radio_off.png",
    "controls/radio_on.png",
    "controls/slider_active.png",
    "controls/slider_fill.png",
    "controls/slider_knob.png",
    "controls/slider_normal.png",
    "controls/slider_track.png",
    "controls/stepper_minus.png",
    "controls/stepper_plus.png",
    "dark_compact_left.png",
    "decorative/bottom_decor.png",
    "decorative/corner_decor.png",
    "decorative/energy_corner.png",
    "decorative/energy_line.png",
    "decorative/glow_dot.png",
    "decorative/glow_line.png",
    "decorative/particle_blue.png",
    "decorative/particle_gold.png",
    "decorative/side_decor.png",
    "decorative/spark_large.png",
    "decorative/spark_medium.png",
    "decorative/spark_small.png",
    "decorative/top_decor.png",
    "dropdown_after.png",
    "dropdown_before.png",
    "dropdown_selected_bg.png",
    "electric_compact_left.png",
    "frame_profile.png",
    "hue_gradient.png",
    "icons/add_circle.png",
    "icons/autowalk.png",
    "icons/battery_energy.png",
    "icons/calendar_clock.png",
    "icons/calendar_energy.png",
    "icons/camera_energy.png",
    "icons/chat_energy.png",
    "icons/checklist_energy.png",
    "icons/clean_broom.png",
    "icons/clock.png",
    "icons/cloud_energy.png",
    "icons/coin_star.png",
    "icons/cold_shield.png",
    "icons/compass.png",
    "icons/crown.png",
    "icons/database_energy.png",
    "icons/delete_energy.png",
    "icons/document_check.png",
    "icons/documents_energy.png",
    "icons/download.png",
    "icons/edit_pen.png",
    "icons/energy_shield.png",
    "icons/fast_forward.png",
    "icons/file_add.png",
    "icons/file_cancel.png",
    "icons/file_check.png",
    "icons/file_download.png",
    "icons/file_energy.png",
    "icons/file_upload.png",
    "icons/filter_sliders.png",
    "icons/fire.png",
    "icons/folder_download.png",
    "icons/folder_energy.png",
    "icons/folder_favorite.png",
    "icons/folder_minus.png",
    "icons/folder_upload.png",
    "icons/gamepad.png",
    "icons/gift.png",
    "icons/globe_ring.png",
    "icons/group_add.png",
    "icons/hand_heart.png",
    "icons/heart_energy.png",
    "icons/home_energy.png",
    "icons/leaf.png",
    "icons/lightbulb.png",
    "icons/link_broken.png",
    "icons/location_pin.png",
    "icons/lock_energy.png",
    "icons/map.png",
    "icons/map_pin.png",
    "icons/medal_star.png",
    "icons/microphone.png",
    "icons/moon_stars.png",
    "icons/mountain_flag.png",
    "icons/mute.png",
    "icons/notification_bell.png",
    "icons/pause.png",
    "icons/planet_ring.png",
    "icons/potion.png",
    "icons/refresh.png",
    "icons/remove_circle.png",
    "icons/rewind.png",
    "icons/rocket.png",
    "icons/scroll_star.png",
    "icons/search.png",
    "icons/search_glow.png",
    "icons/security_shield.png",
    "icons/send.png",
    "icons/server_global.png",
    "icons/settings.png",
    "icons/settings_energy.png",
    "icons/share.png",
    "icons/shield_star.png",
    "icons/shield_star_wings.png",
    "icons/star_energy.png",
    "icons/stop.png",
    "icons/sun.png",
    "icons/sync.png",
    "icons/target.png",
    "icons/target_add.png",
    "icons/teleport_portal.png",
    "icons/ticket_star.png",
    "icons/trophy.png",
    "icons/unlink.png",
    "icons/unlock_energy.png",
    "icons/upload.png",
    "icons/user_add.png",
    "icons/user_crown.png",
    "icons/user_group.png",
    "icons/user_shield_add.png",
    "icons/video_energy.png",
    "icons/visibility_eye.png",
    "icons/volume.png",
    "icons/warning.png",
    "icons/water_drop.png",
    "icons/wifi.png",
    "icons/wind.png",
    "loading/loading_bar.png",
    "loading/loading_ring.png",
    "loading/loading_spinner.png",
    "loading/skeleton.png",
    "loading/skeleton_box.png",
    "loading/skeleton_text.png",
    "logo.png",
    "navigation/sidebar_separator.png",
    "navigation/tab_disabled.png",
    "navigation/tab_selected.png",
    "navigation/utility_button_active_left.png",
    "navigation/utility_button_normal_blue.png",
    "navigation/utility_button_normal_left.png",
    "notification/notification_error.png",
    "notification/notification_info.png",
    "notification/notification_progress.png",
    "notification/notification_success.png",
    "notification/notification_warning.png",
    "notification/panel_container.png",
    "notification/tab_shape_01.png",
    "notification/tab_shape_02.png",
    "notification/tab_shape_03.png",
    "notification/tab_shape_04.png",
    "notification/toast_background.png",
    "off.png",
    "on.png",
    "player/avatar_away.png",
    "player/avatar_frame.png",
    "player/avatar_offline.png",
    "player/avatar_online.png",
    "player/player_card.png",
    "player/player_card_selected.png",
    "player/rank_badge.png",
    "player/server_card.png",
    "player/server_card_selected.png",
    "popup/confirm_dialog.png",
    "popup/context_menu.png",
    "popup/dialog_frame.png",
    "popup/menu_item.png",
    "popup/menu_item_hover.png",
    "popup/modal_background.png",
    "saturation_value_gradient.png",
    "scroll/scrollbar_arrow_down.png",
    "scroll/scrollbar_arrow_up.png",
    "scroll/scrollbar_thumb.png",
    "scroll/scrollbar_thumb_hover.png",
    "scroll/scrollbar_track.png",
    "search.png",
    "window/close_button.png",
    "window/collapse_button.png",
    "window/expand_button.png",
    "window/maximize_button.png",
    "window/minimize_button.png",
    "window/restore_button.png",
    "window/window_background.png",
    "window/window_frame.png",
    "window/window_humanoid.png",
    "window/window_humanoid_sleep.png",
}

local function GetLocalAsset(path)
    local getAsset = getcustomasset or getsynasset
    local normalizedPath = string.gsub(path, "/", "_")
    local localPath = FolderName .. "/" .. normalizedPath

    if isfile and isfile(localPath) and getAsset then
        return getAsset(localPath)
    end

    -- Fallback for testing environments / downloading on the fly
    if writefile and getAsset and isfile then
        local success, data = pcall(function()
            return game:HttpGet(BaseURL .. path)
        end)
        if success and data and #data > 0 then
            pcall(function()
                writefile(localPath, data)
            end)
            if isfile(localPath) then
                return getAsset(localPath)
            end
        end
    end

    return "rbxasset://" .. localPath
end

-- Prefetch assets in background
task.spawn(function()
    if isfile and writefile then
        for _, path in ipairs(AssetList) do
            local normalizedPath = string.gsub(path, "/", "_")
            local localPath = FolderName .. "/" .. normalizedPath
            if not isfile(localPath) then
                pcall(function()
                    local data = game:HttpGet(BaseURL .. path)
                    if data and #data > 0 then
                        writefile(localPath, data)
                    end
                end)
            end
        end
    end
end)


function ArexansUI:CreateWindow(WindowName)
    local WindowData = {}

    -- 1. Setup Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ArexansInteractiveUI"
    local getHiddenGui = gethui or get_hidden_gui
    local guiParent = CoreGui
    if getHiddenGui then
        local ok, gui = pcall(getHiddenGui)
        if ok and gui then guiParent = gui end
    end
    ScreenGui.Parent = guiParent
    ScreenGui.ResetOnSpawn = false

    -- Bersihkan UI lama
    for _, gui in pairs(ScreenGui.Parent:GetChildren()) do
        if gui.Name == "ArexansInteractiveUI" and gui ~= ScreenGui then
            gui:Destroy()
        end
    end

    -- 2. Toggle On/Off Logo Button
    local OpenCloseButton = Instance.new("ImageButton")
    OpenCloseButton.Name = "OpenCloseLogo"
    OpenCloseButton.Image = GetLocalAsset("logo.png")
    OpenCloseButton.BackgroundTransparency = 1
    OpenCloseButton.Position = UDim2.new(0, 20, 0, 20)
    OpenCloseButton.Size = UDim2.new(0, 60, 0, 60)
    OpenCloseButton.ZIndex = 100
    OpenCloseButton.Parent = ScreenGui

    -- Graceful fallback for logo
    local fallbackLogoCorner = Instance.new("UICorner")
    fallbackLogoCorner.CornerRadius = UDim.new(1, 0)
    fallbackLogoCorner.Parent = OpenCloseButton
    OpenCloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OpenCloseButton.BackgroundTransparency = 0.5 -- Allows image to dominate when loaded

    -- 3. Window Container Utama
    local windowbackground = Instance.new("ImageLabel")
    windowbackground.Name = "window_background"
    windowbackground.Image = GetLocalAsset("window/window_background.png")
    windowbackground.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Fallback
    windowbackground.BackgroundTransparency = 0
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 8)
    windowCorner.Parent = windowbackground

    windowbackground.Position = UDim2.new(0.5, 0, 0.5, 0)
    windowbackground.Size = UDim2.new(0, 512, 0, 241)
    windowbackground.AnchorPoint = Vector2.new(0.5, 0.5)
    windowbackground.ZIndex = 1
    windowbackground.Active = true
    windowbackground.Parent = ScreenGui

    OpenCloseButton.MouseButton1Click:Connect(function()
        windowbackground.Visible = not windowbackground.Visible
    end)

    -- 4. Custom Dragging Area
    local DragHandle = Instance.new("Frame")
    DragHandle.Name = "DragHandle"
    DragHandle.BackgroundTransparency = 1
    DragHandle.Position = UDim2.new(0.5, -80, 0, -45)
    DragHandle.Size = UDim2.new(0, 160, 0, 50)
    DragHandle.ZIndex = 60
    DragHandle.Active = true
    DragHandle.Parent = windowbackground

    -- Fix dragging leak using properly separated event bindings
    local dragging = false
    local dragStart, startPos

    DragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = windowbackground.Position
        end
    end)

    DragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            windowbackground.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- ==============================================================================
    -- PERBAIKAN KOORDINAT PRESISI KOTAK KIRI & KANAN
    -- ==============================================================================

    -- KOTAK TABS (Kiri)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 36, 0, 68)
    TabContainer.Size = UDim2.new(0, 122, 0, 122)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 0
    TabContainer.ClipsDescendants = true
    TabContainer.ZIndex = 5
    TabContainer.Parent = windowbackground

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Parent = TabContainer

    -- Manually update CanvasSize instead of AutomaticCanvasSize (memory guideline)
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
    end)

    -- KOTAK TOGGLES (Kanan)
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.BackgroundTransparency = 1
    PageContainer.Position = UDim2.new(0, 168, 0, 68)
    PageContainer.Size = UDim2.new(0, 305, 0, 122)
    PageContainer.ClipsDescendants = true
    PageContainer.ZIndex = 5
    PageContainer.Parent = windowbackground

    -- ==============================================================================
    -- BINGKAI SELALU DI DEPAN (ZIndex 50 & 51)
    -- ==============================================================================
    local windowframe = Instance.new("ImageLabel")
    windowframe.Name = "window_frame"
    windowframe.Image = GetLocalAsset("window/window_frame.png")
    windowframe.BackgroundTransparency = 1
    windowframe.Position = UDim2.new(0.5, 0, 0.5, -4)
    windowframe.Size = UDim2.new(0, 557, 0, 299)
    windowframe.AnchorPoint = Vector2.new(0.5, 0.5)
    windowframe.ZIndex = 50
    windowframe.Active = false
    windowframe.Parent = windowbackground

    local windowhumanoid = Instance.new("ImageLabel")
    windowhumanoid.Name = "window_humanoid"
    windowhumanoid.Image = GetLocalAsset("window/window_humanoid.png")
    windowhumanoid.BackgroundTransparency = 1
    windowhumanoid.Position = UDim2.new(0.5, 0, 0.5, -135)
    windowhumanoid.Size = UDim2.new(0, 618, 0, 149)
    windowhumanoid.AnchorPoint = Vector2.new(0.5, 0.5)
    windowhumanoid.ZIndex = 51
    windowhumanoid.Active = false
    windowhumanoid.Parent = windowbackground
    -- ==============================================================================

    local Tabs = {}
    local Pages = {}
    local FirstTab = true

    function WindowData:CreateTab(TabName)
        local TabData = {}

        -- Tombol Tab
        local TabButton = Instance.new("ImageButton")
        TabButton.Name = TabName .. "_Tab"
        TabButton.Image = GetLocalAsset("navigation/tab_disabled.png")
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Fallback
        TabButton.BackgroundTransparency = 0 -- Fallback support
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = TabButton

        TabButton.Size = UDim2.new(1, -4, 0, 34)
        TabButton.ZIndex = 10
        TabButton.Parent = TabContainer

        local TabText = Instance.new("TextLabel")
        TabText.BackgroundTransparency = 1
        TabText.Size = UDim2.new(1, 0, 1, 0)
        TabText.Font = Enum.Font.GothamBold
        TabText.Text = TabName
        TabText.TextColor3 = Color3.fromRGB(180, 180, 220)
        TabText.TextSize = 12
        TabText.ZIndex = 11
        TabText.Parent = TabButton

        -- Area Halaman (Scroll untuk Toggle)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName .. "_Page"
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 0
        Page.Visible = FirstTab
        Page.ClipsDescendants = false
        Page.ZIndex = 10
        Page.Parent = PageContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 4)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.Parent = Page

        -- Fix AutomaticCanvasSize memory guideline
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y)
        end)

        if FirstTab then
            TabButton.Image = GetLocalAsset("navigation/tab_selected.png")
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Fallback selected
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            FirstTab = false
        end

        table.insert(Tabs, TabButton)
        table.insert(Pages, Page)

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Image = GetLocalAsset("navigation/tab_disabled.png")
                tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                tab:FindFirstChild("TextLabel").TextColor3 = Color3.fromRGB(180, 180, 220)
            end
            for _, page in pairs(Pages) do
                page.Visible = false
            end
            TabButton.Image = GetLocalAsset("navigation/tab_selected.png")
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            Page.Visible = true
        end)

        function TabData:CreateToggle(ToggleName, Default, Callback)
            local State = Default or false
            Callback = Callback or function() end

            -- Background Toggle
            local ToggleBg = Instance.new("ImageButton")
            ToggleBg.Name = ToggleName .. "_Toggle"
            ToggleBg.Image = State and GetLocalAsset("electric_compact_left.png") or GetLocalAsset("dark_compact_left.png")
            ToggleBg.BackgroundColor3 = State and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(30, 30, 30) -- Fallback
            ToggleBg.BackgroundTransparency = 0
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 6)
            toggleCorner.Parent = ToggleBg

            ToggleBg.Size = UDim2.new(1, -10, 0, 36)
            ToggleBg.ZIndex = 10
            ToggleBg.Parent = Page

            -- Teks Toggle
            local ToggleText = Instance.new("TextLabel")
            ToggleText.BackgroundTransparency = 1
            ToggleText.Position = UDim2.new(0, 20, 0, 0)
            ToggleText.Size = UDim2.new(0.6, 0, 1, 0)
            ToggleText.Font = Enum.Font.GothamBold
            ToggleText.Text = ToggleName
            ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left
            ToggleText.TextSize = 12
            ToggleText.ZIndex = 11
            ToggleText.Parent = ToggleBg

            -- Indikator On/Off Knob
            local ToggleKnob = Instance.new("ImageLabel")
            ToggleKnob.Name = "Knob"
            ToggleKnob.Image = State and GetLocalAsset("on.png") or GetLocalAsset("off.png")
            ToggleKnob.BackgroundColor3 = State and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150) -- Fallback
            ToggleKnob.BackgroundTransparency = 0
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = ToggleKnob

            ToggleKnob.AnchorPoint = Vector2.new(1, 0.5)
            ToggleKnob.Position = UDim2.new(1, -10, 0.5, 0)
            ToggleKnob.Size = State and UDim2.new(0, 32, 0, 16) or UDim2.new(0, 34, 0, 18)
            ToggleKnob.ZIndex = 11
            ToggleKnob.Parent = ToggleBg

            local function UpdateState(isInit)
                if not isInit then State = not State end
                if State then
                    ToggleBg.Image = GetLocalAsset("electric_compact_left.png")
                    ToggleBg.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                    ToggleKnob.Image = GetLocalAsset("on.png")
                    ToggleKnob.Size = UDim2.new(0, 32, 0, 16)
                    ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                else
                    ToggleBg.Image = GetLocalAsset("dark_compact_left.png")
                    ToggleBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    ToggleKnob.Image = GetLocalAsset("off.png")
                    ToggleKnob.Size = UDim2.new(0, 34, 0, 18)
                    ToggleKnob.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                end
                if not isInit then
                    Callback(State)
                end
            end

            ToggleBg.MouseButton1Click:Connect(function()
                UpdateState(false)
            end)

            if State then Callback(State) end
        end

        return TabData
    end

    function WindowData:Notify(options)
        options = options or {}
        local content = options.Content or ""
        print("[ArexansUI Notification]: " .. content)
    end

    return WindowData
end

-- ==============================================================================
-- CLIENT TEST SCRIPT
-- ==============================================================================

local Window = ArexansUI:CreateWindow("Arexans Hub")

-- Tab 1: Main
local MainTab = Window:CreateTab("Main")

-- Menambahkan banyak toggle untuk test autoscroll dan memastikan batasnya
MainTab:CreateToggle("Auto Farm Level", true, function(Value) print("Auto Farm Level:", Value) end)
MainTab:CreateToggle("Auto Quest", true, function(Value) print("Auto Quest:", Value) end)
MainTab:CreateToggle("God Mode", false, function(Value) print("God Mode:", Value) end)
MainTab:CreateToggle("Auto Haki", false, function(Value) print("Auto Haki:", Value) end)
MainTab:CreateToggle("Bring Mobs", false, function(Value) print("Bring Mobs:", Value) end)

-- Tab 2: Settings
local SettingsTab = Window:CreateTab("Settings")
SettingsTab:CreateToggle("Anti AFK", true, function(Value) print("Anti AFK:", Value) end)
SettingsTab:CreateToggle("ESP Players", false, function(Value) print("ESP Status:", Value) end)

return ArexansUI
