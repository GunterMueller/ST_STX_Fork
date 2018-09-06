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

NamedSpec subclass:#WidgetSpec
	instanceVariableNames:'callbacksSpec foregroundColor backgroundColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!WidgetSpec class methodsFor:'documentation'!

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
        Claus Gittinger
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"

! !

!WidgetSpec class methodsFor:'interface specs'!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:WidgetSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'CheckBox Details'
         name: 'CheckBox Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 413 288)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'fontColorSubSpec'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 127 0)
             majorKey: UISpecification
             minorKey: fontColorSubSpec
           )
          (UISubSpecification
             name: 'detailsInitSubSpec'
             layout: (LayoutFrame 0 0.0 131 0 0 1.0 200 0)
             majorKey: UISpecification
             minorKey: detailsInitSubSpec
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 200 0 0 1.0 270 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'tabable'
                   layout: (Point 10 3)
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

!WidgetSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        colors
                        foregroundColor
                        backgroundColor
                        callbacksSpec 
                        style
                     )
        to:env 
        for:inst 
        channel:aChannel.

!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Channels channelsEditSpec)
       )

! !

!WidgetSpec methodsFor:'accessing'!

callbacksSpec
    "return the value of the instance variable 'callbacksSpec' (automatically generated)"

    ^ callbacksSpec
!

callbacksSpec:something
    "set the value of the instance variable 'callbacksSpec' (automatically generated)"

    callbacksSpec := something.
! !

!WidgetSpec methodsFor:'accessing-color & font'!

backgroundColor

    ^ backgroundColor
!

backgroundColor: aColor

    backgroundColor := aColor
!

foregroundColor

    ^ foregroundColor
!

foregroundColor: aColor

    foregroundColor := aColor
! !

!WidgetSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    foregroundColor notNil 
        ifTrue: [aView foregroundColor:(self resolveColor:foregroundColor ifUnknown:[Color red] with:aBuilder)]
        ifFalse:[aBuilder isEditing ifTrue: [aView foregroundColor: Color black]].
    backgroundColor notNil 
        ifTrue: [aView backgroundColor:(self resolveColor:backgroundColor ifUnknown:[Color yellow] with:aBuilder)]
        ifFalse:[aBuilder isEditing ifTrue: [aView backgroundColor: self viewClass defaultViewBackgroundColor]].
    self setModelAttributeIn:aView with:aBuilder
! !

!WidgetSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    style notNil ifTrue:[style := style decodeAsLiteralArray].
    callbacksSpec notNil ifTrue:[callbacksSpec   := callbacksSpec decodeAsLiteralArray].
    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].

    "Modified: / 19.4.1998 / 12:46:00 / cg"
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    style             isNil ifTrue:[l add:#style].
    foregroundColor   isNil ifTrue:[l add:#foregroundColor].
    backgroundColor   isNil ifTrue:[l add:#backgroundColor].

    ^ l

    "Modified: / 20.6.1998 / 13:42:00 / cg"
! !

!WidgetSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    style           := aView font.
    foregroundColor := aView foregroundColor.
    backgroundColor := aView backgroundColor.

    super fromView:aView callBack:aBlock.


! !

!WidgetSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/WidgetSpec.st,v 1.54 2017-11-28 18:21:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/WidgetSpec.st,v 1.54 2017-11-28 18:21:54 cg Exp $'
! !

