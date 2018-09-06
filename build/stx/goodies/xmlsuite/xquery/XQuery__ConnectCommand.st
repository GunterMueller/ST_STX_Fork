"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TriggerCommand subclass:#ConnectCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Trigger Creating'
!


!ConnectCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^5

    "Created: / 25-03-2012 / 15:18:19 / Adam Senk <senkadam@gmail.com>"
! !

!ConnectCommand methodsFor:'accessing'!

targetSequence
    ^ targetSequence
!

targetSequence:something
    targetSequence := something.
!

triggerDefSequence
    ^ sourceSequence

    "Modified: / 25-03-2012 / 13:31:24 / Adam Senk <senkadam@gmail.com>"
!

triggerDefSequence:something
    sourceSequence := something.

    "Modified: / 25-03-2012 / 13:32:02 / Adam Senk <senkadam@gmail.com>"
! !

!ConnectCommand methodsFor:'connecting'!

connect: triggerDefNode to: node

    node documentAdaptor
       connectTriggerDef: triggerDefNode nodeId to: node nodeId

    "Created: / 25-03-2012 / 13:35:49 / Adam Senk <senkadam@gmail.com>"
! !

!ConnectCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"

    self sourceSequence
        do:[:node|self connect: node  to: self targetSequence first]

    "Created: / 25-03-2012 / 13:33:53 / Adam Senk <senkadam@gmail.com>"
! !

!ConnectCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
