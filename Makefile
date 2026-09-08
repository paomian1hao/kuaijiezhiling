ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:16.0
THEOS_PACKAGE_SCHEME = roothide
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MiniShortcutProgress
MiniShortcutProgress_FILES = Tweak.xm
MiniShortcutProgress_CFLAGS = -fobjc-arc
MiniShortcutProgress_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
