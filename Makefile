export THEOS = $(HOME)/theos
export THEOS_DEVICE_IP = 10.0.1.31
export SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk
TARGET := iphone:clang:latest:8.0
include $(THEOS)/makefiles/common.mk
ARCHS = armv7 arm64

APPLICATION_NAME = Brooklyn

Brooklyn_FILES = $(wildcard *.m) $(wildcard *.xm)
Brooklyn_FRAMEWORKS = UIKit CoreGraphics MessageUI AVFoundation QuartzCore
Brooklyn_PRIVATE_FRAMEWORKS = IMCore ChatKit IMFoundation IMDPersistence AppSupport
Brooklyn_CFLAGS = -fobjc-arc
Brooklyn_CODESIGN_FLAGS = -Sent.plist


include $(THEOS_MAKE_PATH)/application.mk

before-all::
	sh layout/var/mobile/Documents/mautrix-imessage-armv7/fetch.sh
	sh nibbuild.sh
SUBPROJECTS += rubicon
SUBPROJECTS += brooklynsettings
SUBPROJECTS += brooklynbypass
SUBPROJECTS += smshelper
include $(THEOS_MAKE_PATH)/aggregate.mk
