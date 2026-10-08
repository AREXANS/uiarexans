const fs = require('fs');

let content = fs.readFileSync('uiarexans.lua', 'utf8');

// Fix TabContainer size, active, and scrolling
content = content.replace(
    /TabContainer\.Size = UDim2\.new\(0, 134, 0, 243\)/,
    "TabContainer.Size = UDim2.new(0, 134, 0, 230)\n    TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y\n    TabContainer.Active = true"
);

// Fix TabListLayout CanvasSize update
content = content.replace(
    /TabListLayout:GetPropertyChangedSignal\("AbsoluteContentSize"\):Connect\(function\(\)\n        TabContainer\.CanvasSize = UDim2\.new\(0, 0, 0, TabListLayout\.AbsoluteContentSize\.Y\)\n    end\)/,
    "local function UpdateTabCanvas()\n        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)\n    end\n    TabListLayout:GetPropertyChangedSignal(\"AbsoluteContentSize\"):Connect(UpdateTabCanvas)"
);

// Call UpdateTabCanvas when a tab is created
content = content.replace(
    /TabText\.Parent = TabButton/,
    "TabText.Parent = TabButton\n\n        UpdateTabCanvas()"
);

// Remove the slot background which causes ugliness and boundary bleeding
content = content.replace(
    /            local SlotBg = Instance\.new\("ImageLabel"\)\n            SlotBg\.Name = "SlotBackground"\n            SlotBg\.Image = GetLocalAsset\("long_horizonal_box\.png"\)\n            SlotBg\.BackgroundTransparency = 1\n            SlotBg\.Size = UDim2\.fromScale\(1, 1\)\n            SlotBg\.ScaleType = Enum\.ScaleType\.Stretch\n            SlotBg\.ZIndex = 19\n            SlotBg\.Parent = slot\n/,
    ""
);

// Fix ContentLayout CanvasSize update to allow dropdowns to expand
content = content.replace(
    /        ContentLayout:GetPropertyChangedSignal\("AbsoluteContentSize"\):Connect\(function\(\)\n            local contentHeight = ContentLayout\.AbsoluteContentSize\.Y \+ 6\n            Page\.CanvasSize = UDim2\.new\(0, 0, 0, math\.max\(Page\.AbsoluteSize\.Y \- 4, contentHeight\)\)\n        end\)/,
    "        local function UpdatePageCanvas()\n            local contentHeight = ContentLayout.AbsoluteContentSize.Y + 10\n            local minHeight = Page.AbsoluteSize.Y > 0 and Page.AbsoluteSize.Y or 220\n            Page.CanvasSize = UDim2.new(0, 0, 0, math.max(minHeight, contentHeight + 80))\n        end\n        ContentLayout:GetPropertyChangedSignal(\"AbsoluteContentSize\"):Connect(UpdatePageCanvas)\n        Page:GetPropertyChangedSignal(\"AbsoluteSize\"):Connect(UpdatePageCanvas)"
);

// Fix Dropdown ZIndex when opening
content = content.replace(
    /                Button\.ZIndex = 31\n                Label\.ZIndex = 32\n                ValueLabel\.ZIndex = 32/,
    "                Button.ZIndex = 45\n                Label.ZIndex = 46\n                ValueLabel.ZIndex = 46"
);

// Fix dropdown up/down logic which caused ZIndex overlap/darkening
content = content.replace(
    /                    if spaceDown >= 32 or spaceDown >= spaceUp then\n                        local visibleHeight = math\.min\(desiredHeight, math\.max\(32, spaceDown\)\)\n                        ListPanel\.Position = UDim2\.new\(0, 0, 0, 0\)\n                        ListPanel\.Size = UDim2\.new\(1, 0, 0, visibleHeight\)\n                        List\.Position = UDim2\.new\(0, 8, 0, 30\)\n                        List\.Size = UDim2\.new\(1, -16, 1, -35\)\n                    else\n                        local visibleHeight = math\.min\(desiredHeight, math\.max\(32, spaceUp\)\)\n                        ListPanel\.Position = UDim2\.new\(0, 0, 0, -visibleHeight\)\n                        ListPanel\.Size = UDim2\.new\(1, 0, 0, visibleHeight\)\n                        List\.Position = UDim2\.new\(0, 8, 0, 5\)\n                        List\.Size = UDim2\.new\(1, -16, 1, -10\)\n                    end/,
    "                    ListPanel.Position = UDim2.new(0, 0, 0, 0)\n                    ListPanel.Size = UDim2.new(1, 0, 0, desiredHeight)\n                    List.Position = UDim2.new(0, 8, 0, 30)\n                    List.Size = UDim2.new(1, -16, 1, -35)"
);


fs.writeFileSync('uiarexans.lua', content);
