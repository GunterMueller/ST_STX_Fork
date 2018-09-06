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

InputFieldSpec subclass:#ComboBoxSpec
	instanceVariableNames:'comboList useIndex isFilenameBox resizableMenu comboMenuHolder
		comboMenuPerformer'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ComboBoxSpec class methodsFor:'documentation'!

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

!ComboBoxSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'ComboBoxSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU3A????>@G@@@@8@\***3!!A2UUUN@GHDET8@\5UUS A0@@@N@GEUUS8@\UUUO A1UUT>@G@@@C8P_???? C*****@@@@@@@@b');
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

!ComboBoxSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ComboBoxSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'ComboBox Basics'
         name: 'ComboBox Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 423 402)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'modelListSubSpec'
             layout: (LayoutFrame 0 0.0 5 0 0 1.0 119 0)
             minorKey: modelListSubSpec
           )
          (UISubSpecification
             name: 'menuSubSpec'
             layout: (LayoutFrame 0 0.0 120 0 0 1.0 235 0)
             majorKey: ComboBoxSpec
             minorKey: menuSubSpec
           )
          (FramedBoxSpec
             label: 'Field Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 237 0 0 1.0 388 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Type:'
                   name: 'typeLabel'
                   layout: (AlignmentOrigin 100 0 20 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                 )
                (PopUpListSpec
                   label: 'string'
                   name: 'typePopUpList'
                   layout: (LayoutFrame 100 0 9 0 5 1.0 33 0)
                   activeHelpKey: typeConverter
                   translateLabel: true
                   tabable: true
                   model: type
                   menu: typeList
                 )
                (LabelSpec
                   label: 'Converter:'
                   name: 'converterLabel'
                   layout: (AlignmentOrigin 100 0 50 0 1 0.5)
                   activeHelpKey: converter
                   translateLabel: true
                 )
                (InputFieldSpec
                   name: 'converterField'
                   layout: (LayoutFrame 100 0 37 0 5 1 59 0)
                   activeHelpKey: converter
                   tabable: true
                   model: converter
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Size:'
                   name: 'sizeLabel'
                   layout: (AlignmentOrigin 100 0 75 0 1 0.5)
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'sizeField'
                   layout: (LayoutFrame 100 0 63 0 140 0 85 0)
                   activeHelpKey: maxChars
                   tabable: true
                   model: numChars
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'FormatString:'
                   name: 'formatStringLabel'
                   layout: (AlignmentOrigin 248 0 75 0 1 0.5)
                   activeHelpKey: formatString
                   foregroundChannel: greyIfFormatStringDisabled
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'formatStringField'
                   layout: (LayoutFrame 248 0 63 0 5 1 85 0)
                   activeHelpKey: formatString
                   enableChannel: formatStringEnabled
                   tabable: true
                   model: formatString
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'MinValue:'
                   name: 'minLabel'
                   layout: (AlignmentOrigin 100 0 100 0 1 0.5)
                   activeHelpKey: minValue
                   foregroundChannel: greyIfMinMaxDisabled
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'minValueField'
                   layout: (LayoutFrame 100 0 89 0 160 0 111 0)
                   activeHelpKey: minValue
                   enableChannel: minMaxEnabled
                   tabable: true
                   model: minValue
                   group: inputGroup
                   type: numberOrNil
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'MaxValue:'
                   name: 'maxLabel'
                   layout: (AlignmentOrigin 269 0 100 0 1 0.5)
                   activeHelpKey: maxValue
                   foregroundChannel: greyIfMinMaxDisabled
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'maxValueField'
                   layout: (LayoutFrame 273 0 89 0 343 0 111 0)
                   activeHelpKey: maxValue
                   enableChannel: minMaxEnabled
                   tabable: true
                   model: maxValue
                   group: inputGroup
                   type: numberOrNil
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

menuSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ComboBoxSpec andSelector:#menuSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: menuSubSpec
       window: 
      (WindowSpec
         label: 'Menu SubSpec'
         name: 'Menu SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 123)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Combol Menu'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 120 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Selector:'
                   name: 'selectorLabel'
                   layout: (AlignmentOrigin 100 0 18 0 1 0.5)
                   activeHelpKey: comboMenuId
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'menuField'
                   layout: (LayoutFrame 100 0 7 0 5 1.0 29 0)
                   activeHelpKey: comboMenuId
                   tabable: true
                   model: comboMenuHolder
                   group: inputGroup
                   acceptOnLeave: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Performer:'
                   name: 'performerLabel'
                   layout: (AlignmentOrigin 100 0 43 0 1 0.5)
                   activeHelpKey: comboMenuPerformer
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'performerField'
                   layout: (LayoutFrame 100 0 32 0 5 1.0 54 0)
                   activeHelpKey: comboMenuPerformer
                   tabable: true
                   model: comboMenuPerformer
                   group: inputGroup
                   acceptOnLeave: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (ActionButtonSpec
                   label: 'Menu Editor'
                   name: 'menuButton'
                   layout: (LayoutFrame 100 0 59 0 5 1 83 0)
                   activeHelpKey: comboMenuButton
                   translateLabel: true
                   tabable: true
                   model: openEditMenu
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!ComboBoxSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    env at:#typeList put:((env at:#typeList) copyWith:#fileName). 

    self 
        adaptApects:
                    #(  
                        useIndex
                        comboMenuHolder
                        comboMenuPerformer
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

    "Modified: / 26.10.1997 / 14:20:28 / cg"
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array     
        with:InputFieldSpec

    "Created: / 12-01-2008 / 23:58:51 / cg"
! !

!ComboBoxSpec methodsFor:'accessing'!

comboList
    "return the comboList aspect name"

    ^ comboList

    "Created: 14.2.1997 / 15:59:01 / cg"
!

comboList:something
    "set the comboList aspect name"

    comboList := something.

    "Created: 14.2.1997 / 15:59:02 / cg"
!

comboMenuHolder
    ^ comboMenuHolder
!

comboMenuHolder:something
    comboMenuHolder := something.
!

comboMenuPerformer
    ^ comboMenuPerformer
!

comboMenuPerformer:something
    comboMenuPerformer := something.
!

isFilenameBox
    ^ isFilenameBox
!

isFilenameBox:something
    isFilenameBox := something.
!

listSelector
    ^ comboList
!

listSelector:something
    self comboList:something
!

resizableMenu
    "as yet unimplemented"

    ^ resizableMenu
!

resizableMenu:something
    "as yet unimplemented"

    resizableMenu := something.
!

type
    isFilenameBox == true ifTrue:[
        ^ #fileName
    ].
    ^ super type
!

type:aSymbol
    aSymbol == #fileName ifTrue:[
        super type:#string.
        isFilenameBox := true.
        ^ self
    ].
    isFilenameBox := false.
    super type:aSymbol
!

useIndex
    ^ useIndex ? false
!

useIndex:something
    useIndex := something.
! !

!ComboBoxSpec methodsFor:'building'!

defineCallBacksFor:aBuilder view:aView
    |sel|

    "/ transform ST-80 Style callBackSpec
    "/ into ST/X actions ...

    (aBuilder isEditing or:[callbacksSpec isNil]) ifFalse:[
        sel := callbacksSpec valueChangeSelector.
        sel notNil ifTrue:[
            aView action:(self callBackActionFor:sel with:aBuilder)
        ]
    ].

    "Modified: / 20.6.1998 / 13:43:16 / cg"
!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"

    |m|

    self setModelIn:aView useIndex:(self useIndex) with:aBuilder.
    autoSelectInitialText == true ifTrue:[
        aView selectAllInitially
    ].
    aBuilder isEditing ifFalse:[
        comboMenuHolder notNil ifTrue:[
            m := aBuilder menuFor:comboMenuHolder. "/ self model:comboMenuHolder inBuilder:aBuilder.
            aView comboMenuHolder:m.
            comboMenuPerformer notNil ifTrue:[
                aView comboMenuPerformer:self model:comboMenuPerformer inBuilder:aBuilder.
            ]
        ].
    ].

"/    resizableMenu == true ifTrue:[
"/        "as yet unimplemented"
"/
"/        aView resizableMenu:true
"/    ].
! !

!ComboBoxSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.
    comboList notNil ifTrue:[comboList := comboList decodeAsLiteralArray].
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    useIndex isNil                      ifTrue:[l add:#useIndex].
    isFilenameBox isNil                 ifTrue:[l add:#isFilenameBox].
    resizableMenu isNil                 ifTrue:[l add:#resizableMenu].
    comboMenuHolder isNil               ifTrue:[l add:#comboMenuHolder].
    comboMenuPerformer isNil            ifTrue:[l add:#comboMenuPerformer].
    ^l
! !

!ComboBoxSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    |c|

    (c := aView converter) notNil ifTrue:[
        type := c type    
    ].
    (type == #password and:[aView passwordCharacter notNil]) ifTrue:[
        type := #password
    ].

    super fromView:aView callBack:aBlock.


! !

!ComboBoxSpec methodsFor:'queries'!

usefulReplacementSpecClassNames
    ^ #( ComboListSpec InputFieldSpec )
!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^self class userFriendlyName

!

viewClass
    "return the corresponding view class of the spec"

    self class == ComboBoxSpec ifTrue:[
        isFilenameBox == true ifTrue:[
            ^ FilenameComboBoxView
        ].
        ^ ComboBoxView
    ].
    ^ super viewClass
! !

!ComboBoxSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    comboList notNil ifTrue:[more add:comboList].
    ^ more

    "Modified: / 10.2.2000 / 01:25:17 / cg"
! !

!ComboBoxSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitComboBoxSpec:self
! !

!ComboBoxSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ComboBoxSpec.st,v 1.68 2016-08-25 21:12:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/ComboBoxSpec.st,v 1.68 2016-08-25 21:12:30 cg Exp $'
! !

