"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UpdateCommand subclass:#DeleteCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!DeleteCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^50
! !

!DeleteCommand methodsFor:'accessing'!

sourceSequence: anXquerySequence

    self shouldNotImplement
! !

!DeleteCommand methodsFor:'checks'!

checkSourceSequence:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldNotImplement
!

checkTargetSequence: anXquerySequence 

    "targetSequence can be anything"
! !

!DeleteCommand methodsFor:'deleting'!

deleteNode: node

    node documentAdaptor
            updDelete: node nodeId
! !

!DeleteCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"

    self targetSequence
        do:[:node|self deleteNode: node]
! !

!DeleteCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
