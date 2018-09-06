"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UpdateCommand subclass:#InsertCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!InsertCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    self shouldNotImplement
! !

!InsertCommand methodsFor:'checks'!

checkSourceSequence:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldNotImplement
!

checkTargetSequence:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldNotImplement
! !

!InsertCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"

    self shouldImplement
! !

!InsertCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
