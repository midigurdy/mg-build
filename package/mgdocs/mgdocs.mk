################################################################################
#
# The MidiGurdy documentation
#
################################################################################

MGDOCS_VERSION = c34128b1ab3b8ac258b942447bee0115caaa8e44
MGDOCS_SITE = $(call github,midigurdy,mg-docs,$(MGDOCS_VERSION))
MGDOCS_INSTALL_STAGING = NO
MGDOCS_INSTALL_TARGET = YES
MGDOCS_AUTORECONF = NO

define MGDOCS_BUILD_CMDS
    $(MAKE) -C $(@D) html singlehtml epub latexpdf
endef

define MGDOCS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/srv/www/manual/en/html
	mkdir -p $(TARGET_DIR)/srv/www/manual/en/singlehtml
	mkdir -p $(TARGET_DIR)/srv/www/manual/en/download
    cp -r $(@D)/build/html/* $(TARGET_DIR)/srv/www/manual/en/html/
    cp -r $(@D)/build/singlehtml/* $(TARGET_DIR)/srv/www/manual/en/singlehtml/
    cp -r $(@D)/build/latex/midigurdy_manual.pdf $(TARGET_DIR)/srv/www/manual/en/download/
    cp -r $(@D)/build/epub/midigurdy_manual.epub $(TARGET_DIR)/srv/www/manual/en/download/
endef

$(eval $(generic-package))
