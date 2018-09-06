"{ Package: 'stx:goodies/petitparser/devtools' }"

Object subclass:#XBGFParser
	instanceVariableNames:'productions'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Utils'
!

!XBGFParser class methodsFor:'documentation'!

documentation
"
    A parse to parse XBGF grammar definitions

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        http://slps.github.com/

"
! !

!XBGFParser methodsFor:'accessing'!

productionAt: id
    productions isNil ifTrue:[productions := Dictionary new].
    ^productions at: id ifAbsentPut:[PPUnresolvedParser named: id]

    "Created: / 10-01-2013 / 12:03:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productions
    ^ productions
! !

!XBGFParser methodsFor:'parsing'!

parse: aStringOrStreamOrFilename
    | doc |

    doc := XML::XMLParser 
                processDocumentStream:aStringOrStreamOrFilename readStream
                beforeScanDo:[:p|p validate: false]. 
    self processDocument: doc.
    ^self

    "Created: / 10-01-2013 / 12:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XBGFParser methodsFor:'processing'!

processDocument: doc
    ( doc root / 'ns0:production' ) do:[:node|
        self processProduction: node
    ]

    "Created: / 10-01-2013 / 12:01:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processExpression: node

    | expr parser |

    self assert: node children size == 1.
    expr := node children anElement.

    expr tag type = 'nonterminal' ifTrue:[
        ^self productionAt: expr characterData. 
    ].

    expr tag type = 'terminal' ifTrue:[
        ^PPLiteralSequenceParser on: expr characterData. 
    ].

    expr tag type = 'optional' ifTrue:[
        ^PPOptionalParser on: (self processExpression: (expr / 'ns0:expression') anElement)  
    ].

    expr tag type = 'any' ifTrue:[
        ^#any asParser  
    ].

    expr tag type = 'epsilon' ifTrue:[
        ^nil asParser  
    ].


    expr tag type = 'sequence' ifTrue:[
        parser := PPSequenceParser new
    ] ifFalse:[expr tag type = 'choice' ifTrue:[
        parser := PPChoiceParser new
    ] ifFalse:[expr tag type = 'star' ifTrue:[
        parser := PPRepeatingParser new setMin: 0 max: SmallInteger maxVal.
        parser setParser: (self processExpression: (expr / 'ns0:expression') anElement).
        ^parser
    ] ifFalse:[expr tag type = 'plus' ifTrue:[
        parser := PPRepeatingParser new setMin: 1 max: SmallInteger maxVal.
        parser setParser: (self processExpression: (expr / 'ns0:expression') anElement).
        ^parser
    ] ifFalse:[
        self error: 'Unknown expression: ', expr tag type
    ]]]].

    parser setParsers:
        ((expr / 'ns0:expression') collect:[:e|self processExpression: e]).
    ^parser

    "Created: / 10-01-2013 / 12:05:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processProduction: node

    | name prod |

    name := (node / 'nonterminal') characterData.
    prod := self productionAt: name.

    self assert: (node / 'ns0:expression') size == 1.

    prod def: (self processExpression: (node / 'ns0:expression') anElement)

    "Created: / 10-01-2013 / 12:01:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XBGFParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/XBGFParser.st,v 1.2 2013-01-10 13:22:58 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/XBGFParser.st,v 1.2 2013-01-10 13:22:58 vrany Exp $'
! !
