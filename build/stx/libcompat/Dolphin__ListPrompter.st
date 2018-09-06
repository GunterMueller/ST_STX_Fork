"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

DialogBox subclass:#ListPrompter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!ListPrompter class methodsFor:'dialogs'!

list:aListOfItems caption:aString
    ^ Dialog 
            choose:aString 
            fromList:aListOfItems 
            values:aListOfItems 
            lines:10
            cancel:nil
! !

!ListPrompter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__ListPrompter.st,v 1.2 2011-10-01 11:11:59 vrany Exp $'
!

version_SVN
    ^ '§Id: Dolphin__ListPrompter.st,v 1.1 2011/07/05 18:09:55 cg Exp §'
! !
