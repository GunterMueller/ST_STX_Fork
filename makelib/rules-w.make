#
# $Header: /cvs/stx/stx/rules/stdRules_bc,v 1.132 2017-01-19 10:28:06 stefan Exp $
#
# MIMEType: application/x-make
# EOLMode: msdos
#
# The name of this rules file is now misleading; it used to be used only for
# borland, but now also contains visualC and other compiler definitions.
#
# defaults to borland-build, unless invoked with either
#   USEVC=1  - visualC-make
#   USELCC=1 - lcc make        (suspended work - unfinished)
#   USETCC=1 - tcc make        (suspended work - unfinished)
#   USEMINGW64=1 - mingw make  (ongoing work)

COMMONSYMBOLS=+commonSymbols

!ifdef USETCC
CSUFFIX=c
!else
! if defined(USEMINGW32) || defined(USEMINGW64)
CSUFFIX=sc
! else
CSUFFIX=sc
! endif
!endif

#STCFLAGS=-H$(STX_INCDIR) -Y$(STX_INCDIR) $(STCLOCALOPT) $(STCOPT) -cSuffix=$(CSUFFIX)
#no longer use a common include directory - leave header files where the classes are
#notice: the -Y cares for the common symbol file

!ifndef SCMTYPE
SCMTYPE=auto
!endif

STCFLAGS=-Y$(STX_INCDIR) $(STCLOCALOPT) $(STCOPT) $(STC_MSGFORMAT) $(STC_CMD_OPT) -cSuffix=$(CSUFFIX) +lineInfo +stLineInfo -scmType: auto -sha1

# KEEPCFILE=1

!ifdef USEBC

#------------------------------------------------------------------
# borland-c defs here ...
#------------------------------------------------------------------

DEFS=-D_NO_VCL;WIN32;DEBUG;_RTLDLL
#DEFS=-D_NO_VCL;WIN32;DEBUG

COPTFLAGS=-O2 -5
#COPTFLAGS=-O2 -5 -r -a4 -b -d -H

#CFLAGS1= -WD -w- -x- -k- -v- -c -tWD
# -v  source level debugging
# -y  line number info
# -k  standard stack frame
# -x- no exception handling code

! if !$d(CFLAGS1)
# CFLAGS1= -WD -w- -x- -r- -k -y -v -vi- -c -tWDR
CFLAGS1= -WD -w- -w-pro -w-ccc -w-rch -w-aus -w-par -x- -r- -k -y -v -vi- -c -tWDR
! endif

! if !$d(CFLAGS2)
CFLAGS2= -RT- -Tkh30000
! endif

CFLAGS=$(CFLAGS1) $(CFLAGS2) $(LOCALINCLUDES) $(CLOCAL_INCL) $(CFLAGS_LOCAL)

! if !$d(LFLAGS)
LFLAGS = -L$(LIBDIR) -L$(BCB)\lib;$(BCB)\lib\PSDK;$(DEBUGLIBPATH) -ap -Tpd -s -Gn -Gi -v -w-dup $(LIB_BASE_LD_ARG)
#LFLAGS = -L$(BCB)\lib;$(DEBUGLIBPATH) -ap -Tpd -s -Gn -Gi -M -v -w-dup
! endif

LD_BASE_ARG=-b:
LIBFILES=$(LIBDIR)\librun.lib

ALLLIB = $(LIBFILES) $(LOCALLIBS) import32.lib $(IPHLPAPI_LIB) $(RT_LIB)
!undef USEVC
!undef USELCC

!else
! ifdef USEVC

#------------------------------------------------------------------
# MS visual-C Compiler defs here
#------------------------------------------------------------------
DEFS=-lineInfo -stLineInfo
CDEFS=/D"DEBUG" /D"WIN32" /D"_CONSOLE" /D"VISUALC" /D"__VISUALC__" /D"__i386__"

# O2 - optimize
# Ob1 - only inline explicit

# COPTFLAGS=/O2
# COPTFLAGS=/Ox -- does not work !!!
COPTFLAGS=/ZI

# GF - merge common strings in data space
# outdated: GZ - no stack checks (done by stx-code itself)
# EHsc - catch only C++ exceptions. External functions never throw a C++ exception
# W2 - warnings
# w - no warnings
# Oy - no frame pointer
# Ox - full optimization (=Oy, O2, Og)
# ZI - debug info
# Zi - debug info

CDEBUGFLAGS1=/w /GF /EHsc
CDEBUGFLAGS2=/FR$(OUTDIR)
CDEBUGFLAGS3=/Fp"$(OUTDIR)$(LIBNAME).pch" /Fd"$(OUTDIR)$(LIBNAME).pdb"

CDEBUGFLAGS=$(CDEBUGFLAGS1) $(CDEBUGFLAGS2) $(CDEBUGFLAGS3) $(LOCALINCLUDES) $(CLOCAL_INCL) $(CFLAGS_LOCAL)

LD_BASE_ARG=/BASE:

! else
!  ifdef USELCC

#------------------------------------------------------------------
# LCC defs here (not yet supported)
#------------------------------------------------------------------
DEFS=-DWIN32 -D__LCC__ -DDEBUG
CFLAGS=-nw $(CFLAGS1) $(CFLAGS2) $(LOCALINCLUDES) $(CLOCAL_INCL) $(CFLAGS_LOCAL)
LFLAGS = -L$(LIBDIR) $(LIB_BASE_LD_ARG)
LD_BASE_ARG=-b:
LIBFILES=$(LIBDIR_LIBRUN)\librun.lib

ALLLIB = $(LIBFILES) $(LOCALLIBS) $(IPHLPAPI_LIB) $(RT_LIB)

!  else
!   ifdef USETCC

#------------------------------------------------------------------
# TCC defs here (not yet supported)
#------------------------------------------------------------------
DEFS=-DWIN32 -D__TCC__ -DDEBUG
CFLAGS=$(CFLAGS1) $(CFLAGS2) $(LOCALINCLUDES) $(CLOCAL_INCL) $(CFLAGS_LOCAL)
LFLAGS = -L$(LIBDIR) $(LIB_BASE_LD_ARG)
LIBFILES=$(LIBDIR_LIBRUN)\librun.lib
# no resource compiler
RESFILES=

ALLLIB = $(LIBFILES) $(LOCALLIBS) $(IPHLPAPI_LIB) $(RT_LIB)

!   else
!    ifdef USEMINGW32

#------------------------------------------------------------------
# MINGW32 defs here
#------------------------------------------------------------------
DEFS=-DWIN32 -D__MINGW__ -D__MINGW32__ -DDEBUG -DBUILD_TARGET="$(BUILD_TARGET)"
CFLAGS=$(OPT) $(CFLAGS1) $(CFLAGS2) $(LOCALINCLUDES) $(CLOCAL_INCL) $(CFLAGS_LOCAL)
LFLAGS = -L$(LIBDIR) $(LIB_BASE_LD_ARG)
LIBFILES=$(LIBDIR_LIBRUN)\librun.lib
# no resource compiler
RESFILES=

ALLLIB = $(LIBFILES) $(LOCALLIBS) $(IPHLPAPI_LIB) $(SYS_LIB_FLAGS) $(RT_LIB)

!    else
!     ifdef USEMINGW64

#------------------------------------------------------------------
# MINGW64 defs here
#------------------------------------------------------------------
DEFS=-DWIN32 -D__MINGW__ -D__MINGW64__ -DDEBUG -DBUILD_TARGET="$(BUILD_TARGET)"
CFLAGS=$(OPT) $(CFLAGS1) $(CFLAGS2) $(CWARNFLAGS) $(LOCALINCLUDES) $(CLOCAL_INCL) $(CFLAGS_LOCAL)
LFLAGS=-g $(LIB_BASE_LD_ARG)
LFLAGS2=-L$(LIBDIR)
LIBFILES=$(LIBDIR_LIBRUN)/librun.lib

ALLLIB = $(LIBFILES) $(LOCALLIBS) $(IPHLPAPI_LIB) $(SYS_LIB_FLAGS) $(RT_LIB)

!     else
error error error
!     endif
!    endif
!   endif
!  endif
! endif
!endif

#
# create a symbolic link to the shared library in the projects/smalltalk/packages
# folder. This folder can later be scanned quickly and presented in the Launcher's
# load package menu item.
#
REGISTERED_PACKAGES_DIR=$(TOP)\projects\smalltalk\packages

registerClassLib: $(REGISTERED_PACKAGES_DIR)
	@echo "registering $(MODULE):$(MODULE_DIR)/$(LIBNAME) in $(REGISTERED_PACKAGES_DIR)"
	@-if exist $(REGISTERED_PACKAGES_DIR)\$(LIBNAME).dll del $(REGISTERED_PACKAGES_DIR)\$(LIBNAME).dll
	@echo "lib ..\..\..\..\$(MODULE)\$(MODULE_PATH)\$(OUTDIR)$(LIBNAME).dll" > $(REGISTERED_PACKAGES_DIR)\$(LIBNAME).dll

registerApplication:
	@if "$(APPNAME)" NEQ "" $(MAKE) -N -f bc.mak $(USE_ARG) registerApplicationN

registerApplicationN: $(REGISTERED_PACKAGES_DIR)
	@echo "registering $(MODULE):$(MODULE_DIR)/$(PROJECT_NOCONSOLE) in $(REGISTERED_PACKAGES_DIR)"
	@-if exist $(REGISTERED_PACKAGES_DIR)\$(PROJECT_NOCONSOLE) del $(REGISTERED_PACKAGES_DIR)\$(PROJECT_NOCONSOLE)
	@echo "app ..\..\..\..\$(MODULE)\$(MODULE_PATH)\$(OUTDIR)$(APPNAME)" > $(REGISTERED_PACKAGES_DIR)\$(APPNAME)

$(REGISTERED_PACKAGES_DIR):
	@-if not exist $(REGISTERED_PACKAGES_DIR)\nul mkdir $(REGISTERED_PACKAGES_DIR)\.

$(LIBDIR_PARENT):
	@-if not exist $(LIBDIR_PARENT)\nul mkdir $(LIBDIR_PARENT)\.

$(LIBDIR): $(LIBDIR_PARENT)
	@-if not exist $(LIBDIR)\nul mkdir $(LIBDIR)\.

$(OUTDIR):
	@-if not exist $(OUTDIR)nul mkdir $(OUTDIR:/=)

$(OUTDIR)$(LIBNAME).lib : $(OUTDIR)$(LIBNAME).dll

$(BINDIR)\include:
	@if not exist $(BINDIR)\include\nul mkdir $(BINDIR)\include

!ifdef USEBC

$(OUTDIR)$(LIBNAME).dll : $(OUTDIR) $(DEF_FILE) $(OBJS) $(RESFILES) $(LIBFILES) $(LIBINIT_FILE)
	@echo generating $(LIBNAME).dll / .lib [bc link] ...
	@type &&!
	$(LINK32) $(LFLAGS) +
	    c0d32.obj $(LIBINIT_FILE) $(IOBJS) $(OBJS) , +
	    $(OUTDIR)$(LIBNAME).dll,, +
	    $(ALLLIB) $(X11_LIBS), +
	    $(DEF_FILE), +
	    $(RESFILES)
!
    $(LINK32) @&&!
	$(LFLAGS) +
	c0d32.obj $(LIBINIT_FILE) $(IOBJS) $(OBJS) , +
	$(OUTDIR)$(LIBNAME).dll,, +
	$(ALLLIB) $(X11_LIBS), +
	$(DEF_FILE), +
	$(RESFILES)
!
	del $(OUTDIR)$(LIBNAME).tds
	$(MAKE) -f bc.mak registerClassLib

# CLIB_STARTUP=c0d32.obj
CLIB_STARTUP=

cLibRule:
	@echo generating $(CLIB).dll / .lib [cLibRule clib bc link] ...
	@type &&!
	$(LFLAGS) +
	    $(CLIB_STARTUP) $(COBJS) , +
	    $(CLIB).dll,, +
	    $(CLINK_LIBS), +
	    $(CDEF_FILE), +
	    $(CRESFILES)
!
    $(LINK32) @&&!
	$(LFLAGS) +
	$(CLIB_STARTUP) $(COBJS) , +
	$(CLIB).dll,, +
	$(CLINK_LIBS), +
	$(CDEF_FILE), +
	$(CRESFILES)
!

!else
! ifdef USEVC

$(OUTDIR)$(LIBNAME).dll : $(OUTDIR) $(OBJS) $(LIBINIT_FILE) $(RESFILES) $(LIBFILES)
	@-if not exist $(OUTDIR)nul mkdir $(OUTDIR:/=)
	@-if not exist $(LIBDIR)nul mkdir $(LIBDIR)\.
	@echo generating $(LIBNAME).dll / .lib [vc link] ...
	@echo RESFILES= $(RESFILES)
	@type &&!
	$(LINK32) /DEF:$(DEF_FILE)
	    $(LINK32_FLAGS)
	    $(ALLLIB) $(X11_LIBS) $(LIBINIT_FILE) $(IOBJS)
	    $(OBJS)
	    $(DEF_FILE)
	    $(RESFILES)
!
	@echo linking...
	$(LINK32) /DEF:$(DEF_FILE) @&&!
	    $(LINK32_FLAGS) $(ALLLIB) $(X11_LIBS) $(LIBINIT_FILE) $(IOBJS) $(OBJS) $(RESFILES)
	$(MAKE) -f bc.mak registerClassLib
!

cLibRule:
	@echo generating $(CLIB).dll / .lib [cLibRule vc link] ...
	@type &&!
	$(LINK32) $(LINK32_FLAGS)
	    $(CLINK_LIBS)
	    $(COBJS)
	    $(CDEF_FILE)
	    $(CRESFILES)
!
    @echo linking...
    $(LINK32) /DEF:$(CDEF_FILE) @&&!
	$(LINK32_FLAGS) $(CLINK_LIBS) $(COBJS) $(CRESFILES)
!

! else
!  ifdef USELCC

$(OUTDIR)$(LIBNAME).dll : $(OUTDIR) $(DEF_FILE) $(OBJS) $(RESFILES) $(LIBINIT_FILE) $(LIBFILES)
	@echo generating $(LIBNAME).dll / .lib [lcc link] ...
	$(LINK32_DLL) \
	    $(LFLAGS_DLL) \
	    $(LIBINIT_FILE) $(IOBJS) $(OBJS) \
	    $(ALLLIB) $(X11_LIBS) \
	    $(RESFILES) \
	    -o $(OUTDIR)$(LIBNAME).dll

	@-del $(OUTDIR)$(LIBNAME).exp
	@-del $(OUTDIR)$(LIBNAME).lib
	$(MAKE) -f bc.mak registerClassLib

# additional rule to convert visual-c lib files into lcc format
$(TOP)\$(LIBDIR_PARENT)\lcc\librun.lib: $(TOP)\$(LIBDIR_PARENT)\vc\librun.lib
	@-if not exist $(TOP)\$(LIBDIR_PARENT)\nul mkdir $(TOP)\$(LIBDIR_PARENT).
	@-if not exist $(TOP)\$(LIBDIR_PARENT)\lcc\nul mkdir $(TOP)\$(LIBDIR_PARENT)\lcc.
	$(LCCBINDIR)\pedump /exp $(TOP)\$(LIBDIR_PARENT)\vc\librun.lib > $(TOP)\$(LIBDIR_PARENT)\lcc\librun.exp
	$(LCCBINDIR)\buildlib $(TOP)\$(LIBDIR_PARENT)\lcc\librun.exp $(TOP)\$(LIBDIR_PARENT)\lcc\librun.lib

!  else
!   ifdef USETCC

$(OUTDIR)$(LIBNAME).dll : $(OUTDIR) $(DEF_FILE) $(OBJS) $(RESFILES) $(LIBINIT_FILE) $(LIBFILES)
	@echo generating $(LIBNAME).dll / .lib [tcc link] ...
	$(LINK32) -shared \
	    $(LFLAGS) \
	    $(LIBINIT_FILE) $(IOBJS) $(OBJS) \
	    $(ALLLIB) $(X11_LIBS) \
	    $(RESFILES) \
	    -o $(OUTDIR)$(LIBNAME).dll

	del $(OUTDIR)$(LIBNAME).lib
	$(MAKE) -f bc.mak registerClassLib

# additional rule to copy visual-c lib files into tcc folder
$(TOP)\$(LIBDIR_PARENT)\tcc\librun.lib: $(TOP)\$(LIBDIR_PARENT)\vc\librun.lib
	@-if not exist $(TOP)\$(LIBDIR_PARENT)\nul mkdir $(TOP)\$(LIBDIR_PARENT).
	@-if not exist $(TOP)\$(LIBDIR_PARENT)\mingw\nul mkdir $(TOP)\$(LIBDIR_PARENT)\mingw.
	copy $(TOP)\$(LIBDIR_PARENT)\vc\librun.lib $(TOP)\$(LIBDIR_PARENT)\tcc\librun.lib

!   else
!    if defined(USEMINGW32) || defined(USEMINGW64) || defined(USEMINGW)

$(OUTDIR)$(LIBNAME).dll : $(OUTDIR) $(DEF_FILE) $(OBJS) $(RESFILES) $(LIBINIT_FILE) $(LIBFILES)
	@echo generating $(LIBNAME).dll / .lib [mingw link] ...
	type &&!
	    $(LINK32_DLL)  \
	    $(LFLAGS_DLL) -L$(MINGWDIR)\lib \
	    $(LIBINIT_FILE) $(IOBJS) $(OBJS) \
	    $(ALLLIB) $(X11_LIBS) \
	    -o $(OUTDIR)$(LIBNAME).dll
!
	$(LINK32_DLL) $(LFLAGS_DLL) -L$(MINGWDIR)\lib @&&$
		$(LIBINIT_FILE) $(IOBJS) $(OBJS)
$ \
		$(ALLLIB) $(X11_LIBS) -o $(OUTDIR_SLASH)$(LIBNAME).dll
	$(OBJCOPY) --only-keep-debug $(OUTDIR)$(LIBNAME).dll $(OUTDIR)$(LIBNAME).dll.debug
	$(STRIP) --strip-debug --strip-unneeded $(OUTDIR)$(LIBNAME).dll
	$(OBJCOPY) --add-gnu-debuglink="$(OUTDIR)$(LIBNAME).dll.debug" $(OUTDIR)$(LIBNAME).dll
	$(MAKE) -f bc.mak registerClassLib

cLibRule:
	@echo generating $(CLIB).dll / .lib [cLibRule mingw link] ...
	@echo COBJS=$(COBJS)
	type &&!
	    $(LINK32_DLL) $(LFLAGS_DLL) -L$(MINGWDIR)\lib \
	    $(COBJS) \
	    $(CLINK_LIBS) \
	    -o $(CLIB).dll
!
	$(LINK32_DLL) $(LFLAGS_DLL) -L$(MINGWDIR)\lib \
	    $(COBJS) $(CLINK_LIBS) -o $(CLIB).dll

!    else

error error error

!    endif
!   endif
!  endif
! endif
!endif

iObjs : $(IOBJS) $(WIN32_IOBJS)

$(BINDIR)\$(LIBNAME).dll: $(OUTDIR)$(LIBNAME).dll
	-copy $(OUTDIR)$(LIBNAME).dll $(BINDIR)

$(LIBDIR)\$(LIBNAME).lib: $(OUTDIR)$(LIBNAME).lib
	-copy $(OUTDIR)$(LIBNAME).lib $(LIBDIR)
	-touch $(LIBDIR)\$(LIBNAME).lib

# full:
#    in addition to all, this also builds support stuff needed
#    by some subsystems using ant and possibly other tools.
#    for now, this is libjava only
full::   all

lib: $(BINDIR)\$(LIBNAME).dll

cleanjunk:
	-del *.sbr
	-del *.pdb $(OBJDIR)\*.pdb
	-del *.ilk
	-del *.sc
	-del ntLibInit.c
	-del MAKE*.@@@
	-del *.$$$$$

clean_obj: cleanjunk
	-del $(OBJDIR)\*.$(O) $(OBJDIR)\*.obj $(OBJDIR)\*.map $(OBJDIR)\*.tds $(OBJDIR)\*.$(RES)
	-del $(OBJDIR)\*.sbr $(OBJDIR)\*.idb $(OBJDIR)\*.exp
	-del *.$(O) *.map *.tds *.$(RES) *.ilk

clean:: clean_obj
	-del .\#*.*
	-del *.sc
	-del ntLibInit.c
	-del MAKE0000.@@@
	-del *.$$$$$
	-del *.$$$

clobber:: clean
	-del $(OBJDIR)\*.dll $(OBJDIR)\*.lib $(OBJDIR)\*.ilk $(OBJDIR)\*.exp $(OBJDIR)\*.pdb $(OBJDIR)\*.map
	-del objbc\*.dll objbc\*.lib objbc\*.ilk objbc\*.exp objbc\*.obj objbc\*.pdb objbc\*.map
	-del objmingw\*.dll objmingw\*.o objmingw\*.lib objmingw\*.ilk objmingw\*.exp objmingw\*.obj objmingw\*.pdb objmingw\*.map
	-del objvc\*.dll objvc\*.lib objvc\*.ilk objvc\*.exp objvc\*.obj objvc\*.pdb objvc\*.map
	-del objtcc\*.dll objtcc\*.lib objtcc\*.o
	-del objlcc\*.dll objlcc\*.lib objlcc\*.obj objlcc\*.exp
	-rd /S /Q objbc objvc objtcc objlcc obj objmingw
	-del *.dll *.lib *.sth *.sav

!ifdef USEBC

.SUFFIXES: .st .$(CSUFFIX) .c .cc .$(O)

.$(CSUFFIX).I:
    cpp32 $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) $<

.$(CSUFFIX).$(O):
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c -o$@ $<

.st.$(O):
    $(STC) $(STX_INCL) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C $<
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c -o$@ $&.$(CSUFFIX)
!  ifndef KEEPCFILE
    del $&.$(CSUFFIX)
!  endif

.st.$(CSUFFIX):
    $(STC) $(FFLAGS) $(STCFLAGS)  $(STC_CMD_OPT) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C $<

# disabled? - leads to double-compile trouble?
#.st.$(H):
#    $(STC) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C -headerOnly $<


.c.obj:
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c -o$@ $<

!else
! ifdef USEVC

.SUFFIXES: .st .sc .c .cc .obj

.st.obj:
    $(STC) $(STX_INCL) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C $<
    $(CC) /nologo $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(CDEFS) $(COPTFLAGS) $(DBGFLAGS) $(CDEBUGFLAGS) -c /Fo$*.obj /Tc$&.$(CSUFFIX)
!  ifndef KEEPCFILE
    del $&.$(CSUFFIX)
!  endif

#.st.asm:
#    $(STC) $(STX_INCL) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C $<
#    $(CC) /nologo $(STX_INCL) $(SYS_INCL) $(FFLAGS) /Fa /Fs $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CDEBUGFLAGS) -c $*.c

.st.$(CSUFFIX):
    $(STC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C $<

#.c.asm:
#    $(CC) /nologo $(STX_INCL) $(SYS_INCL) $(FFLAGS) /Fa /Fs $(CDEFS) $(COPTFLAGS) $(DBGFLAGS) $(CDEBUGFLAGS) -c $<

.$(CSUFFIX).$(O):
    $(CC) /nologo $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(CDEFS) $(COPTFLAGS) $(DBGFLAGS) $(CDEBUGFLAGS) -c /Fo$*.$(O) /Tc$<

.c.$(O):
    $(CC) /nologo $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(CDEFS) $(COPTFLAGS) $(DBGFLAGS) $(CDEBUGFLAGS) -c  /Fo$*.$(O) /Tc$<

.$(CSUFFIX).i:
    $(CC) /nologo $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(CDEFS) $(COPTFLAGS) $(DBGFLAGS) $(CDEBUGFLAGS) /EP /Tc$< >$*.i


! else
!  ifdef USELCC

.SUFFIXES: .st .c .sc .$(O)

.sc.$(O):
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c $<

.c.$(O):
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c -o $*.$(O) $<

.st.$(O):
    $(STC) $(STX_INCL) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C $<
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c -o $*.$(O) $&.$(CSUFFIX)
!  ifndef KEEPCFILE
    del *.$(CSUFFIX)
!  endif

.st.$(CSUFFIX):
    $(STC) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C $<

!  else
!   ifdef USETCC

.SUFFIXES: .st .c .sc .$(O)

.st.$(O):
    $(STC) $(STX_INCL) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C $<
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c -o $*.$(O) $&.$(CSUFFIX)
!  ifndef KEEPCFILE
    del *.$(CSUFFIX)
!  endif

.st.$(CSUFFIX):
    $(STC) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C $<

.c.$(O):
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c -o $@ $<

.sc.$(O):
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c -o $@ $<

!   else
!    if defined(USEMINGW32) || defined(USEMINGW64) || defined(USEMINGW)

# .SUFFIXES: .st $(CSUFFIX) .c .sc .s .$(O) .i
.SUFFIXES: .st .c .$(O) .i

.st.$(O):
    $(STC) $(STX_INCL) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C $<
! ifdef KEEPCFILE
    copy $&.$(CSUFFIX) $&.c
! endif
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -x c -c -o $*.$(O) $&.$(CSUFFIX)
    del $&.$(CSUFFIX)

.st.$(CSUFFIX):
    $(STC) $(STX_INCL) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C $<

.c.$(O):
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c -o $@ $<

#.sc.$(O):
#       $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c -o $@ $<

#.c.i:
#       $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -E $< > $*.i

.$(CSUFFIX).$(O):
    copy $&.$(CSUFFIX) $&.c
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -c -o $@ $&.c
    del $&.c

.$(CSUFFIX).s:
    $(CC) $(STX_INCL) $(SYS_INCL) $(FFLAGS) $(DEFS) $(COPTFLAGS) $(DBGFLAGS) $(CFLAGS) -S $<

!    else

error error error

!    endif
!   endif
!  endif
! endif
!endif

!ifdef USEBC

.SUFFIXES: .rc .res

.rc.res:
	$(RC) -I$(BCB)\include $&.rc @&&|
$(RCINCLUDEPATH)
| -fo$@

!else
! ifdef USEVC

.SUFFIXES: .rc .res

.rc.res:
	$(RC) /fo $@ $&.rc

! else
!  ifdef USELCC

.SUFFIXES: .rc .res

.rc.res:
	$(RC) $&.rc

!  else
!   ifdef USETCC

# no resource compiler ?

!   else
!    if defined(USEMINGW32) || defined(USEMINGW64)

.suffixes .rc .$(RES)

.rc.$(RES):
	$(RC) -D__MINGW__=1 --input="$<" --output="$@"

.suffixes .rc .res

.rc.res:
	$(RC) -D__MINGW__=1 --input="$<" --output="$@"

#.rc.res:
#        echo "xxx RC is " $(RC)
#        $(RC) $&.rc -o $&.o
#        -ren $&.o $&.res

!    else
error error error
!    endif
!   endif
!  endif
! endif
!endif

$(OUTDIR)ntLibInit.$(O): ntLibInit.c

ntLibInit.c:  libInit.cc
	-copy libInit.cc ntLibInit.c

buildDate.h: $(GENDATE_UTILITY)
	call $(GENDATE_UTILITY)
