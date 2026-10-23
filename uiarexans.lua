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
    -- Set gambar lokal + auto-refresh ketika file asset selesai diunduh.
    function WindowData:SetImage(imageObject, path) SetLocalImage(imageObject, path) end
    
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
                        SetLocalImage(entry.Background, entry.Value == selected and "popup/option_selected.png" or "popup/option_normal_01.png")
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
                                SetLocalImage(entry.Background, entry.Value == selected and "popup/option_selected.png" or "popup/option_normal_01.png")
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
            local function FormatValue(v)
                if (Max - Min) <= 10 then
                    local s = string.format("%.2f", v)
                    s = string.gsub(s, "0+$", "")
                    s = string.gsub(s, "%.$", "")
                    return s
                end
                return tostring(math.floor(v + 0.5))
            end

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
            Value.Text = FormatValue(value)
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
                Value.Text = FormatValue(value)
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
local __AXS_SOURCE=[=[-- ==============================================================================
-- AXS VD - SIMULATION BUILD
-- Semua fitur di bawah ini HANYA simulasi UI: toggle/slider/dropdown/tombol
-- berubah dan memberi notifikasi, tetapi TIDAK mengubah game, TIDAK memanggil
-- remote, TIDAK melakukan teleport, dan TIDAK mengambil data dari internet.
-- ==============================================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

if type(getgenv) ~= "function" then
    getgenv = function() return _G end
end

-- ------------------------------------------------------------------------------
-- UI library + adapter (Lib:Window / AddTab / AddSection / AddToggle ...)
-- ------------------------------------------------------------------------------
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
                if title == "Server List" or title == "Preview Warna ESP" then
                    -- Never allow an optional custom-section API mismatch to stop
                    -- construction of every feature that follows this section.
                    local custom
                    local customOK = pcall(function()
                        if type(tab.CreateCustomSection) == "function" then
                            custom = tab:CreateCustomSection(title, title == "Server List" and 184 or 66)
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

-- ------------------------------------------------------------------------------
-- SIMULATION HELPERS
-- ------------------------------------------------------------------------------
local Sim = {
    state = {},
    handles = {},
    kinds = {},
    defaults = {},
    silent = true, -- tidak ada notifikasi saat UI sedang dibangun / config di-apply
}

local function simNotify(title, content, duration)
    Lib:MakeNotify({
        Title = "[SIM] " .. tostring(title),
        Content = tostring(content),
        Time = duration or 2,
    })
end

local function fmtNum(v)
    if type(v) ~= "number" then return tostring(v) end
    if math.abs(v - math.floor(v + 0.5)) < 0.0001 then
        return tostring(math.floor(v + 0.5))
    end
    return string.format("%.2f", v)
end

local function register(kind, title, handle, default)
    Sim.handles[title] = handle
    Sim.kinds[title] = kind
    Sim.defaults[title] = default
    Sim.state[title] = default
end

local function addToggle(section, title, default, onChange)
    local handle = section:AddToggle({
        Title = title,
        Default = default == true,
        Callback = function(value)
            Sim.state[title] = value
            if not Sim.silent then
                simNotify(title, value and "ON" or "OFF", 1.5)
            end
            if onChange then onChange(value) end
        end,
    })
    register("toggle", title, handle, default == true)
    return handle
end

local sliderTokens = {}
local function addSlider(section, title, min, max, default, onChange, quiet)
    local step = ((max - min) <= 10) and 0.01 or 1
    local handle = section:AddSlider({
        Title = title,
        Min = min,
        Max = max,
        Default = default,
        Callback = function(value)
            value = math.floor(value / step + 0.5) * step
            Sim.state[title] = value
            if onChange then onChange(value) end
            if Sim.silent or quiet then return end
            -- Debounce: notifikasi hanya muncul setelah slider berhenti digeser.
            local token = (sliderTokens[title] or 0) + 1
            sliderTokens[title] = token
            task.delay(0.6, function()
                if sliderTokens[title] == token then
                    simNotify(title, "= " .. fmtNum(value), 1.5)
                end
            end)
        end,
    })
    register("slider", title, handle, default)
    return handle
end

local function addDropdown(section, title, options, default, onChange)
    local handle = section:AddDropdown({
        Title = title,
        Options = options,
        Default = default,
        Callback = function(value)
            Sim.state[title] = value
            if not Sim.silent then
                simNotify(title, "dipilih: " .. tostring(value), 1.5)
            end
            if onChange then onChange(value) end
        end,
    })
    register("dropdown", title, handle, default)
    return handle
end

local function addButton(section, title, action)
    section:AddButton({
        Title = title,
        Callback = function()
            if type(action) == "function" then
                action()
            else
                simNotify(title, "dijalankan (simulasi)", 1.5)
            end
        end,
    })
end

local function applyConfig(config)
    if type(config) ~= "table" then return 0 end
    local applied = 0
    Sim.silent = true
    for title, value in pairs(config) do
        local handle = Sim.handles[title]
        local kind = Sim.kinds[title]
        if handle then
            if kind == "toggle" and type(value) == "boolean" then
                handle:Set(value)
                applied = applied + 1
            elseif kind == "slider" and type(value) == "number" then
                pcall(function() handle:SetValue(value) end)
                applied = applied + 1
            elseif kind == "dropdown" and value ~= nil then
                pcall(function() handle:SetValue(value) end)
                applied = applied + 1
            end
        end
    end
    Sim.silent = false
    return applied
end

local function snapshotConfig()
    local copy = {}
    for title, value in pairs(Sim.state) do
        if Sim.handles[title] then copy[title] = value end
    end
    return copy
end

-- ------------------------------------------------------------------------------
-- WINDOW + TABS
-- ------------------------------------------------------------------------------
print("Loaded!\nAXS Violence Distric - SIMULATION MODE (tidak ada fitur yang berjalan sungguhan)")

Window = Lib:Window({
    Title = "AXS VD [ SIM ]",
    Footer = "Violence Distric By Arexans",
    Color = Color3.fromRGB(0, 170, 255),
    Version = 1,
})

Window:SetToggleKey(Enum.KeyCode.K)

local LogsTab = Window:AddTab({ Name = "Logs", Icon = "scroll" })
local UniversalTab = Window:AddTab({ Name = "Universal", Icon = "web" })
local KillerTab = Window:AddTab({ Name = "Pembunuh", Icon = "sword" })
local SurvivorTab = Window:AddTab({ Name = "Penyintas", Icon = "user" })
local EspTab = Window:AddTab({ Name = "ESP", Icon = "eyes" })
local PlayerTab = Window:AddTab({ Name = "Pemain", Icon = "player" })
local MiscTab = Window:AddTab({ Name = "Lainnya", Icon = "menu" })
local ConfigTab = Window:AddTab({ Name = "Konfigurasi", Icon = "settings" })
local ServerTab = Window:AddTab({ Name = "Server", Icon = "web" })
local KeybindTab = Window:AddTab({ Name = "Keybinds", Icon = "settings" })

-- ==============================================================================
-- SERVER TAB  (daftar server dummy, scroll vertikal + scrollbar popup/scrollbar_thumb.png)
-- ==============================================================================
-- Penyebab list sebelumnya tidak bisa di-scroll: ScreenGui memakai
-- ZIndexBehavior.Global, sedangkan ServerFrame ber-ZIndex 3 berada DI BAWAH
-- Page (ZIndex 10, Active=true). Page menelan semua input sentuh/mouse, jadi
-- ScrollingFrame list tidak pernah menerima gesture. Semua elemen list sekarang
-- memakai ZIndex 28-40 (di atas Page, tetap di bawah window_frame ZIndex 50).
local UI = Window._ui

local function setImg(obj, path)
    if UI and type(UI.SetImage) == "function" then
        pcall(function() UI:SetImage(obj, path) end)
    end
end

local serverData = {}
local currentFilter = "Normal"
local joinedId = nil
local refreshServers
local renderServers

local FILTER_LABEL = {
    Normal = "Normal",
    Low = "Low (Sepi)",
    Fast = "Ping Cepat",
}

local rng = Random.new()
local function genServers(count)
    local list = {}
    for i = 1, count do
        local maxPlayers = 12
        local playing
        if rng:NextNumber() < 0.35 then
            playing = rng:NextInteger(1, 5)
        else
            playing = rng:NextInteger(3, maxPlayers - 1)
        end
        list[i] = {
            id = string.format("SIM-%04X-%04X", rng:NextInteger(0, 65535), rng:NextInteger(0, 65535)),
            playing = playing,
            maxPlayers = maxPlayers,
            ping = rng:NextInteger(35, 320),
            fps = rng:NextInteger(28, 60),
        }
    end
    return list
end
serverData = genServers(28)

local okServer, errServer = pcall(function()
    local ServerListSection = ServerTab:AddSection("Server List", true)
    local listRoot = ServerListSection.SectionRoot
    local listArea = ServerListSection.SectionAdd
    assert(listRoot and listArea, "Server List container tidak tersedia")

    -- ---------- container ----------
    listRoot.ZIndex = 28
    listRoot.ClipsDescendants = true
    listRoot.BackgroundTransparency = 1

    local backdrop = Instance.new("ImageLabel")
    backdrop.Name = "ServerListBackdrop"
    backdrop.BackgroundTransparency = 1
    backdrop.BorderSizePixel = 0
    backdrop.Position = UDim2.new(0, 2, 0, 24)
    backdrop.Size = UDim2.new(1, -4, 1, -26)
    backdrop.ScaleType = Enum.ScaleType.Stretch
    backdrop.ZIndex = 29
    backdrop.Parent = listRoot
    setImg(backdrop, "containers/panel2.png")

    local headerArt = Instance.new("ImageLabel")
    headerArt.Name = "ServerHeaderAsset"
    headerArt.BackgroundTransparency = 1
    headerArt.BorderSizePixel = 0
    headerArt.Position = UDim2.new(0, -5, 0, 0)
    headerArt.Size = UDim2.new(1, 20, 0, 26)
    headerArt.ScaleType = Enum.ScaleType.Stretch
    headerArt.ZIndex = 30
    headerArt.Parent = listRoot
    setImg(headerArt, "long_horizonal_box.png")

    local headerTitle = listRoot:FindFirstChild("Title")
    if not headerTitle then
        headerTitle = Instance.new("TextLabel")
        headerTitle.Name = "Title"
        headerTitle.BackgroundTransparency = 1
        headerTitle.Font = Enum.Font.GothamBold
        headerTitle.TextColor3 = Color3.fromRGB(230, 248, 255)
        headerTitle.TextSize = 9
        headerTitle.TextXAlignment = Enum.TextXAlignment.Left
        headerTitle.Parent = listRoot
    end
    headerTitle.Position = UDim2.new(0, 14, 0, 0)
    headerTitle.Size = UDim2.new(1, -222, 0, 26)
    headerTitle.TextYAlignment = Enum.TextYAlignment.Center
    headerTitle.TextTruncate = Enum.TextTruncate.AtEnd
    headerTitle.ZIndex = 31

    -- Label status kecil (filter + jumlah) di sebelah kiri tombol header.
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "ServerStatusInfo"
    statusLabel.BackgroundTransparency = 1
    statusLabel.AnchorPoint = Vector2.new(1, 0)
    statusLabel.Position = UDim2.new(1, -142, 0, 0)
    statusLabel.Size = UDim2.new(0, 62, 0, 26)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 8
    statusLabel.TextColor3 = Color3.fromRGB(160, 215, 245)
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.TextYAlignment = Enum.TextYAlignment.Center
    statusLabel.TextTruncate = Enum.TextTruncate.AtEnd
    statusLabel.ZIndex = 31
    statusLabel.Parent = listRoot

    -- Judul = nama map Roblox yang sedang dimainkan.
    local mapName = tostring(game.Name)
    local function updateHeaderTitle()
        headerTitle.Text = mapName
        statusLabel.Text = FILTER_LABEL[currentFilter] .. "  •  " .. tostring(#serverData)
    end
    task.spawn(function()
        local ok, info = pcall(function()
            return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        end)
        if ok and type(info) == "table" and type(info.Name) == "string" and info.Name ~= "" then
            mapName = info.Name
            if headerTitle.Parent then updateHeaderTitle() end
        end
    end)

    local function makeHeaderButton(name, iconPath, rightOffset, holderH, iconW, iconH)
        local holder = Instance.new("ImageLabel")
        holder.Name = name .. "Background"
        holder.BackgroundTransparency = 1
        holder.BorderSizePixel = 0
        holder.AnchorPoint = Vector2.new(1, 0)
        holder.Position = UDim2.new(1, rightOffset, 0, 2)
        holder.Size = UDim2.fromOffset(25, holderH)
        holder.ScaleType = Enum.ScaleType.Stretch
        holder.ZIndex = 31
        holder.Parent = listRoot
        setImg(holder, "popup/header_frame_center.png")

        local button = Instance.new("ImageButton")
        button.Name = name
        button.BackgroundTransparency = 1
        button.AutoButtonColor = false
        button.AnchorPoint = Vector2.new(0.5, 0.5)
        button.Position = UDim2.fromScale(0.5, 0.5)
        button.Size = UDim2.fromOffset(iconW, iconH)
        button.ScaleType = Enum.ScaleType.Fit
        button.ZIndex = 32
        button.Parent = holder
        setImg(button, iconPath)
        return button
    end

    local FilterButton = makeHeaderButton("FilterIcon", "icons/filter_sliders.png", -50, 22, 16, 15)
    local RefreshButton = makeHeaderButton("RefreshIcon", "icons/refresh.png", -10, 20, 25, 15)

    -- ---------- viewport list ----------
    listArea.Position = UDim2.new(0, 14, 0, 34)
    listArea.Size = UDim2.new(1, -44, 1, -50)
    listArea.BackgroundTransparency = 1
    listArea.BorderSizePixel = 0
    listArea.ClipsDescendants = true
    listArea.Active = false
    listArea.ZIndex = 32

    local ServerFrame = Instance.new("ScrollingFrame")
    ServerFrame.Name = "ServerScroll"
    ServerFrame.Position = UDim2.new(0, 2, 0, 0)
    ServerFrame.Size = UDim2.new(1, 10, 1, 0)
    ServerFrame.BackgroundTransparency = 1
    ServerFrame.BorderSizePixel = 0
    ServerFrame.ClipsDescendants = true
    ServerFrame.Active = true
    ServerFrame.Selectable = true
    ServerFrame.ScrollingEnabled = true
    ServerFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ServerFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    ServerFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
    ServerFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    -- Scrollbar bawaan Roblox disembunyikan; diganti thumb bergambar di bawah.
    ServerFrame.ScrollBarThickness = 0
    ServerFrame.ScrollBarImageTransparency = 1
    ServerFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
    ServerFrame.ZIndex = 33
    ServerFrame.Parent = listArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 3)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = ServerFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 2)
    padding.PaddingBottom = UDim.new(0, 4)
    padding.PaddingLeft = UDim.new(0, 2)
    padding.PaddingRight = UDim.new(0, 2)
    padding.Parent = ServerFrame

    -- ---------- custom scrollbar: popup/scrollbar_thumb.png ----------
    local Track = Instance.new("Frame")
    Track.Name = "ServerScrollTrack"
    Track.AnchorPoint = Vector2.new(1, 0)
    Track.Position = UDim2.new(1, 0, 0, 2)
    Track.Size = UDim2.new(0, 6, 1, -4)
    Track.BackgroundColor3 = Color3.fromRGB(4, 24, 52)
    Track.BackgroundTransparency = 0.45
    Track.BorderSizePixel = 0
    Track.Active = true
    Track.ZIndex = 36
    Track.Parent = listArea
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = Track

    local Thumb = Instance.new("ImageLabel")
    Thumb.Name = "ServerScrollThumb"
    Thumb.BackgroundColor3 = Color3.fromRGB(35, 180, 255)
    Thumb.BackgroundTransparency = 0.25 -- fallback sampai gambar selesai diunduh
    Thumb.BorderSizePixel = 0
    Thumb.ScaleType = Enum.ScaleType.Stretch
    Thumb.Size = UDim2.new(1, 0, 0.3, 0)
    Thumb.Position = UDim2.new(0, 0, 0, 0)
    Thumb.ZIndex = 37
    Thumb.Parent = Track
    setImg(Thumb, "popup/scrollbar_thumb.png")

    local function syncThumbFallback()
        local img = Thumb.Image
        local loaded = img ~= "" and img ~= "rbxassetid://0"
        Thumb.BackgroundTransparency = loaded and 1 or 0.25
    end
    Thumb:GetPropertyChangedSignal("Image"):Connect(syncThumbFallback)
    syncThumbFallback()

    local thumbFrac = 0.3
    local function windowHeight()
        local h = ServerFrame.AbsoluteWindowSize.Y
        if h <= 0 then h = ServerFrame.AbsoluteSize.Y end
        return h
    end

    local function updateThumb()
        if not ServerFrame.Parent then return end
        local viewH = windowHeight()
        local canvasH = ServerFrame.AbsoluteCanvasSize.Y
        local maxScroll = canvasH - viewH
        if maxScroll <= 1 or canvasH <= 0 then
            Track.Visible = false
            return
        end
        Track.Visible = true
        thumbFrac = math.clamp(viewH / canvasH, 0.12, 1)
        local alpha = math.clamp(ServerFrame.CanvasPosition.Y / maxScroll, 0, 1)
        Thumb.Size = UDim2.new(1, 0, thumbFrac, 0)
        Thumb.Position = UDim2.new(0, 0, (1 - thumbFrac) * alpha, 0)
    end

    local function updateCanvas()
        if not ServerFrame.Parent then return end
        local contentH = layout.AbsoluteContentSize.Y
        -- UIListLayout tidak menghitung UIPadding, jadi ditambahkan manual.
        ServerFrame.CanvasSize = UDim2.new(0, 0, 0, contentH + padding.PaddingTop.Offset + padding.PaddingBottom.Offset)
        local maxY = math.max(0, ServerFrame.AbsoluteCanvasSize.Y - windowHeight())
        if ServerFrame.CanvasPosition.Y > maxY then
            ServerFrame.CanvasPosition = Vector2.new(0, maxY)
        end
        updateThumb()
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    ServerFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas)
    ServerFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateThumb)
    ServerFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(updateThumb)
    Track:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateThumb)

    -- Drag thumb / tap track untuk lompat ke posisi tertentu.
    local draggingThumb = false
    local dragInput = nil
    local function scrollToPointer(posY)
        local maxScroll = math.max(0, ServerFrame.AbsoluteCanvasSize.Y - windowHeight())
        local trackPx = math.max(1, Track.AbsoluteSize.Y)
        local thumbPx = thumbFrac * trackPx
        local usable = math.max(1, trackPx - thumbPx)
        local alpha = math.clamp((posY - Track.AbsolutePosition.Y - thumbPx / 2) / usable, 0, 1)
        ServerFrame.CanvasPosition = Vector2.new(0, alpha * maxScroll)
    end
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingThumb = true
            dragInput = input
            scrollToPointer(input.Position.Y)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not draggingThumb then return end
        local isMouse = input.UserInputType == Enum.UserInputType.MouseMovement
        local isTouch = input.UserInputType == Enum.UserInputType.Touch and input == dragInput
        if isMouse or isTouch then
            scrollToPointer(input.Position.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingThumb = false
            dragInput = nil
        end
    end)

    -- ---------- rows ----------
    local function clearRows()
        for _, child in ipairs(ServerFrame:GetChildren()) do
            if child:IsA("GuiObject") then child:Destroy() end
        end
    end

    local function addStatusRow(text)
        local label = Instance.new("TextLabel")
        label.Name = "ServerStatus"
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -4, 0, 38)
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextColor3 = Color3.fromRGB(175, 215, 245)
        label.TextSize = 10
        label.ZIndex = 35
        label.Parent = ServerFrame
    end

    local rowWidgets = {}

    local function setJoinedVisual(serverId, joined)
        local widget = rowWidgets[serverId]
        if not widget or not widget.button.Parent then return end
        widget.label.Text = joined and "Joined" or "Join"
        widget.button.ImageColor3 = joined and Color3.fromRGB(150, 255, 180) or Color3.fromRGB(255, 255, 255)
    end

    local function createRow(index, server)
        local row = Instance.new("ImageLabel")
        row.Name = "ServerEntry"
        row.BackgroundTransparency = 1
        row.BorderSizePixel = 0
        row.Size = UDim2.new(1, -4, 0, 38)
        row.LayoutOrder = index
        row.ScaleType = Enum.ScaleType.Stretch
        row.ClipsDescendants = true
        row.ZIndex = 34
        row.Parent = ServerFrame
        setImg(row, "long_horizonal_box.png")

        local icon = Instance.new("ImageLabel")
        icon.Name = "ServerIcon"
        icon.BackgroundTransparency = 1
        icon.Position = UDim2.new(0, 15, 0.5, -10)
        icon.Size = UDim2.fromOffset(20, 20)
        icon.ScaleType = Enum.ScaleType.Fit
        icon.ZIndex = 35
        icon.Parent = row
        setImg(icon, "icons/server_global.png")

        local pingColor = "#00FF66"
        if server.ping > 200 then
            pingColor = "#FF4444"
        elseif server.ping > 100 then
            pingColor = "#FFD21E"
        end

        local info = Instance.new("TextLabel")
        info.Name = "Info"
        info.BackgroundTransparency = 1
        info.Position = UDim2.new(0, 45, 0, 0)
        info.Size = UDim2.new(1, -100, 1, 0)
        info.Font = Enum.Font.Gotham
        info.RichText = true
        info.TextSize = 9
        info.TextColor3 = Color3.fromRGB(255, 255, 255)
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Center
        info.TextTruncate = Enum.TextTruncate.AtEnd
        info.ZIndex = 35
        info.Text = string.format(
            "<b>%s</b>\n%d/%d Players  |  Ping: <font color='%s'>%d</font>  |  FPS: %d",
            server.id, server.playing, server.maxPlayers, pingColor, server.ping, server.fps
        )
        info.Parent = row

        local join = Instance.new("ImageButton")
        join.Name = "JoinButton"
        join.BackgroundTransparency = 1
        join.AutoButtonColor = false
        join.AnchorPoint = Vector2.new(1, 0.5)
        join.Position = UDim2.new(1, -20, 0.5, -1)
        join.Size = UDim2.fromOffset(50, 25)
        join.ScaleType = Enum.ScaleType.Stretch
        join.ZIndex = 36
        join.Parent = row
        setImg(join, "button_selected.png")

        local joinLabel = Instance.new("TextLabel")
        joinLabel.Name = "JoinLabel"
        joinLabel.BackgroundTransparency = 1
        joinLabel.Size = UDim2.fromScale(1, 1)
        joinLabel.Font = Enum.Font.GothamBold
        joinLabel.Text = "Join"
        joinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        joinLabel.TextSize = 10
        joinLabel.ZIndex = 37
        joinLabel.Parent = join

        rowWidgets[server.id] = { button = join, label = joinLabel }
        if joinedId == server.id then setJoinedVisual(server.id, true) end

        join.MouseEnter:Connect(function()
            join.ImageTransparency = 0.2
        end)
        join.MouseLeave:Connect(function()
            join.ImageTransparency = 0
        end)
        join.MouseButton1Click:Connect(function()
            local previous = joinedId
            joinedId = server.id
            if previous then setJoinedVisual(previous, false) end
            setJoinedVisual(server.id, true)
            simNotify("Join Server", server.id .. " (simulasi, tidak ada teleport)", 2.5)
        end)
    end

    local function getFiltered()
        local out = {}
        for _, s in ipairs(serverData) do
            if currentFilter ~= "Low" or s.playing <= 5 then
                table.insert(out, s)
            end
        end
        if currentFilter == "Fast" then
            table.sort(out, function(a, b) return a.ping < b.ping end)
        end
        return out
    end

    renderServers = function()
        clearRows()
        table.clear(rowWidgets)
        local list = getFiltered()
        if #list == 0 then
            addStatusRow("Tidak ada server yang cocok dengan filter")
        else
            for index, server in ipairs(list) do
                createRow(index, server)
            end
        end
        updateHeaderTitle()
        task.defer(updateCanvas)
    end

    local refreshToken = 0
    refreshServers = function(quiet)
        refreshToken = refreshToken + 1
        local token = refreshToken
        clearRows()
        table.clear(rowWidgets)
        addStatusRow("Memuat daftar server (simulasi)...")
        task.delay(0.6, function()
            if token ~= refreshToken or not ServerFrame.Parent then return end
            serverData = genServers(28)
            joinedId = nil
            ServerFrame.CanvasPosition = Vector2.new(0, 0)
            renderServers()
            if not quiet then
                simNotify("Server List", tostring(#serverData) .. " server dummy dibuat", 1.5)
            end
        end)
    end

    RefreshButton.MouseButton1Click:Connect(function()
        refreshServers(false)
    end)

    FilterButton.MouseButton1Click:Connect(function()
        if currentFilter == "Normal" then
            currentFilter = "Low"
        elseif currentFilter == "Low" then
            currentFilter = "Fast"
        else
            currentFilter = "Normal"
        end
        ServerFrame.CanvasPosition = Vector2.new(0, 0)
        renderServers()
        simNotify("Server Filter", "Filter aktif: " .. FILTER_LABEL[currentFilter], 2)
    end)

    renderServers()
end)
if not okServer then
    warn("[AXS VD] Server List gagal dibuat: " .. tostring(errServer))
end

local ServerControls = ServerTab:AddSection("Server Controls", true)

local function simTeleport(label, serverId)
    simNotify(label, "Menyimulasikan perpindahan server...", 1.2)
    task.delay(1.3, function()
        simNotify(label, "Selesai -> " .. serverId .. " (tanpa teleport sungguhan)", 2.5)
    end)
end

addButton(ServerControls, "Rejoin Server", function()
    simTeleport("Rejoin Server", "SIM-CURRENT")
end)
addButton(ServerControls, "Hop Random Server", function()
    local pick = serverData[rng:NextInteger(1, math.max(1, #serverData))]
    simTeleport("Hop Random", pick and pick.id or "SIM-RANDOM")
end)
addButton(ServerControls, "Hop Low Pop Server", function()
    local best = nil
    for _, s in ipairs(serverData) do
        if not best or s.playing < best.playing then best = s end
    end
    if best and best.playing < 5 then
        simTeleport("Hop Low Pop", best.id .. " (" .. best.playing .. " pemain)")
    else
        simNotify("Hop Low Pop", "Tidak ada server sepi (simulasi).", 2.5)
    end
end)

-- ==============================================================================
-- LOGS
-- ==============================================================================
local LogsSection = LogsTab:AddSection("Update Logs", true)
local function logLine(text)
    LogsSection:AddParagraph({ Title = text, Content = "" })
end
logLine("MODE SIMULASI")
logLine("[i] Semua fitur hanya simulasi UI")
logLine("[i] Tidak ada efek ke game")
logLine("[i] Tidak ada remote / teleport")
logLine("[+] Warna ESP + Gradient (preview)")
logLine("08.01.26 — UPDATE")
logLine("[+] Auto Play (AI, BETA)")
logLine("[+] Auto Run (BETA)")
logLine("[+] Auto Farm (BETA)")
logLine("[+] Auto Loop (BETA)")
logLine("[+] Wall Hug")
logLine("[+] Version Checker")
logLine("[+] Fixed ESP Tracers/Boxes")
logLine("[+] Better Pallet Detection")
logLine("[+] Better Window Detection")
logLine("07.01.26 — FIXES")
logLine("[+] Infinite Lunge (Premium)")
logLine("[+] Hook Farm (Screws)")
logLine("[+] Charged Spear Aim (Veil)")
logLine("[+] Spear Aim (Veil)")
logLine("[+] Expand Hitboxes")
logLine("[+] No Fall")
logLine("[/] Damage Aura fixes")
logLine("[/] General improvements")
logLine("[/] Code rewritten")
addButton(LogsSection, "Copy Community Link", function()
    simNotify("Community", "Link disalin (simulasi)", 2)
end)

-- ==============================================================================
-- UNIVERSAL
-- ==============================================================================
local FunSection = UniversalTab:AddSection("Fun", true)
addToggle(FunSection, "Desync (Anti Hit)")
addDropdown(FunSection, "Tipe Desync", { "Hitbox Improving", "Fake Position" }, "Hitbox Improving")
addToggle(FunSection, "Invisibilitas")
FunSection:AddDivider()
addSlider(FunSection, "Radius Hitbox", 5, 30, 10)
addToggle(FunSection, "Perbesar Hitbox")
addToggle(FunSection, "Hitbox Terlihat?")

local UMiscSection = UniversalTab:AddSection("Lainnya", true)
addToggle(UMiscSection, "Auto Farm Event")
addToggle(UMiscSection, "Crosshair (Bidik)")
addDropdown(UMiscSection, "Tipe Crosshair", {
    "crosshair dot", "crosshair dot 2", "crosshair square", "crosshair +•", "crosshair +",
    "crosshair O+", "crosshair O+ 2", "Croshair (+)", "Crosshair [ • ]", "Crosshair [O+]", "Crosshair star",
}, "crosshair dot")
addToggle(UMiscSection, "Potato Grafik")
addToggle(UMiscSection, "Anti Freeze / Anti Lag")
addToggle(UMiscSection, "Tampilkan Tombol Lompat")

local UPlaySection = UniversalTab:AddSection("Auto Play", true)
addToggle(UPlaySection, "Auto Play (AI, BETA)")
UPlaySection:AddDivider()
addToggle(UPlaySection, "Auto Run (BETA)")
addToggle(UPlaySection, "Auto Farm (BETA)")
addToggle(UPlaySection, "Auto Loop (BETA)")
addToggle(UPlaySection, "Wall Hug")

-- ==============================================================================
-- KILLER
-- ==============================================================================
local KillerBlatantSection = KillerTab:AddSection("Blatant (Kasar)", true)
addToggle(KillerBlatantSection, "Infinite Abilities (PREMIUM)")
addToggle(KillerBlatantSection, "Infinite Lunge (PREMIUM)")
KillerBlatantSection:AddDivider()
addToggle(KillerBlatantSection, "Hook Farm (Sekrup)")
addSlider(KillerBlatantSection, "Jumlah Hook", 2, 1000, 10)

local KillerSection = KillerTab:AddSection("Berburu", true)
addToggle(KillerSection, "Damage Aura")
KillerSection:AddDivider()
addToggle(KillerSection, "Auto Aim Tombak Terisi (Veil)")
addToggle(KillerSection, "Auto Aim Tombak (Veil)")
addToggle(KillerSection, "Silent Aim (Veil Spear)")
addToggle(KillerSection, "Show FOV Veil")
addToggle(KillerSection, "ESP Khusus Veil")
addToggle(KillerSection, "Crosshair Veil")

local KillerMiscSection = KillerTab:AddSection("Atribut", true)
addToggle(KillerMiscSection, "Anti Senter (Flashlight)")
addToggle(KillerMiscSection, "Anti Lambat (Slow Down)")
addButton(KillerMiscSection, "Aktifkan Emote")

-- ==============================================================================
-- SURVIVOR
-- ==============================================================================
local SurvSection = SurvivorTab:AddSection("Pertarungan", true)
addToggle(SurvSection, "Mode Dewa (PREMIUM)")
addToggle(SurvSection, "Auto Target (Aimbot)")
addToggle(SurvSection, "Auto Serang (Cerdas)")
addToggle(SurvSection, "Show FOV Pistol")
addToggle(SurvSection, "Laser Target Lock")
addToggle(SurvSection, "ESP Stunned Detect")
addDropdown(SurvSection, "Pilih Target Aim", { "Killers", "Players" }, "Killers")
addDropdown(SurvSection, "Bagian Target Aim", { "Kepala", "Badan", "Pundak Kanan", "Pundak Kiri" }, "Kepala")

local SurvDefSection = SurvivorTab:AddSection("Looping", true)
addToggle(SurvDefSection, "Auto Tangkis Pembunuh")
addToggle(SurvDefSection, "Auto Face Killer (Smart Face)", true)
addToggle(SurvDefSection, "Visual Radius Tangkis")
addSlider(SurvDefSection, "Radius Tangkis", 5, 30, 20)
addSlider(SurvDefSection, "Jeda Tangkis (Delay)", 0, 1, 0)
addDropdown(SurvDefSection, "Metode Tangkis", { "Combined", "Lunge", "Attack (BETA)" }, "Lunge")
addToggle(SurvDefSection, "No Fall (Anti Jatuh)")
SurvDefSection:AddDivider()
addToggle(SurvDefSection, "Auto Jatuhkan Pallet")
addToggle(SurvDefSection, "Pallet Saat Digendong?")

local SurvMiscSection = SurvivorTab:AddSection("Objektif", true)
addToggle(SurvMiscSection, "Auto Perfect Generator")
addToggle(SurvMiscSection, "Auto Perfect Heal")
SurvMiscSection:AddDivider()
addToggle(SurvMiscSection, "Anti Gagal Generator")
addToggle(SurvMiscSection, "Hapus Pakaian Veil")
addToggle(SurvMiscSection, "Anti Camp Selalu Berjalan")
addButton(SurvMiscSection, "Kabur Instan")
addButton(SurvMiscSection, "Hancurkan Gerbang")

-- ==============================================================================
-- ESP
-- ==============================================================================
local EspSection = EspTab:AddSection("Visual", true)
addToggle(EspSection, "Kunci FOV")
addToggle(EspSection, "Tampilkan FPS")
addSlider(EspSection, "Radius FOV", 1, 120, 70)
addToggle(EspSection, "Infinite Zoom Out")
addToggle(EspSection, "Terang Penuh (Full Bright)")
addDropdown(EspSection, "ESP Style", { "Full", "Outline Only" }, "Full")
addDropdown(EspSection, "ESP's", { "Killers", "Players", "Generators", "Presents", "Windows", "Pallets" }, "Killers")
addToggle(EspSection, "Highlight Objek")
addToggle(EspSection, "Tampilkan Tracer (Garis)")
addToggle(EspSection, "Tampilkan Kotak (Box)")
addToggle(EspSection, "Tampilkan Nama")
addToggle(EspSection, "Snow Ping & FPS")
addToggle(EspSection, "Tampilkan Jarak (Studs)")

-- ==============================================================================
-- WARNA ESP (SIMULASI): warna tunggal atau gradient + preview langsung
-- Hanya mengubah tampilan preview di UI; tidak ada ESP sungguhan yang dibuat.
-- ==============================================================================
local DEFAULT_RGB = {
    ["Warna 1"] = { 255, 60, 60 },
    ["Warna 2"] = { 255, 200, 80 },
}
local COLOR_PRESETS = {
    Merah = { 255, 60, 60 },
    Oranye = { 255, 150, 40 },
    Kuning = { 255, 220, 50 },
    Hijau = { 60, 255, 120 },
    Cyan = { 40, 220, 255 },
    Biru = { 60, 120, 255 },
    Ungu = { 170, 80, 255 },
    Pink = { 255, 100, 200 },
    Putih = { 255, 255, 255 },
}
local COLOR_PRESET_NAMES = { "Custom", "Merah", "Oranye", "Kuning", "Hijau", "Cyan", "Biru", "Ungu", "Pink", "Putih" }
local GRADIENT_PRESETS = {
    Sunset = { { 255, 90, 90 }, { 255, 200, 80 } },
    Ocean = { { 0, 180, 255 }, { 120, 90, 255 } },
    Neon = { { 255, 0, 200 }, { 0, 255, 230 } },
    Fire = { { 255, 40, 0 }, { 255, 220, 0 } },
    Toxic = { { 160, 255, 0 }, { 0, 200, 120 } },
    Ice = { { 200, 240, 255 }, { 60, 140, 255 } },
    Blood = { { 120, 0, 0 }, { 255, 50, 50 } },
}
local GRADIENT_PRESET_NAMES = { "Custom", "Sunset", "Ocean", "Neon", "Fire", "Toxic", "Ice", "Blood" }
local GRADIENT_DIRECTIONS = { Horizontal = 0, Vertical = 90, Diagonal = 45 }
local updateEspPreview

local function refreshEspPreview()
    if updateEspPreview then updateEspPreview() end
end

local function readEspColor(prefix)
    local fallback = DEFAULT_RGB[prefix]
    local function channel(name, index)
        local value = Sim.state[prefix .. " " .. name]
        if type(value) ~= "number" then value = fallback[index] end
        return math.clamp(math.floor(value + 0.5), 0, 255)
    end
    return Color3.fromRGB(channel("R", 1), channel("G", 2), channel("B", 3))
end

local function toHex(color)
    return string.format(
        "#%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
end

local function setEspSliders(prefix, rgb)
    local previous = Sim.silent
    Sim.silent = true
    for index, channel in ipairs({ "R", "G", "B" }) do
        local handle = Sim.handles[prefix .. " " .. channel]
        if handle then
            pcall(function() handle:SetValue(rgb[index]) end)
        end
    end
    Sim.silent = previous
    refreshEspPreview()
end

local function enableToggleQuietly(title)
    local handle = Sim.handles[title]
    if not handle then return end
    local previous = Sim.silent
    Sim.silent = true
    handle:Set(true)
    Sim.silent = previous
end

local EspColorSection = EspTab:AddSection("Warna ESP", true)
addToggle(EspColorSection, "Warna Kustom ESP", false, refreshEspPreview)
addDropdown(EspColorSection, "Preset Warna ESP", COLOR_PRESET_NAMES, "Merah", function(name)
    local rgb = COLOR_PRESETS[name]
    if not rgb then return end
    enableToggleQuietly("Warna Kustom ESP")
    setEspSliders("Warna 1", rgb)
end)

local EspPreviewSection = EspTab:AddSection("Preview Warna ESP", true)
local okPreview, errPreview = pcall(function()
    local previewRoot = EspPreviewSection.SectionRoot
    local previewArea = EspPreviewSection.SectionAdd
    assert(previewRoot and previewArea, "Preview container tidak tersedia")

    -- ZIndexBehavior.Global: harus di atas Page (10), di bawah window_frame (50).
    previewRoot.ZIndex = 28
    local previewTitle = previewRoot:FindFirstChild("Title")
    if previewTitle then previewTitle.ZIndex = 31 end
    previewArea.ZIndex = 32

    local panel = Instance.new("Frame")
    panel.Name = "EspPreviewPanel"
    panel.BackgroundColor3 = Color3.fromRGB(4, 24, 52)
    panel.BackgroundTransparency = 0.3
    panel.BorderSizePixel = 0
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.ZIndex = 33
    panel.Parent = previewArea
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 8)
    panelCorner.Parent = panel
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(35, 140, 255)
    panelStroke.Transparency = 0.5
    panelStroke.Thickness = 1
    panelStroke.Parent = panel

    local fill = Instance.new("Frame")
    fill.Name = "EspPreviewFill"
    fill.BackgroundColor3 = Color3.new(1, 1, 1)
    fill.BorderSizePixel = 0
    fill.Position = UDim2.new(0, 8, 0, 8)
    fill.Size = UDim2.new(0.5, -12, 0, 30)
    fill.ZIndex = 34
    fill.Parent = panel
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 6)
    fillCorner.Parent = fill
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Parent = fill

    local outline = Instance.new("Frame")
    outline.Name = "EspPreviewOutline"
    outline.BackgroundTransparency = 1
    outline.BorderSizePixel = 0
    outline.Position = UDim2.new(0.5, 4, 0, 8)
    outline.Size = UDim2.new(0.5, -12, 0, 30)
    outline.ZIndex = 34
    outline.Parent = panel
    local outlineCorner = Instance.new("UICorner")
    outlineCorner.CornerRadius = UDim.new(0, 6)
    outlineCorner.Parent = outline
    local outlineStroke = Instance.new("UIStroke")
    outlineStroke.Color = Color3.new(1, 1, 1)
    outlineStroke.Thickness = 2
    outlineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    outlineStroke.Parent = outline
    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Parent = outlineStroke

    local function makeTag(parent, text)
        local tag = Instance.new("TextLabel")
        tag.BackgroundTransparency = 1
        tag.Size = UDim2.new(1, 0, 1, 0)
        tag.Font = Enum.Font.GothamBold
        tag.Text = text
        tag.TextSize = 9
        tag.TextColor3 = Color3.new(1, 1, 1)
        tag.TextStrokeColor3 = Color3.new(0, 0, 0)
        tag.TextStrokeTransparency = 0.5
        tag.ZIndex = 35
        tag.Parent = parent
    end
    makeTag(fill, "ESP Fill")
    makeTag(outline, "ESP Outline")

    local info = Instance.new("TextLabel")
    info.Name = "EspPreviewInfo"
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0, 8, 0, 42)
    info.Size = UDim2.new(1, -16, 0, 18)
    info.Font = Enum.Font.GothamBold
    info.TextSize = 9
    info.TextColor3 = Color3.fromRGB(175, 215, 245)
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextTruncate = Enum.TextTruncate.AtEnd
    info.ZIndex = 34
    info.Parent = panel

    updateEspPreview = function()
        if not panel.Parent then return end
        local color1 = readEspColor("Warna 1")
        local color2 = readEspColor("Warna 2")
        local useGradient = Sim.state["Gunakan Gradient"] == true
        local customOn = Sim.state["Warna Kustom ESP"] == true
        local sequence
        if useGradient then
            sequence = ColorSequence.new(color1, color2)
        else
            sequence = ColorSequence.new(color1)
        end
        fillGradient.Color = sequence
        strokeGradient.Color = sequence

        if not (useGradient and Sim.state["Animasi Gradient"] == true) then
            local rotation = GRADIENT_DIRECTIONS[Sim.state["Arah Gradient"] or "Horizontal"] or 0
            fillGradient.Rotation = rotation
            strokeGradient.Rotation = rotation
        end

        local fade = customOn and 0 or 0.65
        fill.BackgroundTransparency = fade
        outlineStroke.Transparency = fade

        if not customOn then
            info.Text = "Warna kustom OFF (memakai warna bawaan ESP)"
        elseif useGradient then
            info.Text = "Gradient  " .. toHex(color1) .. "  →  " .. toHex(color2)
        else
            info.Text = "Warna  " .. toHex(color1)
        end
    end

    -- Animasi putar gradient (hanya di preview UI).
    task.spawn(function()
        local angle = 0
        while panel.Parent do
            if Sim.state["Gunakan Gradient"] == true and Sim.state["Animasi Gradient"] == true then
                angle = (angle + 3) % 360
                fillGradient.Rotation = angle
                strokeGradient.Rotation = angle
                task.wait(0.03)
            else
                task.wait(0.25)
            end
        end
    end)
end)
if not okPreview then
    warn("[AXS VD] Preview Warna ESP gagal dibuat: " .. tostring(errPreview))
end

local EspColor1Section = EspTab:AddSection("Warna 1", true)
addSlider(EspColor1Section, "Warna 1 R", 0, 255, 255, refreshEspPreview, true)
addSlider(EspColor1Section, "Warna 1 G", 0, 255, 60, refreshEspPreview, true)
addSlider(EspColor1Section, "Warna 1 B", 0, 255, 60, refreshEspPreview, true)

local EspGradientSection = EspTab:AddSection("Gradient ESP", true)
addToggle(EspGradientSection, "Gunakan Gradient", false, refreshEspPreview)
addDropdown(EspGradientSection, "Preset Gradient ESP", GRADIENT_PRESET_NAMES, "Custom", function(name)
    local preset = GRADIENT_PRESETS[name]
    if not preset then return end
    enableToggleQuietly("Warna Kustom ESP")
    enableToggleQuietly("Gunakan Gradient")
    setEspSliders("Warna 1", preset[1])
    setEspSliders("Warna 2", preset[2])
end)
addDropdown(EspGradientSection, "Arah Gradient", { "Horizontal", "Vertical", "Diagonal" }, "Horizontal", refreshEspPreview)
addToggle(EspGradientSection, "Animasi Gradient", false, refreshEspPreview)
addSlider(EspGradientSection, "Warna 2 R", 0, 255, 255, refreshEspPreview, true)
addSlider(EspGradientSection, "Warna 2 G", 0, 255, 200, refreshEspPreview, true)
addSlider(EspGradientSection, "Warna 2 B", 0, 255, 80, refreshEspPreview, true)
refreshEspPreview()

-- ==============================================================================
-- PLAYER
-- ==============================================================================
local PlayerSection = PlayerTab:AddSection("Main", true)
addToggle(PlayerSection, "Camera DBD")
addSlider(PlayerSection, "DBD Camera Distance", 5, 100, 25)
addSlider(PlayerSection, "DBD Camera FOV", 40, 160, 120)
addSlider(PlayerSection, "DBD Camera Height", -5, 10, 0)
addSlider(PlayerSection, "DBD Character Scale", 0.01, 1, 0.05)
addToggle(PlayerSection, "Use Character Scale", true)
addButton(PlayerSection, "Reset Camera DBD", function()
    applyConfig({
        ["DBD Camera Distance"] = 25,
        ["DBD Camera FOV"] = 120,
        ["DBD Camera Height"] = 0,
        ["DBD Character Scale"] = 0.05,
    })
    simNotify("Camera DBD", "Nilai di-reset ke default", 1.8)
end)
addToggle(PlayerSection, "Lock Target Hidden")
addToggle(PlayerSection, "Noclip (Tembus Tembok)")
addToggle(PlayerSection, "Kunci Kecepatan Jalan")
addSlider(PlayerSection, "Kecepatan Jalan", 10, 100, 28)

-- ==============================================================================
-- MISC
-- ==============================================================================
local MiscSection = MiscTab:AddSection("Main", true)
MiscSection:AddInput({
    Title = "Hit Sound",
    Placeholder = "Sound ID",
    Default = "",
    Callback = function(value)
        Sim.state["Hit Sound"] = value
        if not Sim.silent and value ~= "" then
            simNotify("Hit Sound", "ID tersimpan: " .. tostring(value), 2)
        end
    end,
})
addDropdown(MiscSection, "Chase Theme", { "Mila - Compass", "Close To Me" }, "Mila - Compass")
addToggle(MiscSection, "Protect Identity")
addToggle(MiscSection, "Anti AFK")
addToggle(MiscSection, "Anti Fling")
addToggle(MiscSection, "Touch Fling")
addToggle(MiscSection, "Anti Admin")

-- ==============================================================================
-- KEYBINDS  (hanya men-toggle tampilan switch di UI)
-- ==============================================================================
local KeyNames = { "None" }
for code = string.byte("A"), string.byte("Z") do
    table.insert(KeyNames, string.char(code))
end
for _, name in ipairs({ "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine" }) do
    table.insert(KeyNames, name)
end
for i = 1, 12 do
    table.insert(KeyNames, "F" .. i)
end
for _, name in ipairs({
    "Space", "LeftShift", "RightShift", "LeftControl", "RightControl", "LeftAlt", "Tab",
    "Backspace", "Return", "CapsLock", "Insert", "Delete", "Home", "End", "PageUp", "PageDown",
    "Up", "Down", "Left", "Right", "MB1", "MB2",
}) do
    table.insert(KeyNames, name)
end

local KeybindSection = KeybindTab:AddSection("Keybinds", true)
local KeybindConns = {}
local KeybindHandles = {}
local KeybindValues = {}

local function addBind(name, target)
    local function apply(keyName)
        if KeybindConns[name] then
            KeybindConns[name]:Disconnect()
            KeybindConns[name] = nil
        end
        if not keyName or keyName == "None" then return end
        local keyCode, inputType
        if keyName == "MB1" then
            inputType = Enum.UserInputType.MouseButton1
        elseif keyName == "MB2" then
            inputType = Enum.UserInputType.MouseButton2
        else
            pcall(function() keyCode = Enum.KeyCode[keyName] end)
        end
        if not keyCode and not inputType then return end
        KeybindConns[name] = UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            local hit = (keyCode ~= nil and input.KeyCode == keyCode)
                or (inputType ~= nil and input.UserInputType == inputType)
            if not hit then return end
            if type(target) == "string" then
                local handle = Sim.handles[target]
                if handle then handle:Set(not Sim.state[target]) end
            elseif type(target) == "function" then
                target()
            end
        end)
    end
    KeybindHandles[name] = KeybindSection:AddDropdown({
        Title = name,
        Options = KeyNames,
        Default = "None",
        Callback = function(value)
            KeybindValues[name] = value
            apply(value)
            if not Sim.silent then
                simNotify("Keybind", name .. " = " .. tostring(value), 1.5)
            end
        end,
    })
end

addButton(KeybindSection, "Save Keybinds", function()
    local count = 0
    for _, value in pairs(KeybindValues) do
        if value and value ~= "None" then count = count + 1 end
    end
    simNotify("Keybinds", "Tersimpan di memori: " .. count .. " bind (simulasi)", 2)
end)
addButton(KeybindSection, "Reset Keybinds", function()
    Sim.silent = true
    for _, handle in pairs(KeybindHandles) do
        pcall(function() handle:SetValue("None") end)
    end
    Sim.silent = false
    simNotify("Keybinds", "Semua keybind di-reset", 2)
end)

addBind("Kursor Mouse", function()
    simNotify("Kursor Mouse", "Toggle kursor (simulasi)", 1.5)
end)
addBind("Lompat Manual (PC)", function()
    simNotify("Lompat Manual", "Lompat (simulasi)", 1.5)
end)
addBind("Crosshair", "Crosshair (Bidik)")
addBind("Auto Aim Killer", "Auto Aim Tombak (Veil)")
addBind("Auto Target", "Auto Target (Aimbot)")
addBind("Auto Serang", "Auto Serang (Cerdas)")
addBind("Auto Tangkis", "Auto Tangkis Pembunuh")
addBind("Noclip", "Noclip (Tembus Tembok)")
addBind("Speed", "Kunci Kecepatan Jalan")

-- ==============================================================================
-- CONFIG  (disimpan di memori saja; tidak menulis file)
-- ==============================================================================
local ConfigSection = ConfigTab:AddSection("Main", true)
local SavedConfig = nil

addButton(ConfigSection, "Save Config", function()
    SavedConfig = snapshotConfig()
    simNotify("Config", "Tersimpan di memori (simulasi)", 2)
end)
addButton(ConfigSection, "Copy Config", function()
    local ok, json = pcall(function() return HttpService:JSONEncode(snapshotConfig()) end)
    if ok then
        simNotify("Config", "Config " .. #json .. " karakter disalin (simulasi)", 2.5)
    else
        simNotify("Config", "Gagal membuat config", 2.5)
    end
end)
ConfigSection:AddInput({
    Title = "Import Config",
    Placeholder = "Tempel JSON",
    Default = "",
    Callback = function(value)
        if value == nil or value == "" then return end
        local ok, decoded = pcall(function() return HttpService:JSONDecode(value) end)
        if ok and type(decoded) == "table" then
            local applied = applyConfig(decoded)
            simNotify("Config", "Config dimuat: " .. applied .. " item", 2.5)
        else
            simNotify("Config", "JSON config tidak valid", 2.5)
        end
    end,
})
addButton(ConfigSection, "Reset Config", function()
    local defaults = {}
    for title, value in pairs(Sim.defaults) do defaults[title] = value end
    applyConfig(defaults)
    simNotify("Config", "Semua pengaturan di-reset", 2)
end)
addToggle(ConfigSection, "Kunci Icon Mengambang", true)

-- Selesai membangun UI: notifikasi mulai aktif.
Sim.silent = false
simNotify("Mode Simulasi", "Semua fitur hanya tampilan UI.", 4)
]=];local __AXS_COMPILER=loadstring or load;if type(__AXS_COMPILER)~="function"then __AXS_Bootstrap("AXS VD FAILED\nloadstring/load tidak tersedia di executor ini",false)warn("[AXS VD] loadstring/load unavailable")return end;__AXS_Bootstrap("AXS VD  •  Loading",true)local __AXS_CHUNK,__AXS_COMPILE_ERR=__AXS_COMPILER(__AXS_SOURCE)if type(__AXS_CHUNK)~="function"then local msg=tostring(__AXS_COMPILE_ERR)__AXS_Bootstrap("AXS VD COMPILE ERROR\n"..msg,false)warn("[AXS VD] COMPILE ERROR: "..msg)return end;local __AXS_OK,__AXS_ERR=xpcall(__AXS_CHUNK,function(err)local msg=tostring(err)pcall(function()if debug and debug.traceback then msg=debug.traceback(msg,2)end end)return msg end)if __AXS_OK then pcall(function()if __AXS_BOOT_GUI then __AXS_BOOT_GUI:Destroy()end end)__AXS_Bootstrap("AXS VD  •  Loaded successfully",true)print("[AXS VD] Loaded successfully")else local msg=tostring(__AXS_ERR)__AXS_Bootstrap("AXS VD RUNTIME ERROR\n"..msg,false)warn("[AXS VD] RUNTIME ERROR: "..msg)end