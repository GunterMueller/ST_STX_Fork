"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#DataType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Data Type Library'
!


!DataType class methodsFor:'accessing'!

typename
    ^self subclassResponsibility

    "Created: / 28-04-2005 / 14:00:01 / janfrog"
! !

!DataType methodsFor:'accessing'!

typename
    ^self class typename

    "Created: / 28-04-2005 / 14:03:47 / janfrog"
! !

!DataType methodsFor:'initialization'!

initializeFromDOMElement:anElement

    "Nothing by default"

    "Created: / 28-04-2005 / 13:47:32 / janfrog"
! !

!DataType methodsFor:'instance creation'!

createObjectFromString:arg 
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 02-05-2005 / 10:38:06 / janfrog"
!

createStringFromObject:anObject 
    ^ self subclassResponsibility

    "Created: / 02-05-2005 / 10:38:21 / janfrog"
!

objectFromString:aString

    ^
    [
        "/ aString has expanded entites... somehow... must revise this
        self createObjectFromString: aString "/ (String fromXMLEscapedString:aString)
    ] on: Error do:[:ex|
        DataConversionError raiseErrorString:ex errorString.
        nil
    ]

    "Created: / 02-05-2005 / 10:40:09 / janfrog"
    "Modified: / 28-06-2005 / 13:52:46 / masca"
!

stringFromObject:anObject

    | res |
    [ 
        res := self createStringFromObject:anObject
    ] on:Error do:[:ex|
        ^DataConversionError raiseErrorString:'Cannot convert to string:',anObject printString
    ].
    ^res asXMLEscapedString

    "Created: / 02-05-2005 / 10:40:53 / janfrog"
    "Modified: / 16-05-2005 / 14:21:40 / masca"
! !

!DataType methodsFor:'printing'!

printOn:aStream

    aStream 
       nextPutAll:self class typename;
       nextPutAll:' (';
       nextPutAll:self class name;
        nextPut:$).

    "Created: / 29-04-2005 / 15:13:47 / janfrog"
! !

!DataType methodsFor:'queries'!

acceptsEmptyStringAsContent

    ^false

    "Created: / 14-06-2005 / 12:16:35 / masca"
! !

!DataType methodsFor:'testing'!

isKey
    "Answer whether this datatype represents an ID of the node within the
    document."

    ^false

    "Created: / 29-04-2005 / 12:18:30 / janfrog"
!

isKeyRef
    "Answer whether this datatype represents a reference to an ID of a node.
    The ID must exist in the document."

    ^false

    "Created: / 29-04-2005 / 12:19:03 / janfrog"
!

isText
    "Answer whether this datatype represents a general text.
     Such data type is used by <text/> pattern in Relax NG
    "

    ^false

    "Created: / 30-04-2005 / 17:39:55 / janfrog"
! !

!DataType class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__DataType.st,v 1.1.1.1 2005-11-01 22:07:13 vranyj1 Exp $'
! !
