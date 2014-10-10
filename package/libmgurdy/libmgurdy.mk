################################################################################
#
# Shared library for MidiGurdy core functionality. Used as a CFFI extension
# in Python 3 main program (python-mgurdy).
#
################################################################################

LIBMGURDY_VERSION = v1.1.3
LIBMGURDY_STRIP_COMPONENTS = 2
LIBMGURDY_EXCLUDES = mgurdy/
LIBMGURDY_SITE = $(call github,midigurdy,mg-core,$(LIBMGURDY_VERSION))
LIBMGURDY_INSTALL_STAGING = YES
LIBMGURDY_INSTALL_TARGET = YES
LIBMGURDY_AUTORECONF = YES
LIBMGURDY_DEPENDENCIES = fluidsynth alsa-lib libwebsockets-mg
LIBMGURDY_FREETYPE_CONFIG=$(STAGING_DIR)/usr/bin/freetype-config


define LIBMGURDY_BUILD_CMDS
    rm -rf $(@D)/build
    $(MAKE) CC=$(TARGET_CC) LD=$(TARGET_LD) FREETYPE_CFLAGS="-I$(STAGING_DIR)/usr/include/freetype2" -C $(@D) all
endef

define LIBMGURDY_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/build/libmgurdy.so $(TARGET_DIR)/usr/lib
endef

define LIBMGURDY_INSTALL_STAGING_CMDS
    $(INSTALL) -D -m 0755 $(@D)/build/libmgurdy.so $(STAGING_DIR)/usr/lib
	$(INSTALL) -D -m 0644 $(@D)/src/mg.h $(STAGING_DIR)/usr/include/mg.h
	$(INSTALL) -D -m 0644 $(@D)/src/display.h $(STAGING_DIR)/usr/include/display.h
endef

$(eval $(generic-package))
