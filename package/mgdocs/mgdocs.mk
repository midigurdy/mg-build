################################################################################
#
# The MidiGurdy documentation
#
################################################################################
MGDOCS_VERSION = 0791e41570ce78266588e1a27b52e4b51508c642
MGDOCS_SITE = $(call github,midigurdy,mg-docs,$(MGDOCS_VERSION))
MGDOCS_INSTALL_STAGING = NO
MGDOCS_INSTALL_TARGET = YES
MGDOCS_AUTORECONF = NO

define MGDOCS_BUILD_CMDS
    $(MAKE) -C $(@D) tiny-release
endef

define MGDOCS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/srv/www/manual/
    cp -r $(@D)/release/* $(TARGET_DIR)/srv/www/manual/
endef

$(eval $(generic-package))
