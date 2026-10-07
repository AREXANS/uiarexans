local ArexansUi = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function getAsset(path)
    -- In standard Roblox exploits, getcustomasset is often used to map local files.
    -- For demonstration/testing, we assume it's available or fallback to a standard rbxasset string.
    if getcustomasset then
        return getcustomasset(path)
    end
    return "rbxasset://" .. path
end

function ArexansUi:MakeWindow(config)
    config = config or {}
    local windowName = config.Name or "Arexans UI"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ArexansHub"
    ScreenGui.Parent = CoreGui

    -- Main background (using asset/window/window_frame+background.png)
    local MainFrame = Instance.new("ImageLabel")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
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
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 40)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar

    -- Container for tab contents
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -160, 1, -40)
    ContentContainer.Position = UDim2.new(0, 160, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local WindowAPI = {
        Tabs = {},
        CurrentTab = nil
    }

    function WindowAPI:MakeTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or "asset/icons/home_energy.png"

        local TabButton = Instance.new("ImageButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.BackgroundTransparency = 1
        TabButton.Image = getAsset("asset/navigation/sidebar_item_normal.png")
        TabButton.Parent = Sidebar

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = getAsset(tabIcon)
        TabIcon.Parent = TabButton

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -35, 1, 0)
        TabLabel.Position = UDim2.new(0, 30, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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
        TabContent.Parent = ContentContainer

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(WindowAPI.Tabs) do
                t.Content.Visible = false
                t.Button.Image = getAsset("asset/navigation/sidebar_item_normal.png")
            end
            TabContent.Visible = true
            TabButton.Image = getAsset("asset/navigation/sidebar_item_selected.png")
        end)

        local TabAPI = {}

        function TabAPI:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            local btnName = btnConfig.Name or "Button"
            local callback = btnConfig.Callback or function() end

            local ButtonFrame = Instance.new("ImageButton")
            ButtonFrame.Name = "Button_" .. btnName
            ButtonFrame.Size = UDim2.new(1, -10, 0, 35)
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
            ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
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
            TogButton.Size = UDim2.new(0, 40, 0, 20)
            TogButton.Position = UDim2.new(1, -45, 0.5, -10)
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
            SliderFrame.Size = UDim2.new(1, -10, 0, 45)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = TabContent

            local SlLabel = Instance.new("TextLabel")
            SlLabel.Size = UDim2.new(1, 0, 0, 20)
            SlLabel.BackgroundTransparency = 1
            SlLabel.Text = slName
            SlLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SlLabel.Font = Enum.Font.Gotham
            SlLabel.TextXAlignment = Enum.TextXAlignment.Left
            SlLabel.TextSize = 14
            SlLabel.Parent = SliderFrame

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

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 30, 0, 20)
            ValueLabel.Position = UDim2.new(1, -30, 0, 0)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.TextSize = 12
            ValueLabel.Parent = SliderFrame

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

        table.insert(WindowAPI.Tabs, {Button = TabButton, Content = TabContent})
        if #WindowAPI.Tabs == 1 then
            TabContent.Visible = true
            TabButton.Image = getAsset("asset/navigation/sidebar_item_selected.png")
        end

        return TabAPI
    end

    return WindowAPI
end

return ArexansUi
