# Microsoft Developer Studio Project File - Name="core_MesaGLUT32" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 5.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=core_MesaGLUT32 - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "MesaGLUT32.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "MesaGLUT32.mak" CFG="core_MesaGLUT32 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "core_MesaGLUT32 - Win32 Release" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE "core_MesaGLUT32 - Win32 Debug" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "core_MesaGLUT32 - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release\MesaGLUT32"
# PROP BASE Intermediate_Dir "Release\MesaGLUT32"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release\MesaGLUT32"
# PROP Intermediate_Dir "Release\MesaGLUT32"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /G5 /MD /W3 /Zi /Ot /Oa /Oi /Oy /Ob2 /I "..\src-glut" /I "..\include" /D "NDEBUG" /D "BUILD_GLUT32" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /D "W32_MESA" /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /o NUL /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /o NUL /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386
# ADD LINK32 GLU32.lib OpenGL32.lib msvcrt.lib winmm.lib kernel32.lib user32.lib gdi32.lib oldnames.lib /nologo /subsystem:windows /dll /pdb:"..\lib\GLUT32.pdb" /map:"..\lib\GLUT32.map" /debug /machine:I386 /out:"..\lib\GLUT32.DLL" /implib:"..\lib\GLUT32.lib" /libpath:"../lib"
# SUBTRACT LINK32 /pdb:none

!ELSEIF  "$(CFG)" == "core_MesaGLUT32 - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug\MesaGLUT32"
# PROP BASE Intermediate_Dir "Debug\MesaGLUT32"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug\MesaGLUT32"
# PROP Intermediate_Dir "Debug\MesaGLUT32"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /G5 /MDd /W3 /Zi /Od /I "..\src-glut" /I "..\include" /D "_DEBUG" /D "BUILD_GLUT32" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /D "W32_MESA" /YX /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o NUL /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o NUL /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /pdbtype:sept
# ADD LINK32 GLU32d.lib OpenGL32d.lib msvcrtd.lib winmm.lib kernel32.lib user32.lib gdi32.lib oldnames.lib /nologo /subsystem:windows /dll /profile /map:"..\lib\GLUT32d.map" /debug /machine:I386 /out:"..\lib\GLUT32d.DLL" /implib:"..\lib\GLUT32d.lib" /libpath:"../lib"

!ENDIF 

# Begin Target

# Name "core_MesaGLUT32 - Win32 Release"
# Name "core_MesaGLUT32 - Win32 Debug"
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
# Begin Source File

SOURCE=.\res\mesaglut32.def
# End Source File
# Begin Source File

SOURCE=.\res\mesaglut32.rc
# End Source File
# End Target
# End Project
