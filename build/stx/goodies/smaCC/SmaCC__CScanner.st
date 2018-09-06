"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCScanner subclass:#CScanner
	instanceVariableNames:'typeNames'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Example Parsers'
!


!CScanner class methodsFor:'generated-comments'!

scannerDefinitionComment

	"<H>: [a-fA-F0-9]        ;
<IS>: [uUlL]    ;
<D>: [0-9]      ;
<E>: [Ee][\+\-]?<D>+    ;
<FS>: [fFlL]    ;
<ELLIPSIS> : \.\.\. ;
<comment>: \/ \*        ;
<LETTER> : [a-zA-Z_] ;
<DIGIT> : [0-9] ;
<IDENTIFIER>: <LETTER> (<LETTER>|<DIGIT>)*      ;
<CONSTANT>: (0[xX]<H>+<IS>?) | 
                                (<D>+<IS>?) | 
                                (<D>+<E><FS>?) | 
                                <D>*\.<D>+<E>?<FS>? | 
                                (L? \' ( (\\ .) | ([^\\\""]) )+ \')      ;

<STRING_LITERAL>: L? \"" ( (\\ .) | ([^\\\""]) )* \""      ;

<LEFT_BLOCK>: \[ | (\< \:)      ;
<RIGHT_BLOCK>: \] | (\: \>)     ;
<LEFT_BRACE>: \{ | (\< \%)      ;
<RIGHT_BRACE>: \} | (\% \>)     ;

<whitespace>: \s+       ;
"

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CScanner class methodsFor:'generated-initialization'!

initializeKeywordMap
    keywordMap := Dictionary new.
    #( #(IDENTIFIER 'auto' 65)
     #(IDENTIFIER 'break' 48)
     #(IDENTIFIER 'case' 38)
     #(IDENTIFIER 'char' 73)
     #(IDENTIFIER 'const' 40)
     #(IDENTIFIER 'continue' 47)
     #(IDENTIFIER 'default' 39)
     #(IDENTIFIER 'do' 54)
     #(IDENTIFIER 'double' 70)
     #(IDENTIFIER 'else' 46)
     #(IDENTIFIER 'enum' 45)
     #(IDENTIFIER 'extern' 58)
     #(IDENTIFIER 'float' 67)
     #(IDENTIFIER 'for' 49)
     #(IDENTIFIER 'goto' 50)
     #(IDENTIFIER 'if' 42)
     #(IDENTIFIER 'int' 69)
     #(IDENTIFIER 'long' 66)
     #(IDENTIFIER 'register' 71)
     #(IDENTIFIER 'return' 56)
     #(IDENTIFIER 'short' 68)
     #(IDENTIFIER 'signed' 51)
     #(IDENTIFIER 'sizeof' 24)
     #(IDENTIFIER 'static' 61)
     #(IDENTIFIER 'struct' 43)
     #(IDENTIFIER 'switch' 52)
     #(IDENTIFIER 'typedef' 57)
     #(IDENTIFIER 'union' 44)
     #(IDENTIFIER 'unsigned' 55)
     #(IDENTIFIER 'void' 72)
     #(IDENTIFIER 'volatile' 41)
     #(IDENTIFIER 'while' 53) ) 
            do:[:each | 
                (keywordMap at:each first ifAbsentPut:[ Dictionary new ]) at:(each at:2)
                    put:each last
            ].
    ^ keywordMap

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CScanner class methodsFor:'public'!

needsLineNumbers
	^true
! !

!CScanner methodsFor:'default token handling'!

comment
	| char |
	
	[[(char := stream next) isNil or: [char == $*]] whileFalse.
	stream atEnd ifTrue: [self scannerError].
	stream peekFor: $/] 
			whileFalse.
	^self whitespace
! !

!CScanner methodsFor:'generated-scanner'!

scan1
    [
        self recordMatch:#( 77 ).
        self step.
        (currentCharacter isXMLDigit)
    ] whileTrue.
    (currentCharacter == $F 
        or:[
            currentCharacter == $L 
                or:[ currentCharacter == $f or:[ currentCharacter == $l ] ]
        ]) 
            ifTrue:[ ^ self recordAndReportMatch:#( 77 ). ].
    ^ self reportLastMatch

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

scan2
    self step.
    (currentCharacter isXMLDigit) ifTrue:[
        ^ self scan3
    ].
    ^ self reportLastMatch

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

scan3
    [
        self recordMatch:#( 77 ).
        self step.
        (currentCharacter isXMLDigit)
    ] whileTrue.
    (currentCharacter == $F 
        or:[
            currentCharacter == $L 
                or:[ currentCharacter == $f or:[ currentCharacter == $l ] ]
        ]) 
            ifTrue:[ ^ self recordAndReportMatch:#( 77 ). ].
    (currentCharacter == $E or:[ currentCharacter == $e ]) ifTrue:[
        ^ self scan4
    ].
    ^ self reportLastMatch

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

scan4
    self step.
    (currentCharacter isXMLDigit) ifTrue:[
        ^ self scan1
    ].
    (currentCharacter == $+ or:[ currentCharacter == $- ]) ifTrue:[
        self step.
        (currentCharacter isXMLDigit) ifTrue:[
            ^ self scan1
        ].
        ^ self reportLastMatch
    ].
    ^ self reportLastMatch

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

scan5
    self step.
    (currentCharacter <= $!! 
        or:[ (currentCharacter between:$# and:$[) or:[ currentCharacter >= $] ] ]) 
            ifTrue:[ ^ self scan6 ].
    (currentCharacter == $\) ifTrue:[
        ^ self scan7
    ].
    ^ self reportLastMatch

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

scan6
    [
        self step.
        (currentCharacter <= $!! 
            or:[
                (currentCharacter between:$# and:$&) 
                    or:[ (currentCharacter between:$( and:$[) or:[ currentCharacter >= $] ] ]
            ])
    ] whileTrue.
    (currentCharacter == $') ifTrue:[
        [
            self recordMatch:#( 77 ).
            self step.
            (currentCharacter <= $!! 
                or:[
                    (currentCharacter between:$# and:$&) 
                        or:[ (currentCharacter between:$( and:$[) or:[ currentCharacter >= $] ] ]
                ]) 
                    ifTrue:[ ^ self scan6 ].
            (currentCharacter == $')
        ] whileTrue.
        (currentCharacter == $\) ifTrue:[
            ^ self scan7
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $\) ifTrue:[
        ^ self scan7
    ].
    ^ self reportLastMatch

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

scan7
    self step.
    (currentCharacter isImmediate) ifTrue:[
        ^ self scan6
    ].
    ^ self reportLastMatch

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

scan8
    [
        self step.
        (currentCharacter <= $!! 
            or:[ (currentCharacter between:$# and:$[) or:[ currentCharacter >= $] ] ])
    ] whileTrue.
    (currentCharacter == $") ifTrue:[
        ^ self recordAndReportMatch:#( 78 ).
    ].
    (currentCharacter == $\) ifTrue:[
        self step.
        (currentCharacter isImmediate) ifTrue:[
            ^ self scan8
        ].
        ^ self reportLastMatch
    ].
    ^ self reportLastMatch

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

scan9
    [
        self recordMatch:#( 77 ).
        self step.
        (currentCharacter isXMLDigit)
    ] whileTrue.
    (currentCharacter == $L 
        or:[
            currentCharacter == $U 
                or:[ currentCharacter == $l or:[ currentCharacter == $u ] ]
        ]) 
            ifTrue:[ ^ self recordAndReportMatch:#( 77 ). ].
    (currentCharacter == $E or:[ currentCharacter == $e ]) ifTrue:[
        ^ self scan4
    ].
    (currentCharacter == $.) ifTrue:[
        ^ self scan2
    ].
    ^ self reportLastMatch

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

scanForToken
    self step.
    ((currentCharacter between:$A and:$K) 
        or:[
            (currentCharacter between:$M and:$Z) 
                or:[ currentCharacter == $_ or:[ (currentCharacter between:$a and:$z) ] ]
        ]) 
            ifTrue:[
                [
                    self recordMatch:#IDENTIFIER.
                    self step.
                    (currentCharacter isLetterOrDigit or:[ currentCharacter == $_ ])
                ] whileTrue.
                ^ self reportLastMatch
            ].
    (currentCharacter between:$1 and:$9) ifTrue:[
        ^ self scan9
    ].
    (currentCharacter isSeparator 
        or:[ currentCharacter == (Character codePoint:16rB) ]) 
            ifTrue:[
                [
                    self recordMatch:#whitespace.
                    self step.
                    (currentCharacter isSeparator 
                        or:[ currentCharacter == (Character codePoint:16rB) ])
                ] whileTrue.
                ^ self reportLastMatch
            ].
    (currentCharacter == $!!) ifTrue:[
        self recordMatch:#( 32 ).
        self step.
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 4 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $") ifTrue:[
        ^ self scan8
    ].
    (currentCharacter == $%) ifTrue:[
        self recordMatch:#( 30 ).
        self step.
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 10 ).
        ].
        (currentCharacter == $>) ifTrue:[
            ^ self recordAndReportMatch:#( 82 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $&) ifTrue:[
        self recordMatch:#( 28 ).
        self step.
        (currentCharacter == $&) ifTrue:[
            ^ self recordAndReportMatch:#( 5 ).
        ].
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 63 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $') ifTrue:[
        ^ self scan5
    ].
    (currentCharacter == $() ifTrue:[
        ^ self recordAndReportMatch:#( 25 ).
    ].
    (currentCharacter == $)) ifTrue:[
        ^ self recordAndReportMatch:#( 26 ).
    ].
    (currentCharacter == $*) ifTrue:[
        self recordMatch:#( 34 ).
        self step.
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 12 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $+) ifTrue:[
        self recordMatch:#( 35 ).
        self step.
        (currentCharacter == $+) ifTrue:[
            ^ self recordAndReportMatch:#( 23 ).
        ].
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 11 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $,) ifTrue:[
        ^ self recordAndReportMatch:#( 21 ).
    ].
    (currentCharacter == $-) ifTrue:[
        self recordMatch:#( 36 ).
        self step.
        (currentCharacter == $-) ifTrue:[
            ^ self recordAndReportMatch:#( 20 ).
        ].
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 19 ).
        ].
        (currentCharacter == $>) ifTrue:[
            ^ self recordAndReportMatch:#( 22 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $.) ifTrue:[
        self recordMatch:#( 27 ).
        self step.
        (currentCharacter isXMLDigit) ifTrue:[
            ^ self scan3
        ].
        (currentCharacter == $.) ifTrue:[
            self step.
            (currentCharacter == $.) ifTrue:[
                ^ self recordAndReportMatch:#( 74 ).
            ].
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $/) ifTrue:[
        self recordMatch:#( 29 ).
        self step.
        (currentCharacter == $*) ifTrue:[
            ^ self recordAndReportMatch:#comment.
        ].
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 13 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $0) ifTrue:[
        self recordMatch:#( 77 ).
        self step.
        (currentCharacter isXMLDigit) ifTrue:[
            ^ self scan9
        ].
        (currentCharacter == $L 
            or:[
                currentCharacter == $U 
                    or:[ currentCharacter == $l or:[ currentCharacter == $u ] ]
            ]) 
                ifTrue:[ ^ self recordAndReportMatch:#( 77 ). ].
        (currentCharacter == $E or:[ currentCharacter == $e ]) ifTrue:[
            ^ self scan4
        ].
        (currentCharacter == $X or:[ currentCharacter == $x ]) ifTrue:[
            self step.
            (currentCharacter isXMLDigit 
                or:[
                    (currentCharacter between:$A and:$F) 
                        or:[ (currentCharacter between:$a and:$f) ]
                ]) 
                    ifTrue:[
                        [
                            self recordMatch:#( 77 ).
                            self step.
                            (currentCharacter isXMLDigit 
                                or:[
                                    (currentCharacter between:$A and:$F) 
                                        or:[ (currentCharacter between:$a and:$f) ]
                                ])
                        ] whileTrue.
                        (currentCharacter == $L 
                            or:[
                                currentCharacter == $U 
                                    or:[ currentCharacter == $l or:[ currentCharacter == $u ] ]
                            ]) 
                                ifTrue:[ ^ self recordAndReportMatch:#( 77 ). ].
                        ^ self reportLastMatch
                    ].
            ^ self reportLastMatch
        ].
        (currentCharacter == $.) ifTrue:[
            ^ self scan2
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $:) ifTrue:[
        self recordMatch:#( 16 ).
        self step.
        (currentCharacter == $>) ifTrue:[
            ^ self recordAndReportMatch:#( 80 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $;) ifTrue:[
        ^ self recordAndReportMatch:#( 60 ).
    ].
    (currentCharacter == $<) ifTrue:[
        self recordMatch:#( 18 ).
        self step.
        (currentCharacter == $%) ifTrue:[
            ^ self recordAndReportMatch:#( 81 ).
        ].
        (currentCharacter == $:) ifTrue:[
            ^ self recordAndReportMatch:#( 79 ).
        ].
        (currentCharacter == $<) ifTrue:[
            self recordMatch:#( 33 ).
            self step.
            (currentCharacter == $=) ifTrue:[
                ^ self recordAndReportMatch:#( 37 ).
            ].
            ^ self reportLastMatch
        ].
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 7 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $=) ifTrue:[
        self recordMatch:#( 17 ).
        self step.
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 3 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $>) ifTrue:[
        self recordMatch:#( 6 ).
        self step.
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 8 ).
        ].
        (currentCharacter == $>) ifTrue:[
            self recordMatch:#( 14 ).
            self step.
            (currentCharacter == $=) ifTrue:[
                ^ self recordAndReportMatch:#( 62 ).
            ].
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $?) ifTrue:[
        ^ self recordAndReportMatch:#( 15 ).
    ].
    (currentCharacter == $L) ifTrue:[
        self recordMatch:#IDENTIFIER.
        self step.
        (currentCharacter isLetterOrDigit or:[ currentCharacter == $_ ]) ifTrue:[
            [
                self recordMatch:#IDENTIFIER.
                self step.
                (currentCharacter isLetterOrDigit or:[ currentCharacter == $_ ])
            ] whileTrue.
            ^ self reportLastMatch
        ].
        (currentCharacter == $") ifTrue:[
            ^ self scan8
        ].
        (currentCharacter == $') ifTrue:[
            ^ self scan5
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $[) ifTrue:[
        ^ self recordAndReportMatch:#( 79 ).
    ].
    (currentCharacter == $]) ifTrue:[
        ^ self recordAndReportMatch:#( 80 ).
    ].
    (currentCharacter == $^) ifTrue:[
        self recordMatch:#( 1 ).
        self step.
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 64 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == ${) ifTrue:[
        ^ self recordAndReportMatch:#( 81 ).
    ].
    (currentCharacter == $|) ifTrue:[
        self recordMatch:#( 2 ).
        self step.
        (currentCharacter == $=) ifTrue:[
            ^ self recordAndReportMatch:#( 59 ).
        ].
        (currentCharacter == $|) ifTrue:[
            ^ self recordAndReportMatch:#( 9 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $}) ifTrue:[
        ^ self recordAndReportMatch:#( 82 ).
    ].
    (currentCharacter == $~) ifTrue:[
        ^ self recordAndReportMatch:#( 31 ).
    ].
    ^ self reportLastMatch

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CScanner methodsFor:'generated-tokens'!

CONSTANTId
	^77

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

IDENTIFIERId
	^76

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

TYPE_NAMEId
	^132

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

emptySymbolTokenId
	^147

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

errorTokenId
	^148

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CScanner methodsFor:'initialize-release'!

initialize
	super initialize.
	typeNames := Set new
! !

!CScanner methodsFor:'public'!

IDENTIFIER
	| name token |
	name := outputStream contents.
	matchActions := (typeNames includes: name) 
				ifTrue: [Array with: self TYPE_NAMEId]
				ifFalse: [Array with: self IDENTIFIERId].
	outputStream reset.
	token := SmaCCToken 
				value: name
				start: start
				id: matchActions.
	matchActions := nil.
	returnMatchBlock value: token
!

addTypeName: aString 
	typeNames add: aString
! !

!CScanner class methodsFor:'documentation'!

version
    ^ '$Id$'
! !

