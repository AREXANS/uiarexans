const fs = require('fs');
let content = fs.readFileSync('uiarexans.lua', 'utf8');

// There's one more fix. The dropdown visual logic needs to let the options be selected correctly
// Let's ensure the toggle background shape on normal items is completely removed because it bleeds out!

// Re-verify the removal of long_horizonal_box.png from slot (which was item background). It was done by the regex.
// Let's verify:
