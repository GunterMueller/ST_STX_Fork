# Microsoft Developer Studio Project File - Name="core_MesaGLU" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 5.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=core_MesaGLU - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "mesaglu.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "mesaglu.mak" CFG="core_MesaGLU - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "core_MesaGLU - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "core_MesaGLU - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe

!IF  "$(CFG)" == "core_MesaGLU - Win32 Release"

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
# ADD CPP /nologo /G5 /W3 /Zi /Ot /Oa /Oi /Oy /Ob2 /I "..\src-glu" /I "..\include" /D "NDEBUG" /D "MMX" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /YX /FD /c
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo /out:"..\lib\MesaGLU.lib"

!ELSEIF  "$(CFG)" == "core_MesaGLU - Win32 Debug"

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
# ADD CPP /nologo /G5 /W3 /Zi /Od /I "..\src-glu" /I "..\include" /D "_DEBUG" /D "MMX" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /YX /FD /c
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo /out:"..\lib\MesaGLUd.lib"

!ENDIF 

# Begin Target

# Name "core_MesaGLU - Win32 Release"
# Name "core_MesaGLU - Win32 Debug"
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
# End Target
# End Project
