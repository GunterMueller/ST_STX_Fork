"
 COPYRIGHT (c) 1999 by eXept Software AG
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

AbstractHierarchicalItem subclass:#HierarchicalItem
	instanceVariableNames:'isExpanded height width'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

HierarchicalItem subclass:#Example
	instanceVariableNames:'label icon'
	classVariableNames:'PenguinIcon'
	poolDictionaries:''
	privateIn:HierarchicalItem
!

!HierarchicalItem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    Hierarchical Items are mostly like Models, but the list of
    dependencies are kept by its HierarchicalList.
    Instances of (subclasses of) me are used to build up hierarchical trees.
    This class is usually subclassed, to add label, icon or value (reference to some info)
    to the tree item.
    
    [Instance variables:]
        parent      <Item, List or nil>         parent or my HierarchicalList.
        children    <Collection or nil>         list of children
        isExpanded  <Boolean>                   indicates whether the item is
                                                expanded or collapsed
        width       <Integer>                   cached width of displayed label
        height      <Integer>                   cached height of displayed label

    [author:]
        Claus Atzkern

    [see also:]
        HierarchicalList
        HierarchicalListView
"
! !

!HierarchicalItem methodsFor:'accessing'!

height
    "return the cached height"

    ^ height
!

height:something
    "set the cached height"

    height := something.
!

width
    "return the cached width"

    ^ width
!

width:something
    "set the cached width"

    width := something.
! !

!HierarchicalItem methodsFor:'private'!

fetchChildren
    "should compute the list of children via the model.
     Be aware, that the somewhat stupid 'optimization' of how the model is fetched may lead to
     a O(n*log n) or even O(n^2) behavior here.
     *** to optimize: redefine #model by subClass"

    |model childrenFromModel|

    (model := self model) notNil ifTrue:[
        childrenFromModel := model childrenFor:self
    ].
    ^ childrenFromModel
!

makeWidthAndHeightUnknown
    width := height := nil
!

setExpanded:aBoolean
    "set expanded flag without any computation or notification"

    isExpanded := aBoolean
! !

!HierarchicalItem methodsFor:'protocol-displaying'!

heightOn:aGC
    "return the height of the receiver, if it is to be displayed on aGC"

    height isNil ifTrue:[
        height := self heightOf:(self label) on:aGC
    ].
    ^ height
!

widthOn:aGC
    "return the width of the receiver, if it is to be displayed on aGC"

    width isNil ifTrue:[
        width := self widthOf:(self label) on:aGC
    ].
    ^ width
! !

!HierarchicalItem methodsFor:'queries'!

isExpanded
    "returns true if the item is expanded"

    ^ isExpanded 
! !

!HierarchicalItem::Example class methodsFor:'instance creation'!

labeled:aLabel
    ^ self new setLabel:aLabel


!

labeled:aLabel icon:anIcon
    ^ self new setLabel:aLabel icon:anIcon


! !

!HierarchicalItem::Example class methodsFor:'resources'!

iconForLevel:aLevel
    "returns an icon
    "
    aLevel == 2 ifTrue:[ ^ ResourceSelectionBrowser iconPrivateClass ].
    aLevel == 3 ifTrue:[ ^ ResourceSelectionBrowser iconClass ].
    aLevel == 4 ifTrue:[ ^ ResourceSelectionBrowser iconCategory ].

  ^ nil
!

penguinIcon
    PenguinIcon isNil ifTrue:[
        PenguinIcon := Smalltalk imageFromFileNamed:'xpmBitmaps/misc_logos/linux_penguin.xpm'
                                 inPackage:'stx:goodies'
    ].
    ^ PenguinIcon
! !

!HierarchicalItem::Example methodsFor:'accessing'!

children
    |lvl lbl txt image img icon|

    children notNil ifTrue:[
        ^ children
    ].

    (lvl := self level) == 5 ifTrue:[
        children := #().
      ^ children
    ].
    icon     := self class iconForLevel:(lvl + 1).
    children := OrderedCollection new.

    lvl < 4 ifTrue:[
        txt := (lvl + 1) printString, ' ['.
        img := Icon saveIcon.

        1 to:5 do:[:i|
            (i == 2 or:[i == 3]) ifTrue:[
                lbl := img
            ] ifFalse:[
                i == 4 ifTrue:[
                    lbl := Array with:(self class penguinIcon)
                                 with:('penguin#and#text' copyReplaceAll:$# with:(Character cr)).
                ] ifFalse:[
                    lbl := txt, (i printString), ']'
                ]
            ].
            children add:(self class labeled:lbl icon:icon)
        ].
    ] ifFalse:[
        image := ResourceSelectionBrowser iconPrivateClass.
        txt   := LabelAndIcon icon:image string:'Text'.
        img   := Icon copyIcon.

        1 to:5 do:[:i|
            lbl := i odd ifTrue:[txt] ifFalse:[img].
            lbl := Array with:lbl with:'test' with:img.
            children add:(self class labeled:lbl icon:icon).
        ].
        children add:(self class labeled:'Edit Text').
    ].

    children do:[:aChild| aChild parent:self ].
  ^ children
!

icon
    "returns the icon
    "
    ^ icon
!

icon:anIcon
    "set the icon; if icon changed, a notification
     is raised.
    "
    icon ~= anIcon ifTrue:[
        icon := anIcon.
        self iconChanged
    ]
!

label
    "returns the label
    "
    ^ label

!

label:aLabel
    "set the label; if label changed, a notification
     is raised.
    "
    label ~= aLabel ifTrue:[
        label := aLabel.
        self changed.
    ]

!

setIcon:anIcon
    "set the icon without any change notification
    "
    icon := anIcon
!

setLabel:aLabel
    "set the label without any change notification
    "
    label := aLabel
!

setLabel:aLabel icon:anIcon
    "set the label and icon without any change notification
    "
    label := aLabel.
    icon  := anIcon.
! !

!HierarchicalItem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

