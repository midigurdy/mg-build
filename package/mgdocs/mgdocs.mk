################################################################################
#
# The MidiGurdy documentation
#
################################################################################
MGDOCS_VERSION = fa7bade4e576128c7e16a475183b08c2174b7691
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
    find $(TARGET_DIR)/srv/www/manual/en/ -wholename "**/fonts/**.ttf" -delete
    find $(TARGET_DIR)/srv/www/manual/en/ -wholename "**/fonts/**.eot" -delete
    find $(TARGET_DIR)/srv/www/manual/en/ -wholename "**/fonts/**.svg" -delete
    find $(TARGET_DIR)/srv/www/manual/en/ -wholename "**/fonts/**.woff2" -delete
    rm -rf $(TARGET_DIR)/srv/www/manual/en/singlehtml/_static/
    rm -rf $(TARGET_DIR)/srv/www/manual/en/singlehtml/_images/
    ln -s ../html/_static $(TARGET_DIR)/srv/www/manual/en/html/_static
    ln -s ../html/_images $(TARGET_DIR)/srv/www/manual/en/html/_images
endef

$(eval $(generic-package))
