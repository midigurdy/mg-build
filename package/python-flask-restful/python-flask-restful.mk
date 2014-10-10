################################################################################
#
# python-flask-restful
#
################################################################################

PYTHON_FLASK_RESTFUL_VERSION = 0.3.6
PYTHON_FLASK_RESTFUL_SOURCE = Flask-RESTful-$(PYTHON_FLASK_RESTFUL_VERSION).tar.gz
PYTHON_FLASK_RESTFUL_SITE = https://pypi.python.org/packages/20/f1/14a62bba209ae189e5c5fa33d5e0b7a4b5969488fa71fd3b8b323860bfc8
PYTHON_FLASK_RESTFUL_LICENSE = BSD
PYTHON_FLASK_RESTFUL_LICENSE_FILES = LICENSE
PYTHON_FLASK_RESTFUL_SETUP_TYPE = setuptools

$(eval $(python-package))
