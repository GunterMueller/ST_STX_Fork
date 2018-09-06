"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::Scanner subclass:#XQueryScanner
	instanceVariableNames:'lastValidState invalidTokenIds'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Core'
!


!XQueryScanner class methodsFor:'generated-comments'!

scannerDefinitionComment

	"<whitespace> :  [\f\n\r\t\v]+;
<comment> : \(\:.*\:\);
<char> : [a-zA-Z];
<digit> : [0-9];
<char_ref> : ((&\#[0-9]+\;) | (&\#x[0-9a-fA-F]+\;));

<ncnamechar> : (<char> | <digit> | \. | \- | \_);
<ncname> : (<char> | \_) (<ncnamechar>)*;
<qname> : (<ncname> \:)? <ncname>;

<digits> : [0-9]+;
<integer_literal> : <digits>;
<decimal_literal> : (\.<digits>) | (<digits>\.[0-9]*);
<double_literal> : ((\.<digits>) | (<digits>(\.[0-9]*)?)) [eE] [\+\-]? <digits>;

<predefined_entity_ref> : &(lt | gt | amp | quot | apos)\;;
<escape_quot> : """";
<escape_apos> : '';

<string_literal> : ("" (<predefined_entity_ref> | <char_ref> | <escape_quot> | [^""&])* "") | (' (<predefined_entity_ref> | <char_ref> | <escape_apos> | [^'&])* ');

<element_content_char> : <char> | <digit> | [ ];
<element_content_char2> : <char> - [{}<&] | <digit>;
<qout_attr_content_char> : <char> - [""{}<&];
<apos_attr_content_char> : <char> - ['{}<&];
"
! !

!XQueryScanner class methodsFor:'generated-initialization'!

initializeKeywordMap
    keywordMap := Dictionary new.
    #( #(131 'after' 89)
     #(131 'ancestor' 123)
     #(131 'and' 14)
     #(131 'as' 27)
     #(131 'ascending' 50)
     #(131 'at' 57)
     #(131 'attribute' 99)
     #(131 'before' 92)
     #(131 'by' 56)
     #(131 'cast' 30)
     #(131 'castable' 28)
     #(131 'child' 98)
     #(131 'comment' comment)
     #(131 'connect' 88)
     #(131 'copy' 94)
     #(131 'create' 85)
     #(131 'declare' 45)
     #(131 'default' 40)
     #(131 'delete' 66)
     #(131 'descendant' 100)
     #(131 'descending' 49)
     #(131 'disconnect' 81)
     #(131 'div' 1)
     #(131 'do' 71)
     #(131 'document' 73)
     #(131 'drop' 83)
     #(131 'element' 39)
     #(131 'else' 12)
     #(131 'empty' 52)
     #(131 'eq' 21)
     #(131 'every' 31)
     #(131 'except' 15)
     #(131 'first' 79)
     #(131 'following' 119)
     #(131 'for' 47)
     #(131 'from' 84)
     #(131 'function' 34)
     #(131 'ge' 108)
     #(131 'greatest' 51)
     #(131 'gt' 105)
     #(131 'idiv' 4)
     #(131 'if' 10)
     #(131 'import' 42)
     #(131 'in' 58)
     #(131 'insert' 69)
     #(131 'instance' 26)
     #(131 'intersect' 16)
     #(131 'into' 80)
     #(131 'is' 107)
     #(131 'item' 23)
     #(131 'last' 90)
     #(131 'le' 106)
     #(131 'least' 54)
     #(131 'let' 60)
     #(131 'lt' 95)
     #(131 'mod' 3)
     #(131 'modify' 93)
     #(131 'module' 41)
     #(131 'namespace' 43)
     #(131 'ne' 63)
     #(131 'node' 77)
     #(131 'of' 25)
     #(131 'on' 82)
     #(131 'or' 11)
     #(131 'order' 61)
     #(131 'ordered' 115)
     #(131 'parent' 121)
     #(131 'preceding' 126)
     #(131 'rename' 65)
     #(131 'replace' 68)
     #(131 'return' 48)
     #(131 'satisfies' 32)
     #(131 'self' 102)
     #(131 'some' 53)
     #(131 'stable' 55)
     #(131 'statement' 64)
     #(131 'text' 76)
     #(131 'then' 9)
     #(131 'to' 13)
     #(131 'transform' 91)
     #(131 'trigger' 86)
     #(131 'triggerdef' 87)
     #(131 'union' 6)
     #(131 'unordered' 112)
     #(131 'value' 67)
     #(131 'where' 62)
     #(131 'with' 70)
     #(132 'after' 89)
     #(132 'ancestor' 123)
     #(132 'and' 14)
     #(132 'as' 27)
     #(132 'ascending' 50)
     #(132 'at' 57)
     #(132 'attribute' 99)
     #(132 'before' 92)
     #(132 'by' 56)
     #(132 'cast' 30)
     #(132 'castable' 28)
     #(132 'child' 98)
     #(132 'comment' comment)
     #(132 'connect' 88)
     #(132 'copy' 94)
     #(132 'create' 85)
     #(132 'declare' 45)
     #(132 'default' 40)
     #(132 'delete' 66)
     #(132 'descendant' 100)
     #(132 'descending' 49)
     #(132 'disconnect' 81)
     #(132 'div' 1)
     #(132 'do' 71)
     #(132 'document' 73)
     #(132 'drop' 83)
     #(132 'element' 39)
     #(132 'else' 12)
     #(132 'empty' 52)
     #(132 'eq' 21)
     #(132 'every' 31)
     #(132 'except' 15)
     #(132 'first' 79)
     #(132 'following' 119)
     #(132 'for' 47)
     #(132 'from' 84)
     #(132 'function' 34)
     #(132 'ge' 108)
     #(132 'greatest' 51)
     #(132 'gt' 105)
     #(132 'idiv' 4)
     #(132 'if' 10)
     #(132 'import' 42)
     #(132 'in' 58)
     #(132 'insert' 69)
     #(132 'instance' 26)
     #(132 'intersect' 16)
     #(132 'into' 80)
     #(132 'is' 107)
     #(132 'item' 23)
     #(132 'last' 90)
     #(132 'le' 106)
     #(132 'least' 54)
     #(132 'let' 60)
     #(132 'lt' 95)
     #(132 'mod' 3)
     #(132 'modify' 93)
     #(132 'module' 41)
     #(132 'namespace' 43)
     #(132 'ne' 63)
     #(132 'node' 77)
     #(132 'of' 25)
     #(132 'on' 82)
     #(132 'or' 11)
     #(132 'order' 61)
     #(132 'ordered' 115)
     #(132 'parent' 121)
     #(132 'preceding' 126)
     #(132 'rename' 65)
     #(132 'replace' 68)
     #(132 'return' 48)
     #(132 'satisfies' 32)
     #(132 'self' 102)
     #(132 'some' 53)
     #(132 'stable' 55)
     #(132 'statement' 64)
     #(132 'text' 76)
     #(132 'then' 9)
     #(132 'to' 13)
     #(132 'transform' 91)
     #(132 'trigger' 86)
     #(132 'triggerdef' 87)
     #(132 'union' 6)
     #(132 'unordered' 112)
     #(132 'value' 67)
     #(132 'where' 62)
     #(132 'with' 70) ) do:
                [:each | 
                (keywordMap at:each first ifAbsentPut:[Dictionary new]) at:(each at:2)
                    put:each last].
    ^keywordMap
! !

!XQueryScanner methodsFor:'accessing'!

invalidTokenIds
    invalidTokenIds isNil ifTrue: [
        invalidTokenIds := OrderedCollection new.
    ].

    ^ invalidTokenIds.

    "Created: / 13-07-2009 / 22:39:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

lastValidState
    lastValidState isNil ifTrue: [
        lastValidState := XQueryScannerState new.
    ].
    ^ lastValidState.

    "Created: / 13-07-2009 / 23:03:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

source

    ^stream isExternalStream
        ifTrue:[self sourceFromExternalStream]
        ifFalse:[self sourceFromInternalStream]

    "Created: / 12-04-2007 / 11:52:21 / janfrog"
!

sourceFromExternalStream

    ^self shouldImplement "not yet implemented"

    "Created: / 12-04-2007 / 11:53:47 / janfrog"
!

sourceFromInternalStream

    ^stream collection asString.

    "Created: / 12-04-2007 / 11:54:00 / janfrog"
!

stream
    ^stream

    "Created: / 24-10-2007 / 15:55:43 / janfrog"
! !

!XQueryScanner methodsFor:'generated-scanner'!

scan1
    
    [self step.
    currentCharacter ~~ $:] whileTrue.
    ^self scan20
!

scan10
    self step.
    (currentCharacter == $t) ifTrue:[^self scan9].
    ^self reportLastMatch
!

scan11
    
    [self step.
    (currentCharacter <= $% or:[currentCharacter >= $(])] whileTrue.
    (currentCharacter == $&) 
        ifTrue:
            [self step.
            (currentCharacter == $g or:[currentCharacter == $l]) 
                ifTrue:[^self scan10].
            (currentCharacter == $#) 
                ifTrue:
                    [self step.
                    (currentCharacter isNationalDigit) 
                        ifTrue:
                            [
                            [self step.
                            (currentCharacter isNationalDigit)] whileTrue.
                            (currentCharacter == $;) ifTrue:[^self scan11].
                            ^self reportLastMatch].
                    (currentCharacter == $x) 
                        ifTrue:
                            [self step.
                            (currentCharacter isNationalDigit or:
                                    [(currentCharacter between:$A and:$F) 
                                        or:[(currentCharacter between:$a and:$f)]]) 
                                ifTrue:
                                    [
                                    [self step.
                                    (currentCharacter isNationalDigit or:
                                            [(currentCharacter between:$A and:$F) 
                                                or:[(currentCharacter between:$a and:$f)]])] whileTrue.
                                    (currentCharacter == $;) ifTrue:[^self scan11].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            (currentCharacter == $a) 
                ifTrue:
                    [self step.
                    (currentCharacter == $m) 
                        ifTrue:
                            [self step.
                            (currentCharacter == $p) ifTrue:[^self scan9].
                            ^self reportLastMatch].
                    (currentCharacter == $p) 
                        ifTrue:
                            [self step.
                            (currentCharacter == $o) 
                                ifTrue:
                                    [self step.
                                    (currentCharacter == $s) ifTrue:[^self scan9].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            (currentCharacter == $q) 
                ifTrue:
                    [self step.
                    (currentCharacter == $u) 
                        ifTrue:
                            [self step.
                            (currentCharacter == $o) ifTrue:[^self scan10].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            ^self reportLastMatch].
    (currentCharacter == $') 
        ifTrue:
            [self recordMatch:#( 137 ).
            self step.
            (currentCharacter == $') ifTrue:[^self scan11].
            ^self reportLastMatch].
    ^self reportLastMatch
!

scan12
    
    [self recordMatch:#( 131 132 ).
    self step.
    (currentCharacter isLetterOrDigit 
        or:[(currentCharacter between:$- and:$.) or:[currentCharacter == $_]])] whileTrue.
    (currentCharacter == $:) ifTrue:[^self scan2].
    ^self reportLastMatch
!

scan13
    self recordMatch:#( 131 132 138 ).
    self step.
    (currentCharacter isNationalDigit or:
            [(currentCharacter between:$- and:$.) or:
                    [(currentCharacter between:$A and:$Z) or:
                            [currentCharacter == $_ or:
                                    [(currentCharacter between:$a and:$d) or:
                                            [(currentCharacter between:$f and:$n) 
                                                or:[(currentCharacter between:$p and:$z)]]]]]]) 
        ifTrue:[^self scan12].
    (currentCharacter == $:) ifTrue:[^self scan2].
    (currentCharacter == $e) 
        ifTrue:
            [self recordMatch:#( 131 132 ).
            self step.
            ((currentCharacter between:$- and:$.) or:
                    [(currentCharacter between:$0 and:$9) or:
                            [(currentCharacter between:$A and:$Z) or:
                                    [currentCharacter == $_ or:
                                            [(currentCharacter between:$a and:$r) 
                                                or:[(currentCharacter between:$t and:$z)]]]]]) 
                ifTrue:[^self scan12].
            (currentCharacter == $:) ifTrue:[^self scan2].
            (currentCharacter == $s) 
                ifTrue:
                    [self recordMatch:#( 131 132 ).
                    self step.
                    ((currentCharacter between:$- and:$.) or:
                            [(currentCharacter between:$0 and:$9) or:
                                    [(currentCharacter between:$A and:$Z) or:
                                            [currentCharacter == $_ or:
                                                    [(currentCharacter between:$a and:$b) 
                                                        or:[(currentCharacter between:$d and:$z)]]]]]) 
                        ifTrue:[^self scan12].
                    (currentCharacter == $:) ifTrue:[^self scan2].
                    (currentCharacter == $c) 
                        ifTrue:
                            [self recordMatch:#( 131 132 ).
                            self step.
                            (currentCharacter isNationalDigit or:
                                    [(currentCharacter between:$- and:$.) or:
                                            [(currentCharacter between:$A and:$Z) or:
                                                    [currentCharacter == $_ or:
                                                            [(currentCharacter between:$a and:$d) 
                                                                or:[(currentCharacter between:$f and:$z)]]]]]) 
                                ifTrue:[^self scan12].
                            (currentCharacter == $:) ifTrue:[^self scan2].
                            (currentCharacter == $e) 
                                ifTrue:
                                    [self recordMatch:#( 131 132 ).
                                    self step.
                                    ((currentCharacter between:$- and:$.) or:
                                            [(currentCharacter between:$0 and:$9) or:
                                                    [(currentCharacter between:$A and:$Z) or:
                                                            [currentCharacter == $_ or:
                                                                    [(currentCharacter between:$a and:$m) 
                                                                        or:[(currentCharacter between:$o and:$z)]]]]]) 
                                        ifTrue:[^self scan12].
                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                    (currentCharacter == $n) 
                                        ifTrue:
                                            [self recordMatch:#( 131 132 ).
                                            self step.
                                            ((currentCharacter between:$- and:$.) or:
                                                    [(currentCharacter between:$0 and:$9) or:
                                                            [(currentCharacter between:$A and:$Z) or:
                                                                    [currentCharacter == $_ or:
                                                                            [(currentCharacter between:$a and:$c) 
                                                                                or:[(currentCharacter between:$e and:$z)]]]]]) 
                                                ifTrue:[^self scan12].
                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                            (currentCharacter == $d) 
                                                ifTrue:
                                                    [self recordMatch:#( 131 132 ).
                                                    self step.
                                                    (currentCharacter isNationalDigit or:
                                                            [(currentCharacter between:$- and:$.) or:
                                                                    [(currentCharacter between:$A and:$Z) 
                                                                        or:[currentCharacter == $_ or:[(currentCharacter between:$b and:$z)]]]]) 
                                                        ifTrue:[^self scan12].
                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                    (currentCharacter == $a) 
                                                        ifTrue:
                                                            [self recordMatch:#( 131 132 ).
                                                            self step.
                                                            ((currentCharacter between:$- and:$.) or:
                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                    [currentCharacter == $_ or:
                                                                                            [(currentCharacter between:$a and:$m) 
                                                                                                or:[(currentCharacter between:$o and:$z)]]]]]) 
                                                                ifTrue:[^self scan12].
                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                            (currentCharacter == $n) 
                                                                ifTrue:
                                                                    [self recordMatch:#( 131 132 ).
                                                                    self step.
                                                                    ((currentCharacter between:$- and:$.) or:
                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                            [currentCharacter == $_ or:
                                                                                                    [(currentCharacter between:$a and:$s) 
                                                                                                        or:[(currentCharacter between:$u and:$z)]]]]]) 
                                                                        ifTrue:[^self scan12].
                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                    (currentCharacter == $t) 
                                                                        ifTrue:
                                                                            [self recordMatch:#( 131 132 ).
                                                                            self step.
                                                                            (currentCharacter isLetterOrDigit 
                                                                                or:[currentCharacter == $. or:[currentCharacter == $_]]) 
                                                                                    ifTrue:[^self scan12].
                                                                            (currentCharacter == $-) 
                                                                                ifTrue:
                                                                                    [self recordMatch:#( 131 132 ).
                                                                                    self step.
                                                                                    (currentCharacter isNationalDigit or:
                                                                                            [(currentCharacter between:$- and:$.) or:
                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                            [currentCharacter == $_ or:
                                                                                                                    [(currentCharacter between:$a and:$n) 
                                                                                                                        or:[(currentCharacter between:$p and:$z)]]]]]) 
                                                                                        ifTrue:[^self scan12].
                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                    (currentCharacter == $o) 
                                                                                        ifTrue:
                                                                                            [self recordMatch:#( 131 132 ).
                                                                                            self step.
                                                                                            ((currentCharacter between:$- and:$.) or:
                                                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                    [currentCharacter == $_ or:
                                                                                                                            [(currentCharacter between:$a and:$q) 
                                                                                                                                or:[(currentCharacter between:$s and:$z)]]]]]) 
                                                                                                ifTrue:[^self scan12].
                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                            (currentCharacter == $r) 
                                                                                                ifTrue:
                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                    self step.
                                                                                                    (currentCharacter isLetterOrDigit 
                                                                                                        or:[currentCharacter == $. or:[currentCharacter == $_]]) 
                                                                                                            ifTrue:[^self scan12].
                                                                                                    (currentCharacter == $-) 
                                                                                                        ifTrue:
                                                                                                            [self recordMatch:#( 131 132 ).
                                                                                                            self step.
                                                                                                            ((currentCharacter between:$- and:$.) or:
                                                                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                                    [currentCharacter == $_ or:
                                                                                                                                            [(currentCharacter between:$a and:$r) 
                                                                                                                                                or:[(currentCharacter between:$t and:$z)]]]]]) 
                                                                                                                ifTrue:[^self scan12].
                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                            (currentCharacter == $s) 
                                                                                                                ifTrue:
                                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                                    self step.
                                                                                                                    (currentCharacter isNationalDigit or:
                                                                                                                            [(currentCharacter between:$- and:$.) or:
                                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                                    [(currentCharacter between:$a and:$d) 
                                                                                                                                                        or:[(currentCharacter between:$f and:$z)]]]]]) 
                                                                                                                        ifTrue:[^self scan12].
                                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                    (currentCharacter == $e) 
                                                                                                                        ifTrue:
                                                                                                                            [self recordMatch:#( 131 132 ).
                                                                                                                            self step.
                                                                                                                            ((currentCharacter between:$- and:$.) or:
                                                                                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                                                    [currentCharacter == $_ or:
                                                                                                                                                            [(currentCharacter between:$a and:$k) 
                                                                                                                                                                or:[(currentCharacter between:$m and:$z)]]]]]) 
                                                                                                                                ifTrue:[^self scan12].
                                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                            (currentCharacter == $l) 
                                                                                                                                ifTrue:
                                                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                                                    self step.
                                                                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                                                    [(currentCharacter between:$a and:$e) 
                                                                                                                                                                        or:[(currentCharacter between:$g and:$z)]]]]]) 
                                                                                                                                        ifTrue:[^self scan12].
                                                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                                    (currentCharacter == $f) 
                                                                                                                                        ifTrue:
                                                                                                                                            [self recordMatch:#( 101 131 132 ).
                                                                                                                                            self step.
                                                                                                                                            (currentCharacter isLetterOrDigit 
                                                                                                                                                or:[(currentCharacter between:$- and:$.) or:[currentCharacter == $_]]) 
                                                                                                                                                    ifTrue:[^self scan12].
                                                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                                            ^self reportLastMatch].
                                                                                                                                    ^self reportLastMatch].
                                                                                                                            ^self reportLastMatch].
                                                                                                                    ^self reportLastMatch].
                                                                                                            ^self reportLastMatch].
                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                    ^self reportLastMatch].
                                                                                            ^self reportLastMatch].
                                                                                    ^self reportLastMatch].
                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                            ^self reportLastMatch].
                                                                    ^self reportLastMatch].
                                                            ^self reportLastMatch].
                                                    ^self reportLastMatch].
                                            ^self reportLastMatch].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            ^self reportLastMatch].
    (currentCharacter == $o) 
        ifTrue:
            [self recordMatch:#( 131 132 ).
            self step.
            ((currentCharacter between:$- and:$.) or:
                    [(currentCharacter between:$0 and:$9) or:
                            [(currentCharacter between:$A and:$Z) or:
                                    [currentCharacter == $_ or:
                                            [(currentCharacter between:$a and:$b) 
                                                or:[(currentCharacter between:$d and:$z)]]]]]) 
                ifTrue:[^self scan12].
            (currentCharacter == $:) ifTrue:[^self scan2].
            (currentCharacter == $c) 
                ifTrue:
                    [self recordMatch:#( 131 132 ).
                    self step.
                    (currentCharacter isNationalDigit or:
                            [(currentCharacter between:$- and:$.) or:
                                    [(currentCharacter between:$A and:$Z) or:
                                            [currentCharacter == $_ or:
                                                    [(currentCharacter between:$a and:$t) 
                                                        or:[(currentCharacter between:$v and:$z)]]]]]) 
                        ifTrue:[^self scan12].
                    (currentCharacter == $:) ifTrue:[^self scan2].
                    (currentCharacter == $u) 
                        ifTrue:
                            [self recordMatch:#( 131 132 ).
                            self step.
                            ((currentCharacter between:$- and:$.) or:
                                    [(currentCharacter between:$0 and:$9) or:
                                            [(currentCharacter between:$A and:$Z) or:
                                                    [currentCharacter == $_ or:
                                                            [(currentCharacter between:$a and:$l) 
                                                                or:[(currentCharacter between:$n and:$z)]]]]]) 
                                ifTrue:[^self scan12].
                            (currentCharacter == $:) ifTrue:[^self scan2].
                            (currentCharacter == $m) 
                                ifTrue:
                                    [self recordMatch:#( 131 132 ).
                                    self step.
                                    (currentCharacter isNationalDigit or:
                                            [(currentCharacter between:$- and:$.) or:
                                                    [(currentCharacter between:$A and:$Z) or:
                                                            [currentCharacter == $_ or:
                                                                    [(currentCharacter between:$a and:$d) 
                                                                        or:[(currentCharacter between:$f and:$z)]]]]]) 
                                        ifTrue:[^self scan12].
                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                    (currentCharacter == $e) 
                                        ifTrue:
                                            [self recordMatch:#( 131 132 ).
                                            self step.
                                            ((currentCharacter between:$- and:$.) or:
                                                    [(currentCharacter between:$0 and:$9) or:
                                                            [(currentCharacter between:$A and:$Z) or:
                                                                    [currentCharacter == $_ or:
                                                                            [(currentCharacter between:$a and:$m) 
                                                                                or:[(currentCharacter between:$o and:$z)]]]]]) 
                                                ifTrue:[^self scan12].
                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                            (currentCharacter == $n) 
                                                ifTrue:
                                                    [self recordMatch:#( 131 132 ).
                                                    self step.
                                                    ((currentCharacter between:$- and:$.) or:
                                                            [(currentCharacter between:$0 and:$9) or:
                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                            [currentCharacter == $_ or:
                                                                                    [(currentCharacter between:$a and:$s) 
                                                                                        or:[(currentCharacter between:$u and:$z)]]]]]) 
                                                        ifTrue:[^self scan12].
                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                    (currentCharacter == $t) 
                                                        ifTrue:
                                                            [self recordMatch:#( 131 132 ).
                                                            self step.
                                                            (currentCharacter isLetterOrDigit 
                                                                or:[currentCharacter == $. or:[currentCharacter == $_]]) 
                                                                    ifTrue:[^self scan12].
                                                            (currentCharacter == $-) 
                                                                ifTrue:
                                                                    [self recordMatch:#( 131 132 ).
                                                                    self step.
                                                                    ((currentCharacter between:$- and:$.) or:
                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                            [currentCharacter == $_ or:
                                                                                                    [(currentCharacter between:$a and:$m) 
                                                                                                        or:[(currentCharacter between:$o and:$z)]]]]]) 
                                                                        ifTrue:[^self scan12].
                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                    (currentCharacter == $n) 
                                                                        ifTrue:
                                                                            [self recordMatch:#( 131 132 ).
                                                                            self step.
                                                                            (currentCharacter isNationalDigit or:
                                                                                    [(currentCharacter between:$- and:$.) or:
                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                    [currentCharacter == $_ or:
                                                                                                            [(currentCharacter between:$a and:$n) 
                                                                                                                or:[(currentCharacter between:$p and:$z)]]]]]) 
                                                                                ifTrue:[^self scan12].
                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                            (currentCharacter == $o) 
                                                                                ifTrue:
                                                                                    [self recordMatch:#( 131 132 ).
                                                                                    self step.
                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                            [currentCharacter == $_ or:
                                                                                                                    [(currentCharacter between:$a and:$c) 
                                                                                                                        or:[(currentCharacter between:$e and:$z)]]]]]) 
                                                                                        ifTrue:[^self scan12].
                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                    (currentCharacter == $d) 
                                                                                        ifTrue:
                                                                                            [self recordMatch:#( 131 132 ).
                                                                                            self step.
                                                                                            (currentCharacter isNationalDigit or:
                                                                                                    [(currentCharacter between:$- and:$.) or:
                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                    [currentCharacter == $_ or:
                                                                                                                            [(currentCharacter between:$a and:$d) 
                                                                                                                                or:[(currentCharacter between:$f and:$z)]]]]]) 
                                                                                                ifTrue:[^self scan12].
                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                            (currentCharacter == $e) 
                                                                                                ifTrue:
                                                                                                    [self recordMatch:#( 72 131 132 ).
                                                                                                    self step.
                                                                                                    (currentCharacter isLetterOrDigit 
                                                                                                        or:[(currentCharacter between:$- and:$.) or:[currentCharacter == $_]]) 
                                                                                                            ifTrue:[^self scan12].
                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                    ^self reportLastMatch].
                                                                                            ^self reportLastMatch].
                                                                                    ^self reportLastMatch].
                                                                            ^self reportLastMatch].
                                                                    ^self reportLastMatch].
                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                            ^self reportLastMatch].
                                                    ^self reportLastMatch].
                                            ^self reportLastMatch].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            ^self reportLastMatch].
    ^self reportLastMatch
!

scan14
    self recordMatch:#( 131 132 138 ).
    self step.
    ((currentCharacter between:$- and:$.) or:
            [(currentCharacter between:$0 and:$9) or:
                    [(currentCharacter between:$A and:$Z) or:
                            [currentCharacter == $_ or:
                                    [(currentCharacter between:$a and:$q) 
                                        or:[(currentCharacter between:$s and:$z)]]]]]) 
        ifTrue:[^self scan12].
    (currentCharacter == $:) ifTrue:[^self scan2].
    (currentCharacter == $r) ifTrue:[^self scan15].
    ^self reportLastMatch
!

scan15
    self recordMatch:#( 131 132 ).
    self step.
    (currentCharacter isNationalDigit or:
            [(currentCharacter between:$- and:$.) or:
                    [(currentCharacter between:$A and:$Z) or:
                            [currentCharacter == $_ or:
                                    [(currentCharacter between:$a and:$d) or:
                                            [(currentCharacter between:$f and:$n) 
                                                or:[(currentCharacter between:$p and:$z)]]]]]]) 
        ifTrue:[^self scan12].
    (currentCharacter == $:) ifTrue:[^self scan2].
    (currentCharacter == $e) 
        ifTrue:
            [self recordMatch:#( 131 132 ).
            self step.
            ((currentCharacter between:$- and:$.) or:
                    [(currentCharacter between:$0 and:$9) or:
                            [(currentCharacter between:$A and:$Z) or:
                                    [currentCharacter == $_ or:
                                            [(currentCharacter between:$a and:$b) 
                                                or:[(currentCharacter between:$d and:$z)]]]]]) 
                ifTrue:[^self scan12].
            (currentCharacter == $:) ifTrue:[^self scan2].
            (currentCharacter == $c) 
                ifTrue:
                    [self recordMatch:#( 131 132 ).
                    self step.
                    (currentCharacter isNationalDigit or:
                            [(currentCharacter between:$- and:$.) or:
                                    [(currentCharacter between:$A and:$Z) or:
                                            [currentCharacter == $_ or:
                                                    [(currentCharacter between:$a and:$d) 
                                                        or:[(currentCharacter between:$f and:$z)]]]]]) 
                        ifTrue:[^self scan12].
                    (currentCharacter == $:) ifTrue:[^self scan2].
                    (currentCharacter == $e) 
                        ifTrue:
                            [self recordMatch:#( 131 132 ).
                            self step.
                            ((currentCharacter between:$- and:$.) or:
                                    [(currentCharacter between:$0 and:$9) or:
                                            [(currentCharacter between:$A and:$Z) or:
                                                    [currentCharacter == $_ or:
                                                            [(currentCharacter between:$a and:$c) 
                                                                or:[(currentCharacter between:$e and:$z)]]]]]) 
                                ifTrue:[^self scan12].
                            (currentCharacter == $:) ifTrue:[^self scan2].
                            (currentCharacter == $d) 
                                ifTrue:
                                    [self recordMatch:#( 131 132 ).
                                    self step.
                                    (currentCharacter isNationalDigit or:
                                            [(currentCharacter between:$- and:$.) or:
                                                    [(currentCharacter between:$A and:$Z) or:
                                                            [currentCharacter == $_ or:
                                                                    [(currentCharacter between:$a and:$h) 
                                                                        or:[(currentCharacter between:$j and:$z)]]]]]) 
                                        ifTrue:[^self scan12].
                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                    (currentCharacter == $i) 
                                        ifTrue:
                                            [self recordMatch:#( 131 132 ).
                                            self step.
                                            ((currentCharacter between:$- and:$.) or:
                                                    [(currentCharacter between:$0 and:$9) or:
                                                            [(currentCharacter between:$A and:$Z) or:
                                                                    [currentCharacter == $_ or:
                                                                            [(currentCharacter between:$a and:$m) 
                                                                                or:[(currentCharacter between:$o and:$z)]]]]]) 
                                                ifTrue:[^self scan12].
                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                            (currentCharacter == $n) 
                                                ifTrue:
                                                    [self recordMatch:#( 131 132 ).
                                                    self step.
                                                    ((currentCharacter between:$- and:$.) or:
                                                            [(currentCharacter between:$0 and:$9) or:
                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                            [currentCharacter == $_ or:
                                                                                    [(currentCharacter between:$a and:$f) 
                                                                                        or:[(currentCharacter between:$h and:$z)]]]]]) 
                                                        ifTrue:[^self scan12].
                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                    (currentCharacter == $g) 
                                                        ifTrue:
                                                            [self recordMatch:#( 131 132 ).
                                                            self step.
                                                            (currentCharacter isLetterOrDigit 
                                                                or:[currentCharacter == $. or:[currentCharacter == $_]]) 
                                                                    ifTrue:[^self scan12].
                                                            (currentCharacter == $-) 
                                                                ifTrue:
                                                                    [self recordMatch:#( 131 132 ).
                                                                    self step.
                                                                    ((currentCharacter between:$- and:$.) or:
                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                            [currentCharacter == $_ or:
                                                                                                    [(currentCharacter between:$a and:$r) 
                                                                                                        or:[(currentCharacter between:$t and:$z)]]]]]) 
                                                                        ifTrue:[^self scan12].
                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                    (currentCharacter == $s) 
                                                                        ifTrue:
                                                                            [self recordMatch:#( 131 132 ).
                                                                            self step.
                                                                            (currentCharacter isNationalDigit or:
                                                                                    [(currentCharacter between:$- and:$.) or:
                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                    [currentCharacter == $_ or:
                                                                                                            [(currentCharacter between:$a and:$h) 
                                                                                                                or:[(currentCharacter between:$j and:$z)]]]]]) 
                                                                                ifTrue:[^self scan12].
                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                            (currentCharacter == $i) 
                                                                                ifTrue:
                                                                                    [self recordMatch:#( 131 132 ).
                                                                                    self step.
                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                            [currentCharacter == $_ 
                                                                                                                or:[currentCharacter == $a or:[(currentCharacter between:$c and:$z)]]]]]) 
                                                                                        ifTrue:[^self scan12].
                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                    (currentCharacter == $b) 
                                                                                        ifTrue:
                                                                                            [self recordMatch:#( 131 132 ).
                                                                                            self step.
                                                                                            ((currentCharacter between:$- and:$.) or:
                                                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                    [currentCharacter == $_ or:
                                                                                                                            [(currentCharacter between:$a and:$k) 
                                                                                                                                or:[(currentCharacter between:$m and:$z)]]]]]) 
                                                                                                ifTrue:[^self scan12].
                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                            (currentCharacter == $l) 
                                                                                                ifTrue:
                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                    self step.
                                                                                                    (currentCharacter isNationalDigit or:
                                                                                                            [(currentCharacter between:$- and:$.) or:
                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                    [(currentCharacter between:$a and:$h) 
                                                                                                                                        or:[(currentCharacter between:$j and:$z)]]]]]) 
                                                                                                        ifTrue:[^self scan12].
                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                    (currentCharacter == $i) 
                                                                                                        ifTrue:
                                                                                                            [self recordMatch:#( 131 132 ).
                                                                                                            self step.
                                                                                                            ((currentCharacter between:$- and:$.) or:
                                                                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                                    [currentCharacter == $_ or:
                                                                                                                                            [(currentCharacter between:$a and:$m) 
                                                                                                                                                or:[(currentCharacter between:$o and:$z)]]]]]) 
                                                                                                                ifTrue:[^self scan12].
                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                            (currentCharacter == $n) 
                                                                                                                ifTrue:
                                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                                    self step.
                                                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                                    [(currentCharacter between:$a and:$f) 
                                                                                                                                                        or:[(currentCharacter between:$h and:$z)]]]]]) 
                                                                                                                        ifTrue:[^self scan12].
                                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                    (currentCharacter == $g) 
                                                                                                                        ifTrue:
                                                                                                                            [self recordMatch:#( 127 131 132 ).
                                                                                                                            self step.
                                                                                                                            (currentCharacter isLetterOrDigit 
                                                                                                                                or:[(currentCharacter between:$- and:$.) or:[currentCharacter == $_]]) 
                                                                                                                                    ifTrue:[^self scan12].
                                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                            ^self reportLastMatch].
                                                                                                                    ^self reportLastMatch].
                                                                                                            ^self reportLastMatch].
                                                                                                    ^self reportLastMatch].
                                                                                            ^self reportLastMatch].
                                                                                    ^self reportLastMatch].
                                                                            ^self reportLastMatch].
                                                                    ^self reportLastMatch].
                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                            ^self reportLastMatch].
                                                    ^self reportLastMatch].
                                            ^self reportLastMatch].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            ^self reportLastMatch].
    (currentCharacter == $o) ifTrue:[^self scan16].
    ^self reportLastMatch
!

scan16
    self recordMatch:#( 131 132 ).
    self step.
    ((currentCharacter between:$- and:$.) or:
            [(currentCharacter between:$0 and:$9) or:
                    [(currentCharacter between:$A and:$Z) or:
                            [currentCharacter == $_ or:
                                    [(currentCharacter between:$a and:$b) 
                                        or:[(currentCharacter between:$d and:$z)]]]]]) 
        ifTrue:[^self scan12].
    (currentCharacter == $:) ifTrue:[^self scan2].
    (currentCharacter == $c) ifTrue:[^self scan17].
    ^self reportLastMatch
!

scan17
    self recordMatch:#( 131 132 ).
    self step.
    (currentCharacter isNationalDigit or:
            [(currentCharacter between:$- and:$.) or:
                    [(currentCharacter between:$A and:$Z) or:
                            [currentCharacter == $_ or:
                                    [(currentCharacter between:$a and:$d) 
                                        or:[(currentCharacter between:$f and:$z)]]]]]) 
        ifTrue:[^self scan12].
    (currentCharacter == $:) ifTrue:[^self scan2].
    (currentCharacter == $e) ifTrue:[^self scan18].
    ^self reportLastMatch
!

scan18
    self recordMatch:#( 131 132 ).
    self step.
    ((currentCharacter between:$- and:$.) or:
            [(currentCharacter between:$0 and:$9) or:
                    [(currentCharacter between:$A and:$Z) or:
                            [currentCharacter == $_ or:
                                    [(currentCharacter between:$a and:$r) 
                                        or:[(currentCharacter between:$t and:$z)]]]]]) 
        ifTrue:[^self scan12].
    (currentCharacter == $:) ifTrue:[^self scan2].
    (currentCharacter == $s) 
        ifTrue:
            [self recordMatch:#( 131 132 ).
            self step.
            ((currentCharacter between:$- and:$.) or:
                    [(currentCharacter between:$0 and:$9) or:
                            [(currentCharacter between:$A and:$Z) or:
                                    [currentCharacter == $_ or:
                                            [(currentCharacter between:$a and:$r) 
                                                or:[(currentCharacter between:$t and:$z)]]]]]) 
                ifTrue:[^self scan12].
            (currentCharacter == $:) ifTrue:[^self scan2].
            (currentCharacter == $s) 
                ifTrue:
                    [self recordMatch:#( 131 132 ).
                    self step.
                    (currentCharacter isNationalDigit or:
                            [(currentCharacter between:$- and:$.) or:
                                    [(currentCharacter between:$A and:$Z) or:
                                            [currentCharacter == $_ or:
                                                    [(currentCharacter between:$a and:$h) 
                                                        or:[(currentCharacter between:$j and:$z)]]]]]) 
                        ifTrue:[^self scan12].
                    (currentCharacter == $:) ifTrue:[^self scan2].
                    (currentCharacter == $i) 
                        ifTrue:
                            [self recordMatch:#( 131 132 ).
                            self step.
                            ((currentCharacter between:$- and:$.) or:
                                    [(currentCharacter between:$0 and:$9) or:
                                            [(currentCharacter between:$A and:$Z) or:
                                                    [currentCharacter == $_ or:
                                                            [(currentCharacter between:$a and:$m) 
                                                                or:[(currentCharacter between:$o and:$z)]]]]]) 
                                ifTrue:[^self scan12].
                            (currentCharacter == $:) ifTrue:[^self scan2].
                            (currentCharacter == $n) 
                                ifTrue:
                                    [self recordMatch:#( 131 132 ).
                                    self step.
                                    ((currentCharacter between:$- and:$.) or:
                                            [(currentCharacter between:$0 and:$9) or:
                                                    [(currentCharacter between:$A and:$Z) or:
                                                            [currentCharacter == $_ or:
                                                                    [(currentCharacter between:$a and:$f) 
                                                                        or:[(currentCharacter between:$h and:$z)]]]]]) 
                                        ifTrue:[^self scan12].
                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                    (currentCharacter == $g) 
                                        ifTrue:
                                            [self recordMatch:#( 131 132 ).
                                            self step.
                                            (currentCharacter isLetterOrDigit 
                                                or:[currentCharacter == $. or:[currentCharacter == $_]]) 
                                                    ifTrue:[^self scan12].
                                            (currentCharacter == $-) 
                                                ifTrue:
                                                    [self recordMatch:#( 131 132 ).
                                                    self step.
                                                    (currentCharacter isNationalDigit or:
                                                            [(currentCharacter between:$- and:$.) or:
                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                            [currentCharacter == $_ or:
                                                                                    [(currentCharacter between:$a and:$h) 
                                                                                        or:[(currentCharacter between:$j and:$z)]]]]]) 
                                                        ifTrue:[^self scan12].
                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                    (currentCharacter == $i) 
                                                        ifTrue:
                                                            [self recordMatch:#( 131 132 ).
                                                            self step.
                                                            ((currentCharacter between:$- and:$.) or:
                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                    [currentCharacter == $_ or:
                                                                                            [(currentCharacter between:$a and:$m) 
                                                                                                or:[(currentCharacter between:$o and:$z)]]]]]) 
                                                                ifTrue:[^self scan12].
                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                            (currentCharacter == $n) 
                                                                ifTrue:
                                                                    [self recordMatch:#( 131 132 ).
                                                                    self step.
                                                                    ((currentCharacter between:$- and:$.) or:
                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                            [currentCharacter == $_ or:
                                                                                                    [(currentCharacter between:$a and:$r) 
                                                                                                        or:[(currentCharacter between:$t and:$z)]]]]]) 
                                                                        ifTrue:[^self scan12].
                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                    (currentCharacter == $s) 
                                                                        ifTrue:
                                                                            [self recordMatch:#( 131 132 ).
                                                                            self step.
                                                                            ((currentCharacter between:$- and:$.) or:
                                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                    [currentCharacter == $_ or:
                                                                                                            [(currentCharacter between:$a and:$s) 
                                                                                                                or:[(currentCharacter between:$u and:$z)]]]]]) 
                                                                                ifTrue:[^self scan12].
                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                            (currentCharacter == $t) 
                                                                                ifTrue:
                                                                                    [self recordMatch:#( 131 132 ).
                                                                                    self step.
                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                            [currentCharacter == $_ or:
                                                                                                                    [(currentCharacter between:$a and:$q) 
                                                                                                                        or:[(currentCharacter between:$s and:$z)]]]]]) 
                                                                                        ifTrue:[^self scan12].
                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                    (currentCharacter == $r) 
                                                                                        ifTrue:
                                                                                            [self recordMatch:#( 131 132 ).
                                                                                            self step.
                                                                                            (currentCharacter isNationalDigit or:
                                                                                                    [(currentCharacter between:$- and:$.) or:
                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                    [currentCharacter == $_ or:
                                                                                                                            [(currentCharacter between:$a and:$t) 
                                                                                                                                or:[(currentCharacter between:$v and:$z)]]]]]) 
                                                                                                ifTrue:[^self scan12].
                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                            (currentCharacter == $u) 
                                                                                                ifTrue:
                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                    self step.
                                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                    [(currentCharacter between:$a and:$b) 
                                                                                                                                        or:[(currentCharacter between:$d and:$z)]]]]]) 
                                                                                                        ifTrue:[^self scan12].
                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                    (currentCharacter == $c) 
                                                                                                        ifTrue:
                                                                                                            [self recordMatch:#( 131 132 ).
                                                                                                            self step.
                                                                                                            ((currentCharacter between:$- and:$.) or:
                                                                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                                    [currentCharacter == $_ or:
                                                                                                                                            [(currentCharacter between:$a and:$s) 
                                                                                                                                                or:[(currentCharacter between:$u and:$z)]]]]]) 
                                                                                                                ifTrue:[^self scan12].
                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                            (currentCharacter == $t) 
                                                                                                                ifTrue:
                                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                                    self step.
                                                                                                                    (currentCharacter isNationalDigit or:
                                                                                                                            [(currentCharacter between:$- and:$.) or:
                                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                                    [(currentCharacter between:$a and:$h) 
                                                                                                                                                        or:[(currentCharacter between:$j and:$z)]]]]]) 
                                                                                                                        ifTrue:[^self scan12].
                                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                    (currentCharacter == $i) 
                                                                                                                        ifTrue:
                                                                                                                            [self recordMatch:#( 131 132 ).
                                                                                                                            self step.
                                                                                                                            (currentCharacter isNationalDigit or:
                                                                                                                                    [(currentCharacter between:$- and:$.) or:
                                                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                                                    [currentCharacter == $_ or:
                                                                                                                                                            [(currentCharacter between:$a and:$n) 
                                                                                                                                                                or:[(currentCharacter between:$p and:$z)]]]]]) 
                                                                                                                                ifTrue:[^self scan12].
                                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                            (currentCharacter == $o) 
                                                                                                                                ifTrue:
                                                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                                                    self step.
                                                                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                                                    [(currentCharacter between:$a and:$m) 
                                                                                                                                                                        or:[(currentCharacter between:$o and:$z)]]]]]) 
                                                                                                                                        ifTrue:[^self scan12].
                                                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                                    (currentCharacter == $n) 
                                                                                                                                        ifTrue:
                                                                                                                                            [self recordMatch:#( 78 131 132 ).
                                                                                                                                            self step.
                                                                                                                                            (currentCharacter isLetterOrDigit 
                                                                                                                                                or:[(currentCharacter between:$- and:$.) or:[currentCharacter == $_]]) 
                                                                                                                                                    ifTrue:[^self scan12].
                                                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                                            ^self reportLastMatch].
                                                                                                                                    ^self reportLastMatch].
                                                                                                                            ^self reportLastMatch].
                                                                                                                    ^self reportLastMatch].
                                                                                                            ^self reportLastMatch].
                                                                                                    ^self reportLastMatch].
                                                                                            ^self reportLastMatch].
                                                                                    ^self reportLastMatch].
                                                                            ^self reportLastMatch].
                                                                    ^self reportLastMatch].
                                                            ^self reportLastMatch].
                                                    ^self reportLastMatch].
                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                            ^self reportLastMatch].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            ^self reportLastMatch].
    ^self reportLastMatch
!

scan19
    
    [self recordMatch:#( 134 ).
    self step.
    (currentCharacter isNationalDigit)] whileTrue.
    (currentCharacter == $E or:[currentCharacter == $e]) ifTrue:[^self scan3].
    ^self reportLastMatch
!

scan2
    self step.
    (currentCharacter isLetter or:[currentCharacter == $_]) 
        ifTrue:
            [
            [self recordMatch:#( 132 ).
            self step.
            (currentCharacter isLetterOrDigit 
                or:[(currentCharacter between:$- and:$.) or:[currentCharacter == $_]])] whileTrue.
            ^self reportLastMatch].
    ^self reportLastMatch
!

scan20
    
    [self step.
    (currentCharacter <= $( 
        or:[(currentCharacter between:$* and:$9) or:[currentCharacter >= $;]]) 
            ifTrue:[^self scan1].
    (currentCharacter == $)) 
        ifTrue:
            [self recordMatch:#comment.
            self step.
            (currentCharacter ~~ $:) ifTrue:[^self scan1].
            (currentCharacter == $:) ifTrue:[^self scan20].
            ^self reportLastMatch].
    (currentCharacter == $:)] whileTrue.
    ^self reportLastMatch
!

scan21
    [
        self step.
        (currentCharacter <= $( 
            or:[ (currentCharacter between:$* and:$9) or:[ currentCharacter >= $; ] ]) 
                ifTrue:[ ^ self scan2 ].
        (currentCharacter == $)) ifTrue:[
            self recordMatch:#comment.
            self step.
            (currentCharacter ~~ $:) ifTrue:[
                ^ self scan2
            ].
            (currentCharacter == $:) ifTrue:[
                ^ self scan21
            ].
            ^ self reportLastMatch
        ].
        (currentCharacter == $:)
    ] whileTrue.
    ^ self reportLastMatch
!

scan22
    [
        self step.
        (currentCharacter <= $( 
            or:[ (currentCharacter between:$* and:$9) or:[ currentCharacter >= $; ] ]) 
                ifTrue:[ ^ self scan3 ].
        (currentCharacter == $)) ifTrue:[
            self recordMatch:#comment.
            self step.
            (currentCharacter ~~ $:) ifTrue:[
                ^ self scan3
            ].
            (currentCharacter == $:) ifTrue:[
                ^ self scan22
            ].
            ^ self reportLastMatch
        ].
        (currentCharacter == $:)
    ] whileTrue.
    ^ self reportLastMatch
!

scan23
    [
        self step.
        (currentCharacter <= $( 
            or:[ (currentCharacter between:$* and:$9) or:[ currentCharacter >= $; ] ]) 
                ifTrue:[ ^ self scan1 ].
        (currentCharacter == $)) ifTrue:[
            self recordMatch:#comment.
            self step.
            (currentCharacter ~~ $:) ifTrue:[
                ^ self scan1
            ].
            (currentCharacter == $:) ifTrue:[
                ^ self scan23
            ].
            ^ self reportLastMatch
        ].
        (currentCharacter == $:)
    ] whileTrue.
    ^ self reportLastMatch
!

scan3
    self step.
    (currentCharacter isNationalDigit) 
        ifTrue:
            [
            [self recordMatch:#( 135 ).
            self step.
            (currentCharacter isNationalDigit)] whileTrue.
            ^self reportLastMatch].
    (currentCharacter == $+ or:[currentCharacter == $-]) 
        ifTrue:
            [self step.
            (currentCharacter isNationalDigit) 
                ifTrue:
                    [
                    [self recordMatch:#( 135 ).
                    self step.
                    (currentCharacter isNationalDigit)] whileTrue.
                    ^self reportLastMatch].
            ^self reportLastMatch].
    ^self reportLastMatch
!

scan4
    self step.
    (currentCharacter == $t) ifTrue:[^self scan5].
    ^self reportLastMatch
!

scan5
    self step.
    (currentCharacter == $;) ifTrue:[^self recordAndReportMatch:#( 136 ).].
    ^self reportLastMatch
!

scan6
    
    [self step.
    (currentCharacter <= $!! 
        or:[(currentCharacter between:$# and:$%) or:[currentCharacter >= $']])] whileTrue.
    (currentCharacter == $") 
        ifTrue:
            [self recordMatch:#( 137 ).
            self step.
            (currentCharacter == $") ifTrue:[^self scan6].
            ^self reportLastMatch].
    (currentCharacter == $&) 
        ifTrue:
            [self step.
            (currentCharacter == $g or:[currentCharacter == $l]) ifTrue:[^self scan7].
            (currentCharacter == $#) 
                ifTrue:
                    [self step.
                    (currentCharacter isNationalDigit) 
                        ifTrue:
                            [
                            [self step.
                            (currentCharacter isNationalDigit)] whileTrue.
                            (currentCharacter == $;) ifTrue:[^self scan6].
                            ^self reportLastMatch].
                    (currentCharacter == $x) 
                        ifTrue:
                            [self step.
                            (currentCharacter isNationalDigit or:
                                    [(currentCharacter between:$A and:$F) 
                                        or:[(currentCharacter between:$a and:$f)]]) 
                                ifTrue:
                                    [
                                    [self step.
                                    (currentCharacter isNationalDigit or:
                                            [(currentCharacter between:$A and:$F) 
                                                or:[(currentCharacter between:$a and:$f)]])] whileTrue.
                                    (currentCharacter == $;) ifTrue:[^self scan6].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            (currentCharacter == $a) 
                ifTrue:
                    [self step.
                    (currentCharacter == $m) 
                        ifTrue:
                            [self step.
                            (currentCharacter == $p) ifTrue:[^self scan8].
                            ^self reportLastMatch].
                    (currentCharacter == $p) 
                        ifTrue:
                            [self step.
                            (currentCharacter == $o) 
                                ifTrue:
                                    [self step.
                                    (currentCharacter == $s) ifTrue:[^self scan8].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            (currentCharacter == $q) 
                ifTrue:
                    [self step.
                    (currentCharacter == $u) 
                        ifTrue:
                            [self step.
                            (currentCharacter == $o) ifTrue:[^self scan7].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            ^self reportLastMatch].
    ^self reportLastMatch
!

scan7
    self step.
    (currentCharacter == $t) ifTrue:[^self scan8].
    ^self reportLastMatch
!

scan8
    self step.
    (currentCharacter == $;) ifTrue:[^self scan6].
    ^self reportLastMatch
!

scan9
    self step.
    (currentCharacter == $;) ifTrue:[^self scan11].
    ^self reportLastMatch
!

scanForToken
    self step.
    ((currentCharacter between:$A and:$Z) or:
            [currentCharacter == $c or:
                    [(currentCharacter between:$g and:$o) 
                        or:[(currentCharacter between:$q and:$z)]]]) 
        ifTrue:
            [self recordMatch:#( 131 132 138 ).
            self step.
            (currentCharacter isLetterOrDigit 
                or:[(currentCharacter between:$- and:$.) or:[currentCharacter == $_]]) 
                    ifTrue:[^self scan12].
            (currentCharacter == $:) ifTrue:[^self scan2].
            ^self reportLastMatch].
    (currentCharacter isNationalDigit) 
        ifTrue:
            [self recordMatch:#( 133 138 ).
            self step.
            (currentCharacter isNationalDigit) 
                ifTrue:
                    [
                    [self recordMatch:#( 133 ).
                    self step.
                    (currentCharacter isNationalDigit)] whileTrue.
                    (currentCharacter == $E or:[currentCharacter == $e]) ifTrue:[^self scan3].
                    (currentCharacter == $.) ifTrue:[^self scan19].
                    ^self reportLastMatch].
            (currentCharacter == $E or:[currentCharacter == $e]) ifTrue:[^self scan3].
            (currentCharacter == $.) ifTrue:[^self scan19].
            ^self reportLastMatch].
    (currentCharacter between:(Character tab) and:(Character codePoint:16rD)) 
        ifTrue:
            [
            [self recordMatch:#whitespace.
            self step.
            (currentCharacter between:(Character tab) and:(Character codePoint:16rD))] whileTrue.
            ^self reportLastMatch].
    (currentCharacter == (Character space)) 
        ifTrue:[^self recordAndReportMatch:#( 138 ).].
    (currentCharacter == $!!) 
        ifTrue:
            [self step.
            (currentCharacter == $=) ifTrue:[^self recordAndReportMatch:#( 18 ).].
            ^self reportLastMatch].
    (currentCharacter == $") ifTrue:[^self scan6].
    (currentCharacter == $$) ifTrue:[^self recordAndReportMatch:#( 37 ).].
    (currentCharacter == $&) 
        ifTrue:
            [self step.
            (currentCharacter == $g or:[currentCharacter == $l]) ifTrue:[^self scan4].
            (currentCharacter == $#) 
                ifTrue:
                    [self step.
                    (currentCharacter isNationalDigit) 
                        ifTrue:
                            [
                            [self step.
                            (currentCharacter isNationalDigit)] whileTrue.
                            (currentCharacter == $;) ifTrue:[^self recordAndReportMatch:#( 130 ).].
                            ^self reportLastMatch].
                    (currentCharacter == $x) 
                        ifTrue:
                            [self step.
                            (currentCharacter isNationalDigit or:
                                    [(currentCharacter between:$A and:$F) 
                                        or:[(currentCharacter between:$a and:$f)]]) 
                                ifTrue:
                                    [
                                    [self step.
                                    (currentCharacter isNationalDigit or:
                                            [(currentCharacter between:$A and:$F) 
                                                or:[(currentCharacter between:$a and:$f)]])] whileTrue.
                                    (currentCharacter == $;) ifTrue:[^self recordAndReportMatch:#( 130 ).].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            (currentCharacter == $a) 
                ifTrue:
                    [self step.
                    (currentCharacter == $m) 
                        ifTrue:
                            [self step.
                            (currentCharacter == $p) ifTrue:[^self scan5].
                            ^self reportLastMatch].
                    (currentCharacter == $p) 
                        ifTrue:
                            [self step.
                            (currentCharacter == $o) 
                                ifTrue:
                                    [self step.
                                    (currentCharacter == $s) ifTrue:[^self scan5].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            (currentCharacter == $q) 
                ifTrue:
                    [self step.
                    (currentCharacter == $u) 
                        ifTrue:
                            [self step.
                            (currentCharacter == $o) ifTrue:[^self scan4].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            ^self reportLastMatch].
    (currentCharacter == $') ifTrue:[^self scan11].
    (currentCharacter == $() 
        ifTrue:
            [self recordMatch:#( 36 ).
            self step.
            (currentCharacter == $:) ifTrue:[^self scan1].
            ^self reportLastMatch].
    (currentCharacter == $)) ifTrue:[^self recordAndReportMatch:#( 35 ).].
    (currentCharacter == $*) ifTrue:[^self recordAndReportMatch:#( 2 ).].
    (currentCharacter == $+) ifTrue:[^self recordAndReportMatch:#( 8 ).].
    (currentCharacter == $,) ifTrue:[^self recordAndReportMatch:#( 38 ).].
    (currentCharacter == $-) ifTrue:[^self recordAndReportMatch:#( 7 ).].
    (currentCharacter == $.) 
        ifTrue:
            [self recordMatch:#( 116 ).
            self step.
            (currentCharacter isNationalDigit) ifTrue:[^self scan19].
            (currentCharacter == $.) ifTrue:[^self recordAndReportMatch:#( 124 ).].
            ^self reportLastMatch].
    (currentCharacter == $/) 
        ifTrue:
            [self recordMatch:#( 104 ).
            self step.
            (currentCharacter == $/) ifTrue:[^self recordAndReportMatch:#( 103 ).].
            (currentCharacter == $>) ifTrue:[^self recordAndReportMatch:#( 96 ).].
            ^self reportLastMatch].
    (currentCharacter == $:) 
        ifTrue:
            [self recordMatch:#( 120 ).
            self step.
            (currentCharacter == $:) ifTrue:[^self recordAndReportMatch:#( 97 ).].
            (currentCharacter == $=) ifTrue:[^self recordAndReportMatch:#( 59 ).].
            ^self reportLastMatch].
    (currentCharacter == $;) ifTrue:[^self recordAndReportMatch:#( 44 ).].
    (currentCharacter == $<) 
        ifTrue:
            [self recordMatch:#( 17 ).
            self step.
            (currentCharacter == $/) ifTrue:[^self recordAndReportMatch:#( 74 ).].
            (currentCharacter == $<) ifTrue:[^self recordAndReportMatch:#( 110 ).].
            (currentCharacter == $=) ifTrue:[^self recordAndReportMatch:#( 20 ).].
            ^self reportLastMatch].
    (currentCharacter == $=) ifTrue:[^self recordAndReportMatch:#( 46 ).].
    (currentCharacter == $>) 
        ifTrue:
            [self recordMatch:#( 19 ).
            self step.
            (currentCharacter == $=) ifTrue:[^self recordAndReportMatch:#( 22 ).].
            (currentCharacter == $>) ifTrue:[^self recordAndReportMatch:#( 109 ).].
            ^self reportLastMatch].
    (currentCharacter == $?) ifTrue:[^self recordAndReportMatch:#( 29 ).].
    (currentCharacter == $@) ifTrue:[^self recordAndReportMatch:#( 122 ).].
    (currentCharacter == $[) ifTrue:[^self recordAndReportMatch:#( 114 ).].
    (currentCharacter == $]) ifTrue:[^self recordAndReportMatch:#( 113 ).].
    (currentCharacter == $_) ifTrue:[^self scan12].
    (currentCharacter == $a) 
        ifTrue:
            [self recordMatch:#( 131 132 138 ).
            self step.
            ((currentCharacter between:$- and:$.) or:
                    [(currentCharacter between:$0 and:$9) or:
                            [(currentCharacter between:$A and:$Z) or:
                                    [currentCharacter == $_ or:
                                            [(currentCharacter between:$a and:$m) 
                                                or:[(currentCharacter between:$o and:$z)]]]]]) 
                ifTrue:[^self scan12].
            (currentCharacter == $:) ifTrue:[^self scan2].
            (currentCharacter == $n) 
                ifTrue:
                    [self recordMatch:#( 131 132 ).
                    self step.
                    ((currentCharacter between:$- and:$.) or:
                            [(currentCharacter between:$0 and:$9) or:
                                    [(currentCharacter between:$A and:$Z) or:
                                            [currentCharacter == $_ or:
                                                    [(currentCharacter between:$a and:$b) 
                                                        or:[(currentCharacter between:$d and:$z)]]]]]) 
                        ifTrue:[^self scan12].
                    (currentCharacter == $:) ifTrue:[^self scan2].
                    (currentCharacter == $c) 
                        ifTrue:
                            [self recordMatch:#( 131 132 ).
                            self step.
                            (currentCharacter isNationalDigit or:
                                    [(currentCharacter between:$- and:$.) or:
                                            [(currentCharacter between:$A and:$Z) or:
                                                    [currentCharacter == $_ or:
                                                            [(currentCharacter between:$a and:$d) 
                                                                or:[(currentCharacter between:$f and:$z)]]]]]) 
                                ifTrue:[^self scan12].
                            (currentCharacter == $:) ifTrue:[^self scan2].
                            (currentCharacter == $e) 
                                ifTrue:
                                    [self recordMatch:#( 131 132 ).
                                    self step.
                                    ((currentCharacter between:$- and:$.) or:
                                            [(currentCharacter between:$0 and:$9) or:
                                                    [(currentCharacter between:$A and:$Z) or:
                                                            [currentCharacter == $_ or:
                                                                    [(currentCharacter between:$a and:$r) 
                                                                        or:[(currentCharacter between:$t and:$z)]]]]]) 
                                        ifTrue:[^self scan12].
                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                    (currentCharacter == $s) 
                                        ifTrue:
                                            [self recordMatch:#( 131 132 ).
                                            self step.
                                            ((currentCharacter between:$- and:$.) or:
                                                    [(currentCharacter between:$0 and:$9) or:
                                                            [(currentCharacter between:$A and:$Z) or:
                                                                    [currentCharacter == $_ or:
                                                                            [(currentCharacter between:$a and:$s) 
                                                                                or:[(currentCharacter between:$u and:$z)]]]]]) 
                                                ifTrue:[^self scan12].
                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                            (currentCharacter == $t) 
                                                ifTrue:
                                                    [self recordMatch:#( 131 132 ).
                                                    self step.
                                                    (currentCharacter isNationalDigit or:
                                                            [(currentCharacter between:$- and:$.) or:
                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                            [currentCharacter == $_ or:
                                                                                    [(currentCharacter between:$a and:$n) 
                                                                                        or:[(currentCharacter between:$p and:$z)]]]]]) 
                                                        ifTrue:[^self scan12].
                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                    (currentCharacter == $o) 
                                                        ifTrue:
                                                            [self recordMatch:#( 131 132 ).
                                                            self step.
                                                            ((currentCharacter between:$- and:$.) or:
                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                    [currentCharacter == $_ or:
                                                                                            [(currentCharacter between:$a and:$q) 
                                                                                                or:[(currentCharacter between:$s and:$z)]]]]]) 
                                                                ifTrue:[^self scan12].
                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                            (currentCharacter == $r) 
                                                                ifTrue:
                                                                    [self recordMatch:#( 131 132 ).
                                                                    self step.
                                                                    (currentCharacter isLetterOrDigit 
                                                                        or:[currentCharacter == $. or:[currentCharacter == $_]]) 
                                                                            ifTrue:[^self scan12].
                                                                    (currentCharacter == $-) 
                                                                        ifTrue:
                                                                            [self recordMatch:#( 131 132 ).
                                                                            self step.
                                                                            (currentCharacter isNationalDigit or:
                                                                                    [(currentCharacter between:$- and:$.) or:
                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                    [currentCharacter == $_ or:
                                                                                                            [(currentCharacter between:$a and:$n) 
                                                                                                                or:[(currentCharacter between:$p and:$z)]]]]]) 
                                                                                ifTrue:[^self scan12].
                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                            (currentCharacter == $o) 
                                                                                ifTrue:
                                                                                    [self recordMatch:#( 131 132 ).
                                                                                    self step.
                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                            [currentCharacter == $_ or:
                                                                                                                    [(currentCharacter between:$a and:$q) 
                                                                                                                        or:[(currentCharacter between:$s and:$z)]]]]]) 
                                                                                        ifTrue:[^self scan12].
                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                    (currentCharacter == $r) 
                                                                                        ifTrue:
                                                                                            [self recordMatch:#( 131 132 ).
                                                                                            self step.
                                                                                            (currentCharacter isLetterOrDigit 
                                                                                                or:[currentCharacter == $. or:[currentCharacter == $_]]) 
                                                                                                    ifTrue:[^self scan12].
                                                                                            (currentCharacter == $-) 
                                                                                                ifTrue:
                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                    self step.
                                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                    [(currentCharacter between:$a and:$r) 
                                                                                                                                        or:[(currentCharacter between:$t and:$z)]]]]]) 
                                                                                                        ifTrue:[^self scan12].
                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                    (currentCharacter == $s) 
                                                                                                        ifTrue:
                                                                                                            [self recordMatch:#( 131 132 ).
                                                                                                            self step.
                                                                                                            (currentCharacter isNationalDigit or:
                                                                                                                    [(currentCharacter between:$- and:$.) or:
                                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                                    [currentCharacter == $_ or:
                                                                                                                                            [(currentCharacter between:$a and:$d) 
                                                                                                                                                or:[(currentCharacter between:$f and:$z)]]]]]) 
                                                                                                                ifTrue:[^self scan12].
                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                            (currentCharacter == $e) 
                                                                                                                ifTrue:
                                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                                    self step.
                                                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                                    [(currentCharacter between:$a and:$k) 
                                                                                                                                                        or:[(currentCharacter between:$m and:$z)]]]]]) 
                                                                                                                        ifTrue:[^self scan12].
                                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                    (currentCharacter == $l) 
                                                                                                                        ifTrue:
                                                                                                                            [self recordMatch:#( 131 132 ).
                                                                                                                            self step.
                                                                                                                            ((currentCharacter between:$- and:$.) or:
                                                                                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                                                    [currentCharacter == $_ or:
                                                                                                                                                            [(currentCharacter between:$a and:$e) 
                                                                                                                                                                or:[(currentCharacter between:$g and:$z)]]]]]) 
                                                                                                                                ifTrue:[^self scan12].
                                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                            (currentCharacter == $f) 
                                                                                                                                ifTrue:
                                                                                                                                    [self recordMatch:#( 125 131 132 ).
                                                                                                                                    self step.
                                                                                                                                    (currentCharacter isLetterOrDigit 
                                                                                                                                        or:[(currentCharacter between:$- and:$.) or:[currentCharacter == $_]]) 
                                                                                                                                            ifTrue:[^self scan12].
                                                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                                    ^self reportLastMatch].
                                                                                                                            ^self reportLastMatch].
                                                                                                                    ^self reportLastMatch].
                                                                                                            ^self reportLastMatch].
                                                                                                    ^self reportLastMatch].
                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                            ^self reportLastMatch].
                                                                                    ^self reportLastMatch].
                                                                            ^self reportLastMatch].
                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                    ^self reportLastMatch].
                                                            ^self reportLastMatch].
                                                    ^self reportLastMatch].
                                            ^self reportLastMatch].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            ^self reportLastMatch].
    (currentCharacter == $b) 
        ifTrue:
            [self recordMatch:#( 131 132 138 ).
            self step.
            (currentCharacter isNationalDigit or:
                    [(currentCharacter between:$- and:$.) or:
                            [(currentCharacter between:$A and:$Z) 
                                or:[currentCharacter == $_ or:[(currentCharacter between:$b and:$z)]]]]) 
                ifTrue:[^self scan12].
            (currentCharacter == $:) ifTrue:[^self scan2].
            (currentCharacter == $a) 
                ifTrue:
                    [self recordMatch:#( 131 132 ).
                    self step.
                    ((currentCharacter between:$- and:$.) or:
                            [(currentCharacter between:$0 and:$9) or:
                                    [(currentCharacter between:$A and:$Z) or:
                                            [currentCharacter == $_ or:
                                                    [(currentCharacter between:$a and:$r) 
                                                        or:[(currentCharacter between:$t and:$z)]]]]]) 
                        ifTrue:[^self scan12].
                    (currentCharacter == $:) ifTrue:[^self scan2].
                    (currentCharacter == $s) 
                        ifTrue:
                            [self recordMatch:#( 131 132 ).
                            self step.
                            (currentCharacter isNationalDigit or:
                                    [(currentCharacter between:$- and:$.) or:
                                            [(currentCharacter between:$A and:$Z) or:
                                                    [currentCharacter == $_ or:
                                                            [(currentCharacter between:$a and:$d) 
                                                                or:[(currentCharacter between:$f and:$z)]]]]]) 
                                ifTrue:[^self scan12].
                            (currentCharacter == $:) ifTrue:[^self scan2].
                            (currentCharacter == $e) 
                                ifTrue:
                                    [self recordMatch:#( 131 132 ).
                                    self step.
                                    (currentCharacter isLetterOrDigit 
                                        or:[currentCharacter == $. or:[currentCharacter == $_]]) 
                                            ifTrue:[^self scan12].
                                    (currentCharacter == $-) 
                                        ifTrue:
                                            [self recordMatch:#( 131 132 ).
                                            self step.
                                            (currentCharacter isNationalDigit or:
                                                    [(currentCharacter between:$- and:$.) or:
                                                            [(currentCharacter between:$A and:$Z) or:
                                                                    [currentCharacter == $_ or:
                                                                            [(currentCharacter between:$a and:$t) 
                                                                                or:[(currentCharacter between:$v and:$z)]]]]]) 
                                                ifTrue:[^self scan12].
                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                            (currentCharacter == $u) 
                                                ifTrue:
                                                    [self recordMatch:#( 131 132 ).
                                                    self step.
                                                    ((currentCharacter between:$- and:$.) or:
                                                            [(currentCharacter between:$0 and:$9) or:
                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                            [currentCharacter == $_ or:
                                                                                    [(currentCharacter between:$a and:$q) 
                                                                                        or:[(currentCharacter between:$s and:$z)]]]]]) 
                                                        ifTrue:[^self scan12].
                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                    (currentCharacter == $r) 
                                                        ifTrue:
                                                            [self recordMatch:#( 131 132 ).
                                                            self step.
                                                            (currentCharacter isNationalDigit or:
                                                                    [(currentCharacter between:$- and:$.) or:
                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                    [currentCharacter == $_ or:
                                                                                            [(currentCharacter between:$a and:$h) 
                                                                                                or:[(currentCharacter between:$j and:$z)]]]]]) 
                                                                ifTrue:[^self scan12].
                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                            (currentCharacter == $i) 
                                                                ifTrue:
                                                                    [self recordMatch:#( 33 131 132 ).
                                                                    self step.
                                                                    (currentCharacter isLetterOrDigit 
                                                                        or:[(currentCharacter between:$- and:$.) or:[currentCharacter == $_]]) 
                                                                            ifTrue:[^self scan12].
                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                    ^self reportLastMatch].
                                                            ^self reportLastMatch].
                                                    ^self reportLastMatch].
                                            ^self reportLastMatch].
                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            ^self reportLastMatch].
    (currentCharacter == $d) ifTrue:[^self scan13].
    (currentCharacter == $e) 
        ifTrue:
            [self recordMatch:#( 131 132 138 ).
            self step.
            ((currentCharacter between:$- and:$.) or:
                    [(currentCharacter between:$0 and:$9) or:
                            [(currentCharacter between:$A and:$Z) or:
                                    [currentCharacter == $_ or:
                                            [(currentCharacter between:$a and:$l) 
                                                or:[(currentCharacter between:$n and:$z)]]]]]) 
                ifTrue:[^self scan12].
            (currentCharacter == $:) ifTrue:[^self scan2].
            (currentCharacter == $m) 
                ifTrue:
                    [self recordMatch:#( 131 132 ).
                    self step.
                    ((currentCharacter between:$- and:$.) or:
                            [(currentCharacter between:$0 and:$9) or:
                                    [(currentCharacter between:$A and:$Z) or:
                                            [currentCharacter == $_ or:
                                                    [(currentCharacter between:$a and:$o) 
                                                        or:[(currentCharacter between:$q and:$z)]]]]]) 
                        ifTrue:[^self scan12].
                    (currentCharacter == $:) ifTrue:[^self scan2].
                    (currentCharacter == $p) 
                        ifTrue:
                            [self recordMatch:#( 131 132 ).
                            self step.
                            ((currentCharacter between:$- and:$.) or:
                                    [(currentCharacter between:$0 and:$9) or:
                                            [(currentCharacter between:$A and:$Z) or:
                                                    [currentCharacter == $_ or:
                                                            [(currentCharacter between:$a and:$s) 
                                                                or:[(currentCharacter between:$u and:$z)]]]]]) 
                                ifTrue:[^self scan12].
                            (currentCharacter == $:) ifTrue:[^self scan2].
                            (currentCharacter == $t) 
                                ifTrue:
                                    [self recordMatch:#( 131 132 ).
                                    self step.
                                    ((currentCharacter between:$- and:$.) or:
                                            [(currentCharacter between:$0 and:$9) or:
                                                    [(currentCharacter between:$A and:$Z) or:
                                                            [currentCharacter == $_ 
                                                                or:[(currentCharacter between:$a and:$x) or:[currentCharacter == $z]]]]]) 
                                        ifTrue:[^self scan12].
                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                    (currentCharacter == $y) 
                                        ifTrue:
                                            [self recordMatch:#( 131 132 ).
                                            self step.
                                            (currentCharacter isLetterOrDigit 
                                                or:[currentCharacter == $. or:[currentCharacter == $_]]) 
                                                    ifTrue:[^self scan12].
                                            (currentCharacter == $-) 
                                                ifTrue:
                                                    [self recordMatch:#( 131 132 ).
                                                    self step.
                                                    ((currentCharacter between:$- and:$.) or:
                                                            [(currentCharacter between:$0 and:$9) or:
                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                            [currentCharacter == $_ or:
                                                                                    [(currentCharacter between:$a and:$r) 
                                                                                        or:[(currentCharacter between:$t and:$z)]]]]]) 
                                                        ifTrue:[^self scan12].
                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                    (currentCharacter == $s) 
                                                        ifTrue:
                                                            [self recordMatch:#( 131 132 ).
                                                            self step.
                                                            (currentCharacter isNationalDigit or:
                                                                    [(currentCharacter between:$- and:$.) or:
                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                    [currentCharacter == $_ or:
                                                                                            [(currentCharacter between:$a and:$d) 
                                                                                                or:[(currentCharacter between:$f and:$z)]]]]]) 
                                                                ifTrue:[^self scan12].
                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                            (currentCharacter == $e) 
                                                                ifTrue:
                                                                    [self recordMatch:#( 131 132 ).
                                                                    self step.
                                                                    ((currentCharacter between:$- and:$.) or:
                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                            [currentCharacter == $_ or:
                                                                                                    [(currentCharacter between:$a and:$p) 
                                                                                                        or:[(currentCharacter between:$r and:$z)]]]]]) 
                                                                        ifTrue:[^self scan12].
                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                    (currentCharacter == $q) 
                                                                        ifTrue:
                                                                            [self recordMatch:#( 131 132 ).
                                                                            self step.
                                                                            (currentCharacter isNationalDigit or:
                                                                                    [(currentCharacter between:$- and:$.) or:
                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                    [currentCharacter == $_ or:
                                                                                                            [(currentCharacter between:$a and:$t) 
                                                                                                                or:[(currentCharacter between:$v and:$z)]]]]]) 
                                                                                ifTrue:[^self scan12].
                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                            (currentCharacter == $u) 
                                                                                ifTrue:
                                                                                    [self recordMatch:#( 131 132 ).
                                                                                    self step.
                                                                                    (currentCharacter isNationalDigit or:
                                                                                            [(currentCharacter between:$- and:$.) or:
                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                            [currentCharacter == $_ or:
                                                                                                                    [(currentCharacter between:$a and:$d) 
                                                                                                                        or:[(currentCharacter between:$f and:$z)]]]]]) 
                                                                                        ifTrue:[^self scan12].
                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                    (currentCharacter == $e) 
                                                                                        ifTrue:
                                                                                            [self recordMatch:#( 131 132 ).
                                                                                            self step.
                                                                                            ((currentCharacter between:$- and:$.) or:
                                                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                    [currentCharacter == $_ or:
                                                                                                                            [(currentCharacter between:$a and:$m) 
                                                                                                                                or:[(currentCharacter between:$o and:$z)]]]]]) 
                                                                                                ifTrue:[^self scan12].
                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                            (currentCharacter == $n) 
                                                                                                ifTrue:
                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                    self step.
                                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                    [(currentCharacter between:$a and:$b) 
                                                                                                                                        or:[(currentCharacter between:$d and:$z)]]]]]) 
                                                                                                        ifTrue:[^self scan12].
                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                    (currentCharacter == $c) 
                                                                                                        ifTrue:
                                                                                                            [self recordMatch:#( 131 132 ).
                                                                                                            self step.
                                                                                                            (currentCharacter isNationalDigit or:
                                                                                                                    [(currentCharacter between:$- and:$.) or:
                                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                                    [currentCharacter == $_ or:
                                                                                                                                            [(currentCharacter between:$a and:$d) 
                                                                                                                                                or:[(currentCharacter between:$f and:$z)]]]]]) 
                                                                                                                ifTrue:[^self scan12].
                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                            (currentCharacter == $e) 
                                                                                                                ifTrue:
                                                                                                                    [self recordMatch:#( 24 131 132 ).
                                                                                                                    self step.
                                                                                                                    (currentCharacter isLetterOrDigit 
                                                                                                                        or:[(currentCharacter between:$- and:$.) or:[currentCharacter == $_]]) 
                                                                                                                            ifTrue:[^self scan12].
                                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                    ^self reportLastMatch].
                                                                                                            ^self reportLastMatch].
                                                                                                    ^self reportLastMatch].
                                                                                            ^self reportLastMatch].
                                                                                    ^self reportLastMatch].
                                                                            ^self reportLastMatch].
                                                                    ^self reportLastMatch].
                                                            ^self reportLastMatch].
                                                    ^self reportLastMatch].
                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                            ^self reportLastMatch].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            ^self reportLastMatch].
    (currentCharacter == $f) 
        ifTrue:
            [self recordMatch:#( 131 132 138 ).
            self step.
            (currentCharacter isNationalDigit or:
                    [(currentCharacter between:$- and:$.) or:
                            [(currentCharacter between:$A and:$Z) or:
                                    [currentCharacter == $_ or:
                                            [(currentCharacter between:$a and:$n) 
                                                or:[(currentCharacter between:$p and:$z)]]]]]) 
                ifTrue:[^self scan12].
            (currentCharacter == $:) ifTrue:[^self scan2].
            (currentCharacter == $o) 
                ifTrue:
                    [self recordMatch:#( 131 132 ).
                    self step.
                    ((currentCharacter between:$- and:$.) or:
                            [(currentCharacter between:$0 and:$9) or:
                                    [(currentCharacter between:$A and:$Z) or:
                                            [currentCharacter == $_ or:
                                                    [(currentCharacter between:$a and:$k) 
                                                        or:[(currentCharacter between:$m and:$z)]]]]]) 
                        ifTrue:[^self scan12].
                    (currentCharacter == $:) ifTrue:[^self scan2].
                    (currentCharacter == $l) 
                        ifTrue:
                            [self recordMatch:#( 131 132 ).
                            self step.
                            ((currentCharacter between:$- and:$.) or:
                                    [(currentCharacter between:$0 and:$9) or:
                                            [(currentCharacter between:$A and:$Z) or:
                                                    [currentCharacter == $_ or:
                                                            [(currentCharacter between:$a and:$k) 
                                                                or:[(currentCharacter between:$m and:$z)]]]]]) 
                                ifTrue:[^self scan12].
                            (currentCharacter == $:) ifTrue:[^self scan2].
                            (currentCharacter == $l) 
                                ifTrue:
                                    [self recordMatch:#( 131 132 ).
                                    self step.
                                    (currentCharacter isNationalDigit or:
                                            [(currentCharacter between:$- and:$.) or:
                                                    [(currentCharacter between:$A and:$Z) or:
                                                            [currentCharacter == $_ or:
                                                                    [(currentCharacter between:$a and:$n) 
                                                                        or:[(currentCharacter between:$p and:$z)]]]]]) 
                                        ifTrue:[^self scan12].
                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                    (currentCharacter == $o) 
                                        ifTrue:
                                            [self recordMatch:#( 131 132 ).
                                            self step.
                                            ((currentCharacter between:$- and:$.) or:
                                                    [(currentCharacter between:$0 and:$9) or:
                                                            [(currentCharacter between:$A and:$Z) or:
                                                                    [currentCharacter == $_ or:
                                                                            [(currentCharacter between:$a and:$v) 
                                                                                or:[(currentCharacter between:$x and:$z)]]]]]) 
                                                ifTrue:[^self scan12].
                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                            (currentCharacter == $w) 
                                                ifTrue:
                                                    [self recordMatch:#( 131 132 ).
                                                    self step.
                                                    (currentCharacter isNationalDigit or:
                                                            [(currentCharacter between:$- and:$.) or:
                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                            [currentCharacter == $_ or:
                                                                                    [(currentCharacter between:$a and:$h) 
                                                                                        or:[(currentCharacter between:$j and:$z)]]]]]) 
                                                        ifTrue:[^self scan12].
                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                    (currentCharacter == $i) 
                                                        ifTrue:
                                                            [self recordMatch:#( 131 132 ).
                                                            self step.
                                                            ((currentCharacter between:$- and:$.) or:
                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                    [currentCharacter == $_ or:
                                                                                            [(currentCharacter between:$a and:$m) 
                                                                                                or:[(currentCharacter between:$o and:$z)]]]]]) 
                                                                ifTrue:[^self scan12].
                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                            (currentCharacter == $n) 
                                                                ifTrue:
                                                                    [self recordMatch:#( 131 132 ).
                                                                    self step.
                                                                    ((currentCharacter between:$- and:$.) or:
                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                            [currentCharacter == $_ or:
                                                                                                    [(currentCharacter between:$a and:$f) 
                                                                                                        or:[(currentCharacter between:$h and:$z)]]]]]) 
                                                                        ifTrue:[^self scan12].
                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                    (currentCharacter == $g) 
                                                                        ifTrue:
                                                                            [self recordMatch:#( 131 132 ).
                                                                            self step.
                                                                            (currentCharacter isLetterOrDigit 
                                                                                or:[currentCharacter == $. or:[currentCharacter == $_]]) 
                                                                                    ifTrue:[^self scan12].
                                                                            (currentCharacter == $-) 
                                                                                ifTrue:
                                                                                    [self recordMatch:#( 131 132 ).
                                                                                    self step.
                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                            [currentCharacter == $_ or:
                                                                                                                    [(currentCharacter between:$a and:$r) 
                                                                                                                        or:[(currentCharacter between:$t and:$z)]]]]]) 
                                                                                        ifTrue:[^self scan12].
                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                    (currentCharacter == $s) 
                                                                                        ifTrue:
                                                                                            [self recordMatch:#( 131 132 ).
                                                                                            self step.
                                                                                            (currentCharacter isNationalDigit or:
                                                                                                    [(currentCharacter between:$- and:$.) or:
                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                    [currentCharacter == $_ or:
                                                                                                                            [(currentCharacter between:$a and:$h) 
                                                                                                                                or:[(currentCharacter between:$j and:$z)]]]]]) 
                                                                                                ifTrue:[^self scan12].
                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                            (currentCharacter == $i) 
                                                                                                ifTrue:
                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                    self step.
                                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                            [currentCharacter == $_ 
                                                                                                                                or:[currentCharacter == $a or:[(currentCharacter between:$c and:$z)]]]]]) 
                                                                                                        ifTrue:[^self scan12].
                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                    (currentCharacter == $b) 
                                                                                                        ifTrue:
                                                                                                            [self recordMatch:#( 131 132 ).
                                                                                                            self step.
                                                                                                            ((currentCharacter between:$- and:$.) or:
                                                                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                                    [currentCharacter == $_ or:
                                                                                                                                            [(currentCharacter between:$a and:$k) 
                                                                                                                                                or:[(currentCharacter between:$m and:$z)]]]]]) 
                                                                                                                ifTrue:[^self scan12].
                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                            (currentCharacter == $l) 
                                                                                                                ifTrue:
                                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                                    self step.
                                                                                                                    (currentCharacter isNationalDigit or:
                                                                                                                            [(currentCharacter between:$- and:$.) or:
                                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                                    [(currentCharacter between:$a and:$h) 
                                                                                                                                                        or:[(currentCharacter between:$j and:$z)]]]]]) 
                                                                                                                        ifTrue:[^self scan12].
                                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                    (currentCharacter == $i) 
                                                                                                                        ifTrue:
                                                                                                                            [self recordMatch:#( 131 132 ).
                                                                                                                            self step.
                                                                                                                            ((currentCharacter between:$- and:$.) or:
                                                                                                                                    [(currentCharacter between:$0 and:$9) or:
                                                                                                                                            [(currentCharacter between:$A and:$Z) or:
                                                                                                                                                    [currentCharacter == $_ or:
                                                                                                                                                            [(currentCharacter between:$a and:$m) 
                                                                                                                                                                or:[(currentCharacter between:$o and:$z)]]]]]) 
                                                                                                                                ifTrue:[^self scan12].
                                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                            (currentCharacter == $n) 
                                                                                                                                ifTrue:
                                                                                                                                    [self recordMatch:#( 131 132 ).
                                                                                                                                    self step.
                                                                                                                                    ((currentCharacter between:$- and:$.) or:
                                                                                                                                            [(currentCharacter between:$0 and:$9) or:
                                                                                                                                                    [(currentCharacter between:$A and:$Z) or:
                                                                                                                                                            [currentCharacter == $_ or:
                                                                                                                                                                    [(currentCharacter between:$a and:$f) 
                                                                                                                                                                        or:[(currentCharacter between:$h and:$z)]]]]]) 
                                                                                                                                        ifTrue:[^self scan12].
                                                                                                                                    (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                                    (currentCharacter == $g) 
                                                                                                                                        ifTrue:
                                                                                                                                            [self recordMatch:#( 111 131 132 ).
                                                                                                                                            self step.
                                                                                                                                            (currentCharacter isLetterOrDigit 
                                                                                                                                                or:[(currentCharacter between:$- and:$.) or:[currentCharacter == $_]]) 
                                                                                                                                                    ifTrue:[^self scan12].
                                                                                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                                                                                            ^self reportLastMatch].
                                                                                                                                    ^self reportLastMatch].
                                                                                                                            ^self reportLastMatch].
                                                                                                                    ^self reportLastMatch].
                                                                                                            ^self reportLastMatch].
                                                                                                    ^self reportLastMatch].
                                                                                            ^self reportLastMatch].
                                                                                    ^self reportLastMatch].
                                                                            (currentCharacter == $:) ifTrue:[^self scan2].
                                                                            ^self reportLastMatch].
                                                                    ^self reportLastMatch].
                                                            ^self reportLastMatch].
                                                    ^self reportLastMatch].
                                            ^self reportLastMatch].
                                    ^self reportLastMatch].
                            ^self reportLastMatch].
                    ^self reportLastMatch].
            ^self reportLastMatch].
    (currentCharacter == $p) ifTrue:[^self scan14].
    (currentCharacter == ${) ifTrue:[^self recordAndReportMatch:#( 118 ).].
    (currentCharacter == $|) ifTrue:[^self recordAndReportMatch:#( 5 ).].
    (currentCharacter == $}) ifTrue:[^self recordAndReportMatch:#( 117 ).].
    ^self reportLastMatch
! !

!XQueryScanner methodsFor:'generated-tokens'!

emptySymbolTokenId
	^290
!

errorTokenId
	^291
! !

!XQueryScanner methodsFor:'private - hacks'!

checkForKeyword: aString
    "Reserved keywords hack - if the string is keyword, return the keyword ID and token IDs
        as well - if the keyword raises error another tokens could be valid. This works only 
        with error recovery hack"
"/    | match |
"/    match := OrderedCollection withAll: matchActions.
"/    super checkForKeyword: aString.
"/    (match includesAll: matchActions) ifFalse:
"/    [
"/        matchActions do:
"/        [ :item |
"/            (match includes: item) ifFalse: [ match addFirst: item ]
"/        ].
"/        matchActions := match.
"/    ]
    super checkForKeyword: aString.

    "Created: / 27-10-2009 / 12:49:12 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-11-2009 / 16:24:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

recordMatch: aCollection 
    | reducedIds |
    aCollection isSymbol ifTrue:
    [
        super recordMatch: aCollection
    ] ifFalse: [
        reducedIds := self removeInvalidTokenIds: aCollection.
        reducedIds ifNotEmpty: [
            super recordMatch: reducedIds.
        ].
    ].

    "Created: / 13-07-2009 / 22:35:31 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 28-10-2009 / 14:24:02 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryScanner methodsFor:'xquery-invalid-token-recovery'!

addInvalidToken: token
    self invalidTokenIds addAll: token id.

    "Created: / 13-07-2009 / 22:38:31 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 28-10-2009 / 13:53:53 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isInvalidTokenCollection: aCollection
    ^ self invalidTokenIds includes: aCollection.

    "Created: / 13-07-2009 / 22:36:49 / Jan Kurs <kursj1@fel.cvut.cz>"
!

recoverFromError
    start := self lastValidState start.
    stream position: self lastValidState streamPosition.

    "Created: / 13-07-2009 / 22:34:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

removeInvalidTokenIds: aCollection
    " select only that ids which does not raises error. "
    ^ aCollection select:
    [ :item |
        (self invalidTokenIds includes: item) not.
    ].

    "Created: / 28-10-2009 / 13:57:39 / Jan Kurs <kursj1@fel.cvut.cz>"
!

saveCurrentState
    self lastValidState start: start copy.
    self lastValidState streamPosition: stream position.

    self invalidTokenIds removeAll.

    "Created: / 13-07-2009 / 22:31:22 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryScanner class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
