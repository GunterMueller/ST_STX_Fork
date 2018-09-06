pushd common
call mingwmake.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
popd 
pushd mercurial
call mingwmake.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
popd
