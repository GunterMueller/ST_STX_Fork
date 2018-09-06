"
 COPYRIGHT (c) 2013 by eXept Software AG
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

CheckBoxSpec subclass:#TriggerBoxSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!TriggerBoxSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!TriggerBoxSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self icon inspect
     ImageEditor openOnClass:self andSelector:#icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'TriggerBoxSpec icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU3A????>@G????8@]UU??!!A7?><>@G_?;L8@]??,3 A7?>0N@G_?;L8@]??,3 A>**?>@G????8P_???? C*****@@@@@@@@b');
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

!TriggerBoxSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TriggerBoxSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'TriggerBox Basics'
         name: 'TriggerBox Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 196)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 123 0)
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
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 6 0 1 1 28 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Label:'
                   name: 'labelLabel'
                   layout: (AlignmentOrigin 100 0 42 0 1 0.5)
                   activeHelpKey: label
                   translateLabel: true
                 )
                (InputFieldSpec
                   name: 'labelField'
                   layout: (LayoutFrame 100 0 31 0 1 1 53 0)
                   activeHelpKey: label
                   tabable: true
                   model: label
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Action:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 67 0 1 0.5)
                   activeHelpKey: booleanModel
                   translateLabel: true
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 56 0 -20 1 78 0)
                   activeHelpKey: booleanModel
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
                   layout: (LayoutFrame -20 1 56 0 0 1 78 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseActionMethod:nameAs:
                   actionValue: model
                   actionValue2: 'action'
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Label Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 122 0 0 1.0 193 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Label is Image'
                   name: 'imageLabelCheckBox'
                   layout: (Point 7 5)
                   activeHelpKey: labelIsImage
                   tabable: true
                   model: hasImageOrientedLabel
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Translate Label'
                   name: 'translateLabelCheckBox'
                   layout: (Point 162 5)
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
! !

!TriggerBoxSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        actionValue
                     )
        to:env 
        for:inst 
        channel:aChannel.
! !

!TriggerBoxSpec methodsFor:'building'!

getBindingIn:aBuilder binding:binding
    |action|

    binding = model ifTrue:[
        action := aBuilder actionFor:model.
        ^ action
    ].
    ^ super getBindingIn:aBuilder binding:binding
!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"

    |m action channel|

    model notNil ifTrue:[
        aBuilder isEditing ifFalse:[
            (m := self modelInBuilder:aBuilder) notNil ifTrue:[
                "/ an actionButton simply sends the model message
                "/ to the application

                m isBlock ifTrue:[
                    action := m.
                ] ifFalse:[
                    channel := m.
                ]
            ] ifFalse:[
                "/ no action ?!!
                ('TriggerBoxSpec[info]: app provides no actionFor: ' , model printString) infoPrintCR.
            ].

            action notNil ifTrue:[ aView action:action ].
            channel notNil ifTrue:[ aView triggerChannel:channel ].
        ]
    ]
! !

!TriggerBoxSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^ 'TriggerBox'
! !

!TriggerBoxSpec methodsFor:'queries - UIPainter'!

defaultModelIsCallBackMethodSelector:someAspect
    "used by the UIPainters aspectGenerator;
     Return true if the aspect specifies an action method
     (or callBack) as opposed to a real model value."

    ^ someAspect == model
! !

!TriggerBoxSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitTriggerBoxSpec:self
! !

!TriggerBoxSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/TriggerBoxSpec.st,v 1.4 2017-01-23 23:39:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/TriggerBoxSpec.st,v 1.4 2017-01-23 23:39:29 cg Exp $'
! !

