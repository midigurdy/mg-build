################################################################################
#
# The MidiGurdy web interface. It's a single page application based on VueJS,
# built and bundled with WebPack 
#
################################################################################

MGWEB_VERSION = v1.3.0
MGWEB_SITE = $(call github,midigurdy,mg-web,$(MGWEB_VERSION))
MGWEB_INSTALL_STAGING = NO
MGWEB_INSTALL_TARGET = YES
MGWEB_AUTORECONF = YES

define MGWEB_BUILD_CMDS
    $(MAKE) -C $(@D) all
endef

define MGWEB_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/srv/www
    cp -r $(@D)/dist/* $(TARGET_DIR)/srv/www/
endef

$(eval $(generic-package))
