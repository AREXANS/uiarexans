local AssetList = loadstring(game:HttpGet("https://raw.githubusercontent.com/AREXANS/uiarexans/main/asset_list.lua"))()

local ArexansUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/AREXANS/uiarexans/main/ArexansUi.lua"))()

-- Core GUI Canvas
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local EditorCanvas = Instance.new("ScreenGui")
EditorCanvas.Name = "ArexansEditorCanvas"
EditorCanvas.Parent = CoreGui

local CanvasFrame = Instance.new("Frame")
CanvasFrame.Size = UDim2.new(1, 0, 1, 0)
CanvasFrame.BackgroundTransparency = 1
CanvasFrame.Parent = EditorCanvas

local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

-- Re-use getAsset logic from ArexansUi
local function getAsset(path)
    local fileName = path:match("([^/]+)$")
    local success, result = pcall(function()
        if isfile and isfile(fileName) then
            return getcustomasset(fileName)
        end
        local content = game:HttpGet("https://raw.githubusercontent.com/AREXANS/uiarexans/main/" .. path)
        if writefile then
            writefile(fileName, content)
            return getcustomasset(fileName)
        end
        return ""
    end)
    if success and result ~= "" then
        return result
    end
    return ""
end

-- Toolbox Window
local Window = ArexansUi:MakeWindow({
    Name = "Arexans UI Editor",
    Size = UDim2.new(0, 300, 0, 500)
})

local SpawnerTab = Window:MakeTab({
    Name = "Assets Spawner",
    Icon = "asset/icons/folder_energy.png"
})

local ControlsTab = Window:MakeTab({
    Name = "Export Controls",
    Icon = "asset/icons/settings.png"
})

-- Spawner logic
local addedCount = 0
for _, path in ipairs(AssetList) do
    local fileName = path:match("([^/]+)$")
    SpawnerTab:AddButton({
        Name = "Spawn: " .. fileName,
        Callback = function()
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 50, 0, 50)
            img.Position = UDim2.new(0.5, 0, 0.5, 0) -- center
            img.BackgroundTransparency = 1
            local assetUrl = getAsset(path)
            if assetUrl ~= "" then
                img.Image = assetUrl
            else
                img.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                img.BackgroundTransparency = 0
            end

            img:SetAttribute("AssetPath", path)
            makeDraggable(img)

            -- Right click to delete
            img.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                    img:Destroy()
                end
            end)

            img.Parent = CanvasFrame
            addedCount = addedCount + 1

            Window:Notify({
                Title = "Spawned",
                Content = "Spawned " .. fileName .. "\n(Right click to delete)",
                Duration = 2
            })
        end
    })
end

ControlsTab:AddButton({
    Name = "Export Layout to Clipboard",
    Callback = function()
        local scriptOutput = "-- Exported Arexans UI Layout\nlocal CoreGui = game:GetService('CoreGui')\nlocal ScreenGui = Instance.new('ScreenGui')\nScreenGui.Parent = CoreGui\n\n"

        local childCount = 0
        for _, child in ipairs(CanvasFrame:GetChildren()) do
            if child:IsA("ImageLabel") then
                childCount = childCount + 1
                local path = child:GetAttribute("AssetPath")
                local pos = child.Position

                scriptOutput = scriptOutput .. string.format([[
local img%d = Instance.new("ImageLabel")
img%d.Size = UDim2.new(0, 50, 0, 50)
img%d.Position = UDim2.new(%f, %d, %f, %d)
img%d.BackgroundTransparency = 1
img%d.Image = "]] .. path .. [["
img%d.Parent = ScreenGui
]], childCount, childCount, childCount, pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset, childCount, childCount, childCount)
            end
        end

        if setclipboard then
            setclipboard(scriptOutput)
            Window:Notify({
                Title = "Export Success",
                Content = "Layout exported to Clipboard! (" .. childCount .. " elements)",
                Duration = 5
            })
        else
            print(scriptOutput)
            Window:Notify({
                Title = "Export Success",
                Content = "Layout printed to F9 Console! (" .. childCount .. " elements)",
                Duration = 5
            })
        end
    end
})

ControlsTab:AddButton({
    Name = "Export Layout to File",
    Callback = function()
        local scriptOutput = "-- Exported Arexans UI Layout\nlocal CoreGui = game:GetService('CoreGui')\nlocal ScreenGui = Instance.new('ScreenGui')\nScreenGui.Parent = CoreGui\n\n"

        local childCount = 0
        for _, child in ipairs(CanvasFrame:GetChildren()) do
            if child:IsA("ImageLabel") then
                childCount = childCount + 1
                local path = child:GetAttribute("AssetPath")
                local pos = child.Position

                scriptOutput = scriptOutput .. string.format([[
local img%d = Instance.new("ImageLabel")
img%d.Size = UDim2.new(0, 50, 0, 50)
img%d.Position = UDim2.new(%f, %d, %f, %d)
img%d.BackgroundTransparency = 1
img%d.Image = "]] .. path .. [["
img%d.Parent = ScreenGui
]], childCount, childCount, childCount, pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset, childCount, childCount, childCount)
            end
        end

        if writefile then
            writefile("ArexansLayoutExport.lua", scriptOutput)
            Window:Notify({
                Title = "Export Success",
                Content = "Saved to workspace as 'ArexansLayoutExport.lua'",
                Duration = 5
            })
        else
            Window:Notify({
                Title = "Export Failed",
                Content = "Your executor does not support writefile.",
                Duration = 5
            })
        end
    end
})

ControlsTab:AddButton({
    Name = "Clear Canvas",
    Callback = function()
        for _, child in ipairs(CanvasFrame:GetChildren()) do
            child:Destroy()
        end
        Window:Notify({
            Title = "Cleared",
            Content = "Canvas has been cleared.",
            Duration = 3
        })
    end
})

Window:Notify({
    Title = "Editor Ready",
    Content = "Spawn assets, drag them around, right click to delete. Then export!",
    Duration = 8
})
