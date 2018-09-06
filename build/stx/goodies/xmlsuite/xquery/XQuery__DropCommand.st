"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TriggerCommand subclass:#DropCommand
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Trigger Creating'
!


!DropCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^5

    "Created: / 10-04-2012 / 19:51:01 / Adam Senk <senkadam@gmail.com>"
! !

!DropCommand methodsFor:'accessing'!

name
    ^ name
!

name:something
    name := something.
! !

!DropCommand methodsFor:'executing'!

execute
  "Place for future work"
  self halt.

    "Created: / 10-04-2012 / 19:46:28 / Adam Senk <senkadam@gmail.com>"
! !

!DropCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
