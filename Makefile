export THEOS = $(HOME)/theos
export SYSROOT = $(THEOS)/sdks/iPhoneOS8.4.1.sdk
TARGET := iphone:clang:latest:8.0
include $(THEOS)/makefiles/common.mk
ARCHS = armv7 arm64

APPLICATION_NAME = Brooklyn

Brooklyn_FILES = $(wildcard *.m) $(wildcard *.xm)
Brooklyn_FRAMEWORKS = UIKit CoreGraphics MessageUI
Brooklyn_PRIVATE_FRAMEWORKS = IMCore ChatKit IMFoundation IMDPersistence AppSupport
Brooklyn_LIBRARIES = rocketbootstrap
Brooklyn_CFLAGS = -fobjc-arc
Brooklyn_CODESIGN_FLAGS = -Sent.plist


include $(THEOS_MAKE_PATH)/application.mk

before-all::
	sh nibbuild.sh
SUBPROJECTS += rubicon
SUBPROJECTS += brooklynsettings
SUBPROJECTS += brooklynbypass
SUBPROJECTS += smshelper
include $(THEOS_MAKE_PATH)/aggregate.mk
