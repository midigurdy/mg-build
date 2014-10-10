################################################################################
#
# python-peewee
#
################################################################################

PYTHON_PEEWEE_VERSION = 2.10.1
PYTHON_PEEWEE_SOURCE = peewee-$(PYTHON_PEEWEE_VERSION).tar.gz
PYTHON_PEEWEE_SITE = https://pypi.python.org/packages/c6/c6/ee7165f2e639156a21c2c20a3c39e8706cdd8707b5d5aab3ee286e27cfce
PYTHON_PEEWEE_SETUP_TYPE = distutils
PYTHON_PEEWEE_LICENSE = MIT
PYTHON_PEEWEE_LICENSE_FILES = LICENSE

$(eval $(python-package))
