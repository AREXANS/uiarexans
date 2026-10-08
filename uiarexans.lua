-- ==============================================================================
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
    "popup/dialog_frame.png",
    "popup/modal_background.png",
    "saturation_value_gradient.png",
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

-- Download all assets concurrently, but block execution until all are finished
-- so that UI elements don't slowly pop in one by one.
local function PrefetchAllAssets()
    if not (isfile and writefile) then return end

    local missingAssets = {}
    for _, path in ipairs(AssetList) do
        local normalizedPath = string.gsub(path, "/", "_")
        local localPath = FolderName .. "/" .. normalizedPath
        if not isfile(localPath) then
            table.insert(missingAssets, {path = path, localPath = localPath})
        end
    end

    if #missingAssets == 0 then return end

    local completed = 0
    local target = #missingAssets
    local bindable = Instance.new("BindableEvent")

    local PREFETCH_WORKERS = 15
    for worker = 1, PREFETCH_WORKERS do
        task.spawn(function()
            for index = worker, target, PREFETCH_WORKERS do
                local assetInfo = missingAssets[index]
                pcall(function()
                    local data = game:HttpGet(BaseURL .. assetInfo.path)
                    if data and #data > 0 and not isfile(assetInfo.localPath) then
                        writefile(assetInfo.localPath, data)
                    end
                end)
                completed = completed + 1
                if completed >= target then
                    bindable:Fire()
                end
            end
        end)
    end

    bindable.Event:Wait()
    bindable:Destroy()
end

PrefetchAllAssets()


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
    SearchPanel.Image = GetLocalAsset("window_search2.png")
    SearchPanel.BackgroundTransparency = 1
    SearchPanel.AnchorPoint = Vector2.new(0.5, 1)
    SearchPanel.Position = UDim2.new(0.5, 0, 1, -2)
    SearchPanel.Size = UDim2.new(0, 145, 0, 30)
    SearchPanel.ScaleType = Enum.ScaleType.Stretch
    SearchPanel.ZIndex = 510
    SearchPanel.Parent = OverlayLayer

    -- Search text transparan di atas asset agar bisa dipakai sebagai input.
    -- Saat kosong, asset tetap menampilkan label "Searching..." bawaannya.
    local SearchInput = Instance.new("TextBox")
    SearchInput.Name = "SearchInput"
    SearchInput.BackgroundTransparency = 1
    SearchInput.BorderSizePixel = 0
    SearchInput.Position = UDim2.new(0, 38, 0, 6)
    SearchInput.Size = UDim2.new(1, -68, 0, 18)
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.Text = ""
    SearchInput.PlaceholderText = ""
    SearchInput.TextColor3 = Color3.fromRGB(225, 245, 255)
    SearchInput.TextSize = 7
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
    NotificationPanel.Image = GetLocalAsset("notification/panel_notification.png")
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

    function WindowData:SetSearchText(text)
        SearchInput.Text = tostring(text or "")
    end

    function WindowData:SetSearchVisible(state)
        SearchPanel.Visible = state ~= false
    end

    -- 3. Toggle On/Off Logo Button
    local OpenCloseButton = Instance.new("ImageButton")
    OpenCloseButton.Name = "OpenCloseLogo"
    OpenCloseButton.Image = GetLocalAsset("logo.png")
    OpenCloseButton.BackgroundTransparency = 1
    OpenCloseButton.Position = UDim2.new(1, -80, 0, 20)
    OpenCloseButton.Size = UDim2.new(0, 60, 0, 60)
    OpenCloseButton.ZIndex = 100
    OpenCloseButton.Parent = ScreenGui


    -- Tidak ada tombol/ornamen tambahan di luar asset utama.
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
    windowbackground.Image = GetLocalAsset("window/window_background.png")
    windowbackground.BackgroundTransparency = 1
    windowbackground.Position = UDim2.new(0.5, 0, 0.5, 0)
    windowbackground.Size = UDim2.new(0, 512, 0, 241)
    windowbackground.AnchorPoint = Vector2.new(0.5, 0.5)
    windowbackground.ZIndex = 1
    windowbackground.Parent = WindowRoot

    OpenCloseButton.MouseButton1Click:Connect(function()
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
    TabContainer.Position = UDim2.new(0, 27, 0, 53)
    TabContainer.Size = UDim2.new(0, 134, 0, 243) 
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 0
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
    TabPanelBg.Image = GetLocalAsset("containers/panel2.png")
    TabPanelBg.BackgroundTransparency = 1
    TabPanelBg.Position = UDim2.new(0, 22, 0, 49)
    TabPanelBg.Size = UDim2.new(0, 144, 0, 241)
    TabPanelBg.ScaleType = Enum.ScaleType.Stretch
    TabPanelBg.ZIndex = 4
    TabPanelBg.Parent = WindowRoot

    -- ==============================================================================
    -- BINGKAI SELALU DI DEPAN (ZIndex 50 & 51)
    -- ==============================================================================
    local windowframe = Instance.new("ImageLabel")
    windowframe.Name = "window_frame"
    windowframe.Image = GetLocalAsset("window/window_frame.png")
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
    windowhumanoid.Image = GetLocalAsset("window/window_humanoid.png")
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
        windowhumanoid.Image = GetLocalAsset(
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
        TabButton.Image = GetLocalAsset("navigation/tab_disabled.png")
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
        Content.Size = UDim2.new(1, 0, 0, 0)
        Content.AutomaticSize = Enum.AutomaticSize.Y
        Content.Position = UDim2.new(0, 0, 0, 0)
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
        local function GetItemParent()
            if not currentRow or currentColumn >= 2 then
                currentRow = Instance.new("Frame")
                currentRow.Name = "ItemRow"
                currentRow.BackgroundTransparency = 1
                currentRow.Size = UDim2.new(1, 0, 0, ITEM_HEIGHT)
                currentRow.ZIndex = 20
                currentRow.Parent = Content

                local RowLayout = Instance.new("UIListLayout")
                RowLayout.Name = "ColumnsLayout"
                RowLayout.FillDirection = Enum.FillDirection.Horizontal
                RowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                RowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                RowLayout.Padding = UDim.new(0, ITEM_GAP)
                RowLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RowLayout.Parent = currentRow

                currentColumn = 0
            end

            local slot = Instance.new("Frame")
            slot.Name = "ItemSlot"
            slot.BackgroundTransparency = 1
            slot.Size = UDim2.new(0.5, -(ITEM_GAP / 2), 1, 0)
            slot.ZIndex = 20
            slot.LayoutOrder = currentColumn + 1
            slot.Parent = currentRow
            currentColumn += 1
            return slot
        end

        local function CreateCategoryInternal(title)
            -- Category memakai asset yang sudah tersedia; tidak ada Frame/Stroke
            -- buatan untuk garis dekoratif.
            currentRow = nil
            currentColumn = 2

            local Category = Instance.new("ImageLabel")
            Category.Name = "Category_" .. tostring(title):gsub("%s+", "_")
            Category.Image = GetLocalAsset("containers/section_header.png")
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

        -- ======================================================================
        -- CATEGORY TITLE
        -- ======================================================================
        function TabData:CreateCategory(CategoryName)
            return CreateCategoryInternal(CategoryName)
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
            LabelBg.Image = GetLocalAsset("textbox_medium_01.png")
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
            InputBg.Image = GetLocalAsset("textbox_right_01.png")
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
            Options = Options or {}
            Callback = Callback or function() end
            local selected = Default or Options[1]
            local open = false

            local Holder = Instance.new("Frame")
            Holder.Name = DropdownName .. "_Dropdown"
            Holder.BackgroundTransparency = 1
            Holder.Size = UDim2.new(1, 0, 0, 28)
            Holder.ZIndex = 30
            Holder.Parent = GetItemParent()

            local Button = Instance.new("ImageButton")
            Button.Name = "DropdownButton"
            Button.Image = GetLocalAsset("dropdown_before.png")
            Button.BackgroundTransparency = 1
            Button.AutoButtonColor = false
            Button.Size = UDim2.new(1, 0, 0, 28)
            Button.ScaleType = Enum.ScaleType.Stretch
            Button.ZIndex = 31
            Button.Parent = Holder

            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 11, 0, 0)
            Label.Size = UDim2.new(0.52, -11, 1, 0)
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
            ValueLabel.Size = UDim2.new(0.32, -2, 1, 0)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.Text = tostring(selected or "-")
            ValueLabel.TextColor3 = Color3.fromRGB(225, 242, 255)
            ValueLabel.TextSize = 9
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.ZIndex = 32
            ValueLabel.Parent = Button

            local listHeight = math.min(96, math.max(32, #Options * 18 + 6))
            local ListPanel = Instance.new("ImageLabel")
            ListPanel.Name = "ExpandedPanel"
            ListPanel.Image = GetLocalAsset("dropdown_after.png")
            ListPanel.BackgroundTransparency = 1
            ListPanel.Position = UDim2.new(0, 0, 0, 0)
            ListPanel.Size = UDim2.new(1, 0, 0, listHeight + 30)
            ListPanel.ScaleType = Enum.ScaleType.Stretch
            ListPanel.ZIndex = 44
            ListPanel.Visible = false
            ListPanel.Parent = Holder

            local List = Instance.new("ScrollingFrame")
            List.Name = "Options"
            List.BackgroundTransparency = 1
            List.BorderSizePixel = 0
            List.Position = UDim2.new(0, 8, 0, 30)
            List.Size = UDim2.new(1, -16, 1, -35)
            List.CanvasSize = UDim2.new(0, 0, 0, #Options * 18)
            List.ScrollBarThickness = 0
            List.ScrollingDirection = Enum.ScrollingDirection.Y
            List.ZIndex = 45
            List.ClipsDescendants = true
            List.Parent = ListPanel

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 0)
            ListLayout.Parent = List

            local function CloseList()
                open = false
                ListPanel.Visible = false
                Button.ZIndex = 31
                Label.ZIndex = 32
                ValueLabel.ZIndex = 32
            end

            for index, option in ipairs(Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = "Option_" .. index
                OptionButton.BackgroundTransparency = 1
                OptionButton.BorderSizePixel = 0
                OptionButton.AutoButtonColor = false
                OptionButton.Size = UDim2.new(1, -26, 0, 18)
                OptionButton.Position = UDim2.new(0, 10, 0, 0)
                OptionButton.Font = Enum.Font.GothamBold
                OptionButton.Text = tostring(option)
                OptionButton.TextColor3 = Color3.fromRGB(235, 246, 255)
                OptionButton.TextSize = 9
                OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                OptionButton.ZIndex = 46
                OptionButton.Parent = List

                OptionButton.MouseEnter:Connect(function()
                    OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                end)
                OptionButton.MouseLeave:Connect(function()
                    OptionButton.TextColor3 = Color3.fromRGB(235, 246, 255)
                end)
                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    ValueLabel.Text = tostring(option)
                    CloseList()
                    Callback(option)
                end)
            end

            Button.MouseButton1Click:Connect(function()
                open = not open
                if not open then
                    CloseList()
                    return
                end

                -- Dropdown tetap berada DI DALAM area Page.
                -- ZIndex sengaja di bawah frame (50) dan humanoid (51),
                -- sehingga asset bingkai/humanoid selalu menjadi lapisan terdepan.
                Button.ZIndex = 31
                Label.ZIndex = 32
                ValueLabel.ZIndex = 32

                task.defer(function()
                    if not Page.Visible or not Holder.Parent then return end

                    local pageTop = Page.AbsolutePosition.Y
                    local pageBottom = pageTop + Page.AbsoluteSize.Y
                    local holderTop = Holder.AbsolutePosition.Y
                    local holderBottom = holderTop + Holder.AbsoluteSize.Y
                    local desiredHeight = listHeight + 30
                    local spaceDown = math.max(0, pageBottom - holderBottom - 2)
                    local spaceUp = math.max(0, holderTop - pageTop - 2)

                    -- Utamakan arah yang punya ruang paling besar.
                    -- Panel tetap clipped oleh Page sehingga tidak pernah keluar frame.
                    if spaceDown >= 32 or spaceDown >= spaceUp then
                        local visibleHeight = math.min(desiredHeight, math.max(32, spaceDown))
                        ListPanel.Position = UDim2.new(0, 0, 0, 0)
                        ListPanel.Size = UDim2.new(1, 0, 0, visibleHeight)
                        List.Position = UDim2.new(0, 8, 0, 30)
                        List.Size = UDim2.new(1, -16, 1, -35)
                    else
                        local visibleHeight = math.min(desiredHeight, math.max(32, spaceUp))
                        ListPanel.Position = UDim2.new(0, 0, 0, -visibleHeight)
                        ListPanel.Size = UDim2.new(1, 0, 0, visibleHeight)
                        List.Position = UDim2.new(0, 8, 0, 5)
                        List.Size = UDim2.new(1, -16, 1, -10)
                    end

                    List.CanvasSize = UDim2.new(0, 0, 0, #Options * 18)
                    ListPanel.Visible = true
                end)
            end)

            return {
                SetValue = function(_, newValue)
                    for _, option in ipairs(Options) do
                        if option == newValue then
                            selected = option
                            ValueLabel.Text = tostring(option)
                            Callback(option)
                            return
                        end
                    end
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
            Button.Image = GetLocalAsset("button.png")
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
                Button.Image = GetLocalAsset("button_selected.png")
            end)

            Button.MouseLeave:Connect(function()
                Button.Image = GetLocalAsset("button.png")
            end)

            Button.MouseButton1Down:Connect(function()
                Button.Image = GetLocalAsset("button_selected.png")
            end)

            Button.MouseButton1Up:Connect(function()
                Button.Image = GetLocalAsset("button.png")
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

            local function UpdateState(isInit)
                if not isInit then State = not State end
                if State then
                    ToggleBg.Image = GetLocalAsset("electric_compact_left.png")
                    ToggleBg.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                    ToggleKnob.Image = GetLocalAsset("on.png")
                    ToggleKnob.Size = UDim2.new(0, 29, 0, 15)
                    ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                else
                    ToggleBg.Image = GetLocalAsset("dark_compact_left.png")
                    ToggleBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    ToggleKnob.Image = GetLocalAsset("off.png")
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
            Card.Image = GetLocalAsset(Options.Asset or "containers/panel.png")
            Card.BackgroundTransparency = 1
            Card.Size = UDim2.new(CardWidthMode, CardWidthMode == 1 and 0 or -1, 0, CardHeight)
            Card.ScaleType = Enum.ScaleType.Stretch
            Card.ZIndex = 35
            Card.Parent = slot

            if IconPath then
                local Icon = Instance.new("ImageLabel")
                Icon.Name = "Icon"
                Icon.Image = GetLocalAsset(IconPath)
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0, 8, 0, 8)
                Icon.Size = UDim2.new(0, 28, 0, 28)
                Icon.ScaleType = Enum.ScaleType.Fit
                Icon.ZIndex = 36
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
            AvatarFrame.Image = GetLocalAsset("player/avatar_frame.png")
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

            local Holder = Instance.new("Frame")
            Holder.Name = SliderName .. "_Slider"
            Holder.BackgroundTransparency = 1
            Holder.Size = UDim2.new(1, 0, 0, 28)
            Holder.ZIndex = 30
            Holder.Parent = GetItemParent()

            local Title = Instance.new("TextLabel")
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(0.52, 0, 1, 0)
            Title.Font = Enum.Font.GothamBold
            Title.Text = SliderName
            Title.TextColor3 = Color3.fromRGB(240, 250, 255)
            Title.TextSize = 9
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.ZIndex = 31
            Title.Parent = Holder

            local Track = Instance.new("Frame")
            Track.BackgroundTransparency = 1
            Track.Position = UDim2.new(0.52, 0, 0.5, -3)
            Track.Size = UDim2.new(0.36, 0, 0, 6)
            Track.ZIndex = 31
            Track.Parent = Holder

            local TrackImage = Instance.new("ImageLabel")
            TrackImage.BackgroundTransparency = 1
            TrackImage.Image = GetLocalAsset("controls/slider_track.png")
            TrackImage.Size = UDim2.fromScale(1, 1)
            TrackImage.ScaleType = Enum.ScaleType.Stretch
            TrackImage.ZIndex = 31
            TrackImage.Parent = Track

            local Fill = Instance.new("ImageLabel")
            Fill.BackgroundTransparency = 1
            Fill.Image = GetLocalAsset("controls/slider_fill.png")
            Fill.Size = UDim2.new((value - Min) / (Max - Min), 0, 1, 0)
            Fill.ScaleType = Enum.ScaleType.Stretch
            Fill.ZIndex = 32
            Fill.Parent = Track

            local Knob = Instance.new("ImageLabel")
            Knob.BackgroundTransparency = 1
            Knob.Image = GetLocalAsset("controls/slider_knob.png")
            Knob.AnchorPoint = Vector2.new(0.5, 0.5)
            Knob.Position = UDim2.new((value - Min) / (Max - Min), 0, 0.5, 0)
            Knob.Size = UDim2.new(0, 12, 0, 12)
            Knob.ZIndex = 33
            Knob.Parent = Track

            local Value = Instance.new("TextLabel")
            Value.BackgroundTransparency = 1
            Value.Position = UDim2.new(0.89, 0, 0, 0)
            Value.Size = UDim2.new(0.11, -6, 1, 0)
            Value.Font = Enum.Font.GothamBold
            Value.Text = tostring(math.floor(value))
            Value.TextColor3 = Color3.fromRGB(225, 242, 255)
            Value.TextSize = 8
            Value.TextXAlignment = Enum.TextXAlignment.Right
            Value.ZIndex = 31
            Value.Parent = Holder

            local function SetSlider(v, fire)
                value = math.clamp(tonumber(v) or value, Min, Max)
                local alpha = (value - Min) / (Max - Min)
                Fill.Size = UDim2.new(alpha, 0, 1, 0)
                Knob.Position = UDim2.new(alpha, 0, 0.5, 0)
                Value.Text = tostring(math.floor(value + 0.5))
                if fire then Callback(value) end
            end

            local draggingSlider = false
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    local alpha = math.clamp((input.Position.X - Track.AbsolutePosition.X) / math.max(1, Track.AbsoluteSize.X), 0, 1)
                    SetSlider(Min + (Max - Min) * alpha, true)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if not draggingSlider then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
                local alpha = math.clamp((input.Position.X - Track.AbsolutePosition.X) / math.max(1, Track.AbsoluteSize.X), 0, 1)
                SetSlider(Min + (Max - Min) * alpha, true)
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
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
-- AREXANS UI - DEMO / HOME + MAIN + SETTINGS
-- ==============================================================================

local Window = ArexansUI:CreateWindow("Arexans Hub")

-- HOME: dashboard card, profile, camera, server, character.
local HomeTab = Window:CreateTab("Home")

-- MAIN: fitur utama tetap tersedia dan tersusun di dalam satu panel penuh.
local MainTab = Window:CreateTab("Main")
MainTab:CreateCategory("FARMING")
MainTab:CreateToggle("Auto Farm Level", true, function(Value) print("Auto Farm Level:", Value) end)
MainTab:CreateToggle("Auto Quest", true, function(Value) print("Auto Quest:", Value) end)
MainTab:CreateToggle("God Mode", false, function(Value) print("God Mode:", Value) end)
MainTab:CreateToggle("Auto Haki", false, function(Value) print("Auto Haki:", Value) end)
MainTab:CreateToggle("Bring Mobs", false, function(Value) print("Bring Mobs:", Value) end)
MainTab:CreateToggle("Auto Collect", false, function(Value) print("Auto Collect:", Value) end)
MainTab:CreateToggle("Auto Chest", false, function(Value) print("Auto Chest:", Value) end)
MainTab:CreateToggle("Auto Boss", false, function(Value) print("Auto Boss:", Value) end)
MainTab:CreateToggle("Auto Stats", false, function(Value) print("Auto Stats:", Value) end)
MainTab:CreateToggle("Auto Teleport", false, function(Value) print("Auto Teleport:", Value) end)
MainTab:CreateCategory("TARGET & WEBHOOK")
MainTab:CreateTextbox("Player Name", "Masukkan nama...", "", function(Value) print("Player Name:", Value) end)
MainTab:CreateTextbox("Webhook", "URL webhook...", "", function(Value) print("Webhook:", Value) end)
MainTab:CreateDropdown("Mode", {"Normal", "Fast", "Safe", "Extreme"}, "Normal", function(Value) print("Mode:", Value) end)
MainTab:CreateDropdown("Farm Target", {"Nearest", "Lowest HP", "Boss", "Players"}, "Nearest", function(Value) print("Farm Target:", Value) end)
MainTab:CreateSlider("Farm Speed", 1, 100, 50, function(Value) print("Farm Speed:", Value) end)
MainTab:CreateCategory("ACTIONS")
MainTab:CreateButton("Refresh", function() print("Refresh clicked") end)
MainTab:CreateButton("Start Farm", function() print("Start Farm") end)
MainTab:CreateButton("Stop Farm", function() print("Stop Farm") end)

-- SETTINGS
local SettingsTab = Window:CreateTab("Settings")
SettingsTab:CreateCategory("PLAYER & ESP")
SettingsTab:CreateToggle("Anti AFK", true, function(Value) print("Anti AFK:", Value) end)
SettingsTab:CreateToggle("ESP Players", false, function(Value) print("ESP Status:", Value) end)
SettingsTab:CreateToggle("ESP NPC", false, function(Value) print("ESP NPC:", Value) end)
SettingsTab:CreateToggle("Show Damage", true, function(Value) print("Show Damage:", Value) end)
SettingsTab:CreateToggle("Hide Effects", false, function(Value) print("Hide Effects:", Value) end)
SettingsTab:CreateToggle("Low Graphics", false, function(Value) print("Low Graphics:", Value) end)
SettingsTab:CreateToggle("Auto Rejoin", false, function(Value) print("Auto Rejoin:", Value) end)
SettingsTab:CreateToggle("Server Hop", false, function(Value) print("Server Hop:", Value) end)
SettingsTab:CreateCategory("APPEARANCE")
SettingsTab:CreateDropdown("Theme", {"Blue", "Dark", "Neon"}, "Blue", function(Value) print("Theme:", Value) end)
SettingsTab:CreateDropdown("Quality", {"Low", "Medium", "High", "Ultra"}, "High", function(Value) print("Quality:", Value) end)
SettingsTab:CreateSlider("UI Scale", 65, 125, 112, function(Value) print("UI Scale:", Value) end)
SettingsTab:CreateCategory("ACTIONS")
SettingsTab:CreateButton("Reset Settings", function() print("Reset Settings") end)
SettingsTab:CreateButton("Close UI", function() print("Close UI") end)

return ArexansUI
