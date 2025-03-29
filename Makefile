TARGET := iphone:clang:latest:16.0
ARCHS = arm64
INSTALL_TARGET_PROCESSES = SpringBoard
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = chamarootless
chamarootless_FILES = Tweak.xm
chamarootless_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/Tweak.mk
after-install::
	install.exec "sbreload"