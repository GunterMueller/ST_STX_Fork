"{ Encoding: utf8 }"

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

JavaMethodWithHandler variableSubclass:#JavaNativeMethod
	instanceVariableNames:'nativeImplementation nCalls'
	classVariableNames:'CacheNativeImplementation Verbose TrampolineSelectors'
	poolDictionaries:''
	category:'Languages-Java-Classes'
!

!JavaNativeMethod class methodsFor:'documentation'!

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

!JavaNativeMethod class methodsFor:'initialization'!

cacheNativeImplementation

    "For details, see #cacheNativeImplementation:"

    ^CacheNativeImplementation

    "Created: / 30-04-2011 / 23:38:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cacheNativeImplementation: aBoolean

    "If set, native implementations are cached, resulting
     in better performance when calling native methods.
     Hower, no change in native method implemenetaion will
     not be visible then, unless #flushAllCachedNativeMethods
     is explictely called"

    CacheNativeImplementation := aBoolean

    "Created: / 30-04-2011 / 23:38:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    "/self flags: ((self flags bitClear: Behavior flagMethod) bitOr: Behavior flagJavaMethod).
    self flags: ((self flags bitClear: Behavior flagJavaMethod) bitOr: Behavior flagMethod).
    "
    self flags bitAnd: Behavior flagJavaMethod
    self flags bitAnd: Behavior flagMethod

    "
    "By default, do not cache native impls while developing"
    CacheNativeImplementation := Smalltalk isStandAloneApp.
    Verbose := false.
    "
    Verbose := true.
    "

    TrampolineSelectors := #(
        "/0
        #trampoline:
        #trampoline:_:
        #trampoline:_:_:
        #trampoline:_:_:_:
        "/4
        #trampoline:_:_:_:
        #trampoline:_:_:_:_:
        #trampoline:_:_:_:_:_:
        #trampoline:_:_:_:_:_:_:
        "/8
        #trampoline:_:_:_:_:_:_:
        #trampoline:_:_:_:_:_:_:_:
        #trampoline:_:_:_:_:_:_:_:_:
        #trampoline:_:_:_:_:_:_:_:_:_:
        "/13
        #trampoline:_:_:_:_:_:_:_:_:_:
        #trampoline:_:_:_:_:_:_:_:_:_:_:
        #trampoline:_:_:_:_:_:_:_:_:_:_:_:
        #trampoline:_:_:_:_:_:_:_:_:_:_:_:_:
    ).

    "Modified (comment): / 03-11-2011 / 10:48:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2013 / 14:40:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethod class methodsFor:'instance creation'!

new
    "Redefined again, since since trampoline methods need
     literals"

    ^ self basicNew:1.

    "Created: / 31-01-2013 / 13:26:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethod class methodsFor:'cleanup'!

flushAllCachedNativeMethods
    self allInstancesDo:[:aNativeMethod |
        aNativeMethod nativeImplementation:nil
    ].

    "
     self flushAllCachedNativeMethods
    "

    "Created: / 24.12.1999 / 03:10:38 / cg"
    "Modified: / 24.12.1999 / 03:10:51 / cg"
! !

!JavaNativeMethod class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaNativeMethod methodsFor:'* As yet uncategorized *'!

messagesSentToSuper
    ^#()

    "Created: / 30-03-2013 / 09:58:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethod methodsFor:'accessing'!

nCalls
    ^ nCalls ? 0

    "Modified: / 27-10-2012 / 18:05:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nCallsReset
    nCalls := 0

    "Modified: / 27-10-2012 / 18:05:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nativeImplementation
    "return the value of the instance variable 'nativeImplementation' (automatically generated)"

    ^ nativeImplementation

    "Created: / 25.9.1999 / 23:08:00 / cg"
!

nativeImplementation:something
    "set the value of the instance variable 'nativeImplementation' (automatically generated)"

    nativeImplementation := something.

    "Created: / 25.9.1999 / 23:08:00 / cg"
!

sourceLineNumber

    ^super sourceLineNumber

"/    ForceByteCodeDisplay == true ifTrue:[ ^ 1].
"/    lineNumberTable notNil ifTrue:[ ^ lineNumberTable at:2].
"/    ^1


    "
    ^ (JavaSourceCodeCache new)
        findLineForMethod:(self selector)
        inClass:javaClass.
    "

    "Modified: / 13-12-2010 / 13:55:55 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 13-12-2010 / 23:46:30 / Marcel Hlopko <hlopik@gmail.com>"
    "Created: / 17-12-2010 / 10:34:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethod methodsFor:'private'!

compileNativeImplementation:sel dispatchingTo:oldSel
    | src  arg  converted  header |

    src := (JavaVM class compiledMethodAt:oldSel) source.
    src := src asStringCollection.
    (src first includesString:'aJavaContext') ifTrue:[
        arg := 'aJavaContext'
    ] ifFalse:[
        (src first includesString:'nativeContext') ifTrue:[
            arg := 'nativeContext'
        ]
    ].
    arg isNil ifTrue:[
        arg := 'nativeContext'.
        src := '    self breakPoint: #jv info: ''Convert it to new-style natives''.

                ^ self '
                , oldSel , ' nativeContext'.
        converted := false.
    ] ifFalse:[
        src removeFirst asString.
        converted := true.
    ].
    header := String
            streamContents:[:s |
                sel numArgs == 2 ifTrue:[
                    s
                        nextPutAll:sel;
                        space;
                        nextPutAll:'this  '.
                ] ifFalse:[
                    | kw |

                    kw := sel keywords.
                    s nextPutAll:kw first.
                    s nextPutAll:' this '.
                    2 to:kw size - 1 do:[:i |
                        sel
                            nextPutAll:(kw at:i);
                            space;
                            nextPut:$a;
                            nextPutAll:i printString;
                            space.
                    ].
                ]
            ].
    (JavaVM class compile:(self nativeMethodTemplate
                bindWith:header
                with:arg
                with:src asString)
        classified:'native - '
                , ((javaClass javaPackage upTo:$$) replaceAll:$/ with:$.))
            package:JavaVM package.
    converted ifTrue:[
        (JavaVM class compiledMethodAt:oldSel)
            category:'native - old-style (converted)'
    ] ifFalse:[
        (JavaVM class compiledMethodAt:oldSel)
            category:'native - old-style (FAILED to convert)'
    ]

    "Created: / 01-05-2011 / 00:08:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 15:51:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compileNativeImplementationStub: sel
    | header |

    "/No natives, no fun...
    JavaVM natives isNil ifTrue:[ ^ self ].

    header := String streamContents:[:s|
            | kw |

            kw := sel keywords.
            s nextPutAll: kw first.
            s nextPutAll: ' this '.
            2 to: kw size  do:[:i|
                s nextPutAll: (kw at: i); space; nextPut:$a; nextPutAll: (i - 1) printString; space.
            ].

    ].

    Class updateChangeFileQuerySignal answer: false do:[
        (JavaVM natives class
            compile:
                (self nativeMethodTemplate bindWith:header with: 'nativeContext' with:('^ JavaVM unimplementedNativeMethodSignal raise'))
            classified:
                'native - ', ((javaClass javaPackage upTo:$$) replaceAll:$/ with:$.))
            package: JavaVM package.
    ].
    self assert: (JavaVM natives respondsTo: sel).

    "Created: / 01-05-2011 / 00:08:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-01-2015 / 09:14:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nativeMethodTemplate

    ^'%1

    <javanative: ''', javaClass name , ''' name: ''', (selector copyButLast:signature size), '''>

    %3'

    "Created: / 01-05-2011 / 00:12:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2013 / 15:07:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchNativeImplementation
    <resource: #obsolete>

    "Returns a SELECTOR of native method implementation.
    For now, two naming schemes are used. The onld one uses
    just a class name and selector as a name for native method impl.
    The new one uses fully qualified class name.
    "

    | nm newStyleSel oldStyleSel |

    self error: 'Should no longer be called!!'.

    nm := selector upTo: $(.
    newStyleSel := ('_' , ((javaClass name copyReplaceAll:$/ with:$_) replaceAll:$$ with:$_), '_' , nm , ':') asSymbol.
    (JavaVM natives class canUnderstand: newStyleSel) ifTrue:[
        "Good, a JavaVM understands new style native selectors"
        ^newStyleSel
    ].

    oldStyleSel := ('_' , (javaClass lastName copyReplaceAll:$$ with:$_) , '_' , nm , ':') asSymbol.
    (JavaVM natives canUnderstand: oldStyleSel) ifTrue:[
        "Convert method on the fly only if Im Jan Vrany
         (to avoid confusion of other developers :-)"
        OperatingSystem getLoginName = 'jv' ifTrue:[
            "OK, old style method has not yet been converted to a newstyle one.
            Converts old-style method to a new-style one"
            self compileNativeImplementation: newStyleSel dispatchingTo: oldStyleSel.
            ^newStyleSel
        ] ifFalse:[
            ^oldStyleSel
        ]
    ].
    self compileNativeImplementationStub: newStyleSel.
    ^newStyleSel

    "Created: / 30-04-2011 / 23:50:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2013 / 23:31:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchNativeImplementation: numArgs

    "Returns a SELECTOR of native method implementation."


    | nm newStyleSel args |
    nm := selector upTo: $(.

    numArgs > 14 ifTrue:[ ^ nil ].

    args := #(
        "0"  ''
        "1"  '_:'
        "2"  '_:_:'
        "3"  '_:_:_:'
        "4"  '_:_:_:_:'
        "5"  '_:_:_:_:_:'
        "6"  '_:_:_:_:_:_:'
        "7"  '_:_:_:_:_:_:_:'
        "8"  '_:_:_:_:_:_:_:_:'
        "9"  '_:_:_:_:_:_:_:_:_:'
        "10" '_:_:_:_:_:_:_:_:_:_:'
        "11" '_:_:_:_:_:_:_:_:_:_:_:'
        "12" '_:_:_:_:_:_:_:_:_:_:_:_:'
        "13" '_:_:_:_:_:_:_:_:_:_:_:_:_:'
        "14" '_:_:_:_:_:_:_:_:_:_:_:_:_:_:'
    ) at: numArgs + 1.

    newStyleSel := ('_' , ((javaClass binaryName copyReplaceAll:$/ with:$_) replaceAll:$$ with:$_), '_' , nm , ':' , args) asSymbol.
    (JavaVM natives class canUnderstand: newStyleSel) ifTrue:[
        "Good, a JavaVM understands new style native selectors"
        "No checke whether the descriptor is the same."
        | m a |

        m := JavaVM natives class lookupMethodFor: newStyleSel.
        m isWrapped ifTrue:[ m := m originalMethod ].
        a := m annotationsAt: #javanative:name:.
        a do:[:each|
            each arguments second = selector ifTrue:[
                ^newStyleSel
            ].
        ].
        m mclass == JavaVM natives class ifTrue:[
            self breakPoint: #jv. "/no descriptor annotation!!!!!!"
            ^newStyleSel.
        ].

    ].

    self compileNativeImplementationStub: newStyleSel.
    ^newStyleSel

    "Created: / 19-01-2013 / 22:11:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-10-2013 / 01:43:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethod methodsFor:'private-compiler interface'!

numberOfArgs:aNumber
    | args sendTree trampolineTree compiler trampoline |

    super numberOfArgs:aNumber.

    aNumber > 14 ifTrue:[
        ^self.
    ].
    (self class flags bitAnd:Behavior flagJavaMethod) ~~ 0 ifTrue:[ ^ self ].
    javaClass isNil ifTrue:[
        self error: 'Cannot install trampoline - no Java class yet'.
        ^self.
    ].
    selector isNil ifTrue:[
        self error: 'Cannot install trampoline - no selector yet'.
        ^self.
    ].

    MethodNode isNil ifTrue:[
        self error: 'Cannot install trampoline - no MethodNode class'.
        ^self.
    ].

    "Create the trampoline"
    args := (1 to: aNumber) collect:[:i|(VariableNode methodArgumentNamed: ('arg_' , i printString)) index: i].

    sendTree := MessageNode
                    receiver: (VariableNode globalNamed:#'JavaVM:NativeMethodsImplementation')
                    selector: (self searchNativeImplementation: aNumber)
                    args: (Array with: (SelfNode value: #self)) , args.
    self isSynchronized ifTrue:[
        sendTree :=
            MessageNode
                receiver: ((BlockNode
                            arguments: #()
                            home: nil
                            variables: #())
                            statements: (
                                (StatementNode expression:
                                    (MessageNode
                                        receiver: (VariableNode globalNamed:#'JavaVM')
                                        selector: #_MONITORENTER:
                                          args: (Array with: (SelfNode value: #self) )))
                                nextStatement: (StatementNode expression:sendTree)
                                )
                        )

                selector: #ensure:
                args: {
                        (BlockNode
                            arguments: #()
                            home: nil
                            variables: #())
                            statements:
                                (StatementNode expression:
                                    (MessageNode
                                        receiver: (VariableNode globalNamed:#'JavaVM')
                                        selector: #_MONITOREXIT:
                                        args: (Array with: (SelfNode value: #self))
                                    )
                                )

                }
    ].
    trampolineTree := MethodNode new
        arguments: args;
        selector: (TrampolineSelectors at: aNumber + 1);
        statements:
            (Array with: (ReturnNode expression: sendTree));
        yourself.

    compiler := ByteCodeCompiler new.
    compiler methodClass: Method.
    trampoline := compiler
                    compileTree: trampolineTree
                    forClass: javaClass
                    ifFail:[self error: 'Failed to compile tampoline'].
    "Install the trampoline"

    self byteCode: trampoline byteCode.
    self literals: trampoline literals.

%{
    /* Now, try to bind to C-optimized native method */
    __jbindnative(self);
%}.


    "Created: / 31-01-2013 / 12:44:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-03-2013 / 01:39:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethod methodsFor:'queries'!

lineNumberForPC0: pc
    | src name lineNumber |

    src := javaClass source.
    src notNil ifTrue:[
        name := self name.
        src asStringCollection withIndexDo:[:l :lno|
            ((l includesString: 'native') and:[l includesString: name]) ifTrue:[
                lineNumber := lno.
                ^ lineNumber
            ].
        ].
    ].
    lineNumber := 1.
    ^ lineNumber

    "Created: / 08-08-2014 / 07:30:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethod methodsFor:'vm support'!

nativeMethodInvokation
    "Called by the VM when a native method is
     to be executed - old (slow) implementation"

    ^self nativeMethodInvokation: thisContext sender.

    "
     JavaNativeMethod flushAllCachedNativeMethods"

    "Modified: / 27-01-2000 / 13:34:53 / cg"
    "Modified: / 03-11-2011 / 10:47:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-10-2012 / 15:15:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nativeMethodInvokation: context
    "Called by the VM when a native method is
     to be executed.

     'context' is the context of being-invoked native method"

    | sel  mthd  sender nArgs receiverAndArgsAndContext |
    nCalls := (nCalls ? 0) + 1.
    receiverAndArgsAndContext := Array new: (nArgs := context numArgs) + 1"receiver".
    receiverAndArgsAndContext replaceFrom:2 to:1 + nArgs with: context startingAt: context arg1Index.
    receiverAndArgsAndContext at: 1 put: context receiver.



    (mthd := nativeImplementation) isNil ifTrue: [
        sel := self searchNativeImplementation: nArgs.
        mthd := (JavaVM natives class compiledMethodAt: sel).
        (mthd isNil or: [ mthd isLazyMethod ]) ifTrue: [
            sender := context.
            sender sender selector == #noByteCode ifTrue: [
                sender := sender sender.
                sender := sender sender.
                sender := sender sender.
            ].
            ^ JavaVM natives perform: sel withArguments: receiverAndArgsAndContext
        ].
        CacheNativeImplementation ifTrue: [ nativeImplementation := mthd. ]
    ].
    Verbose ifTrue: [Logger log: 'Native method invokation: ' , sel severity: Logger severityDEBUG facility: #JVM].
    ^ mthd
        valueWithReceiver: JavaVM natives
        arguments: receiverAndArgsAndContext
        selector: selector
        search: JavaVM natives class
        sender: nil

    "
     JavaNativeMethod flushAllCachedNativeMethods"

    "Created: / 27-10-2012 / 15:13:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2015 / 14:06:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethod class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaNativeMethod.st,v 1.20 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaNativeMethod.st,v 1.20 2015-03-20 12:08:00 vrany Exp $'
!

version_SVN
    ^ 'Id'

! !


JavaNativeMethod initialize!
