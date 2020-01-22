# Makefile for MEX files written in C
# make the .mexsol binaries by simply executing './configure', 'make'
#
# Copyright (C) 2002-2007 Moritz Borgmann

# include configuration output
-include Makeconf.mk

OCTAVE_MEXSFX = mex
OCTAVE_MEX = mkoctfile --mex
EXTRA_MEX_OPTS = -inline


ORDINPROJ = RealRESIZE

DEPENDS =  Makefile Makeconf.mk mexutils.c mexheader.h mexutils.h RealRESIZE.h


# End of customization

ARCH_NOW := $(shell $(HOME)/clstools/libexec/config.guess)

DEPEND = makedepend -o.$(MEXSFX) -Y

PROJ = $(ORDINPROJ)

SRCS = $(addsuffix .c, $(PROJ))
MEXS = $(addsuffix .$(MEXSFX), $(PROJ))
OCTAVE_MEXS = $(addprefix $(ARCH)/, $(addsuffix .$(OCTAVE_MEXSFX), $(PROJ)))
OCTAVE_MEXS_ORDIN =  $(addprefix $(ARCH)/, $(addsuffix .$(OCTAVE_MEXSFX), $(ORDINPROJ)))

MEX_PROFILE_GENERATE = $(subst COPTIMFLAGS=",LDOPTIMFLAGS="-fprofile-generate" COPTIMFLAGS="-fprofile-generate , $(MEX))
MEX_PROFILE_USE      = $(subst COPTIMFLAGS=",COPTIMFLAGS="-fprofile-use , $(MEX))

.SUFFIXES: .$(MEXSFX) .$(OCTAVE_MEXSFX)

.PHONY: all optimized matlab octave

ifeq ($(ARCH),$(ARCH_NOW))
DEFAULT_TARGETS = $(MEXS) $(OCTAVE_MEXS_CONDITIONAL)
endif

all: $(DEFAULT_TARGETS)
ifneq ($(ARCH),$(ARCH_NOW))
	@echo "Last configure run was for wrong architecture $(ARCH), reconfiguring..."
	./configure
	$(MAKE)
endif

matlab: $(MEXS)
octave: $(OCTAVE_MEXS_CONDITIONAL)

# rebuild all mex functions with profiler-guided performance tuning for gcc
optimized:
	./configure # force a rebuild of all mex files
	$(MAKE) MEX='$(MEX_PROFILE_GENERATE)' matlab
	cd ~/projects/CLSN601/sim/nsim/tests; echo "testAll();" | matlab -nojvm -nodisplay
	./configure # force a rebuild of all mex files
	$(MAKE) MEX='$(MEX_PROFILE_USE)' matlab
	rm -f *.gcda *.gcno


Makeconf.mk: configure
	./configure

$(MEXS) $(OCTAVE_MEXS): $(DEPENDS)

$(addsuffix .$(MEXSFX), $(ORDINPROJ)): %.$(MEXSFX) : %.c
	$(MEX) $(INC) $(EXTRA_MEX_OPTS) $*.c mexutils.c


$(OCTAVE_MEXS_ORDIN): $(ARCH)/%.$(OCTAVE_MEXSFX) : %.c
	@mkdir -p "$(ARCH)/"
	$(OCTAVE_MEX) $(INC) -o "$(ARCH)/$*.mex" $*.c mexutils.c


# obsolete rule, do not use
depend: 
	-$(DEPEND) -- $(CFLAGS) -- $(SRCS)

clean:
	-rm -f $(MEXS) $(OCTAVE_MEXS) *.o *.gcda *.gcno

