ARCHS = armv7 arm64
PACKAGE_VERSION = 1.1
TARGET = iphone:clang:latest:6.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BlobsterHack
BlobsterHack_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp -R Resources $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(TWEAK_NAME)$(ECHO_END)
