"
 COPYRIGHT (c) 1999 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"



TreeItem subclass:#TreeItemWithImage
	instanceVariableNames:'icon'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support'
!

!TreeItemWithImage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    Like a regular TreeItem, but provides its own icon image.


    [author:]
        Claus Gittinger (cg@exept)

    [see also:]
        TreeItem FileSelectionItem
        SelectionInTree SelectionInTreeView

    [instance variables:]
        image           <ImageOrForm>           my icon image

    [class variables:]
"
! !

!TreeItemWithImage methodsFor:'accessing'!

icon
    "return the value of the instance variable 'icon' (automatically generated)"

    icon isNil ifTrue:[^ super icon].
    ^ icon
!

icon:something
    "set the value of the instance variable 'icon' (automatically generated)"

    icon := something.! !

!TreeItemWithImage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/TreeItemWithImage.st,v 1.4 2000-02-18 14:39:34 cg Exp $'
! !
