"{ Encoding: utf8 }"

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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

ThreeColumnTextView subclass:#Diff3TextView
	instanceVariableNames:'useColors showSeparators addedColor addedBgColor removedColor
		removedBgColor changedColor changedBgColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text'
!

!Diff3TextView class methodsFor:'documentation'!

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
    a view showing merged diff3 (see rcsmerge / merge unix manual pages) output in a
    user-friendly form.
    The view is created and opened with:

       d := Diff3TextView openOn:text label:l1 label:l2 label:l3.

    and it will show the 3 versions side-by-side
    Its main use is for the SourceCodeManager, to show merged sources after
    a failed checkin.

    Notice:
	This has diff3 output (or cvs diff output) hardwired into it.
	Needs to be adapted, if that format ever changes.

    [see also:]
	TextView EditTextView DiffTextView

    [author:]
	Claus Gittinger
"
! !

!Diff3TextView class methodsFor:'instance creation'!

openOnMergedText:text label:firstLabel label:secondLabel label:thirdLabel
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
    v scrolledView updateListsFromMergedText:text.

"/    self addNextPreviousButtons.
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

    "Modified: 12.12.1995 / 13:09:13 / cg"
! !

!Diff3TextView class methodsFor:'public helpers'!

emphasizeMergedDiff3Text:mergedText emphasize1:e1 emphasize2:e2 emphasizeSep:e3
    "given the merge()/rcsmerge() merged output (as created by 'cvs update'),
     create & return a text object which contains the conflicts
     highlighted.
     CAVEAT: this is a highly specialized method - probably not the right place
     for it here ..."

    |dIdx dEnd state entry list skip l1 l2 buffer
     sameAtStart sameAtEnd sepYourVersion sepOtherVersion sepLine|

    sepYourVersion  := '----- your version -----'.
    sepOtherVersion := '----- other version ----'.
    sepLine := '------------------------'.

    list := OrderedCollection new.

    dIdx := 1.
    dEnd := mergedText size + 1.
    state := #initial.
    [dIdx < dEnd] whileTrue:[
	dIdx == dEnd ifTrue:[
	    "dummy cleanup entry"
	    entry := nil.
	    state := #initial.
	] ifFalse:[
	    entry := mergedText at:dIdx.
	    dIdx := dIdx + 1.
	].

	skip := false.

	entry notNil ifTrue:[
	    (entry startsWith:'<<<<<<<') ifTrue:[
		state := 1. skip := true.
		l1 := OrderedCollection new.
		buffer := l1.
	    ] ifFalse:[
		(entry startsWith:'|||||||') ifTrue:[
		    state := 2. skip := true.
		    buffer := nil.
		] ifFalse:[
		    (entry startsWith:'=======') ifTrue:[
			state == 2 ifFalse:[
			    state := 23        "/ on both 2 and 3
			] ifTrue:[
			    state := 3         "/ only in 3
			].
			skip := true.
			l2 := OrderedCollection new.
			buffer := l2.
		    ] ifFalse:[
			(entry startsWith:'>>>>>>>') ifTrue:[
			    state := #initial.
			    skip := true.
			    buffer := nil.
			]
		    ]
		]
	    ].

	    state == #initial ifTrue:[
		l1 notNil ifTrue:[
		    "/ diff3-output is sometimes stupid; fix some here
		    sameAtStart := OrderedCollection new.
		    [l1 notEmpty and:[l2 notEmpty and:[l1 first = l2 first or:[l1 first withTabsExpanded = l2 first withTabsExpanded]]]] whileTrue:[
			sameAtStart addLast:l1 removeFirst.
			l2 removeFirst
		    ].
		    sameAtEnd := OrderedCollection new.
		    [l1 notEmpty and:[l2 notEmpty and:[l1 last = l2 last or:[l1 last withTabsExpanded = l2 last withTabsExpanded]]]] whileTrue:[
			sameAtEnd addFirst:l1 removeLast.
			l2 removeLast
		    ].
		    sameAtStart do:[:eachEntry | list add:eachEntry].

		    (l1 notEmpty or:[l2 notEmpty]) ifTrue:[
			list add:(e3 isNil ifTrue:[sepYourVersion] ifFalse:[Text string:sepYourVersion emphasis:e3]).
			l1 do:[:eachEntry | list add:(e1 isNil ifTrue:[eachEntry] ifFalse:[Text string:eachEntry emphasis:e1])].
			list add:(e3 isNil ifTrue:[sepOtherVersion] ifFalse:[Text string:sepOtherVersion emphasis:e3]).
			l2 do:[:eachEntry | list add:(e2 isNil ifTrue:[eachEntry] ifFalse:[Text string:eachEntry emphasis:e2])].
			list add:(e3 isNil ifTrue:[sepLine] ifFalse:[Text string:sepLine emphasis:e3]).
		    ].
		    sameAtEnd do:[:eachEntry | list add:eachEntry].
		    l1 := l2 := nil.
		].
	    ].

	    skip ifFalse:[
		state == #initial ifTrue:[
		    list add:entry
		].
		state == 1 ifTrue:[
		    l1 add:entry.
"/                    e1 notNil ifTrue:[
"/                        list add:(Text string:entry emphasis:e1)
"/                    ] ifFalse:[
"/                        list add:entry
"/                    ]
		].
		(state == 3 or:[state == 23]) ifTrue:[
		    l2 add:entry
"/                    e2 notNil ifTrue:[
"/                        list add:(Text string:entry emphasis:e2)
"/                    ] ifFalse:[
"/                        list add:entry
"/                    ]
		].
	    ].
	].
    ].

    l1 notNil ifTrue:[
	state ~~ #initial ifTrue:[self error:'oops - bad state should not happen ...'].

	"/ diff3-output is sometimes stupid; fix some here
	[l1 notEmpty and:[l2 notEmpty and:[l1 first = l2 first or:[l1 first withTabsExpanded = l2 first withTabsExpanded]]]] whileTrue:[l1 removeFirst. l2 removeFirst].
	[l1 notEmpty and:[l2 notEmpty and:[l1 last = l2 last or:[l1 last withTabsExpanded = l2 last withTabsExpanded]]]] whileTrue:[l1 removeLast. l2 removeLast].

	(l1 notEmpty or:[l2 notEmpty]) ifTrue:[
	    list add:(e3 isNil ifTrue:[sepYourVersion] ifFalse:[Text string:sepYourVersion emphasis:e3]).
	    l1 do:[:eachEntry | list add:(e1 isNil ifTrue:[eachEntry] ifFalse:[Text string:eachEntry emphasis:e1])].
	    list add:(e3 isNil ifTrue:[sepOtherVersion] ifFalse:[Text string:sepOtherVersion emphasis:e3]).
	    l2 do:[:eachEntry | list add:(e2 isNil ifTrue:[eachEntry] ifFalse:[Text string:eachEntry emphasis:e2])].
	    list add:(e3 isNil ifTrue:[sepLine] ifFalse:[Text string:sepLine emphasis:e3]).
	].
	l1 := l2 := nil.
    ].
    ^ list

    "Created: 9.9.1996 / 19:54:00 / cg"
    "Modified: 9.9.1996 / 20:41:40 / cg"
!

emphasizeMergedDiff3TextFromPerforce:mergedText origEmphasis:origEmphasize otherEmphasis:otherEmphasize yourEmphasis:yourEmphasize separatorEmphasis:separatorEmphasize
    "given the merge()/rcsmerge() merged output (as created by 'cvs update'),
     create & return a text object which contains the conflicts
     highlighted.
     CAVEAT: this is a highly specialized method - probably not the right place
     for it here ..."

    |list origSeparator otherSeparator yourSeparator endSeparator line currentEmphasis nextEmphasis|

    list := StringCollection new.

    origSeparator := '>>>> ORIGINAL //'.
    otherSeparator := '==== THEIRS //'.
    yourSeparator := '==== YOURS //'.
    endSeparator := '<<<<'.
    mergedText do:[:aLine|
	line := aLine withoutTrailingSeparators.
	(aLine startsWith:origSeparator) ifTrue:[
	    currentEmphasis := separatorEmphasize.
	    nextEmphasis := origEmphasize.
	] ifFalse:[
	    (aLine startsWith:otherSeparator) ifTrue:[
		currentEmphasis := separatorEmphasize.
		nextEmphasis := otherEmphasize.
	    ] ifFalse:[
		(aLine startsWith:yourSeparator) ifTrue:[
		    currentEmphasis := separatorEmphasize.
		    nextEmphasis := yourEmphasize.
		] ifFalse:[
		    (aLine startsWith:endSeparator) ifTrue:[
			currentEmphasis := separatorEmphasize.
			nextEmphasis := nil.
		    ] ifFalse:[
			nextEmphasis := currentEmphasis.
		    ].
		].
	    ].
	].
	list add:(currentEmphasis isNil ifTrue:[aLine] ifFalse:[Text string:aLine emphasis:currentEmphasis]).

	currentEmphasis := nextEmphasis.
    ].
    ^ list

    "Created: / 01-06-2012 / 10:44:31 / cg"
! !

!Diff3TextView methodsFor:'initialization'!

initStyle
    super initStyle.

    showSeparators := false.

    useColors := true.
    useColors ifTrue:[
        device hasColors ifTrue:[
            addedColor := self blackColor.
            addedBgColor := Color green.

            changedColor := removedColor := self whiteColor.
            removedBgColor := Color red.
            changedBgColor := Color blue.
        ] ifFalse:[
            addedBgColor := removedBgColor := changedBgColor := self blackColor.
            addedColor := removedColor := changedColor := self whiteColor.
        ]
    ].

    "Created: 16.11.1995 / 16:59:48 / cg"
    "Modified: 12.12.1995 / 12:25:55 / cg"
! !

!Diff3TextView methodsFor:'private'!

updateListsFromMergedText:mergedText
    "given the merge()/rcsmerge() merged output (as created by 'cvs update'),
     update my views contents"

    |idx1 idx2 idx3 dIdx dEnd state entry l1 l2 l3
     textView1 textView2 textView3 skip max|

    textView1 := textViews at:1.
    textView2 := textViews at:2.
    textView3 := textViews at:3.

    l1 := OrderedCollection new.
    l2 := OrderedCollection new.
    l3 := OrderedCollection new.

    idx1 := 1.
    idx2 := 1.
    idx3 := 1.

    dIdx := 1.
    dEnd := mergedText size + 1.
    state := #initial.
    [dIdx < dEnd] whileTrue:[
	dIdx == dEnd ifTrue:[
	    "dummy cleanup entry"
	    entry := nil.
	    state := #initial.
	] ifFalse:[
	    entry := mergedText at:dIdx.
	    dIdx := dIdx + 1.
	].

	state == #initial ifTrue:[
	    "
	     fill up to size difference from previous change
	    "
	    max := (l1 size max:l2 size) max:l3 size.
	    [l1 size < max] whileTrue:[
		l1 add:nil
	    ].
	    [l2 size < max] whileTrue:[
		l2 add:nil
	    ].
	    [l3 size < max] whileTrue:[
		l3 add:nil
	    ].

	    "
	     except for the first chunk, add a separating line
	    "
	    l1 size ~~ 0 ifTrue:[
		showSeparators ifTrue:[
		    l1 add:'--------'.
		    l2 add:'--------'.
		    l3 add:'--------'.
		]
	    ].
	].

	skip := false.

	entry notNil ifTrue:[
	    (entry startsWith:'<<<<<<<') ifTrue:[
		state := 1. skip := true.
	    ] ifFalse:[
		(entry startsWith:'|||||||') ifTrue:[
		    state := 2. skip := true.
		] ifFalse:[
		    (entry startsWith:'=======') ifTrue:[
			state == 2 ifFalse:[
			    state := 23        "/ on both 2 and 3
			] ifTrue:[
			    state := 3         "/ only in 3
			].
			skip := true.
		    ] ifFalse:[
			(entry startsWith:'>>>>>>>') ifTrue:[
			    state := #initial.
			    skip := true.
			]
		    ]
		]
	    ].

	    skip ifFalse:[
		(state == #initial or:[state == 1]) ifTrue:[
		    (useColors and:[state == 1]) ifTrue:[
			l1 add:(Text string:entry
				     emphasis:(Array with:(#color->changedColor)
						     with:(#backgroundColor->changedBgColor))).
		    ] ifFalse:[
			l1 add:entry
		    ]
		].
		(state == #initial or:[state == 2 or:[state == 23]]) ifTrue:[
		    (useColors and:[state == 2 or:[state == 23]]) ifTrue:[
			l2 add:(Text string:entry
				     emphasis:(Array with:(#color->changedColor)
						     with:(#backgroundColor->changedBgColor))).
		    ] ifFalse:[
			l2 add:entry
		    ]
		].
		(state == #initial or:[state == 3 or:[state == 23]]) ifTrue:[
		    (useColors and:[state == 3 or:[state == 23]]) ifTrue:[
			l3 add:(Text string:entry
				     emphasis:(Array with:(#color->changedColor)
						     with:(#backgroundColor->changedBgColor))).
		    ] ifFalse:[
			l3 add:entry
		    ]
		].
	    ].
	].
    ].

    textView1 list:l1.
    textView2 list:l2.
    textView3 list:l3.

    "Modified: 13.12.1995 / 19:56:32 / cg"
! !

!Diff3TextView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

