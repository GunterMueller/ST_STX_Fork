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

ComponentSpec subclass:#NamedSpec
	instanceVariableNames:'initiallyDisabled enableChannel tabable model'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!NamedSpec class methodsFor:'documentation'!

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

!NamedSpec class methodsFor:'interface specs'!

basicsEditSpec
    ^ self basicsEditSpecWithModel
!

channelsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NamedSpec andSelector:#channelsEditSpec
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
          bounds: (Rectangle 0 0 419 207)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Channels'
              name: 'FramedBox'
              layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 123 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'VisibilityChannelSubSpecification'
                    layout: (LayoutFrame 0 0.0 3 0.0 4 1.0 28 0)
                    majorKey: UISpecification
                    minorKey: subSpecForVisibilityChannel
                  )
                 (UISubSpecification
                    name: 'EnableChannelSubSpecification'
                    layout: (LayoutFrame 0 0.0 29 0.0 4 1.0 54 0)
                    majorKey: UISpecification
                    minorKey: subSpecForEnableChannel
                  )
                 (UISubSpecification
                    name: 'BGColorChannelSubSpecification'
                    layout: (LayoutFrame 0 0.0 55 0.0 4 1.0 80 0)
                    majorKey: UISpecification
                    minorKey: subSpecForBGColorChannel
                  )
                 )
               
              )
            )
           (FramedBoxSpec
              label: 'CallBacks'
              name: 'FramedBox1'
              layout: (LayoutFrame 0 0.0 117 0 0 1.0 180 0)
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

xbasicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NamedSpec andSelector:#xbasicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: xbasicsEditSpec
       window: 
      (WindowSpec
         label: 'UISpecification Basics'
         name: 'UISpecification Basics'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 400 109)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 106 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 22 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 11 0 5 1.0 33 0)
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
                   layout: (AlignmentOrigin 100 0 49 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 38 0 -15 1.0 60 0)
                   activeHelpKey: model
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
                   layout: (LayoutFrame -15 1 38 0 5 1 60 0)
                   activeHelpKey: model
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseActionMethod:
                   actionValue: model
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!NamedSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        initiallyDisabled
                        initiallyInvisible
                        tabable
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        model
                        "/ listOfAspects has already been provided by the UISpecificationTool
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        enableChannel
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrBooleanOrNil.

    "Modified: / 12-01-2008 / 19:23:51 / cg"
! !

!NamedSpec methodsFor:'accessing'!

initiallyDisabled
    "return the value of the instance variable 'initiallyDisabled' (automatically generated)"

    ^ initiallyDisabled ? false
!

initiallyDisabled:something
    "set the value of the instance variable 'initiallyDisabled' (automatically generated)"

    initiallyDisabled := something.
!

model
    "return the value of the instance variable 'model' (automatically generated)"

    ^ model
!

model:something
    "set the value of the instance variable 'model' (automatically generated)"

    model := something.
!

modelSelector
    "return my model selector"

    ^ model


!

setModel:aModel
    model := aModel


!

tabable
    ^ tabable ? true

    "Modified: / 5.2.2000 / 19:46:51 / cg"
!

tabable:something
    tabable := something.
! !

!NamedSpec methodsFor:'accessing-channels'!

enableChannel
    "return the value of the instance variable 'enableChannel' (automatically generated)"

    ^ enableChannel

    "Created: 28.3.1997 / 21:32:19 / cg"
!

enableChannel:something
    "set the value of the instance variable 'enableChannel' (automatically generated)"

    enableChannel := something

    "Created: 28.3.1997 / 21:32:19 / cg"
! !

!NamedSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    self tabable == true ifTrue:[ self setTabable:aView with:aBuilder ].

    "Modified: / 5.2.2000 / 19:46:14 / cg"
!

setChannelsIn:aView with:aBuilder
    "set channels in aView"

    |channel enaDisa|

    aBuilder isEditing ifTrue:[^self].

    super setChannelsIn:aView with:aBuilder.

    enableChannel isNil ifTrue:[
        enaDisa := self initiallyDisabled ifTrue:[#disable] ifFalse:[#enable].
        "/ could be a visualComponent ...
        aView perform:enaDisa ifNotUnderstood:nil.
    ] ifFalse:[
        aBuilder isEditing ifFalse:[
            channel := self channel:#enableChannel inBuilder:aBuilder.
"/ don't do this:
"/        channel value:(initiallyDisabled not).
            channel notNil ifTrue:[
                aView enableChannel:channel.
            ]
        ]
    ].

    "Modified: / 30.1.1998 / 14:31:58 / cg"
!

setTabable:aView with:aBuilder
    aBuilder makeTabable:aView

    "Created: 5.8.1997 / 18:37:19 / cg"
! !

!NamedSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    initiallyDisabled ~~ true ifTrue:[
        l add:#initiallyDisabled
    ].
    initiallyInvisible ~~ true ifTrue:[
        l add:#initiallyInvisible
    ].
    enableChannel isNil ifTrue:[
        l add:#enableChannel
    ].
    tabable isNil ifTrue:[
        l add:#tabable
    ].

    ^ l

    "Modified: / 20.6.1998 / 13:41:16 / cg"
! !

!NamedSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    initiallyDisabled  := aView enabled not.

    super fromView:aView callBack:aBlock.


! !

!NamedSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    enableChannel notNil ifTrue:[more add:enableChannel].
    ^ more

    "Modified: / 10.2.2000 / 01:24:53 / cg"
!

defaultModelValueFor:someAspect
    "used by the UIDefiner - return the aspects default value"

    someAspect == enableChannel ifTrue:[
        ^ true
    ].

    ^ super defaultModelValueFor:someAspect

    "Created: / 26.10.1997 / 19:03:30 / cg"
    "Modified: / 10.2.2000 / 01:28:04 / cg"
! !

!NamedSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/NamedSpec.st,v 1.69 2017-11-28 18:21:43 cg Exp $'
! !

