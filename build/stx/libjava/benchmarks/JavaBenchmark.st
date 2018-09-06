"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaBenchmark
	instanceVariableNames:'profiler'
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Framework'
!

!JavaBenchmark class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaBenchmark methodsFor:'accessing'!

profiler
    ^ profiler
!

profiler:something
    profiler := something.
! !

!JavaBenchmark methodsFor:'profiling'!

profileStart
    profiler == #callgrind ifTrue:[
        Profiler valgrind callgrindInstrumentationStart
    ].

    "Created: / 02-11-2012 / 02:28:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

profileStop
    profiler == #callgrind ifTrue:[
        Profiler valgrind callgrindInstrumentationStop
    ].

    "Created: / 02-11-2012 / 02:28:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmark methodsFor:'running'!

runBenchmarkJ: n
    "Actually run a **Java** benchmark. Return time in milliseconds or
     string 'N/A' if there is no Java equivalent of the benchmark"

    | bench |

    bench := (Java classForName: 'stx.libjava.benchmarks.' , self class name).

    ^(bench >> #'runBenchmarkJ(I)J')
        valueWithReceiver: bench arguments: (Array with: n)

    "Created: / 31-10-2012 / 10:31:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-10-2012 / 21:42:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 31-10-2012 / 22:52:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runBenchmarkS2J: n
    "Actually run a cross-language call variant of the benchmark
     (i.e., Smalltalk calling Java or vice versa). Return time in milliseconds or
     string 'N/A' if there is no cross-call equivalent of the benchmark"

    ^'N/A'

    "Created: / 31-10-2012 / 23:39:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runBenchmarkS:n 
    "Actually run a **Smalltalk** benchmark. Return time in milliseconds or
     string 'N/A' if there is no Smalltalk equivalent of the benchmark"
    
    ^ self subclassResponsibility

    "Created: / 31-10-2012 / 10:26:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmark methodsFor:'running-API'!

runJ: passes
    "Run **Java** version of the benchmark. Do the warmup"

    | time |

    "Here, we have to do the warmup twice. First, to
     load all the Java code and an make sure methods
     are in oldspace (for ILCs), second to force resolve
     and machine-compile Java code"

    JavaVM booted ifFalse:[
        Java flushAllJavaResources.
        Java initialize.
        JavaVM initializeVM.
    ].

    self runBenchmarkJ: (passes / 2) rounded.
    ObjectMemory scavenge.
    ObjectMemory tenure.
    self runBenchmarkJ: (passes / 2) rounded.

    Transcript showCR: '*** RUNNING BENCHMARK ***'.
    ObjectMemory debugBreakPoint3.
    self profileStart.
    time := self runBenchmarkJ: passes.
    self profileStop.
    Transcript showCR: '*** DONE ************ ***'.
    JavaVM performance printCountersOn: Stdout.
    ^time.

    "Created: / 31-10-2012 / 11:15:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-11-2012 / 20:41:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runS2J: passes
    "Run **cross-language** version of the benchmark. Do the warmup"

    | time |

    "Here, we have to do the warmup twice. First, to
     load all the Java code and an make sure methods
     are in oldspace (for ILCs), second to force resolve
     and machine-compile Java code"

    JavaVM booted ifFalse:[
        Java flushAllJavaResources.
        Java initialize.
        JavaVM initializeVM.
    ].

    self runBenchmarkS2J: 2.
    ObjectMemory scavenge.
    ObjectMemory tenure.
    self runBenchmarkS2J: 2.

    self profileStart.
    time := self runBenchmarkS2J: passes.
    self profileStop.
    JavaVM performance printCountersOn: Stdout.
    ^time.

    "Created: / 31-10-2012 / 23:40:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-11-2012 / 20:41:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runS: passes
    "Run **Smalltalk** version of the benchmark. Do the warmup"

    | time |

    ObjectMemory justInTimeCompilation: true.
    
    self runBenchmarkS: 2.
    ObjectMemory scavenge.
    ObjectMemory tenure.
    self runBenchmarkS: 2.
    self profileStart.
    time := self runBenchmarkS: passes.
    self profileStop.
    ^time

    "Created: / 31-10-2012 / 11:12:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2012 / 02:31:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmark class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/JavaBenchmark.st,v 1.5 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

