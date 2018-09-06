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

Object subclass:#JavaClassReader
	instanceVariableNames:'inStream msb constants majorVsn minorVsn constNeeds2Slots
		constSlot classBeingLoaded classLoader attributes'
	classVariableNames:'Verbose AnnotationsVerbose Silent AbsolutelySilent
		LazyClassLoading InvalidClassFormatSignal ClassLoaderQuerySignal
		JavaArchiveCache JavaArchiveCacheLock LastJavaArchive
		LastJavaArchiveLock MaxContextSize MaxContextSizeLimit
		InternedStrings'
	poolDictionaries:'JavaConstants'
	category:'Languages-Java-Support'
!

!JavaClassReader class methodsFor:'documentation'!

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

!JavaClassReader class methodsFor:'initialization'!

flushInternedStrings
    self initializeInternedStrings

    "Created: / 13-11-2014 / 12:13:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    InvalidClassFormatSignal := Signal new mayProceed:true.
    InvalidClassFormatSignal notifierString:'class load failure'.
    InvalidClassFormatSignal nameClass:self message:#invalidClassFormatSignal.
    Verbose := false.
    Silent := true.
    AbsolutelySilent := false.

    "/LazyClassLoading := false.

    LazyClassLoading := true.
    ClassLoaderQuerySignal := QuerySignal new.
    ClassLoaderQuerySignal defaultAnswer:[ JavaVM systemClassLoader ].
    self initializeArchiveCache.
    JavaArchiveCacheLock := RecursionLock new.
    LastJavaArchiveLock := RecursionLock new.
    AnnotationsVerbose := false.
    MaxContextSize := 0.
     "Maximum stack depth supported by the VM.
     if you change it, make sure it is equal (or lower)
     to CONSIZE in jinterpret.c (line 111 or so)
     Otherwise, VM may crash!!!!!!"
    MaxContextSizeLimit := 100.

    self initializeInternedStrings.

    "
     JavaClassReader initialize"

    "Modified: / 27-01-1998 / 17:54:23 / cg"
    "Modified: / 17-12-2010 / 17:37:45 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 10-05-2011 / 23:59:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-08-2012 / 02:01:37 / jv"
    "Modified (comment): / 13-11-2014 / 12:12:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeArchiveCache
    OperatingSystem isMSWINDOWSlike ifFalse:[
        JavaArchiveCache := CacheDictionary new:32.
    ] ifTrue:[
        JavaArchiveCache := CacheDictionary new:8.
    ]
!

initializeInternedStrings
     "Constant pool strings are interned to save memory
     and kept in InternedStrings variable"
    InternedStrings := Set new

    "Modified (comment): / 13-11-2014 / 12:12:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReader class methodsFor:'Signal constants'!

classLoaderQuerySignal
    ^ ClassLoaderQuerySignal

    "Created: 14.8.1997 / 19:56:03 / cg"
!

invalidClassFormatSignal
    ^ InvalidClassFormatSignal

    "Created: 3.8.1997 / 18:17:21 / cg"
! !

!JavaClassReader class methodsFor:'constants'!

fileMajorVersions
    ^#(
        45  "Java 1.0.2"
        46  "Java 1.2"
        47  "???"
        48  "???"
        49  "Java 5"
        50  "Java 6"
      ).

    "
     JSR 202:
     The Java virtual machine implementation of Sun's JDK release 1.0.2 supports
     class file format versions 45.0 through 45.3 inclusive. Sun's JDK releases
     1.1.X can support class file formats of versions in the range 45.0 through
     45.65535 inclusive. For k > 1 implementations of version 1.k of the Java 2
     platform can support class file formats of versions in the range 45.0 through
     44+k.0 inclusive.
"

    "Created: / 19-10-2010 / 21:40:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 22:50:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 18-08-2011 / 19:32:37 / jv"
    "Modified (comment): / 16-08-2012 / 15:34:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMinorVersions
    ^ #(
        3 "Java 1.0.2 , Java 1.2"
        0 "Java 6"
    )

    "Created: / 19-10-2010 / 21:41:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

magic_LSB
    ^ 16rBEBAFECA

    "Modified: / 7.5.1998 / 13:14:27 / cg"
    "Created: / 7.5.1998 / 13:15:05 / cg"
!

magic_MSB
    ^ 16rCAFEBABE

    "Modified: / 7.5.1998 / 13:14:27 / cg"
! !

!JavaClassReader class methodsFor:'debugging'!

annotationsVerbose:aBoolean
    AnnotationsVerbose := aBoolean

    "
     Java flushClasses.
     JavaClassReader verbose:true
     JavaClassReader verbose:false"

    "Created: / 25-02-2011 / 12:25:23 / Marcel Hlopko <hlopik@gmail.com>"
!

verbose:aBoolean
    Verbose := aBoolean

    "
     Java flushClasses.
     JavaClassReader verbose:true
     JavaClassReader verbose:false
    "
! !

!JavaClassReader class methodsFor:'file reading'!

readClass: aClassName
    "reads a class, and returns it.
     <clinit> is NOT called, class is NOT installed"

    ^ self readClass: aClassName ignoring: Set new.

    "Created: / 15-04-1996 / 14:58:53 / cg"
    "Modified: / 20-10-1998 / 17:24:54 / cg"
    "Modified: / 08-09-2011 / 08:10:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 07-02-2013 / 14:21:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readClass: aClassName classPath: classPath
    "reads a class, and returns it.
     <clinit> is NOT called, class is NOT installed"

    ^ self readClass: aClassName ignoring: Set new classPath: classPath

    "Created: / 15-04-1996 / 14:58:53 / cg"
    "Modified: / 20-10-1998 / 17:24:54 / cg"
    "Modified: / 08-09-2011 / 08:10:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 30-10-2011 / 12:27:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 07-02-2013 / 14:21:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readClass: className ignoring: classesBeingLoadedOrNil

    "This method is bit hacky, as it tries to supply 'correct'
     classloader.

    If the class is loaded from Java release classPath (containing
    base java classes shipped with JDK/JRE), then set the classloader
    to null. Otherwise set class's loader to system class loader
    (as returned by ClassLoader#getSystemClassLoader())

    This is required to run groovy and other SW that uses resources
    or other classloader dependent stuff. When changing, make sure
    Groovy is running afterwards!!!!!!
    "

    | class |
    class := self
                readClass: className ignoring: classesBeingLoadedOrNil
                classPath: Java release classPath.
    class notNil ifTrue:[ ^ class ].

    class isNil ifTrue:[
        JavaVM booted ifFalse:[
            ^nil
        ].
        JavaClassReader classLoaderQuerySignal answer: JavaVM systemClassLoader do:[
            class := self
                readClass: className ignoring: classesBeingLoadedOrNil
                classPath: Java classPath.
        ].
    ].

    ^class

    "Created: / 15-04-1996 / 14:58:53 / cg"
    "Modified: / 20-10-1998 / 17:24:54 / cg"
    "Modified: / 21-10-2011 / 13:39:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 30-10-2011 / 16:50:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readClass: className ignoring: ignoring classPath: classPath
    | cls |

    cls := self new readClass: className ignoring: ignoring classPath: classPath.
    cls notNil ifTrue:[
        Logger
            log: 'loaded class ' , cls displayString
            severity: Logger severityTRACE
            facility: 'JVM'.
    ].
    ^cls.

    "Created: / 07-02-2013 / 14:34:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2015 / 14:08:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFile:aFilename ignoring:classesBeingLoaded
    "reads a class from aFilename and returns it.
     The JavaClass is NOT installed as global and unresolved
     refs are NOT patched."

    | inStream |

    [
        JavaVM commonOpenStreamUsing:[ inStream := aFilename asFilename readStream ]
    ] on:StreamError do:[:ex |
        Logger
            log:('cannot read .class file: ' , ex description) severity:Logger severityERROR facility:'JVM'.
        self breakPoint: #jv.
        ^ nil
    ].

    ^[
        self readStream:inStream ignoring:classesBeingLoaded.
    ] ensure:[
        inStream close.
    ].

    "Created: / 15-04-1996 / 14:58:53 / cg"
    "Modified: / 09-05-1998 / 01:44:24 / cg"
    "Modified: / 14-08-2012 / 02:17:26 / jv"
    "Modified: / 02-03-2015 / 14:08:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readStream: aStream
    "reads a class from aStream and returns it.
     The JavaClass is not installed as global"

    ^self readStream: aStream ignoring: Set new.

    "Created: / 24-10-2011 / 00:12:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readStream: stream ignoring: classesBeingLoaded
    "reads a class from aStream and returns it.
     The JavaClass is not installed as global"

    ^self readStream: stream loader: self classLoaderQuerySignal query ignoring: classesBeingLoaded

    "Modified: / 30-03-1998 / 18:14:40 / cg"
    "Modified: / 09-05-2011 / 23:15:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-05-2013 / 09:51:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readStream: stream loader: classloader
    "reads a class from aStream and returns it.
     The JavaClass is not installed as global"

    ^self readStream: stream loader: classloader ignoring: Set new.

    "Created: / 02-05-2013 / 09:51:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readStream: stream loader: classloader ignoring: classesBeingLoaded
    "reads a class from aStream and returns it.
     The JavaClass is not installed as global"

    | javaClass |

    javaClass := JavaClassReader new readStream: stream loader: classloader ignoring: classesBeingLoaded.
    Logger
        log: 'loaded class ' , javaClass displayString
        severity: Logger severityTRACE
        facility: 'JVM'.
    ^ javaClass.

    "Created: / 02-05-2013 / 09:50:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2015 / 14:08:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReader class methodsFor:'obsolete'!

resolveClass: aJavaClass
    "Resolve a particular classes' constants.
     Perform all class initialization functions
     (of those which are not yet initialized)."

    | loader  classToLoad |


     "new resolving does not need this - shouldn't be called at all"
    LazyClassLoading ifFalse: [
        loader := (aJavaClass classLoader).
        [
            classToLoad := nil.
            aJavaClass constantPool do: [
                :item |
                | itemClass |

                itemClass := item class.
                itemClass == JavaUnresolvedClassConstant ifTrue: [
                    classToLoad := item className.

"/                ] ifFalse:[
"/                    itemClass == JavaUnresolvedMethodrefConstant ifTrue:[
"/self halt.
"/                    ] ifFalse:[
"/                        itemClass == JavaUnresolvedInterfaceMethodrefConstant ifTrue:[
"/self halt.
"/                        ]
"/                    ]
                ].
            ].
            classToLoad notNil ifTrue: [
                loader isNil ifTrue: [ JavaVM classForName: classToLoad. ] ifFalse: [
                    "/
                    "/ the aquired loader is a javaClassLoader
                    "/ which expects an URL as arg.
                    "/
                    "/ classURL := Java as_URL:('file:' , nextUnresolved asString , '.class').
                    "/ loader loadClass:classURL
                    loader perform: #'loadClass(Ljava/lang/String;)Ljava/lang/Class;'
                        with: (Java as_String: (classToLoad asString)).
                ]
            ].
            classToLoad notNil.
        ] whileTrue.
        aJavaClass isInitialized ifFalse: [
            Silent ifFalse: [
                'performing class initialization of ' print.
                aJavaClass fullName printCR.
            ].
            aJavaClass classInit
        ].
    ]

    "Created: / 20-10-1998 / 17:53:22 / cg"
    "Modified: / 16-11-2011 / 14:39:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassReader class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaClassReader methodsFor:'accessing'!

constantPoolAt: index
    ^ constants at: index

!

constants
    ^ constants.

    "Created: / 10-05-2011 / 13:48:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

constants: aJavaConstantPool
    constants := aJavaConstantPool.

    "Created: / 10-05-2011 / 13:48:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

stream
^ inStream.

    "Created: / 09-05-2011 / 23:22:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

stream:aReadStream
    inStream := aReadStream.

    "Created: / 09-05-2011 / 23:23:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassReader methodsFor:'file reading'!

readClass: clsName from: path ignoring: classesBeingLoaded
    "load class named clsName from directory or .jar archive path.
     <clinit> is NOT called, class is NOT installed as global"

    | nm  p  zar zarAndRefcount entry  zipFile  read rslt |

    p := path asString.
    p asFilename isDirectory ifTrue: [
        | f |

        (p endsWith: Filename separator) ifFalse: [
            p := p , (Filename separator asString)
        ].
        nm := p , clsName , '.class'.
        (f := nm asFilename) exists ifTrue: [
            (Java isExcludedFromClassPath: nm) ifFalse: [
                "means we are successfully going to read something :)"
                f readingFileDo:[:s|rslt := self readStream: s loader: self class classLoaderQuerySignal query ignoring: classesBeingLoaded].
                rslt notNil ifTrue: [ ^ rslt. ].
            ]
        ].
    ] ifFalse: [
        ((zipFile := p asFilename withSuffix: 'jar') exists
            or: [ (zipFile := p asFilename withSuffix: 'zip') exists ])
                ifTrue: [
                    "/ Do not use at:ifAbsentPut: here, JavaArchiveCache is a CacheDictionary!!!!!!
                    JavaArchiveCacheLock critical:[
                        zarAndRefcount := JavaArchiveCache at: zipFile ifAbsent: [ nil ].
                        zarAndRefcount isNil ifTrue:[
                            JavaVM commonOpenStreamUsing:[ zar := ZipArchive oldFileNamed: zipFile ].
                            JavaArchiveCache at: zipFile put: (zarAndRefcount := Array with: zar with: 1)
                        ] ifFalse:[
                            zar := zarAndRefcount first.
                            zarAndRefcount at: 2 put: (zarAndRefcount at: 2) + 1.
                        ].
                    ].
                    read := [
                            nm := clsName , '.class'.

                            (zar isValidFile: nm) ifTrue: [
                                (Java isExcludedFromClassPath: nm) ifFalse: [
                                    entry := zar extract: nm.
                                    rslt := self readStream: (entry readStream) loader: self class classLoaderQuerySignal query ignoring: classesBeingLoaded.
                                    rslt notNil ifTrue: [
                                        JavaArchiveCacheLock critical:[
                                            zarAndRefcount at: 2 put: (zarAndRefcount at: 2) - 1.
                                        ].
                                        ^ rslt
                                    ].
                                ]
                            ].
                            JavaArchiveCacheLock critical:[
                                zarAndRefcount at: 2 put: (zarAndRefcount at: 2) - 1.
                            ].

                        ].
                    JavaClassReader invalidClassFormatSignal         
                        handle: [
                            "Kludge, sometimes zar gets corrupted"
                            JavaArchiveCache at: zipFile put: (Array with: (zar := JavaVM commonOpenStreamUsing: [ZipArchive oldFileNamed: zipFile]) with: 1).
                            read value
                        ]
                        do: [ read value ].
                ]
    ].
    ^nil

    "Created: / 03-12-2012 / 22:47:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2016 / 22:57:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readClass: className ignoring: classesBeingLoadedOrNil classPath: classPath
    "searches classspath for a class, loads it and returns.
     <clinit> is not called, class is not installed as global"

    | rslt  clsName  classesBeingLoaded |
    clsName := className asSlashedJavaClassName.
    classesBeingLoaded := classesBeingLoadedOrNil.
    classesBeingLoaded isNil ifTrue: [
        classesBeingLoaded := Set new.
    ].
    classesBeingLoaded add: clsName.


    classPath do: [:path |
        rslt := self readClass: clsName from: path ignoring: classesBeingLoaded.
        rslt notNil ifTrue:[ ^rslt ].
    ].
    ^nil.

    "Created: / 15-04-1996 / 14:58:53 / cg"
    "Modified: / 20-10-1998 / 17:24:54 / cg"
    "Created: / 23-10-2011 / 21:48:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-11-2011 / 18:14:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-08-2012 / 02:17:59 / jv"
    "Modified: / 07-02-2013 / 14:19:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readClassFileIgnoring: classesbeingLoaded
    "reads a class from inStream and returns it.
     The JavaClass is not installed as global and its constants
     (especially strings) may not be fully resolved."

    | access_flags  this_class_index  super_class  super_class_index  this_class_ref  existingSuperClass  fields  interfaces  staticFields  nStatic  superClassName  thisClassName  existing_class  thisMetaClass |

    self readMagic.
    self readVersion.

    "/
    "/ get constant pool
    "/

    self readConstantPool.

    "/
    "/ access flags
    "/

    access_flags := inStream nextUnsignedShortMSB: msb.
    this_class_index := inStream nextUnsignedShortMSB: msb.
    super_class_index := inStream nextUnsignedShortMSB: msb.
    super_class_index == 0 ifTrue: [ super_class := nil ] ifFalse: [
        super_class := self constantPoolAt: super_class_index.
        superClassName := super_class fullName.

        "/ special for ST-classes

        (superClassName startsWith: 'smalltalk.') ifTrue: [
            "/ a Smalltalk class
            superClassName := superClassName copyFrom: 11.
            existingSuperClass := Smalltalk at: superClassName asSymbol.
            existingSuperClass notNil ifTrue: [ super_class := existingSuperClass ] ifFalse: [
                "/ self halt - must load superclass ...
            ]
        ] ifFalse: [
            "/ a JAVA class
            super_class := JavaVM classNamed: superClassName definedBy: classLoader.
            super_class isNil ifTrue: [
                super_class := self
                                loadSuperclassIdentifiedBy: (self constantPoolAt: super_class_index)
                                ignoring: classesbeingLoaded
            ].
            super_class isNil ifTrue: [
                self breakPoint:#jv info: 'Cannot find super class?!!'
            ].
        ].
    ].

    "/ If superclass is finalized, mark class so as well.
    (super_class notNil and:[super_class hasFinalize]) ifTrue:[
        access_flags := access_flags bitOr: ACX_HASFINALIZE
    ].

    "/
    "/ get interfaces
    "/

    interfaces := self readInterfaces.
    interfaces do:[:ifaceRefIndex |
        (self constantPoolAt: ifaceRefIndex) javaClassName = 'java/lang/Cloneable' ifTrue:[
            access_flags := access_flags bitOr: ACX_CLONEABLE.
        ].
    ].

    "/
    "/ get fields
    "/

    fields := self readFieldInfofields.

    "/
    "/ create the fields as instVars
    "/ static fields are created as class-InstVars
    "/

    staticFields := fields select: [:f | f isStatic ].
    nStatic := staticFields size.
    this_class_ref := self constantPoolAt: this_class_index.
    thisClassName := this_class_ref name.
    thisClassName = 'java/lang/Cloneable' ifTrue:[
        access_flags := access_flags bitOr: ACX_CLONEABLE.
    ].
    thisClassName = 'stx/libjava/tools/compiler/CompileError' ifFalse:[ 
        (constants contains: [:entry | entry isJavaClassRef and:[entry name = 'stx/libjava/tools/compiler/CompileError']]) ifTrue:[ 
            access_flags := access_flags bitOr: ACX_HASERRORS.
        ].
    ].

    "/ care for smalltalk classes ...

    (thisClassName startsWith: 'smalltalk.') ifTrue: [
        thisClassName := thisClassName copyFrom: 11.
        existing_class := Smalltalk at: thisClassName asSymbol.
        existing_class notNil ifTrue: [
            self halt: ('overloading existing class: ' , thisClassName).
            thisClassName := (thisClassName , '_new') asSymbol.
        ].
        thisMetaClass := Metaclass new.
        thisMetaClass setSuperclass: super_class class.
        thisMetaClass instSize: (super_class class instSize + nStatic).
        classBeingLoaded := thisMetaClass new.
        classBeingLoaded setSuperclass: super_class.
        classBeingLoaded setName: thisClassName asSymbol.
    ] ifFalse: [
        "/ a java class
        Class withoutUpdatingChangesDo:[
            classBeingLoaded := JavaClass binaryName: thisClassName numStatic: nStatic.
            classBeingLoaded classLoader: self class classLoaderQuerySignal query.
            fields := fields reject: [:f | f isStatic ].
            JavaClass setInstanceVariableStringFromFields: staticFields
                in: classBeingLoaded class.
            classBeingLoaded setStaticFields: staticFields.
            classBeingLoaded setAccessFlags: access_flags.
            classBeingLoaded setSuperclass: super_class.
            classBeingLoaded setConstantPool: constants.
            classBeingLoaded setFields: fields.
            classBeingLoaded setInterfaces: interfaces.
        ]
    ].

    "/
    "/ get methods
    "/

    self readMethodsFor: classBeingLoaded.
    self readAttributesFor: classBeingLoaded.
    classBeingLoaded setAttributes: attributes.

    "/
    "/ get extensions
    "/
    self readExtensionsFor: classBeingLoaded.

    classBeingLoaded fields do: [:each | self updateOwnerInField: each ].
    classBeingLoaded staticFields do: [:each | self updateOwnerInField: each ].
    classBeingLoaded classLoader: classLoader.
    classesbeingLoaded remove: classBeingLoaded name ifAbsent:[].
    ^ classBeingLoaded.

    "
     JavaClassReader loadFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader loadFile:'/phys/ibm3/hotjava/classes/browser/Alignable.class'
     JavaClassReader loadFile:'foo.cls'

     JavaClassReader verbose:true.
     JavaClassReader loadFile:'/phys/ibm3/hotjava/classes/java/lang/ArithmeticException.class'
     JavaClassReader loadFile:'/phys/ibm3/java/lib/java/lang/ArithmeticException.class'"

    "Created: / 15-04-1996 / 15:02:47 / cg"
    "Modified: / 12-11-1998 / 21:14:45 / cg"
    "Modified: / 15-10-2010 / 17:37:38 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 28-01-2011 / 15:09:48 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 18-05-2011 / 15:30:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-09-2016 / 22:36:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readMagic
    "Read magic, determine byte order"
    | magic |

    msb := true.
    magic := inStream nextUnsignedLongMSB: true.
    magic = (self class magic_MSB) ifFalse: [
        magic = (self class magic_LSB) ifFalse: [
            InvalidClassFormatSignal raiseErrorString: 'not a java class file'.
            ^ nil
        ].
        msb := false.
    ]

    "Created: / 04-12-2014 / 17:32:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readStream:aStream ignoring:classesBeingLoaded
    <resource: #obsolete>
    "reads a class from aStream and returns it.
     The JavaClass is not installed as global"

    ^self readStream:aStream loader: self class classLoaderQuerySignal query ignoring:classesBeingLoaded


    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
    "

    "Created: / 15-04-1996 / 15:00:55 / cg"
    "Modified: / 02-05-2013 / 09:53:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readStream:stream loader: classloader ignoring:classesBeingLoaded
    "reads a class from aStream and returns it.
     The JavaClass is not installed as global"

    inStream := stream.
    classLoader := classloader.
    inStream binary.

    ^ self readClassFileIgnoring:classesBeingLoaded

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
    "

    "Created: / 02-05-2013 / 09:52:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readVersion
    minorVsn := inStream nextUnsignedShortMSB: msb.
    majorVsn := inStream nextUnsignedShortMSB: msb.
    ((self class fileMajorVersions includes: majorVsn) not
        or: [ (self class fileMinorVersions includes: minorVsn) not ])
            ifTrue: [
                | path |

                path := inStream isFileStream ifTrue:[
                    path := inStream pathName
                ] ifFalse:[
                    path := '<memory>'
                ].
                Verbose ifTrue:[
                    self info:
                        ('class reader: file ', path , ' has version ' ,
                             majorVsn printString ,
                                '.' , minorVsn printString)
                ].

            ].

    "Created: / 06-12-2014 / 13:37:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReader methodsFor:'file reading - attributes'!

readAnnotationDefaultAttributeFor:something
    "/        ('JAVA [info]: unhandled attribute: AnnotationDefault') infoPrintCR.

    |len startPos endPos annotationDefault|

    self assert:something isJavaMethod
    message:'AnnotationDefault may only occure for methods!!'.
    len := inStream nextUnsignedLongMSB:msb.
    startPos := inStream position.
    annotationDefault := (something ensureHasAnnotations)
                default:(JavaAnnotationDefault new
                            value:(self readAnnotationValueFor:something));
                default.
    endPos := inStream position.
    inStream position:startPos.
    annotationDefault bytes:(inStream next:len).
    self assert:inStream position = endPos
    message:'self readAnnotationValueFor: something is reading what it shouldn'.

    "Modified: / 28-02-2011 / 17:08:28 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 03-03-2011 / 23:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readAnnotationFor:something
    | typeIndex  type  result  attrsCount |

    typeIndex := inStream nextUnsignedShortMSB:msb.
    type := self constantPoolAt:typeIndex.
    attrsCount := inStream nextUnsignedShortMSB:msb.
    result := JavaAnnotation for:something.
    result name:type.
    attrsCount timesRepeat:
            [ | nameIndex  name attr |

            nameIndex := inStream nextUnsignedShortMSB:msb.
            name := self constantPoolAt:nameIndex.
            attr := self readAnnotationValueFor:something.
            attr name:name.
            result values at: name put:attr.
            AnnotationsVerbose
                ifTrue:[ Logger 
                               log:('JAVA [INFO]: Reading annotation attribute: ' , name)
                               severity:Logger severityDEBUG
                               facility:#JVM. ]. ].
    ^ result.

    "Created: / 17-12-2010 / 16:21:28 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 25-02-2011 / 12:25:36 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 08-12-2014 / 16:23:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 02-03-2015 / 16:04:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readAnnotationValueFor:something
    | tag  result |

    tag := (inStream nextByte) asCharacter.
    tag = $e
        ifTrue:
            [ result := JavaAnnotationEnumValue for:something.
            result nameIndex:(inStream nextUnsignedShortMSB:msb).
            result valueIndex:(inStream nextUnsignedShortMSB:msb).
            AnnotationsVerbose
                ifTrue:
                    [ Logger 
                            log:('JAVA [INFO]: Reading annotation enum value: ' 
                                    , result name printString , ' -> ' 
                                    , result value printString)
                            severity:Logger severityDEBUG
                            facility:#JVM ].
            ^ result ].
    tag = $c
        ifTrue:
            [ result := JavaAnnotationClassValue for:something.
            result classIndex:(inStream nextUnsignedShortMSB:msb).
            AnnotationsVerbose
                ifTrue:
                    [ Logger 
                            log:('JAVA [INFO]: Reading annotation class value: ' 
                                    , result name printString , ' -> ' 
                                    , result value printString)
                            severity:Logger severityDEBUG
                            facility:#JVM ].
            ^ result ].
    tag = $@
        ifTrue:
            [ result := JavaAnnotationNestedAnnotationValue for:something.
            result nestedAnnotation:(self readAnnotationFor: something).
            AnnotationsVerbose
                ifTrue:
                    [ Logger 
                            log:('JAVA [INFO]: Reading annotation nested annotation value: ' 
                                    , result name printString , ' -> ' 
                                    , result value printString)
                            severity:Logger severityDEBUG
                            facility:#JVM ].
            ^ result ].
    tag = $[
        ifTrue:
            [ result := JavaAnnotationArrayValue for:something.
            result count:(inStream nextUnsignedShortMSB:msb).
            AnnotationsVerbose
                ifTrue:[ Logger 
                               log:('JAVA [INFO]: Reading annotation array value')
                               severity:Logger severityDEBUG
                               facility:#JVM ].
            1 to:result count
                do:[:index | result values at:index put:(self readAnnotationValueFor:something) ].
            AnnotationsVerbose
                ifTrue:
                    [ Logger 
                            log:('JAVA [INFO]: Finished reading annotation array value: ' 
                                    , result value printString)
                            severity:Logger severityDEBUG
                            facility:#JVM ].
            ^ result ].
    result := JavaAnnotationPrimitiveValue for:something.
    result valueIndex:(inStream nextUnsignedShortMSB:msb).
     AnnotationsVerbose
                ifTrue:
                    [ Logger 
                            log:('JAVA [INFO]: Finished reading annotation primitive value: ' 
                                    , result name printString , ' -> ' 
                                    , result value printString)
                            severity:Logger severityDEBUG
                            facility:#JVM ].
    ^ result.

    "Created: / 17-12-2010 / 16:44:14 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-02-2011 / 16:12:09 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 12-02-2013 / 19:35:15 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

readAttribute:attributeName for:something
    "/ implemented JAVA attributes

    (attributeName = 'ConstantValue')
        ifTrue:
            [ self readConstantValueAttributeFor:something.
            ^ self. ].
    (attributeName = 'Code')
        ifTrue:
            [ self readCodeAttributeFor:something.
            ^ self. ].
    (attributeName = 'Exceptions')
        ifTrue:
            [ self readExceptionsAttributeFor:something.
            ^ self. ].
    (attributeName = 'InnerClasses')
        ifTrue:
            [ self readInnerClassesAttributeFor:something.
            ^ self. ].
    (attributeName = 'EnclosingMethod')
        ifTrue:
            [ self readEnclosingMethodAttributeFor:something.
            ^ self. ].
    (attributeName = 'LineNumberTable')
        ifTrue:
            [ self readLineNumberTableAttributeFor:something.
            ^ self. ].
    (attributeName = 'LocalVariableTable')
        ifTrue:
            [ self readLocalVariableTableAttributeFor:something.
            ^ self. ].
    (attributeName = 'LocalVariableTypeTable')
        ifTrue:
            [ self readLocalVariableTypeTableAttributeFor:something.
            ^ self. ].
    (attributeName = 'SourceFile')
        ifTrue:
            [ self readSourceFileAttributeFor:something.
            ^ self. ].
    (attributeName = 'SourceDebugExtension')
        ifTrue:
            [ self readSourceDebugExtensionAttributeFor:something.
            ^ self. ].
    (attributeName = 'Synthetic')
        ifTrue:
            [ self readSyntheticAttributeFor:something.
            ^ self. ].
    (attributeName = 'Signature')
        ifTrue:
            [ self readSignatureAttributeFor:something.
            ^ self. ].
    (attributeName = 'Deprecated')
        ifTrue:
            [ self readDeprecatedAttributeFor:something.
            ^ self. ].
    (attributeName = 'RuntimeVisibleAnnotations')
        ifTrue:
            [ self readRuntimeAnnotationsAttributeFor:something visible:true.
            ^ self. ].
    (attributeName = 'RuntimeInvisibleAnnotations')
        ifTrue:
            [  self readRuntimeAnnotationsAttributeFor:something visible:false.
            ^ self. ].
    (attributeName = 'RuntimeVisibleParameterAnnotations')
        ifTrue:
            [ self readRuntimeParameterAnnotationsAttributeFor:something visible:true.
            ^ self. ].
    (attributeName = 'RuntimeInvisibleParameterAnnotations')
        ifTrue:
            [ self readRuntimeParameterAnnotationsAttributeFor:something visible:false.
            ^ self. ].
    (attributeName = 'AnnotationDefault')
        ifTrue:
            [ self readAnnotationDefaultAttributeFor:something.
            ^ self. ].

    "/ ignored JAVA attributes

    (attributeName = 'FastJavac1.0')
        ifTrue:
            [ "/        ('JAVA [info]: unhandled attribute: ' , attributeName) infoPrintCR.
            self skipAttribute:attributeName.
            ^ self. ].
    (attributeName = 'AbsoluteSourcePath')
        ifTrue:
            [ "/        ('JAVA [info]: unhandled attribute: ' , attributeName) infoPrintCR.
            self skipAttribute:attributeName.
            ^ self. ].
    (attributeName startsWith:((Character value:13) asString , 'WARNING:'))
        ifTrue:
            [ "/        ('JAVA [info]: unhandled attribute: ' , attributeName) infoPrintCR.
            self skipAttribute:attributeName.
            ^ self. ].
    (attributeName = 'StackMapTable')
        ifTrue:
            [ "/        ('JAVA [info]: unhandled attribute: ' , attributeName) infoPrintCR.
            self readStackMapTableAttributeFor:something.
            ^ self. ].

    "/ implemented ST attributes

    (attributeName = 'STLiterals')
        ifTrue:
            [ self readSTLiteralsAttributeFor:something.
            ^ self. ].
    (attributeName = 'ClassRevision')
        ifTrue:
            [ self readSTClassRevisionAttributeFor:something.
            ^ self. ].
    (attributeName = 'ClassPackage')
        ifTrue:
            [ self readSTClassPackageAttributeFor:something.
            ^ self. ].
    (attributeName = 'ClassCategory')
        ifTrue:
            [ self readSTClassCategoryAttributeFor:something.
            ^ self. ].
    (attributeName = 'ClassVarNames')
        ifTrue:
            [ self readSTClassVarNamesAttributeFor:something.
            ^ self. ].
    (attributeName = 'ClassInstVarNames')
        ifTrue:
            [ self readSTClassInstVarNamesAttributeFor:something.
            ^ self. ].
    (attributeName = 'InstVarNames')
        ifTrue:
            [ self readSTInstVarNamesAttributeFor:something.
            ^ self. ].
    (attributeName = 'STCode')
        ifTrue:
            [ self readSTCodeAttributeFor:something.
            ^ self. ].
    (attributeName = 'MethodCategory')
        ifTrue:
            [ self readSTMethodCategoryAttributeFor:something.
            ^ self. ].

    "/ Eclipse Java Compiler Specific Attributes
    (attributeName = 'MissingTypes')
        ifTrue:
            [ self readMissingTypesAttributeFor:something.
            ^ self. ].

    "/ unknown attributes

    Logger 
          log:('JAVA [warning]: unrecognized attribute: ' , attributeName)
          severity:Logger severityDEBUG
          facility:#JVM.
    self skipAttribute:attributeName.

    "Modified: / 03-12-1998 / 13:13:42 / cg"
    "Modified: / 25-02-2011 / 18:09:21 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 02-03-2015 / 16:04:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readAttributeFor:something
    |attribute_name_index attribute_name attribute_length attribute_info|

    Verbose ifTrue:[Transcript show:'attrib at pos: '; showCR:inStream position].

    attribute_name_index := inStream nextUnsignedShortMSB:msb.
    attribute_name_index == 0 ifTrue:[
        self halt.
        "/self skipAttribute:'unnamed'.
        ^ self.
    ].

    "/
    "/ UNDOC feature ?
    "/
    attribute_name_index > constants size ifTrue:[
        attribute_name_index == 16rb700 ifTrue:[
            self halt.
        ]
    ].

    attribute_name := self constantPoolAt:attribute_name_index.

    Verbose ifTrue:[Transcript show:'attrib name: '; showCR:attribute_name].

    self readAttribute:attribute_name for:something.

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
    "

    "Created: / 15-04-1996 / 15:40:17 / cg"
    "Modified: / 09-04-1998 / 18:13:34 / cg"
    "Modified: / 19-10-2010 / 21:43:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readAttributeLength
    ^ inStream nextUnsignedLongMSB:msb

    "Created: / 03-12-2014 / 12:53:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readAttributesFor:something
    |attributes_count|

    attributes_count := inStream nextUnsignedShortMSB:msb.
    attributes := OrderedCollection new: attributes_count * 2.

    1 to:attributes_count do:[:i |
        self readAttributeFor:something.
    ].

    "Created: / 15-04-1996 / 15:40:17 / cg"
    "Modified: / 13-09-2013 / 01:01:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readDeprecatedAttributeFor:aJavaMethodWithHandler

    self skipAttribute:'Deprecated'.
    ^self

    "Created: / 18-10-2010 / 22:26:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readEnclosingMethodAttributeFor:something
    | class_ref_index method_ref_index |

    self skipAttributeLength.
    class_ref_index := inStream nextUnsignedShortMSB:msb.
    method_ref_index := inStream nextUnsignedShortMSB:msb.
    attributes add: #EnclosingMethod; add: (Array with: class_ref_index with: method_ref_index)

    "Modified: / 03-12-2014 / 12:56:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readInnerClassesAttributeFor:something
    | attribute_length number_of_classes classes |

    attribute_length := inStream nextUnsignedLongMSB:msb. "/ skip attribute length.
    number_of_classes := inStream nextUnsignedShortMSB:msb.
    classes := JavaInnerClasses new: number_of_classes.
    self assert: attribute_length == ((number_of_classes * 8) + 2).
    1 to: number_of_classes do:[:i |
        | entry |

        entry := JavaInnerClasses::Entry new.
        entry setInnerClassRefIndex:(inStream nextUnsignedShortMSB:msb).
        entry setOuterClassRefIndex:(inStream nextUnsignedShortMSB:msb).
        entry setNameIndex: (inStream nextUnsignedShortMSB:msb).
        entry setAccessFlags: (inStream nextUnsignedShortMSB:msb).
        classes at: i put:  entry
    ].

    attributes add: #InnerClasses; add: classes.

    "Modified: / 03-12-2014 / 14:06:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readLocalVariableTypeTableAttributeFor:something
"/        ('JAVA [info]: unhandled attribute: LocalVariableTypeTable') infoPrintCR.
        self skipAttribute:'LocalVariableTypeTable'.
!

readMissingTypesAttributeFor:something
    | attribute_length numMissingTypes missingTypes |

    attribute_length := inStream nextUnsignedLongMSB:msb. "/ skip attribute length.
    numMissingTypes := inStream nextUnsignedShortMSB:msb.
    missingTypes := Array new: numMissingTypes.
    self assert: attribute_length == ((numMissingTypes * 2) + 2).
    1 to: numMissingTypes do:[: i |
        missingTypes at: i put: (inStream nextUnsignedShortMSB:msb)
    ].

    attributes add: #MissingTypes; add: missingTypes.

    "Created: / 16-10-2013 / 02:04:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readRuntimeAnnotationsAttributeFor: something visible: visible
    | length  annotationsCount  annotations  rawAnnotations  startPos  endPos |

    self assert: inStream isPositionable
        message: '.class file stream must be positionable'.
    length := inStream nextUnsignedLongMSB: msb.
    startPos := inStream position.
    annotationsCount := inStream nextUnsignedShortMSB: msb.
    annotationsCount = 0 ifTrue: [ ^ nil ].
    annotations := visible ifTrue: [something ensureHasAnnotations ensureRuntimeVisible] ifFalse: [something ensureHasAnnotations ensureRuntimeInvisible].
    annotationsCount timesRepeat:
            [ | currentAnnotation |

            currentAnnotation := self readAnnotationFor: something.
            annotations at: currentAnnotation name put: currentAnnotation. ].
     "Cut raw annotations as required by getRawAnnotations()"
    endPos := inStream position.
    inStream position: startPos.
    rawAnnotations := inStream next: length.
    inStream position ~= endPos
        ifTrue: [ self halt: 'annotations are probably reading what they shouldnt' ].
    annotations rawAnnotations: rawAnnotations.

    "Modified: / 07-01-2011 / 22:00:07 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 25-02-2011 / 18:45:58 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 03-03-2011 / 23:01:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2011 / 16:57:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

readRuntimeParameterAnnotationsAttributeFor: javaMethod visible: visible
    | length  paramsCount  annotationsCount  rawAnnotations  startPos  endPos |
    self assert: inStream isPositionable
        message: '.class file stream must be positionable'.
    length := inStream nextUnsignedLongMSB: msb.
    startPos := inStream position.
    paramsCount := inStream nextByte.
    paramsCount = 0 ifTrue: [ ^ nil ].
    1 to: paramsCount do: [
        :paramIndex |
        annotationsCount := inStream nextUnsignedShortMSB: msb.
        annotationsCount > 0 ifTrue: [
            | annotations |
            annotations := visible ifTrue: [
                    javaMethod ensureHasAnnotations
                        ensureVisibleParameterAnnotationsAt: paramIndex
                ] ifFalse: [
                    javaMethod ensureHasAnnotations
                        ensureInvisibleParameterAnnotationsAt: paramIndex
                ].
            annotationsCount timesRepeat: [
                | annotation |
                annotation := self readAnnotationFor: javaMethod.
                annotations at: (annotation name) put: annotation.
            ]
        ]
    ].
    endPos := inStream position.
    inStream position: startPos.
    rawAnnotations := inStream next: length.
    inStream position ~= endPos ifTrue: [
        self halt: 'annotations are probably reading what they shouldnt'
    ].

    javaMethod annotations rawParamAnnotations: rawAnnotations.

    "Modified: / 28-02-2011 / 17:05:47 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 01-12-2012 / 22:54:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 25-01-2014 / 21:44:28 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

readSignatureAttributeFor:something

    |attribute_length signature_index signature|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    signature_index := inStream nextUnsignedShortMSB:msb.
    signature := self constantPoolAt:signature_index.

    something isJavaClass ifTrue:[
        attributes add: #GenericSignature; add: signature
    ] ifFalse:[
        something setSignature: signature.
    ].

    "Modified: / 07-12-2014 / 01:43:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readSourceDebugExtensionAttributeFor:something
"/        ('JAVA [info]: unhandled attribute: SourceDebugExtension') infoPrintCR.
        self skipAttribute:'SourceDebugExtension'.
!

readSourceFileAttributeFor:aClass
    |attribute_length sourceFile_index sourceFile|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    sourceFile_index := inStream nextUnsignedShortMSB:msb.
    sourceFile := self constantPoolAt:sourceFile_index.

    aClass isJavaClass ifTrue:[
        aClass setSourceFile:sourceFile.
    ] ifFalse:[
        aClass setClassFilename:sourceFile
    ].

    Verbose ifTrue:[Transcript show:'sourceFile: '; showCR:sourceFile].
    ^ true

    "
     JavaClassReader loadFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader loadFile:'/phys/ibm3/hotjava/classes/browser/Alignable.class'
     JavaClassReader loadFile:'foo.cls'
    "

    "Created: / 15.4.1996 / 15:40:17 / cg"
    "Modified: / 12.5.1998 / 22:01:07 / cg"
!

readStackMapTableAttributeFor:something
"/        ('JAVA [info]: unhandled attribute: StackMapTable') infoPrintCR.
    self skipAttribute:'StackMapTable'.

    "Created: / 09-02-2011 / 01:19:20 / Marcel Hlopko <hlopik@gmail.com>"
!

readSyntheticAttributeFor:something
"/        ('JAVA [info]: unhandled attribute: Synthetic') infoPrintCR.
        self skipAttribute:'Synthetic'.
        attributes add: #Synthetic; add: true.

    "Modified: / 13-09-2013 / 01:08:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipAttribute
    "Skip attribute, advance in .class file stream to next entity"
    inStream skip: self readAttributeLength.

    "Created: / 06-12-2014 / 10:53:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipAttribute:attributeName
    "dont know about this attribute - skip it here"

    Verbose ifTrue:[Transcript show:'skipped '; show:attributeName; showCR:'-attribute'].
    self skipAttribute

    "Created: / 09-04-1998 / 18:12:46 / cg"
    "Modified: / 06-12-2014 / 10:54:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipAttributeLength
    inStream skip:4.

    "Created: / 03-12-2014 / 12:53:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReader methodsFor:'file reading - attributes-ST'!

readSTClassCategoryAttributeFor:aClass
    |attribute_length categoryString_index categoryString|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    categoryString_index := inStream nextUnsignedShortMSB:msb.
    categoryString := self constantPoolAt:categoryString_index.

    aClass category:categoryString.

    Verbose ifTrue:[Transcript show:'categoryString: '; showCR:categoryString].
    ^ true

    "
     JavaClassReader loadFile:'foo.cls'
    "

    "Created: / 9.5.1998 / 02:33:13 / cg"
    "Modified: / 9.5.1998 / 02:36:55 / cg"
!

readSTClassInstVarNamesAttributeFor:aClass
    |attribute_length nameString_index nameString|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    nameString_index := inStream nextUnsignedShortMSB:msb.
    nameString := self constantPoolAt:nameString_index.

    aClass class instanceVariableString:nameString.

    Verbose ifTrue:[Transcript show:'nameString: '; showCR:nameString].
    ^ true

    "
     JavaClassReader loadFile:'foo.cls'
    "

    "Modified: / 12.5.1998 / 22:18:03 / cg"
    "Created: / 12.5.1998 / 22:18:24 / cg"
!

readSTClassPackageAttributeFor:aClass
    |attribute_length packageString_index packageString|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    packageString_index := inStream nextUnsignedShortMSB:msb.
    packageString := self constantPoolAt:packageString_index.

    aClass package:packageString asSymbol.

    Verbose ifTrue:[Transcript show:'packageString: '; showCR:packageString].
    ^ true

    "
     JavaClassReader loadFile:'foo.cls'
    "

    "Modified: / 9.5.1998 / 02:32:38 / cg"
    "Created: / 9.5.1998 / 02:33:44 / cg"
!

readSTClassRevisionAttributeFor:aClass
    |attribute_length revisionString_index revisionString|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    revisionString_index := inStream nextUnsignedShortMSB:msb.
    revisionString := self constantPoolAt:revisionString_index.

    aClass setBinaryRevision:revisionString.

    Verbose ifTrue:[Transcript show:'revisionString: '; showCR:revisionString].
    ^ true

    "
     JavaClassReader loadFile:'foo.cls'
    "

    "Created: / 9.5.1998 / 02:33:13 / cg"
    "Modified: / 9.5.1998 / 02:35:01 / cg"
!

readSTClassVarNamesAttributeFor:aClass
    |attribute_length nameString_index nameString|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    nameString_index := inStream nextUnsignedShortMSB:msb.
    nameString := self constantPoolAt:nameString_index.

    aClass classVariableString:nameString.

    Verbose ifTrue:[Transcript show:'nameString: '; showCR:nameString].
    ^ true

    "
     JavaClassReader loadFile:'foo.cls'
    "

    "Created: / 9.5.1998 / 02:33:13 / cg"
    "Modified: / 12.5.1998 / 22:18:03 / cg"
!

readSTInstVarNamesAttributeFor:aClass
    |attribute_length nameString_index nameString|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    nameString_index := inStream nextUnsignedShortMSB:msb.
    nameString := self constantPoolAt:nameString_index.

    aClass setInstanceVariableString:nameString.

    Verbose ifTrue:[Transcript show:'nameString: '; showCR:nameString].
    ^ true

    "
     JavaClassReader loadFile:'foo.cls'
    "

    "Created: / 12.5.1998 / 22:18:14 / cg"
    "Modified: / 12.5.1998 / 22:21:10 / cg"
! !

!JavaClassReader methodsFor:'file reading - constants'!

readConstant
    |tag constReader|


    constNeeds2Slots := false.

    "/
    "/ get tag
    "/
    tag := inStream nextByte.
    Verbose ifTrue:[Transcript show:'tag = '; showCR:tag].

    tag >= 250 ifTrue:[
        constReader := #(
                        "/ ST types
                        readConstant_ST_Large           "/ 249
                        readConstant_ST_Special         "/ 250
                        readConstant_ST_Character       "/ 251
                        readConstant_ST_ByteArray       "/ 252
                        readConstant_ST_Array           "/ 253
                        readConstant_ST_Symbol          "/ 254
                        readConstant_ST_Reserved        "/ 255
                    ) at:tag-249+1.
    ] ifFalse:[
        constReader := #(
                        "/ JAVA types
                        readConstant_Utf8               "/ 1  - now called Utf8
                        readConstant_Unicode            "/ 2
                        readConstant_Integer            "/ 3
                        readConstant_Float              "/ 4
                        readConstant_Long               "/ 5
                        readConstant_Double             "/ 6
                        readConstant_Class              "/ 7
                        readConstant_String             "/ 8
                        readConstant_Fieldref           "/ 9
                        readConstant_Methodref          "/ 10
                        readConstant_InterfaceMethodref "/ 11
                        readConstant_NameAndType        "/ 12
                        readConstant_Undef              "/ 13
                        readConstant_Undef              "/ 14
                        readConstant_MethodHandle       "/ 15
                        readConstant_MethodType         "/ 16
                        readConstant_Undef              "/ 17
                        readConstant_InvokeDynamic      "/ 18
                    ) at:tag ifAbsent:[#readConstant_Undef].
    ].
    ^ self perform:constReader.

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
    "

    "Created: / 15-04-1996 / 15:46:32 / cg"
    "Modified: / 09-05-1998 / 01:26:05 / cg"
    "Modified: / 20-05-2014 / 17:15:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstantPool
    | constantPoolSize  const |

    "/
    "/ get constant pool
    "/
    constantPoolSize := inStream nextUnsignedShortMSB: msb.
    Verbose ifTrue:[
        self info: 'constantPoolSize = ' , constantPoolSize printString.
    ].
    constants := JavaConstantPool new: constantPoolSize - 1.
    constSlot := 1.
    [ constSlot < constantPoolSize ] whileTrue: [
            Verbose ifTrue:[
                self info: 'const slot: ' , constSlot printString.
            ].
            const := self readConstant.
            constants at: constSlot put: const.

            "/ long & double consts take 2 slots
            "/ (only first is used)

            constSlot := constNeeds2Slots ifTrue: [ constSlot + 2. ] ifFalse: [ constSlot + 1. ]].
    constSlot := -1.

    constants do:[:ref|ref isJavaRef ifTrue:[ref preResolve]].
"/    1 to: constantPoolSize - 1
"/        do:
"/            [:i |
"/            | const  value |
"/
"/            const := self constantPoolAt: i.
"/            const notNil ifTrue:
"/                    [ "/ kludge for 2-slot constants (which only take 1 slot in ST/X)
"/                    (const isKindOf: JavaUnresolvedConstant)
"/                        ifTrue:
"/                            [ value := const preResolve.
"/                            value ~~ const ifTrue: [ self constantPoolAt: i put: value. ] ] ] ].

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/Alignable.class'"

    "Modified: / 07-05-1998 / 11:44:06 / cg"
    "Created: / 13-05-2011 / 16:52:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:41:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_Asciz
    | len  string |


    len := inStream nextUnsignedShortMSB: msb.
    string := String new: len.
    inStream
        nextBytes: len
        into: string
        startingAt: 1.
    string := InternedStrings elementAt: string ifAbsent: [ InternedStrings add: string ].
    Verbose
        ifTrue:
            [ Transcript
                show: 'asciz; string= ';
                showCR: string ].
    ^ string

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/Alignable.class'"

    "Created: / 15-04-1996 / 15:15:35 / cg"
    "Modified: / 15-04-1996 / 16:33:45 / cg"
    "Modified: / 13-05-2011 / 17:31:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-11-2014 / 11:53:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_Class
    | nameIndex |

    nameIndex := inStream nextUnsignedShortMSB: msb.
    Verbose ifTrue:[
        ((self constantPoolAt: nameIndex) isNil) ifTrue: [
                self info: ('reading class; index=' , nameIndex printString , ' name='
                            , (self constantPoolAt: nameIndex) printString)
        ] ifFalse: [
            self info: ('reading class; index= ' , nameIndex printString)
        ].
    ].
    ^ JavaClassRef2 in: constants withNameAt: nameIndex.

    "Modified: / 18-05-2011 / 18:21:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-09-2016 / 22:34:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_Double
    |high low aFloat bytes|

"/ new code - to be tested
"/    bytes := ByteArray new:8.
"/
"/    inStream nextBytes:8 into:bytes startingAt:1.
"/    msb ~~ UninterpretedBytes isBigEndian ifTrue:[
"/        bytes reverse
"/    ].
"/    aFloat := bytes doubleAt:1.

"/ old code

    high := inStream nextUnsignedLongMSB:msb.
    low := inStream nextUnsignedLongMSB:msb.

    aFloat := Float new.
    UninterpretedBytes isBigEndian ifTrue:[
        aFloat basicAt:1 put:((high bitShift:-24) bitAnd:16rFF).
        aFloat basicAt:2 put:((high bitShift:-16) bitAnd:16rFF).
        aFloat basicAt:3 put:((high bitShift:-8) bitAnd:16rFF).
        aFloat basicAt:4 put:(high bitAnd:16rFF).
        aFloat basicAt:5 put:((low bitShift:-24) bitAnd:16rFF).
        aFloat basicAt:6 put:((low bitShift:-16) bitAnd:16rFF).
        aFloat basicAt:7 put:((low bitShift:-8) bitAnd:16rFF).
        aFloat basicAt:8 put:(low bitAnd:16rFF).
    ] ifFalse:[
        aFloat basicAt:1 put:(low bitAnd:16rFF).
        aFloat basicAt:2 put:((low bitShift:-8) bitAnd:16rFF).
        aFloat basicAt:3 put:((low bitShift:-16) bitAnd:16rFF).
        aFloat basicAt:4 put:((low bitShift:-24) bitAnd:16rFF).
        aFloat basicAt:5 put:(high bitAnd:16rFF).
        aFloat basicAt:6 put:((high bitShift:-8) bitAnd:16rFF).
        aFloat basicAt:7 put:((high bitShift:-16) bitAnd:16rFF).
        aFloat basicAt:8 put:((high bitShift:-24) bitAnd:16rFF).
    ].

    constNeeds2Slots := true.

    Verbose ifTrue:[Transcript show:'double; value= ';     showCR:aFloat].
    ^ aFloat

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/Alignable.class'
    "

    "Created: / 15.4.1996 / 16:34:42 / cg"
    "Modified: / 8.5.1998 / 22:06:07 / cg"
!

readConstant_Fieldref
    "incrementally changing resolving logic, fields will come later"

    | classIndex  nameAndTypeIndex |

    classIndex := inStream nextUnsignedShortMSB: msb.
    nameAndTypeIndex := inStream nextUnsignedShortMSB: msb.
    Verbose ifTrue:[
        self
            info: 'reading fieldref; classindex=' , classIndex printString
                    , ' nameAndTypeIndex=' , nameAndTypeIndex printString.
    ].
    ^ JavaFieldRef2
        in: constants
        withNameAndTypeAt: nameAndTypeIndex
        andClassAt: classIndex.

    "Modified: / 15-05-2011 / 14:20:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_Float
    |b1 b2 b3 b4 aFloat bytes|

"/ new code - to be tested ...
"/
"/    bytes := ByteArray new:4.
"/    inStream nextBytes:4 into:bytes startingAt:1.
"/    msb ~~ UninterpretedBytes isBigEndian ifTrue:[
"/        bytes reverse
"/    ].
"/    aFloat := bytes floatAt:1.
"/    Verbose ifTrue:[Transcript show:'float; value= ';     showCR:aFloat].
"/    ^ aFloat.

"/ old code

    aFloat := ShortFloat basicNew.

    b1 := inStream nextByte.
    b2 := inStream nextByte.
    b3 := inStream nextByte.
    b4 := inStream nextByte.

    UninterpretedBytes isBigEndian ifTrue:[
        aFloat basicAt:1 put:b1.
        aFloat basicAt:2 put:b2.
        aFloat basicAt:3 put:b3.
        aFloat basicAt:4 put:b4.
    ] ifFalse:[
        aFloat basicAt:4 put:b1.
        aFloat basicAt:3 put:b2.
        aFloat basicAt:2 put:b3.
        aFloat basicAt:1 put:b4.
    ].
    Verbose ifTrue:[Transcript show:'float; value= ';     showCR:aFloat].
    ^ aFloat

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/Alignable.class'
    "

    "Created: / 15.4.1996 / 16:34:42 / cg"
    "Modified: / 10.11.1998 / 22:04:59 / cg"
!

readConstant_Integer
    |value|

    value := inStream nextLongMSB:msb.

    Verbose ifTrue:[Transcript show:'integer; value= ';     showCR:value].

    ^ value

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/Alignable.class'
    "

    "Modified: 15.4.1996 / 15:42:16 / cg"
    "Created: 15.4.1996 / 16:34:42 / cg"
!

readConstant_InterfaceMethodref
    | classIndex  nameAndTypeIndex  |

    classIndex := inStream nextUnsignedShortMSB: msb.
    nameAndTypeIndex := inStream nextUnsignedShortMSB: msb.
    Verbose ifTrue:[
        self
            info: 'reading interface methodref; classindex=' , classIndex printString
                    , ' nameAndTypeIndex=' , nameAndTypeIndex printString.
    ].
    ^ JavaInterfaceMethodRef2
        in: constants
        withNameAndTypeAt: nameAndTypeIndex
        andClassAt: classIndex.

    "Modified: / 12-05-2011 / 18:57:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:38:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_InvokeDynamic
    | bootstrapMethodAttrIndex nameAndTypeIndex |

    bootstrapMethodAttrIndex := inStream nextUnsignedShortMSB: msb.
    nameAndTypeIndex := inStream nextUnsignedShortMSB: msb.

    ^ JavaInvokeDynamic2
        in: constants
        bootstrapMethodAttrIndex:bootstrapMethodAttrIndex
        nameAndTypeIndex:nameAndTypeIndex

    "Created: / 20-05-2014 / 17:37:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_Long
    |high low value|

    high := inStream nextUnsignedLongMSB:msb.
    low := inStream nextUnsignedLongMSB:msb.

    value := (high bitShift:32) bitOr:low.
    (high bitTest:16r80000000) ifTrue:[
	value := value - 16r10000000000000000.
    ].
    constNeeds2Slots := true.

    Verbose ifTrue:[Transcript show:'long; value= ';     showCR:value].
    ^ value

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/Alignable.class'
    "

    "Modified: 15.4.1996 / 15:42:16 / cg"
    "Created: 15.4.1996 / 16:34:42 / cg"
!

readConstant_MethodHandle
    | reference_kind  reference_index |

    reference_kind := inStream next.
    reference_index := inStream nextUnsignedShortMSB: msb.

    ^ JavaMethodHandle2
        in:constants
        kind:reference_kind
        index:reference_index

    "Created: / 20-05-2014 / 17:30:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_MethodType
    | descriptorIndex |

    descriptorIndex := inStream nextUnsignedShortMSB: msb.
    ^ JavaMethodType2
        in:constants
        index:descriptorIndex

    "Created: / 20-05-2014 / 17:40:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_Methodref
    | classIndex  nameAndTypeIndex   |

    classIndex := inStream nextUnsignedShortMSB: msb.
    nameAndTypeIndex := inStream nextUnsignedShortMSB: msb.
    Verbose ifTrue:[
        self
            info: 'reading methodref; classindex=' , classIndex printString , ' nameAndTypeIndex='
                    , nameAndTypeIndex printString.
    ].
    ^ JavaMethodRef2
        in: constants
        withNameAndTypeAt: nameAndTypeIndex
        andClassAt: classIndex.

    "Modified: / 15-05-2011 / 14:20:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:38:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_NameAndType
    | nameIndex  descriptorIndex |

    nameIndex := inStream nextUnsignedShortMSB: msb.
    descriptorIndex := inStream nextUnsignedShortMSB: msb.
    Verbose ifTrue:[
        self
            info: 'reading nameAndType; nameindex=' , nameIndex printString
                    , ' descriptorIndex= ' , descriptorIndex printString.
    ].
    ^JavaNameAndType2
                in: constants
                withNameAt: nameIndex
                andDescriptorAt: descriptorIndex.

    "Modified: / 10-05-2011 / 17:09:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_String
    | string_index |

    string_index := inStream nextUnsignedShortMSB: msb.
    ^ JavaStringRef2 in: constants withValueAt: string_index.



    "Created: / 15-04-1996 / 15:20:33 / cg"
    "Modified: / 07-05-1998 / 11:42:45 / cg"
    "Modified: / 13-05-2011 / 17:31:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 10-08-2011 / 23:25:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_Unicode
    | len  string  ascii |

    len := inStream nextUnsignedShortMSB: msb.
    string := TwoByteString new: len.
    1 to: len
        do:
            [:idx |
            ascii := inStream nextUnsignedShortMSB: msb.
            string at: idx put: (Character value: ascii). ].
    string := InternedStrings elementAt: string ifAbsent: [ InternedStrings add: string ].
    Verbose
        ifTrue:
            [ Transcript
                show: 'asciz; unicodeString= ';
                showCR: string ].
    ^ string

    "Modified: / 13-05-2011 / 17:31:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-11-2014 / 11:53:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readConstant_Utf8
    | len string |

    len := inStream nextUnsignedShortMSB: msb.
    string  := String uninitializedNew: len.
    inStream
        nextBytes: len
        into: string
        startingAt: 1.
    string := CharacterArray decodeFromJavaUTF8: string.
    string := InternedStrings elementAt: string ifAbsent: [ InternedStrings add: string ].
    Verbose
        ifTrue:
            [ Transcript
                show: 'asciz; string= ';
                showCR: string ].
    ^ string

    "Modified: / 13-05-2011 / 17:31:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-11-2014 / 11:53:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReader methodsFor:'file reading - constants-ST'!

readConstant_ST_Array
    |aSize arr|

    aSize := inStream nextUnsignedShortMSB:msb.
    arr := Array new:aSize.

    1 to:aSize do:[:i |
        |element_index element|

        element_index := inStream nextUnsignedShortMSB:msb.
        arr at:i put:element_index.
    ].
    Verbose ifTrue:[Transcript show:'array; size= ';     showCR:aSize].

    ^ JavaUnresolvedSTArrayConstant
                pool:constants
                poolIndex:constSlot
                array:arr

    "Created: / 7.5.1998 / 11:47:01 / cg"
    "Modified: / 9.5.1998 / 00:25:34 / cg"
!

readConstant_ST_ByteArray
    |aSize arr|

    aSize := inStream nextUnsignedShortMSB:msb.
    arr := ByteArray new:aSize.

    1 to:aSize do:[:i |
        |element_index|

        arr at:i put:(inStream nextByte).
    ].
    Verbose ifTrue:[Transcript show:'byteArray; size= ';     showCR:aSize].

    ^ arr

    "Created: / 7.5.1998 / 11:47:12 / cg"
!

readConstant_ST_Character
    |ascii|

    ascii := inStream nextUnsignedShortMSB:msb.

    Verbose ifTrue:[Transcript show:'char; ascii= '; showCR:ascii].
    ^ Character value:ascii

    "Created: / 7.5.1998 / 11:48:12 / cg"
!

readConstant_ST_Special
    |type|

    type := inStream nextUnsignedShortMSB:msb.
    ^ #(
        nil
        true
        false
     ) at:(type + 1)

    "Created: / 8.5.1998 / 23:06:56 / cg"
    "Modified: / 9.5.1998 / 00:40:14 / cg"
!

readConstant_ST_String
    | tag  string_index  chars |


    string_index := inStream nextUnsignedShortMSB: msb.
    Verbose
        ifTrue:
            [ Transcript
                show: 'string; index= ';
                showCR: string_index ].

    "/ resolve here if possible

    string_index < constSlot
        ifTrue:
            [ chars := (self constantPoolAt: string_index).
            ^ chars ].
    ^ JavaUnresolvedSTStringConstant
        pool: constants
        poolIndex: constSlot
        stringIndex: string_index

    "Created: / 07-05-1998 / 11:49:55 / cg"
    "Modified: / 13-05-2011 / 17:32:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

readConstant_ST_Symbol
    | tag  string_index  chars |


    string_index := inStream nextUnsignedShortMSB: msb.
    Verbose
        ifTrue:
            [ Transcript
                show: 'symbol; index= ';
                showCR: string_index ].

    "/ resolve here if possible

    string_index < constSlot
        ifTrue:
            [ chars := (self constantPoolAt: string_index).
            chars isString ifFalse: [ self halt: 'should not happen' ].
            ^ chars asSymbol ].
    ^ JavaUnresolvedSTSymbolConstant
        pool: constants
        poolIndex: constSlot
        stringIndex: string_index

    "Modified: / 07-05-1998 / 11:48:28 / cg"
    "Modified: / 13-05-2011 / 17:32:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassReader methodsFor:'file reading - extensions'!

readExtensionsFor: class
    "Given a class, load extensions (i.e., non-java methods) for that class"

    | classnameAsPath |

    classnameAsPath := class binaryName copyReplaceAll: $/ with: Filename separator.

    Java effectiveExtensionsPath do:[:each|
        ProgrammingLanguage allDo:[:lang|
            lang supportsExtensionMethods ifTrue:[
                | file |
                file := each asString , Filename separator , classnameAsPath , '.' , lang sourceFileSuffix.
                file := file asFilename.
                file exists ifTrue:[
                    self readExtensionsFor: class from: file language: lang
                ]
            ]
        ]
    ]

    "Created: / 06-09-2012 / 11:37:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:59:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readExtensionsFor: class from: file
    "Given a class, load extensions (i.e., non-java methods) for that class"

    JAVA isNil ifTrue:[ JavaPackage initialize ].
    [
        Smalltalk fileIn: file.
    ] on: JavaClassQuery do:[:query |
        query className = class name ifTrue:[
            query resumeWith: class
        ] ifFalse:[
            query resumeWith: nil.
        ]
    ].

    "Created: / 06-09-2012 / 12:04:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readExtensionsFor: class from: file language: language
    "Given a class, load extensions (i.e., non-java methods) for that class"

    JAVA isNil ifTrue:[ JavaPackage initialize ].
    [
        | wasSilent |

        wasSilent := Smalltalk silentLoading.
        Smalltalk silentLoading: true.
        [
            Class withoutUpdatingChangesDo:[
                language fileIn: file.
            ].
        ] ensure:[
            Smalltalk silentLoading: wasSilent
        ].
    ] on: JavaClassQuery do:[:query |
        query className = class binaryName ifTrue:[
            query resumeWith: class
        ] ifFalse:[
            query resumeWith: nil.
        ]
    ].

    "Created: / 06-09-2012 / 12:14:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 11:12:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReader methodsFor:'file reading - fields'!

readConstantValueAttributeFor:aField
    |attribute_length constantvalue_index constantValue|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    constantvalue_index := inStream nextUnsignedShortMSB:msb.
    constantValue := self constantPoolAt:constantvalue_index.

    aField constantValue:constantValue.

    Verbose ifTrue:[Transcript show:'constantValue: '; showCR:constantValue].
    ^ true

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/Alignable.class'
    "

    "Modified: 15.4.1996 / 15:33:28 / cg"
    "Created: 15.4.1996 / 15:40:17 / cg"
!

readFieldInfofield
    | access_flags  name_index  descriptor_index  attributes_count  field |

    access_flags := inStream nextUnsignedShortMSB: msb.
    name_index := inStream nextUnsignedShortMSB: msb.
    descriptor_index := inStream nextUnsignedShortMSB: msb.
    field := JavaField new.
    field setAccessFlags: access_flags.
    field setName: (self constantPoolAt: name_index) asSymbol.
    field setDescriptor: (self constantPoolAt: descriptor_index) asSymbol.
    attributes_count := inStream nextUnsignedShortMSB: msb.
    attributes := OrderedCollection new: attributes_count * 2.
    Verbose
        ifTrue:
            [ Transcript
                show: '  field name: ';
                show: (self constantPoolAt: name_index);
                show: ' access: ';
                show: access_flags;
                show: ' attrib_cnt: ';
                showCR: attributes_count ].
    1 to: attributes_count do: [:i | self readAttributeFor: field. ].
    ^ field.

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'"

    "Created: / 15-04-1996 / 15:38:43 / cg"
    "Modified: / 15-10-1998 / 10:38:01 / cg"
    "Modified: / 17-12-2010 / 18:44:30 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 18-05-2011 / 14:11:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-12-2014 / 16:25:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFieldInfofields
    |nFields fields|

    "/
    "/ get fieldInfos
    "/
    nFields := inStream nextUnsignedShortMSB:msb.
    Verbose ifTrue:[Transcript show:'fieldsCount = '; showCR:nFields].

    fields := Array new:nFields.

    1 to:nFields do:[:i |
	Verbose ifTrue:[Transcript show:'field: '; showCR:i].
	fields at:i put:(self readFieldInfofield)
    ].
    ^ fields

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
    "

    "Created: 15.4.1996 / 15:34:41 / cg"
    "Modified: 15.4.1996 / 15:35:28 / cg"
! !

!JavaClassReader methodsFor:'file reading - interfaces'!

readInterfaces
    | interfacesCount interface_index interfaces |

    "/
    "/ get interfaces
    "/
    interfacesCount := inStream nextUnsignedShortMSB:msb.
    Verbose ifTrue:[Transcript show:'interfacesCount = '; showCR:interfacesCount].

    interfaces := Array new:interfacesCount.

    1 to:interfacesCount do:[:i |
        Verbose ifTrue:[Transcript show:'interface: '; showCR:i].
        interface_index := inStream nextUnsignedShortMSB:msb.
        interfaces at:i put:interface_index.
    ].
    ^ interfaces

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
    "

    "Created: / 15-04-1996 / 15:31:59 / cg"
    "Modified: / 27-11-2014 / 16:55:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReader methodsFor:'file reading - methods'!

readCodeAttributeFor:aJavaMethod
    |attribute_length max_stack max_locals code_length code
     exception_table_length exception_table unknown1 unknown2 |

    attribute_length := inStream nextUnsignedLongMSB:msb.

    Verbose ifTrue:[Transcript show:'code_attribute_length: 0x'; showCR:(attribute_length printStringRadix:16)].

    ((minorVsn > 2) or:[majorVsn > 45]) ifTrue:[
        "/ should be:
        max_stack := inStream nextUnsignedShortMSB:msb.
        max_locals := inStream nextUnsignedShortMSB:msb.
        code_length := inStream nextUnsignedLongMSB:msb.
        "/ Remember max context size so far, will be used to
        "/ optimize context size as alloca() won't work.
        MaxContextSize := MaxContextSize max: (max_stack + max_locals + 4"safe area").
"
        MaxContextSize > MaxContextSizeLimit ifTrue:[
            self error:'method''s stack depth overflows VM limit'.
            ^false
        ].
"

"/        unknown1 := inStream nextByte.
"/        max_stack := inStream nextByte.
"/        max_locals := inStream nextUnsignedShortMSB:msb.
"/        unknown2 := inStream nextUnsignedShortMSB:msb.
"/        code_length := inStream nextUnsignedShortMSB:msb.
"/        Verbose ifTrue:[Transcript show:'?1: '; showCR:unknown1].
"/        Verbose ifTrue:[Transcript show:'?2: '; showCR:unknown2].
    ] ifFalse:[
        max_stack := inStream nextByte.
        max_locals := inStream nextByte.
        code_length := inStream nextUnsignedShortMSB:msb.
    ].

    Verbose ifTrue:[
        Transcript show:'code_length: '; showCR:(code_length printStringRadix:16).
        Transcript show:'code at pos: '; showCR:inStream position
    ].

    code_length ~~ 0 ifTrue:[
        code := ByteArray new:code_length.
        inStream nextBytes:code_length into:code startingAt:1.
    ].
    Verbose ifTrue:[Transcript show:'method code: '; showCR:code.].

    exception_table_length := inStream nextUnsignedShortMSB:msb.
    Verbose ifTrue:[Transcript show:'exception_table_length: '; showCR:(exception_table_length printStringRadix:16)].
    exception_table_length ~~ 0 ifTrue:[
        Verbose ifTrue:[Transcript show:'exceptionTable length:'; showCR:exception_table_length.].

        exception_table := JavaExceptionTable new:exception_table_length * 4.
        1 to:exception_table_length do:[:i |

            "/ start PC
            exception_table at:((i-1) * 4) + 1 put: (inStream nextUnsignedShortMSB:msb).
            "/ end PC
            exception_table at:((i-1) * 4) + 2 put: (inStream nextUnsignedShortMSB:msb).
            "/ handler PC
            exception_table at:((i-1) * 4) + 3 put: (inStream nextUnsignedShortMSB:msb).
            "/ catch type
            exception_table at:((i-1) * 4) + 4 put: (inStream nextUnsignedShortMSB:msb).
        ].
        aJavaMethod setExceptionHandlerTable:exception_table.
    ].

    (max_stack + max_locals + 4) > MaxContextSizeLimit ifTrue:[
        code := nil
    ].

    aJavaMethod
        setCode:code
        maxStack:max_stack
        maxLocals:max_locals
        u1:unknown1
        u2:unknown2.

    self readAttributesFor:aJavaMethod.
    ^ true

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/Alignable.class'
    "

    "Created: / 15-04-1996 / 15:40:17 / cg"
    "Modified: / 16-05-1998 / 01:39:42 / cg"
    "Modified: / 06-05-2013 / 22:08:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readExceptionsAttributeFor:aJavaMethod
    |attribute_length exception_table_length exception_table|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    exception_table_length := inStream nextUnsignedShortMSB:msb.
    exception_table_length ~~ 0 ifTrue:[
        exception_table := Array new:exception_table_length.
        1 to:exception_table_length do:[:i |
            | idx |

            idx := inStream nextUnsignedShortMSB:msb.
            exception_table at:i put:idx.
        ].
    ].

    Verbose ifTrue:[Transcript showCR:'method has an exceptionTable'].

    aJavaMethod setExceptionTable:exception_table.
    ^ true

    "Created: / 15-04-1996 / 15:40:17 / cg"
    "Modified: / 04-12-2014 / 14:29:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readLineNumberTableAttributeFor:aJavaMethod
    |attribute_length line_number_table_length line_number_table|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    line_number_table_length := inStream nextUnsignedShortMSB:msb.
    line_number_table_length ~~ 0 ifTrue:[
        line_number_table := Array new:line_number_table_length.
        1 to:line_number_table_length do:[:i |
            |start_pc line_number|

            start_pc := inStream nextUnsignedShortMSB:msb.
            line_number := inStream nextUnsignedShortMSB:msb.
            line_number_table at:i put:(start_pc -> line_number).
        ].
        Verbose ifTrue:[Transcript showCR:'method has a lineNumberTable'].

        aJavaMethod setLineNumberTable:line_number_table.
    ].

    ^ true

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/java/lang/Boolean.class'
    "

    "Created: / 15.4.1996 / 15:40:17 / cg"
    "Modified: / 7.4.1998 / 19:08:42 / cg"
!

readLocalVariableTableAttributeFor:aJavaMethod
    |attribute_length local_variable_table_length local_variable_table|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    local_variable_table_length := inStream nextUnsignedShortMSB:msb.
    local_variable_table_length ~~ 0 ifTrue:[
	local_variable_table := JavaLocalVariableTable new:local_variable_table_length.
	1 to:local_variable_table_length do:[:i |
	    |start_pc length name_index sig_index slot name signature|

	    start_pc := inStream nextUnsignedShortMSB:msb.
	    length := inStream nextUnsignedShortMSB:msb.
	    name_index := inStream nextUnsignedShortMSB:msb.
	    name := self constantPoolAt:name_index.
	    sig_index := inStream nextUnsignedShortMSB:msb.
	    signature := self constantPoolAt:sig_index.
	    slot := inStream nextUnsignedShortMSB:msb.

	    local_variable_table at:i put:(JavaLocalVariableTableEntry new
						startPC:start_pc
						length:length
						name:name
						signature:signature
						slot:slot)
	].
    ].

    Verbose ifTrue:[Transcript showCR:'method has a localvariableTable'].

    aJavaMethod setLocalVariableTable:local_variable_table.
    ^ true

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/java/lang/Boolean.class'
    "

    "Modified: 15.4.1996 / 15:33:28 / cg"
    "Created: 15.4.1996 / 15:40:17 / cg"
!

readMethodFor:aJavaClass into: aMethodDictionary
    |m access_flags name_index name descriptor_index descriptor
     tooManyArgs|

    "/
    "/ get a method
    "/
    access_flags := inStream nextUnsignedShortMSB:msb.
    name_index := inStream nextUnsignedShortMSB:msb.
    descriptor_index := inStream nextUnsignedShortMSB:msb.

    name := self constantPoolAt:name_index.
    descriptor := self constantPoolAt:descriptor_index.

    Verbose ifTrue:[
        Transcript show:'method name:'; showCR:name.
        Transcript show:'descriptor:'; showCR:descriptor.
    ].

    aJavaClass isJavaClass ifTrue:[
        (access_flags bitAnd:ACC_NATIVE) ~~ 0 ifTrue:[
            m := JavaNativeMethod new.
        ] ifFalse:[
            m := JavaMethodWithHandler new.
        ].
        m setAccessFlags:access_flags.
        m setJavaClass:aJavaClass.
        tooManyArgs := false.
        [
            m setName:name descriptor:descriptor.
        ] on: ArgumentError do:[:ex |
            Logger log: 'java method has too many arguments - will fail to execute' severity: Logger severityWARN facility: 'JVM'.
            tooManyArgs := true.
            ex proceed.
        ].

        self readAttributesFor:m.

        tooManyArgs ifTrue:[
            m code:nil.
            m byteCode:nil.
        ].

        (m exceptionHandlerTable isNil) ifTrue:[
            m isNative ifFalse:[
                m getExceptionTable isNil ifTrue:[
                    m := JavaMethod fromMethod:m
                ] ifFalse:[
                    m := JavaMethodWithException fromMethod:m
                ]
            ]
        ] ifFalse:[
            | newAccessFlags |

            newAccessFlags := m accessFlags.
            newAccessFlags := newAccessFlags bitOr:ACX_HASHANDLER.
            m hasFinallyBasedOnExceptionTable ifTrue:[
                newAccessFlags := newAccessFlags bitOr:ACX_HASFINALLY.
            ].
            m setAccessFlags:newAccessFlags.
        ].
        aMethodDictionary at: (name , descriptor) asSymbol put: m.

        ( m selector == #'finalize()V' ) ifTrue:[
            ( aJavaClass binaryName ~~ #'java/lang/Object' ) ifTrue:[
                aJavaClass setAccessFlags: (aJavaClass accessFlags bitOr:ACX_HASFINALIZE)
            ]
        ].
    ] ifFalse:[
        "/ Reading method for non-Java class
        self error: 'Not really supported'.

        m := Method new.
        self readAttributesFor:m.
        (access_flags bitTest:ACC_STATIC) ifTrue:[
            self addSelector:name asSymbol withMethod:m toClass: aJavaClass class.
        ] ifFalse:[
            self addSelector:name asSymbol withMethod:m toClass: aJavaClass.
        ]
    ].

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
    "

    "Created: / 21-05-2014 / 15:58:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2015 / 14:09:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readMethodsFor:aJavaClass
    | methodsCount methodDict |

    "/
    "/ get methods
    "/
    methodsCount := inStream nextUnsignedShortMSB:msb.
    Verbose ifTrue:[Transcript show:'methodsCount = '; showCR:methodsCount].
    methodDict := MethodDictionary new: methodsCount.

    1 to:methodsCount do:[:i |
        Verbose ifTrue:[Transcript show:'method: '; showCR:i].
        self readMethodFor: aJavaClass into: methodDict.
    ].
    "/ Set method dictionary bit do noy yet flush caches. Caches are flushed
    "/ at the very last moment, when a class is actually initialized. This should
    "/ be sufficent as an object cannot be sent a message unless a class is
    "/ initialized first. This saves us a little bit of time when reading classes
    "/ but cost time when initializing the class, so normally this is not much
    "/ of a saving. However, this helps in cases Java class is only read into memory
    "/ and never initialized - that's what JBrowser Workspace does.
    "/ See JavaClass>>classInit.
    aJavaClass setMethodDictionary: methodDict.

    "
     JavaClassReader readFile:'/phys/ibm3/hotjava/classes/browser/AddButton.class'
    "

    "Created: / 15-04-1996 / 16:46:30 / cg"
    "Modified: / 08-05-1998 / 21:20:59 / cg"
    "Modified (comment): / 04-08-2014 / 17:04:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReader methodsFor:'file reading - methods-ST'!

readSTCodeAttributeFor:aSmalltalkMethod
    |attribute_length max_stack max_locals code_length code
     exception_table_length unknown1 unknown2|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    Verbose ifTrue:[Transcript show:'attribute_length: 0x'; showCR:(attribute_length printStringRadix:16)].

    max_stack := inStream nextUnsignedShortMSB:msb.
    max_locals := inStream nextUnsignedShortMSB:msb.

    code_length := inStream nextUnsignedLongMSB:msb.
    Verbose ifTrue:[Transcript show:'code_length: '; showCR:(code_length printStringRadix:16)].
    Verbose ifTrue:[Transcript show:'code at pos: '; showCR:inStream position].

    code_length ~~ 0 ifTrue:[
        code := ByteArray new:code_length.
        inStream nextBytes:code_length into:code startingAt:1.
    ].
    Verbose ifTrue:[Transcript show:'method code: '; showCR:code.].

    exception_table_length := inStream nextUnsignedShortMSB:msb.
    Verbose ifTrue:[Transcript show:'exception_table_length: '; showCR:(exception_table_length printStringRadix:16)].
    exception_table_length ~~ 0 ifTrue:[
        self error:'unexpected exceptionTable length'.
        "/ skip it.
        1 to:exception_table_length do:[:i |
            "start_pc :="   inStream nextUnsignedShortMSB:msb.
            "end_pc :="     inStream nextUnsignedShortMSB:msb.
            "handler_pc :=" inStream nextUnsignedShortMSB:msb.
            "catch_type :=" inStream nextUnsignedShortMSB:msb.
        ].
    ].

    aSmalltalkMethod byteCode:code.
    aSmalltalkMethod stackSize:max_stack .
    aSmalltalkMethod numberOfVars:max_locals.

    self readAttributesFor:aSmalltalkMethod.
    ^ true

    "Modified: / 16.5.1998 / 01:39:30 / cg"
!

readSTLiteralsAttributeFor:aSmalltalkMethod
    |attribute_length literal_table_length literal_table litIndex literal|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    literal_table_length := inStream nextUnsignedShortMSB:msb.
    literal_table_length ~~ 0 ifTrue:[
        literal_table := Array new:literal_table_length.
        1 to:literal_table_length do:[:i |
            litIndex := inStream nextUnsignedShortMSB:msb.
            literal := (self constantPoolAt:litIndex).
            literal_table at:i put:literal.
        ].
    ].
    Verbose ifTrue:[Transcript show:'literals: '; showCR:literal_table storeString.].

    "Created: / 7.5.1998 / 11:52:28 / cg"
    "Modified: / 16.5.1998 / 01:52:27 / cg"
!

readSTMethodCategoryAttributeFor:aSmalltalkMethod
    |attribute_length name_index name|

    attribute_length := inStream nextUnsignedLongMSB:msb.

    name_index := inStream nextUnsignedShortMSB:msb.
    name := (self constantPoolAt:name_index).

    aSmalltalkMethod category:name.

    "Modified: / 8.5.1998 / 20:39:59 / cg"
    "Created: / 16.5.1998 / 01:04:19 / cg"
! !

!JavaClassReader methodsFor:'helpers'!

addSelector: selector withMethod: method toClass: javaClass
    "Basically a primAddSelector:withMethod:. This indirection
     is required by Expecco (it uses custom class reader so
     which overrides this method"

    javaClass primAddSelector:selector withMethod: method

    "Created: / 26-02-2013 / 11:42:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadSuperclassIdentifiedBy: aJavaClassRef ignoring: classesBeingLoaded
    "overriding method, here we expect something to be new JavaClassRef2"

    self assert: aJavaClassRef isJavaRef
        message: 'class identifier is not a java reference'.
    self assert: aJavaClassRef isJavaClassRef
        message: 'class identifier is not a java class reference'.
    (classesBeingLoaded includes: aJavaClassRef name) ifTrue: [
        self
            error: 'class we want to load is being loaded and that means something went wrong. tell mh'
    ].
     "hint in case of bug - is parent of something set? surely jv will know more :)" "find out which classloader is used"
    ^ JavaVM classForName: aJavaClassRef name definedBy: classLoader.

    "Created: / 18-05-2011 / 14:55:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-10-2013 / 22:57:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateOwnerInCPItem: each
    ((each isJavaRef and: [ each isNewJavaRef ])
        or: [ each isJavaNameAndType and: [ each isNewJavaNameAndType ] ])
            ifTrue: [ each owner: classBeingLoaded ].

    "Created: / 12-05-2011 / 17:40:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

updateOwnerInField: each

            each setClass: classBeingLoaded.

    "Created: / 18-05-2011 / 13:57:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassReader methodsFor:'logging'!

info: message
    Verbose ifTrue: [ Logger log: message severity: Logger severityINFO facility: 'JVM' ].

    "Created: / 18-05-2011 / 15:06:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 14:10:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassReader.st,v 1.101 2015-03-20 12:07:59 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassReader.st,v 1.101 2015-03-20 12:07:59 vrany Exp $'
!

version_SVN
    ^ 'Id'
! !


JavaClassReader initialize!
