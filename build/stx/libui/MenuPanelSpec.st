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

MenuComponentSpec subclass:#MenuPanelSpec
	instanceVariableNames:'showSeparatingLines verticalLayout fitFirstPanel centerItems
		foregroundColor backgroundColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!MenuPanelSpec class methodsFor:'documentation'!

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

!MenuPanelSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'MenuPanelSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@,UUUUU01????>@G????8@_????"Q0@@@BBGE!!XVHD\^G!!8 A18^G"EGJ"(*H,\@@@@"A????>@G????8\_???? C*****H@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
! !

!MenuPanelSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MenuPanelSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'MenuPanel Basics'
         name: 'MenuPanel Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 153)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 152 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 16 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 5 0 5 1.0 27 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Selector:'
                   name: 'selectorLabel'
                   layout: (AlignmentOrigin 100 0 41 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'menuField'
                   layout: (LayoutFrame 100 0 30 0 5 1.0 52 0)
                   activeHelpKey: menuId
                   tabable: true
                   model: menuSelector
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Performer:'
                   name: 'performerLabel'
                   layout: (AlignmentOrigin 100 0 66 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'performerField'
                   layout: (LayoutFrame 100 0 55 0 5 1.0 77 0)
                   activeHelpKey: menuPerformer
                   tabable: true
                   model: performer
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (ActionButtonSpec
                   label: 'Menu Editor'
                   name: 'menuButton'
                   layout: (LayoutFrame 100 0 82 0 5 1 106 0)
                   activeHelpKey: menuButton
                   translateLabel: true
                   tabable: true
                   model: openEditMenu
                 )
                )
              
             )
           )
          )
        
       )
     )
!

channelsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MenuPanelSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'NamedSpec Channels'
         name: 'NamedSpec Channels'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 413 222)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 155 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'VisibilityChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 6 0.0 4 1.0 31 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'EnableChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 32 0.0 4 1.0 57 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                (UISubSpecification
                   name: 'FGColorChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 60 0.0 4 1.0 85 0)
                   majorKey: UISpecification
                   minorKey: subSpecForFGColorChannel
                 )
                (UISubSpecification
                   name: 'BGColorChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 87 0.0 4 1.0 112 0)
                   majorKey: UISpecification
                   minorKey: subSpecForBGColorChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'CallBacks'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 155 0 0 1.0 220 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 28 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
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
     UIPainter new openOnClass:MenuPanelSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'MenuPanel Details'
         name: 'MenuPanel Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 413 336)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'fontColorSubSpec'
             layout: (LayoutFrame 0 0 0 0 0 1 135 0)
             minorKey: fontColorSubSpec
           )
          (FramedBoxSpec
             label: 'Menu Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 135 0.0 0 1.0 253 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Level:'
                   name: 'levelLabel'
                   layout: (AlignmentOrigin 210 0 10 0 1 0.5)
                   activeHelpKey: level
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'levelField'
                   layout: (LayoutFrame 213 0 -1 0 -86 1 21 0)
                   activeHelpKey: level
                   tabable: true
                   model: level
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Vertical Orientation'
                   name: 'verticalLayoutCheckBox'
                   layout: (LayoutFrame 10 0 25 0 175 0 50 0)
                   activeHelpKey: verticalLayout
                   tabable: true
                   model: verticalLayout
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Show Separating Lines'
                   name: 'showSeparatingLinesCheckBox'
                   layout: (LayoutOrigin 10 0 50 0)
                   activeHelpKey: showSeparatingLines
                   tabable: true
                   model: showSeparatingLines
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Center Icons'
                   name: 'centerItems'
                   layout: (LayoutFrame 227 0 25 0 346 0 50 0)
                   activeHelpKey: centerIcons
                   enableChannel: verticalLayout
                   tabable: true
                   model: centerItems
                   translateLabel: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 257 0.0 0 1.0 324 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'canTabCheckBox'
                   layout: (LayoutOrigin 10 0 1 0)
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

!MenuPanelSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(
                        foregroundColor
                        backgroundColor
                        showSeparatingLines
                        verticalLayout
                        fitFirstPanel
                        centerItems
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(
                        foregroundChannel
                        backgroundChannel
                        menuSelector
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    "Modified: / 26.10.1997 / 03:33:07 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec) 
            (Channels channelsEditSpec)
       )

! !

!MenuPanelSpec class methodsFor:'menu specs-gallery'!

galleryMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuPanelSpec andSelector:#galleryMenu
     (Menu new fromLiteralArrayEncoding:(MenuPanelSpec galleryMenu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'newImage'
                #isButton: true
                #value: #newImage
                #activeHelpKey: #fileNewImage
                #labelImage: #(#ResourceRetriever #Icon #newIcon)
            )
             #(#MenuItem
                #label: 'loadFromClass'
                #isButton: true
                #value: #loadFromClass
                #activeHelpKey: #fileLoadFromClass
                #labelImage: #(#ResourceRetriever #Icon #loadIcon)
            )
             #(#MenuItem
                #label: 'saveMethod'
                #isButton: true
                #value: #saveMethod
                #activeHelpKey: #fileSaveMethod
                #enabled: #imageIsLoaded
                #labelImage: #(#ResourceRetriever #Icon #saveIcon)
            )
          ) nil
          nil
      )
!

galleryMenuText
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuPanelSpec andSelector:#galleryMenuText
     (Menu new fromLiteralArrayEncoding:(MenuPanelSpec galleryMenuText)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'About'
                #translateLabel: true
            )
             #(#MenuItem
                #label: 'File'
                #translateLabel: true
                #activeHelpKey: #fileNewImage
            )
             #(#MenuItem
                #label: '...'
                #translateLabel: true
                #activeHelpKey: #fileLoadFromClass
            )
          ) nil
          nil
      )

    "Modified: / 6.6.1998 / 16:48:04 / cg"
! !

!MenuPanelSpec class methodsFor:'queries'!

supportsLabel
    "answer whether corresponding view instances of the spec class can have labels"

    ^ false


! !

!MenuPanelSpec methodsFor:'accessing'!

centerItems
    ^ centerItems ? false
!

centerItems:aBoolean
    centerItems := aBoolean.
!

fitFirstPanel
    "return the value of the instance variable 'fitFirstPanel' (automatically generated)"

    ^ fitFirstPanel ? true
!

fitFirstPanel:aBoolean
    "set the value of the instance variable 'fitFirstPanel' (automatically generated)"

    fitFirstPanel := aBoolean.
!

showSeparatingLines
    "return the value of the instance variable 'showSeparatingLines' (automatically generated)"

    ^ showSeparatingLines ? false
!

showSeparatingLines:aBoolean
    "set the value of the instance variable 'showSeparatingLines' (automatically generated)"

    showSeparatingLines := aBoolean.
!

textDefault
    ^ self otherAttributeAt:#textDefault

    "Created: / 6.6.1998 / 16:34:22 / cg"
!

textDefault:aBoolean
    self otherAttributeAt:#textDefault put:aBoolean

    "Created: / 6.6.1998 / 16:34:17 / cg"
!

verticalLayout
    "return the value of the instance variable 'verticalLayout' (automatically generated)"

    ^ verticalLayout ? false
!

verticalLayout:aBoolean
    "set the value of the instance variable 'verticalLayout' (automatically generated)"

    verticalLayout := aBoolean
! !

!MenuPanelSpec methodsFor:'accessing-color & font'!

backgroundColor
    ^ backgroundColor
!

backgroundColor:something
    backgroundColor := something.
!

foregroundColor
    ^ foregroundColor
!

foregroundColor:something
    foregroundColor := something.
! !

!MenuPanelSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |m a appl aspects val|

    super setAttributesIn:aView with:aBuilder.

    foregroundColor notNil ifTrue: [
        aView foregroundColor:(self resolveColor:foregroundColor ifUnknown:[Color red] with:aBuilder)]
    ifFalse:[
        aBuilder isEditing ifTrue: [
            aView foregroundColor: Color black
        ]
    ].
    backgroundColor notNil ifTrue: [
        aView backgroundColor:(self resolveColor:backgroundColor ifUnknown:[Color red] with:aBuilder)
    ] ifFalse:[
        aBuilder isEditing ifTrue: [
            aView backgroundColor: self viewClass defaultViewBackgroundColor
        ]
    ].

    aView verticalLayout:(self verticalLayout).
    aView showSeparatingLines:(self showSeparatingLines).
    aView fitFirstPanel:(self fitFirstPanel).
    aView centerItems:(self centerItems).

    menu class == Menu ifTrue:[
        aView menu:menu.
        menu := nil.
      ^ self
    ].
    aBuilder isEditing ifTrue:[
        aBuilder showDefaults ifTrue:[
            aView menu:(((self textDefault) == true) ifTrue:[
                            self class galleryMenu
                       ] ifFalse:[
                            self class galleryMenuText
                       ]).
            ^ self
        ].
        (m := aBuilder menuFor:menu) isCollection ifFalse:[^ self].
        a  := Menu new.
        (m := a fromLiteralArrayEncoding:m) isNil  ifTrue:[^ self].

        a  := Menu new.
        aspects := IdentityDictionary new.

        m itemsDo:[:anItem||sym mod|
            anItem findGuiResourcesIn:aBuilder applicationClass.

            (sym := anItem choice) isSymbol ifTrue:[
                (mod := aspects at:sym ifAbsent:nil) isNil ifTrue:[
                    aspects at:sym put:(mod := ValueHolder with:true)
                ].
                anItem choice:mod
            ].

            a addItem:anItem
        ].
        ^ aView menu:a
    ].

    (appl := aBuilder application) isNil ifTrue:[
        ^ self
    ].

    menu notNil ifTrue:[
        m := aBuilder menuFor:menu.

        m isNil ifTrue:[
            m := self getBindingIn:aBuilder binding:menu.
        ].

        (val := m value) notNil ifTrue:[
            val isCollection ifFalse:[
                val findGuiResourcesIn:appl
            ] ifTrue:[
                (val isKindOf:Model) ifFalse:[
                    a := Menu new.
                    m := a fromLiteralArrayEncoding:val.
                    m findGuiResourcesIn:appl.
                ]
            ]
        ].

        (m isKindOf:Model) ifTrue:[
            aView menuHolder:m
        ] ifFalse:[
            aView menu:m
        ].
        self setMenuPerformerIn:menu forView:aView with:aBuilder.
    ]

    "Modified: / 6.6.1998 / 17:05:11 / cg"
! !

!MenuPanelSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    self showSeparatingLines ~~ true  ifTrue:[l add:#showSeparatingLines].
    self verticalLayout      ~~ true  ifTrue:[l add:#verticalLayout].
    self fitFirstPanel       ~~ false ifTrue:[l add:#fitFirstPanel].
    self centerItems         ~~ true  ifTrue:[l add:#centerItems].
    foregroundColor   isNil           ifTrue:[l add:#foregroundColor].
    backgroundColor   isNil           ifTrue:[l add:#backgroundColor].

  ^ l

    "Modified: / 20.6.1998 / 13:41:14 / cg"
! !

!MenuPanelSpec methodsFor:'parsing a view'!

fromView:aMenuPanel callBack:aBlock
    "extract attributes from aView"

    (aMenuPanel isKindOf:PullDownMenu) ifFalse:[
        verticalLayout      := aMenuPanel verticalLayout.
        showSeparatingLines := aMenuPanel showSeparatingLines.
        fitFirstPanel       := aMenuPanel fitFirstPanel.
        centerItems         := aMenuPanel centerItems.
    ] ifTrue:[
        fitFirstPanel := false.
    ].
    menu := aMenuPanel asMenu.
    super fromView:aMenuPanel callBack:aBlock.
! !

!MenuPanelSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'ToolBar'

! !

!MenuPanelSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitMenuPanelSpec:self
! !

!MenuPanelSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/MenuPanelSpec.st,v 1.64 2017-11-28 18:21:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/MenuPanelSpec.st,v 1.64 2017-11-28 18:21:37 cg Exp $'
! !

