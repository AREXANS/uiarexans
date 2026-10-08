#!/bin/bash
echo 'local BaseURL = "https://raw.githubusercontent.com/AREXANS/uiarexans/main/asset/"' > AssetList.lua
echo 'local FolderName = "ArexansUI_Assets"' >> AssetList.lua
echo '' >> AssetList.lua
echo 'if not isfolder(FolderName) then' >> AssetList.lua
echo '    makefolder(FolderName)' >> AssetList.lua
echo 'end' >> AssetList.lua
echo '' >> AssetList.lua
echo '-- Hardcoded asset list to bypass GitHub API rate limits' >> AssetList.lua
echo 'local AssetList = {' >> AssetList.lua

cd asset
find . -type f | sed 's/^\.\///' | sort | while read -r file; do
    echo "    \"$file\"," >> ../AssetList.lua
done
cd ..

echo '}' >> AssetList.lua
