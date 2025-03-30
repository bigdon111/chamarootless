TARGET := iphone:clang:latest:16.0
ARCHS = arm64
INSTALL_TARGET_PROCESSES = SpringBoard
PACKAGE_VERSION = 0.0.1-12+debug
THEOS_PACKAGE_DIR_NAME = debs
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = chamarootless
chamarootless_FILES = DockTweak.xm InstaLabelTweak.xm
chamarootless_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk
after-install::
	install.exec "sbreload"