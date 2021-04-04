TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BrooklynBypass

BrooklynBypass_FILES = SIMBypass.xm
BrooklynBypass_PRIVATE_FRAMEWORKS = FTServices
BrooklynBypass_EXTRA_FRAMEWORKS = Cephei
BrooklynBypass_CFLAGS = -fobjc-arc
Rubicon_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
