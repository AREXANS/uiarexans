const fs = require('fs');
let content = fs.readFileSync('uiarexans.lua', 'utf8');

// Fix the logic that was backwards!
// CloseList should restore ZIndex to 31
content = content.replace(
    /            local function CloseList\(\)\n                open = false\n                ListPanel\.Visible = false\n                Button\.ImageTransparency = 0\n                Button\.ZIndex = 45\n                Label\.ZIndex = 46\n                ValueLabel\.ZIndex = 46\n            end/,
    "            local function CloseList()\n                open = false\n                ListPanel.Visible = false\n                Button.ImageTransparency = 0\n                Button.ZIndex = 31\n                Label.ZIndex = 32\n                ValueLabel.ZIndex = 32\n            end"
);

// Open should set ZIndex to 45
content = content.replace(
    /                -- Dropdown tetap berada DI DALAM area Page\.\n                Button\.ZIndex = 31\n                Label\.ZIndex = 32\n                ValueLabel\.ZIndex = 32\n\n                task\.defer/,
    "                -- Dropdown tetap berada DI DALAM area Page.\n                Button.ZIndex = 45\n                Label.ZIndex = 46\n                ValueLabel.ZIndex = 46\n\n                task.defer"
);


fs.writeFileSync('uiarexans.lua', content);
