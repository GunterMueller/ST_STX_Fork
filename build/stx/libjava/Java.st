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
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Java
	instanceVariableNames:''
	classVariableNames:'Initialized Classes UnresolvedClassRefs Release BootBundle
		ClassPath ClassPathBundle SourcePath ClassPathExt ExtensionsPath
		ExtensionsPathPackages CacheDirectory JavaHome InternedStrings
		Java_lang_String Java_lang_Class PrettyPrintStyle
		LastArgumentString Threads ExcludedClassPath FailedToLoadClasses
		SourceCache SourceArchiveCache JavaClassLoaderQuerySignal
		ClassLoaderQuerySignal ThreadsAccess'
	poolDictionaries:'JavaVMData'
	category:'Languages-Java-Support'
!

!Java class methodsFor:'documentation'!

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

!Java class methodsFor:'accessing'!

classForName: aString
    "/JavaVM booted ifFalse:[JavaVM boot].

    | cls |

    "HACK, required to load extensions methods"
    cls := JavaClassQuery query: (aString copyReplaceAll:$. with: $/).
    cls isNil ifTrue:[
	cls := JavaVM classForName: aString.
    ].
    ^cls.

    "Modified: / 08-11-2012 / 00:25:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classNamed: aString
    ^JavaVM classNamed: aString.
!

classRegistry

    <resource: #obsolete>

    self breakPoint: #mh.
    self breakPoint: #jv.

    ^ JavaVM classRegistry.

    "Modified: / 21-10-2011 / 11:12:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

intern:aJavaString
    |stString internedString|

    "JV@2012-07-07: We MUST UTF8-encode the string as java.lang.String
     can keep both normal String and Unicode16String. Therefore it may
     happen that #intern: gets called once with Java string keeping
     characters in String and then with a String with same value but
     characters in Unicode16String.

     UTF8-encoding ensures that the key is single-byte string
     and thus #intern: will return the same interned string
     (actually it return whichever one comes first).
    "

    stString := (self as_ST_String:aJavaString) utf8Encoded.


    internedString := InternedStrings at:stString ifAbsent:nil.
    internedString isNil ifTrue:[
	InternedStrings at:stString put:aJavaString.
	internedString := aJavaString
    ].
    ^ internedString

    "Modified: / 07-07-2012 / 22:14:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaExtDirs

    ^Java release javaExtDirs

    "/ JV@2013-08-29: Do not add Smalltalk/X support classes nor groovy nor junit to the
    "/                ext path. They are then loaded by *ext* class loader and thus cannot
    "/                access classes defined in standard class path (as they are loaded by
    "/                system (*app*) class loader.
"/        , (Array
"/                with: ((Smalltalk packageDirectoryForPackageId: 'stx:libjava') / 'java' / 'bin')
"/                with: ((Smalltalk packageDirectoryForPackageId: 'stx:libjava') / 'java' / 'libs' / 'ext')
"/        ).

    "Created: / 31-08-2011 / 22:55:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 29-08-2013 / 00:28:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

java_lang_Class
    Java_lang_Class isNil ifTrue:[
	Java_lang_Class := self at:'java.lang.Class'
    ].
    ^ Java_lang_Class

    "Created: 26.3.1997 / 13:42:59 / cg"
    "Modified: 26.3.1997 / 13:46:24 / cg"
!

java_lang_String
    Java_lang_String isNil ifTrue: [
	Java_lang_String := JavaVM classNamed: 'java/lang/String'.
    ].
    ^ Java_lang_String.

    "Created: / 26-03-1997 / 13:43:17 / cg"
    "Modified: / 21-10-2011 / 13:41:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

prettyPrintStyle
    PrettyPrintStyle isNil ifTrue:[
        self initializePrettyPrintStyle
    ].
    ^ PrettyPrintStyle

    "Created: 1.8.1997 / 10:37:57 / cg"
!

release
    Release isNil ifTrue:[
        self initializeRelease
    ].
    ^Release

    "
     Release := nil
    "

    "Created: / 22-11-2010 / 12:38:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release: aJavaRelease

    Release := aJavaRelease.

    "
	Java release: JavaRelease openJDK6.
	Java release: JavaRelease sunJDK6.

    "

    "Created: / 22-11-2010 / 12:38:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2013 / 17:59:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

systemPropertyAt:key put:something
    JavaVM systemProperties at:key put:something

    "Created: / 9.1.1999 / 14:49:35 / cg"
! !

!Java class methodsFor:'change & update'!

update: what with: param from: sender

    what == #restarted ifTrue:[
        self reinitialize.
    ].
    what == #packageLoaded ifTrue:[ 
        self updateAfterPackageLoaded: param.
    ].

    "Created: / 14-12-2010 / 21:00:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-09-2016 / 22:53:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterPackageLoaded: pkgdef
    | bundle |

    JavaVM booted ifFalse:[ ^ self ].
    bundle := pkgdef javaBundle.
    bundle notNil ifTrue:[ 
        bundle classPath do:[:each | self addToClassPathInRuntime: each ].
    ].

    "Created: / 19-09-2016 / 22:54:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Java class methodsFor:'class initialization'!

boot

    ^JavaVM boot.

    "Created: / 21-02-2012 / 18:10:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultRelease
    | nm release home |

    "First, consult STX_LIBJAVA_RELEASE environment variable, if set"
    nm := OperatingSystem getEnvironment:'STX_LIBJAVA_RELEASE'.
    nm isNil ifTrue:[
        | home |

        home := UserPreferences current javaHome.
        home notEmptyOrNil ifTrue:[ 
            release := JavaRelease inDirectory: home.
            release notNil ifTrue:[ ^ release ]
        ].
    ].
    nm notNil ifTrue:[
        release := JavaRelease perform: nm asSymbol ifNotUnderstood:[nil].
        release notNil ifTrue:[ ^ release ].
    ].

    "/ Second. use release configured in preferences
    home := UserPreferences current javaHome.
    (home notEmptyOrNil and:[home asFilename exists]) ifTrue:[ 
        release := JavaRelease inDirectory: home.
        release notNil ifTrue:[ ^ release ].
    ].

    release := JavaRelease system.
    "/ Java8 is not yet supported, it's here just for experiments...
    (release notNil and:[release isJava8 not]) ifTrue:[ ^ release ].

    release := JavaRelease default.
    ^ release



    "
    Java defaultRelease.

    "

    "Created: / 11-11-2013 / 16:13:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-04-2016 / 20:58:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initAllClasses
    | system |

    FailedToLoadClasses := nil.
    self initAllStaticFields.
    system := JavaVM classForName:'java.lang.System' definedBy:nil.
    system isInitialized ifFalse: [ self initSystemClass. ].
    self allClassesDo: [:cls | cls isInitialized ifFalse: [ cls classInit ] ]

    "
     Java initAllClasses"
    "Modified: / 27.11.1998 / 00:33:05 / cg"
!

initAllStaticFields
     self allClassesDo:[:cls |
	cls initializeStaticFields
     ]

!

initSystemClass
    | system |

    system := JavaVM classForName:'java.lang.System' definedBy:nil.
    system isNil ifTrue: [
	"/        JavaVM initializeVM.
	"/        system := Java at:'java.lang.System'.
	"/        system isNil ifTrue:[
	self warn: 'JavaVM: no ''' , 'java.lang.System' allBold , ''' class.'.

"/            self error:'no ''java.lang.System'' class'.

	^
"/        ].
	self
    ].
    system classInit.
    (system implements: #'initializeSystemClass()V') ifTrue: [
	system "invokeStatic:" perform: #'initializeSystemClass()V'.
    ].

    "
     Java initSystemClass

     (Java at:'java.lang.System')
	perform:#'getProperty(Ljava/lang/String;)Ljava/lang/String;'
	with:(Java as_String:'java.home')"
    "Modified: / 10.11.1998 / 12:39:58 / cg"
!

initialize
    | flag |

    Initialized == nil ifTrue:[
        "/ only do this if reinitialized!!
        Initialized := true.
    ] ifFalse:[
        JavaNativeMethod flushAllCachedNativeMethods.
    ].

    InternedStrings := Dictionary new.
    FailedToLoadClasses := nil.
    ClassPathExt := nil.
    ExcludedClassPath := OrderedCollection new.
    SourceCache := CacheDictionary new: 32.
    SourceArchiveCache := CacheDictionary new: 32.

    "/ Sigh, check for the very first initialization...
    Threads isNil ifTrue:[
        ThreadsAccess := RecursionLock forMutualExclusion.
        Threads := IdentityDictionary new.
    ].

    ClassPathBundle := JavaClassPathBundle new.
    ClassPath isNil ifTrue:[ClassPath:= OrderedCollection new]. "/ for ad-hoc packages
    SourcePath isNil ifTrue:[SourcePath := OrderedCollection new]."/ for ad-hoc packages

    ThreadsAccess := RecursionLock forMutualExclusion.
    "/ self initializePrettyPrintStyle. -- done in getter

    "Initialize JITer and Native method optimization"
    (flag := OperatingSystem getEnvironment:'STX_LIBJAVA_ENABLE_JIT') notNil ifTrue:[
        ObjectMemory javaJustInTimeCompilation: (flag = '1')
    ].
    (flag := OperatingSystem getEnvironment:'STX_LIBJAVA_ENABLE_NATIVE_METHOD_OPTIMIZATION') notNil ifTrue:[
        ObjectMemory javaNativeCodeOptimization: (flag = '1')
    ].

    ObjectMemory addDependent: self.
    Smalltalk addDependent: self.  

    "
     Java flushAllJavaResources.
     Java initialize.
     JavaVM initializeVM
     Java classPath inspect"

    "Modified: / 06-11-2001 / 09:24:12 / cg"
    "Created: / 03-10-2010 / 15:54:02 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 15-10-2010 / 17:37:20 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 09-12-2011 / 13:16:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 19-09-2016 / 22:52:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializePrettyPrintStyle
    PrettyPrintStyle := IdentityDictionary new.
    PrettyPrintStyle  at:#accessAttribute put:(#color -> (Color red:0 green:0 blue:25)).
    PrettyPrintStyle  at:#className       put:(Array with:(#color -> Color black) with:#bold).
    PrettyPrintStyle  at:#methodName      put:(Array with:(#color -> Color black) with:#bold).
    PrettyPrintStyle  at:#code            put:(#color -> Color black).


     "
      Java initializePrettyPrintStyle
     "

    "Created: 1.8.1997 / 11:08:43 / cg"
    "Modified: 1.8.1997 / 11:09:58 / cg"
!

initializeRelease

    Release isNil ifTrue:[
	self reinitializeRelease.
    ].

    "
	Release := nil.
	self initializeRelease.
	Release
    "

    "Created: / 22-11-2010 / 13:41:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reboot

    ^JavaVM reboot.

    "Created: / 21-02-2012 / 18:11:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reinitAllClasses
     self markAllClassesUninitialized.
     self initAllClasses

     "
      Java reinitAllClasses
     "

    "Modified: / 4.1.1998 / 00:34:29 / cg"
!

reinitialize
    FailedToLoadClasses := nil.

    "Kludge"
    JavaMethod reinitialize.
    JavaMethodWithException reinitialize.
    JavaMethodWithHandler reinitialize.
    JavaNativeMethod reinitialize.
    JavaNativeMethod flushAllCachedNativeMethods.


    "
     Java reinitialize
    "

    "Created: / 26-08-1997 / 20:07:00 / cg"
    "Modified: / 27-04-1998 / 14:57:23 / cg"
    "Modified: / 17-08-2012 / 11:58:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reinitializeRelease

    Release := self defaultRelease.




    "
        Release := nil.
        self initializeRelease.
        Release
    "

    "Created: / 26-07-2012 / 23:58:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-11-2013 / 16:13:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startupJavaSystem
    | javaEventThread  haveEventThread  haveScreenUpdater |
    FailedToLoadClasses := nil.

    "/
    "/ check if already running
    "/

    haveEventThread := true.
    javaEventThread := JavaVM javaEventThread.
    (javaEventThread isNil or: [ javaEventThread isDead ]) ifTrue: [
        haveEventThread := false
    ].
    haveScreenUpdater := false.
    haveEventThread ifTrue: [
        self threadsDo: [
            :aJavaThread |
            aJavaThread name = 'JAVA-Screen Updater' ifTrue: [
                aJavaThread isDead ifFalse: [
                    "/ already running
                    haveScreenUpdater := true
                ]
            ]
        ].
    ].
    (haveEventThread and: [ haveScreenUpdater ]) ifTrue: [ ^ self ].
    JavaClass orderOfClassInits isNil ifTrue: [
        "/ the very first start ...
        Logger log: 'JAVA [info]: (re)initializing JAVA environment completely ...' severity: Logger severityDEBUG facility: #JVM.

        JavaVM initializeVM.
    ] ifFalse: [ JavaVM initializeVMIfNoEventThreadRunning ].
    Logger log: 'JAVA [info]: done JAVA initialization.' severity: Logger severityDEBUG facility: #JVM                         .

    "
     Java startupJavaSystem"

    "Modified: / 24-12-1999 / 01:37:49 / cg"
    "Modified: / 09-12-2011 / 12:50:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 16:03:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

terminateAllThreads
    "Terminates all pure Java threads (i.e., threads created by the JVM."

    | myself  threadsToKill  semaphore |

    Threads isEmptyOrNil  ifTrue: [ ^ self ].

    myself := Processor activeProcess.
    threadsToKill := IdentitySet new.
    ThreadsAccess critical:[
        Threads do: [:aJavaThread |
            aJavaThread ~~ myself ifTrue: [
                "/ What's the aim of the check below? Looks like a check for weak corpse (object's gone)
                "/ but Threads is not a weak dictionary!!
                "/ (aJavaThread isNil or: [ aJavaThread == 0 ]) ifFalse: [
                    (aJavaThread isDead not and:[aJavaThread isMemberOf: JavaProcess]) ifTrue: [
                        threadsToKill add: aJavaThread 
                    ]
                "/ ]
            ]
        ].
    ].
    threadsToKill notEmptyOrNil ifTrue: [
        Logger
            log: 'Killing ' , threadsToKill size printString , ' java processes'
            severity:Logger severityDEBUG
            facility: #JVM.
        semaphore := Semaphore new: 1 - threadsToKill size.
        semaphore name: 'Java thread killer'.
        threadsToKill do: [ :aThread |
            aThread == JavaVM javaScreenUpdaterThread ifTrue: [ self halt ].
            aThread == JavaVM javaEventQueueThread ifTrue: [ self halt ].
            aThread
                addExitAction: [
                    Logger
                        log: 'Java thread killed successfully'
                        severity: Logger severityDEBUG
                        facility: #JVM.
                    semaphore signal
                ].
            aThread terminate
        ].
        semaphore wait.
    ].
    JavaVM releaseAllMonitors.
    Logger
        log: 'No Java threads running at this point'
        severity: Logger severityDEBUG
        facility: #JVM.

    "
     Java terminateAllThreads"

    "Created: / 26-08-1997 / 19:57:40 / cg"
    "Modified: / 24-12-1999 / 02:34:53 / cg"
    "Modified: / 17-11-2011 / 21:31:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 14:10:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Java class methodsFor:'debugging'!

dontHaltOnKnownBugs
    Object disableBreakPoint: #knownBugs.

    "Created: / 09-10-2011 / 17:29:17 / m"
!

dumpConfig
    Transcript notNil ifTrue:[
        self dumpConfigOn: Transcript
    ] ifFalse:[
        self dumpConfigOn: Stdout
    ]

    "Created: / 10-12-2011 / 12:54:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 11-02-2013 / 14:18:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpConfigKey: key value: value on: stream
    '%-30s : %s' printf: { key . value } on: stream.
    stream cr.

    "Created: / 08-02-2013 / 10:18:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpConfigOn: stream
    "Prints current config (java home, initial system properties etc) on a stream."

    | props |

    stream nextPutAll: '== VM configuration =='; cr.
    self dumpConfigKey: 'JIT' value: (ObjectMemory javaJustInTimeCompilation printString) on: stream.
    self dumpConfigKey: 'Native Opt' value: (ObjectMemory javaNativeCodeOptimization printString) on: stream.
    Java release dumpConfigOn: stream.
    props := Dictionary new.
    JavaVM initializeSystemPropertiesInto: props.
    stream nextPutAll: '== Initial system properties =='; cr.
    props keysAndValuesDo:[:key :value|
        self dumpConfigKey: key value: value on: stream.
    ].

    "
        Java dumpConfigOn: Transcript.
    "

    "Created: / 10-12-2011 / 12:54:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2013 / 10:23:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

haltOnKnownBugs
    Object enableBreakPoint: #knownBugs.

    "Created: / 09-10-2011 / 17:29:05 / m"
! !

!Java class methodsFor:'enumerating'!

allClasses

    ^JavaVM classRegistry classes

    "Modified: / 28-01-1998 / 01:42:04 / cg"
    "Modified: / 23-10-2011 / 20:14:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allClassesDo:aBlock

    ^JavaVM classRegistry allClassesDo: aBlock

    "Modified: / 09-04-2014 / 18:43:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Java class methodsFor:'object conversions'!

as_Boolean:aBoolean
    "convert an ST-boolean into a Java Boolean"

    |i|

    i := (Java at:'java.lang.Boolean') new.
    i perform:#'<init>(Z)V' with:(aBoolean ifTrue:[1] ifFalse:[0]).
    ^ i

    "
     Java as_Boolean: true
     Java as_Boolean: false
    "

    "Created: / 26-12-2011 / 20:44:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

as_Float:aNumber
    "convert an ST-float into a Java Float"

    |i|

    i := (Java at:'java.lang.Float') new.
    i perform:#'<init>(F)V' with:(aNumber asShortFloat).
    ^ i

    "
     Java as_Float:1
     Java as_Float:3.14159
    "

    "Created: 7.8.1997 / 21:21:13 / cg"
    "Modified: 7.8.1997 / 21:22:05 / cg"
!

as_Hashtable: aDictionary
    "given a smalltalk dictionary, create and return
     a Java hashTable for it"

    | hashTable |

    hashTable := (JavaVM classForName:'java.util.Hashtable' definedBy:nil) new.
    aDictionary
	keysAndValuesDo: [
	    :k :v |
	    | sk  sv  jk  jv |

	    (sk := k) isSymbol ifTrue: [ sk := sk asString ].
	    (sv := v) isSymbol ifTrue: [ sv := sv asString ].
	    jk := self as_Object: sk.
	    jv := self as_Object: sv.
	    hashTable
		perform: #'put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;'
		with: jk
		with: jv.
	].
    ^ hashTable

    "
     Java as_Hashtable:(Dictionary new
			   at:'hello' put:'Hallo';
			   at:'world' put:'Welt';
			   yourself)"
    "Modified: / 14.1.1998 / 17:02:13 / cg"
!

as_Integer:anInteger
    "convert an ST-integer into a Java Integer"

    |i|

    i := (Java at:'java.lang.Integer') new.
    i perform:#'<init>(I)V' with:anInteger.
    ^ i

    "
     Java as_Integer:1
    "

    "Modified: 7.8.1997 / 21:19:37 / cg"
    "Created: 7.8.1997 / 21:21:13 / cg"
!

as_Object:anObject
    "convert an ST-Object into a Java Object"

    anObject isString ifTrue:[
	^ self as_String:anObject
    ].
    anObject isInteger ifTrue:[
	^ self as_Integer:anObject
    ].

    self halt.

    "
     Java as_Object:'hello world'
    "

    "Created: 7.8.1997 / 21:15:38 / cg"
    "Modified: 7.8.1997 / 21:20:07 / cg"
!

as_ST_String: aJavaString
    "Given a java.lang.String instance, returns a coresponding
     Smalltalk String"

    ^Release as_ST_String: aJavaString

    "Created: / 08-08-1997 / 12:02:55 / cg"
    "Modified: / 04-01-1999 / 23:55:08 / cg"
    "Modified: / 22-03-2011 / 17:21:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-02-2013 / 20:02:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

as_String:aString
    "Given a Smalltalk string, returns corresponsing instance of
     java.lang.String"

    ^Release as_String: aString

    "
     Java as_String:'hello world'
    "

    "Created: / 07-08-1997 / 21:15:49 / cg"
    "Modified: / 07-02-2013 / 20:03:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

as_URL:aString
    "convert an ST-String into a Java String"

    "hard-coding internas of java.lang.String here is bad ..."

    |u s|

    s := aString.

    "/ kludge for volume
    OperatingSystem isMSDOSlike ifTrue:[
	((s size > 1) and:[(s at:2) == $:]) ifTrue:[
	    s := 'file:' , (s copy at:2 put:$|)
	]
    ].
    u := (self at:'java.net.URL') newCleared.
    u perform:#'<init>(Ljava/lang/String;)V' with:(self as_String:s).
    ^ u

    "
     Java as_URL:'http://www.altavista.com'
     Java as_URL:'file:/foo/bar'
    "

    "Created: / 7.8.1997 / 21:15:49 / cg"
    "Modified: / 25.9.1999 / 22:22:21 / cg"
! !

!Java class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!Java class methodsFor:'paths-accessing'!

cacheDirectory
    CacheDirectory isNil ifTrue:[
        CacheDirectory := Filename homeDirectory / '.smalltalk' / 'libjava'
                / 'caches'
                    / (((Smalltalk at:#'stx_libjava') svnRepositoryUrlBase copyReplaceAll:$/
                            with:$_) replaceAll:$: with:$_)
    ].
    ^ CacheDirectory

    "Created: / 08-04-2011 / 15:02:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 15:53:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classPath
    ^ClassPath

    "Created: / 07-02-1997 / 19:23:45 / cg"
    "Modified: / 16-01-2013 / 12:45:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classPath:aCollectionOfPaths
    ClassPath := aCollectionOfPaths

    "Created: / 07-02-1997 / 19:23:45 / cg"
    "Modified: / 17-09-1998 / 20:44:09 / cg"
    "Modified: / 16-01-2013 / 12:44:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classPathAsString
    ^ (self classPath collect: [ :each | each pathName ]) asStringWith: $:.

    "Created: / 12-12-2012 / 23:55:00 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

classPathBundle
    ^ClassPathBundle

    "Created: / 25-01-2013 / 21:49:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

effectiveClassPath
    ^ClassPathBundle classPath , self classPath

    "
    Java effectiveClassPath
    "

    "Created: / 22-11-2010 / 13:03:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2011 / 09:44:16 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 23-01-2013 / 14:45:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

effectiveExtensionsPath
    "Return an effective list of directories that contains
     extensions to Java classes. These extensions are loaded
     by JavaClassReader each time the class is loaded into
     running system"

    ^self effectiveExtensionsPathForRelease: Release

    "
    Java effectiveExtensionsPath
    "

    "Created: / 06-09-2012 / 11:27:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

effectiveSourceDirectories
    ^Release sourcePath , ClassPathBundle sourcePath , SourcePath
    "
        Java effectiveSourceDirectories
    "

    "Created: / 30-11-2010 / 11:53:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-01-2013 / 15:22:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

excludedClassPath
    ^ ExcludedClassPath

    "Modified: / 7.2.1997 / 19:23:55 / cg"
    "Created: / 27.1.1998 / 21:57:13 / cg"
!

isExcludedFromClassPath:fileName
    |nm|

    nm := fileName asFilename pathName.
    ExcludedClassPath do:[:excludedPath |
	(nm startsWith:excludedPath) ifTrue:[^ true].
    ].
    ^ false

    "Created: / 27.1.1998 / 22:00:40 / cg"
!

javaHome
    JavaHome isNil ifTrue:[
        ^ Release javaHome
    ].
    ^ JavaHome

    "Created: / 06-08-1997 / 00:53:19 / cg"
    "Modified: / 04-08-2014 / 16:01:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHome:aPath

    <resource: #obsolete>

    self obsoleteMethodWarning: 'javaHome is now controlled by java release'.

    JavaHome := aPath

    "Created: / 06-08-1997 / 00:53:23 / cg"
    "Modified: / 22-11-2010 / 12:40:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePath
    ^SourcePath

    "Created: / 16-01-1998 / 13:26:55 / cg"
    "Modified: / 16-01-2013 / 12:45:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Java class methodsFor:'paths-adding & removing'!

addToClassPath:pathOrCollection
    ^ self addToPath:ClassPath path:pathOrCollection

    "Created: / 01-08-1997 / 21:10:07 / cg"
    "Modified: / 17-09-1998 / 20:43:55 / cg"
    "Modified: / 14-12-2011 / 00:04:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addToPath:cp filesMatching:pattern in:path
    |dir|

    dir := path asFilename.
    dir exists ifFalse:[ ^ self ].
    dir directoryContents do:[:fname |
	(fname matches:pattern) ifTrue:[
	    |p|

	    p := (dir / fname) pathName.
	    (cp includes:p) ifFalse:[
		cp add:p.
		cp == ClassPath ifTrue:[
		    self addToClassPathInRuntime:p.
		].
		FailedToLoadClasses := nil
	    ]
	]
    ].

    "Created: / 14-12-2011 / 00:04:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addToPath:cp path:pathOrCollection
    |path|

    (pathOrCollection isSequenceable and:[pathOrCollection isCharacters not]) ifTrue:[
	pathOrCollection do:[:each |
	    self addToPath:cp path:each
	].
	^ self.
    ].
    path := pathOrCollection asFilename.
    (pathOrCollection asString includes:$*) ifTrue:[
	self
	    addToPath:cp
	    filesMatching:path baseName
	    in:path directoryName.
    ] ifFalse:[
	(ClassPath includes:pathOrCollection asString) ifFalse:[
	    cp add:pathOrCollection asString.
	    cp == ClassPath ifTrue:[
		self addToClassPathInRuntime:pathOrCollection.
	    ].
	    FailedToLoadClasses := nil
	]
    ]

    "Created: / 01-08-1997 / 21:10:07 / cg"
    "Modified: / 17-09-1998 / 20:43:55 / cg"
    "Created: / 14-12-2011 / 00:03:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addToSourcePath:pathOrCollection

    self addToPath: SourcePath path: pathOrCollection

    "Created: / 02-08-1997 / 14:12:31 / cg"
    "Modified: / 14-12-2011 / 00:08:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeFromClassPath:aPath
    (ClassPath includes:aPath) ifTrue:[
	ClassPath remove:aPath
    ]

    "Modified: 7.2.1997 / 19:23:55 / cg"
    "Created: 1.8.1997 / 21:10:21 / cg"
!

removeFromSourcePath:aPath
    (SourceDirectories includes:aPath) ifTrue:[
	SourceDirectories remove:aPath
    ]

    "Modified: 7.2.1997 / 19:23:55 / cg"
    "Created: 2.8.1997 / 14:13:01 / cg"
! !

!Java class methodsFor:'paths-utils'!

addToClassPathInRuntime: aString
    | path  file  url  scl |

    "Java might not be loaded/or initialized, in this case
     there is no no need to inform java about new entry in classpath"
    JavaVM booted ifFalse: [ ^ self ].
    scl := JavaVM systemClassLoader.
    scl isNil ifTrue:[ ^self ].
    path := Java as_String: aString asString.
    file := ((JavaVM at: 'java.io.File') new)
                perform: #'<init>(Ljava/lang/String;)V' with: path;
                yourself.
    url := file perform: #'toURL()Ljava/net/URL;'.
    scl perform: #'addURL(Ljava/net/URL;)V' with: url.

    "Created: / 01-08-1997 / 21:10:07 / cg"
    "Modified: / 17-09-1998 / 20:43:55 / cg"
    "Created: / 07-08-2011 / 14:01:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classPathInRuntime: classPath
    "Sets the classpath in already booted/running Java environment"

    | urls ucp scl |

    JavaVM booted ifFalse: [ ^ self ].

    scl := JavaVM systemClassLoader.
    scl isNil ifTrue:[ ^self ].

    urls := (JavaVM classForName:'java.net.URL' definedBy:nil) javaArrayClass new: classPath size.
    classPath withIndexDo:[:element :index|
        | path file url |
        path := Java as_String: element pathName.
        file := ((JavaVM at: 'java.io.File') new)
                perform: #'<init>(Ljava/lang/String;)V' with: path;
                yourself.
        url := file perform: #'toURL()Ljava/net/URL;'.
        urls at: index put: url
    ].
    ucp := (Java classForName:'sun.misc.URLClassPath') new.
    ucp perform: #'<init>([Ljava/net/URL;)V' with: urls.
    scl instVarNamed: #ucp put: ucp.

    "Created: / 02-08-2012 / 16:04:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-05-2013 / 11:20:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

effectiveExtensionsPathForRelease: aRelease

    ^ (ExtensionsPath ? #()) ,
	self extensionsPathFromPackages

    "Created: / 06-09-2012 / 11:27:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionsPathFromPackages

    ExtensionsPathPackages isNil ifTrue:[
        ExtensionsPathPackages := OrderedCollection new.
        Smalltalk allPackageIDs do:[:pkg|
            | dir |

            dir := Smalltalk getPackageDirectoryForPackage: pkg.
            dir notNil ifTrue:[
                dir := dir asFilename / 'java' / 'extensions'.
                dir exists ifTrue:[
                    ExtensionsPathPackages add: dir
                ].
            ]
        ].
    ].
    ^ExtensionsPathPackages.

    "
    Java extensionsPathFromPackages
    "


    "
        Java extensionsPathFromPackages
    "

    "Created: / 06-09-2012 / 11:30:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-06-2016 / 07:55:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceDirectories:aCollectionOfPaths
    SourceDirectories := aCollectionOfPaths asOrderedCollection

    "
     Java
	sourceDirectories:#(
			    '/phys/ibm3/java/src'
			   )
    "


! !

!Java class methodsFor:'queries'!

smalltalkClassFor:typeRef
self halt.
"/    (typeString startsWith:'[[') ifTrue:[
"/        ^ Array
"/    ].
"/    (typeString startsWith:'[F') ifTrue:[
"/        ^ FloatArray
"/    ].
    self halt.

    "Modified: 7.4.1997 / 13:33:46 / cg"
!

smalltalkDerefType:typeString
    (typeString startsWith:'[') ifTrue:[
	^ typeString copyFrom:2
    ].
    self halt.

    "Modified: 7.4.1997 / 13:13:24 / cg"
! !

!Java class methodsFor:'registering java classes'!

at: aJavaName

    ^JavaVM at: aJavaName.

    "Modified: / 18-07-1998 / 22:55:16 / cg"
    "Modified (format): / 21-10-2011 / 10:40:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: aJavaName put: aJavaClass

    ^JavaVM at:aJavaName put:aJavaClass.

    "Created: / 17-04-1996 / 23:29:31 / cg"
    "Modified: / 07-08-1997 / 19:15:58 / cg"
    "Modified (format): / 21-10-2011 / 10:39:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flushAllJavaResources

    self flushClasses.
    JavaVM reflection notNil ifTrue:[
        JavaVM reflection flush.
    ].
    InternedStrings := Dictionary new.
    SourceCache := CacheDictionary new: 32.
    SourceArchiveCache := CacheDictionary new: 32.
    ClassPathPackages := nil.
    JavaMonitor initialize.
    Smalltalk garbageCollect.
    ObjectMemory
        allObjectsDo: [:someObject |
            someObject isBehavior ifTrue: [
                (someObject isJavaClass and:[someObject class ~~ JavaClassAccessor]) ifTrue: [

                    | cp |

                    cp := someObject constantPool.
                    Class flushSubclassInfoFor: someObject.
                    1 to: cp size do:[:i|cp at: i put: nil].
                    someObject setConstantPool: nil.
                    someObject setInterfaces: nil.
                    someObject setMethodDictionary: (MethodDictionary new).
                    Logger
                        log: 'flushing ' , someObject fullName
                        severity: Logger severityDEBUG
                        facility: 'JVM'.
                ]
            ].
        ].
    JavaVM releasehSystemClassLoader.
    JavaVM releasehSmalltalkClassLoader.
    Class flushSubclassInfoFor: JavaObject.
    GroovyEvaluator flushWorkspaceShell.
    GroovyEvaluator flushWorkspaceBinding.
    GroovyCompiler  flushGroovyClassLoader.

    JavaClass flushClassesInitOrder.
    JavaVM finalizationLobby notNil ifTrue:[
        JavaVM finalizationLobby stopFinalizationProcess
    ].
    JavaClassReader flushInternedStrings.
    Threads := IdentityDictionary new.
    self flushProxies.
    Smalltalk garbageCollect.

    "
    Java flushAllJavaResources
    "

    "Modified: / 06-11-2001 / 09:49:37 / cg"
    "Modified: / 02-11-2011 / 21:34:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 14:11:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flushClasses

    | packagesInSystemDictionary |

    UnresolvedClassRefs := nil.
    JavaVM flushClasses.
    Smalltalk keysAndValuesDo:[:name :class |
        class isJavaClass ifTrue:[
            Smalltalk at: name put: nil.
        ]
    ].
    packagesInSystemDictionary := Set new.
    Smalltalk keysAndValuesDo:[:key :value|
        "/ Do not remove JAVA namespace - used by Java bridge, sigh
        (key ~~ #JAVA and:[value isClass and:[value superclass == JavaPackage]]) ifTrue:[
            packagesInSystemDictionary add: key.
        ].
    ].
    packagesInSystemDictionary do:[:key|
        Smalltalk removeKey: key.
    ].

    Java_lang_String := Java_lang_Class := nil.
    JavaVM releaseAllJavaResources.
    JavaUnresolvedConstant flushPatchLists.
    Debugger == DebugView ifTrue:[Debugger newDebugger].
    ObjectMemory flushCaches.

    "
     Java flushClasses
    "

    "Modified: / 06-11-2001 / 09:47:49 / cg"
    "Modified: / 16-11-2011 / 09:43:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 30-11-2013 / 06:58:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flushProxies

    Smalltalk allClassesDo:[:cls |
        | selectorsToRemove meta |

        selectorsToRemove := Set new.
        cls methodDictionary keysAndValuesDo:[:selector :method |
            method isProxyMethod ifTrue:[ 
                selectorsToRemove add: selector.
            ].
        ].
        selectorsToRemove do:[:selector | 
            cls basicRemoveSelector: selector.  
        ].
        meta := cls class.
        selectorsToRemove := Set new.
        meta methodDictionary keysAndValuesDo:[:selector :method |
            method isProxyMethod ifTrue:[ 
                selectorsToRemove add: selector.
            ].
        ].
        selectorsToRemove do:[:selector | 
            meta basicRemoveSelector: selector.  
        ].
    ].
    ObjectMemory flushCaches.

    "
    Java flushProxies
    "

    "Created: / 17-12-2014 / 13:29:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markAllClassesUninitialized
    self allClassesDo:[:aJavaClass |
	aJavaClass markUninitialized
    ].

    "
     Java markAllClassesUninitialized
    "
!

rememberUnresolved:anUnresolvedClassRef
    Logger log: ('JAVA: remember unresolved class: ' , anUnresolvedClassRef fullName) severity: Logger severityDEBUG facility: #JVM.

    UnresolvedClassRefs isNil ifTrue:[
        UnresolvedClassRefs := Dictionary new.
    ].
    UnresolvedClassRefs
        at:anUnresolvedClassRef fullName
        put:anUnresolvedClassRef

    "Created: / 18-04-1996 / 00:05:31 / cg"
    "Modified: / 19-10-1998 / 20:57:44 / cg"
    "Modified: / 02-03-2015 / 15:58:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeClass:aJavaClass
    "Remove the class from the system, as well as all its subclasses
     (or users of the interface, if class is interface)"

    JavaVM unloadClass: aJavaClass.

    "Modified: / 19-10-1998 / 20:58:49 / cg"
    "Modified (comment): / 14-09-2013 / 23:51:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unresolvedClassRefFor:aClassName
    UnresolvedClassRefs isNil ifTrue:[^ nil].
    ^ UnresolvedClassRefs at:aClassName ifAbsent:nil.

    "Modified: / 19.10.1998 / 20:56:46 / cg"
!

updateClassRefsFrom:oldClass to:newClass
    "update all references to oldClass to now refer to newClass.
     sent, when a class is reloaded"

    newClass notNil ifTrue:[
	"/
	"/ kludge: the new class might have been resolved with the oldClass ...
	"/
	newClass constantPool
	    updateClassRefsFrom:oldClass to:newClass.
    ].

    self allClassesDo:[:aJavaClass |
	aJavaClass updateClassRefsFrom:oldClass to:newClass
    ].

    "Created: 26.3.1997 / 13:49:20 / cg"
    "Modified: 12.8.1997 / 03:04:44 / cg"
! !

!Java class methodsFor:'source management'!

classSourceStreamFor: aClass
    | jpackage  dirName  sourceFileName  sourceFile  loader  codeBaseURL  protocol  codeBaseURLIdx  src |

    aClass isNil ifTrue: [
        ^ nil
    ].

    "/ look at the cache"

    "/ maybe it was loaded by a java classLoader ...

    (loader := aClass classLoader) notNil ifTrue: [
        codeBaseURLIdx := loader class instVarIndexFor: 'codeBaseURL'.
        codeBaseURLIdx notNil ifTrue: [
            (codeBaseURL := loader instVarAt: codeBaseURLIdx) notNil ifTrue: [
                (protocol := codeBaseURL instVarNamed: 'protocol') notNil ifTrue: [
                    (Java as_ST_String: protocol) = 'file' ifTrue: [
                        dirName := Java as_ST_String: (codeBaseURL instVarNamed: 'file').
                        dirName := dirName asFilename.
                        dirName exists ifTrue: [
                            aClass sourceFile notNil ifTrue: [
                                sourceFile := sourceFileName := dirName construct: aClass sourceFile.
                            ]
                        ]
                    ]
                ]
            ]
        ].

        "/ HACK HACK HACK: The eXpecco JImport plugin load the Java class and
        "/ sets fake classloader - an instance of Expecco::JIClassLoaderPlaceholder
        "/ which in turn references codelibrary in an instvar. If that's the case,
        "/ ask that library for source

        loader class name == #'Expecco::JIClassLoaderPlaceholder' ifTrue: [
            ^ (loader library classSourceOf: aClass name) readStream.
        ]
    ].

    "/ if that fails, look in standard places

    (sourceFile isNil or: [ sourceFile exists not ]) ifTrue: [
        sourceFile := aClass sourceFile.
        sourceFile isNil ifTrue: [
            "Hmm, hmm...just a guess"
            sourceFile := (aClass lastName upTo: $$) , '.java'.
        ].
        jpackage := aClass javaPackageAsDirname.
        self effectiveSourceDirectories do: [:dir |
            src := self
                         classSourceStreamForFile: sourceFile
                         package: jpackage
                         in: dir.
            src notNil ifTrue: [
                ^ src
            ]
        ]
    ].
    sourceFile isFilename ifFalse: [
        ^ nil
    ].
    ^ sourceFile readStream

    "
        Java classSourceOf: JAVA::java::lang::Object"

    "Modified: / 27-01-1999 / 20:40:30 / cg"
    "Modified: / 07-10-2013 / 17:01:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classSourceStreamForFile: filename package: jpackage in: dirOrZipFile
    | fn  pn  zar memberName member zipMemberName|

    fn := dirOrZipFile asFilename.
    pn := dirOrZipFile asString.
    fn isDirectory ifTrue: [
        jpackage notNil ifTrue: [
            (memberName := fn / jpackage / filename) exists ifTrue: [
                ^ memberName readStream
            ].
        ].
        (memberName := fn / filename) exists ifTrue: [
            ^ memberName readStream
        ].
    ] ifFalse: [
        ((pn last == $p and: [ fn hasSuffix: 'zip' ])
            or: [ (pn last == $r and: [ fn hasSuffix: 'jar' ]) ])
                ifTrue: [
                    zar := SourceArchiveCache at: dirOrZipFile
                            ifAbsentPut: [ ZipArchive oldFileNamed: fn pathName ].
                    zar notNil ifTrue: [
                        jpackage notNil ifTrue: [
                            OperatingSystem fileSeparator ~~ $/ ifTrue: [
                                memberName := (jpackage copyReplaceAll: OperatingSystem fileSeparator with: $/)
                                        , '/' , filename
                            ] ifFalse: [
                                memberName := jpackage , '/' , filename.
                            ]
                        ] ifFalse: [
                            memberName := filename
                        ].
                        zipMemberName := memberName.
                        member := zar findMember: zipMemberName.
                        member isNil ifTrue: [
                            "/ apple sources in the src.jar begin with a src/ prefix
                            zipMemberName := 'src/',memberName.
                            member := zar findMember: zipMemberName.
                        ].
                        member notNil ifTrue: [
                            | source |

                            source := zar extract: zipMemberName.
                            "/ Check, sometimes the ZipArchive fails to uncompress
                            "/ correctly. Not sure why...
                            (source size == member uncompressedSize) ifTrue:[
                                ^ source asString readStream
                            ] ifFalse:[
                                "Kludge because of broken ZipArchive"
                                | cache memberFileName |

                                cache := Java cacheDirectory / Release name / 'src'.
                                cache exists ifFalse: [
                                    cache recursiveMakeDirectory
                                ].
                                (cache / memberName) exists ifTrue: [
                                    ^ (cache / memberName) readStream
                                ].
                                OperatingSystem
                                    executeCommand: ('unzip "%1" "%2"' bindWith: fn asAbsoluteFilename asString
                                    with: memberName asString)
                                    inDirectory: cache asString.
                                (memberFileName := cache / memberName) exists ifTrue: [
                                    ^ memberFileName readStream
                                ].
                                OperatingSystem
                                    executeCommand: ('unzip "%1" "%2"' bindWith: fn asAbsoluteFilename asString
                                    with: zipMemberName asString)
                                    inDirectory: cache asString.
                                (memberFileName := cache / zipMemberName) exists ifTrue: [
                                    ^ memberFileName readStream
                                ]
                            ]
                        ].
                    ]
                ]
    ].
    ^ nil

    "
 Java classSource: 'Object.java' package:'java/lang' in:'/home/jv/Projects/JavaX/java-6-openjdk/src'
 Java classSource: 'Object.java' package:'java/lang' in:'/usr/lib/jvm/java-6-openjdk/src.zip'"

    "Modified: / 29-03-1998 / 21:46:40 / cg"
    "Created: / 30-11-2010 / 12:32:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2016 / 22:54:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceDirectories
    ^self sourcePath
    "
	Java sourceDirectories 
    "

    "Modified: / 16-01-2013 / 12:46:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Java class methodsFor:'starting apps'!

javaProcessForMainOf:aJavaClass
    "ask for a commandLine, create a java process to invoke
     its main and return it. The process is not scheduled for
     execution."

    ^ self javaProcessForMainOf:aJavaClass argumentString:nil

    "Modified: / 30.12.1998 / 20:24:25 / cg"
!

javaProcessForMainOf:aJavaClass argumentString:argStringIn
    "create a java process, ready to invoke the classes main
     method. Returns the process - ready to run but not yet resumed"

    |p argStringArray argString stdInReplacement alreadyAskedForStdin|

    argString := argStringIn.
    argString isNil ifTrue:[
        argString := Dialog
                    request:'argument string:'
                    initialAnswer:LastArgumentString ? ''
                    onCancel:nil.
        argString isNil ifTrue:[^ nil].

        LastArgumentString := argString.
    ].

    JavaVM initializeVMIfNoEventThreadRunning.
    (Java at:'java.lang.System') instVarNamed:'security' put:nil.

    argString isEmpty ifTrue:[
        argStringArray := #()
    ] ifFalse:[
        argStringArray := (argString asCollectionOfWords collect:[:s | Java as_String:s]) asArray.
    ].

    p := JavaProcess
            for:[
                    "/ if the program reads from stdin, let user provide a file
                    "/ for it.
                    JavaVM stdinReplacementFileQuerySignal handle:[:ex |
                        |fn|

                        alreadyAskedForStdin == true ifFalse:[
                            fn := Dialog
                                    requestFileName:'Program reads from Stdin - give inputFile or cancel for EOF'
                                    default:nil
                                    fromDirectory:(FileSelectionBox lastFileSelectionDirectory).
                            fn notNil ifTrue:[
                                stdInReplacement := fn asFilename readStream.
                            ].
                            alreadyAskedForStdin := true.
                        ].
                        ex proceedWith:stdInReplacement
                    ] do:[
                        aJavaClass
                            performStatic:#'main([Ljava/lang/String;)V'
                            with:argStringArray.
                    ]
                ]
            priority:(Processor activePriority - 1).

    p name:(aJavaClass fullName , '::main()').
    p restartable:true.
    ^ p

    "Created: / 15.8.1997 / 04:41:20 / cg"
    "Modified: / 24.12.1999 / 01:50:21 / cg"
! !

!Java class methodsFor:'threads'!

addThread: jThread for: stProcess
    ThreadsAccess critical: [
        self assert: (Threads includesKey: jThread) not.
        jThread == 0 ifTrue: [self breakPoint:#mh].
        Threads at: jThread put: stProcess.
        stProcess addExitAction: [
            self removeThread: jThread for: stProcess
        ].
    ]

    "Created: / 26-08-1997 / 19:53:57 / cg"
    "Created: / 09-12-2011 / 12:47:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2014 / 08:57:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeCurrentThread
    "adds current thread into known threads"

    | thisProcess  jThread |
    thisProcess := Processor activeProcess.
    jThread := JavaVM newThread: thisProcess name.
    jThread instVarNamed: 'tid' put: thisProcess id.
    Java addThread: jThread for: thisProcess.

    "Created: / 09-12-2011 / 12:08:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

removeThread: jThread for: stProcess
    ThreadsAccess critical: [
        self assert: ((Threads includesKey: jThread) not or:[(Threads at: jThread) == stProcess]).
        Threads removeKey: jThread ifAbsent:nil.
    ]

    "Created: / 26-08-1997 / 19:53:57 / cg"
    "Created: / 09-12-2011 / 12:47:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-12-2014 / 00:28:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadForStProcess: stProcess
    ^ ThreadsAccess critical: [ Threads keyAtValue: stProcess ].

    "Created: / 26-08-1997 / 19:53:57 / cg"
    "Created: / 09-12-2011 / 12:50:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2014 / 09:25:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadForStProcess: stProcess ifAbsent: block
    ^ ThreadsAccess critical: [ Threads keyAtValue: stProcess ifAbsent: block ].

    "Created: / 26-08-1997 / 19:53:57 / cg"
    "Created: / 09-12-2011 / 12:53:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 08-08-2014 / 09:25:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threads
    self breakPoint:#mh.
    ^ Threads.

    "Created: / 26-08-1997 / 19:53:57 / cg"
    "Modified: / 09-12-2011 / 12:49:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

threadsAt: key
    ^ ThreadsAccess critical:[ Threads at: key ]

    "Created: / 26-08-1997 / 19:53:57 / cg"
    "Created: / 09-12-2011 / 12:31:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2014 / 09:24:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadsAt: key ifAbsent: block
    ^ ThreadsAccess critical: [ Threads at: key ifAbsent: block ]

    "Created: / 26-08-1997 / 19:53:57 / cg"
    "Created: / 09-12-2011 / 12:49:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2014 / 09:24:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadsDo: block
    ThreadsAccess
	    critical: [ Threads do: block]

    "Created: / 26-08-1997 / 19:53:57 / cg"
    "Created: / 09-12-2011 / 12:49:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!Java class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/Java.st,v 1.147 2015-05-07 21:34:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/Java.st,v 1.147 2015-05-07 21:34:17 cg Exp $'
!

version_SVN
    ^ '$Id: Java.st,v 1.147 2015-05-07 21:34:17 cg Exp $'

! !


Java initialize!
