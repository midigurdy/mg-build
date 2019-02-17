################################################################################
#
# python-pyalsa
#
################################################################################

PYTHON_PYALSA_VERSION = 1.1.6
PYTHON_PYALSA_SOURCE = pyalsa-$(PYTHON_PYALSA_VERSION).tar.bz2
PYTHON_PYALSA_SITE = ftp://ftp.alsa-project.org/pub/pyalsa
PYTHON_PYALSA_SETUP_TYPE = setuptools
PYTHON_PYALSA_LICENSE = MIT
PYTHON_PYALSA_LICENSE_FILES = LICENSE

$(eval $(python-package))
