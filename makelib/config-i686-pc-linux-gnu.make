#
# Definitions for target i686-pc-linux-gnu.
#
# based on eXept's:
#
# linux-elf/amd64_mode32: cpu: athlon64 in 32 bit mode os:linux-ELF options: +commonSymbol
#
#------------------ start of linux/amd64_mode32 ---------------------
#
# $Header: /cvs/stx/stx/configurations/linux-elf/amd64_mode32/defines,v 1.25 2016-03-17 22:32:46 stefan Exp $

include $(MAKELIB)/config-linux-gnu.make
include $(MAKELIB)/config-i686.make

#------------------ end of linux-elf/amd64_mode32 ---------------------
EXTRA_LIBS=-ldl -lX11 -lXext

# Following is a workaround for Debian / Ubuntu boxes.
#
ifeq ($(wildcard /usr/lib/i386-linux-gnu/libXft.so),)
ifeq ($(wildcard /usr/lib/i386-linux-gnu/libXft.so.2),/usr/lib/i386-linux-gnu/libXft.so.2)
LIB_XFT=-l:libXft.so.2 -l:libfontconfig.so.1
endif
endif

