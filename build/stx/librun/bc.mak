# $Header$
#
# makefile for borland-c
#       also for visual-c, (if USEVC is defined)
#       also for mingw, (if USEMINGW32/USEMINGW64 is defined)
#
#############################################################################

# CDEBUGFLAGS=-DDEBUGGING

# a binary-only distribution, if any
STXBIN=..\..\stxbin

!ifdef USEBC
! undef USEVC
! undef USEMINGW32
! undef USEMINGW64
!endif

!ifdef USEVC
! undef USEBC
! undef USEMINGW32
! undef USEMINGW64
!endif

!if defined(USEMINGW32) || defined(USEMINGW64)
! undef USEBC
! undef USEVC
!endif

TOP=..

!INCLUDE $(TOP)\rules\stdHeader_bc

LIBRUN_LIB=$(LIBDIR)\librun.lib
FFI_TARGET=ffi_target
FFI_HEADER_TARGETS=$(INCDIR)\ffi.h $(INCDIR)\fficonfig.h

!ifdef USEBC
  LIBRUN_BASE_LD_ARG=-b:$(LIBRUN_BASE)
!endif

!ifdef USEVC
  LIBRUN_BASE_LD_ARG=-/BASE:$(LIBRUN_BASE)
!endif

USERINITFUNCS=

LIBNAME=librun

INCDIR=..\include

vm:     librun buildDate.h $(INCDIR)\md5.h $(INCDIR)\mcompiler.h

all:    vm

full::  vm

librun: $(OBJDIR) $(LIBDIR) $(FFI_TARGET) $(FFI_HEADER_TARGETS) librun_dll $(LIBRUN_LIB)

$(INCDIR)\md5.h: md5.h
	copy md5.h $(INCDIR)\md5.h

$(INCDIR)\mcompiler.h: mcompiler.h
	copy mcompiler.h $(INCDIR)\mcompiler.h

$(LIBDIR)\librun.lib: $(OBJDIR)\librun.lib
	copy $(OBJDIR)\librun.lib $(LIBDIR)\librun.lib

$(OBJDIR):
	@-if not EXIST $(OBJDIR)\nul mkdir $(OBJDIR)

$(LIBDIR):
	@if not EXIST $(LIBDIR)\nul mkdir $(LIBDIR)

!if !defined(USEMINGW32) || defined(USEMINGW64)

ffi: $(LIBFFI_OBJS)
	echo "FFI done"

!else

ffi:
	pushd libffi\build_win32 & call $(MAKE_BAT)

!endif # !defined(USEMINGW32) || defined(USEMINGW64)

removeMain:
	del $(OBJDIR)\main.$(O)

plugin:
	pushd plugin\mozilla & $(MAKE)


!ifdef USEBC

$(LIBDIR)\$(RT_LIB): ..\support\win32\borland\$(RT_LIB)
	copy ..\support\win32\borland\$(RT_LIB) $(LIBDIR)\$(RT_LIB)

!else

$(LIBDIR)\$(RT_LIB):
	-@echo "bc.mak: no need to copy runtime files (crt0.obj) for non-bcc32"

!endif


!ifdef USEBC

INCL=-I..\include -I$(BCB)\include -I$(INCDIR)
DEFS=-D_NO_VCL;WIN32;HAVE_CONFIG_H;DEBUG;_CONSOLE;_RTLDLL

CC_FLAGS = $(INCL) -O2 -WD -w- -x- -d -k -y -v -lv -vi -c -tWDR \
		$(DEFS) \
		-xd- -R -RT -Tkh30000 -5

RFLAGS = -D_NO_VCL;WIN32;HAVE_CONFIG_H;DEBUG;_CONSOLE;_RTLDLL \
		-i.;$(BCB)\include;$(INCDIR)

AS_FLAGS = /i. /i$(BCB)\include /i$(INCDIR) /d_NO_VCL /dWIN32 /dHAVE_CONFIG_H \
		/dDEBUG /d_CONSOLE /d_RTLDLL /mx /w2 /zi

LFLAGS = -L..\libbc;$(BCB)\lib $(LIBRUN_BASE_LD_ARG) \
		-ap -Tpd -s -Gn -Gi -w-dup -v -m -s

#CC_FLAGS= $(INCL) -O2 -5 -WD -w- -x- -r- -k -y -v -vi- -c -tWD \
#                 -RT- -Tkh30000 -D_NO_VCL;WIN32;DEBUG

.c.$(O):
	$(CC) $(CC_FLAGS) -n$(@D) $<

!else
! ifdef USEVC

INCL=-I. -I..\include -I$(INCDIR)
SYS_INCL=-I"$(VCINSTALLDIR)\include" -I"$(SDK)Include" $(INCLUDE_WINDOWSKIT)
DEFS=-D__VISUALC__ -DNO_VCL -DWIN32 -DHAVE_CONFIG_H -DDEBUG -D_CONSOLE -D_RTLDLL
# COPTFLAGS=/Ox /Gd
# COPTFLAGS=/ZI /Zi
COPTFLAGS=/Gd
CC_FLAGS = /nologo $(INCL) $(COPTFLAGS) $(CDEBUGFLAGS) $(DEFS) $(SYS_INCL)

.c.$(O):
	$(CC) -c /Fo"$@" $(CC_FLAGS) $<

! else
!  ifdef USELCC

INCL=-I. -I..\include -I$(INCDIR)
SYS_INCL=
DEFS=-D__LCC__ -DWIN32 -DHAVE_CONFIG_H -DDEBUG -D_CONSOLE -D_RTLDLL
COPTFLAGS=
CC_FLAGS = $(INCL) $(COPTFLAGS) $(DEFS) $(SYS_INCL)

.c.$(O):
	$(CC) -c -o "$@" $(CC_FLAGS) $<

!  else
!   ifdef USETCC

INCL=-I. -I..\include -I$(INCDIR)
SYS_INCL=-I"$(TOP)\support\tcc\include"
DEFS=-D__TCC__ -DWIN32 -DHAVE_CONFIG_H -DDEBUG -D_CONSOLE -D_RTLDLL
COPTFLAGS=
CC_FLAGS = $(INCL) $(COPTFLAGS) $(DEFS) $(SYS_INCL)

.c.$(O):
	$(CC) -c -o "$@" $(CC_FLAGS) $<

!   else
!    if defined(USEMINGW32) || defined(USEMINGW64)

INCL=-I. -I..\include -I$(INCDIR)
SYS_INCL=-I$(MINGW_DIR)\include
!     if defined(USEMINGW32)
DEFS=-D__MINGW__ -D__MINGW32__ -DWIN32 -DHAVE_CONFIG_H -DDEBUG -DDEBUGGING -D_CONSOLE -D_RTLDLL -DBUILD_TARGET=\"$(BUILD_TARGET)\"
!     else
DEFS=-D__MINGW__ -D__MINGW64__ -DWIN32 -DHAVE_CONFIG_H -DDEBUG -DDEBUGGING -D_CONSOLE -D_RTLDLL -DBUILD_TARGET=\"$(BUILD_TARGET)\"
!     endif
COPTFLAGS=$(OPT)
CC_FLAGS =-x c -g -fdiagnostics-color=auto -fwrapv -Wall -W -Wno-unused-parameter -Wno-error=unused-variable -Wno-comment -Wno-error=comment $(INCL) $(COPTFLAGS) $(DEFS) $(SYS_INCL)

!    else
error error error
!    endif
!   endif
!  endif
! endif
!endif

.autodepend
PATHCPP = .
.PATH.CPP = $(PATHCPP)
.PATH.C   = $(PATHCPP)
.PATH.ASM = $(PATHCPP)

.c.I:
	cpp32 $(INCL) $(DEFS) $<

.asm.obj:
	$(AS) $(AS_FLAGS) $<, $@

!ifdef USEBC
.rc.res:
	$(RC) $(RFLAGS) -fo$@ $<
!endif

$(OBJDIR)\librun.res: librun.res
	copy librun.res $(OBJDIR)\librun.res

!if defined(USEMINGW32) || defined(USEMINGW64)
! if defined(USEMINGW64)
LIBFFI_TARGET   = x86_64-w64-mingw32
LIBFFI_WINOBJ   = win64.o
! else
LIBFFI_TARGET   = i686-pc-mingw32
LIBFFI_WINOBJ   = win32.o
! endif

LIBFFI_DIR      = libffi-3.2.1
LIBFFI_OBJS     = \
	$(LIBFFI_DIR)\$(LIBFFI_TARGET)\src\.libs\java_raw_api.o \
	$(LIBFFI_DIR)\$(LIBFFI_TARGET)\src\.libs\prep_cif.o \
	$(LIBFFI_DIR)\$(LIBFFI_TARGET)\src\.libs\raw_api.o \
	$(LIBFFI_DIR)\$(LIBFFI_TARGET)\src\.libs\types.o \
	$(LIBFFI_DIR)\$(LIBFFI_TARGET)\src\x86\.libs\ffi.o \
	$(LIBFFI_DIR)\$(LIBFFI_TARGET)\src\x86\.libs\$(LIBFFI_WINOBJ) \

#

#
# use ready to use prebuild libffi.a
#

!else

#
# with bcc and vc, place the ffi objects right into the librun
#
LIBFFI_OBJS = \
	libffi\build_win32\$(OBJDIR)\debug.$(O) \
	libffi\build_win32\$(OBJDIR)\java_raw_api.$(O) \
	libffi\build_win32\$(OBJDIR)\prep_cif.$(O) \
	libffi\build_win32\$(OBJDIR)\raw_api.$(O) \
	libffi\build_win32\$(OBJDIR)\types.$(O) \
	libffi\build_win32\$(OBJDIR)\ffi.$(O) \
	libffi\build_win32\$(OBJDIR)\win32.$(O)

!endif

!if defined(USEMINGW32) || defined(USEMINGW64)

$(LIBFFI_DIR)\$(LIBFFI_TARGET)\include\ffi.h: $(LIBFFI_OBJS)
	echo

$(INCDIR)\ffi.h: $(LIBFFI_DIR)\$(LIBFFI_TARGET)\include\ffi.h
	copy $(LIBFFI_DIR)\$(LIBFFI_TARGET)\include\ffi.h $(INCDIR)\ffi.h
	copy $(LIBFFI_DIR)\$(LIBFFI_TARGET)\include\ffitarget.h $(INCDIR)\ffitarget.h


$(INCDIR)\fficonfig.h: $(LIBFFI_DIR)\$(LIBFFI_TARGET)\fficonfig.h
	copy $(LIBFFI_DIR)\$(LIBFFI_TARGET)\fficonfig.h $(INCDIR)\fficonfig.h

!else
$(INCDIR)\ffi.h: libffi\build_win32\include\ffi.h
	copy libffi\build_win32\include\ffi.h $(INCDIR)\ffi.h

$(INCDIR)\fficonfig.h: libffi\build_win32\include\fficonfig.h
	copy libffi\build_win32\include\fficonfig.h $(INCDIR)\fficonfig.h
!endif

!ifdef USEBC
ASMHELP_OBJ=$(OBJDIR)\ntasmhelp.obj
!endif

!ifdef USEVC
ASMHELP_OBJ=$(OBJDIR)\vcasmhelp.obj
!endif

!if defined(USEMINGW32) || defined(USEMINGW64)
ASMHELP_OBJ=$(OBJDIR)\asmhelp.obj
!endif

LIBRUN_OBJFILES = \
	$(OBJDIR)\win32.$(O) $(OBJDIR)\char.$(O) $(OBJDIR)\classes.$(O) \
	$(OBJDIR)\errhandler.$(O) $(OBJDIR)\float.$(O) $(OBJDIR)\globals.$(O) $(OBJDIR)\init.$(O) \
	$(OBJDIR)\interpret.$(O) $(OBJDIR)\interrupt.$(O) $(OBJDIR)\jinterpret.$(O) $(OBJDIR)\jsupport.$(O) $(OBJDIR)\lookup.$(O) \
	$(OBJDIR)\mcompiler.$(O) $(OBJDIR)\md5.$(O) $(OBJDIR)\memory.$(O) $(OBJDIR)\malloc.$(O) $(OBJDIR)\new.$(O) $(OBJDIR)\hmm.$(O) $(OBJDIR)\debug.$(O) \
	$(OBJDIR)\process.$(O) $(OBJDIR)\stack.$(O) $(OBJDIR)\send.$(O) $(OBJDIR)\snapshot.$(O) \
	$(OBJDIR)\statistic.$(O) $(OBJDIR)\string.$(O) $(OBJDIR)\stxmain.$(O) $(OBJDIR)\symbol.$(O) \
	$(OBJDIR)\symlist.$(O) $(OBJDIR)\util.$(O) $(OBJDIR)\apithreads.$(O) \
	$(OBJDIR)\backtrace.$(O) $(OBJDIR)\stxplugin.$(O) $(ASMHELP_OBJ)

!ifdef USEBC

# $(LIBFFI_OBJS): libffi\build_win32\include\ffi.h libffi\build_win32\include\fficonfig.h
#         pushd libffi\build_win32 & call $(MAKE_BAT) objs

libffi\build_win32\$(OBJDIR)\debug.$(O): libffi\build_win32\debug.c libffi\build_win32\include\ffi.h libffi\build_win32\include\fficonfig.h
	@pushd libffi\build_win32 & call $(MAKE_BAT) $(OBJDIR)\debug.$(O)

libffi\build_win32\$(OBJDIR)\java_raw_api.$(O): libffi\build_win32\java_raw_api.c libffi\build_win32\include\ffi.h libffi\build_win32\include\fficonfig.h
	@pushd libffi\build_win32 & call $(MAKE_BAT) $(OBJDIR)\java_raw_api.$(O)

libffi\build_win32\$(OBJDIR)\prep_cif.$(O): libffi\build_win32\prep_cif.c libffi\build_win32\include\ffi.h libffi\build_win32\include\fficonfig.h
	@pushd libffi\build_win32 & call $(MAKE_BAT) $(OBJDIR)\prep_cif.$(O)

libffi\build_win32\$(OBJDIR)\raw_api.$(O): libffi\build_win32\raw_api.c libffi\build_win32\include\ffi.h libffi\build_win32\include\fficonfig.h
	@pushd libffi\build_win32 & call $(MAKE_BAT) $(OBJDIR)\raw_api.$(O)

libffi\build_win32\$(OBJDIR)\types.$(O): libffi\build_win32\types.c libffi\build_win32\include\ffi.h libffi\build_win32\include\fficonfig.h
	@pushd libffi\build_win32 & call $(MAKE_BAT) $(OBJDIR)\types.$(O)

libffi\build_win32\$(OBJDIR)\ffi.$(O): libffi\build_win32\ffi.c libffi\build_win32\include\ffi.h libffi\build_win32\include\fficonfig.h
	@pushd libffi\build_win32 & call $(MAKE_BAT) $(OBJDIR)\ffi.$(O)

libffi\build_win32\$(OBJDIR)\win32.$(O): libffi\build_win32\win32.asm libffi\build_win32\include\ffi.h libffi\build_win32\include\fficonfig.h
	@pushd libffi\build_win32 & call $(MAKE_BAT) $(OBJDIR)\win32.$(O)

!else
! ifdef USEVC

$(LIBFFI_OBJS): libffi\build_win32\include\ffi.h libffi\build_win32\include\fficonfig.h
	pushd libffi\build_win32 & call $(MAKE_BAT)

! else
!  if defined(USEMINGW32) || defined(USEMINGW64)

$(FFI_TARGET): $(LIBFFI_OBJS)

$(LIBFFI_DIR)\$(LIBFFI_TARGET)\config.status:
	pushd $(LIBFFI_DIR) & set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & bash configure --build=$(LIBFFI_TARGET)


$(LIBFFI_OBJS): $(LIBFFI_DIR)\$(LIBFFI_TARGET)\config.status
	-touch $(LIBFFI_DIR)\doc\libffi.info
	pushd $(LIBFFI_DIR) & set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & make

!  endif
! endif
!endif

! ifdef NOTDEF
!  ifdef USEBC
IEEE754_OBJFILES=ieee754_support\\SoftFloat-2b\\softfloat\\bits32\\386-Win32-BCC\\softfloat.obj
!  else
!   ifdef USE_VC
!   else
!   endif
!  endif
! endif

librun_dll:
	-if EXIST stxprocess.h call $(MAKE_BAT) compile_librun
	-if NOT EXIST stxprocess.h call $(MAKE_BAT) noSource_librun

#
# for binary only distributions
#
noSource_librun:
	@if EXIST $(STXBIN)\librun\librun.dll copy $(STXBIN)\librun\librun.dll *.*
	@if EXIST $(STXBIN)\librun\librun.lib copy $(STXBIN)\librun\librun.lib *.*


compile_librun: $(OBJDIR)\librun.dll

!ifdef USEBC

#$(OBJDIR)\librun.res: librun.rc
#        $(RC) librun.rc
#        copy librun.res $(OBJDIR)\librun.res

$(OBJDIR)\librun.dll: $(LIBRUN_OBJFILES) $(LIBFFI_OBJS) $(LIBDIR)\$(RT_LIB) bc.def $(OBJDIR)\librun.res
## $(OBJDIR)\librun.dll: $(LIBRUN_OBJFILES) $(LIBDIR)\$(RT_LIB) bc.def $(OBJDIR)\librun.res
	@echo generating librun.dll / .lib [borland C link] ...
	$(LINK32) @&&!
		$(LFLAGS) +
	c0d32.obj $(LIBRUN_OBJFILES) $(LIBFFI_OBJS) $(IEEE754_OBJFILES), +
		$(OBJDIR)\librun.dll,, +
		import32.lib $(LIBDIR)\$(RT_LIB), +
		bc.def, +
		$(OBJDIR)\librun.res
!

!endif

!ifdef USEVC

xKERNEL_LIBS="$(SYSLIBDIR)kernel32.lib" "$(SYSLIBDIR)user32.lib" "$(SYSLIBDIR)gdi32.lib" "$(SYSLIBDIR)wsock32.lib" "$(SYSLIBDIR)winmm.lib" "$(SYSLIBDIR)advapi32.lib"
KERNEL_LIBS=kernel32.lib user32.lib gdi32.lib wsock32.lib winmm.lib advapi32.lib
LFLAGS=/NOLOGO /DLL /SUBSYSTEM:console

$(OBJDIR)\librun.dll: $(LIBRUN_OBJFILES) libffi_objs $(LIBDIR)\$(RT_LIB) bc.def $(OBJDIR)\librun.res
	@echo generating librun.dll / .lib [visual C link] ...
	@echo lflags: "$(LFLAGS)"
	@echo $(LINK32) $(LFLAGS) /OUT:"$(OBJDIR)\librun.dll" /DEF:"vc.def"
	@echo "     " $(LIBRUN_OBJFILES) $(LIBFFI_OBJS) $(KERNEL_LIBS)
	$(LINK32) @<<
	    $(LFLAGS) /OUT:"$(OBJDIR)\librun.dll" /DEF:"vc.def" $(LIBRUN_OBJFILES) $(LIBFFI_OBJS) $(KERNEL_LIBS)
<<

!endif

!if defined(USEMINGW32) || defined(USEMINGW64)

# funny: libs are called xxx32, even on 64 bit systems
KERNEL_LIBS=-lkernel32 -luser32 -lgdi32 -lwsock32 -lwinmm -ladvapi32

$(OBJDIR)\librun.dll: $(LIBRUN_OBJFILES) $(LIBFFI_OBJS) $(LIBDIR)\$(RT_LIB) bc.def $(OBJDIR)\librun.res
	@echo generating $(LIBNAME).dll / .lib [mingw link] ...
	$(LINK32_DLL) \
		$(LFLAGS_DLL) \
		$(LIBRUN_OBJFILES) $(LIBFFI_OBJS) $(KERNEL_LIBS) \
		-Wl,--out-implib,$(OBJDIR)\librun.lib \
		-o $(OBJDIR)\librun.dll
	@-del $(OBJDIR)\librun.exp

!endif

HEADERS=\
	..\include\stc.h \
	..\include\stcIntern.h \
	..\include\stxNames.h \
	..\include\ntIntern.h

!ifdef USEBC
CONF_CC=bcc
!else
! ifdef USEVC
CONF_CC=msvc
! else
!  ifdef USEMINGW64
CONF_CC=mingw64
!  else
!   ifdef USEMINGW32
CONF_CC=mingw32
!   else
CONF_CC=unknown
!   endif
!  endif
! endif
!endif

$(OBJDIR)\main.obj: main.c modules.c $(HEADERS) buildDate.h
	$(CC) /DCONFIGURATION_STRING="\"win32/$(CONF_CC):standard\"" \
	      /DUSERINITFUNCS=$(USERINITFUNCS) \
	      $(CC_FLAGS) -n$(OBJDIR) main.c
	@if EXIST modules.c del modules.c

genDate.com:
	@if exist genDate.c call $(MAKE_BAT) compile_genDate
	@if exist $(STXBIN)\librun\genDate.com $(MAKE_BAT) copy_genDate

!ifdef USEBC
compile_genDate: genDate.c
	$(CC) -DWIN32 -I$(BCB)\include -L$(BCB)\lib genDate.c
	@if exist genDate.com @del genDate.com
	@ren genDate.exe genDate.com
!endif

!ifdef USEVC
compile_genDate: genDate.c
	$(CC) $(CC_FLAGS) -c genDate.c
	echo /ALLOWISOLATION /TLBID:1 /DYNAMICBASE /NXCOMPAT /DEBUG /DYNAMICBASE:NO /MACHINE:X86 /SUBSYSTEM:CONSOLE /OUT:"genDate.com" genDate.obj kernel32.lib
	$(LINK32) @<<
	    /ALLOWISOLATION /TLBID:1 /DYNAMICBASE /NXCOMPAT /DEBUG /DYNAMICBASE:NO /MACHINE:X86 /SUBSYSTEM:CONSOLE /OUT:"genDate.com" genDate.obj kernel32.lib
<<

!endif

!if defined(USEMINGW32) || defined(USEMINGW64)
compile_genDate: genDate.c
	$(CC) $(CC_FLAGS) -o genDate.com genDate.c

!endif

copy_genDate: $(STXBIN)\librun\genDate.com
	copy $(STXBIN)\librun\genDate.com *.*

buildDate.h: genDate.com
	genDate

$(LIBRUN_OBJFILES): stxprocess.h $(HEADERS)

clean::
	-del *.obj *.res
	-del $(OBJDIR)\*.obj $(OBJDIR)\*.res
	-del objbc\*.obj objbc\*.res
	-del objvc\*.obj objvc\*.res
	-del objmingw\*.obj objmingw\*.res
	-del *.$$$
	-del *.@@@

clobber:: clean
	-del *.dll objbc\*.dll objvc\*.dll objmingw\*.dll $(OBJDIR)\*.dll
	-del *.lib objbc\*.lib objvc\*.lib objmingw\*.dll $(OBJDIR)\*.dll

!if defined(USEMINGW32) || defined(USEMINGW64)
clobber::
    -rmdir /S /Q $(LIBFFI_DIR)\$(LIBFFI_TARGET)
!endif

modules.c: modules.templ
	copy modules.templ modules.c

supportFiles:


#
# IEEE 754 support (mybe needed for Java VM implementation)
#

ieee754_support\SoftFloat-2b\softfloat\bits32\386-Win32-BCC\softfloat.obj:
    @pushd ieee754_support\SoftFloat-2b\softfloat\bits32\386-Win32-BCC & make

ieee754_support\\SoftFloat-2b\\softfloat\\bits32\\386-Win32-BCC\\softfloat.obj:
    @pushd ieee754_support\SoftFloat-2b\softfloat\bits32\\386-Win32-BCC & make

!if defined(USEMINGW32) || defined(USEMINGW64)

$(ASMHELP_OBJ): asmhelp.c
	$(CC) -D__ASSEMBLER__ $(CC_FLAGS) $(CFLAGS) $(LIBRUN_ASM_CPP_OPT) -E asmhelp.c > asmhelp.s
	$(CC) -o $(ASMHELP_OBJ) -c $(CC_AS_OPT) $(ASFLAGS) $(AS_CC_CFLAG) asmhelp.s
	-del asmhelp.s

.suffixes .c .$(O)

# Under MINGW64, compile apithreads.c with no optimization.
# The problem is that when compiled with -O then it fails
# to link with following messages:
#
#  objmingw\apithreads.obj:apithreads.c:(.xdata+0x50): undefined reference to `.l_endw'
#
# The reason is yet unknown, but it has something to do with SEH
# handlers.
!if defined(USEMINGW64)
$(OBJDIR)\apithreads.$(O): apithreads.c
	$(CC) -c -o "$@" $(CC_FLAGS) -O0 apithreads.c
!endif

$(OBJDIR)\send.$(O): send.c
	$(CC) -c -o "$@" $(CC_FLAGS) -Werror send.c

$(OBJDIR)\backtrace.$(O): backtrace.c
	$(CC) -c -o "$@" $(CC_FLAGS) -Werror backtrace.c

$(OBJDIR)\stxmain.$(O): stxmain.c
	$(CC) -c -o "$@" $(CC_FLAGS) -Werror stxmain.c

$(OBJDIR)\errhandler.$(O): errhandler.c
	$(CC) -c -o "$@" $(CC_FLAGS) -Werror errhandler.c

$(OBJDIR)\jinterpret.$(O): jinterpret.c
	$(CC) -c -o "$@" $(CC_FLAGS) -Werror jinterpret.c

$(OBJDIR)\jsupport.$(O): jsupport.c
	$(CC) -c -o "$@" $(CC_FLAGS) -Werror jsupport.c


$(OBJDIR)\interpret.$(O): interpret.c
	$(CC) -c -o "$@" $(CC_FLAGS) -O1 interpret.c

$(OBJDIR)\util.$(O): util.c
	$(CC) -c -o "$@" $(CC_FLAGS) -Werror util.c

$(OBJDIR)\hmm.$(O): hmm.c
	$(CC) -c -o "$@" $(CC_FLAGS) -Werror hmm.c

$(OBJDIR)\debug.$(O): debug.c
	$(CC) -c -o "$@" $(CC_FLAGS) -Werror debug.c

$(OBJDIR)\char.$(O): char.c
	$(CC) -c -o "$@" $(CC_FLAGS) -Werror char.c


$(OBJDIR)\mcompiler.$(O): mcompiler.c
	$(CC) -c -o "$@" $(CC_FLAGS) -Wno-unused-function -Wno-unused-variable -Wno-unused-but-set-variable -Wno-unused-label mcompiler.c

.c.$(O):
	$(CC) -c -o "$@" $(CC_FLAGS) $<



.suffixes .rc .res

.rc.res:
	$(RC) --input="$<" --output="$@"

!endif
