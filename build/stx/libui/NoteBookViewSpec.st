"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

TabViewSpec subclass:#NoteBookViewSpec
	instanceVariableNames:'canvas canvasInset tabTopMargin tabBottomMargin keepCanvasAlive
		tabLevel tabLabelInset'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!NoteBookViewSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    Not normally used by applications.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by reading public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"

! !

!NoteBookViewSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NoteBookViewSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'NoteBookView Basics'
         name: 'NoteBookView Basics'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 387 327)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 214 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 26 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 15 0 3 1.0 37 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 51 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 40 0 -17 1.0 62 0)
                   activeHelpKey: selectionHolder
                   tabable: true
                   model: model
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button1'
                   layout: (LayoutFrame -17 1 40 0 3 1 62 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseActionMethod:
                   actionValue: model
                 )
                (LabelSpec
                   label: 'List:'
                   name: 'listLabel'
                   layout: (AlignmentOrigin 100 0 77 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'listField'
                   layout: (LayoutFrame 100 0 65 0 -73 1.0 87 0)
                   activeHelpKey: listHolder
                   tabable: true
                   model: listSelector
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Index'
                   name: 'useIndexCheckBox'
                   layout: (AlignmentOrigin -3 1.0 77 0 1 0.5)
                   activeHelpKey: useIndex
                   tabable: true
                   model: useIndex
                   translateLabel: true
                 )
                (ActionButtonSpec
                   label: 'Tab List Editor'
                   name: 'listButton'
                   layout: (LayoutFrame 100 0 91 0 3 1 115 0)
                   translateLabel: true
                   tabable: true
                   model: openTabListEditor
                 )
                (LabelSpec
                   label: 'Canvas:'
                   name: 'canvasLabel'
                   layout: (AlignmentOrigin 100 0 130 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'canvasField'
                   layout: (LayoutFrame 100 0 119 0 3 1.0 141 0)
                   activeHelpKey: canvas
                   tabable: true
                   model: canvas
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Do not destroy canvas'
                   name: 'keepCanvaseCheckBox'
                   layout: (LayoutFrame 84 0 150 0 0 1.0 172 0)
                   activeHelpKey: keepCanvasAlive
                   tabable: true
                   model: keepCanvasAlive
                   translateLabel: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Label Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 217 0 0 1.0 282 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Translate Label'
                   name: 'translateLabel'
                   layout: (LayoutFrame 26 0 4 0 0 1 26 0)
                   activeHelpKey: translateLabel
                   tabable: true
                   model: translateLabel
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NoteBookViewSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'NoteBookView Details'
         name: 'NoteBookView Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 501 500)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 174 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Font:'
                   name: 'fontLabel'
                   layout: (AlignmentOrigin 100 0 27 0 1 0.5)
                   activeHelpKey: fontMenu
                   translateLabel: true
                   resizeForLabel: true
                 )
                (FontMenuSpec
                   name: 'fontMenu'
                   layout: (LayoutFrame 100 0 15 0 5 1.0 37 0)
                   activeHelpKey: fontMenu
                   model: style
                   allowSymbolicFonts: true
                 )
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 100 0 55 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 100 0 43 0 5 1 65 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'Orientation:'
                   name: 'directionLabel'
                   layout: (AlignmentOrigin 100 0 87 0 1 0.5)
                   activeHelpKey: tabOrientation
                   translateLabel: true
                   resizeForLabel: true
                 )
                (PopUpListSpec
                   label: 'Orientation'
                   name: 'directionPopUpList'
                   layout: (LayoutFrame 100 0 75 0 5 1.0 99 0)
                   activeHelpKey: tabOrientation
                   translateLabel: true
                   tabable: true
                   model: direction
                   menu: directionList
                 )
                (LabelSpec
                   label: 'Level:'
                   name: 'levelLabel'
                   layout: (AlignmentOrigin 100 0 119 0 1 0.5)
                   activeHelpKey: level
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'levelField'
                   layout: (LayoutFrame 100 0 108 0 150 0 130 0)
                   activeHelpKey: level
                   tabable: true
                   model: level
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Is Scrollable'
                   name: 'hasScrollButtons'
                   layout: (LayoutFrame 208 0 108 0 344 0 130 0)
                   activeHelpKey: scrollTabs
                   model: hasScrollButtons
                   translateLabel: true
                   resizeForLabel: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Tab Attributes'
             name: 'tabAttributes'
             layout: (LayoutFrame 0 0.0 178 0 0 1.0 342 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Canvas Inset:'
                   name: 'canvasInsetLabel'
                   layout: (AlignmentOrigin 152 0 19 0 1 0.5)
                   activeHelpKey: canvasInset
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'canvasInsetField'
                   layout: (LayoutFrame 152 0 7 0 186 0 29 0)
                   activeHelpKey: canvasInset
                   tabable: true
                   model: canvasInset
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Fit Tabs To View'
                   name: 'fitLastRowCheckBox'
                   layout: (Point 208 4)
                   activeHelpKey: fitLastRow
                   tabable: true
                   model: fitLastRow
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Tab Level:'
                   name: 'tabLevel'
                   layout: (AlignmentOrigin 152 0 47 0 1 0.5)
                   activeHelpKey: tabLevel
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'tabLevelField'
                   layout: (LayoutFrame 152 0 36 0 186 0 58 0)
                   activeHelpKey: tabLevel
                   tabable: true
                   model: tabLevel
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Tab Label Inset:'
                   name: 'tabLabelInsetLabel'
                   layout: (AlignmentOrigin 356 0 48 0 1 0.5)
                   activeHelpKey: tabLabelInset
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'tabLabelInsetField'
                   layout: (LayoutFrame 357 0 36 0 396 0 58 0)
                   activeHelpKey: tabLabelInset
                   tabable: true
                   model: tabLabelInset
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (DividerSpec
                   name: 'Separator1'
                   layout: (LayoutFrame 0 0.0 64 0 0 1.0 68 0)
                 )
                (LabelSpec
                   label: 'Tab Margin Top:'
                   name: 'tabMarginTop'
                   layout: (AlignmentOrigin 152 0 86 0 1 0.5)
                   activeHelpKey: tabTopMargin
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'tabTopMarginfield'
                   layout: (LayoutFrame 152 0 76 0 185 0 98 0)
                   activeHelpKey: tabTopMargin
                   tabable: true
                   model: tabTopMargin
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Left:'
                   name: 'tabLeftMarginLabel'
                   layout: (AlignmentOrigin 356 0 86 0 1 0.5)
                   activeHelpKey: tabLeftMargin
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'tabLeftMargin'
                   layout: (LayoutFrame 357 0 76 0 396 0 98 0)
                   activeHelpKey: tabLeftMargin
                   tabable: true
                   model: tabLeftMargin
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Bottom:'
                   name: 'tabMarginBottom'
                   layout: (AlignmentOrigin 152 0 114 0 1 0.5)
                   activeHelpKey: tabBottomMargin
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'tabBottomMarginField'
                   layout: (LayoutFrame 152 0 103 0 185 0 125 0)
                   activeHelpKey: tabBottomMargin
                   tabable: true
                   model: tabBottomMargin
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Right:'
                   name: 'tabRightMarginLabel'
                   layout: (AlignmentOrigin 356 0 114 0 1 0.5)
                   activeHelpKey: tabRightMargin
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'tabRightMargin'
                   layout: (LayoutFrame 357 0 103 0 396 0 125 0)
                   activeHelpKey: tabRightMargin
                   tabable: true
                   model: tabRightMargin
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 342 0.0 0 1.0 409 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'canTabCheckBox'
                   layout: (Point 10 1)
                   activeHelpKey: tabable
                   tabable: true
                   model: tabable
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!NoteBookViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        canvas
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        keepCanvasAlive
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        canvasInset
                        tabLabelInset
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#numberOrPointOrNil.

    self 
        adaptApects:
                    #(  
                        tabLevel
                        tabTopMargin
                        tabBottomMargin
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#numberOrNil.

    "Modified: / 5.2.2000 / 03:08:48 / cg"
! !

!NoteBookViewSpec methodsFor:'accessing'!

canvas
    ^ canvas
!

canvas:something
    something isNil ifTrue:[
        canvas := nil.
    ] ifFalse:[
        canvas := something asSymbol
    ]
!

canvasFrameLevel
    "ignored"

    ^ nil
!

canvasFrameLevel:something
    "ignored"
!

canvasInset
    ^ canvasInset

    "Created: / 5.2.2000 / 01:23:30 / cg"
!

canvasInset:something
    canvasInset := something

    "Created: / 5.2.2000 / 01:23:52 / cg"
!

keepCanvasAlive
    ^ keepCanvasAlive ? false
!

keepCanvasAlive:something
    keepCanvasAlive := something.
!

tabBottomMargin
    ^ tabBottomMargin
!

tabBottomMargin:aMargin
    tabBottomMargin := aMargin.
!

tabLabelInset
    "inset (a point) of the label relative to its frame
         preferredExtent of Tab: label extent + tabLabelInset
    "
    ^ tabLabelInset
!

tabLabelInset:something
    "inset (a point) of the label relative to its frame
         preferredExtent of Tab: label extent + tabLabelInset
    "
    tabLabelInset := something.
!

tabLevel
    ^ tabLevel
!

tabLevel:something
    tabLevel := something
!

tabTopMargin
    ^ tabTopMargin
!

tabTopMargin:aMargin
    tabTopMargin := aMargin.
! !

!NoteBookViewSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"
    |something|

    super setAttributesIn:aView with:aBuilder.

    canvasInset     notNil ifTrue:[aView canvasInset:canvasInset].
    tabLabelInset   notNil ifTrue:[aView tabLabelInset:tabLabelInset].
    tabLevel        notNil ifTrue:[aView tabLevel:tabLevel].
    tabTopMargin    notNil ifTrue:[aView tabTopMargin:tabTopMargin].
    tabBottomMargin notNil ifTrue:[aView tabBottomMargin:tabBottomMargin].

    something := self getBindingIn:aBuilder binding:canvas.

    something isView ifTrue:[
        aView canvas:something
    ] ifFalse:[
        aView canvasHolder:something.
    ].
    aView keepCanvas:(keepCanvasAlive == true)

    "Modified: / 5.2.2000 / 03:07:52 / cg"
!

validateModel:aModel forView:aView withValue:constantList
    "about to set the model.
     If it's a plain valueHolder, change the listMessage
     to #value"

    ^ self
        validateSelectionInListModel:aModel forView:aView withValue:constantList

    "Created: / 26-10-1997 / 19:12:24 / cg"
    "Modified (comment): / 13-02-2017 / 20:27:25 / cg"
! !

!NoteBookViewSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    canvasInset   notNil ifTrue:[canvasInset := canvasInset decodeAsLiteralArray].
    tabLabelInset notNil ifTrue:[tabLabelInset := tabLabelInset decodeAsLiteralArray].
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    canvas          isNil ifTrue:[l add:#canvas].
    canvasInset     isNil ifTrue:[l add:#canvasInset].
    tabLabelInset   isNil ifTrue:[l add:#tabLabelInset].
    tabLevel        isNil ifTrue:[l add:#tabLevel].
    tabBottomMargin isNil ifTrue:[l add:#tabBottomMargin].
    tabTopMargin    isNil ifTrue:[l add:#tabTopMargin].

    keepCanvasAlive ~~ true ifTrue:[l add:#keepCanvasAlive].
    ^ l

    "Modified: / 5.2.2000 / 03:08:17 / cg"
! !

!NoteBookViewSpec methodsFor:'parsing a view'!

fromView:aNoteBookView callBack:aBlock
    "extract attributes from aView"

    tabTopMargin    := aNoteBookView tabTopMargin.
    tabBottomMargin := aNoteBookView tabBottomMargin.
    canvasInset     := aNoteBookView canvasInset.
    tabLevel        := aNoteBookView tabLevel.
    tabLabelInset   := aNoteBookView tabLabelInset.

    super fromView:aNoteBookView callBack:aBlock.
! !

!NoteBookViewSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'NoteBook'

! !

!NoteBookViewSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    canvas notNil ifTrue:[more add:canvas].
    ^ more

    "Modified: / 10.2.2000 / 01:24:50 / cg"
! !

!NoteBookViewSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitNoteBookViewSpec:self
! !

!NoteBookViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/NoteBookViewSpec.st,v 1.63 2017-02-13 19:46:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/NoteBookViewSpec.st,v 1.63 2017-02-13 19:46:13 cg Exp $'
! !

