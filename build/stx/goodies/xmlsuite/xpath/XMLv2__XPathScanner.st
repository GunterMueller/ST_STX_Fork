"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

SmaCC::SmaCCScanner subclass:#XPathScanner
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath'
!


!XPathScanner class methodsFor:'generated-comments'!

scannerDefinitionComment

	"<whitespace>         :       \s+;

#[39]    
<ExprWhitespace>     :  <whitespace> ;

<Digit>              :  [0-9];




#!!!!!!
<Letter>             : [a-zA-Z] ;


#[30] 
<Number>             :  <Digit>+ (\. <Digit>*)? ;

#[29]    
<Literal>            :    \"" [^\""]* \""   
                        | \' [^\']* \' ;


<NCNameChar>        :    <Letter> | <Digit> | ""."" | ""-"" | ""_"" ;

<NCName>             :     <Letter> (<NCNameChar>)* 
                               | ""_""  (<NCNameChar>)* ;    
"

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
! !

!XPathScanner class methodsFor:'generated-initialization'!

initializeKeywordMap
    keywordMap := Dictionary new.
    #( #(33 'ancestor' 15)
     #(33 'attribute' 2)
     #(33 'child' 1)
     #(33 'comment' comment)
     #(33 'descendant' 4)
     #(33 'element' 17)
     #(33 'following' 6)
     #(33 'namespace' 16)
     #(33 'node' 29)
     #(33 'parent' 31)
     #(33 'preceding' 26)
     #(33 'self' 28)
     #(33 'text' 20) ) 
            do:[:each | 
                (keywordMap at:each first ifAbsentPut:[ Dictionary new ]) at:(each at:2)
                    put:each last
            ].
    ^ keywordMap

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
! !

!XPathScanner methodsFor:'generated-scanner'!

scan1
    [
        self recordMatch:#( 33 ).
        self step.
        (currentCharacter isLetterOrDigit)
    ] whileTrue.
    (currentCharacter == $") ifTrue:[
        ^ self scan5
    ].
    ^ self reportLastMatch

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

scan10
    self recordMatch:#( 33 ).
    self step.
    (currentCharacter isXMLDigit 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$d) 
                        or:[ (currentCharacter between:$f and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan6
    ].
    (currentCharacter == $e) ifTrue:[
        ^ self scan11
    ].
    ^ self reportLastMatch

    "Modified: / 16-11-2007 / 09:44:18 / janfrog"
!

scan11
    self recordMatch:#( 33 ).
    self step.
    ((currentCharacter between:$0 and:$9) 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$r) 
                        or:[ (currentCharacter between:$t and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan6
    ].
    (currentCharacter == $s) ifTrue:[
        self recordMatch:#( 33 ).
        self step.
        ((currentCharacter between:$0 and:$9) 
            or:[
                (currentCharacter between:$A and:$Z) 
                    or:[
                        (currentCharacter between:$a and:$r) 
                            or:[ (currentCharacter between:$t and:$z) ]
                    ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $") ifTrue:[
            ^ self scan6
        ].
        (currentCharacter == $s) ifTrue:[
            self recordMatch:#( 33 ).
            self step.
            (currentCharacter isXMLDigit 
                or:[
                    (currentCharacter between:$A and:$Z) 
                        or:[
                            (currentCharacter between:$a and:$h) 
                                or:[ (currentCharacter between:$j and:$z) ]
                        ]
                ]) 
                    ifTrue:[ ^ self scan1 ].
            (currentCharacter == $") ifTrue:[
                ^ self scan6
            ].
            (currentCharacter == $i) ifTrue:[
                self recordMatch:#( 33 ).
                self step.
                ((currentCharacter between:$0 and:$9) 
                    or:[
                        (currentCharacter between:$A and:$Z) 
                            or:[
                                (currentCharacter between:$a and:$m) 
                                    or:[ (currentCharacter between:$o and:$z) ]
                            ]
                    ]) 
                        ifTrue:[ ^ self scan1 ].
                (currentCharacter == $") ifTrue:[
                    ^ self scan6
                ].
                (currentCharacter == $n) ifTrue:[
                    self recordMatch:#( 33 ).
                    self step.
                    ((currentCharacter between:$0 and:$9) 
                        or:[
                            (currentCharacter between:$A and:$Z) 
                                or:[
                                    (currentCharacter between:$a and:$f) 
                                        or:[ (currentCharacter between:$h and:$z) ]
                                ]
                        ]) 
                            ifTrue:[ ^ self scan1 ].
                    (currentCharacter == $") ifTrue:[
                        ^ self scan6
                    ].
                    (currentCharacter == $g) ifTrue:[
                        self recordMatch:#( 33 ).
                        self step.
                        (currentCharacter isLetterOrDigit) ifTrue:[
                            ^ self scan1
                        ].
                        (currentCharacter == $") ifTrue:[
                            ^ self scan6
                        ].
                        (currentCharacter == $-) ifTrue:[
                            self step.
                            (currentCharacter == $i) ifTrue:[
                                self step.
                                (currentCharacter == $n) ifTrue:[
                                    self step.
                                    (currentCharacter == $s) ifTrue:[
                                        self step.
                                        (currentCharacter == $t) ifTrue:[
                                            self step.
                                            (currentCharacter == $r) ifTrue:[
                                                self step.
                                                (currentCharacter == $u) ifTrue:[
                                                    self step.
                                                    (currentCharacter == $c) ifTrue:[
                                                        self step.
                                                        (currentCharacter == $t) ifTrue:[
                                                            self step.
                                                            (currentCharacter == $i) ifTrue:[
                                                                self step.
                                                                (currentCharacter == $o) ifTrue:[
                                                                    self step.
                                                                    (currentCharacter == $n) ifTrue:[
                                                                        ^ self recordAndReportMatch:#( 22 ).
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
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    ^ self reportLastMatch

    "Modified: / 16-11-2007 / 09:44:18 / janfrog"
!

scan12
    self recordMatch:#( 30 ).
    self step.
    (currentCharacter isXMLDigit 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$d) 
                        or:[ (currentCharacter between:$f and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan7
    ].
    (currentCharacter == $e) ifTrue:[
        self recordMatch:#( 30 ).
        self step.
        ((currentCharacter between:$0 and:$9) 
            or:[
                (currentCharacter between:$A and:$Z) 
                    or:[
                        (currentCharacter between:$a and:$r) 
                            or:[ (currentCharacter between:$t and:$z) ]
                    ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $") ifTrue:[
            ^ self scan7
        ].
        (currentCharacter == $s) ifTrue:[
            self recordMatch:#( 30 ).
            self step.
            ((currentCharacter between:$0 and:$9) 
                or:[
                    (currentCharacter between:$A and:$Z) 
                        or:[
                            (currentCharacter between:$a and:$s) 
                                or:[ (currentCharacter between:$u and:$z) ]
                        ]
                ]) 
                    ifTrue:[ ^ self scan1 ].
            (currentCharacter == $") ifTrue:[
                ^ self scan7
            ].
            (currentCharacter == $t) ifTrue:[
                self recordMatch:#( 30 ).
                self step.
                (currentCharacter isXMLDigit 
                    or:[
                        (currentCharacter between:$A and:$Z) 
                            or:[
                                (currentCharacter between:$a and:$n) 
                                    or:[ (currentCharacter between:$p and:$z) ]
                            ]
                    ]) 
                        ifTrue:[ ^ self scan1 ].
                (currentCharacter == $") ifTrue:[
                    ^ self scan7
                ].
                (currentCharacter == $o) ifTrue:[
                    self recordMatch:#( 30 ).
                    self step.
                    ((currentCharacter between:$0 and:$9) 
                        or:[
                            (currentCharacter between:$A and:$Z) 
                                or:[
                                    (currentCharacter between:$a and:$q) 
                                        or:[ (currentCharacter between:$s and:$z) ]
                                ]
                        ]) 
                            ifTrue:[ ^ self scan1 ].
                    (currentCharacter == $") ifTrue:[
                        ^ self scan7
                    ].
                    (currentCharacter == $r) ifTrue:[
                        self recordMatch:#( 30 ).
                        self step.
                        (currentCharacter isLetterOrDigit) ifTrue:[
                            ^ self scan1
                        ].
                        (currentCharacter == $") ifTrue:[
                            ^ self scan7
                        ].
                        (currentCharacter == $-) ifTrue:[
                            self step.
                            (currentCharacter == $o) ifTrue:[
                                self step.
                                (currentCharacter == $r) ifTrue:[
                                    self step.
                                    (currentCharacter == $-) ifTrue:[
                                        self step.
                                        (currentCharacter == $s) ifTrue:[
                                            self step.
                                            (currentCharacter == $e) ifTrue:[
                                                self step.
                                                (currentCharacter == $l) ifTrue:[
                                                    self step.
                                                    (currentCharacter == $f) ifTrue:[
                                                        self step.
                                                        (currentCharacter == $:) ifTrue:[
                                                            self step.
                                                            (currentCharacter == $:) ifTrue:[
                                                                ^ self recordAndReportMatch:#( 14 ).
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
                                ^ self reportLastMatch
                            ].
                            ^ self reportLastMatch
                        ].
                        (currentCharacter == $:) ifTrue:[
                            self step.
                            (currentCharacter == $:) ifTrue:[
                                ^ self recordAndReportMatch:#( 10 ).
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

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

scan13
    self recordMatch:#( 30 ).
    self step.
    (currentCharacter isXMLDigit 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$d) 
                        or:[
                            (currentCharacter between:$f and:$n) 
                                or:[ (currentCharacter between:$p and:$z) ]
                        ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan7
    ].
    (currentCharacter == $e) ifTrue:[
        ^ self scan14
    ].
    (currentCharacter == $o) ifTrue:[
        ^ self scan15
    ].
    ^ self reportLastMatch

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

scan14
    self recordMatch:#( 30 ).
    self step.
    ((currentCharacter between:$0 and:$9) 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$b) 
                        or:[ (currentCharacter between:$d and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan7
    ].
    (currentCharacter == $c) ifTrue:[
        ^ self scan18
    ].
    ^ self reportLastMatch

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

scan15
    self recordMatch:#( 30 ).
    self step.
    ((currentCharacter between:$0 and:$9) 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$b) 
                        or:[ (currentCharacter between:$d and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan7
    ].
    (currentCharacter == $c) ifTrue:[
        ^ self scan16
    ].
    ^ self reportLastMatch

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

scan16
    self recordMatch:#( 30 ).
    self step.
    (currentCharacter isXMLDigit 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$d) 
                        or:[ (currentCharacter between:$f and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan7
    ].
    (currentCharacter == $e) ifTrue:[
        ^ self scan17
    ].
    ^ self reportLastMatch

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

scan17
    self recordMatch:#( 30 ).
    self step.
    ((currentCharacter between:$0 and:$9) 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$r) 
                        or:[ (currentCharacter between:$t and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan7
    ].
    (currentCharacter == $s) ifTrue:[
        self recordMatch:#( 30 ).
        self step.
        ((currentCharacter between:$0 and:$9) 
            or:[
                (currentCharacter between:$A and:$Z) 
                    or:[
                        (currentCharacter between:$a and:$r) 
                            or:[ (currentCharacter between:$t and:$z) ]
                    ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $") ifTrue:[
            ^ self scan7
        ].
        (currentCharacter == $s) ifTrue:[
            self recordMatch:#( 30 ).
            self step.
            (currentCharacter isXMLDigit 
                or:[
                    (currentCharacter between:$A and:$Z) 
                        or:[
                            (currentCharacter between:$a and:$h) 
                                or:[ (currentCharacter between:$j and:$z) ]
                        ]
                ]) 
                    ifTrue:[ ^ self scan1 ].
            (currentCharacter == $") ifTrue:[
                ^ self scan7
            ].
            (currentCharacter == $i) ifTrue:[
                self recordMatch:#( 30 ).
                self step.
                ((currentCharacter between:$0 and:$9) 
                    or:[
                        (currentCharacter between:$A and:$Z) 
                            or:[
                                (currentCharacter between:$a and:$m) 
                                    or:[ (currentCharacter between:$o and:$z) ]
                            ]
                    ]) 
                        ifTrue:[ ^ self scan1 ].
                (currentCharacter == $") ifTrue:[
                    ^ self scan7
                ].
                (currentCharacter == $n) ifTrue:[
                    self recordMatch:#( 30 ).
                    self step.
                    ((currentCharacter between:$0 and:$9) 
                        or:[
                            (currentCharacter between:$A and:$Z) 
                                or:[
                                    (currentCharacter between:$a and:$f) 
                                        or:[ (currentCharacter between:$h and:$z) ]
                                ]
                        ]) 
                            ifTrue:[ ^ self scan1 ].
                    (currentCharacter == $") ifTrue:[
                        ^ self scan7
                    ].
                    (currentCharacter == $g) ifTrue:[
                        self recordMatch:#( 30 ).
                        self step.
                        (currentCharacter isLetterOrDigit) ifTrue:[
                            ^ self scan1
                        ].
                        (currentCharacter == $") ifTrue:[
                            ^ self scan7
                        ].
                        (currentCharacter == $-) ifTrue:[
                            self step.
                            (currentCharacter == $i) ifTrue:[
                                self step.
                                (currentCharacter == $n) ifTrue:[
                                    self step.
                                    (currentCharacter == $s) ifTrue:[
                                        self step.
                                        (currentCharacter == $t) ifTrue:[
                                            self step.
                                            (currentCharacter == $r) ifTrue:[
                                                self step.
                                                (currentCharacter == $u) ifTrue:[
                                                    self step.
                                                    (currentCharacter == $c) ifTrue:[
                                                        self step.
                                                        (currentCharacter == $t) ifTrue:[
                                                            self step.
                                                            (currentCharacter == $i) ifTrue:[
                                                                self step.
                                                                (currentCharacter == $o) ifTrue:[
                                                                    self step.
                                                                    (currentCharacter == $n) ifTrue:[
                                                                        ^ self recordAndReportMatch:#( 19 ).
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
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    ^ self reportLastMatch

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

scan18
    self recordMatch:#( 30 ).
    self step.
    (currentCharacter isXMLDigit 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$d) 
                        or:[ (currentCharacter between:$f and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan7
    ].
    (currentCharacter == $e) ifTrue:[
        self recordMatch:#( 30 ).
        self step.
        ((currentCharacter between:$0 and:$9) 
            or:[
                (currentCharacter between:$A and:$Z) 
                    or:[
                        (currentCharacter between:$a and:$c) 
                            or:[ (currentCharacter between:$e and:$z) ]
                    ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $") ifTrue:[
            ^ self scan7
        ].
        (currentCharacter == $d) ifTrue:[
            self recordMatch:#( 30 ).
            self step.
            (currentCharacter isXMLDigit 
                or:[
                    (currentCharacter between:$A and:$Z) 
                        or:[
                            (currentCharacter between:$a and:$h) 
                                or:[ (currentCharacter between:$j and:$z) ]
                        ]
                ]) 
                    ifTrue:[ ^ self scan1 ].
            (currentCharacter == $") ifTrue:[
                ^ self scan7
            ].
            (currentCharacter == $i) ifTrue:[
                self recordMatch:#( 30 ).
                self step.
                ((currentCharacter between:$0 and:$9) 
                    or:[
                        (currentCharacter between:$A and:$Z) 
                            or:[
                                (currentCharacter between:$a and:$m) 
                                    or:[ (currentCharacter between:$o and:$z) ]
                            ]
                    ]) 
                        ifTrue:[ ^ self scan1 ].
                (currentCharacter == $") ifTrue:[
                    ^ self scan7
                ].
                (currentCharacter == $n) ifTrue:[
                    self recordMatch:#( 30 ).
                    self step.
                    ((currentCharacter between:$0 and:$9) 
                        or:[
                            (currentCharacter between:$A and:$Z) 
                                or:[
                                    (currentCharacter between:$a and:$f) 
                                        or:[ (currentCharacter between:$h and:$z) ]
                                ]
                        ]) 
                            ifTrue:[ ^ self scan1 ].
                    (currentCharacter == $") ifTrue:[
                        ^ self scan7
                    ].
                    (currentCharacter == $g) ifTrue:[
                        self recordMatch:#( 30 ).
                        self step.
                        (currentCharacter isLetterOrDigit) ifTrue:[
                            ^ self scan1
                        ].
                        (currentCharacter == $") ifTrue:[
                            ^ self scan7
                        ].
                        (currentCharacter == $-) ifTrue:[
                            self step.
                            (currentCharacter == $s) ifTrue:[
                                self step.
                                (currentCharacter == $i) ifTrue:[
                                    self step.
                                    (currentCharacter == $b) ifTrue:[
                                        self step.
                                        (currentCharacter == $l) ifTrue:[
                                            self step.
                                            (currentCharacter == $i) ifTrue:[
                                                self step.
                                                (currentCharacter == $n) ifTrue:[
                                                    self step.
                                                    (currentCharacter == $g) ifTrue:[
                                                        self step.
                                                        (currentCharacter == $:) ifTrue:[
                                                            self step.
                                                            (currentCharacter == $:) ifTrue:[
                                                                ^ self recordAndReportMatch:#( 15 ).
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
                                ^ self reportLastMatch
                            ].
                            ^ self reportLastMatch
                        ].
                        (currentCharacter == $:) ifTrue:[
                            self step.
                            (currentCharacter == $:) ifTrue:[
                                ^ self recordAndReportMatch:#( 13 ).
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

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

scan19
    self recordMatch:#( 30 ).
    self step.
    ((currentCharacter between:$0 and:$9) 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$r) 
                        or:[ (currentCharacter between:$t and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan7
    ].
    (currentCharacter == $s) ifTrue:[
        ^ self scan20
    ].
    ^ self reportLastMatch

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

scan2
    self step.
    (currentCharacter == $") ifTrue:[
        [
            self recordMatch:#( 33 ).
            self step.
            (currentCharacter isLetterOrDigit)
        ] whileTrue.
        (currentCharacter == $") ifTrue:[
            self step.
            (currentCharacter isImmediate) ifTrue:[
                ^ self scan2
            ].
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    ^ self reportLastMatch

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

scan20
    self recordMatch:#( 30 ).
    self step.
    ((currentCharacter between:$0 and:$9) 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$b) 
                        or:[ (currentCharacter between:$d and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan7
    ].
    (currentCharacter == $c) ifTrue:[
        ^ self scan21
    ].
    ^ self reportLastMatch

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

scan21
    self recordMatch:#( 30 ).
    self step.
    (currentCharacter isXMLDigit 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$d) 
                        or:[ (currentCharacter between:$f and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan7
    ].
    (currentCharacter == $e) ifTrue:[
        ^ self scan22
    ].
    ^ self reportLastMatch

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

scan22
    self recordMatch:#( 30 ).
    self step.
    ((currentCharacter between:$0 and:$9) 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$m) 
                        or:[ (currentCharacter between:$o and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan7
    ].
    (currentCharacter == $n) ifTrue:[
        self recordMatch:#( 30 ).
        self step.
        ((currentCharacter between:$0 and:$9) 
            or:[
                (currentCharacter between:$A and:$Z) 
                    or:[
                        (currentCharacter between:$a and:$c) 
                            or:[ (currentCharacter between:$e and:$z) ]
                    ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $") ifTrue:[
            ^ self scan7
        ].
        (currentCharacter == $d) ifTrue:[
            self recordMatch:#( 30 ).
            self step.
            (currentCharacter isXMLDigit 
                or:[
                    (currentCharacter between:$A and:$Z) 
                        or:[ (currentCharacter between:$b and:$z) ]
                ]) 
                    ifTrue:[ ^ self scan1 ].
            (currentCharacter == $") ifTrue:[
                ^ self scan7
            ].
            (currentCharacter == $a) ifTrue:[
                self recordMatch:#( 30 ).
                self step.
                ((currentCharacter between:$0 and:$9) 
                    or:[
                        (currentCharacter between:$A and:$Z) 
                            or:[
                                (currentCharacter between:$a and:$m) 
                                    or:[ (currentCharacter between:$o and:$z) ]
                            ]
                    ]) 
                        ifTrue:[ ^ self scan1 ].
                (currentCharacter == $") ifTrue:[
                    ^ self scan7
                ].
                (currentCharacter == $n) ifTrue:[
                    self recordMatch:#( 30 ).
                    self step.
                    ((currentCharacter between:$0 and:$9) 
                        or:[
                            (currentCharacter between:$A and:$Z) 
                                or:[
                                    (currentCharacter between:$a and:$s) 
                                        or:[ (currentCharacter between:$u and:$z) ]
                                ]
                        ]) 
                            ifTrue:[ ^ self scan1 ].
                    (currentCharacter == $") ifTrue:[
                        ^ self scan7
                    ].
                    (currentCharacter == $t) ifTrue:[
                        self recordMatch:#( 30 ).
                        self step.
                        (currentCharacter isLetterOrDigit) ifTrue:[
                            ^ self scan1
                        ].
                        (currentCharacter == $") ifTrue:[
                            ^ self scan7
                        ].
                        (currentCharacter == $-) ifTrue:[
                            self step.
                            (currentCharacter == $o) ifTrue:[
                                self step.
                                (currentCharacter == $r) ifTrue:[
                                    self step.
                                    (currentCharacter == $-) ifTrue:[
                                        self step.
                                        (currentCharacter == $s) ifTrue:[
                                            self step.
                                            (currentCharacter == $e) ifTrue:[
                                                self step.
                                                (currentCharacter == $l) ifTrue:[
                                                    self step.
                                                    (currentCharacter == $f) ifTrue:[
                                                        self step.
                                                        (currentCharacter == $:) ifTrue:[
                                                            self step.
                                                            (currentCharacter == $:) ifTrue:[
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
                                        ].
                                        ^ self reportLastMatch
                                    ].
                                    ^ self reportLastMatch
                                ].
                                ^ self reportLastMatch
                            ].
                            ^ self reportLastMatch
                        ].
                        (currentCharacter == $:) ifTrue:[
                            self step.
                            (currentCharacter == $:) ifTrue:[
                                ^ self recordAndReportMatch:#( 11 ).
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

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

scan3
    self recordMatch:#( 33 ).
    self step.
    ((currentCharacter between:$0 and:$9) 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$q) 
                        or:[ (currentCharacter between:$s and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan5
    ].
    (currentCharacter == $r) ifTrue:[
        ^ self scan6
    ].
    ^ self reportLastMatch

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

scan4
    self recordMatch:#( 33 ).
    self step.
    (currentCharacter isXMLDigit 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$d) 
                        or:[
                            (currentCharacter between:$f and:$n) 
                                or:[ (currentCharacter between:$p and:$z) ]
                        ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan5
    ].
    (currentCharacter == $e) ifTrue:[
        self recordMatch:#( 33 ).
        self step.
        ((currentCharacter between:$0 and:$9) 
            or:[
                (currentCharacter between:$A and:$Z) 
                    or:[
                        (currentCharacter between:$a and:$r) 
                            or:[ (currentCharacter between:$t and:$z) ]
                    ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $") ifTrue:[
            ^ self scan5
        ].
        (currentCharacter == $s) ifTrue:[
            self recordMatch:#( 33 ).
            self step.
            ((currentCharacter between:$0 and:$9) 
                or:[
                    (currentCharacter between:$A and:$Z) 
                        or:[
                            (currentCharacter between:$a and:$b) 
                                or:[ (currentCharacter between:$d and:$z) ]
                        ]
                ]) 
                    ifTrue:[ ^ self scan1 ].
            (currentCharacter == $") ifTrue:[
                ^ self scan5
            ].
            (currentCharacter == $c) ifTrue:[
                self recordMatch:#( 33 ).
                self step.
                (currentCharacter isXMLDigit 
                    or:[
                        (currentCharacter between:$A and:$Z) 
                            or:[
                                (currentCharacter between:$a and:$d) 
                                    or:[ (currentCharacter between:$f and:$z) ]
                            ]
                    ]) 
                        ifTrue:[ ^ self scan1 ].
                (currentCharacter == $") ifTrue:[
                    ^ self scan5
                ].
                (currentCharacter == $e) ifTrue:[
                    self recordMatch:#( 33 ).
                    self step.
                    ((currentCharacter between:$0 and:$9) 
                        or:[
                            (currentCharacter between:$A and:$Z) 
                                or:[
                                    (currentCharacter between:$a and:$m) 
                                        or:[ (currentCharacter between:$o and:$z) ]
                                ]
                        ]) 
                            ifTrue:[ ^ self scan1 ].
                    (currentCharacter == $") ifTrue:[
                        ^ self scan5
                    ].
                    (currentCharacter == $n) ifTrue:[
                        self recordMatch:#( 33 ).
                        self step.
                        ((currentCharacter between:$0 and:$9) 
                            or:[
                                (currentCharacter between:$A and:$Z) 
                                    or:[
                                        (currentCharacter between:$a and:$c) 
                                            or:[ (currentCharacter between:$e and:$z) ]
                                    ]
                            ]) 
                                ifTrue:[ ^ self scan1 ].
                        (currentCharacter == $") ifTrue:[
                            ^ self scan5
                        ].
                        (currentCharacter == $d) ifTrue:[
                            self recordMatch:#( 33 ).
                            self step.
                            (currentCharacter isXMLDigit 
                                or:[
                                    (currentCharacter between:$A and:$Z) 
                                        or:[ (currentCharacter between:$b and:$z) ]
                                ]) 
                                    ifTrue:[ ^ self scan1 ].
                            (currentCharacter == $") ifTrue:[
                                ^ self scan5
                            ].
                            (currentCharacter == $a) ifTrue:[
                                self recordMatch:#( 33 ).
                                self step.
                                ((currentCharacter between:$0 and:$9) 
                                    or:[
                                        (currentCharacter between:$A and:$Z) 
                                            or:[
                                                (currentCharacter between:$a and:$m) 
                                                    or:[ (currentCharacter between:$o and:$z) ]
                                            ]
                                    ]) 
                                        ifTrue:[ ^ self scan1 ].
                                (currentCharacter == $") ifTrue:[
                                    ^ self scan5
                                ].
                                (currentCharacter == $n) ifTrue:[
                                    self recordMatch:#( 33 ).
                                    self step.
                                    ((currentCharacter between:$0 and:$9) 
                                        or:[
                                            (currentCharacter between:$A and:$Z) 
                                                or:[
                                                    (currentCharacter between:$a and:$s) 
                                                        or:[ (currentCharacter between:$u and:$z) ]
                                                ]
                                        ]) 
                                            ifTrue:[ ^ self scan1 ].
                                    (currentCharacter == $") ifTrue:[
                                        ^ self scan5
                                    ].
                                    (currentCharacter == $t) ifTrue:[
                                        self recordMatch:#( 33 ).
                                        self step.
                                        (currentCharacter isLetterOrDigit) ifTrue:[
                                            ^ self scan1
                                        ].
                                        (currentCharacter == $") ifTrue:[
                                            ^ self scan5
                                        ].
                                        (currentCharacter == $-) ifTrue:[
                                            self step.
                                            (currentCharacter == $o) ifTrue:[
                                                self step.
                                                (currentCharacter == $r) ifTrue:[
                                                    self step.
                                                    (currentCharacter == $-) ifTrue:[
                                                        self step.
                                                        (currentCharacter == $s) ifTrue:[
                                                            self step.
                                                            (currentCharacter == $e) ifTrue:[
                                                                self step.
                                                                (currentCharacter == $l) ifTrue:[
                                                                    self step.
                                                                    (currentCharacter == $f) ifTrue:[
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
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $o) ifTrue:[
        self recordMatch:#( 33 ).
        self step.
        ((currentCharacter between:$0 and:$9) 
            or:[
                (currentCharacter between:$A and:$Z) 
                    or:[
                        (currentCharacter between:$a and:$b) 
                            or:[ (currentCharacter between:$d and:$z) ]
                    ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $") ifTrue:[
            ^ self scan5
        ].
        (currentCharacter == $c) ifTrue:[
            self recordMatch:#( 33 ).
            self step.
            (currentCharacter isXMLDigit 
                or:[
                    (currentCharacter between:$A and:$Z) 
                        or:[
                            (currentCharacter between:$a and:$t) 
                                or:[ (currentCharacter between:$v and:$z) ]
                        ]
                ]) 
                    ifTrue:[ ^ self scan1 ].
            (currentCharacter == $") ifTrue:[
                ^ self scan5
            ].
            (currentCharacter == $u) ifTrue:[
                self recordMatch:#( 33 ).
                self step.
                ((currentCharacter between:$0 and:$9) 
                    or:[
                        (currentCharacter between:$A and:$Z) 
                            or:[
                                (currentCharacter between:$a and:$l) 
                                    or:[ (currentCharacter between:$n and:$z) ]
                            ]
                    ]) 
                        ifTrue:[ ^ self scan1 ].
                (currentCharacter == $") ifTrue:[
                    ^ self scan5
                ].
                (currentCharacter == $m) ifTrue:[
                    self recordMatch:#( 33 ).
                    self step.
                    (currentCharacter isXMLDigit 
                        or:[
                            (currentCharacter between:$A and:$Z) 
                                or:[
                                    (currentCharacter between:$a and:$d) 
                                        or:[ (currentCharacter between:$f and:$z) ]
                                ]
                        ]) 
                            ifTrue:[ ^ self scan1 ].
                    (currentCharacter == $") ifTrue:[
                        ^ self scan5
                    ].
                    (currentCharacter == $e) ifTrue:[
                        self recordMatch:#( 33 ).
                        self step.
                        ((currentCharacter between:$0 and:$9) 
                            or:[
                                (currentCharacter between:$A and:$Z) 
                                    or:[
                                        (currentCharacter between:$a and:$m) 
                                            or:[ (currentCharacter between:$o and:$z) ]
                                    ]
                            ]) 
                                ifTrue:[ ^ self scan1 ].
                        (currentCharacter == $") ifTrue:[
                            ^ self scan5
                        ].
                        (currentCharacter == $n) ifTrue:[
                            self recordMatch:#( 33 ).
                            self step.
                            ((currentCharacter between:$0 and:$9) 
                                or:[
                                    (currentCharacter between:$A and:$Z) 
                                        or:[
                                            (currentCharacter between:$a and:$s) 
                                                or:[ (currentCharacter between:$u and:$z) ]
                                        ]
                                ]) 
                                    ifTrue:[ ^ self scan1 ].
                            (currentCharacter == $") ifTrue:[
                                ^ self scan5
                            ].
                            (currentCharacter == $t) ifTrue:[
                                self recordMatch:#( 33 ).
                                self step.
                                (currentCharacter isLetterOrDigit) ifTrue:[
                                    ^ self scan1
                                ].
                                (currentCharacter == $") ifTrue:[
                                    ^ self scan5
                                ].
                                (currentCharacter == $-) ifTrue:[
                                    self step.
                                    (currentCharacter == $e) ifTrue:[
                                        self step.
                                        (currentCharacter == $l) ifTrue:[
                                            self step.
                                            (currentCharacter == $e) ifTrue:[
                                                self step.
                                                (currentCharacter == $m) ifTrue:[
                                                    self step.
                                                    (currentCharacter == $e) ifTrue:[
                                                        self step.
                                                        (currentCharacter == $n) ifTrue:[
                                                            self step.
                                                            (currentCharacter == $t) ifTrue:[
                                                                ^ self recordAndReportMatch:#( 18 ).
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
    ^ self reportLastMatch

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

scan5
    self step.
    (currentCharacter isImmediate) ifTrue:[
        self step.
        (currentCharacter == $") ifTrue:[
            ^ self scan1
        ].
        ^ self reportLastMatch
    ].
    ^ self reportLastMatch

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

scan6
    self recordMatch:#( 33 ).
    self step.
    (currentCharacter isXMLDigit 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$d) 
                        or:[
                            (currentCharacter between:$f and:$n) 
                                or:[ (currentCharacter between:$p and:$z) ]
                        ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan5
    ].
    (currentCharacter == $e) ifTrue:[
        self recordMatch:#( 33 ).
        self step.
        ((currentCharacter between:$0 and:$9) 
            or:[
                (currentCharacter between:$A and:$Z) 
                    or:[
                        (currentCharacter between:$a and:$b) 
                            or:[ (currentCharacter between:$d and:$z) ]
                    ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $") ifTrue:[
            ^ self scan5
        ].
        (currentCharacter == $c) ifTrue:[
            self recordMatch:#( 33 ).
            self step.
            (currentCharacter isXMLDigit 
                or:[
                    (currentCharacter between:$A and:$Z) 
                        or:[
                            (currentCharacter between:$a and:$d) 
                                or:[ (currentCharacter between:$f and:$z) ]
                        ]
                ]) 
                    ifTrue:[ ^ self scan1 ].
            (currentCharacter == $") ifTrue:[
                ^ self scan5
            ].
            (currentCharacter == $e) ifTrue:[
                self recordMatch:#( 33 ).
                self step.
                ((currentCharacter between:$0 and:$9) 
                    or:[
                        (currentCharacter between:$A and:$Z) 
                            or:[
                                (currentCharacter between:$a and:$c) 
                                    or:[ (currentCharacter between:$e and:$z) ]
                            ]
                    ]) 
                        ifTrue:[ ^ self scan1 ].
                (currentCharacter == $") ifTrue:[
                    ^ self scan5
                ].
                (currentCharacter == $d) ifTrue:[
                    self recordMatch:#( 33 ).
                    self step.
                    (currentCharacter isXMLDigit 
                        or:[
                            (currentCharacter between:$A and:$Z) 
                                or:[
                                    (currentCharacter between:$a and:$h) 
                                        or:[ (currentCharacter between:$j and:$z) ]
                                ]
                        ]) 
                            ifTrue:[ ^ self scan1 ].
                    (currentCharacter == $") ifTrue:[
                        ^ self scan5
                    ].
                    (currentCharacter == $i) ifTrue:[
                        self recordMatch:#( 33 ).
                        self step.
                        ((currentCharacter between:$0 and:$9) 
                            or:[
                                (currentCharacter between:$A and:$Z) 
                                    or:[
                                        (currentCharacter between:$a and:$m) 
                                            or:[ (currentCharacter between:$o and:$z) ]
                                    ]
                            ]) 
                                ifTrue:[ ^ self scan1 ].
                        (currentCharacter == $") ifTrue:[
                            ^ self scan5
                        ].
                        (currentCharacter == $n) ifTrue:[
                            self recordMatch:#( 33 ).
                            self step.
                            ((currentCharacter between:$0 and:$9) 
                                or:[
                                    (currentCharacter between:$A and:$Z) 
                                        or:[
                                            (currentCharacter between:$a and:$f) 
                                                or:[ (currentCharacter between:$h and:$z) ]
                                        ]
                                ]) 
                                    ifTrue:[ ^ self scan1 ].
                            (currentCharacter == $") ifTrue:[
                                ^ self scan5
                            ].
                            (currentCharacter == $g) ifTrue:[
                                self recordMatch:#( 33 ).
                                self step.
                                (currentCharacter isLetterOrDigit) ifTrue:[
                                    ^ self scan1
                                ].
                                (currentCharacter == $") ifTrue:[
                                    ^ self scan5
                                ].
                                (currentCharacter == $-) ifTrue:[
                                    self step.
                                    (currentCharacter == $s) ifTrue:[
                                        self step.
                                        (currentCharacter == $i) ifTrue:[
                                            self step.
                                            (currentCharacter == $b) ifTrue:[
                                                self step.
                                                (currentCharacter == $l) ifTrue:[
                                                    self step.
                                                    (currentCharacter == $i) ifTrue:[
                                                        self step.
                                                        (currentCharacter == $n) ifTrue:[
                                                            self step.
                                                            (currentCharacter == $g) ifTrue:[
                                                                ^ self recordAndReportMatch:#( 25 ).
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
    (currentCharacter == $o) ifTrue:[
        ^ self scan7
    ].
    ^ self reportLastMatch

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

scan7
    self recordMatch:#( 33 ).
    self step.
    ((currentCharacter between:$0 and:$9) 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$b) 
                        or:[ (currentCharacter between:$d and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan5
    ].
    (currentCharacter == $c) ifTrue:[
        ^ self scan8
    ].
    ^ self reportLastMatch

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

scan8
    self recordMatch:#( 33 ).
    self step.
    (currentCharacter isXMLDigit 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$d) 
                        or:[ (currentCharacter between:$f and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan5
    ].
    (currentCharacter == $e) ifTrue:[
        ^ self scan9
    ].
    ^ self reportLastMatch

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

scan9
    self recordMatch:#( 33 ).
    self step.
    ((currentCharacter between:$0 and:$9) 
        or:[
            (currentCharacter between:$A and:$Z) 
                or:[
                    (currentCharacter between:$a and:$r) 
                        or:[ (currentCharacter between:$t and:$z) ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter == $") ifTrue:[
        ^ self scan5
    ].
    (currentCharacter == $s) ifTrue:[
        self recordMatch:#( 33 ).
        self step.
        ((currentCharacter between:$0 and:$9) 
            or:[
                (currentCharacter between:$A and:$Z) 
                    or:[
                        (currentCharacter between:$a and:$r) 
                            or:[ (currentCharacter between:$t and:$z) ]
                    ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $") ifTrue:[
            ^ self scan5
        ].
        (currentCharacter == $s) ifTrue:[
            self recordMatch:#( 33 ).
            self step.
            (currentCharacter isXMLDigit 
                or:[
                    (currentCharacter between:$A and:$Z) 
                        or:[
                            (currentCharacter between:$a and:$h) 
                                or:[ (currentCharacter between:$j and:$z) ]
                        ]
                ]) 
                    ifTrue:[ ^ self scan1 ].
            (currentCharacter == $") ifTrue:[
                ^ self scan5
            ].
            (currentCharacter == $i) ifTrue:[
                self recordMatch:#( 33 ).
                self step.
                ((currentCharacter between:$0 and:$9) 
                    or:[
                        (currentCharacter between:$A and:$Z) 
                            or:[
                                (currentCharacter between:$a and:$m) 
                                    or:[ (currentCharacter between:$o and:$z) ]
                            ]
                    ]) 
                        ifTrue:[ ^ self scan1 ].
                (currentCharacter == $") ifTrue:[
                    ^ self scan5
                ].
                (currentCharacter == $n) ifTrue:[
                    self recordMatch:#( 33 ).
                    self step.
                    ((currentCharacter between:$0 and:$9) 
                        or:[
                            (currentCharacter between:$A and:$Z) 
                                or:[
                                    (currentCharacter between:$a and:$f) 
                                        or:[ (currentCharacter between:$h and:$z) ]
                                ]
                        ]) 
                            ifTrue:[ ^ self scan1 ].
                    (currentCharacter == $") ifTrue:[
                        ^ self scan5
                    ].
                    (currentCharacter == $g) ifTrue:[
                        self recordMatch:#( 33 ).
                        self step.
                        (currentCharacter isLetterOrDigit) ifTrue:[
                            ^ self scan1
                        ].
                        (currentCharacter == $") ifTrue:[
                            ^ self scan5
                        ].
                        (currentCharacter == $-) ifTrue:[
                            self step.
                            (currentCharacter == $i) ifTrue:[
                                self step.
                                (currentCharacter == $n) ifTrue:[
                                    self step.
                                    (currentCharacter == $s) ifTrue:[
                                        self step.
                                        (currentCharacter == $t) ifTrue:[
                                            self step.
                                            (currentCharacter == $r) ifTrue:[
                                                self step.
                                                (currentCharacter == $u) ifTrue:[
                                                    self step.
                                                    (currentCharacter == $c) ifTrue:[
                                                        self step.
                                                        (currentCharacter == $t) ifTrue:[
                                                            self step.
                                                            (currentCharacter == $i) ifTrue:[
                                                                self step.
                                                                (currentCharacter == $o) ifTrue:[
                                                                    self step.
                                                                    (currentCharacter == $n) ifTrue:[
                                                                        ^ self recordAndReportMatch:#( 22 ).
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
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    ^ self reportLastMatch

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

scanForToken
    self step.
    ((currentCharacter between:$A and:$Z) 
        or:[
            (currentCharacter between:$b and:$c) 
                or:[
                    currentCharacter == $e 
                        or:[
                            (currentCharacter between:$g and:$o) 
                                or:[ (currentCharacter between:$q and:$z) ]
                        ]
                ]
        ]) 
            ifTrue:[ ^ self scan1 ].
    (currentCharacter isSeparator 
        or:[ currentCharacter == (Character value:16rB) ]) 
            ifTrue:[
                [
                    self recordMatch:#whitespace.
                    self step.
                    (currentCharacter isSeparator 
                        or:[ currentCharacter == (Character value:16rB) ])
                ] whileTrue.
                ^ self reportLastMatch
            ].
    (currentCharacter == $") ifTrue:[
        self step.
        (currentCharacter == $_) ifTrue:[
            ^ self scan2
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $() ifTrue:[
        ^ self recordAndReportMatch:#( 24 ).
    ].
    (currentCharacter == $)) ifTrue:[
        ^ self recordAndReportMatch:#( 23 ).
    ].
    (currentCharacter == $*) ifTrue:[
        ^ self recordAndReportMatch:#( 27 ).
    ].
    (currentCharacter == $.) ifTrue:[
        self recordMatch:#( 12 ).
        self step.
        (currentCharacter == $.) ifTrue:[
            ^ self recordAndReportMatch:#( 11 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $/) ifTrue:[
        self recordMatch:#( 10 ).
        self step.
        (currentCharacter == $/) ifTrue:[
            ^ self recordAndReportMatch:#( 9 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $:) ifTrue:[
        self recordMatch:#( 30 ).
        self step.
        (currentCharacter == $:) ifTrue:[
            ^ self recordAndReportMatch:#( 14 ).
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $@) ifTrue:[
        ^ self recordAndReportMatch:#( 13 ).
    ].
    (currentCharacter == $[) ifTrue:[
        ^ self recordAndReportMatch:#( 21 ).
    ].
    (currentCharacter == $]) ifTrue:[
        ^ self recordAndReportMatch:#( 8 ).
    ].
    (currentCharacter == $a) ifTrue:[
        self recordMatch:#( 33 ).
        self step.
        ((currentCharacter between:$0 and:$9) 
            or:[
                (currentCharacter between:$A and:$Z) 
                    or:[
                        (currentCharacter between:$a and:$m) 
                            or:[ (currentCharacter between:$o and:$z) ]
                    ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $") ifTrue:[
            ^ self scan5
        ].
        (currentCharacter == $n) ifTrue:[
            self recordMatch:#( 33 ).
            self step.
            ((currentCharacter between:$0 and:$9) 
                or:[
                    (currentCharacter between:$A and:$Z) 
                        or:[
                            (currentCharacter between:$a and:$b) 
                                or:[ (currentCharacter between:$d and:$z) ]
                        ]
                ]) 
                    ifTrue:[ ^ self scan1 ].
            (currentCharacter == $") ifTrue:[
                ^ self scan5
            ].
            (currentCharacter == $c) ifTrue:[
                self recordMatch:#( 33 ).
                self step.
                (currentCharacter isXMLDigit 
                    or:[
                        (currentCharacter between:$A and:$Z) 
                            or:[
                                (currentCharacter between:$a and:$d) 
                                    or:[ (currentCharacter between:$f and:$z) ]
                            ]
                    ]) 
                        ifTrue:[ ^ self scan1 ].
                (currentCharacter == $") ifTrue:[
                    ^ self scan5
                ].
                (currentCharacter == $e) ifTrue:[
                    self recordMatch:#( 33 ).
                    self step.
                    ((currentCharacter between:$0 and:$9) 
                        or:[
                            (currentCharacter between:$A and:$Z) 
                                or:[
                                    (currentCharacter between:$a and:$r) 
                                        or:[ (currentCharacter between:$t and:$z) ]
                                ]
                        ]) 
                            ifTrue:[ ^ self scan1 ].
                    (currentCharacter == $") ifTrue:[
                        ^ self scan5
                    ].
                    (currentCharacter == $s) ifTrue:[
                        self recordMatch:#( 33 ).
                        self step.
                        ((currentCharacter between:$0 and:$9) 
                            or:[
                                (currentCharacter between:$A and:$Z) 
                                    or:[
                                        (currentCharacter between:$a and:$s) 
                                            or:[ (currentCharacter between:$u and:$z) ]
                                    ]
                            ]) 
                                ifTrue:[ ^ self scan1 ].
                        (currentCharacter == $") ifTrue:[
                            ^ self scan5
                        ].
                        (currentCharacter == $t) ifTrue:[
                            self recordMatch:#( 33 ).
                            self step.
                            (currentCharacter isXMLDigit 
                                or:[
                                    (currentCharacter between:$A and:$Z) 
                                        or:[
                                            (currentCharacter between:$a and:$n) 
                                                or:[ (currentCharacter between:$p and:$z) ]
                                        ]
                                ]) 
                                    ifTrue:[ ^ self scan1 ].
                            (currentCharacter == $") ifTrue:[
                                ^ self scan5
                            ].
                            (currentCharacter == $o) ifTrue:[
                                self recordMatch:#( 33 ).
                                self step.
                                ((currentCharacter between:$0 and:$9) 
                                    or:[
                                        (currentCharacter between:$A and:$Z) 
                                            or:[
                                                (currentCharacter between:$a and:$q) 
                                                    or:[ (currentCharacter between:$s and:$z) ]
                                            ]
                                    ]) 
                                        ifTrue:[ ^ self scan1 ].
                                (currentCharacter == $") ifTrue:[
                                    ^ self scan5
                                ].
                                (currentCharacter == $r) ifTrue:[
                                    self recordMatch:#( 33 ).
                                    self step.
                                    (currentCharacter isLetterOrDigit) ifTrue:[
                                        ^ self scan1
                                    ].
                                    (currentCharacter == $") ifTrue:[
                                        ^ self scan5
                                    ].
                                    (currentCharacter == $-) ifTrue:[
                                        self step.
                                        (currentCharacter == $o) ifTrue:[
                                            self step.
                                            (currentCharacter == $r) ifTrue:[
                                                self step.
                                                (currentCharacter == $-) ifTrue:[
                                                    self step.
                                                    (currentCharacter == $s) ifTrue:[
                                                        self step.
                                                        (currentCharacter == $e) ifTrue:[
                                                            self step.
                                                            (currentCharacter == $l) ifTrue:[
                                                                self step.
                                                                (currentCharacter == $f) ifTrue:[
                                                                    ^ self recordAndReportMatch:#( 7 ).
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
        ^ self reportLastMatch
    ].
    (currentCharacter == $d) ifTrue:[
        ^ self scan4
    ].
    (currentCharacter == $f) ifTrue:[
        self recordMatch:#( 33 ).
        self step.
        (currentCharacter isXMLDigit 
            or:[
                (currentCharacter between:$A and:$Z) 
                    or:[
                        (currentCharacter between:$a and:$n) 
                            or:[ (currentCharacter between:$p and:$z) ]
                    ]
            ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $") ifTrue:[
            ^ self scan5
        ].
        (currentCharacter == $o) ifTrue:[
            self recordMatch:#( 33 ).
            self step.
            ((currentCharacter between:$0 and:$9) 
                or:[
                    (currentCharacter between:$A and:$Z) 
                        or:[
                            (currentCharacter between:$a and:$k) 
                                or:[ (currentCharacter between:$m and:$z) ]
                        ]
                ]) 
                    ifTrue:[ ^ self scan1 ].
            (currentCharacter == $") ifTrue:[
                ^ self scan5
            ].
            (currentCharacter == $l) ifTrue:[
                self recordMatch:#( 33 ).
                self step.
                ((currentCharacter between:$0 and:$9) 
                    or:[
                        (currentCharacter between:$A and:$Z) 
                            or:[
                                (currentCharacter between:$a and:$k) 
                                    or:[ (currentCharacter between:$m and:$z) ]
                            ]
                    ]) 
                        ifTrue:[ ^ self scan1 ].
                (currentCharacter == $") ifTrue:[
                    ^ self scan5
                ].
                (currentCharacter == $l) ifTrue:[
                    self recordMatch:#( 33 ).
                    self step.
                    (currentCharacter isXMLDigit 
                        or:[
                            (currentCharacter between:$A and:$Z) 
                                or:[
                                    (currentCharacter between:$a and:$n) 
                                        or:[ (currentCharacter between:$p and:$z) ]
                                ]
                        ]) 
                            ifTrue:[ ^ self scan1 ].
                    (currentCharacter == $") ifTrue:[
                        ^ self scan5
                    ].
                    (currentCharacter == $o) ifTrue:[
                        self recordMatch:#( 33 ).
                        self step.
                        ((currentCharacter between:$0 and:$9) 
                            or:[
                                (currentCharacter between:$A and:$Z) 
                                    or:[
                                        (currentCharacter between:$a and:$v) 
                                            or:[ (currentCharacter between:$x and:$z) ]
                                    ]
                            ]) 
                                ifTrue:[ ^ self scan1 ].
                        (currentCharacter == $") ifTrue:[
                            ^ self scan5
                        ].
                        (currentCharacter == $w) ifTrue:[
                            self recordMatch:#( 33 ).
                            self step.
                            (currentCharacter isXMLDigit 
                                or:[
                                    (currentCharacter between:$A and:$Z) 
                                        or:[
                                            (currentCharacter between:$a and:$h) 
                                                or:[ (currentCharacter between:$j and:$z) ]
                                        ]
                                ]) 
                                    ifTrue:[ ^ self scan1 ].
                            (currentCharacter == $") ifTrue:[
                                ^ self scan5
                            ].
                            (currentCharacter == $i) ifTrue:[
                                self recordMatch:#( 33 ).
                                self step.
                                ((currentCharacter between:$0 and:$9) 
                                    or:[
                                        (currentCharacter between:$A and:$Z) 
                                            or:[
                                                (currentCharacter between:$a and:$m) 
                                                    or:[ (currentCharacter between:$o and:$z) ]
                                            ]
                                    ]) 
                                        ifTrue:[ ^ self scan1 ].
                                (currentCharacter == $") ifTrue:[
                                    ^ self scan5
                                ].
                                (currentCharacter == $n) ifTrue:[
                                    self recordMatch:#( 33 ).
                                    self step.
                                    ((currentCharacter between:$0 and:$9) 
                                        or:[
                                            (currentCharacter between:$A and:$Z) 
                                                or:[
                                                    (currentCharacter between:$a and:$f) 
                                                        or:[ (currentCharacter between:$h and:$z) ]
                                                ]
                                        ]) 
                                            ifTrue:[ ^ self scan1 ].
                                    (currentCharacter == $") ifTrue:[
                                        ^ self scan5
                                    ].
                                    (currentCharacter == $g) ifTrue:[
                                        self recordMatch:#( 33 ).
                                        self step.
                                        (currentCharacter isLetterOrDigit) ifTrue:[
                                            ^ self scan1
                                        ].
                                        (currentCharacter == $") ifTrue:[
                                            ^ self scan5
                                        ].
                                        (currentCharacter == $-) ifTrue:[
                                            self step.
                                            (currentCharacter == $s) ifTrue:[
                                                self step.
                                                (currentCharacter == $i) ifTrue:[
                                                    self step.
                                                    (currentCharacter == $b) ifTrue:[
                                                        self step.
                                                        (currentCharacter == $l) ifTrue:[
                                                            self step.
                                                            (currentCharacter == $i) ifTrue:[
                                                                self step.
                                                                (currentCharacter == $n) ifTrue:[
                                                                    self step.
                                                                    (currentCharacter == $g) ifTrue:[
                                                                        ^ self recordAndReportMatch:#( 5 ).
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
            ^ self reportLastMatch
        ].
        ^ self reportLastMatch
    ].
    (currentCharacter == $p) ifTrue:[
        ^ self scan3
    ].
    ^ self reportLastMatch

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
! !

!XPathScanner methodsFor:'generated-tokens'!

emptySymbolTokenId
	^47

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

errorTokenId
	^48

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
! !

!XPathScanner class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathScanner.st,v 1.2 2007-12-01 17:56:51 vranyj1 Exp $'
! !
