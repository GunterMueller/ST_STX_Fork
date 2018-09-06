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

SimpleView subclass:#SyncedMultiColumnTextView
	instanceVariableNames:'textViewClass textViews scrollLock'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text'
!

!SyncedMultiColumnTextView class methodsFor:'documentation'!

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
    abstract superclass for multi-col textviews.
    Scrolling is synced, by always scrolling all views.
    This type of view is especially useful to show diff-lists,
    code-versions, or other one-by-one viewable texts.

    Usually, it does not make much sense, to put totally different
    or unrelated texts into this kind of view.

    See concrete examples in subclasses: TwoColumnTextView, DiffTextView etc.

    [see also:]
        TwoColumnTextView DiffTextView

    [author:]
        Claus Gittinger
"
! !

!SyncedMultiColumnTextView class methodsFor:'defaults'!

numberOfViews
    "return the number of the synced subViews.
     Usually redefined in subclasses"

    ^ 2
!

textViewClass
    "return the type of the synced subViews.
     Can be redefined in subclasses"

    ^ TextView
! !

!SyncedMultiColumnTextView methodsFor:'accessing'!

textViewClass
    textViewClass isNil ifTrue:[ ^ self class textViewClass ].
    ^ textViewClass

    "Created: / 06-10-2006 / 14:28:53 / cg"
!

textViewClass:aClass
    textViewClass := aClass

    "Created: / 06-10-2006 / 14:29:04 / cg"
!

textViews                    
    ^ textViews

    "Created: / 08-05-2012 / 14:04:00 / cg"
! !

!SyncedMultiColumnTextView methodsFor:'change & update'!

update:something with:someArgument from:changedObject
    "/
    "/ if any of my views changes its contents,
    "/ I have logically changed my contents -> to give scrollbar
    "/ a chance to update
    "/
    something == #sizeOfContents ifTrue:[
        self changed:something
    ].

    "/
    "/ if any of my views' changes the origin its contents,
    "/ I have logically changed my origin -> give the scrollbar
    "/ a chance to update and sync my views.
    "/
    something == #originOfContents ifTrue:[
        "/ beware of recursive calls
        scrollLock ifFalse:[
            scrollLock := true.
            textViews do:[:v|
                v ~~ changedObject ifTrue:[
                    v scrollTo:changedObject viewOrigin.
                ].
            ].
            self changed:something.
            scrollLock := false.
        ].
        ^ self.
    ].
    super update:something with:someArgument from:changedObject

    "Created: / 24-11-1995 / 11:11:22 / cg"
    "Modified: / 25-09-1997 / 11:46:32 / stefan"
    "Modified: / 06-06-2012 / 11:04:21 / cg"
! !

!SyncedMultiColumnTextView methodsFor:'initialization'!

initialize
    |n wEach org crn cls|

    scrollLock := false.

    super initialize.

    cls := self textViewClass.
    n := self class numberOfViews.

    textViews := Array new:n.
    wEach := (1 / n) asFloat.
    org := 0.0.
    1 to:n do:[:i |
        |textView|

        i == n ifTrue:[
            crn := 1.0
        ] ifFalse:[
            crn := org + wEach
        ].
        textView:= cls 
                        origin:org @ 0.0
                        corner:crn @ 1.0
                            in:self.

        textView borderWidth:1.
        textView level:0.
        textView addDependent:self.
        textViews at:i put:textView.
        org := org + wEach
    ].

    "Created: / 20-11-1995 / 13:06:16 / cg"
    "Modified: / 06-06-2012 / 11:04:03 / cg"
! !

!SyncedMultiColumnTextView methodsFor:'queries'!

heightOfContents
    ^ textViews inject:0 into:[:maxSoFar :thisView | maxSoFar max:(thisView heightOfContents)]

    "Created: 20.11.1995 / 13:08:25 / cg"
!

innerHeight 
    ^ textViews inject:0 into:[:maxSoFar :thisView | maxSoFar max:(thisView innerHeight)]

    "Created: 20.11.1995 / 13:08:42 / cg"
!

innerWidth 
    ^ textViews inject:0 into:[:maxSoFar :thisView | maxSoFar max:(thisView innerWidth)]

    "Created: 20.11.1995 / 13:08:49 / cg"
!

widthOfContents 
    ^ textViews inject:0 into:[:maxSoFar :thisView | maxSoFar max:(thisView widthOfContents)]

    "Created: 20.11.1995 / 13:08:59 / cg"
!

xOriginOfContents
    ^ textViews inject:0 into:[:maxSoFar :thisView | maxSoFar max:(thisView xOriginOfContents)]

    "Created: 20.11.1995 / 13:09:11 / cg"
!

yOriginOfContents
    ^ textViews inject:0 into:[:maxSoFar :thisView | maxSoFar max:(thisView yOriginOfContents)]

    "Created: 20.11.1995 / 13:09:18 / cg"
! !

!SyncedMultiColumnTextView methodsFor:'scrolling'!

scrollDown:nLines
    textViews first scrollDown:nLines.

    "Created: 20.11.1995 / 13:09:40 / cg"
    "Modified: 25.9.1997 / 11:39:59 / stefan"
!

scrollHorizontalToPercent:p
    "since the percentage given is based on the widest text
     of my subvies, scroll the view containing the widest first,
     and take that scroll-offset for the others."

    |master max|

    max := 0.
    textViews do:[:thisView |
        |wThis|

        (wThis := thisView widthOfContents) > max ifTrue:[
            max := wThis.
            master := thisView
        ]
    ].
    master notNil ifTrue:[
        master scrollHorizontalToPercent:p.
    ].

    "Created: 20.11.1995 / 13:14:41 / cg"
    "Modified: 24.11.1995 / 14:22:27 / cg"
    "Modified: 25.9.1997 / 11:42:46 / stefan"
!

scrollLeft
    textViews first scrollLeft.

    "Created: 20.11.1995 / 13:09:40 / cg"
    "Modified: 20.11.1995 / 13:15:45 / cg"
    "Modified: 25.9.1997 / 11:41:04 / stefan"
!

scrollLeft:nPixels
    textViews first scrollLeft:nPixels.

    "Created: 20.11.1995 / 13:09:40 / cg"
    "Modified: 20.11.1995 / 13:15:49 / cg"
    "Modified: 25.9.1997 / 11:41:17 / stefan"
!

scrollRight
    textViews first scrollRight.

    "Created: 20.11.1995 / 13:09:40 / cg"
    "Modified: 20.11.1995 / 13:15:39 / cg"
    "Modified: 25.9.1997 / 11:41:30 / stefan"
!

scrollRight:nPixels
    textViews first scrollRight:nPixels.

    "Created: 20.11.1995 / 13:09:40 / cg"
    "Modified: 20.11.1995 / 13:15:27 / cg"
    "Modified: 25.9.1997 / 11:41:43 / stefan"
!

scrollToLine:lineNr
    textViews first scrollToLine:lineNr.

    "Created: 20.11.1995 / 13:09:40 / cg"
    "Modified: 20.11.1995 / 13:15:07 / cg"
    "Modified: 25.9.1997 / 11:41:56 / stefan"
!

scrollUp:nLines
    textViews first scrollUp:nLines.

    "Created: 20.11.1995 / 13:09:40 / cg"
    "Modified: 20.11.1995 / 13:14:51 / cg"
    "Modified: 25.9.1997 / 11:42:10 / stefan"
!

scrollVerticalToPercent:p
    "since the percentage given is based on the longest text
     of my subvies, scroll the view containing the longest first,
     and take that scroll-offset for the others."

    |master max|

    max := 0.
    textViews do:[:thisView |
        |hThis|

        (hThis := thisView heightOfContents) > max ifTrue:[
            max := hThis.
            master := thisView
        ]
    ].

    master notNil ifTrue:[
        master scrollVerticalToPercent:p.
    ]

    "Created: 20.11.1995 / 13:14:41 / cg"
    "Modified: 24.11.1995 / 14:22:19 / cg"
    "Modified: 25.9.1997 / 11:42:34 / stefan"
!

verticalScrollStep    
    "return the amount to scroll when stepping up/down (also used for mouseWheel)."

    ^ 1.

    "Created: / 21.5.1999 / 19:18:09 / cg"
! !

!SyncedMultiColumnTextView class methodsFor:'documentation'!

version
^ '$Header: /cvs/stx/stx/libwidg2/SyncedMultiColumnTextView.st,v 1.13 2012-06-08 07:38:47 cg Exp $'
! !
