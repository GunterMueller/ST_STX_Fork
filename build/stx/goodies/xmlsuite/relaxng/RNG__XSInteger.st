"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

DataType subclass:#XSInteger
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-XS Data types'
!


!XSInteger class methodsFor:'accessing'!

typename
    "Superclass says that I am responsible to implement this method"

    ^'integer'

    "Created: / 28-04-2005 / 14:00:20 / janfrog"
! !

!XSInteger methodsFor:'instance creation'!

createObjectFromString:aString 

    ^(aString allSatisfy:[:c|c isDigit])
        ifTrue:[aString asInteger]
        ifFalse:[Error raiseErrorString:'not a integer']

    "Created: / 02-05-2005 / 10:38:06 / janfrog"
!

createStringFromObject:anObject 
    ^ anObject printString

    "Created: / 02-05-2005 / 10:38:21 / janfrog"
! !

!XSInteger class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__XSInteger.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
