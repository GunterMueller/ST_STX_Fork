"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

XMLv2::ContentHandler subclass:#Validator
	instanceVariableNames:'schema contextStack pendingTextStream'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Validation'
!


!Validator class methodsFor:'instance creation'!

for:aSchema

    ^self new schema:aSchema

    "Created: / 01-05-2005 / 15:54:46 / janfrog"
! !

!Validator methodsFor:'SAX2 interface'!

characters:aString

    pendingTextStream ifNil:[
        pendingTextStream := (aString species new:aString size) writeStream.
    ].
    pendingTextStream nextPutAll:aString.

    "Created: / 02-05-2005 / 11:30:50 / janfrog"
    "Modified: / 07-06-2005 / 15:35:32 / masca"
!

endElement:localName namespace:namespace prefix:prefix

    "first, process pending text"
    pendingTextStream ifNotNil:[
        self processCharacters:pendingTextStream contents.
    ].
    pendingTextStream := nil.


    contextStack top tryToFinish.

    contextStack top finished ifFalse:[
        self validationError:'Incomplete content of <',localName,'>; '
            ,'Expecting: ',(contextStack top automaton
                expectedTokensStringFromState:contextStack top currentPattern)
    ].

    "Transcript showCR:'End: ',localName, ' '
        , documentLocator getLineNumber printString
            ,' pop: ',contextStack top printString."

    contextStack pop.

    "Created: / 01-05-2005 / 16:15:56 / janfrog"
    "Modified: / 14-05-2005 / 11:31:18 / janfrog"
    "Modified: / 14-06-2005 / 12:19:44 / masca"
!

startDocument

    contextStack := Stack new.
    contextStack push:
        ((self newContextFor:schema rootPattern)
            attributes:#();
            yourself)

    "Created: / 01-05-2005 / 15:57:52 / janfrog"
    "Modified: / 01-05-2005 / 18:46:38 / janfrog"
!

startElement:localName namespace:namespace prefix:qName attributes:anAttributes

    | pattern newContext expandedName |

    "first, process pending text"
    pendingTextStream ifNotNil:[
        self processCharacters:pendingTextStream contents.
    ].
    pendingTextStream := nil.


    expandedName := (self ns:namespace name:localName).
    pattern := contextStack top nextPutElement:expandedName.

    newContext := self newContextFor:pattern.
    newContext attributes:anAttributes asArray asOrderedCollection.
    contextStack push:newContext

    "Created: / 01-05-2005 / 16:14:05 / janfrog"
    "Modified: / 02-05-2005 / 12:25:38 / janfrog"
    "Modified: / 07-06-2005 / 15:34:58 / masca"
! !

!Validator methodsFor:'accessing'!

newContextFor:aPattern

    ^aPattern newValidatorContext
        validator:self;
        yourself

    "Created: / 01-05-2005 / 15:58:39 / janfrog"
    "Modified: / 02-05-2005 / 12:23:19 / janfrog"
!

result

    ^true

    "Created: / 14-05-2005 / 11:05:15 / janfrog"
!

schema:aSchema

    schema := aSchema

    "Created: / 01-05-2005 / 15:55:09 / janfrog"
! !

!Validator methodsFor:'error reporting'!

validationError:aString

    ValidationError raiseErrorString:aString

    "Created: / 01-05-2005 / 16:20:22 / janfrog"
! !

!Validator methodsFor:'processing extras'!

processAttribute:attr usingPattern:pattern


    contextStack push:(self newContextFor:pattern).
    contextStack top nextPutText:attr value.
    contextStack pop.

    "Created: / 02-05-2005 / 12:38:43 / janfrog"
    "Modified: / 02-05-2005 / 15:00:47 / janfrog"
    "Modified: / 19-05-2005 / 10:48:04 / masca"
!

processCharacters:aString 
    contextStack top nextPutText:aString

    "Created: / 07-06-2005 / 15:28:51 / masca"
! !

!Validator methodsFor:'utilities'!

ns:ns name:name

    ^ns isEmpty ifTrue:[name] ifFalse:[ns , '#' , name]"
    ^ns , '#' , name   "

    "Created: / 01-05-2005 / 16:17:44 / janfrog"
    "Modified: / 14-05-2005 / 11:34:57 / janfrog"
! !

!Validator class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__Validator.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
