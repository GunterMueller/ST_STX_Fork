# Microsoft Developer Studio Project File - Name="core_MesaGLUT" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 5.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=core_MesaGLUT - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "mesaglut.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "mesaglut.mak" CFG="core_MesaGLUT - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "core_MesaGLUT - Win32 Release" (based on\
 "Win32 (x86) Static Library")
!MESSAGE "core_MesaGLUT - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe

!IF  "$(CFG)" == "core_MesaGLUT - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release\MesaGLU"
# PROP BASE Intermediate_Dir "Release\MesaGLU"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release\MesaGLU"
# PROP Intermediate_Dir "Release\MesaGLU"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /G5 /W3 /Zi /Ot /Oa /Oi /Oy /Ob2 /I "..\src-glut" /I "..\include" /D "NDEBUG" /D "MMX" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /D "W32_MESA" /Fp"Release\MesaGLUT/mesaglut.pch" /YX /Fo"Release\MesaGLUT/" /Fd"Release\MesaGLUT/" /FD /c
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo /out:"..\lib\MesaGLUT.lib"

!ELSEIF  "$(CFG)" == "core_MesaGLUT - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug\MesaGLU"
# PROP Intermediate_Dir "Debug\MesaGLU"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /G5 /W3 /Zi /Od /I "..\src" /I "..\include" /D "_DEBUG" /D "MMX" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /D "W32_MESA" /Fp"Debug\MesaGLUT/mesaglut.pch" /YX /Fo"Debug\MesaGLUT/" /Fd"Debug\MesaGLUT/" /FD /c
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo /out:"..\lib\MesaGLUTd.lib"

!ENDIF 

# Begin Target

# Name "core_MesaGLUT - Win32 Release"
# Name "core_MesaGLUT - Win32 Debug"
# Begin Group "core"

# PROP Default_Filter ""
# Begin Source File

SOURCE="..\src-glut\glut_8x13.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_9x15.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_bitmap.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_bwidth.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_cindex.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_cmap.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_cursor.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_dials.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_dstr.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_event.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_ext.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_fullscrn.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_gamemode.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_get.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_hel10.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_hel12.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_hel18.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_init.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_input.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_joy.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_key.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_keyctrl.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_keyup.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_mesa.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_modifier.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_mroman.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_overlay.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_roman.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_shapes.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_space.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_stroke.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_swap.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_swidth.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_tablet.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_teapot.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_tr10.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_tr24.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_util.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_vidresize.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_warp.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_win.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glut_winmisc.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glutbitmap.h"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glutint.h"
# End Source File
# Begin Source File

SOURCE="..\src-glut\glutstroke.h"
# End Source File
# Begin Source File

SOURCE="..\src-glut\stroke.h"
# End Source File
# End Group
# Begin Group "win32"

# PROP Default_Filter ""
# Begin Source File

SOURCE="..\src-glut\glutwin32.h"
# End Source File
# Begin Source File

SOURCE="..\src-glut\win32_glx.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\win32_glx.h"
# End Source File
# Begin Source File

SOURCE="..\src-glut\win32_menu.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\win32_util.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\win32_winproc.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\win32_x11.c"
# End Source File
# Begin Source File

SOURCE="..\src-glut\win32_x11.h"
# End Source File
# End Group
# Begin Group "headers"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\include\GL\glut.h
# End Source File
# End Group
# End Target
# End Project
