local ArexansUi = require(script.Parent:WaitForChild("ArexansUi"))

local Window = ArexansUi:MakeWindow({
    Name = "Arexans Hub"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "asset/icons/home_energy.png"
})

MainTab:AddButton({
    Name = "Print Hello",
    Callback = function()
        print("Hello from Arexans UI!")
    end
})

MainTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Auto Farm state:", state)
    end
})

local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "asset/icons/settings.png"
})

SettingsTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        print("WalkSpeed changed to:", value)
    end
})
