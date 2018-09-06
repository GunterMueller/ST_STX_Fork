"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

ApplicationModel subclass:#Shell
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!Shell class methodsFor:'startup'!

show
    |app|

    app := self new.
    app open.
    ^ app
! !

!Shell methodsFor:'Compatibility-Dolphin'!

caption:aString
    "change my windows label"

    self window label:aString
!

exit
    self closeRequest
! !

!Shell class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__Shell.st,v 1.3 2011-08-18 08:00:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__Shell.st,v 1.3 2011-08-18 08:00:13 cg Exp $'
!

version_SVN
    ^ '§Id: Dolphin__Shell.st,v 1.1 2011/07/05 18:09:55 cg Exp §'
! !
