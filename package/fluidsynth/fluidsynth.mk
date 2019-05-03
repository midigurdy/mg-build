################################################################################
#
# Fluidsynth package
#
################################################################################

FLUIDSYNTH_VERSION = v2.0.5
FLUIDSYNTH_SITE = $(call github,FluidSynth,fluidsynth,$(FLUIDSYNTH_VERSION))
FLUIDSYNTH_INSTALL_STAGING = YES
FLUIDSYNTH_INSTALL_TARGET = YES
FLUIDSYNTH_CFLAGS = -ffast-math -O3
FLUIDSYNTH_CONF_OPTS = -Denable-ipv6=0 -Denable-floats=1 -Denable-ladspa=1 -Denable-alsa=1 -DCMAKE_C_FLAGS_RELEASE="$(FLUIDSYNTH_CFLAGS)"
# FLUIDSYNTH_MAKE_ENV = VERBOSE=1 
FLUIDSYNTH_DEPENDENCIES = alsa-lib libglib2 readline ladspa

$(eval $(cmake-package))
