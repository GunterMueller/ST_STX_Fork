"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#SingletonObject
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Support'
!

SingletonObject class instanceVariableNames:'soleInstance'

"
 No other class instance variables are inherited by this class.
"
!


!SingletonObject class methodsFor:'instance creation'!

default

    soleInstance ifNil:[
        soleInstance := self basicNew initialize
    ].
    ^soleInstance

    "Created: / 30-04-2005 / 13:43:19 / janfrog"
!

new
    self shouldNotImplement.
        "Use #default instead"

    "Created: / 30-04-2005 / 13:44:11 / janfrog"
! !

!SingletonObject class methodsFor:'utilities'!

flushDefault

    soleInstance := nil.

    "
        RNG::SingletonObject flushDefault
    "

    "Created: / 30-04-2005 / 13:45:00 / janfrog"
! !

!SingletonObject class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__SingletonObject.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
