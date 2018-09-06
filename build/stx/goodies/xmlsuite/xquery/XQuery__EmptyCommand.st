"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UpdateCommand subclass:#EmptyCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!EmptyCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^0
! !

!EmptyCommand methodsFor:'accessing'!

sourceSequence: anXquerySequence

    self shouldNotImplement
!

targetSequence: anXquerySequence

    self shouldNotImplement
! !

!EmptyCommand methodsFor:'checking'!

isEmptyCommand
   ^true.

    "Created: / 25-03-2012 / 15:10:44 / Adam Senk <senkadam@gmail.com>"
! !

!EmptyCommand methodsFor:'checks'!

checkSourceSequence:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldNotImplement
!

checkTargetSequence:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldNotImplement
! !

!EmptyCommand methodsFor:'executing'!

execute

    "Nothing to do"
! !

!EmptyCommand methodsFor:'flattening'!

flattenOn: aStream
! !

!EmptyCommand methodsFor:'merging'!

mergeWith: anotherCommand

        ^anotherCommand
! !

!EmptyCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
