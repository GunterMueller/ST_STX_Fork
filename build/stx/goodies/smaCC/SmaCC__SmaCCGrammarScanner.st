"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCScanner subclass:#SmaCCGrammarScanner
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCGrammarScanner comment:'SmaCCGrammarScanner is the scanner for the grammar parser'
!


!SmaCCGrammarScanner class methodsFor:'generated-comments'!

scannerDefinitionComment

	"<name> : [a-zA-Z_] \w* ;
<whitespace>    :       \s+ ;
<tokenname>     :       \< <name> \> ;
<symbolname>    :       <name>   ;
<keyword>       :       (\"" [^\""]* \"") + ;
<comment>       :       \# [^\r\n]* ;
<code>: \{ [^\}]+ \} ;
<variablename> :        \' <name> \' ;
<production> : \: (\: \=)? ;
"
! !

!SmaCCGrammarScanner class methodsFor:'generated-initialization'!

initializeKeywordMap
    keywordMap := Dictionary new.
    #( #(20 'error' 16) ) do:[:each | 
        (keywordMap at:each first ifAbsentPut:[ Dictionary new ]) at:(each at:2)
            put:each last
    ].
    ^ keywordMap
! !

!SmaCCGrammarScanner class methodsFor:'public'!

needsLineNumbers
	^true
! !

!SmaCCGrammarScanner methodsFor:'generated-scanner'!

keywordFor: aString 
	^aString asUppercase
!

scan1
    [
        [
            self step.
            currentCharacter ~~ $"
        ] whileTrue.
        self recordMatch:#( 21 ).
        self step.
        (currentCharacter == $")
    ] whileTrue:[].
    ^ self reportLastMatch
!

scan2
    self step.
    (currentCharacter == $>) ifTrue:[
        ^ self recordAndReportMatch:#( 10 ).
    ].
    (currentCharacter == $i) ifTrue:[
        self step.
        (currentCharacter == $d) ifTrue:[
            ^ self recordAndReportMatch:#( 4 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $l) ifTrue:[
        self step.
        (currentCharacter == $e) ifTrue:[
            self step.
            (currentCharacter == $f) ifTrue:[
                self step.
                (currentCharacter == $t) ifTrue:[
                    ^ self recordAndReportMatch:#( 6 ).
                ].
                ^ self reportLastMatch
            ].
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $n) ifTrue:[
        self step.
        (currentCharacter == $o) ifTrue:[
            self step.
            (currentCharacter == $n) ifTrue:[
                self step.
                (currentCharacter == $a) ifTrue:[
                    self step.
                    (currentCharacter == $s) ifTrue:[
                        self step.
                        (currentCharacter == $s) ifTrue:[
                            self step.
                            (currentCharacter == $o) ifTrue:[
                                self step.
                                (currentCharacter == $c) ifTrue:[
                                    ^ self recordAndReportMatch:#( 3 ).
                                ].
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
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $r) ifTrue:[
        self step.
        (currentCharacter == $i) ifTrue:[
            self step.
            (currentCharacter == $g) ifTrue:[
                self step.
                (currentCharacter == $h) ifTrue:[
                    self step.
                    (currentCharacter == $t) ifTrue:[
                        ^ self recordAndReportMatch:#( 8 ).
                    ].
                    ^ self reportLastMatch
                ].
                ^ self reportLastMatch
            ].
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $s) ifTrue:[
        self step.
        (currentCharacter == $t) ifTrue:[
            self step.
            (currentCharacter == $a) ifTrue:[
                self step.
                (currentCharacter == $r) ifTrue:[
                    self step.
                    (currentCharacter == $t) ifTrue:[
                        ^ self recordAndReportMatch:#( 1 ).
                    ].
                    ^ self reportLastMatch
                ].
                ^ self reportLastMatch
            ].
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    ^ self reportLastMatch
!

scanForToken
    self step.
    (currentCharacter isLetter or:[ currentCharacter == $_ ]) ifTrue:[
        [
            self recordMatch:#( 20 ).
            self step.
            (currentCharacter isLetterOrDigit or:[ currentCharacter == $_ ])
        ] whileTrue.
        ^ self reportLastMatch
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
    (currentCharacter == $") ifTrue:[
        ^ self scan1
    ].
    (currentCharacter == $#) ifTrue:[
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
    (currentCharacter == $%) ifTrue:[
        ^ self scan2
    ].
    (currentCharacter == $') ifTrue:[
        self step.
        (currentCharacter isLetter or:[ currentCharacter == $_ ]) ifTrue:[
            [
                self step.
                (currentCharacter isLetterOrDigit or:[ currentCharacter == $_ ])
            ] whileTrue.
            (currentCharacter == $') ifTrue:[
                ^ self recordAndReportMatch:#( 24 ).
            ].
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $() ifTrue:[
        ^ self recordAndReportMatch:#( 17 ).
    ].
    (currentCharacter == $)) ifTrue:[
        ^ self recordAndReportMatch:#( 12 ).
    ].
    (currentCharacter == $*) ifTrue:[
        ^ self recordAndReportMatch:#( 9 ).
    ].
    (currentCharacter == $+) ifTrue:[
        ^ self recordAndReportMatch:#( 15 ).
    ].
    (currentCharacter == $:) ifTrue:[
        self recordMatch:#( 25 ).
        self step.
        (currentCharacter == $:) ifTrue:[
            self step.
            (currentCharacter == $=) ifTrue:[
                ^ self recordAndReportMatch:#( 25 ).
            ].
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $;) ifTrue:[
        ^ self recordAndReportMatch:#( 7 ).
    ].
    (currentCharacter == $<) ifTrue:[
        self step.
        (currentCharacter isLetter or:[ currentCharacter == $_ ]) ifTrue:[
            [
                self step.
                (currentCharacter isLetterOrDigit or:[ currentCharacter == $_ ])
            ] whileTrue.
            (currentCharacter == $>) ifTrue:[
                ^ self recordAndReportMatch:#( 19 ).
            ].
            ^ self reportLastMatch
        ].
        (currentCharacter == $%) ifTrue:[
            ^ self recordAndReportMatch:#( 13 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $?) ifTrue:[
        ^ self recordAndReportMatch:#( 5 ).
    ].
    (currentCharacter == $[) ifTrue:[
        ^ self recordAndReportMatch:#( 11 ).
    ].
    (currentCharacter == $]) ifTrue:[
        ^ self recordAndReportMatch:#( 14 ).
    ].
    (currentCharacter == ${) ifTrue:[
        self step.
        (currentCharacter ~~ $}) ifTrue:[
            [
                self step.
                currentCharacter ~~ $}
            ] whileTrue.
            ^ self recordAndReportMatch:#( 23 )
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $|) ifTrue:[
        ^ self recordAndReportMatch:#( 2 ).
    ].
    ^ self reportLastMatch
! !

!SmaCCGrammarScanner methodsFor:'generated-tokens'!

emptySymbolTokenId
	^43
!

errorTokenId
	^44
! !

!SmaCCGrammarScanner class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCGrammarScanner.st,v 1.1 2006-02-09 21:15:17 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
