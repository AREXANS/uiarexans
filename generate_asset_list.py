import os

assets = []
for root, dirs, files in os.walk('asset'):
    for file in files:
        if file.endswith('.png'):
            assets.append(os.path.join(root, file).replace('\\', '/'))

with open('asset_list.lua', 'w') as f:
    f.write('local AssetList = {\n')
    for asset in assets:
        f.write(f'    "{asset}",\n')
    f.write('}\nreturn AssetList\n')
