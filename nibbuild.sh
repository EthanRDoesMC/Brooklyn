#!/bin/sh

#  nibbuild.sh
#  brooklyn
#
#  Created by EthanRDoesMC on 1/1/21.
#

# make sure this is macos
if [[ "$OSTYPE" == "darwin"* ]]; then
# our xibs are in resources
cd ./Resources
# build xib with xcode-only ibtool
echo "Building xibs"
find . -name "*.xib" -type f | awk '{sub(/.xib/,"");print}' | xargs -I % ibtool --compile %.nib %.xib
# ok now handle xcassets
cd ..
/Applications/Xcode.app/Contents/Developer/usr/bin/actool BeeperAppIcon.xcassets --compile ./Resources --platform iphoneos  --minimum-deployment-target 8.0 --app-icon BeeperAppIcon --output-partial-info-plist tmp.plist
/usr/libexec/PlistBuddy -x -c "Merge tmp.plist" ./Resources/Info.plist
rm tmp.plist

echo "good luck"
else
    echo "Not macOS. Xibs will not be built."
    echo "If changes have been made to Xibs but nibs are not up-to-date: compile with macOS, then make sure to commit and push the nib files."
fi
