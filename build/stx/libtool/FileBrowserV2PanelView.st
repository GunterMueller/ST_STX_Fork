"
 COPYRIGHT (c) 2002 by eXept Software AG 
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

VariablePanel subclass:#FileBrowserV2PanelView
	instanceVariableNames:'whichView viewIsVisible visibilityHolder oldOrigin oldCorner'
	classVariableNames:'BarHeight'
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FileBrowserV2PanelView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG 
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
    copy of the Panel from CBrowser , if a better HorizontalPanel and VerticalPanel is available
    the new version can be used here

    [Author:]
        Christian Penk
"
! !

!FileBrowserV2PanelView methodsFor:'accessing'!

visible:aState
    |view1 view2 newVisible newOrigin1 newOrigin2 newCorner1 newCorner2|

    newVisible := aState ? true.

    ((newVisible == self isVisible) or:[subViews size ~~ 2]) ifTrue:[
        ^ self
    ].
    viewIsVisible := newVisible.

    view1 := subViews at:1.
    view2 := subViews at:2.

    viewIsVisible ifTrue:[
        "
        MAKE VISIBLE
        "
        view1 origin:0.0@0.0   corner:oldCorner.
        view2 origin:oldOrigin corner:1.0@1.0.
        self  resizeSubviews.
    ] ifFalse:[
        "
        MAKE INVISIBLE
        "
        oldCorner := view1 relativeCorner.
        oldOrigin := view2 relativeOrigin.

        orientation == #vertical ifTrue:[
            whichView == #first ifTrue:[
                newOrigin1 := 0.0 @ 0.0. newCorner1 := 1.0 @ 0.0.
                newOrigin2 := 0.0 @ 0.0. newCorner2 := view2 corner.
            ] ifFalse:[
                newOrigin1 := 0.0 @ 0.0. newCorner1 := 1.0 @ 1.0.
                newOrigin2 := 0.0 @ 1.0. newCorner2 := view2 corner.
            ].
        ] ifFalse:[
            whichView == #first ifTrue:[
                newOrigin1 := 0.0 @ 0.0. newCorner1 := 0.0 @ 1.0.
                newOrigin2 := 0.0 @ 0.0. newCorner2 := 1.0 @ 1.0.
            ] ifFalse:[
                newOrigin1 := 0.0 @ 0.0. newCorner1 := 1.0 @ 1.0.
                newOrigin2 := 1.0 @ 0.0. newCorner2 := 1.0 @ 1.0.
            ]
        ].
        view1 origin:newOrigin1 corner:newCorner1.
        view2 origin:newOrigin2 corner:newCorner2.
    ].
    visibilityHolder notNil ifTrue:[visibilityHolder value:viewIsVisible]
!

whichView
    "return the value of the instance variable 'whichView' (automatically generated)"

    ^ whichView
!

whichView:something
    "set the value of the instance variable 'whichView' (automatically generated)"

    whichView := something.
! !

!FileBrowserV2PanelView methodsFor:'accessing-mvc'!

visibilityHolder
    ^ visibilityHolder
!

visibilityHolder:aHolder
    visibilityHolder removeDependent:self.

    (visibilityHolder := aHolder) notNil ifTrue:[
        visibilityHolder addDependent:self.

        realized ifTrue:[
            self visible:(visibilityHolder value)
        ]
    ]
! !

!FileBrowserV2PanelView methodsFor:'actions'!

toggleVisibility

    self visible:(self isVisible not)
! !

!FileBrowserV2PanelView methodsFor:'change & update'!

update:what with:aPara from:chgObj

    chgObj == visibilityHolder ifTrue:[
        self visible:(chgObj value).
        ^ self.
    ].
    super update:what with:aPara from:chgObj
! !

!FileBrowserV2PanelView methodsFor:'initialization'!

destroy
    visibilityHolder removeDependent:self.
    super destroy
!

initialize
    orientation := #vertical.
    whichView   := #first.
    viewIsVisible := true.
    super initialize
!

realize
    super realize.

    visibilityHolder notNil ifTrue:[
        self visible:(visibilityHolder value)
    ]
! !

!FileBrowserV2PanelView methodsFor:'queries'!

anyNonRelativeSubviews
    "return true, if any of my subviews has no relative origin/extent"

    "/ cg asking ca: "whats the reason for this ?"
    "/ ^ subViews notNil
    ^ super anyNonRelativeSubviews.
!

isVisible
    ^ viewIsVisible 
!

specClass
    ^ FileBrowserV2UISpecifications panelSpecClass
! !

!FileBrowserV2PanelView class methodsFor:'documentation'!

version
    ^ '$Id: FileBrowserV2PanelView.st 7854 2012-01-30 17:49:41Z vranyj1 $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: FileBrowserV2PanelView.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

