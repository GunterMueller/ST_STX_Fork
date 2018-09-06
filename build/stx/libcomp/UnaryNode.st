"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

MessageNode subclass:#UnaryNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!UnaryNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    node for parse-trees, representing unary messages
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!UnaryNode class methodsFor:'instance creation'!

receiver:r selector:s
    "return a new UnaryNode for sending selector s to receiver r.
     Fold constants."

    ^ self receiver:r selector:s fold:true
!

receiver:r selector:selectorString fold:folding
    "return a new UnaryNode for sending selector selectorString to receiver r.
     If folding is true, fold constant expressions."

    |result recVal selector canFold globalName caughtErrorMessage|

"
    The constant folding code can usually not optimize things - this may change
    when some kind of constant declaration is added to smalltalk.
"

    canFold := false.

    (folding notNil and:[folding ~~ false]) ifTrue:[
        selector := selectorString asSymbolIfInterned.
        selector notNil ifTrue:[
            "/
            "/ do constant folding ...
            "/ evaluate at compile time:
            "/      Character tab
            "/      Character cr
            "/          ...
            "/      Float pi
            "/      Float e
            "/          ...
            "/      String cr
            "/      String crlf
            "/          ...
            "/      #(...) asFloatArray

            r isGlobal ifTrue:[
                globalName := r name.
                recVal := r evaluate.

                (globalName = 'Character') ifTrue:[
                    ( #( tab cr lf return space backspace esc ) includes:selector)
                    ifTrue:[
                        canFold := true
                    ]
                ].
                (globalName = 'Float') ifTrue:[
                    ( #( pi e NaN unity zero ) includes:selector)
                    ifTrue:[
                        (recVal respondsTo:selector) ifTrue:[
                            canFold := true
                        ]
                    ]
                ].
                (globalName = 'String') ifTrue:[
                    ( #( cr crlf lf ) includes:selector)
                    ifTrue:[
                        (recVal respondsTo:selector) ifTrue:[
                            canFold := true
                        ]
                    ]
                ].

"/ no, this 'optimization' is not good -
"/ if bytecode is transported to another machine.
"/ However, the JIT compiler compensates for this ;-)
"/                (globalName = 'Smalltalk') ifTrue:[
"/                    ( #( isSmalltalkX isVisualWorks isSqueak
"/                         isSmalltalkMT isDolphinSmalltalk isVisualAge
"/                         isSmalltalkV) includes:selector)
"/                    ifTrue:[
"/                        (recVal respondsTo:selector) ifTrue:[
"/                            canFold := true
"/                        ]
"/                    ]
"/                ].

"/ no, this 'optimization' is not good -
"/ if bytecode is transported to another machine.
"/ However, the JIT compiler compensates for this ;-)
"/                (globalName = 'SmallInteger') ifTrue:[
"/                    ( #( minVal maxVal ) includes:selector)
"/                    ifTrue:[
"/                        (recVal respondsTo:selector) ifTrue:[
"/                            canFold := true
"/                        ]
"/                    ]
"/                ]
            ].

            r isConstant ifTrue:[
                "check if we can do it ..."
                recVal := r evaluate.

                "
                 we could do much more here - but then, we need a dependency from
                 the folded selectors method to the method we generate code for ...
                 limit optimizations to those that will never change
                 (or, if you change them, it will crash badly anyway ...)
                "
                recVal respondsToArithmetic ifTrue:[
                    (#( negated abs asPoint degreesToRadians radiansToDegrees
                        exp ln log sqrt reciprocal
                        arcCos arcSin arcTan sin cos tan) includes:selector)
                    ifTrue:[
                        canFold := true
                    ]
                ].
                recVal isCharacter ifTrue:[
                    (#( asciiValue asInteger digitValue asString) includes:selector)
                    ifTrue:[
                        canFold := true
                    ]
                ].
                recVal isString ifTrue:[
                    (selector == #withCRs) ifTrue:[
                        canFold := folding isSymbol
                                   and:[(folding >= #level2) or:[folding == #full]]
                    ].
                    (selector == #size) ifTrue:[
                        canFold := folding isSymbol
                                   and:[(folding >= #level1) or:[folding == #full]]
                    ].
                    (selector == #asSymbol) ifTrue:[
                        canFold := folding isSymbol
                                   and:[(folding >= #level1) or:[folding == #full]]
                    ].
                ].
                (recVal isMemberOf:Array) ifTrue:[
                    (#(asFloatArray asDoubleArray) includes:selector) ifTrue:[
                        canFold := folding isSymbol
                                   and:[(folding >= #level2) or:[folding == #full]]
                    ]
                ]
            ]
        ].

        canFold ifTrue:[
            (recVal respondsTo:selector) ifTrue:[
                SignalSet anySignal "Number domainErrorSignal" handle:[:ex |
                    "in case of an error, abort fold and return original"
                    caughtErrorMessage := ex description.
                    ex return
                ] do:[
                    result := recVal perform:selector.
                    ^ ConstantNode type:(ConstantNode typeOfConstant:result) value:result
                ].
                "when we reach here, something went wrong (something like 0.0 log)"
                ^ ParseErrorNode 
                    errorString:(caughtErrorMessage,' - error occurred while evaluating constant expression')
            ].
        ].
    ].

    ^ (self basicNew) receiver:r selector:selectorString args:nil lineno:0

    "Modified: / 03-07-2017 / 13:56:31 / cg"
! !

!UnaryNode methodsFor:'accessing'!

selectorPartPositions
    selectorPartPositions isNil ifTrue:[
        selectorPartPositions := Array with: (selectorPosition to: selectorPosition + selector size - 1).
    ].
    ^ selectorPartPositions

    "Created: / 19-10-2013 / 23:48:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnaryNode methodsFor:'checks'!

plausibilityCheckIn:aParser
    "check for funny selector - careful to do string compare instead
     of symbol identity compare: I don't want to introduce these as symbols
     into the system (would make the '... is nowhere implemented' warning
     go away.
     TODO: rewite to use lint/lint rules and apply them before accepting"

    |selectorSymbol|

    "JV@2012-07-06: Do not check if receiver is Java package,
     otherwise it reports false-positives when working with Java code"
    receiver isJavaPackageReference ifTrue:[ ^ nil ].

    selectorSymbol := selector asSymbolIfInterned.
    selectorSymbol notNil ifTrue:[
        ((selectorSymbol == #self) or:[
         (selectorSymbol == #super) or:[
         (selectorSymbol == #thisContext) or:[
         (selectorSymbol == #nil) or:[
         (selectorSymbol == #true) or:[
         (selectorSymbol == #false)]]]]]) 
        ifTrue:[
            (aParser alreadyWarnedUnimplementedSelectors includes:selectorSymbol) ifFalse:[
                aParser alreadyWarnedUnimplementedSelectors add:selectorSymbol.
                ^ 'funny selector: ',selectorSymbol allBold,'; possible missing ''.'' or keyword-colon.'
            ].
        ].

        (Smalltalk includesKey:selectorSymbol) ifTrue:[
            ( #( void ) includes:selectorSymbol) ifFalse:[
                (aParser alreadyWarnedUnimplementedSelectors includes:selectorSymbol) ifFalse:[
                    aParser alreadyWarnedUnimplementedSelectors add:selectorSymbol.
                    ^ 'funny selector: ',selectorSymbol allBold,' (known as global); possible missing ''.'' or keyword-colon.'
                ].
            ].
        ].
    ].

    "
     more to come 
     ...
    "

    ^ super plausibilityCheckIn:aParser

    "Modified: / 16-07-2006 / 16:16:25 / cg"
    "Modified: / 06-07-2012 / 10:46:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnaryNode methodsFor:'code generation'!

codeOn:aStream inBlock:b for:aCompiler
    "append bytecode for the receiver to aStream."

    |rSel notSelector|

    "
     optimize 
        (a == b) not -> (a ~~ b)
        (a ~~ b) not -> (a == b)
    "
    (selector == #not) ifTrue:[
        (receiver class == BinaryNode) ifTrue:[
            ((rSel := receiver selector) == #==) ifTrue:[
                notSelector := #~~
            ] ifFalse:[
                (rSel == #~~) ifTrue:[
                    notSelector := #==
                ]
            ].
            notSelector notNil ifTrue:[
                aCompiler addLiteral:selector; addLiteral:rSel.

                (BinaryNode 
                        receiver:(receiver receiver)
                        selector:notSelector
                        arg:(receiver arg)) 
                    codeOn:aStream 
                    inBlock:b 
                    for:aCompiler.
                ^ self
            ]
        ]
    ].

    ^ super codeOn:aStream inBlock:b for:aCompiler

    "Modified: / 05-03-2007 / 15:11:35 / cg"
! !

!UnaryNode methodsFor:'evaluation'!

evaluateIn:anEnvironment
    "evaluate the expression represented by the receiver"

    |r|

    selector := selector asSymbol.
    receiver isSuper ifTrue:[
        ^ super evaluateIn:anEnvironment
    ].
    r := receiver evaluateIn:anEnvironment.
    selector == #class ifTrue:[
        ^ r class.
    ].
    ^ r perform:selector

    "Modified: / 04-06-2007 / 17:46:31 / cg"
! !

!UnaryNode methodsFor:'printing & storing'!

printOn:aStream indent:i 
    "prettyprint the expression represented by the receiver"
    
    receiver printOn:aStream indent:i parenthized:(receiver precedence < self precedence).
    aStream space.
    selector printString printOn:aStream.

    "Modified: / 20-04-2005 / 14:36:26 / cg"
! !

!UnaryNode methodsFor:'queries'!

precedence
    ^ 100

    "Created: / 20-04-2005 / 14:10:34 / cg"
! !

!UnaryNode methodsFor:'testing'!

isJavaPackageReference
    "Return true, given node is JAVA class reference in form:
        JAVA package1 package2
    "

    ^receiver isJavaPackageReference 
        and:[selector isLowercaseFirst
            and:[selector isUnarySelector]]

    "Created: / 19-04-2012 / 09:52:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-06-2017 / 06:57:49 / cg"
!

isUnaryMessage
    "return true, if this node is one for a unary message"

    ^ true

    "Modified: 23.10.1997 / 02:05:18 / cg"
! !

!UnaryNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitUnaryNode:self
! !

!UnaryNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

