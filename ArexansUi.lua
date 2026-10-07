local ArexansUi = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local function getAsset(path)
    -- Fallback for standard Roblox Studio
    if not isfile or not writefile or not getcustomasset or not makefolder then
        return "rbxasset://" .. path
    end

    local folderPath = "ArexansUI_Assets"
    if not isfolder(folderPath) then
        makefolder(folderPath)
    end

    local fileName = folderPath .. "/" .. path:gsub("/", "_")

    if not isfile(fileName) then
        local success, result = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/AREXANS/uiarexans/main/" .. path)
        end)
        if success and result then
            writefile(fileName, result)
        else
            return "rbxasset://" .. path
        end
    end

    local customAsset = getcustomasset(fileName)
    return customAsset or ""
end

function ArexansUi:MakeWindow(config)
    config = config or {}
    local windowName = config.Name or "Arexans UI"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ArexansHub"
    ScreenGui.Parent = CoreGui

    -- Main background
    local MainFrame = Instance.new("ImageLabel")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 650, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    MainFrame.BackgroundTransparency = 1
    MainFrame.Image = getAsset("asset/window/window_frame+background.png")
    MainFrame.Parent = ScreenGui

    -- Draggable functionality
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Sidebar for tabs
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 45)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar

    -- Container for tab contents
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -170, 1, -50)
    ContentContainer.Position = UDim2.new(0, 170, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    -- Toast Notification Container
    local ToastContainer = Instance.new("Frame")
    ToastContainer.Name = "ToastContainer"
    ToastContainer.Size = UDim2.new(0, 250, 1, 0)
    ToastContainer.Position = UDim2.new(1, -260, 0, 0)
    ToastContainer.BackgroundTransparency = 1
    ToastContainer.Parent = ScreenGui
    ToastContainer.ZIndex = 100

    local ToastLayout = Instance.new("UIListLayout")
    ToastLayout.Parent = ToastContainer
    ToastLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ToastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    ToastLayout.Padding = UDim.new(0, 10)

    local ToastPadding = Instance.new("UIPadding")
    ToastPadding.PaddingBottom = UDim.new(0, 20)
    ToastPadding.Parent = ToastContainer

    local WindowAPI = {
        Tabs = {},
        CurrentTab = nil
    }

    function WindowAPI:Notify(notifConfig)
        notifConfig = notifConfig or {}
        local title = notifConfig.Title or "Notification"
        local content = notifConfig.Content or ""
        local duration = notifConfig.Duration or 3
        local typeIcon = notifConfig.Type or "asset/notification/notification_info.png"

        local ToastFrame = Instance.new("ImageLabel")
        ToastFrame.Size = UDim2.new(1, 0, 0, 60)
        ToastFrame.BackgroundTransparency = 1
        ToastFrame.Image = getAsset("asset/notification/toast_background.png")
        ToastFrame.Parent = ToastContainer

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 24, 0, 24)
        Icon.Position = UDim2.new(0, 10, 0.5, -12)
        Icon.BackgroundTransparency = 1
        Icon.Image = getAsset(typeIcon)
        Icon.Parent = ToastFrame

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -45, 0, 20)
        TitleLabel.Position = UDim2.new(0, 40, 0, 10)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = ToastFrame

        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Size = UDim2.new(1, -45, 0, 20)
        ContentLabel.Position = UDim2.new(0, 40, 0, 30)
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Text = content
        ContentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        ContentLabel.Font = Enum.Font.Gotham
        ContentLabel.TextSize = 12
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.Parent = ToastFrame

        task.spawn(function()
            task.wait(duration)
            local fadeOut = TweenService:Create(ToastFrame, TweenInfo.new(0.5), {ImageTransparency = 1})
            fadeOut:Play()
            TweenService:Create(Icon, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
            TweenService:Create(TitleLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(ContentLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            fadeOut.Completed:Wait()
            ToastFrame:Destroy()
        end)
    end

    function WindowAPI:MakeTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or "asset/icons/home_energy.png"

        local TabButton = Instance.new("ImageButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundTransparency = 1
        TabButton.Image = getAsset("asset/navigation/sidebar_item_normal.png")
        TabButton.Parent = Sidebar

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = getAsset(tabIcon)
        TabIcon.Parent = TabButton

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -40, 1, 0)
        TabLabel.Position = UDim2.new(0, 40, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.TextSize = 14
        TabLabel.Parent = TabButton

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 4
        TabContent.Visible = false
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        TabContent.Parent = ContentContainer

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)

        ContentLayout.GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.PaddingBottom = UDim.new(0, 5)
        ContentPadding.PaddingLeft = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 5)
        ContentPadding.Parent = TabContent

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(WindowAPI.Tabs) do
                t.Content.Visible = false
                t.Button.Image = getAsset("asset/navigation/sidebar_item_normal.png")
                t.Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            TabContent.Visible = true
            TabButton.Image = getAsset("asset/navigation/sidebar_item_selected.png")
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local TabAPI = {}

        function TabAPI:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            local btnName = btnConfig.Name or "Button"
            local callback = btnConfig.Callback or function() end

            local ButtonFrame = Instance.new("ImageButton")
            ButtonFrame.Name = "Button_" .. btnName
            ButtonFrame.Size = UDim2.new(1, 0, 0, 38)
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.Image = getAsset("asset/button.png")
            ButtonFrame.Parent = TabContent

            local BtnLabel = Instance.new("TextLabel")
            BtnLabel.Size = UDim2.new(1, 0, 1, 0)
            BtnLabel.BackgroundTransparency = 1
            BtnLabel.Text = btnName
            BtnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnLabel.Font = Enum.Font.Gotham
            BtnLabel.TextSize = 14
            BtnLabel.Parent = ButtonFrame

            ButtonFrame.MouseButton1Click:Connect(function()
                ButtonFrame.Image = getAsset("asset/button_hover.png")
                task.wait(0.1)
                ButtonFrame.Image = getAsset("asset/button.png")
                callback()
            end)
        end

        function TabAPI:AddToggle(togConfig)
            togConfig = togConfig or {}
            local togName = togConfig.Name or "Toggle"
            local default = togConfig.Default or false
            local callback = togConfig.Callback or function() end

            local state = default

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle_" .. togName
            ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Parent = TabContent

            local TogLabel = Instance.new("TextLabel")
            TogLabel.Size = UDim2.new(1, -50, 1, 0)
            TogLabel.BackgroundTransparency = 1
            TogLabel.Text = togName
            TogLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TogLabel.Font = Enum.Font.Gotham
            TogLabel.TextXAlignment = Enum.TextXAlignment.Left
            TogLabel.TextSize = 14
            TogLabel.Parent = ToggleFrame

            local TogButton = Instance.new("ImageButton")
            TogButton.Size = UDim2.new(0, 44, 0, 22)
            TogButton.Position = UDim2.new(1, -44, 0.5, -11)
            TogButton.BackgroundTransparency = 1
            TogButton.Image = state and getAsset("asset/on.png") or getAsset("asset/off.png")
            TogButton.Parent = ToggleFrame

            TogButton.MouseButton1Click:Connect(function()
                state = not state
                TogButton.Image = state and getAsset("asset/on.png") or getAsset("asset/off.png")
                callback(state)
            end)
        end

        function TabAPI:AddSlider(slConfig)
            slConfig = slConfig or {}
            local slName = slConfig.Name or "Slider"
            local min = slConfig.Min or 0
            local max = slConfig.Max or 100
            local default = slConfig.Default or min
            local callback = slConfig.Callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider_" .. slName
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = TabContent

            local SlLabel = Instance.new("TextLabel")
            SlLabel.Size = UDim2.new(1, -40, 0, 20)
            SlLabel.BackgroundTransparency = 1
            SlLabel.Text = slName
            SlLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SlLabel.Font = Enum.Font.Gotham
            SlLabel.TextXAlignment = Enum.TextXAlignment.Left
            SlLabel.TextSize = 14
            SlLabel.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 40, 0, 20)
            ValueLabel.Position = UDim2.new(1, -40, 0, 0)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.TextSize = 12
            ValueLabel.Parent = SliderFrame

            local Track = Instance.new("ImageLabel")
            Track.Size = UDim2.new(1, 0, 0, 10)
            Track.Position = UDim2.new(0, 0, 1, -15)
            Track.BackgroundTransparency = 1
            Track.Image = getAsset("asset/controls/slider_track.png")
            Track.Parent = SliderFrame

            local Fill = Instance.new("ImageLabel")
            Fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
            Fill.BackgroundTransparency = 1
            Fill.Image = getAsset("asset/controls/slider_fill.png")
            Fill.Parent = Track

            local Knob = Instance.new("ImageButton")
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.Position = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), -8, 0.5, -8)
            Knob.BackgroundTransparency = 1
            Knob.Image = getAsset("asset/controls/slider_knob.png")
            Knob.Parent = Track

            local dragging = false
            Knob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = input.Position.X
                    local trackPos = Track.AbsolutePosition.X
                    local trackSize = Track.AbsoluteSize.X
                    local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                    local value = math.floor(min + (max - min) * percent)

                    Fill.Size = UDim2.new(percent, 0, 1, 0)
                    Knob.Position = UDim2.new(percent, -8, 0.5, -8)
                    ValueLabel.Text = tostring(value)

                    callback(value)
                end
            end)
        end

        function TabAPI:AddCheckbox(chkConfig)
            chkConfig = chkConfig or {}
            local chkName = chkConfig.Name or "Checkbox"
            local default = chkConfig.Default or false
            local callback = chkConfig.Callback or function() end

            local state = default

            local CheckFrame = Instance.new("Frame")
            CheckFrame.Name = "Checkbox_" .. chkName
            CheckFrame.Size = UDim2.new(1, 0, 0, 38)
            CheckFrame.BackgroundTransparency = 1
            CheckFrame.Parent = TabContent

            local ChkLabel = Instance.new("TextLabel")
            ChkLabel.Size = UDim2.new(1, -30, 1, 0)
            ChkLabel.Position = UDim2.new(0, 30, 0, 0)
            ChkLabel.BackgroundTransparency = 1
            ChkLabel.Text = chkName
            ChkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ChkLabel.Font = Enum.Font.Gotham
            ChkLabel.TextXAlignment = Enum.TextXAlignment.Left
            ChkLabel.TextSize = 14
            ChkLabel.Parent = CheckFrame

            local ChkButton = Instance.new("ImageButton")
            ChkButton.Size = UDim2.new(0, 20, 0, 20)
            ChkButton.Position = UDim2.new(0, 0, 0.5, -10)
            ChkButton.BackgroundTransparency = 1
            ChkButton.Image = state and getAsset("asset/controls/checkbox_on.png") or getAsset("asset/controls/checkbox_off.png")
            ChkButton.Parent = CheckFrame

            ChkButton.MouseButton1Click:Connect(function()
                state = not state
                ChkButton.Image = state and getAsset("asset/controls/checkbox_on.png") or getAsset("asset/controls/checkbox_off.png")
                callback(state)
            end)
        end

        table.insert(WindowAPI.Tabs, {Button = TabButton, Content = TabContent, Label = TabLabel})
        if #WindowAPI.Tabs == 1 then
            TabContent.Visible = true
            TabButton.Image = getAsset("asset/navigation/sidebar_item_selected.png")
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        return TabAPI
    end

    return WindowAPI
end

return ArexansUi
