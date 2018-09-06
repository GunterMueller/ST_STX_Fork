"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TriggerCommand subclass:#DisConnectCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Trigger Creating'
!


!DisConnectCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^5

    "Created: / 10-04-2012 / 19:51:06 / Adam Senk <senkadam@gmail.com>"
! !

!DisConnectCommand methodsFor:'disconnecting'!

disconnect: node
   self halt.
   node documentAdaptor
       disconnectTriggerDef: node nodeId

    "Created: / 16-04-2012 / 20:10:01 / Adam Senk <senkadam@gmail.com>"
! !

!DisConnectCommand methodsFor:'executing'!

execute

    self targetSequence
        do:[:node|self disconnect: node]

    "Created: / 10-04-2012 / 19:36:23 / Adam Senk <senkadam@gmail.com>"
! !

!DisConnectCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
