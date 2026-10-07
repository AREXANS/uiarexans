-- Load the ArexansUI library
local ArexansUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AREXANS/uiarexans/refs/heads/feature/ui-structural-assets-7323372619121539655/ArexansUI.lua"))()
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Create a protective folder for the arranger
local screen = Instance.new("ScreenGui")
screen.Name = "ArexansUI_Arranger"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true

if gethui then
    screen.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(screen)
    screen.Parent = CoreGui
else
    screen.Parent = CoreGui
end

local elements = {}
local currentZIndex = 1

-- Wait for assets to download
ArexansUI.Assets:WaitForReady(15)

-- Create export button
local exportBtn = Instance.new("TextButton")
exportBtn.Size = UDim2.fromOffset(150, 40)
exportBtn.Position = UDim2.new(1, -170, 0, 20)
exportBtn.Text = "Export Layout JSON"
exportBtn.BackgroundColor3 = Color3.fromRGB(30, 145, 255)
exportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exportBtn.Font = Enum.Font.GothamBold
exportBtn.TextSize = 12
exportBtn.ZIndex = 999
exportBtn.Parent = screen

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = exportBtn

exportBtn.MouseButton1Click:Connect(function()
    local layout = {}
    for name, obj in pairs(elements) do
        layout[name] = {
            Position = {
                ScaleX = obj.Position.X.Scale, OffsetX = obj.Position.X.Offset,
                ScaleY = obj.Position.Y.Scale, OffsetY = obj.Position.Y.Offset
            },
            Size = {
                ScaleX = obj.Size.X.Scale, OffsetX = obj.Size.X.Offset,
                ScaleY = obj.Size.Y.Scale, OffsetY = obj.Size.Y.Offset
            },
            ZIndex = obj.ZIndex
        }
    end

    local json = HttpService:JSONEncode(layout)
    if setclipboard then
        setclipboard(json)
        exportBtn.Text = "Copied!"
        task.delay(2, function()
            if exportBtn.Parent then exportBtn.Text = "Export Layout JSON" end
        end)
    else
        warn("setclipboard not found. JSON: " .. json)
    end
end)

-- Spawner configuration
local startPos = UDim2.fromOffset(20, 80)
local spacing = 110
local wrap = 5

local i = 0
for key, path in pairs(ArexansUI.Assets.Files) do
    local img = Instance.new("ImageLabel")
    img.Name = key
    img.BackgroundTransparency = 1

    -- Arrange them in a grid initially
    local row = math.floor(i / wrap)
    local col = i % wrap
    img.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (col * spacing), startPos.Y.Scale, startPos.Y.Offset + (row * spacing))
    img.Size = UDim2.fromOffset(100, 100)
    img.ScaleType = Enum.ScaleType.Fit
    img.ZIndex = 1

    local text = Instance.new("TextLabel")
    text.Text = key
    text.Size = UDim2.new(1, 0, 0, 20)
    text.Position = UDim2.new(0, 0, 1, 5)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1, 1, 1)
    text.TextStrokeTransparency = 0
    text.Font = Enum.Font.Gotham
    text.TextSize = 10
    text.Parent = img

    ArexansUI.Assets:Apply(img, key)
    img.Parent = screen
    elements[key] = img

    -- Drag Logic
    local dragging = false
    local dragStart = nil
    local startPos = nil

    img.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = img.Position

            -- Bring to front on click
            currentZIndex = currentZIndex + 1
            img.ZIndex = currentZIndex
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            img.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    i = i + 1
end

print("Loaded " .. tostring(i) .. " UI assets into arranger.")
