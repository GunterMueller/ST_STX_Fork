"
 COPYRIGHT (c) 1995 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#UILayoutTool
	instanceVariableNames:'modifiedHolder aspects selection currentTool layoutView tabList
		layoutSpec toolsDictionary'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-UIPainter'
!

ApplicationModel subclass:#AnyLayout
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:UILayoutTool
!

UILayoutTool::AnyLayout subclass:#AlignmentOrigin
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:UILayoutTool
!

UILayoutTool::AnyLayout subclass:#Extent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:UILayoutTool
!

UILayoutTool::AnyLayout subclass:#LayoutFrame
	instanceVariableNames:''
	classVariableNames:'DefaultFixPartHeight'
	poolDictionaries:''
	privateIn:UILayoutTool
!

UILayoutTool::AnyLayout subclass:#LayoutOrigin
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:UILayoutTool
!

UILayoutTool::AnyLayout subclass:#Point
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:UILayoutTool
!

UILayoutTool::AnyLayout subclass:#Rectangle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:UILayoutTool
!

!UILayoutTool class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by eXept Software AG
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
    used by the UIPainter to manipulate the layout of the selected component

    [author:]
        Claus Atzkern

    [see also:]
        UIPainter
        UIHelpTool
        UISpecificationTool
"


! !

!UILayoutTool class methodsFor:'constants'!

label
    ^ 'Layout'
! !

!UILayoutTool class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:UILayoutTool    
    "

    <resource: #help>

    ^super helpSpec addPairsFrom:#(

#cornerX
'Absolute corner x of the selected widget.'

#cornerY
'Absolute corner y of the selected widget.'

#layoutTool
'Tool to set the layout of the selected widget.'

#leftAbsolute
'Offset of the left edge; positive is to the right, negative to the left.'

#leftRelative
'Relative origin x of the selected widget.'

#makeLeftAbsolute
'Compute pure-absolute x'

#makeLeftRelative
'Compute pure-fractional x.'

#makeLeftRelativeFromRight
'Compute fraction+offset for x relative to containers right.'

#makeTopAbsolute
'Compute pure-absolute y.'

#makeTopRelative
'Compute pure-fractional y.'

#makeTopRelativeFromBottom
'Compute fraction+offset for y relative to containers bottom.'

#originX
'Absolute origin x of the selected widget.'

#originY
'Absolute origin y of the selected widget.'

#topAbsolute
'Offset of the top edge; positive is to the bottom, negative to the top.'

#topRelative
'Relative origin y of the selected widget.'

)
! !

!UILayoutTool class methodsFor:'interface specs'!

layoutOriginSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UILayoutTool andSelector:#layoutOriginSpec
     UILayoutTool new openInterface:#layoutOriginSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: layoutOriginSpec
       window: 
      (WindowSpec
         label: 'UILayoutTool'
         name: 'UILayoutTool'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 345 107)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Origin'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 108 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Relative:'
                   name: 'labelRelative'
                   layout: (Point 103 3)
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Offset:'
                   name: 'labelAbsolute'
                   layout: (Point 203 3)
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Left:'
                   name: 'labelLeft'
                   layout: (AlignmentOrigin 68 0 24 0 1 0)
                   translateLabel: true
                 )
                (ActionButtonSpec
                   label: 'imageFractX'
                   name: 'actionRelativeLeft'
                   layout: (LayoutFrame 77 0 21 0 99 0 43 0)
                   activeHelpKey: makeLeftRelative
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: relativeLeft
                 )
                (InputFieldSpec
                   name: 'fieldLeftFraction'
                   layout: (LayoutFrame 102 0 22 0 152 0 44 0)
                   activeHelpKey: leftRelative
                   tabable: true
                   model: leftFraction
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: 'imageAbsX'
                   name: 'actionAbsoluteLeft'
                   layout: (LayoutFrame 178 0 21 0 200 0 43 0)
                   activeHelpKey: makeLeftAbsolute
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: absoluteLeft
                 )
                (InputFieldSpec
                   name: 'fieldLeftOffset'
                   layout: (LayoutFrame 203 0 21 0 253 0 43 0)
                   activeHelpKey: leftAbsolute
                   tabable: true
                   model: leftOffset
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: 'imageAbsXFromRight'
                   name: 'actionRightRelativeLeft'
                   layout: (LayoutFrame 257 0 21 0 279 0 43 0)
                   activeHelpKey: makeLeftRelativeFromRight
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: rightRelativeLeft
                 )
                (LabelSpec
                   label: 'Top:'
                   name: 'labelTop'
                   layout: (AlignmentOrigin 68 0 51 0 1 0)
                   translateLabel: true
                 )
                (ActionButtonSpec
                   label: 'imageFractY'
                   name: 'actionRelativeTop'
                   layout: (LayoutFrame 77 0 48 0 99 0 70 0)
                   activeHelpKey: makeTopRelative
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: relativeTop
                 )
                (InputFieldSpec
                   name: 'fieldTopFraction'
                   layout: (LayoutFrame 103 0 48 0 153 0 70 0)
                   activeHelpKey: topRelative
                   tabable: true
                   model: topFraction
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: 'imageAbsY'
                   name: 'actionAbsoluteTop'
                   layout: (LayoutFrame 178 0 48 0 200 0 70 0)
                   activeHelpKey: makeTopAbsolute
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: absoluteTop
                 )
                (InputFieldSpec
                   name: 'fieldTopOffset'
                   layout: (LayoutFrame 203 0 48 0 253 0 70 0)
                   activeHelpKey: topAbsolute
                   tabable: true
                   model: topOffset
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: 'imageAbsYFromBottom'
                   name: 'actionBottomRelativeTop'
                   layout: (LayoutFrame 257 0 48 0 279 0 70 0)
                   activeHelpKey: makeTopRelativeFromBottom
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: bottomRelativeTop
                 )
                )
              
             )
           )
          )
        
       )
     )
!

layoutPointSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UILayoutTool andSelector:#layoutPointSpec
     UILayoutTool new openInterface:#layoutPointSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: layoutPointSpec
       window: 
      (WindowSpec
         label: 'UILayoutTool'
         name: 'UILayoutTool'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 278 124)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Origin'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 94 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Left:'
                   name: 'labelOriginY'
                   layout: (AlignmentOrigin 83 0 12 0 1 0)
                   translateLabel: true
                 )
                (InputFieldSpec
                   name: 'fieldOriginX'
                   layout: (LayoutFrame 85 0 9 0 135 0 31 0)
                   activeHelpKey: originX
                   tabable: true
                   model: leftOffset
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Top:'
                   name: 'labelOriginX'
                   layout: (AlignmentOrigin 83 0 37 0 1 0)
                   translateLabel: true
                 )
                (InputFieldSpec
                   name: 'fieldOriginY'
                   layout: (LayoutFrame 85 0 34 0 135 0 56 0)
                   activeHelpKey: originY
                   tabable: true
                   model: topOffset
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

slices
    ^ #(
        ( 'Frame'          LayoutFrame)
        ( 'Origin'         LayoutOrigin)
        ( 'Alig.Origin'    AlignmentOrigin)
        ( 'Point'          Point)
        ( 'Rectangle'      Rectangle)
        ( 'Extent'         Extent)
       ) 

!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UILayoutTool andSelector:#windowSpec
     UILayoutTool new openInterface:#windowSpec
     UILayoutTool open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'UILayoutTool'
          name: 'UILayoutTool'
          min: (Point 10 10)
          bounds: (Rectangle 12 22 354 321)
        )
        component: 
       (SpecCollection
          collection: (
           (NoteBookViewSpec
              name: 'NoteBook'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              activeHelpKey: layoutTool
              enableChannel: enableChannel
              tabable: true
              model: noteBookModel
              menu: noteBookList
              direction: bottom
              translateLabel: true
              canvas: layoutCanvasHolder
              tabTopMargin: 0
              tabBottomMargin: 0
              keepCanvasAlive: true
              tabLevel: 0
            )
           )
         
        )
      )
! !

!UILayoutTool class methodsFor:'resources'!

classResources
    "my translations are found in the UIPainter classes resources"

    ^ UIPainter classResources 
! !

!UILayoutTool methodsFor:'accessing'!

acceptChannel
    "return the value of the instance variable 'acceptChannel' (automatically generated)"

    ^ masterApplication acceptChannel
!

layout
    "returns configued layout or nil
    "
    ^ currentTool notNil ifTrue:[currentTool layout]
                        ifFalse:[nil]
!

layoutType
    "returns current layout type or nil
    "
    |slice|

    (slice := self selectedSlice) notNil ifTrue:[
        ^ slice last
    ].
  ^ nil
!

layoutView
    "returns current edited view
    "
    ^ layoutView
!

layoutView:aView type:aTypeOrNil spec:aSpec
    "change current edited view
    "
    |type name list|

    layoutView := aView.
    layoutSpec := aSpec.

    (self aspectFor:#defaultExtentEnabled) value:(aSpec class ==  WindowSpec) not.

    aTypeOrNil notNil ifTrue:[ 
        self class slices findFirst:[:e|
            e last == aTypeOrNil 
                ifTrue:[name := e first. true] 
                ifFalse:[false].
        ].
        list := Array with:name with: 'Frame'.
    ] ifFalse:[
        (type := UIPainterView layoutType:layoutView) notNil ifTrue:[
            self class slices findFirst:[:e|
                e last == type ifTrue:[name := e first. true] ifFalse:[false]
            ].
            list := tabList.
            type == #Extent ifTrue:[ 
                aView superView specClass isLayoutContainer ifTrue:[
                    list := Array with:name
                ] ifFalse:[
                    list := list copyWith:name
                ]
            ]
        ]
    ].
    self noteBookList  value:list.
    self noteBookModel value:name.
    self update.
!

modifiedHolder:aValueHolder
    "set the value holder set to true in case of modifying attributes
    "
    modifiedHolder notNil ifTrue:[
        modifiedHolder removeDependent:self. 
    ].

    (modifiedHolder := aValueHolder) notNil ifTrue:[
        modifiedHolder addDependent:self.
    ].

!

update
    "update from view
    "
    |view|

    (selection notNil and:[currentTool notNil]) ifTrue:[
        (view := layoutView) notNil ifTrue:[
            currentTool fetch:view spec:layoutSpec
        ]
    ].
        
! !

!UILayoutTool methodsFor:'aspects'!

aspectFor:aKey
    "returns the aspect for a aKey or nil"

    ^ aspects at:aKey ifAbsent:[ super aspectFor:aKey ]
!

layoutCanvasHolder
    |holder|

    (holder := builder bindingAt:#layoutCanvasHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#layoutCanvasHolder put:holder
    ].
  ^ holder
!

notUsingDefaultExtent
    |holder|

    (holder := builder bindingAt:#notUsingDefaultExtent) isNil ifTrue:[
        holder := BlockValue forLogicalNot:(self aspectFor:#useDefaultExtent).
        builder aspectAt:#notUsingDefaultExtent put:holder.
    ].
    ^ holder

!

noteBookList
    "holds the list of tab labels"

    ^ builder valueAspectFor:#noteBookList initialValue:nil
!

noteBookModel
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#noteBookModel) isNil ifTrue:[
        holder := AspectAdaptor new subject:self; forAspect:#selection.
        builder aspectAt:#noteBookModel put:holder.
    ].
    ^ holder
! !

!UILayoutTool methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "one of my models changed its value
    "
    changedObject ~~ modifiedHolder ifTrue:[
        modifiedHolder value ~~ true ifTrue:[
            modifiedHolder isNil ifFalse:[
                modifiedHolder value:true
            ]
        ]
    ]

! !

!UILayoutTool methodsFor:'converting absolute'!

absolute:what xOrY:xOrY
    "compute what as absolute (i.e. fraction=0, offset >= 0)"

    |extent fraction offset fractSymb offsetSymb 
     newOffset newFraction fractHolder offsetHolder|

    extent     := (self layoutView superView computeExtent) perform:xOrY.
    fractSymb  := (what, 'Fraction') asSymbol.
    offsetSymb := (what,   'Offset') asSymbol.
    fractHolder := (self aspectFor:fractSymb).
    offsetHolder := (self aspectFor:offsetSymb).
    fraction   := fractHolder  value.
    offset     := offsetHolder value.

    newOffset := offset + ((fraction * extent) asInteger).
    newFraction := 0.

    fractHolder  value:newFraction.
    offsetHolder value:newOffset.
!

absoluteBottom
    "compute bottom as absolute (i.e. fraction=0, offset >= 0)"

    self absolute:'bottom' xOrY:#y

!

absoluteLeft
    "compute left as absolute (i.e. fraction=0, offset >= 0)"

    self absolute:'left' xOrY:#x

!

absoluteRight
    "compute right as absolute (i.e. fraction=0, offset >= 0)"

    self absolute:'right' xOrY:#x

!

absoluteTop
    "compute top as absolute (i.e. fraction=0, offset >= 0)"

    self absolute:'top' xOrY:#y

! !

!UILayoutTool methodsFor:'converting absolute from corner'!

bottomRelativeBottom
    "compute bottom relative to containers bottom (fraction=1, offset negative)"

    self cornerRelative:'bottom' xOrY:#y

!

bottomRelativeTop
    "compute top relative to containers bottom (fraction=1, offset negative)"

    self cornerRelative:'top' xOrY:#y

!

cornerRelative:what xOrY:xOrY
    "compute what relative to the corner (i.e. fraction=1, offset negative)"

    |extent fraction offset fractSymb offsetSymb 
     newFraction newOffset fractHolder offsetHolder|

    extent     := (self layoutView superView computeExtent) perform:xOrY.
    fractSymb  := (what, 'Fraction') asSymbol.
    offsetSymb := (what,   'Offset') asSymbol.
    fractHolder := (self aspectFor:fractSymb).
    offsetHolder := (self aspectFor:offsetSymb).
    fraction   := fractHolder  value.
    offset     := offsetHolder value.

    newOffset := offset + ((fraction * extent) asInteger).
    newOffset := newOffset - extent.
    newFraction := 1.

    fractHolder  value:newFraction.
    offsetHolder value:newOffset.



!

rightRelativeLeft
    "compute left relative to containers right (fraction=1, offset negative)"

    self cornerRelative:'left' xOrY:#x

!

rightRelativeRight
    "compute right relative to containers right (fraction=1, offset negative)"

    self cornerRelative:'right' xOrY:#x

! !

!UILayoutTool methodsFor:'converting relative'!

relative:what xOrY:xOrY
    "compute what relative to the origin (i.e. fraction=0..1, offset 0)"

    |extent fraction offset fractSymb offsetSymb 
     newFraction newOffset
     fractHolder offsetHolder|

    extent     := (self layoutView superView computeExtent) perform:xOrY.
    fractSymb  := (what, 'Fraction') asSymbol.
    offsetSymb := (what,   'Offset') asSymbol.
    fractHolder := (self aspectFor:fractSymb).
    offsetHolder := (self aspectFor:offsetSymb).
    fraction   := fractHolder  value.
    offset     := offsetHolder value.

    newFraction   := (fraction + (offset / extent)) asFloat.
    newOffset := 0.

    (newFraction > 1.0) ifTrue:[newFraction := 1.0].
    (newFraction < 0.0) ifTrue:[newFraction := 0].

    offsetHolder value:newOffset.
    fractHolder  value:newFraction.



!

relativeBottom
    "compute bottom relative to the origin (i.e. fraction=0..1, offset 0)"

    self relative:'bottom' xOrY:#y


!

relativeLeft
    "compute left relative to the origin (i.e. fraction=0..1, offset 0)"

    self relative:'left' xOrY:#x

!

relativeRight
    "compute right relative to the origin (i.e. fraction=0..1, offset 0)"

    self relative:'right' xOrY:#x

!

relativeTop
    "compute top relative to the origin (i.e. fraction=0..1, offset 0)"

    self relative:'top' xOrY:#y

! !

!UILayoutTool methodsFor:'initialization'!

initialize
    "initialize channels
    "
    |slices size|

    super initialize.

    aspects  := IdentityDictionary new.
    toolsDictionary := IdentityDictionary new.

    #(  bottomFraction          bottomOffset
        leftFraction            leftOffset
        topFraction             topOffset
        rightFraction           rightOffset
        leftAlignmentFraction   topAlignmentFraction
        (useDefaultExtent     false)
        (defaultExtentEnabled false)

        (usePreferredWidth false)
        (usePreferredHeight false)
        (useDynamicPreferredWidth false)
        (useDynamicPreferredHeight false)
        (keepSpaceForOSXResizeHandleV false)
        (keepSpaceForOSXResizeHandleH false)
    )

    do:[:aKeyOrPair| |holder key val|
        (key := aKeyOrPair) isSymbol ifFalse:[
            key := aKeyOrPair first.
            val := aKeyOrPair second
        ].
        holder := val asValue.
        holder addDependent:self.
        aspects at:key put:holder.
    ].

    slices  := self class slices.
    size    := slices size - 1.
    tabList := Array new:size.

    1 to:size do:[:i| tabList at:i put:((slices at:i) first) ].
! !

!UILayoutTool methodsFor:'selection'!

selectedSlice
    "returns the slice assigned to the selection or nil"

    selection isNil ifTrue:[^ nil].
    ^ self class slices detect:[:aSlice | aSlice first = selection] ifNone:nil

"/    selection notNil ifTrue:[
"/        self class slices do:[:aSlice|
"/            aSlice first = selection ifTrue:[
"/                ^ aSlice
"/            ]
"/        ]
"/    ].
"/    ^ nil
!

selection
    ^ selection
!

selection:aSelection
    |appl slice sel key view|

    aSelection isNumber ifTrue:[
        aSelection ~~ 0 ifTrue:[sel := tabList at:aSelection]
    ] ifFalse:[
        sel := aSelection
    ].

    selection = sel ifFalse:[
        (selection := sel) notNil ifTrue:[
            key := selection asSymbol.
            appl := toolsDictionary at:key ifAbsent:nil.

            appl isNil ifTrue:[
                view  := ApplicationSubView new.
                slice := self selectedSlice.
                appl  := slice last asString.
                appl := Smalltalk classNamed:(self class name asString, '::', appl).
                appl := appl new.
                appl masterApplication:self.
                appl createBuilder.
                view client:appl.
                appl window:view.
                toolsDictionary at:key put:appl.
            ] ifFalse:[
                view := appl window
            ].
            modifiedHolder value:true.
        ].
        currentTool := appl.
        self layoutCanvasHolder value:view.
    ].
    self update

    "Modified: / 4.2.2000 / 22:31:41 / cg"
! !

!UILayoutTool::AnyLayout class methodsFor:'image specs'!

imageAbsX
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageAbsX inspect
     ImageEditor openOnClass:self andSelector:#imageAbsX
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::AnyLayout class imageAbsX'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
<@BP@I@N$L*P*)BZ''8*@@(@B''8*P&)B*$L*PC)@@<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'<@C0@O@N<L;0;/C>??;??/?>??;0?/C.<L;0C/@@<@@b');
                            yourself);
                yourself
        ]
!

imageAbsXFromRight
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageAbsXFromRight inspect
     ImageEditor openOnClass:self andSelector:#imageAbsXFromRight
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::AnyLayout class imageAbsXFromRight'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@<@BW@IT0%UBU$IT_%@@T@AT_%YBUTIT0%0BP@I@@<b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@<@C7@O\0=7C7<O_?=??7??_?=?C7\O\0=0C0@O@@<b');
                            yourself);
                yourself
        ]
!

imageAbsY
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageAbsY inspect
     ImageEditor openOnClass:self andSelector:#imageAbsY
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::AnyLayout class imageAbsY'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'??>@@X@A?''<BP@I@@$@BPA98D@ HD@P O''0 AC?<@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??????????<C0@O@@<@C0A?8G? O<@_ O?0??C?<@@@b');
                            yourself);
                yourself
        ]
!

imageAbsYFromBottom
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageAbsYFromBottom inspect
     ImageEditor openOnClass:self andSelector:#imageAbsYFromBottom
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::AnyLayout class imageAbsYFromBottom'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@??B@DO''0DH@ PD@ ^^@I@@$@BP@I@?''>@@X@A??<b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@??C?<O?0G8@?0G? _>@O@@<@C0@O@??????????<b');
                            yourself);
                yourself
        ]
!

imageFractX
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFractX inspect
     ImageEditor openOnClass:self andSelector:#imageFractX
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::AnyLayout class imageFractX'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
<@>PBY@I&A&TJYII$X&@@X@A$X&RRYP)&A&PBY@I<@<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'<@?0C?@O>A?<O?9????????????>_?0?>A?0C?@O<@<b');
                            yourself);
                yourself
        ]
!

imageFractY
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFractY inspect
     ImageEditor openOnClass:self andSelector:#imageFractY
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::AnyLayout class imageFractY'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'??>@@X@A?''<PB@ PAB@BP@I@AB@HDA@H?''>@@X@A??<b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??????????<_>@?0A>@C0@O@A>@O<A?8??????????<b');
                            yourself);
                yourself
        ]
! !

!UILayoutTool::AnyLayout methodsFor:'accessing'!

aspectValueOr0For:aspectName
    "common helper - fetches the aspect value; if it is nil, return 0."

    ^ self aspectValueOr:0 for:aspectName
! !

!UILayoutTool::AlignmentOrigin class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:UILayoutTool::AlignmentOrigin    
    "

    <resource: #help>

    ^super helpSpec addPairsFrom:#(

#alignBottomCenter
'Aligns the widget''s bottomCenter to location.'

#alignBottomLeft
'Aligns the widget''s bottomLeft to location.'

#alignBottomRight
'Aligns the widget''s bottomRight to location.'

#alignCenter
'Aligns the widget''s center to location.'

#alignHorizontal
'Horizontal relative position of the alignment point of the widget (that point is aligned with the above origin).'

#alignLeftCenter
'Aligns the widget''s leftCenter to location.'

#alignRightCenter
'Aligns the widget''s rightCenter to location.'

#alignTopCenter
'Aligns the widget''s topCenter to location.'

#alignTopLeft
'Aligns the widget''s topLeft to location.'

#alignTopRight
'Aligns the widget''s topRight to location.'

#alignVertical
'Vertical relative position of the alignment point of the widget (that point is aligned with the above origin).'

)

    "Modified: / 28-07-2010 / 10:05:41 / cg"
! !

!UILayoutTool::AlignmentOrigin class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UILayoutTool::AlignmentOrigin andSelector:#windowSpec
     UILayoutTool::AlignmentOrigin new openInterface:#windowSpec
     UILayoutTool::AlignmentOrigin open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'UILayoutTool-AlignmentOrigin'
         name: 'UILayoutTool-AlignmentOrigin'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 405 220)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'layoutOriginSpec'
             layout: (LayoutFrame 1 0.0 6 0 0 1.0 111 0)
             majorKey: UILayoutTool
             minorKey: layoutOriginSpec
           )
          (FramedBoxSpec
             label: 'Alignment'
             name: 'FramedBox'
             layout: (LayoutFrame 1 0.0 113 0 0 1.0 215 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Horizontal:'
                   name: 'alignHLabel'
                   layout: (AlignmentOrigin 88 0 17 0 1 0)
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'leftAlignmentFractionField'
                   layout: (LayoutFrame 90 0 14 0 147 0 36 0)
                   activeHelpKey: alignHorizontal
                   tabable: true
                   model: leftAlignmentFraction
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Vertical:'
                   name: 'alignVLabel'
                   layout: (AlignmentOrigin 88 0 43 0 1 0)
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'topAlignmentFractionField'
                   layout: (LayoutFrame 90 0 40 0 147 0 62 0)
                   activeHelpKey: alignVertical
                   tabable: true
                   model: topAlignmentFraction
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (DividerSpec
                   name: 'separator1'
                   layout: (LayoutFrame 204 0 19 0 245 0 22 0)
                 )
                (DividerSpec
                   name: 'separator2'
                   layout: (LayoutFrame 204 0 55 0 245 0 58 0)
                 )
                (DividerSpec
                   name: 'separator3'
                   layout: (LayoutFrame 196 0 28 0 199 0 50 0)
                   orientation: vertical
                 )
                (DividerSpec
                   name: 'separator4'
                   layout: (LayoutFrame 250 0 28 0 253 0 50 0)
                   orientation: vertical
                 )
                (ActionButtonSpec
                   name: 'alignTopLeft'
                   layout: (LayoutFrame 190 0 14 0 204 0 28 0)
                   activeHelpKey: alignTopLeft
                   tabable: true
                   model: alignTopLeft
                 )
                (ActionButtonSpec
                   name: 'alignTopCenter'
                   layout: (LayoutFrame 217 0 14 0 231 0 28 0)
                   activeHelpKey: alignTopCenter
                   tabable: true
                   model: alignTopCenter
                 )
                (ActionButtonSpec
                   name: 'alignTopRight'
                   layout: (LayoutFrame 245 0 14 0 259 0 28 0)
                   activeHelpKey: alignTopRight
                   tabable: true
                   model: alignTopRight
                 )
                (ActionButtonSpec
                   name: 'alignLeftCenter'
                   layout: (LayoutFrame 190 0 32 0 204 0 46 0)
                   activeHelpKey: alignLeftCenter
                   tabable: true
                   model: alignLeftCenter
                 )
                (ActionButtonSpec
                   name: 'alignCenter'
                   layout: (LayoutFrame 217 0 32 0 231 0 46 0)
                   activeHelpKey: alignCenter
                   tabable: true
                   model: alignCenter
                 )
                (ActionButtonSpec
                   name: 'alignRightCenter'
                   layout: (LayoutFrame 245 0 32 0 259 0 46 0)
                   activeHelpKey: alignRightCenter
                   tabable: true
                   model: alignRightCenter
                 )
                (ActionButtonSpec
                   name: 'alignBottomLeft'
                   layout: (LayoutFrame 190 0 50 0 204 0 64 0)
                   activeHelpKey: alignBottomLeft
                   tabable: true
                   model: alignBottomLeft
                 )
                (ActionButtonSpec
                   name: 'alignBottomCenter'
                   layout: (LayoutFrame 217 0 50 0 231 0 64 0)
                   activeHelpKey: alignBottomCenter
                   tabable: true
                   model: alignBottomCenter
                 )
                (ActionButtonSpec
                   name: 'alignBottomRight'
                   layout: (LayoutFrame 245 0 50 0 259 0 64 0)
                   activeHelpKey: alignBottomRight
                   tabable: true
                   model: alignBottomRight
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!UILayoutTool::AlignmentOrigin methodsFor:'accessing'!

fetch:aView spec:aSpec
    "fetch alignmentOrigin
    "
    |layout type 
     leftAlignmentFractionHolder topAlignmentFractionHolder
     leftOffsetHolder leftFractionHolder topOffsetHolder topFractionHolder|

    type   := UIPainterView layoutType:aView.
    layout := aView geometryLayout.

    leftOffsetHolder := (self aspectFor:#leftOffset).
    leftFractionHolder := (self aspectFor:#leftFraction).
    topOffsetHolder := (self aspectFor:#topOffset).
    topFractionHolder := (self aspectFor:#topFraction).
    leftAlignmentFractionHolder := (self aspectFor:#leftAlignmentFraction).
    topAlignmentFractionHolder := (self aspectFor:#topAlignmentFraction).

    layout isLayout ifTrue:[
        leftOffsetHolder   value:(layout leftOffset).
        leftFractionHolder value:(layout leftFraction).
        topOffsetHolder    value:(layout topOffset).
        topFractionHolder  value:(layout topFraction).

        type == #AlignmentOrigin ifTrue:[
            leftAlignmentFractionHolder value:(layout leftAlignmentFraction).
            topAlignmentFractionHolder  value:(layout topAlignmentFraction).
          ^ self
        ]
    ] ifFalse:[
        layout := aView computeOrigin.

        leftOffsetHolder   value:(layout x).
        leftFractionHolder value:0.
        topOffsetHolder    value:(layout y).
        topFractionHolder  value:0.
    ].
    leftAlignmentFractionHolder value:0.
    topAlignmentFractionHolder  value:0.


!

layout
    "returns current layout as alignmentOrigin
    "
    |layout|

    layout  := (Smalltalk at:#AlignmentOrigin) new.

    layout 
        leftFraction:(self aspectValueOr0For:#leftFraction)
        offset:(self aspectValueOr0For:#leftOffset)
        topFraction:(self aspectValueOr0For:#topFraction)
        offset:(self aspectValueOr0For:#topOffset).

    layout 
        leftAlignmentFraction:(self aspectValueOr0For:#leftAlignmentFraction)
        topAlignmentFraction:(self aspectValueOr0For:#topAlignmentFraction).

  ^ layout
! !

!UILayoutTool::AlignmentOrigin methodsFor:'alignment'!

alignBottomCenter
    self makeAlignLeft:0.5 top:1


!

alignBottomLeft
    self makeAlignLeft:0 top:1


!

alignBottomRight
    self makeAlignLeft:1 top:1


!

alignCenter
    self makeAlignLeft:0.5 top:0.5


!

alignLeftCenter
    self makeAlignLeft:0 top:0.5


!

alignRightCenter
    self makeAlignLeft:1 top:0.5


!

alignTopCenter
    self makeAlignLeft:0.5 top:0


!

alignTopLeft
    self makeAlignLeft:0 top:0


!

alignTopRight
    self makeAlignLeft:1 top:0


!

makeAlignLeft:leftAlignmentFraction top:topAlignmentFraction
    |lAF tAF lO tO ext lAHolder tAHolder lOHolder tOHolder|

    lAF     := (lAHolder := self aspectFor:#leftAlignmentFraction) value ? 0.
    tAF     := (tAHolder := self aspectFor:#topAlignmentFraction)  value ? 0.
    ext     := (self aspectFor:#layoutView) computeExtent.

    lAHolder value:leftAlignmentFraction.
    tAHolder  value:topAlignmentFraction.

    lO := (lOHolder := self aspectFor:#leftOffset) value ? 0.
    tO := (tOHolder := self aspectFor:#topOffset)  value ? 0.

    lO := lO + (ext x * (leftAlignmentFraction - lAF)).
    tO := tO + (ext y * (topAlignmentFraction  - tAF)).

    lOHolder value:(lO rounded).
    tOHolder value:(tO rounded).

!

makeAlignTopRight
    self makeAlignLeft:1 top:0


! !

!UILayoutTool::Extent class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:UILayoutTool::Extent    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#hrzExtent
'Horizontal extent of the selected widget.'

#useDynamicPreferredWidth
'Dynamically adapt to any change of the widget''s preferred width'

#useDynamicPreferredHeight
'Dynamically adapt to any change of the widget''s preferred height'

#usePreferredHeight
'Use the widget''s preferred height as initial size'

#usePreferredWidth
'Use the widget''s preferred width as initial size'

#useDefaultExtent
'Use the widget''s default extent as initial size'

#vrtExtent
'Vertical extent of the selected widget.'

)
! !

!UILayoutTool::Extent class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UILayoutTool::Extent andSelector:#windowSpec
     UILayoutTool::Extent new openInterface:#windowSpec
     UILayoutTool::Extent open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'UILayoutTool-Extent'
         name: 'UILayoutTool-Extent'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 506 169)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Extent'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 158 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Width:'
                   name: 'labelWidth'
                   layout: (AlignmentOrigin 89 0 41 0 1 0.5)
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'fieldLeftOffset'
                   layout: (LayoutFrame 90 0 30 0 140 0 52 0)
                   activeHelpKey: hrzExtent
                   enableChannel: notUsingDefaultExtent
                   tabable: true
                   model: leftOffset
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Height:'
                   name: 'labelHeight'
                   layout: (AlignmentOrigin 89 0 66 0 1 0.5)
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'fieldRightOffset'
                   layout: (LayoutFrame 90 0 55 0 140 0 77 0)
                   activeHelpKey: vrtExtent
                   enableChannel: notUsingDefaultExtent
                   tabable: true
                   model: topOffset
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (CheckBoxSpec
                   label: 'Preferred'
                   name: 'CheckBox1'
                   layout: (LayoutFrame 169 0 30 0 275 0 52 0)
                   activeHelpKey: usePreferredWidth
                   model: usePreferredWidth
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Dynamic'
                   name: 'CheckBox3'
                   layout: (LayoutFrame 276 0 30 0 371 0 52 0)
                   activeHelpKey: useDynamicPreferredWidth
                   model: useDynamicPreferredWidth
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Preferred'
                   name: 'CheckBox2'
                   layout: (LayoutFrame 169 0 58 0 275 0 80 0)
                   activeHelpKey: usePreferredHeight
                   model: usePreferredHeight
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Dynamic'
                   name: 'CheckBox4'
                   layout: (LayoutFrame 276 0 58 0 372 0 80 0)
                   activeHelpKey: useDynamicPreferredHeight
                   model: useDynamicPreferredHeight
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Use Widget''s Default Extent'
                   name: 'useDefaultExtentCheckBox'
                   layout: (Point 5 84)
                   activeHelpKey: useDefaultExtent
                   enableChannel: defaultExtentEnabled
                   tabable: true
                   model: useDefaultExtent
                   translateLabel: true
                 )
                )
              
             )
           )
          (PopUpListSpec
             label: 'Common Extents'
             name: 'CommonExtentsPopUpList'
             layout: (LayoutFrame 189 0 21 0 314 0 43 0)
             tabable: true
             menu: listOfCommonExtents
             useIndex: true
             ignoreReselect: false
             stateChangeCallBackSelector: commonExtentSelected:
           )
          )
        
       )
     )
! !

!UILayoutTool::Extent methodsFor:'accessing'!

fetch:aView spec:aSpec
    "fetch the extent from aView"

    |extent|

    extent  := aView computeExtent.

    (self aspectFor:#leftOffset)  value:(extent x).
    (self aspectFor:#topOffset)   value:(extent y).
    aSpec notNil ifTrue:[
        (self aspectFor:#usePreferredWidth) value:(aSpec usePreferredWidth).
        (self aspectFor:#usePreferredHeight) value:(aSpec usePreferredHeight).
        (self aspectFor:#useDynamicPreferredWidth) value:(aSpec useDynamicPreferredWidth).
        (self aspectFor:#useDynamicPreferredHeight) value:(aSpec useDynamicPreferredHeight).
        (self aspectFor:#useDefaultExtent) value:aSpec useDefaultExtent 
    ].
!

layout
    "returns the current extent"

    ^ (self aspectValueOr0For:#leftOffset) @ (self aspectValueOr0For:#topOffset)
! !

!UILayoutTool::Extent methodsFor:'aspects'!

commonExtentsSpec
    ^ #( 
        ('200 x 100'  (200 100) ) 
        ('300 x 300'  (300 300) ) 
        ('640 x 400'  (640 400) ) 
        ('800 x 600'  (800 600) ) 
        ('1024 x 768'  (1024 768) ) 
        ('1200 x 800'  (1200 800) ) 
      )
!

listOfCommonExtents
    ^ self commonExtentsSpec collect:[:eachRow | eachRow first].
! !

!UILayoutTool::Extent methodsFor:'user actions'!

commonExtentSelected:index
    |xy x y|

    xy := (self commonExtentsSpec at:index) second. 
    x := xy at:1.
    y := xy at:2.

    (self aspectFor:#leftOffset)  value:x.
    (self aspectFor:#topOffset)   value:y.

    (builder componentAt:#CommonExtentsPopUpList) 
        label:(resources string:'Common Extents').
! !

!UILayoutTool::LayoutFrame class methodsFor:'defaults'!

defaultFixPartHeight
    ^ DefaultFixPartHeight ? 30
! !

!UILayoutTool::LayoutFrame class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:UILayoutTool::LayoutFrame    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#bigBottomFixPartLayout
'Set layout for a big fixed area at the bottom of the widgets container'

#bigHorizontalFixPartLayout
'Set layout for a big fixed-height area centered vertically in the widgets container'

#bigTopFixPartLayout
'Set layout for a big fixed area at the top of the widgets container'

#bottomAbsolute
'Offset of the bottom edge; positive is to the bottom, negative to the top.'

#bottomFixPartLayout
'Set layout for a small fixed area at the bottom of the widgets container'

#bottomHalfLayout
'Set layout for the bottom half of the widgets container'

#bottomLeftQuarterLayout
'Set layout for the bottom-left quarter of the widgets container'

#bottomRelative
'Relative corner y of the selected widget.'

#bottomRightQuarterLayout
'Set layout for the bottom-right quarter of the widgets container'

#fullLayout
'Set layout to fill all of the widgets container'

#horizontalFixPartLayout
'Set layout for a small fixed-height area centered vertically in the widgets container'

#keepSpaceForOSXResizeHandleH
'Keep space at the right for the window resize handle under MAXOS-X; ignored when running on other systems'

#keepSpaceForOSXResizeHandleV
'Keep space at the bottom for the window resize handle under MAXOS-X; ignored when running on other systems'

#leftFixPartLayout
'Set layout for a small fixed area at the left of the widgets container'

#leftHalfLayout
'Set layout for the left half of the widgets container'

#makeBottomAbsolute
'Compute pure-absolute y.'

#makeBottomRelative
'Compute pure-fractional y.'

#makeBottomRelativeFromBottom
'Compute fraction+offset for y relative to containers bottom.'

#makeRightAbsolute
'Compute pure-absolute x.'

#makeRightRelative
'Compute pure-fractional x.'

#makeRightRelativeFromRight
'Compute fraction+offset for x relative to containers right.'

#rightAbsolute
'Offset of the right edge; positive is to the right, negative to the left.'

#rightFixPartLayout
'Set layout for a small fixed area at the right of the widgets container'

#rightHalfLayout
'Set layout for the right half of the widgets container'

#rightRelative
'Relative corner x of the selected widget.'

#screenFrameLayout
''

#useDynamicPreferredWidth
'Dynamically adapt to any change of the widget''s preferred width'

#useDynamicPreferredHeight
'Dynamically adapt to any change of the widget''s preferred height'

#usePreferredHeight
'Use the widget''s preferred height as initial size'

#usePreferredWidth
'Use the widget''s preferred width as initial size'


#topFixPartLayout
'Set layout for a small fixed area at the top of the widgets container'

#topHalfLayout
'Set layout for the top half of the widgets container'

#topLeftQuarterLayout
'Set layout for the top-left quarter of the widgets container'

#topRightQuarterLayout
'Set layout for the top-right quarter of the widgets container'

#verticalFixPartLayout
'Set layout for a small fixed-width area centered horizontally in the widgets container'

)
! !

!UILayoutTool::LayoutFrame class methodsFor:'image specs'!

setBigBottomFixPartIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setBigBottomFixPartIcon inspect
     ImageEditor openOnClass:self andSelector:#setBigBottomFixPartIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'UILayoutTool::LayoutFrame class setBigBottomFixPartIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"H"H"H"H"@BDQDQDQDQH@HQDQDQDQD @!!DQDQDQDR@BDQDQDQDQH@HQ
DQDQDQD @!!DQDQDQDR@BDQDQDQDQH@H"H"H"H"H @@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??>A XFA XFA _????????????????????????????<b');
                            yourself);
                yourself
        ]
!

setBigHorizontalFixPartIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setBigHorizontalFixPartIcon inspect
     ImageEditor openOnClass:self andSelector:#setBigHorizontalFixPartIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'UILayoutTool::LayoutFrame class setBigHorizontalFixPartIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BH"H"H"H"H@HQDQDQDQD @!!DQDQDQDR@BDQDQDQDQH@HQDQDQDQD @!!DQDQDQDR@BDQDQDQDQH@H"
H"H"H"H @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??>A XFA??????????????????????????>A XFA??<b');
                            yourself);
                yourself
        ]
!

setBigTopFixPartIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setBigTopFixPartIcon inspect
     ImageEditor openOnClass:self andSelector:#setBigTopFixPartIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'UILayoutTool::LayoutFrame class setBigTopFixPartIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@BH"H"H"H"H@HQDQDQDQD @!!DQDQDQDR@BDQDQDQDQH@HQDQDQDQD @!!DQDQDQDR@BDQDQDQDQH@HQDQDQDQD @"H"H"H"H"@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'?????????????????????????????8FA XFA XFA??<b');
                            yourself);
                yourself
        ]
!

setBottomFixPartIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setBottomFixPartIcon inspect
     ImageEditor openOnClass:self andSelector:#setBottomFixPartIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'UILayoutTool::LayoutFrame class setBottomFixPartIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H"
H"@BH"H @!!DQD@DQDR@BDQDP@QDQH@H"H"@BH"H @@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??>@@X@A @F@@X@A @F@@X@A @G???????????????<b');
                            yourself);
                yourself
        ]
!

setBottomHalfIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setBottomHalfIcon inspect
     ImageEditor openOnClass:self andSelector:#setBottomHalfIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::LayoutFrame class setBottomHalfIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"H"H"H"H"@BDQDQDQDQH@HQ
DQDQDQD @!!DQDQDQDR@BDQDQDQDQH@H"H"H"H"H @@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??>@@X@A @F@@X@A @F@@_????????????????????<b');
                            yourself);
                yourself
        ]
!

setBottomLeftQuarterIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setBottomLeftQuarterIcon inspect
     ImageEditor openOnClass:self andSelector:#setBottomLeftQuarterIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'UILayoutTool::LayoutFrame class setBottomLeftQuarterIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H"H"@@@@@@@!!DQH@@@@@@BDQD @@@@@@HQ
DR@@@@@@@!!DQH@@@@@@BDQD @@@@@@H"H"@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??>@@X@A @F@@X@A @G?@_<A?0G?@_<A?0G?@_<A??<b');
                            yourself);
                yourself
        ]
!

setBottomRightQuarterIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setBottomRightQuarterIcon inspect
     ImageEditor openOnClass:self andSelector:#setBottomRightQuarterIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'UILayoutTool::LayoutFrame class setBottomRightQuarterIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BH"H"@@@@@@HQDQH@@@
@@@!!DQD @@@@@BDQDR@@@@@@HQDQH@@@@@@"H"H @@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??>@@X@A @F@@X@A @F@@XG? _>A?8G? _>A?8G???<b');
                            yourself);
                yourself
        ]
!

setFullIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setFullIcon inspect
     ImageEditor openOnClass:self andSelector:#setFullIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::LayoutFrame class setFullIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@BH"H"H"H"H@HQDQDQDQD @!!DQDQDQDR@BDQDQDQDQH@HQDQDQDQD @!!DQDQDQDR@BDQDQDQDQH@HQDQDQDQD @!!DQDQDQDR@BDQDQDQDQH@HQ
DQDQDQD @!!DQDQDQDR@BDQDQDQDQH@H"H"H"H"H @@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??????????????????????????????????????????<b');
                            yourself);
                yourself
        ]
!

setHorizontalFixPartIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setHorizontalFixPartIcon inspect
     ImageEditor openOnClass:self andSelector:#setHorizontalFixPartIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'UILayoutTool::LayoutFrame class setHorizontalFixPartIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"H"H@H"H"@BDQDP@QDQH@HQDQ@ADQD @"H"H@H"H"@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??>@@X@A @F@@_???????????????8@A @F@@X@A??<b');
                            yourself);
                yourself
        ]
!

setLeftFixPartIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setLeftFixPartIcon inspect
     ImageEditor openOnClass:self andSelector:#setLeftFixPartIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::LayoutFrame class setLeftFixPartIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@BH"@@@@@@@@HQH@@@@@@@@!!D @@@@@@@BDR@@@@@@@@HQH@@@@@@@@!!D @@@@@@@@@@@@@@@@@@@@@@@@@@@@@!!D @@@@@@@BDR@@@@@@@@HQ
H@@@@@@@@!!D @@@@@@@BDR@@@@@@@@H"H@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'???<@_0A?@G<@_0A?@G<@_0A?@G<@_0A?@G<@_0A??<b');
                            yourself);
                yourself
        ]
!

setLeftHalfIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setLeftHalfIcon inspect
     ImageEditor openOnClass:self andSelector:#setLeftHalfIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::LayoutFrame class setLeftHalfIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@BH"H @@@@@@HQDR@@@@@@@!!DQH@@@@@@BDQD @@@@@@HQDR@@@@@@@!!DQH@@@@@@BDQD @@@@@@HQDR@@@@@@@!!DQH@@@@@@BDQD @@@@@@HQ
DR@@@@@@@!!DQH@@@@@@BDQD @@@@@@H"H"@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'????@_<A?0G?@_<A?0G?@_<A?0G?@_<A?0G?@_<A??<b');
                            yourself);
                yourself
        ]
!

setRightFixPartIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setRightFixPartIcon inspect
     ImageEditor openOnClass:self andSelector:#setRightFixPartIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'UILayoutTool::LayoutFrame class setRightFixPartIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@H"H@@@@@@@@!!D @@@@@@@BDR@@@@@@@@HQH@@@@@@@@!!D @@@@@@@BDR@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BDR@@@@@@@@HQH@@@
@@@@@!!D @@@@@@@BDR@@@@@@@@HQH@@@@@@@@"H @@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??>@O8@? C>@O8@? C>@O8@? C>@O8@? C>@O8@???<b');
                            yourself);
                yourself
        ]
!

setRightHalfIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setRightHalfIcon inspect
     ImageEditor openOnClass:self andSelector:#setRightHalfIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::LayoutFrame class setRightHalfIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@"H"H@@@@@@BDQD @@@@@@HQDR@@@@@@@!!DQH@@@@@@BDQD @@@@@@HQDR@@@@@@@!!DQH@@@@@@BDQD @@@@@@HQDR@@@@@@@!!DQH@@@
@@@BDQD @@@@@@HQDR@@@@@@@!!DQH@@@@@@BH"H @@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??>@?8C? O>@?8C? O>@?8C? O>@?8C? O>@?8C???<b');
                            yourself);
                yourself
        ]
!

setToRightQuarterIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setToRightQuarterIcon inspect
     ImageEditor openOnClass:self andSelector:#setToRightQuarterIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'UILayoutTool::LayoutFrame class setToRightQuarterIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@"H"H@@@@@@BDQD @@@@@@HQDR@@@@@@@!!DQH@@@@@@BDQD @@@@@@HQDR@@@@@@@"H"H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??>@?8C? O>@?8C? O>@?8C? @F@@X@A @F@@X@A??<b');
                            yourself);
                yourself
        ]
!

setTopFixPartIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setTopFixPartIcon inspect
     ImageEditor openOnClass:self andSelector:#setTopFixPartIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::LayoutFrame class setTopFixPartIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@BH"H @"H"H@HQDQ@ADQD @!!DQD@DQDR@BH"H @"H"H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'???????????????? @F@@X@A @F@@X@A @F@@X@A??<b');
                            yourself);
                yourself
        ]
!

setTopHalfIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setTopHalfIcon inspect
     ImageEditor openOnClass:self andSelector:#setTopHalfIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UILayoutTool::LayoutFrame class setTopHalfIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@BH"H"H"H"H@HQDQDQDQD @!!DQDQDQDR@BDQDQDQDQH@HQDQDQDQD @"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'?????????????????????8@A @F@@X@A @F@@X@A??<b');
                            yourself);
                yourself
        ]
!

setTopLeftQuarterIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setTopLeftQuarterIcon inspect
     ImageEditor openOnClass:self andSelector:#setTopLeftQuarterIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'UILayoutTool::LayoutFrame class setTopLeftQuarterIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@BH"H"@@@@@@HQDQH@@@@@@!!DQD @@@@@BDQDR@@@@@@HQDQH@@@@@@"H"H @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'???? _>A?8G? _>A?8G? X@A @F@@X@A @F@@X@A??<b');
                            yourself);
                yourself
        ]
!

setVerticalFixPartIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self setVerticalFixPartIcon inspect
     ImageEditor openOnClass:self andSelector:#setVerticalFixPartIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'UILayoutTool::LayoutFrame class setVerticalFixPartIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@"H @@@@@@@BDR@@@@@@@@HQH@@@@@@@@!!D @@@@@@@BDR@@@@@@@@HQH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HQH@@@@@@@@!!D @@@@@@
@BDR@@@@@@@@HQH@@@@@@@@!!D @@@@@@@BH"@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??>G8X_!!!!>FG8X_!!!!>FG8X_!!!!>FG8X_!!!!>FG8X_!!??<b');
                            yourself);
                yourself
        ]
! !

!UILayoutTool::LayoutFrame class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UILayoutTool::LayoutFrame andSelector:#windowSpec
     UILayoutTool::LayoutFrame new openInterface:#windowSpec
     UILayoutTool::LayoutFrame open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'UILayoutTool-LayoutFrame'
         name: 'UILayoutTool-LayoutFrame'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 527 393)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'layoutOriginSpec'
             layout: (LayoutFrame 1 0.0 6 0 0 1.0 112 0)
             majorKey: UILayoutTool
             minorKey: layoutOriginSpec
           )
          (FramedBoxSpec
             label: 'Corner'
             name: 'FramedBox'
             layout: (LayoutFrame 1 0.0 113 0 0 1.0 266 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Right:'
                   name: 'labelRight'
                   layout: (AlignmentOrigin 68 0 16 0 1 0)
                   translateLabel: true
                 )
                (ActionButtonSpec
                   label: 'imageFractX'
                   name: 'actionRelativeRight'
                   layout: (LayoutFrame 78 0 14 0 100 0 36 0)
                   activeHelpKey: makeRightRelative
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: relativeRight
                 )
                (InputFieldSpec
                   name: 'fieldRightFraction'
                   layout: (LayoutFrame 103 0 14 0 153 0 36 0)
                   activeHelpKey: rightRelative
                   tabable: true
                   model: rightFraction
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: 'imageAbsX'
                   name: 'actionAbsoluteRight'
                   layout: (LayoutFrame 178 0 14 0 200 0 36 0)
                   activeHelpKey: makeRightAbsolute
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: absoluteRight
                 )
                (InputFieldSpec
                   name: 'fieldRightOffset'
                   layout: (LayoutFrame 203 0 14 0 253 0 36 0)
                   activeHelpKey: rightAbsolute
                   tabable: true
                   model: rightOffset
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: 'imageAbsXFromRight'
                   name: 'actionRightRelativeRight'
                   layout: (LayoutFrame 257 0 14 0 279 0 36 0)
                   activeHelpKey: makeRightRelativeFromRight
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: rightRelativeRight
                 )
                (LabelSpec
                   label: 'Bottom:'
                   name: 'labelBottom'
                   layout: (AlignmentOrigin 68 0 44 0 1 0)
                   translateLabel: true
                 )
                (ActionButtonSpec
                   label: 'imageFractY'
                   name: 'actionRelativeBottom'
                   layout: (LayoutFrame 78 0 42 0 100 0 64 0)
                   activeHelpKey: makeBottomRelative
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: relativeBottom
                 )
                (InputFieldSpec
                   name: 'fieldBottomFraction'
                   layout: (LayoutFrame 103 0 42 0 153 0 64 0)
                   activeHelpKey: bottomRelative
                   tabable: true
                   model: bottomFraction
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: 'imageAbsY'
                   name: 'actionAbsoluteBottom'
                   layout: (LayoutFrame 178 0 42 0 200 0 64 0)
                   activeHelpKey: makeBottomAbsolute
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: absoluteBottom
                 )
                (InputFieldSpec
                   name: 'fieldBottomOffset'
                   layout: (LayoutFrame 203 0 42 0 253 0 64 0)
                   activeHelpKey: bottomAbsolute
                   tabable: true
                   model: bottomOffset
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: 'imageAbsYFromBottom'
                   name: 'actionBottomRelativeBottom'
                   layout: (LayoutFrame 257 0 42 0 279 0 64 0)
                   activeHelpKey: makeBottomRelativeFromBottom
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   tabable: true
                   model: bottomRelativeBottom
                 )
                (CheckBoxSpec
                   label: 'Preferred'
                   name: 'CheckBox1'
                   layout: (LayoutFrame 287 0 14 0 393 0 36 0)
                   activeHelpKey: usePreferredWidth
                   model: usePreferredWidth
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Dynamic'
                   name: 'CheckBox3'
                   layout: (LayoutFrame 394 0 14 0 481 0 36 0)
                   activeHelpKey: useDynamicPreferredWidth
                   model: useDynamicPreferredWidth
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Preferred'
                   name: 'CheckBox2'
                   layout: (LayoutFrame 287 0 40 0 393 0 62 0)
                   activeHelpKey: usePreferredHeight
                   model: usePreferredHeight
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Dynamic'
                   name: 'CheckBox4'
                   layout: (LayoutFrame 394 0 40 0 481 0 62 0)
                   activeHelpKey: useDynamicPreferredWidth
                   model: useDynamicPreferredHeight
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'OSX-ResizeH'
                   name: 'OSXResizeH Checkbox'
                   layout: (LayoutFrame 287 0 70 0 480 0 92 0)
                   activeHelpKey: keepSpaceForOSXResizeHandleH
                   model: keepSpaceForOSXResizeHandleH
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'OSX-ResizeV'
                   name: 'OSXResizeV Checkbox'
                   layout: (LayoutFrame 287 0 96 0 480 0 118 0)
                   activeHelpKey: keepSpaceForOSXResizeHandleV
                   model: keepSpaceForOSXResizeHandleV
                   translateLabel: true
                 )
                )
              
             )
           )
          (MenuPanelSpec
             name: 'commonLayoutToolBar1'
             layout: (LayoutFrame 6 0.0 267 0 -4 1.0 299 0)
             level: 0
             tabable: true
             menu: commonFrameLayoutsMenu1
             textDefault: true
           )
          (MenuPanelSpec
             name: 'commonLayoutToolBar2'
             layout: (LayoutFrame 6 0.0 299 0 -4 1.0 331 0)
             level: 0
             tabable: true
             menu: commonFrameLayoutsMenu2
             textDefault: true
           )
          (MenuPanelSpec
             name: 'commonLayoutToolBar3'
             layout: (LayoutFrame 6 0.0 323 0 -4 1.0 355 0)
             level: 0
             tabable: true
             menu: commonFrameLayoutsMenu3
             textDefault: true
           )
          )
        
       )
     )
! !

!UILayoutTool::LayoutFrame class methodsFor:'menu specs'!

commonFrameLayoutsMenu1
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:UILayoutTool::LayoutFrame andSelector:#commonFrameLayoutsMenu1
     (Menu new fromLiteralArrayEncoding:(UILayoutTool::LayoutFrame commonFrameLayoutsMenu1)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #activeHelpKey: #fullLayout
            #label: 'setFullFrame'
            #itemValue: #setFullFrame
            #nameKey: #setFullFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever #'UILayoutTool::LayoutFrame' #setFullIcon)
          )
         #(#MenuItem
            #label: ''
          )
         #(#MenuItem
            #activeHelpKey: #topHalfLayout
            #label: 'setTopHalfFrame'
            #itemValue: #setTopHalfFrame
            #nameKey: #setTopHalfFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever #'UILayoutTool::LayoutFrame' #setTopHalfIcon)
          )
         #(#MenuItem
            #activeHelpKey: #bottomHalfLayout
            #label: 'setBottomHalfFrame'
            #itemValue: #setBottomHalfFrame
            #nameKey: #setBottomHalfFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setBottomHalfIcon)
          )
         #(#MenuItem
            #activeHelpKey: #leftHalfLayout
            #label: 'setLeftHalfFrame'
            #itemValue: #setLeftHalfFrame
            #nameKey: #setLeftHalfFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setLeftHalfIcon)
          )
         #(#MenuItem
            #activeHelpKey: #rightHalfLayout
            #label: 'setRightHalfFrame'
            #itemValue: #setRightHalfFrame
            #nameKey: #setRightHalfFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setRightHalfIcon)
          )
         #(#MenuItem
            #label: ''
          )
         #(#MenuItem
            #activeHelpKey: #topLeftQuarterLayout
            #label: 'setTopLeftQuarterFrame'
            #itemValue: #setTopLeftQuarterFrame
            #nameKey: #setTopLeftQuarterFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setTopLeftQuarterIcon)
          )
         #(#MenuItem
            #activeHelpKey: #topRightQuarterLayout
            #label: 'setTopRightQuarterFrame'
            #itemValue: #setTopRightQuarterFrame
            #nameKey: #setTopRightQuarterFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setToRightQuarterIcon)
          )
         #(#MenuItem
            #activeHelpKey: #bottomRightQuarterLayout
            #label: 'setBottomRightQuarterFrame'
            #itemValue: #setBottomRightQuarterFrame
            #nameKey: #setBottomRightQuarterFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setBottomRightQuarterIcon)
          )
         #(#MenuItem
            #activeHelpKey: #bottomLeftQuarterLayout
            #label: 'setBottomLeftQuarterFrame'
            #itemValue: #setBottomLeftQuarterFrame
            #nameKey: #setBottomLeftQuarterFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setBottomLeftQuarterIcon)
          )
         )
        nil
        nil
      )
!

commonFrameLayoutsMenu2
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:UILayoutTool::LayoutFrame andSelector:#commonFrameLayoutsMenu2
     (Menu new fromLiteralArrayEncoding:(UILayoutTool::LayoutFrame commonFrameLayoutsMenu2)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #activeHelpKey: #topFixPartLayout
            #label: 'setTopFixPartFrame'
            #itemValue: #setTopFixPartFrame
            #nameKey: #setTopFixPartFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setTopFixPartIcon)
          )
         #(#MenuItem
            #activeHelpKey: #horizontalFixPartLayout
            #label: 'setHorizontalFixPartFrame'
            #itemValue: #setHorizontalFixPartFrame
            #nameKey: #setHorizontalFixPartFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setHorizontalFixPartIcon)
          )
         #(#MenuItem
            #activeHelpKey: #bottomFixPartLayout
            #label: 'setBottomFixPartFrame'
            #itemValue: #setBottomFixPartFrame
            #nameKey: #setBottomFixPartFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setBottomFixPartIcon)
          )
         #(#MenuItem
            #label: ''
          )
         #(#MenuItem
            #activeHelpKey: #leftFixPartLayout
            #label: 'setLeftFixPartFrame'
            #itemValue: #setLeftFixPartFrame
            #nameKey: #setLeftFixPartFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setLeftFixPartIcon)
          )
         #(#MenuItem
            #activeHelpKey: #verticalFixPartLayout
            #label: 'setVerticalFixPartFrame'
            #itemValue: #setVerticalFixPartFrame
            #nameKey: #setVerticalFixPartFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setVerticalFixPartIcon)
          )
         #(#MenuItem
            #activeHelpKey: #rightFixPartLayout
            #label: 'setRightFixPartFrame'
            #itemValue: #setRightFixPartFrame
            #nameKey: #setRightFixPartFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setRightFixPartIcon)
          )
         #(#MenuItem
            #label: ''
          )
         #(#MenuItem
            #activeHelpKey: #bigTopFixPartLayout
            #label: 'setBigTopFixPartFrame'
            #itemValue: #setBigTopFixPartFrame
            #nameKey: #setBigTopFixPartFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setBigTopFixPartIcon)
          )
         #(#MenuItem
            #activeHelpKey: #bigHorizontalFixPartLayout
            #label: 'setBigHorizontalFixPartFrame'
            #itemValue: #setBigHorizontalFixPartFrame
            #nameKey: #setBigHorizontalFixPartFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setBigHorizontalFixPartIcon)
          )
         #(#MenuItem
            #activeHelpKey: #bigBottomFixPartLayout
            #label: 'setBigBottomFixPartFrame'
            #itemValue: #setBigBottomFixPartFrame
            #nameKey: #setBigBottomFixPartFrame
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever nil #setBigBottomFixPartIcon)
          )
         )
        nil
        nil
      )
!

commonFrameLayoutsMenu3
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:UILayoutTool::LayoutFrame andSelector:#commonFrameLayoutsMenu3
     (Menu new fromLiteralArrayEncoding:(UILayoutTool::LayoutFrame commonFrameLayoutsMenu3)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: screenFrameLayout
            label: 'setScreenFrame'
            itemValue: setScreenFrame
            nameKey: setScreenFrame
            translateLabel: true
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever #'UILayoutTool::LayoutFrame' setScreenIcon)
          )
         )
        nil
        nil
      )
! !

!UILayoutTool::LayoutFrame methodsFor:'accessing'!

fetch:aView spec:aSpec
    |layout|

    aSpec class == WindowSpec ifTrue:[
         (layout := aSpec layout) isNil ifTrue:[
             layout := aSpec bounds asLayout.
         ] 
    ] ifFalse: [
         layout  := UIPainterView asLayoutFrameFromView:aView.
    ].
    (self aspectFor:#leftOffset)     value:(layout leftOffset).
    (self aspectFor:#leftFraction)   value:(layout leftFraction).
    (self aspectFor:#topOffset)      value:(layout topOffset).
    (self aspectFor:#topFraction)    value:(layout topFraction).
    (self aspectFor:#rightOffset)    value:(layout rightOffset value).  "take care of blocks"
    (self aspectFor:#bottomOffset)   value:(layout bottomOffset value). "take care of blocks"
    (self aspectFor:#rightFraction)  value:(layout rightFraction).
    (self aspectFor:#bottomFraction) value:(layout bottomFraction).

    (self aspectFor:#usePreferredWidth) value:(aSpec usePreferredWidth).
    (self aspectFor:#usePreferredHeight) value:(aSpec usePreferredHeight).
    (self aspectFor:#useDynamicPreferredWidth) value:(aSpec useDynamicPreferredWidth).
    (self aspectFor:#useDynamicPreferredHeight) value:(aSpec useDynamicPreferredHeight).

    (self aspectFor:#keepSpaceForOSXResizeHandleV) value:(aSpec keepSpaceForOSXResizeHandleV).
    (self aspectFor:#keepSpaceForOSXResizeHandleH) value:(aSpec keepSpaceForOSXResizeHandleH).
!

layout
    "returns the current layout as layoutFrame
    "
    |layout|

    layout  := (Smalltalk at:#LayoutFrame) new.

    layout 
        leftFraction:(self aspectValueOr0For:#leftFraction)
            offset:(self aspectValueOr0For:#leftOffset)
        rightFraction:(self aspectValueOr0For:#rightFraction)
            offset:(self aspectValueOr0For:#rightOffset)
        topFraction:(self aspectValueOr0For:#topFraction)
            offset:(self aspectValueOr0For:#topOffset)
        bottomFraction:(self aspectValueOr0For:#bottomFraction)
            offset:(self aspectValueOr0For:#bottomOffset).

  ^ layout
! !

!UILayoutTool::LayoutFrame methodsFor:'common frames'!

setBigBottomFixPartFrame
    self
        setFrameLeft:0   offset:0 
        right:1          offset:0 
        top:0            offset:(self class defaultFixPartHeight) 
        bottom:1         offset:0
!

setBigHorizontalFixPartFrame
    self
        setFrameLeft:0   offset:0 
        right:1          offset:0 
        top:0            offset:(self class defaultFixPartHeight) 
        bottom:1         offset:(self class defaultFixPartHeight negated)
!

setBigTopFixPartFrame
    self
        setFrameLeft:0   offset:0 
        right:1          offset:0 
        top:0            offset:0 
        bottom:1         offset:(self class defaultFixPartHeight negated)
!

setBottomFixPartFrame
    self
        setFrameLeft:0   offset:0 
        right:1          offset:0 
        top:1            offset:(self class defaultFixPartHeight negated) 
        bottom:1         offset:0
!

setBottomHalfFrame
    self
        setFrameLeft:0  offset:0 
        right:1         offset:0 
        top:0.5         offset:0 
        bottom:1        offset:0
!

setBottomLeftQuarterFrame
    self
        setFrameLeft:0   offset:0 
        right:0.5        offset:0 
        top:0.5          offset:0 
        bottom:1         offset:0
!

setBottomRightQuarterFrame
    self
        setFrameLeft:0.5 offset:0 
        right:1          offset:0 
        top:0.5          offset:0 
        bottom:1         offset:0
!

setFrameLeft:lF offset:lO right:rF offset:rO top:tF offset:tO bottom:bF offset:bO
    (self aspectFor:#leftOffset)     value:lO.
    (self aspectFor:#rightOffset)    value:rO value.
    (self aspectFor:#topOffset)      value:tO.
    (self aspectFor:#bottomOffset)   value:bO value.

    (self aspectFor:#leftFraction)   value:lF.
    (self aspectFor:#rightFraction)  value:rF.
    (self aspectFor:#topFraction)    value:tF.
    (self aspectFor:#bottomFraction) value:bF.
!

setFullFrame
    self
        setFrameLeft:0   offset:0 
        right:1          offset:0 
        top:0            offset:0 
        bottom:1         offset:0
!

setHorizontalFixPartFrame
    self
        setFrameLeft:0   offset:0 
        right:1          offset:0 
        top:0.5          offset:(self class defaultFixPartHeight negated // 2) 
        bottom:0.5       offset:(self class defaultFixPartHeight // 2)
!

setLeftFixPartFrame
    self
        setFrameLeft:0   offset:0 
        right:0          offset:(self class defaultFixPartHeight) 
        top:0            offset:0 
        bottom:1         offset:0
!

setLeftHalfFrame
    self
        setFrameLeft:0  offset:0 
        right:0.5       offset:0 
        top:0           offset:0 
        bottom:1        offset:0
!

setRightFixPartFrame
    self
        setFrameLeft:1   offset:(self class defaultFixPartHeight negated) 
        right:1          offset:0 
        top:0            offset:0 
        bottom:1         offset:0
!

setRightHalfFrame
    self
        setFrameLeft:0.5 offset:0 
        right:1          offset:0 
        top:0            offset:0 
        bottom:1         offset:0
!

setTopFixPartFrame
    self
        setFrameLeft:0   offset:0 
        right:1          offset:0 
        top:0            offset:0 
        bottom:0         offset:(self class defaultFixPartHeight)
!

setTopHalfFrame
    self
        setFrameLeft:0   offset:0 
        right:1          offset:0 
        top:0            offset:0 
        bottom:0.5       offset:0
!

setTopLeftQuarterFrame
    self
        setFrameLeft:0   offset:0 
        right:0.5        offset:0 
        top:0            offset:0 
        bottom:0.5       offset:0
!

setTopRightQuarterFrame
    self
        setFrameLeft:0.5 offset:0 
        right:1          offset:0 
        top:0            offset:0 
        bottom:0.5       offset:0
!

setVerticalFixPartFrame
    self
        setFrameLeft:0.5   offset:(self class defaultFixPartHeight negated // 2 )
        right:0.5          offset:(self class defaultFixPartHeight // 2 ) 
        top:0          offset:0 
        bottom:1       offset:0
! !

!UILayoutTool::LayoutOrigin class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UILayoutTool::LayoutOrigin andSelector:#windowSpec
     UILayoutTool::LayoutOrigin new openInterface:#windowSpec
     UILayoutTool::LayoutOrigin open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'UILayoutTool-LayoutOrigin'
          name: 'UILayoutTool-LayoutOrigin'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 372 192)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'layoutOriginSpec'
              layout: (LayoutFrame 1 0.0 6 0 0 1.0 110 0)
              majorKey: UILayoutTool
              minorKey: layoutOriginSpec
            )
           )
         
        )
      )
! !

!UILayoutTool::LayoutOrigin methodsFor:'accessing'!

fetch:aView spec:aSpec
    "fetch layoutOrigin
    "
    |layout|

    layout  := UIPainterView asLayoutFrameFromView:aView.

    (self aspectFor:#leftOffset)   value:(layout leftOffset).
    (self aspectFor:#leftFraction) value:(layout leftFraction).
    (self aspectFor:#topOffset)    value:(layout topOffset).
    (self aspectFor:#topFraction)  value:(layout topFraction).


!

layout
    "returns current layout as layoutOrigin
    "
    |layout|

    layout  := (Smalltalk at:#LayoutOrigin) new.

    layout 
        leftFraction:(self aspectValueOr0For:#leftFraction)
            offset:(self aspectValueOr0For:#leftOffset)
        topFraction:(self aspectValueOr0For:#topFraction)
            offset:(self aspectValueOr0For:#topOffset).

  ^ layout
! !

!UILayoutTool::Point class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UILayoutTool::Point andSelector:#windowSpec
     UILayoutTool::Point new openInterface:#windowSpec
     UILayoutTool::Point open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'UILayoutTool-Point'
          name: 'UILayoutTool-Point'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 309 184)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'layoutPointSpec'
              layout: (LayoutFrame 1 0.0 6 0 0 1.0 100 0)
              majorKey: UILayoutTool
              minorKey: layoutPointSpec
            )
           )
         
        )
      )
! !

!UILayoutTool::Point methodsFor:'accessing'!

fetch:aView spec:aSpec
    "fetch point
    "
    |origin|

    origin  := aView computeOrigin.

    (self aspectFor:#leftOffset) value:(origin x).
    (self aspectFor:#topOffset)  value:(origin y).


!

layout
    "returns current layout as point
    "
  ^ (self aspectValueOr0For:#leftOffset) @ (self aspectValueOr0For:#topOffset)
! !

!UILayoutTool::Rectangle class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UILayoutTool::Rectangle andSelector:#windowSpec
     UILayoutTool::Rectangle new openInterface:#windowSpec
     UILayoutTool::Rectangle open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'UILayoutTool-Rectangle'
         name: 'UILayoutTool-Rectangle'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 342 199)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'subSpecification'
             layout: (LayoutFrame 1 0.0 6 0 0 1.0 96 0)
             majorKey: UILayoutTool
             minorKey: layoutPointSpec
           )
          (FramedBoxSpec
             label: 'Corner'
             name: 'FramedBox'
             layout: (LayoutFrame 1 0.0 99 0 0 1.0 194 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Right:'
                   name: 'labelCornerY'
                   layout: (AlignmentOrigin 83 0 12 0 1 0)
                   translateLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'fieldCornerX'
                   layout: (LayoutFrame 85 0 9 0 135 0 31 0)
                   activeHelpKey: cornerX
                   tabable: true
                   model: rightOffset
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Bottom:'
                   name: 'labelCornerX'
                   layout: (AlignmentOrigin 83 0 37 0 1 0)
                   translateLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'fieldCornerY'
                   layout: (LayoutFrame 85 0 34 0 135 0 56 0)
                   activeHelpKey: cornerY
                   tabable: true
                   model: bottomOffset
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!UILayoutTool::Rectangle methodsFor:'accessing'!

fetch:aView spec:aSpec
    "fetch rectangle
    "
    |origin corner|

    origin := aView computeOrigin.
    corner := aView computeCorner.

    (self aspectFor:#leftOffset)   value:(origin x).
    (self aspectFor:#rightOffset)  value:(corner x).
    (self aspectFor:#topOffset)    value:(origin y).
    (self aspectFor:#bottomOffset) value:(corner y).


!

layout
    "returns current layout as rectangle"

    ^ (Smalltalk at:#Rectangle) 
        left:(self aspectValueOr0For:#leftOffset)
        top:(self aspectValueOr0For:#topOffset)
        right:(self aspectValueOr0For:#rightOffset)
        bottom:(self aspectValueOr0For:#bottomOffset)
! !

!UILayoutTool class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

