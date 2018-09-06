"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

EnterBox subclass:#EnterBoxWithList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!EnterBoxWithList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

!

examples 
"
                                                                        [exBegin]
        |box|

        box := EnterBoxWithList new.
        box list:#('Jim' 'John' 'Paul').
        box title:'your name please:'.
        box action:[:arg | Transcript showCR:'entered: ''' , arg printString , ''''].
        box open
                                                                        [exEnd]
"

    "Modified: 16.11.1995 / 21:28:11 / cg"


! !

!EnterBoxWithList methodsFor:'accessing-contents'!

list:aList
    enterField list:aList.
! !

!EnterBoxWithList methodsFor:'initialization'!

createEnterField
    "here, a ComboBox is created."

    |widget|

    widget := ComboBoxView new.
    widget leaveAction:[:key | self okPressed].
    ^ widget
! !

!EnterBoxWithList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/EnterBoxWithList.st,v 1.5 2007-01-26 14:00:55 cg Exp $'
! !
