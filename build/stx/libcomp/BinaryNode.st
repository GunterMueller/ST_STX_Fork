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

MessageNode subclass:#BinaryNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!BinaryNode class methodsFor:'documentation'!

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
    node for parse-trees, representing binary message sends
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger

"
! !

!BinaryNode methodsFor:'accessing'!

arg
    ^ argArray at:1
! !

!BinaryNode methodsFor:'checks'!

plausibilityCheckIn:aParser
    "check for possible precedence error and bad variable name in artihmetic expressions
     TODO: rewite to use lint/lint rules and apply them before accepting"

    |rSelector arg1 checkBadVarName|

    "/ using +/- in an expression without grouping
    ( #( #'*' #'/' #'//' #'\' #'\\' ) includes:selector) ifTrue:[
        receiver isMessage ifTrue:[
            receiver parenthesized ifFalse:[
                rSelector := receiver selector.
                ( #( #'+' #'-') includes:rSelector) ifTrue:[
                    ^ 'possible precedence error - use parentheses to make evaluation order explicit.'
                ].
            ].
        ].
    ].

    ( #( #'*' #'/' #'//' #'\' #'\\' #'+' #'-' 
         #'<' #'>' #'<=' #'>=' #'=' #'~=' #'==' #'~~') includes:selector) ifTrue:[
        arg1 := self arg1.
        
        checkBadVarName := 
            [:expr1 :expr2 |
                expr1 isVariable and:[ expr1 name = 'l' 
                and:[ expr2 isLiteral and:[ (expr2 value isSymbol or:[expr2 value isString]) not]]]
            ].
        ((checkBadVarName value:receiver value:arg1)
        or:[ checkBadVarName value:arg1 value:receiver]) ifTrue:[
            ^ 'using short names is bad by itself, 
but using "l" which looks almost like "1" is even worse. 
Please change to something like "length" or "lengthOfX".'
        ]
    ].

    ^ super plausibilityCheckIn:aParser.

    "Modified: / 17-05-2017 / 18:25:48 / mawalch"
    "Modified: / 20-06-2017 / 10:45:59 / cg"
! !

!BinaryNode methodsFor:'code generation'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    "generate code for this statement - value not needed"

    (selector == #= 
    or:[selector == #~=
    or:[selector == #==]]) ifTrue:[
        receiver isVariable ifTrue:[
            aCompiler 
                warning:'possible typing error: ''='' instead of '':=''' 
                position:selectorPosition to:selectorPosition.
        ]
    ].

    ^ super codeForSideEffectOn:aStream inBlock:b for:aCompiler

    "Created: 5.8.1997 / 02:32:55 / cg"
    "Modified: 5.8.1997 / 02:50:18 / cg"
!

codeOn:aStream inBlock:b for:aCompiler
    |arg1 recVal argVal code|

    selector := selector asSymbol.

    receiver isSuper ifFalse:[
        (aCompiler isBuiltInSelector:selector forReceiver:receiver) ifTrue:[
            arg1 := argArray at:1.

            receiver isConstant ifTrue:[
                recVal := receiver value.
                (receiver type == #Integer) ifTrue:[
                    ((selector == #==) or:[selector == #~~]) ifTrue:[
                        recVal == 0 ifTrue:[
                            arg1 codeOn:aStream inBlock:b for:aCompiler.
                            (selector == #==) ifTrue:[
                                code := #eq0
                            ] ifFalse:[
                                code := #ne0
                            ].
                            aStream nextPut:code.
                            ^ self
                        ]
                    ].
                ].

                recVal == nil ifTrue:[
                    ((selector == #==) or:[selector == #~~]) ifTrue:[
                        arg1 codeOn:aStream inBlock:b for:aCompiler.
                        (selector == #==) ifTrue:[
                            code := #isNil 
                        ] ifFalse:[
                            code := #notNil 
                        ].
                        aStream nextPut:code. 
                        ^ self
                    ]
                ].

                "/ disabled this, since it is confusing if the error is reported
                "/ by the argument as receiver (i.e. transforms 1+foo into foo+1)
                "/ and it might also be incorrect.
                "/ correct would be to encode it with a reverse-plus1 opCode,
                "/ which checks for int/float args and does a reverse send as fallback.
                "/ The jitter does that already, so we don't care on the bytecode level.
"/                (selector == #+) ifTrue:[
"/                    (recVal == 1) ifTrue:[
"/                        arg1 codeOn:aStream inBlock:b for:aCompiler.
"/                        aStream nextPut:#plus1; nextPut:lineNr.
"/                        ^ self
"/                    ]
"/                ]
            ].

            receiver codeOn:aStream inBlock:b for:aCompiler.
            arg1 isConstant ifTrue:[
                argVal := arg1 value.
                (arg1 type == #Integer) ifTrue:[
                    ((selector == #==) or:[selector == #~~]) ifTrue:[
                        (argVal == 0) ifTrue:[
                            (selector == #==) ifTrue:[
                                code := #eq0
                            ] ifFalse:[
                                code := #ne0
                            ].
                            aStream nextPut:code.
                            ^ self
                        ]
                    ].
                    selector == #> ifTrue:[
                        argVal == 0 ifTrue:[ 
                            lineNr >= 255 ifTrue:[
                                self codeLineNumber: lineNr on: aStream for: aCompiler.  
                            ].
                            aStream nextPut:#gt0; nextPut:lineNr.
                            ^ self
                        ]
                    ].
                    ((selector == #+) or:[selector == #-]) ifTrue:[
                        (argVal == 1) ifTrue:[
                            (selector == #+) ifTrue:[
                                code := #plus1
                            ] ifFalse:[
                                code := #minus1
                            ].
                            lineNr >= 255 ifTrue:[
                                self codeLineNumber: lineNr on: aStream for: aCompiler.  
                            ].
                            aStream nextPut:code; nextPut:lineNr.
                            ^ self
                        ]
                    ]
                ].
                argVal isNil ifTrue:[
                    (selector == #==) ifTrue:[
                        aStream nextPut:#isNil.
                        ^ self
                    ].
                    (selector == #~~) ifTrue:[
                        aStream nextPut:#notNil.
                        ^ self
                    ].
                ]
            ].
            arg1 codeOn:aStream inBlock:b for:aCompiler.
            lineNr >= 255 ifTrue:[
                self codeLineNumber: lineNr on: aStream for: aCompiler.  
            ].
            aStream nextPut:selector.
            (aCompiler hasLineNumber:selector) ifTrue:[
                aStream nextPut:lineNr.
            ].
            ^ self
        ]
    ].
    ^ super codeOn:aStream inBlock:b for:aCompiler

    "Modified: / 04-07-1999 / 19:05:13 / cg"
    "Modified: / 13-04-2013 / 11:08:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BinaryNode methodsFor:'evaluation'!

evaluateIn:anEnvironment

    selector := selector asSymbol.

    receiver isSuper ifTrue:[
        ^ super evaluateIn:anEnvironment
    ].
    ^ (receiver evaluateIn:anEnvironment) 
        perform:selector 
        with:((argArray at:1) evaluateIn:anEnvironment)
! !

!BinaryNode methodsFor:'printing & storing'!

printOn:aStream indent:i 
    |arg|

    receiver printOn:aStream indent:i parenthized:(receiver precedence < self precedence).
    aStream space.
    self printSelectorOn:aStream.
    aStream space.
    arg := self arg.
    arg printOn:aStream indent:i + 4 parenthized:(arg precedence <= self precedence).

    "Modified: / 20-04-2005 / 14:31:43 / cg"
!

printSelectorOn:aStream
    selector printString printOn:aStream.
! !

!BinaryNode methodsFor:'queries'!

precedence
    ^ 50

    "Created: / 20-04-2005 / 14:10:44 / cg"
! !

!BinaryNode methodsFor:'testing'!

isBinaryMessage
    ^ true
! !

!BinaryNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitBinaryNode:self
! !

!BinaryNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

