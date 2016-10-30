PLIST_BUDDY = /usr/libexec/PlistBuddy
BUNDLE_VERSION = 100
BUNDLE_SHORT_VERSION = 1.0.0
COPYRIGHT = © 2016 SmoothMouse Developers

# -----------------------------------------------------------------------

all = Resources/icon.icns SmoothMouse\ Uninstaller.app

all: $(all)

.PHONY: all release clean

Resources/icon.icns: icon.iconset/
	iconutil -c icns -o "$@" "$^"

SmoothMouse\ Uninstaller.app: main.scpt $(wildcard Resources/*) $(wildcard Resources/**/*)
	$(clean)
	osacompile -o "$@" -x "main.scpt"
	rm -f "$@/Contents/Resources/applet.icns"
	cp -R "Resources/" "$@/Contents/Resources/"
	
	$(PLIST_BUDDY) -c \
		"Set CFBundleIconFile icon" \
		"$@/Contents/Info.plist"
	
	$(PLIST_BUDDY) -c \
		"Add CFBundleVersion String '$(BUNDLE_VERSION)'" \
		"$@/Contents/Info.plist"
	
	$(PLIST_BUDDY) -c \
		"Add CFBundleShortVersionString String '$(BUNDLE_SHORT_VERSION)'" \
		"$@/Contents/Info.plist"
	
	$(PLIST_BUDDY) -c \
		"Add NSHumanReadableCopyright String '$(COPYRIGHT)'" \
		"$@/Contents/Info.plist"

release: $(all)
	codesign -f -s "Developer ID Application: $(SM_CERTIFICATE_IDENTITY)" "SmoothMouse Uninstaller.app"
	zip -r "SmoothMouse Uninstaller.zip" "SmoothMouse Uninstaller.app"

clean:
	$(clean)

define clean
	rm -rf "SmoothMouse Uninstaller.app" "SmoothMouse Uninstaller.zip"
endef
