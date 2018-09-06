"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaBenchmarkClassReader
	instanceVariableNames:'booted rt_dot_jar groovy_all_X_Y_dot_jar saxon_A_B_C_D_dot_jar
		classfiles1 classfiles2 classfiles3'
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java'
!


!JavaBenchmarkClassReader class methodsFor:'running'!

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

!JavaBenchmarkClassReader methodsFor:'benchmarks'!

benchmarkReadClasses1
    <benchmark: 'Read .class files 1'>

    "
    Reads set of classes which contains natives. Actually, compiling native proxies
    take most of the time
    "

    100 timesRepeat:[
        classfiles1 do:[:each |
            JavaClassReader readStream: each readStream
        ].
    ]

    "Created: / 21-05-2014 / 14:04:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 21-05-2014 / 16:31:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkReadClasses2
    <benchmark: 'Read .class files 2'>

    "
    Reads set of classes which contains smalltalk extensions. Most of the time is spent
    in compiling an installing those extension methods
    "

    200 timesRepeat:[
        classfiles2 do:[:each |
            JavaClassReader readStream: each readStream
        ].
    ]

    "Created: / 21-05-2014 / 16:30:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkReadClasses3
    <benchmark: 'Read .class files 3'>

    "
    Reads set of classes which contain no extensions nor native methods. This is the most
    common case
    "

    200 timesRepeat:[
        classfiles3 do:[:each |
            JavaClassReader readStream: each readStream
        ].
    ]

    "Created: / 21-05-2014 / 16:30:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkReadGroovyJar
    "/ Does not work, contains some classes that requires ant to be loaded, sigh
    "/    <benchmark: 'Read groovy-all-X.Y.jar'>

    JavaVM loadClassesIn:groovy_all_X_Y_dot_jar

    "Created: / 21-05-2014 / 11:29:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkReadSaxonJar
    <benchmark: 'Read saxon-A.B.C.D.jar'>
    JavaVM loadClassesIn:saxon_A_B_C_D_dot_jar

    "Created: / 21-05-2014 / 11:40:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmarkClassReader methodsFor:'running'!

setUp
    <setup>

    | bundle lib archive |

    booted := JavaVM booted.

    booted ifTrue:[
        Smalltalk isStandAloneApp ifFalse:[
            Display notNil ifTrue:[
                (Dialog confirm: 'Java has to be rebooted in order to run a JavaClassReader benchmark. Reboot?') ifFalse:[
                    AbortOperationRequest raise.
                    self error:'Abort benchmark'.
                    ^ self.
                ].
            ].
        ].
        booted := false.
        JavaVM reboot.
    ] ifFalse:[
        JavaVM boot.
    ].


    bundle := (Smalltalk at:#'stx_libjava') javaBundle.
    lib := bundle allLibraries detect:[:each | each name startsWith: 'groovy-all' ] ifNone:[ self error: 'Cannot find Groovy .jar' ].
    groovy_all_X_Y_dot_jar := lib classes.

    Smalltalk loadPackage: 'stx:libjava/libs'.
    bundle := (Smalltalk at:#'stx_libjava_libs') javaBundle.
    lib := bundle allLibraries detect:[:each | each name startsWith: 'saxon' ] ifNone:[ self error: 'Cannot find Saxon .jar' ].
    saxon_A_B_C_D_dot_jar := lib classes.

    Smalltalk loadPackage: 'stx:libjava/libs'.
    bundle := Java release javaBundle.
    lib := bundle allLibraries detect:[:each | each name startsWith: 'rt.jar' ] ifNone:[ self error: 'Cannot find rt.jar' ].
    rt_dot_jar := lib classes.

    archive := ZipArchive oldFileNamed: rt_dot_jar.
    classfiles1 := #(
        'java/lang/Object.class'
        'java/lang/String.class'
        'java/lang/System.class'
        'java/lang/Class.class'
        'java/lang/ClassLoader.class'
    ) collect:[:each |  archive extract: each ] .

    classfiles2 := #(
        'java/util/Map.class'
        'java/util/List.class'
        'java/util/Collection.class'
    ) collect:[:each |  archive extract: each ].

    classfiles3 := #(
        'java/util/Vector.class'
        'java/util/ArrayList.class'
        'java/util/HashMap.class'
        'java/util/HashSet.class'
    ) collect:[:each |  archive extract: each ].

    "Created: / 21-05-2014 / 11:24:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-09-2016 / 00:28:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    <teardown>

    booted ifFalse:[
        Java flushAllJavaResources.
    ].
    ObjectMemory garbageCollect.

    "Created: / 21-05-2014 / 11:29:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmarkClassReader class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

