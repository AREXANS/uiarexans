const fs = require('fs');

let content = fs.readFileSync('uiarexans.lua', 'utf8');

// The HomeTab was defined as:
// local HomeTab = Window:CreateTab("Home")
// Since we want to empty it out:

// It might be followed by things or it might already be empty because I emptied it previously.
// Let's check what's there.
