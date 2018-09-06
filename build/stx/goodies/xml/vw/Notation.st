"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Node subclass:#Notation
	instanceVariableNames:'name publicID systemID'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

Notation comment:'This class represents an XML Notation declaration. Notations are XML nodes which identify by name the format of unparsed entities, the format of elements which bear a notation attribute or the application to which a processing instruction is addressed.

Notations are delimited by the start-tag ''<!!!!!!!!NOTATION'' and end-tag ''>''

The name instance variable provides a name or identifier for the notation, for use in entity and attribute specifications. The publicID instance variable provides an external identifier which allows the XML processor or the client application to locate a helper application capable of processing data in the given notation. The systemID variable allows the parser to optionally resolve the publicID into the system identifier, file name, or other information needed to allow the application to call a processor for data in the notation.


Instance Variables:
	name    <XML.NodeTag>
	publicID        <String | XML.URIResolver>
	systemID        <String | XML.URIResolver>
'
!


!Notation methodsFor:'accessing'!

name
	"Needed for SAX. REW"
	^name
!

publicID
	"Needed for SAX. REW"
	^publicID
!

systemID
	"Needed for SAX. REW"
	^systemID
! !

!Notation methodsFor:'initialization'!

name: aName identifiers: anArray

	name := aName.
	anArray size = 1
		ifTrue: [systemID := anArray at: 1]
		ifFalse: [anArray size = 2
			ifTrue:
				[systemID := anArray at: 2.
				publicID := anArray at: 1]
			ifFalse: [self error: 'Invalid PUBLIC / SYSTEM identifiers']]
! !

!Notation methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitNotation:self
! !

!Notation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Notation.st,v 1.9 2005-05-11 09:28:32 cg Exp $'
! !
