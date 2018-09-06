# Microsoft Developer Studio Project File - Name="core_MesaGL" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 5.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=core_MesaGL - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "mesagl.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "mesagl.mak" CFG="core_MesaGL - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "core_MesaGL - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "core_MesaGL - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe

!IF  "$(CFG)" == "core_MesaGL - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release\Mesa"
# PROP BASE Intermediate_Dir "Release\Mesa"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release\Mesa"
# PROP Intermediate_Dir "Release\Mesa"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /G5 /W3 /Zi /Ot /Oa /Oi /Oy /Ob2 /I "..\src" /I "..\include" /D "NDEBUG" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /YX /FD /c
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo /out:"..\lib\MesaGL.lib"

!ELSEIF  "$(CFG)" == "core_MesaGL - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug\Mesa"
# PROP BASE Intermediate_Dir "Debug\Mesa"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug\Mesa"
# PROP Intermediate_Dir "Debug\Mesa"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /G5 /W3 /Zi /Od /I "..\src" /I "..\include" /D "_DEBUG" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /YX /FD /c
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo /out:"..\lib\MesaGLd.lib"

!ENDIF 

# Begin Target

# Name "core_MesaGL - Win32 Release"
# Name "core_MesaGL - Win32 Debug"
# Begin Group "core"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\src\accum.c
# End Source File
# Begin Source File

SOURCE=..\src\accum.h
# End Source File
# Begin Source File

SOURCE=..\src\alpha.c
# End Source File
# Begin Source File

SOURCE=..\src\alpha.h
# End Source File
# Begin Source File

SOURCE=..\src\alphabuf.c
# End Source File
# Begin Source File

SOURCE=..\src\alphabuf.h
# End Source File
# Begin Source File

SOURCE=..\src\api.h
# End Source File
# Begin Source File

SOURCE=..\src\api1.c
# End Source File
# Begin Source File

SOURCE=..\src\api2.c
# End Source File
# Begin Source File

SOURCE=..\src\apiext.c
# End Source File
# Begin Source File

SOURCE=..\src\attrib.c
# End Source File
# Begin Source File

SOURCE=..\src\attrib.h
# End Source File
# Begin Source File

SOURCE=..\src\bitmap.c
# End Source File
# Begin Source File

SOURCE=..\src\bitmap.h
# End Source File
# Begin Source File

SOURCE=..\src\blend.c
# End Source File
# Begin Source File

SOURCE=..\src\blend.h
# End Source File
# Begin Source File

SOURCE=..\src\clip.c
# End Source File
# Begin Source File

SOURCE=..\src\clip.h
# End Source File
# Begin Source File

SOURCE=..\src\colortab.c
# End Source File
# Begin Source File

SOURCE=..\src\colortab.h
# End Source File
# Begin Source File

SOURCE=..\src\config.h
# End Source File
# Begin Source File

SOURCE=..\src\context.c
# End Source File
# Begin Source File

SOURCE=..\src\context.h
# End Source File
# Begin Source File

SOURCE=..\src\copypix.c
# End Source File
# Begin Source File

SOURCE=..\src\copypix.h
# End Source File
# Begin Source File

SOURCE=..\src\depth.c
# End Source File
# Begin Source File

SOURCE=..\src\depth.h
# End Source File
# Begin Source File

SOURCE=..\src\dlist.c
# End Source File
# Begin Source File

SOURCE=..\src\dlist.h
# End Source File
# Begin Source File

SOURCE=..\src\drawpix.c
# End Source File
# Begin Source File

SOURCE=..\src\drawpix.h
# End Source File
# Begin Source File

SOURCE=..\src\enable.c
# End Source File
# Begin Source File

SOURCE=..\src\enable.h
# End Source File
# Begin Source File

SOURCE=..\src\eval.c
# End Source File
# Begin Source File

SOURCE=..\src\eval.h
# End Source File
# Begin Source File

SOURCE=..\src\feedback.c
# End Source File
# Begin Source File

SOURCE=..\src\feedback.h
# End Source File
# Begin Source File

SOURCE=..\src\fog.c
# End Source File
# Begin Source File

SOURCE=..\src\fog.h
# End Source File
# Begin Source File

SOURCE=..\src\get.c
# End Source File
# Begin Source File

SOURCE=..\src\get.h
# End Source File
# Begin Source File

SOURCE=..\src\hash.c
# End Source File
# Begin Source File

SOURCE=..\src\hash.h
# End Source File
# Begin Source File

SOURCE=..\src\image.c
# End Source File
# Begin Source File

SOURCE=..\src\image.h
# End Source File
# Begin Source File

SOURCE=..\src\light.c
# End Source File
# Begin Source File

SOURCE=..\src\light.h
# End Source File
# Begin Source File

SOURCE=..\src\lines.c
# End Source File
# Begin Source File

SOURCE=..\src\lines.h
# End Source File
# Begin Source File

SOURCE=..\src\logic.c
# End Source File
# Begin Source File

SOURCE=..\src\logic.h
# End Source File
# Begin Source File

SOURCE=..\src\masking.c
# End Source File
# Begin Source File

SOURCE=..\src\masking.h
# End Source File
# Begin Source File

SOURCE=..\src\matrix.c
# End Source File
# Begin Source File

SOURCE=..\src\matrix.h
# End Source File
# Begin Source File

SOURCE=..\src\misc.c
# End Source File
# Begin Source File

SOURCE=..\src\misc.h
# End Source File
# Begin Source File

SOURCE=..\src\mmath.c
# End Source File
# Begin Source File

SOURCE=..\src\mmath.h
# End Source File
# Begin Source File

SOURCE=..\src\mthreads.c
# End Source File
# Begin Source File

SOURCE=..\src\mthreads.h
# End Source File
# Begin Source File

SOURCE=..\src\pb.c
# End Source File
# Begin Source File

SOURCE=..\src\pb.h
# End Source File
# Begin Source File

SOURCE=..\src\pixel.c
# End Source File
# Begin Source File

SOURCE=..\src\pixel.h
# End Source File
# Begin Source File

SOURCE=..\src\pointers.c
# End Source File
# Begin Source File

SOURCE=..\src\pointers.h
# End Source File
# Begin Source File

SOURCE=..\src\points.c
# End Source File
# Begin Source File

SOURCE=..\src\points.h
# End Source File
# Begin Source File

SOURCE=..\src\polygon.c
# End Source File
# Begin Source File

SOURCE=..\src\polygon.h
# End Source File
# Begin Source File

SOURCE=..\src\quads.c
# End Source File
# Begin Source File

SOURCE=..\src\quads.h
# End Source File
# Begin Source File

SOURCE=..\src\rastpos.c
# End Source File
# Begin Source File

SOURCE=..\src\rastpos.h
# End Source File
# Begin Source File

SOURCE=..\src\readpix.c
# End Source File
# Begin Source File

SOURCE=..\src\readpix.h
# End Source File
# Begin Source File

SOURCE=..\src\rect.c
# End Source File
# Begin Source File

SOURCE=..\src\rect.h
# End Source File
# Begin Source File

SOURCE=..\src\scissor.c
# End Source File
# Begin Source File

SOURCE=..\src\scissor.h
# End Source File
# Begin Source File

SOURCE=..\src\shade.c
# End Source File
# Begin Source File

SOURCE=..\src\shade.h
# End Source File
# Begin Source File

SOURCE=..\src\span.c
# End Source File
# Begin Source File

SOURCE=..\src\span.h
# End Source File
# Begin Source File

SOURCE=..\src\stencil.c
# End Source File
# Begin Source File

SOURCE=..\src\stencil.h
# End Source File
# Begin Source File

SOURCE=..\src\teximage.c
# End Source File
# Begin Source File

SOURCE=..\src\teximage.h
# End Source File
# Begin Source File

SOURCE=..\src\texobj.c
# End Source File
# Begin Source File

SOURCE=..\src\texobj.h
# End Source File
# Begin Source File

SOURCE=..\src\texstate.c
# End Source File
# Begin Source File

SOURCE=..\src\texstate.h
# End Source File
# Begin Source File

SOURCE=..\src\texture.c
# End Source File
# Begin Source File

SOURCE=..\src\texture.h
# End Source File
# Begin Source File

SOURCE=..\src\triangle.c
# End Source File
# Begin Source File

SOURCE=..\src\triangle.h
# End Source File
# Begin Source File

SOURCE=..\src\varray.c
# End Source File
# Begin Source File

SOURCE=..\src\varray.h
# End Source File
# Begin Source File

SOURCE=..\src\vb.c
# End Source File
# Begin Source File

SOURCE=..\src\vb.h
# End Source File
# Begin Source File

SOURCE=..\src\vbfill.c
# End Source File
# Begin Source File

SOURCE=..\src\vbfill.h
# End Source File
# Begin Source File

SOURCE=..\src\vbrender.c
# End Source File
# Begin Source File

SOURCE=..\src\vbrender.h
# End Source File
# Begin Source File

SOURCE=..\src\vbxform.c
# End Source File
# Begin Source File

SOURCE=..\src\vbxform.h
# End Source File
# Begin Source File

SOURCE=..\src\winpos.c
# End Source File
# Begin Source File

SOURCE=..\src\winpos.h
# End Source File
# Begin Source File

SOURCE=..\src\xform.c
# End Source File
# Begin Source File

SOURCE=..\src\xform.h
# End Source File
# Begin Source File

SOURCE=..\src\zoom.c
# End Source File
# Begin Source File

SOURCE=..\src\zoom.h
# End Source File
# End Group
# Begin Group "win32"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\src\Windows\colors.h
# End Source File
# Begin Source File

SOURCE=..\src\Windows\wmesa.c
# End Source File
# End Group
# Begin Group "off-screen"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\src\OSmesa\osmesa.c
# End Source File
# End Group
# End Target
# End Project
