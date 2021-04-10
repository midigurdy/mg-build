################################################################################
#
# Fluidsynth package
#
################################################################################

MG_FLUIDSYNTH_VERSION = v2.2.0
MG_FLUIDSYNTH_SITE = $(call github,FluidSynth,fluidsynth,$(MG_FLUIDSYNTH_VERSION))
MG_FLUIDSYNTH_INSTALL_STAGING = YES
MG_FLUIDSYNTH_INSTALL_TARGET = YES
MG_FLUIDSYNTH_CFLAGS = -ffast-math -O3
MG_FLUIDSYNTH_CONF_OPTS = -Denable-ipv6=0 -Denable-floats=1 -Denable-ladspa=1 -Denable-alsa=1 -DCMAKE_C_FLAGS_RELEASE="$(FLUIDSYNTH_CFLAGS)"
# FLUIDSYNTH_MAKE_ENV = VERBOSE=1 
MG_FLUIDSYNTH_DEPENDENCIES = alsa-lib libglib2 readline ladspa

$(eval $(cmake-package))
