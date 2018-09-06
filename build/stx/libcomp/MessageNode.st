"{ Encoding: utf8 }"

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

ParseNode subclass:#MessageNode
	instanceVariableNames:'receiver selector argArray lineNr selectorPosition lines
		endLineNr endCharPosition selectorPartPositions'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!MessageNode class methodsFor:'documentation'!

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
    node for parse-trees, representing message sends
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!MessageNode class methodsFor:'instance creation'!

receiver:recNode selector:selectorString 
    ^ self receiver:recNode selector:selectorString args:nil lineno:0

    "Modified: / 26-03-2018 / 15:34:28 / stefan"
!

receiver:recNode selector:selectorString arg1:arg1Node arg2:arg2Node
    ^ self receiver:recNode selector:selectorString arg1:arg1Node arg2:arg2Node fold:nil
!

receiver:recNode selector:selectorString arg1:argNode1 arg2:argNode2 fold:folding
    |result recVal argVal selector cls|

    "
     This is just a demonstration - of how complex constants can be folded.
     This was inspired by some discussion in c.l.s about enhancing the language - I prefer
     enhancing the compiler ....
     The following optimization will convert '#(...) with:#(...) collect:[...]' into an array constant,
     allowing constant arrays of complex objects.

     Notice: this method is normally disabled - its just a demo after all.
    "
    folding notNil ifTrue:[
        "/
        "/ do constant folding ...
        "/
        (recNode isConstant and:[argNode1 isConstant]) ifTrue:[
            "check if we can do it ..."
            selector := selectorString asSymbolIfInterned.
            selector notNil ifTrue:[
                recVal := recNode evaluate.
                (recVal respondsTo:selector) ifTrue:[
                    "
                     we could do much more here - but then, we need a dependency from
                     the folded selectors method to the method we generate code for ...
                     limit optimizations to those that will never change
                     (or - if you change them - you will crash so bad ...)
                    "
                    argVal := argNode1 evaluate.
                    ((recVal isMemberOf:Array) and:[argVal isMemberOf:Array]) ifTrue:[
                        folding == #full ifTrue:[
                            (selector == #with:collect:) ifTrue:[
                                (argNode2 isBlock) ifTrue:[
                                    SignalSet anySignal handle:[:ex |
                                        ^ ParseErrorNode errorString:'error in constant expression (' , ex description , ')'
                                    ] do:[
                                        result := recVal perform:selector with:argVal with:(argNode2 evaluate).
                                    ].
                                    ^ ConstantNode type:(ConstantNode typeOfConstant:result) value:result
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ].

    cls := self.
    cls == MessageNode ifTrue:[
        "if sent to MessageNode (and not a concrete class), create concrete nodes"
        selectorString isUnarySelector ifTrue:[
            cls := UnaryNode.
        ] ifFalse:[selectorString isBinarySelector ifTrue:[
            cls := BinaryNode.
        ]].
    ].

    ^ self receiver:recNode selector:selectorString args:(Array with:argNode1 with:argNode2) lineno:0

    "Modified: / 28-06-1997 / 15:16:01 / cg"
    "Modified: / 26-03-2018 / 15:34:14 / stefan"
!

receiver:recNode selector:selectorString arg:argNode
    ^ self receiver:recNode selector:selectorString arg:argNode fold:nil
!

receiver:recNode selector:selectorString arg:argNode fold:folding
    |result recVal argVal selector globalName canFold|

   "
     The constant folding code can usually not optimize much
     - this may change when some kind of constant/macro declaration is added to smalltalk,
     so that constant classVars can be inlined.
    "
    (folding notNil and:[ folding ~~ false]) ifTrue:[
        selector := selectorString asSymbolIfInterned.
        selector notNil ifTrue:[

            "/
            "/ do constant folding ...
            "/
            canFold := false.

            (recNode isGlobal and:[argNode isConstant]) ifTrue:[
                globalName := recNode name.
                recVal := recNode evaluate.

                (globalName = 'SmallInteger') ifTrue:[
                    ( #( bitMaskFor: ) includes:selector)
                    ifTrue:[
                        canFold := true
                    ]
                ].
            ].

            (recNode isConstant and:[argNode isConstant]) ifTrue:[
                "check if we can do it ..."
                recVal := recNode evaluate.
                "
                 we could do much more here - but then, we need a dependency from
                 the folded selectors method to the method we generate code for ...
                 limit optimizations to those that will never change
                 (or - if you change them - you will crash so bad ...)
                "
                argVal := argNode evaluate.
                (recVal respondsToArithmetic and:[argVal respondsToArithmetic]) ifTrue:[
                    ( #( + - * / // \\ min: max: quo: raisedTo:) includes:selector) ifTrue:[
                        (#( / // \\ ) includes:selector) ifTrue:[
                            argVal = 0 ifTrue:[
                                ^ ParseErrorNode errorString:'division by zero in constant expression'
                            ].
                        ].
                        canFold := true
                    ].
                    ( #( @ ) includes:selector) ifTrue:[
                        canFold := (folding == #full)
                    ]
                ].
                (recVal isInteger and:[argVal isInteger]) ifTrue:[
                    ( #( bitShift: bitOr: bitAnd: ) includes:selector) ifTrue:[
                        canFold := true
                    ]
                ].
                (recVal isSingleByteString) ifTrue:[
                    (argVal isInteger and:[selector == #at:]) ifTrue:[
                        canFold := folding isSymbol
                                   and:[(folding >= #level2) or:[folding == #full]].
                    ].
                    selector == #',' ifTrue:[
                        (argVal isSingleByteString) ifTrue:[
                            canFold := folding isSymbol
                                       and:[(folding >= #level2) or:[folding == #full]].
                        ].
                        (argVal isMemberOf:Character) ifTrue:[
                            canFold := folding isSymbol
                                       and:[(folding >= #level2) or:[folding == #full]].
                        ].
                    ]
                ].
            ].

            canFold ifTrue:[
                (recVal respondsTo:selector) ifTrue:[
                    SignalSet anySignal handle:[:ex |
                        ^ ParseErrorNode errorString:'error in constant expression (' , ex description , ')'
                    ] do:[
                        result := recVal perform:selector with:argVal.
                    ].
                    ^ ConstantNode type:(ConstantNode typeOfConstant:result) value:result
                                   from: recNode startPosition to: argNode endPosition
                ]
            ]
        ].

        "/
        "/ #perform with a constant selector
        "/
        (selector == #perform: 
        and:[argNode isConstant]) ifTrue:[
            argVal := argNode evaluate.
            argVal isSymbol ifTrue:[
                ^ (UnaryNode receiver:recNode selector:argVal fold:folding)
                    startPosition: recNode startPosition endPosition: argNode endPosition.

            ]
        ].
    ].

    ^ self receiver:recNode selector:selectorString args:(Array with:argNode) lineno:0

    "Modified: / 16-11-1999 / 21:50:33 / cg"
    "Modified: / 01-08-2011 / 12:31:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2018 / 15:34:03 / stefan"
!

receiver:recNode selector:selectorString args:anArray
    ^ self receiver:recNode selector:selectorString args:anArray fold:nil
!

receiver:recNode selector:selectorString args:argArray fold:folding
    |numArgs arg1 arg1Val|

    folding notNil ifTrue:[
        numArgs := argArray size.
        numArgs > 0 ifTrue:[
            arg1 := (argArray at:1).
            (numArgs == 1) ifTrue:[
                ^ self receiver:recNode selector:selectorString arg:arg1 fold:folding 
            ].

            "/
            "/ #perform:... with a constant selector
            "/
            numArgs <= 6 ifTrue:[
                (#(nil
                   #'perform:with:'
                   #'perform:with:with:'
                   #'perform:with:with:with:'
                   #'perform:with:with:with:with:'
                   #'perform:with:with:with:with:with:'
                   #'perform:with:with:with:with:with:with:'
                ) at:numArgs) = selectorString 
                ifTrue:[
                    arg1 isConstant ifTrue:[    
                        arg1Val := arg1 evaluate.
                        arg1Val isSymbol ifTrue:[
                            ^ MessageNode 
                                    receiver:recNode 
                                    selector:arg1Val
                                    args:(argArray copyFrom:2)
                                    fold:folding
                        ]
                    ]
                ]
            ].
        ].

        (numArgs == 2) ifTrue:[
            ^ self receiver:recNode selector:selectorString arg1:arg1 arg2:(argArray at:2) fold:folding 
        ].
        numArgs > Method maxNumberOfArguments ifTrue:[
            ^ ParseErrorNode errorString:'too many arguments for current VM implementation'.
        ].
    ].

    ^ self receiver:recNode selector:selectorString args:argArray lineno:0

    "Modified: / 03-09-1995 / 16:41:39 / claus"
    "Modified: / 15-05-1998 / 15:32:05 / cg"
    "Modified: / 26-03-2018 / 15:33:42 / stefan"
!

receiver:recNode selector:selectorString args:argArray lineno:lineNo
    |cls|

    cls := self.
    cls == MessageNode ifTrue:[
        "if sent to MessageNode (and not a concrete class), create concrete nodes"
        selectorString isUnarySelector ifTrue:[
            cls := UnaryNode.
        ] ifFalse:[selectorString isBinarySelector ifTrue:[
            cls := BinaryNode.
        ]].
    ].

    ^ cls basicNew receiver:recNode selector:selectorString args:argArray lineno:lineNo

    "Created: / 26-03-2018 / 15:33:29 / stefan"
! !

!MessageNode methodsFor:'accessing'!

arg1
    ^ argArray at:1
!

arg2
    ^ argArray at:2
!

args
    ^ argArray
!

arguments
    ^ argArray ? #()

    "Created: 19.6.1997 / 17:31:14 / cg"
    "Modified: 19.6.1997 / 17:32:25 / cg"
!

endCharPosition
    ^ endCharPosition
!

endCharPosition:something
    endCharPosition := something.
!

endLineNr
    ^ endLineNr
!

endLineNr:something
    endLineNr := something.
!

lineNumber
     ^ lineNr
!

lineNumber:num
    lineNr := num.
    self assert:(lineNr >= 0)
!

lines
    ^ lines
!

lines:something
    lines := something.
!

receiver
    ^ receiver
!

receiver:r selector:s args:a lineno:l

    receiver notNil ifTrue:[ receiver parent: nil].
    receiver := r.
    receiver notNil ifTrue:[
        receiver parent notNil ifTrue:[self breakPoint:#cg].
        receiver parent: self
    ].

    startPosition := receiver startPosition.

"/ create the symbol only, if the symbol is already known in the system.
"/ otherwise a lot of partial symbols will be created by the SyntaxHighlighter
"/ during typing
"/    selector := s asSymbol.

    selector := s asSymbolIfInterned ? s.

    argArray notNil ifTrue:[argArray do:[:each| each parent:nil]].
    argArray := a.
    "JV@2012-04-20: I hate this #Error being returned. We should not
     be lazy to create a new class - ErrorNode. Results in a mess!!"
    argArray ~~ #Error ifTrue:[
        argArray notEmptyOrNil ifTrue:[
            argArray do:[:each| each parent:self].
            endPosition := argArray last endPosition
        ].
    ].

    lineNr := l.
    self assert:(lineNr >= 0).
    self checkInlinability.

    "Modified: / 02-07-1997 / 17:01:24 / cg"
    "Modified: / 08-05-2012 / 17:07:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
    ^ selector
!

selector:s
"/ create the symbol only, if the symbol is already known in the system.
"/ otherwise a lot of partial symbols will be created by the SyntaxHighlighter
"/ during typing
"/    selector := s asSymbol.

    selector := s asSymbolIfInterned ? s.
"/    selector := s asSymbol.
!

selectorPartPositions
    ^ selectorPartPositions
!

selectorPartPositions:something
    selectorPartPositions := something.
!

selectorPosition
    "return the value of the instance variable 'selectorPosition' (automatically generated)"

    ^ selectorPosition

    "Created: 5.8.1997 / 02:49:27 / cg"
!

selectorPosition:something
    "set the value of the instance variable 'selectorPosition' (automatically generated)"

    selectorPosition := something.

    "Created: 5.8.1997 / 02:49:27 / cg"
! !

!MessageNode methodsFor:'checks'!

checkCondition
    "check ifTrue/ifFalse for plausibility.
     TODO: rewite to use lint/lint rules and apply them before accepting"

    |args lastArg receiverSelector or1 or2|

    receiver isBlock ifTrue:[
        (Block canUnderstand:selector) ifFalse:[
            ^ 'blocks usually do not respond to ' , selector , ' messages'
        ].
    ].

    "/ (rr keyw:ra = a) ifTrue:[ ...]

    receiver isMessage ifTrue:[
        (receiver numArgs > 0) ifTrue:[
            receiverSelector := receiver selector.
            (receiverSelector isKeywordSelector) ifTrue:[
                (args := receiver arguments) notEmptyOrNil ifTrue:[
                    (lastArg := args last) isMessage ifTrue:[
                        lastArg parenthesized ifFalse:[
                            (#( #'=' #'~=' #'==' #'~~' '>' '<' '>=' '<=') 
                            includes:(lastArg selector asSymbol)) ifTrue:[
                                ^ 'possible precedence error in condition (missing parenthesis ?)'
                            ]
                        ]
                    ].
                ].

                (selector == #ifFalse: or:[ selector == #ifFalse:ifTrue: ]) ifTrue:[
                    receiverSelector == #or: ifTrue:[
                        or1 := receiver receiver.    
                        or2 := receiver arg1.
                        (or1 isMessage and:[or1 selector = '~~']) ifTrue:[
                            (or2 isBlock 
                            and:[ or2 isSingleExpressionBlock
                            and:[ or2 statements expression isMessage 
                            and:[ or2 statements expression selector = '~~']]]) ifTrue:[
                                ^ 'please use "((...==...) and:[...==...]) ifTrue:" here\\(are you obfuscating by purpose ?)'
                            ].
                        ].
                    ].
                ].
            ]
        ].
    ].

    ^ nil
!

checkGlobalFromNameSpaceConflictFor:aNode
    "check if aNode is a local-nameSpace's variable,
     which hides a global from Smalltalk with the same name.
     This is especially bad for Error handle: do:... 
     TODO: rewite to use lint/lint rules and apply them before accepting"

    |fullName shortName|

    aNode isGlobalVariable ifTrue:[
        fullName := aNode name.
        shortName := (Class nameWithoutPrefix:fullName) asSymbolIfInterned.
        (shortName ~= fullName and:[shortName notNil]) ifTrue:[
            (Smalltalk includesKey:shortName) ifTrue:[
                ^ '\Possible name conflict: local "%1" vs. "Smalltalk::%1"\The value here is %2.\The value in Smalltalk is %3.' 
                    bindWith:shortName
                    with:(Smalltalk at:fullName asSymbol) printString
                    with:(Smalltalk at:shortName) printString.
            ].
        ].
    ].

    ^ nil.

    "Modified: / 08-03-2017 / 12:01:46 / cg"
!

checkIdentityCompare
    "check #== applied to Floats, Strings or Fractions
     TODO: rewite to use lint/lint rules and apply them before accepting"

    |rec arg1 arg1Value operand|

    ((selector == #==) or:[selector == #~~]) ifTrue:[
        (argArray size > 0) ifTrue:[
            arg1 := argArray at:1
        ].

        "
         it once took me almost an hour, to find a '==' which
         should have been an '=' (you cannot compare floats with ==)
         (well, I looked at the '==' at least 50 times -
          - but didn't think about it ...).
         that's reason enough to add this check here.
         I will add more as heuristic knowledge increases ...
         (send me comments on common programming errors...)
        "

        receiver isConstant ifTrue:[
            rec := receiver evaluate.
            ((rec isSingleByteString) or:[
             (rec isMemberOf:Float) or:[
             (rec isMemberOf:Fraction)]]) ifTrue:[
                operand := rec
            ].
        ].
        arg1 isConstant ifTrue:[
            arg1Value := arg1 evaluate.
            ((arg1Value isSingleByteString) or:[
             (arg1Value isMemberOf:Float) or:[
             (arg1Value isMemberOf:Fraction)]]) ifTrue:[
                operand := arg1Value
            ].
        ].
        operand notNil ifTrue:[
            (selector == #==) ifTrue:[
                ^ 'identity compare is unsafe here (will usually return false here. Consider changing to "=")'
            ].
            ^ 'identity compare is unsafe here (will usually return true here. Consider changing to "~=")'
        ]
    ].

    ^ nil

    "Modified: / 08-03-2012 / 01:07:33 / cg"
!

checkInlinability
    "early check for possible inlinability.
     TODO: rewite to use lint/lint rules and apply them before accepting"

    |numArgs arg1 arg2 arg3|

    (numArgs := argArray size) >= 1 ifTrue:[
        arg1 := argArray at:1.
    ].
    numArgs == 0 ifTrue:[
        (selector == #whileTrue 
        or:[selector == #whileFalse]) ifTrue:[
            receiver isBlock ifTrue:[
                receiver possiblyInlined:true
            ].
        ].
        (selector == #value) ifTrue:[
            receiver isBlock ifTrue:[
                receiver possiblyInlined:true
            ].
        ].
        ((selector == #repeat) or:[selector == #loop]) ifTrue:[
            receiver isBlock ifTrue:[
                receiver possiblyInlined:true
            ].
        ].
    ].

    numArgs == 1 ifTrue:[
        (selector == #or: 
        or:[selector == #and:]) ifTrue:[
            arg1 isBlock ifTrue:[
                arg1 possiblyInlined:true
            ].
        ].

        (selector == #ifTrue: 
        or:[selector == #ifFalse:
        or:[selector == #ifNil:
        or:[selector == #ifNotNil:]]]) ifTrue:[
            arg1 isBlock ifTrue:[
                arg1 possiblyInlined:true
            ].
        ].

        (selector == #whileTrue: 
        or:[selector == #whileFalse:]) ifTrue:[
            arg1 isBlock ifTrue:[
                arg1 possiblyInlined:true
            ].
            receiver isBlock ifTrue:[
                receiver possiblyInlined:true
            ].
        ].
        selector == #timesRepeat: ifTrue:[
            arg1 isBlock ifTrue:[
                arg1 possiblyInlined:true withSelector:selector.
            ]
        ].
        ^ self
    ].
    numArgs >= 2 ifTrue:[
        arg2 := argArray at:2.
    ].    
    numArgs == 2 ifTrue:[
        (selector == #ifTrue:ifFalse:
        or:[selector == #ifFalse:ifTrue:
        or:[selector == #ifNil:ifNotNil:
        or:[selector == #ifNotNil:ifNil:]]]) ifTrue:[
            (arg1 isBlock 
            and:[arg2 isBlock]) ifTrue:[
                arg1 possiblyInlined:true.
                arg2 possiblyInlined:true.
            ].
        ].
        selector == #to:do: ifTrue:[
            arg2 isBlock ifTrue:[
                arg2 possiblyInlined:true withSelector:selector.
            ].
        ].
        ^ self
    ].
    numArgs >= 3 ifTrue:[
        arg3 := argArray at:3.
    ].    
    numArgs == 3 ifTrue:[
        selector == #to:by:do: ifTrue:[
            arg3 isBlock ifTrue:[
                arg3 possiblyInlined:true withSelector:selector.
            ].
        ].
        ^ self
    ].
    ^ self

    "Created: / 2.7.1997 / 17:01:10 / cg"
    "Modified: / 2.4.1998 / 19:08:54 / cg"
!

plausibilityCheckIn:aParser
    "some useful checks applied when accepting in a browser.
     TODO: rewite to use lint/lint rules and apply them before accepting"

    |arg1 msg|

    (argArray size > 0) ifTrue:[
        arg1 := argArray at:1
    ].

    "
     check #== applied to Floats, Strings or Fractions
    "
    ((selector == #==) or:[selector == #~~]) ifTrue:[
        (msg := self checkIdentityCompare) notNil ifTrue:[^ msg].
    ].

    "
     [...] ifTrue:...
     an error often occuring when you are a beginner ...
    "
    ((selector == #ifTrue:) or:[selector == #ifFalse:]) ifTrue:[
        (msg := self checkCondition) notNil ifTrue:[^ msg].
    ].
    ((selector == #ifTrue:ifFalse:) or:[selector == #ifFalse:ifTrue:]) ifTrue:[
        (msg := self checkCondition) notNil ifTrue:[^ msg].
    ].

    "
     (...) whileTrue:[
    "
    ((selector == #whileTrue:) or:[selector == #whileFalse:]) ifTrue:[
        (receiver isBlock not and:[ receiver parenthesized ]) ifTrue:[
            "/ only warn, if code was originally parenthized
            ^ 'will fail at runtime, if receiver of ' , selector , ' does not evaluate to a block or respond reasonable to #value'
        ].
        arg1 isBlock ifFalse:[
            ^ 'will fail at runtime, if argument to ' , selector , ' does not evaluate to a block or respond reasonable to #value'
        ].
    ].

    "
     [...] ensure:[...]
    "
    ((selector == #ensure:) or:[(selector == #ifCurtailed:)]) ifTrue:[
        (receiver isBlock not and:[ receiver parenthesized ]) ifTrue:[
            "/ only warn, if code was originally parenthized
            ^ 'will fail at runtime, if receiver of ' , selector , ' does not evaluate to a block or respond reasonable to #value'
        ].
        (arg1 isBlock not and:[ arg1 parenthesized ]) ifTrue:[
            ^ 'will fail at runtime, if receiver of ' , selector , ' does not evaluate to a block or respond reasonable to #value'
        ].
        (arg1 isBlock and:[arg1 isEmptyBlock]) ifTrue:[
            ^ 'useless ensure (empty block)'
        ].
    ].

    argArray size > 0 ifTrue:[
        "/ check for a beginners error (using super as arg)
        "/ as in (something ? super) foo
        "/ let him know, that this will not be a "super foo"
        argArray do:[:arg | 
            arg isSuper ifTrue:[
                ^ 'super special semantic only with receiver of message sends'
            ]
        ].
    ].

    (selector = #'handle:do:' 
    or:[ selector = #'handle:from:do:'
    or:[ selector = #'ignoreIn:'
    or:[ selector = #'catch:' ]]]) ifTrue:[
        (msg := self checkGlobalFromNameSpaceConflictFor:receiver) notNil ifTrue:[^ msg].
    ].
    (selector = #'on:do:'
    or:[ selector = #'on:do:ensure:'
    or:[ selector = #'on:do:ifCurtailed:'
    or:[ selector = #'on:do:on:do:' ]]]) ifTrue:[
        (msg := self checkGlobalFromNameSpaceConflictFor:arg1) notNil ifTrue:[^ msg].
    ].

"/    receiver isBlock ifTrue:[
"/        ([] respondsTo:selector) ifFalse:[
"/            ^ 'blocks do not respond to ' , selector , '; Missing ''.'' between statements ?'
"/        ].
"/    ].

    ^ nil

    "Modified: / 28-03-2007 / 14:14:28 / cg"
    "Modified (format): / 08-03-2017 / 11:36:03 / cg"
! !

!MessageNode methodsFor:'code generation'!

codeOn:aStream inBlock:b for:aCompiler
    self codeOn:aStream inBlock:b valueNeeded:true for:aCompiler
!

codeOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "most work is in checking for inlinable code here."

    |recType nargs isBuiltIn litIndex cls clsLitIndex code isSpecial
     specialCode stackTop arg1 arg2 arg3 isSuper realReceiver 
     noSendDrop alreadyDropped
     useSelfSend usedSelector|

    selector := selector asSymbol.
    usedSelector := aCompiler nameSpaceSelectorFor:selector.

    "/ must be added for browsers-search to work on optimized nodes
    usedSelector ~~ selector ifTrue:[ aCompiler addLiteral:selector ].
    litIndex := aCompiler addLiteral:usedSelector.

    noSendDrop := aCompiler class newCodeSet == true.

    realReceiver := self realReceiver.
    isSuper := realReceiver isSuper.

    argArray isNil ifTrue:[
        nargs := 0
    ] ifFalse:[
        nargs := argArray size.
        nargs > 0 ifTrue:[
            arg1 := argArray at:1.
            nargs > 1 ifTrue:[
                arg2 := argArray at:2.
                nargs > 2 ifTrue:[
                    arg3 := argArray at:3.
                ]
            ]    
        ].
    ].

    recType := receiver type.

    (nargs == 0) ifTrue:[
        (recType == #ThisContext) ifTrue:[
            valueNeeded ifFalse:[
                "for now, only do it in methods"
                b isNil ifTrue:[
                    (selector == #restart) ifTrue:[
                        aStream nextPut:#jump; nextPut:1.      "jump to start"
                        ^ self
                    ].
                ].
                (selector == #return) ifTrue:[  "^ nil"
                    aStream nextPut:#retNil.
                    ^ self
                ].
            ].
            "/ aCompiler rememberContextReturnablePragma
        ].

        (receiver isBlock 
        and:[receiver numArgs == 0
        and:[receiver isInlinable]]) ifTrue:[
            selector == #value ifTrue:[
                receiver codeInlineOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ^ self
            ].
            ((selector == #whileTrue) or:[selector == #whileFalse]) ifTrue:[
                ^ self codeWhileOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
            ].
            ((selector == #repeat) or:[selector == #loop]) ifTrue:[
                valueNeeded ifFalse:[
                    ^ self codeRepeatOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ]
            ].
        ].
        
        "/ this optimization is for javaScript where we have to write "foo".asSymbol()
        selector == #asSymbol ifTrue:[
            (receiver isConstant and:[receiver evaluate isString]) ifTrue:[
                (ConstantNode value:receiver evaluate asSymbol) codeOn:aStream inBlock:b for:aCompiler.
                ^ self
            ].    
        ].    
    ].

    (nargs == 1) ifTrue:[
        (recType == #ThisContext) ifTrue:[
            (selector == #return:) ifTrue:[
                arg1 codeOn:aStream inBlock:b for:aCompiler.  "^ value"
                aStream nextPut:#retTop.
                valueNeeded ifTrue:[
                    "/ although we know, that it is useless, we generate a push-nil
                    "/ to make any stack-checkers happy (caller will generate a pop).
                    aStream nextPut:#pushNil.
                ].
                ^ self.
             ].
        ].

        ((selector == #ifNil:) or:[selector == #ifNotNil:]) ifTrue:[
            receiver isBlock ifFalse:[
                (arg1 isBlock not
                or:[arg1 numArgs == 0]) ifTrue:[
                    ^ self codeIfNilOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ].
                (arg1 isConstant or:[arg1 isVariable]) ifTrue:[
                    ^ self codeIfNilOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ].

            ].
        ].

        (arg1 isBlock 
        and:[arg1 isInlinable
        and:[arg1 numArgs == 0]]) ifTrue:[
            ((selector == #ifTrue:) or:[selector == #ifFalse:]) ifTrue:[
                receiver isBlock ifFalse:[
                    ^ self codeIfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ].
            ].

            (selector == #or:) ifTrue:[
                ^ self codeOrOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
            ].

            (selector == #and:) ifTrue:[
                ^ self codeAndOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
            ].

            (selector == #timesRepeat:) ifTrue:[
                "/ now, always inline #timesRepeat:;
                "/ the receiver must understand #> and #-

               ^ self codeTimesRepeatOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
            ].

            ((selector == #whileTrue:) or:[selector == #whileFalse:]) ifTrue:[
                (receiver isBlock 
                and:[receiver isInlinable
                and:[receiver numArgs == 0]]) ifTrue:[
                    ^ self codeWhileOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ]
            ]
        ].

        ((selector == #ifTrue:) or:[selector == #ifFalse:]) ifTrue:[
            (arg1 isConstant or:[arg1 isVariable]) ifTrue:[
                ^ self codeIfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
            ].
        ].

        usedSelector == #? ifTrue:[
            "/ only do short-circuit optimization, if arg is not a message;
            "/ (could have side-effects)
            "/
            arg1 isMessage ifFalse:[
                ^ self codeQuestOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
            ]
        ].
        (selector == #caseOf:) ifTrue:[
            (self codeCaseOfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler) ifTrue:[
                ^ self
            ].
        ].
    ].

    (nargs == 2) ifTrue:[
        receiver isBlock ifFalse:[
            (arg1 isBlock 
            and:[arg1 isInlinable
            and:[arg1 numArgs == 0
            and:[arg2 isBlock 
            and:[arg2 isInlinable
            and:[arg2 numArgs == 0]]]]]) ifTrue:[
                ((selector == #ifTrue:ifFalse:) or:[selector == #ifFalse:ifTrue:]) ifTrue:[
                    ^ self codeIfElseOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ].
                ((selector == #ifNil:ifNotNil:) or:[selector == #ifNotNil:ifNil:]) ifTrue:[
                    ^ self codeIfNilNotNilOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ]
            ].

            ((arg1 isConstant or:[arg1 isVariable])
            and:[arg2 isConstant or:[arg2 isVariable]]) ifTrue:[
                ((selector == #ifTrue:ifFalse:) or:[selector == #ifFalse:ifTrue:]) ifTrue:[
                    ^ self codeIfElseOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ].
                ((selector == #ifNil:ifNotNil:) or:[selector == #ifNotNil:ifNil:]) ifTrue:[
                    ^ self codeIfNilNotNilOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ]
            ].
        ].
        selector == #to:do: ifTrue:[
            (arg2 isBlock 
            and:[arg2 isInlinable 
            and:[arg2 numArgs == 1]]) ifTrue:[
                ^ self codeToDoOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
            ]
        ].
        (selector == #'caseOf:otherwise:') ifTrue:[
            (self codeCaseOfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler) ifTrue:[
                ^ self
            ].
        ].
    ].

    (nargs == 3) ifTrue:[
        selector == #to:by:do: ifTrue:[
            "/ step must be a constant (need to know how to compare)
            (arg2 isConstant 
            and:[arg2 type == #Integer
            and:[arg3 isBlock 
            and:[arg3 isInlinable 
            and:[arg3 numArgs == 1]]]]) ifTrue:[
                ^ self codeToByDoOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
            ]
        ].
    ].

    isBuiltIn := isSpecial := false.
    isSuper ifFalse:[
        isBuiltIn := aCompiler isBuiltInSelector:usedSelector forReceiver:receiver.
        isBuiltIn ifFalse:[
            specialCode := aCompiler specialSendCodeFor:usedSelector.
            isSpecial := specialCode notNil.
        ].
    ].


    "can we use a send-bytecode ?"
    (isBuiltIn or:[isSpecial]) ifTrue:[
        receiver codeOn:aStream inBlock:b for:aCompiler.
        (nargs > 0) ifTrue:[
            arg1 codeOn:aStream inBlock:b for:aCompiler.
            (nargs > 1) ifTrue:[
                arg2 codeOn:aStream inBlock:b for:aCompiler
            ]
        ].
        lineNr >= 255 ifTrue:[
            self codeLineNumber: lineNr on: aStream for:aCompiler.  
        ].
        aStream nextPut:usedSelector.
        (aCompiler hasLineNumber:usedSelector) ifTrue:[
            aStream nextPut:lineNr.
        ].
        isSpecial ifTrue:[
            aStream nextPut:specialCode
        ].
        valueNeeded ifFalse:[
            aStream nextPut:#drop
        ].
        ^ self
    ].

    ((nargs == 0) and:[selector == #yourself]) ifTrue:[
        "yourself is often added to get the receiver -
         we get it without the yourself-message"

        (valueNeeded or:[receiver isMessage]) ifTrue:[
            receiver codeOn:aStream inBlock:b for:aCompiler
        ].
        ^ self
    ].

    "not inlinable - generate a send"

    stackTop := nil.

    useSelfSend := isSuper not and:[ recType == #Self and:[ litIndex <= 16rFFFF ] ].
    useSelfSend ifFalse:[
        receiver codeOn:aStream inBlock:b for:aCompiler.
        receiver isConstant ifTrue:[ 
            stackTop := receiver
        ].
    ].
    argArray notNil ifTrue:[
        argArray do:[:arg |
            (stackTop notNil and:[arg canReuseAsArg:stackTop]) ifTrue:[
                aStream nextPut:#dup.
                "/ 'reuse:' print. stackTop print. ' in ' print. aCompiler selector printNL.
            ] ifFalse:[
                arg codeOn:aStream inBlock:b for:aCompiler.
                stackTop := arg.
            ]
        ]
    ].

    isSuper ifTrue:[
        cls := aCompiler targetClass.
        realReceiver isHere ifTrue:[
            "/ same code as supersend, but targetClass starts search
        ] ifFalse:[
            "/ targetClasses superclass starts search
            cls := cls superclass.
        ].
        clsLitIndex := aCompiler addLiteral:cls.
        self emitSuperSendLiteralIndex:litIndex classLiteralIndex:clsLitIndex numArgs:nargs line:lineNr on:aStream for:aCompiler.
        valueNeeded ifFalse:[
            aStream nextPut:#drop
        ].
        ^ self.
    ].

    valueNeeded ifTrue:[ noSendDrop := true ].
    alreadyDropped := false.

    (litIndex <= 255) ifTrue:[
        (nargs <= 3) ifTrue:[
            |codes|

            noSendDrop ifTrue:[
                useSelfSend ifTrue:[
                    codes := #(sendSelf0 sendSelf1 sendSelf2 sendSelf3)
                ] ifFalse:[
                    codes := #(send0 send1 send2 send3)
                ]
            ] ifFalse:[
                useSelfSend ifTrue:[
                    codes := #(sendSelfDrop0 sendSelfDrop1 sendSelfDrop2 sendSelfDrop3)
                ] ifFalse:[
                    codes := #(sendDrop0 sendDrop1 sendDrop2 sendDrop3)
                ].
                alreadyDropped := true.
            ].
            lineNr >= 255 ifTrue:[
                self codeLineNumber: lineNr on: aStream for: aCompiler.
            ].
            aStream nextPut:(codes at:(nargs + 1)); nextPut:lineNr; nextPut:litIndex.
            valueNeeded ifFalse:[
                alreadyDropped ifFalse:[
                    aStream nextPut:#drop
                ].
            ].
            ^ self
        ].

        useSelfSend ifTrue:[
            code := #sendSelf
        ] ifFalse:[
            noSendDrop ifTrue:[
                code := #send
            ] ifFalse:[
                code := #sendDrop.
                alreadyDropped := true.
            ]
        ].

        lineNr >= 255 ifTrue:[
            self codeLineNumber: lineNr on: aStream for: aCompiler.
        ].           
        aStream nextPut:code; nextPut:lineNr; nextPut:litIndex; nextPut:nargs.
        valueNeeded ifFalse:[
            alreadyDropped ifFalse:[
                aStream nextPut:#drop
            ].
        ].
        ^ self
    ].

    "needs 16bit literal index"
    (litIndex <= 16rFFFF) ifTrue:[
        useSelfSend ifTrue:[
            aStream nextPut:#sendSelfL; nextPut:lineNr; nextPut:litIndex; nextPut:0; nextPut:nargs.
        ] ifFalse:[
            self emitSendLiteralIndex:litIndex numArgs:nargs line:lineNr on:aStream for:aCompiler.
        ].
    ] ifFalse:[
        "needs 32bit literal index"
        self emitSendLiteralIndex:litIndex numArgs:nargs line:lineNr on:aStream for:aCompiler.
    ].

    valueNeeded ifFalse:[
        aStream nextPut:#drop
    ].

    "Modified: / 03-09-1995 / 12:55:42 / claus"
    "Modified: / 25-05-2012 / 11:29:47 / cg"
    "Modified: / 12-04-2013 / 22:42:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MessageNode methodsFor:'enumerating'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    receiver allNodesDo:aBlock.
    argArray notNil ifTrue:[
        argArray do:[:arg | arg allNodesDo:aBlock].
    ]
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector here and in subnodes"

    aBlock value:selector.
    receiver messageSelectorsDo:aBlock.
    argArray notNil ifTrue:[
        argArray do:[:arg | arg messageSelectorsDo:aBlock].
    ]
!

messagesDo:aBlock
    "evaluate aBlock for each message-node here and in subnodes"

    aBlock value:self.
    receiver messagesDo:aBlock.
    argArray notNil ifTrue:[
        argArray do:[:arg | arg messagesDo:aBlock].
    ]
!

nodeDo:anEnumerator
    "helper for parse tree walking"

    |args|

    args := argArray ? #().
    ^ anEnumerator doMessage:self receiver:receiver selector:selector arguments:args

    "Created: 19.6.1997 / 16:46:39 / cg"
    "Modified: 19.6.1997 / 17:08:28 / cg"
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node here and in subnodes"

    receiver variableNodesDo:aBlock.
    argArray notNil ifTrue:[
        argArray do:[:arg | arg variableNodesDo:aBlock].
    ]
! !

!MessageNode methodsFor:'evaluation'!

evaluateForCascadeIn:anEnvironment
    "evaluate, but return the receiver expression's value,
     not the message-send's value"

    ^ self evaluateIn:anEnvironment forCascade:true

    "Modified: / 20-04-2005 / 12:12:01 / cg"
    "Modified (comment): / 08-08-2017 / 18:08:45 / cg"
!

evaluateIn:anEnvironment
    ^ self evaluateIn:anEnvironment forCascade:false

    "Modified: / 20-04-2005 / 12:11:55 / cg"
!

evaluateIn:anEnvironment forCascade:forCascade
    "evaluate the send (possibly recursively evaluating the args before)
     if forCascade is true, return the receiver expression's value,
     otherwise return the message-send's value"

    |retVal defClass r a1 a2 a3 nargs argValueArray class sel|

    sel := self evaluationSelector.
    receiver isSuper ifTrue:[
        r := receiver value.

        defClass := receiver definingClass.
        receiver isHere ifTrue:[
            class := defClass.
        ] ifFalse:[
            class := defClass superclass.
        ].
        argArray notNil ifTrue:[
            argValueArray := argArray collect:[:arg | arg evaluateIn:anEnvironment].
        ] ifFalse:[
            argValueArray := #()
        ].
        retVal := r perform:sel inClass:class withArguments:argValueArray.
    ] ifFalse:[
        r := receiver evaluateIn:anEnvironment.

        argArray isNil ifTrue:[
            retVal := r perform:sel
        ] ifFalse:[
            nargs := argArray size.
            (nargs == 0) ifTrue:[
                retVal := r perform:sel
            ] ifFalse:[
                a1 := (argArray at:1) evaluateIn:anEnvironment.
                (nargs == 1) ifTrue:[
                    retVal := r perform:sel with:a1
                ] ifFalse:[
                    a2 := (argArray at:2) evaluateIn:anEnvironment.
                    (nargs == 2) ifTrue:[
                        retVal := r perform:sel with:a1 with:a2
                    ] ifFalse:[
                        a3 := (argArray at:3) evaluateIn:anEnvironment.
                        (nargs == 3) ifTrue:[
                            retVal := r perform:sel with:a1 with:a2 with:a3
                        ] ifFalse:[
                            argValueArray := Array new:nargs.
                            argValueArray at:1 put:a1.
                            argValueArray at:2 put:a2.
                            argValueArray at:3 put:a3.
                            4 to:nargs do:[:idx | argValueArray at:idx put:((argArray at:idx) evaluateIn:anEnvironment)].
                            retVal := r perform:sel withArguments:argValueArray.
                        ].
                    ].
                ].
            ].
        ].
    ].
    ^ forCascade ifTrue:[r] ifFalse:[retVal]

    "Created: / 20-04-2005 / 12:11:39 / cg"
    "Modified (comment): / 08-08-2017 / 18:08:56 / cg"
!

evaluationSelector
    ^ selector asSymbol
! !

!MessageNode methodsFor:'optimized code generation'!

codeAndIfElseOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for (x and:[y]) ifxxx:[ ... ] ifyyy:[ ... ]"

    |theByteCode optByteCode receiver1 receiver2 theArg theArg2 pos1 pos2 pos3 code here jmp
     block1 block2 andBlock optByteCode2|

    aCompiler addLiteral:#and:.

    theByteCode := #falseJump.
    receiver1 := receiver receiver.
    theArg := nil.

    optByteCode := self optimizedConditionFor:receiver1 with:theByteCode for:aCompiler.
    optByteCode notNil ifTrue:[
        ((optByteCode == #eqJump) or:[optByteCode == #notEqJump]) ifTrue:[
            theArg := receiver1 arg1
        ].
        receiver1 := receiver1 receiver.
        theByteCode := optByteCode
    ].
    "/ code the left-of the and-part
    receiver1 codeOn:aStream inBlock:b for:aCompiler.
    theArg notNil ifTrue:[
        theArg codeOn:aStream inBlock:b for:aCompiler
    ].
    aStream nextPut:theByteCode.
    pos1 := aStream position + 1.   "/ remember branch target of left-fail branch
    aStream nextPut:0.

    "/ code the right of the and-part
    (selector == #ifTrue:ifFalse:) ifTrue:[
        jmp := #falseJump
    ] ifFalse:[
        jmp := #trueJump
    ].

    andBlock := receiver arg1.
    theArg2 := nil.

    "/ code the left-of the and-part
    (andBlock statements isNil or:[andBlock statements nextStatement isNil]) ifTrue:[
        "/ simple - one statement
        receiver2 := andBlock statements expression.
        optByteCode2 := self optimizedConditionFor:receiver2 with:jmp for:aCompiler.
    ].
    optByteCode2 notNil ifTrue:[
        ((optByteCode2 == #eqJump) or:[optByteCode2 == #notEqJump]) ifTrue:[
            theArg2 := receiver2 arg1
        ].
        receiver2 := receiver2 receiver.
        receiver2 codeOn:aStream inBlock:b for:aCompiler.
        theArg2 notNil ifTrue:[
            theArg2 codeOn:aStream inBlock:b for:aCompiler
        ].
        jmp := optByteCode2
    ] ifFalse:[
        andBlock codeInlineOn:aStream inBlock:b for:aCompiler.
    ].

    aStream nextPut:jmp.
    pos2 := aStream position + 1.   "/ remember branch target of right-fail branch 
    aStream nextPut:0.

    code := aStream contents.
    (selector == #ifFalse:ifTrue:) ifTrue:[
        code at:pos1 put:(aStream position + 1)
    ].

    "/ code the if-block
    block1 := argArray at: 1.
    self codeBlockEvaluation:block1 on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.

    aStream nextPut:#jump.
    pos3 := aStream position + 1.
    aStream nextPut:0.

    here := aStream position + 1.
    (selector == #ifTrue:ifFalse:) ifTrue:[
        code at:pos1 put:here
    ].
    code at:pos2 put:here.

    "/ code the else-block
    block2 := argArray at: 2.
    self codeBlockEvaluation:block2 on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.

    code at:pos3 put:(aStream position + 1)

    "Created: 6.9.1996 / 12:56:23 / cg"
!

codeAndIfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for (x and:[y]) ifxxx:[ ... ]"

    |theByteCode optByteCode andBlock theArg pos1 pos2 pos3 code here jmp
     receiver1 receiver2 optByteCode2 theArg2 block|

    aCompiler addLiteral:#and:.

    theByteCode := #falseJump.
    receiver1 := receiver receiver.
    theArg := nil.

    optByteCode := self optimizedConditionFor:receiver1 with:theByteCode for:aCompiler.
    optByteCode notNil ifTrue:[
        ((optByteCode == #eqJump) or:[optByteCode == #notEqJump]) ifTrue:[
            theArg := receiver1 arg1
        ].
        receiver1 := receiver1 receiver.
        theByteCode := optByteCode
    ].
    "/ code the left-of the and-part
    receiver1 codeOn:aStream inBlock:b for:aCompiler.
    theArg notNil ifTrue:[
        theArg codeOn:aStream inBlock:b for:aCompiler
    ].
    aStream nextPut:theByteCode.
    pos1 := aStream position + 1.
    aStream nextPut:0.

    andBlock := receiver arg1. "/ the and:-block
    (selector == #ifTrue:) ifTrue:[
        jmp := #falseJump
    ] ifFalse:[
        jmp := #trueJump
    ].
    optByteCode2 := nil.

    (andBlock statements isNil or:[andBlock statements nextStatement isNil]) ifTrue:[
        "/ simple - one statement
        receiver2 := andBlock statements expression.
        optByteCode2 := self optimizedConditionFor:receiver2 with:jmp for:aCompiler.
    ].
    optByteCode2 notNil ifTrue:[
        ((optByteCode2 == #eqJump) or:[optByteCode2 == #notEqJump]) ifTrue:[
            theArg2 := receiver2 arg1
        ].
        receiver2 := receiver2 receiver.
        receiver2 codeOn:aStream inBlock:b for:aCompiler.
        theArg2 notNil ifTrue:[
            theArg2 codeOn:aStream inBlock:b for:aCompiler
        ].
        jmp := optByteCode2.
    ] ifFalse:[
        andBlock codeInlineOn:aStream inBlock:b for:aCompiler.
    ].
    aStream nextPut:jmp.
    pos2 := aStream position + 1.
    aStream nextPut:0.

    code := aStream contents.
    (selector == #ifFalse:) ifTrue:[
        code at:pos1 put:(aStream position + 1)
    ].
    block := argArray at: 1.
    self codeBlockEvaluation:block on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.

    valueNeeded ifTrue:[
        aStream nextPut:#jump.
        pos3 := aStream position + 1.
        aStream nextPut:0.
        here := aStream position + 1.
        (selector == #ifTrue:) ifTrue:[
            code at:pos1 put:here
        ].
        code at:pos2 put:here.
        aStream nextPut:#pushNil.
        code at:pos3 put:(aStream position + 1)
    ] ifFalse:[
        here := aStream position + 1.
        (selector == #ifTrue:) ifTrue:[
            code at:pos1 put:here
        ].
        code at:pos2 put:here
    ]
!

codeAndOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for (x and:[y])"

    |jumpTarget1 rightExpr|

    aCompiler addLiteral:#and:.

    (receiver isConstant and:[receiver value == true ]) ifTrue:[
        "/ happens when code is "commented" i.e. true and:[ ... ]
        
    ] ifFalse:[

        receiver codeOn:aStream inBlock:b for:aCompiler.
        valueNeeded ifTrue:[
            aStream nextPut:#dup.
        ].
        aStream nextPut:#falseJump.
        jumpTarget1 := aStream position + 1.
        aStream nextPut:0.
        valueNeeded ifTrue:[
            aStream nextPut:#drop.
        ].
    ].

    rightExpr := argArray at:1.
    rightExpr codeInlineOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.

    jumpTarget1 notNil ifTrue:[
        (aStream contents) at:jumpTarget1 put:(aStream position + 1)
    ].

    "Created: 17.6.1996 / 15:46:42 / cg"
    "Modified: 17.6.1996 / 15:47:44 / cg"
!

codeBlockEvaluation:aBlock on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "gen code to evaluate a block"

    (aBlock isBlock and:[aBlock isInlinable]) ifTrue:[
        aBlock codeInlineOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
    ] ifFalse:[
        aBlock codeOn:aStream inBlock:b for:aCompiler.
        aBlock isConstant ifFalse:[
            self codeValueSendOn:aStream for:aCompiler.
        ].
        valueNeeded ifFalse:[
            aStream nextPut:#drop
        ].
    ].
!

codeCaseOfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "expr
        caseOf: {
            [val1] -> [ caseStats1 ].
            [val2] -> [ caseStats2 ].
            ...
            [valN] -> [ caseStatsN ].
        }
        otherwise: [
            otherStats
        ].
     also handles caseOf, without otherwise: arg.
     Compiled as a nested if-statement.
    "

    |caseArg otherwiseArg checkAndCollectCases checkAndCollectCases2 caseValueExpressions caseBlocks elseBlock ifMessage|

    checkAndCollectCases := 
        [:expr :atEnd |
            |numCasesAllocated caseNr caseValueExpression caseBlock|

            expr receiver isMessage ifFalse:[ ^ false].
            expr selector = #'at:put:' ifFalse:[ ^ false].
            "check if at: arg is an integer (the case-nr)"
            expr arg1 isConstant ifFalse:[ ^ false].
            (caseNr := expr arg1 value) isInteger ifFalse:[ ^ false].
            "check if put: arg is []->[] (the case-spec)"
            expr arg2 isMessage ifFalse:[ ^ false].
            expr arg2 selector == #'->' ifFalse:[ ^ false].
            expr arg2 receiver isBlock ifFalse:[ ^ false].
            (caseBlock := expr arg2 arg1) isBlock ifFalse:[ ^ false].
            "the case-value-block must consist of a single expression"
            expr arg2 receiver isSingleExpressionBlock ifFalse:[ ^ false].
            (caseValueExpression := expr arg2 receiver simpleSendBlockExpression) notNil ifFalse:[ ^ false].
            caseValueExpressions isEmptyOrNil ifTrue:[
                caseValueExpressions := OrderedCollection newWithSize:caseNr.
                caseBlocks := OrderedCollection newWithSize:caseNr.
            ].
            caseValueExpressions at:caseNr put:caseValueExpression.
            caseBlocks at:caseNr put:caseBlock.

            atEnd ifFalse: [
                expr receiver isCascade ifTrue:[
                    "at the left, there must be another cascade"
                    checkAndCollectCases value:expr receiver value:false.
                ] ifFalse:[
                    "at the left, there must be an (Array new:N) at:1 put:([]->[]) expression"
                    checkAndCollectCases value:expr receiver value:true.
                    expr receiver selector = #'at:put:' ifFalse:[ ^ false].
                    expr receiver receiver isMessage ifFalse:[ ^ false].
                    expr receiver receiver selector = #'new:' ifFalse:[ ^ false].
                    expr receiver receiver receiver isGlobal ifFalse:[ ^ false].
                    expr receiver receiver receiver name = 'Array' ifFalse:[^ false].
                    expr receiver receiver arg1 isConstant ifFalse:[^ false].
                    (numCasesAllocated := expr receiver receiver arg1 value) isInteger ifFalse:[^ false].
                    numCasesAllocated = caseBlocks size ifFalse:[^ false].
                ].
            ].
        ].

    checkAndCollectCases2 :=    "/ for with:with: cases
        [:expr |
            |caseNr caseValueExpression caseBlock|

            expr args do:[:eachCaseArg |
                "check if put: eachCaseArg is []->[] (the case-spec)"
                eachCaseArg isMessage ifFalse:[ ^ false].
                eachCaseArg selector == #'->' ifFalse:[ ^ false].
                eachCaseArg receiver isBlock ifFalse:[ ^ false].
                (caseBlock := eachCaseArg arg1) isBlock ifFalse:[
                    caseBlock isVariable ifFalse:[ ^ false].
                ].
                "the case-value-block must consist of a single expression"
                eachCaseArg receiver isSingleExpressionBlock ifFalse:[ ^ false].
                (caseValueExpression := eachCaseArg receiver simpleSendBlockExpression) notNil ifFalse:[ ^ false].
                caseValueExpressions isEmptyOrNil ifTrue:[
                    caseValueExpressions := OrderedCollection new.
                    caseBlocks := OrderedCollection new.
                ].
                caseValueExpressions add:caseValueExpression.
                caseBlocks add:caseBlock.
            ].
        ].

    receiver isMessage ifTrue:[ ^ false].   "for now: I cannot introduce temporaries"

    caseArg := argArray at:1.
    "caseArg has already been transformed from a {...}- to
     an Array-creating cascade expression or an Array-with:... expression"
    caseArg isCascade ifTrue:[
        caseArg receiver isMessage ifFalse:[^ false].
        checkAndCollectCases value:(caseArg receiver) value:false.
    ] ifFalse:[
        (caseArg isMessage
            and:[ (caseArg receiver isGlobalNamed:'Array')
            and:[ 
                #( 'with:'
                   'with:with:' 
                   'with:with:with:' 
                   'with:with:with:with:' 
                   'with:with:with:with:with:' 
                   'with:with:with:with:with:with:' 
                   'with:with:with:with:with:with:with:' 
                   'with:with:with:with:with:with:with:with:' 
                    ) includes:caseArg selector ]
        ]) ifTrue:[
            checkAndCollectCases2 value:caseArg.
        ] ifFalse:[
            "whenever an explicit Array-expression is used here, add support below"
            ^ false
        ].
    ].
    argArray size > 1 ifTrue:[
        otherwiseArg := argArray at:2.
        otherwiseArg isBlock ifFalse:[
            otherwiseArg isVariable ifFalse:[^ false]
        ]
    ].
    "compile as a nested if"

    elseBlock := otherwiseArg ? (ConstantNode value:nil).
    caseValueExpressions with:caseBlocks reverseDo:[:eachCaseValueExpression :eachCaseBlock |
        |cond|

        cond := BinaryNode receiver:receiver selector:#= arg:eachCaseValueExpression.
        ifMessage := MessageNode
                        receiver:cond
                        selector:#'ifTrue:ifFalse:'
                        arg1:eachCaseBlock
                        arg2:elseBlock.
        elseBlock := BlockNode withExpression:ifMessage in:b.
    ].
    ifMessage codeOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
    ^ true

    "Created: / 25-05-2012 / 11:28:27 / cg"
    "Modified: / 26-03-2018 / 15:28:32 / stefan"
!

codeForCascadeOn:aStream inBlock:b for:aCompiler
    "like codeOn, but always leave the receiver instead of the result"

    |nargs isBuiltIn code litIndex cls clsLitIndex isSuper realReceiver noSendDrop|

    selector := selector asSymbol.
    noSendDrop := aCompiler class newCodeSet == true.

    realReceiver := self realReceiver.
    isSuper := realReceiver isSuper.

    argArray isNil ifTrue:[
        nargs := 0
    ] ifFalse:[
        nargs := argArray size
    ].

    isBuiltIn := isSuper not and:[ aCompiler isBuiltInSelector:selector forReceiver:receiver ].

    litIndex := aCompiler addLiteral:selector.

    receiver codeOn:aStream inBlock:b for:aCompiler.
    aStream nextPut:#dup.

    "can we use a send-bytecode ?"
    isBuiltIn ifTrue:[
        (nargs > 0) ifTrue:[
            (argArray at:1) codeOn:aStream inBlock:b for:aCompiler.
            (nargs > 1) ifTrue:[
                (argArray at:2) codeOn:aStream inBlock:b for:aCompiler
            ]
        ].
        lineNr >= 255 ifTrue:[
            self codeLineNumber: lineNr on: aStream for:aCompiler.  
        ].
        aStream nextPut:selector.
        (aCompiler hasLineNumber:selector) ifTrue:[
            aStream nextPut:lineNr.
        ].
        aStream nextPut:#drop.
        ^ self
    ].

    "no - generate a send"
    argArray notNil ifTrue:[
        argArray do:[:arg |
            arg codeOn:aStream inBlock:b for:aCompiler
        ]
    ].

    isSuper ifTrue:[
        cls := aCompiler targetClass.
        realReceiver isHere ifTrue:[
            "/ same code as supersend, but targetClass starts search
        ] ifFalse:[
            "/ targetClasses superclass starts search
            cls := cls superclass.
        ].
        clsLitIndex := aCompiler addLiteral:cls.
        self emitSuperSendLiteralIndex:litIndex classLiteralIndex:clsLitIndex numArgs:nargs line:lineNr on:aStream for:aCompiler.
        aStream nextPut:#drop.
        ^ self
    ].

    noSendDrop ifFalse:[
        litIndex <= 255 ifTrue:[
            (nargs <= 3) ifTrue:[
                code := #(sendDrop0 sendDrop1 sendDrop2 sendDrop3) at:(nargs+1).
                lineNr >= 255 ifTrue:[
                    self codeLineNumber: lineNr on: aStream for:aCompiler.  
                ].
                aStream nextPut:code; nextPut:lineNr; nextPut:litIndex.
                ^ self
            ].
            lineNr >= 255 ifTrue:[
                self codeLineNumber: lineNr on: aStream for:aCompiler.  
            ].
            aStream nextPut:#sendDrop; nextPut:lineNr; nextPut:litIndex; nextPut:nargs.
            ^ self
        ].
    ].

    self emitSendLiteralIndex:litIndex numArgs:nargs line:lineNr on:aStream for:aCompiler.
    aStream nextPut:#drop.

    "Modified: / 04-07-1999 / 19:06:53 / cg"
    "Modified: / 13-04-2013 / 10:49:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    self codeOn:aStream inBlock:b valueNeeded:false for:aCompiler
!

codeForSimpleReturnOn:aStream inBlock:b lineNumber:lineNrOrNil for:aCompiler
    |arg1 rightExpr pos1|

    (selector == #and:
    or:[selector == #or:]) ifTrue:[
        arg1 := argArray at:1.

        "/ for now:
        "/ only do it for non-blocks, since
        "/ the JIT compiler is smart enough to
        "/ specially optimize the resulting code
        "/ (and not smart enough to optimized the
        "/  other - actually more efficient - code)

        (arg1 isBlock not 
"/        or:[arg1 isInlinable]
        ) ifTrue:[

            "/ encode #and: as:
            "/
            "/      eLeft
            "/      jmp_false       LBL
            "/      eRight
            "/      retTop
            "/  LBL:
            "/      retFalse

            "/ encode #or: as:
            "/
            "/      eLeft
            "/      jmp_true       LBL
            "/      eRight
            "/      retTop
            "/  LBL:
            "/      retTrue

            receiver codeOn:aStream inBlock:b for:aCompiler.
            selector == #and: ifTrue:[
                aStream nextPut:#falseJump.
            ] ifFalse:[
                aStream nextPut:#trueJump.
            ].
            pos1 := aStream position + 1.
            aStream nextPut:0.
        
            rightExpr := argArray at:1.
            rightExpr isBlock ifTrue:[
                rightExpr codeInlineOn:aStream inBlock:b valueNeeded:true for:aCompiler.
            ] ifFalse:[
                rightExpr codeOn:aStream inBlock:b for:aCompiler.
            ].
            aStream nextPut:#retTop.
        
            (aStream contents) at:pos1 put:(aStream position + 1).
            selector == #and: ifTrue:[
                aStream nextPut:#retFalse.
            ] ifFalse:[
                aStream nextPut:#retTrue
            ].
            ^ self.
        ].
    ].

    super
        codeForSimpleReturnOn:aStream 
        inBlock:b 
        lineNumber:lineNrOrNil 
        for:aCompiler
!

codeIfElseOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for x ifxxx:[ ... ] yyy:[ ...]"

    |pos pos2 theReceiver theArg theByteCode optByteCode subsel code needLineNr
     needJump block1 block2|

    theReceiver := receiver.

    theReceiver isConstant ifTrue:[
        (self tryFoldedIfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler) ifTrue:[
            ^ self
        ].
    ].

    (theReceiver isMessage) ifTrue:[
        subsel := theReceiver selector.
        ((subsel == #and:) and:[theReceiver arg1 isBlock and:[theReceiver arg1 isInlinable]]) ifTrue:[
            self codeAndIfElseOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
            ^ self
        ].
        ((subsel == #or:) and:[theReceiver arg1 isBlock and:[theReceiver arg1 isInlinable]]) ifTrue:[
            self codeOrIfElseOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
            ^ self
        ]
    ].

    (selector == #ifTrue:ifFalse:) ifTrue:[
        theByteCode := #falseJump
    ] ifFalse:[
        theByteCode := #trueJump
    ].
    optByteCode := self optimizedConditionFor:theReceiver with:theByteCode for:aCompiler.
    optByteCode notNil ifTrue:[
        ((optByteCode == #eqJump) or:[optByteCode == #notEqJump]) ifTrue:[
            theArg := theReceiver arg1
        ].
        theReceiver := theReceiver receiver.
        theByteCode := optByteCode
    ].
    theReceiver codeOn:aStream inBlock:b for:aCompiler.

    needLineNr := true.
    theArg isNil ifTrue:[
        theReceiver isMessage ifTrue:[
            (aCompiler hasLineNumber:(theReceiver selector)) ifTrue:[
                theReceiver lineNumber == lineNr ifTrue:[
                    needLineNr := false
                ]
            ]
        ]
    ] ifFalse:[
        theArg codeOn:aStream inBlock:b for:aCompiler
    ].

    needLineNr ifTrue:[
        (lineNr between:1 and:255) ifTrue:[
            aStream nextPut:#lineno; nextPut:lineNr.
        ]
    ].

    aStream nextPut:theByteCode.
    pos := aStream position + 1.
    aStream nextPut:0.
    block1 := argArray at:1.
    self codeBlockEvaluation:block1 on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.

    needJump := true.
    (block1 isBlock and:[block1 endsWithReturn]) ifTrue:[
        needJump := false
    ].
    needJump ifTrue:[
        aStream nextPut:#jump.
        pos2 := aStream position + 1.
        aStream nextPut:0.
    ].
    code := aStream contents.
    code at:pos put:(aStream position + 1).
    block2 := (argArray at:2).
    self codeBlockEvaluation:block2 on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
    needJump ifTrue:[
        code at:pos2 put:(aStream position + 1)
    ]

    "
     |a|
     (a size = 0 and:a isNil) ifTrue: [self halt.] ifFalse:[]
    "

    "Modified: / 21-05-2010 / 15:39:15 / cg"
!

codeIfNilNotNilOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for x ifNil:[ ... ] ifNotNil:[...]
     or: x ifNil:const1 ifNotNil:const2"

    |pos pos2 theReceiver theArg theByteCode code
     needLineNr block1 block2|

    theReceiver := receiver.

    (selector == #ifNil:ifNotNil:) ifTrue:[
        theByteCode := #notNilJump
    ] ifFalse:[
        theByteCode := #nilJump
    ].

    theReceiver codeOn:aStream inBlock:b for:aCompiler.

    needLineNr := true.
    theArg isNil ifTrue:[
        theReceiver isMessage ifTrue:[
            (aCompiler hasLineNumber:(theReceiver selector)) ifTrue:[
                theReceiver lineNumber == lineNr ifTrue:[
                    needLineNr := false
                ]
            ]
        ]
    ].

    needLineNr ifTrue:[
        (lineNr between:1 and:255) ifTrue:[
            aStream nextPut:#lineno; nextPut:lineNr.
        ]
    ].

    aStream nextPut:theByteCode.
    pos := aStream position + 1.
    aStream nextPut:0.
    block1 := argArray at: 1.
    self codeBlockEvaluation:block1 on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
    aStream nextPut:#jump.
    pos2 := aStream position + 1.
    aStream nextPut:0.

    code := aStream contents.
    code at:pos put:(aStream position + 1).
    block2 := argArray at: 2.
    self codeBlockEvaluation:block2 on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.

    code := aStream contents.
    code at:pos2 put:(aStream position + 1)

    "Modified: / 11.2.2000 / 12:50:36 / cg"
!

codeIfNilOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for x ifNil:[ ... ]"

    |pos theReceiver theByteCode code needLineNr|

    theReceiver := receiver.

    (selector == #ifNil:) ifTrue:[
        theByteCode := #notNilJump
    ] ifFalse:[
        theByteCode := #nilJump
    ].

    theReceiver codeOn:aStream inBlock:b for:aCompiler.

    needLineNr := true.

    theReceiver isMessage ifTrue:[
        (aCompiler hasLineNumber:(theReceiver selector)) ifTrue:[
            theReceiver lineNumber == lineNr ifTrue:[
                needLineNr := false
            ]
        ]
    ].

    needLineNr ifTrue:[
        (lineNr between:1 and:255) ifTrue:[
            aStream nextPut:#lineno; nextPut:lineNr.
        ]
    ].

    valueNeeded ifTrue:[
        aStream nextPut:#dup.
    ].
    aStream nextPut:theByteCode.
    pos := aStream position + 1.
    aStream nextPut:0.
    valueNeeded ifTrue:[
        aStream nextPut:#drop.
    ].

    self codeBlockEvaluation:(argArray at: 1) on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.

    code := aStream contents.
    code at:pos put:(aStream position + 1)

    "Modified: / 28.10.1997 / 18:33:42 / cg"
!

codeIfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for x ifxxx:[ ... ]"

    |pos pos2 theReceiver theArg theByteCode optByteCode subsel code
     needLineNr block|

    theReceiver := receiver.

    theReceiver isConstant ifTrue:[
        (self tryFoldedIfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler) ifTrue:[
            ^ self
        ].
    ].

    (theReceiver isMessage) ifTrue:[
        subsel := theReceiver selector.

        (subsel == #and:) ifTrue:[
            theReceiver arg1 isBlock ifTrue:[
                self codeAndIfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ^ self
            ]
        ].
        (subsel == #or:) ifTrue:[
            theReceiver arg1 isBlock ifTrue:[
                self codeOrIfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
                ^ self
            ]
        ].
    ].
    (selector == #ifTrue:) ifTrue:[
        theByteCode := #falseJump
    ] ifFalse:[
        theByteCode := #trueJump
    ].
    optByteCode := self optimizedConditionFor:theReceiver with:theByteCode for:aCompiler.
    optByteCode notNil ifTrue:[
        ((optByteCode == #eqJump) or:[optByteCode == #notEqJump]) ifTrue:[
            theArg := theReceiver arg1
        ].
        theReceiver := theReceiver receiver.
        theByteCode := optByteCode
    ].

    theReceiver codeOn:aStream inBlock:b for:aCompiler.
    theArg notNil ifTrue:[
        theArg codeOn:aStream inBlock:b for:aCompiler
    ].

    needLineNr := true.
    theArg isNil ifTrue:[
        theReceiver isMessage ifTrue:[
            (aCompiler hasLineNumber:(theReceiver selector)) ifTrue:[
                theReceiver lineNumber == lineNr ifTrue:[
                    needLineNr := false
                ]
            ]
        ]
    ].

    needLineNr ifTrue:[
        (lineNr between:1 and:255) ifTrue:[
            aStream nextPut:#lineno; nextPut:lineNr.
        ]
    ].

    aStream nextPut:theByteCode.
    pos := aStream position + 1.
    aStream nextPut:0.
    block := (argArray at:1).

    self codeBlockEvaluation:block on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.

    code := aStream contents.
    valueNeeded ifTrue:[
        aStream nextPut:#jump.
        pos2 := aStream position + 1.
        aStream nextPut:0.
        code at:pos put:(aStream position + 1).
        aStream nextPut:#pushNil.
        code at:pos2 put:(aStream position + 1)
    ] ifFalse:[
        code at:pos put:(aStream position + 1)
    ]

    "Modified: / 28.10.1997 / 18:33:42 / cg"
!

codeOrIfElseOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for (x or:[y]) ifxxx:[ ... ] ifyyy:[ ... ]"

    |theByteCode optByteCode theReceiver theArg pos1 pos2 pos3 code here jmp
     block1 block2 optJmp blockExpr|

    aCompiler addLiteral:#or:.

    theByteCode := #trueJump.
    theReceiver := receiver receiver.

    optByteCode := self optimizedConditionFor:theReceiver with:theByteCode for:aCompiler.
    optByteCode notNil ifTrue:[
        ((optByteCode == #eqJump) or:[optByteCode == #notEqJump]) ifTrue:[
            theArg := theReceiver arg1
        ].
        theReceiver := theReceiver receiver.
        theByteCode := optByteCode
    ].
    "/ code the left-of the or-part
    theReceiver codeOn:aStream inBlock:b for:aCompiler.
    theArg notNil ifTrue:[
        theArg codeOn:aStream inBlock:b for:aCompiler
    ].
    aStream nextPut:theByteCode.
    pos1 := aStream position + 1.   "/ remember branch target of left-ok branch
    aStream nextPut:0.

    "/ code the right of the or-part
    (selector == #ifTrue:ifFalse:) ifTrue:[
        jmp := #falseJump
    ] ifFalse:[
        jmp := #trueJump
    ].
    theReceiver := receiver arg1.
    theArg := nil.
    optJmp := nil.

    (theReceiver isBlock
    and:[theReceiver statements notNil
    and:[theReceiver statements nextStatement isNil]]) ifTrue:[
        blockExpr := theReceiver statements expression.
        optJmp := self optimizedConditionFor:blockExpr with:jmp for:aCompiler.
        optJmp notNil ifTrue:[
            ((optJmp == #eqJump) or:[optJmp == #notEqJump]) ifTrue:[
                theArg := blockExpr arg1
            ].
            theReceiver := blockExpr receiver.
            jmp := optJmp
        ].
    ].

    optJmp notNil ifTrue:[
        theReceiver codeOn:aStream inBlock:b for:aCompiler.
        theArg notNil ifTrue:[
            theArg codeOn:aStream inBlock:b for:aCompiler
        ]
    ] ifFalse:[
        theReceiver codeInlineOn:aStream inBlock:b for:aCompiler.
    ].
    aStream nextPut:jmp.
    pos2 := aStream position + 1.   "/ remember branch target of right-fail branch 
    aStream nextPut:0.


    code := aStream contents.
    (selector == #ifTrue:ifFalse:) ifTrue:[
        code at:pos1 put:(aStream position + 1)
    ].

    "/ code the if-block
    block1 := argArray at: 1.
    self codeBlockEvaluation:block1 on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.

    aStream nextPut:#jump.
    pos3 := aStream position + 1.
    aStream nextPut:0.

    here := aStream position + 1.
    (selector == #ifFalse:ifTrue:) ifTrue:[
        code at:pos1 put:here
    ].
    code at:pos2 put:here.

    "/ code the else-block
    block2 := argArray at: 2.
    self codeBlockEvaluation:block2 on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
    code at:pos3 put:(aStream position + 1)

    "Created: 6.9.1996 / 13:08:52 / cg"
!

codeOrIfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for (x or:[y]) ifxxx:[ ... ]"

    |theByteCode optByteCode theReceiver theArg pos1 pos2 pos3 code here jmp
     block|

    aCompiler addLiteral:#or:.

    theByteCode := #trueJump.
    theReceiver := receiver receiver.

    optByteCode := self optimizedConditionFor:theReceiver with:theByteCode for:aCompiler.
    optByteCode notNil ifTrue:[
        ((optByteCode == #eqJump) or:[optByteCode == #notEqJump]) ifTrue:[
            theArg := theReceiver arg1
        ].
        theReceiver := theReceiver receiver.
        theByteCode := optByteCode
    ].
    theReceiver codeOn:aStream inBlock:b for:aCompiler.
    theArg notNil ifTrue:[
        theArg codeOn:aStream inBlock:b for:aCompiler
    ].
    aStream nextPut:theByteCode.
    pos1 := aStream position + 1.
    aStream nextPut:0.


    theReceiver := receiver arg1.
    theArg := nil.

"new:"
    (selector == #ifTrue:) ifTrue:[
        theByteCode := #falseJump
    ] ifFalse:[
        theByteCode := #trueJump
    ].
    optByteCode := self optimizedConditionFor:theReceiver with:theByteCode for:aCompiler.
    optByteCode notNil ifTrue:[
        theReceiver isBlock ifTrue:[
            theReceiver := theReceiver statements expression
        ].
        ((optByteCode == #eqJump) or:[optByteCode == #notEqJump]) ifTrue:[
            theArg := theReceiver arg1
        ].
        theReceiver := theReceiver receiver.
        theByteCode := optByteCode.

        theReceiver codeOn:aStream inBlock:b for:aCompiler.
        theArg notNil ifTrue:[
            theArg codeOn:aStream inBlock:b for:aCompiler
        ].
        aStream nextPut:theByteCode.

    ] ifFalse:[
"org"
        theReceiver codeInlineOn:aStream inBlock:b for:aCompiler.
        (selector == #ifTrue:) ifTrue:[
            jmp := #falseJump
        ] ifFalse:[
            jmp := #trueJump
        ].
        aStream nextPut:jmp
    ].
    pos2 := aStream position + 1.
    aStream nextPut:0.
    (selector == #ifTrue:) ifTrue:[
        (aStream contents) at:pos1 put:(aStream position + 1)
    ].
    block := argArray at: 1.
    self codeBlockEvaluation:block on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.

    code := aStream contents.
    valueNeeded ifTrue:[
        aStream nextPut:#jump.
        pos3 := aStream position + 1.
        aStream nextPut:0.
        here := aStream position + 1.
        (selector == #ifFalse:) ifTrue:[
            code at:pos1 put:here
        ].
        code at:pos2 put:here.
        aStream nextPut:#pushNil.
        code at:pos3 put:(aStream position + 1)
    ] ifFalse:[
        here := aStream position + 1.
        (selector == #ifFalse:) ifTrue:[
            code at:pos1 put:here
        ].
        code at:pos2 put:here
    ]

    "Modified: 9.11.1996 / 19:52:26 / cg"
!

codeOrOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for (x or:[y])"

    |jumpTarget1 rightExpr|

    aCompiler addLiteral:#or:.

    (receiver isConstant and:[receiver value == false ]) ifTrue:[
        "/ happens when code is "commented" i.e. false or:[ ... ]

    ] ifFalse:[

        receiver codeOn:aStream inBlock:b for:aCompiler.
        valueNeeded ifTrue:[
            aStream nextPut:#dup.
        ].
        aStream nextPut:#trueJump.
        jumpTarget1 := aStream position + 1.
        aStream nextPut:0.
        valueNeeded ifTrue:[
            aStream nextPut:#drop.
        ].
    ].

    rightExpr := argArray at:1.
    rightExpr codeInlineOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.

    jumpTarget1 notNil ifTrue:[
        (aStream contents) at:jumpTarget1 put:(aStream position + 1)
    ].

    "Created: 17.6.1996 / 15:40:22 / cg"
    "Modified: 17.6.1996 / 15:47:22 / cg"
!

codeQuestOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for x ? y. 
     However, this is only done for non-send args."

    |pos code|

    aCompiler addLiteral:#'?'.

    receiver codeOn:aStream inBlock:b for:aCompiler.
    aStream nextPut:#dup.
    aStream nextPut:#notNilJump.
    pos := aStream position + 1.
    aStream nextPut:0.

    aStream nextPut:#drop.
    (argArray at: 1) codeOn:aStream inBlock:b for:aCompiler.

    code := aStream contents.
    code at:pos put:(aStream position + 1).

    valueNeeded ifFalse:[
        aStream nextPut:#drop.
    ].

    "Created: / 10.11.1996 / 18:28:57 / cg"
    "Modified: / 28.10.1997 / 18:16:20 / cg"
!

codeRepeatOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for 
        [ ... ] repeat
     and:
        [ ... ] loop
    "

    |pos|

    pos := aStream position + 1.
    receiver codeInlineOn:aStream inBlock:b valueNeeded:false for:aCompiler.
    aStream nextPut:#jump; nextPut:pos.

    "Created: 29.8.1997 / 08:14:58 / cg"
!

codeSendOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "like code on, but assumes that receiver has already been
     coded onto stack - needed for cascade"

    |nargs isBuiltIn code litIndex cls clsLitIndex isSuper realReceiver 
     noSendDrop alreadyDropped|

    selector := selector asSymbol.
    noSendDrop := aCompiler class newCodeSet == true.

    realReceiver := self realReceiver.
    isSuper := realReceiver isSuper.

    argArray isNil ifTrue:[
        nargs := 0
    ] ifFalse:[
        nargs := argArray size
    ].

    litIndex := aCompiler addLiteral:selector.

    isBuiltIn := isSuper not and:[ aCompiler isBuiltInSelector:selector forReceiver:receiver ].

    "can we use a send-bytecode ?"
    isBuiltIn ifTrue:[
        (nargs > 0) ifTrue:[
            (argArray at:1) codeOn:aStream inBlock:b for:aCompiler.
            (nargs > 1) ifTrue:[
                (argArray at:2) codeOn:aStream inBlock:b for:aCompiler
            ]
        ].
        lineNr >= 255 ifTrue:[
            self codeLineNumber: lineNr on: aStream for:aCompiler.  
        ].
        aStream nextPut:selector.
        (aCompiler hasLineNumber:selector) ifTrue:[
            aStream nextPut:lineNr.
        ].
        valueNeeded ifFalse:[
            aStream nextPut:#drop
        ].
        ^ self
    ].

    argArray notNil ifTrue:[
        argArray do:[:arg |
            arg codeOn:aStream inBlock:b for:aCompiler
        ]
    ].

    isSuper ifTrue:[
        cls := aCompiler targetClass.
        realReceiver isHere ifTrue:[
            "/ same code as supersend, but targetClass starts search
        ] ifFalse:[
            "/ targetClasses superclass starts search
            cls := cls superclass.
        ].
        clsLitIndex := aCompiler addLiteral:cls.
        self emitSuperSendLiteralIndex:litIndex classLiteralIndex:clsLitIndex numArgs:nargs line:lineNr on:aStream for:aCompiler.
        valueNeeded ifFalse:[
            aStream nextPut:#drop
        ].
        ^ self
    ].

    (nargs == 0) ifTrue:[
        (selector == #yourself) ifTrue:[
            "yourself is often added to get the receiver -
             we get it without the yourself-message"

            valueNeeded ifFalse:[
                aStream nextPut:#drop
            ].
            ^ self
        ].
    ].

    alreadyDropped := false.
    valueNeeded ifTrue:[ noSendDrop := true ].

    litIndex <= 255 ifTrue:[
        (nargs <= 3) ifTrue:[
            noSendDrop ifTrue:[
                code := #(send0 send1 send2 send3) at:(nargs+1).
            ] ifFalse:[
                code := #(sendDrop0 sendDrop1 sendDrop2 sendDrop3) at:(nargs+1).
                alreadyDropped := true.
            ].
            lineNr >= 255 ifTrue:[
                self codeLineNumber: lineNr on: aStream for:aCompiler.  
            ].
            aStream nextPut:code; nextPut:lineNr; nextPut:litIndex.
            valueNeeded ifFalse:[
                alreadyDropped ifFalse:[
                    aStream nextPut:#drop
                ].
            ].
            ^ self
        ].

        noSendDrop ifTrue:[
            code := #send
        ] ifFalse:[
            code := #sendDrop.
            alreadyDropped := true.
        ].
        lineNr >= 255 ifTrue:[
            self codeLineNumber: lineNr on: aStream for:aCompiler.  
        ].
        aStream nextPut:code; nextPut:lineNr; nextPut:litIndex; nextPut:nargs.
        valueNeeded ifFalse:[
            alreadyDropped ifFalse:[
                aStream nextPut:#drop
            ].
        ].
        ^ self
    ].

    self emitSendLiteralIndex:litIndex numArgs:nargs line:lineNr on:aStream for:aCompiler.
    valueNeeded ifFalse:[
        aStream nextPut:#drop
    ].

    "Modified: / 16-07-1998 / 20:26:52 / cg"
    "Modified: / 13-04-2013 / 10:46:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeTimesRepeatOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for n timesRepeat:[ ... ]"

    |pos1 pos2 lateEval loopCount|

    lateEval := false.

    receiver isConstant ifTrue:[
        loopCount := receiver evaluate.
        (loopCount isMemberOf:SmallInteger) ifFalse:[
            loopCount := nil.
        ] ifTrue:[
            loopCount <= 0 ifTrue:[
                "/ that's it - all we need is the receiver on the stack
                valueNeeded ifTrue:[
                    receiver codeOn:aStream inBlock:b for:aCompiler.
                ].
                ^ self
            ]
        ].
    ].

    receiver codeOn:aStream inBlock:b for:aCompiler.

    valueNeeded ifTrue:[
        "/ easily reconstructable - no need to keep on stack
        loopCount notNil ifTrue:[
            lateEval := true.
        ].
        lateEval ifFalse:[
            aStream nextPut:#dup
        ].
    ].

    loopCount isNil ifTrue:[
        aStream nextPut:#pushgt0; nextPut:lineNr; nextPut:#falseJump.
        pos2 := aStream position + 1.
        aStream nextPut:0.
    ].

    pos1 := aStream position + 1.
    (argArray at:1) codeInlineOn:aStream inBlock:b valueNeeded:false for:aCompiler.
    aStream nextPut:#minus1; nextPut:lineNr.
    aStream nextPut:#pushgt0; nextPut:lineNr.
    aStream nextPut:#trueJump; nextPut:pos1.

    pos2 notNil ifTrue:[
        (aStream contents) at:pos2 put:(aStream position + 1).
    ].
    aStream nextPut:#drop.  "/ drop run variable

    lateEval ifTrue:[
        receiver codeOn:aStream inBlock:b for:aCompiler.
    ]

    "Modified: 27.5.1997 / 14:28:49 / cg"
!

codeToByDoOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for a to:b by:c do:[:arg | ... ]"

    |pos pos2 start stop step lateEval theBlock loopVarIndex
     stepVal stopVarIndex|

    "/ NOTICE: could compile it as a timesRepeat-like loop, if
    "/ the loop-counter is not accessed within the loop-block.
    "/ This generates somewhat (15%) faster code, but makes
    "/ debugging somewhat difficult (no loop-value seen in debugger).

    start := receiver.
    stop := (argArray at:1).
    step := (argArray at:2).

"/    stop isConstant ifFalse:[self error:'should not happen' mayProceed:true].
"/    (stop evaluate isMemberOf:SmallInteger) ifFalse:[self error:'should not happen' mayProceed:true].

    step isConstant ifFalse:[self error:'should not happen' mayProceed:true].
    stepVal := step evaluate.
    (stepVal isMemberOf:SmallInteger) ifFalse:[
        self error:'should not happen' mayProceed:true
    ].

    start codeOn:aStream inBlock:b for:aCompiler.

    lateEval := false.

    valueNeeded ifTrue:[
        "/ easily reconstructable - no need to keep on stack
        start isConstant ifTrue:[
            (start evaluate isMemberOf:SmallInteger) ifTrue:[
                lateEval := true.
            ]
        ].
        lateEval ifFalse:[
            aStream nextPut:#dup
        ].
    ].

    "/ if stop is not constant, and not an argVar,
    "/  evaluate it into a temp slot ...

    (stop isConstant and:[stop type == #Integer]) ifFalse:[
        "/ a method/blockArg is constant as well ...
        (stop isVariable and:[stop isArgument]) ifFalse:[
            stop codeOn:aStream inBlock:b for:aCompiler.

            b isNil ifTrue:[
                stopVarIndex := aCompiler addTempVar.
                aStream nextPut:#storeMethodVar; nextPut:stopVarIndex.
            ] ifFalse:[
                stopVarIndex := b addTempVar.
                aStream nextPut:#storeBlockVar; nextPut:stopVarIndex.
            ].
        ]
    ].

    pos := aStream position + 1.

    aStream nextPut:#dup.
    stopVarIndex notNil ifTrue:[
        b isNil ifTrue:[
            aStream nextPut:#pushMethodVar; nextPut:stopVarIndex.
        ] ifFalse:[
            aStream nextPut:#pushBlockVar; nextPut:stopVarIndex.
        ]
    ] ifFalse:[
        stop codeOn:aStream inBlock:b for:aCompiler.
    ].
    stepVal >= 0 ifTrue:[
        aStream nextPut:#>.
    ] ifFalse:[
        aStream nextPut:#<.
    ].
    (aCompiler hasLineNumber:selector) ifTrue:[
        aStream nextPut:lineNr.
    ].
    aStream nextPut:#trueJump.
    pos2 := aStream position + 1.
    aStream nextPut:0.

    theBlock := argArray at:3.

    "/ need a temporary in the outer context for
    "/ the loop ...
    b isNil ifTrue:[
        loopVarIndex := aCompiler addTempVar.
        aStream nextPut:#dup.
        aStream nextPut:#storeMethodVar; nextPut:loopVarIndex.
    ] ifFalse:[
        loopVarIndex := b addTempVar.
        aStream nextPut:#dup.
        aStream nextPut:#storeBlockVar; nextPut:loopVarIndex.
    ].
    theBlock indexOfFirstTemp:loopVarIndex.

    theBlock codeInlineOn:aStream inBlock:b valueNeeded:false for:aCompiler.

    "/ increment/decrement counter & jump back.

    stepVal == 1 ifTrue:[
        aStream nextPut:#plus1; nextPut:lineNr.
    ] ifFalse:[
        stepVal == -1 ifTrue:[
            aStream nextPut:#minus1; nextPut:lineNr.
        ] ifFalse:[
            step codeOn:aStream inBlock:b for:aCompiler.
            aStream nextPut:#+.
            (aCompiler hasLineNumber:#+) ifTrue:[
                aStream nextPut:lineNr.
            ].
        ]
    ].

    aStream nextPut:#jump; nextPut:pos.

    (aStream contents) at:pos2 put:(aStream position + 1).
    aStream nextPut:#drop.  "/ drop run variable
    lateEval ifTrue:[
        start codeOn:aStream inBlock:b for:aCompiler.
    ].

    "/ no need to nil-out loop-tempVar to help GC
    "/ (its integer, anyway).

    b isNil ifTrue:[
        aCompiler removeTempVar
    ] ifFalse:[
        b removeTempVar
    ].

    stopVarIndex notNil ifTrue:[
        b isNil ifTrue:[
            aCompiler removeTempVar
        ] ifFalse:[
            b removeTempVar
        ]
    ].

    "Created: 27.6.1997 / 12:48:18 / cg"
    "Modified: 27.6.1997 / 13:43:06 / cg"
!

codeToDoOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for n to:n do:[:unusedArg | ... ]"

    |pos pos2 start stop lateEval theBlock loopVarIndex
     stopVarIndex|

    "/ NOTICE: could compile it as a timesRepeat, if
    "/ the loop-counter is not accessed within the loop-block.
    "/ This generates somewhat (15%) faster code, but makes
    "/ debugging somewhat difficult (no loop-value seen in debugger).

    start := receiver.
    stop := (argArray at:1).
"/    stop isConstant ifFalse:[self halt:'should not happen'].
"/    (stop evaluate isMemberOf:SmallInteger) ifFalse:[self halt:'should not happen'].

    start codeOn:aStream inBlock:b for:aCompiler.

    lateEval := false.

    valueNeeded ifTrue:[
        "/ easily reconstructable - no need to keep on stack
        start isConstant ifTrue:[
            (start evaluate isMemberOf:SmallInteger) ifTrue:[
                lateEval := true.
            ]
        ].
        lateEval ifFalse:[
            aStream nextPut:#dup
        ].
    ].

    "/ if stop is not constant, and not an argVar,
    "/  evaluate it into a temp slot ...

    (stop isConstant and:[stop type == #Integer]) ifFalse:[
        "/ a method/blockArg is constant as well ...
        (stop isVariable and:[stop isArgument]) ifFalse:[
            stop codeOn:aStream inBlock:b for:aCompiler.

            b isNil ifTrue:[
                stopVarIndex := aCompiler addTempVar.
                aStream nextPut:#storeMethodVar; nextPut:stopVarIndex.
            ] ifFalse:[
                stopVarIndex := b addTempVar.
                aStream nextPut:#storeBlockVar; nextPut:stopVarIndex.
            ].
        ]
    ].

    pos := aStream position + 1.

    aStream nextPut:#lineno; nextPut:lineNr.

    aStream nextPut:#dup.
    stopVarIndex notNil ifTrue:[
        b isNil ifTrue:[
            aStream nextPut:#pushMethodVar; nextPut:stopVarIndex.
        ] ifFalse:[
            aStream nextPut:#pushBlockVar; nextPut:stopVarIndex.
        ]
    ] ifFalse:[
        stop codeOn:aStream inBlock:b for:aCompiler.
    ].
    aStream nextPut:#>.
    (aCompiler hasLineNumber:selector) ifTrue:[
        aStream nextPut:lineNr.
    ].
    aStream nextPut:#trueJump.
    pos2 := aStream position + 1.
    aStream nextPut:0.

    theBlock := argArray at:2.

    "/ need a temporary in the outer context for
    "/ the loop ...
    b isNil ifTrue:[
        loopVarIndex := aCompiler addTempVar.
        aStream nextPut:#dup.
        aStream nextPut:#storeMethodVar; nextPut:loopVarIndex.
    ] ifFalse:[
        loopVarIndex := b addTempVar.
        aStream nextPut:#dup.
        aStream nextPut:#storeBlockVar; nextPut:loopVarIndex.
    ].
    theBlock indexOfFirstTemp:loopVarIndex.

    theBlock codeInlineOn:aStream inBlock:b valueNeeded:false for:aCompiler.

    "/ increment counter & jump back.

    aStream nextPut:#plus1; nextPut:lineNr; nextPut:#jump; nextPut:pos.

    (aStream contents) at:pos2 put:(aStream position + 1).
    aStream nextPut:#drop.  "/ drop run variable
    lateEval ifTrue:[
        start codeOn:aStream inBlock:b for:aCompiler.
    ].

    "/ no need to nil-out loop-tempVar to help GC
    "/ (its integer, anyway).

    b isNil ifTrue:[
        aCompiler removeTempVar
    ] ifFalse:[
        b removeTempVar
    ].

    stopVarIndex notNil ifTrue:[
        b isNil ifTrue:[
            aCompiler removeTempVar
        ] ifFalse:[
            b removeTempVar
        ]
    ].

    "Created: 26.6.1997 / 10:58:47 / cg"
    "Modified: 19.10.1997 / 01:31:40 / cg"
!

codeValueSendOn:aStream for:aCompiler
    "/ send #value to the top of the stack ...
    aStream nextPut:#value.
    (aCompiler hasLineNumber:#value) ifTrue:[
        aStream nextPut:lineNr.
    ]
!

codeWhileOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for
        [...] whileXXX:[ ... ] 
     and also 
        [...] whileXXX
    "

    |pos pos2 theReceiver theArg theByteCode optByteCode needLineNr blockExpr
     hasLoopBlock fastReceiver condStats constCondition|

    hasLoopBlock := true.
    (selector == #whileTrue:) ifTrue:[
        theByteCode := #falseJump.
    ] ifFalse:[
        (selector == #whileFalse:) ifTrue:[
            theByteCode := #trueJump
        ] ifFalse:[
            hasLoopBlock := false.
            (selector == #whileTrue) ifTrue:[
                theByteCode := #trueJump
            ] ifFalse:[
                theByteCode := #falseJump
            ].
        ]
    ].

    theReceiver := receiver.

    (receiver isBlock
    and:[(condStats := receiver statements) notNil
    and:[condStats nextStatement isNil
    and:[condStats expression notNil]]])
    ifTrue:[
        fastReceiver := receiver statements expression.
        optByteCode := self optimizedConditionFor:fastReceiver with:theByteCode for:aCompiler.
    ] ifFalse:[
        optByteCode := self optimizedConditionFor:theReceiver with:theByteCode for:aCompiler.
    ].

    optByteCode notNil ifTrue:[
        ((optByteCode == #eqJump) or:[optByteCode == #notEqJump]) ifTrue:[
            theArg := receiver statements expression arg1
        ].
        theReceiver := receiver statements expression receiver.
        theByteCode := optByteCode
    ].

"/ OLD:
"/    valueNeeded ifTrue:[aStream nextPut:#pushNil].
"/
    needLineNr := true.

    pos := aStream position + 1.

"/    aCompiler lineNumberInfo == #full ifTrue:[
        self codeLineNumber:lineNr on:aStream for:aCompiler.
        needLineNr := false.
"/    ].

    optByteCode notNil ifTrue:[
        theReceiver codeOn:aStream inBlock:b for:aCompiler.
        theArg notNil ifTrue:[
            theArg codeOn:aStream inBlock:b for:aCompiler
        ]
    ] ifFalse:[
        (fastReceiver notNil 
        and:[fastReceiver isConstant]) ifTrue:[
            constCondition := fastReceiver evaluate.
            theByteCode == #trueJump ifTrue:[
                constCondition == true ifTrue:[
                    theByteCode := #jump
                ] ifFalse:[
                    constCondition == false ifTrue:[
                        theByteCode := #never
                    ]
                ]
            ] ifFalse:[
                theByteCode == #falseJump ifTrue:[
                    constCondition == false ifTrue:[
                        theByteCode := #jump
                    ] ifFalse:[
                        constCondition == true ifTrue:[
                            theByteCode := #never
                        ]
                    ]
                ]
            ]
        ].

        (theByteCode ~~ #jump and:[theByteCode ~~ #never]) ifTrue:[
            theReceiver codeInlineOn:aStream inBlock:b for:aCompiler.
        ].

        "/
        "/ cannot enable code below 
        "/ (tiny loops would not be debuggable with next, since lineNo remains the same)
        "/ think about it ...
        "/
        blockExpr := theReceiver simpleSendBlockExpression.
        blockExpr notNil ifTrue:[
            blockExpr isMessage ifTrue:[
                (aCompiler hasLineNumber:(blockExpr selector)) ifTrue:[
                    blockExpr lineNumber == lineNr ifTrue:[
                        needLineNr := false
                    ]
                ]
            ]
        ].
    ].

    needLineNr ifTrue:[
        self codeLineNumber:lineNr on:aStream for:aCompiler.
    ].

    hasLoopBlock ifFalse:[
        "/ simple [...] whileXXX
        theByteCode ~~ #never ifTrue:[
            aStream nextPut:theByteCode; nextPut:pos.
        ].

        valueNeeded ifTrue:[aStream nextPut:#pushNil].
        ^ self
    ].

    "/ [...] whileXXX:[...]

    theByteCode ~~ #never ifTrue:[
        aStream nextPut:theByteCode.
        pos2 := aStream position + 1.
        aStream nextPut:0.
    ].

    (argArray at:1) codeInlineOn:aStream inBlock:b valueNeeded:false for:aCompiler.
    aStream nextPut:#jump; nextPut:pos.
    theByteCode ~~ #never ifTrue:[
        (aStream contents) at:pos2 put:(aStream position + 1).
    ].

    valueNeeded ifTrue:[aStream nextPut:#pushNil].

    "Modified: 22.10.1996 / 21:34:37 / cg"
!

new_codeWhileOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for
        [...] whileXXX:[ ... ] 
     and also 
        [...] whileXXX

     This generates the check at the end and should generate better
     code (only 1 conditional-branch at the end instead of 2 branches).
     However, for now, it is disabled, since the JIT has special provisions
     to detect loops and actually generates better machine code for the
     old bytecode sequence ... (sigh)
    "

    |pos pos0 theReceiver theArg theByteCode optByteCode needLineNr blockExpr
     hasLoopBlock fastReceiver condStats constCondition|

    hasLoopBlock := true.
    (selector == #whileTrue:) ifTrue:[
        theByteCode := #trueJump.
    ] ifFalse:[
        (selector == #whileFalse:) ifTrue:[
            theByteCode := #falseJump
        ] ifFalse:[
            hasLoopBlock := false.
            (selector == #whileTrue) ifTrue:[
                theByteCode := #trueJump
            ] ifFalse:[
                theByteCode := #falseJump
            ].
        ]
    ].

    theReceiver := receiver.

    (receiver isBlock
    and:[(condStats := receiver statements) notNil
    and:[condStats nextStatement isNil
    and:[(fastReceiver := condStats expression) notNil]]])
    ifTrue:[
        optByteCode := self optimizedConditionFor:fastReceiver with:theByteCode for:aCompiler.
    ] ifFalse:[
        optByteCode := self optimizedConditionFor:theReceiver with:theByteCode for:aCompiler.
    ].

    optByteCode notNil ifTrue:[
        ((optByteCode == #eqJump) or:[optByteCode == #notEqJump]) ifTrue:[
            theArg := receiver statements expression arg1
        ].
        theReceiver := receiver statements expression receiver.
        theByteCode := optByteCode
    ].

    needLineNr := true.

    hasLoopBlock ifTrue:[
        (argArray at:1) isEmptyBlock ifFalse:[
            aStream nextPut:#jump.
            pos0 := aStream position + 1.
            aStream nextPut:0.

            pos := aStream position + 1.
            (argArray at:1) codeInlineOn:aStream inBlock:b valueNeeded:false for:aCompiler.

            (aStream contents) at:pos0 put:(aStream position + 1).
        ]
    ] ifFalse:[
        pos := aStream position + 1.
    ].

    optByteCode isNil ifTrue:[
        blockExpr := theReceiver simpleSendBlockExpression.
        blockExpr notNil ifTrue:[
            blockExpr isMessage ifTrue:[
                (aCompiler hasLineNumber:(blockExpr selector)) ifTrue:[
                    blockExpr lineNumber == lineNr ifTrue:[
                        needLineNr := false
                    ]
                ]
            ]
        ].
    ].

    needLineNr ifTrue:[
        self codeLineNumber:lineNr on:aStream for:aCompiler.
    ].
    needLineNr := false.

    optByteCode notNil ifTrue:[
        theReceiver codeOn:aStream inBlock:b for:aCompiler.
        theArg notNil ifTrue:[
            theArg codeOn:aStream inBlock:b for:aCompiler
        ]
    ] ifFalse:[
        (fastReceiver notNil 
        and:[fastReceiver isConstant]) ifTrue:[
            constCondition := fastReceiver evaluate.
            theByteCode == #trueJump ifTrue:[
                constCondition == true ifTrue:[
                    theByteCode := #jump
                ] ifFalse:[
                    constCondition == false ifTrue:[
                        theByteCode := #never
                    ]
                ]
            ] ifFalse:[
                theByteCode == #falseJump ifTrue:[
                    constCondition == false ifTrue:[
                        theByteCode := #jump
                    ] ifFalse:[
                        constCondition == true ifTrue:[
                            theByteCode := #never
                        ]
                    ]
                ]
            ]
        ].

        (theByteCode ~~ #jump and:[theByteCode ~~ #never]) ifTrue:[
            theReceiver codeInlineOn:aStream inBlock:b for:aCompiler.
        ].
    ].

    hasLoopBlock ifFalse:[
        "/ simple [...] whileXXX
        theByteCode ~~ #never ifTrue:[
            aStream nextPut:theByteCode; nextPut:pos.
        ].

        valueNeeded ifTrue:[aStream nextPut:#pushNil].
        ^ self
    ].

    "/ [...] whileXXX:[...]

    theByteCode ~~ #never ifTrue:[
        aStream nextPut:theByteCode.
        aStream nextPut:pos.
    ].


    valueNeeded ifTrue:[aStream nextPut:#pushNil].

    "Modified: 22.10.1996 / 21:34:37 / cg"
!

optimizedConditionFor:aReceiver with:aByteCode for:aCompiler
    |rec sel stats|

    rec := aReceiver.
    (rec isBlock) ifTrue:[
        (stats := rec statements) notNil ifTrue:[
            stats nextStatement isNil ifTrue:[
                rec := rec statements expression
            ]
        ]
    ].
    (rec isUnaryMessage) ifTrue:[
        sel := rec selector.
        (sel == #isNil) ifTrue:[
            "/
            "/ isNil trueJmp  -> nilJump
            "/ isNil falseJmp -> notNilJump
            "/
            aCompiler addLiteral:#isNil.
            (aByteCode == #trueJump) ifTrue:[^ #nilJump].
            (aByteCode == #falseJump) ifTrue:[^ #notNilJump]
        ].
        (sel == #notNil) ifTrue:[
            "/
            "/ notNil trueJmp  -> notNilJump
            "/ notNil falseJmp -> nilJump
            "/
            aCompiler addLiteral:#notNil.
            (aByteCode == #trueJump) ifTrue:[^ #notNilJump].
            (aByteCode == #falseJump) ifTrue:[^ #nilJump]
        ].
        (sel == #not) ifTrue:[
            "/
            "/ not trueJmp  -> falseJump
            "/ not falseJmp -> trueJump
            "/
            aCompiler addLiteral:#not.
            (aByteCode == #trueJump) ifTrue:[^ #falseJump].
            (aByteCode == #falseJump) ifTrue:[^ #trueJump]
        ].
        ^ nil
    ].
    (rec isBinaryMessage) ifTrue:[
        sel := rec selector.
        rec arg1 isConstant ifTrue:[
            (rec arg1 value == 0) ifTrue:[
                "/
                "/ ==0 trueJmp  -> zeroJump
                "/ ==0 falseJmp -> notZeroJump
                "/
                (sel == #==) ifTrue:[
                    aCompiler addLiteral:#==.
                    (aByteCode == #trueJump) ifTrue:[^ #zeroJump].
                    (aByteCode == #falseJump) ifTrue:[^ #notZeroJump]
                ].
                "/
                "/ ~~0 trueJmp  -> notZeroJump
                "/ ~~0 falseJmp -> zeroJump
                "/
                (sel == #~~) ifTrue:[
                    aCompiler addLiteral:#~~.
                    (aByteCode == #falseJump) ifTrue:[^ #zeroJump].
                    (aByteCode == #trueJump) ifTrue:[^ #notZeroJump]
                ].
                ^ nil
            ]
        ].
        (sel == #==) ifTrue:[
            "/
            "/ == trueJmp  -> eqJump
            "/ == falseJmp -> notEqJump
            "/
            aCompiler addLiteral:#==.
            (aByteCode == #trueJump) ifTrue:[^ #eqJump].
            (aByteCode == #falseJump) ifTrue:[^ #notEqJump]
        ].
        (sel == #~~) ifTrue:[
            "/
            "/ ~~ trueJmp  -> notEqJump
            "/ ~~ falseJmp -> eqJump
            "/
            aCompiler addLiteral:#~~.
            (aByteCode == #falseJump) ifTrue:[^ #eqJump].
            (aByteCode == #trueJump) ifTrue:[^ #notEqJump]
        ]
    ].
    ^ nil
!

tryFoldedIfOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    |rVal branch|

    receiver isConstant ifTrue:[
        rVal := receiver evaluate.
        rVal == true ifTrue:[
            (selector == #ifFalse:) ifTrue:[
                valueNeeded ifTrue:[
                    "/ true ifFalse:[] - evaluates to nil.
                    aStream nextPut:#pushNil
                ].
                ^ true.
            ].
            ((selector == #ifTrue:) or:[selector == #ifTrue:ifFalse:]) ifTrue:[
                branch := (argArray at: 1).
            ].
            (selector == #ifFalse:ifTrue:) ifTrue:[
                branch := (argArray at: 2).
            ].
        ].
        rVal == false ifTrue:[
            (selector == #ifTrue:) ifTrue:[
                valueNeeded ifTrue:[
                    "/ false ifTrue:[] - evaluates to nil.
                    aStream nextPut:#pushNil
                ].
                ^ true.
            ].
            ((selector == #ifFalse:) or:[selector == #ifFalse:ifTrue:]) ifTrue:[
                branch := (argArray at: 1).
            ].
            (selector == #ifTrue:ifFalse:) ifTrue:[
                branch := (argArray at: 2).
            ].
        ].
        branch notNil ifTrue:[
            self codeBlockEvaluation:branch on:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler.
            ^ true.
        ]
    ].
    ^ false
! !

!MessageNode methodsFor:'printing & storing'!

printOn:aStream indent:i 
    |selectorParts|

    (#( whileTrue: whileFalse: ) includes:selector) ifTrue:[
        receiver isBlock ifTrue:[
            ^ self printWhileOn:aStream indent:i
        ].
    ].
    selectorParts := selector keywords.
    receiver printOn:aStream indent:i parenthized:(receiver precedence <= self precedence).
    argArray notNil ifTrue:[
        argArray with:selectorParts
            do:[:arg :selPart | 
                aStream
                    cr;
                    spaces:i + 4;
                    nextPutAll:selPart.
                arg printOn:aStream 
                    indent:i + 4 
                    parenthized:(arg precedence <= self precedence).
            ]
    ].

    "Modified: / 06-07-2011 / 09:44:55 / cg"
!

printWhileOn:aStream indent:i
    "special handling of whileTrue/whileFalse"

    |arg|

    aStream nextPutAll:'['.
    receiver statements printOn:aStream indent:i.
    aStream nextPutAll:'] ',selector,' '.

    arg := argArray at:1.
    arg printOn:aStream indent:i parenthized:(arg precedence <= self precedence).
! !

!MessageNode methodsFor:'queries'!

argumentCount
    "VisualAge/ANSI compatibility - same as numArgs"

    ^ argArray size
!

collectBlocksInto:aCollection
    receiver collectBlocksInto:aCollection.
    argArray size > 0 ifTrue:[
        argArray do:[:arg |
            arg collectBlocksInto:aCollection.
        ]
    ].

    "Created: 23.10.1996 / 15:44:49 / cg"
    "Modified: 23.10.1996 / 16:03:46 / cg"
!

containsReturn
    receiver containsReturn ifTrue:[^ true].
    ^ self arguments contains:[:arg | arg containsReturn]
!

isCascade
    ^ false

    "Created: / 16.7.1998 / 20:03:42 / cg"
!

numArgs
    ^ argArray size
!

precedence
    ^ 10

    "Created: / 20-04-2005 / 14:10:59 / cg"
!

realReceiver
    receiver isCascade ifTrue:[
        ^ receiver realReceiver
    ].
    self isCascade ifTrue:[
        ^ receiver receiver
    ].

    ^ receiver

    "Modified: / 17.7.1998 / 02:09:05 / cg"
!

withConstantValueDo:aBlock
    "return true, if this evaluates to a constant value
     and evaluate aBlock with it. 
     Also return true, if the node can be evaluated at compile time.
     Used for constant folding"

    |recVal argValues allArgsConstant fold cond2 condVal2|

    (receiver isGlobal and:[receiver name = 'Smalltalk']) ifTrue:[
        "/ (Smalltalk respondsTo:#isSmalltalkX) -> true
        (selector == #respondsTo:) ifTrue:[
            argArray size == 1 ifTrue:[
                argArray first isConstant ifTrue:[
                    (#(isSmalltalkX isVisualSmalltalkEnterprise isVisualWorks isSqueak isDolphinSmalltalk)
                        includesIdentical: argArray first value)
                    ifTrue:[
                        "/ true here !!
                        aBlock value:true.
                        ^ true
                    ].
                ].
            ].
        ].
        "/ (Smalltalk isSmalltalkX) -> true
        (selector == #isSmalltalkX) ifTrue:[
            "/ true here !!
            aBlock value:true.
            ^ true
        ].
        "/ (Smalltalk isVisualSmalltalkEnterprise) -> false
        ((selector == #isVisualSmalltalkEnterprise) 
        or:[ (selector == #isVisualWorks) 
        or:[ (selector == #isDolphinSmalltalk) 
        or:[ (selector == #isSqueak) ]]]) ifTrue:[
            "/ true here !!
            aBlock value:false.
            ^ true
        ].
    ].

    (receiver withConstantValueDo:[:val | recVal := val]) ifTrue:[
        argValues := Array new:argArray size.
        allArgsConstant := true.
        argArray notNil ifTrue:[
            argArray doWithIndex:[:arg :index |
                allArgsConstant := allArgsConstant
                                and:[ arg withConstantValueDo:[:val | argValues at:index put:val] ]
            ].
        ].
        allArgsConstant ifTrue:[
            fold := true.

            "/ only a few messages are checked:
            recVal isNumber ifTrue:[
                (#(positive negative abs negated + - * == = ~= ~~) includes:selector) ifFalse:[
                    recVal isInteger ifTrue:[
                        (#(<< bitShift: bitAnd: bitOr:) includes:selector) ifFalse:[
                            ^ false
                        ].
                    ] ifFalse:[
                        ^ false
                    ]
                ].
            ] ifFalse:[
                recVal isBoolean ifTrue:[
                    (#(not && || ) includes:selector) ifFalse:[
                        ^ false
                    ].
                ] ifFalse:[
                    recVal isString ifTrue:[
                        (#(size) includes:selector) ifFalse:[
                            ^ false
                        ].
                    ] ifFalse:[
                        recVal isArray ifTrue:[
                            (#(size) includes:selector) ifFalse:[
                                ^ false
                            ].
                        ] ifFalse:[
                            ^ false
                        ]
                    ].
                ]
            ].
        
            aBlock value:(recVal perform:selector withArguments:argValues).
            ^ true
        ].

        "/ detects: ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
        selector == #and: ifTrue:[
            recVal == false ifTrue:[
                "/ false here !!
                aBlock value:recVal.
                ^ true "/ constant
            ].
            recVal == true ifTrue:[
                argArray first isBlockNode ifTrue:[
                    argArray first isSingleExpressionBlock ifTrue:[
                        cond2 := argArray first simpleSendBlockExpression.
                        cond2 notNil ifTrue:[
                            (cond2 withConstantValueDo:[:val | condVal2 := val]) ifTrue:[
                                aBlock value:condVal2.
                                ^ true "/ constant
                            ]
                        ]
                    ]                                          
                ]
            ].
        ].
    ].
    ^ false

    "Modified: / 12-09-2012 / 12:27:52 / cg"
! !

!MessageNode methodsFor:'testing'!

isMessage
    ^ true
! !

!MessageNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitMessageNode:self
! !

!MessageNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id $'
! !

