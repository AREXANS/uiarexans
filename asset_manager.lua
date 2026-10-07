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
local AssetList = {}
local success, result = pcall(function()
    return game:HttpGet("https://api.github.com/repos/AREXANS/uiarexans/git/trees/main?recursive=1")
end)

if success then
    local decoded = HttpService:JSONDecode(result)
    if decoded and type(decoded.tree) == "table" then
        for _, item in ipairs(decoded.tree) do
            if item.path:match("^asset/") and item.path:match("%.png$") then
                local relativePath = item.path:gsub("^asset/", "")
                table.insert(AssetList, relativePath)
            end
        end
    else
        warn("Failed to parse asset tree from GitHub. Rate limited?")
    end
else
    warn("Failed to fetch asset tree from github.")
end

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local getAsset = getcustomasset or getsynasset
local getHiddenGui = gethui or get_hidden_gui

local BaseURL = "https://raw.githubusercontent.com/AREXANS/uiarexans/main/asset/"
local FolderName = "ArexansUI_Assets"

if not isfolder(FolderName) then
    makefolder(FolderName)
end

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

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 250, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 6
Sidebar.Parent = ScreenGui

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingTop = UDim.new(0, 10)
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
ExportButton.Parent = Sidebar

local ClearButton = Instance.new("TextButton")
ClearButton.Name = "ClearButton"
ClearButton.Size = UDim2.new(1, 0, 0, 40)
ClearButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.Text = "Clear All"
ClearButton.Font = Enum.Font.GothamBold
ClearButton.TextSize = 16
ClearButton.Parent = Sidebar

local LockButton = Instance.new("TextButton")
LockButton.Name = "LockButton"
LockButton.Size = UDim2.new(1, 0, 0, 40)
LockButton.BackgroundColor3 = Color3.fromRGB(200, 160, 60)
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.Text = "Lock UI"
LockButton.Font = Enum.Font.GothamBold
LockButton.TextSize = 16
LockButton.Parent = Sidebar

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, 0, 0, 30)
SearchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderText = "Search assets..."
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.Parent = Sidebar

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

Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y

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
