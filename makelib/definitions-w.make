#
# $Header: /cvs/stx/stx/rules/stdHeader_bc,v 1.197 2017-06-14 13:36:25 cg Exp $
#
# MIMEType: application/x-make
# EOLMode: msdos
#
# The name of this rules file is now misleading; it used to be used only for
# borland, but now also contains visualC and other compiler definitions.
# actually, it is used for all Windows builds.
#
# defaults to borland-build (USEBC=1), unless invoked with any of:
#   USEVC=1      - visualC-make
#   USELCC=1     - lcc make       (suspended work - unfinished)
#   USETCC=1     - tiny-C (tcc)   (suspended work - unfinished)
#   USEMINGW64=1 - mingw-C        (ongoing work)

!ifndef BUILD_TARGET
! ifdef USEMINGW32
BUILD_TARGET = i686-pc-mingw32
! else
!  ifdef USEMINGW64
BUILD_TARGET = x86_64-w64-mingw32
!  else
BUILD_TARGET = unknown-unknown-unknown
!  endif
! endif
!endif


!ifdef USEVC
! undef USEBC
!endif

# use borland-cc by default
!ifndef USEBC
! ifndef USEVC
!  ifndef USELCC
!   ifndef USETCC
!    ifndef USEMINGW32
!     ifndef USEMINGW64
USEBC=1
!     endif
!    endif
!   endif
!  endif
! endif
!endif

MAKENSIS=makensis
MAKENSIS=c:\programme\nsis\makensis
MAKENSIS="$(PROGRAMFILES)\nsis\makensis.exe"

#STC_MSGFORMAT= -messageFormat: gcc
STC_MSGFORMAT= -messageFormat: gcc-jenkins

COMMONSYMBOLS=+commonSymbols

# uncomment this, if the stc compiled C files should be kept for debugging
# KEEPCFILE=1

# borland cbuilder version
CBUILDER5=1
#CBUILDER6=1

!ifdef WINVER_5
IPHLPAPI_LIB=iphlpapi.lib
!else
IPHLPAPI_LIB=
!endif

# all compiler specific libs are now under lib (used to be at top level)
LIBDIR_PARENT=lib

#
# extensions
#
O=obj
H=STH
RES=res

MAKE=make.exe

!ifdef USEBC

# ----------------
# Borland C
# ----------------

# LIBDIR: final destination directory for lib's lib\bc, lib\vc, lib\lcc etc.
# OUTDIR: temporary output directory (path) .\objbc\ .\objvc\ .\objlc\
# OBJDIR: name of object directory (not path) - objbc, objvc or objlc
LIBDIR_NAME=$(LIBDIR_PARENT)\bc
LIBDIR=$(TOP)\$(LIBDIR_NAME)
LIBDIR_LIBRUN=$(LIBDIR)
OBJDIR=objbc
OBJDIR_LIBRUN=$(OBJDIR)
OUTDIR=objbc\\

# the stxc32i is a stripped down version
# of the original cw32i for CBuilder3
#
# cs32i is for CBuilder4
#
# CAUTION:
# We need special build borland libraries for STX/X,
# (they have to be linked to a different base address).
# Look into support\win32\borland\not_delivered for more information
# and build procedures. The generated libraries are in support\win32\borland.

# CBUILDER5
# RT_LIB = cs32mt.lib
# The libraries from BCC 5.1 have not yet been adapted,
# don't use them!
#RT_LIB = cw32i.lib
#RT_DLL = cc3250.dll

# Use libraries from BCC 4
RT_LIB = cs32i.lib
RT_DLL = cs3245.dll

X11_DLL  = X11.dll
XEXT_DLL = Xext.dll

#
# where are the bctools ?
#
! ifndef BCB
# BCB = $(MAKEDIR)\..
BCB=c:\Borland\bcc55
! endif


# FOR BORLAND default (as installed, in path)
# CC=bcc32.exe
# RC=brcc32 -DWIN32
# LINK32=ilink32.exe

# FOR BORLAND 5.5 (CBuilder5, free command line tools)
# BCB=c:\Borland\bcc55

# FOR BORLAND 5.6 (CBuilder6)
# BCB=c:\Borland\bcc56

CC=$(BCB)\bin\bcc32.exe
RC=$(BCB)\bin\brcc32 -DWIN32
LINK32=$(BCB)\bin\ilink32.exe
LIB32=$(BCB)\bin\tlib.exe
AS=tasm32.exe
MAKE_BAT=bmake
USE_ARG=-DUSEBC
APP_LINKER=$(LINK32)
# APP_LFLAGS = -L$(LIBDIR);$(BCB)\lib;$(DEBUGLIBPATH) -H:0x400000 -Hc:0x100000 -S:0x40000 -Sc:0x10000 -ap -Tpe -x -Gn -v -Ao:0x10000
APP_LFLAGS = -L$(LIBDIR);$(BCB)\lib -S:0x40000 -Sc:0x10000 -Tpe -x -Gn -v -Ao:0x10000
APP_RT_LIB=
APP_IMPORTLIBS=import32.lib
CRT_STARTUP_CONSOLE=c0x32.obj
CRT_STARTUP_NOCONSOLE=c0w32.obj
LFLAGS_CONSOLE=-ap
LFLAGS_NOCONSOLE=-aa

!else
! ifdef USEVC

# ----------------
# MS visual c
# ----------------

# !MESSAGE WINDOWSSDKDIR is $(WINDOWSSDKDIR)
# !MESSAGE VSINSTALLDIR is $(VSINSTALLDIR)

LIBDIR_NAME=$(LIBDIR_PARENT)\vc
LIBDIR=$(TOP)\$(LIBDIR_NAME)
# LIBDIR=$(TOP)\librun\Debug
LIBDIR_LIBRUN=$(LIBDIR)
OBJDIR=objvc
OBJDIR_LIBRUN=$(OBJDIR)
OUTDIR=objvc\\

!   if "$(WINDOWSSDKDIR)x" == "x"

SDK6=$(PROGRAMS)\Microsoft SDKs\Windows\v6.0A
SDK70a=$(PROGRAMS)\Microsoft SDKs\Windows\v7.0A
SDK70a_x86=$(PROGRAMS86)\Microsoft SDKs\Windows\v7.0A
SDK71=$(PROGRAMS)\Microsoft SDKs\Windows\v7.1
SDK71_x86=$(PROGRAMS86)\Microsoft SDKs\Windows\v7.1

SDK=$(SDK71_x86)\\
SDK=$(SDK70a_x86)\\


!MESSAGE WINDOWSSDKDIR not set; assuming $(SDK)...

!   else

SDK=$(WINDOWSSDKDIR)

!   endif

!   if "$(VSINSTALLDIR)x" == "x"
!ERROR VSINSTALLDIR not set. Please call the appropriate setup script (typically: C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\vcvars32.bat)
# VSINSTDIR=%ProgramFiles%\Microsoft Visual Studio 8\\
# VSINSTDIR=%ProgramFiles%\Microsoft Visual Studio 9.0\\
VSINSTDIR=%ProgramFiles%\Microsoft Visual Studio 10.0\\

!   else

VSINSTDIR=$(VSINSTALLDIR)

!   endif

VCINSTALLDIR=$(VSINSTDIR)VC
VCBINDIR=$(VCINSTALLDIR)\bin\\
VCLIBDIR=$(VCINSTALLDIR)\lib\\

VS80COMNTOOLS=$(VSINSTDIR)Common7\Tools\\
WINDOWSKIT=c:\Program Files (x86)\Windows Kits\10\Include\10.0.10150.0\ucrt
INCLUDE_WINDOWSKIT=-I"$(WINDOWSKIT)"

# VCBINDIR=
LINK32="$(VCBINDIR)link.exe"
CC="$(VCBINDIR)cl.exe"
LIB32="$(VCBINDIR)lib.exe"
MAKE_BAT=vcmake
MAKE=make.exe
USE_ARG=-DUSEVC
RC="$(SDK)bin\rc.exe"
APP_LINKER=$(LINK32)
CRT_STARTUP_CONSOLE=
CRT_STARTUP_NOCONSOLE=
LFLAGS_CONSOLE=/nologo /DEBUG /DYNAMICBASE:NO /MACHINE:X86 /ERRORREPORT:PROMPT
LFLAGS_NOCONSOLE=/nologo /DEBUG /DYNAMICBASE:NO /MACHINE:X86 /ERRORREPORT:PROMPT
APP_RT_LIB=
APP_IMPORTLIBS=kernel32.lib

! else
!  ifdef USELCC

# ------------
# lcc compiler
# ------------
LIBDIR_NAME=$(LIBDIR_PARENT)\lcc
LIBDIR=$(TOP)\$(LIBDIR_NAME)
LIBDIR_LIBRUN=$(TOP)\$(LIBDIR_PARENT)\vc
LIBDIR_LIBRUN=$(LIBDIR)
OBJDIR=objlcc
OBJDIR_LIBRUN=objvc
OUTDIR=objlcc\\

LCCDIR=c:\lcc
LCCBINDIR=$(LCCDIR)\bin
CC=$(LCCBINDIR)\lcc.exe
RC=$(LCCBINDIR)\lrc
LINK32=$(LCCBINDIR)\lcclnk.exe
LINK32_DLL=$(LCCBINDIR)\lcclnk.exe
MAKE_BAT=lccmake
USE_ARG=-DUSELCC
APP_LINKER=$(LINK32)
# APP_LFLAGS = -L$(LIBDIR);$(BCB)\lib;$(DEBUGLIBPATH) -H:0x400000 -Hc:0x100000 -S:0x40000 -Sc:0x10000 -ap -Tpe -x -Gn -v -Ao:0x10000
CRT_STARTUP_CONSOLE=
CRT_STARTUP_NOCONSOLE=
LFLAGS_DLL=-dll
LFLAGS_CONSOLE=
LFLAGS_NOCONSOLE=
APP_RT_LIB=
APP_IMPORTLIBS=kernel32.lib

!  else
!   ifdef USETCC

# ------------
# tcc compiler
# ------------
O=o

LIBDIR_NAME=$(LIBDIR_PARENT)\tcc
LIBDIR=$(TOP)\$(LIBDIR_NAME)
# LIBDIR=$(TOP)\librun\Debug
LIBDIR_LIBRUN=$(TOP)\$(LIBDIR_PARENT)\vc
OBJDIR=objtcc
OBJDIR_LIBRUN=objvc
OUTDIR=objtcc\\

TCCDIR=$(TOP)\support\tcc
CC=$(TCCDIR)\tcc.exe
LINK32=$(TCCDIR)\tcc.exe
MAKE_BAT=tccmake
USE_ARG=-DUSETCC
APP_LINKER=$(LINK32)
# APP_LFLAGS = -L$(LIBDIR);$(BCB)\lib;$(DEBUGLIBPATH) -H:0x400000 -Hc:0x100000 -S:0x40000 -Sc:0x10000 -ap -Tpe -x -Gn -v -Ao:0x10000
CRT_STARTUP_CONSOLE=
CRT_STARTUP_NOCONSOLE=
LFLAGS_CONSOLE=
LFLAGS_NOCONSOLE=
APP_RT_LIB=
APP_IMPORTLIBS=kernel32.lib

!   else
!    if defined(USEMINGW32) || defined(USEMINGW64)

# ------------
# mingw gcc compiler
# ------------

LIBDIR_NAME=$(LIBDIR_PARENT)\mingw
LIBDIR=$(TOP)\$(LIBDIR_NAME)
# LIBDIR=$(TOP)\librun\Debug
LIBDIR_LIBRUN=$(TOP)\$(LIBDIR_PARENT)\mingw
OBJDIR=objmingw
OBJDIR_LIBRUN=objmingw
OUTDIR=objmingw/


!     ifndef MINGW_DIR
	echo "MINGW_DIR is not set"
MINGW_DIR="C:\\MINGW"
!     endif

# do not quote here;
# must already be quoted in the shell-env, if it contains spaces (program files\...)
MINGWDIR=$(MINGW_DIR)
MINGWBINDIR=$(MINGWDIR)\bin
MINGWLIBDIR=$(MINGWDIR)\lib

CC=$(MINGWBINDIR)\gcc.exe
# LINK32=$(MINGWBINDIR)\ld.exe
LINK32=$(CC)
LINK32_DLL=$(CC)
MAKE_BAT=mingwmake
RC=$(MINGWBINDIR)\windres
RFLAGS=
RES=$(O)
APP_LINKER=$(CC)
STRIP=$(MINGWBINDIR)\strip.exe
OBJCOPY=$(MINGWBINDIR)\objcopy.exe

!    if defined(USEMINGW32)
USE_ARG=-DUSEMINGW32=1
!    else
USE_ARG=-DUSEMINGW64=1
!    endif

# the following generates a correct exe, but with console!
CRT_STARTUP_CONSOLE=
CRT_STARTUP_NOCONSOLE=

LFLAGS_DLL=-g -shared
# -L$(MINGWDIR)\lib
LFLAGS_CONSOLE=-g
# -L$(MINGWDIR)\lib
LFLAGS_NOCONSOLE=-g -mwindows
# -L$(MINGWDIR)\lib
APP_RT_LIB=
#APP_IMPORTLIBS=$(MINGWLIBDIR)\libkernel32.a
APP_IMPORTLIBS=



!    else
error error error
!    endif
!   endif
!  endif
! endif
!endif

#slashified OUTDIR, because MIGNW does not handle backslashes correctly in a response file (sigh)
!if defined(USEMINGW32) || defined(USEMINGW64)
OUTDIR_SLASH=objmingw/
!else
OUTDIR_SLASH=$(OUTDIR)
!endif

STC_BINDIR=$(TOP)\stc
GENDATE_UTILITY=$(TOP)\librun\genDate.com

#
# give disjount base addresses
# (its not fatal, if libs overlap;
#  however, startup time and sharability are affected if they do ...)
#

LIBORACLE_BASE            =0x03d00000
LIBJAVA_BASE              =0x04000000
LIBOPENGL_BASE            =0x04400000


WORKFLOW_BASE             =0x66000000
#                              680000
#                              7fffff
EXPECCO_BASE              =0x67000000
#                              807000
#                              dfffff
EXPECCOREPORT_BASE        =0x67e00000
#                               69000
#                               fffff
EXPECCOSTORAGE_BASE       =0x67f00000
#                               4C000
#                               7ffff
EXEPT_PDF_BASE            =0x67f80000
#                               55000
#                               dffff
EXEPT_SIGNEDZIP_BASE      =0x67fe0000
#                                E000
#                               1ffff

DAPASX_BASE               =0x66000000

LIBRUN_BASE               =0x69000000
#                              181000
#                              2FFFFF
LIBSOAP_BASE              =0x69300000
#                               98000
#                               fffff     space
#                               fffff     end-addr
GOODIES_NET_BASE          =0x69400000
#                               E7000
#                              1fffff     space
#                              5fffff     end-addr
GOODIES_AUTH_BASE         =0x69600000
#                               12000
#                               3ffff     space
#                               3ffff     end-addr
# **FREE**                =0x69640000
#
#                               3ffff     space
#                               7ffff     end-addr
GOODIES_POSTSCRIPT_BASE   =0x69680000
#                               2A000
#                               3ffff     space
#                               Bffff     end-addr
GOODIES_RDOIT_BASE        =0x696C0000
#                               17000
#                               3ffff     space
#                               fffff     end-addr
GOODIES_COMM_BASE         =0x69700000
#                               E1000
#                              1fffff     space
#                              8fffff     end-addr
LIBCOMPAT_BASE            =0x69900000
#                               4a000
#                               fffff     space
#                               fffff     end-addr
# **FREE**                =0x69A00000
#
#                              5fffff     space
#                              Ffffff     end-addr

LIBBASIC_BASE             =0x6A000000
#                              52b000
#                              bfffff     space
LIBOSI_ASN1_BASE          =0x6AC00000
#                               b7000
#                               fffff     space
#                               fffff     end-addr
LIBCRYPT_BASE             =0x6AD00000
#                               7B000
#                               fffff     space
#                               fffff     end-addr
LIBBASIC3_BASE            =0x6AE00000
#                               b2000
#                              1fffff     space
#                              Ffffff     end-addr
LIBVIEW_BASE              =0x6B000000
#                              25d000     used
#                              6fffff     space
#                              6fffff     end-addr
LIBVIEW2_BASE             =0x6B700000
#                              13e000
#                              2fffff     space
#                              9fffff     end-addr
LIBCOMP_BASE              =0x6BA00000
#                              138000
#                              2fffff     space
#                              cfffff     end-addr
LIBBASIC2_BASE            =0x6BD00000
#                               cd000
#                              1fffff     space
#                              efffff     end-addr
LIBHTMLTREE_BASE          =0x6BF00000
#                               ba000
#                               fffff     space
#                              Ffffff     end-addr

LIBTOOL_BASE              =0x6C000000
#                              623000     used
#                              Bfffff     space
#                              Bfffff     end-addr
LIBTOOL2_BASE             =0x6CC00000
#                              12c000     used
#                              3fffff     space
#                              Ffffff     end-addr

LIBWIDG_BASE              =0x6D000000
#                              1f8000
#                              4fffff
LIBWIDG2_BASE             =0x6D500000
#                              18a000
#                              7fffff
LIBWEBSERVER_BASE         =0x6D800000
#                              15c000
#                              3fffff
#                              Bfffff
LIBWIDG3_BASE             =0x6DC00000
#                               18000
#                               3ffff
WINWORKSTAT_BASE          =0x6DC40000
#                               44000
#                               fffff
XWORKSTAT_BASE            =0x6DD00000
#                               3F000
#                               fffff
LIBUI_BASE                =0x6DE00000
#                               c4000
#                              1fffff
#                              Ffffff

LIBREGEX_BASE             =0x6E800000
#                               42000
#                               7ffff
LIBXMLSTX_BASE            =0x6E880000
#                               16000
#                               3FFFF
#                               bffff
LIBSOAP_XMLSIG_BASE       =0x6E8C0000
#                               17000
#                               3FFFF
#                               fffff
LIBXMLVW_BASE             =0x6E900000
#                               79000
#                               fffff
LIBHTMLTREE_BASE          =0x6EA00000
#                               AB000
#                              1fFFFF
#                              Bfffff


LIBJAVASCRIPT_BASE        =0x6EC00000
#                               64000
#                               fffff
LIBODBC_BASE              =0x6ED00000
#                               4a000
#                               fffff
LIBBOSS_BASE              =0x6EE00000
#                               2d000
#                               7ffff
LIBDB_BASE                =0x6EE80000
#                               1b000
#                               fffff
LIBHTML_BASE              =0x6EF00000
#                               82000
#                               fffff


LIB_RB_HELPERS_BASE       =0x6f000000
#                               2b000
#                               7ffff
LIB_RB_CHANGES_BASE       =0x6f080000
#                               2F000
#                               bffff
LIB_XML_YAXO_BASE         =0x6f0c0000
#                               2F000
#                               fffff
LIB_RB_PARSER_BASE        =0x6f100000
#                               95000
#                               fffff
LIB_RB_REFACTORING_BASE   =0x6f200000
#                               9e000
#                               fffff

#                          0x6f300000

!ifdef USEBC
MAKE_ZLIB_ARG= -f win32\Makefile.bor
MAKE_BZ2LIB_ARG= -f Makefile.bor
MAKE_FDMLIB_ARG= -f Makefile.bcc
!else
! ifdef USELCC
MAKE_ZLIB_ARG= -f win32\Makefile.lcc
MAKE_BZ2LIB_ARG= -f Makefile.lcc
MAKE_FDMLIB_ARG= -f Makefile.lcc
! else
!  ifdef USEVC
MAKE_ZLIB_ARG= -f win32\Makefile.msvc
MAKE_BZ2LIB_ARG= -f Makefile.msvc
MAKE_FDMLIB_ARG= -f Makefile.msvc
!  else
!   ifdef USETCC
MAKE_ZLIB_ARG= -f win32\Makefile.tcc
MAKE_BZ2LIB_ARG= -f Makefile.tcc
MAKE_FDMLIB_ARG= -f Makefile.tcc
!   else
!    if defined(USEMINGW32) || defined(USEMINGW64)
MAKE_ZLIB_ARG= -f win32\Makefile.mingw
MAKE_BZ2LIB_ARG= -f Makefile.mingw
MAKE_FDMLIB_ARG= -f Makefile.mingw
!    else
error error error
!    endif
!   endif
!  endif
! endif
!endif

!ifdef LIB_BASE
! ifdef USEBC
LIB_BASE_LD_ARG=-b:$(LIB_BASE)
! endif
! ifdef USEVC
#LIB_BASE_LD_ARG=/BASE:$(LIB_BASE)
! endif
!endif

ZLIB_DIR=$(TOP)\support\zlib-1.2.3
ZLIB=$(OBJDIR)\zlib.lib

BZ2LIB_DIR=$(TOP)\support\bz2lib
BZ2LIB=$(BZ2LIB_DIR)\bz2lib.lib

#
# final destination directory for exe's and dll's
#
BINDIR=$(TOP)\projects\smalltalk
STX=$(BINDIR)\stx.com

#
# input/output directory for STX-includes
#
STX_INCDIR=$(TOP)\include
INCLUDE=$(STX_INCDIR)
INCL=$(TOP)\include\\

LIBRUN=$(LIBDIR)\librun.lib

# WINSOCK=wsock32
WINSOCK=ws2_32
WINSOCK_LIB=$(WINSOCK).lib
L_WINSOCK=-l$(WINSOCK)

!ifdef USEBC

# BORLAND
SYS_INCL=-I$(BCB)\include -I..\support\win32\include
OPENGL_INCLUDE=-I$(BCB)\include\gl

# Linker definition file for DLL's (generic)
DEF_FILE=$(TOP)\rules\bc_dll.def
SYSLIBDIR=$(BCB)\lib\release
IPHLPAPI_LIB=$(BCB)\lib\PSDK\iphlpapi.lib

!else
! ifdef USEVC

# VISUALC
SYS_INCL=-I"$(VCINSTALLDIR)\include" -I"$(SDK)Include" -I"$(SDK2)Include" -I"$(SDK3)Include" -I..\librun
SYS_INCL=-I"$(VCINSTALLDIR)\include" -I"$(SDK)Include" -I..\librun
SYS_INCL=-I"$(VCINSTALLDIR)\include" -I"$(SDK)Include" $(INCLUDE_WINDOWSKIT) -I..\librun
OPENGL_INCLUDE=-I$(SDK)\include\gl

DEF_FILE=$(TOP)\rules\vc_dll.def
SYSLIBDIR=$(SDK)lib\\

LINK32_LIBS=\
	kernel32.lib \
	user32.lib \
	gdi32.lib\
	shell32.lib\
	comdlg32.lib \
	ole32.lib \
	oleaut32.lib \
	advapi32.lib \
	Mpr.lib \
	uuid.lib \
	iphlpapi.lib \
	winmm.lib \
	winspool.lib \
#        wingdi.lib \
	version.lib \
	$(WINSOCK_LIB) \
	"$(VCLIBDIR)oldnames.lib" \
#        "$(VCLIBDIR)libcmt.lib" \
	$(LOCALLIBS)

# LINK32_INCREMENTAL=/INCREMENTAL:yes

LINK32_FLAGS=\
	$(LINK32_LIBS) \
	$(LIBRUN) \
	/NOLOGO \
	/SUBSYSTEM:$(LIB_SUBSYSTEM) \
	$(LINK32_INCREMENTAL) \
	/PDB:$(OUTDIR)$(LIBNAME).pdb \
	/DEBUG \
	/DLL \
	/DYNAMICBASE:NO \
	/MACHINE:X86 \
	/LARGEADDRESSAWARE \
	/ERRORREPORT:PROMPT \
	/OUT:$(OUTDIR)$(LIBNAME).dll

! else
!  ifdef USELCC

# LCC
SYS_INCL=-I$(LCCDIR)\include
OPENGL_INCLUDE=-I$(LCCDIR)\include\gl

!  else
!   ifdef USETCC

# TCC
SYS_INCL=-I$(TCCDIR)\include
OPENGL_INCLUDE=-I$(TCCDIR)\include\gl
STC_CMD_OPT=-commonRefs

!   else
!    if defined(USEMINGW32) || defined(USEMINGW64)

# MINGW
SYS_INCL=-I$(MINGWDIR)\include
OPTIONAL_SUPPORT_XLIB_INCLUDE=-I$(TOP)\support\win32\include -I$(TOP)\support\win32\include\x11
OPENGL_INCLUDE=-I$(MINGWDIR)\include\gl
# STC_CMD_OPT=-commonRefs
!     if defined(USEMINGW32)
L_WINSOCK=-lws2_32 -lwsock32
WINSOCK_LIB=
!     else
L_WINSOCK=-lws2_32 -lwsock32
WINSOCK_LIB=
!     endif

!    else
error error error
!    endif
!   endif
!  endif
! endif
!endif

STC=$(STC_BINDIR)\stc
STX_INCL=-I"$(STX_INCDIR)"
LIBINIT_FILE=$(OUTDIR_SLASH)ntLibInit.$(O)

SYS_LIBS=\
	"$(SYSLIBDIR)kernel32.lib" \
	"$(SYSLIBDIR)user32.lib" \
	"$(SYSLIBDIR)gdi32.lib" \
	"$(SYSLIBDIR)comdlg32.lib" \
	"$(SYSLIBDIR)ole32.lib" \
	"$(SYSLIBDIR)oleaut32.lib" \
	"$(SYSLIBDIR)advapi32.lib" \
	"$(SYSLIBDIR)Mpr.lib" \
	"$(SYSLIBDIR)uuid.lib" \
	"$(SYSLIBDIR)PSDK\iphlpapi.lib" \
	"$(SYSLIBDIR)$(WINSOCK_LIB)" \
	"$(SYSLIBDIR)version.lib" \
	"$(SYSLIBDIR)libc.lib" \
	"$(SYSLIBDIR)oldnames.lib"

SYS_LIB_FLAGS=\
	-lkernel32 -luser32 -lgdi32 -lcomdlg32 -lole32 -loleaut32 -ladvapi32 \
	-lMpr -luuid -liphlpapi $(L_WINSOCK) -lversion -lwinmm

! if defined(USEMINGW32) || defined(USEMINGW64)
ODBC32_LIB=-lodbc32
! else
ODBC32_LIB=odbc32.lib
! endif

INTDIR=.

#
# defaults ...
#

LIB_SUBSYSTEM=console

!if defined(USEMINGW32) || defined(USEMINGW64)
OPT=-fPIC -O2 -fno-strict-aliasing -Wno-strict-aliasing -fno-stack-protector -ggdb3 -pipe -U_FORTIFY_SOURCE
CFLAGS=$(OPT) $(CFLAGS1) $(CFLAGS2) $(LOCALINCLUDES) $(CLOCAL_INCL) $(CFLAGS_LOCAL)
!endif

