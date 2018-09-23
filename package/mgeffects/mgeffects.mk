################################################################################
#
# LADSPA effects used by the MidiGurdy
#
################################################################################

MGEFFECTS_VERSION = v1.1.4
MGEFFECTS_SITE = $(call github,midigurdy,mg-effects,$(MGEFFECTS_VERSION))
MGEFFECTS_INSTALL_STAGING = NO
MGEFFECTS_INSTALL_TARGET = YES
MGEFFECTS_AUTORECONF = NO
MGEFFECTS_DEPENDENCIES = ladspa

define MGEFFECTS_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CC) LD=$(TARGET_LD) \
		-C $(@D)
endef

define MGEFFECTS_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/lib/ladspa
    $(INSTALL) -D -m 0755 $(@D)/build/*.so $(TARGET_DIR)/usr/lib/ladspa
endef

$(eval $(generic-package))
