#
#  @(#)Makefile 1.4 95/01/18
#
#  ====================================================
#  Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
#
#  Developed at SunSoft, a Sun Microsystems, Inc. business.
#  Permission to use, copy, modify, and distribute this
#  software is freely granted, provided that this notice
#  is preserved.
#  ====================================================
#
#

#
# There are two options in making libm at fdlibm compile time:
# 	_IEEE_LIBM 	--- IEEE libm; smaller, and somewhat faster
#	_MULTI_LIBM	--- Support multi-standard at runtime by
#			    imposing wrapper functions defined in
#			    fdlibm.h:
#				_IEEE_MODE 	-- IEEE
#				_XOPEN_MODE 	-- X/OPEN
#				_POSIX_MODE 	-- POSIX/ANSI
#				_SVID3_MODE 	-- SVID
#
# Here is how to set up CFLAGS to create the desired libm at
# compile time:
#
# 	CFLAGS = -D_IEEE_LIBM		... IEEE libm (recommended)
#	CFLAGS = -D_SVID3_MODE	... Multi-standard supported
#					    libm with SVID as the
#					    default standard
#	CFLAGS = -D_XOPEN_MODE	... Multi-standard supported
#					    libm with XOPEN as the
#					    default standard
#	CFLAGS = -D_POSIX_MODE	... Multi-standard supported
#					    libm with POSIX as the
#					    default standard
#	CFLAGS = 			... Multi-standard supported
#					    libm with IEEE as the
#					    default standard
#
# NOTE: if scalb's second arguement is an int, then one must
# define _SCALB_INT in CFLAGS. The default prototype of scalb
# is double scalb(double, double)
#

prefix	= /usr/local

OUTDIR ?= .

AR	= ar

CC	= gcc

#
# Default IEEE libm
#
CFLAGS	= -g -O2 $(CCCONFOPT)

CHMOD	= chmod

CP	= cp

INCFILES = fdlibm.h

LDFLAGS	= 

LIB	= $(OUTDIR)/libfdm.a

LIBS	= 

RANLIB	= ranlib

RM	= /bin/rm -f

.INIT: $(INCFILES)

.KEEP_STATE:

src = 	k_standard.c k_rem_pio2.c \
	k_cos.c k_sin.c k_tan.c \
	e_acos.c e_acosh.c e_asin.c e_atan2.c \
	e_atanh.c e_cosh.c e_exp.c e_fmod.c \
	e_gamma.c e_gamma_r.c e_hypot.c e_j0.c \
	e_j1.c e_jn.c e_lgamma.c e_lgamma_r.c \
	e_log.c e_log10.c e_pow.c e_rem_pio2.c e_remainder.c \
	e_scalb.c e_sinh.c e_sqrt.c \
	w_acos.c w_acosh.c w_asin.c w_atan2.c \
	w_atanh.c w_cosh.c w_exp.c w_fmod.c \
	w_gamma.c w_gamma_r.c w_hypot.c w_j0.c \
	w_j1.c w_jn.c w_lgamma.c w_lgamma_r.c \
	w_log.c w_log10.c w_pow.c w_remainder.c \
	w_scalb.c w_sinh.c w_sqrt.c \
	s_asinh.c s_atan.c s_cbrt.c s_ceil.c s_copysign.c \
	s_cos.c s_erf.c s_expm1.c s_fabs.c s_finite.c s_floor.c \
	s_frexp.c s_ilogb.c s_isnan.c s_ldexp.c s_lib_version.c \
	s_log1p.c s_logb.c s_matherr.c s_modf.c s_nextafter.c \
	s_rint.c s_scalbn.c s_signgam.c s_significand.c s_sin.c \
	s_tan.c s_tanh.c

obj = 	$(OUTDIR)/k_standard.o $(OUTDIR)/k_rem_pio2.o \
	$(OUTDIR)/k_cos.o $(OUTDIR)/k_sin.o $(OUTDIR)/k_tan.o \
	$(OUTDIR)/e_acos.o $(OUTDIR)/e_acosh.o $(OUTDIR)/e_asin.o $(OUTDIR)/e_atan2.o \
	$(OUTDIR)/e_atanh.o $(OUTDIR)/e_cosh.o $(OUTDIR)/e_exp.o $(OUTDIR)/e_fmod.o \
	$(OUTDIR)/e_gamma.o $(OUTDIR)/e_gamma_r.o $(OUTDIR)/e_hypot.o $(OUTDIR)/e_j0.o \
	$(OUTDIR)/e_j1.o $(OUTDIR)/e_jn.o $(OUTDIR)/e_lgamma.o $(OUTDIR)/e_lgamma_r.o \
	$(OUTDIR)/e_log.o $(OUTDIR)/e_log10.o $(OUTDIR)/e_pow.o $(OUTDIR)/e_rem_pio2.o $(OUTDIR)/e_remainder.o  \
	$(OUTDIR)/e_scalb.o $(OUTDIR)/e_sinh.o $(OUTDIR)/e_sqrt.o \
	$(OUTDIR)/w_acos.o $(OUTDIR)/w_acosh.o $(OUTDIR)/w_asin.o $(OUTDIR)/w_atan2.o \
	$(OUTDIR)/w_atanh.o $(OUTDIR)/w_cosh.o $(OUTDIR)/w_exp.o $(OUTDIR)/w_fmod.o \
	$(OUTDIR)/w_gamma.o $(OUTDIR)/w_gamma_r.o $(OUTDIR)/w_hypot.o $(OUTDIR)/w_j0.o \
	$(OUTDIR)/w_j1.o $(OUTDIR)/w_jn.o $(OUTDIR)/w_lgamma.o $(OUTDIR)/w_lgamma_r.o \
	$(OUTDIR)/w_log.o $(OUTDIR)/w_log10.o $(OUTDIR)/w_pow.o $(OUTDIR)/w_remainder.o \
	$(OUTDIR)/w_scalb.o $(OUTDIR)/w_sinh.o $(OUTDIR)/w_sqrt.o \
	$(OUTDIR)/s_asinh.o $(OUTDIR)/s_atan.o $(OUTDIR)/s_cbrt.o $(OUTDIR)/s_ceil.o $(OUTDIR)/s_copysign.o \
	$(OUTDIR)/s_cos.o $(OUTDIR)/s_erf.o $(OUTDIR)/s_expm1.o $(OUTDIR)/s_fabs.o $(OUTDIR)/s_finite.o $(OUTDIR)/s_floor.o \
	$(OUTDIR)/s_frexp.o $(OUTDIR)/s_ilogb.o $(OUTDIR)/s_isnan.o $(OUTDIR)/s_ldexp.o $(OUTDIR)/s_lib_version.o \
	$(OUTDIR)/s_log1p.o $(OUTDIR)/s_logb.o $(OUTDIR)/s_matherr.o $(OUTDIR)/s_modf.o $(OUTDIR)/s_nextafter.o \
	$(OUTDIR)/s_rint.o $(OUTDIR)/s_scalbn.o $(OUTDIR)/s_signgam.o $(OUTDIR)/s_significand.o $(OUTDIR)/s_sin.o \
	$(OUTDIR)/s_tan.o $(OUTDIR)/s_tanh.o

all: $(LIB)

check:
	@echo This package does not have a validation suite.

clean:
	-$(RM) *~ \#* core a.out  $(obj) $(LIB)

distclean:	mostlyclean
	-$(RM) $(LIB)

install:	$(LIB) uninstall
	$(CP) $(LIB) $(prefix)/lib/$(LIB)
	$(CHMOD) 664 $(prefix)/lib/$(LIB)
	$(RANLIB) $(prefix)/lib/$(LIB) || true

$(LIB) : $(OUTDIR) $(obj)
	$(AR) cru $(LIB) $(obj)
	$(RANLIB) $(LIB) || true

maintainer-clean:	distclean
	@echo "This command is intended for maintainers to use;"
	@echo "it deletes files that may require special tools to rebuild."
	-$(RM) configure

mostlyclean:	clean
	-$(RM) $(obj)

source: $(src) README

uninstall:
	-$(RM) $(prefix)/lib/$(LIB)
	-$(RM) $(prefix)/lib/$(LIB)


$(OUTDIR):
	mkdir $(OUTDIR)

$(OUTDIR)/%.o:  %.c 
	$(CC) $(CFLAGS) -c -o $@ $<
