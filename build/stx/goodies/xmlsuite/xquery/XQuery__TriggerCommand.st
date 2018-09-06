"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UpdateCommand subclass:#TriggerCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Trigger Creating'
!


!TriggerCommand methodsFor:'executing'!

execute

    ^self subclassResponsibility

    "Created: / 25-03-2012 / 12:13:06 / Adam Senk <senkadam@gmail.com>"
! !

!TriggerCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
