"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

DialogBox subclass:#Prompter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!Prompter class methodsFor:'Compatibility - Dolphin'!

on:aString prompt:message caption:caption
    ^ Dialog 
        request:message 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:aString 
        okLabel:nil 
        cancelLabel:nil 
        title:caption 
        onCancel:nil
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil
!

prompt:message caption:caption
    ^ Dialog 
        request:message 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:'' 
        okLabel:nil 
        cancelLabel:nil 
        title:caption 
        onCancel:nil
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil
! !

!Prompter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__Prompter.st,v 1.2 2011-10-01 11:04:10 vrany Exp $'
!

version_SVN
    ^ '§Id: Dolphin__Prompter.st,v 1.1 2011/07/05 18:09:55 cg Exp §'
! !
