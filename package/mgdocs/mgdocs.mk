################################################################################
#
# The MidiGurdy documentation
#
################################################################################
MGDOCS_VERSION = v1.2.1
MGDOCS_SITE = $(call github,midigurdy,mg-docs,$(MGDOCS_VERSION))
MGDOCS_INSTALL_STAGING = NO
MGDOCS_INSTALL_TARGET = YES
MGDOCS_AUTORECONF = NO

define MGDOCS_BUILD_CMDS
    $(MAKE) -C $(@D) clean-all
    $(MAKE) -C $(@D) -e DOCLANG=en tiny-release
    $(MAKE) -C $(@D) clean
    $(MAKE) -C $(@D) -e DOCLANG=fr tiny-release
endef

define MGDOCS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/srv/www/manual/
    cp -r $(@D)/release/* $(TARGET_DIR)/srv/www/manual/
endef

$(eval $(generic-package))
