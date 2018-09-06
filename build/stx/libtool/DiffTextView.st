"{ Encoding: utf8 }"

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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

TwoColumnTextView subclass:#DiffTextView
	instanceVariableNames:'useColors showSeparators addedColor addedBgColor removedColor
		removedBgColor changedColor changedBgColor changedSpacesOnlyColor
		changedSpacesOnlyBgColor diffLineNumbers'
	classVariableNames:'DiffCommandTemplate'
	poolDictionaries:''
	category:'Views-Text'
!

AbstractBackground subclass:#DiffTextScrollerBackground
	instanceVariableNames:'diffView'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DiffTextView
!

!DiffTextView class methodsFor:'documentation'!

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
    a view showing diff output (see unix manual pages)
    in a user-friendly form.
    The view is created and opened with:

        d := DiffTextView openOn:text1 and:text2

    or:
        d := DiffTextView openOn:text1 label:l1
                             and:text2 label:l2

    and it will show the differences side-by-side.

    The colors mean:
        red             - removed
        green           - added
        blue            - changed
        light-blue        changed, but not really (i.e. spaces only)

    For a real world application and use of this widget, 
    see the ChangesBrowsers `compare', 
    or the browsers 'compare with repository' functions.

    Notice:
        A diff command must be available on your system and found
        along the PATH (you will see a warning on stderr, if there is no diff).
        We use gnu-diff.

    [see also:]
        TextView EditTextView Diff3TextView

    [author:]
        Claus Gittinger
"
!

examples
"
                                                        [exBegin]
    |text1 text2|

    text1 := 'hello world
here is some difference
more text
this line has been removed
more text
more text
'.

    text2 := 'hello world
where is the difference ?
more text
more text
more text
this line has been added
'.

    DiffTextView openOn:text1 label:'text1'
                    and:text2 label:'text2'
                                                        [exEnd]
"
! !

!DiffTextView class methodsFor:'instance creation'!

openOnClass:classA labelA:lblA andClass:classB labelB:lblB title:title ifSame:sameAction
    "provided for protocol compatibility with the VersionDiffBrowser;
     actually, the classes are ignored here"

    |v aStream sourceA sourceB|

    aStream := '' writeStream.
    Method flushSourceStreamCache.
    classA fileOutOn:aStream withTimeStamp:false.
    sourceA := aStream contents asString.

    aStream := '' writeStream.
    Method flushSourceStreamCache.
    classB fileOutOn:aStream withTimeStamp:false.
    sourceB := aStream contents asString.

    v := self 
            openOn:sourceA label:lblA
            and:sourceB label:lblB.      
    v topView label:title.
    ^ v
!

openOnClass:someClass labelA:lblA sourceA:sourceA labelB:lblB sourceB:sourceB
    "provided for protocol compatibility with the VersionDiffBrowser;
     actually, the class is ignored here"

    ^ self 
        openOnClass:someClass 
        labelA:lblA sourceA:sourceA 
        labelB:lblB sourceB:sourceB 
        title:'Comparing ' , someClass name.
!

openOnClass:someClass labelA:lblA sourceA:sourceA labelB:lblB sourceB:sourceB title:title
    "provided for protocol compatibility with the VersionDiffBrowser;
     actually, the class is ignored here"

    ^ self
        openOnClass:someClass 
        labelA:lblA sourceA:sourceA 
        labelB:lblB sourceB:sourceB 
        title:title ifSame:nil
!

openOnClass:someClass labelA:lblA sourceA:sourceA labelB:lblB sourceB:sourceB title:title ifSame:sameAction
    "provided for protocol compatibility with the VersionDiffBrowser;
     actually, the class is ignored here"

    |v|

    v := self 
            openOn:sourceA label:lblA
            and:sourceB label:lblB.      
    v topView label:title.
    ^ v
! !

!DiffTextView class methodsFor:'defaults'!

diffCommand
    "return the diff-command (with argument placeHolders)"

    "/ forwarded, for backward compatibility...
    ^ DiffListUtility diffCommand
!

diffCommandTemplate:aCommandTemplateString
    "set the diff-command template"

    "/ forwarded for backward compatibility
    DiffListUtility diffCommandTemplate:aCommandTemplateString
! !

!DiffTextView methodsFor:'accessing'!

text1:t1 text2:t2
    "set the two texts which are to be diffed;
     execute DiffCommand and update the two textViews."

    |text1 text2 diffList|

    text1 := t1 asStringCollection.
    text2 := t2 asStringCollection.
    text1 = text2 ifTrue:[
        diffList := #()
    ] ifFalse:[
        diffList := self diffListFor:text1 and:text2.
    ].
    self updateListsFrom:text1 and:text2 diffs:diffList

    "
     |v|

     v := HVScrollableView for:DiffTextView.
     v scrolledView text1:('../libview/Color.st' asFilename readStream contents)
                    text2:('../libview/Color.st.old' asFilename readStream contents).
     v open
    "

    "
     |v t1 t2|

     t1 := '
one
two
three
four
'.
     t2 := '
one
two-a
two-b
three
three-b
four
'.

     v := DiffTextView new.
     v text1:t1 text2:t2.
     v open
    "

    "Modified: / 27-03-2007 / 12:06:46 / cg"
! !

!DiffTextView methodsFor:'initialization'!

addNextPreviousButtons
    super addNextPreviousButtons.
    nextPrevButtonPanel beVisible.
!

initStyle
    super initStyle.

    showSeparators := false.

    (useColors := device hasColors) ifTrue:[
        addedColor := self whiteColor.
        addedBgColor := Color red.

        removedColor := self blackColor.
        removedBgColor := Color green.

        changedColor := self whiteColor.
        changedBgColor := Color blue.

        changedSpacesOnlyColor := self whiteColor.
        changedSpacesOnlyBgColor := Color blue lightened.
    ] ifFalse:[
        showSeparators := true.

        (useColors := device hasGreyscales) ifTrue:[
            addedBgColor := removedBgColor := changedBgColor := Color grey:80.
            addedColor := removedColor := changedColor := self blackColor.
        ] ifFalse:[
            addedBgColor := removedBgColor := changedBgColor := self blackColor.
            addedColor := removedColor := changedColor := self whiteColor.
        ].

        changedSpacesOnlyColor := self whiteColor.
        changedSpacesOnlyBgColor := self blackColor.
    ].

    "Created: 16.11.1995 / 16:59:48 / cg"
    "Modified: 14.6.1996 / 16:14:39 / cg"
!

postRealize
    super postRealize.
    self moveToNextChanged
! !

!DiffTextView methodsFor:'private'!

diffListFor:text1 and:text2
    "return a raw difflist for the two texts which are to be diffed"

    ^ DiffListUtility diffListFor:text1 and:text2
!

processDiffList:diffList from:text1 and:text2
    "given the two texts in text1 and text2, and the diff-output in diffList,
     return new left and right lists."

    |idx1 idx2 dIdx dEnd state s nr1 nr2 nr3 op entry l1 l2 any delta s1 s2 line1 line2|

    diffList size == 1 ifTrue:[
        ^ { diffList. diffList }
    ].

    diffLineNumbers := OrderedCollection new.

    l1 := OrderedCollection new.
    l2 := OrderedCollection new.

    idx1 := 1.
    idx2 := 1.

    dIdx := 1.
    dEnd := diffList size + 1.
    state := #initial.
    [dIdx <= dEnd] whileTrue:[
        dIdx == dEnd ifTrue:[
            "dummy cleanup entry"
            entry := nil.
            state := #initial.
        ] ifFalse:[
            entry := diffList at:dIdx.
        ].

        state == #initial ifTrue:[
            "entry is of the form <nr> <op> <offs> [<offs2>]"

            "
             fill up to size difference from previous change
            "
            delta := l1 size - l2 size.
            delta > 0 ifTrue:[
                delta timesRepeat:[l2 add:nil]
            ] ifFalse:[
                delta < 0 ifTrue:[
                    delta negated timesRepeat:[l1 add:nil]
                ]
            ].

            "
             except for the first chunk, add a separating line
            "
            l1 size ~~ 0 ifTrue:[
                showSeparators ifTrue:[
                    l1 add:'--------'.
                    l2 add:'--------'.
                ]
            ].
            "
             in cleanup ?
            "
            entry isNil ifTrue:[
                nr1 := text1 size + 1.
                nr2 := text2 size + 1.
                state := #finish.
            ] ifFalse:[
                s := ReadStream on:entry.
                nr1 := Integer readFrom:s.
                s peek == $, ifTrue:[
                    s next.
                    Integer readFrom:s
                ].
                op := s next.
                nr2 := Integer readFrom:s.
                s peek == $, ifTrue:[
                    s next.
                    nr3 := Integer readFrom:s
                ] ifFalse:[
                    nr3 := nil
                ].
                diffLineNumbers add:{ op . nr1 . nr2 }.

                op == $c ifTrue:[
                    state := #changed.
                ] ifFalse:[
                    (op == $a) ifTrue:[
                        state := #added.
                    ] ifFalse:[
                        op == $d ifTrue:[
                            state := #deleted
                        ] ifFalse:[
                            self halt:'unexpected diff entry'.
                        ]
                    ]
                ].

            ].

"/ nr1 print. ' ' print. op print. ' ' print. nr2 print. ' , ' print. nr3 printNL.

            "
             copy over unchanged lines
            "
            any := false.
            [idx1 < nr1] whileTrue:[
"/ '< add:' print. idx1 printNL.
                l1 add:(text1 at:idx1).
                idx1 := idx1 + 1.
                any := true.
            ].
            [idx2 < nr2] whileTrue:[
"/ '> add:' print. idx2 printNL.
                l2 add:(text2 at:idx2).
                idx2 := idx2 + 1.
                any := true.
            ].

            state == #added ifTrue:[
                l1 add:(text1 at:idx1 ifAbsent:'').
                idx1 := idx1 + 1.
            ].
            state == #deleted ifTrue:[
                l2 add:(text2 at:idx2 ifAbsent:'').
                idx2 := idx2 + 1.
            ].

            "
             add a separating line, except at end
            "
            any ifTrue:[
                state ~~ #finish ifTrue:[
                    showSeparators ifTrue:[
                        l1 add:'--------'.
                        l2 add:'--------'.
                    ].
                ]
            ].
        ] ifFalse:[
            state == #changed ifTrue:[
                line1 := line2 := nil.
                (entry at:1) == $< ifTrue:[
                    useColors ifTrue:[
                        (l2 size >= idx1
                        and:[(s2 := line2 := l2 at:idx1) notNil
                        and:[(line2 asString string withoutSeparators = (line1 := text1 at:idx1) asString string withoutSeparators)
                              "/ or:[(s2 asString withoutSeparators withTabsExpanded = (text1 at:idx1) withoutSeparators withTabsExpanded)]  
                        ]]) ifTrue:[
                            line1 := Text string:line1 
                                         foregroundColor:changedSpacesOnlyColor
                                         backgroundColor:changedSpacesOnlyBgColor.
                            line2 := Text string:line2 asString 
                                         foregroundColor:changedSpacesOnlyColor 
                                         backgroundColor:changedSpacesOnlyBgColor.

                            line1 string withoutTrailingSeparators = line2 string withoutTrailingSeparators ifTrue:[
                                line1 := line1 string.
                                line2 := line2 string.
                            ] ifFalse:[
                                line1 withoutSeparators withTabsExpanded = line2 withoutSeparators withTabsExpanded
                                ifTrue:[
                                    line1 := line1 string.
                                    line2 := line2 string.
                                ]
                            ].
                            l1 add:line1.
                            l2 at:idx1 put:line2.
                        ] ifFalse:[
                            line1 := Text string:(text1 at:idx1) 
                                         foregroundColor:changedColor 
                                         backgroundColor:changedBgColor.
                            l1 add:line1.
                        ]
                    ] ifFalse:[
                        l1 add:(text1 at:idx1).
                    ].
                    idx1 := idx1 + 1
                ] ifFalse:[
                    (entry at:1) == $> ifTrue:[
                        useColors ifTrue:[
                            (l1 size >= idx2
                            and:[(s1 := line1 := l1 at:idx2) notNil
                            and:[(s1 asString string withoutSeparators = (text2 at:idx2) string withoutSeparators)
                                  "/ or:[(s1 asString withoutSeparators withTabsExpanded = (text2 at:idx2) withoutSeparators withTabsExpanded)]  
                            ]]) ifTrue:[
                                line2 := Text string:(text2 at:idx2) 
                                            foregroundColor:changedSpacesOnlyColor 
                                            backgroundColor:changedSpacesOnlyBgColor.
                                line1 := Text string:line1 asString 
                                            foregroundColor:changedSpacesOnlyColor 
                                            backgroundColor:changedSpacesOnlyBgColor.
                                line1 string withoutTrailingSeparators = line2 string withoutTrailingSeparators ifTrue:[
                                    line1 := line1 string.
                                    line2 := line2 string.
                                ] ifFalse:[
                                    line1 withoutSeparators withTabsExpanded = line2 withoutSeparators withTabsExpanded
                                    ifTrue:[
                                        line1 := line1 string.
                                        line2 := line2 string.
                                    ]
                                ].
                                l2 add:line2.
                                l1 at:idx2 put:line1.
                            ] ifFalse:[
                                line2 := Text string:(text2 at:idx2) foregroundColor:changedColor backgroundColor:changedBgColor.
                                l2 add:line2
                            ]
                        ] ifFalse:[
                            l2 add:(text2 at:idx2).
                        ].
                        idx2 := idx2 + 1
                    ] ifFalse:[
                        (entry at:1) == $- ifTrue:[
                        ] ifFalse:[
                            state := #initial.
                            dIdx := dIdx - 1
                        ]
                    ]
                ].
            ] ifFalse:[
                state == #added ifTrue:[
                    (entry at:1) == $> ifTrue:[
                        useColors ifTrue:[
                            l2 add:(Text string:(text2 at:idx2) foregroundColor:addedColor backgroundColor:addedBgColor )
                        ] ifFalse:[
                            l2 add:(text2 at:idx2).
                        ].
                        idx2 := idx2 + 1.
                        l1 add:nil
                    ] ifFalse:[
                        state := #initial.
                        dIdx := dIdx - 1
                    ]
                ] ifFalse:[
                    state == #deleted ifTrue:[
                        (entry at:1) == $< ifTrue:[
                            useColors ifTrue:[
                                l1 add:(Text string:(text1 at:idx1) foregroundColor:removedColor backgroundColor:removedBgColor ).
                            ] ifFalse:[
                                l1 add:(text1 at:idx1).
                            ].
                            idx1 := idx1 + 1.
                            l2 add:nil
                        ] ifFalse:[
                            state := #initial.
                            dIdx := dIdx - 1
                        ]
                    ] 
                    "must be in finish otherwise"
                ]
            ].
        ].
        dIdx := dIdx + 1
    ].
    [l1 size < l2 size] whileTrue:[
        l1 add:''.
    ].
    [l2 size < l1 size] whileTrue:[
        l2 add:''.
    ].

    "/ fixup - diff -b is ignoring lines which differ in leading space only ...
    1 to:l1 size do:[:idx |
        |line1 line2|

        line1 := l1 at:idx.
        line2 := l2 at:idx.
        (line1 notNil and:[line1 hasChangeOfEmphasis not]) ifTrue:[
            (line2 notNil and:[line2 hasChangeOfEmphasis not]) ifTrue:[
                line1 withTabsExpanded withoutTrailingSeparators
                ~= line2 withTabsExpanded withoutTrailingSeparators 
                ifTrue:[
                    line1 := Text string:line1 
                                 foregroundColor:changedSpacesOnlyColor
                                 backgroundColor:changedSpacesOnlyBgColor.
                    line2 := Text string:line2 
                                 foregroundColor:changedSpacesOnlyColor 
                                 backgroundColor:changedSpacesOnlyBgColor.
                    l1 at:idx put:line1.
                    l2 at:idx put:line2.
                ]
            ]        
        ]
    ].

    ^ { l1. l2 }

    "Modified: / 13.7.1999 / 14:12:11 / cg"
!

updateListsFrom:text1 and:text2 diffs:diffList
    "given the two texts in text1 and text2, and the diff-output in diffList,
     update my views contents"

    |lists textView1 textView2|

    textView1 := textViews at:1.
    textView2 := textViews at:2.

    lists := self processDiffList:diffList from:text1 and:text2.

    textView1 list:lists first.
    textView2 list:lists second.

    self updateScrollbarBackground
!

updateScrollbarBackground
    "define a background in the scroller allowing quick positioning to changes"

    |container vScroller thumb|

    ((container := self container) notNil
    and:[container isScrollWrapper]) ifTrue:[
        (vScroller := container verticalScrollBar) notNil ifTrue:[
            (thumb := vScroller thumb) notNil ifTrue:[
                thumb viewBackground:(DiffTextScrollerBackground new diffView:self).
            ]
        ]
    ].
! !

!DiffTextView::DiffTextScrollerBackground class methodsFor:'documentation'!

documentation
"
    I am a scroller background used by the diff-text-viewers.
    I draws line-markers at positions where differences between two texts are.
"
! !

!DiffTextView::DiffTextScrollerBackground methodsFor:'accessing'!

diffView:something
    diffView := something.
! !

!DiffTextView::DiffTextScrollerBackground methodsFor:'drawing'!

fillRectangleX:x y:y width:w height:h in:aScroller
    |leftTextView rightTextView overAllHeight|

    leftTextView := diffView textViews first.
    rightTextView := diffView textViews second.

    overAllHeight := leftTextView numberOfLines.
    1 to:overAllHeight do:[:lineNr |
        |l1 l2 isDiff yThumb clr e|

        yThumb := (aScroller height * (lineNr / overAllHeight)) rounded.
        (yThumb >= y and:[yThumb <= (y+h)]) ifTrue:[
            l1 := leftTextView listAt:lineNr.
            l2 := rightTextView listAt:lineNr.
            (l1 notNil and:[l1 isText]) ifTrue:[
                e := l1 emphasis
            ] ifFalse:[
                (l2 notNil and:[l2 isText ]) ifTrue:[
                    e := l2 emphasis
                ]
            ].
            e size > 0 ifTrue:[
                |el|

                el := e detect:[:el | (Text extractEmphasis:#backgroundColor from:el) notNil] ifNone:nil.
                el notNil ifTrue:[
                    clr := Text extractEmphasis:#backgroundColor from:el.
                    (clr brightness > 0.5) ifTrue:[ clr := clr darkened ].
                    aScroller paint:clr.
                    aScroller displayLineFromX:1 y:yThumb toX:aScroller width-2 y:yThumb.
                ].
            ].
        ].
    ]
! !

!DiffTextView::DiffTextScrollerBackground methodsFor:'ignored conversion'!

asFormOn:aDevice
    "superclass AbstractBackground says that I am responsible to implement this method"

    ^ self 
!

onDevice:aDevice
    "superclass AbstractBackground says that I am responsible to implement this method"

    ^ self 
! !

!DiffTextView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

