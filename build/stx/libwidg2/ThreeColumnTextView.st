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

    "Created: 20.11.1995 / 13:21:17 / cg"

"{ Package: 'stx:libwidg2' }"

SyncedMultiColumnTextView subclass:#ThreeColumnTextView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text'
!

!ThreeColumnTextView class methodsFor:'documentation'!

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

    "Created: 20.11.1995 / 13:21:17 / cg"
!

documentation
"
    a view showing two texts side-by-side.
    Scrolling is synced, by always scrolling both views.
    This type of view is especially useful to show diff-lists,
    code-versions, or other one-by-one viewable texts.

    Usually, it does not make much sense, to put totally different
    or unrelated texts into this kind of view.

    See subclass DiffTextView for a real class;
    see ChangesBrowsers compare operation for a real application
    of this kind of views.
"

    "Created: 20.11.1995 / 13:21:17 / cg"
!

examples
"
     ThreeColumnTextViews are currently not directly used by the system.
     However, it is used as an abstract superclass for Diff3TextView.
     See more examples there.
     (you may find nice uses for it anyway ...)

     ThreeColumnTextView
        openOn:('smalltalk.rc' asFilename contents)
        and:('display.rc' asFilename contents)
        and:('host.rc' asFilename contents)


     ThreeColumnTextView
        openOn:('smalltalk.rc' asFilename contents)
        label:'smalltalk.rc'
        and:('display.rc' asFilename contents)
        label:'display.rc'
        and:('host.rc' asFilename contents)
        label:'host.rc'
"

    "Created: 20.11.1995 / 13:21:42 / cg"
    "Modified: 20.11.1995 / 13:23:12 / cg"
! !

!ThreeColumnTextView class methodsFor:'instance creation'!

openOn:firstText and:secondText and:thirdText
    "open up a view showing firstText, secondText and thirdText side-by-side"

    |top v|

    top := StandardSystemView label:'three texts'.
    v := HVScrollableView 
               for:self 
               miniScrollerH:true miniScrollerV:false
               in:top.
    v origin:0.0 @ 0.0 corner:1.0 @ 1.0.
    v scrolledView text1:firstText text2:secondText text3:thirdText.
    ^ top open

    "
     ThreeColumnTextView
        openOn:('smalltalk.rc' asFilename contentsOfEntireFile)
        and:('display.rc' asFilename contentsOfEntireFile)
        and:('private.rc' asFilename contentsOfEntireFile)
    "

    "Modified: 12.12.1995 / 12:22:51 / cg"
!

openOn:firstText label:firstLabel and:secondText label:secondLabel and:thirdText label:thirdLabel
    "open up a view showing firstText, secondText and thirdText side-by-side,
     and labels for all views."

    |top v l1 l2 l3|

    top := StandardSystemView label:'three texts'.
    l1 := Label label:firstLabel in:top.
    l1 origin:0.0@0.0 corner:0.33@(l1 height).
    l2 := Label label:secondLabel in:top.
    l2 origin:0.33@0.0 corner:0.67@(l1 height).
    l3 := Label label:thirdLabel in:top.
    l3 origin:0.67@0.0 corner:1.0@(l1 height).

    v := HVScrollableView 
               for:self 
               miniScrollerH:true miniScrollerV:false
               in:top.
    v origin:0.0 @ (l1 height + ViewSpacing) corner:1.0 @ 1.0.
    v scrolledView text1:firstText text2:secondText text3:thirdText.
    ^ top open

    "
     ThreeColumnTextView
        openOn:('smalltalk.rc' asFilename contentsOfEntireFile)
        label:'smalltalk.rc'
        and:('display.rc' asFilename contentsOfEntireFile)
        label:'display.rc'
        and:('private.rc' asFilename contentsOfEntireFile)
        label:'private.rc'
    "

    "Modified: 12.12.1995 / 12:24:14 / cg"
! !

!ThreeColumnTextView class methodsFor:'specification'!

numberOfViews
    ^ 3

    "Created: 20.11.1995 / 13:17:00 / cg"
    "Modified: 12.12.1995 / 12:24:06 / cg"
! !

!ThreeColumnTextView methodsFor:'accessing'!

text1:t1 text2:t2 text3:t3
    (textViews at:1) list:t1 asText.
    (textViews at:2) list:t2 asText.
    (textViews at:3) list:t3 asText.

    "Created: 20.11.1995 / 13:20:39 / cg"
    "Modified: 12.12.1995 / 12:21:42 / cg"
! !

!ThreeColumnTextView class methodsFor:'documentation'!

version
^ '$Header: /cvs/stx/stx/libwidg2/ThreeColumnTextView.st,v 1.3 2006-07-05 07:42:12 fm Exp $'
! !
