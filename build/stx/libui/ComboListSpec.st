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

WidgetSpec subclass:#ComboListSpec
	instanceVariableNames:'comboList useIndex hidePullDownMenuButton'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ComboListSpec class methodsFor:'documentation'!

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

!ComboListSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'ComboListSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU3A????>@G@@@@8@\UUU3!!A1?<BN@GG??88@\:**# A0@@@N@GEUUS8@\UUUO A1UUT>@G@@@C8P_???? C*****@@@@@@@@b');
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

!ComboListSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ComboListSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'ComboList Basics'
         name: 'ComboList Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 189)
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
                   name: 'modelListSubSpec'
                   minorKey: modelListSubSpec
                   extent: (Point 400 121)
                 )
                (FramedBoxSpec
                   label: 'Menu'
                   name: 'FramedBox1'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Do Not Show Dropdown Menu Button'
                         name: 'CheckBox1'
                         layout: (LayoutFrame 25 0 3 0 346 0 26 0)
                         activeHelpKey: noMenuButton
                         tabable: true
                         model: hidePullDownMenuButton
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 400 62)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!ComboListSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        useIndex
                        hidePullDownMenuButton
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        listSelector
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#arrayLiteralOrSymbolOrNil.

    "Modified: / 26.10.1997 / 14:20:21 / cg"
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array     
        with:ComboBoxSpec
        with:PopUpListSpec

    "Created: / 12-01-2008 / 23:58:05 / cg"
! !

!ComboListSpec methodsFor:'accessing'!

comboList
    "return the value of the instance variable 'comboList' (automatically generated)"

    ^ comboList
!

comboList:something
    "set the value of the instance variable 'comboList' (automatically generated)"

    comboList := something.
!

hidePullDownMenuButton
    ^hidePullDownMenuButton ? false
!

hidePullDownMenuButton: something
    hidePullDownMenuButton := something
!

listSelector
    ^ comboList


!

listSelector:something
    self comboList:something


!

useIndex
    "return the value of the instance variable 'useIndex' (automatically generated)"

    ^ useIndex ? false
!

useIndex:something
    "set the value of the instance variable 'useIndex' (automatically generated)"

    useIndex := something.
! !

!ComboListSpec methodsFor:'building'!

nameShownWhileEditingFor:aView
    (model notNil) ifTrue:[ ^ model].
    ^ aView name

    "Modified: / 30.10.2001 / 13:59:25 / cg"
    "Created: / 30.10.2001 / 14:46:56 / cg"
!

setAttributesIn:aView with:aBuilder
    |button field|

    super setAttributesIn:aView with:aBuilder.

    aView isView ifTrue:[
        button := aView menuButton.    
        field := aView field.
        self hidePullDownMenuButton ifTrue:[  
            button isVisible ifTrue:[
                button beInvisible.
            ].
            field rightInset: 0.
        ] ifFalse:[
            button isVisible ifFalse:[
                button beVisible.
            ].
            field rightInset:(button width).
        ].
    ].

    "Modified: / 16-01-2008 / 10:59:54 / cg"
!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"

    aBuilder isEditing ifTrue:[
        aView contents:(self nameShownWhileEditingFor:aView).
    ] ifFalse:[
        self setModelIn:aView useIndex:useIndex with:aBuilder
    ]

    "Modified: / 30.10.2001 / 14:47:03 / cg"
!

validateModel:aModel forView:aView withValue:constantList
    "about to set the model.
     If it's a plain valueHolder, change the listMessage
     to #value"

    ^ self
        validateSelectionInListModel:aModel forView:aView withValue:constantList

    "Created: / 26-10-1997 / 19:11:51 / cg"
    "Modified (comment): / 13-02-2017 / 19:58:46 / cg"
! !

!ComboListSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.
    comboList notNil ifTrue:[comboList := comboList decodeAsLiteralArray].

    "Created: / 26-03-2007 / 13:59:55 / cg"
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    useIndex isNil                      ifTrue:[l add:#useIndex].
    hidePullDownMenuButton isNil        ifTrue:[l add:#hidePullDownMenuButton].
    ^l
! !

!ComboListSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    useIndex := aView useIndex.
    super fromView:aView callBack:aBlock
! !

!ComboListSpec methodsFor:'queries'!

usefulReplacementSpecClassNames
    ^ #( ComboBoxSpec InputFieldSpec PopUpListSpec )
! !

!ComboListSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    comboList notNil ifTrue:[more add:comboList ].
    ^ more

    "Modified: / 10.2.2000 / 01:25:14 / cg"
!

defaultModelClassFor:someAspect
    "used by the UIPainters aspectGenerator"

    comboList notNil ifTrue:[
        ^ super defaultModelClassFor:someAspect
    ].
    ^ SelectionInList

    "Modified: / 26.10.1997 / 18:58:20 / cg"
! !

!ComboListSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitComboListSpec:self
! !

!ComboListSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ComboListSpec.st,v 1.66 2017-02-13 19:03:29 cg Exp $'
! !

