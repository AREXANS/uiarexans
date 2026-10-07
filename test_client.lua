local ArexansUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/AREXANS/uiarexans/refs/heads/arexansui-implementation-12405782579210080253/ArexansUi.lua"))()

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
        Window:Notify({
            Title = "Success",
            Content = "Printed Hello!",
            Duration = 3,
            Type = "asset/notification/notification_success.png"
        })
    end
})

MainTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Auto Farm state:", state)
        Window:Notify({
            Title = "Auto Farm",
            Content = "State is now: " .. tostring(state),
            Duration = 2,
            Type = "asset/notification/notification_info.png"
        })
    end
})

MainTab:AddCheckbox({
    Name = "God Mode",
    Default = false,
    Callback = function(state)
        print("God Mode state:", state)
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

-- Trigger a startup notification
Window:Notify({
    Title = "Welcome",
    Content = "Arexans UI has loaded successfully.",
    Duration = 5,
    Type = "asset/notification/notification_info.png"
})
