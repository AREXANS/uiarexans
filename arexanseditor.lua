-- AREXANS UI SIMULASI INTERAKTIF
-- Hanya UI demo: tidak ada fitur game, ESP, teleport, remote, exploit, atau bootstrap fitur.
-- Kontrol hanya mengubah tampilan lokal UI; callback fitur sengaja tidak dipasang.

local ArexansUI = (function()
-- ==============================================================================
-- AREXANS UI LIBRARY - ASSET ONLY / CLEAN SPLIT PANEL
-- ==============================================================================
local ArexansUI = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local BaseURL = "https://raw.githubusercontent.com/AREXANS/uiarexans/main/asset/"
local FolderName = "ArexansUI_Assets"

-- Executor file APIs are optional; never let a missing API abort startup.
local function SafeEnsureAssetFolder()
    if type(isfolder) ~= "function" or type(makefolder) ~= "function" then return false end
    local ok, exists = pcall(isfolder, FolderName)
    if ok and exists then return true end
    local made = pcall(makefolder, FolderName)
    return made
end
SafeEnsureAssetFolder()

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
    "scroll/scrollbar_thumb.png", "controls/checkbox_off.png", "controls/checkbox_on.png",
    "controls/left.png", "controls/right.png", "window/close_button.png",
    "window/minimize_button.png", "window/maximize_button.png",
    "window/expand_button.png", "window/collapse_button.png", "window/restore_button.png",
    "icons/lock_energy.png", "icons/unlock_energy.png"
}

local function PrefetchAllAssets()
    -- Android executors can crash natively during many HttpGet/writefile calls.
    -- Keep mobile execution offline-first: use any assets already cached locally.
    -- Desktop may fetch only critical assets, serialized and guarded.
    if type(isfile) ~= "function" or type(writefile) ~= "function" or type(makefolder) ~= "function" then return end
    local mobile = false
    pcall(function()
        mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    end)
    if mobile then
        warn("[AXS] Android stability mode: bulk asset downloads disabled; using cached assets.")
        return
    end

    local lockKey = "__AXS_ASSET_PREFETCH_RUNNING"
    local canUseGlobal, alreadyRunning = pcall(function()
        return type(getgenv) == "function" and getgenv()[lockKey] == true
    end)
    if canUseGlobal and alreadyRunning then return end
    pcall(function() if type(getgenv) == "function" then getgenv()[lockKey] = true end end)

    task.spawn(function()
        local okRun, errRun = pcall(function()
            SafeEnsureAssetFolder()
            for _, path in ipairs(CriticalAssets) do
                local localPath = AssetLocalPath(path)
                local exists = false
                pcall(function() exists = isfile(localPath) end)
                if not exists then
                    local okDownload, data = pcall(function()
                        return game:HttpGet(BaseURL .. path)
                    end)
                    if okDownload and type(data) == "string" and #data > 0 then
                        pcall(function()
                            if not isfile(localPath) then writefile(localPath, data) end
                        end)
                    end
                    task.wait(0.25)
                end
                pcall(function() RefreshAssetUsers(path) end)
                task.wait(0.1)
            end
        end)
        if not okRun then pcall(function() warn("[AXS] Asset fetch stopped safely: " .. tostring(errRun)) end) end
        pcall(function() if type(getgenv) == "function" then getgenv()[lockKey] = nil end end)
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
    -- Parent to the player's normal PlayerGui instead of executor-hidden/CoreGui.
    -- This is substantially more compatible with Roblox Android clients.
    local guiParent
    local okParent = pcall(function()
        guiParent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
    end)
    if not okParent or not guiParent then
        pcall(function() ScreenGui:Destroy() end)
        error("Arexans UI: PlayerGui tidak tersedia; coba jalankan ulang setelah karakter selesai dimuat.")
    end
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = guiParent

    -- Jangan menutupi UI eksternal seperti icon/menu Delta.
    -- Arexans tetap tampil normal, tetapi UI lain yang berada di DisplayOrder
    -- lebih tinggi tetap bisa menerima input ketika posisinya beririsan.
    ScreenGui.DisplayOrder = 1
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
    NotificationHolder.Position = UDim2.new(1, -8, 1, -8)
    NotificationHolder.Size = UDim2.new(0, 200, 0, 60)
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
    NotificationTitle.Position = UDim2.new(0, 48, 0, 6)
    NotificationTitle.Size = UDim2.new(1, -56, 0, 17)
    NotificationTitle.Font = Enum.Font.GothamBold
    NotificationTitle.Text = "Arexans Tools"
    NotificationTitle.TextColor3 = Color3.fromRGB(235, 248, 255)
    NotificationTitle.TextSize = 9
    NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotificationTitle.ZIndex = 521
    NotificationTitle.Parent = NotificationHolder

    local NotificationContent = Instance.new("TextLabel")
    NotificationContent.Name = "Content"
    NotificationContent.BackgroundTransparency = 1
    NotificationContent.Position = UDim2.new(0, 48, 0, 22)
    NotificationContent.Size = UDim2.new(1, -56, 0, 38)
    NotificationContent.Font = Enum.Font.Gotham
    NotificationContent.Text = ""
    NotificationContent.TextColor3 = Color3.fromRGB(220, 238, 255)
    NotificationContent.TextSize = 8
    NotificationContent.TextWrapped = true
    NotificationContent.TextXAlignment = Enum.TextXAlignment.Left
    NotificationContent.TextYAlignment = Enum.TextYAlignment.Top
    NotificationContent.ZIndex = 521
    NotificationContent.Parent = NotificationHolder

    NotificationHolder.Visible = false

    local function ShowNotification(title, content, duration)
        NotificationTitle.Text = tostring(title or "Arexans Tools")
        NotificationContent.Text = tostring(content or "")
        NotificationHolder.Visible = true

        task.delay(tonumber(duration) or 3, function()
            if NotificationHolder and NotificationHolder.Parent then
                NotificationHolder.Visible = false
            end
        end)
    end

    -- Notifikasi tampil langsung setelah layer dibuat; tidak menahan first render.
    task.defer(function()
        if NotificationHolder and NotificationHolder.Parent then
            ShowNotification("Arexans Tools", "Berhasil di load", 3)
        end
    end)

    WindowData._screenGui = ScreenGui
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
            local root = Instance.new("ImageLabel")
            root.Name = "Section_" .. tostring(SectionName or "Custom"):gsub("%s+", "_")
            root.BackgroundTransparency = 1
            SetLocalImage(root, "containers/panel.png") -- Restore native Arexans panel artwork behind Server List.
            root.ScaleType = Enum.ScaleType.Stretch
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

end)()

local Window = ArexansUI:CreateWindow("AREXANS UI SIMULASI")

-- Semua tab dan kontrol di bawah adalah contoh visual/interaktif saja.
-- Tab, toggle, dropdown, textbox, slider, dan tombol tetap bisa digunakan
-- untuk menguji tampilan UI, tetapi tidak menjalankan fungsi gameplay apa pun.

local server = Window:CreateTab("Server")
server:CreateCategory("SERVER BROWSER")
server:CreateLabel("Simulasi daftar server")
server:CreateDropdown("Pilih Server", {"Server #1", "Server #2", "Server #3"}, "Server #1")
server:CreateButton("Refresh Server")
server:CreateButton("Join Server")
server:CreateTextbox("Kode Server", "Masukkan kode...", "")
server:CreateToggle("Tampilkan Server Penuh", false)

local esp = Window:CreateTab("ESP")
esp:CreateCategory("ESP SIMULASI")
esp:CreateToggle("ESP Penyintas", false)
esp:CreateToggle("ESP Killer", false)
esp:CreateToggle("Tampilkan Nama", true)
esp:CreateToggle("Tampilkan Jarak", false)
esp:CreateToggle("Tampilkan HP", false)
esp:CreateDropdown("Warna ESP", {"Biru", "Merah", "Hijau", "Kuning"}, "Biru")
esp:CreateSlider("Ukuran Marker", 1, 10, 5)

local survivors = Window:CreateTab("Penyintas")
survivors:CreateCategory("PENYINTAS")
survivors:CreateToggle("Highlight Penyintas", false)
survivors:CreateToggle("Tampilkan Status", true)
survivors:CreateDropdown("Pilih Penyintas", {"Penyintas 1", "Penyintas 2", "Penyintas 3"}, "Penyintas 1")
survivors:CreateButton("Lihat Detail")
survivors:CreateButton("Reset Tampilan")

local killer = Window:CreateTab("Killer")
killer:CreateCategory("KILLER")
killer:CreateToggle("Highlight Killer", false)
killer:CreateToggle("Tampilkan Status Killer", true)
killer:CreateDropdown("Pilih Killer", {"Killer 1", "Killer 2", "Killer 3"}, "Killer 1")
killer:CreateSlider("Ukuran Highlight", 1, 10, 5)

local player = Window:CreateTab("Player")
player:CreateCategory("PLAYER SIMULASI")
player:CreateToggle("Mode Compact", false)
player:CreateToggle("Animasi UI", true)
player:CreateSlider("Skala UI", 65, 125, 100)
player:CreateDropdown("Tema", {"Electric Blue", "Dark Blue", "Cyan"}, "Electric Blue")

local settings = Window:CreateTab("Settings")
settings:CreateCategory("PENGATURAN UI")
settings:CreateToggle("Efek Glow", true)
settings:CreateToggle("Partikel Dekorasi", true)
settings:CreateDropdown("Bahasa", {"Indonesia", "English"}, "Indonesia")
settings:CreateButton("Reset Pengaturan Demo")
settings:CreateLabel("Mode: UI simulasi saja")


-- =============================================================================
-- AREXANS LIVE UI EDITOR (visual-only sandbox)
-- Bisa tambah/duplikat/hapus elemen UI, ubah properti, dan melihat hasil langsung.
-- Tidak mengubah karakter/gameplay dan tidak menjalankan callback fitur.
-- =============================================================================
do
    local editorGui = Window._screenGui
    local editorRoot = editorGui and editorGui:FindFirstChild("WindowRoot")
    if editorGui and editorRoot then
        -- Global ZIndex memungkinkan kontrol FRONT/BACK bekerja konsisten lintas parent.
        pcall(function() editorGui.ZIndexBehavior = Enum.ZIndexBehavior.Global end)
        local selectedObject = nil
        local selectionStroke = nil
        local editorVisible = true
        local function make(className, props, parent)
            local obj = Instance.new(className)
            for k, v in pairs(props or {}) do
                pcall(function() obj[k] = v end)
            end
            obj.Parent = parent
            return obj
        end
        local panel = make("Frame", {
            Name = "ArexansLiveEditor", AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -10, 0, 10), Size = UDim2.fromOffset(265, 462),
            BackgroundColor3 = Color3.fromRGB(13, 21, 34), BackgroundTransparency = 0.04,
            BorderSizePixel = 0, ZIndex = 700, Active = true
        }, editorGui)
        make("UICorner", {CornerRadius = UDim.new(0, 9)}, panel)
        make("UIStroke", {Color = Color3.fromRGB(50, 164, 255), Thickness = 1}, panel)
        local title = make("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 5),
            Size = UDim2.new(1, -48, 0, 25), Font = Enum.Font.GothamBold,
            Text = "AREXANS • LIVE UI EDITOR", TextSize = 12,
            TextColor3 = Color3.fromRGB(220, 242, 255), TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 701
        }, panel)
        local function actionButton(text, x, y, w, parent)
            local b = make("TextButton", {
                Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, 25),
                BackgroundColor3 = Color3.fromRGB(24, 65, 96), BorderSizePixel = 0,
                Font = Enum.Font.GothamBold, Text = text, TextSize = 10,
                TextColor3 = Color3.fromRGB(235, 248, 255), AutoButtonColor = true,
                ZIndex = 702
            }, parent or panel)
            make("UICorner", {CornerRadius = UDim.new(0, 5)}, b)
            return b
        end
        local hideBtn = actionButton("Preview", 207, 5, 48)
        local reopenBtn = make("TextButton", {
            Name = "ArexansEditorReopen", AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -10, 0, 10), Size = UDim2.fromOffset(110, 30),
            BackgroundColor3 = Color3.fromRGB(20, 75, 110), BorderSizePixel = 0,
            Font = Enum.Font.GothamBold, Text = "Buka Editor", TextSize = 11,
            TextColor3 = Color3.fromRGB(240, 250, 255), Visible = false, ZIndex = 710
        }, editorGui)
        make("UICorner", {CornerRadius = UDim.new(0, 6)}, reopenBtn)
        local status = make("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 31),
            Size = UDim2.new(1, -20, 0, 18), Font = Enum.Font.Gotham,
            Text = "Pilih elemen • resize dengan tarik sudut biru",
            TextSize = 9, TextColor3 = Color3.fromRGB(145, 190, 220),
            TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 701
        }, panel)
        local hierarchy = make("ScrollingFrame", {
            Name = "Hierarchy", Position = UDim2.fromOffset(10, 53),
            Size = UDim2.new(1, -20, 0, 105), BackgroundColor3 = Color3.fromRGB(8, 14, 24),
            BorderSizePixel = 0, ScrollBarThickness = 4, CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 701
        }, panel)
        make("UICorner", {CornerRadius = UDim.new(0, 5)}, hierarchy)
        local hierarchyLayout = make("UIListLayout", {
            Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder
        }, hierarchy)
        local propsFrame = make("ScrollingFrame", {
            Name = "Properties", Position = UDim2.fromOffset(10, 165),
            Size = UDim2.new(1, -20, 0, 164), BackgroundTransparency = 1,
            BorderSizePixel = 0, ScrollBarThickness = 3, CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 701
        }, panel)
        make("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, propsFrame)
        local controls = {}
        local controlValues = {}
        local validTarget, setStatus
        local function field(labelText, initial)
            local row = make("Frame", {Size = UDim2.new(1, -4, 0, 27), BackgroundTransparency = 1, ZIndex = 702}, propsFrame)
            make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(2, 0),
                Size = UDim2.new(0.30, -2, 1, 0), Font = Enum.Font.Gotham, Text = labelText,
                TextSize = 9, TextColor3 = Color3.fromRGB(180, 210, 235),
                TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 703}, row)
            local valueClass = (labelText == "Image") and "TextBox" or "TextLabel"
            local value = make(valueClass, {Name = "Value", Position = UDim2.new(0.30, 0, 0, 1),
                Size = UDim2.new(0.42, -2, 1, -2), BackgroundColor3 = Color3.fromRGB(23, 36, 53),
                BorderSizePixel = 0, Font = Enum.Font.Code, Text = tostring(initial or ""),
                TextSize = 9, TextColor3 = Color3.fromRGB(240, 248, 255),
                TextTruncate = Enum.TextTruncate.AtEnd, ClearTextOnFocus = false,
                PlaceholderText = (labelText == "Image") and "Asset ID / rbxassetid://..." or "",
                ZIndex = 703}, row)
            make("UICorner", {CornerRadius = UDim.new(0, 4)}, value)
            if labelText == "Image" then
                local function applyImageValue()
                    local target = selectedObject
                    if not target or not validTarget(target) then
                        setStatus("Pilih ImageLabel/ImageButton, atau buat gambar dengan + Image")
                        return
                    end
                    if not (target:IsA("ImageLabel") or target:IsA("ImageButton")) then
                        setStatus("Elemen terpilih bukan elemen gambar")
                        return
                    end
                    local raw = tostring(value.Text or ""):gsub("%s+", "")
                    if raw ~= "" and not raw:find("rbxassetid://", 1, true) then
                        raw = "rbxassetid://" .. raw
                    end
                    local ok, err = pcall(function() target.Image = raw end)
                    if ok then
                        controlValues.Image = raw
                        value.Text = raw
                        setStatus(raw == "" and "Gambar dikosongkan" or "Asset gambar diterapkan")
                    else
                        setStatus("Asset gambar gagal diterapkan: " .. tostring(err))
                    end
                end
                value.FocusLost:Connect(applyImageValue)
                value:GetPropertyChangedSignal("Text"):Connect(function()
                    if selectedObject and (selectedObject:IsA("ImageLabel") or selectedObject:IsA("ImageButton")) then
                        controlValues.Image = value.Text
                    end
                end)
            end
            local minus = make("TextButton", {Position = UDim2.new(0.73, 0, 0, 1),
                Size = UDim2.new(0.12, -1, 1, -2), BackgroundColor3 = Color3.fromRGB(24, 65, 96),
                BorderSizePixel = 0, Font = Enum.Font.GothamBold, Text = "−", TextSize = 12,
                TextColor3 = Color3.new(1,1,1), ZIndex = 703}, row)
            local plus = make("TextButton", {Position = UDim2.new(0.86, 0, 0, 1),
                Size = UDim2.new(0.12, -1, 1, -2), BackgroundColor3 = Color3.fromRGB(24, 95, 140),
                BorderSizePixel = 0, Font = Enum.Font.GothamBold, Text = "+", TextSize = 12,
                TextColor3 = Color3.new(1,1,1), ZIndex = 703}, row)
            controls[labelText] = value
            controlValues[labelText] = tostring(initial or "")
            local function change(direction)
                local n = tonumber(controlValues[labelText]) or 0
                n += direction * ((labelText == "Transparency") and 0.05 or 5)
                if labelText == "Transparency" then n = math.floor(math.clamp(n, 0, 1) * 100 + 0.5) / 100 end
                if labelText == "Width" or labelText == "Height" then n = math.max(1, n) end
                if labelText == "ZIndex" then n = math.clamp(math.floor(n), 1, 1000) end
                if labelText ~= "Transparency" then n = math.floor(n) end
                controlValues[labelText] = tostring(n); value.Text = controlValues[labelText]
                if selectedObject and selectedObject.Parent and (labelText == "X" or labelText == "Y" or labelText == "Width" or labelText == "Height" or labelText == "Transparency" or labelText == "ZIndex") then
                    pcall(function()
                        selectedObject.Position = UDim2.fromOffset(tonumber(controlValues.X) or selectedObject.Position.X.Offset, tonumber(controlValues.Y) or selectedObject.Position.Y.Offset)
                        selectedObject.Size = UDim2.fromOffset(math.max(1, tonumber(controlValues.Width) or selectedObject.Size.X.Offset), math.max(1, tonumber(controlValues.Height) or selectedObject.Size.Y.Offset))
                        selectedObject.BackgroundTransparency = math.clamp(tonumber(controlValues.Transparency) or selectedObject.BackgroundTransparency, 0, 1)
                        selectedObject.ZIndex = math.clamp(math.floor(tonumber(controlValues.ZIndex) or selectedObject.ZIndex), 1, 1000)
                    end)
                end
            end
            minus.MouseButton1Click:Connect(function() change(-1) end)
            plus.MouseButton1Click:Connect(function() change(1) end)
            return value
        end
        field("Name", "-"); field("Text", "-"); field("Image", "-")
        field("X", "0"); field("Y", "0")
        field("Width", "100"); field("Height", "28")
        field("Transparency", "0"); field("ZIndex", "10")
        local applyBtn = actionButton("Terapkan", 10, 337, 76)
        local duplicateBtn = actionButton("Duplikat", 91, 337, 76)
        local deleteBtn = actionButton("Hapus", 172, 337, 83)
        local addLabelBtn = actionButton("+ Label", 10, 367, 76)
        local addButtonBtn = actionButton("+ Button", 91, 367, 76)
        local addImageBtn = actionButton("+ Image", 172, 367, 83)
        local resetBtn = actionButton("Refresh daftar", 10, 397, 118)
        local previewBtn = actionButton("Selesai / Editor", 133, 397, 122)
        local moveModeBtn = actionButton("Geser: OFF", 10, 427, 76)
        local frontBtn = actionButton("Ke depan", 91, 427, 76)
        local backBtn = actionButton("Ke belakang", 172, 427, 83)
        local protected = {
            WindowRoot = true, window_frame = true, window_background = true,
            TabContainer = true, PageContainer = true, OverlayLayer = true,
            ArexansLiveEditor = true, ArexansEditorReopen = true
        }
        validTarget = function(obj)
            return obj and obj:IsA("GuiObject") and obj:IsDescendantOf(editorRoot)
                and not protected[obj.Name] and not obj.Name:match("^__Editor") and not obj:IsDescendantOf(panel)
        end
        setStatus = function(text)
            status.Text = tostring(text)
        end
        -- Mode geser memungkinkan elemen dipindahkan langsung dengan mouse atau sentuhan.
        local UserInputService = game:GetService("UserInputService")
        local moveMode = false
        local draggingObject, dragInput, dragStart, dragOrigin
        local dragConnections = {}
        local function updatePositionFromDrag(input)
            if not draggingObject or not validTarget(draggingObject) or not dragStart or not dragOrigin then return end
            local delta = input.Position - dragStart
            draggingObject.Position = UDim2.new(dragOrigin.X.Scale, dragOrigin.X.Offset + delta.X, dragOrigin.Y.Scale, dragOrigin.Y.Offset + delta.Y)
            if selectedObject == draggingObject then
                controlValues.X = tostring(draggingObject.Position.X.Offset); controls.X.Text = controlValues.X
                controlValues.Y = tostring(draggingObject.Position.Y.Offset); controls.Y.Text = controlValues.Y
            end
        end
        UserInputService.InputChanged:Connect(function(input)
            if draggingObject and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updatePositionFromDrag(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if draggingObject and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                draggingObject = nil; dragInput = nil; dragStart = nil; dragOrigin = nil
                setStatus("Posisi diperbarui")
            end
        end)
        -- Handle sudut untuk mengubah ukuran langsung dengan drag/touch.
        local resizeHandle, resizingObject, resizeStart, resizeOriginalSize
        local function attachResizeHandle(obj)
            if resizeHandle then resizeHandle:Destroy(); resizeHandle = nil end
            if not validTarget(obj) then return end
            resizeHandle = make("TextButton", {
                Name = "__EditorResizeHandle", AnchorPoint = Vector2.new(1, 1),
                Position = UDim2.new(1, 0, 1, 0), Size = UDim2.fromOffset(18, 18),
                BackgroundColor3 = Color3.fromRGB(35, 165, 255), BorderSizePixel = 0,
                Text = "↘", TextColor3 = Color3.new(1,1,1), TextSize = 12,
                Font = Enum.Font.GothamBold, AutoButtonColor = false,
                ZIndex = math.clamp(obj.ZIndex + 50, 1, 1000), Active = true
            }, obj)
            make("UICorner", {CornerRadius = UDim.new(0, 5)}, resizeHandle)
            resizeHandle.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                resizingObject = obj
                resizeStart = input.Position
                resizeOriginalSize = obj.Size
                setStatus("Tarik sudut biru untuk mengubah ukuran")
            end)
        end
        UserInputService.InputChanged:Connect(function(input)
            if resizingObject and resizeStart and resizeOriginalSize and
                (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - resizeStart
                local w = math.max(18, resizeOriginalSize.X.Offset + delta.X)
                local h = math.max(18, resizeOriginalSize.Y.Offset + delta.Y)
                resizingObject.Size = UDim2.new(resizeOriginalSize.X.Scale, w, resizeOriginalSize.Y.Scale, h)
                if selectedObject == resizingObject then
                    controlValues.Width = tostring(math.floor(w)); controls.Width.Text = controlValues.Width
                    controlValues.Height = tostring(math.floor(h)); controls.Height.Text = controlValues.Height
                end
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if resizingObject and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                resizingObject = nil; resizeStart = nil; resizeOriginalSize = nil
                setStatus("Ukuran diperbarui langsung")
            end
        end)
        local function hookDirectDrag(obj)
            if dragConnections[obj] or not obj:IsA("GuiObject") then return end
            dragConnections[obj] = obj.InputBegan:Connect(function(input)
                if not moveMode or not validTarget(obj) then return end
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                selectedObject = obj
                if selectionStroke then selectionStroke:Destroy() end
                selectionStroke = make("UIStroke", {Name = "__EditorSelection", Color = Color3.fromRGB(65,190,255), Thickness = 1}, obj)
                draggingObject = obj
                dragInput = input
                dragStart = input.Position
                dragOrigin = obj.Position
                setStatus("Geser elemen langsung; matikan mode Geser untuk klik normal")
            end)
        end
        for _, obj in ipairs(editorRoot:GetDescendants()) do hookDirectDrag(obj) end
        editorRoot.DescendantAdded:Connect(function(obj)
            if obj:IsA("GuiObject") then task.defer(function() hookDirectDrag(obj) end) end
        end)
        local function refreshHierarchy()
            for _, child in ipairs(hierarchy:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            local list = {}
            for _, obj in ipairs(editorRoot:GetDescendants()) do
                if validTarget(obj) then table.insert(list, obj) end
            end
            table.sort(list, function(a,b)
                local da, db = 0, 0
                local p = a.Parent
                while p and p ~= editorRoot do da += 1; p = p.Parent end
                p = b.Parent
                while p and p ~= editorRoot do db += 1; p = p.Parent end
                if da == db then return a:GetFullName() < b:GetFullName() end
                return da < db
            end)
            for i, obj in ipairs(list) do
                hookDirectDrag(obj)
                local depth = 0; local p = obj.Parent
                while p and p ~= editorRoot do depth += 1; p = p.Parent end
                local b = make("TextButton", {
                    Name = "Node_" .. i, LayoutOrder = i,
                    Size = UDim2.new(1, -6, 0, 21), BackgroundColor3 = Color3.fromRGB(20, 35, 52),
                    BorderSizePixel = 0, Font = Enum.Font.Gotham,
                    Text = string.rep("  ", math.min(depth, 5)) .. obj.Name .. "  [" .. obj.ClassName .. "]",
                    TextSize = 9, TextColor3 = Color3.fromRGB(210, 233, 250),
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 702
                }, hierarchy)
                b.MouseButton1Click:Connect(function()
                    if not validTarget(obj) then return end
                    selectedObject = obj
                    if resizeHandle then resizeHandle:Destroy(); resizeHandle = nil end
                    if selectionStroke then selectionStroke:Destroy(); selectionStroke = nil end
                    selectionStroke = make("UIStroke", {
                        Name = "__EditorSelection", Color = Color3.fromRGB(65, 190, 255),
                        Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }, obj)
                    local pos, size = obj.Position, obj.Size
                    controlValues.Name = tostring(obj.Name); controls.Name.Text = controlValues.Name
                    controlValues.Text = tostring((obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) and obj.Text or "-")
                    controls.Text.Text = controlValues.Text
                    controlValues.Image = tostring((obj:IsA("ImageLabel") or obj:IsA("ImageButton")) and obj.Image or "-")
                    controls.Image.Text = controlValues.Image
                    controlValues.X = tostring(pos.X.Offset); controls.X.Text = controlValues.X
                    controlValues.Y = tostring(pos.Y.Offset); controls.Y.Text = controlValues.Y
                    controlValues.Width = tostring(size.X.Offset); controls.Width.Text = controlValues.Width
                    controlValues.Height = tostring(size.Y.Offset); controls.Height.Text = controlValues.Height
                    controlValues.Transparency = tostring(obj.BackgroundTransparency); controls.Transparency.Text = controlValues.Transparency
                    controlValues.ZIndex = tostring(obj.ZIndex); controls.ZIndex.Text = controlValues.ZIndex
                    attachResizeHandle(obj)
                    setStatus("Dipilih: " .. obj.Name .. " • tarik sudut biru untuk resize")
                end)
            end
            hierarchy.CanvasPosition = Vector2.new(0, 0)
        end
        local function applyProperties(skipRefresh)
            local obj = selectedObject
            if not validTarget(obj) then setStatus("Pilih elemen terlebih dahulu"); return end
            local ok, err = pcall(function()
                local newName = tostring(controlValues.Name or obj.Name)
                if newName ~= "" and not newName:match("^__Editor") then obj.Name = newName end
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    if controlValues.Text and controlValues.Text ~= "-" then obj.Text = tostring(controlValues.Text) end
                end
                if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                    local raw = tostring(controlValues.Image or "")
                    raw = raw:gsub("%s+", "")
                    if raw ~= "" and not raw:find("rbxassetid://", 1, true) then raw = "rbxassetid://" .. raw end
                    obj.Image = raw
                end
                obj.Position = UDim2.fromOffset(tonumber(controlValues.X) or obj.Position.X.Offset, tonumber(controlValues.Y) or obj.Position.Y.Offset)
                obj.Size = UDim2.fromOffset(math.max(1, tonumber(controlValues.Width) or obj.Size.X.Offset), math.max(1, tonumber(controlValues.Height) or obj.Size.Y.Offset))
                obj.BackgroundTransparency = math.clamp(tonumber(controlValues.Transparency) or obj.BackgroundTransparency, 0, 1)
                obj.ZIndex = math.clamp(math.floor(tonumber(controlValues.ZIndex) or obj.ZIndex), 1, 1000)
            end)
            if not ok then setStatus("Gagal menerapkan perubahan: " .. tostring(err)); return end
            setStatus("Perubahan diterapkan secara realtime")
            if not skipRefresh then refreshHierarchy() end
        end
        applyBtn.MouseButton1Click:Connect(function() applyProperties(false) end)
        duplicateBtn.MouseButton1Click:Connect(function()
            if not validTarget(selectedObject) then setStatus("Pilih elemen dulu"); return end
            local ok, clone = pcall(function() return selectedObject:Clone() end)
            if ok and clone then
                clone.Name = selectedObject.Name .. "_Copy"
                clone.Parent = selectedObject.Parent
                clone.Position = selectedObject.Position + UDim2.fromOffset(8, 8)
                selectedObject = clone
                setStatus("Elemen diduplikasi")
                refreshHierarchy()
            else setStatus("Elemen ini tidak dapat diduplikasi") end
        end)
        deleteBtn.MouseButton1Click:Connect(function()
            local old = selectedObject
            if not old or not old.Parent or not validTarget(old) then
                setStatus("Pilih elemen yang akan dihapus dari daftar terlebih dahulu")
                return
            end
            -- Lepas handle, stroke, dan koneksi sebelum menghapus target terpilih.
            if resizeHandle then pcall(function() resizeHandle:Destroy() end); resizeHandle = nil end
            resizingObject, resizeStart, resizeOriginalSize = nil, nil, nil
            if selectionStroke then pcall(function() selectionStroke:Destroy() end); selectionStroke = nil end
            if dragConnections[old] then pcall(function() dragConnections[old]:Disconnect() end); dragConnections[old] = nil end
            if draggingObject == old then draggingObject, dragInput, dragStart, dragOrigin = nil, nil, nil, nil end
            selectedObject = nil
            controlValues.Name = "-"; controls.Name.Text = "-"
            controlValues.Text = "-"; controls.Text.Text = "-"
            controlValues.Image = ""; controls.Image.Text = ""
            local ok, err = pcall(function()
                -- Destroy tetap valid untuk ImageLabel, ImageButton, TextLabel, Frame, dan elemen UI lain.
                old:Destroy()
            end)
            if ok then
                setStatus("Elemen berhasil dihapus")
            else
                setStatus("Gagal menghapus elemen: " .. tostring(err))
            end
            refreshHierarchy()
            if not selectedObject then setStatus("Asset dihapus • pilih elemen lalu gunakan + Image / FRONT / BACK") end
        end)
        local function addElement(kind)
            -- Tambahkan elemen sebagai sibling dari elemen terpilih bila memungkinkan,
            -- supaya layering dan posisi relatif lebih mudah dipahami.
            -- Tempatkan elemen baru sebagai sibling dari pilihan agar posisi dan
            -- urutan layer bisa dibandingkan langsung dengan asset yang dipilih.
            -- Jika belum ada pilihan, gunakan PageContainer sebagai area kerja.
            local parent = (validTarget(selectedObject) and selectedObject.Parent)
                or (editorRoot:FindFirstChild("PageContainer") and editorRoot.PageContainer:IsA("GuiObject") and editorRoot.PageContainer)
                or editorRoot
            local obj
            if kind == "Label" then
                obj = make("TextLabel", {
                    Name = "NewLabel", BackgroundTransparency = 1, Size = UDim2.fromOffset(130, 24),
                    Position = UDim2.fromOffset(175, 80), Font = Enum.Font.Gotham,
                    Text = "Label baru", TextSize = 12, TextColor3 = Color3.new(1,1,1),
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 80
                }, parent)
            elseif kind == "Button" then
                obj = make("TextButton", {
                    Name = "NewButton", BackgroundColor3 = Color3.fromRGB(25, 100, 160),
                    Size = UDim2.fromOffset(110, 28), Position = UDim2.fromOffset(175, 110),
                    Font = Enum.Font.GothamBold, Text = "Tombol baru", TextSize = 11,
                    TextColor3 = Color3.new(1,1,1), ZIndex = 80
                }, parent)
                make("UICorner", {CornerRadius = UDim.new(0, 5)}, obj)
            else
                -- Buat ImageLabel baru yang langsung terlihat dan dapat dipilih/dihapus.
                obj = make("ImageLabel", {
                    Name = "NewImage", BackgroundTransparency = 0.15,
                    BackgroundColor3 = Color3.fromRGB(24, 75, 110),
                    Size = UDim2.fromOffset(96, 96), Position = UDim2.fromOffset(175, 145),
                    Image = "", ScaleType = Enum.ScaleType.Fit,
                    ZIndex = 100, Visible = true, Active = true,
                    Selectable = true, ImageTransparency = 0, BorderSizePixel = 1
                }, parent)
            end
            selectedObject = obj
            controlValues.Name = tostring(obj.Name); controls.Name.Text = controlValues.Name
            controlValues.Text = tostring((obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text or "-"); controls.Text.Text = controlValues.Text
            controlValues.Image = tostring((obj:IsA("ImageLabel") or obj:IsA("ImageButton")) and obj.Image or "-"); controls.Image.Text = controlValues.Image
            controlValues.X = tostring(obj.Position.X.Offset); controls.X.Text = controlValues.X
            controlValues.Y = tostring(obj.Position.Y.Offset); controls.Y.Text = controlValues.Y
            controlValues.Width = tostring(obj.Size.X.Offset); controls.Width.Text = controlValues.Width
            controlValues.Height = tostring(obj.Size.Y.Offset); controls.Height.Text = controlValues.Height
            controlValues.Transparency = tostring(obj.BackgroundTransparency); controls.Transparency.Text = controlValues.Transparency; controlValues.ZIndex = tostring(obj.ZIndex); controls.ZIndex.Text = controlValues.ZIndex
            if selectionStroke then selectionStroke:Destroy(); selectionStroke = nil end
            selectionStroke = make("UIStroke", {Name = "__EditorSelection", Color = Color3.fromRGB(65,190,255), Thickness = 1}, obj)
            attachResizeHandle(obj)
            hookDirectDrag(obj)
            setStatus(kind == "Image" and "Image ditambahkan • tempel Asset ID di kolom Image" or kind .. " ditambahkan")
            refreshHierarchy()
        end
        addLabelBtn.MouseButton1Click:Connect(function() addElement("Label") end)
        addButtonBtn.MouseButton1Click:Connect(function() addElement("Button") end)
        addImageBtn.MouseButton1Click:Connect(function() addElement("Image") end)
        resetBtn.MouseButton1Click:Connect(refreshHierarchy)
        moveModeBtn.MouseButton1Click:Connect(function()
            moveMode = not moveMode
            moveModeBtn.Text = moveMode and "Geser: ON" or "Geser: OFF"
            moveModeBtn.BackgroundColor3 = moveMode and Color3.fromRGB(0, 125, 205) or Color3.fromRGB(24, 65, 96)
            setStatus(moveMode and "Mode geser aktif: seret elemen langsung" or "Mode geser mati: klik UI seperti biasa")
        end)
        local function setLayer(direction)
            local target = selectedObject
            if not validTarget(target) then
                setStatus("Pilih gambar/elemen dari daftar terlebih dahulu")
                return
            end
            -- ZIndexBehavior.Global aktif pada ScreenGui, jadi nilai ZIndex mengatur
            -- urutan gambar meskipun elemen berada di parent yang berbeda.
            local candidates = {}
            local maxZ, minZ = 1, 1000
            -- Global ZIndex: bandingkan semua elemen di WindowRoot, bukan hanya
            -- sibling. Ini memungkinkan FRONT/BACK terhadap asset di parent lain.
            for _, obj in ipairs(editorRoot:GetDescendants()) do
                if obj:IsA("GuiObject") and validTarget(obj) then
                    table.insert(candidates, obj)
                    if obj ~= target then
                        maxZ = math.max(maxZ, obj.ZIndex)
                        minZ = math.min(minZ, obj.ZIndex)
                    end
                end
            end
            if #candidates <= 1 then
                setStatus("Asset ini tidak punya sibling untuk dibandingkan; pilih asset lain pada daftar atau tambahkan gambar di parent yang sama")
                return
            end
            if direction > 0 then
                -- Normalize first if near the upper limit, then put target above all other UI objects.
                if maxZ >= 999 then
                    for _, obj in ipairs(candidates) do
                        if obj ~= target then obj.ZIndex = math.max(1, obj.ZIndex - 1) end
                    end
                    maxZ = 998
                end
                target.ZIndex = maxZ + 1
                setStatus("FRONT diterapkan ke seluruh UI • ZIndex " .. target.ZIndex)
            else
                if minZ <= 2 then
                    for _, obj in ipairs(candidates) do
                        if obj ~= target then obj.ZIndex = math.min(1000, obj.ZIndex + 1) end
                    end
                    minZ = 2
                end
                target.ZIndex = math.max(1, minZ - 1)
                setStatus("BACK diterapkan ke seluruh UI • ZIndex " .. target.ZIndex)
            end
            controlValues.ZIndex = tostring(target.ZIndex)
            controls.ZIndex.Text = controlValues.ZIndex
            if resizeHandle and resizeHandle.Parent == target then
                resizeHandle.ZIndex = math.clamp(target.ZIndex + 50, 1, 1000)
            end
        end
        frontBtn.MouseButton1Click:Connect(function() setLayer(1) end)
        backBtn.MouseButton1Click:Connect(function() setLayer(-1) end)
        local function toggleEditor()
            editorVisible = not editorVisible
            panel.Visible = editorVisible
            reopenBtn.Visible = not editorVisible
            if not editorVisible then
                if selectionStroke then selectionStroke:Destroy(); selectionStroke = nil end
                if resizeHandle then resizeHandle:Destroy(); resizeHandle = nil end
                selectedObject = nil
            end
        end
        hideBtn.MouseButton1Click:Connect(toggleEditor)
        previewBtn.MouseButton1Click:Connect(toggleEditor)
        reopenBtn.MouseButton1Click:Connect(toggleEditor)
        refreshHierarchy()
    end
end

return Window
