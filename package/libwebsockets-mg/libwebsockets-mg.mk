################################################################################
#
# libwebsockets-mg
#
################################################################################

LIBWEBSOCKETS_MG_VERSION = v2.2.1
LIBWEBSOCKETS_MG_SITE = $(call github,warmcat,libwebsockets,$(LIBWEBSOCKETS_MG_VERSION))
LIBWEBSOCKETS_MG_LICENSE = LGPL-2.1 with exceptions
LIBWEBSOCKETS_MG_LICENSE_FILES = LICENSE
LIBWEBSOCKETS_MG_DEPENDENCIES = zlib
LIBWEBSOCKETS_MG_INSTALL_STAGING = YES
LIBWEBSOCKETS_MG_CONF_OPTS = -DLWS_WITHOUT_TESTAPPS=ON -DLWS_IPV6=OFF

# If LWS_MAX_SMP=1, then there is no code related to pthreads compiled
# in the library. If unset, LWS_MAX_SMP defaults to 32 and a small
# amount of pthread mutex code is built into the library.
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
LIBWEBSOCKETS_MG_CONF_OPTS += -DLWS_MAX_SMP=1
else
LIBWEBSOCKETS_MG_CONF_OPTS += -DLWS_MAX_SMP=
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBWEBSOCKETS_MG_DEPENDENCIES += openssl host-openssl
LIBWEBSOCKETS_MG_CONF_OPTS += -DLWS_WITH_SSL=ON
else
LIBWEBSOCKETS_MG_CONF_OPTS += -DLWS_WITH_SSL=OFF
endif

ifeq ($(BR2_PACKAGE_LIBEV),y)
LIBWEBSOCKETS_MG_DEPENDENCIES += libev
LIBWEBSOCKETS_MG_CONF_OPTS += -DLWS_WITH_LIBEV=ON
else
LIBWEBSOCKETS_MG_CONF_OPTS += -DLWS_WITH_LIBEV=OFF
endif

ifeq ($(BR2_PACKAGE_LIBUV),y)
LIBWEBSOCKETS_MG_DEPENDENCIES += libuv
LIBWEBSOCKETS_MG_CONF_OPTS += -DLWS_WITH_LIBUV=ON
else
LIBWEBSOCKETS_MG_CONF_OPTS += -DLWS_WITH_LIBUV=OFF
endif

ifeq ($(BR2_STATIC_LIBS),y)
LIBWEBSOCKETS_MG_CONF_OPTS += -DLWS_WITH_SHARED=OFF
endif

ifeq ($(BR2_SHARED_LIBS),y)
LIBWEBSOCKETS_MG_CONF_OPTS += -DLWS_WITH_STATIC=OFF
endif

$(eval $(cmake-package))
