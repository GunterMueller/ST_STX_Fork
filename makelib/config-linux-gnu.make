#------------------ start of linux-elf/COMMON/defines ---------------------
#
# $Header: /cvs/stx/stx/configurations/linux-elf/COMMON/defines,v 1.92 2016-07-19 19:56:46 stefan Exp $
include $(MAKELIB)/config.make

CCARCHCOMMONOPT=-DELF
#RELOCINSTVARS=+relocInstvars

INTERN_H=linuxIntern.h
CPUINTERN_H=$(INCLUDE)/linuxIntern.h
OS=-DLINUX

MAKEFILE_EXTENSION=linux-elf
SETUP_RULE=setup_linux

# We need to use at most GCC 6.x, some code may fail to compile
# with GCC 7 due to -Werror (`send.c` for instance). We won't fix
# that for Smalltalk/X 6.x.x, will be fixed only for Smalltalk/X 8.1.x 
# series. 
# 
# Note, that we have to use the trick with `ifeq $(origin CC),...` rather than
# `ifdef` since CC is one of the GNU make implicit variables. series
#
# See https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html
ifeq ($(origin CC),default)
  ifneq ($(shell which gcc-6),)
    CC = gcc-6
  else ifneq ($(shell which gcc-5),)
    CC = gcc-5
  else ifneq ($(shell which gcc-4),)
    CC = gcc-4
  endif
endif
