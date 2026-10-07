-- Load the ArexansUI library from the specified branch
local ArexansUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AREXANS/uiarexans/refs/heads/feature/ui-structural-assets-7323372619121539655/ArexansUI.lua"))()

-- Create the main window
local Window = ArexansUI:CreateWindow({
    Name = "Arexans Hub",
    Subtitle = "Contoh Script GUI",
    Logo = "asset/logo.png",
    HeroImage = "asset/logo.png"
})

-- Add a main tab
local MainTab = Window:AddTab({
    Name = "Utama",
    Icon = "asset/icons/home.png" -- Replace with valid icon path if home.png isn't available
})

-- Add a section in the tab
MainTab:AddSection("Informasi Karakter")

-- Add a button
MainTab:AddButton({
    Name = "Sembuhkan Karakter",
    Description = "Mengembalikan HP ke penuh",
    Icon = "asset/icons/check.png",
    Callback = function()
        Window:Notify({
            Title = "Sukses",
            Content = "Karakter berhasil disembuhkan!",
            Duration = 3,
            Icon = "asset/icons/check.png"
        })
    end
})

-- Add a toggle
local AutoFarmToggle = MainTab:AddToggle({
    Name = "Auto Farm",
    Description = "Mengaktifkan mode farming otomatis",
    Default = false,
    Callback = function(state)
        if state then
            Window:Notify({
                Title = "Auto Farm",
                Content = "Auto Farm Diaktifkan",
                Duration = 2,
                Icon = "asset/icons/check.png"
            })
        else
            Window:Notify({
                Title = "Auto Farm",
                Content = "Auto Farm Dimatikan",
                Duration = 2,
                Icon = "asset/icons/close.png"
            })
        end
    end
})

-- Select the first tab so it's immediately visible
Window:SelectTab(MainTab)

Window:Notify({
    Title = "ArexansUI",
    Content = "Script berhasil dimuat!",
    Duration = 5,
    Icon = "asset/logo.png"
})
