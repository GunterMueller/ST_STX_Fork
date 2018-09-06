..\..\
set PATH_ORIG=%PATH%
set PATH=%MINGW_DIR%\bin;%MINGW_DIR%\MSYS\1.0\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%PATH%
if not exist makefile (
	bash configure
)
make
set PATH=%PATH_ORIG%
