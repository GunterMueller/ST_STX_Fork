"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaBenchmarkMisc
	instanceVariableNames:'booted'
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java'
!


!JavaBenchmarkMisc class methodsFor:'running'!

run
    ^ (BenchmarkSuite class:self) run

    "Created: / 10-06-2013 / 21:53:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run: benchmark
    ^ (BenchmarkInstance class:self selector:benchmark) run

    "Created: / 31-05-2013 / 10:39:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-06-2013 / 21:53:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spy: benchmark
    ^ (BenchmarkInstance class:self selector:benchmark) spy

    "Created: / 21-05-2014 / 10:57:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmarkMisc methodsFor:'benchmarks'!

groovy3plus4
    <benchmark: 'Groovy 3 + 4'>

    (Java classForName:'stx.libjava.benchmarks.Groovy') new runBenchmarkJ: 100

    "Created: / 09-04-2015 / 23:26:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-04-2015 / 17:25:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 14-09-2015 / 18:22:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lockingNoContentionNesting0
    <benchmark: 'Locking (no contention, no nesting'>

    | o b0 |
    o := (Java classForName:'java.lang.Object') new.
    b0 := [  ].
    1000000 timesRepeat:[
        o synchronized: b0
    ].

    "
    JavaBenchmarkMisc run: #lockingNoContentionNesting0
    "

    "Created: / 18-03-2017 / 22:14:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lockingNoContentionNesting1
    <benchmark: 'Locking (no contention, nesting depth 1'>

    | o b0 b1 |
    o := (Java classForName:'java.lang.Object') new.
    b0 := [  ].
    b1 := [ o synchronized: b0 ].
    1000000 timesRepeat:[
        o synchronized: b1
    ].

    "
    JavaBenchmarkMisc run: #lockingNoContentionNesting1
    "

    "Created: / 18-03-2017 / 22:15:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lockingNoContentionNesting2
    <benchmark: 'Locking (no contention, nesting depth 1'>

    | o b0 b1 b2 |
    o := (Java classForName:'java.lang.Object') new.
    b0 := [  ].
    b1 := [ o synchronized: b0 ].
    b2 := [ o synchronized: b1 ].
    1000000 timesRepeat:[
        o synchronized: b2
    ].

    "
    JavaBenchmarkMisc run: #lockingNoContentionNesting2
    "

    "Created: / 18-03-2017 / 22:16:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saxon
    <benchmark: 'Saxon'>

    (Java classForName:'stx.libjava.benchmarks.Saxon')
        new runBenchmarkJ: 100

    "Created: / 11-04-2015 / 17:27:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

urlClassLoaderGetResourceFail
    <benchmark: 'URLClassLoader.getResource() - fail'>

    | cl |
    cl := (Java classForName:'stx.libjava.benchmarks.Groovy') classLoader.
    5000 timesRepeat:[
        cl getResource: 'some.bogus.resource'
    ]

    "
    JavaBenchmarkMisc run: #urlClassLoaderGetResourceFail
    "

    "Created: / 14-09-2015 / 18:43:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

urlClassLoaderGetResourceFindInBootstrap
    <benchmark: 'URLClassLoader.getResource() - find in bootstrap CL'>

    | cl |
    cl := (Java classForName:'stx.libjava.benchmarks.Groovy') classLoader.
    5000 timesRepeat:[
        cl getResource: 'java/lang/Object.class'
    ]

    "
    JavaBenchmarkMisc run: #urlClassLoaderGetResourceFindInBootstrap
    "

    "Created: / 14-09-2015 / 18:47:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

urlClassLoaderGetResourceFindInHere
    <benchmark: 'URLClassLoader.getResource() - find in here'>

    | cl |
    cl := (Java classForName:'stx.libjava.benchmarks.Groovy') classLoader.
    5000 timesRepeat:[
        cl getResource: 'stx/libjava/benchmarks/Groovy.class'
    ]

    "
    JavaBenchmarkMisc run: #urlClassLoaderGetResourceFindInHere
    "

    "Created: / 14-09-2015 / 18:47:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmarkMisc methodsFor:'running'!

setUp
    <setup>

    booted := JavaVM booted.

    booted ifTrue:[
        "
        Smalltalk isStandAloneApp ifFalse:[
            Display notNil ifTrue:[
                (Dialog confirm: 'Java has to be rebooted in order to run a JavaClassReader benchmark. Reboot?') ifFalse:[
                    AbortOperationRequest raise.
                    self error:'Abort benchmark'.
                    ^ self.
                ].
            ].
        ].
        JavaVM reboot.
        "
    ] ifFalse:[
        JavaVM boot.
    ].

    Java classForName: 'stx.libjava.benchmarks.Groovy'.
    Java classForName: 'stx.libjava.benchmarks.Saxon'.

    "Created: / 21-05-2014 / 11:24:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-03-2017 / 22:17:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    <teardown>

    "
    booted ifFalse:[
        Java flushAllJavaResources.
    ].
    "
    ObjectMemory garbageCollect.

    "Created: / 21-05-2014 / 11:29:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmarkMisc class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

