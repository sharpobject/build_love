#!/bin/zsh
# usage: ./make_framework.sh <library> <version> <org_id>
# 
# example:
#   Creates Foo.framework from dynamic library named Foo with version 1.2.3 and
#   bundle id "com.example.Foo" in Info.plist:
#   
#   > ./make_framework.sh Foo 1.2.3 com.example

NAME=$1
ORG_ID=$2
BUNDLE_ID="$ORG_ID.$NAME"
VERSION=$3

mkdir -p $NAME.framework/Versions/A/Headers
mkdir -p $NAME.framework/Versions/A/Resources
cp $NAME $NAME.framework/Versions/A/
cd $NAME.framework/Versions && ln -s A Current
cd .. 
ln -s Versions/Current/Headers
ln -s Versions/Current/Resources
ln -s Versions/Current/$NAME
echo "
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>English</string>
    <key>CFBundleExecutable</key>
    <string>$NAME</string>
    <key>CFBundleIconFile</key>
    <string></string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CSResourcesFileMapped</key>
    <true/>
</dict>
</plist>
" > Resources/Info.plist
