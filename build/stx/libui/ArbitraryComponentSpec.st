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
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

ViewWithScrollerSpec subclass:#ArbitraryComponentSpec
	instanceVariableNames:'component hasBorder viewChannel subAspectHolders'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ArbitraryComponentSpec class methodsFor:'documentation'!

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
    Not normally used by applications.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by read public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!ArbitraryComponentSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'ArbitraryComponentSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@QDQDQDQDQD0@P@@@@@@@@@ @PH"H"H"H#@ @PH3L3L3L1@ @PH0@@@@@1@ @PH0H"H#@1@ @PH0JH"A@1@ @PH0JH"A@1@ @PH0LQDQ@1@ @PH0@@@@@1@ @PH3L3L3L1@ @PLQDQDQDQ@ @P@@@@@@@@@ @2H"H"H"H"H @@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
! !

!ArbitraryComponentSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ArbitraryComponentSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpec
        window: 
       (WindowSpec
          label: 'ArbitraryComponent Basics'
          name: 'ArbitraryComponent Basics'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 335)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'idModelWindowBoxSubSpec'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 110 0)
              majorKey: ArbitraryComponentSpec
              minorKey: idModelWindowBoxSpec
            )
           (UISubSpecification
              name: 'menuSubSpec'
              layout: (LayoutFrame 0 0.0 109 0 0 1.0 224 0)
              majorKey: UISpecification
              minorKey: menuSubSpec
            )
           (UISubSpecification
              name: 'scrollerSubSpec'
              layout: (LayoutFrame 0 0.0 229 0 0 1.0 320 0)
              majorKey: ViewWithScrollerSpec
              minorKey: scrollerSubSpec
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
     UIPainter new openOnClass:ArbitraryComponentSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'ArbitraryComponentSpec Channels'
         name: 'ArbitraryComponentSpec Channels'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 413 220)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 128 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'VisibilityChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 7 0.0 4 1.0 32 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 33 0.0 4 1.0 58 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                (LabelSpec
                   label: 'View Channel:'
                   name: 'viewLabel'
                   layout: (AlignmentOrigin 100 0 71 0 1 0.5)
                   activeHelpKey: viewChannel
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'viewField'
                   layout: (LayoutFrame 100 0 60 0 4 1 82 0)
                   activeHelpKey: viewChannel
                   tabable: true
                   model: viewChannel
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'CallBacks'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 131 0 0 1.0 194 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification2'
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
     UIPainter new openOnClass:ArbitraryComponentSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'ArbitraryComponent Details'
         name: 'ArbitraryComponent Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 101)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Init Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 108 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Initially Disabled'
                   name: 'initiallyDisabled'
                   layout: (Point 8 3)
                   activeHelpKey: initiallyDisabled
                   tabable: true
                   model: initiallyDisabled
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Initially Invisible'
                   name: 'initiallyInvisible'
                   layout: (Point 175 3)
                   activeHelpKey: initiallyInvisible
                   tabable: true
                   model: initiallyInvisible
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Bordered'
                   name: 'hasBorder'
                   layout: (LayoutOrigin 8 0 36 0)
                   activeHelpKey: hasBorder
                   visibilityChannel: false
                   tabable: true
                   model: hasBorder
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Border:'
                   name: 'BorderLabel'
                   layout: (LayoutFrame 8 0 40 0 70 0 62 0)
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'BorderField'
                   layout: (LayoutFrame 71 0 40 0 117 0 62 0)
                   model: borderWidth
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Level:'
                   name: 'LevelLabel'
                   layout: (LayoutFrame 153 0 40 0 215 0 62 0)
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'LevelField'
                   layout: (LayoutFrame 216 0 40 0 256 0 62 0)
                   model: level
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

idModelWindowBoxSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ArbitraryComponentSpec andSelector:#idModelWindowBoxSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: idModelWindowBoxSpec
       window: 
      (WindowSpec
         label: 'ArbitraryComponent Basics'
         name: 'ArbitraryComponent Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 335)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'idModelWindowBox'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 116 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'idLabel'
                   layout: (AlignmentOrigin 100 0 16 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'idField'
                   layout: (LayoutFrame 100 0 1 0 5 1 23 0)
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
                   layout: (AlignmentOrigin 100 0 39 0 1 0.5)
                   activeHelpKey: model
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 28 0 -15 1 50 0)
                   activeHelpKey: model
                   tabable: true
                   model: model
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button1'
                   layout: (LayoutFrame -15 1 27 0 5 1 49 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                (LabelSpec
                   label: 'View / Class:'
                   name: 'viewLabel'
                   layout: (AlignmentOrigin 100 0 65 0 1 0.5)
                   activeHelpKey: arbitraryView
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'viewField'
                   layout: (LayoutFrame 100 0 54 0 5 1 76 0)
                   activeHelpKey: arbitraryView
                   tabable: true
                   model: component
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!ArbitraryComponentSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    |major cls subCanvasAspects|

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        subAspectHolderDataList
                        hasBorder
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:#(
                        component
                        viewChannel
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil

    "Modified: / 10.2.2000 / 01:05:49 / cg"
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ { NonScrollableArbitraryComponentSpec }

    "Modified (comment): / 05-09-2012 / 19:26:41 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^#(
            (Basics  basicsEditSpec)
            (Details detailsEditSpec) 
            (Channels channelsEditSpec) 
            (SubChannels subChannelsEditSpec)
      )

    "Modified: / 10.2.2000 / 01:04:59 / cg"
! !

!ArbitraryComponentSpec methodsFor:'accessing'!

component
    ^ component
!

component:something
    component := something.
!

hasBorder
    ^ hasBorder ? false
!

hasBorder:something
    hasBorder := something.
!

subAspectHolderDataList
    subAspectHolders := self class
                            updatedAspectHolderDataList:subAspectHolders 
                            forClassNamed:component.
    ^ subAspectHolders.

!

subAspectHolders
    ^ subAspectHolders

    "Created: / 10.2.2000 / 01:02:07 / cg"
!

subAspectHolders:aCollection
    subAspectHolders := aCollection

    "Created: / 10.2.2000 / 01:02:15 / cg"
! !

!ArbitraryComponentSpec methodsFor:'accessing-channels'!

viewChannel
    ^ viewChannel

    "Created: / 5.2.2000 / 17:47:18 / cg"
!

viewChannel:something
    viewChannel := something.

    "Created: / 5.2.2000 / 17:47:18 / cg"
! !

!ArbitraryComponentSpec methodsFor:'building'!

createViewFor:aBuilder in:aView

    ^ ScrollableView in:aView.

!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |newView cls scrView c childView|

    level notNil ifTrue:[
        self setLevelAttributeIn:aView with:aBuilder.
    ].

    (component notNil) ifTrue:[
        self isScrollable ifTrue:[
            "/ a component is to be embedded ...
            ((cls := Smalltalk resolveName:component inClass:self class) notNil
            or:[((newView := aBuilder componentFor:component) isNil
                 and:[(newView := aBuilder aspectFor:component) isNil])]
            ) ifTrue:[
                cls isNil ifTrue:[
                    (cls := self resolveName:component in:aBuilder) isNil ifTrue:[
                        aBuilder isEditing ifFalse:[
                            self proceedableError:('missing view-class: ' , component).
                        ].
                        cls := View
                    ]
                ].

                (scrView := aView scrolledView) class ~~ cls ifTrue:[
                    scrView notNil ifTrue:[
                        scrView destroy.
                    ].
                    newView := cls new
                ].
            ].

            newView notNil ifTrue:[
                aView scrolledView:newView.

"/ cg: who disabled this ?
"/            self setMenuIn:aView with:aBuilder.
            ].
        ] ifFalse:[
            newView := aView
        ].

        model notNil ifTrue:[
            self setModelAttributeIn:aView with:aBuilder
        ].

        (subAspectHolders notNil) ifTrue:[
            subAspectHolders do:[:infoEntry | 
                |subAspect aspect holder callBack type|

                subAspect := infoEntry subAspect.
                aspect := infoEntry aspect.
                callBack := infoEntry callBack.
                type := infoEntry type.
                (aspect notNil or:[callBack notNil]) ifTrue:[
                    aspect notNil ifTrue:[
                        "/ store a mainApps aspect into the widgets subAspect slot
                        holder := self getBindingIn:aBuilder binding:aspect asSymbol.
                        holder notNil ifTrue:[
                            "/ TODO: must use the general setBinding here (subAspect could be in a binding directory)...
                            newView perform:subAspect asMutator with:holder.
                        ]
                    ] ifFalse:[
                        "/ arrange for getting informed, when subAspect changes
                        "/ TODO: must use the general getBinding here (subAspect could be in a binding directory)...
                        holder := newView perform:subAspect asSymbol
                    ].
                    callBack notNil ifTrue:[
                        holder isNil ifTrue:[
                            "/ how about an error here ?
                        ] ifFalse:[
                            holder onChangeSend:callBack asSymbol to:aBuilder application
                        ]
                    ]
                ]
            ]
        ]
    ].

    aBuilder isEditing ifFalse:[    
        self isScrollable ifTrue:[
            viewChannel notNil ifTrue:[
                "/ dynamic behavior; arrange for the valueHolder to
                "/ notify me, and install the new view then...
                c := self channel:#viewChannel inBuilder:aBuilder.
                c notNil ifTrue:[
                    childView := c value.
                    childView notNil ifTrue:[
                        aView scrolledView:childView
                    ].
                    c isValueModel ifTrue:[
                        c onChangeEvaluate:[
                            |newView|

                            newView := c value.
                            aView scrolledView:newView.
                        ]
                    ]
                ].
            ].
        ].
    ].

    super setAttributesIn:aView with:aBuilder.

    "Modified: / 10-02-2000 / 01:47:43 / cg"
    "Modified: / 24-05-2018 / 13:47:48 / Claus Gittinger"
!

setColorAttributesIn:aView with:aBuilder
    "set my color attributes to aView"



! !

!ArbitraryComponentSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    subAspectHolders notNil ifTrue:[
        "/ temporary - convert backward compatible array to a SubChannelInfoSpec
        subAspectHolders := subAspectHolders collect:[:el |
                                el isArray ifTrue:[
                                    (el first == #SubChannelInfoSpec) ifTrue:[
                                        el decodeAsLiteralArray
                                    ] ifFalse:[
                                        SubChannelInfoSpec new
                                            subAspect:(el at:1 ifAbsent:nil); 
                                            aspect:(el at:2 ifAbsent:nil); 
                                            callBack:(el at:3 ifAbsent:nil)
                                    ]
                                ] ifFalse:[
                                    el
                                ]
                            ].

        subAspectHolders := subAspectHolders select:[:el | el notNil and:[el ~~ #Array]].

        "/ later, we will do:
        "/ subAspectHolders := subAspectHolders decodeAsLiteralArray.
    ].

!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    viewChannel        isNil ifTrue:[l add:#viewChannel].
    component          isNil ifTrue:[l add:#component].
    hasBorder          isNil ifTrue:[l add:#hasBorder].
    subAspectHolders notNil ifTrue:[
        subAspectHolders do:[:el | el normalize].
        subAspectHolders := subAspectHolders select:[:el | el hasNonNilAspectOrCallBack].
        subAspectHolders := subAspectHolders asArray
    ].
    subAspectHolders size == 0 ifTrue:[ l add:#subAspectHolders ].
    ^ l

    "Created: / 5.2.2000 / 20:09:44 / cg"
    "Modified: / 10.2.2000 / 01:42:28 / cg"
! !

!ArbitraryComponentSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    ('Spec [warning]: fromView: cannot parse arbitrary view''s contents (' , aView displayString , ')') infoPrintCR.

    ((aView isMemberOf:SimpleView)
    or:[aView isMemberOf:View]) ifTrue:[
        ^ ViewSpec fromView:aView callBack:aBlock
    ].

    ^ super fromView:aView callBack:aBlock
! !

!ArbitraryComponentSpec methodsFor:'queries'!

viewClass
    "return the corresponding view class of the spec"

    ^ View

    "Modified: / 01-01-1970 / 01:00:00 / cg"
! !

!ArbitraryComponentSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.

    subAspectHolders notNil ifTrue:[
        more addAll:
                (subAspectHolders
                        collect:[:infoEntry | infoEntry callBack]
                        thenSelect:[:callBack | callBack notNil])
"/        subAspectHolders do:[:infoEntry | 
"/            |callBack|
"/
"/            (callBack := infoEntry callBack) notNil ifTrue:[more add:callBack].
"/        ]
    ].

    ^ more

    "Modified: / 10.2.2000 / 01:37:03 / cg"
    "Created: / 10.2.2000 / 01:37:24 / cg"
!

aspectSelectors
    "add more aspect selectors (these can generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    viewChannel notNil ifTrue:[ more add:viewChannel ].

    subAspectHolders notNil ifTrue:[
        more addAll:
                (subAspectHolders
                        collect:[:infoEntry | infoEntry aspect]
                        thenSelect:[:aspect | aspect notNil])
"/        subAspectHolders do:[:infoEntry | 
"/            |aspect|
"/
"/            (aspect := infoEntry aspect) notNil ifTrue:[more add:aspect].
"/        ]
    ].

    ^ more

    "Created: / 10.2.2000 / 01:36:44 / cg"
    "Modified: / 10.2.2000 / 01:37:48 / cg"
!

valueSelectors
    "the view is acquired through a value method"

    |more|

    more := super valueSelectors.
    component notNil ifTrue:[
        "/ only if not uppercase 
        component isLowercaseFirst ifTrue:[
            more add:component
        ].
    ].
    ^ more

    "Modified: / 22-06-2017 / 06:56:03 / cg"
! !

!ArbitraryComponentSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitArbitraryComponentSpec:self
! !

!ArbitraryComponentSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ArbitraryComponentSpec.st,v 1.104 2018-05-24 12:50:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/ArbitraryComponentSpec.st,v 1.104 2018-05-24 12:50:35 cg Exp $'
! !

