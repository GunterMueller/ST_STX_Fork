"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#ParseTreeSourceRewriterTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!ParseTreeSourceRewriterTests methodsFor:'tests'!

test_01a
    | original expected rewritten rewriter |


    original := 'nextLineFrom: stream
        | line lineString nextChar |

        stream isBinary ifTrue:[
            line := stream upTo:(Character return codePoint).
            nextChar := stream peek.
            nextChar = (Character lf codePoint) 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ] ifFalse:[
            line := stream upTo:(Character cr).
            nextChar := stream peek.
            nextChar = (Character lf) 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ].
        self logWireLine: (lineString := line asString).
        ^lineString'.

    rewriter := ParseTreeSourceRewriter new.
    rewriter alwaysPerformAllSearches:true.
    rewriter
        replace:'(Character return codePoint) '
            "->"
           with: '(13)'.

    expected := 'nextLineFrom: stream
        | line lineString nextChar |

        stream isBinary ifTrue:[
            line := stream upTo:13.
            nextChar := stream peek.
            nextChar = (Character lf codePoint) 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ] ifFalse:[
            line := stream upTo:(Character cr).
            nextChar := stream peek.
            nextChar = (Character lf) 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ].
        self logWireLine: (lineString := line asString).
        ^lineString'.

    (rewriter executeTree: (RBParser parseMethod: original)) ifTrue:[
        rewritten := rewriter executeReplacementsInSource:original copy.
        self assert: rewritten = expected.
    ] ifFalse:[ 
        self assert: false description: 'No replacement has been done'
    ].

    "Created: / 19-02-2015 / 15:11:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-02-2015 / 12:49:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01b
    | original expected rewritten rewriter |


    original := 'nextLineFrom: stream
        | line lineString nextChar |

        stream isBinary ifTrue:[
            line := stream upTo:(Character return codePoint).
            nextChar := stream peek.
            nextChar = (Character lf codePoint) 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ] ifFalse:[
            line := stream upTo:(Character return).
            nextChar := stream peek.
            nextChar = (Character lf) 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ].
        self logWireLine: (lineString := line asString).
        ^lineString'.

    rewriter := ParseTreeSourceRewriter new.
"/    rewriter alwaysPerformAllSearches:true.
    rewriter
        replace:'(Character return codePoint) '
            "->"
           with: '(13)';

        replace:'(Character lf codePoint) '
            "->"
           with: '(10)';

        replace:'(Character return) '
            "->"
           with: '(Character value:13)';

        replace:'(Character lf) '
            "->"
           with: '(Character value:10)'.

    expected := 'nextLineFrom: stream
        | line lineString nextChar |

        stream isBinary ifTrue:[
            line := stream upTo:13.
            nextChar := stream peek.
            nextChar = 10 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ] ifFalse:[
            line := stream upTo:(Character value:13).
            nextChar := stream peek.
            nextChar = (Character value:10) 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ].
        self logWireLine: (lineString := line asString).
        ^lineString'.

    (rewriter executeTree: (RBParser parseMethod: original)) ifTrue:[
        rewritten := rewriter executeReplacementsInSource:original copy.
        self assert: rewritten = expected.
        "
        Tools::TextDiff2Tool openOn:rewritten label:'Rewritten Source' and: expected label: 'Expected Source'
        "
    ] ifFalse:[ 
        self assert: false description: 'No replacement has been done'
    ].

    "Created: / 20-02-2015 / 07:10:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-02-2015 / 12:49:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01c
    | original expected rewritten rewriter |


    original := 'nextLineFrom: stream
        | line lineString nextChar |

        stream isBinary ifTrue:[
            line := stream upTo:(Character return codePoint).
            nextChar := stream peek.
            nextChar = (Character return codePoint) 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ] ifFalse:[
            line := stream upTo:(Character return).
            nextChar := stream peek.
            nextChar = (Character return) 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ].
        self logWireLine: (lineString := line asString).
        ^lineString'.

    rewriter := ParseTreeSourceRewriter new.
"/    rewriter alwaysPerformAllSearches:true.
    rewriter
        replace:'(Character return codePoint) '
            "->"
           with: '(13)';

        replace:'(Character lf codePoint) '
            "->"
           with: '(10)';

        replace:'(Character return) '
            "->"
           with: '(Character value:13)';

        replace:'(Character lf) '
            "->"
           with: '(Character value:10)'.

    expected := 'nextLineFrom: stream
        | line lineString nextChar |

        stream isBinary ifTrue:[
            line := stream upTo:13.
            nextChar := stream peek.
            nextChar = 13 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ] ifFalse:[
            line := stream upTo:(Character value:13).
            nextChar := stream peek.
            nextChar = (Character value:13) 
                ifTrue:[ stream next ]
                ifFalse:[ self breakPoint:#cg ].
        ].
        self logWireLine: (lineString := line asString).
        ^lineString'.

    (rewriter executeTree: (RBParser parseMethod: original)) ifTrue:[
        rewritten := rewriter executeReplacementsInSource:original copy.
        self assert: rewritten = expected.
        "
        Tools::TextDiff2Tool openOn:rewritten label:'Rewritten Source' and: expected label: 'Expected Source'
        "
    ] ifFalse:[ 
        self assert: false description: 'No replacement has been done'
    ].

    "Created: / 20-02-2015 / 12:39:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02a
    | original expected rewritten rewriter |

    original := 'sel
    self foo.
    self bla.
'.

    rewriter := ParseTreeSourceRewriter new.
    rewriter alwaysPerformAllSearches: false.
    rewriter
        replace:'`expr foo'
            "->"
           with: '`expr bar';

        replace:'`expr bla'
            "->"
           with: '`expr blabla'.

    expected := 'sel
    self bar.
    self blabla.
'.


    (rewriter executeTree: (RBParser parseMethod: original)) ifTrue:[
        rewritten := rewriter executeReplacementsInSource:original copy.
        self assert: rewritten = expected.
        "
        Tools::TextDiff2Tool openOn:rewritten label:'Rewritten Source' and: expected label: 'Expected Source'
        "
    ] ifFalse:[ 
        self assert: false description: 'No replacement has been done'
    ].

    "Created: / 20-02-2015 / 12:50:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeSourceRewriterTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/ParseTreeSourceRewriterTests.st,v 1.3 2015-02-20 14:47:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/ParseTreeSourceRewriterTests.st,v 1.3 2015-02-20 14:47:00 vrany Exp $'
! !

