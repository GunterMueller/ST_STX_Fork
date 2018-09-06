"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UpdateCommand subclass:#CreateCommand
	instanceVariableNames:'name body event type time'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Trigger Creating'
!


!CreateCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^5

    "Created: / 10-04-2012 / 20:05:16 / Adam Senk <senkadam@gmail.com>"
! !

!CreateCommand methodsFor:'accessing'!

body
    ^ body
!

body:something
    body := something.
!

event
    ^ event
!

event:something
    event := something.
!

name
    ^ name
!

name:something
    name := something.
!

time
    ^ time
!

time:something
    time := something.
!

type
    ^ type
!

type:something
    type := something.
! !

!CreateCommand methodsFor:'executing'!

execute
  "place for future work"
  self halt.

    "Created: / 10-04-2012 / 20:05:48 / Adam Senk <senkadam@gmail.com>"
! !

!CreateCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
