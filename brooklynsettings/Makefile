TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = BrooklynSettings

BrooklynSettings_FILES = BLSRootListController.m
BrooklynSettings_FRAMEWORKS = UIKit
BrooklynSettings_PRIVATE_FRAMEWORKS = Preferences
BrooklynSettings_INSTALL_PATH = /Library/PreferenceBundles
BrooklynSettings_CFLAGS = -fobjc-arc
BrooklynSettings_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk
