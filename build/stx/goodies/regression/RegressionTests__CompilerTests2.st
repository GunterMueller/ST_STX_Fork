"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
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
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CompilerTests2
	instanceVariableNames:'methods enabledJIT savedContext savedContextArgAndVarNames
		savedContextArgAndVarValues savedContextArgAndVarValuesUsingEval
		savedContextLine'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Compilers'
!

!CompilerTests2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
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
! !

!CompilerTests2 class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'librun.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'kernel32.dll'].

    self error:'Library name for host OS is not known'

    "Created: / 14-07-2016 / 10:10:56 / jv"
! !

!CompilerTests2 methodsFor:'private'!

assertSendersMethodIsIdenticalTo: sendersMethod
    "Do not assert here, pass down to have some immediate, possibly lazy contexts
     in between"

    self assertSendersSendersMethodIsIdenticalTo: sendersMethod

    "Created: / 25-04-2013 / 15:28:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

assertSendersSendersMethodIsIdenticalTo: thisMethod
    | ctx methodSlotIndex method |

    ctx := thisContext sender sender.
    methodSlotIndex := Context instVarIndexFor: #method.

    [ ctx isBlockContext ] whileTrue:[
        | block |

        block := ctx instVarAt: methodSlotIndex.
        self assert: block isBlock.
        self assert: block home == ctx home.
        ctx := ctx home.
    ].

    "/ Now, DO NOT USE Context>>method as it searches for the method
    "/ if it is not set!!

    method := ctx instVarAt: methodSlotIndex.
    self assert: method == thisMethod

    "Created: / 25-04-2013 / 15:30:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2016 / 11:15:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compile: source mode: mode
    "Compile given source and returns the new method.
     The from the source is prepended the mode + underscore
     (i.e., foo -> stc_foo).

     If mode is:
       #stc....then the method is stc-compiled.
       #jit....then the method is bytecode compiled and left
               to the jitter
       #bc.....them the method is bytecode compiled and marked
               as checked so JIT won't even try.
    "

    | m |

    Class withoutUpdatingChangesDo:[
        mode == #stc ifTrue:[
            ParserFlags withSTCCompilation:#always do:[
                m := self class compile: (mode, '_', source) classified: 'private - *dynamic*'.
            ].
        ] ifFalse:[
            ParserFlags withSTCCompilation:#never do:[
                m := self class compile: (mode, '_', source) classified: 'private - *dynamic*'.
                m checked: (mode == #bc)
            ].
        ].
    ].
    methods add: m.
    ^m

    "Created: / 25-04-2013 / 15:18:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

currentLineNumber
    thisContext fixAllLineNumbers.
    ^thisContext sender lineNumber.

    "Created: / 12-04-2013 / 21:20:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-04-2013 / 10:12:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveContext
    self saveContext: thisContext sender.

    "Created: / 26-09-2014 / 12:49:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveContext: aContext
    savedContext := aContext.
    savedContextArgAndVarNames := savedContext argAndVarNames asArray.
    savedContextArgAndVarValues := savedContext argsAndVars.
    savedContextArgAndVarValuesUsingEval := savedContextArgAndVarNames 
        collect:[ :each | 
            Compiler evaluate:each
                             in:savedContext
                             receiver:savedContext receiver
                             notifying:nil
                             logged:false
                             ifFail:[ '*Error when evaluating*'].
        ].
    savedContextLine := savedContext lineNumber.

    self assert: savedContextArgAndVarNames size == savedContextArgAndVarValues size.
    self assert: savedContextArgAndVarNames size == savedContextArgAndVarValuesUsingEval size.

    1 to: savedContextArgAndVarNames size do:[:i | 
        | v1 v2 |

        v1 := savedContextArgAndVarValues at: i.
        v2 := savedContextArgAndVarValuesUsingEval at: i.

        self assert: v1 == v2. "HAS to be IDENTICAL"
    ].

    "Created: / 26-09-2014 / 12:49:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 14:58:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompilerTests2 methodsFor:'private-mock methods'!

method_argAndVarNames_01
    #(1 2 3 4) select:[:each |
        | isEven |

        isEven := each even.
        self saveContext.
    ].

    "Created: / 20-08-2013 / 09:04:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 13:00:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_argAndVarNames_02
    #(1 2 3 4) select:[:each |
        | isEven |

        '1234' select:[:char |
            | someOtherLocal |

            someOtherLocal := char == $1.
        ].
        isEven := each even.
        self saveContext.
    ].

    "Created: / 20-08-2013 / 09:17:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 13:00:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_argAndVarNames_03
    "Reported by Stefan"

    savedContextArgAndVarNames := 1.
    (Smalltalk isStandAloneApp | (savedContextArgAndVarNames == 1)) ifTrue:[
        | ttt |

        ttt := 123.
        self saveContext.
    ].
    self halt.
    

    "
    CompilerTests2 basicNew method_argAndVarNames_03
    "

    "Created: / 20-08-2013 / 09:22:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 13:01:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_argAndVarNames_04
    #(1 2 3 4) select:[:each |
        | isEven |

        isEven := each even.
        isEven ifTrue:[
            | isOddNot |

            isOddNot := each odd not.
            self saveContext.
        ]
    ].

    "Created: / 20-08-2013 / 10:11:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 13:01:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_argAndVarNames_05
    | b |

    b := [:len |
        1 to: len do:[:i|
            | local1 local2 |

            local1 := #local1.
            local2 := 42.

            i == 1 ifTrue:[
                self saveContext.
            ]
        ]
    ].

    b value: 5

    "
    CompilerTests2 basicNew method_argAndVarNames_05
    "

    "Created: / 22-08-2013 / 15:48:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 13:01:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_argAndVarNames_06
    (Smalltalk at:#stx_goodies_regression) classNamesAndAttributesDo:[:clsnm :attributes|
        | cls |

        cls := Smalltalk at: clsnm.
        ((Array with: self class) includes: cls) ifTrue:[
            (attributes includes: #autoload) ifTrue:[
                "/ Care for Object!!
                cls superclass notNil ifTrue:[
                    | superDef superNm |

                    superDef := ProjectDefinition definitionClassForPackage: cls superclass package.
                    superNm := cls superclass name.
                    self saveContext.
                    ^ self
                ].
            ].
        ].
    ].           

    "
    CompilerTests2 basicNew method_argAndVarNames_06
    "

    "Created: / 20-09-2013 / 11:44:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2016 / 09:42:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_argAndVarNames_07
    | b |

    b := [:len |
        1 to: len do:[:i|
            i == 1 ifTrue:[
                self saveContext.
            ]
        ]
    ].

    b value: 5

    "
    CompilerTests2 basicNew method_argAndVarNames_05
    "

    "Created: / 23-12-2015 / 18:40:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_lineno_002
    1 factorial. ^self currentLineNumber

    "Created: / 12-04-2013 / 21:22:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_lineno_300
    "DO NOT MAKE THIS METHOD SHORTER, DO NOT REMOVE BLANK LINES!!!!!!"









































































































































































































































































































    ^self currentLineNumber

    "Created: / 12-04-2013 / 21:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_literals_array_01a
    | literal |

    literal := #(
        _XXX:_:
        YYY
        _XXX:_:
    ).
    ^ literal

    "Created: / 20-01-2014 / 13:39:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_literals_array_01b
    | literal |

    literal := #(
        #'_XXX:_:'
        #'YYY'
        #'_XXX:_:'
    ).
    ^ literal

    "Created: / 20-01-2014 / 13:39:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_literals_symbol_01
    | literal |

    literal := #_XXX:_:.
    ^ literal.

    "Created: / 20-01-2014 / 13:43:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_methodslot_01: thisMethod
    self assertSendersMethodIsIdenticalTo: thisMethod

    "Created: / 25-04-2013 / 15:28:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_methodslot_02: thisMethod
     [ self assertSendersMethodIsIdenticalTo: thisMethod ]
        valueWithArguments:#() "/ don't use #value, it gets optimized!!

    "Created: / 25-04-2013 / 15:36:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_methodslot_03: thisMethod
    "Deep block nesting...."
    [
        [
            [
                [ 
                    self assertSendersMethodIsIdenticalTo: thisMethod 
                ] valueWithArguments:#() "/ don't use #value, it gets optimized!!
            ] valueWithArguments:#() "/ don't use #value, it gets optimized!!
        ] valueWithArguments:#() "/ don't use #value, it gets optimized!!
    ] valueWithArguments:#() "/ don't use #value, it gets optimized!!

    "Created: / 25-04-2013 / 15:38:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method_negativeZero_01
    | literal |

    literal := -0.0.
    ^ literal.
! !

!CompilerTests2 methodsFor:'setup'!

setUp
    methods := Set new.
    enabledJIT := ObjectMemory justInTimeCompilation:true.
    savedContext := savedContextArgAndVarNames 
    := savedContextArgAndVarValues := savedContextArgAndVarValuesUsingEval 
    := savedContextLine := '* Not assigned *'.

    "Created: / 25-04-2013 / 15:20:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 13:00:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    savedContext := savedContextArgAndVarNames 
    := savedContextArgAndVarValues := savedContextArgAndVarValuesUsingEval 
    := savedContextLine := nil.

    ObjectMemory justInTimeCompilation: enabledJIT.
    Class withoutUpdatingChangesDo:[
        | classesToRemove |
        (Smalltalk at: #'exept_regression_testData_CompilerTests2') notNil ifTrue:[
            (Smalltalk at: #'exept_regression_testData_CompilerTests2') classes do:[:e|
                e notNil ifTrue:[
                    Smalltalk removeClass: e
                ].
            ].
        ].
        Smalltalk allClassesDo:[:cls|
            (#(
                'stx:goodies/regression/testData/CompilerTests2'
                "/Add more...
            ) includes: cls package) ifTrue:[
                Smalltalk removeClass: cls
            ]
        ].

        methods do:[:m|
            m mclass removeSelector: m selector.
        ]
    ]

    "Created: / 26-10-2012 / 11:32:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 12:59:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompilerTests2 methodsFor:'tests'!

test_01
    "JV@2012-10-26:

     When a package is loaded from source using

        Smalltalk loadPackage:'...'

     expression __EVALUATED FROM WORKSPACE__ AND a method from loaded class
     uses a class from the same package that is not yet loaded (i.e., it will
     be loaded later),

     then the compiler as of 2012-10-26 generates access to a workspace variable
     instead of access to a global

     This tests checks for this bug
    "

    | ws |

    "/ this test only works with a Display...
    self skipIf:[Display isNil] description:'Test requires a Display'.

    "/First, make sure that package is not yet loaded...
    self
        assert: (Smalltalk at: #'exept_regression_testData_CompilerTests2') isNil
        description: 'Mock package already loaded'.

    ws := WorkspaceApplication new.
    ws selectedWorkspace
        autoDefineVariables: #workspace;
        contents: '(Smalltalk loadPackage: #''stx:goodies/regression/testData/CompilerTests2'')';
        selectAll;
        doIt.

    self assert: (Smalltalk at: #'RegressionTests::CompilerTests2Mock1') new foo class
                    == (Smalltalk at: #'RegressionTests::CompilerTests2Mock2')

    "Created: / 26-10-2012 / 11:59:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2013 / 15:30:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02
    "JV@2012-10-26:

     When a package is loaded from source using

        Smalltalk loadPackage:'...'

     expression and a method from loaded class in namespace uses a class from the
     same package and same namespace, that is not yet loaded (i.e., it will be loaded
     later),

     then the compiler as of 2012-10-26 generates access to class in no namespace.

     This test checks for this bug
    "

    "/First, make sure that package is not yet loaded...
    self
        assert: (Smalltalk at: #'exept_regression_testData_CompilerTests2') isNil
        description: 'Mock package already loaded'.

    self
        assert: (Smalltalk loadPackage: #'stx:goodies/regression/testData/CompilerTests2')
        description: 'Cannot load mock package!!'.


    self assert: (Smalltalk at: #'RegressionTests::CompilerTests2Mock1') new foo class
                    == (Smalltalk at: #'RegressionTests::CompilerTests2Mock2')

    "Created: / 26-10-2012 / 12:26:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 12-02-2013 / 16:24:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03
    "JV@2013-10-27:

     As of 2013-10-27 parser crashes on DNU when a message
     is constant-folded.
    "

    self compile: 'mock_03 ^ 1 perform: #+ with: 2' mode: #bc.
    self assert: self bc_mock_03 == 3

    "Created: / 24-06-2013 / 14:06:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-08-2013 / 02:38:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_04
    "JV@2013-10-27:

     As of 2013-10-27 bytecode compiler generates invalid code
     for perform:* with constant symbol. That's because
     in Parser, rev 1.781 >> keywordExpressionFor:, line 57 the
     selector is reser back to the original, overwriting the one
     set by constant-folding method.
    "

    self compile: 'mock_04:x ^x perform: #+ with: 2' mode: #bc.
    self assert: (self bc_mock_04:2) == 4

    "Created: / 27-08-2013 / 02:37:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-08-2013 / 10:32:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05a
    "JV@2014-05-23:

    As of 2014-05-23, stc generate wrong code for compilation units
    which references symbol AND contains argument declarations for
    variable named _<value of that symbol> (given that symbol consist
    of [A-Za-z]). 

    The problem is that stc creates per-compilation unit static variable
    for the symbol and defines a short accessor in form _<symbol value>.
    If the function has argumemt with the very same name, the CPP expands
    argment name in method signature to the access to the static variable
    referencing the symbol object and thus cause syntax error.

    NOTE, that problem occurs even if the symbol object is used as a selector
    in message send ANYWHERE in the same compilation unit.

    Bytecode compiler, however, handles this correctly, so this problem
    will manifest itself by uncompilable code once checked out and
    compled by STC.
    "
    #(bc stc) do:[:mode | 
    self compile: 'at: _key 
                    ^ #key' mode: mode.
        self assert: (self perform: (mode , '_at:') asSymbol with: 2) == #key.
    ]

    "Created: / 23-05-2014 / 14:33:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 23-05-2014 / 16:11:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05b
    "JV@2014-05-23:

    As of 2014-05-23, stc generate wrong code for compilation units
    which references symbol AND contains local variable declarations for
    variable named _<value of that symbol> (given that symbol consist
    of [A-Za-z]. 

    The problem is that local variables in stc code are not a C local variables
    but rather accessed indirectly using __context[offset]. As a courtesy to a problammer,
    original variable name is a #define expaning to this context-accessing expression.
    If there's a symbol with conflicitng name, the #define which is used to access it
    is overriden by #define for local variable, causing bad return value of the method.

    Bytecode compiler, however, handles this correctly, so this problem
    will manifest itself when recompiled by STC and run. Even worse, in debugger
    printit you'll get correct answer and well as if you recompile. 

    "
    #(bc stc) do:[:mode | 
    self compile: 'at: arg
                    | _key |

                    _key := arg.
                    ^ #key' mode: mode.
        self assert: (self perform: (mode , '_at:') asSymbol with: 2) == #key.
    ]

    "Created: / 23-05-2014 / 14:33:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 23-05-2014 / 16:16:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompilerTests2 methodsFor:'tests - FFI'!

test_external_function_call_01a_u
    "Test for stx bug for <cdecl> specs like

        <cdecl: Cairo::FontFace 'cairo_get_font_face' ( Cairo::GraphicsContext ) >

     i.e., when custom subclass of ExternalAddress is in namespace."
    
    | malloc  free |

    self skipIf: OperatingSystem isUNIXlike not description: 'This test is UNIX specific, see _w variant for Windows'.

    malloc := 'malloc: size

    <cdecl: const RegressionTests::CompilerTests2ExternalBytes "malloc" ( int ) module: ''librun.so''>
    self primitive failed'.
    free := 'free: ptr

    <cdecl: const void "free" ( RegressionTests::CompilerTests2ExternalBytes ) module: ''librun.so''>
    self primitive failed'.
    #( #bc #stc ) do:[:mode | 
        | ptr |

        self compile:malloc mode:mode.
        self compile:free mode:mode.
        ptr := self perform:(mode , '_malloc:') asSymbol with:1.
        self assert:ptr class == RegressionTests::CompilerTests2ExternalBytes.
        self perform:(mode , '_free:') asSymbol with:ptr.
    ]

    "Created: / 12-07-2016 / 23:54:54 / jv"
!

test_external_function_call_01a_w
    "Test for stx bug for <cdecl> specs like

        <cdecl: Cairo::FontFace 'cairo_get_font_face' ( Cairo::GraphicsContext ) >

     i.e., when custom subclass of ExternalAddress is in namespace."
    
    | getProcessHeap |

    self skipIf: OperatingSystem isMSWINDOWSlike not description: 'This test is Windows specific, see _u variant for UNIX'.

    getProcessHeap := 'getProcessHeap
    <apicall: RegressionTests::CompilerTests2ExternalBytes "GetProcessHeap" (  ) module: "kernel32.dll">
    self primitive failed'.

    #( #bc #stc ) do:[:mode | 
        | heap |

        self compile:getProcessHeap mode:mode.
        heap := self perform: (mode , '_getProcessHeap') asSymbol.
        self assert:heap class == RegressionTests::CompilerTests2ExternalBytes.

    ]

    "Created: / 12-07-2016 / 23:57:56 / jv"
!

test_external_function_call_01b_u
    "Test for stx bug for <cdecl> specs like

        <cdecl: Cairo::FontFace 'cairo_get_font_face' ( Cairo::GraphicsContext ) >

     i.e., when custom subclass of ExternalAddress is in namespace."
    
    | malloc  free |

    self skipIf: OperatingSystem isUNIXlike not description: 'This test is UNIX specific, see _w variant for Windows'.

    malloc := 'malloc: size

    <cdecl: const RegressionTests::CompilerTests2ExternalBytes "malloc" ( int ) module: ''librun''>
    self primitive failed'.
    free := 'free: ptr

    <cdecl: const void "free" ( RegressionTests::CompilerTests2ExternalBytes ) module: ''librun''>
    self primitive failed'.
    #( #bc #stc ) do:[:mode | 
        | ptr |

        self compile:malloc mode:mode.
        self compile:free mode:mode.
        ptr := self perform:(mode , '_malloc:') asSymbol with:1.
        self assert:ptr class == RegressionTests::CompilerTests2ExternalBytes.
        self perform:(mode , '_free:') asSymbol with:ptr.
    ]

    "Created: / 12-07-2016 / 23:55:01 / jv"
!

test_external_function_call_01b_w
    "Test for stx bug for <cdecl> specs like

        <cdecl: Cairo::FontFace 'cairo_get_font_face' ( Cairo::GraphicsContext ) >

     i.e., when custom subclass of ExternalAddress is in namespace."
    
    | getProcessHeap |

    self skipIf: OperatingSystem isMSWINDOWSlike not description: 'This test is Windows specific, see _u variant for UNIX'.

    getProcessHeap := 'getProcessHeap
    <apicall: RegressionTests::CompilerTests2ExternalBytes "GetProcessHeap" (  ) module: "kernel32">
    self primitive failed'.

    #( #bc #stc ) do:[:mode | 
        | heap |

        self compile:getProcessHeap mode:mode.
        heap := self perform: (mode , '_getProcessHeap') asSymbol.
        self assert:heap class == RegressionTests::CompilerTests2ExternalBytes.

    ]

    "Created: / 14-07-2016 / 10:07:40 / jv"
!

test_external_function_call_01c_u
    "Test for stx bug for <cdecl> specs like

        <cdecl: Cairo::FontFace 'cairo_get_font_face' ( Cairo::GraphicsContext ) >

     i.e., when custom subclass of ExternalAddress is in namespace."
    
    | malloc  free |

    self skipIf: OperatingSystem isUNIXlike not description: 'This test is UNIX specific, see _w variant for Windows'.

    malloc := 'malloc: size

    <cdecl: const RegressionTests::CompilerTests2ExternalBytes "malloc" ( int )>
    self primitive failed'.
    free := 'free: ptr

    <cdecl: const void "free" ( RegressionTests::CompilerTests2ExternalBytes )>
    self primitive failed'.
    #( #bc #stc ) do:[:mode | 
        | ptr |

        self compile:malloc mode:mode.
        self compile:free mode:mode.
        ptr := self perform:(mode , '_malloc:') asSymbol with:1.
        self assert:ptr class == RegressionTests::CompilerTests2ExternalBytes.
        self perform:(mode , '_free:') asSymbol with:ptr.
    ]

    "Created: / 12-07-2016 / 23:55:06 / jv"
!

test_external_function_call_01c_w
    "Test for stx bug for <cdecl> specs like

        <cdecl: Cairo::FontFace 'cairo_get_font_face' ( Cairo::GraphicsContext ) >

     i.e., when custom subclass of ExternalAddress is in namespace."
    
    | getProcessHeap |

    self skipIf: OperatingSystem isMSWINDOWSlike not description: 'This test is Windows specific, see _u variant for UNIX'.

    getProcessHeap := 'getProcessHeap
    <apicall: RegressionTests::CompilerTests2ExternalBytes "GetProcessHeap" (  )>
    self primitive failed'.

    #( #bc #stc ) do:[:mode | 
        | heap |

        self compile:getProcessHeap mode:mode.
        heap := self perform: (mode , '_getProcessHeap') asSymbol.
        self assert:heap class == RegressionTests::CompilerTests2ExternalBytes.

    ]

    "Created: / 14-07-2016 / 10:08:04 / jv"
! !

!CompilerTests2 methodsFor:'tests - arg & var names'!

test_argAndVarNames_04

    #(bc jit stc) do:[:mode |
        savedContextArgAndVarNames := nil.
        self compile: (self class >> #method_argAndVarNames_04) source mode: mode.
        self perform: (mode , '_method_argAndVarNames_04') asSymbol.
        self assert: savedContextArgAndVarNames = #(each isEven isOddNot).
        self assert: savedContextArgAndVarValues = #(4 true true).  
    ]

    "Created: / 20-08-2013 / 10:12:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 15:04:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_argAndVarNames_05bc
    "/ CG: this test tries to access the context of a block.
    "/ however, the block is an inlined to:do: block, so its block local gets
    "/ lifted to its home context.
    "/ It is questionable if the test is right.
    "/ 
    "/ JV: true, but this tests exercise methods used by the
    "/ debugger. Therefore it does not matter whether block is inlined
    "/ or not - the debugger should show correct data in all cases!!

    savedContextArgAndVarNames := nil.
    self compile: (self class >> #method_argAndVarNames_05) source mode: #bc.
    self perform: (#bc , '_method_argAndVarNames_05') asSymbol.
    self assert: savedContextArgAndVarNames = #(len i local1 local2).
    self assert: savedContextArgAndVarValues = #(5 1 #local1 42).

    "Created: / 23-12-2015 / 18:38:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_argAndVarNames_05jit
    "/ CG: this test tries to access the context of a block.
    "/ however, the block is an inlined to:do: block, so its block local gets
    "/ lifted to its home context.
    "/ It is questionable if the test is right.
    "/ 
    "/ JV: true, but this tests exercise methods used by the
    "/ debugger. Therefore it does not matter whether block is inlined
    "/ or not - the debugger should show correct data in all cases!!


    "/ The bytecode compiler inlines the to:do: in this case...
    savedContextArgAndVarNames := nil.
    self compile: (self class >> #method_argAndVarNames_05) source mode: #jit.
    self perform: (#jit , '_method_argAndVarNames_05') asSymbol.
    self assert: savedContextArgAndVarNames = #(len i local1 local2).
    self assert: savedContextArgAndVarValues = #(5 1 #local1 42).

    "Created: / 23-12-2015 / 18:38:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_argAndVarNames_05stc
    "/ CG: this test tries to access the context of a block.
    "/ however, the block is an inlined to:do: block, so its block local gets
    "/ lifted to its home context.
    "/ It is questionable if the test is right.
    "/ 
    "/ JV: true, but this tests exercise methods used by the
    "/ debugger. Therefore it does not matter whether block is inlined
    "/ or not - the debugger should show correct data in all cases!!


    "/ The stc compiler as of 2015-12-23 does not (!!!!!!) inline to:do:
    savedContextArgAndVarNames := nil.
    self compile: (self class >> #method_argAndVarNames_05) source mode: #stc.
    self perform: (#stc , '_method_argAndVarNames_05') asSymbol.
    self assert: savedContextArgAndVarNames = #(i local1 local2).
    self assert: savedContextArgAndVarValues = #(1 #local1 42)

    "Created: / 23-12-2015 / 18:37:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_argAndVarNames_06

    #(bc jit stc) do:[:mode |
        savedContextArgAndVarNames := nil.
        self compile: (self class >> #method_argAndVarNames_06) source mode: mode.
        self perform: (mode , '_method_argAndVarNames_06') asSymbol.
        self assert: savedContextArgAndVarNames = #(clsnm attributes cls superDef superNm).
        self assert: savedContextArgAndVarValues = {
            self class name.
            #(#autoload).
            self class.
            Smalltalk at: #stx_goodies_sunit.
            self class superclass name.
        }

    ]

    "Created: / 20-09-2013 / 11:44:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 15:09:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_argAndVarNames_07bc

    savedContextArgAndVarNames := nil.
    self compile: (self class >> #method_argAndVarNames_07) source mode: #bc.
    self perform: (#bc , '_method_argAndVarNames_07') asSymbol.
    self assert: savedContextArgAndVarNames = #(len i ).
    self assert: savedContextArgAndVarValues = #(5 1 ).

    "Created: / 23-12-2015 / 18:40:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_argAndVarNames_07jit

    savedContextArgAndVarNames := nil.
    self compile: (self class >> #method_argAndVarNames_07) source mode: #jit.
    self perform: (#jit , '_method_argAndVarNames_07') asSymbol.
    self assert: savedContextArgAndVarNames = #(len i ).
    self assert: savedContextArgAndVarValues = #(5 1 ).

    "Created: / 23-12-2015 / 18:40:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_argAndVarNames_07stc

    savedContextArgAndVarNames := nil.
    self compile: (self class >> #method_argAndVarNames_07) source mode: #stc.
    self perform: (#stc , '_method_argAndVarNames_07') asSymbol.
    self assert: savedContextArgAndVarNames = #( i ).
    self assert: savedContextArgAndVarValues = #( 1 ).

    "Created: / 23-12-2015 / 18:41:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-12-2015 / 07:38:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompilerTests2 methodsFor:'tests - line numbers'!

test_lineno_01_bci
    | m002 m300 l |

    m002 := self compile: (self class >> #method_lineno_002) source mode: #bc.
    m300 := self compile: (self class >> #method_lineno_300) source mode: #bc.

    self assert: (l := self bc_method_lineno_002) == 2.
    self assert: (l := self bc_method_lineno_300) == 300.

    self assert: m002 code isNil.
    self assert: m300 code isNil.

    "Created: / 12-04-2013 / 21:24:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-04-2013 / 15:24:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_lineno_01_jit
    | m002 m300 l |


    self skipIf: ObjectMemory justInTimeCompilation not 
         description: 'Just-in-time compilation not supported on this setup'.

    m002 := self compile: (self class >> #method_lineno_002) source mode: #jit.
    m300 := self compile: (self class >> #method_lineno_300) source mode: #jit.

    self assert: (l := self jit_method_lineno_002) == 2.
    self assert: (l := self jit_method_lineno_300) == 300.

    self assert: m002 code notNil.
    self assert: m300 code notNil.

    "Created: / 12-04-2013 / 21:41:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-05-2013 / 18:23:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_lineno_01_stc
    | m002 m300 l |

    m002 := self class >> #method_lineno_002.
    m300 := self class >> #method_lineno_300.

    self compile: m002 source mode: #stc.
    self compile: m300 source mode: #stc.

    self assert: (l := self stc_method_lineno_002) == 2.
    self assert: (l := self stc_method_lineno_300) == 300.

    "Created: / 12-04-2013 / 21:50:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-04-2013 / 15:22:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompilerTests2 methodsFor:'tests - literals'!

test_literals_array_01a
    | m l_stc l_bc |

    m := self class >> #method_literals_array_01a.

    self compile: m source mode: #stc.
    self compile: m source mode: #bc.

    l_stc := self stc_method_literals_array_01a.
    l_bc :=  self bc_method_literals_array_01a.

    self assert: l_stc = l_bc.

    "Created: / 20-01-2014 / 13:46:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_literals_array_01a_bc
    | m l |

    m := self class >> #method_literals_array_01a.

    self compile: m source mode: #bc.

    l := self bc_method_literals_array_01a.

    self assert: l size == 3.
    self assert: l first == #'_XXX:_:'.
    self assert: l second == #'YYY'.
    self assert: l third == #'_XXX:_:'.

    "Created: / 20-01-2014 / 13:42:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_literals_array_01a_stc
    | m l |

    m := self class >> #method_literals_array_01a.

    self compile: m source mode: #stc.

    l := self stc_method_literals_array_01a.

    self assert: l size == 3.
    self assert: l first == #'_XXX:_:'.
    self assert: l second == #'YYY'.
    self assert: l third == #'_XXX:_:'.

    "Created: / 20-01-2014 / 13:40:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_literals_array_01b
    | m l_stc l_bc |

    m := self class >> #method_literals_array_01b.

    self compile: m source mode: #stc.
    self compile: m source mode: #bc.

    l_stc := self stc_method_literals_array_01b.
    l_bc :=  self bc_method_literals_array_01b.

    self assert: l_stc = l_bc.

    "Created: / 20-01-2014 / 13:46:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_literals_array_01b_bc
    | m l |

    m := self class >> #method_literals_array_01b.

    self compile: m source mode: #bc.

    l := self bc_method_literals_array_01b.

    self assert: l size == 3.
    self assert: l first == #'_XXX:_:'.
    self assert: l second == #'YYY'.
    self assert: l third == #'_XXX:_:'.

    "Created: / 20-01-2014 / 13:42:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_literals_array_01b_stc
    | m l |

    m := self class >> #method_literals_array_01b.

    self compile: m source mode: #stc.

    l := self stc_method_literals_array_01b.

    self assert: l size == 3.
    self assert: l first == #'_XXX:_:'.
    self assert: l second == #'YYY'.
    self assert: l third == #'_XXX:_:'.

    "Created: / 20-01-2014 / 13:40:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_literals_negativeZero_bc
    | m l |

    m := self class >> #method_negativeZero_01.

    self compile: m source mode: #bc.

    l := self bc_method_negativeZero_01.
    self assert: l = 0.0.
    self assert: l isNegativeZero.
!

test_literals_negativeZero_stc
    | m negZero |

    m := self class >> #method_negativeZero_01.

    self compile: m source mode: #stc.

    negZero := self stc_method_negativeZero_01.
    self assert: negZero = 0.0.
    self assert: negZero isNegativeZero.
!

test_literals_symbol_01_bc
    | m l |

    m := self class >> #method_literals_symbol_01.

    self compile: m source mode: #bc.

    l := self bc_method_literals_symbol_01.
    self assert: l == #'_XXX:_:'.

    "Created: / 20-01-2014 / 13:44:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_literals_symbol_01_stc
    | m l |

    m := self class >> #method_literals_symbol_01.

    self compile: m source mode: #stc.

    l := self stc_method_literals_symbol_01.
    self assert: l == #'_XXX:_:'.

    "Created: / 20-01-2014 / 13:44:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompilerTests2 methodsFor:'tests - method slot'!

test_methodslot_01_bci
    | m |

    m := self compile: (self class >> #method_methodslot_01:) source mode: #bc.
    self bc_method_methodslot_01: m.
    self assert: m code isNil.

    "Created: / 25-04-2013 / 15:33:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_methodslot_01_jit
    | m |

    self skipIf: ObjectMemory justInTimeCompilation not 
         description: 'Just-in-time compilation not supported on this setup'.

    m := self compile: (self class >> #method_methodslot_01:) source mode: #jit.
    self jit_method_methodslot_01: m.
    self assert: m code notNil.

    "Created: / 25-04-2013 / 15:34:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_methodslot_01_stc
    | m |

    m := self compile: (self class >> #method_methodslot_01:) source mode: #stc.
    self stc_method_methodslot_01: m.
    self assert: m code notNil.

    "Created: / 25-04-2013 / 15:34:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_methodslot_02_bci
    | m |

    m := self compile: (self class >> #method_methodslot_02:) source mode: #bc.
    self bc_method_methodslot_02: m.
    self assert: m code isNil.

    "Created: / 25-04-2013 / 15:36:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_methodslot_02_jit
    | m |

    self skipIf: ObjectMemory justInTimeCompilation not 
         description: 'Just-in-time compilation not supported on this setup'.

    m := self compile: (self class >> #method_methodslot_02:) source mode: #jit.
    self jit_method_methodslot_02: m.
    self assert: m code notNil.

    "Created: / 25-04-2013 / 15:37:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_methodslot_02_stc
    | m |

    m := self compile: (self class >> #method_methodslot_02:) source mode: #stc.
    self stc_method_methodslot_02: m.
    self assert: m code notNil.

    "Created: / 25-04-2013 / 15:37:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_methodslot_03_bci
    | m |

    m := self compile: (self class >> #method_methodslot_03:) source mode: #bc.
    self bc_method_methodslot_03: m.
    self assert: m code isNil.

    "Created: / 25-04-2013 / 15:39:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_methodslot_03_jit
    | m |

    self skipIf: ObjectMemory justInTimeCompilation not 
         description: 'Just-in-time compilation not supported on this setup'.

    m := self compile: (self class >> #method_methodslot_03:) source mode: #jit.
    self jit_method_methodslot_03: m.
    self assert: m code notNil.

    "Created: / 25-04-2013 / 15:39:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_methodslot_03_stc
    | m |

    m := self compile: (self class >> #method_methodslot_03:) source mode: #stc.
    self stc_method_methodslot_03: m.
    self assert: m code notNil.

    "Created: / 25-04-2013 / 15:39:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompilerTests2 methodsFor:'tests - regression'!

test_issue_205a
    | source |

    ParserFlags allowAssignmentToBlockArgument: true.
    ParserFlags warnAssignmentToBlockArgument: false.     

    source := 'foo | r | r := 0. 1 to: 10 do:[ :i | r := i. i := 100. self assert: i == 100 ]. ^ r'.

    self compile: source mode: #bc.
    self assert: (self perform: #bc_foo) == 10.
    
    self compile: source mode: #jit.
    self assert: (self perform: #jit_foo) == 10.

    "Created: / 18-04-2018 / 15:12:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-04-2018 / 23:20:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_205b
    | source |

    ParserFlags allowAssignmentToBlockArgument: true.
    ParserFlags warnAssignmentToBlockArgument: false.     

    source := 'foo | r | r := 0. 1 to: 10 do:[ :i | r := i. r == 1 ifTrue:[ r > 0 ifTrue: [ i := 100. self assert: i == 100 ] ] ]. ^ r'.

    self compile: source mode: #bc.
    self assert: (self perform: #bc_foo) == 10.
    
    self compile: source mode: #jit.
    self assert: (self perform: #jit_foo) == 10.

    "Created: / 18-04-2018 / 16:33:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-04-2018 / 23:31:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_205c
    | source |

    ParserFlags allowAssignmentToBlockArgument: true.
    ParserFlags warnAssignmentToBlockArgument: false.     

    source := 'foo | r | r := 0. 1 to: 10 do:[ :i | r := i. #(1 2 3 5) do:[:e| i := 100 ]. self assert: i == 100 ]. ^ r'.

    self compile: source mode: #bc.
    self assert: (self perform: #bc_foo) == 10.
    
    self compile: source mode: #jit.
    self assert: (self perform: #jit_foo) == 10.

    "Created: / 18-04-2018 / 16:35:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_205d
    | source |

    ParserFlags allowAssignmentToBlockArgument: true.
    ParserFlags warnAssignmentToBlockArgument: false.     

    source := 'foo | r | r := 0. 1 to: 10 by: 2 do:[ :i | r := i. i := 100. self assert: i == 100 ]. ^ r'.

    self compile: source mode: #bc.
    self assert: (self perform: #bc_foo) == 9.
    
    self compile: source mode: #jit.
    self assert: (self perform: #jit_foo) == 9.

    "Created: / 18-04-2018 / 16:45:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-04-2018 / 23:31:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_205e
    | source |

    ParserFlags allowAssignmentToBlockArgument: true.
    ParserFlags warnAssignmentToBlockArgument: false.     

    source := 'foo | r | r := 0. 1 to: 10 by: 2 do:[ :i | r := i. r == 1 ifTrue:[ r > 0 ifTrue: [ i := 100. self assert: i == 100 ] ] ]. ^ r'.

    self compile: source mode: #bc.
    self assert: (self perform: #bc_foo) == 9.
    
    self compile: source mode: #jit.
    self assert: (self perform: #jit_foo) == 9.

    "Created: / 18-04-2018 / 16:46:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-04-2018 / 23:32:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_205f
    | source |

    ParserFlags allowAssignmentToBlockArgument: true.
    ParserFlags warnAssignmentToBlockArgument: false.     

    source := 'foo | r | r := 0. 1 to: 10 by: 2 do:[ :i | r := i. #(1 2 3 5) do:[:e| i := 100 ]. self assert: i == 100 ]. ^ r'.

    self compile: source mode: #bc.
    self assert: (self perform: #bc_foo) == 9.
    
    self compile: source mode: #jit.
    self assert: (self perform: #jit_foo) == 9.

    "Created: / 18-04-2018 / 16:51:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_205g
    | source |

    ParserFlags allowAssignmentToBlockArgument: true.
    ParserFlags warnAssignmentToBlockArgument: false.     

    source := 'foo | r | r := 0. [ 1 to: 10 do:[ :i | r := i. i := 100. self assert: i == 100 ] ] valueWithOptionalArgument: ''bogus''. ^ r'.

    self compile: source mode: #bc.
    self assert: (self perform: #bc_foo) == 10.
    
    self compile: source mode: #jit.
    self assert: (self perform: #jit_foo) == 10.

    "Created: / 18-04-2018 / 23:15:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompilerTests2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

