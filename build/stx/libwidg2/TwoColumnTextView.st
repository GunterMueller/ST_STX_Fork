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
"{ Package: 'stx:libwidg2' }"

SyncedMultiColumnTextView subclass:#TwoColumnTextView
	instanceVariableNames:'nextPrevButtonPanel'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text'
!

!TwoColumnTextView class methodsFor:'documentation'!

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

    [see also:]
        DiffTextView
        TextView EditTextView

    [author:]
        Claus Gittinger
"

    "Created: 20.11.1995 / 13:21:17 / cg"
!

examples
"
     TwoColumnTextView are currently not directly used by the system.
     However, it is used as an abstract superclass for DiffTextView.
     See more examples there.
     (you may find nice uses for it anyway ...)

                                                                        [exBegin]
     TwoColumnTextView
        openOn:('smalltalk.rc' asFilename contents)
        and:('display.rc' asFilename contents)
                                                                        [exEnd]


                                                                        [exBegin]
     TwoColumnTextView
        openOn:('display.rc' asFilename contents)
        and:('smalltalk.rc' asFilename contents)
                                                                        [exEnd]


                                                                        [exBegin]
     TwoColumnTextView
        openOn:('smalltalk.rc' asFilename contents)
        label:'smalltalk.rc'
        and:('display.rc' asFilename contents)
        label:'display.rc'
                                                                        [exEnd]
"

    "Created: 20.11.1995 / 13:21:42 / cg"
    "Modified: 20.11.1995 / 13:23:12 / cg"
! !

!TwoColumnTextView class methodsFor:'instance creation'!

openOn:firstText and:secondText
    "open up a view showing firstText and secondText side-by-side.
     This does not make much sense for unrelated texts - of course."

    ^ self openOn:firstText and:secondText title:'Two Texts'

    "
     TwoColumnTextView
        openOn:('smalltalk.rc' asFilename contentsOfEntireFile)
        and:('display.rc' asFilename contentsOfEntireFile)


     TwoColumnTextView
        openOn:('display.rc' asFilename contentsOfEntireFile)
        and:('smalltalk.rc' asFilename contentsOfEntireFile)
    "

    "Modified: 25.4.1996 / 13:31:03 / cg"
!

openOn:firstText and:secondText in:aView 
    "open up a view showing firstText and secondText side-by-side.
     This does not make much sense for unrelated texts - of course."
    
    self 
        openOn:firstText
        label:nil
        and:secondText
        label:nil
        in:aView.
!

openOn:firstText and:secondText title:titleOrNil
    "open up a view showing firstText and secondText side-by-side.
     This does not make much sense for unrelated texts - of course."

    |top|

    top := StandardSystemView new.
    titleOrNil notNil ifTrue:[ top label:titleOrNil ].
    self openOn:firstText and:secondText in:top.
    ^ top open

    "
     TwoColumnTextView
        openOn:('smalltalk.rc' asFilename contentsOfEntireFile)
        and:('display.rc' asFilename contentsOfEntireFile)


     TwoColumnTextView
        openOn:('display.rc' asFilename contentsOfEntireFile)
        and:('smalltalk.rc' asFilename contentsOfEntireFile)
    "

    "Modified: 25.4.1996 / 13:31:03 / cg"
!

openOn:firstText label:firstLabel and:secondText label:secondLabel 
    "open up a view showing firstText and secondText side-by-side,
     and labels for both views.
     This does not make much sense for unrelated texts - of course."
    
    ^ self 
        openOn:firstText 
        label:firstLabel 
        and:secondText 
        label:secondLabel 
        title:'Two Texts'

    "
     TwoColumnTextView
        openOn:('smalltalk.rc' asFilename contentsOfEntireFile)
        label:'smalltalk.rc'
        and:('display.rc' asFilename contentsOfEntireFile)
        label:'display.rc'
    "
    "Modified: 15.8.1996 / 19:46:38 / cg"
!

openOn:firstText label:firstLabel and:secondText label:secondLabel title:titleOrNil
    "open up a view showing firstText and secondText side-by-side,
     and labels for both views.
     This does not make much sense for unrelated texts - of course."
    
    |top v|

    top := StandardSystemView new.
    titleOrNil notNil ifTrue:[ top label:titleOrNil ].
    v := self 
            openOn:firstText
            label:firstLabel
            and:secondText
            label:secondLabel
            in:top.
    top open.
    ^ v

    "
     TwoColumnTextView
        openOn:('smalltalk.rc' asFilename contentsOfEntireFile)
        label:'smalltalk.rc'
        and:('display.rc' asFilename contentsOfEntireFile)
        label:'display.rc'
    "
    "Modified: 15.8.1996 / 19:46:38 / cg"
! !

!TwoColumnTextView class methodsFor:'instance creation-basic'!

openOn:firstText label:firstLabel and:secondText label:secondLabel in:aView
    "open up a view showing firstText and secondText side-by-side,
     and labels for both views. Return the (wrapped) diff-view.
     This does not make much sense for unrelated texts - of course."

    |hvs scr l1 l2|

    hvs := HVScrollableView 
               for:self 
               miniScrollerH:true miniScrollerV:false
               in:aView.

    scr := hvs scrolledView.

    (firstLabel notNil and:[secondLabel notNil]) ifTrue:[
        l1 := Label label:firstLabel in:aView.
        l1 origin:0.0@0.0 corner:0.5@(l1 height).
        l1 borderWidth:0.
        l2 := Label label:secondLabel in:aView.
        l2 origin:0.5@0.0 corner:1.0@(l1 height).
        l2 borderWidth:0.

        hvs origin:0.0 @ (l1 height + ViewSpacing) corner:1.0 @ 1.0.
    ] ifFalse:[
        hvs origin:0.0 @ 0.0  corner:1.0 @ 1.0
    ].
    scr text1:firstText text2:secondText.
    scr addNextPreviousButtons.
    scr moveToNextChanged.

    ^ scr.
! !

!TwoColumnTextView class methodsFor:'specification'!

numberOfViews
    ^ 2

    "Created: 20.11.1995 / 13:17:00 / cg"
! !

!TwoColumnTextView methodsFor:'accessing'!

leftTextView
    ^ textViews at:1
!

numberOfChanges
    |start numberOfChanges|

    textViews first contents size == textViews last contents size ifTrue: [^0].
    start := 1.
    numberOfChanges := 0.
    textViews do:[:v||list max lnNr|
        list := v list.
        max  := list size.
        lnNr := start.
        [(lnNr < max)] whileTrue: [
            (lnNr < max and: [ (list at: lnNr - 1 ifAbsent: [list at:1]) isText not and: [(list at:lnNr) isText]])
                ifTrue: [numberOfChanges := numberOfChanges + 1].
            lnNr := lnNr + 1
        ].
    ].

    ^numberOfChanges
!

rightTextView
    ^ textViews at:2
!

text1:t1 text2:t2
    (textViews at:1) list:t1 asText.
    (textViews at:2) list:t2 asText.

    "Created: 20.11.1995 / 13:20:39 / cg"
! !

!TwoColumnTextView methodsFor:'actions'!

moveToLine:aLineNr
    |lnNr view nLinesShown|

    view := textViews at:1.

    view shown ifTrue:[
        lnNr := (view lastLineShown - view firstLineShown) // 3.
    ] ifFalse:[
        lnNr := 5.
    ].

    (lnNr := aLineNr - lnNr) < 1 ifTrue:[
        lnNr := 1
    ].
    self scrollToLine:lnNr.
!

moveToNextChanged
    |start end|

    start := ((textViews at:1) lastLineShown) + 1.

    textViews do:[:v||list max lnNr|
        list := v list.
        max  := list size.
        lnNr := start.

        [(lnNr > max or:[(list at:lnNr) isText])
        ] whileFalse:[
            lnNr := lnNr + 1
        ].

        (lnNr <= max) ifTrue:[
            (end isNil or:[lnNr < end]) ifTrue:[
                end := lnNr.
            ]
        ].
    ].

    end notNil ifTrue:[
        self moveToLine:end
    ].
!

moveToPreviousChanged
    |start end found|

    start := ((textViews at:1) firstLineShown) - 1.
    end   := 1.
    found := false.

    start > 1 ifTrue:[
        textViews do:[:v||lnNr list|
            list := v list.
            lnNr := list size.

            lnNr >= start ifTrue:[
                lnNr := start
            ].

            [(lnNr == end or:[(list at:lnNr) isText])
            ] whileFalse:[
                lnNr := lnNr - 1
            ].
            (list at:lnNr) isText ifTrue:[
                end   := lnNr.
                found := true
            ]
        ]
    ].
    found ifTrue:[
        self moveToLine:end
    ].
! !

!TwoColumnTextView methodsFor:'initialization'!

addNextPreviousButtons
    "set up-down buttons"

    |panel buttonPrev buttonNext|

    panel := nextPrevButtonPanel := VerticalPanelView in:self.

    buttonPrev := Button label:'-' in:panel.
    buttonNext := Button label:'+' in:panel.
    buttonPrev extent:15@22.
    buttonNext extent:15@22.
    panel origin:0.0 @ 1.0 corner:(15 + SimpleView viewSpacing) @ 1.0.
    panel topInset:(2 * (buttonPrev preferredHeight)) negated.
    panel level:1.

    "set actions"

    buttonPrev pressAction:[
        buttonPrev turnOff.
        self moveToPreviousChanged
    ].

    buttonNext pressAction:[
        buttonNext turnOff.
        self moveToNextChanged
    ].

    panel beInvisible.
! !

!TwoColumnTextView class methodsFor:'documentation'!

version
^ '$Header: /cvs/stx/stx/libwidg2/TwoColumnTextView.st,v 1.25 2010-05-20 09:42:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg2/TwoColumnTextView.st,v 1.25 2010-05-20 09:42:26 cg Exp $'
! !
