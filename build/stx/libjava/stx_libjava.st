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

LibraryDefinition subclass:#stx_libjava
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libjava class methodsFor:'documentation'!

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

!stx_libjava class methodsFor:'accessing'!

svnRepositoryUrl

    ^'https://jv@swing.fit.cvut.cz/svn/stx/libjava/branches/jk_new_structure/src'

!

svnRepositoryUrlBase

    | url |
    url := stx_libjava svnRepositoryUrl.
    url ifNil:[url := 'https://swing.fit.cvut.cz/svn/stx/libjava/trunk/src'].
    (url endsWith: 'src') ifTrue:[url := url copyTo: url size - 4].
    ^url

    "Created: / 08-04-2011 / 16:57:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava class methodsFor:'accessing - tests'!

excludedFromTestSuite
    "List of testcases and/or tests excluded from testsuite.
     Entries maybe ClassName or #(ClassName testName)
    "
    ^ #(
        LookupTests
    )

    "Created: / 03-06-2011 / 17:04:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSuite

    | suite  |
    suite := super testSuite.
    Smalltalk loadPackage: #'stx:libjava/tests'.
    suite addTests: (Smalltalk at: #'stx_libjava_tests') testSuite tests.
    ^ suite

    "
    stx_libjava testSuite
    "

    "Created: / 07-05-2011 / 19:58:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2011 / 17:23:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 21-01-2015 / 12:55:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSuiteWithoutJavaTests

    ^super testSuite.

    "Created: / 21-06-2011 / 17:33:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'stx:libjava/experiments'
        #'stx:libjava/tools'
        #'stx:goodies/sunit'    "TestAsserter - superclass of GroovyEvaluatorTests"
    )

    "Modified: / 31-07-2014 / 09:15:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:libbasic'    "AbstractLock - superclass of JavaMonitor"
        #'stx:libbasic2'    "Socket - extended"
        #'stx:libbasic3'    "SystemEnvironment - superclass of JavaClassEnvironment"
        #'stx:libview'    "DisplaySurface - superclass of JavaEmbeddedFrameView"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
        #'stx:libcomp'    "AssignmentNode - referenced by ProxyMethodJavaFieldSetter>>generate:"
        #'stx:libhtml'    "URL - referenced by JavaEmbeddedFrameView>>setupAppletFrameIn:initializeJava:"
        #'stx:libtool'    "DebugView - referenced by Java class>>flushClasses"
        #'stx:libview2'    "GIFReader - referenced by JavaNativeMethodImpl_OpenJDK6 class>>_GifImageDecoder_parseImage:"
        #'stx:libwidg'    "Button - referenced by JavaNativeMethodImpl_OpenJDK6 class>>_WButtonPeer_create:"
        #'stx:libwidg2'    "CheckBox - referenced by JavaNativeMethodImpl_OpenJDK6 class>>_WCheckboxPeer_create:"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
        #'stx:libjava/experiments'
        #'stx:libjava/tools'
    )
! !

!stx_libjava class methodsFor:'description - compilation'!

additionalDefinitions_bc_dot_mak
    ^ '
!!if defined(USEMINGW32) || defined(USEMINGW64)
!! if defined(USEMINGW32)
LIBFDM_TARGET = i686-pc-mingw32
!! else
LIBFDM_TARGET = x86_64-w64-mingw32
!! endif
LIBFDM=support\fdlibm\$(LIBFDM_TARGET)\libfdm.a
!!else
LIBFDM=$(LIBFDM_DIR)\fdlibm\libfdm.a
!!endif


'

    "Created: / 22-08-2006 / 23:58:05 / cg"
    "Modified: / 19-07-2017 / 00:44:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalDefinitions_make_dot_proto
    ^ '
ifdef BUILD_TARGET
LIBFDM_TARGET=$(BUILD_TARGET)
else
ifeq ($(CONF),config-linux-x86_64)
LIBFDM_TARGET=x86_64-pc-linux-gnu
else ifeq ($(CONF),config-linux-i386)
LIBFDM_TARGET=i686-pc-linux-gnu
endif
endif
LIBFDM=support/fdlibm/$(LIBFDM_TARGET)/libfdm.a


'

    "Created: / 19-07-2017 / 08:13:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalLinkLibraries_bc_dot_mak

    ^ '$(ZLIB_DIR)\$(ZLIB) $(LIBFDM)'

    "Modified: / 19-07-2017 / 00:44:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalLinkLibraries_make_dot_proto

    ^ '$(ZLIB_LD_ARG) $(LIBFDM)'

    "Modified: / 19-07-2017 / 08:13:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_bc_dot_mak
    ^ '
doc:
        pushd docs\user & $(MAKE_BAT) html

doc-install:
        pushd docs\user & $(MAKE_BAT) html-install


clean::
        pushd docs\user & $(MAKE_BAT) clean


$(ZLIB):
        cd $(ZLIB_DIR)
        $(MAKE) $(MAKE_ZLIB_ARG) $(ZLIB)
        cd ..\..\libjava

$(BZ2LIB):
        cd $(BZ2LIB_DIR)
        $(MAKE) $(MAKE_BZ2LIB_ARG) bz2.lib
        cd ..\..\libjava

!!ifdef USEMINGW64
$(LIBFDM):
    set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & make -C support\fdlibm OUTDIR=$(LIBFDM_TARGET)
!!else
!! ifdef USEMINGW32
$(LIBFDM):
    set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & make -C support\fdlibm OUTDIR=$(LIBFDM_TARGET)
!! else
$(LIBFDM):
    set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & make -C support\fdlibm
!! endif
!!endif
'

    "Modified: / 19-07-2017 / 00:49:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_make_dot_proto
    ^ '
doc:
        $(MAKE) -C docs/user html

doc-install:
        $(MAKE) -C docs/user html-install

clean::
        $(MAKE) -C docs/user clean


zlib:
        cd $(ZLIB_DIR); $(MAKE) $(MAKE_ZLIB_ARG)

$(LIBFDM):
        $(MAKE) CCCONFOPT="$(CCCONFOPT) -fPIC" OUTDIR=$(LIBFDM_TARGET) -C support/fdlibm

clean::
        $(MAKE) OUTDIR=$(LIBFDM_TARGET) -C support/fdlibm clean
'

    "Modified: / 19-07-2017 / 08:14:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_bc_dot_mak

    ^ '$(ZLIB) $(LIBFDM)'

    "Modified: / 19-07-2017 / 00:50:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_make_dot_proto

    ^ ' zlib $(LIBFDM)'

    "Created: / 05-09-2006 / 16:05:12 / cg"
    "Modified: / 19-07-2017 / 08:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

localIncludes
    ^ '-I$(ZLIB_DIR) -Isupport/fdlibm'

    "Created: / 06-09-2006 / 18:18:15 / cg"
    "Modified: / 07-09-2011 / 17:03:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stcOptimizationOptions
    ^ '+optinline +optinline2'

    "Created: / 23-08-2006 / 11:06:17 / cg"
! !

!stx_libjava class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        GroovyCompiler
        GroovyEvaluator
        GroovyLanguage
        GroovySourceFileWriter
        JavaAnnotation
        JavaAnnotationContainer
        JavaAnnotationDefault
        JavaAnnotationDictionary
        JavaAnnotationValue
        JavaArray
        JavaBooleanArray
        JavaByte
        JavaByteCodeProcessor
        JavaClassAccessor
        JavaClassEnvironment
        JavaClassQuery
        JavaClassReloader
        JavaCodeLibraryOrBundle
        JavaCompilerForSmalltalkExtensionsOnly
        #'JavaCompiler_Eclipse'
        JavaConstantPool
        JavaConstants
        JavaContext
        JavaDecompiler
        JavaDescriptor
        JavaError
        JavaExceptionTable
        JavaField
        JavaFinalizationRegistry
        JavaInnerClasses
        JavaLanguage
        JavaLibraries
        JavaLocalVariableTable
        JavaLocalVariableTableEntry
        JavaLookup
        JavaMetaclass
        JavaMonitor
        JavaNameAndType2
        JavaNativeMemory
        JavaNioSupport
        JavaObject
        JavaObjectDictionary
        JavaPopUpView
        JavaProcess
        JavaRef2
        JavaRelease
        JavaResolver
        JavaShort
        JavaSocket
        JavaSourceCodeCache
        JavaSourceFileWriter
        JavaTestsLoader
        JavaTopView
        JavaUnresolvedCompilationError
        JavaUnresolvedConstant
        JavaUtilities
        JavaVMData
        JavaView
        JavaZipDeflater
        JavaZipFile
        JavaZipInflater
        ProxyMethod
        ProxyMethodCompiler
        ProxyMethodNode
        SmalltalkAppletContext
        SmalltalkAppletStub
        #'stx_libjava'
        GroovyMetaclass
        Java
        JavaAnnotationArrayValue
        JavaAnnotationClassValue
        JavaAnnotationEnumValue
        JavaAnnotationNestedAnnotationValue
        JavaAnnotationPrimitiveValue
        JavaBehavior
        JavaByteCodeDisassembler
        JavaByteCodeProcessorAdapter
        JavaClassAnnotationContainer
        JavaClassFormatError
        JavaClassMemberRef2
        JavaClassReader
        JavaClassRef2
        JavaClassRegistry
        JavaCodeBundle
        JavaCodeLibrary
        JavaEmbeddedFrameView
        JavaFieldAnnotationContainer
        JavaFieldDescriptor
        JavaFieldDescriptorWithUnionType
        JavaInvokeDynamic2
        JavaMethod
        JavaMethodAnnotationContainer
        JavaMethodDescriptor
        JavaMethodHandle2
        JavaMethodType2
        JavaMirror
        #'JavaNativeMethodImpl_OpenJDK6'
        JavaStringRef2
        JavaUnhandledExceptionError
        JavaUnhandledThreadDeathError
        JavaUnresolvedClassConstant
        JavaUnresolvedStringConstant
        JavaVM
        ProxyMethodConditionNode
        ProxyMethodGuardNode
        ProxyMethodInvocationNode
        ProxyMethodJavaFieldAccessor
        JavaAlienMirror
        JavaArrayMirror
        JavaByteCodePreresolver
        JavaClass
        JavaClassMirror
        JavaClassPathBundle
        JavaFieldRef2
        JavaMethodAnalyzer
        JavaMethodRef2
        JavaMethodWithException
        #'JavaNativeMethodImpl_AppleJDK6'
        #'JavaNativeMethodImpl_OpenJDK7'
        #'JavaNativeMethodImpl_SunJDK6'
        JavaPrimitiveMirror
        ProxyMethodAndNode
        ProxyMethodBlockInvocationNode
        ProxyMethodJavaFieldGetter
        ProxyMethodJavaFieldSetter
        ProxyMethodMethodInvocationNode
        ProxyMethodTypeCheckNode
        GroovyClass
        JavaInterfaceMethodRef2
        JavaMethodWithHandler
        #'JavaNativeMethodImpl_OpenJDK8'
        #'JavaNativeMethodImpl_OracleJDK7'
        ProxyMethodJavaMethodInvocationNode
        ProxyMethodJavaTypeCheckNode
        JavaNativeMethod
        #'JavaNativeMethodImpl_OracleJDK8'
        (GroovyEvaluatorTests autoload)
        (JavaAntProjectResource autoload)
        (JavaByteCodeProcessorTests autoload)
        (JavaClassLoadingTests autoload)
        (JavaClassReloaderTests autoload)
        (JavaExceptionTests autoload)
        (JavaFreshlyInitializedResource autoload)
        (JavaInitializedResource autoload)
        (JavaJUnitTests autoload)
        (JavaLibrariesResource autoload)
        (JavaLookupResolutionAlgorithmTests autoload)
        (JavaLookupTests autoload)
        (JavaMonitorsTests autoload)
        (JavaNativeMemoryTests autoload)
        (JavaRefsAndConstantPoolTestCase autoload)
        (JavaReleaseTests autoload)
        (JavaTestCaseProxy autoload)
        (JavaThreadingTests autoload)
        (JavaUTF8Tests autoload)
        (JUnitTestCaseProxy autoload)
        (JavaByteCodeDisassemblerTests autoload)
        (JavaClassReaderTests autoload)
        (JavaClassRefTests autoload)
        (JavaFieldRefTests autoload)
        (JavaInterfaceMethodRefTests autoload)
        (JavaMethodRefTests autoload)
        (JavaRefMock autoload)
        (JavaRuntimeConstantPoolTests autoload)
        (JavaTestsResource autoload)
        (TestletTestCaseProxy autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        Behavior isInterface
        CharacterArray asDottedJavaClassName
        CharacterArray asJavaComponentClassName
        CharacterArray asNiceJavaClassName
        CharacterArray asSTXInternalJavaClassName
        CharacterArray asSlashedJavaClassName
        CharacterArray isJavaArrayDescriptor
        CharacterArray isJavaPrimitiveTypeDescriptor
        Delay waitWithState:
        Object isGroovyClass
        Object isJavaArray
        Object isJavaNameAndType
        Object isJavaPackage
        Object isJavaRef
        Object isJavaWrapperClass
        Object javaBox:
        Object javaUnwrap:
        Object javaUnwrapFrom:
        Object javaWrap:
        Process clearInterrupted
        Process isInterrupted
        Process isSleeping
        Process isWaiting
        Process javaInterrupt
        Process setInterrupted
        Set #'java__contains:'
        SmallInteger javaUnwrapFrom:
        String asArrayOfSubstringsSeparatedBy:
        WrappedMethod descriptor
        WrappedMethod isAbstract
        ZipArchive nextBytes:of:startingAt:into:startingAt:
        'Boolean class' isJavaPrimitiveType
        'Boolean class' javaArrayClass
        'Boolean class' javaBox:
        'Boolean class' javaName
        'Boolean class' javaUnbox:onError:
        'Boolean class' javaUnwrap:
        'Boolean class' javaWrapperClass
        'ByteArray class' isInterface
        'ByteArray class' isJavaArrayClass
        'ByteArray class' isJavaReferenceType
        'ByteArray class' javaArrayClass
        'ByteArray class' javaComponentClass
        'ByteArray class' javaName
        'Character class' isJavaPrimitiveType
        'Character class' javaArrayClass
        'Character class' javaBox:
        'Character class' javaName
        'Character class' javaUnbox:onError:
        'Character class' javaWrapperClass
        'CharacterArray class' decodeFromJavaUTF8:
        'CharacterArray class' fromJavaUTF8Bytes:
        'CharacterArray class' isJavaArrayClass
        'CharacterArray class' javaArrayClass
        'CharacterArray class' javaComponentClass
        'ConfigurableFeatures class' hasJavaSupport
        'DoubleArray class' isInterface
        'DoubleArray class' isJavaArrayClass
        'DoubleArray class' isJavaReferenceType
        'DoubleArray class' javaArrayClass
        'DoubleArray class' javaComponentClass
        'DoubleArray class' javaName
        'Float class' isJavaPrimitiveType
        'Float class' javaArrayClass
        'Float class' javaBox:
        'Float class' javaName
        'Float class' javaWrapperClass
        'FloatArray class' isInterface
        'FloatArray class' isJavaArrayClass
        'FloatArray class' isJavaReferenceType
        'FloatArray class' javaArrayClass
        'FloatArray class' javaComponentClass
        'FloatArray class' javaName
        'Integer class' isJavaPrimitiveType
        'Integer class' javaArrayClass
        'Integer class' javaBox:
        'Integer class' javaName
        'Integer class' javaUnbox:onError:
        'Integer class' javaUnbox:onError:min:max:
        'Integer class' javaWrapperClass
        'LargeInteger class' isJavaPrimitiveType
        'LargeInteger class' javaArrayClass
        'LargeInteger class' javaBox:
        'LargeInteger class' javaName
        'LargeInteger class' javaUnbox:onError:
        'LargeInteger class' javaWrapperClass
        'Object class' isJavaArrayClass
        'Object class' isJavaClassType
        Behavior isJavaPrimitiveType
        'Object class' isJavaReferenceType
        'Object class' isJavaType
        'ProjectDefinition class' javaClassPath
        'ProjectDefinition class' javaSourcePath
        'ShortFloat class' isJavaPrimitiveType
        'ShortFloat class' javaArrayClass
        'ShortFloat class' javaBox:
        'ShortFloat class' javaName
        'ShortFloat class' javaWrapperClass
        'SignedIntegerArray class' isInterface
        'SignedIntegerArray class' isJavaArrayClass
        'SignedIntegerArray class' javaArrayClass
        'SignedIntegerArray class' javaComponentClass
        'SignedIntegerArray class' javaName
        'SignedLongIntegerArray class' isInterface
        'SignedLongIntegerArray class' isJavaArrayClass
        'SignedLongIntegerArray class' isJavaReferenceType
        'SignedLongIntegerArray class' javaArrayClass
        'SignedLongIntegerArray class' javaComponentClass
        'SignedLongIntegerArray class' javaName
        'SignedWordArray class' isJavaArrayClass
        'SignedWordArray class' isJavaReferenceType
        'SignedWordArray class' javaComponentClass
        'SignedWordArray class' javaName
        'UndefinedObject class' isJavaPrimitiveType
        'UndefinedObject class' javaName
        'WordArray class' isInterface
        'WordArray class' isJavaArrayClass
        'WordArray class' isJavaReferenceType
        'WordArray class' javaArrayClass
        'WordArray class' javaComponentClass
        'WordArray class' javaName
        'Boolean class' javaWrap:
        ProgrammingLanguage isGroovy
        ProgrammingLanguage isJavaLike
        Class javaMirror
        Class javaMirrorClass
        ExecutableFunction isJavaConstructor
        Process isParked
        Semaphore parkWithTimeoutMs:
        Object isSocket
        Socket isSocket
        Socket reOpenIfPossible
        Method isStatic
        Class classLoader
        Method isAbstract
        Method javaClass
        Object getJavaLockWord
        Object getJavaMonitor
        Object javaWrapRequired
        'Boolean class' javaWrapRequired
        CharacterArray withoutSuffix:
        ExecutableFunction isProxyMethod
        'ProjectDefinition class' javaBundle
        'String class' javaName
        'Unicode16String class' javaName
        'Float class' javaUnbox:onError:
        'ShortFloat class' javaUnbox:onError:
        Class binaryName
        Class isSynthetic
        ByteArray #'_ARRAYLENGTH:'
        ByteArray #'_CHECKCAST:'
        ByteArray #'_INSTANCEOF:'
        CharacterArray #'_ARRAYLENGTH:'
        CharacterArray #'_CHECKCAST:'
        CharacterArray #'_INSTANCEOF:'
        DoubleArray #'_ARRAYLENGTH:'
        DoubleArray #'_CHECKCAST:'
        DoubleArray #'_INSTANCEOF:'
        FloatArray #'_ARRAYLENGTH:'
        FloatArray #'_CHECKCAST:'
        FloatArray #'_INSTANCEOF:'
        Object #'_ARRAYLENGTH:'
        Object #'_CHECKCAST:'
        Object #'_INSTANCEOF:'
        SignedIntegerArray #'_ARRAYLENGTH:'
        SignedIntegerArray #'_CHECKCAST:'
        SignedIntegerArray #'_INSTANCEOF:'
        SignedLongIntegerArray #'_ARRAYLENGTH:'
        SignedLongIntegerArray #'_CHECKCAST:'
        SignedLongIntegerArray #'_INSTANCEOF:'
        SignedWordArray #'_ARRAYLENGTH:'
        SignedWordArray #'_CHECKCAST:'
        SignedWordArray #'_INSTANCEOF:'
        UndefinedObject #'_ARRAYLENGTH:'
        UndefinedObject #'_CHECKCAST:'
        UndefinedObject #'_INSTANCEOF:'
        ZipArchive isValidFile:
        'ProjectDefinition class' generateJavaBuildPrereqs
        'ProjectDefinition class' generateJavaBuildPrereqsClasspathPaths
        'ProjectDefinition class' generateJavaBuildPrereqsClasspathRefs
        'ProjectDefinition class' generateJavaBuildPrereqsUsingTemplate:
        'ProjectDefinition class' #'generate_java_build_auto_dot_xml'
        'ProjectDefinition class' #'generate_java_build_dot_xml'
        'ProjectDefinition class' #'java_build_auto_dot_xml'
        'ProjectDefinition class' #'java_build_auto_dot_xml_mappings'
        'ProjectDefinition class' #'java_build_dot_xml'
        'ProjectDefinition class' #'java_build_dot_xml_mappings'
        'ProjectDefinition class' #'additionalRules_java_clean_in_bc_dot_mak'
        'ProjectDefinition class' #'additionalRules_java_clean_in_make_dot_proto'
        'ProjectDefinition class' #'additionalRules_java_compile_in_bc_dot_mak'
        'ProjectDefinition class' #'additionalRules_java_compile_in_make_dot_proto'
        'ProjectDefinition class' #'javaBundle_code'
        'ProjectDefinition class' postLoadJavaHook
        UserPreferences javaHome
        UserPreferences javaHome:
        'Character class' javaUnwrap:
        'Character class' javaWrap:
    )
! !

!stx_libjava class methodsFor:'description - java'!

javaBundle

    ^ JavaCodeBundle standardPackageBundleFor: self package
! !

!stx_libjava class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG & SWING Research Group'

    "Modified: / 15-11-2012 / 23:51:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Description string which will appear in vc.def / bc.def"

    ^ 'Java support for Smalltalk/X'

    "Modified: / 15-11-2012 / 23:51:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2011\nCopyright eXept Software AG 2011\nCopyright Jan Vrany, Jan Kurs and Marcel Hlopko\n          SWING Research Group, Czech Technical University In Prague'

    "Modified: / 15-11-2012 / 23:51:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productName
    "Return product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libjava class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
     Do not make the string shorter!!!!!! We have to use fixed-length keyword!!!!!!
    "

    ^ '$URL::                                                                                                                        $'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'2242            '"$"
! !

!stx_libjava class methodsFor:'file generation'!

basicFileNamesToGenerat
    "answer a dictionary (filename -> generator method) with all the files, that have to be generated for this
     package"

    |dict|

    dict := super basicFileNamesToGenerate.

    dict
        at:'builder/package.deps.rake' put: #'generate_package_dot_deps_dot_rake'.

    ^ dict.

    "Created: / 11-03-2011 / 09:32:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!stx_libjava class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

