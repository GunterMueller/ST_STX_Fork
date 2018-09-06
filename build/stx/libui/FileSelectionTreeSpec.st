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

SelectionInTreeViewSpec subclass:#FileSelectionTreeSpec
	instanceVariableNames:'itemClass monitoringDelayTime monitoring'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!FileSelectionTreeSpec class methodsFor:'documentation'!

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

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"





! !

!FileSelectionTreeSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileSelectionTreeSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'FileSelectionTree Basics'
         name: 'FileSelectionTree Basics'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 336)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 123 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'idLabel'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'idField'
                   layout: (LayoutFrame 100 0 6 0 5 1 28 0)
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
                   layout: (AlignmentOrigin 100 0 42 0 1 0.5)
                   activeHelpKey: selectionHolder
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 31 0 5 1 53 0)
                   activeHelpKey: selectionHolder
                   tabable: true
                   model: model
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Root:'
                   name: 'rootLabel'
                   layout: (AlignmentOrigin 100 0 67 0 1 0.5)
                   activeHelpKey: fileSelectionTreeRoot
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'hierarchicalListField'
                   layout: (LayoutFrame 100 0 56 0 5 1 78 0)
                   activeHelpKey: fileSelectionTreeRoot
                   tabable: true
                   model: hierarchicalList
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'menuSubSpec'
             layout: (LayoutFrame 0 0.0 122 0 0 1.0 237 0)
             majorKey: UISpecification
             minorKey: menuSubSpec
           )
          (UISubSpecification
             name: 'scrollerSubSpec'
             layout: (LayoutFrame 0 0.0 241 0 0 1.0 352 0)
             majorKey: UISpecification
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
     UIPainter new openOnClass:FileSelectionTreeSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'FileSelectionTree Channels'
         name: 'FileSelectionTree Channels'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 321)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 96 0)
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
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 29 0.0 4 1.0 54 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'CallBacks'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 96 0 0 1.0 158 0)
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
          (FramedBoxSpec
             label: 'Callbacks - Selection'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 157 0.0 0 1.0 322 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification4'
                   layout: (LayoutFrame 0 0.0 4 0.0 4 1.0 32 0)
                   majorKey: UISpecification
                   minorKey: subSpecForSelectedValueChangeCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification5'
                   layout: (LayoutFrame 0 0.0 29 0.0 4 1.0 57 0)
                   majorKey: UISpecification
                   minorKey: subSpecForSelectConditionCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification6'
                   layout: (LayoutFrame 0 0.0 54 0.0 4 1.0 82 0)
                   majorKey: UISpecification
                   minorKey: subSpecForDoubleClickCallBack
                 )
                (LabelSpec
                   label: 'Val.DblClick:'
                   name: 'validateDoubleClickLabel'
                   layout: (AlignmentOrigin 100 0 91 0 1 0.5)
                   activeHelpKey: validateDoubleClickSelector
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'validateDoubleClickSelectorField'
                   layout: (LayoutFrame 100 0 80 0 4 1 102 0)
                   activeHelpKey: validateDoubleClickSelector
                   tabable: true
                   model: validateDoubleClickSelector
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Val.Expand:'
                   name: 'validateExpandabilityLabel'
                   layout: (AlignmentOrigin 100 0 116 0 1 0.5)
                   activeHelpKey: validateExpandabilitySelector
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'validateExpandabilitySelectorField'
                   layout: (LayoutFrame 100 0 105 0 4 1 127 0)
                   activeHelpKey: validateExpandabilitySelector
                   tabable: true
                   model: validateExpandabilitySelector
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

details2EditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileSelectionTreeSpec andSelector:#details2EditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: details2EditSpec
       window: 
      (WindowSpec
         label: 'FileSelectionTree Details2'
         name: 'FileSelectionTree Details2'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 338)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'details2EditSpec'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 267 0)
             majorKey: SelectionInTreeViewSpec
             minorKey: details2EditSpec
           )
          (FramedBoxSpec
             label: 'Monitoring'
             name: 'monitoringBox'
             layout: (LayoutFrame 0 0 270 0 0 1.0 340 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Enable'
                   name: 'monitoringCheckBox'
                   layout: (Point 7 4)
                   activeHelpKey: monitoring
                   tabable: true
                   model: monitoring
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Delay Time:'
                   name: 'delayTimeLabel'
                   layout: (AlignmentOrigin 202 0 18 0 1 0.5)
                   activeHelpKey: monitoringDelayTime
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'monitoringDelayTimeField'
                   layout: (LayoutFrame 204 0 7 0 2 1.0 29 0)
                   activeHelpKey: monitoringDelayTime
                   tabable: true
                   model: monitoringDelayTime
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
     UIPainter new openOnClass:FileSelectionTreeSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'FileSelectionTree Details'
         name: 'FileSelectionTree Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 321)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'detailsEditSpec'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 276 0)
             majorKey: SelectionInTreeViewSpec
             minorKey: detailsEditSpec
           )
          (FramedBoxSpec
             label: 'Filter'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0 253 0 0 1.0 319 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Class:'
                   name: 'classLabel'
                   layout: (AlignmentOrigin 100 0 16 0 1 0.5)
                   activeHelpKey: fileSelectionFilterClas
                   translateLabel: true
                   resizeForLabel: true
                 )
                (ComboBoxSpec
                   name: 'itemClassComboBox'
                   layout: (LayoutFrame 100 0 5 0 -1 1.0 27 0)
                   activeHelpKey: fileSelectionFilterClas
                   tabable: true
                   model: itemClass
                   acceptOnPointerLeave: false
                   comboList: itemClassList
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!FileSelectionTreeSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        monitoring
                        itemClass
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        monitoringDelayTime
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#numberOrNil.

    env at:#itemClassList       put:#( 'Directory' 'File' ) asValue.

    "Modified: / 26.10.1997 / 03:27:00 / cg"
! !

!FileSelectionTreeSpec methodsFor:'accessing'!

itemClass
    "return the value of the instance variable 'itemClass' (automatically generated)"

    ^ itemClass
!

itemClass:something
    "set the value of the instance variable 'itemClass' (automatically generated)"

    (itemClass := something) notNil ifTrue:[
        itemClass := something withoutSeparators.

        itemClass size == 0 ifTrue:[
            itemClass := nil
        ]
    ].
!

monitoring
    "return the value of the instance variable 'monitoring' (automatically generated)"

    ^ monitoring ? false
!

monitoring:something
    "set the value of the instance variable 'monitoring' (automatically generated)"

    monitoring := something.
!

monitoringDelayTime
    "return the value of the instance variable 'monitoringDelayTime' (automatically generated)"

    monitoringDelayTime isNil ifTrue:[
        monitoringDelayTime :=  FileSelectionTree monitoringDelayTime
    ].
    ^ monitoringDelayTime
!

monitoringDelayTime:something
    "set the value of the instance variable 'monitoringDelayTime' (automatically generated)"

    monitoringDelayTime := something.
! !

!FileSelectionTreeSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |cls list item|

    aBuilder isEditing ifFalse:[
        itemClass size > 0 ifTrue:[
            itemClass = 'Directory' ifTrue:[
                cls := FileSelectionItem filterClassForDirectoriesOnly.
            ] ifFalse:[
                itemClass = 'File' ifTrue:[
                    cls := FileSelectionItem filterClassForFilesOnly.
                ] ifFalse:[
                    cls := self resolveName:itemClass in:aBuilder.
                ]
            ].

            cls notNil ifTrue:[ 
                aView itemClass:cls
            ]
        ].
        aView monitoring:(self monitoring).
        aView monitoringDelayTime:(self monitoringDelayTime).
    ].

    super setAttributesIn:aView with:aBuilder.

    (aBuilder isEditing "and:[aBuilder showDefaults]") ifTrue:[
        item := TreeItem name:'File Tree List' contents:nil.
        list := Array with:(TreeItem name:'File 1')
                      with:(TreeItem name:'File 2').
        item children:list.
        aView itemClass:TreeItem.
        aView root: item
    ]
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    self monitoring ifFalse:[
        l add:#monitoring.
        l add:#monitoringDelayTime.
    ] ifTrue:[
        self monitoringDelayTime == FileSelectionTree monitoringDelayTime ifTrue:[
            l add:#monitoringDelayTime
        ]
    ].
    itemClass size == 0 ifTrue:[
        l add:#itemClass
    ].    
  ^ l

    "Modified: / 20.6.1998 / 13:40:56 / cg"
! !

!FileSelectionTreeSpec methodsFor:'queries'!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"

    |path model|

    aBuilder isEditing ifFalse:[
        model := self modelInBuilder:aBuilder.

        (path := hierarchicalList) isSymbol ifTrue:[
            path := self getBindingIn:aBuilder binding:hierarchicalList
        ].

        (model isMemberOf:SelectionInTree) ifTrue:[
            aView model:model.

            path notNil ifTrue:[
                (path isMemberOf:TreeItem) ifFalse:[
                    aView directory:path value asFilename
                ] ifTrue:[
                    model root:path
                ]
            ].
            ^ self
        ].
        
        aView selectionHolder:(self modelInBuilder:aBuilder).

        path notNil ifTrue:[
             (path isString or:[path isMemberOf:Filename]) ifTrue:[
                aView directory:path asFilename
             ] ifFalse:[
                aView rootHolder:path
             ]
        ]
    ]

!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'FileTreeList'

!

viewClass
    "return the corresponding view class of the spec"

    ^ FileSelectionTree


! !

!FileSelectionTreeSpec methodsFor:'queries-UIDefiner'!

defaultModelValueFor:someAspect
    "used by the UIDefiner - return the aspects default value"

    someAspect == hierarchicalList ifTrue:[
        ^ '.'
    ].
    ^ super defaultModelValueFor:someAspect

    "Modified: / 10.2.2000 / 01:28:02 / cg"
! !

!FileSelectionTreeSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitFileSelectionTreeSpec:self
! !

!FileSelectionTreeSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/FileSelectionTreeSpec.st,v 1.50 2015-11-19 13:53:17 cg Exp $'
! !

