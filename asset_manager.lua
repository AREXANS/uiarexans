--[[
    Realtime UI Builder & Asset Arranger
    Downloads assets from AREXANS/uiarexans GitHub and allows visual drag-and-drop arrangement.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Fetch assets dynamically
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local getAsset = getcustomasset or getsynasset
local getHiddenGui = gethui or get_hidden_gui

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
    local localPath = FolderName .. "/" .. path:gsub("/", "_")
    if not isfile(localPath) then
        local url = BaseURL .. path
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        if success and response and response ~= "404: Not Found" then
            writefile(localPath, response)
        else
            warn("Failed to download asset: " .. path)
            return nil
        end
    end
    if getAsset then
        return getAsset(localPath)
    else
        return "rbxasset://" .. localPath
    end
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

local parentGui = getGuiParent()
if parentGui:FindFirstChild("ArexansUIBuilder") then
    parentGui.ArexansUIBuilder:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArexansUIBuilder"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = parentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Parent = ScreenGui

local SidebarContainer = Instance.new("Frame")
SidebarContainer.Name = "SidebarContainer"
SidebarContainer.Size = UDim2.new(0, 250, 1, 0)
SidebarContainer.Position = UDim2.new(0, 0, 0, 0)
SidebarContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SidebarContainer.BorderSizePixel = 0
SidebarContainer.Parent = ScreenGui

local ControlsFrame = Instance.new("Frame")
ControlsFrame.Name = "ControlsFrame"
ControlsFrame.Size = UDim2.new(1, 0, 0, 170)
ControlsFrame.Position = UDim2.new(0, 0, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = SidebarContainer

local ControlsLayout = Instance.new("UIListLayout")
ControlsLayout.Parent = ControlsFrame
ControlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ControlsLayout.Padding = UDim.new(0, 5)

local ControlsPadding = Instance.new("UIPadding")
ControlsPadding.Parent = ControlsFrame
ControlsPadding.PaddingTop = UDim.new(0, 10)
ControlsPadding.PaddingBottom = UDim.new(0, 10)
ControlsPadding.PaddingLeft = UDim.new(0, 10)
ControlsPadding.PaddingRight = UDim.new(0, 10)

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(1, 0, 1, -170)
Sidebar.Position = UDim2.new(0, 0, 0, 170)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 6
Sidebar.Parent = SidebarContainer

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingTop = UDim.new(0, 0)
SidebarPadding.PaddingBottom = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)

local ExportButton = Instance.new("TextButton")
ExportButton.Name = "ExportButton"
ExportButton.Size = UDim2.new(1, 0, 0, 40)
ExportButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
ExportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExportButton.Text = "Export Layout"
ExportButton.Font = Enum.Font.GothamBold
ExportButton.TextSize = 16
ExportButton.Parent = ControlsFrame

local ClearButton = Instance.new("TextButton")
ClearButton.Name = "ClearButton"
ClearButton.Size = UDim2.new(1, 0, 0, 40)
ClearButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.Text = "Clear All"
ClearButton.Font = Enum.Font.GothamBold
ClearButton.TextSize = 16
ClearButton.Parent = ControlsFrame

local LockButton = Instance.new("TextButton")
LockButton.Name = "LockButton"
LockButton.Size = UDim2.new(1, 0, 0, 40)
LockButton.BackgroundColor3 = Color3.fromRGB(200, 160, 60)
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.Text = "Lock UI"
LockButton.Font = Enum.Font.GothamBold
LockButton.TextSize = 16
LockButton.Parent = ControlsFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, 0, 0, 30)
SearchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderText = "Search assets..."
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.Parent = ControlsFrame

local IsLocked = false
local AssetButtons = {}

local DraggingElement = nil
local DragOffset = Vector2.zero

local function MakeDraggable(element)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    element.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not IsLocked then
            dragging = true
            dragStart = input.Position
            startPos = element.Position

            local changedConn
            changedConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if changedConn then changedConn:Disconnect() end
                end
            end)
        end
    end)

    element.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            element.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    element.Destroying:Connect(function()
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end)
end

local function MakeResizable(element)
    local ResizeHandle = Instance.new("Frame")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
    ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ResizeHandle.BackgroundTransparency = 0.5
    ResizeHandle.ZIndex = 10
    ResizeHandle.Parent = element

    local resizing = false
    local dragInput
    local dragStart
    local startSize

    ResizeHandle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not IsLocked then
            resizing = true
            dragStart = input.Position
            startSize = element.Size

            local changedConn
            changedConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                    if changedConn then changedConn:Disconnect() end
                end
            end)
        end
    end)

    ResizeHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and resizing then
            local delta = input.Position - dragStart
            element.Size = UDim2.new(
                startSize.X.Scale, startSize.X.Offset + delta.X,
                startSize.Y.Scale, startSize.Y.Offset + delta.Y
            )
        end
    end)

    element.Destroying:Connect(function()
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end)
end

local function SpawnAsset(path)
    local localAsset = GetLocalAsset(path)
    if not localAsset then return end

    local img = Instance.new("ImageLabel")
    img.Name = path
    img.Image = localAsset
    img.BackgroundTransparency = 1
    img.Size = UDim2.new(0, 100, 0, 100) -- Default size, can be adjusted
    img.Position = UDim2.new(0.5, 0, 0.5, 0)
    img.AnchorPoint = Vector2.new(0.5, 0.5)
    img.Parent = MainFrame

    MakeDraggable(img)
    MakeResizable(img)

    if IsLocked and img:FindFirstChild("ResizeHandle") then
        img.ResizeHandle.Visible = false
    end
end

for i, path in ipairs(AssetList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    local assetName = path:match("([^/]+)$") or path
    btn.Text = assetName
    btn.TextTruncate = Enum.TextTruncate.AtEnd
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = Sidebar

    btn.MouseButton1Click:Connect(function()
        SpawnAsset(path)
    end)

    table.insert(AssetButtons, {Button = btn, Name = assetName:lower()})
end

SearchBox.GetPropertyChangedSignal("Text"):Connect(function()
    local query = SearchBox.Text:lower()
    for _, item in ipairs(AssetButtons) do
        if query == "" or string.find(item.Name, query, 1, true) then
            item.Button.Visible = true
        else
            item.Button.Visible = false
        end
    end
    -- Allow UIListLayout to update its AbsoluteContentSize before updating CanvasSize
    task.defer(UpdateCanvasSize)
end)

LockButton.MouseButton1Click:Connect(function()
    IsLocked = not IsLocked
    if IsLocked then
        LockButton.Text = "Unlock UI"
        LockButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        for _, child in ipairs(MainFrame:GetChildren()) do
            if child:IsA("ImageLabel") and child:FindFirstChild("ResizeHandle") then
                child.ResizeHandle.Visible = false
            end
        end
    else
        LockButton.Text = "Lock UI"
        LockButton.BackgroundColor3 = Color3.fromRGB(200, 160, 60)
        for _, child in ipairs(MainFrame:GetChildren()) do
            if child:IsA("ImageLabel") and child:FindFirstChild("ResizeHandle") then
                child.ResizeHandle.Visible = true
            end
        end
    end
end)

local function UpdateCanvasSize()
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 20)
end
SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)
UpdateCanvasSize()

ExportButton.MouseButton1Click:Connect(function()
    local code = "-- Auto-generated ArexansUI Layout\n"
    code = code .. "local ScreenGui = Instance.new(\"ScreenGui\")\n"
    code = code .. "ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild(\"PlayerGui\")\n\n"
    code = code .. "local function GetLocalAsset(path)\n"
    code = code .. "    local getAsset = getcustomasset or getsynasset\n"
    code = code .. "    local localPath = \"ArexansUI_Assets/\" .. path:gsub(\"/\", \"_\")\n"
    code = code .. "    if isfile and isfile(localPath) and getAsset then return getAsset(localPath) end\n"
    code = code .. "    return \"rbxasset://\" .. localPath\n"
    code = code .. "end\n\n"

    for _, child in ipairs(MainFrame:GetChildren()) do
        if child:IsA("ImageLabel") then
            local varName = child.Name:match("([^/]+)$"):gsub("%.png", ""):gsub("[^%w]", "") .. "_" .. tostring(math.random(1000, 9999))
            code = code .. string.format("local %s = Instance.new(\"ImageLabel\")\n", varName)
            code = code .. string.format("%s.Name = \"%s\"\n", varName, child.Name:match("([^/]+)$"))
            code = code .. string.format("%s.Image = GetLocalAsset(\"%s\")\n", varName, child.Name)
            code = code .. string.format("%s.BackgroundTransparency = 1\n", varName)
            code = code .. string.format("%s.Position = UDim2.new(%.3f, %d, %.3f, %d)\n", varName, child.Position.X.Scale, child.Position.X.Offset, child.Position.Y.Scale, child.Position.Y.Offset)
            code = code .. string.format("%s.Size = UDim2.new(%.3f, %d, %.3f, %d)\n", varName, child.Size.X.Scale, child.Size.X.Offset, child.Size.Y.Scale, child.Size.Y.Offset)
            code = code .. string.format("%s.AnchorPoint = Vector2.new(0.5, 0.5)\n", varName)
            code = code .. string.format("%s.Parent = ScreenGui\n\n", varName)
        end
    end

    if writefile then
        writefile("ArexansUI_ExportedLayout.lua", code)
        print("Saved to workspace/ArexansUI_ExportedLayout.lua")
    end

    if setclipboard then
        setclipboard(code)
        print("Layout copied to clipboard!")
    else
        print("Exported Layout:\n" .. code)
    end
end)

ClearButton.MouseButton1Click:Connect(function()
    for _, child in ipairs(MainFrame:GetChildren()) do
        if child:IsA("ImageLabel") then
            child:Destroy()
        end
    end
end)

print("ArexansUI Builder initialized.")
