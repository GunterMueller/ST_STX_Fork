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
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

SimpleView subclass:#TabSpecRuler
	instanceVariableNames:'tabSpec titles handleStyle handleCursor movedTabIndex movedTabX
		synchronousOperation handleWidth fixedTabs tabsAreVariable
		hiddenTabs masterView'
	classVariableNames:'DefaultHandleStyle'
	poolDictionaries:''
	category:'Views-Misc'
!

!TabSpecRuler class methodsFor:'documentation'!

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
    It shows the tabulator positions of a TabulatorSpecification
    and allows its tab positions to be manipulated.
    (as shown in a FileBrowser, when the longList is enabled).

    [author]
        Claus Gittinger

    [see also:]
        TabulatorSpecification
        Ruler
        ListView
"
!

examples
"
                                                                [exBegin]
    |top head spec|

    top := View new.
    top extent:300@100.

    head := TabSpecRuler in:top.
    head width:1.0.
    head level:1.

    spec := TabulatorSpecification new.
    spec unit:#inch.
    spec positions:#(0     1     2.5    3.5    4       5        ).
    spec align:    #(#left #left #right #right #center #decimal ).

    head tabulatorSpecification:spec.
    top open.
                                                                [exEnd]

                                                                [exBegin]
    |top head spec|

    top := View new.
    top extent:300@100.

    head := TabSpecRuler in:top.
    head width:1.0.
    head level:1.
    head titles:#('col1' 'col2' 'col3' 'col4' 'col5' 'col6').

    spec := TabulatorSpecification new.
    spec unit:#inch.
    spec positions:#(0     1     2.5    3.5    4       5        ).
    spec align:    #(#left #left #right #right #center #decimal ).

    head tabulatorSpecification:spec.
    top open.
                                                                [exEnd]
"

! !

!TabSpecRuler class methodsFor:'defaults'!

updateStyleCache
    <resource: #style (#'tabRuler.handleStyle')>

    DefaultHandleStyle := StyleSheet at:'tabRuler.handleStyle'.

    "Modified: 20.10.1997 / 15:14:47 / cg"
! !

!TabSpecRuler methodsFor:'accessing'!

beAsynchronous
    "clear synchronousOperation mode;
     if on, a move is immediately forwarded to dependents;
     of off, its forwarded when the mouse button is released."

    synchronousOperation := false.

    "Modified: 28.3.1997 / 15:02:07 / cg"
!

beSynchronous
    "set synchronousOperation mode;
     if on, a move is immediately forwarded to dependents;
     of off, its forwarded when the mouse button is released."

    synchronousOperation := true.

    "Modified: 28.3.1997 / 15:02:07 / cg"
!

fixedTabs
    "return the collection of tabIndices which are fixed;
     or nil, if all are variable"

    ^ fixedTabs

    "Created: 28.3.1997 / 15:02:29 / cg"
    "Modified: 28.3.1997 / 15:03:05 / cg"
!

fixedTabs:something
    "set the collection of tabIndices which are fixed;
     nil, if all are to be variable"

    fixedTabs := something.

    "Created: 28.3.1997 / 15:02:29 / cg"
    "Modified: 28.3.1997 / 15:03:18 / cg"
!

hiddenTabs
    "return the collection of tabs which are to be hidden
     (or nil if all are to be shown)"

    ^ hiddenTabs

    "Created: 28.3.1997 / 15:35:54 / cg"
    "Modified: 28.3.1997 / 15:36:18 / cg"
!

hiddenTabs:something
    "set the collection of tabs which are to be hidden
     (or nil if all are to be shown)"

    hiddenTabs := something.

    "Created: 28.3.1997 / 15:35:54 / cg"
    "Modified: 28.3.1997 / 15:36:24 / cg"
!

isSynchronous
    "return the synchronousOperation mode settings value"

    ^ synchronousOperation

    "Created: 28.3.1997 / 15:01:17 / cg"
    "Modified: 28.3.1997 / 15:02:20 / cg"
!

masterView:aView
    "set my master view - if non-nil, I will follow the masters scroll-offset"

    masterView notNil ifTrue:[
        masterView removeDependent:self
    ].
    masterView := aView.
    masterView notNil ifTrue:[
        masterView addDependent:self
    ].

!

synchronousOperation
    <resource: #obsolete>
    "return the synchronousOperation mode settings value"

    self obsoleteMethodWarning:'use #isSynchronous'.
    ^ synchronousOperation

    "Created: 28.3.1997 / 15:01:17 / cg"
    "Modified: 28.3.1997 / 15:02:20 / cg"
!

synchronousOperation:something
    <resource: #obsolete>
    "set/clear synchronousOperation mode;
     if on, a move is immediately forwarded to dependents;
     of off, its forwarded when the mouse button is released."

    self obsoleteMethodWarning:'use #beSynchronous / #beAsynchronous'.
    synchronousOperation := something.

    "Modified: 28.3.1997 / 15:02:07 / cg"
!

tabsAreVariable
    "return the value of the instance variable 'tabsAreVariable' (automatically generated)"

    ^ tabsAreVariable

    "Created: 28.3.1997 / 15:05:27 / cg"
!

tabsAreVariable:something
    "set/clear movability of tabs. If false, tab positions are only
     displayed - but cannot be moved by the user.
     The default is true."

    tabsAreVariable := something.

    "Created: 28.3.1997 / 15:05:27 / cg"
    "Modified: 28.3.1997 / 15:06:19 / cg"
!

tabulatorSpecification:aTabSpec
    "set my tabulator specification"

    tabSpec := aTabSpec.
    self invalidate

    "Modified: 18.4.1997 / 18:16:07 / cg"
!

titles:aCollectionOfStrings
    titles := aCollectionOfStrings

    "Created: 1.4.1997 / 13:52:37 / cg"
! !

!TabSpecRuler methodsFor:'event handling'!

buttonMotion:state x:x y:y
    "mouse-button was moved while pressed;
     redraw thumb at its new position and, if scroll-mode is asynchronous, 
     the scroll action is performed"

    |left right limit1 limit2 minSpacing newX|

    movedTabIndex notNil ifTrue:[
        minSpacing := 5.

        left := limit1 := 0.
        movedTabIndex > 1 ifTrue:[
            left := self positionOfTabAtIndex:(movedTabIndex-1).
            limit1 := left + minSpacing.
        ].
        right := limit2 := width.
        movedTabIndex < tabSpec size ifTrue:[
            right := self positionOfTabAtIndex:(movedTabIndex+1).
            limit2 := right - minSpacing.
        ].
        newX := (x max:limit1) min:limit2.
        x ~= newX ifTrue:[
            self cursor:Cursor stop.
        ] ifFalse:[
            self cursor:handleCursor
        ].
        newX ~= movedTabX ifTrue:[
            movedTabX := newX.
            self clearRectangleX:left+handleWidth y:0 
                           width:(right-left-handleWidth-handleWidth) height:height.
            movedTabIndex ~~ 1 ifTrue:[
                self redrawTitleAtIndex:(movedTabIndex - 1).
            ].
            self redrawTabAtIndex:movedTabIndex.
            synchronousOperation == true ifTrue:[
                self moveTabAtIndex:movedTabIndex toX:movedTabX
            ]
        ]
    ] ifFalse:[
        (self canMoveTabAtX:x) ifTrue:[
            self cursor:handleCursor
        ] ifFalse:[
            self cursor:(Cursor normal)
        ]
    ]

    "Modified: 1.4.1997 / 15:21:16 / cg"
!

buttonPress:button x:x y:y
    "mouse-button was pressed;
     start moving the tab"

    movedTabIndex := nil.
    (self canMoveTabAtX:x) ifTrue:[
        movedTabIndex := self indexOfTabAtX:x.
        self cursor:handleCursor.
    ]

    "Modified: 28.3.1997 / 15:13:15 / cg"
!

buttonRelease:button x:x y:y
    "mouse-button was pressed;
     start moving the tab"

    |idx|

    idx := movedTabIndex.
    movedTabIndex := nil.
    idx notNil ifTrue:[
        synchronousOperation == true ifFalse:[
            self moveTabAtIndex:idx toX:movedTabX
        ]
    ]

    "Modified: 28.3.1997 / 15:10:23 / cg"
!

pointerLeave:state
    "mouse left view - restore cursor."

    self cursor:(Cursor normal).

    "Created: 28.3.1997 / 13:37:52 / cg"
!

update:something with:aParameter from:changedObject
    changedObject == masterView ifTrue:[
        something == #originOfContents ifTrue:[
            self scrollTo:(masterView viewOrigin x @ 0).
        ].
    ].
! !

!TabSpecRuler methodsFor:'initialization'!

initStyle
    super initStyle.

    handleStyle := DefaultHandleStyle.
    handleCursor := (VariablePanel cursorForOrientation:#horizontal onDevice:device) onDevice:device.
    self is3D ifTrue:[
        handleWidth := 2.
    ] ifFalse:[
        handleWidth := 1
    ]

    "Modified: / 30.9.1998 / 18:20:20 / cg"
!

initialize
    super initialize.

    tabsAreVariable := true.

    self enableMotionEvents.
    self enableEnterLeaveEvents.

    self height:(gc font height + (2 * gc font descent)). 

    "
     TabSpecRuler new open
    "

    "Modified: 28.3.1997 / 15:06:29 / cg"
! !

!TabSpecRuler methodsFor:'private'!

canMoveTabAtX:x
    |idx|

    tabsAreVariable ifTrue:[
        (idx := self indexOfTabAtX:x) ~~ 0 ifTrue:[
            (fixedTabs notNil and:[fixedTabs includes:idx]) ifFalse:[
                ^ true
            ]
        ]
    ].
    ^ false

    "Created: 28.3.1997 / 15:12:05 / cg"
    "Modified: 28.3.1997 / 15:19:01 / cg"
!

indexOfTabAtX:x
    |xTab minDelta bestIndex|

    tabSpec isNil ifTrue:[^ 0].
    bestIndex := 0.

    1 to:tabSpec size do:[:i |
        xTab := tabSpec positionOfTab:i on:self.
        (x between:(xTab-5) and:(xTab+5)) ifTrue:[
            (minDelta isNil 
            or:[(x - xTab) abs < minDelta]) ifTrue:[
                minDelta := (x - xTab) abs.
                bestIndex := i.
            ]
        ]
    ].
    ^ bestIndex

    "Modified: 28.3.1997 / 13:43:47 / cg"
    "Created: 28.3.1997 / 15:12:09 / cg"
!

moveTabAtIndex:idx toX:movedTabX
    |unitPosition|

    unitPosition := (tabSpec unitsPerPixelOn:self) * movedTabX.
    tabSpec moveTabAtIndex:idx to:unitPosition.

    "Modified: 28.3.1997 / 14:54:58 / cg"
! !

!TabSpecRuler methodsFor:'queries'!

widthOfContents
    masterView notNil ifTrue:[^ masterView heightOfContents].
    ^ super heightOfContents.

! !

!TabSpecRuler methodsFor:'redrawing'!

drawHandleAtX:x type:handleType
    "redraw a tabulator handle"

    self paint:self blackColor.
    self displayLineFromX:x y:0 toX:x y:height - 1.
    self is3D ifTrue:[
        self paint:self whiteColor.
        self displayLineFromX:x+1 y:0 toX:x+1 y:height - 1
    ]

    "Modified: 28.3.1997 / 14:35:48 / cg"
!

positionOfTabAtIndex:idx
    ^ ( tabSpec positionOfTab:idx on:self ) rounded.

    "Created: 28.3.1997 / 14:26:28 / cg"
    "Modified: 28.3.1997 / 15:14:03 / cg"
!

redraw
    "redraw the handles from by tabSpec"

    tabSpec isNil ifTrue:[^ self].
    shown ifFalse:[^ self].

    self clearView.
    1 to:tabSpec size do:[:idx |
        self redrawTabAtIndex:idx.
    ]

    "Modified: 1.4.1997 / 15:13:16 / cg"
!

redrawTabAtIndex:idx
    "redraw a single handle"

    |x s|

    tabSpec isNil ifTrue:[^ self].
    idx == movedTabIndex ifTrue:[
        x := movedTabX
    ] ifFalse:[
        x := self positionOfTabAtIndex:idx.
    ].

    (hiddenTabs notNil and:[hiddenTabs includes:idx]) ifFalse:[
        self drawHandleAtX:x type:(tabSpec typeOfTab:idx).
    ].

    titles notNil ifTrue:[
        s := titles at:idx.
        self paint:self blackColor.
        s displayOn:self x:x+3 y:(gc font ascent).
    ].

    "Created: 28.3.1997 / 13:57:54 / cg"
    "Modified: 1.4.1997 / 15:29:19 / cg"
!

redrawTitleAtIndex:idx
    "redraw a single handle"

    |x s|

    tabSpec isNil ifTrue:[^ self].
    titles isNil ifTrue:[^ self].

    idx == movedTabIndex ifTrue:[
        x := movedTabX
    ] ifFalse:[
        x := self positionOfTabAtIndex:idx.
    ].

    s := titles at:idx.
    self paint:self blackColor.
    s displayOn:self x:x+3 y:(gc font ascent).

    "Modified: 1.4.1997 / 15:20:31 / cg"
! !

!TabSpecRuler class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

