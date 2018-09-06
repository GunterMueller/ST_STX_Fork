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

ActionButtonSpec subclass:#ButtonSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ButtonSpec class methodsFor:'documentation'!

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

!ButtonSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ButtonSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'Button Basic'
         name: 'Button Basic'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 242)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 148 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 6 0 0 1.0 28 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptOnLeave: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Label:'
                   name: 'labelLabel'
                   layout: (AlignmentOrigin 100 0 42 0 1 0.5)
                   activeHelpKey: label
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'labelInputField'
                   layout: (LayoutFrame 100 0 31 0 0 1 53 0)
                   activeHelpKey: label
                   tabable: true
                   model: label
                   group: inputGroup
                   acceptOnLeave: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 67 0 1 0.5)
                   activeHelpKey: model
                   translateLabel: true
                   resizeForLabel: true
                 )
                (ComboBoxSpec
                   name: 'ComboBox1'
                   layout: (LayoutFrame 100 0 56 0 -15 1 78 0)
                   activeHelpKey: model
                   tabable: true
                   model: model
                   acceptOnLeave: true
                   acceptOnLostFocus: false
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button1'
                   layout: (LayoutFrame -15 1 56 0 5 1 78 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                (LabelSpec
                   label: 'Value:'
                   name: 'valueLabel'
                   layout: (AlignmentOrigin 100 0 92 0 1 0.5)
                   activeHelpKey: buttonModelArg
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'actionValueField'
                   layout: (LayoutFrame 100 0 81 0 0 1.0 103 0)
                   activeHelpKey: buttonModelArg
                   tabable: true
                   model: actionValue
                   group: inputGroup
                   acceptOnLeave: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'basicsEditSubSpec'
             layout: (LayoutFrame 0 0.0 147 0 0 1.0 288 0)
             majorKey: ActionButtonSpec
             minorKey: basicsEditSubSpec
           )
          )
        
       )
     )
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array     
        with:LabelSpec
        with:ActionButtonSpec

    "Created: / 05-09-2012 / 19:26:31 / cg"
! !

!ButtonSpec methodsFor:'building'!

getBindingIn:aBuilder
    "re-redefined to use model again"

    ^ self getBindingIn:aBuilder binding:#model

    "Created: / 30.1.1998 / 04:09:06 / cg"
!

getBindingIn:aBuilder binding:binding
    "re-redefined to get the aspect again"

    ^ aBuilder aspectAt:binding

    "Created: / 30.1.1998 / 04:10:02 / cg"
!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"

    |m pressAction releaseAction aV|

    aBuilder isEditing ifFalse:[
        (m := self modelInBuilder:aBuilder) notNil ifTrue:[
            "/ in contrast to an actionButton,
            "/ that one puts argValue (or true if undefined)
            "/ into the model holder.

            aV := actionValue.
            aV size == 0 ifTrue:[
                aV := true
            ].
            m isBlock ifTrue:[
                self isTriggerOnDown ifTrue:[
                    m numArgs == 0 ifTrue:[
                        pressAction := m.
                    ] ifFalse:[
                        pressAction := [m value:aV].
                    ]
                ] ifFalse:[
                    m numArgs == 0 ifTrue:[
                        releaseAction := m.
                    ] ifFalse:[
                        releaseAction := [m value:aV].
                    ]
                ]
            ] ifFalse:[
                self isTriggerOnDown ifTrue:[
                    pressAction := [m value:aV].
                ] ifFalse:[
                    releaseAction := [m value:aV].
                ]
            ]
        ].

        aView pressAction:pressAction.
        aView releaseAction:releaseAction.
    ]

    "Created: / 30.1.1998 / 04:07:03 / cg"
    "Modified: / 28.7.1998 / 11:16:56 / cg"
! !

!ButtonSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^ 'ModelButton'
! !

!ButtonSpec methodsFor:'queries-UIDefiner'!

defaultModelIsCallBackMethodSelector:someAspect
    "used by the UIPainters aspectGenerator;
     Return true if the aspect specifies an action method
     (or callBack) as opposed to a real model value."

    ^ false

    "Created: / 5.6.1998 / 01:47:40 / cg"
! !

!ButtonSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ButtonSpec.st,v 1.29 2015-11-19 13:51:13 cg Exp $'
! !

