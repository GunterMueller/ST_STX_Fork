"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
 COPYRIGHT (c) 2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

Object subclass:#STCCompilerInterface
	instanceVariableNames:'originator parserFlags initName theNonMetaclassToCompileFor
		classToCompileFor stFileName cFileName oFileName stcFlags cFlags
		stcPath ccPath requestor methodCategory executionStatus package'
	classVariableNames:'SequenceNumber Verbose KeepIntermediateFiles
		BuiltinCIncludeDirectories'
	poolDictionaries:''
	category:'System-Compiler'
!

!STCCompilerInterface class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
 COPYRIGHT (c) 2018 Jan Vrany
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
    a refactored complex method - originally found in ByteCodeCompiler.
"
! !

!STCCompilerInterface class methodsFor:'accessing'!

builtinCFlags
    "Return C compiler flags that are always passed to the C compiler
     when a (ST)C file is compiled."

    ^ self getCPUDefine , ' ', self getOSDefine , ' ' , self getBuildTargetDefine

    "Created: / 04-12-2015 / 16:41:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2018 / 22:23:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

builtinCIncludeDirectories
    "Return C compiler include directories that are always passed to the C compiler
     when a (ST)C file is compiled."

    BuiltinCIncludeDirectories isNil ifTrue:[ 
        | executablePath |
        (executablePath := OperatingSystem pathOfSTXExecutable) notNil ifTrue:[
            executablePath := executablePath asFilename directory.
            ((executablePath / 'include' / 'stc.h') exists
              or:[((executablePath := executablePath directory) / 'include' / 'stc.h') exists
              or:[((executablePath := executablePath directory) / 'include' / 'stc.h') exists]])
                ifTrue:[
                    BuiltinCIncludeDirectories := '-I' , (executablePath / 'include') pathName.
                    ^ BuiltinCIncludeDirectories
                ]
        ].
        ^ ''
    ].
    ^ BuiltinCIncludeDirectories

    "
    STCCompilerInterface builtinCIncludeDirectories
    "

    "Created: / 09-12-2015 / 16:54:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

builtinCIncludeDirectories: aString
    "Set C compiler include directories that are always passed to the C compiler
     when a (ST)C file is compiled. 
     This is an entry for init scripts for custom Smalltalk/X distributions which use
     different directory layout than just a plain St/X worktree (such as Smalltalk/X jv-branch).

     Note, that this is a string, so it must include '-I'
     "

     BuiltinCIncludeDirectories := aString

    "Created: / 09-12-2015 / 16:59:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getBuildTargetDefine
    ^ '-DBUILD_TARGET=\"', Smalltalk configuration , '\"'

    "Created: / 17-01-2018 / 22:24:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getCCDefine
    "return a string which was used to identify the C-Compiler used
     when STX was compiled, and which should be passed down when compiling methods.
     For example, when compiled with GNUC, this is '__GNUC__';
     on windows, this is either '__VISUAL__', '__BORLANDC__' or '__MINGW64__'"

%{  /* NOCONTEXT */
#ifndef CC_DEFINE
# ifdef __win32__
#  if defined( __BORLANDC__ )
#   define CC_DEFINE    "__BORLANDC__"
#  else
#   if defined( __VISUALC__ )
#    define CC_DEFINE     "__VISUALC__"
#   else
#    if defined( __MINGW64__ )
#     define CC_DEFINE     "__MINGW64__"
#    else
#     if defined( __MINGW32__ )
#      define CC_DEFINE     "__MINGW32__"
#     else
#      define CC_DEFINE     "__CC__"
#     endif
#    endif
#   endif
#  endif
# else /* not __win32__ */
#  if defined(__CLANG__) || defined( __clang__ )
#   define CC_DEFINE     "__CLANG__"
#  else
#   ifdef __GNUC__
#    define CC_DEFINE     "__GNUC__"
#   else
#    define CC_DEFINE     "__CC__"
#   endif
#  endif
# endif
#endif
    RETURN ( __MKSTRING(CC_DEFINE));
%}
    "
     STCCompilerInterface getCCDefine
    "
!

getCPUDefine
    "return a string which was used to identify this CPU type when STX was
     compiled, and which should be passed down when compiling methods.
     For example, on a 386 (and successors), this may be '-D__x86__'; 
     on a vax, this would be '-D__vax__'.
          This is normally not of interest to 'normal' users; however, it is passed
     down to the c-compiler when methods are incrementally compiled to machine code.
     Do not use this for CPU determination; only to pass on to stc for compilation.
     (see OperatingSystem getCPUType for this)"

%{  /* NOCONTEXT */
#   ifndef CPU_DEFINE
#       define CPU_DEFINE "-DunknownCPU"
#   endif

    RETURN ( __MKSTRING(CPU_DEFINE));
%}
    "
     STCCompilerInterface getCPUDefine
    "
!

getOSDefine
    "return a string which was used to identify this machine when stx was
     compiled, and which should be passed down when compiling methods.
     For example, on linux, this is '-D__linux__'; on osx, it is '-D__osx__'.
     Do not use this for OS determination; only to pass on to stc for compilation.
     (see OperatingSystem getOSType for this)"

%{  /* NOCONTEXT */

#ifndef OS_DEFINE
# ifdef __win32__
#  define OS_DEFINE "-D__win32__"
# endif

# ifndef OS_DEFINE
#  define OS_DEFINE "-DunknownOS"
# endif
#endif

    RETURN ( __MKSTRING(OS_DEFINE));

#undef OS_DEFINE
%}
    "
     STCCompilerInterface getOSDefine
    "
!

stcPathOf:command 
    "return the path to an stc command, or nil if not found."

    |f d reqdSuffix cmd|

    "/
    "/ care for executable suffix
    "/
    cmd := command.
    OperatingSystem isMSDOSlike ifTrue:[
        reqdSuffix := 'exe'
    ] ifFalse:[
        OperatingSystem isVMSlike ifTrue:[
            reqdSuffix := 'EXE'
        ].
    ].
    reqdSuffix notNil ifTrue:[
        (f := cmd asFilename) suffix isEmpty ifTrue:[
            cmd := (f withSuffix:reqdSuffix) name
        ]
    ].
    "/
    "/ for our convenience, also check in current
    "/ and parent directories; even if PATH does not
    "/ include them ...
    "/
    #('.' '../stc' '../../stc') do:[:relPath |
        d := Filename currentDirectory construct:relPath.
        (f := d construct:cmd) isExecutable ifTrue:[
            ^ f pathName
        ].
    ].

    "/
    "/ ok, stc must be installed in some directory along the PATH
    "/
    ^ OperatingSystem pathOfCommand:command

    "
     STCCompilerInterface stcPathOf:'stc'     
    "

    "Created: 13.9.1995 / 14:37:16 / claus"
!

verbose
    "if on, trace command execution on the Transcript"

    ^ Verbose
!

verbose:aBoolean 
    "if on, trace command execution on the Transcript"

    Verbose := aBoolean

    "
    STCCompilerInterface verbose: true.
    STCCompilerInterface verbose: false.
    "

    "Modified (comment): / 04-12-2015 / 16:44:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!STCCompilerInterface class methodsFor:'class initialization'!

initialize
    Verbose := false.
! !

!STCCompilerInterface methodsFor:'accessing'!

cFileName:something
    cFileName := something.
!

incrementalStcPath 
    "return the path to the stc command for incremental method compilation, 
     or nil if not found."

    |f cmd|

    (cmd := parserFlags stcPath) isEmptyOrNil ifTrue:[
        (f := self class stcPathOf:'stc') notNil ifTrue:[
            cmd := f
        ] ifFalse:[
            cmd := self class stcPathOf:'demostc'
        ]
    ].
    (cmd notNil and:[cmd includes:Character space]) ifTrue:[
        cmd := '"' , cmd , '"'.
    ].
    ^ cmd

    "Created: 13.9.1995 / 14:36:36 / claus"
    "Modified: 13.9.1995 / 15:15:04 / claus"
!

originator:something
    originator := something.
!

parserFlags:something
    parserFlags := something.
!

stFileName:something
    stFileName := something.
! !

!STCCompilerInterface methodsFor:'error raising'!

parseError:messageText position:position
    originator parseError:messageText position:position.
    "not normally reached"
    ParseError raiseErrorString:messageText.
! !

!STCCompilerInterface methodsFor:'machine code generation'!

compileToMachineCode:aString forClass:aClass selector:selector inCategory:categoryArg 
                             notifying:requestorArg install:install skipIfSame:skipIfSame silent:silent
    "this is called to compile primitive code.
     It saves the code to a tmporary, calls stc to create C-code, compiles it, links
     it to a tiny little dll and loads it.
     As you already see, this takes some time and is therefore ONLY done for code containing prims;
     all pure smalltalk code is compiled to bytecode and jitted by the VM."

    |handle oldMethod newMethod ok dllFileName|

    install ifFalse:[
        "/ cannot do it uninstalled. reason:
        "/ if it is loaded twice, the first version could be unloaded by
        "/ finalization, which would also unload the second version
        "/ (because the first unload would unload the second version too)
        ^ #CannotLoad
    ].
    parserFlags isNil ifTrue:[
        parserFlags := ParserFlags new
    ].
    parserFlags stcCompilation == #never ifTrue:[^ #CannotLoad].

    classToCompileFor := aClass.
    requestor := requestorArg.
    methodCategory := categoryArg.

    self ensureExternalToolsArePresent.
    self ensureModuleDirectoryExists.

    theNonMetaclassToCompileFor := classToCompileFor theNonMetaclass.

    self ensureSuperClassesAreLoadedOf:theNonMetaclassToCompileFor.
    theNonMetaclassToCompileFor privateClassesSorted do:[:aPrivateClass |
        self ensureSuperClassesAreLoadedOf:aPrivateClass.
    ].

    (classToCompileFor isNil 
    or:[parserFlags allowExtensionsToPrivateClasses 
    or:[classToCompileFor owningClass isNil]]) ifTrue:[
        (requestor respondsTo:#packageToInstall) ifFalse:[
            package := Class packageQuerySignal query.
        ] ifTrue:[
            package := requestor packageToInstall
        ].
    ] ifFalse:[
        package := classToCompileFor owningClass package
    ].

    [
        self generateSTSource:aString.
        self setupCompilationCommandArguments.
        ok := self 
                compileToC_onError:[:errorFile |
                    self reportCompilationErrorFor:stcPath fromFile:errorFile
                ].

        parserFlags stcKeepSIntermediate ifTrue:[ 
            self compileToS_onError:[:errorFile | ]
        ].
        "/ now compile to machine code
        ok := self 
                compileToObj_onError:[:errorFile |
                    self reportCompilationErrorFor:ccPath fromFile:errorFile.
                ].

        originator activityNotification:''.

        "
         if required, make a shared or otherwise loadable object file for it
        "
        originator activityNotification:'linking'.
        dllFileName := ObjectFileLoader createLoadableObjectFor:(oFileName asFilename withoutSuffix name).
        dllFileName isNil ifTrue:[
            "/ something went wrong
            self parseError:('link error: ' , ObjectFileLoader lastError) position:1.
        ].
        dllFileName asFilename exists ifFalse:[
            self parseError:'link failed - cannot create machine code' position:1.
        ].

        oldMethod := classToCompileFor compiledMethodAt:selector.
        oldMethod notNil ifTrue:[package := oldMethod package].
        install ifTrue:[
            (Smalltalk
                    changeRequest:#methodInClass
                    with:(Array with:classToCompileFor with:selector with:oldMethod)) ifFalse:[
                ^ #CannotLoad
            ].
        ].

        "
         load the method objectfile
        "
        originator activityNotification:'loading'.
        handle := ObjectFileLoader loadMethodObjectFile:dllFileName.
        originator activityNotification:''.

        handle isNil ifTrue:[
            KeepIntermediateFiles ~~ true ifTrue:[ OperatingSystem removeFile:dllFileName ].
            "catch, so that #CannotLoad processing is done"
            ParseError catch:[
                originator parseError:'dynamic load of machine code failed' position:1.
            ].
            ^ #CannotLoad
        ].

        "
         did it work ?
        "
        newMethod := classToCompileFor compiledMethodAt:selector.

        "/ if install is false, we have to undo the install (which is always done, when loading machine code)
        install ifFalse:[
            oldMethod isNil ifTrue:[
                classToCompileFor removeSelector:selector
            ] ifFalse:[
                newMethod setPackage:oldMethod package.
                classToCompileFor addSelector:selector withMethod:oldMethod.
                oldMethod setPackage:package.
            ]
        ].

        newMethod notNil ifTrue:[
            handle method ~~ newMethod ifTrue:[
                'Compiler [warning]: loaded method installed itself in another class' errorPrintCR.
            ].

            newMethod source:aString string.
            newMethod setPackage:package.
"/            Project notNil ifTrue:[
"/                newMethod package:(Project currentPackageName)
"/            ].

    "/        classToCompileFor updateRevisionString.
            install ifTrue:[
                classToCompileFor addChangeRecordForMethod:newMethod fromOld:oldMethod.

                "/ kludge-sigh: must send change messages manually here (stc-loaded code does not do it)
                "/ see addMethod:... in ClassDescription
                classToCompileFor changed:#methodDictionary with:(Array with:selector with:oldMethod).
                Smalltalk changed:#methodInClass with:(Array with:classToCompileFor with:selector with:oldMethod).
            ] ifFalse:[
                oldMethod := nil.
            ].

            silent ifFalse:[
                Transcript showCR:('    compiled: ', aClass name,' ',selector,' - machine code')
            ].
            ObjectMemory flushCaches.

            handle method:newMethod.

            "/ check for obsolete compiled method code and unload the
            "/ corresponding ObjectFileHandle.
            "/ The old method with its source code is usually kept in the method history.
            "/ and will be recompiled on an undo

            ObjectFileLoader loadedObjectHandlesDo:[:anotherHandle |
                anotherHandle isMethodHandle ifTrue:[
                    anotherHandle method == oldMethod ifTrue:[
                        "break association betwen old method, code and handle"
                        anotherHandle removeConnectedObjects.
                    ].
                    anotherHandle isObsolete ifTrue:[
                        anotherHandle unload.
                        anotherHandle removeUnusedObjectFile.
                    ].
                ].
            ].
            ^ newMethod.
        ].

        "/ OperatingSystem removeFile:moduleFileName.
        self parseError:'dynamic load failed' position:1.
    ] ensure:[
        KeepIntermediateFiles == true ifTrue:[ 
            Transcript showCR:'keeping files'
        ] ifFalse:[
            parserFlags stcKeepSTIntermediate ifTrue:[
                Transcript showCR:'keeping st file: ', stFileName asFilename pathName
            ] ifFalse:[
                OperatingSystem removeFile:stFileName.
                OperatingSystem removeFile:'errorOutput'.
            ].
            cFileName notNil ifTrue:[
                parserFlags stcKeepCIntermediate == true ifTrue:[
                    Transcript showCR:'keeping c file: ', cFileName asFilename pathName
                ] ifFalse:[
                    OperatingSystem removeFile:cFileName.
                ]
            ].
            oFileName notNil ifTrue:[
                parserFlags stcKeepOIntermediate == true ifTrue:[
                    Transcript showCR:'keeping o file: ', oFileName asFilename pathName
                ] ifFalse:[
                    OperatingSystem removeFile:oFileName.
                ].
            ].
"/            OperatingSystem isMSDOSlike ifTrue:[
"/                mapFileName notNil ifTrue:[
"/                   OperatingSystem removeFile:mapFileName.
"/                ].
"/                libFileName notNil ifTrue:[
"/                   OperatingSystem removeFile:libFileName.
"/                ].
"/            ].
        ]
    ].

    "
     |m|

     Object subclass:#Test
            instanceVariableNames:''
            classVariableNames:''
            poolDictionaries:''
            category:'tests'.
     m := ByteCodeCompiler
            compile:'foo ^ ''hello'''
            forClass:Test
            inCategory:'tests'
            notifying:nil
            install:false
            skipIfSame:false.
     m inspect
    "
    "
     |m|

     Object subclass:#Test
            instanceVariableNames:''
            classVariableNames:''
            poolDictionaries:''
            category:'tests'.
     m := ByteCodeCompiler
            compileToMachineCode:'foo %{ RETURN (_MKSMALLINT(1)); %}'
            forClass:Test
            inCategory:'tests'
            notifying:nil
            install:false
            skipIfSame:false
            silent:false.
     m inspect
    "

    "Modified: / 14-09-1995 / 22:33:04 / claus"
    "Modified: / 19-03-1999 / 08:31:42 / stefan"
    "Modified: / 17-09-2011 / 10:39:25 / cg"
! !

!STCCompilerInterface methodsFor:'machine code generation-helpers'!

compileToC_onError:aBlock
    "compile st to C using stc.
     If any error happens, call aBlock passing it the fileName containing diagnostics"

    |command ok errorOutputFile|

    command := (self possiblyQuotedPath:stcPath) , ' ' , stcFlags 
                , ' -E:',(self possiblyQuotedPath:(Filename tempDirectory / 'lastIncrStcErrorOutput') pathName)
                , ' -defdir=', (self possiblyQuotedPath:cFileName asFilename directory pathName).
    cFileName asFilename suffix ~= 'c' ifTrue:[
        command := command , ' -cSuffix=',cFileName asFilename suffix.
    ].
    command := command , ' -C ' , (self possiblyQuotedPath:stFileName asFilename pathName).

    Verbose == true ifTrue:[
        Transcript show:'executing: '; showCR:command.
    ].

    originator activityNotification:'compiling (stc)'.

    errorOutputFile := Filename tempDirectory / 'stcErrorOutput'. 
    errorOutputFile writingFileDo:[:errorStream |
        ok := OperatingSystem 
                    executeCommand:command 
                    inputFrom:nil
                    outputTo:errorStream
                    errorTo:errorStream
                    showWindow:false
                    onError:[:stat| 
                                self breakPoint:#cg.
                                executionStatus := stat.
                                false
                            ].
    ].

    cFileName asFilename exists ifTrue:[
        ok ifFalse:[
            'Compiler [info]: oops - system says stc failed - but c-file is there ...' infoPrintCR.
            ok := true
        ]
    ] ifFalse:[
        ok ifTrue:[
            'Compiler [info]: oops - system says stc ok - but no c-file is there ...' infoPrintCR
        ].
        ok := false
    ].
    
    [
        ok ifFalse:[
            aBlock value:errorOutputFile
        ].
    ] ensure:[
        errorOutputFile remove.
    ].
    ^ ok

    "Created: / 07-11-2006 / 12:11:24 / cg"
    "Modified: / 08-08-2011 / 22:12:01 / cg"
!

compileToExe_onError:aBlock 
    "compile C to exe, using cc.
     If any error happens, call aBlock passing it the fileName containing diagnostics"

    |command errorOutputFile ok|

    command := (self possiblyQuotedPath:ccPath) , ' ' , cFlags , ' -D__INCREMENTAL_COMPILE__ ' , (self possiblyQuotedPath:cFileName).

    Verbose == true ifTrue:[
        Transcript show:'executing: ' showCR:command.
    ].
    originator activityNotification:'compiling (' , ccPath , ')'.

    errorOutputFile := Filename tempDirectory / 'stcErrorOutput'. 
    errorOutputFile writingFileDo:[:errorStream |
        ok := OperatingSystem 
                    executeCommand:command 
                    inputFrom:nil
                    outputTo:errorStream
                    errorTo:errorStream
                    showWindow:false
                    onError:[:stat| 
                                executionStatus := stat.
                                false
                    ].
    ].
    
    [
        ok ifFalse:[
            aBlock value:errorOutputFile
        ].
    ] ensure:[
        errorOutputFile remove.
    ].
    ^ ok
!

compileToObj_onError:aBlock
    "compile C to obj, using cc.
     If any error happens, call aBlock passing it the fileName containing diagnostics"

    |errorOutputFile ok commandTemplate command ccDefine env|

    "/ bcc does not like -D__BORLANDC__ (needs to be set to a version, such as 0x0505)
    "/ others do not need it (is already predefined in the compiler)
    "/ ccDefine := ' -D',ParserFlags usedCompilerDefine.
    "/ so, never redefine ccDefine
    ccDefine := ''.

    ParserFlags useBorlandC ifTrue:[
        "Note: Windows/bcc32 does not understand a space between -o and filename"
        "/ cg: I guess, this does not work for visual-c
        commandTemplate := '%1 %2%3 -D__INCREMENTAL_COMPILE__ -o%4 -c %5'.
    ] ifFalse:[
        commandTemplate := '%1 %2%3 -D__INCREMENTAL_COMPILE__ -o %4 -c %5'.
    ].
    command := commandTemplate
                    bindWith:(self possiblyQuotedPath:ccPath) 
                    with:cFlags
                    with:ccDefine
                    with:(self possiblyQuotedPath:oFileName)
                    with:(self possiblyQuotedPath:cFileName).

    Verbose == true ifTrue:[
        Transcript show:'executing: '; showCR:command.
    ].
    originator activityNotification:'compiling (' , ccPath , ')'.

    env := OperatingSystem isUNIXlike
                    ifTrue:[OperatingSystem getEnvironment copy]
                    ifFalse:[env := Dictionary new].
    env at:'LANG' put:'C'.
    env at:'LC_MESSAGES' put:'C'.

    "/ When compiling using MINGW32/64, the bin directory
    "/ must be in path since compiler uses some .dlls found there
    "/ (an otherwise, they won't be found)
    (ParserFlags useMingw32 or:[ ParserFlags useMingw64 ]) ifTrue:[
        "/ JV @ 2016-01-04: I dunno why, but adding new, fixed path to env variable passed
        "/ to executeCommand:...environment:... below does not work.
        "/ Modifying this very process own environment works, though,
        | path |

        path := OperatingSystem getEnvironment: 'PATH'.
        (path includesSubstring: ccPath) ifFalse:[
            OperatingSystem setEnvironment: 'PATH' to: path  , ';', ccPath asFilename directory pathName
        ].
    ].
    
    errorOutputFile := Filename tempDirectory / 'stcErrorOutput'. 
    errorOutputFile writingFileDo:[:errorStream |
        ok := OperatingSystem 
                    executeCommand:command 
                    inputFrom:nil
                    outputTo:errorStream
                    errorTo:errorStream
                    environment:env
                    showWindow:false
                    onError:
                        [:stat| 
                            executionStatus := stat.
                            false
                        ].
    ].
    
    oFileName asFilename exists ifTrue:[
        ok ifFalse:[
            'Compiler [info]: system says compile failed - but o-file is there ...' infoPrintCR.
            ok := true
        ]
    ] ifFalse:[
        ok ifTrue:[
            'Compiler [info]: system says compile ok - but no o-file is there ...' infoPrintCR.
        ].
        ok := false
    ].
    [
        ok ifFalse:[
            aBlock value:errorOutputFile
        ].
    ] ensure:[
        errorOutputFile remove.
    ].
    ^ ok

    "Created: / 07-11-2006 / 12:14:51 / cg"
    "Modified: / 04-01-2016 / 21:12:56 / jv"
!

compileToS_onError:aBlock
    "compile C to assembler, using cc.
     If any error happens, call aBlock passing it the fileName containing diagnostics"

    |command errorOutputFile ok|

    command := (self possiblyQuotedPath:ccPath) , ' ' , cFlags , ' -D__INCREMENTAL_COMPILE__ -S ' , (self possiblyQuotedPath:cFileName).

    Verbose == true ifTrue:[
        Transcript show:'executing: '; showCR:command.
    ].
    originator activityNotification:'compiling (' , ccPath , ')'.

    errorOutputFile := Filename tempDirectory / 'stcErrorOutput'. 
    errorOutputFile writingFileDo:[:errorStream |
        ok := OperatingSystem 
                    executeCommand:command 
                    inputFrom:nil
                    outputTo:errorStream
                    errorTo:errorStream
                    showWindow:false
                    onError:[:stat| 
                                executionStatus := stat.
                                false
                    ].
    ].
    [
        ok ifFalse:[
            aBlock value:errorOutputFile
        ].
    ] ensure:[
        errorOutputFile remove.
    ].
    ^ ok
!

ensureExternalToolsArePresent
    (stcPath := self incrementalStcPath) isNil ifTrue:[
        self parseError:'no stc compiler available - cannot create machine code' position:1.
    ].

    "make it absolute, so that we are immune to directory changes"
    stcPath := stcPath asFilename pathName.
    (ccPath := parserFlags ccPath) isNil ifTrue:[
        self parseError:'no cc compiler available - cannot create machine code' position:1.
    ].
    "make it absolute, so that we are immune to directory changes"
    ccPath := ccPath asFilename pathName.

    (ObjectFileLoader notNil and:[ObjectFileLoader canLoadObjectFiles]) ifFalse:[
        self parseError:'no dynamic loader configured - cannot create machine code' position:1.
    ].

    "Created: / 07-11-2006 / 12:31:48 / cg"
!

ensureModuleDirectoryExists
    |mP t msg|

    mP := parserFlags stcModulePath.
    mP isEmptyOrNil ifTrue:[
        self parseError:'No temporary module directory, check your settings!!' position:1.
    ].
    mP := mP asFilename.
    mP exists ifFalse:[
        mP recursiveMakeDirectory
    ].
    (mP isWritableDirectory and:[mP isReadable]) ifFalse:[
        (mP exists and:[mP isDirectory]) ifTrue:[
            msg := 'No write permission in temporary module directory: '.
        ] ifFalse:[    
            msg := 'No access to temporary module directory: '.
        ].
        self parseError:(msg , mP pathName) position:1.
    ].
    
    "/ create a small README there ...
    
    (t := mP construct:'README') exists ifFalse:[
        t contents:'This temporary ST/X directory contains machine code for
accepted methods with embedded C-code 
(i.e. dynamic compiled code for inline-C methods).

Files here are not automatically removed, since ST/X 
cannot determine if any (other) snapshot image still 
requires a file here.

Please be careful when removing files here - a snapshot
image which was saved with accepted embedded C-code
may not be able to restart correctly if you remove a
required file.
Also, when you export a snapshot image for execution
on another machine, make certain that the required
module-files are also present there.

You should periodically clean dead entries here.
i.e. remove files, when you are certain that none
of your snapshot images refers to any module here.

See the launchers File-Modules dialog for a list of
modules which are still required by your running image.

With kind regards - your ST/X.
'.
    ].

    "Modified: / 26-10-2016 / 22:35:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ensureSuperClassesAreLoadedOf:aClass
    |supers|

    supers := aClass allSuperclasses.
    supers reverseDo:[:cls|
        cls isLoaded ifFalse:[
            self parseError:('Cannot stc-compile (superclass %1 is unloaded)' bindWith:cls) position:1.
        ]
    ].
!

fileOutAllDefinitionsOf:aClass to:aStream rememberIn:definedClasses
    |defineAction|

    defineAction := 
        [:cls|
            (definedClasses includes:cls) ifFalse:[
                cls 
                    basicFileOutDefinitionOn:aStream 
                    withNameSpace:false withPackage:false
                    syntaxHilighting:false.

                aStream nextPut:(aStream class chunkSeparator); cr.
                definedClasses add:cls.
            ].
        ].

    aClass allSuperclasses reverseDo:defineAction.
    defineAction value:aClass.
!

generateSTSource:aString 
    |stream definedClasses sep className modulesDir ns nsName|

    "/ generate a unique name, consisting of my processID and a sequence number
    "/ the processId is added to allow filein of modules from different
    "/ lifes

    SequenceNumber := (SequenceNumber ? 0) + 1.

    initName := 'm_' , OperatingSystem getProcessId printString, '_' , SequenceNumber printString.

"/    Smalltalk isSmalltalkDevelopmentSystem ifTrue:[
"/        modulesParentDir := Filename currentDirectory. 
"/    ] ifFalse:[
"/        modulesParentDir := Filename tempDirectory. 
"/    ].
"/    modulesDir := modulesParentDir construct:'modules'. 
    modulesDir := ParserFlags stcModulePath.
    stFileName := (modulesDir asFilename construct:(initName , '.st')) name. 

    [
        stream := stFileName asFilename writeStream.
    ] on:FileStream openErrorSignal do:[:ex|
        self parseError:'cannot create temporary sourcefile for compilation' position:1.
        ^ #CannotLoad
    ].
    stream := EncodedStream stream:stream encoder:(CharacterEncoder encoderForUTF8).
    stream nextPutLine:'"{ Encoding: utf8 }" !!'.

    definedClasses := IdentitySet new.

    sep := stream class chunkSeparator.

    Class fileOutNameSpaceQuerySignal answer:true
    do:[
        theNonMetaclassToCompileFor realSharedPoolNames do:[:eachPoolname |
            |pool|

            pool := Smalltalk at:eachPoolname.
            self 
                fileOutAllDefinitionsOf:pool 
                to:stream 
                rememberIn:definedClasses.
        ].

        self 
            fileOutAllDefinitionsOf:theNonMetaclassToCompileFor 
            to:stream 
            rememberIn:definedClasses.

        theNonMetaclassToCompileFor privateClassesSorted do:[:aPrivateClass |
            self 
                fileOutAllDefinitionsOf:aPrivateClass 
                to:stream 
                rememberIn:definedClasses.
        ].
"/        theNonMetaclassToCompileFor fileOutPrimitiveDefinitionsOn:stream.
"/ If a method uses a static primitive function... - but this doesn't work
"/ Yes it does work, but primitive functions have to be strictly static!!
        theNonMetaclassToCompileFor fileOutPrimitiveSpecsOn:stream.
    ].

"/    stream cr.
"/    stream nextPutLine:'"{ Package: ''' , package , ''' }"'.
"/    stream cr.

    className := theNonMetaclassToCompileFor name.
    ns := theNonMetaclassToCompileFor topNameSpace.
    (ns notNil and:[ns ~= Smalltalk and:[nsName := ns name. className startsWith:(nsName,'::')]]) ifTrue:[
        className := className copyFrom:nsName size+2+1.
        "/ split to avoid being regognized as a directive
        stream nextPutLine:('"','{ NameSpace: ',nsName,' }"').
    ].

    stream nextPut:sep.
    stream nextPutAll:className.
    classToCompileFor isMeta ifTrue:[
        stream nextPutAll:' class'.
    ].
    stream nextPutAll:' methodsFor:'''; nextPutAll:methodCategory; nextPutAll:''''.
    stream nextPut:sep; cr.

    stream nextPutLine:'"{ Line: 0 }"'; 
           nextChunkPut:aString;
           space; nextPut:sep.

    stream close.

    "Modified: / 08-08-2011 / 23:23:10 / cg"
!

possiblyQuotedPath:aPath
    (aPath includes:Character space) ifTrue:[
        (aPath startsWith:$") ifFalse:[
            ^ '"',aPath,'"'
        ]
    ].
    ^ aPath
!

reportCompilationErrorFor:aCommand
    |eMsg errorMessages lNr|

    (executionStatus notNil and:[executionStatus couldNotExecute]) ifTrue:[
        eMsg := 'oops, no %1 - cannot create machine code' bindWith:aCommand.
    ] ifFalse:[
        errorMessages := 'errorOutput' asFilename contents collect:[:l | OperatingSystem decodePathOrCommandOutput: l ].
        OperatingSystem removeFile:'errorOutput'.

        errorMessages notNil ifTrue:[
            errorMessages := errorMessages reject:[:line | line includesString:'Warning:'].

            errorMessages size > 20 ifTrue:[
                errorMessages := errorMessages select:[:line | line asLowercase startsWith:'error'].
                errorMessages size > 20 ifTrue:[
                    errorMessages := (errorMessages copyTo:20) copyWith:'... more messages skipped'
                ].
            ].
"/                    errorMessages := errorMessages collect:[:line |
"/                        (line startsWith:(stFileName , ':')) ifTrue:[
"/                            'Line: ' , (line copyFrom:(stFileName size + 2))
"/                        ] ifFalse:[
"/                            line
"/                        ]
"/                      ].
        ].
        errorMessages isNil ifTrue:[
            errorMessages := #('')
        ].
        errorMessages := (Array with:'Failed to execute: "', aCommand,'"') , errorMessages.

        "/ try to extract a line number"
        (errorMessages contains:[:line | line includesString:'Borland']) ifTrue:[
            |i i2 s|
            i := errorMessages findFirst:[:l | l startsWith:(cFileName,':')].
            i ~~ 0 ifTrue:[
                ((errorMessages at:i+1) startsWith:'Error') ifTrue:[
                    i2 := (errorMessages at:i+1) indexOfSubCollection:(stFileName).
                    i2 ~~ 0 ifTrue:[
                        s := (errorMessages at:i+1) copyFrom:(i2+stFileName size+1).
                        s := s readStream.
                        lNr := Integer readFrom:s.
                        s skipSeparators.
                    ].    
                ]
            ].
        ].

        errorMessages isEmpty ifTrue:[
            eMsg := 'Error during compilation:\\Unspecified error (no output)' withCRs
        ] ifFalse:[
            eMsg := 'Error during compilation:\\' withCRs ,
                    (errorMessages asStringCollection asString).
        ].
    ].

    originator activityNotification:''.

    ParseError new
        lineNumber:lNr;
        errorMessage:eMsg;
        raise.

    "Created: / 07-11-2006 / 12:29:04 / cg"
    "Modified: / 21-12-2013 / 00:08:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reportCompilationErrorFor:aCommand fromFile:anErrorFilename
    |eMsg errorMessages lNr|

    (executionStatus notNil and:[executionStatus couldNotExecute]) ifTrue:[
        eMsg := 'oops, no %1 - cannot create machine code' bindWith:aCommand.
    ] ifFalse:[
        errorMessages := anErrorFilename contents 
                            collect:[:l | OperatingSystem decodePathOrCommandOutput: l ].
        Transcript showCR:errorMessages asString.
        errorMessages notNil ifTrue:[
            errorMessages := errorMessages reject:[:line | line includesString:'Warning:'].

            errorMessages size > 20 ifTrue:[
                "/ errorMessages := errorMessages select:[:line | line asLowercase startsWith:'error'].
                errorMessages size > 20 ifTrue:[
                    errorMessages := (errorMessages copyTo:20) copyWith:'... more messages skipped'
                ].
            ].
"/                    errorMessages := errorMessages collect:[:line |
"/                        (line startsWith:(stFileName , ':')) ifTrue:[
"/                            'Line: ' , (line copyFrom:(stFileName size + 2))
"/                        ] ifFalse:[
"/                            line
"/                        ]
"/                      ].
        ].
        errorMessages isNil ifTrue:[
            errorMessages := #('')
        ].
        errorMessages := (Array with:'Failed to execute: "', aCommand,'"') , errorMessages.

        "/ try to extract a line number"
        (errorMessages contains:[:line | line includesString:'Borland']) ifTrue:[
            |i i2 s|
            i := errorMessages findFirst:[:l | l startsWith:(cFileName,':')].
            i ~~ 0 ifTrue:[
                ((errorMessages at:i+1) startsWith:'Error') ifTrue:[
                    i2 := (errorMessages at:i+1) indexOfSubCollection:(stFileName).
                    i2 ~~ 0 ifTrue:[
                        s := (errorMessages at:i+1) copyFrom:(i2+stFileName size+1).
                        s := s readStream.
                        lNr := Integer readFrom:s.
                        s skipSeparators.
                    ].    
                ]
            ].
        ].

        errorMessages isEmpty ifTrue:[
            eMsg := 'Error during compilation:\\Unspecified error (no output)' withCRs
        ] ifFalse:[
            eMsg := 'Error during compilation:\\' withCRs ,
                    (errorMessages asStringCollection asString).
        ].
    ].

    originator activityNotification:''.

    ParseError new
        lineNumber:lNr;
        errorMessage:eMsg;
        raise.

    "Created: / 07-11-2006 / 12:29:04 / cg"
    "Modified: / 21-12-2013 / 00:08:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-02-2017 / 09:58:18 / cg"
    "Modified (format): / 25-02-2017 / 19:33:58 / cg"
!

setupCompilationCommandArguments
    |stFn libDir incDir incDirArg defs incl opts|

    parserFlags isNil ifTrue:[ parserFlags := ParserFlags new].

    stFn := stFileName asFilename.
    oFileName := stFn nameWithoutSuffix , (ObjectFileLoader objectFileExtension).
    cFileName := (stFn withSuffix:'c') name. 
"/    ParserFlags useBorlandC ifTrue:[
"/        cFileName := (stFn withSuffix:'sc') name. 
"/    ].
    oFileName asFilename remove.
    cFileName asFilename remove.

    "/ stcFlags := '-commonSymbols +sharedLibCode +newIncremental -E:errorOutput -N' , initName .
    stcFlags := '+newIncremental'.
    initName notEmptyOrNil ifTrue:[
        stcFlags := stcFlags,' -N' , initName .
    ].
    cFlags := self class builtinCFlags.

    (defs := parserFlags stcCompilationDefines) notEmptyOrNil ifTrue:[
        cFlags := cFlags , ' ' , defs
    ].
    stcFlags := stcFlags , ' ', self class builtinCIncludeDirectories.
    cFlags := cFlags , ' ', self class builtinCIncludeDirectories.

    (incl := parserFlags stcCompilationIncludes) notEmptyOrNil ifTrue:[
        stcFlags := incl , ' ' , stcFlags.
        cFlags := cFlags , ' ' , incl.

        "/ if STX_LIBDIR is defined, and not in passed argument,
        "/ add it here.

        libDir := OperatingSystem getEnvironment:'STX_LIBDIR'.
        (libDir notNil and:[libDir asFilename exists]) ifTrue:[
            incDir := libDir asFilename construct:'include'.
            incDir exists ifTrue:[
                incDirArg := '-I' , incDir pathName.
                (incl asCollectionOfWords includes:incDirArg) ifFalse:[
                    stcFlags := stcFlags , ' ' , incDirArg.
                    cFlags := cFlags , ' ' , incDirArg.
                ]
            ]
        ].
    ].
    (opts := parserFlags stcCompilationOptions) notEmptyOrNil ifTrue:[
        stcFlags := opts , ' ' , stcFlags
    ].
    (opts := parserFlags ccCompilationOptions) notEmptyOrNil ifTrue:[
        cFlags := cFlags , ' ' , opts
    ].

    "Created: / 07-11-2006 / 12:24:47 / cg"
    "Modified: / 07-11-2006 / 13:58:54 / cg"
    "Modified: / 09-12-2015 / 17:00:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!STCCompilerInterface class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


STCCompilerInterface initialize!
