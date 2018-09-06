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

ViewWithScrollerSpec subclass:#HTMLViewSpec
	instanceVariableNames:'htmlText'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!HTMLViewSpec class methodsFor:'documentation'!

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

!HTMLViewSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'HTMLViewSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@QDQDQDQDQD0@P@@@@@@@@@ @PH"H"H"H#@ @PH3LQESL1@ @PH3UQYUL1@ @PH5UVUUX1@ @PH5YVYUX1@ @PH5Y&UVX1@ @PH5UVUVT1@ @PH3UVYVL1@ @PH3MVY#L1@ @PLQDQDQDQ@ @P@@@@@@@@@ @2H"H"H"H"H @@@@@@@@@@@@');
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

!HTMLViewSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HTMLViewSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpec
        window: 
       (WindowSpec
          label: 'HTMLView Basics'
          name: 'HTMLView Basics'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 338)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'documentURLAndTextSubSpec'
              layout: (LayoutFrame 0 0.0 -5 0 0 1.0 110 0)
              majorKey: HTMLViewSpec
              minorKey: documentUrlAndTextSubSpec
            )
           (UISubSpecification
              name: 'menuSubSpec'
              layout: (LayoutFrame 0 0.0 113 0 0 1.0 228 0)
              majorKey: UISpecification
              minorKey: menuSubSpec
            )
           (UISubSpecification
              name: 'scrollerSubSpec'
              layout: (LayoutFrame 0 0.0 234 0 0 1.0 331 0)
              majorKey: UISpecification
              minorKey: scrollerSubSpec
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
     UIPainter new openOnClass:HTMLViewSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'HTMLView Details'
         name: 'HTMLView Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 268)
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
                (UISubSpecification
                   name: 'ColorSubspec'
                   minorKey: colorBGSubSpec
                   extent: (Point 400 65)
                 )
                (FramedBoxSpec
                   label: 'Border'
                   name: 'FramedBox1'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Border:'
                         name: 'borderLabel'
                         layout: (AlignmentOrigin 100 0 10 0 1 0.5)
                         activeHelpKey: borderWidth
                         translateLabel: true
                         resizeForLabel: true
                         adjust: left
                       )
                      (InputFieldSpec
                         name: 'borderWidthField'
                         layout: (LayoutFrame 100 0 -1 0 140 0 21 0)
                         activeHelpKey: borderWidth
                         tabable: true
                         model: borderWidth
                         group: inputGroup
                         immediateAccept: false
                         acceptOnLeave: true
                         acceptOnLostFocus: false
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: 'Level:'
                         name: 'levelLabel'
                         layout: (AlignmentOrigin 208 0 10 0 1 0.5)
                         activeHelpKey: level
                         translateLabel: true
                         resizeForLabel: true
                       )
                      (InputFieldSpec
                         name: 'levelField'
                         layout: (LayoutFrame 210 0 -1 0 250 0 21 0)
                         activeHelpKey: level
                         tabable: true
                         model: level
                         group: inputGroup
                         immediateAccept: false
                         acceptOnLeave: true
                         acceptOnLostFocus: false
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: true
                       )
                      )
                    
                   )
                   extent: (Point 400 58)
                 )
                (UISubSpecification
                   name: 'detailsInitSubSpec'
                   majorKey: UISpecification
                   minorKey: detailsInitSubSpec
                   extent: (Point 400 74)
                 )
                (FramedBoxSpec
                   label: 'Keyboard Attributes'
                   name: 'FramedBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Can Tab'
                         name: 'canTab'
                         layout: (LayoutOrigin 10 0 3 0)
                         activeHelpKey: tabable
                         tabable: true
                         model: tabable
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 400 69)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

documentUrlAndTextSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HTMLViewSpec andSelector:#documentUrlAndTextSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: documentUrlAndTextSubSpec
       window: 
      (WindowSpec
         label: 'DocumentUrl and Text SubSpec'
         name: 'DocumentUrl and Text SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 119)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 118 0)
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
                   layout: (LayoutFrame 100 0 9 0 5 1.0 31 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Document URL:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 120 0 45 0 1 0.5)
                   activeHelpKey: documentURL
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'ComboBox1'
                   layout: (LayoutFrame 120 0 34 0 -15 1 56 0)
                   activeHelpKey: documentURL
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
                   layout: (LayoutFrame -15 1 34 0 5 1 56 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                (LabelSpec
                   label: 'HTML Text:'
                   name: 'textLabel'
                   layout: (AlignmentOrigin 120 0 70 0 1 0.5)
                   activeHelpKey: documentText
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 120 0.0 59 0 -15 1.0 81 0)
                   activeHelpKey: documentText
                   tabable: true
                   model: htmlText
                   group: inputGroup
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button2'
                   layout: (LayoutFrame -15 1 59 0 5 1 81 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   enableChannel: hasListSelector
                   actionValue: htmlText
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!HTMLViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        htmlText
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
	    (Basics   basicsEditSpec)
	    (Details  detailsEditSpec)
	    (Channels  channelsEditSpec)
       )

! !

!HTMLViewSpec methodsFor:'accessing'!

htmlText
    "return the value of the instance variable 'htmlText' (automatically generated)"

    ^ htmlText
!

htmlText:something
    "set the value of the instance variable 'htmlText' (automatically generated)"

    htmlText := something.
! !

!HTMLViewSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |holder|

    super setAttributesIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
        model notNil ifTrue:[
            aView documentHolder:(self modelInBuilder:aBuilder)
        ].
        htmlText notNil ifTrue:[
            holder := self getBindingIn:aBuilder binding:htmlText.
            aView htmlTextHolder:holder
        ].
    ]
    ifTrue:[
        aBuilder showDefaults ifTrue:[  
            aView homeText:'
<HTML>
<BODY>
<B>Hello world</B> - this is some <CITE>HTML</CITE> text
</BODY>
'
        ]
    ]

    "Modified: / 21.8.1998 / 20:49:55 / cg"
! !

!HTMLViewSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'HTMLBrowser'


! !

!HTMLViewSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.

    htmlText notNil ifTrue:[more add:htmlText].

    ^ more
! !

!HTMLViewSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitHTMLViewSpec:self
! !

!HTMLViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/HTMLViewSpec.st,v 1.40 2015-11-19 13:51:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/HTMLViewSpec.st,v 1.40 2015-11-19 13:51:04 cg Exp $'
! !

