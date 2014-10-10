################################################################################
#
# python-prctl
#
################################################################################

PYTHON_PRCTL_VERSION = 1.6.1
PYTHON_PRCTL_SOURCE = python-prctl-$(PYTHON_PRCTL_VERSION).tar.gz
PYTHON_PRCTL_SITE = https://pypi.python.org/packages/2c/a6/a866caf122908583f5f5e27217ca7f956c616e48e35cdb2a4a60ab4c7ad8
PYTHON_PRCTL_SETUP_TYPE = distutils
PYTHON_PRCTL_LICENSE = GNU General Public License (GPL)
PYTHON_PRCTL_DEPENDENCIES = libcap

$(eval $(python-package))
