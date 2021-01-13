export THEOS = /Users/ethanrdoesmc/theos
TARGET := iphone:clang:latest:8.0
INSTALL_TARGET_PROCESSES = Brooklyn imagent SpringBoard MobileSMS
include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = Brooklyn

Brooklyn_FILES = $(wildcard *.m) $(wildcard *.xm)
Brooklyn_FRAMEWORKS = UIKit CoreGraphics MessageUI
Brooklyn_PRIVATE_FRAMEWORKS = IMCore ChatKit IMFoundation
Brooklyn_CFLAGS = -fobjc-arc
Brooklyn_CODESIGN_FLAGS = -Sent.plist

include $(THEOS_MAKE_PATH)/application.mk

before-all::
	sh nibbuild.sh
SUBPROJECTS += rubicon
include $(THEOS_MAKE_PATH)/aggregate.mk