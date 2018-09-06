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

NamedSpec subclass:#FontMenuSpec
	instanceVariableNames:'allowSymbolicFonts labelsAreEmphasized'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!FontMenuSpec class methodsFor:'documentation'!

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
        used by UISpecifications to add a font menu

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"

! !

!FontMenuSpec class methodsFor:'image specs'!

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
    
    ^ Icon constantNamed:'FontMenuSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@PUUUUU0A@@@@B@D***+HDR???4!!AK@C?R@D,3O=H@R?O@4 AK<?ORLD/3<=H,R?O34 AK???R@D5UUUH<P@@@@"3*****@@@@@@@@b');
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

!FontMenuSpec class methodsFor:'interface specs'!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FontMenuSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'FontMenu Details'
         name: 'FontMenu Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 420 175)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Details'
                   name: 'FramedBox3'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Allow Symbolic Font Names'
                         name: 'CheckBox1'
                         layout: (Point 10 2)
                         activeHelpKey: allowSymbolicFonts
                         tabable: true
                         model: allowSymbolicFonts
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Labels are Emphasized'
                         name: 'CheckBox2'
                         layout: (Point 10 28)
                         activeHelpKey: labelsAreEmphasized
                         tabable: true
                         model: labelsAreEmphasized
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 420 94)
                 )
                (FramedBoxSpec
                   label: 'Keyboard Attributes'
                   name: 'FramedBox2'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Can Tab'
                         name: 'tabableCheckBox'
                         layout: (Point 10 2)
                         activeHelpKey: tabable
                         tabable: true
                         model: tabable
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 420 68)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!FontMenuSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        allowSymbolicFonts
                        labelsAreEmphasized
                     )
        to:env 
        for:anInstance 
        channel:aChannel

    "Modified: / 26.10.1997 / 03:27:35 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^#(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
      )
! !

!FontMenuSpec class methodsFor:'queries'!

supportsLabel
    "answer whether corresponding view instances of the spec class can have labels"

    ^ false



! !

!FontMenuSpec methodsFor:'accessing'!

allowSymbolicFonts
    ^ allowSymbolicFonts
!

allowSymbolicFonts:aBoolean
    allowSymbolicFonts := aBoolean.
!

labelsAreEmphasized
    "gets whether labels are drawn in their font."

    ^ labelsAreEmphasized
!

labelsAreEmphasized:aBoolean
    labelsAreEmphasized := aBoolean.
! !

!FontMenuSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    aView allowSymbolicFonts: allowSymbolicFonts.
    aView labelsAreEmphasized: labelsAreEmphasized.
    aView model:(self modelInBuilder:aBuilder).
    aBuilder makeTabable:aView.
! !

!FontMenuSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    allowSymbolicFonts ifFalse:[l add:#allowSymbolicFonts].
    labelsAreEmphasized ifFalse:[l add:#labelsAreEmphasized].

    ^ l
! !

!FontMenuSpec methodsFor:'initialization'!

initialize
    super initialize.
    allowSymbolicFonts := false.
    labelsAreEmphasized := false.
! !

!FontMenuSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/FontMenuSpec.st,v 1.14 2015-11-19 13:52:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/FontMenuSpec.st,v 1.14 2015-11-19 13:52:38 cg Exp $'
! !

