TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = MobileSMS


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = smshelper

smshelper_FILES = Tweak.xm
smshelper_FRAMEWORKS = Foundation
smshelper_PRIVATE_FRAMEWORKS = IMCore AppSupport ChatKit
smshelper_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
