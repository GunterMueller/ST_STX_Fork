"{ Package: 'stx:goodies/petitparser/devtools' }"

PPParserVisitor subclass:#PPPrinter
	instanceVariableNames:'stream root'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Utils'
!


!PPPrinter class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPPrinter class methodsFor:'printing'!

print: parser
    ^self new print: parser.

    "Created: / 11-01-2013 / 09:51:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPPrinter methodsFor:'accessing'!

stream
    ^ stream
!

stream:something
    stream := something.
! !

!PPPrinter methodsFor:'initialization'!

initialize
    stream := String new writeStream.
    root := nil.

    "Modified: / 11-01-2013 / 09:21:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPPrinter methodsFor:'printing'!

print: parser
    self visit: parser.
    ^stream contents

    "Created: / 11-01-2013 / 09:51:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPPrinter methodsFor:'visiting'!

visit:anObject 
    "visit anObject (visitor pattern).
     The object should call back one of my visitXXXX methods."

    anObject name notNil ifTrue:[
        stream nextPutAll: anObject name.
        root isNil ifTrue:[
            stream cr; cr; tab.
            stream nextPut: $^.
            root := anObject.
            anObject acceptVisitor:self.
        ].
        ^self
    ].
    stream nextPut:$(.
    anObject acceptVisitor:self.
    stream nextPut:$)

    "Created: / 11-01-2013 / 09:17:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPPChoiceParser:anObject 
    "dispatched back from the visited pPChoiceParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    root == anObject ifTrue:[stream space].

    anObject children 
        do: [:parser|self visit: parser. root == anObject ifTrue:[stream cr; tab] ifFalse:[stream space]]
        separatedBy:[stream nextPutAll: '/ '].

    "Created: / 11-01-2013 / 09:18:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPPEpsilonParser:anObject 
    stream nextPutAll: 'nil asParser'

    "Created: / 11-01-2013 / 09:34:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPPLiteralObjectParser:anObject 
    self visitPPLiteralParser: anObject

    "Created: / 11-01-2013 / 09:29:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPPLiteralParser:anObject 
    anObject literal storeOn: stream.
    stream nextPutAll: ' asParser'

    "Created: / 11-01-2013 / 09:29:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPPLiteralSequenceParser:anObject 
    self visitPPLiteralParser: anObject

    "Created: / 11-01-2013 / 09:29:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPPOptionalParser:anObject 
    self visit: anObject children anElement.
    stream nextPutAll: ' optional'.

    "Created: / 11-01-2013 / 09:27:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPPPredicateObjectParser:anObject 
    stream nextPutAll: '(self error: ''Cannot print predicate object parsers'')'

    "Created: / 11-01-2013 / 09:32:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPPRepeatingParser:anObject 
    self visit: anObject children anElement.
    (anObject min == 0 and:[anObject max = SmallInteger maxVal]) ifTrue:[
        stream nextPutAll:' star'.
        ^self.
    ].
    (anObject min == 1 and:[anObject max = SmallInteger maxVal]) ifTrue:[
        stream nextPutAll:' plus'.
        ^self.
    ].

    stream 
        nextPutAll:' min: ';
        nextPutAll: anObject min printString;
        nextPutAll:' max: ';
        nextPutAll: anObject max printString

    "Created: / 11-01-2013 / 09:27:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPPSequenceParser:anObject 
    "dispatched back from the visited pPSequenceParser-object (visitor pattern)"

    anObject children 
        do: [:parser|self visit: parser]
        separatedBy:[stream nextPutAll: ' , '].

    "Created: / 11-01-2013 / 09:18:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPPUnresolvedParser:anObject 
    stream nextPutAll: '(self error: ''Unresolved'')'

    "Created: / 11-01-2013 / 09:33:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPPrinter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/PPPrinter.st,v 1.1 2013-01-11 09:57:40 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/PPPrinter.st,v 1.1 2013-01-11 09:57:40 vrany Exp $'
! !
