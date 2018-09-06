#------------------ start of COMMON/defines ---------------------
#
# MIMEType: application/x-make (for editor to knows the comment chars)
#
# $Header: /cvs/stx/stx/configurations/COMMON/defines,v 1.136 2016-11-08 09:37:06 cg Exp $
#
# NOTICE:
#   all of these definitions can be overwritten in
#       vendor/COMMON/defines
#   and/or in
#     vendor/configuration/defines
#
# do not change anything here, but create a new configuration file
# redefining only things that need to be.
# Since Makefiles are created by sequentially concatenating
# the various 'defines'-files, almost everything can be redefined

# This file sets up defaults which fit on most systems -
# see redefinitions in vendor-define, config-define or individual Make.proto files

#
# Define C compiler "optimization: flags to use.
#
# * `-fno-strict-aliasing` since it's almost impossible to write a memory
#   manager without breaking C's aliasing rules. Better be on a safe side.
#   Nice post about these things: http://blog.regehr.org/archives/1307
#
# * `-Wno-strict-aliasing` to turn of warnings about breaking aliasing rules.
#   While one would think these wanings should be turned off when
#   `-fno-strict-aliasing` is passed, apparently some GCCs bark anyway.
#
# * `-fno-stack-protector` is (was) required on Ubuntu brands where it's
#   by default on. Smalltalk/X green thread implementation does not wotk
#   well with it.
#
# * `-U_FORTIFY_SOURCE` is (was) required on Gentoo as a workaround for failing
#   longjmp check when _FORTIFY_SOURCE is defined (which is enabled by default
#   on Gentoo. Remove when fixed.
#
OPT=-fPIC -O2 -fno-strict-aliasing -Wno-strict-aliasing -fno-stack-protector -ggdb3 -pipe -U_FORTIFY_SOURCE


CONF=$(BUILD_TARGET)
CONF_VENDOR=$(BUILD_TARGET)

ARCH=$(CONF)
ARCH_NAME=$(ARCH)
DISTRIB_NAME=$(ARCH)


#
# target for local make
#
TARGET_DIR=$(TOP)/projects/smalltalk

#-------------
# optional subPackages
# can be redefined to empty in concrete packages
#-------------

OPTIONAL_GOODIES_BENCHMARKS=benchmarks
OPTIONAL_GOODIES_PATHS=paths
OPTIONAL_GOODIES_TGEN=tgen
OPTIONAL_SUPPORT_UTILITIES=

OPTIONAL_LIBJAVA=libjava

# ------------
# architecture
# ------------

ARCH=unknown

# -------------
# how to deploy
# redefined in mac to "dmg"
# -------------
DEPLOY_PACKAGE=tgz

# --------
# commands
# --------

SHELL=/bin/sh
# MAKE is defined implicitly by make or gmake. Do not define here!
# MAKE=make

# c-compiler to use
CC ?= cc
AS_CC ?= $(CC) $(CCCONFOPT)
AS_CC_CFLAG=-c
CPP = cpp

# assembler for librun/asmhelp
AS = as

# linker for final executable
LD = $(CC) $(CCCONFOPT)
LDFLAGS = $(CCCONFOPT) \
	-Llib -L/usr/local/lib -L/usr/X11/lib -L/usr/lib \
	-Wl,-z,now,-Bsymbolic,-rpath,'$$ORIGIN',-rpath,'$$ORIGIN/lib',-rpath,'$$ORIGIN/../lib'

# linker for classlib object files, i.e., for example libstx_libbasic.o. This single partially-linked
# object file is later linked into a shared library.
CLASSLIB_LD=ld

# lex (can be replaced by flex)
LEX=lex

# yacc (can be replaced by bison)
YACC=yacc

# librarian
AR=ar
AR_LIB_FLAG=r
RANLIB=ranlib

# symbolic link
LNS=ln -s

# misc
STRIP=strip
OBJCOPY=objcopy
DIRNAME=dirname
CHMOD=chmod
#
# all BSD-based expr-implementations are missing the substring function
#
# RIGHTSTR="expr substr"
RIGHTSTR=$(TOP)/rules/rightstr
TOUCH=touch

# installer (to bring files to the INSTALLTOPDIR)
INSTALL=cp
INSTALL_BIN_CMD=$(INSTALL)
INSTALL_SCRIPT_CMD=$(INSTALL)
INSTALL_LIB_CMD=$(INSTALL)
INSTALL_AUX_CMD=$(INSTALL)
COMPRESSOR=
COMPRESSED_FILETYPE=

# in a vendorConf, you can define:
#
# INSTALL=install
# INSTALL_BIN_CMD=install -s -m 0555
# INSTALL_LIB_CMD=install -m 0444
# INSTALL_AUX_CMD=install -m 0444

#
# programs to install
#
INSTALL_PROGS=$(PROGS)

# --------------
# compiler flags
# --------------

# stc default optimization

DEFAULT_STCOPT=+optinline
STCOPT=$(DEFAULT_STCOPT)

# default stc optimization to use in various lib-directories
# (used in Make.protos)

LIBBASIC_STCOPT=$(DEFAULT_STCOPT) +optinline2 -warnNonStandard
LIBBOSS_STCOPT=$(LIBBASIC_STCOPT)
LIBBASIC2_STCOPT=+optspace2 -warnNonStandard
LIBBASIC3_STCOPT=+optspace2 -warnNonStandard
LIBCOMP_STCOPT=$(DEFAULT_STCOPT) -warnNonStandard
LIBVIEW_STCOPT=$(DEFAULT_STCOPT) -warnNonStandard
LIBVIEW2_STCOPT=+optspace2 -warnNonStandard
LIBWIDG_STCOPT=+optspace2 -warnNonStandard
LIBWIDG2_STCOPT=+optspace2
LIBWIDG3_STCOPT=+optspace3 -warnNonStandard
#LIBUI_STCOPT=+optspace2 -warnNonStandard
LIBUI_STCOPT=-warnNonStandard
LIBHTML_STCOPT=+optspace2 -warnNonStandard
LIBTOOL_STCOPT=+optspace2 -warnNonStandard -warnUnusedLocals -warnUseBeforeSet
LIBTOOL2_STCOPT=+optspace3 -warnNonStandard
LIBTABLE_STCOPT=+optspace2 -warnNonStandard
CLIENT_STCOPT=+optspace2
GOODIES_STCOPT=+optspace2

# common for all:
STCCOMMONOPT=+sharedLibCode -staticMethods +lineInfo +stLineInfo
CCCOMMONOPT=$(OPTIONAL_HAVE_FFI_ARG)

# to be redefined in arch/COMMON/defines
STCARCHCOMMONOPT=
CCARCHCOMMONOPT=-DELF


# top be redefined in arch/<conf>/defines
STCARCHOPT=
CCARCHOPT=

# this could be set per-configuration:
# STCCONFOPT=

# this could be set per-subdirectory:
# STCLOCALOPT=


# all st-objects depend on these:

STCHDR=$(INCLUDE)/stc.h $(INCLUDE)/stcIntern.h $(CPUINTERN_H)

# compile librun with -DDEBUG

DBG=-DDEBUG

#
# some c-preprocessors have a bug in not handling too-deeply nested
# include files. If yours does, some classes have to be compiled with a
# special STC flag, to produce a different kind of header-definition file
# If your machine is one of those, add a line as:
#   LIMITSUPERINCLUDE=+limitSuperInclude
# to the corresponding defines-file
LIMITSUPERINCLUDE=

# default for 'make includeLink'

#INCLUDELINK_FILES= \
#       abbrev.stc \
#       liblist.stc \
#       symbols.stc

INCLUDELINK_FILES= \
	symbols.stc

# -------------------------------------------------------------------------
# normally, the following need not be redefined (they have useful defaults)
# -------------------------------------------------------------------------

# compiler, linker, cflags and lexlib to use when building stc
# you could use a different compiler (gcc vs. cc) here.
# default is to use the same compiler as for classes

STC_CC=$(CC)
STC_LD=$(LD)
STC_CFLAGS=$(CFLAGS)
STC_LEXLIB=-ll

# compiler and optimizer flags to compile main.o
# default is to use the same compiler as for classes

MAIN_CC=$(CC)
MAIN_OPT=$(OPT)

# compiler, and optimizer flags for librun
# default is to use the same compiler as for classes

LIBRUN_CC=$(CC)
LIBRUN_OPT=$(OPT)
LIBRUN_SPECIAL_OPT=$(LIBRUN_OPT)

FFI_CC=$(CC)
FFI_LD=$(LD)
# if ffi.h is to be included from somewhere else...
FFI_INCLUDE=

# compiler to use for big-files
# default is to use the same compiler as for other classes

BIGFILE_CC=$(CC)

# compiler to use for libjpeg
# (only needed for hp, where standard cc cannot compile libjpeg)

# compiler to use for class libraries
# the only system, where this is different is (currently) hpux_
# (their cc crashes for some big files - sigh)

CLASSLIB_CC=$(CC)
CLASSLIB_OPT=$(OPT)
STC_OPT=$(OPT)

# compiler to use for particular class libraries
LIBBASIC_CC=$(CLASSLIB_CC)
LIBBASIC_OPT=$(CLASSLIB_OPT)

LIBBASIC2_CC=$(CLASSLIB_CC)
LIBBASIC2_OPT=$(CLASSLIB_OPT)

LIBBASIC3_OPT=$(CLASSLIB_OPT)
LIBBASIC3_CC=$(CLASSLIB_CC)

LIBCOMP_OPT=$(CLASSLIB_OPT)
LIBCOMP_CC=$(CLASSLIB_CC)

LIBVIEW_OPT=$(CLASSLIB_OPT)
LIBVIEW_CC=$(CLASSLIB_CC)

LIBVIEW2_OPT=$(CLASSLIB_OPT)
LIBVIEW2_CC=$(CLASSLIB_CC)

LIBWIDG_OPT=$(CLASSLIB_OPT)
LIBWIDG_CC=$(CLASSLIB_CC)

LIBWIDG2_OPT=$(CLASSLIB_OPT)
LIBWIDG2_CC=$(CLASSLIB_CC)

LIBWIDG3_OPT=$(CLASSLIB_OPT)
LIBWIDG3_CC=$(CLASSLIB_CC)

LIBTOOL_OPT=$(CLASSLIB_OPT)
LIBTOOL_CC=$(CLASSLIB_CC)

LIBTOOL2_OPT=$(CLASSLIB_OPT)
LIBTOOL2_CC=$(CLASSLIB_CC)

LIBUI_OPT=$(CLASSLIB_OPT)
LIBUI_CC=$(CLASSLIB_CC)

LIBHTML_OPT=$(CLASSLIB_OPT)
LIBHTML_CC=$(CLASSLIB_CC)

#
# flag for prelinking
#
LD_REL_FLAG=-r
#
# additional linker flags for prelinked obj-libraries
# (used when prelinking object modules)
#
LD_OBJ_FLAGS=

#
# optional rebasing rule (to relocate dll's to disjoint address ranges, if supported by the toolchain).
# OS X does provide this
#
rebaseLibsRule=nullRebaseRule
rebaseLibsRule_static=nullRebaseRule

# file name extensions

# name of object files
O=o

# name of archives
A=a

# name of executables
EXE=

# name of shared objects
SO=so
SONAME=.$(SO)
SO_NAME=$(SONAME)

# name of prelinked nonshared objects
OBJ=$(O)
OBJNAME=.$(OBJ)

# name of individual object files (JV: is that true?)
BIN_O=.$(SO)

# extension of linked object files
# (usually either '.a', '.o' or '.obj' on static-link systems
# or '.so' or '.dll' on dynamic link systems.

# shared lib link (default)
O_EXT=.$(SO)

# static link with prelinked relocatable modules (not used currently):
# O_EXT=$(OBJNAME)

# library link (not used currently):
# O_EXT=.$(A)

#
# location of various subdirs
#

INCLUDE    = $(TOP)/include
INCLUDE_IN = $(INCLUDE)
INCLUDE_OUT= $(INCLUDE)
CONFTOP    = $(TOP)
RULETOP    = $(TOP)
STCDIR     = $(TOP)/stc
STC        = $(STCDIR)/stc

CONFDIR    = $(CONFTOP)/configurations
RULEDIR    = $(RULETOP)/rules

LIBBASIC_RELDIR  = libbasic
LIBBASIC2_RELDIR = libbasic2
LIBBASIC3_RELDIR = libbasic3
LIBBOSS_RELDIR   = libboss
LIBCOMP_RELDIR   = libcomp
LIBHTML_RELDIR   = libhtml
LIBVIEW_RELDIR   = libview
LIBVIEW2_RELDIR  = libview2
LIBWIDG_RELDIR   = libwidg
LIBWIDG2_RELDIR  = libwidg2
LIBWIDG3_RELDIR  = libwidg3
LIBTOOL_RELDIR   = libtool
LIBTOOL2_RELDIR  = libtool2
LIBCOMPAT_RELDIR = libcompat
LIBUI_RELDIR     = libui
LIBODBC_RELDIR   = libodbc
LIBOBJC_RELDIR   = libobjc
GOODIES_RELDIR   = goodies
LIBDB_RELDIR     = libdb
SUNIT_RELDIR     = $(GOODIES_RELDIR) $(GOODIES_RELDIR)/sunit
RB_RELDIR        = $(GOODIES_RELDIR) $(GOODIES_RELDIR)/refactoryBrowser

LIBRUNDIR    = $(TOP)/librun
LIBBASICDIR  = $(TOP)/libbasic
LIBBASIC2DIR = $(TOP)/libbasic2
LIBBASIC3DIR = $(TOP)/libbasic3
LIBBOSSDIR   = $(TOP)/libboss
LIBCOMPDIR   = $(TOP)/libcomp
LIBHTMLDIR   = $(TOP)/libhtml
LIBVIEWDIR   = $(TOP)/libview
LIBVIEW2DIR  = $(TOP)/libview2
LIBWIDGDIR   = $(TOP)/libwidg
LIBWIDG2DIR  = $(TOP)/libwidg2
LIBWIDG3DIR  = $(TOP)/libwidg3
LIBTOOLDIR   = $(TOP)/libtool
LIBTOOL2DIR  = $(TOP)/libtool2
LIBTABLEDIR  = $(TOP)/libtable
LIBPRODIR    = $(TOP)/libpro
LIBCOMPATDIR = $(TOP)/libcompat
LIBUIDIR     = $(TOP)/libui
LIBODBCDIR   = $(TOP)/libodbc
CLIENTDIR    = $(TOP)/clients
LIBOBJCDIR   = $(TOP)/libobjc
GOODIESDIR   = $(TOP)/goodies
LIBDBASEDIR  = $(TOP)/goodies/libdbase
SUNITDIR     = $(TOP)/goodies/sunit

RBDIR        = $(TOP)/goodies/refactoryBrowser
LIBRB_HELPERSDIR     = $(RBDIR)/helpers
LIBRB_CHANGESDIR     = $(RBDIR)/changes
LIBRB_PARSERDIR      = $(RBDIR)/parser
LIBRB_REFACTORINGDIR = $(RBDIR)/refactoring
LIBRB_BROWSERDIR     = $(RBDIR)/browser

LIBSCMDIR            = $(TOP)/libscm
LIBSCM_COMMONDIR     = $(LIBSCMDIR)/common
LIBSCM_MERCURIALDIR  = $(LIBSCMDIR)/mercurial

#
# these are not yet released to the public
#
LIBCPLUSPLUSDIR = $(TOP)/libc++
LIBXTDIR        = $(TOP)/libxt
LIBXMDIR        = $(TOP)/libxm

#
# your private directories
#
# OTHERLIBDIRS are directories to be visited by make
#
OTHERLIBDIRS    =
#
# OTHERLIBS are libraries to be linked in at the end
#
OTHERLIBS       = -ldl -lrt -lc

MAIN       = $(LIBRUNDIR)/main.c
#HIDATA     = $(LIBRUNDIR)/hidata.o
HIDATA=

#
# object files to include in a classlibrary
# default is all upper-case .o-files
#
LINKOBJS=[A-Z]*.$(O)


A_EXT=.a
STATIC_O_EXT=.o

#
# libraries as in the development tree;
#
LIBRUN   = $(LIBRUNDIR)/librun$(O_EXT)
LIBBASIC = $(LIBBASICDIR)/libstx_libbasic$(O_EXT)
LIBBOSS  = $(LIBBOSSDIR)/libstx_libboss$(O_EXT)
LIBBASIC2= $(LIBBASIC2DIR)/libstx_libbasic2$(O_EXT)
LIBBASIC3= $(LIBBASIC3DIR)/libstx_libbasic3$(O_EXT)
LIBHTML  = $(LIBHTMLDIR)/libstx_libhtml$(O_EXT)
LIBCOMP  = $(LIBCOMPDIR)/libstx_libcomp$(O_EXT)
LIBCOMPAT= $(LIBCOMPATDIR)/libstx_libcompat$(O_EXT)
LIBVIEW  = $(LIBVIEWDIR)/libstx_libview$(O_EXT)
LIBVIEW2 = $(LIBVIEW2DIR)/libstx_libview2$(O_EXT)
LIBWIDG  = $(LIBWIDGDIR)/libstx_libwidg$(O_EXT)
LIBWIDG2 = $(LIBWIDG2DIR)/libstx_libwidg2$(O_EXT)
LIBWIDG3 = $(LIBWIDG3DIR)/libstx_libwidg3$(O_EXT)
LIBTOOL  = $(LIBTOOLDIR)/libstx_libtool$(O_EXT)
LIBTOOL2 = $(LIBTOOL2DIR)/libstx_libtool2$(O_EXT)
LIBTABLE = $(LIBTABLEDIR)/libstx_libtable$(O_EXT)
LIBUI    = $(LIBUIDIR)/libstx_libui$(O_EXT)
LIBDBASE = $(LIBDBASEDIR)/libstx_goodies_libdbase$(O_EXT)
GOODIES  = $(GOODIESDIR)/libstx_goodies$(O_EXT)
LIBOBJC  = $(LIBOBJCDIR)/libstx_libobjc$(O_EXT)
SUNIT    = $(SUNITDIR)/libstx_goodies_sunit$(O_EXT)

LIBRB_HELPERS     = $(LIBRB_HELPERSDIR)/libstx_goodies_refactoryBrowser_helpers$(O_EXT)
LIBRB_CHANGES     = $(LIBRB_CHANGESDIR)/libstx_goodies_refactoryBrowser_changes$(O_EXT)
LIBRB_PARSER      = $(LIBRB_PARSERDIR)/libstx_goodies_refactoryBrowser_parser$(O_EXT)
LIBRB_REFACTORING = $(LIBRB_REFACTORINGDIR)/libstx_goodies_refactoryBrowser_refactoring$(O_EXT)
LIBRB_BROWSER     = $(LIBRB_BROWSERDIR)/libstx_goodies_refactoryBrowser_browser$(O_EXT)

LIBSCM_COMMON     = $(LIBSCM_COMMONDIR)/libstx_libscm_common$(O_EXT)
LIBSCM_MERCURIAL  = $(LIBSCM_MERCURIALDIR)/libstx_libscm_mercurial$(O_EXT)

#
# additional (depreviated or private/experimental)
# libraries. These are not req'd normally.
#
LIBCPLUSPLUS= $(LIBCPLUSPLUSDIR)/libc++$(O_EXT)
LIBXT       = $(LIBXTDIR)/libxt$(O_EXT)
LIBXM       = $(LIBXMDIR)/libxm$(O_EXT)

#
# libraries which are either provided via the support directory
# or by the system. If a system-library is present, that one should
# usually be used (and then redefined in a platform-specific defines-file)
#

# the following defs are for using the provided (not the system) zlib;
# should work everywhere
ZLIB_DIR=$(TOP)/support/zlib-1.2.3
ZLIB_LD_ARG=-L$(ZLIB_DIR) -lz
ZLIB_MAKE_TARGET=zlib
MAKE_ZLIB_ARG= "CFLAGS=$(CCCONFOPT) -fPIC -O3 -DUSE_MMAP"

# the following defs are for using the provided (not the system) bz2lib;
# should work everywhere
BZ2LIB_DIR=$(TOP)/support/bz2lib
BZ2LIB_LD_ARG=-L$(BZ2LIB_DIR) -lbz2
BZ2LIB_MAKE_TARGET=bz2lib
MAKE_BZ2LIB_ARG= "CC=$(CC) $(CCCONFOPT)"

# the following defs are for NOT using any usb lib (only needed in some apps);
# redefined in linux configurations, to use the system lib (-lusb)
USB_LIB_DIR=
USB_LIB_ARG=
USB_MAKE_TARGET=

#
# libraries as linked to the executable.
# For sharedLib links, these must be in a common
# lib-subdirectory while being linked,
# in order to allow those shared libraries to be placed
# into some other directory (LD_LIBRARY_PATH) later.
# This is a bit inconvenient - sorry.
#
#LINK_LIBDIR = lib/
#LINK_LIBDIR = .
LINK_LIBRUN   = $(LINK_LIBDIR)librun$(O_EXT)
LINK_LIBBASIC = $(LINK_LIBDIR)libstx_libbasic$(O_EXT)
LINK_LIBBOSS  = $(LINK_LIBDIR)libstx_libboss$(O_EXT)
LINK_LIBBASIC2= $(LINK_LIBDIR)libstx_libbasic2$(O_EXT)
LINK_LIBBASIC3= $(LINK_LIBDIR)libstx_libbasic3$(O_EXT)
LINK_LIBHTML  = $(LINK_LIBDIR)libstx_libhtml$(O_EXT)
LINK_LIBCOMP  = $(LINK_LIBDIR)libstx_libcomp$(O_EXT)
LINK_LIBCOMPAT= $(LINK_LIBDIR)libstx_libcompat$(O_EXT)
LINK_LIBVIEW  = $(LINK_LIBDIR)libstx_libview$(O_EXT)
LINK_LIBVIEW2 = $(LINK_LIBDIR)libstx_libview2$(O_EXT)
LINK_LIBWIDG  = $(LINK_LIBDIR)libstx_libwidg$(O_EXT)
LINK_LIBWIDG2 = $(LINK_LIBDIR)libstx_libwidg2$(O_EXT)
LINK_LIBWIDG3 = $(LINK_LIBDIR)libstx_libwidg3$(O_EXT)
LINK_LIBTOOL  = $(LINK_LIBDIR)libstx_libtool$(O_EXT)
LINK_LIBTOOL2 = $(LINK_LIBDIR)libstx_libtool2$(O_EXT)
LINK_LIBTABLE = $(LINK_LIBDIR)libstx_libtable$(O_EXT)
LINK_LIBUI    = $(LINK_LIBDIR)libstx_libui$(O_EXT)
LINK_LIBDBASE = $(LINK_LIBDIR)libstx_goodies_libdbase$(O_EXT)
LINK_GOODIES  = $(LINK_LIBDIR)libstx_goodies$(O_EXT)
LINK_LIBOBJC  = $(LINK_LIBDIR)libstx_libobjc$(O_EXT)
LINK_SUNIT    = $(LINK_LIBDIR)libstx_goodies_sunit$(O_EXT)

LINK_LIBRB_HELPERS     = $(LINK_LIBDIR)libstx_goodies_refactoryBrowser_helpers$(O_EXT)
LINK_LIBRB_CHANGES     = $(LINK_LIBDIR)libstx_goodies_refactoryBrowser_changes$(O_EXT)
LINK_LIBRB_PARSER      = $(LINK_LIBDIR)libstx_goodies_refactoryBrowser_parser$(O_EXT)
LINK_LIBRB_REFACTORING = $(LINK_LIBDIR)libstx_goodies_refactoryBrowser_refactoring$(O_EXT)
LINK_LIBRB_BROWSER     = $(LINK_LIBDIR)libstx_goodies_refactoryBrowser_browser$(O_EXT)

LINK_LIBSCM_COMMON     = $(LINK_LIBDIR)libstx_libscm_common$(O_EXT)
LINK_LIBSCM_MERCURIAL  = $(LINK_LIBDIR)libstx_libscm_mercurial$(O_EXT)

LINK_LIBCPLUSPLUS= $(LINK_LIBDIR)libc++$(O_EXT)
LINK_LIBXT       = $(LINK_LIBDIR)libxt$(O_EXT)
LINK_LIBXM       = $(LINK_LIBDIR)libxm$(O_EXT)

STATIC_LIBRUN      = $(LIBRUNDIR)/librun$(A_EXT)
STATIC_LIBBASIC    = $(LIBBASICDIR)/libstx_libbasic$(STATIC_O_EXT)
STATIC_LIBBOSS     = $(LIBBOSSDIR)/libstx_libboss$(STATIC_O_EXT)
STATIC_LIBBASIC2   = $(LIBBASIC2DIR)/libstx_libbasic2$(STATIC_O_EXT)
STATIC_LIBBASIC3   = $(LIBBASIC3DIR)/libstx_libbasic3$(STATIC_O_EXT)
STATIC_LIBHTML     = $(LIBHTMLDIR)/libstx_libhtml$(STATIC_O_EXT)
STATIC_LIBCOMP     = $(LIBCOMPDIR)/libstx_libcomp$(STATIC_O_EXT)
STATIC_LIBCOMPAT   = $(LIBCOMPATDIR)/libstx_libcompat$(STATIC_O_EXT)
STATIC_LIBVIEW     = $(LIBVIEWDIR)/libstx_libview$(STATIC_O_EXT)
STATIC_LIBVIEW2    = $(LIBVIEW2DIR)/libstx_libview2$(STATIC_O_EXT)
STATIC_LIBWIDG     = $(LIBWIDGDIR)/libstx_libwidg$(STATIC_O_EXT)
STATIC_LIBWIDG2    = $(LIBWIDG2DIR)/libstx_libwidg2$(STATIC_O_EXT)
STATIC_LIBWIDG3    = $(LIBWIDG3DIR)/libstx_libwidg3$(STATIC_O_EXT)
STATIC_LIBTOOL     = $(LIBTOOLDIR)/libstx_libtool$(STATIC_O_EXT)
STATIC_LIBTOOL2    = $(LIBTOOL2DIR)/libstx_libtool2$(STATIC_O_EXT)
STATIC_LIBTABLE    = $(LIBTABLEDIR)/libstx_libtable$(STATIC_O_EXT)
STATIC_LIBUI       = $(LIBUIDIR)/libstx_libui$(STATIC_O_EXT)
STATIC_LIBDBASE    = $(LIBDBASEDIR)/libstx_goodies_libdbase$(STATIC_O_EXT)
STATIC_GOODIES     = $(GOODIESDIR)/libstx_goodies$(STATIC_O_EXT)
STATIC_LIBOBJC     = $(LIBOBJCDIR)/libstx_libobjc$(STATIC_O_EXT)
STATIC_SUNIT       = $(SUNITDIR)/libstx_goodies_sunit$(STATIC_O_EXT)

STATIC_LIBRB_HELPERS     = $(LIBRB_HELPERSDIR)/libstx_goodies_refactoryBrowser_helpers$(STATIC_O_EXT)
STATIC_LIBRB_CHANGES     = $(LIBRB_CHANGESDIR)/libstx_goodies_refactoryBrowser_changes$(STATIC_O_EXT)
STATIC_LIBRB_PARSER      = $(LIBRB_PARSERDIR)/libstx_goodies_refactoryBrowser_parser$(STATIC_O_EXT)
STATIC_LIBRB_REFACTORING = $(LIBRB_REFACTORINGDIR)/libstx_goodies_refactoryBrowser_refactoring$(STATIC_O_EXT)
STATIC_LIBRB_BROWSER     = $(LIBRB_BROWSERDIR)/libstx_goodies_refactoryBrowser_browser$(STATIC_O_EXT)

STATIC_LIBSCM_COMMON     = $(LIBSCM_COMMONDIR)/libstx_libscm_common$(STATIC_O_EXT)
STATIC_LIBSCM_MERCURIAL  = $(LIBSCM_MERCURIALDIR)/libstx_libscm_mercurial$(STATIC_O_EXT)

STATIC_LIBCPLUSPLUS= $(LIBCPLUSPLUSDIR)/libc++$(STATIC_O_EXT)
STATIC_LIBXT       = $(LIBXTDIR)/libxt$(STATIC_O_EXT)
STATIC_LIBXM       = $(LIBXMDIR)/libxm$(STATIC_O_EXT)

# -------------------------------------------
# various package lists (to link)
#
# depending on how the final target is linked,
# either the normal-classlibrary, the shared classlibrary
# or the sep-init libraries are used.
#
# +sepInit is no longer supported - so it may not work
# (no known configurations uses it currently)
# -------------------------------------------
REFACTORY_DIR        = $(LIBRB_HELPERSDIR) $(LIBRB_CHANGESDIR) $(LIBRB_REFACTORINGDIR) $(LIBRB_PARSERDIR) $(LIBRB_BROWSERDIR)
REFACTORY_LIB        = $(LIBRB_HELPERS) $(LIBRB_CHANGES) $(LIBRB_REFACTORING) $(LIBRB_PARSER) $(LIBRB_BROWSER)
REFACTORY_LIST       = libstx_goodies_refactoryBrowser_helpers libstx_goodies_refactoryBrowser_changes libstx_goodies_refactoryBrowser_refactoring libstx_goodies_refactoryBrowser_parser libstx_goodies_refactoryBrowser_browser
LINK_REFACTORY_LIB   = $(LINK_LIBRB_HELPERS) $(LINK_LIBRB_CHANGES) $(LINK_LIBRB_REFACTORING) $(LINK_LIBRB_PARSER) $(LINK_LIBRB_BROWSER)
STATIC_REFACTORY_LIB = $(STATIC_LIBRB_HELPERS) $(STATIC_LIBRB_CHANGES) $(STATIC_LIBRB_REFACTORING) $(STATIC_LIBRB_PARSER) $(STATIC_LIBRB_BROWSER)

SUNIT_DIR        = $(SUNITDIR)
SUNIT_LIB        = $(SUNIT)
SUNIT_LIST       = libstx_goodies_sunit
LINK_SUNIT_LIB   = $(LINK_SUNIT)
STATIC_SUNIT_LIB = $(STATIC_SUNIT)

LIBSCM_DIR        = $(LIBSCM_COMMONDIR) $(LIBSCM_MERCURIALDIR)
LIBSCM_LIB        = $(LIBSCM_COMMON) $(LIBSCM_MERCURIAL)
LIBSCM_LIST       = libstx_libscm_common libstx_libscm_mercurial
LINK_LIBSCM_LIB   = $(LINK_LIBSCM_COMMON) $(LINK_LIBSCM_MERCURIAL)
STATIC_LIBSCM_LIB = $(STATIC_LIBSCM_COMMON) $(STATIC_LIBSCM_MERCURIAL)

#
# barebones
#   absolute minimum - no compiler i.e. no rc files etc.
#
BARE_DIR        = $(LIBBASICDIR) $(PRIVATEOBJ)
BARE_RELDIR     = $(LIBBASIC_RELDIR)
BARE_LIB        = $(LIBBASIC) $(PRIVATEOBJ)
BARE_LIST       = libstx_libbasic $(PRIVATELIBS)
LINK_BARE_LIB   = $(LINK_LIBBASIC) $(LINK_PRIVATE)
STATIC_BARE_LIB = $(STATIC_LIBBASIC) $(STATIC_PRIVATE)

#
# minitalk (non GUI) uses this
#   minimum needed for non GUI applications
#
MINI_DIR        = $(BARE_DIR) $(LIBCOMPDIR)
MINI_RELDIR     = $(BARE_RELDIR) $(LIBCOMP_RELDIR)
MINI_LIB        = $(BARE_LIB) $(LIBCOMP)
MINI_LIST       = $(BARE_LIST) libstx_libcomp
LINK_MINI_LIB   = $(LINK_BARE_LIB) $(LINK_LIBCOMP)
STATIC_MINI_LIB = $(STATIC_BARE_LIB) $(STATIC_LIBCOMP)

#
# fundamental components
#   all that is needed for typical GUI applications
#
FUNDAMENTAL_DIR       = $(MINI_DIR) $(LIBBASIC2DIR) $(LIBVIEWDIR) $(LIBVIEW2DIR) $(LIBWIDGDIR) $(LIBWIDG2DIR) $(LIBUIDIR)
FUNDAMENTAL_RELDIR    = $(MINI_RELDIR) $(LIBBASIC2_RELDIR) $(LIBVIEW_RELDIR) $(LIBVIEW2_RELDIR) $(LIBWIDG_RELDIR) $(LIBWIDG2_RELDIR) $(LIBUI_RELDIR)
FUNDAMENTAL_LIB       = $(MINI_LIB) $(LIBBASIC2) $(LIBVIEW) $(LIBVIEW2) $(LIBWIDG) $(LIBWIDG2) $(LIBUI)
FUNDAMENTAL_LIST      = $(MINI_LIST) libstx_libbasic2 libstx_libview libstx_libview2 libstx_libwidg libstx_libwidg2 libstx_libui
LINK_FUNDAMENTAL_LIB  = $(LINK_MINI_LIB) $(LINK_LIBBASIC2) $(LINK_LIBVIEW) $(LINK_LIBVIEW2) $(LINK_LIBWIDG) $(LINK_LIBWIDG2) $(LINK_LIBUI)
STATIC_FUNDAMENTAL_LIB= $(STATIC_MINI_LIB) $(STATIC_LIBBASIC2) $(STATIC_LIBVIEW) $(STATIC_LIBVIEW2) $(STATIC_LIBWIDG) $(STATIC_LIBWIDG2) $(STATIC_LIBUI)

#
# development components
#   all that is needed for typical GUI applications PLUS development classes
#
DEVELOP_DIR        = $(FUNDAMENTAL_DIR) $(LIBBASIC3DIR) $(REFACTORY_DIR) $(LIBTOOLDIR) $(LIBSCM_DIR) $(SUNITDIR)
DEVELOP_RELDIR     = $(FUNDAMENTAL_RELDIR) $(LIBBASIC3_RELDIR) $(REFACTORY_RELDIR) $(LIBTOOL_RELDIR) $(LIBSCM_RELDIR) $(SUNIT_RELDIR)
DEVELOP_LIB        = $(FUNDAMENTAL_LIB) $(LIBBASIC3) $(REFACTORY_LIB) $(LIBTOOL) $(LIBSCM_LIB) $(SUNIT_LIB)
DEVELOP_LIST       = $(FUNDAMENTAL_LIST) libstx_libbasic3 $(REFACTORY_LIST) libstx_libtool $(LIBSCM_LIST) $(SUNIT_LIST)
LINK_DEVELOP_LIB   = $(LINK_FUNDAMENTAL_LIB) $(LINK_LIBBASIC3) $(LINK_REFACTORY_LIB) $(LINK_LIBTOOL) $(LINK_LIBSCM_LIB) $(LINK_SUNIT_LIB)
STATIC_DEVELOP_LIB = $(STATIC_FUNDAMENTAL_LIB) $(STATIC_LIBBASIC3) $(STATIC_REFACTORY_LIB) $(STATIC_LIBTOOL) $(STATIC_LIBSCM_LIB) $(STATIC_SUNIT_LIB)

#
# standard components
#   all that is needed for typical GUI applications PLUS development classes
#   PLUS persistency PLUS html stuff PLUS some less frequently used classes
#
STANDARD_DIR        = $(DEVELOP_DIR) $(LIBTOOL2DIR) $(LIBHTMLDIR) $(LIBBOSSDIR)
STANDARD_RELDIR     = $(DEVELOP_RELDIR) $(LIBTOOL2_RELDIR) $(LIBHTML_RELDIR) $(LIBBOSS_RELDIR)
STANDARD_LIB        = $(DEVELOP_LIB) $(LIBTOOL2) $(LIBHTML) $(LIBBOSS) $(ADDITIONAL_STANDARD_LIB)
STANDARD_LIST       = $(DEVELOP_LIST) libstx_libtool2 libstx_libhtml libstx_libboss $(ADDITIONAL_STANDARD_LIST)
LINK_STANDARD_LIB   = $(LINK_DEVELOP_LIB) $(LINK_LIBTOOL2) $(LINK_LIBHTML) $(LINK_LIBBOSS) $(ADDITIONAL_LINK_STANDARD_LIB)
STATIC_STANDARD_LIB = $(STATIC_DEVELOP_LIB) $(STATIC_LIBTOOL2) $(STATIC_LIBHTML) $(STATIC_LIBBOSS) $(ADDITIONAL_STATIC_STANDARD_LIB)


#
# all components
#   also includes very seldom used additional widgets
#
EXTENDED_DIR        = $(STANDARD_DIR) $(LIBTABLEDIR) $(LIBWIDG3DIR) $(LIBDBASEDIR) $(LIBCOMPATDIR)
EXTENDED_RELDIR     = $(STANDARD_RELDIR) $(LIBTABLE_RELDIR) $(LIBWIDG3_RELDIR) $(LIBDBASE_RELDIR) $(LIBCOMPAT_RELDIR)
EXTENDED_LIB        = $(STANDARD_LIB) $(LIBTABLE) $(LIBWIDG3) $(LIBDBASE) $(LIBCOMPAT)
EXTENDED_LIST       = $(STANDARD_LIST) libstx_libtable libstx_libwidg3 libstx_goodies_libdbase libstx_libcompat
LINK_EXTENDED_LIB   = $(LINK_STANDARD_LIB) $(LINK_LIBTABLE) $(LINK_LIBWIDG3) $(LINK_LIBDBASE) $(LINK_LIBCOMPAT)
STATIC_EXTENDED_LIB = $(STATIC_STANDARD_LIB) $(STATIC_LIBTABLE) $(STATIC_LIBWIDG3) $(STATIC_LIBDBASE) $(STATIC_LIBCOMPAT)

# -------------------------------------------
# default class package list
# -------------------------------------------
#
# should make all libs req'd by Smalltalk
#
CLASSLIBDIRS     = $(STANDARD_DIR)
CLASSLIB_RELDIRS = $(STANDARD_RELDIR)

LIBOBJS        = $(STANDARD_LIB)
LINK_LIBOBJS   = $(LINK_STANDARD_LIB)
LIBLIST        = $(STANDARD_LIST)
STATIC_LIBLIST = $(LIBLIST)
LINKLIST       = $(LINK_STANDARD_LIB)

#
# those are set to the default values
# (in case no STATIC_ defs are found in a PACKS file)
#
STATIC_OBJS               = $(LINK_OBJS)
STATIC_LIBOBJS            = $(LIBOBJS)
STATIC_ADDITIONAL_OBJS    = $(ADDITIONAL_OBJS)
STATIC_ADDITIONAL_CLASSES = $(ADDITIONAL_CLASSES)
STATIC_EXTRA_OBJ          = $(EXTRA_OBJ)
STATIC_EXTRA_UI_OBJ       = $(EXTRA_UI_OBJ)
LINK_ADDITIONAL_OBJS      = $(ADDITIONAL_OBJS)


# --------------------------------------
# system and other (non-class) libraries
# --------------------------------------

#
# X11 Libraries (X, Xext, Xft and Xinerama)
#
XDEFS    = -DSHAPE
XINCLUDE = $(shell pkg-config --cflags x11 xext)
LIB_X    = $(shell pkg-config --libs   x11 xext)

ifeq (yes, $(shell if pkg-config --exists xft; then echo "yes"; else echo "no"; fi))
XDEFS    += -DXFT -DHAVE_FONTCONFIG
XINCLUDE +=$(shell pkg-config --cflags xft)
LIB_XFT   =$(shell pkg-config --libs   xft)
endif

ifeq (yes, $(shell if pkg-config --exists xinerama; then echo "yes"; else echo "no"; fi))
XDEFS    += -DXINERAMA
XINCLUDE +=$(shell pkg-config --cflags xinerama)
LIB_XINERAMA=$(shell pkg-config --libs xinerama)
endif



# used with sparc only:
# OSI-ACSE library
# redefined to non-empty in sparc config
LIB_OSINET_APLI=
LIB_OSINET_OSI=

WHICH_ODBC=unixodbc

OPTIONAL_LIBS= \
	$(OPTIONAL_LIBXM) \
	$(OPTIONAL_LIBXAW) \
	$(OPTIONAL_LIBXMU) \
	$(OPTIONAL_LIBXT)

MATHLIB     = -lm
SYSLIBS     = \
	$(OTHERLIBS1) \
	$(OPTIONAL_LIBS) \
	$(OTHERLIBS2) \
	$(MATHLIB)

OTHERLIBS1  =
OTHERLIBS2  = $(OTHERLIBS)


STATIC_OPTIONAL_LIBS= \
	$(STATIC_OPTIONAL_LIBXM) \
	$(STATIC_OPTIONAL_LIBXAW) \
	$(STATIC_OPTIONAL_LIBXMU) \
	$(STATIC_OPTIONAL_LIBXT)

STATIC_MATHLIB=/usr/lib/libm.a
STATIC_SYSLIBS     = \
	$(STATIC_OTHERLIBS1) \
	$(STATIC_OPTIONAL_LIBS) \
	$(STATIC_LIBXEXT) $(STATIC_LIBX) \
	$(STATIC_OTHERLIBS2) \
	$(STATIC_MATHLIB)
STATIC_OTHERLIBS1  = $(OTHERLIBS1)
STATIC_OTHERLIBS2  = $(OTHERLIBS2)

SUPPORT_DIR=$(TOP)/support

#
# the makefile to use when building the db1.6 library
#
MAKEFILE_DB  = Makefile.$(MAKEFILE_EXTENSION)

#
# the CTAGS command (for ca's CBrowser, taglist in Filebrowser and cg's STXGDB)
#
#CTAGS_VSN=ctags-3.2.2
CTAGS_VSN=ctags-5.8
CTAGS_DIR=$(TOP)/support/tools/$(CTAGS_VSN)
# CTAGS=$(CTAGS_DIR)/ctags

#
# the CSCOPE command (for cg's STXGDB)
#
CSCOPE_VSN=cscope-15.8a
CSCOPE_DIR=$(TOP)/support/tools/$(CSCOPE_VSN)
# CSCOPE=$(CSCOPE_DIR)/cscope

#
# the SPLINT command (for cg's STXGDB)
#
SPLINT_VSN=splint-3.1.2
SPLINT_DIR=$(TOP)/support/tools/$(SPLINT_VSN)
# SPLINT=$(SPLINT_DIR)/cscope

# --------------------------------------------------
# the MSQL library
#
# those may be redefined in an architecture specific
# defines file, to whereever the stuff is found
#
MSQLDIR=$(TOP)/support/msql/msql-1.0.14

MSQL_INCLUDE_DIR=$(MSQLDIR)/include
MSQL_LIB_DIR=$(MSQLDIR)/lib

#MSQL_INCLUDE_DIR=/usr/local/include
#MSQL_LIB_DIR=/usr/local/lib

# --------------------------------------------------
# The netsnmp library
#
# if already in /usr/lib:
# DYNAMIC_LINK_LIB_NETSNMP=-lnetsnmp
# STATIC_LINK_LIB_NETSNMP=
# TARGET_LIB_NETSNMP=
#
# if a local one should be built and used:
# DYNAMIC_LINK_LIB_NETSNMP=
# STATIC_LINK_LIB_NETSNMP=-L$(NETSNMP_LIBDIR) -L$(NETSNMP_LIBDIR)/.libs $(NETSNMP_LIBDIR)/.libs/libnetsnmp.a
# TARGET_LIB_NETSNMP=$(NETSNMP_LIBDIR)/.libs/libnetsnmp.a

# to not build libsnmp, comment this (or redefine as empty)
ARCH_LIBSNMP=libsnmp

# --------------------------------------------------
#
# the GNU dld library (only works with linux-aout)
#
# has to be explicitely added in the defines file,
# by defining
#       OPTIONAL_LIBDL_TARGET= libdld ...
#       EXTRA_LIBS= ... $(LIB_DLD) ...
# and
#       DLINCLUDE=$(DLD_DIR)
#       DLDEFS= ... -DDLD -I$(DLD_DIR) ...
#
#DLD_REL_DIR  =DLD/dld-3.2.5
DLD_REL_DIR  =dld-3.2.5
DLD_DIR      =$(SUPPORT_DIR)/DLD/$(DLD_REL_DIR)
LIB_DLD      =$(DLD_DIR)/libdld.a
LIB_DLD_SO   =$(DLD_DIR)/libdld$(SO_NAME)
MAKEFILE_DLD =Makefile.$(MAKEFILE_EXTENSION)

# --------------------------------------------------
#
# the gnu BFD binary loader library (not working & EXPERIMENTAL)
#
# has to be explicitely added in the defines file,
# by defining
#       OPTIONAL_LIBDL_TARGET= libbfd
#       EXTRA_LIBS= ... $(LIB_BFD) ...
# and
#       DLINCLUDE=$(BFD_DIR)
#       DLDEFS= ... -DBFD -I$(BFD_DIR) ...
#
#BFD_REL_DIR    =DLD/binutils/bfd
BFD_REL_DIR    =binutils/bfd
BFD_DIR        =$(SUPPORT_DIR)/DLD/$(BFD_REL_DIR)
LIB_BFD        =$(BFD_DIR)/libbfd.a
LIB_BFD_SO     =$(BFD_DIR)/libbfd$(SO_NAME)
MAKEFILE_BFD   =Makefile.$(MAKEFILE_EXTENSION)

# --------------------------------------------------
#
# the dl1.6 COFF loader library (not working & EXPERIMENTAL)
#
# has to be explicitely added in the defines file,
# by defining
#       LIBRUN_EXTRA= ... libdl1_6 ...
#       EXTRA_LIBS= ... $(LIB_DL1_6) ...
# and
#       DLINCLUDE=$(DL1_6_DIR)
#       DLDEFS= ... -DDL1_6 -I$(DLD_DIR) ...
#
#DL1_6_REL_DIR=DLD/dl-1.6
DL1_6_REL_DIR=dl-1.6
DL1_6_DIR    =$(SUPPORT_DIR)/DLD/$(DL1_6_REL_DIR)
LIB_DL1_6    =$(DL1_6_DIR)/libdl.a
LIB_DL1_6_SO =$(DL1_6_DIR)/libdl$(SO_NAME)
MAKEFILE_DL1_6 =Makefile.$(MAKEFILE_EXTENSION)

DLLIB=
DLLIB_SO=
#
# in a vendor configuration, add:
#    DLLIB=$(LIB_DLD)
#    DLLIB_SO=$(LIB_DLD_SO)

#
# additional libs
# undefined elsewhere - should be defined where used, instead of undefined where not
#
ML_LD_OBJ_LIBS=-Lml/lib -lmxlin260 -L/usr/lib -lusb

#
# possible extra arch-specific libraries to be linked in the ld -r pass
#
LD_REL_OBJ_LIBS=

MAKEFILE_SUBX=Makefile.$(MAKEFILE_EXTENSION)

#
# extra targets made in support (old: librun) / libview
#
SUPPORT_EXTRA_TARGETS=$(OPTIONAL_LIBDL_TARGET)

LIBVIEW_EXTRA_TARGETS=

#
# extra asm file in librun
#
LIBRUN_MORE=asmhelp.o

#
# classes from individual objects (not in library-packages)
#
#
# EXTRA_UI_CLASSES    = $(WORKSTAT1) $(WORKSTAT2)
# EXTRA_UI_OBJ        = $(OPTIONAL_XWORKSTATION_OBJ) $(OPTIONAL_GLXWORKSTATION_OBJ)
# STATIC_EXTRA_UI_OBJ = $(STATIC_OPTIONAL_XWORKSTATION_OBJ) $(STATIC_OPTIONAL_GLXWORKSTATION_OBJ)
# EXTRA_LINK_UI_OBJ   = $(OPTIONAL_LINK_XWORKSTATION_OBJ) $(OPTIONAL_LINK_GLXWORKSTATION_OBJ)

#
# default display classes
#
# these are reset in the Make.proto (or PACK-config), as desired
#
WORKSTAT1=XWorkstation
WORKSTAT2=GLXWorkstation

OPTIONAL_XWORKSTATION_OBJ=$(LIBVIEWDIR)/XWorkstation$(BIN_O)
OPTIONAL_GLXWORKSTATION_OBJ=$(LIBVIEWDIR)/GLXWorkstation$(BIN_O)
OPTIONAL_OPENGLWORKSTATION_OBJ=$(LIBVIEWDIR)/OGLWorkstation$(BIN_O)
OPTIONAL_WINWORKSTATION_OBJ=$(LIBVIEWDIR)/WinWorkstation$(BIN_O)
OPTIONAL_NXWORKSTATION_OBJ=$(LIBVIEWDIR)/NXWorkstation$(BIN_O)

# STATIC_OPTIONAL_XWORKSTATION_OBJ=$(LIBVIEWDIR)/XWorkstation$(STATIC_O_EXT)
# STATIC_OPTIONAL_GLXWORKSTATION_OBJ=$(LIBVIEWDIR)/GLXWorkstation$(STATIC_O_EXT)
STATIC_OPTIONAL_WINWORKSTATION_OBJ=$(LIBVIEWDIR)/WinWorkstation$(STATIC_O_EXT)
STATIC_OPTIONAL_NXWORKSTATION_OBJ=$(LIBVIEWDIR)/NXWorkstation$(STATIC_O_EXT)

# OPTIONAL_LINK_XWORKSTATION_OBJ=$(LINK_LIBDIR)XWorkstation$(BIN_O)
# OPTIONAL_LINK_GLXWORKSTATION_OBJ=$(LINK_LIBDIR)GLXWorkstation$(BIN_O)
OPTIONAL_LINK_OPENGLWORKSTATION_OBJ=$(LINK_LIBDIR)OGLWorkstation$(BIN_O)
OPTIONAL_LINK_WINWORKSTATION_OBJ=$(LINK_LIBDIR)WinWorkstation$(BIN_O)
OPTIONAL_LINK_NXWORKSTATION_OBJ=$(LINK_LIBDIR)NXWorkstation$(BIN_O)

# misc optional stuff
#
# these are set in the Make.proto (or PACKS) config, to include those libs
# or left undefined, to exclude them.
# The concrete libs (for example gl vs. vgl) are set in the architecture
# specific configurations.

OPTIONAL_LIBOPENGL_TARGET=
OPTIONAL_OPENGL_LIB=
STATIC_OPTIONAL_OPENGL_LIB=$(OPTIONAL_OPENGL_LIB)
OPTIONAL_LINK_OPENGL_LIB=

OPTIONAL_DL_LIB=
STATIC_OPTIONAL_DL_LIB=$(OPTIONAL_DL_LIB)
OPTIONAL_LINK_DL_LIB=


# to get an ObjectFileLoader,
# you have to decide which dynamic load facility to use;
# for sys5.4 like dlopen, add to the architecture config:
#
#    OPTIONAL_LIBDL_TARGET=
#    OPTIONAL_DL_LIB=-ldl
#
# for GNU dld3.2.5, add to the architecture config:
#
#    OPTIONAL_LIBDL_TARGET=libdld
#    OPTIONAL_DL_LIB=$(LIB_DLD)
#    DLDEFS=-DGNU_DL -I$(DLD_DIR)
#
# for GNU BFD loading (which does not work yet):
#
#    OPTIONAL_LIBDL_TARGET=libbfd
#    OPTIONAL_DL_LIB=$(LIB_BFD)
#    DLDEFS=-DBFD_DL -I$(BFD_DIR)


#extra user C-libraries
EXTRA_C_LIBS=

#EXTRA_LIBS=\
#       $(OPTIONAL_GL_LIB) \
#       $(OPTIONAL_OPENGL_LIB) \
#       $(OPTIONAL_DL_LIB) \
#       $(EXTRA_C_LIBS)

EXTRA_LIBS=\
	$(OPTIONAL_DL_LIB) \
	$(EXTRA_C_LIBS)

#STATIC_EXTRA_LIBS=\
#       $(STATIC_OPTIONAL_GL_LIB) \
#       $(STATIC_OPTIONAL_OPENGL_LIB) \
#       $(STATIC_OPTIONAL_DL_LIB) \
#       $(EXTRA_C_LIBS)

STATIC_EXTRA_LIBS=\
	$(STATIC_OPTIONAL_DL_LIB) \
	$(EXTRA_C_LIBS)

#EXTRA_LINK_LIBS=\
#       $(OPTIONAL_LINK_GL_LIB) \
#       $(OPTIONAL_LINK_OPENGL_LIB) \
#       $(OPTIONAL_LINK_DL_LIB) \
#       $(EXTRA_C_LIBS)

EXTRA_LINK_LIBS=\
	$(OPTIONAL_LINK_DL_LIB) \
	$(EXTRA_C_LIBS)

# -------------
# default rules
# -------------

# rule to generate a self-installing deployable
# setup is for backward compatibility;
# see linux*/COMMON/defines
# and mac/COMMON/defines
SETUP_RULE=setup

#
# rule (from stdRules) for library building
#
OBJTARGET=obj$(TARGET_RULE_EXTENSION)
LIBTARGET=all
LIBRUNTARGET=librun.$(A)

#
# rule for target building
# TARGET_RULE_EXTENSION will be appended.
#
# Note that static linking (_static) might weel be unsupported
#
#TARGET_RULE_EXTENSION=_static
TARGET_RULE_EXTENSION=_shared
TARGET=stx

# -------------
# default flags
# -------------

# collected compiler flags

ASFLAGS=

#
# rule hooks for vendor specific rules
#

PRE_LD_ACTION=emptyRule
POST_LD_ACTION=emptyRule


BIG_STFILE_RULE=__NORMAL_RULE__
VERYBIG_STFILE_RULE=__NORMAL_RULE__
LONGNAME_RULE=__NORMAL_RULE__

__NORMAL_RULE__:
	$(MAKE) $(O_RULE) STFILE=$(BIG_FILE) CC="$(CC)" STC_OPT="$(STC_OPT)" OPT="$(OPT)" SEPINITCODE="$(SEPINITCODE)" XDEFS="$(XDEFS)"


#------------------ end of COMMON/defines ---------------------
