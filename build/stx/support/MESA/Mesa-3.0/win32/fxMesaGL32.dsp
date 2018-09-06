# Microsoft Developer Studio Project File - Name="accel_fxMesaGL32" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 5.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=accel_fxMesaGL32 - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "fxMesaGL32.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "fxMesaGL32.mak" CFG="accel_fxMesaGL32 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "accel_fxMesaGL32 - Win32 Release" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE "accel_fxMesaGL32 - Win32 Debug" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "accel_fxMesaGL32 - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release\fxMesaGL32"
# PROP BASE Intermediate_Dir "Release\fxMesaGL32"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release\fxMesaGL32"
# PROP Intermediate_Dir "Release\fxMesaGL32"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /G5 /MD /W3 /Zi /Ot /Oa /Oi /Oy /Ob2 /I "..\src" /I "..\include" /D "NDEBUG" /D "FX" /D "FX_SILENT" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /D "BUILD_GL32" /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /o NUL /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /o NUL /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386
# ADD LINK32 glide2x.lib kernel32.lib user32.lib gdi32.lib msvcrt.lib oldnames.lib /nologo /subsystem:windows /dll /pdb:"..\lib\FX\OpenGL32.pdb" /map:"..\lib\FX\OpenGL32.map" /debug /machine:I386 /out:"..\lib\FX\OpenGL32.DLL" /implib:"..\lib\FX\OpenGL32.lib" /libpath:"../lib"
# SUBTRACT LINK32 /pdb:none

!ELSEIF  "$(CFG)" == "accel_fxMesaGL32 - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug\fxMesaGL32"
# PROP BASE Intermediate_Dir "Debug\fxMesaGL32"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug\fxMesaGL32"
# PROP Intermediate_Dir "Debug\fxMesaGL32"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /G5 /MDd /W3 /Zi /Od /I "..\src" /I "..\include" /D "_DEBUG" /D "FX" /D "FX_SILENT" /D "_WIN32" /D "WIN32" /D "_WINDOWS" /D "__MSC__" /D "__WIN32__" /D "WINDOWS_NT" /D "NO_PARALLEL" /D "NO_STEREO" /D "BUILD_GL32" /YX /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o NUL /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o NUL /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /pdbtype:sept
# ADD LINK32 glide2x.lib kernel32.lib user32.lib gdi32.lib msvcrtd.lib oldnames.lib /nologo /subsystem:windows /dll /profile /map:"..\lib\FX\OpenGL32d.map" /debug /machine:I386 /nodefaultlib /out:"..\lib\FX\OpenGL32d.dll" /implib:"..\lib\FX\OpenGL32d.lib" /libpath:"../lib"

!ENDIF 

# Begin Target

# Name "accel_fxMesaGL32 - Win32 Release"
# Name "accel_fxMesaGL32 - Win32 Debug"
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
# Begin Group "headers"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\include\GL\gl.h
# End Source File
# Begin Source File

SOURCE=..\include\GL\gl_mangle.h
# End Source File
# Begin Source File

SOURCE=..\include\GL\glu.h
# End Source File
# Begin Source File

SOURCE=..\include\GL\glu_mangle.h
# End Source File
# Begin Source File

SOURCE=..\include\GL\glx.h
# End Source File
# Begin Source File

SOURCE=..\include\GL\glx_mangle.h
# End Source File
# Begin Source File

SOURCE=..\include\GL\osmesa.h
# End Source File
# Begin Source File

SOURCE=..\include\GL\osmesa3.h
# End Source File
# Begin Source File

SOURCE=..\include\GL\wmesa.h
# End Source File
# End Group
# Begin Group "dd-3dfx"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\src\FX\fxapi.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxdd.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxddtex.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxdrv.h
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxlines.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxpoints.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxquads.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxrender.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxrender.h
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxsetup.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxspan.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxtexman.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxtris.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxvsetup.c
# End Source File
# Begin Source File

SOURCE=..\src\FX\fxwgl.c
# End Source File
# End Group
# Begin Group "dd-osmesa"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\src\OSmesa\osmesa.c
# End Source File
# End Group
# Begin Source File

SOURCE=.\res\fxMesaGL32.def
# End Source File
# Begin Source File

SOURCE=.\res\fxMesaGL32.rc
# End Source File
# End Target
# End Project
