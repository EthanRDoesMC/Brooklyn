TARGET := iphone:clang:8.4:7.0
INSTALL_TARGET_PROCESSES = Brooklyn imagent SpringBoard
ARCH = armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Rubicon

Rubicon_FILES = Tweak.xm
Rubicon_PRIVATE_FRAMEWORKS = ChatKit IMCore
Rubicon_CFLAGS = -fobjc-arc
Rubicon_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/tweak.mk
