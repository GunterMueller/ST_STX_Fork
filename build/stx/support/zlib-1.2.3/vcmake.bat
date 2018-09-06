@if not defined VSINSTALLDIR (
	call ..\..\rules\vcsetup.bat
)
make.exe -N -f win32\Makefile.msvc TOP=..\.. %1 %2
