"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

DataType subclass:#XSBoolean
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-XS Data types'
!


!XSBoolean class methodsFor:'accessing'!

typename
    "Superclass says that I am responsible to implement this method"

    ^'boolean'

    "Created: / 12-05-2005 / 11:27:32 / masca"
! !

!XSBoolean methodsFor:'instance creation'!

createObjectFromString:aString 


    aString = 'true' ifTrue:[^true].
    aString = '1' ifTrue:[^true].
    aString = 'false' ifTrue:[^false].
    aString = '0' ifTrue:[^false].

    DataConversionError raiseErrorString:aString , ' is not valid value for xs:boolean'.

    "Created: / 12-05-2005 / 11:27:32 / masca"
!

createStringFromObject:aBoolean 
    "Superclass says that I am responsible to implement this method"

    ^aBoolean ifTrue:['true'] ifFalse:['false']

    "Created: / 12-05-2005 / 11:27:32 / masca"
! !

!XSBoolean class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__XSBoolean.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
