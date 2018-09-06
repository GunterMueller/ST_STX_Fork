"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCScanner subclass:#SmaCCScannerScanner
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Scanner Generator'
!

SmaCCScannerScanner comment:'SmaCCScannerScanner is the scanner for the scanner definition'
!


!SmaCCScannerScanner class methodsFor:'generated-comments'!

scannerDefinitionComment

	"<backslashcharacter>    :       \\ [^cx] | \\ c [A-Z] | \\ x [0-9A-Fa-f]{1,4} ;
<characterblock>        : \[ ([^\]\\] | <backslashcharacter> )+ \] ;
<whitespace>    :       [\ \t\v\r\n]+ ;
<tokenname>     :       \< [a-zA-Z_] \w* \> ;
<comment>       :       \# [^\r\n]* ;
<repeat>        :       \{ [0-9]* \, [0-9]* \} ;
<character>     :       [^\ \t\v\\\r\n\{\(\[\.] ; 
<anycharacter>  : \. ;
"
! !

!SmaCCScannerScanner methodsFor:'generated-scanner'!

scan1
    [
        self step.
        (currentCharacter <= $[ or:[ currentCharacter >= $^ ])
    ] whileTrue.
    (currentCharacter == $\) ifTrue:[
        ^ self scan2
    ].
    (currentCharacter == $]) ifTrue:[
        ^ self recordAndReportMatch:#( 10 ).
    ].
    ^ self reportLastMatch
!

scan2
    self step.
    (currentCharacter <= $b 
        or:[ (currentCharacter between:$d and:$w) or:[ currentCharacter >= $y ] ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $c) ifTrue:[
        self step.
        (currentCharacter between:$A and:$Z) ifTrue:[
            ^ self scan1
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $x) ifTrue:[
        self step.
        (currentCharacter isNationalDigit 
            or:[
                (currentCharacter between:$A and:$F) 
                    or:[ (currentCharacter between:$a and:$f) ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        ^ self reportLastMatch
    ].
    ^ self reportLastMatch
!

scanForToken
    self step.
    (currentCharacter <= (Character codePoint:16r8) 
        or:[
            currentCharacter == (Character codePoint:16rC) 
                or:[
                    (currentCharacter between:(Character codePoint:16rE)
                        and:(Character codePoint:16r1F)) 
                            or:[
                                (currentCharacter between:$!! and:$") 
                                    or:[
                                        (currentCharacter between:$$ and:$') 
                                            or:[
                                                (currentCharacter between:$, and:$-) 
                                                    or:[
                                                        (currentCharacter between:$/ and:$9) 
                                                            or:[
                                                                (currentCharacter between:$= and:$>) 
                                                                    or:[
                                                                        (currentCharacter between:$@ and:$Z) 
                                                                            or:[ (currentCharacter between:$] and:$z) or:[ currentCharacter >= $} ] ]
                                                                    ]
                                                            ]
                                                    ]
                                            ]
                                    ]
                            ]
                ]
        ]) 
            ifTrue:[ ^ self recordAndReportMatch:#( 15 ). ].
    ((currentCharacter between:(Character tab) and:(Character codePoint:16rB)) 
        or:[
            currentCharacter == (Character codePoint:16rD) 
                or:[ currentCharacter == (Character space) ]
        ]) 
            ifTrue:[
                [
                    self recordMatch:#whitespace.
                    self step.
                    ((currentCharacter between:(Character tab) and:(Character codePoint:16rB)) 
                        or:[
                            currentCharacter == (Character codePoint:16rD) 
                                or:[ currentCharacter == (Character space) ]
                        ])
                ] whileTrue.
                ^ self reportLastMatch
            ].
    (currentCharacter == $#) ifTrue:[
        self recordMatch:#comment.
        self step.
        (currentCharacter <= (Character tab) 
            or:[
                (currentCharacter between:(Character codePoint:16rB)
                    and:(Character codePoint:16rC)) 
                        or:[ currentCharacter >= (Character codePoint:16rE) ]
            ]) 
                ifTrue:[
                    [
                        self recordMatch:#comment.
                        self step.
                        (currentCharacter <= (Character tab) 
                            or:[
                                (currentCharacter between:(Character codePoint:16rB)
                                    and:(Character codePoint:16rC)) 
                                        or:[ currentCharacter >= (Character codePoint:16rE) ]
                            ])
                    ] whileTrue.
                    ^ self reportLastMatch
                ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $() ifTrue:[
        ^ self recordAndReportMatch:#( 1 ).
    ].
    (currentCharacter == $)) ifTrue:[
        ^ self recordAndReportMatch:#( 4 15 ).
    ].
    (currentCharacter == $*) ifTrue:[
        ^ self recordAndReportMatch:#( 3 15 ).
    ].
    (currentCharacter == $+) ifTrue:[
        ^ self recordAndReportMatch:#( 5 15 ).
    ].
    (currentCharacter == $.) ifTrue:[
        ^ self recordAndReportMatch:#( 16 ).
    ].
    (currentCharacter == $:) ifTrue:[
        ^ self recordAndReportMatch:#( 7 15 ).
    ].
    (currentCharacter == $;) ifTrue:[
        ^ self recordAndReportMatch:#( 8 15 ).
    ].
    (currentCharacter == $<) ifTrue:[
        self recordMatch:#( 15 ).
        self step.
        (currentCharacter isLetter or:[ currentCharacter == $_ ]) ifTrue:[
            [
                self step.
                (currentCharacter isLetterOrDigit or:[ currentCharacter == $_ ])
            ] whileTrue.
            (currentCharacter == $>) ifTrue:[
                ^ self recordAndReportMatch:#( 12 ).
            ].
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $?) ifTrue:[
        ^ self recordAndReportMatch:#( 6 15 ).
    ].
    (currentCharacter == $[) ifTrue:[
        self step.
        (currentCharacter <= $[ or:[ currentCharacter >= $^ ]) ifTrue:[
            ^ self scan1
        ].
        (currentCharacter == $\) ifTrue:[
            ^ self scan2
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $\) ifTrue:[
        self step.
        (currentCharacter <= $b 
            or:[ (currentCharacter between:$d and:$w) or:[ currentCharacter >= $y ] ]) 
                ifTrue:[ ^ self recordAndReportMatch:#( 9 ). ].
        (currentCharacter == $c) ifTrue:[
            self step.
            (currentCharacter between:$A and:$Z) ifTrue:[
                ^ self recordAndReportMatch:#( 9 ).
            ].
            ^ self reportLastMatch
        ].
        (currentCharacter == $x) ifTrue:[
            self step.
            (currentCharacter isNationalDigit 
                or:[
                    (currentCharacter between:$A and:$F) 
                        or:[ (currentCharacter between:$a and:$f) ]
                ]) 
                    ifTrue:[
                        self recordMatch:#( 9 ).
                        self step.
                        (currentCharacter isNationalDigit 
                            or:[
                                (currentCharacter between:$A and:$F) 
                                    or:[ (currentCharacter between:$a and:$f) ]
                            ]) 
                                ifTrue:[
                                    self recordMatch:#( 9 ).
                                    self step.
                                    (currentCharacter isNationalDigit 
                                        or:[
                                            (currentCharacter between:$A and:$F) 
                                                or:[ (currentCharacter between:$a and:$f) ]
                                        ]) 
                                            ifTrue:[
                                                self recordMatch:#( 9 ).
                                                self step.
                                                (currentCharacter isNationalDigit 
                                                    or:[
                                                        (currentCharacter between:$A and:$F) 
                                                            or:[ (currentCharacter between:$a and:$f) ]
                                                    ]) 
                                                        ifTrue:[ ^ self recordAndReportMatch:#( 9 ). ].
                                                ^ self reportLastMatch
                                            ].
                                    ^ self reportLastMatch
                                ].
                        ^ self reportLastMatch
                    ].
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == ${) ifTrue:[
        [
            self step.
            (currentCharacter isNationalDigit)
        ] whileTrue.
        (currentCharacter == $,) ifTrue:[
            [
                self step.
                (currentCharacter isNationalDigit)
            ] whileTrue.
            (currentCharacter == $}) ifTrue:[
                ^ self recordAndReportMatch:#( 14 ).
            ].
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $|) ifTrue:[
        ^ self recordAndReportMatch:#( 2 15 ).
    ].
    ^ self reportLastMatch
! !

!SmaCCScannerScanner methodsFor:'generated-tokens'!

emptySymbolTokenId
	^21
!

errorTokenId
	^22
! !

!SmaCCScannerScanner class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCScannerScanner.st,v 1.1 2006-02-09 21:18:41 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
