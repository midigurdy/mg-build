################################################################################
#
# python-sf2utils
#
################################################################################

PYTHON_SF2UTILS_VERSION = 0.9.0
PYTHON_SF2UTILS_SOURCE = sf2utils-$(PYTHON_SF2UTILS_VERSION).tar.gz
PYTHON_SF2UTILS_SITE = https://gitlab.com/zeograd/sf2utils.git
PYTHON_SF2UTILS_SITE_METHOD = git
PYTHON_SF2UTILS_SETUP_TYPE = setuptools
PYTHON_SF2UTILS_LICENSE = LGPL3
PYTHON_SF2UTILS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
