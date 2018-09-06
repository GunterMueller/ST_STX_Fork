"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Pattern subclass:#PCDataPattern
	instanceVariableNames:'dataType'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Patterns'
!


!PCDataPattern methodsFor:'accessing'!

charactersFromObject:anObject

    | obj |    
    obj := self bindingInfo hasBinding 
        ifTrue:[anObject instVarNamed:self bindingInfo name]
        ifFalse:[anObject].

    ^self dataType stringFromObject:obj

    "Created: / 16-05-2005 / 13:41:15 / masca"
!

dataType
    ^ dataType

    "Created: / 30-04-2005 / 17:37:17 / janfrog"
!

dataType:aDataType
    dataType := aDataType.

    "Created: / 30-04-2005 / 17:37:22 / janfrog"
!

name
    ^'#pcdata'

    "Created: / 30-04-2005 / 17:21:05 / janfrog"
!

objectFromCharacters:aString 
    ^ self dataType objectFromString:aString

    "Created: / 16-05-2005 / 13:41:32 / masca"
! !

!PCDataPattern methodsFor:'printing'!

nameForPrint

    ^self dataType isText 
        ifTrue:['#pcdata']
        ifFalse:['#pcdata:',self dataType typename]

    "Created: / 30-04-2005 / 17:41:02 / janfrog"
!

printOn:aStream

    self node printOn:aStream.
    aStream nextPutAll:' < e >'

    "Created: / 30-04-2005 / 17:43:04 / janfrog"
    "Modified: / 30-04-2005 / 19:16:39 / janfrog"
! !

!PCDataPattern methodsFor:'queries'!

acceptsEmptyStringAsContent

    ^dataType acceptsEmptyStringAsContent

    "Created: / 14-06-2005 / 12:15:35 / masca"
! !

!PCDataPattern methodsFor:'testing'!

isPCDataPattern
    ^ true

    "Created: / 14-05-2005 / 20:34:31 / janfrog"
! !

!PCDataPattern methodsFor:'validation support'!

validate:aString for:validator
    [
        self dataType objectFromString:aString.
    ] on:DataConversionError do:[:ex|
        validator validationError:'Invalid pcdata content ("',aString,'"): ',ex errorString.
        ^ false 
    ].
    ^ true

    "Created: / 02-05-2005 / 10:43:23 / janfrog"
    "Modified: / 14-05-2005 / 22:01:13 / janfrog"
! !

!PCDataPattern class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__PCDataPattern.st,v 1.1.1.1 2005-11-01 22:07:13 vranyj1 Exp $'
! !
