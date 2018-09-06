"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

ButtonController subclass:#PopUpListController
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!PopUpListController class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    redefined the behavior on various keys if my view has the focus.

    [author:]
        Claus Gittinger
"
! !

!PopUpListController methodsFor:'event handling'!

buttonPress:button x:x y:y
    "redefined to not send any change message to the model when
     pressed (this is done by the popped menu)"

    (button == 1) ifFalse:[
        ^ super buttonPress:button x:x y:y
    ].

    enableChannel value ifTrue:[
        pressed ifFalse:[
            pressed := true.
            view showActive.

            (pressActionBlock notNil or:[model notNil]) ifTrue:[
                "
                 force output - so that button is drawn correctly in case
                 of any long-computation (at high priority)
                "
                view flush.
            ].

            pressActionBlock value.

        ]
    ]

    "Created: 27.1.1997 / 17:22:16 / cg"
    "Modified: 27.1.1997 / 17:23:17 / cg"
!

keyPress:key x:x y:y
    "pull menu on Return and space, if I am the focusView of my group
     (i.e. if I got an explicit focus)"

    <resource: #keyboard (#Return #CursorUp #CursorDown #Space)>

    |menu|

    view hasFocus ifTrue:[
"/        (key == #Return) ifTrue:[
"/            view menu shown ifTrue:[
"/                self halt:'not yet implemented'.
"/                ^ self.
"/            ].
"/        ].
        menu := view menu.
        (menu notNil and:[menu isView]) ifTrue:[
            (key == #CursorUp or:[key == #CursorDown]) ifTrue:[
                menu shown ifTrue:[
                    key == #CursorUp ifTrue:[menu selectNext]
                                     ifFalse:[menu selectPrevious].
                    ^ self.
                ].
            ].
            (key == Character space) ifTrue:[
                menu exclusivePointer:false.
                menu hideOnRelease:true.
                view popMenu.
                view menu exclusivePointer:true.
                ^ self.
            ]
        ]
    ].
    view keyPress:key x:x y:y

    "Created: 9.12.1995 / 23:06:09 / cg"
    "Modified: 7.3.1996 / 13:17:46 / cg"
! !

!PopUpListController class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/PopUpListController.st,v 1.16 2013-01-18 09:50:30 cg Exp $'
! !

