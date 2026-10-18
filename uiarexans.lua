local __AXS_BOOT_GUI = nil
local function __AXS_Bootstrap(message, ok)
    local prefix = ok and "[AXS VD] " or "[AXS VD ERROR] "
    pcall(function() if ok then print(prefix .. tostring(message)) else warn(prefix .. tostring(message)) end end)
    pcall(function()
        local msg = tostring(message)
        if string.find(msg, "Loading", 1, true) then
            if __AXS_BOOT_GUI and __AXS_BOOT_GUI.Parent then __AXS_BOOT_GUI:Destroy() end
            local core = game:GetService("CoreGui")
            local gui = Instance.new("ScreenGui")
            gui.Name = "ArexansExecuteLoader"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 999999
            local panel = Instance.new("Frame")
            panel.Name = "LoaderPanel"
            panel.AnchorPoint = Vector2.new(0.5, 0.5)
            panel.Position = UDim2.new(0.5, 0, 0.5, 0)
            panel.Size = UDim2.fromOffset(210, 54)
            panel.BackgroundColor3 = Color3.fromRGB(5, 24, 48)
            panel.BackgroundTransparency = 0.08
            panel.BorderSizePixel = 0
            panel.Parent = gui
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = panel
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(35, 180, 255)
            stroke.Thickness = 1
            stroke.Parent = panel
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Position = UDim2.fromOffset(10, 0)
            label.Size = UDim2.new(1, -20, 1, 0)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 12
            label.TextColor3 = Color3.fromRGB(225, 245, 255)
            label.Text = "AREXANS  •  LOADING"
            label.Parent = panel
            gui.Parent = core
            __AXS_BOOT_GUI = gui
        elseif string.find(msg, "Ready", 1, true) or string.find(msg, "Loaded successfully", 1, true) then
            if __AXS_BOOT_GUI then __AXS_BOOT_GUI:Destroy(); __AXS_BOOT_GUI = nil end
        elseif not ok then
            if __AXS_BOOT_GUI then __AXS_BOOT_GUI:Destroy(); __AXS_BOOT_GUI = nil end
        end
    end)
end
pcall(function() print("[AXS VD] bootstrap: script started") end)
pcall(function() print("[AXS VD] bootstrap: Arexans UI bundle loading") end)
__AXS_Bootstrap("AXS VD  •  Loading", true)
getgenv = getgenv or function() return _G end; getgenv().__AXS_AREXANS_UI_SOURCE = [=[-- ==============================================================================
-- AREXANS UI LIBRARY - ASSET ONLY / CLEAN SPLIT PANEL
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
    "button_selected.png",
    "containers/divider.png",
    "containers/panel.png",
    "containers/panel2.png",
    "containers/separator.png",
    "controls/checkbox_hover.png",
    "controls/checkbox_off.png",
    "controls/checkbox_on.png",
    "controls/left.png",
    "controls/progress_bar.png",
    "controls/progress_fill.png",
    "controls/progress_knob.png",
    "controls/radio_hover.png",
    "controls/radio_off.png",
    "controls/radio_on.png",
    "controls/right.png",
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
    "dropdown_after_small.png",
    "dropdown_before.png",
    "dropdown_before_small.png",
    "dropdown_open_tall.png",
    "dropdown_selected_bg.png",
    "electric_compact_left.png",
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
    "long_horizonal_box.png",
    "long_horizontal_box_selected.png",
    "long_tab_button.png",
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
    "notification/panel_notification.png",
    "notification/toast_background.png",
    "off.png",
    "on.png",
    "player/avatar_frame.png",
    "popup/header_frame_center.png",
    "popup/arrow_down.png",
    "popup/dropdown_main_panel.png",
    "popup/option_normal_01.png",
    "popup/option_selected.png",
    "popup/search_icon.png",
    "popup/scrollbar_thumb.png",
    "popup/dialog_frame.png",
    "popup/modal_background.png",
    "saturation_value_gradient.png",
    "hue_gradient.png",
    "scroll/scrollbar_arrow_down.png",
    "scroll/scrollbar_arrow_up.png",
    "scroll/scrollbar_thumb.png",
    "scroll/scrollbar_thumb_hover.png",
    "scroll/scrollbar_track.png",
    "search.png",
    "textbox_long_01.png",
    "textbox_medium_01.png",
    "textbox_medium_02.png",
    "textbox_right_01.png",
    "textbox_right_02.png",
    "textbox_right_03.png",
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
    "window_search1.png",
    "window_search2.png",
    "window_search3.png",
}


local assetUsers = {}
local assetDownloadState = {}

local function AssetLocalPath(path)
    return FolderName .. "/" .. string.gsub(path, "/", "_")
end

local function GetLocalAsset(path)
    local getAsset = getcustomasset or getsynasset
    local localPath = AssetLocalPath(path)
    if isfile and getAsset then
        local ok, exists = pcall(isfile, localPath)
        if ok and exists then
            local success, uri = pcall(getAsset, localPath)
            if success and uri then return uri end
        end
    end
    return "rbxassetid://0"
end

local function SetLocalImage(imageObject, path)
    if not imageObject or type(path) ~= "string" then return end
    local uri = GetLocalAsset(path)
    pcall(function() imageObject.Image = uri end)
    if uri ~= "rbxassetid://0" then return end
    assetUsers[path] = assetUsers[path] or {}
    table.insert(assetUsers[path], imageObject)
end

local function RefreshAssetUsers(path)
    local getAsset = getcustomasset or getsynasset
    if not getAsset then return end
    local ok, uri = pcall(getAsset, AssetLocalPath(path))
    if not ok or not uri then return end
    local users = assetUsers[path]
    if not users then return end
    for i = #users, 1, -1 do
        local obj = users[i]
        if not obj or not obj.Parent then
            table.remove(users, i)
        else
            pcall(function() obj.Image = uri end)
        end
    end
end

-- Asset utama diunduh lebih dahulu. UI tetap dibangun langsung; setelah satu
-- kelompok asset penting selesai, gambarnya diperbarui sekaligus, bukan satu per satu.
local CriticalAssets = {
    "logo.png", "window/window_frame.png", "window/window_background.png",
    "window/window_humanoid.png", "window/window_humanoid_sleep.png",
    "containers/panel2.png", "navigation/tab_selected.png", "navigation/tab_disabled.png",
    "window_search2.png", "notification/panel_notification.png",
    "long_horizonal_box.png", "textbox_medium_02.png", "textbox_right_02.png",
    "button.png", "button_hover.png", "button_selected.png", "on.png", "off.png",
    "popup/dropdown_main_panel.png", "popup/option_normal_01.png",
    "popup/option_selected.png", "popup/search_icon.png", "popup/arrow_down.png",
    "popup/scrollbar_thumb.png",
    "scroll/scrollbar_thumb.png", "controls/checkbox_off.png", "controls/checkbox_on.png",
    "controls/left.png", "controls/right.png", "window/close_button.png",
    "window/minimize_button.png", "window/maximize_button.png",
    "window/expand_button.png", "window/collapse_button.png", "window/restore_button.png",
    "icons/lock_energy.png", "icons/unlock_energy.png"
}

local function PrefetchAllAssets()
    -- Mobile/executor stability: never fan out many concurrent HttpGet/writefile
    -- calls. A native SIGSEGV cannot be caught by pcall; keep asset work serialized
    -- in a background task so UI creation remains non-blocking.
    if not (isfile and writefile and makefolder) then return end
    if getgenv and getgenv().__AXS_ASSET_PREFETCH_RUNNING then return end
    if getgenv then getgenv().__AXS_ASSET_PREFETCH_RUNNING = true end

    task.spawn(function()
        local okRun, errRun = pcall(function()
            local criticalSet = {}
            for _, path in ipairs(CriticalAssets) do criticalSet[path] = true end

            local function DownloadGroup(paths)
                for _, path in ipairs(paths) do
                    local localPath = AssetLocalPath(path)
                    local exists = false
                    pcall(function() exists = isfile(localPath) end)
                    if not exists then
                        -- One network/file operation at a time to reduce native
                        -- executor pressure on Android ARM64.
                        local okDownload, data = pcall(function()
                            return game:HttpGet(BaseURL .. path)
                        end)
                        if okDownload and type(data) == "string" and #data > 0 then
                            pcall(function()
                                if not isfile(localPath) then
                                    writefile(localPath, data)
                                end
                            end)
                        end
                        task.wait(0.05)
                    end
                    -- Refresh consumers only after this file has finished writing.
                    pcall(function() RefreshAssetUsers(path) end)
                    task.wait()
                end
            end

            -- UI is already created; critical images are fetched first, then the rest.
            DownloadGroup(CriticalAssets)
            local rest = {}
            for _, path in ipairs(AssetList) do
                if not criticalSet[path] then table.insert(rest, path) end
            end
            DownloadGroup(rest)
        end)
        if not okRun then
            pcall(function() warn("[AXS] Asset prefetch stopped safely: " .. tostring(errRun)) end)
        end
        if getgenv then getgenv().__AXS_ASSET_PREFETCH_RUNNING = nil end
    end)
end

-- Mulai download tanpa menahan pembuatan layout/window.
PrefetchAllAssets()

function ArexansUI:CreateWindow(WindowName)
    local WindowData = {}
    -- Expose the existing asset resolver so extension UI can reuse bundled Arexans artwork.
    function WindowData:GetAsset(path) return GetLocalAsset(path) end
    
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

    -- Jangan menutupi UI eksternal seperti icon/menu Delta.
    -- Arexans tetap tampil normal, tetapi UI lain yang berada di DisplayOrder
    -- lebih tinggi tetap bisa menerima input ketika posisinya beririsan.
    ScreenGui.DisplayOrder = -1
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Bersihkan UI lama
    for _, gui in pairs(ScreenGui.Parent:GetChildren()) do
        if gui.Name == "ArexansInteractiveUI" and gui ~= ScreenGui then
            gui:Destroy()
        end
    end

    -- ==========================================================================
    -- 2. GLOBAL SEARCH + NOTIFICATION OVERLAY
    -- Dibuat sebagai satu layer terpisah supaya posisi selalu rapi terhadap
    -- viewport dan tidak ikut bergeser ketika WindowRoot di-drag/resize.
    -- ==========================================================================

    local OverlayLayer = Instance.new("Frame")
    OverlayLayer.Name = "OverlayLayer"
    OverlayLayer.BackgroundTransparency = 1
    OverlayLayer.Size = UDim2.fromScale(1, 1)
    OverlayLayer.Position = UDim2.fromScale(0, 0)
    OverlayLayer.ZIndex = 500
    OverlayLayer.Parent = ScreenGui

    -- Search bar: asset sudah berisi frame + icon + progress decoration.
    local SearchPanel = Instance.new("ImageLabel")
    SearchPanel.Name = "SearchPanel"
    SetLocalImage(SearchPanel, "window_search2.png")
    SearchPanel.BackgroundTransparency = 1
    SearchPanel.AnchorPoint = Vector2.new(0.5, 1)
    SearchPanel.Position = UDim2.new(0.5, 0, 1, -2)
    SearchPanel.Size = UDim2.new(0, 190, 0, 34)
    SearchPanel.ScaleType = Enum.ScaleType.Stretch
    SearchPanel.ZIndex = 510
    SearchPanel.Parent = OverlayLayer

    -- Search text transparan di atas asset agar bisa dipakai sebagai input.
    -- Saat kosong, asset tetap menampilkan label "Searching..." bawaannya.
    local SearchInput = Instance.new("TextBox")
    SearchInput.Name = "SearchInput"
    SearchInput.BackgroundTransparency = 1
    SearchInput.BorderSizePixel = 0
    SearchInput.Position = UDim2.new(0, 38, 0, 7)
    SearchInput.Size = UDim2.new(1, -50, 0, 20)
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.Text = ""
    SearchInput.PlaceholderText = "Cari fitur..."
    SearchInput.PlaceholderColor3 = Color3.fromRGB(150, 190, 220)
    SearchInput.TextColor3 = Color3.fromRGB(225, 245, 255)
    SearchInput.TextSize = 11
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.ClearTextOnFocus = false
    SearchInput.ZIndex = 511
    SearchInput.Parent = SearchPanel

    -- Notification stack.
    local NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "NotificationHolder"
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.AnchorPoint = Vector2.new(1, 1)
    NotificationHolder.Position = UDim2.new(1, -3, 1, -2)
    NotificationHolder.Size = UDim2.new(0, 220, 0, 70)
    NotificationHolder.ZIndex = 520
    NotificationHolder.Parent = OverlayLayer

    local NotificationPanel = Instance.new("ImageLabel")
    NotificationPanel.Name = "Panel"
    SetLocalImage(NotificationPanel, "notification/panel_notification.png")
    NotificationPanel.BackgroundTransparency = 1
    NotificationPanel.Size = UDim2.fromScale(1, 1)
    NotificationPanel.ScaleType = Enum.ScaleType.Stretch
    NotificationPanel.ZIndex = 520
    NotificationPanel.Parent = NotificationHolder

    local NotificationTitle = Instance.new("TextLabel")
    NotificationTitle.Name = "Title"
    NotificationTitle.BackgroundTransparency = 1
    -- Text-safe area within the notification art; keep the asset at its existing size.
    NotificationTitle.Position = UDim2.new(0, 77, 0, 3)
    NotificationTitle.Size = UDim2.new(1, -116, 0, 18)
    NotificationTitle.Font = Enum.Font.GothamBold
    NotificationTitle.Text = "Arexans Tools"
    NotificationTitle.TextColor3 = Color3.fromRGB(235, 248, 255)
    NotificationTitle.TextSize = 14
    NotificationTitle.TextYAlignment = Enum.TextYAlignment.Center
    NotificationTitle.TextTruncate = Enum.TextTruncate.AtEnd
    NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotificationTitle.ZIndex = 521
    NotificationTitle.Parent = NotificationHolder

    local NotificationContent = Instance.new("TextLabel")
    NotificationContent.Name = "Content"
    NotificationContent.BackgroundTransparency = 1
    NotificationContent.Position = UDim2.new(0, 57, 0, 22)
    NotificationContent.Size = UDim2.new(1, -76, 0, 40)
    NotificationContent.Font = Enum.Font.Gotham
    NotificationContent.Text = ""
    NotificationContent.TextColor3 = Color3.fromRGB(220, 238, 255)
    NotificationContent.TextSize = 13
    NotificationContent.TextTruncate = Enum.TextTruncate.None
    NotificationContent.TextWrapped = true
    NotificationContent.RichText = false
    NotificationContent.TextXAlignment = Enum.TextXAlignment.Left
    NotificationContent.TextYAlignment = Enum.TextYAlignment.Center
    NotificationContent.ZIndex = 521
    NotificationContent.Parent = NotificationHolder

    NotificationHolder.Visible = false

    local function ShowNotification(title, content, duration)
        NotificationTitle.Text = tostring(title or "Arexans Tools")
        NotificationContent.Text = tostring(content or "")
        NotificationHolder.Visible = true

        local timeout = tonumber(duration)
        -- duration <= 0 (or nil) means editor-preview/persistent notification.
        if timeout and timeout > 0 then
            task.delay(timeout, function()
                if NotificationHolder and NotificationHolder.Parent then
                    NotificationHolder.Visible = false
                end
            end)
        end
    end

    -- Notifikasi tampil langsung setelah layer dibuat; tidak menahan first render.
    task.defer(function()
        if NotificationHolder and NotificationHolder.Parent then
            ShowNotification("Arexans Tools", "Berhasil di load\nBerhasil di load", 0)
        end
    end)

    WindowData._screenGui = ScreenGui
    -- Expose notification objects to the Live Layout Editor so the loader toast
    -- can be edited and previewed without leaving the editor panel.
    WindowData._notificationHolder = NotificationHolder
    WindowData._notificationPanel = NotificationPanel
    WindowData._notificationTitle = NotificationTitle
    WindowData._notificationContent = NotificationContent
    function WindowData:SetVisible(state)
        if ScreenGui and ScreenGui.Parent then
            ScreenGui.Enabled = state ~= false
        end
    end

    function WindowData:SetSearchText(text)
        SearchInput.Text = tostring(text or "")
    end

    -- Allow the host script to react to search input without replacing Arexans assets.
    function WindowData:SetSearchCallback(callback)
        if self._searchConnection then self._searchConnection:Disconnect() end
        if type(callback) ~= "function" then return end
        self._searchConnection = SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
            local ok, err = pcall(callback, SearchInput.Text)
            if not ok then warn("[Arexans Search] " .. tostring(err)) end
        end)
    end

    function WindowData:SetSearchVisible(state)
        SearchPanel.Visible = state ~= false
    end

    -- 3. Logo Show UI On/Off + mini lock/unlock untuk posisi logo.
    local OpenCloseButton = Instance.new("ImageButton")
    OpenCloseButton.Name = "OpenCloseLogo"
    SetLocalImage(OpenCloseButton, "logo.png")
    OpenCloseButton.BackgroundTransparency = 1
    OpenCloseButton.Position = UDim2.new(1, -80, 0, 20)
    OpenCloseButton.Size = UDim2.new(0, 60, 0, 60)
    OpenCloseButton.ZIndex = 100
    OpenCloseButton.Active = true
    OpenCloseButton.Parent = ScreenGui

    local LogoPositionLocked = true -- default terkunci supaya tidak bergeser tanpa sengaja
    local LogoDragging = false
    local LogoMoved = false
    local LogoLockWasClicked = false
    local LogoDragStart = nil
    local LogoStartPosition = nil
    local LogoDragInput = nil

    -- Gunakan ikon lock/unlock bawaan asset Arexans, tanpa membuat badge/ikon emoji baru.
    local LogoLockButton = Instance.new("ImageButton")
    LogoLockButton.Name = "LogoPositionLock"
    -- Ikon lock berada di sudut kanan ATAS logo, bukan kanan bawah.
    LogoLockButton.AnchorPoint = Vector2.new(1, 0)
    LogoLockButton.Position = UDim2.new(1, -1, 0, 1)
    LogoLockButton.Size = UDim2.fromOffset(22, 22)
    LogoLockButton.BackgroundTransparency = 1
    LogoLockButton.BorderSizePixel = 0
    LogoLockButton.AutoButtonColor = false
    LogoLockButton.ScaleType = Enum.ScaleType.Fit
    LogoLockButton.ImageTransparency = 0
    LogoLockButton.ZIndex = 102
    LogoLockButton.Parent = OpenCloseButton

    local function UpdateLogoLockVisual()
        SetLocalImage(LogoLockButton, LogoPositionLocked
            and "icons/lock_energy.png"
            or "icons/unlock_energy.png")
        LogoLockButton:SetAttribute("Locked", LogoPositionLocked)
    end
    UpdateLogoLockVisual()

    LogoLockButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            LogoLockWasClicked = true
        end
    end)

    LogoLockButton.MouseButton1Click:Connect(function()
        LogoPositionLocked = not LogoPositionLocked
        LogoDragging = false
        LogoMoved = false
        UpdateLogoLockVisual()
    end)

    OpenCloseButton.InputBegan:Connect(function(input)
        if LogoPositionLocked then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        -- Tap pada mini lock hanya mengubah lock, bukan memulai drag logo.
        local p = input.Position
        local bPos, bSize = LogoLockButton.AbsolutePosition, LogoLockButton.AbsoluteSize
        if p.X >= bPos.X and p.X <= bPos.X + bSize.X
            and p.Y >= bPos.Y and p.Y <= bPos.Y + bSize.Y then return end
        LogoDragging = true
        LogoMoved = false
        LogoDragStart = Vector2.new(p.X, p.Y)
        -- Simpan posisi layar absolut agar posisi awal berbasis scale (pojok kanan)
        -- tidak membuat logo meloncat ketika mulai digeser.
        LogoStartPosition = OpenCloseButton.AbsolutePosition
        LogoDragInput = input
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not LogoDragging or LogoPositionLocked then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if LogoDragInput and LogoDragInput.UserInputType == Enum.UserInputType.Touch
            and input ~= LogoDragInput then return end
        local delta = Vector2.new(input.Position.X, input.Position.Y) - LogoDragStart
        if math.abs(delta.X) + math.abs(delta.Y) > 6 then LogoMoved = true end
        if LogoMoved then
            -- Tanpa clamp/batas tepi: logo mengikuti sentuhan/mouse secara bebas.
            -- Offset absolut juga menjaga gerakan konsisten dari posisi mana pun.
            local x = LogoStartPosition.X + delta.X
            local y = LogoStartPosition.Y + delta.Y
            OpenCloseButton.Position = UDim2.fromOffset(x, y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            LogoDragging = false
            LogoDragInput = nil
        end
    end)

    -- Drag window utama tetap mempunyai lock terpisah.
    local dragLocked = false



    -- 3. ROOT WINDOW + ASSET LAYERS
    -- Root memakai ukuran EXACT window_frame.png.
    -- Jangan jadikan window_background sebagai root karena asset background
    -- memiliki ukuran/aspect ratio berbeda dari frame.
    local WindowRoot = Instance.new("Frame")
    WindowRoot.Name = "WindowRoot"
    WindowRoot.BackgroundTransparency = 1
    -- Posisi kiri dibuat responsif agar seluruh frame + humanoid tetap terlihat.
    -- Tidak lagi memakai AnchorPoint X=0.5 karena itu membuat separuh frame
    -- masuk ke luar layar saat Offset X kecil.
    local BASE_WIDTH, BASE_HEIGHT = 557, 299
    local uiScale = 1.12
    local MIN_SCALE = 0.65
    local MAX_SCALE = 1.25

    -- PENTING:
    -- Jangan mengubah Size WindowRoot saat resize. UIScale saja yang berubah.
    -- Versi lama mengubah Size + UIScale sekaligus sehingga koordinat child
    -- menjadi tidak konsisten dan area klik humanoid ikut bergeser.
    WindowRoot.Size = UDim2.new(0, BASE_WIDTH, 0, BASE_HEIGHT)
    -- Gunakan koordinat top-left murni untuk drag. Ini menghindari
    -- perubahan Scale/Offset Y yang bisa membuat window meloncat saat
    -- sentuhan pertama dimulai.
    WindowRoot.AnchorPoint = Vector2.new(0, 0)
    WindowRoot.ZIndex = 1
    WindowRoot.Active = true
    WindowRoot.Parent = ScreenGui

    -- Search mini menyatu dengan tepian bawah frame, bukan lagi fixed di viewport.
    SearchPanel.AnchorPoint = Vector2.new(0.5, 1)
    SearchPanel.Position = UDim2.new(0.5, 0, 1, -2)
    SearchPanel.ZIndex = 60
    SearchPanel.Parent = WindowRoot

    local UIScale = Instance.new("UIScale")
    UIScale.Name = "FrameScale"
    UIScale.Scale = uiScale
    UIScale.Parent = WindowRoot

    local function GetViewport()
        local viewport = ScreenGui.AbsoluteSize
        if viewport.X <= 0 or viewport.Y <= 0 then
            local camera = workspace.CurrentCamera
            if camera then
                viewport = camera.ViewportSize
            end
        end
        return viewport
    end

    local function GetAllowedScaleRange()
        local viewport = GetViewport()
        local horizontalRoom = math.max(1, viewport.X - 20) / BASE_WIDTH
        local verticalRoom = math.max(1, viewport.Y - 20) / BASE_HEIGHT

        -- Frame selalu bisa tampil utuh di layar. Di HP kecil, skala maksimum
        -- otomatis diturunkan agar tidak ada tab/toggle yang keluar frame.
        local fitMax = math.min(horizontalRoom, verticalRoom)
        local dynamicMax = math.min(MAX_SCALE, fitMax)
        dynamicMax = math.max(MIN_SCALE, dynamicMax)

        return MIN_SCALE, dynamicMax
    end

    local function ClampWindowToViewport()
        local viewport = GetViewport()
        local visualSize = WindowRoot.AbsoluteSize
        local maxX = math.max(0, viewport.X - visualSize.X)
        local maxY = math.max(0, viewport.Y - visualSize.Y)

        local x = math.clamp(WindowRoot.Position.X.Offset, 0, maxX)
        local y = math.clamp(WindowRoot.Position.Y.Offset, 0, maxY)
        WindowRoot.Position = UDim2.new(0, x, 0, y)
    end

    local viewport = GetViewport()
    local safeLeft = 10
    local visualWidth = BASE_WIDTH * uiScale
    local preferredLeft = math.floor(math.max(0, viewport.X - visualWidth) * 0.5)
    local maxLeft = math.max(0, viewport.X - visualWidth - safeLeft)
    local leftPosition = math.clamp(preferredLeft, 0, maxLeft)
    local initialVisualHeight = BASE_HEIGHT * uiScale
    local initialTop = math.max(0, math.floor((viewport.Y - initialVisualHeight) * 0.5))
    WindowRoot.Position = UDim2.new(0, leftPosition, 0, initialTop)

    local resizing = false
    local resizeStart
    local resizeStartScale
    local RESIZE_ZONE = 52

    local function IsInsideResizeCorner(screenPosition)
        if not WindowRoot.Visible then return false end
        local pos = WindowRoot.AbsolutePosition
        local size = WindowRoot.AbsoluteSize
        return screenPosition.X >= (pos.X + size.X - RESIZE_ZONE)
            and screenPosition.X <= (pos.X + size.X + 8)
            and screenPosition.Y >= (pos.Y + size.Y - RESIZE_ZONE)
            and screenPosition.Y <= (pos.Y + size.Y + 8)
    end

    -- Handle resize transparan tetapi memiliki grip kecil supaya mudah ditemukan
    -- dan disentuh di HP. Area sentuh 52px, jauh lebih nyaman dari 30px sebelumnya.
    local ResizeHandle = Instance.new("ImageButton")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.AutoButtonColor = false
    ResizeHandle.Size = UDim2.new(0, RESIZE_ZONE, 0, RESIZE_ZONE)
    ResizeHandle.Position = UDim2.new(1, -RESIZE_ZONE, 1, -RESIZE_ZONE)
    ResizeHandle.AnchorPoint = Vector2.new(0, 0)
    ResizeHandle.ZIndex = 100
    ResizeHandle.Active = true
    ResizeHandle.Parent = WindowRoot

    local function BeginResize(input)
        if not WindowRoot.Visible then return end
        resizing = true
        resizeStart = Vector2.new(input.Position.X, input.Position.Y)
        resizeStartScale = uiScale
    end

    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            BeginResize(input)
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not WindowRoot.Visible then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        if IsInsideResizeCorner(input.Position) then
            BeginResize(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    local function ApplyScale(newScale)
        local minScale, maxScale = GetAllowedScaleRange()
        uiScale = math.clamp(newScale, minScale, maxScale)
        UIScale.Scale = uiScale
        ClampWindowToViewport()
    end

    UserInputService.InputChanged:Connect(function(input)
        if not resizing then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local current = Vector2.new(input.Position.X, input.Position.Y)
        local delta = current - resizeStart

        -- Pakai sumbu yang paling dominan supaya resize di HP tidak terasa seret.
        local dominantDelta = math.abs(delta.X) >= math.abs(delta.Y) and delta.X or delta.Y
        local deltaScale = dominantDelta / (BASE_WIDTH * 0.72)
        ApplyScale(resizeStartScale + deltaScale)
    end)

    -- Jika orientasi/ukuran layar berubah, skala dan posisi langsung dikoreksi.
    ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        local minScale, maxScale = GetAllowedScaleRange()
        if uiScale > maxScale then
            uiScale = maxScale
            UIScale.Scale = uiScale
        end
        ClampWindowToViewport()
    end)

    -- Background ASLI: pertahankan ukuran asset 512x241, jangan stretch.
    local windowbackground = Instance.new("ImageLabel")
    windowbackground.Name = "window_background"
    SetLocalImage(windowbackground, "window/window_background.png")
    windowbackground.BackgroundTransparency = 1
    windowbackground.Position = UDim2.new(0.5, 0, 0.5, 0)
    windowbackground.Size = UDim2.new(0, 512, 0, 241)
    windowbackground.AnchorPoint = Vector2.new(0.5, 0.5)
    windowbackground.ZIndex = 1
    windowbackground.Parent = WindowRoot

    OpenCloseButton.MouseButton1Click:Connect(function()
        -- Mini lock punya aksi sendiri dan tidak boleh ikut men-toggle UI.
        if LogoLockWasClicked then
            LogoLockWasClicked = false
            return
        end
        -- Abaikan klik yang sebenarnya merupakan gerakan memindahkan logo.
        if LogoMoved then
            LogoMoved = false
            return
        end
        -- Klik mini lock/unlock tidak boleh menampilkan/menyembunyikan UI.
        WindowRoot.Visible = not WindowRoot.Visible
    end)

    -- ==========================================================================
    -- SLEEP HITBOX
    -- ==========================================================================
    -- Ada 2 humanoid (kiri & kanan). Masing-masing hanya mempunyai area Sleep
    -- pada kepala dan buntut. Area lengan sengaja tidak dimasukkan agar tab
    -- dan toggle tetap mudah ditekan.
    local SleepZones = {
        -- HUMANOID KIRI
        LeftHead  = { X = 38,  Y = 6, W = 88, H = 46 },
        LeftTail  = { X = 126, Y = 7, W = 62, H = 42 },

        -- HUMANOID KANAN
        RightHead = { X = 285, Y = 6, W = 88, H = 46 },
        RightTail = { X = 390, Y = 7, W = 62, H = 42 },
    }

    -- Logo ARE X ANS adalah area drag khusus. Klik di sini tidak pernah
    -- memicu Humanoid Sleep.
    local DragZone = { X = 165, Y = 0, W = 220, H = 42 }

    local function IsPointInsideZone(screenPosition, zone)
        if not WindowRoot.Visible then return false end
        local pos = WindowRoot.AbsolutePosition
        local scale = UIScale.Scale
        local x = pos.X + zone.X * scale
        local y = pos.Y + zone.Y * scale
        local w = zone.W * scale
        local h = zone.H * scale
        return screenPosition.X >= x and screenPosition.X <= x + w
            and screenPosition.Y >= y and screenPosition.Y <= y + h
    end

    local function IsPointInsideDragZone(screenPosition)
        return IsPointInsideZone(screenPosition, DragZone)
    end

    local function IsPointInsideSleepZone(screenPosition)
        if not WindowRoot.Visible then return false end

        -- PRIORITAS DRAG: header/logo tidak boleh mengaktifkan Sleep.
        if IsPointInsideDragZone(screenPosition) then
            return false
        end

        for _, zone in pairs(SleepZones) do
            if IsPointInsideZone(screenPosition, zone) then
                return true
            end
        end
        return false
    end

    -- 4. Custom Dragging Area
    local DragHandle = Instance.new("Frame")
    DragHandle.Name = "DragHandle"
    DragHandle.BackgroundTransparency = 1
    -- Seluruh area header/logo ARE X ANS menjadi area drag.
    -- Tidak menutupi tombol tab/toggle di bawahnya.
    DragHandle.Position = UDim2.new(0, DragZone.X, 0, DragZone.Y)
    DragHandle.Size = UDim2.new(0, DragZone.W, 0, DragZone.H)
    DragHandle.ZIndex = 60
    DragHandle.Active = true
    DragHandle.Parent = WindowRoot

    local dragging = false
    local dragInput = nil
    local dragStart, startPos
    local dragViewport, dragWindowSize

    local function StopDragging()
        dragging = false
        dragInput = nil
    end

    local function BeginDragging(input)
        if dragLocked then return end
        if not WindowRoot.Visible then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos = WindowRoot.Position
        dragViewport = GetViewport()
        dragWindowSize = WindowRoot.AbsoluteSize
        dragInput = input
        dragging = true
    end

    DragHandle.InputBegan:Connect(function(input)
        BeginDragging(input)
    end)

    -- InputEnded global mencegah drag macet ketika jari/mouse keluar dari
    -- DragHandle saat sedang menggeser.
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            StopDragging()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        -- Saat touch, hanya ikuti jari yang benar-benar memulai drag.
        -- Ini mencegah event touch lain menyebabkan UI bergerak tiba-tiba.
        if dragInput and dragInput.UserInputType == Enum.UserInputType.Touch
            and input ~= dragInput then
            return
        end

        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart

        -- X/Y sama-sama top-left offset. Tidak ada konversi Scale <-> Offset,
        -- sehingga posisi tidak bisa meloncat ketika drag pertama dimulai.
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        local maxX = math.max(0, dragViewport.X - dragWindowSize.X)
        local maxY = math.max(0, dragViewport.Y - dragWindowSize.Y)

        local targetX = math.clamp(newX, 0, maxX)
        local targetY = math.clamp(newY, 0, maxY)

        WindowRoot.Position = UDim2.new(0, targetX, 0, targetY)
    end)

    -- ==============================================================================
    -- PERBAIKAN KOORDINAT PRESISI KOTAK KIRI & KANAN
    -- ==============================================================================
    
    -- KOTAK TABS (Kiri)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundTransparency = 1
    -- Posisi dikembalikan sedikit dari versi sebelumnya agar tidak menembus area kepala/tangan humanoid.
    -- Tetap cukup tinggi untuk mengikuti bagian atas frame tanpa terpotong.
    -- Area tab dibuat lebih pendek daripada panel kiri supaya baris tombol
    -- paling bawah tidak menyentuh atau melewati bingkai bawah.
    -- ClipsDescendants tetap aktif agar tab tambahan hanya muncul saat discroll.
    TabContainer.Position = UDim2.new(0, 27, 0, 53)
    TabContainer.Size = UDim2.new(0, 134, 0, 226)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    -- Scroll tetap berfungsi, tetapi scrollbar tidak terlihat.
    TabContainer.ScrollBarThickness = 0
    TabContainer.ScrollBarImageTransparency = 1
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    TabContainer.Active = true
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.None
    TabContainer.ClipsDescendants = true 
    TabContainer.ZIndex = 5
    TabContainer.Parent = WindowRoot

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 2)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Parent = TabContainer
    
    -- Manually update CanvasSize instead of AutomaticCanvasSize (memory guideline)
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
    end)

    -- AREA FITUR KANAN.
    -- Sengaja dibuat lebih kecil dari window_frame agar TIDAK PERNAH
    -- menggambar di bawah ornamen tepi frame. Area ini juga dibuat simetris
    -- kiri/kanan untuk grid fitur.
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.BackgroundTransparency = 1
    PageContainer.Position = UDim2.new(0, 151, 0, 60)
    PageContainer.Size = UDim2.new(0, 390, 0, 220)
    PageContainer.ClipsDescendants = true
    PageContainer.ZIndex = 5
    PageContainer.Parent = WindowRoot

    -- Panel tab kiri tetap memakai satu asset sendiri.
    local TabPanelBg = Instance.new("ImageLabel")
    TabPanelBg.Name = "TabPanelBg"
    SetLocalImage(TabPanelBg, "containers/panel2.png")
    TabPanelBg.BackgroundTransparency = 1
    TabPanelBg.Position = UDim2.new(0, 22, 0, 49)
    TabPanelBg.Size = UDim2.new(0, 144, 0, 232)
    TabPanelBg.ScaleType = Enum.ScaleType.Stretch
    TabPanelBg.ZIndex = 4
    TabPanelBg.Parent = WindowRoot

    -- ==============================================================================
    -- BINGKAI SELALU DI DEPAN (ZIndex 50 & 51)
    -- ==============================================================================
    local windowframe = Instance.new("ImageLabel")
    windowframe.Name = "window_frame"
    SetLocalImage(windowframe, "window/window_frame.png")
    windowframe.BackgroundTransparency = 1
    windowframe.Position = UDim2.new(0.5, 0, 0.5, 0)
    windowframe.Size = UDim2.new(0, 557, 0, 299)
    windowframe.AnchorPoint = Vector2.new(0.5, 0.5)
    windowframe.ZIndex = 50 
    windowframe.Active = false 
    windowframe.Parent = WindowRoot

    -- HUMANOID VISUAL SAJA.
    -- Penting: jangan gunakan ImageButton di sini karena humanoid berada di depan
    -- toggle/tab. ImageButton akan "memakan" input sehingga UI di bawah tangan
    -- tidak bisa ditekan. Kita gunakan ImageLabel + deteksi klik global yang hanya
    -- aktif pada area tangan/lengan yang TIDAK sedang menutupi tombol UI.
    local windowhumanoid = Instance.new("ImageLabel")
    windowhumanoid.Name = "window_humanoid"
    SetLocalImage(windowhumanoid, "window/window_humanoid.png")
    windowhumanoid.BackgroundTransparency = 1
    windowhumanoid.Position = UDim2.new(0.5, 0, 0.5, -137)
    windowhumanoid.Size = UDim2.new(0, 618, 0, 149)
    windowhumanoid.AnchorPoint = Vector2.new(0.5, 0.5)
    windowhumanoid.ZIndex = 51
    windowhumanoid.Active = false
    windowhumanoid.Parent = WindowRoot
    -- HUMANOID SLEEP: hanya berubah saat kepala atau buntut diklik.
    local humanoidSleeping = false

    local function SetHumanoidSleep(state)
        humanoidSleeping = state == true
        SetLocalImage(windowhumanoid, 
            humanoidSleeping and "window/window_humanoid_sleep.png"
            or "window/window_humanoid.png"
        )
    end

    local function ToggleHumanoidSleep()
        SetHumanoidSleep(not humanoidSleeping)
    end

    -- Input global dipakai karena humanoid adalah ImageLabel non-interaktif.
    -- Logo ARE X ANS selalu diprioritaskan sebagai area drag.
    UserInputService.InputBegan:Connect(function(input)
        if not WindowRoot.Visible then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        -- Klik logo/header hanya untuk drag, bukan Sleep.
        if IsPointInsideDragZone(input.Position) then
            return
        end

        -- Sleep hanya dari kepala/buntut humanoid kiri atau kanan.
        if IsPointInsideSleepZone(input.Position) then
            ToggleHumanoidSleep()
        end
    end)

    function WindowData:SetHumanoidSleep(state)
        SetHumanoidSleep(state == true)
    end

    function WindowData:ToggleHumanoidSleep()
        ToggleHumanoidSleep()
    end

    -- ==============================================================================

    local Tabs = {}
    local Pages = {}
    local FirstTab = true

    function WindowData:CreateTab(TabName)
        local TabData = {}
        
        -- Tombol Tab
        local TabButton = Instance.new("ImageButton")
        TabButton.Name = TabName .. "_Tab"
        SetLocalImage(TabButton, "navigation/tab_disabled.png")
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Fallback
        TabButton.BackgroundTransparency = 1
        TabButton.AutoButtonColor = false
        TabButton.Size = UDim2.new(1, 0, 0, 28)
        TabButton.ZIndex = 10
        TabButton.Parent = TabContainer

        local TabText = Instance.new("TextLabel")
        TabText.BackgroundTransparency = 1
        TabText.Size = UDim2.new(1, 0, 1, 0)
        TabText.Font = Enum.Font.GothamBold
        TabText.Text = TabName
        TabText.TextColor3 = Color3.fromRGB(180, 180, 220)
        TabText.TextSize = 11
        TabText.ZIndex = 11
        TabText.Parent = TabButton

        -- Area Halaman: toggle dibagi menjadi 2 kolom agar panel tidak terlalu panjang.
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName .. "_Page"
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 0
        Page.ScrollBarImageTransparency = 0.35
        Page.ScrollingDirection = Enum.ScrollingDirection.Y
        Page.Active = true
        Page.Visible = FirstTab
        Page.ClipsDescendants = true
        Page.ZIndex = 10
        Page.Parent = PageContainer

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 0)
        PagePadding.PaddingBottom = UDim.new(0, 4)
        PagePadding.PaddingLeft = UDim.new(0, 0)
        PagePadding.PaddingRight = UDim.new(0, 0)
        PagePadding.Parent = Page

        -- Content memiliki margin sama di kiri/kanan.
        -- Semua baris fitur menggunakan grid 50/50 yang benar-benar simetris.
        local Content = Instance.new("Frame")
        Content.Name = "Content"
        Content.BackgroundTransparency = 1
        -- Insets dibuat nyata di kedua sisi area konten. Kolom kiri tidak
        -- boleh menyentuh garis bingkai; sisi kanan tetap memiliki ruang aman.
        Content.Size = UDim2.new(1, -42, 0, 0)
        Content.AutomaticSize = Enum.AutomaticSize.Y
        Content.Position = UDim2.new(0, 18, 0, 0)
        Content.ZIndex = 20
        Content.Parent = Page

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Name = "RowsLayout"
        ContentLayout.Padding = UDim.new(0, 1)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ContentLayout.Parent = Content

        local currentRow = nil
        local currentColumn = 0
        local ITEM_HEIGHT = 27
        local ITEM_GAP = 3
        local function GetItemParent(requestedHeight)
            requestedHeight = math.max(ITEM_HEIGHT, tonumber(requestedHeight) or ITEM_HEIGHT)
            if not currentRow or currentColumn >= 2 then
                currentRow = Instance.new("Frame")
                currentRow.Name = "ItemRow"
                currentRow.BackgroundTransparency = 1
                currentRow.Size = UDim2.new(1, 0, 0, requestedHeight)
                currentRow.ZIndex = 20
                currentRow.Parent = Content

                local RowLayout = Instance.new("UIListLayout")
                RowLayout.Name = "ColumnsLayout"
                RowLayout.FillDirection = Enum.FillDirection.Horizontal
                -- Jika baris hanya berisi satu kontrol (misalnya satu slider),
                -- letakkan di kolom kiri, bukan di tengah baris.
                RowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
                RowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                RowLayout.Padding = UDim.new(0, ITEM_GAP)
                RowLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RowLayout.Parent = currentRow

                currentColumn = 0
            elseif requestedHeight > currentRow.Size.Y.Offset then
                -- Pastikan row cukup tinggi jika berisi slider.
                currentRow.Size = UDim2.new(1, 0, 0, requestedHeight)
            end

            local slot = Instance.new("Frame")
            slot.Name = "ItemSlot"
            slot.BackgroundTransparency = 1
            slot.Size = UDim2.new(0.5, -(ITEM_GAP / 2), 1, 0)
            slot.ZIndex = 20
            slot.LayoutOrder = currentColumn + 1
            slot.Parent = currentRow

            -- Tidak menambahkan SlotBackground: setiap kontrol sudah memiliki
            -- asset latar sendiri. Layer tambahan ini menyebabkan background
            -- tombol/fitur terlihat dobel dan saling menumpuk.

            currentColumn += 1
            return slot
        end

        -- Full-width controls (such as sliders) own an entire row. Starting a
        -- fresh row prevents the next control from being placed beside the slider.
        local function GetFullWidthItemParent(requestedHeight)
            requestedHeight = math.max(ITEM_HEIGHT, tonumber(requestedHeight) or ITEM_HEIGHT)
            currentRow = Instance.new("Frame")
            currentRow.Name = "ItemRow_FullWidth"
            currentRow.BackgroundTransparency = 1
            currentRow.Size = UDim2.new(1, 0, 0, requestedHeight)
            currentRow.ZIndex = 20
            currentRow.Parent = Content

            local slot = Instance.new("Frame")
            slot.Name = "ItemSlot_FullWidth"
            slot.BackgroundTransparency = 1
            slot.Size = UDim2.new(1, 0, 1, 0)
            slot.ZIndex = 20
            slot.Parent = currentRow

            currentColumn = 2 -- next normal control begins on a new row
            return slot
        end

        local function CreateCategoryInternal(title)
            -- Category memakai asset yang sudah tersedia; tidak ada Frame/Stroke
            -- buatan untuk garis dekoratif.
            currentRow = nil
            currentColumn = 2

            local Category = Instance.new("ImageLabel")
            Category.Name = "Category_" .. tostring(title):gsub("%s+", "_")
            SetLocalImage(Category, "long_horizonal_box.png")
            Category.BackgroundTransparency = 1
            Category.Size = UDim2.new(1, 0, 0, 18)
            Category.ScaleType = Enum.ScaleType.Stretch
            Category.ZIndex = 40
            Category.Parent = Content

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -16, 1, 0)
            Title.Font = Enum.Font.GothamBold
            Title.Text = tostring(title or "Category")
            Title.TextColor3 = Color3.fromRGB(230, 248, 255)
            Title.TextSize = 7
            Title.TextXAlignment = Enum.TextXAlignment.Center
            Title.TextTruncate = Enum.TextTruncate.AtEnd
            Title.ZIndex = 41
            Title.Parent = Category

            return Category
        end

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            local contentHeight = ContentLayout.AbsoluteContentSize.Y + 6
            Page.CanvasSize = UDim2.new(0, 0, 0, math.max(Page.AbsoluteSize.Y - 4, contentHeight))
        end)

        if FirstTab then
            SetLocalImage(TabButton, "navigation/tab_selected.png")
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Fallback selected
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            FirstTab = false
        end

        table.insert(Tabs, TabButton)
        table.insert(Pages, Page)

        -- Expose navigation handles so the global feature search can switch tabs.
        TabData._Page = Page
        TabData._TabButton = TabButton
        TabData._Content = Content
        function TabData:Select()
            for _, otherTab in pairs(Tabs) do
                SetLocalImage(otherTab, "navigation/tab_disabled.png")
                otherTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                local otherText = otherTab:FindFirstChild("TextLabel")
                if otherText then otherText.TextColor3 = Color3.fromRGB(180, 180, 220) end
            end
            for _, otherPage in pairs(Pages) do otherPage.Visible = false end
            SetLocalImage(TabButton, "navigation/tab_selected.png")
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            Page.Visible = true
        end
        TabButton.MouseButton1Click:Connect(function() TabData:Select() end)

        -- ======================================================================
        -- CATEGORY TITLE
        -- ======================================================================
        function TabData:CreateCategory(CategoryName)
            return CreateCategoryInternal(CategoryName)
        end

        -- Asset-backed full-width section for legacy features that need a real
        -- container (for example, the server browser). Keeps the same Arexans
        -- panel artwork and exposes its inner content frame safely.
        function TabData:CreateCustomSection(SectionName, Height)
            currentRow = nil
            currentColumn = 2
            local root = Instance.new("Frame")
            root.Name = "Section_" .. tostring(SectionName or "Custom"):gsub("%s+", "_")
            root.BackgroundTransparency = 1
            root.BorderSizePixel = 0
            root.Size = UDim2.new(1, 0, 0, (tonumber(Height) or 320) + 28)
            root.ZIndex = 1
            root.Parent = Content

            local title = Instance.new("TextLabel")
            title.Name = "Title"
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 10, 0, 4)
            title.Size = UDim2.new(1, -20, 0, 20)
            title.Font = Enum.Font.GothamBold
            title.Text = tostring(SectionName or "Section")
            title.TextColor3 = Color3.fromRGB(230, 248, 255)
            title.TextSize = 9
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.ZIndex = 3
            title.Parent = root

            local inner = Instance.new("Frame")
            inner.Name = "SectionAdd"
            inner.BackgroundTransparency = 1
            inner.Position = UDim2.new(0, 8, 0, 26)
            inner.Size = UDim2.new(1, -16, 0, tonumber(Height) or 320)
            inner.ZIndex = 2
            inner.Parent = root

            return {Root = root, Title = title, SectionAdd = inner}
        end

        -- ======================================================================
        -- INPUT COMPONENTS: TEXTBOX / DROPDOWN / BUTTON
        -- ======================================================================
        function TabData:CreateTextbox(TextboxName, Placeholder, DefaultText, Callback)
            local value = tostring(DefaultText or "")
            Callback = Callback or function() end

            local Box = Instance.new("Frame")
            Box.Name = TextboxName .. "_Textbox"
            Box.BackgroundTransparency = 1
            Box.Size = UDim2.new(1, 0, 0, 28)
            Box.ZIndex = 30
            Box.Parent = GetItemParent()

            -- Kiri: textbox_medium_01.png. Kanan: textbox_right_01.png.
            -- Pembagian ini mengikuti bentuk asset pada contoh sehingga tidak ada
            -- lagi kotak UICorner polos yang memotong border biru/gold.
            local LabelBg = Instance.new("ImageLabel")
            LabelBg.Name = "LabelBackground"
            SetLocalImage(LabelBg, "textbox_medium_02.png")
            LabelBg.BackgroundTransparency = 1
            LabelBg.Position = UDim2.new(0, 0, 0, 0)
            LabelBg.Size = UDim2.new(0.635, 1, 1, 0)
            LabelBg.ScaleType = Enum.ScaleType.Stretch
            LabelBg.ZIndex = 30
            LabelBg.Parent = Box

            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(1, -18, 1, 0)
            Label.Font = Enum.Font.GothamBold
            Label.Text = TextboxName
            Label.TextColor3 = Color3.fromRGB(240, 250, 255)
            Label.TextSize = 8
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextTruncate = Enum.TextTruncate.AtEnd
            Label.ZIndex = 31
            Label.Parent = LabelBg

            local InputBg = Instance.new("ImageLabel")
            InputBg.Name = "InputBackground"
            SetLocalImage(InputBg, "textbox_right_02.png")
            InputBg.BackgroundTransparency = 1
            InputBg.Position = UDim2.new(0.625, 0, 0, 0)
            InputBg.Size = UDim2.new(0.375, 0, 1, 0)
            InputBg.ScaleType = Enum.ScaleType.Stretch
            InputBg.ZIndex = 31
            InputBg.Parent = Box

            local Input = Instance.new("TextBox")
            Input.Name = "Input"
            Input.BackgroundTransparency = 1
            Input.BorderSizePixel = 0
            Input.Position = UDim2.new(0, 5, 0, 1)
            Input.Size = UDim2.new(1, -10, 1, -2)
            Input.ClipsDescendants = true
            Input.Font = Enum.Font.GothamBold
            Input.Text = value
            Input.PlaceholderText = Placeholder or ""
            Input.PlaceholderColor3 = Color3.fromRGB(155, 190, 220)
            Input.TextColor3 = Color3.fromRGB(245, 252, 255)
            Input.TextSize = 7
            Input.ClearTextOnFocus = false
            Input.TextXAlignment = Enum.TextXAlignment.Center
            Input.TextTruncate = Enum.TextTruncate.AtEnd
            Input.ZIndex = 32
            Input.Parent = InputBg

            Input.FocusLost:Connect(function()
                value = Input.Text
                Callback(value)
            end)

            return {
                SetValue = function(_, newValue)
                    value = tostring(newValue or "")
                    Input.Text = value
                end,
                GetValue = function()
                    return Input.Text
                end,
            }
        end

        function TabData:CreateDropdown(DropdownName, Options, Default, Callback)
            -- Normalize legacy dropdown formats to a dense array of display values.
            local normalized = {}
            if type(Options) == "table" then
                for _, option in ipairs(Options) do
                    if type(option) == "table" then
                        local value = option.Value
                        if value == nil then value = option.Name end
                        if value == nil then value = option.Title end
                        if value ~= nil then table.insert(normalized, value) end
                    elseif option ~= nil then
                        table.insert(normalized, option)
                    end
                end
                if #normalized == 0 then
                    for key, option in pairs(Options) do
                        if type(option) == "table" then
                            local value = option.Value or option.Name or option.Title or key
                            table.insert(normalized, value)
                        elseif type(key) == "number" then
                            table.insert(normalized, option)
                        else
                            table.insert(normalized, option == true and key or option)
                        end
                    end
                end
            end
            Options = normalized
            Callback = type(Callback) == "function" and Callback or function() end
            local selected = Default
            if type(selected) == "table" then selected = selected.Value or selected.Name or selected[1] end
            local hasDefault = false
            for _, option in ipairs(Options) do
                if option == selected then hasDefault = true break end
            end
            if not hasDefault then selected = Options[1] end
            local open = false

            local Holder = Instance.new("Frame")
            Holder.Name = DropdownName .. "_Dropdown"
            Holder.BackgroundTransparency = 1
            Holder.Size = UDim2.new(1, 0, 0, 28)
            Holder.ZIndex = 30
            Holder.Parent = GetItemParent()

            local Button = Instance.new("ImageButton")
            Button.Name = "DropdownButton"
            SetLocalImage(Button, "popup/header_frame_center.png")
            Button.BackgroundTransparency = 1
            Button.AutoButtonColor = false
            -- Shape dropdown tetap di dalam slot agar tidak menembus bingkai panel,
            -- termasuk saat halaman fitur digulir.
            Button.Position = UDim2.new(0, 0, 0, 0)
            Button.Size = UDim2.new(1, 0, 0, 28)
            Button.ScaleType = Enum.ScaleType.Stretch
            Button.ZIndex = 31
            Button.Parent = Holder

            local Arrow = Instance.new("ImageLabel")
            Arrow.Name = "DropdownArrow"
            SetLocalImage(Arrow, "popup/arrow_down.png")
            Arrow.BackgroundTransparency = 1
            Arrow.AnchorPoint = Vector2.new(1, 0.5)
            Arrow.Position = UDim2.new(1, -10, 0.5, 0)
            Arrow.Size = UDim2.fromOffset(12, 12)
            Arrow.ScaleType = Enum.ScaleType.Fit
            Arrow.ZIndex = 33
            Arrow.Parent = Button

            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 14, 0, 0)
            Label.Size = UDim2.new(0.50, -14, 1, 0)
            Label.Font = Enum.Font.GothamBold
            Label.Text = DropdownName
            Label.TextColor3 = Color3.fromRGB(245, 252, 255)
            Label.TextSize = 9
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 32
            Label.Parent = Button

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.BackgroundTransparency = 1
            -- Sisakan ruang kanan untuk icon panah yang sudah menyatu di asset.
            ValueLabel.Position = UDim2.new(0.50, 0, 0, 0)
            ValueLabel.Size = UDim2.new(0.34, -10, 1, 0)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.Text = tostring(selected or "-")
            ValueLabel.TextColor3 = Color3.fromRGB(225, 242, 255)
            ValueLabel.TextSize = 9
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.ZIndex = 32
            ValueLabel.Parent = Button

            local OPTION_ROW_HEIGHT = 25
            -- Popup ringkas seperti referensi: batasi jumlah baris yang terlihat.
            local listHeight = math.min(224, math.max(112, math.min(#Options, 7) * OPTION_ROW_HEIGHT + 8))
            local dropdownPanelWidth = 190

            -- Clipping layer keeps the expanded dropdown strictly inside the
            -- visible feature/frame area without resizing the dropdown itself.
            -- Lapisan klik di seluruh layar: klik di luar dropdown akan menutupnya.
            -- ZIndex berada di bawah DropdownClip agar opsi tetap bisa dipilih.
            local OutsideClick = Instance.new("TextButton")
            OutsideClick.Name = "DropdownOutsideClick_" .. tostring(DropdownName)
            OutsideClick.Text = ""
            OutsideClick.AutoButtonColor = false
            OutsideClick.BackgroundTransparency = 1
            OutsideClick.BorderSizePixel = 0
            OutsideClick.Size = UDim2.fromScale(1, 1)
            OutsideClick.Position = UDim2.fromScale(0, 0)
            OutsideClick.ZIndex = 198
            OutsideClick.Visible = false
            OutsideClick.Active = true
            OutsideClick.Parent = ScreenGui

            local pageScrollWasEnabled = true

            local DropdownClip = Instance.new("Frame")
            DropdownClip.Name = "DropdownClip_" .. tostring(DropdownName)
            DropdownClip.BackgroundTransparency = 1
            DropdownClip.BorderSizePixel = 0
            DropdownClip.ClipsDescendants = true
            DropdownClip.ZIndex = 199
            DropdownClip.Visible = false
            DropdownClip.Parent = ScreenGui

            local ListPanel = Instance.new("ImageLabel")
            ListPanel.Name = "ExpandedPanel"
            SetLocalImage(ListPanel, "popup/dropdown_main_panel.png")
            ListPanel.BackgroundTransparency = 1
            ListPanel.Position = UDim2.new(0, 0, 0, 0)
            ListPanel.Size = UDim2.new(1, 0, 0, listHeight + 48)
            ListPanel.ScaleType = Enum.ScaleType.Stretch
            ListPanel.ZIndex = 200
            ListPanel.Visible = false
            -- Panel berada dalam clipping layer: ukuran aslinya tetap, namun bagian
            -- yang melewati bingkai bawah tidak akan dirender.
            ListPanel.Parent = DropdownClip

            local List = Instance.new("ScrollingFrame")
            List.Name = "Options"
            List.BackgroundTransparency = 1
            List.BorderSizePixel = 0
            List.Position = UDim2.new(0, 5, 0, 46)
            List.Size = UDim2.new(1, -10, 1, -54)
            List.CanvasSize = UDim2.new(0, 0, 0, #Options * OPTION_ROW_HEIGHT)
            List.ScrollBarThickness = 0
            List.ScrollBarImageTransparency = 1
            List.ScrollingDirection = Enum.ScrollingDirection.Y
            List.ZIndex = 201
            List.ClipsDescendants = true
            List.Parent = ListPanel

            local ScrollThumb = Instance.new("ImageLabel")
            ScrollThumb.Name = "DropdownScrollbarThumb"
            SetLocalImage(ScrollThumb, "popup/scrollbar_thumb.png")
            ScrollThumb.BackgroundTransparency = 1
            ScrollThumb.AnchorPoint = Vector2.new(1, 0)
            ScrollThumb.Position = UDim2.new(1, -5, 0, 50)
            ScrollThumb.Size = UDim2.new(0, 5, 0, math.max(18, (listHeight - 54) * math.min(1, (listHeight - 54) / math.max(1, #Options * OPTION_ROW_HEIGHT))))
            ScrollThumb.ScaleType = Enum.ScaleType.Stretch
            ScrollThumb.ZIndex = 205
            ScrollThumb.Visible = #Options * OPTION_ROW_HEIGHT > listHeight
            ScrollThumb.Parent = ListPanel

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 0)
            ListLayout.Parent = List

            -- Bingkai pencarian agar kolom tidak tampak polos/kecil.
            local SearchBackground = Instance.new("ImageLabel")
            SearchBackground.Name = "DropdownSearchBackground"
            SetLocalImage(SearchBackground, "popup/option_normal_01.png")
            SearchBackground.BackgroundTransparency = 1
            SearchBackground.Position = UDim2.new(0, 7, 0, 5)
            SearchBackground.Size = UDim2.new(1, -14, 0, 34)
            SearchBackground.ScaleType = Enum.ScaleType.Stretch
            SearchBackground.ZIndex = 202
            SearchBackground.Parent = ListPanel

            -- Search field for dropdown options, using the requested Arexans search asset.
            local SearchBox = Instance.new("TextBox")
            SearchBox.Name = "DropdownSearch"
            SearchBox.BackgroundTransparency = 1
            SearchBox.ClearTextOnFocus = false
            SearchBox.PlaceholderText = "Cari opsi..."
            SearchBox.Text = ""
            SearchBox.Font = Enum.Font.Gotham
            SearchBox.TextSize = 15
            SearchBox.TextColor3 = Color3.fromRGB(235, 246, 255)
            SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 190, 225)
            SearchBox.TextXAlignment = Enum.TextXAlignment.Left
            SearchBox.Position = UDim2.new(0, 48, 0, 6)
            SearchBox.Size = UDim2.new(1, -60, 0, 30)
            SearchBox.TextTruncate = Enum.TextTruncate.AtEnd
            SearchBox.ZIndex = 203
            SearchBox.Parent = ListPanel

            local SearchIcon = Instance.new("ImageLabel")
            SearchIcon.Name = "SearchIcon"
            SearchIcon.BackgroundTransparency = 1
            SetLocalImage(SearchIcon, "popup/search_icon.png")
            SearchIcon.Position = UDim2.new(0, 23, 0, 14)
            SearchIcon.Size = UDim2.fromOffset(15, 15)
            SearchIcon.ScaleType = Enum.ScaleType.Fit
            SearchIcon.ZIndex = 204
            SearchIcon.Parent = ListPanel

            local optionEntries = {}
            local EmptyLabel = Instance.new("TextLabel")
            EmptyLabel.Name = "DropdownEmptyState"
            EmptyLabel.BackgroundTransparency = 1
            EmptyLabel.Position = UDim2.new(0, 12, 0, 58)
            EmptyLabel.Size = UDim2.new(1, -24, 0, 36)
            EmptyLabel.Font = Enum.Font.Gotham
            EmptyLabel.Text = #Options == 0 and "Tidak ada opsi tersedia" or "Opsi tidak ditemukan"
            EmptyLabel.TextColor3 = Color3.fromRGB(175, 210, 240)
            EmptyLabel.TextSize = 13
            EmptyLabel.TextWrapped = true
            EmptyLabel.ZIndex = 204
            EmptyLabel.Visible = #Options == 0
            EmptyLabel.Parent = ListPanel
            local function ApplyOptionSearch()
                local query = string.lower(tostring(SearchBox.Text or ""))
                local visibleCount = 0
                for _, entry in ipairs(optionEntries) do
                    local matches = query == "" or string.find(string.lower(tostring(entry.Value)), query, 1, true) ~= nil
                    entry.Background.Visible = matches
                    entry.Button.Visible = matches
                    if matches then
                        entry.Background.LayoutOrder = visibleCount
                        visibleCount = visibleCount + 1
                    end
                end
                List.CanvasSize = UDim2.new(0, 0, 0, visibleCount * OPTION_ROW_HEIGHT)
                EmptyLabel.Visible = visibleCount == 0
                EmptyLabel.Text = #Options == 0 and "Tidak ada opsi tersedia" or "Opsi tidak ditemukan"
            end
            SearchBox:GetPropertyChangedSignal("Text"):Connect(ApplyOptionSearch)

            local RunService = game:GetService("RunService")
            local followConnection
            local lockedPanelPosition = nil

            local function CloseList()
                open = false
                lockedPanelPosition = nil
                ListPanel.Visible = false
                DropdownClip.Visible = false
                OutsideClick.Visible = false
                -- Kembalikan scroll halaman setelah dropdown ditutup.
                if Page and Page.Parent then
                    Page.ScrollingEnabled = pageScrollWasEnabled
                end
                Button.ImageTransparency = 0
                Arrow.Visible = true
                Label.Visible = true
                ValueLabel.Visible = true
                Button.ZIndex = 31
                Label.ZIndex = 32
                ValueLabel.ZIndex = 32
                if followConnection then
                    followConnection:Disconnect()
                    followConnection = nil
                end
            end

            -- Update posisi setiap frame. Dropdown after menggantikan before
            -- pada koordinat tombol yang sama, dan clip layer menjaga panel tetap
            -- di dalam frame tanpa mengecilkan ukuran panel ketika halaman discroll.
            local function UpdateDropdownPosition()
                if not open or not Holder.Parent or not Page.Visible then
                    return false
                end

                local boundsPosition = PageContainer.AbsolutePosition
                local boundsSize = PageContainer.AbsoluteSize
                local rootPosition = WindowRoot.AbsolutePosition
                local rootSize = WindowRoot.AbsoluteSize
                -- ScreenGui coordinates start at the viewport origin; ScreenGui
                -- does not provide a reliable AbsolutePosition across executors.
                local screenPosition = Vector2.new(0, 0)
                local buttonPosition = Button.AbsolutePosition
                local buttonSize = Button.AbsoluteSize

                local contentLeft = math.max(boundsPosition.X + 4, rootPosition.X + 4)
                local contentRight = math.min(boundsPosition.X + boundsSize.X - 4, rootPosition.X + rootSize.X - 4)
                local contentTop = math.max(boundsPosition.Y + 4, rootPosition.Y + 4)
                local contentBottom = math.min(boundsPosition.Y + boundsSize.Y - 4, rootPosition.Y + rootSize.Y - 4)
                local clipWidth = math.max(0, contentRight - contentLeft)
                local clipHeight = math.max(0, contentBottom - contentTop)

                if clipWidth <= 0 or clipHeight <= 0
                    or buttonPosition.Y + buttonSize.Y < contentTop
                    or buttonPosition.Y > contentBottom
                    or buttonPosition.X + buttonSize.X < contentLeft
                    or buttonPosition.X > contentRight then
                    DropdownClip.Visible = false
                    return true
                end

                DropdownClip.Position = UDim2.fromOffset(contentLeft - screenPosition.X, contentTop - screenPosition.Y)
                DropdownClip.Size = UDim2.fromOffset(clipWidth, clipHeight)
                DropdownClip.Visible = true

                -- Popup ringkas: sisi kiri/kanan ditentukan dari kolom kontrol yang dibuka.
                -- Dropdown pada kolom kiri membuka panel di kiri; kolom kanan membuka di kanan.
                local panelWidth = math.min(dropdownPanelWidth, math.max(150, clipWidth - 16))
                local panelHeight = math.min(listHeight + 48, math.max(132, clipHeight - 12))
                local buttonCenterX = buttonPosition.X + buttonSize.X * 0.5
                local rootCenterX = rootPosition.X + rootSize.X * 0.5
                local isLeftDropdown = buttonCenterX < rootCenterX
                local panelX
                if isLeftDropdown then
                    panelX = contentLeft + 8
                else
                    panelX = contentRight - panelWidth - 8
                end
                panelX = math.clamp(panelX, contentLeft + 4, math.max(contentLeft + 4, contentRight - panelWidth - 4))
                local panelY = math.clamp(rootPosition.Y + math.floor((rootSize.Y - panelHeight) * 0.50), contentTop + 4, math.max(contentTop + 4, contentBottom - panelHeight - 4))
                lockedPanelPosition = UDim2.fromOffset(panelX - contentLeft, panelY - contentTop)
                ListPanel.Position = lockedPanelPosition
                ListPanel.Size = UDim2.fromOffset(panelWidth, panelHeight)
                List.Position = UDim2.new(0, 5, 0, 42)
                -- Sisakan inset bawah yang konsisten untuk bingkai panel.
                -- ClipsDescendants pada List dan DropdownClip mencegah baris terakhir
                -- terlihat keluar saat daftar opsi digulir.
                List.Size = UDim2.new(1, -10, 1, -58)
                ScrollThumb.Position = UDim2.new(1, -5, 0, 46)
                ScrollThumb.Size = UDim2.new(0, 5, 0, math.max(18, (panelHeight - 62) * math.min(1, (panelHeight - 62) / math.max(1, #Options * OPTION_ROW_HEIGHT))))
                ScrollThumb.Visible = #Options * OPTION_ROW_HEIGHT > panelHeight - 62
                ListPanel.Visible = true
                return true
            end

            for index, option in ipairs(Options) do
                local OptionBg = Instance.new("ImageLabel")
                OptionBg.Name = "OptionBg_" .. index
                SetLocalImage(OptionBg, option == selected and "popup/option_selected.png" or "popup/option_normal_01.png")
                OptionBg.BackgroundTransparency = 1
                OptionBg.Size = UDim2.new(1, -4, 0, OPTION_ROW_HEIGHT)
                OptionBg.Position = UDim2.new(0, 2, 0, 0)
                OptionBg.ScaleType = Enum.ScaleType.Stretch
                OptionBg.ZIndex = 202
                OptionBg.Parent = List

                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = "Option_" .. index
                OptionButton.BackgroundTransparency = 1
                OptionButton.BorderSizePixel = 0
                OptionButton.AutoButtonColor = false
                OptionButton.Size = UDim2.fromScale(1, 1)
                OptionButton.Position = UDim2.fromScale(0, 0)
                OptionButton.Font = Enum.Font.GothamBold
                OptionButton.Text = tostring(option)
                OptionButton.TextColor3 = Color3.fromRGB(235, 246, 255)
                OptionButton.TextSize = 12
                OptionButton.TextXAlignment = Enum.TextXAlignment.Center
                OptionButton.ZIndex = 203
                OptionButton.Parent = OptionBg
                table.insert(optionEntries, {Background = OptionBg, Button = OptionButton, Value = option})

                OptionButton.MouseEnter:Connect(function()
                    OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptionBg.ImageColor3 = Color3.fromRGB(200, 200, 200)
                end)
                OptionButton.MouseLeave:Connect(function()
                    OptionButton.TextColor3 = Color3.fromRGB(235, 246, 255)
                    OptionBg.ImageColor3 = Color3.fromRGB(255, 255, 255)
                end)
                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    for _, entry in ipairs(optionEntries) do
                        entry.SetLocalImage(Background, entry.Value == selected and "popup/option_selected.png" or "popup/option_normal_01.png")
                    end
                    ValueLabel.Text = tostring(option)
                    CloseList()
                    local ok, err = pcall(Callback, option)
                    if not ok then warn("[ArexansUI Dropdown] callback failed: " .. tostring(err)) end
                end)
            end

            OutsideClick.MouseButton1Click:Connect(function()
                if open then CloseList() end
            end)

            Button.MouseButton1Click:Connect(function()
                if open then
                    CloseList()
                    return
                end
                open = true
                -- Kunci scroll halaman fitur selama dropdown terbuka; daftar opsi
                -- tetap bisa discroll karena memiliki ScrollingFrame sendiri.
                pageScrollWasEnabled = Page.ScrollingEnabled
                Page.ScrollingEnabled = false
                OutsideClick.Visible = true

                -- Reset query whenever the dropdown opens so every option is available.
                SearchBox.Text = ""
                ApplyOptionSearch()

                -- Sembunyikan asset kontrol dan seluruh anaknya ketika panel terbuka
                -- supaya shape/header/teks tidak terlihat dobel di bawah popup.
                Button.ImageTransparency = 1
                Arrow.Visible = false
                Label.Visible = false
                ValueLabel.Visible = false

                -- Dropdown tetap berada DI DALAM area Page.
                Button.ZIndex = 31
                Label.ZIndex = 32
                ValueLabel.ZIndex = 32

                task.defer(function()
                    if not Page.Visible or not Holder.Parent then
                        CloseList()
                        return
                    end

                    DropdownClip.Visible = true
                    ListPanel.Visible = true
                    UpdateDropdownPosition()
                    if followConnection then
                        followConnection:Disconnect()
                    end
                    followConnection = RunService.RenderStepped:Connect(function()
                        if not open then
                            if followConnection then
                                followConnection:Disconnect()
                                followConnection = nil
                            end
                            return
                        end
                        if not UpdateDropdownPosition() then
                            CloseList()
                        end
                    end)
                end)
            end)

            return {
                SetValue = function(_, newValue)
                    for _, option in ipairs(Options) do
                        if option == newValue then
                            selected = option
                            ValueLabel.Text = tostring(option)
                            for _, entry in ipairs(optionEntries) do
                                entry.SetLocalImage(Background, entry.Value == selected and "popup/option_selected.png" or "popup/option_normal_01.png")
                            end
                            local ok, err = pcall(Callback, option)
                            if not ok then warn("[ArexansUI Dropdown] callback failed: " .. tostring(err)) end
                            return true
                        end
                    end
                    return false
                end,
                GetValue = function()
                    return selected
                end,
            }
        end

        function TabData:CreateButton(ButtonName, Callback)
            Callback = Callback or function() end

            local Button = Instance.new("ImageButton")
            Button.Name = ButtonName .. "_Button"
            SetLocalImage(Button, "button.png")
            Button.BackgroundTransparency = 1
            Button.AutoButtonColor = false
            Button.Size = UDim2.new(1, 0, 0, 28)
            Button.ScaleType = Enum.ScaleType.Stretch
            Button.ZIndex = 30
            Button.Parent = GetItemParent()

            local Text = Instance.new("TextLabel")
            Text.BackgroundTransparency = 1
            Text.Size = UDim2.new(1, 0, 1, 0)
            Text.Font = Enum.Font.GothamBold
            Text.Text = ButtonName
            Text.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextSize = 9
            Text.ZIndex = 31
            Text.Parent = Button

            Button.MouseEnter:Connect(function()
                SetLocalImage(Button, "button_selected.png")
            end)

            Button.MouseLeave:Connect(function()
                SetLocalImage(Button, "button.png")
            end)

            Button.MouseButton1Down:Connect(function()
                SetLocalImage(Button, "button_selected.png")
            end)

            Button.MouseButton1Up:Connect(function()
                SetLocalImage(Button, "button.png")
            end)

            Button.MouseButton1Click:Connect(Callback)
            return Button
        end

        function TabData:CreateToggle(ToggleName, Default, Callback)
            local State = Default or false
            Callback = Callback or function() end

            -- Background Toggle
            local ToggleBg = Instance.new("ImageButton")
            ToggleBg.Name = ToggleName .. "_Toggle"
            ToggleBg.Image = State and GetLocalAsset("electric_compact_left.png") or GetLocalAsset("dark_compact_left.png")
            ToggleBg.BackgroundColor3 = State and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(30, 30, 30) -- Fallback
            ToggleBg.BackgroundTransparency = 1
            ToggleBg.AutoButtonColor = false
            ToggleBg.Size = UDim2.new(1, 0, 0, 28) 
            ToggleBg.ZIndex = 10
            ToggleBg.Parent = GetItemParent()

            -- Teks Toggle
            local ToggleText = Instance.new("TextLabel")
            ToggleText.BackgroundTransparency = 1
            ToggleText.Position = UDim2.new(0, 11, 0, 0)
            ToggleText.Size = UDim2.new(0.70, -8, 1, 0)
            ToggleText.Font = Enum.Font.GothamBold
            ToggleText.Text = ToggleName
            ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left
            ToggleText.TextSize = 10
            ToggleText.ZIndex = 11
            ToggleText.Parent = ToggleBg

            -- Indikator On/Off Knob
            local ToggleKnob = Instance.new("ImageLabel")
            ToggleKnob.Name = "Knob"
            ToggleKnob.Image = State and GetLocalAsset("on.png") or GetLocalAsset("off.png")
            ToggleKnob.BackgroundColor3 = State and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150) -- Fallback
            ToggleKnob.BackgroundTransparency = 1
            ToggleKnob.AnchorPoint = Vector2.new(1, 0.5)
            ToggleKnob.Position = UDim2.new(1, -8, 0.5, 0)
            ToggleKnob.Size = UDim2.new(0, 29, 0, 15)
            ToggleKnob.ZIndex = 11
            ToggleKnob.Parent = ToggleBg

            local function UpdateState(isInit, forcedState)
                if forcedState ~= nil then
                    State = forcedState == true
                elseif not isInit then
                    State = not State
                end
                if State then
                    SetLocalImage(ToggleBg, "electric_compact_left.png")
                    ToggleBg.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                    SetLocalImage(ToggleKnob, "on.png")
                    ToggleKnob.Size = UDim2.new(0, 29, 0, 15)
                    ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                else
                    SetLocalImage(ToggleBg, "dark_compact_left.png")
                    ToggleBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    SetLocalImage(ToggleKnob, "off.png")
                    ToggleKnob.Size = UDim2.new(0, 29, 0, 15)
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

            -- Return a handle compatible with the legacy vd_v2 script.
            local handle = { Value = State }
            function handle:Set(value)
                UpdateState(true, value == true)
                self.Value = State
                Callback(State)
            end
            function handle:SetValue(value)
                self:Set(value)
            end
            function handle:GetValue()
                return State
            end
            return setmetatable(handle, {
                __index = function(_, key)
                    if key == "Value" then return State end
                end,
                __newindex = function(t, key, value)
                    if key == "Value" then
                        UpdateState(true, value == true)
                    else
                        rawset(t, key, value)
                    end
                end,
            })
        end

        -- Compact text/section helper so long pages can be organized without
        -- creating large empty gaps in the two-column grid.
        function TabData:CreateLabel(TextValue)
            local Label = Instance.new("TextLabel")
            Label.Name = "Label_" .. tostring(TextValue):gsub("%s+", "_")
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 22)
            Label.Font = Enum.Font.GothamBold
            Label.Text = tostring(TextValue or "")
            Label.TextColor3 = Color3.fromRGB(210, 235, 255)
            Label.TextSize = 9
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextYAlignment = Enum.TextYAlignment.Center
            Label.ZIndex = 30
            Label.Parent = GetItemParent()
            return Label
        end

        -- ======================================================================
        -- COLOR PICKER: saturation/value square + hue strip, both asset-backed.
        -- Callback receives a Roblox Color3 value.
        -- ======================================================================
        function TabData:CreateColorPicker(PickerName, DefaultColor, Callback)
            Callback = Callback or function() end
            local initial = typeof(DefaultColor) == "Color3" and DefaultColor or Color3.fromRGB(35, 170, 255)
            local h, sat, val = Color3.toHSV(initial)
            local draggingSV, draggingHue = false, false

            local slot = GetItemParent(104)
            local panel = Instance.new("Frame")
            panel.Name = tostring(PickerName or "Color") .. "_ColorPicker"
            panel.Size = UDim2.new(1, 0, 0, 100)
            panel.BackgroundColor3 = Color3.fromRGB(5, 28, 66)
            panel.BackgroundTransparency = 0.14
            panel.BorderSizePixel = 0
            panel.ZIndex = 35
            panel.Parent = slot
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = panel
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(35, 170, 255)
            stroke.Thickness = 1
            stroke.Transparency = 0.2
            stroke.Parent = panel

            local title = Instance.new("TextLabel")
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 8, 0, 2)
            title.Size = UDim2.new(1, -16, 0, 16)
            title.Font = Enum.Font.GothamBold
            title.Text = tostring(PickerName or "Color")
            title.TextColor3 = Color3.fromRGB(235, 248, 255)
            title.TextSize = 9
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.ZIndex = 37
            title.Parent = panel

            local sv = Instance.new("ImageLabel")
            sv.Name = "SaturationValue"
            SetLocalImage(sv, "saturation_value_gradient.png")
            sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            sv.Position = UDim2.new(0, 8, 0, 20)
            sv.Size = UDim2.new(1, -16, 0, 51)
            sv.BorderSizePixel = 0
            sv.ZIndex = 37
            sv.Parent = panel
            local svCorner = Instance.new("UICorner")
            svCorner.CornerRadius = UDim.new(0, 5)
            svCorner.Parent = sv

            local svMarker = Instance.new("Frame")
            svMarker.Name = "Selector"
            svMarker.AnchorPoint = Vector2.new(0.5, 0.5)
            svMarker.Size = UDim2.fromOffset(8, 8)
            svMarker.Position = UDim2.new(sat, 0, 1 - val, 0)
            svMarker.BackgroundColor3 = Color3.new(1, 1, 1)
            svMarker.BorderSizePixel = 0
            svMarker.ZIndex = 39
            svMarker.Parent = sv
            local markerCorner = Instance.new("UICorner")
            markerCorner.CornerRadius = UDim.new(1, 0)
            markerCorner.Parent = svMarker
            local markerStroke = Instance.new("UIStroke")
            markerStroke.Color = Color3.fromRGB(0, 25, 55)
            markerStroke.Thickness = 1
            markerStroke.Parent = svMarker

            local hueBar = Instance.new("ImageLabel")
            hueBar.Name = "Hue"
            SetLocalImage(hueBar, "hue_gradient.png")
            hueBar.BackgroundTransparency = 1
            hueBar.Position = UDim2.new(0, 8, 0, 76)
            hueBar.Size = UDim2.new(1, -16, 0, 10)
            hueBar.BorderSizePixel = 0
            hueBar.ZIndex = 37
            hueBar.Parent = panel
            local hueCorner = Instance.new("UICorner")
            hueCorner.CornerRadius = UDim.new(0, 4)
            hueCorner.Parent = hueBar
            local hueMarker = Instance.new("Frame")
            hueMarker.Name = "HueSelector"
            hueMarker.AnchorPoint = Vector2.new(0.5, 0.5)
            hueMarker.Size = UDim2.new(0, 5, 1, 4)
            hueMarker.Position = UDim2.new(h, 0, 0.5, 0)
            hueMarker.BackgroundColor3 = Color3.new(1, 1, 1)
            hueMarker.BorderSizePixel = 0
            hueMarker.ZIndex = 39
            hueMarker.Parent = hueBar

            local preview = Instance.new("Frame")
            preview.Name = "ColorPreview"
            preview.AnchorPoint = Vector2.new(1, 0)
            preview.Position = UDim2.new(1, -8, 0, 2)
            preview.Size = UDim2.fromOffset(12, 12)
            preview.BackgroundColor3 = initial
            preview.BorderSizePixel = 0
            preview.ZIndex = 38
            preview.Parent = panel
            local previewCorner = Instance.new("UICorner")
            previewCorner.CornerRadius = UDim.new(1, 0)
            previewCorner.Parent = preview

            local function updateColor()
                sat = math.clamp(sat, 0, 1)
                val = math.clamp(val, 0, 1)
                h = math.clamp(h, 0, 1)
                sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svMarker.Position = UDim2.new(sat, 0, 1 - val, 0)
                hueMarker.Position = UDim2.new(h, 0, 0.5, 0)
                local color = Color3.fromHSV(h, sat, val)
                preview.BackgroundColor3 = color
                Callback(color)
            end
            local function updateSV(input)
                local x = math.clamp((input.Position.X - sv.AbsolutePosition.X) / math.max(1, sv.AbsoluteSize.X), 0, 1)
                local y = math.clamp((input.Position.Y - sv.AbsolutePosition.Y) / math.max(1, sv.AbsoluteSize.Y), 0, 1)
                sat, val = x, 1 - y
                updateColor()
            end
            local function updateHue(input)
                h = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / math.max(1, hueBar.AbsoluteSize.X), 0, 1)
                updateColor()
            end
            sv.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSV = true
                    updateSV(input)
                end
            end)
            hueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = true
                    updateHue(input)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if draggingSV and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSV(input) end
                if draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateHue(input) end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSV, draggingHue = false, false
                end
            end)
            return {
                SetValue = function(_, color)
                    if typeof(color) == "Color3" then h, sat, val = Color3.toHSV(color); updateColor() end
                end,
                GetValue = function() return Color3.fromHSV(h, sat, val) end,
            }
        end

        -- ==========================================================================
        -- CARD COMPONENTS
        -- Semua card memakai asset library agar konsisten dengan frame utama.
        -- ==========================================================================

        function TabData:CreateCard(CardTitle, CardSubtitle, IconPath, BodyText, Options)
            Options = Options or {}
            local CardHeight = tonumber(Options.Height) or 70
            local CardWidthMode = Options.FullWidth and 1 or 0.5

            local slot = GetItemParent()
            local Card = Instance.new("ImageLabel")
            Card.Name = "Card_" .. tostring(CardTitle):gsub("%s+", "_")
            SetLocalImage(Card, Options.Asset or "containers/panel.png")
            Card.BackgroundTransparency = 1
            Card.Size = UDim2.new(CardWidthMode, CardWidthMode == 1 and 0 or -1, 0, CardHeight)
            Card.ScaleType = Enum.ScaleType.Stretch
            Card.ZIndex = 35
            Card.Parent = slot

            if IconPath then
                -- Badge shape behind every card icon for better contrast.
                local IconBadge = Instance.new("Frame")
                IconBadge.Name = "IconBackgroundShape"
                IconBadge.Position = UDim2.new(0, 7, 0, 7)
                IconBadge.Size = UDim2.new(0, 31, 0, 31)
                IconBadge.BackgroundColor3 = Color3.fromRGB(4, 35, 78)
                IconBadge.BackgroundTransparency = 0.12
                IconBadge.BorderSizePixel = 0
                IconBadge.ZIndex = 36
                IconBadge.Parent = Card
                local BadgeCorner = Instance.new("UICorner")
                BadgeCorner.CornerRadius = UDim.new(0, 9)
                BadgeCorner.Parent = IconBadge
                local BadgeStroke = Instance.new("UIStroke")
                BadgeStroke.Thickness = 1
                BadgeStroke.Color = Color3.fromRGB(35, 190, 255)
                BadgeStroke.Transparency = 0.12
                BadgeStroke.Parent = IconBadge

                local Icon = Instance.new("ImageLabel")
                Icon.Name = "Icon"
                SetLocalImage(Icon, IconPath)
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0, 9, 0, 9)
                Icon.Size = UDim2.new(0, 27, 0, 27)
                Icon.ScaleType = Enum.ScaleType.Fit
                Icon.ZIndex = 37
                Icon.Parent = Card
            end

            local Title = Instance.new("TextLabel")
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, IconPath and 42 or 10, 0, 7)
            Title.Size = UDim2.new(1, -(IconPath and 50 or 20), 0, 16)
            Title.Font = Enum.Font.GothamBold
            Title.Text = tostring(CardTitle or "Card")
            Title.TextColor3 = Color3.fromRGB(245, 252, 255)
            Title.TextSize = 9
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.TextTruncate = Enum.TextTruncate.AtEnd
            Title.ZIndex = 37
            Title.Parent = Card

            local Subtitle = Instance.new("TextLabel")
            Subtitle.BackgroundTransparency = 1
            Subtitle.Position = UDim2.new(0, IconPath and 42 or 10, 0, 24)
            Subtitle.Size = UDim2.new(1, -(IconPath and 50 or 20), 0, 14)
            Subtitle.Font = Enum.Font.Gotham
            Subtitle.Text = tostring(CardSubtitle or "")
            Subtitle.TextColor3 = Color3.fromRGB(160, 205, 235)
            Subtitle.TextSize = 7
            Subtitle.TextXAlignment = Enum.TextXAlignment.Left
            Subtitle.TextTruncate = Enum.TextTruncate.AtEnd
            Subtitle.ZIndex = 37
            Subtitle.Parent = Card

            local Body = Instance.new("TextLabel")
            Body.Name = "Body"
            Body.BackgroundTransparency = 1
            Body.Position = UDim2.new(0, 10, 0, 40)
            Body.Size = UDim2.new(1, -20, 1, -46)
            Body.Font = Enum.Font.Gotham
            Body.Text = tostring(BodyText or "")
            Body.TextColor3 = Color3.fromRGB(225, 242, 255)
            Body.TextSize = 7
            Body.TextWrapped = true
            Body.TextXAlignment = Enum.TextXAlignment.Left
            Body.TextYAlignment = Enum.TextYAlignment.Top
            Body.ZIndex = 37
            Body.Parent = Card

            return {
                Frame = Card,
                Title = Title,
                Subtitle = Subtitle,
                Body = Body,
                SetBody = function(_, value)
                    Body.Text = tostring(value or "")
                end,
                SetSubtitle = function(_, value)
                    Subtitle.Text = tostring(value or "")
                end,
            }
        end

        function TabData:CreateProfileCard()
            local card = self:CreateCard(
                "PROFILE",
                "Roblox account • realtime",
                "icons/user_crown.png",
                "Loading profile...",
                {Asset = "containers/panel.png", Height = 88}
            )

            local Avatar = Instance.new("ImageLabel")
            Avatar.Name = "Avatar"
            Avatar.BackgroundTransparency = 1
            Avatar.Position = UDim2.new(1, -78, 0, 9)
            Avatar.Size = UDim2.new(0, 56, 0, 56)
            Avatar.ScaleType = Enum.ScaleType.Fit
            Avatar.ZIndex = 38
            Avatar.Parent = card.Frame

            local AvatarFrame = Instance.new("ImageLabel")
            AvatarFrame.Name = "AvatarFrame"
            SetLocalImage(AvatarFrame, "player/avatar_frame.png")
            AvatarFrame.BackgroundTransparency = 1
            AvatarFrame.Position = Avatar.Position
            AvatarFrame.Size = Avatar.Size
            AvatarFrame.ScaleType = Enum.ScaleType.Fit
            AvatarFrame.ZIndex = 39
            AvatarFrame.Parent = card.Frame

            task.spawn(function()
                local ok, content = pcall(function()
                    local image, ready = Players:GetUserThumbnailAsync(
                        LocalPlayer.UserId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size100x100
                    )
                    return image, ready
                end)

                if ok and content then
                    local image = content
                    if typeof(content) == "table" then image = content[1] end
                    if image then Avatar.Image = image end
                end

                local name = LocalPlayer.DisplayName or LocalPlayer.Name
                card.Title.Text = tostring(name)
                card.Subtitle.Text = "@" .. tostring(LocalPlayer.Name)
                card.Body.Text = "UserId: " .. tostring(LocalPlayer.UserId)
            end)

            return card
        end

        function TabData:CreateCameraCard()
            local card = self:CreateCard(
                "CAMERA",
                "Realtime workspace camera",
                "icons/camera_energy.png",
                "Reading camera...",
                {Asset = "containers/panel.png", Height = 88}
            )

            local function UpdateCamera()
                local cam = workspace.CurrentCamera
                if not cam then
                    card.Body.Text = "Camera unavailable"
                    return
                end

                local v = cam.ViewportSize
                local p = cam.CFrame.Position
                card.Body.Text = string.format(
                    "FOV %d°  •  Viewport %dx%d\nPOS %.0f, %.0f, %.0f",
                    math.floor(cam.FieldOfView + 0.5),
                    math.floor(v.X),
                    math.floor(v.Y),
                    p.X, p.Y, p.Z
                )
            end

            task.spawn(function()
                while card.Frame.Parent do
                    UpdateCamera()
                    task.wait(0.25)
                end
            end)

            return card
        end

        function TabData:CreateServerCard()
            local card = self:CreateCard(
                "SERVER",
                "Realtime Roblox server",
                "icons/server_global.png",
                "Reading server...",
                {Asset = "containers/panel.png", Height = 88}
            )

            local function UpdateServer()
                local count = #Players:GetPlayers()
                local maxPlayers = Players.MaxPlayers
                local job = tostring(game.JobId or "")
                if #job > 18 then job = string.sub(job, 1, 18) .. "..." end

                card.Body.Text = string.format(
                    "Players %d/%d\nPlace %s\nJob %s",
                    count,
                    maxPlayers,
                    tostring(game.PlaceId),
                    job ~= "" and job or "Studio/Local"
                )
            end

            task.spawn(function()
                while card.Frame.Parent do
                    UpdateServer()
                    task.wait(0.5)
                end
            end)

            return card
        end

        function TabData:CreateCharacterCard()
            local card = self:CreateCard(
                "CHARACTER",
                "Local player realtime",
                "icons/visibility_eye.png",
                "Reading character...",
                {Asset = "containers/panel.png", Height = 88}
            )

            local function UpdateCharacter()
                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local root = character and character:FindFirstChild("HumanoidRootPart")

                if not humanoid or not root then
                    card.Body.Text = "Character not spawned"
                    return
                end

                local hp = math.floor(humanoid.Health + 0.5)
                local maxHp = math.floor(humanoid.MaxHealth + 0.5)
                local pos = root.Position

                card.Body.Text = string.format(
                    "HP %d/%d  •  WalkSpeed %.0f\nPOS %.0f, %.0f, %.0f",
                    hp, maxHp, humanoid.WalkSpeed,
                    pos.X, pos.Y, pos.Z
                )
            end

            task.spawn(function()
                while card.Frame.Parent do
                    UpdateCharacter()
                    task.wait(0.25)
                end
            end)

            return card
        end

        function TabData:CreateSlider(SliderName, Min, Max, Default, Callback)
            Min = tonumber(Min) or 0
            Max = tonumber(Max) or 100
            if Max <= Min then Max = Min + 1 end
            local value = math.clamp(tonumber(Default) or Min, Min, Max)
            Callback = Callback or function() end

            -- Compact slider: same half-width grid slot as Toggle, in a single row.
            -- Use the Arexans dark compact shape as the background and the existing
            -- electric/progress artwork for the active portion of the slider.
            local Holder = Instance.new("ImageLabel")
            Holder.Name = SliderName .. "_Slider"
            Holder.BackgroundTransparency = 1
            SetLocalImage(Holder, "dark_compact_left.png")
            Holder.ScaleType = Enum.ScaleType.Stretch
            Holder.Size = UDim2.new(1, 0, 1, 0)
            Holder.ZIndex = 30
            Holder.Parent = GetItemParent(28)

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(0.34, -8, 1, 0)
            Title.Font = Enum.Font.GothamBold
            Title.Text = SliderName
            Title.TextColor3 = Color3.fromRGB(240, 250, 255)
            Title.TextSize = 9
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.TextTruncate = Enum.TextTruncate.AtEnd
            Title.ZIndex = 31
            Title.Parent = Holder

            local Value = Instance.new("TextLabel")
            Value.Name = "Value"
            Value.BackgroundTransparency = 1
            Value.AnchorPoint = Vector2.new(1, 0.5)
            Value.Position = UDim2.new(1, -7, 0.5, 0)
            Value.Size = UDim2.new(0.13, 0, 0, 16)
            Value.Font = Enum.Font.GothamBold
            Value.Text = tostring(math.floor(value + 0.5))
            Value.TextColor3 = Color3.fromRGB(225, 242, 255)
            Value.TextSize = 9
            Value.TextXAlignment = Enum.TextXAlignment.Right
            Value.ZIndex = 33
            Value.Parent = Holder

            local Track = Instance.new("Frame")
            Track.Name = "ProgressTrack"
            Track.BackgroundColor3 = Color3.fromRGB(23, 30, 42)
            Track.BackgroundTransparency = 0.1
            Track.BorderSizePixel = 0
            Track.Position = UDim2.new(0.37, 0, 0.5, -3)
            Track.Size = UDim2.new(0.43, 0, 0, 6)
            Track.ZIndex = 31
            Track.Parent = Holder

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Name = "ProgressFill"
            Fill.BackgroundColor3 = Color3.fromRGB(56, 174, 255)
            Fill.BorderSizePixel = 0
            Fill.Size = UDim2.new((value - Min) / (Max - Min), 0, 1, 0)
            Fill.ZIndex = 32
            Fill.Parent = Track

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local Knob = Instance.new("ImageLabel")
            Knob.Name = "SliderKnob"
            Knob.BackgroundTransparency = 1
            SetLocalImage(Knob, "controls/slider_knob.png")
            Knob.AnchorPoint = Vector2.new(0.5, 0.5)
            Knob.Position = UDim2.new((value - Min) / (Max - Min), 0, 0.5, 0)
            Knob.Size = UDim2.new(0, 12, 0, 12)
            Knob.ZIndex = 34
            Knob.Parent = Track

            local function SetSlider(v, fire)
                value = math.clamp(tonumber(v) or value, Min, Max)
                local alpha = (value - Min) / (Max - Min)
                Fill.Size = UDim2.new(alpha, 0, 1, 0)
                Knob.Position = UDim2.new(alpha, 0, 0.5, 0)
                Value.Text = tostring(math.floor(value + 0.5))
                if fire then Callback(value) end
            end

            local draggingSlider = false
            local activeTouch = nil
            local function UpdateFromInput(input)
                local alpha = math.clamp(
                    (input.Position.X - Track.AbsolutePosition.X) / math.max(1, Track.AbsoluteSize.X),
                    0, 1
                )
                SetSlider(Min + (Max - Min) * alpha, true)
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    activeTouch = nil
                    SetLocalImage(Holder, "electric_compact_left.png")
                    UpdateFromInput(input)
                elseif input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    activeTouch = input
                    SetLocalImage(Holder, "electric_compact_left.png")
                    UpdateFromInput(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if not draggingSlider then return end
                if activeTouch and input ~= activeTouch then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then
                    UpdateFromInput(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or (activeTouch and input == activeTouch) then
                    draggingSlider = false
                    activeTouch = nil
                    SetLocalImage(Holder, "dark_compact_left.png")
                end
            end)

            return {
                SetValue = function(_, v) SetSlider(v, true) end,
                GetValue = function() return value end,
            }
        end

        return TabData
    end

    function WindowData:Notify(options)
        options = options or {}
        local title = options.Title or options.Name or "Arexans Tools"
        local content = options.Content or options.Text or ""
        local duration = options.Duration or options.Time or 3

        print("[ArexansUI Notification]: " .. tostring(content))
        ShowNotification(title, content, duration)
    end

    return WindowData
end

-- ==============================================================================
-- ==============================================================================
return ArexansUI
]=]
local __AXS_SOURCE=[=[UserInputService = game:GetService("UserInputService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Players = game:GetService("Players")
RunService = game:GetService("RunService")
CoreGui = game:GetService("CoreGui")
Camera = workspace.CurrentCamera
LocalPlayer = Players.LocalPlayer

if type(getgenv) ~= "function" then
    getgenv = function() return _G end
end

-- ==========================================
-- GLOBAL CONFIG BRIDGES
-- ==========================================
getgenv().SilentAimVeilSettings = getgenv().SilentAimVeilSettings or {}
VeilSettings = getgenv().SilentAimVeilSettings

DefaultVeil = {
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
PistolSettings = getgenv().SilentAimPistolSettings

DefaultPistol = {
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

function GetVeilVal(key, altKey, defaultVal)
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

function GetPistolVal(key, altKey, defaultVal)
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
function SafeGet(parent, childName)
    if parent and typeof(parent) == "Instance" then return parent:FindFirstChild(childName) end
    return nil
end

function IsKiller(player)
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

function IsSurvivor(player)
    if not player then return false end
    if player.Team and player.Team.Name then
        local tName = string.lower(tostring(player.Team.Name))
        if string.find(tName, "survivor") or string.find(tName, "victim") then return true end
    end
    return not IsKiller(player)
end

function ResolveTargetPart(char, partName)
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
SafeGuiParent = nil
pcall(function() SafeGuiParent = gethui and gethui() end)
if not SafeGuiParent then pcall(function() SafeGuiParent = game:GetService("CoreGui") end) end
if not SafeGuiParent then SafeGuiParent = LocalPlayer:WaitForChild("PlayerGui") end

ESPFolder = SafeGet(SafeGuiParent, "ArexansTerrainESP_UI")
if not ESPFolder then ESPFolder = Instance.new("Folder") ESPFolder.Name = "ArexansTerrainESP_UI" ESPFolder.Parent = SafeGuiParent end

KillerESPFolder_Pistol = SafeGet(SafeGuiParent, "KillerESPFolder_Pistol")
if not KillerESPFolder_Pistol then KillerESPFolder_Pistol = Instance.new("Folder") KillerESPFolder_Pistol.Name = "KillerESPFolder_Pistol" KillerESPFolder_Pistol.Parent = SafeGuiParent end

-- ==========================================
-- HIDENAME SYSTEM (STRICT DETECTION & RESTORABLE)
-- ==========================================
TARGET_NAME = "AREXANS"
TARGET_IMAGE = "rbxassetid://111967366195505"

OriginalUI = setmetatable({}, {__mode = "k"})

function RestoreUI()
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
function FilterPlayerName(text)
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
function IsPlayerAvatarIcon(instance, imageStr)
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

function processTextElement(instance)
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

function processImageElement(instance)
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

function sweepExistingUI()
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

HideNameConnections = {}
function SetupUIListeners()
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

function SetupNameHooks()
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
SpearState = { target = nil, lookVector = nil, velHistory = {} }
defaultColor = Color3.fromRGB(0, 150, 255)
lockedColor = Color3.fromRGB(0, 255, 120)
blockedColor = Color3.fromRGB(255, 50, 50)

SpearVisuals = {}
pcall(function()
    SpearVisuals.FOVCircle = Drawing.new("Circle") SpearVisuals.FOVCircle.Color = defaultColor SpearVisuals.FOVCircle.Thickness = 1.5 SpearVisuals.FOVCircle.Filled = false SpearVisuals.FOVCircle.Transparency = 1 SpearVisuals.FOVCircle.Visible = false
    SpearVisuals.TrackerCircle = Drawing.new("Circle") SpearVisuals.TrackerCircle.Color = lockedColor SpearVisuals.TrackerCircle.Thickness = 2 SpearVisuals.TrackerCircle.Filled = true SpearVisuals.TrackerCircle.Transparency = 0.8 SpearVisuals.TrackerCircle.Visible = false
    SpearVisuals.TrackerLine = Drawing.new("Line") SpearVisuals.TrackerLine.Color = lockedColor SpearVisuals.TrackerLine.Thickness = 1.5 SpearVisuals.TrackerLine.Transparency = 0.7 SpearVisuals.TrackerLine.Visible = false
end)

-- ==========================================
-- SURVIVOR PISTOL STATE & VISUALS
-- ==========================================
isShooting = false
KILLER_MARKER_NAME = "Lookscriptkiller"

tracerStart = Instance.new("Part")
tracerStart.Size = Vector3.new(0.1, 0.1, 0.1) tracerStart.Transparency = 1 tracerStart.Anchored = true tracerStart.CanCollide = false tracerStart.Parent = workspace
tracerEnd = tracerStart:Clone() tracerEnd.Parent = workspace
att0 = Instance.new("Attachment", tracerStart) att1 = Instance.new("Attachment", tracerEnd)
tracerBeam = Instance.new("Beam") tracerBeam.Attachment0 = att0 tracerBeam.Attachment1 = att1 tracerBeam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255)) tracerBeam.Width0 = 0.15 tracerBeam.Width1 = 0.15 tracerBeam.LightEmission = 1 tracerBeam.LightInfluence = 0 tracerBeam.FaceCamera = true tracerBeam.Enabled = false tracerBeam.Parent = tracerStart

PistolFOVCircle = { Visible = false, Position = Vector2.zero, Radius = 0 }
pcall(function()
    if Drawing and type(Drawing.new) == "function" then
        local d = Drawing.new("Circle")
        d.Color = Color3.fromRGB(255, 255, 255)
        d.Thickness = 1.5
        d.Transparency = 0.8
        d.Filled = false
        d.Visible = false
        PistolFOVCircle = d
    end
end)

function GetEquippedGun(rightArm)
    if not rightArm or typeof(rightArm) ~= "Instance" then return nil end
    for _, child in ipairs(rightArm:GetChildren()) do
        if (child:IsA("Model") or child:IsA("BasePart")) and not string.find(child.Name, "Weld") and not string.find(child.Name, "Grip") then
            return child
        end
    end
    return rightArm:FindFirstChildWhichIsA("Model")
end

function GetKillerTarget()
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
connectedShootButtons = {}
function ConnectShootButton(button)
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

function ScanForShootButton()
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
ESPObjects = {}

function createESP(player, folderToUse)
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

function removeESP(player)
    if ESPObjects[player] then
        if ESPObjects[player].Highlight then ESPObjects[player].Highlight:Destroy() end
        if ESPObjects[player].Billboard then ESPObjects[player].Billboard:Destroy() end
        ESPObjects[player] = nil
    end
end

-- ==========================================
-- MATH & UTILS (PARABOLA PHYSICS)
-- ==========================================
function IsVisible(targetPart, originPart)
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

function solvePitch(p, d, dy)
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

function getCharacterVelocity(char)
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
function SetupNamecallHook()
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
activeSlashers = {}
animConns = {}
currentCrouchState = false

function GetCrouchButton()
    local gui = SafeGet(LocalPlayer, "PlayerGui")
    if not gui then return nil end
    local survivorMob = SafeGet(gui, "Survivor-mob")
    if not survivorMob then return nil end
    local controls = SafeGet(survivorMob, "Controls")
    if not controls then return nil end
    return SafeGet(controls, "crouch")
end

function SetCrouchSync(state)
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

function HookSlasherAnimation(character)
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

function UpdateAutoCrouch()
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

function HookNewPlayer(player)
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
ParryATTACK_ANIMS = {
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

function HasDagger()
    local char = LocalPlayer.Character
    if not char then return false end
    return char:FindFirstChild("Parrying Dagger") ~= nil or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Parrying Dagger") ~= nil)
end

function DoAutoParry()
    local parryRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Items") and ReplicatedStorage.Remotes.Items:FindFirstChild("Parrying Dagger") and ReplicatedStorage.Remotes.Items["Parrying Dagger"]:FindFirstChild("parry")
    if parryRemote then
        pcall(function() parryRemote:FireServer() end)
    end
end

ParryAttached = {}
function AttachParrySensor(kChar)
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

AREXANS_PerfClock = {}
function AREXANS_PerfDue(key, interval)
    local now = os.clock()
    local last = AREXANS_PerfClock[key] or 0
    if now - last < interval then return false end
    AREXANS_PerfClock[key] = now
    return true
end

AREXANS_Potato = {
    Active = false,
    Busy = false,
    RestoreBusy = false,
    Connections = {},
    Changed = {},
    NewObjectQueue = {},
    QueueHead = 1,
}

-- Higher throughput than the old 40-object batch, but capped by time.
POTATO_BATCH_SIZE = 700
POTATO_FRAME_BUDGET = 0.0040 -- about 4 ms per work slice
POTATO_MAX_PER_HEARTBEAT = 900

function AREXANS_PotatoSave(obj, prop)
    if not AREXANS_Potato.Changed[obj] then
        AREXANS_Potato.Changed[obj] = {}
    end
    if AREXANS_Potato.Changed[obj][prop] == nil then
        local ok, value = pcall(function() return obj[prop] end)
        if ok then AREXANS_Potato.Changed[obj][prop] = value end
    end
end

function AREXANS_PotatoSet(obj, prop, value)
    if not obj or not obj.Parent then return end
    AREXANS_PotatoSave(obj, prop)
    pcall(function() obj[prop] = value end)
end

function AREXANS_PotatoOptimize(obj)
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

function AREXANS_PotatoForceRenderQuality()
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

function AREXANS_PotatoDisablePostFX()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("PostEffect") then
            AREXANS_PotatoSet(child, "Enabled", false)
        end
    end
end

function AREXANS_PotatoLowLighting()
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

function AREXANS_PotatoLowTerrain()
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    if not Terrain then return end

    -- Critical for Terrain grass/decorations: disable them immediately.
    AREXANS_PotatoSet(Terrain, "Decoration", false)
    AREXANS_PotatoSet(Terrain, "WaterWaveSize", 0)
    AREXANS_PotatoSet(Terrain, "WaterWaveSpeed", 0)
    AREXANS_PotatoSet(Terrain, "WaterReflectance", 0)
    pcall(function() AREXANS_PotatoSet(Terrain, "WaterTransparency", 1) end)
end

function AREXANS_PotatoProcessMap()
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

function AREXANS_PotatoProcessNewObjects()
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

function AREXANS_PotatoStartHandler()
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

function AREXANS_PotatoEnable()
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

function AREXANS_PotatoDisable()
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

-- PERBATASAN
getgenv().SilentAimVeilSettings = getgenv().SilentAimVeilSettings or {}
getgenv().SilentAimPistolSettings = getgenv().SilentAimPistolSettings or {}
getgenv().PREMIUM_KEY = true

-- Cleanup previous execution connections
if getgenv().AXS_Connections then
    for _, conn in pairs(getgenv().AXS_Connections) do
        if conn and typeof(conn) == "RBXScriptConnection" and conn.Connected then
             conn:Disconnect()
        end
    end
end

if getgenv().AXS_Crosshair_UI then
    getgenv().AXS_Crosshair_UI:Destroy()
    getgenv().AXS_Crosshair_UI = nil
end

if getgenv().KeybindConnections then
    for _, conn in pairs(getgenv().KeybindConnections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
end

if getgenv().AXS_FPS_GUI then
    getgenv().AXS_FPS_GUI:Destroy()
    getgenv().AXS_FPS_GUI = nil
end

getgenv().AXS_Connections = {}
getgenv().AXS_DamageAura = false
getgenv().ParryDebounce = false
getgenv().NextAllowedParry = 0

cloneref = cloneref or function(o) return o end
Players = cloneref(game:GetService("Players"))
ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
RunService = cloneref(game:GetService("RunService"))
lp = Players.LocalPlayer
username = lp.Name
Camera = workspace.CurrentCamera
UserInputService = cloneref(game:GetService("UserInputService"))
TweenService = cloneref(game:GetService("TweenService"))
SoundService = cloneref(game:GetService("SoundService"))
VIM = cloneref(game:GetService("VirtualInputManager"))
Mouse = lp:GetMouse()

Toggles = {} 
character = nil
hum = nil
root = nil

chaseSound = nil
activeTween = nil

function isInteractionActive()
    local pg = lp:FindFirstChild("PlayerGui")
    if not pg then return false end
    local sc = pg:FindFirstChild("SkillCheckPromptGui")
    if not sc then return false end
    local check = sc:FindFirstChild("Check")
    return check and check.Visible
end

function uCR(char)
    character = char
    root = character:WaitForChild("HumanoidRootPart", 5)
    hum = character:WaitForChild("Humanoid", 5)
    
    -- ESP Origin Attachment
    if root then
        local att = root:FindFirstChild("ESP_Origin")
        if not att then
            att = Instance.new("Attachment")
            att.Name = "ESP_Origin"
            att.Position = Vector3.new(0, 0, 0)
            att.Parent = root
        end
    end

    if chaseSound then
       chaseSound:Stop()
	chaseSound:Destroy()
	chaseSound = nil
    end
end

uCR(lp.Character or lp.CharacterAdded:Wait())
lp.CharacterAdded:Connect(function(newChar)
    uCR(newChar)
end)

getgenv().axs_settings = {
    AI = {
        DetectionRange = 300,
        PathUpdateRate = 0.1,
        AttackDistance = 10,
        RunDistance = 50,
        RepairDistance = 5,
        SpinDistance = 15
    },
    Pathfinding = {
        AgentCanJump = false,
        AgentHeight = 5,
        WaypointSpacing = 4,
        Costs = {
             Water = 100,
             Plastic = 1,
             SmoothPlastic = 0.5
        }
    },
    Toggles = {
        Wallhug = false,
        Debug = false
    },
    Methods = {
        Farm = true, 
        Run = true,
        Loop = false 
    }
}

blacklist = {
    [1834326225] = true,
    [396125889] = true,
    [98750775] = true,
    [3808251668] = true,
    [160224394] = true,
    [49706510] = true,
    [115342213] = true,
    [1806115340] = true,
    [1260363902] = true,
    [64656085] = true,
    [271036866] = true,
    [3137137279] = true
}
testers = {"Tgpeek1", "Technique12_12", "urboyfiePoP", "Bva_Back"}
Lib = nil
do
    local __compiler = loadstring or load
    local __source = getgenv().__AXS_AREXANS_UI_SOURCE
    local __ok, __result = pcall(function()
        assert(type(__source) == "string" and #__source > 0, "Bundled Arexans UI source missing")
        assert(type(__compiler) == "function", "loadstring/load unavailable")
        local __chunk, __err = __compiler(__source)
        assert(type(__chunk) == "function", __err or "UI library compile failed")
        local __lib = __chunk()
        assert(type(__lib) == "table" and type(__lib.CreateWindow) == "function", "Invalid Arexans UI library")
        return __lib
    end)
    if not __ok then error("Bundled Arexans UI failed to load: " .. tostring(__result)) end
    Lib = __result
end

-- Compatibility adapter: keep vd_v2 feature callbacks/config API while rendering
-- all controls through uiarexans.lua and its bundled image assets.
do
    local Arexans = Lib
    local OriginalCreateWindow = Arexans.CreateWindow
    local __AXS_ActiveArexansWindow = nil
    local __AXS_PendingArexansNotifications = {}
    -- Legacy vd_v2 calls Lib:MakeNotify before/after the main window exists.
    -- Queue early messages and render them through uiarexans.lua's native Notify.
    function Arexans:MakeNotify(options)
        options = options or {}
        local payload = {
            Title = tostring(options.Title or "AXS VD"),
            Content = tostring(options.Content or options.Description or ""),
            Duration = tonumber(options.Time or options.Duration) or 3,
        }
        if __AXS_ActiveArexansWindow and type(__AXS_ActiveArexansWindow.Notify) == "function" then
            local ok, err = pcall(function() __AXS_ActiveArexansWindow:Notify(payload) end)
            if not ok then warn("[AXS VD notification] " .. tostring(err)) end
        else
            table.insert(__AXS_PendingArexansNotifications, payload)
        end
    end
    local function safeCallback(callback, ...)
        if type(callback) == "function" then
            local args = table.pack(...)
            task.spawn(function()
                local ok, err = pcall(callback, table.unpack(args, 1, args.n))
                if not ok then warn("[AXS VD callback] " .. tostring(err)) end
            end)
        end
    end
    function Arexans:Window(options)
        options = options or {}
        local ui = OriginalCreateWindow(Arexans, tostring(options.Title or "AXS VD"))
        __AXS_ActiveArexansWindow = ui
        -- Deliver early startup notices using the bundled Arexans notification UI.
        for _, notice in ipairs(__AXS_PendingArexansNotifications) do
            if type(ui.Notify) == "function" then
                pcall(function() ui:Notify(notice) end)
            end
        end
        table.clear(__AXS_PendingArexansNotifications)
        local tabs = {}
        local featureIndex = {}
        local adapter = { _ui = ui, _tabs = tabs, _visible = true, _featureIndex = featureIndex }

        -- Search results overlay: searching is global and selecting a result
        -- navigates to the matching feature on its owning tab.
        local screenGui = ui._screenGui
        local windowRoot = screenGui and screenGui:FindFirstChild("WindowRoot")
        local searchPanel = windowRoot and windowRoot:FindFirstChild("SearchPanel")
        local resultsPanel
        local resultsLayout
        local tooltip
        local activeTooltipTarget = nil
        if windowRoot and searchPanel then
            resultsPanel = Instance.new("ImageLabel")
            resultsPanel.Name = "FeatureSearchResults"
            resultsPanel.Image = ui:GetAsset("popup/dropdown_main_panel.png")
            resultsPanel.BackgroundTransparency = 1
            resultsPanel.ScaleType = Enum.ScaleType.Stretch
            resultsPanel.AnchorPoint = Vector2.new(0.5, 1)
            resultsPanel.Position = UDim2.new(0.5, 0, 1, -38)
            resultsPanel.Size = UDim2.new(0, 250, 0, 0)
            resultsPanel.AutomaticSize = Enum.AutomaticSize.Y
            resultsPanel.Visible = false
            resultsPanel.ZIndex = 80
            resultsPanel.Parent = windowRoot
            local resultPadding = Instance.new("UIPadding")
            resultPadding.PaddingTop = UDim.new(0, 5)
            resultPadding.PaddingBottom = UDim.new(0, 5)
            resultPadding.PaddingLeft = UDim.new(0, 5)
            resultPadding.PaddingRight = UDim.new(0, 5)
            resultPadding.Parent = resultsPanel
            resultsLayout = Instance.new("UIListLayout")
            resultsLayout.Padding = UDim.new(0, 3)
            resultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            resultsLayout.Parent = resultsPanel

            -- Text-only full-name hint: no image/shape behind it. The dark text stroke
            -- and bold electric-blue font keep it readable over the existing UI.
            local tooltipBackground = Instance.new("Frame")
            tooltipBackground.Name = "FeatureFullNameTooltip"
            tooltipBackground.BackgroundTransparency = 1
            tooltipBackground.BorderSizePixel = 0
            tooltipBackground.Visible = false
            tooltipBackground.Size = UDim2.fromOffset(230, 48)
            tooltipBackground.ZIndex = 1000
            tooltipBackground.Parent = screenGui
            tooltip = Instance.new("TextLabel")
            tooltip.Name = "FeatureFullNameText"
            tooltip.BackgroundTransparency = 1
            tooltip.Position = UDim2.fromOffset(2, 2)
            tooltip.Size = UDim2.new(1, -4, 1, -4)
            tooltip.Font = Enum.Font.GothamBold
            tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
            tooltip.TextStrokeColor3 = Color3.fromRGB(5, 12, 28)
            tooltip.TextStrokeTransparency = 0.08
            tooltip.TextSize = 13
            tooltip.TextWrapped = true
            tooltip.TextXAlignment = Enum.TextXAlignment.Left
            tooltip.TextYAlignment = Enum.TextYAlignment.Center
            tooltip.ZIndex = 1001
            tooltip.Parent = tooltipBackground
            -- Holding a mouse button or touch shows the full name; releasing hides it.
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if activeTooltipTarget and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    activeTooltipTarget = nil
                    if tooltip and tooltip.Parent then tooltip.Parent.Visible = false end
                end
            end)
        end

        local function findFeatureGui(tab, title, suffix)
            local page = tab and tab._Page
            if not page then return nil end
            local expected = tostring(title) .. tostring(suffix or "")
            for _, node in ipairs(page:GetDescendants()) do
                if node.Name == expected and node:IsA("GuiObject") then return node end
            end
            -- Labels/paragraphs can be normalized by the library, so use a
            -- case-insensitive text match as a fallback.
            for _, node in ipairs(page:GetDescendants()) do
                if node:IsA("TextLabel") and string.find(string.lower(node.Text), string.lower(tostring(title)), 1, true) then
                    return node
                end
            end
            return nil
        end

        local function registerFeature(tab, title, suffix)
            title = tostring(title or "Feature")
            local target = findFeatureGui(tab, title, suffix)
            local entry = { title = title, tab = tab, target = target }
            table.insert(featureIndex, entry)
            if target and tooltip and screenGui then
                -- Bind the click to the actual title text. Some library versions
                -- return a row/container, so search its descendants and fall back
                -- to the closest visible text label if its text has been decorated.
                local textTarget = nil
                local function normalize(value)
                    return string.lower(tostring(value or ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""))
                end
                local wanted = normalize(title)
                local candidates = {}
                if target:IsA("TextLabel") or target:IsA("TextButton") or target:IsA("TextBox") then
                    table.insert(candidates, target)
                end
                for _, node in ipairs(target:GetDescendants()) do
                    if node:IsA("TextLabel") or node:IsA("TextButton") or node:IsA("TextBox") then
                        table.insert(candidates, node)
                    end
                end
                for _, node in ipairs(candidates) do
                    if node.Visible and normalize(node.Text) ~= "" then
                        local actual = normalize(node.Text)
                        if actual == wanted or string.find(actual, wanted, 1, true) or string.find(wanted, actual, 1, true) then
                            textTarget = node
                            break
                        end
                    end
                end
                -- If the visual library decorates the title so the exact text
                -- cannot be matched, use the first visible text object in the row.
                if not textTarget then
                    for _, node in ipairs(candidates) do
                        if node.Visible and normalize(node.Text) ~= "" then
                            textTarget = node
                            break
                        end
                    end
                end
                if textTarget then
                    if textTarget:IsA("TextLabel") then textTarget.Active = true end
                    local TextService = game:GetService("TextService")
                    local function showFullName()
                        if not tooltip or not tooltip.Parent or not textTarget.Parent then return end
                        -- Measure the complete feature name rather than TextBounds,
                        -- which may already be truncated by TextTruncate/ClipsDescendants.
                        local font = textTarget.Font
                        local textSize = textTarget.TextSize
                        local maxTextWidth = math.max(1, textTarget.AbsoluteSize.X - 8)
                        local measured = TextService:GetTextSize(title, textSize, font, Vector2.new(10000, 200))
                        local isClipped = measured.X > maxTextWidth + 2
                        if not isClipped then
                            tooltip.Parent.Visible = false
                            return
                        end
                        tooltip.Text = title
                        tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
                        tooltip.Font = Enum.Font.GothamBold
                        tooltip.TextStrokeColor3 = Color3.fromRGB(5, 12, 28)
                        tooltip.TextStrokeTransparency = 0.08
                        local tipFrame = tooltip.Parent
                        local screenSize = screenGui.AbsoluteSize
                        local tipWidth = math.clamp(measured.X + 28, 180, math.max(180, screenSize.X - 8))
                        local wrapped = TextService:GetTextSize(title, 12, Enum.Font.Gotham, Vector2.new(math.max(120, tipWidth - 24), 1000))
                        local tipHeight = math.clamp(wrapped.Y + 20, 38, 88)
                        tipFrame.Size = UDim2.fromOffset(tipWidth, tipHeight)
                        tooltip.TextSize = 13
                        tooltip.TextWrapped = true
                        tooltip.Position = UDim2.fromOffset(2, 2)
                        tooltip.Size = UDim2.new(1, -4, 1, -4)
                        local x = math.clamp(textTarget.AbsolutePosition.X, 4, math.max(4, screenSize.X - tipWidth - 4))
                        -- Position above the title; clamp to the visible screen bounds.
                        local y = textTarget.AbsolutePosition.Y - tipHeight - 6
                        if y < 4 then y = math.min(screenSize.Y - tipHeight - 4, textTarget.AbsolutePosition.Y + textTarget.AbsoluteSize.Y + 6) end
                        y = math.clamp(y, 4, math.max(4, screenSize.Y - tipHeight - 4))
                        tipFrame.Position = UDim2.fromOffset(x, y)
                        tipFrame.Visible = true
                    end
                    local function handlePress(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            activeTooltipTarget = textTarget
                            showFullName()
                        end
                    end
                    -- InputBegan is intentional: Activated fires on release, but this
                    -- tooltip must remain visible only while the user is holding.
                    textTarget.InputBegan:Connect(handlePress)
                end
            end
            return entry
        end

        local function showFeatureResults(query)
            if not resultsPanel then return end
            for _, child in ipairs(resultsPanel:GetChildren()) do
                if child:IsA("ImageButton") or child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
            end
            query = string.lower(tostring(query or "")):match("^%s*(.-)%s*$")
            if query == "" then resultsPanel.Visible = false; return end
            local matches = {}
            for _, entry in ipairs(featureIndex) do
                if string.find(string.lower(entry.title), query, 1, true) then
                    table.insert(matches, entry)
                end
            end
            local limit = math.min(#matches, 7)
            if limit == 0 then
                local empty = Instance.new("TextLabel")
                empty.BackgroundTransparency = 1
                empty.Size = UDim2.new(1, 0, 0, 25)
                empty.Font = Enum.Font.Gotham
                empty.Text = "Fitur tidak ditemukan"
                empty.TextColor3 = Color3.fromRGB(180, 205, 225)
                empty.TextSize = 10
                empty.ZIndex = 82
                empty.Parent = resultsPanel
            else
                for i = 1, limit do
                    local entry = matches[i]
                    local resultButton = Instance.new("ImageButton")
                    resultButton.Name = "Result_" .. tostring(i)
                    resultButton.LayoutOrder = i
                    resultButton.Size = UDim2.new(1, 0, 0, 29)
                    resultButton.Image = ui:GetAsset("popup/option_normal_01.png")
                    resultButton.BackgroundTransparency = 1
                    resultButton.ScaleType = Enum.ScaleType.Stretch
                    resultButton.AutoButtonColor = true
                    resultButton.ZIndex = 82
                    resultButton.Parent = resultsPanel
                    local resultText = Instance.new("TextLabel")
                    resultText.Name = "ResultText"
                    resultText.BackgroundTransparency = 1
                    resultText.Position = UDim2.new(0, 9, 0, 0)
                    resultText.Size = UDim2.new(1, -18, 1, 0)
                    resultText.Font = Enum.Font.GothamMedium
                    resultText.Text = entry.title .. "   ›"
                    resultText.TextColor3 = Color3.fromRGB(225, 244, 255)
                    resultText.TextSize = 10
                    resultText.TextXAlignment = Enum.TextXAlignment.Left
                    resultText.TextTruncate = Enum.TextTruncate.AtEnd
                    resultText.ZIndex = 83
                    resultText.Parent = resultButton
                    resultButton.MouseButton1Click:Connect(function()
                        resultsPanel.Visible = false
                        if entry.tab and type(entry.tab.Select) == "function" then entry.tab:Select() end
                        if tooltip and tooltip.Parent then tooltip.Parent.Visible = false end
                        task.defer(function()
                            local target = entry.target
                            local page = entry.tab and entry.tab._Page
                            if target and target.Parent and page then
                                local row = target
                                while row.Parent and row.Parent ~= page and row.Name ~= "ItemRow" and row.Name ~= "ItemRow_FullWidth" do
                                    row = row.Parent
                                end
                                local y = row.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y - 6
                                page.CanvasPosition = Vector2.new(0, math.max(0, y))
                                -- Flash a subtle outline around the found feature.
                                local stroke = Instance.new("UIStroke")
                                stroke.Color = Color3.fromRGB(55, 180, 255)
                                stroke.Thickness = 2
                                stroke.Parent = target
                                task.delay(1.3, function() if stroke and stroke.Parent then stroke:Destroy() end end)
                            end
                        end)
                    end)
                end
            end
            resultsPanel.Size = UDim2.new(0, 250, 0, 0)
            resultsPanel.AutomaticSize = Enum.AutomaticSize.Y
            resultsPanel.Visible = true
        end

        if ui and type(ui.SetSearchCallback) == "function" then
            ui:SetSearchCallback(showFeatureResults)
        end

        local function safeTabCall(tab, method, ...)
            local fn = tab and tab[method]
            if type(fn) ~= "function" then
                warn("[AXS VD] UI API unavailable: " .. tostring(method))
                return nil
            end
            local args = table.pack(...)
            local ok, result = pcall(function()
                return fn(tab, table.unpack(args, 1, args.n))
            end)
            if not ok then
                warn("[AXS VD] UI API failed (" .. tostring(method) .. "): " .. tostring(result))
                return nil
            end
            return result
        end
        local function makeSectionProxy(tab, title)
            local sectionProxy = { _tab = tab, _title = title }
            function sectionProxy:AddToggle(o)
                o=o or {}; local title=tostring(o.Title or o.Name or "Toggle")
                local result=safeTabCall(tab, "CreateToggle", title, o.Default == true, function(v) safeCallback(o.Callback, v) end)
                registerFeature(tab, title, "_Toggle")
                return result
            end
            function sectionProxy:AddButton(o)
                o=o or {}; local title=tostring(o.Title or o.Name or "Button")
                local result=safeTabCall(tab, "CreateButton", title, function() safeCallback(o.Callback) end)
                registerFeature(tab, title, "_Button")
                return result
            end
            function sectionProxy:AddSlider(o)
                o=o or {}; local min=tonumber(o.Min or o.Minimum) or 0; local max=tonumber(o.Max or o.Maximum) or 100
                if max <= min then max = min + 1 end
                local default=math.clamp(tonumber(o.Default) or min, min, max)
                local title=tostring(o.Title or o.Name or "Slider")
                local result=safeTabCall(tab, "CreateSlider", title, min, max, default, function(v) safeCallback(o.Callback, v) end)
                registerFeature(tab, title, "_Slider")
                return result
            end
            function sectionProxy:AddDropdown(o)
                o = type(o) == "table" and o or {}
                local opts = o.Options or o.Items or o.Values or o.List or o.OptionsList or {}
                local default = o.Default
                if default == nil then default = o.CurrentOption end
                if type(opts) ~= "table" then opts = {} end

                local dropdownName = tostring(o.Title or o.Name or "Dropdown")
                local callback = function(v) safeCallback(o.Callback, v) end

                -- Guard API mismatches without relying on a second adapter call
                -- from the fallback path (which caused nil-call errors in some builds).
                local createDropdown = tab and tab.CreateDropdown
                if type(createDropdown) == "function" then
                    local ok, result = pcall(createDropdown, tab, dropdownName, opts, default, callback)
                    if ok and result ~= nil then
                        registerFeature(tab, dropdownName, "_Dropdown")
                        return result
                    end
                    if not ok then warn("[AXS VD] CreateDropdown failed: " .. tostring(result)) end
                else
                    warn("[AXS VD] UI API unavailable: CreateDropdown")
                end

                local createLabel = tab and tab.CreateLabel
                local fallbackText = dropdownName .. ": " .. tostring(default or opts[1] or "No options")
                if type(createLabel) == "function" then
                    local ok, result = pcall(createLabel, tab, fallbackText)
                    if ok then
                        registerFeature(tab, dropdownName, nil)
                        return result
                    end
                    warn("[AXS VD] Dropdown fallback label failed: " .. tostring(result))
                end
                return nil
            end
            function sectionProxy:AddInput(o)
                o=o or {}; local title=tostring(o.Title or o.Name or "Input")
                local result=safeTabCall(tab, "CreateTextbox", title, tostring(o.Placeholder or ""), tostring(o.Default or ""),
                    function(v) safeCallback(o.Callback, v) end)
                registerFeature(tab, title, "_Textbox")
                return result
            end
            function sectionProxy:AddParagraph(o)
                o=o or {}; local title=tostring(o.Title or "Info")
                local result=safeTabCall(tab, "CreateLabel", title .. "  " .. tostring(o.Content or ""))
                registerFeature(tab, title, nil)
                return result
            end
            function sectionProxy:AddDivider()
                return safeTabCall(tab, "CreateCategory", "────────────────")
            end
            function sectionProxy:SetAttribute(name, value)
                self[name] = value
            end
            return sectionProxy
        end
        function adapter:SetToggleKey(key)
            if typeof(key) ~= "EnumItem" then return end
            if self._keyConnection then self._keyConnection:Disconnect() end
            local inputService = game:GetService("UserInputService")
            self._keyConnection = inputService.InputBegan:Connect(function(input, processed)
                if not processed and input.KeyCode == key then
                    self._visible = not self._visible
                    if ui._screenGui then ui._screenGui.Enabled = self._visible end
                    if ui.SetVisible then pcall(function() ui:SetVisible(self._visible) end) end
                end
            end)
        end
        function adapter:AddTab(tabOptions)
            tabOptions = tabOptions or {}
            local tab = ui:CreateTab(tostring(tabOptions.Name or "Tab"))
            local tabProxy = {}
            function tabProxy:AddSection(title, compact)
                title = tostring(title or "Section")
                local section = makeSectionProxy(tab, title)
                -- This one legacy feature inserts a dynamic list into its section.
                -- Give it a real Arexans-artwork container instead of a nil legacy
                -- SectionAdd property, which previously stopped UI construction.
                if title == "Server List" then
                    -- Never allow an optional custom-section API mismatch to stop
                    -- construction of every feature that follows this section.
                    local custom
                    local customOK = pcall(function()
                        if type(tab.CreateCustomSection) == "function" then
                            custom = tab:CreateCustomSection(title, 300)
                        end
                    end)
                    if customOK and type(custom) == "table" and custom.SectionAdd then
                        section.SectionAdd = custom.SectionAdd
                        section.SectionRoot = custom.Root
                    else
                        -- Fallback: locate this tab's real Arexans content container
                        -- and insert an asset-backed panel into the normal page flow.
                        local screen = ui._screenGui
                        local page = screen and screen:FindFirstChild(tostring(tabOptions.Name or "Tab") .. "_Page", true)
                        local content = page and page:FindFirstChild("Content")
                        if not content and screen then
                            for _, node in ipairs(screen:GetDescendants()) do
                                if node:IsA("Frame") and node.Name == "Content" and node.Parent and node.Parent.Name == tostring(tabOptions.Name or "Tab") .. "_Page" then
                                    content = node; break
                                end
                            end
                        end
                        local root = Instance.new("ImageLabel")
                        root.Name = "Section_Server_List_Fallback"
                        root.BackgroundTransparency = 1
                        root.Image = ""
                        root.Size = UDim2.new(1, 0, 0, 328)
                        root.ZIndex = 1
                        root.Parent = content or (screen or game:GetService("CoreGui"))
                        local inner = Instance.new("Frame")
                        inner.Name = "SectionAdd"
                        inner.BackgroundTransparency = 1
                        inner.Position = UDim2.new(0, 8, 0, 26)
                        inner.Size = UDim2.new(1, -16, 0, 300)
                        inner.ZIndex = 2
                        inner.Parent = root
                        section.SectionAdd = inner
                        section.SectionRoot = root
                        warn("[AXS VD] Server List custom section fallback used")
                    end
                else
                    pcall(function() tab:CreateCategory(title) end)
                end
                return section
            end
            -- Some legacy call sites attach controls directly to a tab.
            local directProxy = makeSectionProxy(tab, tostring(tabOptions.Name or "Tab"))
            for _, methodName in ipairs({"AddToggle","AddButton","AddSlider","AddDropdown","AddInput","AddParagraph","AddDivider","SetAttribute"}) do
                tabProxy[methodName] = function(_, ...)
                    return directProxy[methodName](directProxy, ...)
                end
            end
            tabs[#tabs+1] = tab
            return tabProxy
        end
        function adapter:MakeNotify(options)
            return Arexans:MakeNotify(options)
        end
        function adapter:Save()
            if getgenv().RealSaveConfig then pcall(getgenv().RealSaveConfig) end
        end
        function adapter:ExportConfig()
            return game:GetService("HttpService"):JSONEncode(ConfigData or {})
        end
        function adapter:ImportConfig(json)
            local ok, decoded=pcall(function() return game:GetService("HttpService"):JSONDecode(json) end)
            if not ok or type(decoded)~="table" then return false end
            ConfigData=decoded
            if LoadConfigElements then pcall(LoadConfigElements) end
            return true
        end
        function adapter:ResetAll()
            if type(ConfigData)=="table" then
                for k in pairs(ConfigData) do ConfigData[k]=nil end
            end
            if LoadConfigElements then pcall(LoadConfigElements) end
        end
        return adapter
    end
end

-- Patching New UI Library for Manual Config & Import/Export
pcall(function()
    if SaveConfig and not getgenv().RealSaveConfig then
        getgenv().RealSaveConfig = SaveConfig
        SaveConfig = function() end -- Disable auto-save
    end
    
    function Lib:Save()
        if getgenv().RealSaveConfig then getgenv().RealSaveConfig() end
    end
    
    function Lib:ExportConfig()
        return game:GetService("HttpService"):JSONEncode(ConfigData or {})
    end
    
    function Lib:ImportConfig(json)
        local success, decoded = pcall(function() return game:GetService("HttpService"):JSONDecode(json) end)
        if success and decoded then
            ConfigData = decoded
            if LoadConfigElements then LoadConfigElements() end
            return true
        end
        return false
    end
end)

if game.PlaceVersion < 10030 then
    Lib:MakeNotify({ Title = "AXS Violence Distric", Content = "This game version hasn't been tested for detections, use with aware.", Time = 5 })
end

function getTag(name)
    if getgenv().PREMIUM_KEY == true then
        return "[ PREMIUM ]"
    end
    return "[ Premium ]"
end

print("Loaded!\nAXS Violence Distric By Cat\nWhatsApp: https://whatsapp.com/channel/0029VarXBlfEVccM6hAkdp1H")

-- Variables for toggles
InvisibilityToggle = false
AutoEventToggle = false
AntiFlashlight = false
Autoshoot = false
Autoparry = false
SmartFace = true
ParryMethod = "Lunge"
facingLoop = false
selectedTarget = {}
AimPart = "Kepala"
AntiGFail = false
AntiHFail = false
GodmodeToggle = false
AntislowToggle = false
ExpandHitboxesToggle = false
HitboxesVisibleToggle = false
InfThingsToggle = false
chasetheme = "Default"
noCdEnabled = false
RemoveClothingsToggle = false
AutoAimNormalToggle = false
AutoAimChargedToggle = false
AutoDropToggle = false
AutoDropSetToggle = false
DamageAura = false
DesyncType = "Hitbox Improving"
Desync = false
ParryDistance = 20
ParryDelay = 0
HitboxesRadius = 10
HookFarmToggle = false
HookTimes = 5
NoFallToggle = false
FallRemote = nil
pcall(function()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local mechanics = remotes and remotes:FindFirstChild("Mechanics")
    FallRemote = mechanics and mechanics:FindFirstChild("Fall")
end)

WalkToggle = false
currentSpeed = 28
Noclip = nil
Clip = nil
NoclipToggle = false
selectedESPTypes = {}
ESPHighlight = false
ESPTracers = false
ESPNames = false
ESPBoxes = false
ESPStuds = false
ESPObjects = {}
esp = {}
tracers = {}
boxes = {}
names = {}
studs = {}
DrawingAvailable = (type(Drawing) == "table" or type(Drawing) == "userdata")

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
    [78935059863801] = true,
    [78432063483146] = true,
    [74968262036854] = true,
    [132817836308238] = true,
    [133963973694098] = true,
    [98163597193511] = true,
    [111920872708571] = true,
    [106871536134254] = true,
    [82666958311998] = true,
}

toggles = {
    JasonPursuit = false,
    JasonMist = false,
    StalkerEvolve = false,
    StalkerStage = false,
    Masked = false
}

function getKiller()
    local weapon = character:FindFirstChild("Weapon")
    local rightArm = weapon and weapon:FindFirstChild("Right Arm")
    
    if character:FindFirstChild("spearmanager") then
        return "Veil"
    end

    if rightArm and rightArm:FindFirstChild("Machete") then
        if rightArm and rightArm.Machete:FindFirstChild("pCube4_knife_0") then
            return "Jeff"
        else
            return "Jason"
        end

    elseif rightArm and rightArm:FindFirstChild("Knife") then
        return "Stalker"

    elseif weapon and weapon:FindFirstChild("Chainsaw") then
        return "Masked"
    end

    return nil
end

function hookButton(btn)
    btn.MouseButton1Down:Connect(function()
        local killer = getKiller()
        if not killer then return end
        
        if btn.Name == "attack" and noCdEnabled then
            game.ReplicatedStorage.Remotes.Attacks.BasicAttack:FireServer()
        end
        
        if killer == "Jason" then
            if btn.Name == "move1" then
                toggles.JasonPursuit = not toggles.JasonPursuit
                game.ReplicatedStorage.Remotes.Killers.Jason.Pursuit:FireServer(toggles.JasonPursuit)
                if toggles.JasonPursuit then
                    local hum = (lp.Character or lp.CharacterAdded:Wait()):WaitForChild("Humanoid")
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://125224839697689"
                    hum:LoadAnimation(anim):Play()
                end
            elseif btn.Name == "move2" then
                toggles.JasonMist = not toggles.JasonMist
                game.ReplicatedStorage.Remotes.Killers.Jason.LakeMist:FireServer(toggles.JasonMist)
            end

        elseif killer == "Veil" then
            if btn.Name == "move1" or btn.Name == "move2" then
            local lookDirection = Camera.CFrame.LookVector
            local args = {
              lookDirection,
              5.290782451629639
            }
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Veil"):WaitForChild("Spearthrow"):FireServer(unpack(args))
            end

        elseif killer == "Stalker" then
            if btn.Name == "move1" then
                toggles.StalkerEvolve = not toggles.StalkerEvolve
                game.ReplicatedStorage.Remotes.Killers.Stalker.EvolveStage:FireServer(toggles.StalkerStage and 2 or false)
            elseif btn.Name == "move2" then
                toggles.StalkerStage = not toggles.StalkerStage
            end

        elseif killer == "Masked" then
            if btn.Name == "move1" then
                if toggles.Masked then
                game.ReplicatedStorage.Remotes.Killers.Masked.Deactivatepower:FireServer()
                    toggles.Masked = false
                    task.wait(2)
                end
                game.ReplicatedStorage.Remotes.Killers.Masked.Activatepower:FireServer(chosenMapped)
                toggles.Masked = true
            end
        end
    end)
end

function isPlayerObject(obj)
    local child = obj:FindFirstChild("Highlight-forsurvivor")
    return child and child:IsA("LocalScript")
end

function isKillerObject(obj)
    local killer1 = obj:FindFirstChild("Killerost")
    local killer2 = obj:FindFirstChild("Lookscriptkiller")
    return (killer1 and killer1:IsA("LocalScript")) or (killer2 and killer2:IsA("LocalScript"))
end

function contains(tbl, val)
    if not tbl or type(tbl) ~= "table" then return false end
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

function getObjType(obj)
    if not obj then return nil end
    
    -- Priority: Check for explicit markers
    if obj:FindFirstChild("Highlight-forsurvivor") then return "Players" end
    if obj:FindFirstChild("Killerost") or obj:FindFirstChild("Lookscriptkiller") then return "Killers", obj end
    
    -- Fallback: Use Players Service (Robustness Fix)
    local plr = Players:GetPlayerFromCharacter(obj)
    if plr and plr ~= lp then
        -- If it's a player but no killer marker found, assume Player (Survivor)
        -- This fixes the issue where ESP disappears if the highlight script is missing
        return "Players"
    end

    local name = obj.Name
    if name == "Generator" or (obj.Parent and obj.Parent.Name == "Gens") then 
        return "Generators"
    end
    
    -- Improved Window Detection (Check for interactable/vault point)
    if name == "Window" and (obj:FindFirstChild("WindowPoint") or obj:FindFirstChild("VaultPoint") or obj:FindFirstChild("Vault") or obj:FindFirstChild("Part")) then
        -- Checking for children ensures we don't pick up empty/dummy windows
        return "Windows"
    end
    
    -- Improved Pallet Detection (Only interactable pallets)
    if string.find(string.lower(name), "pallet") and obj:FindFirstChild("PalletPoint") then 
        return "Pallets" 
    end
    
    if string.find(name, "GiftHandle") and obj.Parent then return "Presents", obj.Parent end
    return nil
end

function passesFilter(obj)
    local t = getObjType(obj)
    return t and contains(selectedESPTypes, t)
end

function getObjColor(obj)
    local t = getObjType(obj)
    if t == "Killers" then return Color3.fromRGB(255, 0, 0) end
    if t == "Generators" then
        local foundPoint = false
        for _, child in ipairs(obj:GetChildren()) do
            if string.find(child.Name, "GeneratorPoint") then
                foundPoint = true
                break
            end
        end
        if not foundPoint then
            return Color3.fromRGB(0, 255, 0)
        end
        return Color3.fromRGB(255, 255, 0)
    end
    if t == "Windows" then return Color3.fromRGB(128, 0, 128) end
    if t == "Pallets" then return Color3.fromRGB(255, 165, 0) end
    if t == "Presents" then return Color3.fromRGB(1, 50, 32) end
    return Color3.fromRGB(0, 255, 0)
end

function getRootPosition(target)
    if target:IsA("BasePart") then 
        return target.Position 
    end
    
    if target:IsA("Model") then
        if target.PrimaryPart then return target.PrimaryPart.Position end
        
        local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("VisibleParts")
        if root and root:IsA("BasePart") then return root.Position end
        
        return target:GetPivot().Position
    end
    
    return Vector3.new(0, 0, 0)
end

ESPStyle = "Full"
function ensureHighlight(obj)
    if not ESPHighlight then
        if esp[obj] and esp[obj].highlight then
            esp[obj].highlight:Destroy()
            esp[obj].highlight = nil
        end
        return
    end
    
    -- Robustness: Recreate if destroyed by game
    if esp[obj].highlight and not esp[obj].highlight.Parent then
        esp[obj].highlight = nil
    end

    local color = getObjColor(obj)
    
    if not esp[obj].highlight then
        local h = Instance.new("Highlight")
        h.Adornee = obj
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = obj
        esp[obj].highlight = h
    end

    local h = esp[obj].highlight
    if h then
        h.OutlineColor = color -- Colorful Outline
        h.FillColor = color
        h.OutlineTransparency = 0
        
        if ESPStyle == "Outline Only" then
            h.FillTransparency = 1
        else
            h.FillTransparency = 0.5
        end
    end
end

function ensureBillboard(obj)
    if not (ESPNames or ESPStuds) then
        if esp[obj].billboard then
            esp[obj].billboard:Destroy()
            esp[obj].billboard = nil
        end
        return
    end

    if not esp[obj].billboard then
        local head = obj:FindFirstChild("Head") or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
        if not head then return end

        local b = Instance.new("BillboardGui")
        b.Name = "roblox"
        b.Size = UDim2.new(0, 200, 0, 50)
        b.Adornee = head
        b.AlwaysOnTop = true
        b.MaxDistance = 5000
        b.Parent = obj
        
        local n = Instance.new("TextLabel")
        n.Name = "MainLabel"
        n.Parent = b
        n.BackgroundTransparency = 1
        n.Size = UDim2.new(1, 0, 1, 0)
        n.Text = ""
        n.Font = Enum.Font.SourceSansBold
        n.TextSize = 14
        n.TextStrokeTransparency = 0
        n.RichText = true

        esp[obj].billboard = b
        esp[obj].nameLabel = n
        esp[obj].studsLabel = nil 
    end
end

function ensureTracer(obj)
    if not ESPTracers then
        if tracers[obj] then
            pcall(function() tracers[obj]:Destroy() end)
            tracers[obj] = nil
        end
        if esp[obj] and esp[obj].attachment then
            pcall(function() esp[obj].attachment:Destroy() end)
            esp[obj].attachment = nil
        end
        return
    end
    
    if not tracers[obj] then
        -- 3D "Alive" Beam Tracer
        local targetRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart") or obj
        if not targetRoot then return end

        local targetAtt = Instance.new("Attachment")
        targetAtt.Name = "ESP_Target_Att"
        targetAtt.Parent = targetRoot
        
        if not esp[obj] then esp[obj] = {} end
        esp[obj].attachment = targetAtt

        -- Ensure Origin exists
        local myRoot = character and character:FindFirstChild("HumanoidRootPart")
        local myAtt = myRoot and myRoot:FindFirstChild("ESP_Origin")
        if not myAtt and myRoot then
             myAtt = Instance.new("Attachment")
             myAtt.Name = "ESP_Origin"
             myAtt.Parent = myRoot
        end

        if myAtt then
            local beam = Instance.new("Beam")
            beam.Name = "ESP_Beam"
            beam.Attachment0 = myAtt
            beam.Attachment1 = targetAtt
            beam.FaceCamera = true
            beam.Width0 = 0.1
            beam.Width1 = 0.1
            -- A laser-like texture to look "alive"
            beam.Texture = "rbxassetid://446111271" 
            beam.TextureSpeed = 2 
            beam.TextureMode = Enum.TextureMode.Wrap
            beam.TextureLength = 10
            beam.LightEmission = 1
            beam.LightInfluence = 0
            beam.Parent = targetRoot 
            tracers[obj] = beam
        end
    end
end

function ensureBox(obj)
    if not ESPBoxes then
        if boxes[obj] then
            if typeof(boxes[obj]) == "table" then
                for _, l in pairs(boxes[obj]) do l:Remove() end
            elseif typeof(boxes[obj]) == "Instance" then
                boxes[obj]:Destroy()
            end
            boxes[obj] = nil
        end
        return
    end

    if not boxes[obj] then
        if DrawingAvailable and Drawing and type(Drawing.new) == "function" then
            boxes[obj] = {
                tl = Drawing.new("Line"),
                tr = Drawing.new("Line"),
                bl = Drawing.new("Line"),
                br = Drawing.new("Line")
            }
            for _, line in pairs(boxes[obj]) do
                line.Thickness = 1
                line.Transparency = 1
            end
        else
            -- Frame Fallback for Box
            local f = Instance.new("Frame")
            f.Name = "ESPBox"
            f.BackgroundTransparency = 1
            f.Visible = false
            f.ZIndex = 10
            
            local s = Instance.new("UIStroke")
            s.Thickness = 1.5
            s.Color = Color3.new(1,1,1)
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Parent = f
            
            local guiName = "AXS_ESP_Tracers"
            local targetParent = (gethui and gethui()) or game:GetService("CoreGui")
            local gui = targetParent:FindFirstChild(guiName)
            if not gui then
                gui = Instance.new("ScreenGui")
                gui.Name = guiName
                gui.IgnoreGuiInset = true
                gui.DisplayOrder = 10000
                if syn and syn.protect_gui then syn.protect_gui(gui) end
                gui.Parent = targetParent
            end
            f.Parent = gui
            boxes[obj] = f
        end
    end
end

function ensureAllFor(obj)
    if not esp[obj] then esp[obj] = {} end
    
    ensureHighlight(obj)
    ensureBillboard(obj)
    ensureTracer(obj)
    ensureBox(obj)
end

function removeESP(obj)
    local d = esp[obj]
    if d then
        if d.highlight then pcall(function() d.highlight:Destroy() end) end
        if d.billboard then pcall(function() d.billboard:Destroy() end) end
        if d.attachment then pcall(function() d.attachment:Destroy() end) end
        esp[obj] = nil
    end
    if tracers[obj] then pcall(function() tracers[obj]:Destroy() end) tracers[obj] = nil end
    if boxes[obj] then
        if typeof(boxes[obj]) == "table" then
            for _, l in pairs(boxes[obj]) do pcall(function() l:Remove() end) end
        else
            pcall(function() boxes[obj]:Destroy() end)
        end
        boxes[obj] = nil
    end
end

getgenv().ESP_Cache = {}
getgenv().KillerCache = {}

function ManageCache()
    local cache = {}
    local kCache = {}
    
    local function check(o)
        local t = getObjType(o)
        if t then
            table.insert(cache, o)
            if t == "Killers" then
                table.insert(kCache, o)
            end
        end
    end

    -- Initial Scan
    for _, v in ipairs(workspace:GetChildren()) do
        if v ~= lp.Character then check(v) end
    end
    
    local map = workspace:FindFirstChild("Map")
    if map then
        for _, v in ipairs(map:GetDescendants()) do
            if v ~= lp.Character then check(v) end
        end
    end
    
    getgenv().ESP_Cache = cache
    getgenv().KillerCache = kCache

    -- Real-time Updates (Event Driven)
    if getgenv().AXS_Connections["Cache_Add"] then getgenv().AXS_Connections["Cache_Add"]:Disconnect() end
    getgenv().AXS_Connections["Cache_Add"] = workspace.DescendantAdded:Connect(function(child)
        if child == lp.Character then return end
        
        -- Marker Detection (Late Load Fix)
        if child.Name == "Highlight-forsurvivor" and child.Parent then
             local parent = child.Parent
             if not table.find(getgenv().ESP_Cache, parent) then
                 table.insert(getgenv().ESP_Cache, parent)
                 if passesFilter(parent) then ensureAllFor(parent) end
             end
        elseif (child.Name == "Killerost" or child.Name == "Lookscriptkiller") and child.Parent then
             local parent = child.Parent
             if not table.find(getgenv().ESP_Cache, parent) then
                 table.insert(getgenv().ESP_Cache, parent)
                 if passesFilter(parent) then ensureAllFor(parent) end
             end
             if not table.find(getgenv().KillerCache, parent) then
                 table.insert(getgenv().KillerCache, parent)
             end
        end

        local t = getObjType(child)
        if t then
            table.insert(getgenv().ESP_Cache, child)
            if t == "Killers" then
                table.insert(getgenv().KillerCache, child)
            end
            if passesFilter(child) then ensureAllFor(child) end
        end
    end)

    if getgenv().AXS_Connections["Cache_Rem"] then getgenv().AXS_Connections["Cache_Rem"]:Disconnect() end
    getgenv().AXS_Connections["Cache_Rem"] = workspace.DescendantRemoving:Connect(function(child)
        removeESP(child)
        local idx = table.find(getgenv().ESP_Cache, child)
        if idx then table.remove(getgenv().ESP_Cache, idx) end
        
        local kIdx = table.find(getgenv().KillerCache, child)
        if kIdx then table.remove(getgenv().KillerCache, kIdx) end
    end)
end

task.spawn(ManageCache)

rootCache = {}
if getgenv().AXS_Connections["ESP_Loop"] then getgenv().AXS_Connections["ESP_Loop"]:Disconnect() end
getgenv().AXS_Connections["ESP_Loop"] = RunService.Heartbeat:Connect(function()
    for _, obj in ipairs(getgenv().ESP_Cache or {}) do
        if passesFilter(obj) then
            ensureAllFor(obj)
        else
            removeESP(obj)
        end
    end 
    
    for obj, data in pairs(esp) do
        local color = getObjColor(obj)
        
        if not obj or not obj.Parent or not passesFilter(obj) then
            removeESP(obj)
            rootCache[obj] = nil
            continue
        end

        local worldPos = getRootPosition(obj)
        local distFromCam = (Camera.CFrame.Position - worldPos).Magnitude
        
        -- Optimization: Skip far objects
        if distFromCam > 1500 then
            if data.billboard and data.billboard.Enabled then data.billboard.Enabled = false end
            if tracers[obj] and tracers[obj].Enabled then tracers[obj].Enabled = false end
            if boxes[obj] then
                if typeof(boxes[obj]) == "table" then
                    for _, l in pairs(boxes[obj]) do if l.Visible then l.Visible = false end end
                else
                    if boxes[obj].Visible then boxes[obj].Visible = false end
                end
            end
            if data.highlight and data.highlight.FillTransparency ~= 1 then data.highlight.FillTransparency = 1 end
            continue
        end

        local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
        local isVisible = onScreen and screenPos.Z > 0

        if data.billboard then
            local active = isVisible and (ESPNames or ESPStuds)
            data.billboard.Enabled = active
            
            if active then
                data.billboard.Adornee = obj:IsA("BasePart") and obj or obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                data.billboard.AlwaysOnTop = true
                data.billboard.Size = UDim2.new(0, 200, 0, 50)
                data.billboard.StudsOffset = Vector3.new(0, 3, 0)

                local targetLabel = data.nameLabel or data.billboard:FindFirstChildOfClass("TextLabel")
                if targetLabel and root then
                    targetLabel.Visible = true
                    targetLabel.Size = UDim2.new(1, 0, 1, 0)
                    targetLabel.BackgroundTransparency = 1
                    
                    local dist = (Camera.CFrame.Position - worldPos).Magnitude
                    local name = (obj.Name == "GiftHandle") and "Present" or obj.Name
                    
                    if ESPNames and ESPStuds then
                        targetLabel.Text = name .. " (" .. string.format("%.0fm", dist) .. ")"
                    elseif ESPNames then
                        targetLabel.Text = name
                    elseif ESPStuds then
                        targetLabel.Text = string.format("%.0fm", dist)
                    end
                    targetLabel.TextColor3 = color
                end
            end
        end

        if tracers[obj] then
            local beam = tracers[obj]
            if beam.Parent then -- Check validity
                beam.Enabled = ESPTracers
                if ESPTracers then
                    beam.Color = ColorSequence.new(color)
                    
                    -- Re-link attachment if character respawned
                    if not beam.Attachment0 or beam.Attachment0.Parent ~= root then
                        local myAtt = root and root:FindFirstChild("ESP_Origin")
                        if not myAtt and root then
                            myAtt = Instance.new("Attachment")
                            myAtt.Name = "ESP_Origin"
                            myAtt.Parent = root
                        end
                        beam.Attachment0 = myAtt
                    end
                end
            else
                tracers[obj] = nil -- Cleanup if destroyed
            end
        end

        if boxes[obj] then
            local isDrawing = (typeof(boxes[obj]) == "table")
            local showBox = isVisible and ESPBoxes

            if isDrawing then
                local box = boxes[obj]
                for _, line in pairs(box) do line.Visible = showBox; line.Color = color end
                if showBox then
                    local size = (1 / screenPos.Z) * 1000 
                    local w, h = size * 0.6, size
                    if obj.Name == "GiftHandle" then w, h = size * 0.4, size * 0.4 end
                    local x, y = screenPos.X, screenPos.Y
                    box.tl.From = Vector2.new(x-w, y-h); box.tl.To = Vector2.new(x+w, y-h)
                    box.tr.From = Vector2.new(x+w, y-h); box.tr.To = Vector2.new(x+w, y+h)
                    box.br.From = Vector2.new(x+w, y+h); box.br.To = Vector2.new(x-w, y+h)
                    box.bl.From = Vector2.new(x-w, y+h); box.bl.To = Vector2.new(x-w, y-h)
                end
            else
                -- Frame Box
                local box = boxes[obj]
                box.Visible = showBox
                if showBox then
                    local stroke = box:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Color = color end
                    
                    local size = (1 / screenPos.Z) * 1000 
                    local w, h = size * 0.6, size
                    if obj.Name == "GiftHandle" then w, h = size * 0.4, size * 0.4 end
                    
                    box.Size = UDim2.new(0, w * 2, 0, h * 2)
                    box.Position = UDim2.new(0, screenPos.X - w, 0, screenPos.Y - h)
                end
            end
        end
        
        if data.highlight then data.highlight.FillColor = color end
    end
end)

Workspace.ChildAdded:Connect(function(child) task.wait(0.5); if passesFilter(child) then ensureAllFor(child) end 
end)
Workspace.ChildRemoved:Connect(function(child) removeESP(child) end)

IsInvisible = false
IsSettingUp = false
FakeCharacter = nil
RealCharacter = nil
Part = nil

function protectGuis()
    local pGui = lp:FindFirstChild("PlayerGui")
    if pGui then
        for _, gui in ipairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                gui.ResetOnSpawn = false
            end
        end
    end
end

function setupFakeCharacter()
    if IsSettingUp then return end
    IsSettingUp = true
    
    RealCharacter = lp.Character or lp.CharacterAdded:Wait()
    RealCharacter.Archivable = true
    
    if FakeCharacter then FakeCharacter:Destroy() end
    if Part then Part:Destroy() end

    FakeCharacter = RealCharacter:Clone()
    FakeCharacter.Name = "FakeCharacter"
    
    Part = Instance.new("Part")
    Part.Anchored = true
    Part.Size = Vector3.new(10, 1, 10)
    Part.CFrame = CFrame.new(0, 200, 0)
    Part.CanCollide = true
    Part.Parent = workspace

    FakeCharacter.Parent = workspace
    
    for _, v in ipairs(FakeCharacter:GetChildren()) do
        if v:IsA("BasePart") then v.Transparency = 0.7 end
    end
    
    for _, v in ipairs(RealCharacter:GetChildren()) do
        if v:IsA("LocalScript") then
            local c = v:Clone()
            c.Disabled = true
            c.Parent = FakeCharacter
        end
    end
    
    task.spawn(function()
        while task.wait(0.1) do
            if IsInvisible and RealCharacter and RealCharacter:FindFirstChild("HumanoidRootPart") then
                RealCharacter.HumanoidRootPart.CFrame = Part.CFrame * CFrame.new(0, 5, 0)
                RealCharacter.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
    
    IsSettingUp = false
end

function enableInvis()
    if IsInvisible or IsSettingUp then return end
    
    RealCharacter = lp.Character
    protectGuis()

    if not FakeCharacter then 
        setupFakeCharacter() 
        repeat task.wait() until FakeCharacter
    end

    local realRoot = RealCharacter:FindFirstChild("HumanoidRootPart")
    local fakeRoot = FakeCharacter:FindFirstChild("HumanoidRootPart")
    
    if realRoot and fakeRoot then
        local storedCF = realRoot.CFrame
        realRoot.CFrame = fakeRoot.CFrame
        fakeRoot.CFrame = storedCF
        
        realRoot.Anchored = true 
        
        RealCharacter.Humanoid:UnequipTools()
        lp.Character = FakeCharacter
        workspace.CurrentCamera.CameraSubject = FakeCharacter.Humanoid

        for _, v in ipairs(FakeCharacter:GetChildren()) do
            if v:IsA("LocalScript") then v.Disabled = false end
        end

        IsInvisible = true
    end
end

function disableInvis()
    if not IsInvisible or IsSettingUp then return end

    local realRoot = RealCharacter:FindFirstChild("HumanoidRootPart")
    local fakeRoot = FakeCharacter:FindFirstChild("HumanoidRootPart")

    if realRoot and fakeRoot then
        local storedCF = fakeRoot.CFrame
        fakeRoot.CFrame = realRoot.CFrame
        realRoot.CFrame = storedCF
        
        realRoot.Anchored = false 
        
        FakeCharacter.Humanoid:UnequipTools()
        lp.Character = RealCharacter
        workspace.CurrentCamera.CameraSubject = RealCharacter.Humanoid

        for _, v in ipairs(FakeCharacter:GetChildren()) do
            if v:IsA("LocalScript") then v.Disabled = true end
        end
        for _, v in ipairs(RealCharacter:GetChildren()) do
            if v:IsA("LocalScript") then v.Disabled = false end
        end

        IsInvisible = false
    end
end

function noclip()
	Clip = false
	if Noclip then Noclip:Disconnect() end
	Noclip = RunService.Stepped:Connect(function()
		if Clip == false and lp.Character then
			for _, v in ipairs(lp.Character:GetChildren()) do --descen
				if v:IsA("BasePart") and v.CanCollide then
					v.CanCollide = false
				end
			end
		end
	end)
end

function clip()
	Clip = true
	if Noclip then
		Noclip:Disconnect()
		Noclip = nil
	end
end

supportsHooks = getrawmetatable and hookfunction and setreadonly

if supportsHooks then
    local success, err = pcall(function()
        local mt = getrawmetatable(game)
        local oldIndex
        local oldNewIndex

        setreadonly(mt, false)

        oldIndex = hookfunction(mt.__index, function(self, index)
            if WalkToggle and not checkcaller() and self:IsA("Humanoid") and self:IsDescendantOf(game.Players.LocalPlayer.Character) then
                if index == "WalkSpeed" then
                    return 16
                end
            end
            return oldIndex(self, index)
        end)

        oldNewIndex = hookfunction(mt.__newindex, function(self, index, value)
            if WalkToggle and not checkcaller() and self:IsA("Humanoid") and self:IsDescendantOf(game.Players.LocalPlayer.Character) then
                if index == "WalkSpeed" then
                    return 
                end
            end
            return oldNewIndex(self, index, value)
        end)

        setreadonly(mt, true)
    end)
    
    if not success then
        warn("[Arexans] Bypass failed to initialize: " .. tostring(err))
    end
else
    warn("[Arexans] Executor does not support metatable hooking (getrawmetatable, setreadonly). WS Bypass Skipped.")
end

SpeedConnection = nil
function applyBypassSpeed()
    if SpeedConnection then 
        SpeedConnection:Disconnect() 
        SpeedConnection = nil 
    end
    
    if WalkToggle then
        -- Ultimate Smoothness: Only apply speed when moving and on floor
        SpeedConnection = RunService.Stepped:Connect(function()
            if getgenv().ParryDebounce then return end
            if hum and hum.Parent and not isInteractionActive() then
                -- Optimization: Only force speed if moving to allow physics sleep
                if hum.MoveDirection.Magnitude > 0 then
                    if math.abs(hum.WalkSpeed - currentSpeed) > 1 then
                        hum.WalkSpeed = currentSpeed
                    end
                else
                    -- Reset to normal when idle to prevent micro-jitter
                    if math.abs(hum.WalkSpeed - 16) > 1 then
                        hum.WalkSpeed = 16 
                    end
                end
                
                -- Removed Aggressive Stop to prevent physics fighting/stuttering
            end
        end)
        
        -- Attribute cleaner throttled
        task.spawn(function()
            while WalkToggle and SpeedConnection do
                if hum and hum.Parent then
                    local negativeAttributes = {"Slowed", "Stunned", "Blind", "SpeedReduction", "Stun"}
                    for _, attr in ipairs(negativeAttributes) do
                        if hum:GetAttribute(attr) then
                            hum:SetAttribute(attr, nil)
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    else
        if hum and hum.Parent then
            hum.WalkSpeed = 16
        end
    end
end

crossUI = nil

function findFolderByKeyword(parent, keyword)
    if not parent then return nil end
    for _, child in ipairs(parent:GetChildren()) do
        if string.find(string.lower(child.Name), string.lower(keyword)) then
            return child
        end
    end
    return nil
end

countevent = 0
function autofarmcurrency()
    task.spawn(function()
        while AutoEventToggle do
            if countevent > 8 then
                warn("[AXS Violence Distric] Remote limit. Waiting 15 seconds to avoid detection...")
                Lib:MakeNotify({ Title = "AXS Violence Distric", Content = "Remote limit. Waiting 15 seconds to avoid detection...", Time = 15 })
                task.wait(15)
                countevent = 0
                continue
            end
            local mapf = workspace:FindFirstChild("Map")
            
            if root and mapf then
                local chris = findFolderByKeyword(mapf, "chris")
                local treeFolder = findFolderByKeyword(chris, "tree")
                
                local treePart = nil
                if treeFolder then
                    local model = treeFolder:FindFirstChild("Model")
                    treePart = model and model:FindFirstChild("Part")
                end

                local giftsFolder = findFolderByKeyword(chris, "gift")
                local targetGift = giftsFolder and giftsFolder:FindFirstChild("GiftHandle", true)

                if targetGift and treePart then
                    root.CFrame = targetGift.CFrame
                    task.wait(0.3)
                    
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("gift", true)
                    if remote then
                        remote:FireServer(targetGift)
                        countevent += 1
                    end
                    
                    task.wait(0.1)
                    root.CFrame = treePart.CFrame
                    task.wait(1)
                else
                    task.wait(1)
                end
            else
                task.wait(1)
            end
        end
    end)
end

function getNearestTarget()
    local nearest, nearestDist = nil, math.huge
    local sourceTable = (selectedTarget == "Killers") and getgenv().KillerCache or getgenv().ESP_Cache

    if not root then return nil end
    local myPos = root.Position

    for _, obj in ipairs(sourceTable or {}) do
        if obj:IsA("Model") and obj ~= lp.Character then
            local valid = false
            if selectedTarget == "Players" then
                 valid = isPlayerObject(obj)
            elseif selectedTarget == "Killers" then
                 valid = true
            end

            if valid then
                local targetRoot = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                if targetRoot then
                    local dist = (targetRoot.Position - myPos).Magnitude
                    if dist < nearestDist then
                        nearest, nearestDist = obj, dist
                    end
                end
            end
        end
    end

    return nearest
end

function faceTarget(model)
    if not root then return end

    local arm = model:FindFirstChild("Head")
    if not arm and model.PrimaryPart then
        arm = model.PrimaryPart
    end
    if not arm then return end

    local pos = arm.Position
    local dir = (pos - root.Position).Unit

    root.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(dir.X, 0, dir.Z))

    local cam = workspace.CurrentCamera
    cam.CFrame = CFrame.new(cam.CFrame.Position, pos)
end

function pressSpecialButton(args)
    local pg = lp:FindFirstChild("PlayerGui")
    if not pg then return end
    local survivor = pg:FindFirstChild("Survivor-mob")
    if not survivor then return end
    local controls = survivor:FindFirstChild("Controls")
    if not controls then return end
    local button = controls:FindFirstChild(args)
    if not button or not (button:IsA("TextButton") or button:IsA("ImageButton")) then return end

    for _, ev in ipairs({"MouseButton1Down", "MouseButton1Up", "MouseButton1Click"}) do
        if button[ev] then
            for _, sig in pairs(getconnections(button[ev])) do
                if sig.Function then
                    sig.Function()
                end
            end
        end
    end
end

GenConnection = nil
HealConnection = nil
genHitDone = false
healHitDone = false

function autoperfectgen()
    local pGui = lp:FindFirstChild("PlayerGui")
    local checkGui = pGui and pGui:FindFirstChild("SkillCheckPromptGui") and pGui.SkillCheckPromptGui:FindFirstChild("Check")
    
    if checkGui and checkGui.Visible then
        local line = checkGui:FindFirstChild("Line")
        local goal = checkGui:FindFirstChild("Goal")
        
        if line and goal then
            local currentRot = line.Rotation
            local perfectStart = 104 + goal.Rotation
            
            if not genHitDone and currentRot >= (perfectStart + 1) and currentRot <= (perfectStart + 9) then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)

                pressSpecialButton("action")
                genHitDone = true
            end
        end
    else
        genHitDone = false
    end
end

function autoperfectheal()
    local pGui = lp:FindFirstChild("PlayerGui")
    local checkGui = pGui and pGui:FindFirstChild("SkillCheckPromptGui") and pGui.SkillCheckPromptGui:FindFirstChild("Check")
    
    if checkGui and checkGui.Visible then
        local line = checkGui:FindFirstChild("Line")
        local goal = checkGui:FindFirstChild("Goal")
        
        if line and goal then
            local currentRot = line.Rotation
            local perfectStart = 104 + goal.Rotation
            
            if not healHitDone and currentRot >= (perfectStart + 1) and currentRot <= (perfectStart + 9) then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                pressSpecialButton("action")
                healHitDone = true
            end
        end
    else
        healHitDone = false
    end
end

getgenv().isAimingBtnPressed = false
getgenv().isMobileAiming = false
getgenv().AutoTargetToggle = false
getgenv().AutoSerangToggle = false

function getSoundIdFromTheme()
	if chasetheme == "Mila - Compass" then
		return "rbxassetid://115877769571526"
	elseif chasetheme == "Close To Me" then
		return "rbxassetid://90022574613230"
	end
	return nil
end

function fadeTo(vol, time)
	if not chaseSound then return end
	if activeTween then activeTween:Cancel() end
	activeTween = TweenService:Create(chaseSound, TweenInfo.new(time, Enum.EasingStyle.Linear), {Volume = vol})
	activeTween:Play()
end

function setupChaseMusic(soundid)
	if not chaseSound then
		chaseSound = Instance.new("Sound")
		chaseSound.Name = "CCM"
		chaseSound.SoundId = soundid
		chaseSound.Looped = true
		chaseSound.Volume = 0
		chaseSound.Parent = SoundService

		chaseSound.Loaded:Wait()
		if 96.5 < chaseSound.TimeLength then
			if chasetheme == "Mila - Compass" then 
			chaseSound.TimePosition = 96.5
			end
		end
		chaseSound:Play()
	end

	fadeTo(1.2, 0)
end

RunService.RenderStepped:Connect(function()
    if not character or not root then return end

    local hasWeapon = character:FindFirstChild("Twist of Fate") or character:FindFirstChild("Flashlight")

    local isAimingNow = false
    if UserInputService.TouchEnabled then
        isAimingNow = getgenv().isMobileAiming
    else
        isAimingNow = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    end

    local target = nil
    local targetPartObj = nil

    if (getgenv().AutoTargetToggle and isAimingNow and hasWeapon) or (getgenv().AutoSerangToggle and hasWeapon) then
        target = getNearestTarget()
        if target then
            if AimPart == "Kepala" then 
                targetPartObj = target:FindFirstChild("Head")
            elseif AimPart == "Badan" then 
                targetPartObj = target:FindFirstChild("UpperTorso") or target:FindFirstChild("Torso") or target:FindFirstChild("HumanoidRootPart")
            elseif AimPart == "Pundak Kanan" then 
                targetPartObj = target:FindFirstChild("RightUpperArm") or target:FindFirstChild("Right Arm")
            elseif AimPart == "Pundak Kiri" then 
                targetPartObj = target:FindFirstChild("LeftUpperArm") or target:FindFirstChild("Left Arm")
            end
            if not targetPartObj then targetPartObj = target:FindFirstChild("Head") end
        end
    end

    if getgenv().AutoTargetToggle and isAimingNow and target and targetPartObj and hasWeapon then
        local targetPos = targetPartObj.Position
        local currentCamPos = workspace.CurrentCamera.CFrame.Position
        
        workspace.CurrentCamera.CFrame = CFrame.new(currentCamPos, targetPos)
        
        local lookDir = (targetPos - root.Position).Unit
        root.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(lookDir.X, 0, lookDir.Z))
    end

    if getgenv().AutoSerangToggle and hasWeapon then
        if not getgenv().AutoSerangDebounce then getgenv().AutoSerangDebounce = 0 end
        if tick() - getgenv().AutoSerangDebounce > 2.5 then
            
            local fireConditionMet = false

            if target and targetPartObj then
                local targetHum = target:FindFirstChildOfClass("Humanoid")
                local isStunned = false
                local isAttacking = false

                if targetHum then
                    for _, track in ipairs(targetHum:GetPlayingAnimationTracks()) do
                        local name = track.Name:lower()
                        local id = tonumber(string.match(track.Animation.AnimationId or "", "%d+"))
                        
                        if name:find("stun") or name:find("hit") then
                            if track.Speed > 0 then
                                isStunned = true
                                break
                            end
                        end
                        if (id and (attackanims[id] or lungeanims[id])) or (name:find("slash") or name:find("attack") or name:find("lunge") or name:find("swing") or name:find("stab") or name:find("knife") or name:find("throw")) then
                            if track.Speed > 0 then
                                isAttacking = true
                            end
                        end
                    end
                end

                if not isStunned then
                    local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(targetPartObj.Position)
                    if onScreen then
                        local distToTarget = (targetPartObj.Position - root.Position).Magnitude
                        
                        local aimPos
                        if UserInputService.TouchEnabled then
                            aimPos = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
                        else
                            local Pos = UserInputService:GetMouseLocation()
                            aimPos = Vector2.new(Pos.X, Pos.Y)
                        end
                        
                        local distFromAim = (Vector2.new(screenPos.X, screenPos.Y) - aimPos).Magnitude
                        
                        if (distToTarget <= 20) or (isAttacking and distToTarget <= 50) or (distFromAim <= 150 and distToTarget <= 60) then
                            local origin = workspace.CurrentCamera.CFrame.Position
                            local direction = (targetPartObj.Position - origin).Unit * (targetPartObj.Position - origin).Magnitude
                            
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterDescendantsInstances = {character}
                            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                            
                            local result = workspace:Raycast(origin, direction, raycastParams)
                            
                            if result and result.Instance:IsDescendantOf(target) then
                                fireConditionMet = true
                            end
                        end
                    end
                end
            end

            if fireConditionMet then
                getgenv().AutoSerangDebounce = tick()
                
                local targetPos = targetPartObj.Position
                local currentCamPos = workspace.CurrentCamera.CFrame.Position
                workspace.CurrentCamera.CFrame = CFrame.new(currentCamPos, targetPos)
                local lookDir = (targetPos - root.Position).Unit
                root.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(lookDir.X, 0, lookDir.Z))
                
                if UserInputService.TouchEnabled then
                    pressSpecialButton("Gui-mob")
                else
                    local Pos = UserInputService:GetMouseLocation()
                    VIM:SendMouseButtonEvent(Pos.X, Pos.Y, 0, true, game, 1)
                    VIM:SendMouseButtonEvent(Pos.X, Pos.Y, 0, false, game, 1)
                end
            end
        end
    end
end)

aimMobButtonConnectionDown = nil
aimMobButtonConnectionUp = nil

function HookMobileAimButton()
    if not UserInputService.TouchEnabled then return end
    
    task.spawn(function()
        local lastButton = nil
        while task.wait(2) do
            local pg = lp:FindFirstChild("PlayerGui")
            if pg then
                local survivor = pg:FindFirstChild("Survivor-mob")
                if survivor then
                    local controls = survivor:FindFirstChild("Controls")
                    if controls then
                        local button = controls:FindFirstChild("Gui-mob")
                        if button and (button:IsA("TextButton") or button:IsA("ImageButton")) and button ~= lastButton then
                            lastButton = button
                            if aimMobButtonConnectionDown then aimMobButtonConnectionDown:Disconnect() end
                            if aimMobButtonConnectionUp then aimMobButtonConnectionUp:Disconnect() end
                            
                            aimMobButtonConnectionDown = button.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    getgenv().isMobileAiming = true
                                end
                            end)
                            
                            aimMobButtonConnectionUp = button.InputEnded:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    getgenv().isMobileAiming = false
                                end
                            end)
                            
                            button.Destroying:Connect(function()
                                getgenv().isMobileAiming = false
                                lastButton = nil
                            end)
                        end
                    end
                end
            end
        end
    end)
end

HookMobileAimButton()

function createDropdown()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "roblox"
    if gethui then ScreenGui.Parent = gethui() elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = game.CoreGui else ScreenGui.Parent = game.CoreGui end

    local chosenOption = "Select Mask"
    local chosenMapped = "Rooster"
    local options = {"Chainsaw", "Deadly Punches", "Walk Faster", "Further Dash", "Vault Faster", "Complete Stealth", "Default Mask"}

    local optionMap = {
        ["Chainsaw"] = "Alex",
        ["Deadly Punches"] = "Tony",
        ["Walk Faster"] = "Brandon",
        ["Further Dash"] = "Cobra",
        ["Vault Faster"] = "Rabbit",
        ["Complete Stealth"] = "Richter",
        ["Default Mask"] = "Rooster"
    }

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0, 160, 0, 40)
    DropdownButton.Position = UDim2.new(0.68, 0, 0.05, 0)
    DropdownButton.Text = chosenOption
    DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownButton.TextColor3 = Color3.new(1, 1, 1)
    DropdownButton.Font = Enum.Font.SourceSansBold
    DropdownButton.TextSize = 18
    DropdownButton.Parent = ScreenGui
    DropdownButton.Active = true
    DropdownButton.Draggable = true

    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size = UDim2.new(0, 160, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 1, 0)
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Visible = false
    OptionsFrame.ClipsDescendants = true
    OptionsFrame.Parent = DropdownButton

    local optionHeight = 20
    for i, name in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, optionHeight)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * optionHeight)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 16
        btn.Text = name
        btn.Parent = OptionsFrame

        btn.MouseButton1Click:Connect(function()
            chosenOption = name
            chosenMapped = optionMap[name]
            DropdownButton.Text = chosenOption
            OptionsFrame.Visible = false
            OptionsFrame.Size = UDim2.new(0, 160, 0, 0)
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        if OptionsFrame.Visible then
            OptionsFrame.Visible = false
            OptionsFrame.Size = UDim2.new(0, 160, 0, 0)
        else
            OptionsFrame.Visible = true
            OptionsFrame.Size = UDim2.new(0, 160, 0, #options * optionHeight)
        end
    end)

    return {
        getSelection = function()
            return chosenOption, chosenMapped
        end
    }
end

lastAnim = nil
RunService.Heartbeat:Connect(function()
    if not root or not character then return end

    for _, obj in ipairs(getgenv().KillerCache or {}) do
        if obj and obj.Parent and obj:IsA("Model") and obj ~= character then
            local killerHum = obj:FindFirstChildOfClass("Humanoid")
            local killerRoot = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")

            if killerHum and killerRoot then
                local dist = (killerRoot.Position - root.Position).Magnitude
                
                -- Optimization: Check Backpack as well
                local dagger = character:FindFirstChild("Parrying Dagger") or lp.Backpack:FindFirstChild("Parrying Dagger")

                -- Optimization: Strict debounce check early to prevent lag and unwanted turning
                if Autoparry and dist < (ParryDistance + 25) and dagger then
                    if not dagger.Enabled then continue end
                    if (getgenv().NextAllowedParry and tick() < getgenv().NextAllowedParry) then continue end
                    if getgenv().ParryDebounce then continue end

                    local shouldParry = false

                    -- Logic Enhanced: "Gacor" Prediction & Anti-Miss
                    local ping = game:GetService("Players").LocalPlayer:GetNetworkPing()
                    local killerVel = killerRoot.Velocity
                    
                    -- Calculate closing speed (how fast they are approaching us)
                    local toPlayer = (root.Position - killerRoot.Position).Unit
                    local closingSpeed = killerVel:Dot(toPlayer)
                    
                    -- Prediction Factor: Increased aggressive buffer for "Anti Miss"
                    local predictionTime = math.clamp(ping, 0.05, 0.5) + 0.15 -- Reduced to prevent too far parries
                    if UserInputService.TouchEnabled then predictionTime = predictionTime + 0.5 end
                    
                    -- Check if killer is behind (Backstab prevention)
                    local facingDot = root.CFrame.LookVector:Dot(toPlayer)
                    if facingDot > 0 then
                         predictionTime = predictionTime + 0.2 -- More time for turn
                    end

                    local approachDist = 0
                    
                    if closingSpeed > 0 then
                        approachDist = closingSpeed * predictionTime
                    end

                    -- Effective Range
                    local effectiveRange = ParryDistance + approachDist -- Removed static buffer for tighter parry

                    -- Panic Mode: Increased threshold for guaranteed safety
                    local panicMode = dist < (ParryDistance - 5) -- Strictly close range only

                    -- Check animations
                    local isAttacking = false
                    for _, track in ipairs(killerHum:GetPlayingAnimationTracks()) do
                        local id = tonumber(string.match(track.Animation.AnimationId or "", "%d+"))
                        local name = track.Name:lower()

                        if name:find("walk") or name:find("idle") or name:find("run") or name:find("equip") or name:find("stun") or name:find("hit") then
                            continue
                        end

                        if (id and (attackanims[id] or lungeanims[id])) or
                           (name:find("slash") or name:find("attack") or name:find("lunge") or name:find("swing") or name:find("stab") or name:find("knife") or name:find("throw")) then
                            if track.Speed > 0 then
                                isAttacking = true
                                break
                            end
                        end
                    end

                    if isAttacking and dist <= effectiveRange then
                        shouldParry = true
                    elseif panicMode and isAttacking then
                        shouldParry = true 
                    end

                    if shouldParry then
                        if not (character:GetAttribute("IsHooked") or character:GetAttribute("IsCarried")) then
                            local function executeParry()
                                -- Failsafe: Reset debounce if stuck for too long (Reduced to 3s for better responsiveness)
                                if getgenv().ParryDebounce and (tick() - (getgenv().LastParryTime or 0) > 3) then
                                    getgenv().ParryDebounce = false
                                end

                                if getgenv().ParryDebounce then return end
                                
                                if (getgenv().NextAllowedParry and tick() < getgenv().NextAllowedParry) then return end
                                getgenv().NextAllowedParry = tick() + 50

                                getgenv().ParryDebounce = true
                                getgenv().LastParryTime = tick()
                                
                                -- Auto Equip Logic: Ensure tool is in hand
                                local tool = character:FindFirstChild("Parrying Dagger")
                                if not tool then
                                    tool = lp.Backpack:FindFirstChild("Parrying Dagger")
                                    if tool then 
                                        hum:EquipTool(tool)
                                    end
                                end

                                -- STRICT CHECK: If tool is not ready/enabled or missing, ABORT IMMEDIATELY.
                                -- This is critical to prevent "One-Time Use" bugs and unwanted rotation when on cooldown.
                                if not tool or not tool.Parent or (tool:IsA("Tool") and not tool.Enabled) then
                                    getgenv().ParryDebounce = false
                                    return
                                end

                                -- KUDA-KUDA (Stance) Logic
                                local oldWS = hum.WalkSpeed
                                pcall(function()
                                    hum.WalkSpeed = 0
                                    character:SetAttribute("Crouchingserver", true)
                                    game.ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", true)
                                    game.ReplicatedStorage.Remotes.Chase.Runevent:FireServer(character, false)
                                end)

                                -- Smart Face: Instantly face the killer before parrying (Only when necessary)
                                if SmartFace and killerRoot and root then
                                    local lookPos = Vector3.new(killerRoot.Position.X, root.Position.Y, killerRoot.Position.Z)
                                    if hum.AutoRotate then
                                        hum.AutoRotate = false
                                        task.delay(0.1, function() if hum then hum.AutoRotate = true end end)
                                    end
                                    root.CFrame = CFrame.lookAt(root.Position, lookPos)
                                end

                                -- Fire Remote (Main Thread)
                                game.ReplicatedStorage.Remotes.Items["Parrying Dagger"].parry:FireServer()

                                task.spawn(function()
                                    -- Use xpcall to ensure cleanup ALWAYS happens, fixing the "One-Time Use" bug
                                    local success, err = pcall(function()
                                        local currentTool = character:FindFirstChild("Parrying Dagger") or lp.Backpack:FindFirstChild("Parrying Dagger") or tool
                                        
                                        -- Activate Tool Locally for Animation
                                        pcall(function()
                                            if currentTool and currentTool:IsA("Tool") then
                                                currentTool:Activate()
                                            end
                                            game.ReplicatedStorage.Remotes.Items["Parrying Dagger"].parry:FireServer()
                                        end)

                                        -- Virtual Input Backup
                                        pcall(function()
                                            if game.UserInputService.TouchEnabled then
                                                pressSpecialButton("Gui-mob")
                                            else
                                                local Pos = game:GetService("UserInputService"):GetMouseLocation()
                                                VIM:SendMouseButtonEvent(Pos.X, Pos.Y, 0, true, game, 1)
                                                VIM:SendMouseButtonEvent(Pos.X, Pos.Y, 0, false, game, 1)
                                            end
                                        end)

                                        -- Wait for Cooldown (Auto Detect)
                                        task.wait(0.2) -- Allow game to update state
                                        local start = tick()
                                        
                                        -- Improved Loop: Checks tool existence strictly
                                        while (tick() - start < 4) do
                                            local t = character:FindFirstChild("Parrying Dagger") or lp.Backpack:FindFirstChild("Parrying Dagger")
                                            
                                            -- If tool is lost (destroyed/unequipped), assume done or broken
                                            if not t or not t.Parent then 
                                                break 
                                            end
                                            
                                            -- If tool is enabled again, cooldown is over
                                            if t.Enabled then 
                                                break 
                                            end
                                            
                                            task.wait(0.1)
                                        end
                                    end)

                                    if not success then
                                        warn("[AutoParry] Error: " .. tostring(err))
                                    end

                                    -- Restore State (Always Runs)
                                    pcall(function()
                                        if WalkToggle then
                                            hum.WalkSpeed = currentSpeed
                                        else
                                            hum.WalkSpeed = (oldWS < 16) and 16 or oldWS
                                        end
                                        if character then
                                            character:SetAttribute("Crouchingserver", false)
                                        end
                                        game.ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", false)
                                    end)

                                    getgenv().ParryDebounce = false
                                end)
                            end

                            if ParryDelay > 0 then
                                task.delay(ParryDelay, executeParry)
                            else
                                executeParry()
                            end
                        end
                    end
                end
            end
        end
    end
end)

function autodrop()
    task.spawn(function()
        while AutoDropToggle do
            task.wait(0.25)
            if not root or not character then continue end

            local nearestPallet = nil
            local shortestDistance = math.huge
            local rootPos = root.Position

            -- Optimized pallet search using ESP_Cache
            for _, obj in ipairs(getgenv().ESP_Cache or {}) do
                if obj and obj.Parent and string.find(obj.Name:lower(), "pallet") and obj:FindFirstChild("PalletPoint") then
                    local palletPos = obj:GetPivot().Position
                    local distance = (palletPos - rootPos).Magnitude

                    -- Pallet must be close to player (within 15 studs)
                    if distance < 15 and distance < shortestDistance then
                         shortestDistance = distance
                         nearestPallet = obj
                    end
                end
            end

            if nearestPallet then
                local nearestPalletPoint = nearestPallet:FindFirstChild("PalletPoint")

                if nearestPalletPoint then
                    local killerNearby = false
                    local palletCenter = nearestPallet:GetPivot().Position

                    -- Use KillerCache instead of scanning workspace
                    for _, obj in ipairs(getgenv().KillerCache or {}) do
                        if obj ~= character then
                            local killerRoot = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                            if killerRoot then
                                local distToPallet = (killerRoot.Position - palletCenter).Magnitude
                                -- If killer is within 10 studs of the pallet
                                if distToPallet < 10 then
                                    killerNearby = true
                                    break
                                end
                            end
                        end
                    end

                    if killerNearby then
                        if not AutoDropSetToggle and character:GetAttribute("IsCarried") then
                            -- Do nothing if carried and toggle is off
                        else
                            game.ReplicatedStorage.Remotes.Pallet.PalletDropEvent:FireServer(nearestPalletPoint)
                            -- Add a small cooldown to prevent spamming the remote for the same pallet action
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end)
end

desyncT = {enabled = false, loc = CFrame.new()}
prevLookVector = nil
isSpinning = false
spinThreshold = 15
desynchook = nil
heartbeatConn, charConn = nil, nil

function getOffsetCFrame()
    local ping = game:GetService("Players").LocalPlayer:GetNetworkPing() * 1000
    if ping < 100 then
        return CFrame.new(0, 0, -2)
    elseif ping <= 170 then
        return CFrame.new(0, 0, -2.7)
    else
        return CFrame.new(0, 0, -3.7)
    end
end

function enableHitboxDesync()
    if not hookmetamethod then
        warn("[Arexans] Executor does not support hookmetamethod. Hitbox Desync Skipped.")
        return
    end

    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not desyncT.enabled or not character then return end
        if not root then return end

        local currentLook = root.CFrame.LookVector
        if prevLookVector then
            local dot = math.clamp(prevLookVector:Dot(currentLook), -1, 1)
            local angleDiff = math.deg(math.acos(dot))
            isSpinning = angleDiff > spinThreshold
        end
        prevLookVector = currentLook

        if isSpinning then return end

        desyncT.loc = root.CFrame
        local offset = getOffsetCFrame()
        local newCFrame = desyncT.loc * offset
        root.CFrame = newCFrame

        root.CFrame = desyncT.loc
    end)

    desynchook = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if desyncT.enabled and not checkcaller() and
           key == "CFrame" and
           LocalPlayer.Character and
           self == LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
           not isSpinning then
            return desyncT.loc
        end
        return desynchook(self, key)
    end))

    charConn = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        prevLookVector = nil
        isSpinning = false
    end)
end

function disableHitboxDesync()
    desyncT.enabled = false
    if heartbeatConn then
        heartbeatConn:Disconnect()
        heartbeatConn = nil
    end
    if charConn then
        charConn:Disconnect()
        charConn = nil
    end
    if desynchook then
        desynchook = nil
    end
    prevLookVector = nil
    isSpinning = false
end

RemoveCrosshair = nil
CrosshairType = "crosshair dot"

function LoadCrosshair()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AXS_Crosshair"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 10000
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local parentSuccess, _ = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not parentSuccess then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    local crosshairMap = {
        ["crosshair dot"] = "rbxassetid://15240614328",
        ["crosshair dot 2"] = "rbxassetid://125887405613260",
        ["crosshair square"] = "rbxassetid://95081014476249",
        ["crosshair +•"] = "rbxassetid://13011888817",
        ["crosshair +"] = "rbxassetid://6587895205",
        ["crosshair O+"] = "rbxassetid://14599258630",
        ["crosshair O+ 2"] = "rbxassetid://96025442253083",
        ["Croshair (+)"] = "rbxassetid://135489154238728",
        ["Crosshair [ • ]"] = "rbxassetid://101370742207347",
        ["Crosshair [O+]"] = "rbxassetid://92175000437419",
        ["Crosshair star"] = "rbxassetid://16575721101"
    }

    local ImageId = crosshairMap[CrosshairType] or "rbxassetid://15240614328"

    local CrosshairImage = Instance.new("ImageLabel")
    CrosshairImage.Size = UDim2.new(0, 50, 0, 50)
    CrosshairImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    CrosshairImage.AnchorPoint = Vector2.new(0.5, 0.5)
    CrosshairImage.BackgroundTransparency = 1
    CrosshairImage.Image = ImageId
    CrosshairImage.ZIndex = 1000
    CrosshairImage.Parent = ScreenGui

    return function()
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end
end

-- UI IMPLEMENTATION

getgenv().KeybindConnections = {}

AllKeys = {}
for _, key in ipairs(Enum.KeyCode:GetEnumItems()) do
    table.insert(AllKeys, key.Name)
end
table.insert(AllKeys, "MB1")
table.insert(AllKeys, "MB2")

function AddBind(section, name, default, toggleHandle)
    local connectionName = "Keybind_" .. name
    
    local function updateKey(keyName)
        if getgenv().KeybindConnections[connectionName] then
            getgenv().KeybindConnections[connectionName]:Disconnect()
            getgenv().KeybindConnections[connectionName] = nil
        end
        
        if keyName == "" or keyName == "None" or keyName == nil then return end
        
        local keyType = "Keyboard"
        local key

        if keyName == "MB1" then
            keyType = "Mouse"
            key = Enum.UserInputType.MouseButton1
        elseif keyName == "MB2" then
            keyType = "Mouse"
            key = Enum.UserInputType.MouseButton2
        else
            pcall(function() key = Enum.KeyCode[keyName] end)
        end
        
        if key then
            getgenv().KeybindConnections[connectionName] = UserInputService.InputBegan:Connect(function(input, gp)
                if not gp then
                    local pressed = false
                    if keyType == "Keyboard" and input.KeyCode == key then
                        pressed = true
                    elseif keyType == "Mouse" and input.UserInputType == key then
                        pressed = true
                    end

                    if pressed then
                        if toggleHandle then
                            if type(toggleHandle) == "function" then
                                toggleHandle()
                            elseif type(toggleHandle) == "table" and toggleHandle.Set then
                                toggleHandle:Set(not toggleHandle.Value)
                            end
                        end
                    end
                end
            end)
        end
    end

    section:AddDropdown({
        Title = name,
        Options = AllKeys,
        Default = default or "None",
        Callback = updateKey
    })
    
    updateKey(default)
end

MouseCursorState = false
function ToggleMouseCursor()
    if UserInputService.TouchEnabled then return end
    MouseCursorState = not MouseCursorState
    UserInputService.MouseIconEnabled = MouseCursorState
    if MouseCursorState then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end

FPSLabel, FPSGui, FPSLoop = nil, nil, nil
function CreateFPS()
    if FPSGui then return end
    FPSGui = Instance.new("ScreenGui")
    FPSGui.Name = "AXS_FPS"
    getgenv().AXS_FPS_GUI = FPSGui
    if gethui then FPSGui.Parent = gethui() elseif syn and syn.protect_gui then syn.protect_gui(FPSGui) FPSGui.Parent = game.CoreGui else FPSGui.Parent = game.CoreGui end
    
    FPSLabel = Instance.new("TextLabel")
    FPSLabel.Size = UDim2.new(0, 100, 0, 30)
    FPSLabel.Position = UDim2.new(1, -110, 0, 10)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Font = Enum.Font.GothamBold
    FPSLabel.TextSize = 18
    FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    FPSLabel.TextStrokeTransparency = 0.5
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
    FPSLabel.Parent = FPSGui
    
    local lastUpdate = 0
    local frameCount = 0
    
    FPSLoop = RunService.RenderStepped:Connect(function(dt)
        frameCount = frameCount + 1
        if tick() - lastUpdate >= 1 then
            local fps = frameCount
            lastUpdate = tick()
            frameCount = 0
            
            if FPSLabel then
                FPSLabel.Text = "FPS: " .. fps
                if fps < 30 then
                    FPSLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                elseif fps < 55 then
                    FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                else
                    FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                end
            end
        end
    end)
end

function RemoveFPS()
    if FPSLoop then FPSLoop:Disconnect() FPSLoop = nil end
    if FPSGui then 
        FPSGui:Destroy() 
        FPSGui = nil 
        getgenv().AXS_FPS_GUI = nil
    end
end



-- ============================================================
-- AXS EXTRA TOGGLES: DBD CAMERA / SNOW PING FPS / LOCK TARGET
-- Integrated version: no standalone source UIs or hotkeys.
-- ============================================================
local __AXS_EXTRA = {
    DBD = {Enabled=false, Distance=25, FOV=120, Height=0, CharScale=0.05, UseCharScale=true,
           Conn=nil, DefaultFOV=nil, DefaultMinZoom=nil, DefaultMaxZoom=nil, OriginalScale=nil, ScaleSaved=false},
    PingFPS = {Enabled=false, Gui=nil, Conn=nil, Frames=0, LastUpdate=0},
    Lock = {Enabled=false, MaxDistance=50, Target=nil, Conn=nil}
}

local function __AXS_ExtraParent()
    local p
    pcall(function() if type(gethui)=="function" then p=gethui() end end)
    if p then return p end
    p=game:GetService("CoreGui")
    if p then return p end
    return LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui",10)
end

-- ---------------- DBD CAMERA ----------------
local function __AXS_DBD_SaveScaleDefaults()
    local s=__AXS_EXTRA.DBD
    local c=LocalPlayer.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    if not h or s.ScaleSaved then return end
    local names={"BodyHeightScale","BodyWidthScale","BodyDepthScale","HeadScale"}
    s.OriginalScale={}
    for _,name in ipairs(names) do
        local v=h:FindFirstChild(name)
        if v and v:IsA("NumberValue") then
            s.OriginalScale[name]=v.Value
        end
    end
    s.ScaleSaved=true
end

local function __AXS_DBD_SaveDefaults()
    local cam=workspace.CurrentCamera
    local s=__AXS_EXTRA.DBD
    if cam and s.DefaultFOV==nil then
        s.DefaultFOV=cam.FieldOfView
        s.DefaultMinZoom=LocalPlayer.CameraMinZoomDistance
        s.DefaultMaxZoom=LocalPlayer.CameraMaxZoomDistance
    end
    __AXS_DBD_SaveScaleDefaults()
end

local function __AXS_DBD_ApplyScale()
    local s=__AXS_EXTRA.DBD
    if not s.UseCharScale then return end
    local c=LocalPlayer.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    local names={"BodyHeightScale","BodyWidthScale","BodyDepthScale","HeadScale"}
    for _,name in ipairs(names) do
        local v=h:FindFirstChild(name)
        if v and v:IsA("NumberValue") then
            v.Value=s.CharScale
        end
    end
end

local function __AXS_DBD_RestoreScale()
    local s=__AXS_EXTRA.DBD
    local c=LocalPlayer.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    local names={"BodyHeightScale","BodyWidthScale","BodyDepthScale","HeadScale"}
    for _,name in ipairs(names) do
        local v=h:FindFirstChild(name)
        local old=s.OriginalScale and s.OriginalScale[name]
        if v and v:IsA("NumberValue") and old~=nil then
            v.Value=old
        end
    end
end

local function __AXS_DBD_ApplySettings()
    local s=__AXS_EXTRA.DBD
    if not s.Enabled then return end
    local cam=workspace.CurrentCamera
    if cam then cam.FieldOfView=math.clamp(tonumber(s.FOV) or 120,20,170) end
    LocalPlayer.CameraMaxZoomDistance=math.max(0.5,tonumber(s.Distance) or 25)
    LocalPlayer.CameraMinZoomDistance=math.max(0.1,(tonumber(s.Distance) or 25)-0.5)
    local c=LocalPlayer.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    if h then
        h.CameraOffset=Vector3.new(0,tonumber(s.Height) or 0,0)
    end
    __AXS_DBD_ApplyScale()
end

local function __AXS_DBD_Reset()
    local s=__AXS_EXTRA.DBD
    if s.Conn then s.Conn:Disconnect(); s.Conn=nil end
    __AXS_DBD_RestoreScale()
    local c=LocalPlayer.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h.CameraOffset=Vector3.zero end) end
    local cam=workspace.CurrentCamera
    if cam and s.DefaultFOV~=nil then cam.FieldOfView=s.DefaultFOV end
    if s.DefaultMaxZoom~=nil then LocalPlayer.CameraMaxZoomDistance=s.DefaultMaxZoom end
    if s.DefaultMinZoom~=nil then LocalPlayer.CameraMinZoomDistance=s.DefaultMinZoom end
end

local function __AXS_DBD_Set(on)
    local s=__AXS_EXTRA.DBD
    s.Enabled=on==true
    if s.Enabled then
        __AXS_DBD_SaveDefaults()
        __AXS_DBD_ApplySettings()
        if s.Conn then s.Conn:Disconnect() end
        s.Conn=RunService.RenderStepped:Connect(function()
            if not s.Enabled then return end
            __AXS_DBD_ApplySettings()
        end)
    else
        __AXS_DBD_Reset()
    end
end

local function __AXS_DBD_UpdateSetting(key,value)
    local s=__AXS_EXTRA.DBD
    if key=="Distance" then
        s.Distance=math.clamp(tonumber(value) or 25,5,100)
    elseif key=="FOV" then
        s.FOV=math.clamp(tonumber(value) or 120,40,160)
    elseif key=="Height" then
        s.Height=math.clamp(tonumber(value) or 0,-5,10)
    elseif key=="CharScale" then
        s.CharScale=math.clamp(tonumber(value) or 0.05,0.01,1)
    elseif key=="UseCharScale" then
        s.UseCharScale=value==true
    end
    if s.Enabled then __AXS_DBD_ApplySettings() end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.35)
    if __AXS_EXTRA.DBD.Enabled then
        __AXS_EXTRA.DBD.ScaleSaved=false
        __AXS_DBD_SaveScaleDefaults()
        __AXS_DBD_ApplySettings()
    end
    if __AXS_EXTRA.Lock.Enabled then __AXS_EXTRA.Lock.Target=nil end
end)

-- ---------------- LOCK TARGET HIDDEN ----------------
local function __AXS_LockIsSurvivor(p)
    return p and p.Team and p.Team.Name=="Survivors"
end

local function __AXS_LockIsDowned(c)
    if not c then return true end
    if c:GetAttribute("Knocked")==true or c:GetAttribute("IsHooked")==true then return true end
    local h=c:FindFirstChildOfClass("Humanoid") or c:FindFirstChild("Humanoid")
    return h and h.Health<=0 or false
end

local function __AXS_LockClosest()
    local c=LocalPlayer.Character
    local root=c and c:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local s=__AXS_EXTRA.Lock
    local best,bestD=nil,s.MaxDistance+1
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and __AXS_LockIsSurvivor(p) and p.Character and not __AXS_LockIsDowned(p.Character) then
            local r=p.Character:FindFirstChild("HumanoidRootPart")
            local h=p.Character:FindFirstChildOfClass("Humanoid") or p.Character:FindFirstChild("Humanoid")
            if r and h and h.Health>0 then
                local d=(r.Position-root.Position).Magnitude
                if d<=s.MaxDistance and d<bestD then bestD=d; best=r end
            end
        end
    end
    return best
end

local function __AXS_LockSet(on)
    local s=__AXS_EXTRA.Lock
    s.Enabled=on==true
    s.Target=nil
    if s.Conn then s.Conn:Disconnect(); s.Conn=nil end
    if s.Enabled then
        s.Conn=RunService.RenderStepped:Connect(function()
            if not s.Enabled then return end
            local target=__AXS_LockClosest()
            s.Target=target
            if target and target.Parent then
                local cam=workspace.CurrentCamera
                if cam then pcall(function() cam.CFrame=CFrame.new(cam.CFrame.Position,target.Position) end) end
            end
        end)
    end
end

Window = Lib:Window({
    Title = "AXS VD " .. getTag(lp.Name),
    Footer = "Violence Distric By Arexans",
    Color = Color3.fromRGB(0, 170, 255),
    Image = "122503252139031",
    Version = 1,
    ["Tab Width"] = 120
})

Window:SetToggleKey(Enum.KeyCode.K)

LogsTab = Window:AddTab({ Name = "Logs", Icon = "scroll" })
UniversalTab = Window:AddTab({ Name = "Universal", Icon = "web" })
KillerTab = Window:AddTab({ Name = "Pembunuh", Icon = "sword" })
SurvivorTab = Window:AddTab({ Name = "Penyintas", Icon = "user" })
EspTab = Window:AddTab({ Name = "ESP", Icon = "eyes" })
PlayerTab = Window:AddTab({ Name = "Pemain", Icon = "player" })
MiscTab = Window:AddTab({ Name = "Lainnya", Icon = "menu" })
ConfigTab = Window:AddTab({ Name = "Konfigurasi", Icon = "settings" })
ServerTab = Window:AddTab({ Name = "Server", Icon = "web" })
KeybindTab = Window:AddTab({ Name = "Keybinds", Icon = "rbxassetid://10709752906" })

-- SERVER

ServerControls = ServerTab:AddSection("Server Controls", true)

ServerControls:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

ServerControls:AddButton({
    Title = "Hop Random Server",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"
        local _place = game.PlaceId
        local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"
        
        local function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
            return Http:JSONDecode(Raw)
        end
        
        local Server, Next; repeat
            local Servers = ListServers(Next)
            Server = Servers.data[math.random(1, #Servers.data)]
            Next = Servers.nextPageCursor
        until Server
        
        TPS:TeleportToPlaceInstance(_place, Server.id, game.Players.LocalPlayer)
    end
})

ServerControls:AddButton({
    Title = "Hop Low Pop Server",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"
        local _place = game.PlaceId
        local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"
        
        local function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
            return Http:JSONDecode(Raw)
        end
        
        local Server, Next;
        local BestServer = nil
        
        repeat
            local Servers = ListServers(Next)
            for _, s in ipairs(Servers.data) do
                if s.playing < s.maxPlayers - 1 and s.id ~= game.JobId then
                    if not BestServer or s.playing < BestServer.playing then
                        BestServer = s
                    end
                end
            end
            Next = Servers.nextPageCursor
        until not Next or (BestServer and BestServer.playing < 5)
        
        if BestServer then
            TPS:TeleportToPlaceInstance(_place, BestServer.id, game.Players.LocalPlayer)
        else
            Lib:MakeNotify({ Title = "Server Hop", Content = "No low population server found.", Time = 3 })
        end
    end
})

ServerList = ServerTab:AddSection("Server List", true)
-- Keep the server browser inside the page content bounds; use one consistent
-- inset so header, list, cards and buttons never overlap each other.
ServerFrame = Instance.new("ScrollingFrame")
ServerFrame.Position = UDim2.new(0, 9, 0, 17)
ServerFrame.Size = UDim2.new(1, -18, 1, -20)
ServerFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
ServerFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ServerFrame.ClipsDescendants = true
ServerFrame.ScrollingEnabled = true
ServerFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
ServerFrame.BackgroundTransparency = 1
ServerFrame.BorderSizePixel = 0
ServerFrame.ZIndex = 3
ServerFrame.ScrollBarThickness = 3
ServerFrame.Active = true
ServerFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ServerFrame.ScrollBarImageColor3 = Color3.fromRGB(35, 180, 255)
ServerFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
ServerFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
if not ServerList or not ServerList.SectionAdd then
    error("[AXS VD] Server List container could not be created")
end
ServerFrame.Parent = ServerList.SectionAdd
ServerFrame.ClipsDescendants = true
ServerFrame.Active = true
ServerFrame.ScrollingEnabled = true
ServerFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ServerList.SectionAdd.ClipsDescendants = true
ServerList.SectionAdd.BackgroundTransparency = 1
ServerList.SectionAdd.Active = true
ServerList.SectionAdd.BorderSizePixel = 0

UIListLayoutServer = Instance.new("UIListLayout")
UIListLayoutServer.Parent = ServerFrame
UIListLayoutServer.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutServer.Padding = UDim.new(0, 2)
UIListLayoutServer.HorizontalAlignment = Enum.HorizontalAlignment.Center

UIListLayoutServer:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(0, UIListLayoutServer.AbsoluteContentSize.Y + 4))
end)

currentServerFilter = "Normal"

function RefreshServerList()
    for _, v in ipairs(ServerFrame:GetChildren()) do
        if v.Name == "ServerEntry" or v:IsA("Frame") then v:Destroy() end
    end
    
    local Http = game:GetService("HttpService")
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"
    
    task.spawn(function()
        local success, result = pcall(function()
            return game:HttpGet(Api)
        end)
        
        if success then
            local decodeOK, data = pcall(function() return Http:JSONDecode(result) end)
            if decodeOK and data and type(data.data) == "table" then
                local filteredData = {}
                for _, s in ipairs(data.data) do
                    if currentServerFilter == "Low" and s.playing > 5 then continue end
                    if s.playing < s.maxPlayers - 1 and s.id ~= game.JobId then
                        table.insert(filteredData, s)
                    end
                end
                
                if currentServerFilter == "Fast" then
                    table.sort(filteredData, function(a, b)
                        return (a.ping or 0) < (b.ping or 0)
                    end)
                end

                for _, server in ipairs(filteredData) do
                        local SFrame = Instance.new("ImageLabel")
                        SFrame.Name = "ServerEntry"
                        SFrame.Position = UDim2.new(0, 0, 0, 0)
                        SFrame.Size = UDim2.new(1, -12, 0, 38)
                        SFrame.ClipsDescendants = true
                        SFrame.BackgroundTransparency = 1
                        SFrame.BorderSizePixel = 0
                        SFrame.LayoutOrder = _
                        SFrame.ZIndex = 4
                        SFrame.ScaleType = Enum.ScaleType.Stretch
                        -- Use the existing Arexans horizontal-box asset instead of the generic blue card.
                        local getAsset = getcustomasset or getsynasset
                        local assetPath = "ArexansUI_Assets/long_horizonal_box.png"
                        local assetOK, assetURI = pcall(function()
                            if getAsset and isfile and isfile(assetPath) then
                                return getAsset(assetPath)
                            end
                        end)
                        if assetOK and assetURI then
                            SFrame.Image = assetURI
                        else
                            SFrame.Image = ""
                            SFrame.BackgroundColor3 = Color3.fromRGB(5, 28, 62)
                            SFrame.BackgroundTransparency = 0.18
                        end
                        SFrame.Parent = ServerFrame

                        local ServerIcon = Instance.new("ImageLabel")
                        ServerIcon.Name = "ServerIcon"
                        ServerIcon.BackgroundTransparency = 1
                        ServerIcon.Visible = true
                        -- Asset downloader flattens folders into filenames with underscores.
                        local serverIconAsset = "ArexansUI_Assets/icons_server_global.png"
                        pcall(function()
                            local getAsset = getcustomasset or getsynasset
                            if getAsset and isfile and isfile(serverIconAsset) then
                                ServerIcon.Image = getAsset(serverIconAsset)
                            end
                        end)
                        ServerIcon.Size = UDim2.fromOffset(20, 20)
                        ServerIcon.Position = UDim2.new(0, 15, 0.5, -10)
                        ServerIcon.ScaleType = Enum.ScaleType.Fit
                        ServerIcon.ZIndex = 5
                        ServerIcon.Parent = SFrame
                        
                        local Info = Instance.new("TextLabel")
                        Info.Size = UDim2.new(1, -122, 1, 0)
                        Info.Position = UDim2.new(0, 40, 0, 0)
                        Info.BackgroundTransparency = 1
                        Info.TextXAlignment = Enum.TextXAlignment.Left
                        Info.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Info.Font = Enum.Font.Gotham
                        Info.TextSize = 9
                        Info.TextTruncate = Enum.TextTruncate.AtEnd
                        Info.RichText = true
                        Info.ZIndex = 5
                        
                        local ping = server.ping or 0
                        local pingColor = "00FF00"
                        if ping > 200 then pingColor = "FF0000"
                        elseif ping > 100 then pingColor = "FFFF00"
                        end

                        Info.Text = string.format("%d/%d Players | Ping: <font color='#%s'>%d</font> | FPS: %d", server.playing, server.maxPlayers, pingColor, ping, server.fps or 0)
                        Info.Parent = SFrame
                        
                        local JoinBtn = Instance.new("ImageButton")
                        JoinBtn.Name = "JoinButton"
                        JoinBtn.Size = UDim2.new(0, 50, 0, 25)
                        JoinBtn.AnchorPoint = Vector2.new(1, 0.5)
                        JoinBtn.Position = UDim2.new(1, -22, 0.5, -2)
                        JoinBtn.BackgroundTransparency = 1
                        JoinBtn.AutoButtonColor = false
                        JoinBtn.ScaleType = Enum.ScaleType.Stretch
                        JoinBtn.Image = "rbxassetid://0"
                        JoinBtn.ZIndex = 6
                        JoinBtn.Parent = SFrame
                        pcall(function()
                            local getAsset = getcustomasset or getsynasset
                            local assetPath = "ArexansUI_Assets/button.png"
                            if getAsset and isfile and isfile(assetPath) then
                                JoinBtn.Image = getAsset(assetPath)
                            end
                        end)

                        local JoinLabel = Instance.new("TextLabel")
                        JoinLabel.Name = "JoinLabel"
                        JoinLabel.BackgroundTransparency = 1
                        JoinLabel.Size = UDim2.fromScale(1, 1)
                        JoinLabel.Font = Enum.Font.GothamBold
                        JoinLabel.Text = "Join"
                        JoinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        JoinLabel.TextSize = 10
                        JoinLabel.TextXAlignment = Enum.TextXAlignment.Center
                        JoinLabel.ZIndex = 7
                        JoinLabel.Parent = JoinBtn

                        JoinBtn.MouseButton1Click:Connect(function()
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, game.Players.LocalPlayer)
                        end)
                end
            end
        end
    end)
end

-- Resolve a safe header host: custom-section implementations can differ between
-- executor environments. Never index Parent without checking it first.
local ServerSectionRoot = ServerList and ServerList.SectionRoot
if not ServerSectionRoot and ServerList and ServerList.SectionAdd then
    ServerSectionRoot = ServerList.SectionAdd.Parent
end
if not ServerSectionRoot then
    warn("[AXS VD] Server List root unavailable; creating a safe Arexans-backed fallback")
    local screen = (Window and Window._ui and Window._ui._screenGui) or game:GetService("CoreGui")
    ServerSectionRoot = Instance.new("ImageLabel")
    ServerSectionRoot.Name = "ServerListFallbackRoot"
    ServerSectionRoot.BackgroundTransparency = 1
    ServerSectionRoot.Image = ""
    ServerSectionRoot.Size = UDim2.new(1, 0, 0, 328)
    ServerSectionRoot.Parent = screen
    if not ServerList then ServerList = {} end
    if not ServerList.SectionAdd then
        ServerList.SectionAdd = Instance.new("Frame")
        ServerList.SectionAdd.Name = "SectionAdd"
        ServerList.SectionAdd.BackgroundTransparency = 1
        ServerList.SectionAdd.Size = UDim2.new(1, -16, 0, 300)
        ServerList.SectionAdd.Position = UDim2.new(0, 8, 0, 26)
        ServerList.SectionAdd.Parent = ServerSectionRoot
    end
end
-- Validated Server Page geometry from Live Layout Editor.
-- The list container remains the same size; only its placement and child controls change.
pcall(function()
    if ServerSectionRoot:IsA("GuiObject") then
        ServerSectionRoot.Position = UDim2.new(0, 6, 0, 31)
        ServerSectionRoot.Size = UDim2.new(1, 0, 0, 328)
        ServerSectionRoot.AnchorPoint = Vector2.new(0, 0)
        ServerSectionRoot.Visible = true
        ServerSectionRoot.ZIndex = 1
    end
    if ServerList and ServerList.SectionAdd then
        ServerList.SectionAdd.Position = UDim2.new(0, 8, 0, 26)
        ServerList.SectionAdd.Size = UDim2.new(1, -16, 0, 300)
        ServerList.SectionAdd.AnchorPoint = Vector2.new(0, 0)
        ServerList.SectionAdd.ClipsDescendants = true
        ServerList.SectionAdd.ZIndex = 2
    end
end)

-- Final server-page layout aligned to the supplied Live Layout Editor reference.
-- Keep the main panel intact; clip all list content to its own scrolling viewport.
pcall(function()
    if ServerList and ServerList.SectionAdd then
        ServerList.SectionAdd.Position = UDim2.new(0, 8, 0, 26)
        ServerList.SectionAdd.Size = UDim2.new(1, -16, 0, 300)
        ServerList.SectionAdd.ClipsDescendants = true
        ServerList.SectionAdd.BackgroundTransparency = 1
    end
    if ServerFrame then
        ServerFrame.Position = UDim2.new(0, 9, 0, 17)
        ServerFrame.Size = UDim2.new(1, -12, 1, -68)
        ServerFrame.AnchorPoint = Vector2.new(0, 0)
        ServerFrame.ClipsDescendants = true
        ServerFrame.ScrollingEnabled = true
        ServerFrame.Active = true
        ServerFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        ServerFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
        ServerFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    end
    if UIListLayoutServer then
        UIListLayoutServer.Padding = UDim.new(0, 2)
        UIListLayoutServer.HorizontalAlignment = Enum.HorizontalAlignment.Center
    end
end)

-- Use a dedicated Arexans asset behind the server list (not containers/panel.png).
pcall(function()
    ServerSectionRoot.BackgroundTransparency = 1
    ServerSectionRoot.BorderSizePixel = 0
    ServerSectionRoot.ClipsDescendants = true
    if ServerSectionRoot:IsA("ImageLabel") or ServerSectionRoot:IsA("ImageButton") then
        ServerSectionRoot.Image = ""
    end
    local oldBackdrop = ServerSectionRoot:FindFirstChild("ServerListAssetBackdrop")
    if oldBackdrop then oldBackdrop:Destroy() end
    local backdrop = Instance.new("ImageLabel")
    backdrop.Name = "ServerListAssetBackdrop"
    backdrop.BackgroundTransparency = 1
    backdrop.BorderSizePixel = 0
    backdrop.Position = UDim2.new(0, 4, 0, 26)
    backdrop.Size = UDim2.new(1, -8, 1, -30)
    backdrop.ScaleType = Enum.ScaleType.Stretch
    backdrop.Image = "rbxassetid://0"
    backdrop.ZIndex = 1
    backdrop.Parent = ServerSectionRoot
    local getAsset = getcustomasset or getsynasset
    local assetPath = "ArexansUI_Assets/containers_panel2.png"
    pcall(function()
        if getAsset and isfile and isfile(assetPath) then
            backdrop.Image = getAsset(assetPath)
        end
    end)
    ServerListAssetBackdrop = backdrop
end)
-- Asset-backed header strip: the title must sit on an actual Arexans image,
-- not float directly over the window art.
pcall(function()
    local oldHeaderArt = ServerSectionRoot:FindFirstChild("ServerHeaderAsset")
    if oldHeaderArt then oldHeaderArt:Destroy() end
    local headerArt = Instance.new("ImageLabel")
    headerArt.Name = "ServerHeaderAsset"
    headerArt.BackgroundTransparency = 1
    headerArt.BorderSizePixel = 0
    headerArt.Position = UDim2.new(0, 0, 0, 0)
    headerArt.Size = UDim2.new(1, 5, 0, 35)
    headerArt.ScaleType = Enum.ScaleType.Stretch
    headerArt.ZIndex = 2
    headerArt.Parent = ServerSectionRoot
    local getAsset = getcustomasset or getsynasset
    local assetPath = "ArexansUI_Assets/long_horizonal_box.png"
    if getAsset and isfile and isfile(assetPath) then
        headerArt.Image = getAsset(assetPath)
    end
end)
SectionHeader = ServerSectionRoot:FindFirstChild("Title")
if not SectionHeader then
    SectionHeader = Instance.new("TextLabel")
    SectionHeader.Name = "Title"
    SectionHeader.BackgroundTransparency = 1
    SectionHeader.Size = UDim2.new(1, -78, 0, 24)
    SectionHeader.Position = UDim2.new(0, 12, 0, 0)
    SectionHeader.Text = "Server List"
    SectionHeader.TextColor3 = Color3.fromRGB(225, 245, 255)
    SectionHeader.Font = Enum.Font.GothamBold
    SectionHeader.TextSize = 11
    SectionHeader.TextXAlignment = Enum.TextXAlignment.Left
    SectionHeader.Parent = ServerSectionRoot
end
pcall(function()
    SectionHeader.BackgroundTransparency = 1
    SectionHeader.Position = UDim2.new(0, 19, 0, 5)
    SectionHeader.Size = UDim2.new(1, -78, 0, 24)
    SectionHeader.Text = "Server List"
    SectionHeader.TextSize = 11
    SectionHeader.TextXAlignment = Enum.TextXAlignment.Left
    SectionHeader.TextYAlignment = Enum.TextYAlignment.Center
    SectionHeader.ZIndex = 3
end)

-- Server icons are standalone; only the Filter and Refresh controls use background tiles.
pcall(function()
    for _, obj in ipairs(ServerSectionRoot:GetDescendants()) do
        if obj.Name == "ServerIconBacking" then obj:Destroy() end
    end
    for _, obj in ipairs(ServerFrame:GetDescendants()) do
        if obj.Name == "ServerIcon" and obj:IsA("GuiObject") then
            obj.BackgroundTransparency = 1
            obj.Position = UDim2.new(0, 9, 0.5, -10)
            obj.Size = UDim2.fromOffset(20, 20)
        elseif obj.Name == "JoinButton" and obj:IsA("GuiObject") then
            obj.Position = UDim2.new(1, -22, 0.5, -2)
            obj.Size = UDim2.fromOffset(50, 25)
        elseif obj.Name == "JoinLabel" and obj:IsA("GuiObject") then
            obj.Position = UDim2.new(0, 0, 0, 0)
            obj.Size = UDim2.new(1, 0, 1, 0)
        elseif obj.Name == "TextLabel" and obj.Parent and obj.Parent.Name == "ServerEntry" and obj:IsA("GuiObject") then
            obj.Position = UDim2.new(0, 40, 0, 0)
            obj.Size = UDim2.new(1, -122, 1, 0)
        end
    end
end)

-- Header controls use Arexans icon assets (no third-party Roblox asset IDs).
local function MakeHeaderAssetButton(name, iconAsset, rightOffset)
    local holder = Instance.new("ImageLabel")
    holder.Name = name .. "Background"
    holder.BackgroundTransparency = 1
    holder.AnchorPoint = Vector2.new(1, 0)
    holder.Position = UDim2.new(1, rightOffset, 0, 2)
    holder.Size = UDim2.fromOffset(25, 22)
    holder.ScaleType = Enum.ScaleType.Stretch
    holder.ZIndex = 4
    holder.Parent = SectionHeader
    pcall(function()
        local getAsset = getcustomasset or getsynasset
        local path = "ArexansUI_Assets/popup_header_frame_center.png"
        if getAsset and isfile and isfile(path) then holder.Image = getAsset(path) end
    end)
    local button = Instance.new("ImageButton")
    button.Name = name
    button.BackgroundTransparency = 1
    button.AutoButtonColor = false
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.Position = UDim2.fromScale(0.5, 0.5)
    button.Size = UDim2.fromOffset(16, 16)
    button.ScaleType = Enum.ScaleType.Fit
    button.ZIndex = 5
    button.Parent = holder
    pcall(function()
        local getAsset = getcustomasset or getsynasset
        local path = "ArexansUI_Assets/" .. iconAsset:gsub("/", "_")
        if getAsset and isfile and isfile(path) then button.Image = getAsset(path) end
    end)
    return button
end

RefreshIcon = MakeHeaderAssetButton("RefreshIcon", "icons/refresh.png", 33)
FilterIcon = MakeHeaderAssetButton("FilterIcon", "icons/filter_sliders.png", 6)

RefreshIcon.MouseButton1Click:Connect(function()
    RefreshServerList()
end)

FilterIcon.MouseButton1Click:Connect(function()
    if currentServerFilter == "Normal" then
        currentServerFilter = "Low"
        Lib:MakeNotify({ Title = "Server Filter", Content = "Filter Active: Low Server (Sepi)", Time = 2 })
    elseif currentServerFilter == "Low" then
        currentServerFilter = "Fast"
        Lib:MakeNotify({ Title = "Server Filter", Content = "Filter Active: Ping Fast (Cepat)", Time = 2 })
    else
        currentServerFilter = "Normal"
        Lib:MakeNotify({ Title = "Server Filter", Content = "Filter Active: Normal", Time = 2 })
    end
    RefreshServerList()
end)


-- Final layout safeguards: compact server rows remain clipped to the backdrop viewport.
-- ServerListAssetBackdrop occupies (4,26) through (width-4,height-4) of ServerSectionRoot.
-- SectionAdd and ServerFrame are inset inside that image, leaving a small safety margin
-- so the last visible row can never draw beyond the decorative panel frame.
do
    pcall(function()
        if ServerSectionRoot and ServerSectionRoot:IsA("GuiObject") then
            ServerSectionRoot.ClipsDescendants = true
        end
        if ServerList and ServerList.SectionAdd then
            local section = ServerList.SectionAdd
            section.Position = UDim2.new(0, 8, 0, 26)
            section.Size = UDim2.new(1, -16, 0, 298)
            section.AnchorPoint = Vector2.new(0, 0)
            section.ClipsDescendants = true
            section.Active = true
            section.BackgroundTransparency = 1
            section.BorderSizePixel = 0
            section.ZIndex = 2
        end
        if ServerFrame then
            ServerFrame.Position = UDim2.new(0, 9, 0, 17)
            ServerFrame.Size = UDim2.new(1, -18, 1, -34)
            ServerFrame.AnchorPoint = Vector2.new(0, 0)
            ServerFrame.BackgroundTransparency = 1
            ServerFrame.BorderSizePixel = 0
            ServerFrame.ClipsDescendants = true
            ServerFrame.ScrollingEnabled = true
            ServerFrame.ScrollingDirection = Enum.ScrollingDirection.Y
            ServerFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
            ServerFrame.Active = true
            ServerFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
            ServerFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
            ServerFrame.ScrollBarThickness = 3
            ServerFrame.ZIndex = 3
        end
        if UIListLayoutServer then
            UIListLayoutServer.Padding = UDim.new(0, 2)
            UIListLayoutServer.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayoutServer.HorizontalAlignment = Enum.HorizontalAlignment.Center
        end
        if ServerFrame then
            local layout = ServerFrame:FindFirstChildOfClass("UIListLayout")
            if layout then
                local updatingCanvas = false
                local function updateCanvas()
                    if updatingCanvas or not ServerFrame.Parent then return end
                    updatingCanvas = true
                    -- AbsoluteContentSize includes row heights and the 2 px gaps.
                    -- Do not force the canvas to viewport height: this keeps vertical scrolling real.
                    ServerFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(0, math.ceil(layout.AbsoluteContentSize.Y + 2)))
                    updatingCanvas = false
                end
                layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
                ServerFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas)
                task.defer(updateCanvas)
            end
        end
        -- Each row is compact and has no extra vertical offset; UIListLayout owns its placement.
        for _, row in ipairs(ServerFrame:GetChildren()) do
            if row.Name == "ServerEntry" and row:IsA("GuiObject") then
                row.Position = UDim2.new(0, 0, 0, 0)
                row.Size = UDim2.new(1, -8, 0, 38)
                row.ClipsDescendants = true
            end
        end
    end)
end

-- Live Layout Editor removed from the main script.
RefreshServerList()

KeybindSection = KeybindTab:AddSection("Keybinds", true)

KeybindSection:AddButton({
    Title = "Save Keybinds",
    Callback = function()
        Lib:Save()
    end
})

KeybindSection:AddButton({
    Title = "Reset Keybinds",
    Callback = function()
        Lib:ResetAll()
    end
})

-- LOGS
-- Teks dipendekkan agar muat pada kolom UI dua sisi tanpa saling menimpa.
LogsSection = LogsTab:AddSection("Update Logs", true)

LogsSection:AddParagraph({ Title = "08.01.26 — UPDATE", Content = "", Icon = "scroll" })
LogsSection:AddParagraph({ Content = "[+] Auto Play (AI, BETA)" })
LogsSection:AddParagraph({ Content = "[+] Auto Run (BETA)" })
LogsSection:AddParagraph({ Content = "[+] Auto Farm (BETA)" })
LogsSection:AddParagraph({ Content = "[+] Auto Loop (BETA)" })
LogsSection:AddParagraph({ Content = "[+] Wall Hug" })
LogsSection:AddParagraph({ Content = "[+] Version Checker" })
LogsSection:AddParagraph({ Content = "[+] Fixed ESP Tracers/Boxes" })
LogsSection:AddParagraph({ Content = "[+] Better Pallet Detection" })
LogsSection:AddParagraph({ Content = "[+] Better Window Detection" })

LogsSection:AddParagraph({ Title = "07.01.26 — FIXES", Content = "", Icon = "scroll" })
LogsSection:AddParagraph({ Content = "[+] Infinite Lunge (Premium)" })
LogsSection:AddParagraph({ Content = "[+] Hook Farm (Screws)" })
LogsSection:AddParagraph({ Content = "[+] Charged Spear Aim (Veil)" })
LogsSection:AddParagraph({ Content = "[+] Spear Aim (Veil)" })
LogsSection:AddParagraph({ Content = "[+] Expand Hitboxes" })
LogsSection:AddParagraph({ Content = "[+] No Fall" })
LogsSection:AddParagraph({ Content = "[/] Damage Aura fixes" })
LogsSection:AddParagraph({ Content = "[/] General improvements" })
LogsSection:AddParagraph({ Content = "[/] Code rewritten" })

-- Spacer satu baris agar tombol tidak terlalu menempel pada changelog.
LogsSection:AddParagraph({ Content = " " })
LogsSection:AddParagraph({ Content = " " })
LogsSection:AddButton({
    Title = "Copy Community Link",
    Callback = function()
        setclipboard("https://whatsapp.com/channel/0029VarXBlfEVccM6hAkdp1H")
        Lib:MakeNotify({ Title = "Community", Content = "Link Copied!", Time = 2 })
    end
})

-- UNIVERSAL

FunSection = UniversalTab:AddSection("Fun", true)

Toggles.DesyncHandle = FunSection:AddToggle({
    Title = "Desync (Anti Hit)",
    Content = "Gunakan untuk hitbox yang lebih baik atau memalsukan posisi.",
    Default = false,
    Callback = function(state)
      task.spawn(function()
        if not setfflag then
            warn("[Arexans] Desync not supported. Desync will not work.")
            return
        end
        Desync = state
        
        if DesyncType == "Fake Position" then
            setfflag('NextGenReplicatorEnabledWrite4', tostring(state))
        elseif DesyncType == "Hitbox Improving" then
            desyncT.enabled = state
            
            if state then
                enableHitboxDesync()
            else
                disableHitboxDesync()
            end
        end
      end)
    end
})

Toggles.DesyncTypeHandle = FunSection:AddDropdown({
    Title = "Tipe Desync",
    Options = { "Hitbox Improving", "Fake Position" },
    Default = DesyncType,
    Callback = function(option)
        DesyncType = option
    end
})

Toggles.InvisibilityHandle = FunSection:AddToggle({
    Title = "Invisibilitas",
    Content = "Membuatmu tidak terlihat oleh orang lain.",
    Default = false,
    Callback = function(state)
        InvisibilityToggle = state
        if state then 
            enableInvis()
        else
            disableInvis()
        end
    end
})

FunSection:AddDivider()

Toggles.HitboxesRadiusHandle = FunSection:AddSlider({
    Title = "Radius Hitbox",
    Min = 5,
    Max = 30,
    Default = 10,
    Callback = function(Value)
        HitboxesRadius = tonumber(Value)
    end
})

Toggles.ExpandHitboxesHandle = FunSection:AddToggle({
    Title = "Perbesar Hitbox",
    Content = "Memperbesar hitbox tim lawan.",
    Default = false,
    Callback = function(state)
        ExpandHitboxesToggle = state
    end
})

Toggles.HitboxesVisibleHandle = FunSection:AddToggle({
    Title = "Hitbox Terlihat?",
    Content = "Membuat hitbox menjadi setengah transparan.",
    Default = false,
    Callback = function(state)
        HitboxesVisibleToggle = state
    end
})

UMiscSection = UniversalTab:AddSection("Lainnya", true)

Toggles.AutoEventHandle = UMiscSection:AddToggle({
    Title = "Auto Farm Event",
    Content = "Farming event yang sedang berlangsung, event saat ini: 🎄",
    Default = false,
    Callback = function(state)
        AutoEventToggle = state
        if state then
            autofarmcurrency()
        end
    end
})

Toggles.CrosshairHandle = UMiscSection:AddToggle({
    Title = "Crosshair (Bidik)",
    Content = "Menambahkan bidikan ke layar.",
    Default = false,
    Callback = function(state)
         if state then
             if not RemoveCrosshair then
                 RemoveCrosshair = LoadCrosshair()
             end
         else
             if RemoveCrosshair then
                 RemoveCrosshair()
                 RemoveCrosshair = nil
             end
         end
    end
})

UMiscSection:AddDropdown({
    Title = "Tipe Crosshair",
    Options = {"crosshair dot", "crosshair dot 2", "crosshair square", "crosshair +•", "crosshair +", "crosshair O+", "crosshair O+ 2", "Croshair (+)", "Crosshair [ • ]", "Crosshair [O+]", "Crosshair star"},
    Default = "crosshair dot",
    Callback = function(option)
        CrosshairType = option
        if RemoveCrosshair then
             RemoveCrosshair()
             RemoveCrosshair = LoadCrosshair()
        end
    end
})


UMiscSection:AddToggle({
    Title = "Potato Grafik",
    Content = "Mengurangi kualitas grafik untuk meningkatkan FPS.",
    Default = false,
    Callback = function(state)
        getgenv().SilentAimVeilSettings.PotatoMode = state == true
        AREXANS_SetPotatoGrafik(state == true)
    end
})

antiLagActive = false
UMiscSection:AddToggle({
    Title = "Anti Freeze / Anti Lag",
    Content = "Optimasi ekstrem untuk mencegah freeze dan mengurangi lag.",
    Default = false,
    Callback = function(state)
        local Lighting = game:GetService("Lighting")
        
        if state then
            antiLagActive = true
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                    v.CastShadow = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = false
                elseif v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                    v.CastShadow = false
                    v.TextureID = 10385902758728957
                elseif v:IsA("Explosion") then
                    v.BlastPressure = 1
                    v.BlastRadius = 1
                    v.Visible = false
                end
            end
            
            for _, e in pairs(Lighting:GetChildren()) do
                if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                    e.Enabled = false
                end
            end
            -- Lib:MakeNotify({ Title = "Optimasi", Content = "Anti Lag aktif!", Time = 2 })
        elseif antiLagActive then
            antiLagActive = false
            Lighting.GlobalShadows = true
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            -- Lib:MakeNotify({ Title = "Info", Content = "Optimasi dinonaktifkan. Tekstur mungkin tidak kembali normal tanpa rejoin.", Time = 3 })
        end
    end
})

JumpUI = nil
function ToggleJumpButton(state)
    if state then
        if JumpUI then return end
        JumpUI = Instance.new("ScreenGui")
        JumpUI.Name = "AXS_Jump_UI"
        JumpUI.ResetOnSpawn = false
        if gethui then JumpUI.Parent = gethui() elseif syn and syn.protect_gui then syn.protect_gui(JumpUI) JumpUI.Parent = game.CoreGui else JumpUI.Parent = game.CoreGui end

        local JumpBtn = Instance.new("TextButton")
        JumpBtn.Size = UDim2.new(0, 60, 0, 60)
        JumpBtn.Position = UDim2.new(1, -80, 1, -80)
        JumpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        JumpBtn.BackgroundTransparency = 0.3
        JumpBtn.Text = "JUMP"
        JumpBtn.TextColor3 = Color3.new(1, 1, 1)
        JumpBtn.Font = Enum.Font.GothamBold
        JumpBtn.TextSize = 14
        JumpBtn.Active = true
        JumpBtn.Draggable = true
        JumpBtn.Parent = JumpUI

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = JumpBtn

        JumpBtn.MouseButton1Click:Connect(function()
            if root and hum then
                if hum.FloorMaterial ~= Enum.Material.Air then
                    root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if JumpUI then
            JumpUI:Destroy()
            JumpUI = nil
        end
    end
end

Toggles.ShowJumpGuiHandle = UMiscSection:AddToggle({
    Title = "Tampilkan Tombol Lompat",
    Content = "Menampilkan tombol di layar untuk melompat secara manual.",
    Default = false,
    Callback = function(state)
        ToggleJumpButton(state)
    end
})

UPlaySection = UniversalTab:AddSection("Auto Play", true)

Toggles.AutoPlayHandle = UPlaySection:AddToggle({
   Title = "Auto Play (AI, BETA)",
   Content = "Automatically plays for you, will be improving further.",
   Default = false,
   Callback = function(state)
       getgenv().AIPlaying = state
       if state then
           local __ok, __err = pcall(function()
               local __src = game:HttpGet("https://pastefy.app/P7Xzdqfu/raw")
               local __chunk, __compileErr = (loadstring or load)(__src)
               assert(__chunk, __compileErr or "Auto Play compile failed")
               __chunk()
           end)
           if not __ok then warn("[AXS VD] Auto Play failed: " .. tostring(__err)) end
       end
   end
})

UPlaySection:AddDivider()

Toggles.RunHandle = UPlaySection:AddToggle({
   Title = "Auto Run (BETA)",
   Content = "Runs from killer if he's close and you're survivor.",
   Default = false,
   Callback = function(state)
       getgenv().axs_settings.Methods.Run = state
   end
})

Toggles.FarmHandle = UPlaySection:AddToggle({
   Title = "Auto Farm (BETA)",
   Content = "Farms generators if you're survivor, survivors if you're killer.",
   Default = false,
   Callback = function(state)
       getgenv().axs_settings.Methods.Farm = state
   end
})

Toggles.LoopHandle = UPlaySection:AddToggle({
   Title = "Auto Loop (BETA)",
   Content = "Loops killer if you're survivor.",
   Default = false,
   Callback = function(state)
       getgenv().axs_settings.Methods.Farm = state
   end
})

Toggles.WallHugHandle = UPlaySection:AddToggle({
   Title = "Wall Hug",
   Content = "Hugs wall while running/farming/looping.",
   Default = false,
   Callback = function(state)
       getgenv().axs_settings.Toggles.Wallhug = state
   end
})

-- KILLER

KillerBlatantSection = KillerTab:AddSection("Blatant (Kasar)", true)

Toggles.InfThingsHandle = KillerBlatantSection:AddToggle({
    Title = "Infinite Abilities (PREMIUM)",
    Content = "Includes no attack cooldown. Supported killers for inf abillities: Slasher, Masked, Veil, Stalker.",
    Default = false,
    Callback = function(state)
        if state then
            if getgenv().PREMIUM_KEY then
                InfThingsToggle = true
                noCdEnabled = true
            else
                InfThingsToggle = false
                noCdEnabled = false
                Lib:MakeNotify({
                    Title = "Premium Feature",
                    Content = "This feature is only for premium users, get premium in our community.",
                    Time = 3
                })
                if Toggles.InfThingsHandle then
                    Toggles.InfThingsHandle:Set(false)
                end
            end
        else
            InfThingsToggle = false
            noCdEnabled = false
        end
    end
})

InfLungeConnection = nil
Toggles.InfLungeHandle = KillerBlatantSection:AddToggle({
    Title = "Infinite Lunge (PREMIUM)",
    Content = "Lunge infinitely without any restrictions.",
    Default = false,
    Callback = function(state)
        if state then
            if not getgenv().PREMIUM_KEY then
                state = false
                Lib:MakeNotify({
                    Title = "Premium Feature",
                    Content = "This feature is only for premium users, get premium in our community.",
                    Time = 3
                })
                if Toggles.InfLungeHandle then
                    Toggles.InfLungeHandle:Set(false)
                end
                return
            end
        end
        if state then
            character:SetAttribute("lungeboost", 999)
            if InfLungeConnection then InfLungeConnection:Disconnect() end
            InfLungeConnection = lp.CharacterAdded:Connect(function(newChar)
                task.wait(1)
                character:SetAttribute("lungeboost", 999)
            end)
        else
            if InfLungeConnection then
                InfLungeConnection:Disconnect()
                InfLungeConnection = nil
            end
            character:SetAttribute("lungeboost", 1)
        end
    end
})

KillerBlatantSection:AddDivider()

Toggles.HookFarmHandle = KillerBlatantSection:AddToggle({
    Title = "Hook Farm (Sekrup)",
    Content = "Gunakan untuk farming sekrup, harus hook seseorang sekali.",
    Default = false,
    Callback = function(state)
        HookFarmToggle = state
    end
})

Toggles.HookTimesHandle = KillerBlatantSection:AddSlider({
    Title = "Jumlah Hook",
    Min = 2,
    Max = 1000,
    Default = 10,
    Callback = function(Value)
        HookTimes = tonumber(Value)
    end
})

KillerSection = KillerTab:AddSection("Berburu", true)

Toggles.OneTapHandle = KillerSection:AddToggle({
    Title = "Damage Aura",
    Content = "Melemparkan siklus serangan ke lokasi yang Anda hadapi.",
    Default = false,
    Callback = function(state)
        getgenv().AXS_DamageAura = state
        if state then
            task.spawn(function()
                while getgenv().AXS_DamageAura and task.wait(0.1) do
                    game.ReplicatedStorage.Remotes.Attacks.BasicAttack:FireServer()
                end
            end)
        end
    end
})

KillerSection:AddDivider()

Toggles.AutoAimChargedHandle = KillerSection:AddToggle({
    Title = "Auto Aim Tombak Terisi (Veil)",
    Content = "Otomatis membidik tombak terisi ke penyintas terdekat. ANDA HARUS MEMEGANG TOMBAK JANGAN LAPOR BUG",
    Default = false,
    Callback = function(state)
        AutoAimChargedToggle = state
        if state and AutoAimNormalToggle and Toggles.AutoAimNormalHandle then
            AutoAimNormalToggle = false
            Toggles.AutoAimNormalHandle:Set(false)
        end
    end
})

Toggles.AutoAimNormalHandle = KillerSection:AddToggle({
    Title = "Auto Aim Tombak (Veil)",
    Content = "Otomatis membidik tombak ke penyintas terdekat. ANDA HARUS MEMEGANG TOMBAK JANGAN LAPOR BUG",
    Default = false,
    Callback = function(state)
        AutoAimNormalToggle = state
        if state and AutoAimChargedToggle and Toggles.AutoAimChargedHandle then
            AutoAimChargedToggle = false
            Toggles.AutoAimChargedHandle:Set(false)
        end
    end
})

Toggles.SilentAimVeilHandle = KillerSection:AddToggle({
    Title = "Silent Aim (Veil Spear)",
    Content = "Otomatis melempar tombak ke target dalam FOV saat charge.",
    Default = false,
    Callback = function(state)
        if getgenv().SilentAimVeilSettings then getgenv().SilentAimVeilSettings.Enabled = state end
    end
})

Toggles.VeilShowFOVHandle = KillerSection:AddToggle({
    Title = "Show FOV Veil",
    Content = "Tampilkan lingkaran FOV Silent Aim Veil.",
    Default = true,
    Callback = function(state)
        if getgenv().SilentAimVeilSettings then getgenv().SilentAimVeilSettings.ShowFOV = state end
    end
})

Toggles.VeilESPHandle = KillerSection:AddToggle({
    Title = "ESP Khusus Veil",
    Content = "Tampilkan ESP khusus target Silent Aim Veil.",
    Default = false,
    Callback = function(state)
        if getgenv().SilentAimVeilSettings then getgenv().SilentAimVeilSettings.ESP = state end
    end
})

Toggles.VeilCrosshairHandle = KillerSection:AddToggle({
    Title = "Crosshair Veil",
    Content = "Tampilkan Crosshair khusus Silent Aim Veil.",
    Default = false,
    Callback = function(state)
        if getgenv().SilentAimVeilSettings then getgenv().SilentAimVeilSettings.Crosshair = state end
    end
})

KillerMiscSection = KillerTab:AddSection("Atribut", true)

Toggles.AntiFlashlightHandle = KillerMiscSection:AddToggle({
    Title = "Anti Senter (Flashlight)",
    Content = "Menghilangkan efek silau senter.",
    Default = false,
    Callback = function(state)
        AntiFlashlight = state
    end
})

Toggles.AntiSlowHandle = KillerMiscSection:AddToggle({
    Title = "Anti Lambat (Slow Down)",
    Content = "Menghilangkan efek kecepatan jalan negatif.",
    Default = false,
    Callback = function(state)
        AntislowToggle = state
    end
})

KillerMiscSection:AddButton({
    Title = "Aktifkan Emote",
    Callback = function()
        local pg = lp:FindFirstChild("PlayerGui")
        if pg then
            local emotesGui = pg:FindFirstChild("Emotes")
            if emotesGui then
               emotesGui.Enabled = true
            end
        end
    end
})

-- SURVIVOR

SurvSection = SurvivorTab:AddSection("Pertarungan", true)

Toggles.GodModeHandle = SurvSection:AddToggle({
    Title = "Mode Dewa (PREMIUM)",
    Content = "Mencegah kamu diserang, membuatmu tak terkalahkan.",
    Default = false,
    Callback = function(state)
        if state then
            if getgenv().PREMIUM_KEY then
                GodmodeToggle = true
            else
                GodmodeToggle = false
                Lib:MakeNotify({
                    Title = "Premium Feature",
                    Content = "This feature is only for premium users, get premium in our community.",
                    Time = 3
                })
                if Toggles.GodModeHandle then
                    Toggles.GodModeHandle:Set(false)
                end
            end
        else
            GodmodeToggle = false
        end
    end
})

Toggles.AutoTargetHandle = SurvSection:AddToggle({
    Title = "Auto Target (Aimbot)",
    Content = "Otomatis membidik ke target saat menekan tombol menembak (atau menahan crosshair di mobile).",
    Default = false,
    Callback = function(state)
        getgenv().AutoTargetToggle = state
    end
})

Toggles.AutoShootHandle = SurvSection:AddToggle({
    Title = "Auto Serang (Cerdas)",
    Content = "Otomatis menembak HANYA saat perlu (Killer menyerang, sangat dekat, atau dalam crosshair) & tidak sedang stun.",
    Default = false,
    Callback = function(state)
        getgenv().AutoSerangToggle = state
        if getgenv().SilentAimPistolSettings then getgenv().SilentAimPistolSettings.Enabled = state end
    end
})

Toggles.PistolShowFOVHandle = SurvSection:AddToggle({
    Title = "Show FOV Pistol",
    Content = "Tampilkan lingkaran FOV Silent Aim Pistol.",
    Default = false,
    Callback = function(state)
        if getgenv().SilentAimPistolSettings then getgenv().SilentAimPistolSettings.ShowFOV = state end
    end
})

Toggles.PistolLaserHandle = SurvSection:AddToggle({
    Title = "Laser Target Lock",
    Content = "Tampilkan Laser Tracer Silent Aim Pistol ke target.",
    Default = false,
    Callback = function(state)
        if getgenv().SilentAimPistolSettings then getgenv().SilentAimPistolSettings.Laser = state end
    end
})

Toggles.PistolStunESPHandle = SurvSection:AddToggle({
    Title = "ESP Stunned Detect",
    Content = "Tampilkan status ESP Stunned saat killer ter-stun.",
    Default = false,
    Callback = function(state)
        if getgenv().SilentAimPistolSettings then getgenv().SilentAimPistolSettings.StunESP = state end
    end
})

Toggles.ShootTargetHandle = SurvSection:AddDropdown({
    Title = "Pilih Target Aim",
    Options = { "Killers", "Players" },
    Default = "",
    Callback = function(option)
        selectedTarget = option
    end
})

Toggles.AimPartHandle = SurvSection:AddDropdown({
    Title = "Bagian Target Aim",
    Options = { "Kepala", "Badan", "Pundak Kanan", "Pundak Kiri" },
    Default = "Kepala",
    Callback = function(option)
        AimPart = option
    end
})

SurvDefSection = SurvivorTab:AddSection("Looping", true)

ParryVisuals = nil
function UpdateParryVisuals(state)
    local shouldShow = state and Autoparry and (getgenv().ParryVisualsEnabled ~= false)
    
    if shouldShow then
        if not ParryVisuals then
            ParryVisuals = Instance.new("CylinderHandleAdornment")
            ParryVisuals.Name = "ParryRadiusVisual"
            ParryVisuals.Height = 0.05
            ParryVisuals.CFrame = CFrame.new(0, -2.95, 0) * CFrame.Angles(math.rad(90), 0, 0)
            ParryVisuals.Color3 = Color3.fromRGB(255, 253, 208) -- Cream
            ParryVisuals.Transparency = 0.6
            ParryVisuals.AlwaysOnTop = false
            ParryVisuals.ZIndex = 0
            ParryVisuals.Adornee = root
            ParryVisuals.Parent = root
        end
        ParryVisuals.Radius = ParryDistance
        ParryVisuals.InnerRadius = ParryDistance - 0.2
        ParryVisuals.Visible = true
        if root then 
            ParryVisuals.Adornee = root
            ParryVisuals.Parent = root 
        end
    else
        if ParryVisuals then
            ParryVisuals:Destroy()
            ParryVisuals = nil
        end
    end
end

Toggles.AutoParryHandle = SurvDefSection:AddToggle({
    Title = "Auto Tangkis Pembunuh",
    Content = "Otomatis menangkis (stun) pembunuh, harus punya parrying dagger sebagai penyintas.",
    Default = false,
    Callback = function(state)
        Autoparry = state
        if getgenv().AutoParrySettings then getgenv().AutoParrySettings.Enabled = state end
        UpdateParryVisuals(state)
    end
})

Toggles.SmartFaceHandle = SurvDefSection:AddToggle({
    Title = "Auto Face Killer (Smart Face)",
    Content = "Otomatis menghadap pembunuh saat menangkis. Matikan jika mengganggu pergerakan.",
    Default = true,
    Callback = function(state)
        SmartFace = state
    end
})

Toggles.VisualParryHandle = SurvDefSection:AddToggle({
    Title = "Visual Radius Tangkis",
    Content = "Menampilkan lingkaran radius auto tangkis.",
    Default = true,
    Callback = function(state)
        getgenv().ParryVisualsEnabled = state
        UpdateParryVisuals(Autoparry)
    end
})

Toggles.ParrySliderHandle = SurvDefSection:AddSlider({
    Title = "Radius Tangkis",
    Min = 5,
    Max = 30,
    Default = 20,
    Callback = function(Value)
        ParryDistance = tonumber(Value)
        if getgenv().AutoParrySettings then getgenv().AutoParrySettings.Range = tonumber(Value) or 20 end
        if Autoparry then UpdateParryVisuals(true) end
    end
})

Toggles.ParryDelayHandle = SurvDefSection:AddSlider({
    Title = "Jeda Tangkis (Delay)",
    Min = 0,
    Max = 1,
    Default = 0,
    Callback = function(Value)
        ParryDelay = tonumber(Value)
    end
})

Toggles.ParryMethodHandle = SurvDefSection:AddDropdown({
    Title = "Metode Tangkis",
    Options = { "Combined", "Lunge", "Attack (BETA)" },
    Default = "Lunge",
    Callback = function(option)
        ParryMethod = option
    end
})


if getrawmetatable and setreadonly then
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if NoFallToggle and self == FallRemote and method == "FireServer" then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
else
    warn("[Arexans] Executor does not support metatable hooking (getrawmetatable, setreadonly). NoFall Bypass Skipped.")
end

Toggles.NoFallHandle = SurvDefSection:AddToggle({
    Title = "No Fall (Anti Jatuh)",
    Content = "Menghilangkan efek jatuh.",
    Default = false,
    Callback = function(state)
        NoFallToggle = state 
    end
})

SurvDefSection:AddDivider()

Toggles.AutoDropHandle = SurvDefSection:AddToggle({
    Title = "Auto Jatuhkan Pallet",
    Content = "Menjatuhkan pallet tepat ke pembunuh, harus dekat.",
    Default = false,
    Callback = function(state)
        AutoDropToggle = state
        if state then autodrop() end
    end
})

Toggles.AutoDropSetHandle = SurvDefSection:AddToggle({
    Title = "Pallet Saat Digendong?",
    Content = "Menjatuhkan pallet bahkan jika pembunuh menggendongmu melewati pallet.",
    Default = false,
    Callback = function(state)
        AutoDropSetToggle = state
    end
})

SurvMiscSection = SurvivorTab:AddSection("Objektif", true)

Toggles.PerfectGenHandle = SurvMiscSection:AddToggle({
    Title = "Auto Perfect Generator",
    Content = "Melakukan skill check generator di titik sempurna.",
    Default = false,
    Callback = function(state)
        if state then
            if getgenv().AXS_Connections["AutoGenerator"] then getgenv().AXS_Connections["AutoGenerator"]:Disconnect() end
            getgenv().AXS_Connections["AutoGenerator"] = RunService.Heartbeat:Connect(autoperfectgen)
        else
            if getgenv().AXS_Connections["AutoGenerator"] then
                getgenv().AXS_Connections["AutoGenerator"]:Disconnect()
                getgenv().AXS_Connections["AutoGenerator"] = nil
            end
        end
    end
})

Toggles.PerfectHealHandle = SurvMiscSection:AddToggle({
    Title = "Auto Perfect Heal",
    Content = "Melakukan skill check penyembuhan di titik sempurna.",
    Default = false,
    Callback = function(state)
        if state then
            HealConnection = RunService.Heartbeat:Connect(autoperfectheal)
        else
            if HealConnection then
                HealConnection:Disconnect()
                HealConnection = nil
            end
        end
    end
})

SurvMiscSection:AddDivider()

Toggles.AntiGFailHandle = SurvMiscSection:AddToggle({
    Title = "Anti Gagal Generator",
    Content = "Gagal skill check generator tidak akan meledak.",
    Default = false,
    Callback = function(state)
        AntiGFail = state
    end
})

Toggles.RemoveClothingsHandle = SurvMiscSection:AddToggle({
    Title = "Hapus Pakaian Veil",
    Content = "Membuat pembunuh Veil telanjang.",
    Default = false,
    Callback = function(state)
        RemoveClothingsToggle = state
    end
})

antiCampConns = {}
Toggles.AntiCampHandle = SurvMiscSection:AddToggle({
    Title = "Anti Camp Selalu Berjalan",
    Content = "Membuat bar loading 'Kamp Anti' untuk kabur dari hook terus terisi penuh tanpa batas jarak killer.",
    Default = false,
    Callback = function(state)
        getgenv().AntiCampToggle = state
        
        for _, conn in ipairs(antiCampConns) do
            if conn.Connected then conn:Disconnect() end
        end
        table.clear(antiCampConns)
        
        if state then
            local function enforceCamp(char)
                if not char then return end
                
                local function forceVal(attr)
                    if not getgenv().AntiCampToggle then return end
                    if char:GetAttribute("IsHooked") then
                        local current = char:GetAttribute(attr)
                        if current ~= 100 then
                            char:SetAttribute(attr, 100)
                            pcall(function()
                                game.ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer(attr, 100)
                            end)
                        end
                    end
                end
                
                local attrs = {"AntiCampMeter", "CampMeter", "CampProgress", "AntiCampProgress", "AntiCampServer"}
                for _, attr in ipairs(attrs) do
                    local conn = char:GetAttributeChangedSignal(attr):Connect(function() forceVal(attr) end)
                    table.insert(antiCampConns, conn)
                end
            end
            
            if character then enforceCamp(character) end
            
            local charAddedConn = lp.CharacterAdded:Connect(function(newChar)
                task.wait(1)
                enforceCamp(newChar)
            end)
            table.insert(antiCampConns, charAddedConn)
            
            task.spawn(function()
                while getgenv().AntiCampToggle do
                    task.wait(0.1)
                    if character and character:GetAttribute("IsHooked") then
                        character:SetAttribute("AntiCampMeter", 100)
                        character:SetAttribute("CampMeter", 100)
                        character:SetAttribute("CampProgress", 100)
                        character:SetAttribute("AntiCampProgress", 100)
                        character:SetAttribute("AntiCampServer", 100)
                        character:SetAttribute("CanSelfUnhook", true)
                        
                        pcall(function()
                            game.ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("AntiCampMeter", 100)
                            game.ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("CampMeter", 100)
                        end)
                    end
                end
            end)
        end
    end
})

SurvMiscSection:AddButton({
    Title = "Kabur Instan",
    Callback = function()
        local gate = workspace.Map:FindFirstChild("Gate")
        if gate then
            local box = gate:FindFirstChild("Box")
            if box and box:IsA("BasePart") then
                local backCFrame = box.CFrame * CFrame.new(0, 0, -50)
                root.CFrame = CFrame.new(backCFrame.Position, box.Position)
            end
        end
    end
})

SurvMiscSection:AddButton({
    Title = "Hancurkan Gerbang",
    Callback = function()
        local map = workspace:FindFirstChild("Map")
        if not map then return end

        for _, gate in ipairs(map:GetChildren()) do
            if gate.Name == "Gate" and gate:IsA("Model") then
                gate:Destroy()
            end
        end
    end
})

-- ESP

FOVRadius = 70
getgenv().FOV_Enabled = false
RunService.Heartbeat:Connect(function()
    if getgenv().FOV_Enabled and game.workspace.CurrentCamera.FieldOfView ~= FOVRadius then
        game.workspace.CurrentCamera.FieldOfView = FOVRadius
    end
end)

EspSection = EspTab:AddSection("Visual", true)

EspSection:AddToggle({
    Title = "Kunci FOV",
    Content = "Mengunci Field of View kamera ke radius tertentu.",
    Default = false,
    Callback = function(state)
        getgenv().FOV_Enabled = state
        if not state then
            game.workspace.CurrentCamera.FieldOfView = 70 -- Reset ke default
        end
    end
})

Toggles.ShowFPSHandle = EspSection:AddToggle({
    Title = "Tampilkan FPS",
    Content = "Menampilkan penghitung FPS di pojok layar.",
    Default = false,
    Callback = function(state)
        if state then
            CreateFPS()
        else
            RemoveFPS()
        end
    end
})

Toggles.FOVSliderHandle = EspSection:AddSlider({
    Title = "Radius FOV",
    Min = 1,
    Max = 120,
    Default = 70,
    Callback = function(Value)
        FOVRadius = tonumber(Value)
    end
})

Toggles.InfiniteZoomHandle = EspSection:AddToggle({
    Title = "Infinite Zoom Out",
    Content = "Allows you to zoom out infinitely.",
    Default = false,
    Callback = function(state)
        getgenv().InfiniteZoom = state
        if state then
             task.spawn(function()
                 while getgenv().InfiniteZoom do
                     lp.CameraMaxZoomDistance = 100000
                     task.wait(1)
                 end
                 lp.CameraMaxZoomDistance = 12.5
             end)
        else
             lp.CameraMaxZoomDistance = 12.5
        end
    end
})

oldAmbient, oldOutdoor, oldBrightness, oldShadows = nil, nil, nil, nil
EspSection:AddToggle({
    Title = "Terang Penuh (Full Bright)",
    Content = "Membuat game menjadi terang benderang.",
    Default = false,
    Callback = function(state)
        local Lighting = game:GetService("Lighting")
        if state then
            oldAmbient = Lighting.Ambient
            oldOutdoor = Lighting.OutdoorAmbient
            oldBrightness = Lighting.Brightness
            oldShadows = Lighting.GlobalShadows
            
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.ShadowSoftness = 0
            Lighting.GlobalShadows = false
        else
            if oldAmbient then
                Lighting.Ambient = oldAmbient
                Lighting.OutdoorAmbient = oldOutdoor
                Lighting.Brightness = oldBrightness
                Lighting.GlobalShadows = oldShadows
            end
        end
    end
})

EspSection:AddDropdown({
    Title = "ESP Style",
    Options = { "Full", "Outline Only" },
    Default = "Full",
    Callback = function(option)
        ESPStyle = option
    end
})

Toggles.ESPDropdownHandle = EspSection:AddDropdown({
    Title = "ESP's",
    Options = { "Killers", "Players", "Generators", "Presents", "Windows", "Pallets" },
    Default = { "Killers", "Players", "Windows", "Pallets" },
    Multi = true,
    Callback = function(option)
        selectedESPTypes = option
    end
})

Toggles.ESPHighlightHandle = EspSection:AddToggle({
    Title = "Highlight Objek",
    Content = "Menandai objek, fitur paling berguna.",
    Default = false,
    Callback = function(state)
        ESPHighlight = state
    end
})

Toggles.ESPTracersHandle = EspSection:AddToggle({
    Title = "Tampilkan Tracer (Garis)",
    Content = "Menambahkan garis penunjuk ke objek ESP.",
    Default = false,
    Callback = function(state)
        ESPTracers = state
    end
})

Toggles.ESPBoxesHandle = EspSection:AddToggle({
    Title = "Tampilkan Kotak (Box)",
    Content = "Menambahkan kotak yang menunjukkan hitbox objek ESP.",
    Default = false,
    Callback = function(state)
        ESPBoxes = state
    end
})

Toggles.ESPNamesHandle = EspSection:AddToggle({
    Title = "Tampilkan Nama",
    Content = "Menambahkan nama objek di atas kepala objek.",
    Default = false,
    Callback = function(state)
        ESPNames = state
    end
})


Toggles.SnowPingFPSHandle = EspSection:AddToggle({
    Title = "Snow Ping & FPS",
    Content = "Tampilkan ping dan FPS di bawah-tengah layar.",
    Default = false,
    Callback = function(state)
        pcall(__AXS_PingSet, state)
    end
})

Toggles.ESPStudsHandle = EspSection:AddToggle({
    Title = "Tampilkan Jarak (Studs)",
    Content = "Menambahkan jarak di atas kepala objek.",
    Default = false,
    Callback = function(state)
        ESPStuds = state
    end
})

-- PLAYER

PlayerSection = PlayerTab:AddSection("Main", true)


Toggles.DBDCameraHandle = PlayerSection:AddToggle({
    Title = "Camera DBD",
    Content = "Aktif/nonaktif kamera DBD dengan jarak, FOV, tinggi, dan skala karakter.",
    Default = false,
    Callback = function(state)
        pcall(__AXS_DBD_Set, state)
    end
})

Toggles.DBDDistanceHandle = PlayerSection:AddSlider({
    Title = "DBD Camera Distance",
    Content = "Jarak zoom kamera DBD.",
    Min = 5,
    Max = 100,
    Default = 25,
    Increment = 1,
    Callback = function(value)
        __AXS_DBD_UpdateSetting("Distance", value)
    end
})

Toggles.DBDFOVHandle = PlayerSection:AddSlider({
    Title = "DBD Camera FOV",
    Content = "Field of View kamera DBD.",
    Min = 40,
    Max = 160,
    Default = 120,
    Increment = 1,
    Callback = function(value)
        __AXS_DBD_UpdateSetting("FOV", value)
    end
})

Toggles.DBDHeightHandle = PlayerSection:AddSlider({
    Title = "DBD Camera Height",
    Content = "Tinggi/rendah posisi kamera.",
    Min = -5,
    Max = 10,
    Default = 0,
    Increment = 0.5,
    Callback = function(value)
        __AXS_DBD_UpdateSetting("Height", value)
    end
})

Toggles.DBDScaleHandle = PlayerSection:AddSlider({
    Title = "DBD Character Scale",
    Content = "Ukuran karakter saat Camera DBD aktif.",
    Min = 0.01,
    Max = 1,
    Default = 0.05,
    Increment = 0.01,
    Callback = function(value)
        __AXS_DBD_UpdateSetting("CharScale", value)
    end
})

Toggles.DBDUseScaleHandle = PlayerSection:AddToggle({
    Title = "Use Character Scale",
    Content = "Aktifkan perubahan skala karakter.",
    Default = true,
    Callback = function(state)
        __AXS_DBD_UpdateSetting("UseCharScale", state)
    end
})

PlayerSection:AddButton({
    Title = "Reset Camera DBD",
    Content = "Kembalikan Distance, FOV, Height, dan Scale ke nilai default.",
    Callback = function()
        __AXS_DBD_UpdateSetting("Distance",25)
        __AXS_DBD_UpdateSetting("FOV",120)
        __AXS_DBD_UpdateSetting("Height",0)
        __AXS_DBD_UpdateSetting("CharScale",0.05)
        __AXS_DBD_UpdateSetting("UseCharScale",true)
    end
})

Toggles.LockTargetHiddenHandle = PlayerSection:AddToggle({
    Title = "Lock Target Hidden",
    Content = "Kunci arah kamera ke Survivor terdekat dalam jarak 50 stud.",
    Default = false,
    Callback = function(state)
        pcall(__AXS_LockSet, state)
    end
})

Toggles.NoclipHandle = PlayerSection:AddToggle({
    Title = "Noclip (Tembus Tembok)",
    Content = "Tembus tembok dengan mengaktifkan ini.",
    Default = false,
    Callback = function(state)
        NoclipToggle = state
        if state then
            noclip()
        else
            clip()
        end
    end
})

Toggles.WsToggleHandle = PlayerSection:AddToggle({
    Title = "Kunci Kecepatan Jalan",
    Content = "Mengunci kecepatan jalan sesuai preferensi (Bertahan saat respawn).",
    Default = false,
    Callback = function(state)
        WalkToggle = state
        applyBypassSpeed()
    end
})

Toggles.WsSliderHandle = PlayerSection:AddSlider({
    Title = "Kecepatan Jalan",
    Min = 10,
    Max = 100,
    Default = 28,
    Callback = function(Value)
        currentSpeed = Value
    end
})

-- MISC

MiscSection = MiscTab:AddSection("Main", true)

antiAfkToggle = false
FlingToggle = false
antiFlingToggle = false
flingThread = nil

function fling()
    local movel = 0.1
    while FlingToggle do
        RunService.Heartbeat:Wait()
        local c = lp.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

task.spawn(function()
	while task.wait(60) do
		if antiAfkToggle then
			game:GetService("VirtualUser"):CaptureController()
			game:GetService("VirtualUser"):ClickButton2(Vector2.new())
		end
	end
end)

MiscSection:AddInput({
    Title = "Hit Sound",
    Content = "rbxassetid://",
    Callback = function(input) 
    end
})

MiscSection:AddDropdown({
    Title = "Chase Theme",
    Options = { "Mila - Compass" },
    Default = chasetheme,
    Callback = function(option)
        chasetheme = option
    end
})

idConn = nil
Toggles.ProtectIdentityHandle = MiscSection:AddToggle({
    Title = "Protect Identity",
    Content = "Hides user, avatar, etc.",
    Default = false,
    Callback = function(state)
        local function bacon(c)
            if not character then return end
            for _, v in pairs(character:GetChildren()) do 
                if v:IsA("Accessory") or v:IsA("Clothing") or v:IsA("ShirtGraphic") or v:IsA("CharacterMesh") then v:Destroy() end 
            end
            if character:FindFirstChild("Head") and character.Head:FindFirstChild("face") then character.Head.face.Texture = "rbxassetid://144075659" end
            local bc = character:FindFirstChild("BodyColors") or Instance.new("BodyColors", c)
            bc.HeadColor3 = Color3.fromRGB(234, 184, 146); bc.TorsoColor3 = Color3.fromRGB(116, 134, 157); bc.LeftLegColor3 = Color3.fromRGB(82, 84, 82); bc.RightLegColor3 = Color3.fromRGB(82, 84, 82); bc.LeftArmColor3 = bc.HeadColor3; bc.RightArmColor3 = bc.HeadColor3
            if lp then
                lp.Name = "Arexans"
                lp.DisplayName = "Arexans"
            end
        end

        if state then
            bacon(character)
            if idConn then idConn:Disconnect() end
            idConn = lp.CharacterAdded:Connect(function(c)
                bacon(c)
                task.wait(2)
                bacon(c) 
            end)
        else
            if idConn then idConn:Disconnect() end
        end
    end
})

Toggles.antiAfkHandle = MiscSection:AddToggle({
    Title = "Anti AFK",
    Content = "If enabled, jumps every minute so you wouldn't get kicked out for AFK.",
    Default = false,
    Callback = function(state)
        antiAfkToggle = state
    end
})

Toggles.antiFlingHandle = MiscSection:AddToggle({
    Title = "Anti Fling",
    Content = "If enabled, no one could fling you off map.",
    Default = false,
    Callback = function(state)
        antiFlingToggle = state
        if not state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character then
                    for _, part in ipairs(plr.Character:GetChildren()) do -- descen
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end
})

Toggles.FlingHandle = MiscSection:AddToggle({
    Title = "Touch Fling",
    Content = "If enabled, you could fling anyone in map by touching them.",
    Default = false,
    Callback = function(state)
        FlingToggle = state
    end
})

antiAdminToggle = false
Toggles.antiAdminHandle = MiscSection:AddToggle({
    Title = "Anti Admin",
    Content = "If enabled, kicks you out if there's admin in your experience.",
    Default = false,
    Callback = function(state)
        antiAdminToggle = state
    end
})

task.spawn(function()
	while task.wait(1) and antiAdminToggle do
	       for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= lp and (table.find(blacklist, plr.UserId) or bannedRanks[plr:GetRoleInGroup(gid)]) then
				lp:Kick("Admin detected: " .. plr.Name)
			end
		end
	end
end)

task.spawn(function()
    while task.wait(0.1) do
        if GodmodeToggle then
           hum.Health = 100
           character:SetAttribute("IsCarried", false)
           character:SetAttribute("IsHooked", false)
           character:SetAttribute("Knocked", false)
        end
        if FlingToggle then
            fling()
        end
    end
end)

-- CONFIG

-- uixans.lua handles config automatically via LoadConfigFromFile / SaveConfig called inside elements.
-- But we can add manual buttons if desired.

ConfigSection = ConfigTab:AddSection("Main", true)

ConfigSection:AddButton({
    Title = "Save Config",
    Callback = function()
        Lib:Save()
        Lib:MakeNotify({ Title = "Config", Content = "Configuration saved.", Time = 3 })
    end
})

ConfigSection:AddButton({
    Title = "Copy Config",
    Callback = function()
        local data = Lib:ExportConfig()
        setclipboard(data)
        Lib:MakeNotify({ Title = "Config", Content = "Copied to clipboard!", Time = 3 })
    end
})

ConfigSection:AddInput({
    Title = "Import Config",
    Content = "Paste JSON here",
    Default = "",
    Callback = function(text)
        if text and text ~= "" then
            local success = Lib:ImportConfig(text)
            if success then
                Lib:MakeNotify({ Title = "Config", Content = "Config loaded successfully.", Time = 3 })
            else
                Lib:MakeNotify({ Title = "Config", Content = "Invalid Config JSON.", Time = 3 })
            end
        end
    end
})

ConfigSection:AddButton({
    Title = "Reset Config",
    Callback = function()
        Lib:ResetAll()
        Lib:MakeNotify({ Title = "Config", Content = "All settings reset.", Time = 3 })
    end
})

ConfigSection:AddToggle({
    Title = "Kunci Icon Mengambang",
    Content = "Mencegah icon UI untuk digerakkan (di-drag).",
    Default = false,
    Callback = function(state)
        local gui = game:GetService("CoreGui"):FindFirstChild("ToggleUIButton")
        if not gui then return end
        
        local mainBtn = gui:FindFirstChildOfClass("ImageLabel")
        if not mainBtn then return end
        
        local shieldName = "LockShield"
        local shield = mainBtn:FindFirstChild(shieldName)
        
        if not shield then
            shield = Instance.new("TextButton")
            shield.Name = shieldName
            shield.Size = UDim2.fromScale(1, 1)
            shield.BackgroundTransparency = 1
            shield.Text = ""
            shield.ZIndex = 50 -- Higher than underlying button
            shield.Parent = mainBtn
            
            shield.MouseButton1Click:Connect(function()
                -- Mimic original toggle behavior
                if game:GetService("CoreGui"):FindFirstChild("Chloeex") then
                    local dropShadow = game:GetService("CoreGui").Chloeex:FindFirstChild("DropShadowHolder")
                    if dropShadow then
                        dropShadow.Visible = not dropShadow.Visible
                    end
                end
            end)
        end
        
        shield.Visible = state
    end
})

-- LOGIC LOOPS (continued)

AddBind(KeybindSection, "Kursor Mouse", nil, ToggleMouseCursor)
AddBind(KeybindSection, "Lompat Manual (PC)", nil, function()
    if root and hum then 
        if hum.FloorMaterial ~= Enum.Material.Air then
            root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
AddBind(KeybindSection, "Crosshair", nil, Toggles.CrosshairHandle)
AddBind(KeybindSection, "Auto Aim Killer", nil, Toggles.AutoAimNormalHandle)
AddBind(KeybindSection, "Auto Target", nil, Toggles.AutoTargetHandle)
AddBind(KeybindSection, "Auto Serang", nil, Toggles.AutoShootHandle)
AddBind(KeybindSection, "Auto Tangkis", nil, Toggles.AutoParryHandle)
AddBind(KeybindSection, "Noclip", nil, Toggles.NoclipHandle)
AddBind(KeybindSection, "Speed", nil, Toggles.WsToggleHandle)

uicreated = false
dropdownCreated = false

task.spawn(function()
	while task.wait(1) do
		local gui = lp:FindFirstChild("PlayerGui")
               local myKiller = getKiller()

               if myKiller == "Masked" and not dropdownCreated and InfThingsToggle then
                   createDropdown()
                   dropdownCreated = true
              end

		if RemoveClothingsToggle then
		    for _, pl in ipairs(game.Workspace:GetChildren()) do
		        if pl:FindFirstChild("spearmanager") then
		            for _, item in ipairs(pl:GetChildren()) do
		                if item:IsA("BasePart") and string.lower(item.Name):find("hat") then item:Destroy() end
		            end
		        end
		    end
		end

		if AntiFlashlight and gui then
			local mobNames = {"Slasher-mob", "Masked-mob", "Hidden-mob", "Veil-mob", "Stalker-mob", "Jeff-mob"}
			for _, name in ipairs(mobNames) do
				local mob = gui:FindFirstChild(name)
				if mob then
					local Blind = mob:FindFirstChild("Blind")
					if Blind then
						Blind.Visible = false
						pcall(function() Blind:Destroy() end)
					end
				end
			end
            
            -- Universal check for any GUI named "Blind" or "FlashlightEffect"
            for _, d in ipairs(gui:GetDescendants()) do
                if (d.Name == "Blind" or d.Name == "FlashlightEffect") and d:IsA("GuiObject") and d.Visible then
                    d.Visible = false
                end
            end
            
            -- Lighting check
            local lighting = game:GetService("Lighting")
            for _, eff in ipairs(lighting:GetChildren()) do
                if eff.Name == "FlashlightLight" or eff.Name == "BlindEffect" then
                    eff:Destroy()
                end
            end
		end

		if AntislowToggle and hum then
            -- Prevent WalkSpeed from being lowered by game scripts if it's below a threshold
            if hum.WalkSpeed < 16 and not WalkToggle then
                 hum.WalkSpeed = 16
            end
            
            -- Remove common slow attributes if they exist
            if hum:GetAttribute("Slowed") then hum:SetAttribute("Slowed", nil) end
            if hum:GetAttribute("Stunned") then hum:SetAttribute("Stunned", nil) end
		end

		if ExpandHitboxesToggle then
            local amIKiller = character:FindFirstChild("Killerost") or character:FindFirstChild("Lookscriptkiller")
            local targetCache = amIKiller and getgenv().ESP_Cache or getgenv().KillerCache
            
            for _, model in ipairs(targetCache or {}) do
                if model:IsA("Model") and model ~= character then
                    local isTarget = false
                    if amIKiller then
                        if model:FindFirstChild("Highlight-forsurvivor") then
                            isTarget = true
                        end
                    else
                        isTarget = true 
                    end

                    if isTarget then
                        local part = model:FindFirstChild("HumanoidRootPart")
                        if part and part:IsA("BasePart") then
                            local targetSize = Vector3.new(HitboxesRadius, HitboxesRadius, HitboxesRadius)
                            if part.Size ~= targetSize then
                                part.Size = targetSize
                            end
                            
                            if part.CanCollide then
                                part.CanCollide = false
                            end

                            local targetTrans = HitboxesVisibleToggle and 0.5 or 1
                            if part.Transparency ~= targetTrans then
                                part.Transparency = targetTrans
                            end
                        end
                    end
                end
            end
        end
               
		if InfThingsToggle and gui then
			local mob = gui:FindFirstChild("Slasher-mob") or gui:FindFirstChild("Masked-mob") or gui:FindFirstChild("Hidden-mob")
			if mob then
				local controls = mob:FindFirstChild("Controls")
				if controls then
					local powerOne = controls:FindFirstChild("move1")
					local powerTwo = controls:FindFirstChild("move2")
					local attack = controls:FindFirstChild("attack")

					if powerOne then hookButton(powerOne) end
					if powerTwo then hookButton(powerTwo) end
					if attack then hookButton(attack) end

					-- No GUI created
				end
			end
		end
	end
end)

task.spawn(function()
	while task.wait(0.2) do
	       for _, obj in ipairs(SoundService:GetChildren()) do
			if obj:IsA("Sound") and obj ~= chaseSound and (chasetheme == "Mila - Compass" or chasetheme == "Close To Me") then
				if string.lower(obj.Name) == "chasemusic" then
					obj.Volume = 0
					obj.Playing = false
				end
			end
		end
	end
end)

ReplicatedStorage.Remotes.Carry.HookEvent.OnClientEvent:Connect(function(...)
    if not HookFarmToggle then return end
    for i = 1, HookTimes do
        ReplicatedStorage.Remotes.Carry.HookEvent:FireServer(...)
    end
end)

ReplicatedStorage.Remotes.Generator.SkillCheckEvent.OnClientEvent:Connect(function(generator, point, context)
    if not AntiGFail then return end
    ReplicatedStorage.Remotes.Generator.SkillCheckResultEvent:FireServer("success", 1, generator, point)
end)

PredictionTime = 0.14
MinDistance = 10
MaxDistance = 200
MinPitch = -1
MaxPitch = 30

PitchTable = {
    [0] = 0.09, [1] = 0.90, [2] = 1.9, [3] = 2.9, [4] = 3.9,
    [5] = 4.9, [6] = 5.9, [7] = 6.9, [8] = 7.9, [9] = 8.9,
    [10] = 10.9, [11] = 11.9, [12] = 12.9, [13] = 13.9, [14] = 14.9,
    [15] = 15.9, [16] = 16.9, [17] = 17.9, [18] = 18.9, [19] = 20.3,
    [20] = 22.3
}
FallbackPitch = 23.3
aimConnection = nil

function InitializeCharacter(newChar)
    character = newChar
    root = newChar:WaitForChild("HumanoidRootPart", 9)

    if aimConnection then 
        aimConnection:Disconnect() 
        aimConnection = nil 
    end
    newChar:GetAttributeChangedSignal('spearmode'):Connect(function()
        local isSpearMode = newChar:GetAttribute('spearmode')

        if aimConnection then 
            aimConnection:Disconnect() 
            aimConnection = nil 
        end
        
        if isSpearMode then 
            aimConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if not (AutoAimNormalToggle or AutoAimChargedToggle) then return end
                if not root then return end

                local targetChar = nil
                local shortestMetric = math.huge
                
                for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= lp and v.Character then
                        local char = v.Character
                        
                        if char:GetAttribute("IsHooked") or char:GetAttribute("IsCarried") or char:GetAttribute("Knocked") then continue end

                        local tHead = char:FindFirstChild("Head")
                        local tRoot = char:FindFirstChild("HumanoidRootPart")
                        local tHum = char:FindFirstChild("Humanoid")

                        if tHead and tRoot and tHum and tHum.Health > 0 then
                            if AutoAimNormalToggle then
                                local screenPos, onScreen = Camera:WorldToViewportPoint(tHead.Position)
                                if onScreen then
                                    local dist2D = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                                    if dist2D < shortestMetric then
                                        shortestMetric = dist2D
                                        targetChar = char
                                    end
                                end
                            elseif AutoAimChargedToggle then
                                local dist3D = (tHead.Position - root.Position).Magnitude
                                if dist3D < shortestMetric then
                                    shortestMetric = dist3D
                                    targetChar = char
                                end
                            end
                        end
                    end
                end

                if not targetChar then return end
                local tHead = targetChar.Head
                local tVel = targetChar.HumanoidRootPart.Velocity
                
                local predictedPos = tHead.Position + (tVel * PredictionTime)
                local camPos = Camera.CFrame.Position
                local distToTarget = (predictedPos - camPos).Magnitude
                
                local finalPitch = 0

                if AutoAimNormalToggle then
                    local alpha = math.clamp((distToTarget - MinDistance) / (MaxDistance - MinDistance), 0, 1)
                    finalPitch = MinPitch + (MaxPitch - MinPitch) * alpha
                    
                elseif AutoAimChargedToggle then
                    local index = math.floor(distToTarget / 10)
                    finalPitch = PitchTable[index] or FallbackPitch
                end
                
                local dir = (predictedPos - camPos).Unit
                local yaw = math.atan2(dir.X, dir.Z)
                local pitchRad = math.rad(finalPitch)

                local look = Vector3.new(
                    math.sin(yaw) * math.cos(pitchRad),
                    math.sin(pitchRad),
                    math.cos(yaw) * math.cos(pitchRad)
                )

                Camera.CFrame = CFrame.new(camPos, camPos + look)
            end)
        end
    end)
end

lp.CharacterAdded:Connect(InitializeCharacter)
if lp.Character then
    InitializeCharacter(lp.Character)
end

ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Chase"):WaitForChild("ChaseMusicEvent").OnClientEvent:Connect(function(action)
       if chasetheme == "Default" or (chasetheme ~= "Mila - Compass" and chasetheme ~= "Close To Me") then return end
	local soundid = getSoundIdFromTheme()

	if action == "StartImmediate" then
		setupChaseMusic(soundid)

	elseif action == "FadeOut" then
		fadeTo(0, 10)

	elseif action == "FadeIn" then
		if chaseSound then
			fadeTo(1.2, 0)
		else
			setupChaseMusic(soundid)
		end
	end
end)

task.spawn(function()
while task.wait(0.5) do
  if antiFlingToggle then
     for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            for _, part in ipairs(plr.Character:GetChildren()) do --descen
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
     end
  end
end
end)
task.spawn(function()
    while task.wait(0.5) do
        if lp and lp.Character then
             local r = lp.Character:FindFirstChild("HumanoidRootPart")
             if r then
                 pcall(function()
                      r:SetNetworkOwner(lp)
                 end)
                 pcall(function()
                      sethiddenproperty(lp, "SimulationRadius", 1000)
                 end)
             end
        end
    end
end)

getgenv().KillerCache = {}
task.spawn(function()
    while task.wait(10) do
        local kCache = {}
        local eCache = getgenv().ESP_Cache or {}
        
        local function process(obj)
            local t = getObjType(obj)
            if t == "Killers" then
                if not table.find(kCache, obj) then table.insert(kCache, obj) end
                if not table.find(eCache, obj) then
                    table.insert(eCache, obj)
                    if passesFilter(obj) then ensureAllFor(obj) end
                end
            elseif t == "Players" then
                if not table.find(eCache, obj) then
                    table.insert(eCache, obj)
                    if passesFilter(obj) then ensureAllFor(obj) end
                end
            end
        end

        for _, obj in ipairs(workspace:GetChildren()) do
            process(obj)
        end
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                process(p.Character)
            end
        end

        getgenv().KillerCache = kCache
        getgenv().ESP_Cache = eCache
    end
end)


-- Final Server List fix (V11): fixed viewport + manually maintained canvas.
-- Do not use AutomaticCanvasSize here: on some Roblox mobile clients it does
-- not update reliably when rows are created asynchronously.
pcall(function()
    if not (ServerList and ServerList.SectionAdd and ServerFrame) then
        warn("[AXS VD] Server List scroll fix: required list objects are missing")
        return
    end

    local section = ServerList.SectionAdd
    local root = ServerSectionRoot or section.Parent

    if root and root:IsA("GuiObject") then
        root.ClipsDescendants = true
    end

    section.ClipsDescendants = true
    section.BackgroundTransparency = 1
    section.BorderSizePixel = 0
    section.Active = false
    section.Selectable = false

    -- Keep a bounded viewport inside the existing server panel.
    ServerFrame.Parent = section
    ServerFrame.AnchorPoint = Vector2.new(0, 0)
    ServerFrame.Position = UDim2.new(0, 8, 0, 4)
    ServerFrame.Size = UDim2.new(1, -18, 1, -8)
    ServerFrame.Visible = true
    ServerFrame.BackgroundTransparency = 1
    ServerFrame.BorderSizePixel = 0
    ServerFrame.ClipsDescendants = true
    ServerFrame.Active = true
    ServerFrame.Selectable = true
    ServerFrame.ScrollingEnabled = true
    ServerFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ServerFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    ServerFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
    -- Inner server list owns its scrolling input; keep the parent section
    -- from intercepting touch gestures intended for this list.
    ServerFrame.Active = true
    ServerFrame.Selectable = true
    ServerFrame.ScrollingEnabled = true
    ServerFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ServerFrame.ScrollBarThickness = 8
    ServerFrame.ScrollBarImageTransparency = 0
    ServerFrame.ScrollBarImageColor3 = Color3.fromRGB(35, 180, 255)
    -- Use the requested Arexans thumb asset (downloaded as
    -- ArexansUI_Assets/popup_scrollbar_thumb.png).
    local function ApplyServerScrollbarAsset()
        local getAsset = getcustomasset or getsynasset
        local thumbPath = "ArexansUI_Assets/popup_scrollbar_thumb.png"
        if not (getAsset and isfile) then return false end
        local exists = false
        pcall(function() exists = isfile(thumbPath) end)
        if not exists then return false end
        local ok, uri = pcall(getAsset, thumbPath)
        if ok and uri then
            ServerFrame.ScrollBarImage = uri
            return true
        end
        return false
    end
    -- Prefetch runs asynchronously; retry briefly so the custom thumb is applied
    -- even when the image finishes downloading after the server UI is created.
    task.spawn(function()
        for _ = 1, 100 do
            if not ServerFrame or not ServerFrame.Parent then return end
            if ApplyServerScrollbarAsset() then return end
            task.wait(0.2)
        end
    end)
    ServerFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
    ServerFrame.CanvasPosition = Vector2.new(0, 0)
    ServerFrame.ZIndex = math.max(ServerFrame.ZIndex, 3)

    local layout = ServerFrame:FindFirstChildOfClass("UIListLayout")
    if not layout then
        layout = Instance.new("UIListLayout")
        layout.Name = "ServerEntriesLayout"
        layout.Parent = ServerFrame
    end
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 3)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top

    local padding = ServerFrame:FindFirstChildOfClass("UIPadding")
    if not padding then
        padding = Instance.new("UIPadding")
        padding.Name = "ServerListSafePadding"
        padding.Parent = ServerFrame
    end
    padding.PaddingTop = UDim.new(0, 3)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 3)
    padding.PaddingRight = UDim.new(0, 3)

    local function updateServerCanvas()
        if not ServerFrame or not ServerFrame.Parent or not layout or not layout.Parent then
            return
        end
        -- Include padding and a small end margin so the final row can scroll
        -- fully above the panel border instead of resting on its lower edge.
        local contentHeight = math.ceil(layout.AbsoluteContentSize.Y)
            + padding.PaddingTop.Offset + padding.PaddingBottom.Offset + 4
        ServerFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(contentHeight, ServerFrame.AbsoluteSize.Y))
        local maxY = math.max(0, ServerFrame.CanvasSize.Y.Offset - ServerFrame.AbsoluteSize.Y)
        if ServerFrame.CanvasPosition.Y > maxY then
            ServerFrame.CanvasPosition = Vector2.new(0, maxY)
        end
    end

    local function normalizeEntry(item)
        if not item:IsA("GuiObject") or item.Name ~= "ServerEntry" then
            return
        end
        item.AnchorPoint = Vector2.new(0, 0)
        item.Position = UDim2.new(0, 0, 0, 0)
        item.Size = UDim2.new(1, -6, 0, 38)
        item.ClipsDescendants = true
        item.Active = false
        item.ZIndex = math.max(item.ZIndex, ServerFrame.ZIndex + 1)
    end

    for _, item in ipairs(ServerFrame:GetChildren()) do
        normalizeEntry(item)
    end

    -- Update canvas after rows are added/removed and after UI layout settles.
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateServerCanvas)
    ServerFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateServerCanvas)
    ServerFrame.ChildAdded:Connect(function(item)
        normalizeEntry(item)
        task.defer(updateServerCanvas)
    end)
    ServerFrame.ChildRemoved:Connect(function()
        task.defer(updateServerCanvas)
    end)
    task.defer(updateServerCanvas)
end)

getgenv().ParryVisualsEnabled = true]=];local __AXS_COMPILER=loadstring or load;if type(__AXS_COMPILER)~="function"then __AXS_Bootstrap("AXS VD FAILED\nloadstring/load tidak tersedia di executor ini",false)warn("[AXS VD] loadstring/load unavailable")return end;__AXS_Bootstrap("AXS VD  •  Loading",true)local __AXS_CHUNK,__AXS_COMPILE_ERR=__AXS_COMPILER(__AXS_SOURCE)if type(__AXS_CHUNK)~="function"then local msg=tostring(__AXS_COMPILE_ERR)__AXS_Bootstrap("AXS VD COMPILE ERROR\n"..msg,false)warn("[AXS VD] COMPILE ERROR: "..msg)return end;local __AXS_OK,__AXS_ERR=xpcall(__AXS_CHUNK,function(err)local msg=tostring(err)pcall(function()if debug and debug.traceback then msg=debug.traceback(msg,2)end end)return msg end)if __AXS_OK then pcall(function()if __AXS_BOOT_GUI then __AXS_BOOT_GUI:Destroy()end end)__AXS_Bootstrap("AXS VD  •  Loaded successfully",true)print("[AXS VD] Loaded successfully")else local msg=tostring(__AXS_ERR)__AXS_Bootstrap("AXS VD RUNTIME ERROR\n"..msg,false)warn("[AXS VD] RUNTIME ERROR: "..msg)end