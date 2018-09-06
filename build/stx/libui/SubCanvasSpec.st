"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

ViewWithScrollerSpec subclass:#SubCanvasSpec
	instanceVariableNames:'majorKey minorKey clientKey selector argument specHolder
		clientHolder subAspectHolders createNewApplication
		createNewBuilder possiblyScrollable'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!SubCanvasSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"

! !

!SubCanvasSpec class methodsFor:'help'!

helpSpec
    "
     UIHelpTool openOnClass:UISpecification    
    "

    <resource: #help>

    ^ IdentityDictionary new addPairsFrom:#(

#horizontalMiniScroller
'Force a mini-scroller as horizontal scrollbar (even if embedded app does not specify so)'

#horizontalScroller
'Enable horizontal scrollability iff the embedded app specifies so in its own window spec.\If off, no horizontal scrollbar is added ever'

#possiblyScrollable
'Support scrolling of the embedded view (iff the embedded application specifies so in its own window spec).'

#verticalMiniScroller
'Force a mini-scroller as vertical scrollbar (even if embedded app does not specify so)'

#verticalScroller
'Enable vertical scrollability iff the embedded app specifies so in its own window spec.\If off, no vertical scrollbar is added ever'

#majorKey
'Name of the class which provides the UI spec.\Optionally, an instance of it is created as embedded application (see check box below)'

#minorKey
'Name of the spec-method in the above class, which defines the UI spec.'

#clientKey
'Alternative to the above: aspect of the main application which provides an application instance for the embedded UI'

#createNewBuilder
'If checked, a new uiBuilder instance is created to construct the UI.\Thus new components will not be remembered in the main application''s builder,\and are not accessible by the application via #componentAt:'

#createNewApplication
'If checked, a new instance of the above class is created as embedded application.\If unchecked, the main application will be the application for the embedded UI.'
)

    "Modified: / 09-08-2012 / 09:40:31 / cg"
! !

!SubCanvasSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SubCanvasSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'SubCanvas Basics'
         name: 'SubCanvas Basics'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 421 317)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 173 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 20 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 9 0 3 1.0 31 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Class (Maj.Key):'
                   name: 'majorKeyLabel'
                   layout: (AlignmentOrigin 148 0 45 0 1 0.5)
                   activeHelpKey: majorKey
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'majorKeyField'
                   layout: (LayoutFrame 152 0 34 0 -90 1 56 0)
                   activeHelpKey: majorKey
                   tabable: true
                   model: majorKey
                   group: inputGroup
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: '...'
                   name: 'Button4'
                   layout: (LayoutFrame -90 1 34 0 -70 1 56 0)
                   translateLabel: true
                   model: doOpenAspectClassChooserFor:
                   actionValue: majorKey
                 )
                (ActionButtonSpec
                   label: 'Browse'
                   name: 'Button1'
                   layout: (LayoutFrame -70 1 34 0 3 1 56 0)
                   translateLabel: true
                   model: doBrowseAspectClass:
                   actionValue: majorKey
                 )
                (LabelSpec
                   label: 'Selector (Min.Key):'
                   name: 'minorKeyLabel'
                   layout: (AlignmentOrigin 148 0 70 0 1 0.5)
                   activeHelpKey: minorKey
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'minorKeyField'
                   layout: (LayoutFrame 152 0 59 0 -70 1 81 0)
                   activeHelpKey: minorKey
                   tabable: true
                   model: minorKey
                   group: inputGroup
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: 'Browse'
                   name: 'Button2'
                   layout: (LayoutFrame -70 1 59 0 3 1 81 0)
                   translateLabel: true
                   model: doBrowseAspectClassAndSelector:
                   actionValue: 
                  (Array
                     majorKey minorKey
                   )
                 )
                (LabelSpec
                   label: 'Client (Key):'
                   name: 'clientKeyLabel'
                   layout: (AlignmentOrigin 148 0 95 0 1 0.5)
                   activeHelpKey: clientKey
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'clientKeyField'
                   layout: (LayoutFrame 152 0 84 0 -90 1 106 0)
                   activeHelpKey: clientKey
                   tabable: true
                   model: clientKey
                   group: inputGroup
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: '...'
                   name: 'Button5'
                   layout: (LayoutFrame -90 1 84 0 -70 1 106 0)
                   translateLabel: true
                   model: doOpenAspectClassChooserFor:
                   actionValue: clientKey
                 )
                (ActionButtonSpec
                   label: 'Browse'
                   name: 'Button3'
                   layout: (LayoutFrame -70 1 84 0 3 1 106 0)
                   translateLabel: true
                   model: doBrowseAspectClassAndSelector:
                   actionValue: 
                  (Array
                     majorKey clientKey
                   )
                 )
                (LabelSpec
                   label: 'Create New:'
                   name: 'createNewLabel'
                   layout: (AlignmentOrigin 148 0 120 0 1 0.5)
                   translateLabel: true
                   adjust: right
                 )
                (LabelSpec
                   label: 'Application:'
                   name: 'applicationLabel'
                   layout: (AlignmentOrigin 249 0 120 0 1 0.5)
                   activeHelpKey: createNewApplication
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (CheckToggleSpec
                   name: 'createNewApplicationCheckToggle'
                   layout: (AlignmentOrigin 251 0 120 0 0 0.5)
                   activeHelpKey: createNewApplication
                   translateLabel: true
                   tabable: true
                   model: createNewApplication
                   enableChannel: createNewApplicationEnabled
                   isTriggerOnDown: true
                   showLamp: false
                   lampColor: (Color 100.0 100.0 0.0)
                 )
                (LabelSpec
                   label: 'Builder:'
                   name: 'builderLabel'
                   layout: (AlignmentOrigin 345 0 120 0 1 0.5)
                   activeHelpKey: createNewBuilder
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (CheckToggleSpec
                   name: 'createNewBuilderCheckToggle'
                   layout: (AlignmentOrigin 347 0 120 0 0 0.5)
                   activeHelpKey: createNewBuilder
                   translateLabel: true
                   tabable: true
                   model: createNewBuilder
                   enableChannel: createNewBuilderEnabled
                   isTriggerOnDown: true
                   showLamp: false
                   lampColor: (Color 100.0 100.0 0.0)
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'scrollerSubSpec'
             layout: (LayoutFrame 0 0.0 175 0 0 1.0 273 0)
             majorKey: UISpecification
             minorKey: scrollerSubSpec
           )
          (CheckBoxSpec
             label: 'Scrollable'
             name: 'CheckBox1'
             layout: (LayoutFrame 3 0 267 0 421 0 289 0)
             activeHelpKey: possiblyScrollable
             visibilityChannel: false
             model: Scrollable
             translateLabel: true
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
     UIPainter new openOnClass:SubCanvasSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'SubCanvas Channels'
         name: 'SubCanvas Channels'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 413 290)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 120 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification2'
                   layout: (LayoutFrame 0 0.0 2 0.0 4 1.0 27 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (LabelSpec
                   label: 'Application:'
                   name: 'applicationLabel'
                   layout: (AlignmentOrigin 100 0 39 0 1 0.5)
                   activeHelpKey: clientHolder
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'applicationChannel'
                   layout: (LayoutFrame 100 0 28 0 4 1 50 0)
                   activeHelpKey: clientHolder
                   tabable: true
                   model: clientHolder
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Spec.:'
                   name: 'specificationLabel'
                   layout: (AlignmentOrigin 100 0 64 0 1 0.5)
                   activeHelpKey: specHolder
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'specificationChannel'
                   layout: (LayoutFrame 100 0 53 0 4 1 75 0)
                   activeHelpKey: specHolder
                   tabable: true
                   model: specHolder
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
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 115 0 0 1.0 202 0)
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
                (UISubSpecification
                   name: 'SubSpecification3'
                   layout: (LayoutFrame 0 0.0 25 0.0 4 1.0 53 0)
                   majorKey: SubCanvasSpec
                   minorKey: subSpecForPostCreateApplicationCallBack
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'CallBacks - Open'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 198 0.0 0 1.0 290 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Selector:'
                   name: 'selectorLabel'
                   layout: (AlignmentOrigin 100 0 16 0 1 0.5)
                   activeHelpKey: canvasSelector
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'selectorField'
                   layout: (LayoutFrame 100 0 5 0 4 1 27 0)
                   activeHelpKey: canvasSelector
                   tabable: true
                   model: selector
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Argument:'
                   name: 'argumentLabel'
                   layout: (AlignmentOrigin 100 0 42 0 1 0.5)
                   activeHelpKey: canvasArgument
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'argumentField'
                   layout: (LayoutFrame 100 0 31 0 4 1 53 0)
                   activeHelpKey: canvasArgument
                   tabable: true
                   model: argument
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
!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SubCanvasSpec andSelector:#detailsEditSpec
     SubCanvasSpec new openInterface:#detailsEditSpec
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'SubCanvas Details'
              #layout: #(#LayoutFrame 131 0 107 0 530 0 253 0)
              #label: 'SubCanvas Details'
              #min: #(#Point 10 10)
              #max: #(#Point 1152 900)
              #bounds: #(#Rectangle 131 107 531 254)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#UISubSpecification
                    #name: 'detailsEditSpec'
                    #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 70 0)
                    #majorKey: #UISubSpecification
                    #minorKey: #detailsEditSpec
                )
                 #(#UISubSpecification
                    #name: 'detailsInitSubSpec'
                    #layout: #(#LayoutFrame 0 0.0 74 0 0 1.0 139 0)
                    #majorKey: #UISpecification
                    #minorKey: #detailsInitSubSpec
                )
              )
          )
      )
!

subSpecForPostCreateApplicationCallBack
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SubCanvasSpec andSelector:#subSpecForPostCreateApplicationCallBack
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForPostCreateApplicationCallBack
       window: 
      (WindowSpec
         label: 'Application CallBacks'
         name: 'Application CallBacks'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 31)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'PostCreate App:'
             name: 'postCreateApplicationCallbackLabel'
             layout: (AlignmentOrigin 150 0 12 0 1 0.5)
             activeHelpKey: postCreateApplicationChannel
             translateLabel: true
             resizeForLabel: true
           )
          (ComboBoxSpec
             name: 'postCreateApplicationCallbackInputField'
             layout: (LayoutFrame 150 0 1 0 -20 1.0 23 0)
             activeHelpKey: postCreateApplicationChannel
             enableChannel: isNotEditingSpecOnly
             tabable: true
             model: posCreateApplicationCallback
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
             comboList: listOfCallbacks
           )
          (ActionButtonSpec
             label: 'browseActionImage'
             name: 'Button1'
             layout: (LayoutFrame -20 1 1 0 0 1 23 0)
             activeHelpKey: browseAction
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: doBrowseActionMethod:
             enableChannel: isNotEditingSpecOnly
             actionValue: postCreateApplicationCallback
           )
          )
        
       )
     )
! !

!SubCanvasSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    |bv|

    super addBindingsTo:env for:inst channel:aChannel.
    env at:#autoHideInScrollerSubSpecVisible put:false.
    self 
        adaptApects:
                    #(  
                        majorKey
                        minorKey
                        clientKey
                        selector
                        argument
                        clientHolder
                        specHolder
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        subAspectHolderDataList
                        createNewApplication
                        createNewBuilder
                     )
        to:env 
        for:inst 
        channel:aChannel.

    bv := BlockValue 
            with:[:maj :clKey :clHolder | 
                    maj notEmptyOrNil
                    and:[true "clKey notEmptyOrNil"
                    and:[clHolder isEmptyOrNil]]]
            arguments:(Array
                        with:(env at:#majorKey)
                        with:(env at:#clientKey)
                        with:(env at:#clientHolder)).

    env at:#createNewApplicationEnabled put:bv.

    bv := BlockValue 
            with:[:ena :creat |
                    ena value == true
                    and:[creat value == true]]
            arguments:(Array
                        with:(env at:#createNewApplicationEnabled)
                        with:(env at:#createNewApplication)).

    env at:#createNewBuilderEnabled put:bv.

    "Modified: / 08-03-2007 / 23:00:10 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Channels channelsEditSpec)
            (SubChannels subChannelsEditSpec)
       )

    "Modified: / 29.1.2000 / 22:46:20 / cg"
! !

!SubCanvasSpec class methodsFor:'queries'!

supportsSubComponents
    "answer whether instances of the spec class support sub components"

    ^ false


! !

!SubCanvasSpec methodsFor:'accessing'!

argument
    "return the open-callBack argument"

    ^ argument
!

argument:something
    "set the open-callBack argument"

    argument := something.
!

clientHolder
    "return the value of the instance variable 'clientHolder' (automatically generated)"

    ^ clientHolder
!

clientHolder:something
    "set the value of the instance variable 'clientHolder' (automatically generated)"

    clientHolder := something.
!

clientKey
    "get the key used when requesting the client from a UIBuilder''s source'
    "
  ^ clientKey
!

clientKey:something
    "set the key used when requesting the client from a UIBuilder''s source'; the model
    "
    clientKey := something
!

createNewApplication
    "return the value of the instance variable 'createNewApplication' (automatically generated)"

    ^ createNewApplication
!

createNewApplication:aBoolean
    "set the value of the instance variable 'createNewApplication' (automatically generated)"

    createNewApplication := aBoolean.
!

createNewBuilder
    ^ createNewBuilder ? false
!

createNewBuilder:aBoolean
    "set the value of the instance variable 'createNewBuilder' (automatically generated)"

    createNewBuilder := aBoolean.
!

majorKey
    "get the class name for the spec producing method
    "
  ^ majorKey
!

majorKey:something
    "set the class name for the spec producing method
    "
    majorKey := something
!

minorKey
    "get the selector to access the specification from class derived from majorKey
    "
  ^ minorKey
!

minorKey:something
    "set the selector to access the specification from class derived from majorKey
    "
    minorKey := something
!

possiblyScrollable
    "return the possiblyScrollable attribute"

    ^ possiblyScrollable ? false
!

possiblyScrollable:aBoolean
    "set the possiblyScrollable attribute"

    possiblyScrollable := aBoolean.
!

postCreateApplicationCallback
    "very special - allow application to hook on sub-application creation"

    otherAttributes isNil ifTrue:[^ nil].
    ^ (self otherAttributeAt:#postCreateApplicationCallback).

    "Created: / 26-07-2010 / 14:27:23 / cg"
!

postCreateApplicationCallback:anActionSelector
    "very special - allow application to hook on sub-application creation"

    self otherAttributeAt:#postCreateApplicationCallback put:anActionSelector

    "Created: / 26-07-2010 / 14:27:40 / cg"
!

selector
    "return the open-callBack selector"

    ^ selector
!

selector:aSymbol
    "set the open-callBack selector"

    selector := aSymbol.
!

specHolder
    "return the value of the instance variable 'specHolder' (automatically generated)"

    ^ specHolder
!

specHolder:something
    "set the value of the instance variable 'specHolder' (automatically generated)"

    specHolder := something.
!

subAspectHolderDataList
    subAspectHolders := self class
                            updatedAspectHolderDataList:subAspectHolders 
                            forClassNamed:majorKey.
    ^ subAspectHolders.
!

subAspectHolders
    ^ subAspectHolders

    "Modified: / 30.1.2000 / 20:44:07 / cg"
    "Created: / 30.1.2000 / 20:46:00 / cg"
!

subAspectHolders:aCollection
    subAspectHolders := aCollection

    "Modified: / 30.1.2000 / 20:44:10 / cg"
    "Created: / 30.1.2000 / 20:46:13 / cg"
! !

!SubCanvasSpec methodsFor:'building'!

connectSubAspectsIn:subAppl withBuilder:aBuilder
    subAspectHolders do:[:infoEntry | 
        |subAspect aspect holder callBack type|

        subAspect := infoEntry subAspect.
        aspect := infoEntry aspect.
        callBack := infoEntry callBack.
        type := infoEntry type.

        (aspect notNil or:[callBack notNil]) ifTrue:[
            aspect notNil ifTrue:[
                "/ store a mainApps aspect into the subCanvas subAspect slot
                holder := self getBindingIn:aBuilder binding:aspect asSymbol.
                holder notNil ifTrue:[
                    "/ TODO: must use the general setBinding here (subAspect could be in a binding directory)...
                    subAppl perform:subAspect asMutator with:holder.
                ]
            ] ifFalse:[
                "/ arrange for getting informed, when subAspect changes
                "/ TODO: must use the general getBinding here (subAspect could be in a binding directory)...
                holder := subAppl perform:subAspect asSymbol
            ].
            callBack notNil ifTrue:[
                holder isNil ifTrue:[
                    "/ how about an error here ?
                ] ifFalse:[
                    holder onChangeSend:(callBack asSymbol) to:aBuilder application
                ]
            ]
        ]
    ]
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |builder spec appNs applClassName applClass appl applHolder scrollable buildersApp
     createCallBackSelector|

    "/ cg to ca: this method is ugly and should be cleaned up.
    "/ I don't understand it !!
    super setAttributesIn:aView with:aBuilder.

    aBuilder isEditing ifTrue:[
        ^ self
    ].

    buildersApp := aBuilder application.

    scrollable := self possiblyScrollable
                  or:[ self hasHorizontalScrollBar 
                  or:[self hasVerticalScrollBar ]].
    aView makeClientViewScrollable:scrollable.
    level isNil ifTrue:[
        aView level:0
    ] ifFalse:[
        self setLevelAttributeIn:aView with:aBuilder.
    ].

    majorKey notNil ifTrue:[
        applClassName := majorKey asSymbol
    ].

    (applClassName notNil or:[minorKey notNil or:[clientKey notNil]]) ifTrue:[
        spec := aBuilder subCanvasAt:applClassName at:minorKey.

        spec isNil ifTrue:[
            minorKey isArray ifTrue:[
                self halt:'obsolete minorKey usage'.
                spec := minorKey
            ].
        ].
        clientKey isNil ifTrue:[
            (clientHolder isNil
            and:[applClassName notNil
            and:[createNewApplication == true]]) ifTrue:[
                "/ create an application and a new builder
                appNs := buildersApp class nameSpace.
                appNs isNameSpace ifTrue:[
                    applClass := appNs at:applClassName.
                ] ifFalse:[
                    applClass := appNs privateClassesAt:applClassName.
                ].
                (applClass isNil and:[appNs ~~ Smalltalk]) ifTrue:[
                    applClass := Smalltalk at:applClassName.
                    applClass isNil ifTrue:[
                        (applClassName startsWith:'Smalltalk::') ifTrue:[
                            applClass := Smalltalk at:(applClassName withoutPrefix:'Smalltalk::') asSymbol.
                        ]
                    ].
                ].
                appl := applClass new.
                appl masterApplication:(buildersApp).

                (createCallBackSelector := self postCreateApplicationCallback) notNil ifTrue:[
                    aBuilder application
                        perform:createCallBackSelector
                        withOptionalArgument:appl 
                        and:spec 
                        and:self.
                ].

                createNewBuilder == true ifTrue:[
                    appl createBuilder.
                    builder := appl builder.
                ] ifFalse:[
                    builder := aBuilder.
                ]
            ] ifFalse:[
                appl := buildersApp.

                "/ only use the applications builder, if there is no
                "/ specHolder. If there is, assume that the spec will change,
                "/ and components will therefore be deleted and rebuilt.
                "/ to avoid keeping references to old widgets, we force a private
                "/ builder for the subcanvas in that case.
                specHolder isNil ifTrue:[
                    builder := aBuilder.
                ]
            ].
        ] ifFalse:[
            appl := aBuilder aspectFor:clientKey.
            applClassName isNil ifTrue:[
                appl isNil ifTrue:[
                    appl := aView application.

                    [(appl isNil or:[appl respondsTo:clientKey])] whileFalse:[
                        appl := appl masterApplication
                    ].

                    appl notNil ifTrue:[
                        appl := appl perform:clientKey
                    ]
                ] ifFalse:[
                    builder := appl builder.

                    builder notNil ifTrue:[
                        spec := builder subCanvasAt:nil at:minorKey.
                    ] ifFalse:[
                        minorKey notNil ifTrue:[
                            spec := appl specificationFor:minorKey.
                        ].
                    ].
                    spec isNil ifTrue:[
                        appl notNil ifTrue:[
                            "/ assume the normal #windowSpec will be used
                        ] ifFalse:[
                            "/ should we raise an error here ?
                            'SubCanvasSpec [warning]: invalid minor key: ' errorPrint.
                            minorKey errorPrintCR.
                        ]
                    ]
                ]
            ]
        ].

        applClassName isNil ifTrue:[
            appl isNil ifTrue:[
                appl    := buildersApp.
                builder := aBuilder newSubBuilder.
            ] ifFalse:[
                builder := appl builder.

             "/ set the application if not done yet (some done in SubCanvas)
                appl masterApplication isNil ifTrue:[
                    appl == buildersApp ifFalse:[
                        appl masterApplication:(buildersApp)
                    ]
                ].
"/                appl masterApplication:(buildersApp).
            ].
        ].

        spec isNil ifTrue:[
            minorKey isNil ifTrue:[
                appl == buildersApp ifTrue:[
                    'SubCanvasSpec [warning]: possibly recursive embedding' errorPrint.
                ] ifFalse:[
                    spec := #windowSpec
                ]
            ]
        ].

        (appl notNil and:[subAspectHolders notNil]) ifTrue:[
            self connectSubAspectsIn:appl withBuilder:aBuilder.
        ].

        aView client:appl spec:spec builder:builder.

        "/ open-callback
        (appl notNil 
        and:[selector notNil
        and:[appl respondsTo:selector]]) ifTrue:[
            argument notNil ifTrue:[
                appl perform:selector with:(aBuilder aspectAt:argument)
            ] ifFalse:[
                appl perform:selector
            ]
        ]
    ].

    clientHolder notNil ifTrue:[
        applHolder := self getBindingIn:aBuilder binding:clientHolder.
        specHolder notNil ifTrue:[    
            aView 
                specHolder:(self getBindingIn:aBuilder binding:specHolder)
                clientHolder:applHolder
        ] ifFalse:[
            aView clientHolder:applHolder.
            minorKey notNil ifTrue:[
                appl := applHolder value.
                (appl notNil) ifTrue:[
                    spec := appl specificationFor:minorKey.
                    aView spec:minorKey
                ].
            ].
        ].
        subAspectHolders notNil ifTrue:[
            appl := applHolder value.
            (appl notNil) ifTrue:[
                self connectSubAspectsIn:appl withBuilder:aBuilder.
            ].
            "/ PROBLEM: subAspects must also be connected, if the client is dynamicly changed later 
            applHolder onChangeEvaluate:[
                        appl := applHolder value.
                        (appl notNil) ifTrue:[
                            self connectSubAspectsIn:appl withBuilder:aBuilder.
                        ].
            ].
        ].
    ] ifFalse:[
        appl isNil ifTrue:[
            appl := buildersApp
        ].
        aView setClient:appl.

        specHolder notNil ifTrue:[
            aView specHolder:(self getBindingIn:aBuilder binding:specHolder)
        ].
    ].

    "Modified: / 15-11-2010 / 09:19:28 / cg"
! !

!SubCanvasSpec methodsFor:'converting'!

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

    clientKey    isNil ifTrue:[l add:#clientKey].
    majorKey     isNil ifTrue:[l add:#majorKey].
    minorKey     isNil ifTrue:[l add:#minorKey].
    selector     isNil ifTrue:[l add:#selector].
    argument     isNil ifTrue:[l add:#argument].
    clientHolder isNil ifTrue:[l add:#clientHolder].
    specHolder   isNil ifTrue:[l add:#specHolder].
    possiblyScrollable isNil ifTrue:[l add:#possiblyScrollable].     
    createNewApplication ~~ true ifTrue:[l add:#createNewApplication].
    subAspectHolders notNil ifTrue:[
        subAspectHolders do:[:el | |sym|
                                (sym := (el subAspect)) size == 0 ifTrue:[
                                    sym := nil
                                ] ifFalse:[
                                    sym := sym string asSymbol
                                ].
                                el subAspect:sym.

                                (sym := (el aspect)) size == 0 ifTrue:[
                                    sym := nil
                                ] ifFalse:[
                                    sym := sym string asSymbol
                                ].
                                el aspect:sym.

                                (sym := (el callBack)) size == 0 ifTrue:[
                                    sym := nil
                                ] ifFalse:[
                                    sym := sym string asSymbol
                                ].
                                el callBack:sym.
                             ].
        subAspectHolders := subAspectHolders select:[:el | 
                                            (el aspect) notNil
                                            or:[(el callBack) notNil]
                                         ].
        subAspectHolders := subAspectHolders asArray
    ].
    subAspectHolders size == 0 ifTrue:[l add:#subAspectHolders].

    ^l

    "Modified: / 10.2.2000 / 01:42:07 / cg"
! !

!SubCanvasSpec methodsFor:'copying'!

postCopy
    subAspectHolders notNil ifTrue:[
        subAspectHolders := subAspectHolders deepCopy
    ].
    super postCopy
! !

!SubCanvasSpec methodsFor:'queries'!

viewClass
    "return the corresponding view class of the spec"

    ^ SubCanvas
! !

!SubCanvasSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.
    clientKey notNil ifTrue:[more add:clientKey].

    subAspectHolders notNil ifTrue:[
        subAspectHolders do:[:infoEntry | 
            |callBack|

            (callBack := infoEntry callBack) notNil ifTrue:[more add:callBack].
        ]
    ].

    ^ more

    "Modified: / 10.2.2000 / 01:37:03 / cg"
!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.

    specHolder   notNil ifTrue:[more add:specHolder].
    clientHolder notNil ifTrue:[more add:clientHolder].

    subAspectHolders notNil ifTrue:[
        subAspectHolders do:[:infoEntry | 
            |aspect|

            (aspect := infoEntry aspect) notNil ifTrue:[more add:aspect].
        ]
    ].

    ^ more

    "Modified: / 10.2.2000 / 01:36:08 / cg"
! !

!SubCanvasSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitSubCanvasSpec:self
! !

!SubCanvasSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/SubCanvasSpec.st,v 1.107 2016-11-04 15:28:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/SubCanvasSpec.st,v 1.107 2016-11-04 15:28:51 cg Exp $'
! !

