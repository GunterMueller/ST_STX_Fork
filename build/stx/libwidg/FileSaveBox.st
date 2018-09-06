"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

FileSelectionBox subclass:#FileSaveBox
	instanceVariableNames:'appendButton appendAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!FileSaveBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    Instances of FileSaveBox add an 'append'-button, and an
    associated append-action. 
    The other behavior is that of a FileSelectionBox.

    [Instance variables:]
        appendAction            action to be performed when append is pressed


    [author:]
        Claus Gittinger

    [see also:]
        DialogBox
        EnterBox2 FilenameEnterBox YesNoBox
        ListSelectionBox FileSelectionBox 
"
! !

!FileSaveBox methodsFor:'accessing'!

appendAction:aBlock
    "set the action to be performed when append is pressed"

    appendAction := aBlock
! !

!FileSaveBox methodsFor:'initialization'!

initialize
    super initialize.

    label := resources string:'Save file dialog'.

    okButton label:(resources string:'save').

    "
     insert an append-button between abort- and save-buttons
    "
    appendButton := Button okButton.
    appendButton isReturnButton:false.
    appendButton label:(resources string:'Append').
    appendButton action:[appendButton turnOffWithoutRedraw. self appendPressed].
    self addButton:appendButton after:okButton.

    "Modified: / 29-08-2013 / 12:19:54 / cg"
! !

!FileSaveBox methodsFor:'user interaction'!

appendPressed
    "append was pressed - evaluate the append-action"

    self hideAndEvaluate:[:string |
        appendAction notNil ifTrue:[
            appendAction value:string 
        ]
    ]

    "Modified: 12.5.1996 / 21:45:52 / cg"
! !

!FileSaveBox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/FileSaveBox.st,v 1.17 2013-08-29 10:28:12 cg Exp $'
! !

