local ArexansUI = require("ArexansUI")

local Window = ArexansUI:CreateWindow({
    Name = "DELTA EXECUTOR",
    Subtitle = "Version 1.0",
    Logo = "logo",
    Size = UDim2.fromOffset(850, 535)
})

local TabHome = Window:AddTab({
    Name = "Home",
    Icon = "home"
})

local TabCode = Window:AddTab({
    Name = "Code",
    Icon = "server" -- Acts as a code/editor icon fallback
})

local TabSettings = Window:AddTab({
    Name = "Settings",
    Icon = "settings"
})

-- Build Home Tab
TabHome:AddSection("Welcome")
TabHome:AddLabel("Welcome to Delta Executor, a fast and reliable Roblox Exploit.")
TabHome:AddButton({
    Name = "Join Discord",
    Description = "Get latest scripts and support",
    Icon = "link",
    Callback = function()
        Window:Notify({
            Title = "Discord",
            Content = "Copied Discord link to clipboard!",
            Icon = "check"
        })
    end
})

-- Build Code Editor Tab
local CodeEditor = TabCode:AddCodeEditor({
    Default = "-- Type your script here...\n\nprint('Hello from Arexans Executor!')\n\nfor i = 1, 10 do\n    print(i)\nend",
    Placeholder = "Enter Lua script..."
})

local ActionRow = TabCode:AddActionRow()

ActionRow:AddButton({
    Name = "Execute",
    Icon = "play",
    Callback = function()
        local scriptText = CodeEditor:Get()
        Window:Notify({
            Title = "Execution",
            Content = "Script executed successfully!",
            Icon = "check"
        })
        -- Here you would do: loadstring(scriptText)()
    end
})

ActionRow:AddButton({
    Name = "Clear",
    Icon = "refresh",
    Callback = function()
        CodeEditor:Set("")
        Window:Notify({
            Title = "Editor",
            Content = "Editor cleared.",
            Icon = "info"
        })
    end
})

ActionRow:AddButton({
    Name = "Copy",
    Icon = "copy",
    Callback = function()
        -- setclipboard(CodeEditor:Get())
        Window:Notify({
            Title = "Clipboard",
            Content = "Script copied to clipboard.",
            Icon = "check"
        })
    end
})


-- Build Settings Tab
TabSettings:AddSection("Application Settings")
TabSettings:AddToggle({
    Name = "Auto Execute",
    Description = "Automatically execute scripts in autoexec folder",
    Default = false,
    Callback = function(state)
        print("Auto Execute:", state)
    end
})

TabSettings:AddSlider({
    Name = "Injection Delay",
    Min = 0,
    Max = 10,
    Default = 2,
    Callback = function(value)
        print("Delay:", value)
    end
})

Window:SelectTab(TabHome)
