################################################################################
#
# python-mgurdy
#
################################################################################

PYTHON_MGURDY_VERSION = 33963498f733f898c3f10fad811db491dd477b10
PYTHON_MGURDY_STRIP_COMPONENTS = 2
PYTHON_MGURDY_EXCLUDES = mgurdy-lib/
PYTHON_MGURDY_SITE = $(call github,midigurdy,mg-core,$(PYTHON_MGURDY_VERSION))
PYTHON_MGURDY_LICENSE = GPL3
PYTHON_MGURDY_SETUP_TYPE = setuptools
PYTHON_MGURDY_DEPENDENCIES = host-python-cffi \
							 libmgurdy fluidsynth freetype python3 \
							 python-marshmallow python-peewee python-flask-restful \
							 python-alsaaudio python-sf2utils python-websockets
PYTHON_MGURDY_ENV = C_INCLUDE_PATH=$(STAGING_DIR)/usr/include/freetype2/

$(eval $(python-package))
