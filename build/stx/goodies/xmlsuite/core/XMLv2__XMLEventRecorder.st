"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XMLEventRecorder
	instanceVariableNames:'events charactersBuffer'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests-SAX2'
!


!XMLEventRecorder class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!XMLEventRecorder methodsFor:'SAX2 events'!

characters:aString 

    charactersBuffer nextPutAll: aString

    "Created: / 06-04-2009 / 10:31:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2009 / 14:04:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

endDocument
    self add: #(#endDocument).

    "Created: / 06-04-2009 / 10:43:26 / Jan Kurs <kursj1@fel.cvut.cz>"
!

endElement:localName namespace:namespace prefix:prefix 
    self add:(Array 
                with:#endElement:namespace:prefix:
                with:localName
                with:namespace
                with:prefix).

    "Created: / 06-04-2009 / 10:45:12 / Jan Kurs <kursj1@fel.cvut.cz>"
!

endPrefixMapping:prefix

    "ignored"

    "Created: / 06-04-2009 / 10:45:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

ignorableWhitespace:aString 

    self characters: aString

    "Created: / 06-04-2009 / 10:46:47 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2009 / 14:04:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

processingInstruction:target data:data 
    self add:(Array 
                with:#processingInstruction:
                with:target
                with:data).

    "Created: / 06-04-2009 / 10:48:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

setDocumentLocator:aDocumentLocator

    "ignored"

    "Created: / 06-04-2009 / 10:48:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

startDocument
    self add:#( #startDocument ).

    "Created: / 06-04-2009 / 10:49:08 / Jan Kurs <kursj1@fel.cvut.cz>"
!

startElement:localName namespace:namespace prefix:prefix attributes:attributes 
    self add:(Array 
                with:#startElement:namespace:prefix:attributes:
                with:localName
                with:namespace
                with:prefix
                with: (self createArrayFromAttributes: attributes)).

    "Created: / 06-04-2009 / 10:50:10 / Jan Kurs <kursj1@fel.cvut.cz>"
!

startPrefix:prefix mappingTo:uri 
    self add:(Array 
                with:#startPrefix:mappingTo:
                with:prefix
                with:uri).

    "Created: / 06-04-2009 / 10:53:51 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XMLEventRecorder methodsFor:'accessing'!

contentHandler

    ^self

    "Created: / 06-04-2009 / 10:30:18 / Jan Kurs <kursj1@fel.cvut.cz>"
!

events
    ^ events.

    "Modified: / 06-04-2009 / 11:46:05 / Jan Kurs <kursj1@fel.cvut.cz>"
!

events:something
    events := something.
!

eventsAsArray
    ^self events asArray.

    "Created: / 06-04-2009 / 11:46:35 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XMLEventRecorder methodsFor:'initialization'!

initialize
    self events:OrderedCollection new.
    charactersBuffer := self createCharacterBuffer
! !

!XMLEventRecorder methodsFor:'private'!

add: something
    self addPendingCharacters.
    self events add: something.

    "Created: / 06-04-2009 / 10:35:24 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2009 / 14:06:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

createArrayFromAttributes: attributes
    "returns attributes #(QName, URI, Value) in array in alphabetical 
        order according to the QName"
    | attrColl length |

    length := attributes getLength.
    attrColl := OrderedCollection new.

    attributes do: [:attr | attrColl add: (Array with:(attr qualifiedName) with: (attr ns) with: (attr value))].
    

    ^ (attrColl asSortedCollection: self getAttributeComparator) asArray.

    "Created: / 06-04-2009 / 11:38:51 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2009 / 12:49:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getAttributeComparator
    ^ [:a :b | a first < b first].

    "Created: / 06-04-2009 / 12:27:09 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XMLEventRecorder class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_SVN
    ^ '$Id$'
! !
