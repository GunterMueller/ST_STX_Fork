# Microsoft Developer Studio Project File - Name="core_MesaGLU32" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 5.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=core_MesaGLU32 - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "MesaGLU32.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "MesaGLU32.mak" CFG="core_MesaGLU32 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "core_MesaGLU32 - Win32 Release" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE "core_MesaGLU32 - Win32 Debug" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "core_MesaGLU32 - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release\MesaGLU32"
# PROP BASE Intermediate_Dir "Release\MesaGLU32"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release\MesaGLU32"
# PROP Intermediate_Dir "Release\MesaGLU32"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /G5 /MD /W3 /Zi /Ot /Oa /Oi /Oy /Ob2 /I "..\src-glu" /I "..\include" /D "NDEBUG" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /D "BUILD_GLU32" /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /o NUL /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /o NUL /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386
# ADD LINK32 OpenGL32.lib kernel32.lib user32.lib gdi32.lib msvcrt.lib oldnames.lib /nologo /subsystem:windows /dll /pdb:"..\lib\GLU32.pdb" /map:"..\lib\GLU32.map" /debug /machine:I386 /out:"..\lib\GLU32.DLL" /implib:"..\lib\GLU32.lib" /libpath:"../lib"
# SUBTRACT LINK32 /pdb:none

!ELSEIF  "$(CFG)" == "core_MesaGLU32 - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug\MesaGLU32"
# PROP BASE Intermediate_Dir "Debug\MesaGLU32"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug\MesaGLU32"
# PROP Intermediate_Dir "Debug\MesaGLU32"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /G5 /MDd /W3 /Zi /Od /I "..\src-glu" /I "..\include" /D "_DEBUG" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /D "BUILD_GLU32" /YX /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o NUL /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o NUL /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /pdbtype:sept
# ADD LINK32 OpenGL32d.lib kernel32.lib user32.lib gdi32.lib msvcrtd.lib oldnames.lib /nologo /subsystem:windows /dll /profile /map:"..\lib\GLU32d.map" /debug /machine:I386 /out:"..\lib\GLU32d.DLL" /implib:"..\lib\GLU32d.lib" /libpath:"../lib"

!ENDIF 

# Begin Target

# Name "core_MesaGLU32 - Win32 Release"
# Name "core_MesaGLU32 - Win32 Debug"
# Begin Group "core"

# PROP Default_Filter ""
# Begin Source File

SOURCE="..\src-glu\glu.c"
# End Source File
# Begin Source File

SOURCE="..\src-glu\gluP.h"
# End Source File
# Begin Source File

SOURCE="..\src-glu\mipmap.c"
# End Source File
# Begin Source File

SOURCE="..\src-glu\nurbs.c"
# End Source File
# Begin Source File

SOURCE="..\src-glu\nurbs.h"
# End Source File
# Begin Source File

SOURCE="..\src-glu\nurbscrv.c"
# End Source File
# Begin Source File

SOURCE="..\src-glu\nurbssrf.c"
# End Source File
# Begin Source File

SOURCE="..\src-glu\nurbsutl.c"
# End Source File
# Begin Source File

SOURCE="..\src-glu\polytest.c"
# End Source File
# Begin Source File

SOURCE="..\src-glu\project.c"
# End Source File
# Begin Source File

SOURCE="..\src-glu\quadric.c"
# End Source File
# Begin Source File

SOURCE="..\src-glu\tess.c"
# End Source File
# Begin Source File

SOURCE="..\src-glu\tess.h"
# End Source File
# Begin Source File

SOURCE="..\src-glu\tesselat.c"
# End Source File
# End Group
# Begin Group "headers"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\include\GL\glu.h
# End Source File
# Begin Source File

SOURCE=..\include\GL\glu_mangle.h
# End Source File
# End Group
# Begin Source File

SOURCE=.\res\mesaglu32.def
# End Source File
# Begin Source File

SOURCE=.\res\mesaglu32.rc
# End Source File
# End Target
# End Project
