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
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

ListEntry subclass:#ColoredListEntry
	instanceVariableNames:'color string bgColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!ColoredListEntry class methodsFor:'documentation'!

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
    Instances of ColoredListEntry can be used in place of strings
    as entries of the list in a ListView or SelectionInListView.

    Notice: this is a historic leftOver from times when the Text class
	    was not available.
	    Please do no longer use it (use Text right away).

    [author:]
	Claus Gittinger

    [see also:]
	Text
	ListView
	ListEntry
	String Color
"
!

examples
"
     putting colored entries into a SelectionInListView
     (instead of strings)'
									[exBegin]
	|v e myList tabs|

	myList := OrderedCollection new.

	myList add:(ColoredListEntry string:'red' color:Color red).
	myList add:(ColoredListEntry string:'green' color:Color green).
	myList add:(ColoredListEntry string:'blue' color:Color blue).
	myList add:(ColoredListEntry string:'white' color:Color white).
	myList add:(ColoredListEntry string:'black' color:Color black).
	myList add:(ColoredListEntry string:'yellow' color:Color yellow).

	v := SelectionInListView new.
	v setList:myList expandTabs:false.
	v open
									[exEnd]


     in a popUpList (sorry, Labels do not (yet) know how to display
     non-strings.
									[exBegin]
	|v e myList selList tabs|

	myList := OrderedCollection new.

	myList add:(ColoredListEntry string:'red' color:Color red).
	myList add:(ColoredListEntry string:'green' color:Color green).
	myList add:(ColoredListEntry string:'blue' color:Color blue).
	myList add:(ColoredListEntry string:'white' color:Color white).
	myList add:(ColoredListEntry string:'black' color:Color black).
	myList add:(ColoredListEntry string:'yellow' color:Color yellow).

	selList := SelectionInList new list:myList.

	v := PopUpList on:selList.
	v open
									[exEnd]
"
! !

!ColoredListEntry class methodsFor:'instance creation'!

string:aString color:aColor
    self obsoleteMethodWarning:'use Text>>string:color:'.

    ^ Text string:aString color:aColor
"/    ^ self new string:aString color:aColor

    "Modified: 12.5.1996 / 17:06:12 / cg"
!

string:aString foregroundColor:fgColor backgroundColor:bgColor
    self obsoleteMethodWarning:'use Text>>emphasis:'.

    ^ Text
	string:aString
	emphasis:(Array with:(#color->fgColor)
			with:(#backgroundColor->bgColor))

"/    ^ self new string:aString foregroundColor:fgColor backgroundColor:bgColor

    "Modified: 12.5.1996 / 19:48:27 / cg"
! !

!ColoredListEntry methodsFor:'accessing'!

string:aString color:aColor
    string := aString.
    color := aColor
!

string:aString foregroundColor:fg backgroundColor:bg
    string := aString.
    color := fg.
    bgColor := bg.

    "Created: 16.11.1995 / 16:53:17 / cg"
! !

!ColoredListEntry methodsFor:'converting'!

asString
    ^ string
!

string
    ^ string
! !

!ColoredListEntry methodsFor:'drawing'!

displayOn:aGC x:x y:y opaque:opaque
    "display the receiver on a GC"

    |savedPaint savedBgPaint|

    savedPaint := aGC paint.
    bgColor notNil ifTrue:[
	savedBgPaint := aGC backgroundPaint.
	aGC paint:color on:bgColor.
	aGC displayOpaqueString:(string withTabsExpanded) x:x y:y.
	aGC paint:savedPaint on:savedBgPaint
    ] ifFalse:[
	aGC paint:color.
	opaque ifTrue:[
	    aGC displayOpaqueString:(string withTabsExpanded) x:x y:y.
	] ifFalse:[
	    aGC displayString:(string withTabsExpanded) x:x y:y.
	].
	aGC paint:savedPaint
    ]

    "Modified: 16.11.1995 / 16:54:40 / cg"
! !

!ColoredListEntry class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/ColoredListEntry.st,v 1.14 2006-11-13 16:11:29 cg Exp $'
! !

