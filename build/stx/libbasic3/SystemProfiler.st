"
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SystemProfiler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Profiler'
!

Object subclass:#Valgrind
	instanceVariableNames:''
	classVariableNames:'Instance'
	poolDictionaries:''
	privateIn:SystemProfiler
!

!SystemProfiler primitiveDefinitions!
%{

#include "stx_libbasic3-config.h"

#ifdef HAS_VALGRIND
# include <valgrind/valgrind.h>
# ifdef HAS_CALLGRIND
#  include <valgrind/callgrind.h>
# endif
#endif

%}
! !

!SystemProfiler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    This class exposes API for systems-being-profiled provided
    by Valgrind (and in future maybe by some others, OProfile, CodeXL 
    comes to mind). The APIs exposed depends on the profiler itself, 
    so no aim for an unified API here.

    Historical note: This class used to be called Profiler and
    also served as an entrypoint for the VM's builtin bytecode-counting
    profiler I (JV) wrote for CellStore guys back then. However, 
    it has never been used, not even by them. For practical profiling,
    system profiler such a Valgrind/Callgrind or AMD's CodeXL gives
    much better insight. Thus the bytecode-counting profiler has been
    obsoleted.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        http://valgrind.org/
        http://oprofile.sourceforge.net/news/

"
! !

!SystemProfiler class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ For backward compatibility. See "Historical note" in #documentation
    Profiler := self.

    "Modified (comment): / 31-05-2016 / 22:16:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SystemProfiler class methodsFor:'accessing'!

valgrind
    "Returns an interface object to control
     valgrind profiler"

    ^Valgrind theOneAndOnlyInstance

    "Created: / 01-11-2012 / 22:19:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SystemProfiler::Valgrind class methodsFor:'documentation'!

documentation
"
    A Smalltalk interface to control callgrind profiler.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        Callgrind 
            http://valgrind.org/docs/manual/cl-manual.html
        KCachegrind
            http://kcachegrind.sourceforge.net/html/Home.html

"
! !

!SystemProfiler::Valgrind class methodsFor:'instance creation'!

flushSingleton
    "flushes the cached singleton"

    Instance := nil

    "
     self flushSingleton
    "
!

new
    "returns a singleton"

    ^ self theOneAndOnlyInstance.
!

theOneAndOnlyInstance
    "returns a singleton"

    Instance isNil ifTrue:[
        Instance := self basicNew initialize.
    ].
    ^ Instance.
! !

!SystemProfiler::Valgrind methodsFor:'callgrind-instrumentation'!

callgrindInstrumentationStart
    "Turn on callgrind instrumentation"

%{
#ifdef HAS_CALLGRIND
    CALLGRIND_START_INSTRUMENTATION;
    RETURN ( self );
#endif
%}.
    self error:'No callgrind support'

    "Created: / 01-11-2012 / 22:31:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

callgrindInstrumentationStop
    "Turn off callgrind instrumentation"

%{
#ifdef HAS_CALLGRIND
    CALLGRIND_STOP_INSTRUMENTATION;
    RETURN ( self );
#endif
%}.
    self error:'No callgrind support'

    "Created: / 01-11-2012 / 22:31:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SystemProfiler::Valgrind methodsFor:'queries'!

hasValgrindSupport
    "Return true, if valgrind support is compiled in, false otherwise"
%{
#ifdef HAS_VALGRIND
    RETURN ( true );
#endif
%}.
    ^ false

!

hasCallgrindSupport
    "Return true, if callgrind support is compiled in, false otherwise"
%{
#ifdef HAS_CALLGRIND
    RETURN ( true );
#endif
%}.
    ^ false

!

runningUnderValgrind
    "Return true, if the VM is running under valgrind,
     false otherwise"

%{
#ifdef HAS_VALGRIND
    RETURN ( (RUNNING_ON_VALGRIND) ? true : false );
#endif
%}.
    ^ false

    "Created: / 01-11-2012 / 22:31:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !




SystemProfiler initialize!
