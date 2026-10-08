import re

with open("uiarexans.lua", "r") as f:
    content = f.read()

# 1. Slider Enlarge
content = content.replace(
'''            local Track = Instance.new("Frame")
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
            Knob.Size = UDim2.new(0, 12, 0, 12)''',
'''            local Track = Instance.new("Frame")
            Track.BackgroundTransparency = 1
            Track.Position = UDim2.new(0.52, 0, 0.5, -4)
            Track.Size = UDim2.new(0.36, 0, 0, 8)
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
            Knob.Size = UDim2.new(0, 16, 0, 16)'''
)

# 2. GetItemParent Slot Background
content = content.replace(
'''            local slot = Instance.new("Frame")
            slot.Name = "ItemSlot"
            slot.BackgroundTransparency = 1
            slot.Size = UDim2.new(0.5, -(ITEM_GAP / 2), 1, 0)
            slot.ZIndex = 20
            slot.LayoutOrder = currentColumn + 1
            slot.Parent = currentRow
            currentColumn += 1
            return slot''',
'''            local slot = Instance.new("Frame")
            slot.Name = "ItemSlot"
            slot.BackgroundTransparency = 1
            slot.Size = UDim2.new(0.5, -(ITEM_GAP / 2), 1, 0)
            slot.ZIndex = 20
            slot.LayoutOrder = currentColumn + 1
            slot.Parent = currentRow

            local SlotBg = Instance.new("ImageLabel")
            SlotBg.Name = "SlotBackground"
            SlotBg.Image = GetLocalAsset("long_horizonal_box.png")
            SlotBg.BackgroundTransparency = 1
            SlotBg.Size = UDim2.fromScale(1, 1)
            SlotBg.ScaleType = Enum.ScaleType.Stretch
            SlotBg.ZIndex = 19
            SlotBg.Parent = slot

            currentColumn += 1
            return slot'''
)

# 3. Category Background
content = content.replace(
'''            local Category = Instance.new("ImageLabel")
            Category.Name = "Category_" .. tostring(title):gsub("%s+", "_")
            Category.Image = GetLocalAsset("containers/section_header.png")
            Category.BackgroundTransparency = 1
            Category.Size = UDim2.new(1, 0, 0, 18)
            Category.ScaleType = Enum.ScaleType.Stretch
            Category.ZIndex = 40
            Category.Parent = Content''',
'''            local Category = Instance.new("ImageLabel")
            Category.Name = "Category_" .. tostring(title):gsub("%s+", "_")
            Category.Image = GetLocalAsset("long_horizonal_box.png")
            Category.BackgroundTransparency = 1
            Category.Size = UDim2.new(1, 0, 0, 18)
            Category.ScaleType = Enum.ScaleType.Stretch
            Category.ZIndex = 40
            Category.Parent = Content'''
)

# 4. Dropdown Overlap Fix & Options Background
content = content.replace(
'''            local function CloseList()
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
            end)''',
'''            local function CloseList()
                open = false
                ListPanel.Visible = false
                Button.ImageTransparency = 0
                Button.ZIndex = 31
                Label.ZIndex = 32
                ValueLabel.ZIndex = 32
            end

            for index, option in ipairs(Options) do
                local OptionBg = Instance.new("ImageLabel")
                OptionBg.Name = "OptionBg_" .. index
                OptionBg.Image = GetLocalAsset("dropdown_selected_bg.png")
                OptionBg.BackgroundTransparency = 1
                OptionBg.Size = UDim2.new(1, -20, 0, 18)
                OptionBg.Position = UDim2.new(0, 10, 0, 0)
                OptionBg.ScaleType = Enum.ScaleType.Stretch
                OptionBg.ZIndex = 45
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
                OptionButton.TextSize = 9
                OptionButton.TextXAlignment = Enum.TextXAlignment.Center
                OptionButton.ZIndex = 46
                OptionButton.Parent = OptionBg

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

                -- Hide before state to prevent overlap
                Button.ImageTransparency = 1

                -- Dropdown tetap berada DI DALAM area Page.
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
            end)'''
)

with open("uiarexans.lua", "w") as f:
    f.write(content)
