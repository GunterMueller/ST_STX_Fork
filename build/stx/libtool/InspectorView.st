"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

SimpleView subclass:#InspectorView
	instanceVariableNames:'listView labelView workspace inspectedObject selectedLine nShown
		hasMore monitorProcess hideReceiver integerDisplayRadix
		inspectHistory allowFollow isStandaloneInspector selectionIndex
		object inspectedObjectHolder displayStringMessage
		suppressPseudoSlots dereferenceValueHolders suppressHeadline
		headLineLabel sortOrder hideMessages hideHashes
		holderChangeInterest sortOrderHolder'
	classVariableNames:'DefaultIcon DefaultIntegerDisplayRadix ExpandArraysInAllLists
		IdDictionary LastExtent NextSequentialID SortOrderAlphabetical
		SortOrderInstvarOrder DefaultHideMessages DefaultHideHashes'
	poolDictionaries:''
	category:'Interface-Inspector'
!

!InspectorView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    This class implements a graphical inspector.
    Inspecting can be done on an object -
    (where its instvarnames/values are inspected)
    or a list of objects (where a nameArray/valuesArray is inspected).
    The later is used by the debugger to inspect method variables/args.

    The system calls the inspector through the global variable 'Inspector'
    which is bound to this class (but could be redefined - it actually is
    set to MiniInspector in a smalltalk without graphical user interface,
    or to NewInspector if that is wanted).

    Also notice, that there are two methods to inspect an object:
    sending #basicInspect to any object, will open this kind of inspector on 
    it (showing instance variables which are physically present).

    Sending it #inspect, will - depending on the object - sometimes invoke a
    specialized inspector. 
    (see OrderedCollectionInspectorView, ImageInspectorView, 
     ColorInspectorView etc. as examples).

    You can also open a monitoring inspector, which displays some instance
    variable in regular intervals. See #openOn:monitor:.

    examples:
            #(1 2 3 4) asOrderedCollection inspect
            #(1 2 3 4) asOrderedCollection basicInspect
            (Array new:10000) inspect
            (Image fromFile:'bitmaps/claus.gif') inspect
            (Image fromFile:'bitmaps/claus.gif') basicInspect
            (Image fromFile:'bitmaps/SBrowser.xbm') inspect
            (Image fromFile:'bitmaps/SBrowser.xbm') basicInspect

            InspectorView openOn:Display
            InspectorView openOn:Display monitor:'shiftDown'
            InspectorView openOn:(Image fromScreen)
            InspectorView openOn:(Image fromFile:'banner8.xpm')

    The InspectorView can also be used as a subComponent within another view.
    In this case, the isStandAlone flag should be cleared, to prevent the
    inspector from changing the topViews window label.

    Notice:
        the instvars 'inspectedObject' and 'selectedLine' have been 
        renamed to 'object' and 'selectionIndex' for squeak compatibility;
        however, the old vars are kept (in sync) for a while, to allow for
        smooth migration.

  Controlling the contents from the inspected object.

    By redefining inspectorExtraAttributes or inspectorExtraNamedFields, the inspected
    object can add items to the list of fields as ashown in the left list-view of the inspector.
    These methods are meant to return a sequencable Collection of Associations, which represent
    of pseudo slot-name, slot-value pairs.
    In the list, extra attributes are shown with a dash (-), extra named fields are marked with a tick (`).
    These are added (read only) to the list.

    [author:]
        Claus Gittinger
"
! !

!InspectorView class methodsFor:'initialization'!

initialize
    SortOrderAlphabetical := #alphabetical.
    SortOrderInstvarOrder := #instvarOrder
! !

!InspectorView class methodsFor:'instance creation'!

for:anObject
    "create and launch a new inspector for anObject.
     This protocol is a historic leftover - this method will vanish."

    ^ self openOn:anObject
!

inspect:anObject
    "create and launch a new inspector for anObject.
     This protocol is a historic leftover - this method will vanish."

    ^ self openOn:anObject
!

openOn:anObject
    "create and launch a new inspector for anObject"

    ^ self openOn:anObject monitor:nil

    "
     InspectorView openOn:(5 @ 7)
     InspectorView openOn:(Array new:400)
     DictionaryInspectorView openOn:(IdentityDictionary new)
    "

    "Modified: 1.3.1996 / 19:31:03 / cg"
!

openOn:anObject monitor:anInstVarNameOrNil
    "create and launch a new inspector for anObject.
     If anInstVarNameOrNil is nonNil, let the inspector monitor it
     (use an integer-printString as name, for indexed instVars)."

    |topView inspectorView|

    topView := StandardSystemView new.
    topView
        icon:self defaultIcon;
        label:'Inspector';
        iconLabel:'Inspector';  
        extent:self defaultTopViewExtent;
        objectAttributeAt:#rememberExtent put:true.

    inspectorView := self origin:(0.0 @ 0.0)
                          corner:(1.0 @ 1.0)
                             in:topView.

    "kludge: must realize first, to be able to set menu again"
    topView openAndWait.
    topView windowGroup 
        focusSequence:(Array 
                            with:inspectorView listView
                            with:inspectorView workspace).
    inspectorView 
        allowFollow:true;
        isStandaloneInspector:true;
        inspect:anObject.

    anInstVarNameOrNil notNil ifTrue:[
        inspectorView monitor:anInstVarNameOrNil
    ].

    ^ inspectorView

    "
     |m|

     m := 1 asValue.
     InspectorView openOn:m monitor:'value'.

     2 to:10 do:[:i |
         Delay waitForSeconds:1.
         m value:i
     ]
    "

    "
     |o|

     o := Array with:1 with:2 with:3.
     InspectorView openOn:o monitor:'2'.
     Delay waitForSeconds:1.
     o at:2 put:20
    "

    "Created: / 01-03-1996 / 19:30:50 / cg"
    "Modified: / 23-10-2007 / 19:08:21 / cg"
!

openOn:anObject title:aString
    "create and launch a new inspector for anObject"

    (self openOn:anObject monitor:nil) topView label:aString

    "
     InspectorView openOn:(5 @ 7) title:'my point'
    "
!

openOn:anObject withEvalPane:withEvalPane
    ^ self openOn:anObject
!

openOn:anObject withEvalPane:withEvalPane withLabel:aLabel
    ^ self openOn:anObject
! !

!InspectorView class methodsFor:'common label support'!

commonLabelFor:anObject
    "return the windowLabel to use in my topView, when inspecting anObject.
     Identical objects are labelled with the same id, which makes it easy to
     see if two objects are identical (and is very useful, indeed).
     WARNING: used by both Inspector and Inspector2 !!!!!!"

    |lbl id|

    (anObject isProtoObject not and:[anObject isImmediate or:[anObject isBoolean]]) ifTrue:[
        ^ self labelNameFor:anObject.
    ].
    lbl := '<%1> %2'.

    IdDictionary isNil ifTrue:[
        IdDictionary := WeakIdentityDictionary new.
    ].

    "/ get or assign a new id
    [    
        id := IdDictionary 
                    at:anObject 
                    ifAbsentPut:[ 
                        |nextID|

                        nextID := NextSequentialID ? 0.
                        NextSequentialID := nextID + 1.
                        nextID
                    ].
    ] valueUninterruptably.

    ^ self classResources 
        string:lbl 
        with:id
        with:(self labelNameFor:anObject)

    "Created: / 15-07-2011 / 16:21:44 / cg"
!

labelNameFor:anObject
    "return the iconLabel to use in my topView, when inspecting anObject.
     Simply returns the className or name of anObjects class"

    |s|

    anObject isProtoObject ifTrue:[
        ^ anObject displayString.
    ].

    anObject isClass ifTrue:[
        s := anObject displayString
    ] ifFalse:[
        (anObject isImmediate
         or:[anObject isBoolean]) ifTrue:[
            s := anObject printString , ', ' , anObject classNameWithArticle
        ] ifFalse:[
            s := anObject classNameWithArticle
        ].
    ].
    s isNil ifTrue:[
        anObject isBehavior ifTrue:[
            ^ 'someBehavior'
        ].
        ^ 'something'
    ].
    ^ s

    "Created: / 15-07-2011 / 16:20:06 / cg"
! !

!InspectorView class methodsFor:'defaults'!

defaultExtent
    "return the default extent of my instances.
     The value returned here is usually ignored, and
     the value from preferredExtent taken instead."

     |display|

    display := Screen current.
    ^ (display monitorBoundsAt:display pointerPosition) extent // 3.

    "Created: / 7.9.1998 / 13:47:45 / cg"
    "Modified: / 7.9.1998 / 14:15:38 / cg"
!

defaultHideHashes
    ^ DefaultHideHashes? true
!

defaultHideHashes:aBoolean
    DefaultHideHashes := aBoolean
!

defaultHideMessages
    ^ DefaultHideMessages ? true
!

defaultHideMessages:aBoolean
    DefaultHideMessages := aBoolean
!

defaultIcon
    "return the browsers default window icon"

    <resource: #programImage>
    <resource: #style (#INSPECTOR_ICON #INSPECTOR_ICON_FILE)>

    |nm i resources|

    (i := DefaultIcon) isNil ifTrue:[
        resources := self classResources.
        i := resources at:#INSPECTOR_ICON default:nil.
        i isNil ifTrue:[
            nm := resources at:#INSPECTOR_ICON_FILE default:'Inspector.xbm'.
            i := Smalltalk imageFromFileNamed:nm forClass:self.
            i isNil ifTrue:[
                i := StandardSystemView defaultIcon
            ]
        ].
        i notNil ifTrue:[
            DefaultIcon := i := i onDevice:Display
        ]
    ].
    ^ i

    "
       DefaultIcon := nil
    "

    "Modified: / 17-09-2007 / 11:36:17 / cg"
!

defaultIntegerDisplayRadix
    ^ DefaultIntegerDisplayRadix ? 10

    "Created: / 10-02-2012 / 19:51:38 / cg"
!

defaultSortOrder
    ^ SortOrderInstvarOrder
!

defaultTopViewExtent
    |def|

    def := LastExtent ? self defaultExtent.
    ^ def min:(Screen current usableExtent)

    "Created: / 23-10-2007 / 19:04:13 / cg"
!

expandArraysInAllLists
    "in the 'all instvars' list, expand arrays"

    ^ ExpandArraysInAllLists ? false

    "Created: / 30-01-2012 / 16:52:57 / cg"
!

expandArraysInAllLists:aBoolean
    "in the 'all instvars' list, expand arrays"

    ExpandArraysInAllLists := aBoolean

    "Created: / 30-01-2012 / 16:53:01 / cg"
!

rememberLastExtent:anExtent
    LastExtent := anExtent

    "Created: / 23-10-2007 / 19:10:02 / cg"
!

sortOrderAlphabetical
    ^ SortOrderAlphabetical
!

sortOrderInstvarOrder
    ^ SortOrderInstvarOrder
! !

!InspectorView class methodsFor:'image specs'!

imageFor_arrays
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_arrays inspect
     ImageEditor openOnClass:self andSelector:#imageFor_arrays
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView class imageFor_arrays'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@T5EQT4@@@@@@@@@@@@AOTUAPBU@IS0@@@@@@@@AOTP%PBUAQ
T %O@@@@@@@@T0$IBP$ITUHIO0@@@@@@@EEPBU@ITUIRBSD@@@@@@@AQBP$IBP%RO0$1@@@@@@@@T5HIT %RO3DIO0@@@@@@@D=RT%HILSEJBR<@@@@@@@@@
S3D1LP%JBR<@@@@@@@@@@@AOO3D1O2<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 0 0 0 227 231 0 132 132 0 151 156 0 142 131 128 255 252 49 175 181 0 255 234 140 218 222 0 251 255 33 74 74 0 94 99 0 107 107 0 143 148 0 189 189 0 87 90 0 251 255 8 247 255 16 167 173 0 206 99 132 156 74 99 206 66 107 115 16 49 255 16 90 189 0 57 132 16 49 206 0 57 198 123 140 255 49 123 255 33 99 222 0 66 99 0 24 239 0 66 255 0 74 255 140 214 148 0 41 140 49 74 198 123 148 255 0 82 90 0 24 132 0 41 206 99 123 156 0 41 198 0 57 74 0 24 255 16 82 214 0 66 90 0 33 189 0 49 107 0 33 206 16 74 214 8 66 218 112 214 255 0 255 208 32 144 199 21 133 186 85 211 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_characters
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_characters inspect
     ImageEditor openOnClass:self andSelector:#imageFor_characters
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView class imageFor_characters'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@6LD5MLCX@@@@@@@@@@@ADRTDIOC-FQ@@@@@@@@@A@MP$IBP$I
Q$U@@@@@@@@@L@%SOP%HRP$>M@@@@@@@@D4<BP$IS#MEP4H@@@@@@@AMNUP9BP$IP3)B@@@@@@@@L@$3R0%EP0%GLP@@@@@@@D@>BP$IBP%RQ2<@@@@@@@@@
K$1LBT]GQ3<@@@@@@@@@@@A@LTIBLR<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 0 0 0 227 231 0 132 132 0 151 156 0 142 131 128 255 252 49 175 181 0 255 234 140 218 222 0 251 255 33 74 74 0 94 99 0 107 107 0 143 148 0 189 189 0 87 90 0 251 255 8 247 255 16 167 173 0 206 99 132 156 74 99 206 66 107 115 16 49 255 16 90 189 0 57 132 16 49 206 0 57 198 123 140 255 49 123 255 33 99 222 0 66 99 0 24 239 0 66 255 0 74 255 140 214 148 0 41 140 49 74 198 123 148 255 0 82 90 0 24 132 0 41 206 99 123 156 0 41 198 0 57 74 0 24 255 16 82 214 0 66 90 0 33 189 0 49 107 0 33 206 16 74 214 8 66 173 0 49 115 0 33 181 0 49 74 0 16 255 8 82 231 0 66 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_classes
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_classes inspect
     ImageEditor openOnClass:self andSelector:#imageFor_classes
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView class imageFor_classes'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@6LD5MLCX@@@@@@@@@@@ADRTEAOC-FQ@@@@@@@@@A@MT 2M3\;
Q$U@@@@@@@@@LD!!HRD!!HRTX>M@@@@@@@@D4<RC\8S$%FP4H@@@@@@@AMNS$9MST3P3)B@@@@@@@@LCL3R4,3P4)GLP@@@@@@@D@>O#8>R$)JQ2<@@@@@@@@@
K$1LP$]GQ3<@@@@@@@@@@@A@LTIBLR<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 0 0 0 0 215 231 0 125 132 0 143 156 128 142 132 49 248 255 0 166 181 140 255 240 0 207 222 33 240 255 0 70 74 0 89 99 0 102 107 0 136 148 0 180 189 0 82 90 8 239 255 16 235 255 0 158 173 127 206 99 95 156 74 100 206 66 44 115 16 78 255 16 48 189 0 43 132 16 47 206 0 136 198 123 113 255 49 88 255 33 55 222 0 19 99 0 54 239 0 61 255 0 208 255 140 34 148 0 69 140 49 144 198 123 69 255 0 19 90 0 34 132 0 118 206 99 33 156 0 47 198 0 20 74 0 70 255 16 55 214 0 28 90 0 40 189 0 28 107 0 64 206 16 56 214 8 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_collectionHolder
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self imageFor_collectionHolder inspect
     ImageEditor openOnClass:self andSelector:#imageFor_collectionHolder
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'InspectorView imageFor_collectionHolder'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
C@0LC@ HB@ HB@ HC@0LC@0LC@0HB@ HB@ HB@0LC@0LC@ HB@ HB@ HB@ HB@0LC@0HB@ 0M#P4M#@HB@ LC@0LB@ 2ACL3L3LDL  HC@0LC@ 2ACL3L3L4
MPP2B@0LC@0HM P3L3L3MCTDK0 LC@0LBCPDL3L3MCT5AB8HC@0LC@ 4ACLDMSPDK0P.B@0LC@0HM P5MST5K28DK0 LC@0LBCHDMST5K"81AB4HC@0LC@ H
L P.K"81AB4HB@0LC@0HB@ 2K28.K24HB@ LC@0LB@ HB@ HB@ HB@ HC@0LC@0LB@ HB@ HB@ LC@0LC@0LC@ HB@ HB@ HC@0LC@@a') ; colorMapFromArray:#[0 0 0 74 74 0 94 99 0 240 240 240 255 255 255 132 132 0 143 148 0 142 131 128 226 226 226 151 156 0 107 107 0 87 90 0 60 59 55 230 230 230 206 173 99 156 131 74 206 165 66 115 82 16 255 181 16 189 132 0 132 99 16 206 149 0 198 181 123 255 181 49 222 156 0 99 75 0 239 173 0 255 181 0 148 107 0 140 115 49 198 173 123 255 173 0 90 66 0 132 91 0 206 182 99 156 115 0 198 141 0 74 50 0 255 189 16 214 148 0 90 57 0 189 140 0 107 74 0 206 148 16 214 156 8 156 74 99 115 16 49 140 49 74 198 123 148 90 0 33 218 112 214 255 0 255 208 32 144 199 21 133 186 85 211]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'<@?0C<@C1>OO<=?;7?/_>=?;7?/_><?31>O@@?@O<@<b') ; yourself); yourself]
!

imageFor_collections
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_collections inspect
     ImageEditor openOnClass:self andSelector:#imageFor_collections
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView class imageFor_collections'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@T5EQT4@@@@@@@@@@@@AOBUAPTE@IS0@@@@@@@@AOBUAPTEAQ
T %O@@@@@@@@T0%PTEAPTUHIO0@@@@@@@EDITEAPTUIRBSD@@@@@@@AQBU@IT%DIO0$1@@@@@@@@T0%RT%IRO3DIO0@@@@@@@D<IT%IRLSEJBR<@@@@@@@@@
S0$1LSEJBR<@@@@@@@@@@@AOO3D1O2<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 0 0 0 227 231 0 132 132 0 151 156 0 142 131 128 255 252 49 175 181 0 255 234 140 218 222 0 251 255 33 74 74 0 94 99 0 107 107 0 143 148 0 189 189 0 87 90 0 251 255 8 247 255 16 167 173 0 206 99 132 156 74 99 206 66 107 115 16 49 255 16 90 189 0 57 132 16 49 206 0 57 198 123 140 255 49 123 255 33 99 222 0 66 99 0 24 239 0 66 255 0 74 255 140 214 148 0 41 140 49 74 198 123 148 255 0 82 90 0 24 132 0 41 206 99 123 156 0 41 198 0 57 74 0 24 255 16 82 214 0 66 90 0 33 189 0 49 107 0 33 206 16 74 214 8 66 218 112 214 255 0 255 208 32 144 199 21 133 186 85 211 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_colors
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_colors inspect
     ImageEditor openOnClass:self andSelector:#imageFor_colors
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView imageFor_colors'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4@N#(:N @]GQ4]GQ4]GQ4@N#(:N#(*M!!4]GQ4]GQ4@@C(:N#(:
J"(6@A4]GQ4]@@@@N!!HRD"(*J#P]GQ4]GP@@@AHRD!!H2L#D1GQ4]GQ4@@@@RD!!HRLB4,KA4]GQ4]@@@@D!!HRH"T*J"(]GQ4]GP@@@@,IH"H"H"(]GQ4]GQ4]
@@@KDRH%H"\]GQ4]GQ4]GQ4@BP$ZH @]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GP@a');
                colorMapFromArray:#[ 0 58 255 0 135 255 0 230 255 0 252 254 0 255 127 0 255 175 0 255 244 0 255 249 63 243 47 115 82 16 125 141 170 128 32 210 156 131 74 158 160 171 161 153 136 180 196 100 191 187 200 192 22 179 195 255 19 198 173 123 198 181 123 206 165 66 206 173 99 206 182 99 207 206 217 216 179 229 219 0 153 223 255 19 225 255 19 226 226 226 229 255 19 246 223 40 247 246 216 248 221 223 250 0 86 252 233 208 254 255 25 255 59 19 255 98 19 255 115 19 255 127 26 255 137 26 255 167 32 255 185 155 255 186 0 255 188 0 255 189 16 255 193 19 255 197 19 255 200 19 255 206 19 255 210 26 255 213 26 255 236 19 255 248 0 255 255 0 255 255 19 255 255 255 0 206 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@<@G8@?0G? _>A?8G? O<@_ @<@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_dictionaries
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_dictionaries inspect
     ImageEditor openOnClass:self andSelector:#imageFor_dictionaries
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView class imageFor_dictionaries'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@T5EQT4@@@@@@@@@@@@AOTUAPTEARS0@@@@@@@@AOTU@HTE@I
BEIO@@@@@@@@T5APBP!!PTUIRO0@@@@@@@EDIBP$I@P$HO3D@@@@@@@AQTUDIBEIRO3D1@@@@@@@@T5IRBEIRBP!!JO0@@@@@@@D=RT%H?LSEJR"<@@@@@@@@@
S3D1LT(IBB<@@@@@@@@@@@AOO3D1O2<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 0 0 0 227 231 0 132 132 0 151 156 0 142 131 128 255 252 49 175 181 0 255 234 140 218 222 0 251 255 33 74 74 0 94 99 0 107 107 0 143 148 0 189 189 0 87 90 0 251 255 8 247 255 16 167 173 0 206 99 132 156 74 99 206 66 107 115 16 49 255 16 90 189 0 57 132 16 49 206 0 57 198 123 140 255 49 123 255 33 99 222 0 66 99 0 24 239 0 66 255 0 74 255 140 214 148 0 41 140 49 74 198 123 148 255 0 82 90 0 24 132 0 41 206 99 123 156 0 41 198 0 57 74 0 24 255 16 82 214 0 66 90 0 33 189 0 49 107 0 33 206 16 74 214 8 66 218 112 214 255 0 255 208 32 144 199 21 133 186 85 211 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_false
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_false inspect
     ImageEditor openOnClass:self andSelector:#imageFor_false
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView imageFor_false'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@ LC@ D@@@@@@@@@@@@DAPXFA0 IA@@@@@@@@@@JB0XLC@0L
CP8J@@@@@@@@@ XOCA@PDA@QD @@@@@@@@LGC00PD1PNEQX@@@@@@@@CE1 LC@0MEQ$V@@@@@@@@@!!PTCA@PDAXZF0@@@@@@@@(QC 0PGA$]F!!8@@@@@@@@@
G10\GA(ZF"@@@@@@@@@@@@@JF1XVF18@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 200 120 145 208 64 109 208 16 96 208 96 128 208 0 87 248 0 103 248 0 88 240 0 85 200 0 68 200 120 146 208 0 72 250 255 248 184 192 189 160 0 52 248 8 100 135 144 128 144 0 60 128 16 63 208 8 83 184 0 77 128 0 53 88 0 37 216 0 75 224 0 78 96 0 25 64 0 27 120 16 59 120 0 50 64 0 12 160 72 102 208 96 143 136 32 60 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_falseHolder
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_falseHolder inspect
     ImageEditor openOnClass:self andSelector:#imageFor_falseHolder
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView imageFor_falseHolder'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
H"H"H @@@@@@@@@@H"H"H"H"H"H@@@@@@@@@@BH"H"H"H @@@@@@@@@@@@@@@BH"H"H@@@@A@ LC@ D@@@@"H"H"@@@DAPXFA0 IA@@@H"H"H @JB0XLC@0L
CP8J@BH"H"H@@ XOCA@PDA@QD @"H"H"@@LGC00PD1PNEQX@H"H"H @CE1 LC@0MEQ$V@BH"H"H@@!!PTCA@PDAXZF0@"H"H"@@(QC 0PGA$]F!!8@H"H"H @@
G10\GA(ZF"@@@BH"H"H@@@@JF1XVF18@@@@"H"H"@@@@@@@@@@@@@@@@H"H"H"H"@@@@@@@@@@@"H"H"H"H"H @@@@@@@@@@H"H"H @a');
                colorMapFromArray:#[ 0 0 0 200 120 145 208 64 109 208 16 96 208 96 128 208 0 87 248 0 103 248 0 88 240 0 85 200 0 68 200 120 146 208 0 72 250 255 248 184 192 189 160 0 52 248 8 100 135 144 128 144 0 60 128 16 63 208 8 83 184 0 77 128 0 53 88 0 37 216 0 75 224 0 78 96 0 25 64 0 27 120 16 59 120 0 50 64 0 12 160 72 102 208 96 143 136 32 60 226 226 226 60 59 55 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'<@?0C<@C1>OO<=?;7?/_>=?;7?/_><?31>O@@?@O<@<b');
                            yourself);
                yourself
        ]
!

imageFor_floats
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self imageFor_floats inspect
     ImageEditor openOnClass:self andSelector:#imageFor_floats
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'InspectorView imageFor_floats'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@6LD5MLCX@@@@@@@@@@@ADRTEAOC-FQ@@@@@@@@@A@MT 2BS\;
Q$U@@@@@@@@@LD!!HBP%HRTX>M@@@@@@@@D4<RC\IS#MFP4H@@@@@@@AMNS$9BSUCP3)B@@@@@@@@LCL3R0%EBP%GLP@@@@@@@D@>O $IQP$IQ2<@@@@@@@@@
K$1LP$]GQ3<@@@@@@@@@@@A@LTIBLR<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 0 0 0 0 231 4 0 132 0 0 156 5 139 142 128 52 255 49 0 181 6 161 255 140 0 222 4 33 255 37 0 74 0 0 99 5 0 107 0 0 148 5 0 189 0 0 90 3 8 255 12 16 255 24 0 173 6 206 173 99 156 131 74 206 165 66 115 82 16 255 181 16 189 132 0 132 99 16 206 149 0 198 181 123 255 181 49 255 189 33 222 156 0 99 75 0 239 173 0 255 181 0 255 181 140 148 107 0 140 115 49 198 173 123 255 173 0 90 66 0 132 91 0 206 182 99 156 115 0 198 141 0 74 50 0 255 189 16 214 148 0 90 57 0 189 140 0 107 74 0 206 148 16 214 156 8]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b') ; yourself); yourself]
!

imageFor_fractions
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_fractions inspect
     ImageEditor openOnClass:self andSelector:#imageFor_fractions
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView class imageFor_fractions'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@6LD5MLCX@@@@@@@@@@@ADRTEABS-FQ@@@@@@@@@A@MSH2BP$7
LTY@@@@@@@@@LCH2L#HIS#D1M@@@@@@@@D4<OC0<BSL1LTH@@@@@@@AML3L3BP$ILSEB@@@@@@@@LCL3L0$3BT\1LP@@@@@@@D@>L3L3BT]GQ2<@@@@@@@@@
K$03BP$IQ3<@@@@@@@@@@@A@LTIBLR<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 0 0 0 0 231 4 0 132 0 0 156 5 139 142 128 52 255 49 0 181 6 161 255 140 0 222 4 33 255 37 0 74 0 0 99 5 0 107 0 0 148 5 0 189 0 0 90 3 8 255 12 16 255 24 0 173 6 206 173 99 156 131 74 206 165 66 115 82 16 255 181 16 189 132 0 132 99 16 206 149 0 198 181 123 255 181 49 255 189 33 222 156 0 99 75 0 239 173 0 255 181 0 255 181 140 148 107 0 140 115 49 198 173 123 255 173 0 90 66 0 132 91 0 206 182 99 156 115 0 198 141 0 74 50 0 255 189 16 214 148 0 90 57 0 189 140 0 107 74 0 206 148 16 214 156 8 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_integers
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_integers inspect
     ImageEditor openOnClass:self andSelector:#imageFor_integers
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView class imageFor_integers'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@6LD5MLCX@@@@@@@@@@@ADRTEAOC-FQ@@@@@@@@@A@MT 2BS\;
Q$U@@@@@@@@@LD!!HBP%HRTX>M@@@@@@@@D4<RC\IS#MFP4H@@@@@@@AMNS$9BSUCP3)B@@@@@@@@LCL3R0%EP4)GLP@@@@@@@D@>O $IBS9JQ2<@@@@@@@@@
K$1LP$]GQ3<@@@@@@@@@@@A@LTIBLR<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 0 0 0 0 231 4 0 132 0 0 156 5 139 142 128 52 255 49 0 181 6 161 255 140 0 222 4 33 255 37 0 74 0 0 99 5 0 107 0 0 148 5 0 189 0 0 90 3 8 255 12 16 255 24 0 173 6 206 173 99 156 131 74 206 165 66 115 82 16 255 181 16 189 132 0 132 99 16 206 149 0 198 181 123 255 181 49 255 189 33 222 156 0 99 75 0 239 173 0 255 181 0 255 181 140 148 107 0 140 115 49 198 173 123 255 173 0 90 66 0 132 91 0 206 182 99 156 115 0 198 141 0 74 50 0 255 189 16 214 148 0 90 57 0 189 140 0 107 74 0 206 148 16 214 156 8 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_nil
    <resource: #programImage>

    ^ self imageFor_nil2

    "Modified: / 21-11-2012 / 14:24:21 / cg"
!

imageFor_nil1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_nil1 inspect
     ImageEditor openOnClass:self andSelector:#imageFor_nil1
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView imageFor_nil1'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@KEP4MEP,@@@@@@@@@@@@GEA$YAP4OA0@@@@@@@@@JEA$WF!!HM
C1 J@@@@@@@@EQ$R@@ CEAXDDP@@@@@@@@4ED!!(ACQXXC@X@@@@@@@@ME@4TEAXXCALF@@@@@@@@EQXVE HXC@XNF@@@@@@@@@(DF@PLCALNC!!@@@@@@@@@@
A1LSA 8NC 4@@@@@@@@@@@@JF@XFFA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_nil2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_nil2 inspect
     ImageEditor openOnClass:self andSelector:#imageFor_nil2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView imageFor_nil2'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"G]7]8"H"H"GQDSLBH"H"GQL3L2P"H"H]L3L3FBH"H!!43L3LTH"H"GSL3L0 "H"H_L3L11BH"H!!<3L1:DH"H"H
B*,QDH"H"H"@@@@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H b');
                colorMapFromArray:#[ 0 0 0 74 74 0 94 99 0 240 240 240 255 255 255 132 132 0 143 148 0 142 131 128 226 226 226 151 156 0 107 107 0 87 90 0 230 230 230 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_nilHolder
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_nilHolder inspect
     ImageEditor openOnClass:self andSelector:#imageFor_nilHolder
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView imageFor_nilHolder'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
3L2H"H"H3L3L3H"H"H#L3L2H"H"H"H#L3H"G]7]8"L3L"GQDS]BH3L2GQM7]6P#L3H]M7]7VBL3L!!47]7]TH3L2GS]7]4 #L3H_]7]51BL3L!!=7]5:DH3L2H
B*,QDH#L3H"@@@@H"L3L"H"H"H"H3L3L"H"H"L3L3L2H"H"H3L0b');
                colorMapFromArray:#[ 0 0 0 74 74 0 94 99 0 240 240 240 255 255 255 132 132 0 143 148 0 142 131 128 226 226 226 151 156 0 107 107 0 87 90 0 60 59 55 230 230 230 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'<@?0C<@C1>OO<=?;7?/_>=?;7?/_><?31>O@@?@O<@<b');
                            yourself);
                yourself
        ]
!

imageFor_numberHolder
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self imageFor_numberHolder inspect
     ImageEditor openOnClass:self andSelector:#imageFor_numberHolder
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'InspectorView imageFor_numberHolder'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
C@0LC@ HB@ HB@ HC@0LC@0LC@0HB@ HB@ HB@0LC@0LC@ HB@ HB@ HB@ HB@0LC@0HB@ VDB,+DAXHB@ LC@0LB@ "I1<_F1($H  HC@0LC@ ^ERXRAA\Z
IBL^B@0LC@0HDBX&A@P&I2P\E@ LC@0LBB,[I!!\DKAL$HR@HC@0LC@ +FA XAAT!!HQ$ B@0LC@0HDALSJPP#HR %DP LC@0LBA8\G@PDAA0(IP<HC@0LC@ H
C"(*HBT%IQ4HB@0LC@0HB@ ^DR@ DP<HB@ LC@0LB@ HB@ HB@ HB@ HC@0LC@0LB@ HB@ HB@ LC@0LC@0LC@ HB@ HB@ HC@0LC@@a') ; colorMapFromArray:#[0 0 0 74 74 0 94 99 0 240 240 240 255 255 255 132 132 0 143 148 0 142 131 128 226 226 226 151 156 0 107 107 0 87 90 0 60 59 55 230 230 230 206 173 99 156 131 74 206 165 66 115 82 16 255 181 16 189 132 0 132 99 16 206 149 0 198 181 123 255 181 49 222 156 0 99 75 0 239 173 0 255 181 0 148 107 0 140 115 49 198 173 123 255 173 0 90 66 0 132 91 0 206 182 99 156 115 0 198 141 0 74 50 0 255 189 16 214 148 0 90 57 0 189 140 0 107 74 0 206 148 16 214 156 8]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'<@?0C<@C1>OO<=?;7?/_>=?;7?/_><?31>O@@?@O<@<b') ; yourself); yourself]
!

imageFor_others
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_others inspect
     ImageEditor openOnClass:self andSelector:#imageFor_others
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView imageFor_others'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
.;.;.;.;.;.;.;.;.;.;.;.;.;.;.;.;.;.5UUU[.;.;.5****B;.;.5*-;\) .;.;V-;\6VB;.;-Z;\*ZXK.;.5+Z*J$0.;.;V)**!!QB;.;-Z):]TDK.;.;
ADHQDK.;.;.0@@@K.;.;.;.;.;.;.;.;.;.;.;.;.;.;.;.;.;,b');
                colorMapFromArray:#[ 0 0 0 76 74 0 88 90 0 96 100 0 108 108 0 144 132 130 152 156 0 168 174 0 176 182 0 188 190 0 220 222 0 228 226 230 228 232 0 240 240 240 255 252 50 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_othersHolder
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_othersHolder inspect
     ImageEditor openOnClass:self andSelector:#imageFor_othersHolder
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView imageFor_othersHolder'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
&Y%&Y&Y&&Y&Y&VY&Y&ZY&Y%&Y&Y&Y&ZY&VY#L3L6Y)&YY#DQDQA&&Y%#DX:DGPZY&VLX:D!!]A)&YX1:DEQ4F&Y%#FAGAV0ZY&VLUDQ0?A)&YX1E1\2<F&Y%&
@"+?<FZY&VY @@@FY)&YY&Y&Y&Y&&Y&YY&Y&Y)&Y&Y%&Y&Y&&Y$b');
                colorMapFromArray:#[ 0 0 0 220 222 0 108 108 0 144 132 130 228 232 0 188 190 0 228 226 230 168 174 0 240 240 240 60 59 55 88 90 0 96 100 0 176 182 0 152 156 0 255 252 50 76 74 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'<@?0C<@C1>OO<=?;7?/_>=?;7?/_><?31>O@@?@O<@<b');
                            yourself);
                yourself
        ]
!

imageFor_sequenceableCollections
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_sequenceableCollections inspect
     ImageEditor openOnClass:self andSelector:#imageFor_sequenceableCollections
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'InspectorView class imageFor_sequenceableCollections'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@T5EQT4@@@@@@@@@@@@AOTUAPTEARS0@@@@@@@@AOTUAPTE@I
BEIO@@@@@@@@T5APTEAPTUIRO0@@@@@@@EEPTEAPT $HO3D@@@@@@@AQTUERT%IRO3D1@@@@@@@@T5IRT%IRBP!!JO0@@@@@@@D=RT%H?LSEJR"<@@@@@@@@@
S3D1LT(IBB<@@@@@@@@@@@AOO3D1O2<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 0 0 0 227 231 0 132 132 0 151 156 0 142 131 128 255 252 49 175 181 0 255 234 140 218 222 0 251 255 33 74 74 0 94 99 0 107 107 0 143 148 0 189 189 0 87 90 0 251 255 8 247 255 16 167 173 0 206 99 132 156 74 99 206 66 107 115 16 49 255 16 90 189 0 57 132 16 49 206 0 57 198 123 140 255 49 123 255 33 99 222 0 66 99 0 24 239 0 66 255 0 74 255 140 214 148 0 41 140 49 74 198 123 148 255 0 82 90 0 24 132 0 41 206 99 123 156 0 41 198 0 57 74 0 24 255 16 82 214 0 66 90 0 33 189 0 49 107 0 33 206 16 74 214 8 66 218 112 214 255 0 255 208 32 144 199 21 133 186 85 211 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_strings
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_strings inspect
     ImageEditor openOnClass:self andSelector:#imageFor_strings
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView class imageFor_strings'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@6LD5MLCX@@@@@@@@@@@ADRTEAOC-FQ@@@@@@@@@A@MTDIM5LI
BTU@@@@@@@@@LDDIM3]HBP$>M@@@@@@@@D4<BP$8S#LIP4H@@@@@@@AMNP$IMUDIP3)B@@@@@@@@LCL3R4=EP4)GLP@@@@@@@D@>QS9CTC)RQ2<@@@@@@@@@
K$1LP$]GQ3<@@@@@@@@@@@A@LTIBLR<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 0 0 0 227 231 0 132 132 0 151 156 0 142 131 128 255 252 49 175 181 0 255 234 140 218 222 0 251 255 33 74 74 0 94 99 0 107 107 0 143 148 0 189 189 0 87 90 0 251 255 8 247 255 16 167 173 0 206 99 132 156 74 99 206 66 107 115 16 49 255 16 90 189 0 57 132 16 49 206 0 57 198 123 140 255 49 123 255 33 99 222 0 66 99 0 24 239 0 66 255 0 74 255 140 214 148 0 41 140 49 74 198 123 148 255 0 82 90 0 24 132 0 41 206 99 123 156 0 41 198 0 57 74 0 24 255 16 82 214 0 66 90 0 33 189 0 49 107 0 33 206 16 74 214 8 66 173 0 49 115 0 33 181 0 49 74 0 16 255 8 82 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_symbols
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_symbols inspect
     ImageEditor openOnClass:self andSelector:#imageFor_symbols
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView class imageFor_symbols'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@6LD5MLCX@@@@@@@@@@@ADRTEAOC-FQ@@@@@@@@@A@MTDIM5LI
Q$U@@@@@@@@@LDDIBP$IBP$>M@@@@@@@@D4<NP$8S $>P4H@@@@@@@AMNS$IMUDIP3)B@@@@@@@@LCLIBP$IBP%GLP@@@@@@@D@>QP%CT@%RQ2<@@@@@@@@@
K$1LP$]GQ3<@@@@@@@@@@@A@LTIBLR<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 0 0 0 227 231 0 132 132 0 151 156 0 142 131 128 255 252 49 175 181 0 255 234 140 218 222 0 251 255 33 74 74 0 94 99 0 107 107 0 143 148 0 189 189 0 87 90 0 251 255 8 247 255 16 167 173 0 206 99 132 156 74 99 206 66 107 115 16 49 255 16 90 189 0 57 132 16 49 206 0 57 198 123 140 255 49 123 255 33 99 222 0 66 99 0 24 239 0 66 255 0 74 255 140 214 148 0 41 140 49 74 198 123 148 255 0 82 90 0 24 132 0 41 206 99 123 156 0 41 198 0 57 74 0 24 255 16 82 214 0 66 90 0 33 189 0 49 107 0 33 206 16 74 214 8 66 173 0 49 115 0 33 181 0 49 74 0 16 255 8 82 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_true
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_true inspect
     ImageEditor openOnClass:self andSelector:#imageFor_true
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView imageFor_true'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(MB@ MB @@@@@@@@@@@@:K#@0F2(\N @@@@@@@@@-H0$IBP$I
A18-@@@@@@@@MC@$I@$$IBP9HP@@@@@@@B@[J20IIB0^K3 @@@@@@@@ MRT,BRP^K1<8@@@@@@@@MB0,I $$K2\"JP@@@@@@@B49G#$IIA<]H#H@@@@@@@@@
M#L3NBH"H#\@@@@@@@@@@@@-JS 8JSH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 98 255 0 75 198 0 25 74 0 57 156 0 34 99 0 92 206 16 60 132 16 31 74 0 79 206 0 128 131 142 88 231 0 70 189 0 38 90 0 148 198 123 57 115 16 92 239 0 103 255 8 76 189 0 154 198 123 85 214 0 53 132 0 106 255 0 138 255 49 107 156 74 44 115 0 119 206 66 85 222 0 142 206 99 68 139 33 33 90 0 57 148 0 135 206 99 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A>@O<A?8G? _>A?8G? _>@?0A>@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

imageFor_trueHolder
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageFor_trueHolder inspect
     ImageEditor openOnClass:self andSelector:#imageFor_trueHolder
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'InspectorView imageFor_trueHolder'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
N3,;N0@@@@@@@@@@N3,;N3,;N3,@@@@@@@@@@C,;N3,;N0@@@@@@@@@@@@@@@C,;N3,@@@@(MB@ MB @@@@;N3,;@@@:K#@0F2(\N @@N3,;N0@-H0$IBP$I
A18-@C,;N3,@MC@$I@$$IBP9HP@;N3,;@B@[J20IIB0^K3 @N3,;N0@ MRT,BRP^K1<8@C,;N3,@MB0,I $$K2\"JP@;N3,;@B49G#$IIA<]H#H@N3,;N0@@
M#L3NBH"H#\@@C,;N3,@@@@-JS 8JSH@@@@;N3,;@@@@@@@@@@@@@@@@N3,;N3,;@@@@@@@@@@@;N3,;N3,;N0@@@@@@@@@@N3,;N0@a');
                colorMapFromArray:#[ 226 226 226 176 176 176 155 155 155 169 169 169 152 152 152 164 164 164 149 149 149 192 192 192 240 240 240 255 255 255 202 202 202 201 201 201 151 151 151 162 162 162 148 148 148 158 158 158 173 173 173 154 154 154 167 167 167 150 150 150 160 160 160 180 180 180 156 156 156 170 170 170 153 153 153 165 165 165 183 183 183 98 255 0 75 198 0 25 74 0 57 156 0 34 99 0 92 206 16 60 132 16 31 74 0 79 206 0 128 131 142 88 231 0 70 189 0 38 90 0 148 198 123 57 115 16 92 239 0 103 255 8 76 189 0 154 198 123 85 214 0 53 132 0 106 255 0 138 255 49 107 156 74 44 115 0 119 206 66 85 222 0 142 206 99 68 139 33 33 90 0 57 148 0 135 206 99 60 59 55 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'<@?0C<@C1>OO<=?;7?/_>=?;7?/_><?31>O@@?@O<@<b');
                            yourself);
                yourself
        ]
! !

!InspectorView class methodsFor:'presentation'!

iconForValue: anObject
    |value|

    anObject == nil ifTrue:[    "isNil is not defined in Lazy et al."
        ^ self imageFor_nil
    ].
    anObject == true ifTrue:[
        ^ self imageFor_true
    ].
    anObject == false ifTrue:[
        ^ self imageFor_false
    ].
    anObject isProtoObject ifFalse:[
        anObject isNumber ifTrue:[
            anObject isInteger ifTrue:[
                ^ self imageFor_integers
            ].
            anObject isFraction ifTrue:[
                ^ self imageFor_fractions
            ].
            ^ self imageFor_floats
        ].
        anObject isCollection ifTrue:[
            anObject isString ifTrue:[
                anObject isSymbol ifTrue:[
                    ^ self imageFor_symbols
                ].
                ^ self imageFor_strings
            ].
            (anObject isDictionary) ifTrue:[
                ^ self imageFor_dictionaries
            ].
            (anObject isArray) ifTrue:[
                ^ self imageFor_arrays
            ].
            (anObject isSequenceable) ifTrue:[
                ^ self imageFor_sequenceableCollections
            ].
            ^ self imageFor_collections
        ].
        anObject isCharacter ifTrue:[
            ^ self imageFor_characters
        ].
        anObject isBehavior ifTrue:[
            ^ self imageFor_classes
        ].
        anObject isColor ifTrue:[
            ^ self imageFor_colors
        ].
        anObject isValueModel ifTrue:[
            "/ this may be problemantic, if #value has a side effect...
            Error handle:[:ex |
            ] do:[
                value := anObject value.
                value == true ifTrue:[^ self imageFor_trueHolder].
                value == false ifTrue:[^ self imageFor_falseHolder].
                value == nil ifTrue:[^ self imageFor_nilHolder].
                value isNumber ifTrue:[^ self imageFor_numberHolder].
                value isCollection ifTrue:[^ self imageFor_collectionHolder].
                ^ self imageFor_othersHolder
            ].
        ].
    ].

    ^ self imageFor_others

    "Created: / 16-05-2012 / 17:58:20 / cg"
!

iconForValueClass: aClass
    "this is useful if we do not want to or cannot access the value itself easily;
     For example as a helper for bridge objects"

    aClass == UndefinedObject ifTrue:[
        ^ self imageFor_nil
    ].
    aClass == True ifTrue:[
        ^ self imageFor_true
    ].
    aClass == False ifTrue:[
        ^ self imageFor_false
    ].
    ((aClass == Future) or:[aClass == Lazy]) ifTrue:[
        ^ self imageFor_others
    ].
    (aClass includesBehavior:Integer) ifTrue:[
        ^ self imageFor_integers
    ].
    (aClass includesBehavior:Fraction) ifTrue:[
        ^ self imageFor_fractions
    ].
    (aClass includesBehavior:LimitedPrecisionReal) ifTrue:[
        ^ self imageFor_floats
    ].
    (aClass includesBehavior:Collection) ifTrue:[
        (aClass includesBehavior:CharacterArray) ifTrue:[
            (aClass includesBehavior:Symbol) ifTrue:[
                ^ self imageFor_symbols
            ].
            ^ self imageFor_strings
        ].
        (aClass includesBehavior:Dictionary) ifTrue:[
            ^ self imageFor_dictionaries
        ].
        (aClass includesBehavior:SequenceableCollection) ifTrue:[
            (aClass includesBehavior:Array) ifTrue:[
                ^ self imageFor_arrays
            ].
            ^ self imageFor_sequenceableCollections
        ].
        ^ self imageFor_collections
    ].

    (aClass == Character) ifTrue:[
        ^ self imageFor_characters
    ].
    (aClass includesBehavior: Behavior) ifTrue:[
        ^ self imageFor_classes
    ].
    (aClass includesBehavior: Color) ifTrue:[
        ^ self imageFor_colors
    ].
    (aClass includesBehavior: ValueModel) ifTrue:[
        ^ self imageFor_othersHolder
    ].
    ^ self imageFor_others
! !

!InspectorView class methodsFor:'queries-plugin'!

aspectSelectors
    ^ #( inspectedObjectHolder )

    "Modified: / 10.2.2000 / 12:25:28 / cg"
! !

!InspectorView methodsFor:'accessing'!

allowFollow:aBoolean
    "enable/disable the follow menu item;
     This is disabled for inspectors which are embedded in the debugger"

    allowFollow := aBoolean
!

dereferenceValueHolders:aBoolean
    dereferenceValueHolders := aBoolean
!

fieldListLabel:aString
    labelView label:aString.
    labelView adjust:#left.

    "Created: 28.6.1996 / 15:30:26 / cg"
!

headLineLabel:aString
    "an alternative headline label (if used as embedded inspector)"

    headLineLabel := aString.

    labelView notNil ifTrue:[
        labelView label:headLineLabel.
    ].

    "Modified: / 25-11-2010 / 17:16:45 / cg"
!

headLineLabelView
    "provides access to the headline"

    ^ labelView

    "Created: / 21-01-2011 / 12:07:13 / cg"
!

hideHashes:aBoolean
    "hide/show the hash-entries in the field list;
     This can be hidden for end-user applications"

    hideHashes := aBoolean

    "Created: 28.6.1996 / 15:08:32 / cg"
!

hideMessages:aBoolean
    "hide/show the messages-entries in the field list;
     This can be hidden for end-user applications"

    hideMessages := aBoolean

    "Created: 28.6.1996 / 15:08:32 / cg"
!

hideReceiver:aBoolean
    "hide/show the self-entry for the inspected object;
     This is hidden for context inspectors in the debugger"

    hideReceiver := aBoolean

    "Created: 28.6.1996 / 15:08:32 / cg"
!

inspect:anObject
    "set/update the object to be inspected"

    self inspect:anObject keepSelection:false
!

inspect:anObject keepSelection:keepSelectionBoolean
    "set/update the object to be inspected"

    |keepList fieldNameList sameObject sameClass oldSelectedField idx|

    "/ (anObject isNil and:[object isNil]) ifTrue:[^ self].

    sameObject := (anObject == object) and:[object notNil].

    "/ JV@2011-08-06: Be carefull here, classes may be variable-lenght,
    "/ so instances of same class may have different number of slots!!
    "/ (caused problems expecially when stack inspector is shown in debugger).
    "/ To fix, I've added ------------------------v
    sameClass := (anObject class == object class) and:[anObject class isVariable not].
    selectionIndex notNil ifTrue:[
        oldSelectedField := (listView list ? #()) at:selectionIndex ifAbsent:nil.
    ].
    inspectedObject := object := anObject.

    keepList := ((sameObject | sameClass) and:[listView list notEmptyOrNil]).
    "/ assume that the list remains unchanged;
    "/ this is no longer true, if some inst-slot has changed (bullet colors)
    UserPreferences current showTypeIndicatorInInspector ifTrue:[
        keepList := false.
    ].
    keepList ifFalse:[
        hasMore := false.
        fieldNameList := self fieldList.                               
        hasMore ifTrue:[
            fieldNameList add:' ... '
        ].
        listView contents:fieldNameList.
        workspace contents:nil.
        self setDoItAction.
    ].
    sameClass ifFalse:[
        selectionIndex := selectedLine := nil.
    ].
    isStandaloneInspector ifTrue:[
        "/ not embedded (as in the debugger)
        self topView 
            label:(self labelFor:anObject);
            iconLabel:(self class labelNameFor:anObject).
    ].
        
    (sameObject | sameClass) ifFalse:[
        idx := (listView list ? #()) indexOf:oldSelectedField.
        idx ~~ 0 ifTrue:[
            listView selection:idx
        ] ifFalse:[
            self setInitialSelection.
        ]
    ].
    self showSelection:((selectedLine ? 1) min: listView list size)

    "Modified (comment): / 06-08-2011 / 13:41:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2012 / 13:06:59 / cg"
!

inspectNext:anObject
    "do a followup inspect on an object.
     This does either open a new inspector, or advances
     the Inspector2 to anObject"

    |app|

    app := self application.
    (app isKindOf:Tools::Inspector2) ifTrue:[
        app inspect:anObject
    ] ifFalse:[
        anObject inspect
    ]
!

isStandaloneInspector:aBoolean
    "obsolete now"

    isStandaloneInspector := aBoolean

    "Modified: / 12.2.1999 / 16:01:44 / cg"
!

label:aString
    "set the fieldListLabel - obsolete; collides with inherited label-functionality"

    <resource:#obsolete>
    self obsoleteMethodWarning:'use fieldListLabel:'.
    self fieldListLabel:aString.
    super label:aString.

    "Created: 28.6.1996 / 15:30:26 / cg"
!

listView
    ^ listView
!

reinspect
    "update display for a changed inspectedObject"

    |aList|

    hasMore := false.
    aList := self fieldList.
    hasMore ifTrue:[
        aList add:' ... '
    ].

    listView contents:aList.
    self setDoItAction.
    selectionIndex := selectedLine := nil

    "Modified (comment): / 02-06-2012 / 13:08:15 / cg"
!

suppressHeadline:aBoolean
    "hide/show the title line above the list/value"

    suppressHeadline := aBoolean.

    labelView notNil ifTrue:[
        suppressHeadline == true ifTrue:[
            labelView beInvisible.
            listView container topInset:0.
            workspace container topInset:0.
        ] ifFalse:[
            labelView beVisible.
            listView container topInset:(labelView preferredHeight).
            workspace container topInset:(labelView preferredHeight).
        ].
    ].

    "Created: / 09-11-2010 / 14:50:04 / cg"
    "Modified: / 05-02-2011 / 14:03:55 / cg"
!

suppressPseudoSlots:aBoolean
    suppressPseudoSlots := aBoolean
!

workspace
    ^ workspace
! !

!InspectorView methodsFor:'accessing-channels'!

inspectedObjectHolder
    inspectedObjectHolder isNil ifTrue:[
        inspectedObjectHolder := ValueHolder new.
        inspectedObjectHolder addDependent:self.
    ].
    ^ inspectedObjectHolder

    "Created: / 10.2.2000 / 13:33:16 / cg"
    "Modified: / 10.2.2000 / 13:34:23 / cg"
!

inspectedObjectHolder:aValueHolder
    inspectedObjectHolder notNil ifTrue:[
        inspectedObjectHolder removeDependent:self.
    ].
    inspectedObjectHolder := aValueHolder.
    inspectedObjectHolder notNil ifTrue:[
        inspectedObjectHolder addDependent:self.
    ].

    "Created: / 10.2.2000 / 13:34:53 / cg"
!

sortOrderHolder
    ^ sortOrderHolder
!

sortOrderHolder:aValueHolder
    self assert:aValueHolder notNil.
    
    sortOrderHolder notNil ifTrue:[
        sortOrderHolder removeDependent:self.
    ].
    sortOrderHolder := aValueHolder.
    sortOrderHolder addDependent:self.
    self sortOrderHolderChanged.
! !

!InspectorView methodsFor:'change & update'!

holderChanged:aValueHolder
    "a valueHolder of which I have registered an iterest
     has changed (see the menu item: 'Catch Change').
     Remove the interest (no further notifications) either by evaluating:
        aValueHolder retractInterestsFor:holderChangeInterest
      or:
        self doUncatchChanges
     here, or via the field menu"

    "/ aValueHolder retractInterestsFor:holderChangeInterest
    self halt:'ValueHolder has changed - please proceed'.
!

sortOrderHolderChanged
    |newOrder|
    
    newOrder := sortOrderHolder value.
    sortOrder ~~ newOrder ifTrue:[
        sortOrder := newOrder.
        self reinspect.
    ].
!

update:something with:aParameter from:changedObject
    "Invoked when one of my dependees sends a change notification."

    |oldSelection|

    changedObject == object ifTrue:[
        oldSelection := listView selection.
        self inspect:object.
        oldSelection notNil ifTrue:[
            self showSelection:oldSelection
        ].
        ^ self
    ].

    changedObject == inspectedObjectHolder ifTrue:[
        self inspect:(inspectedObjectHolder value).
        ^ self
    ].
    changedObject == sortOrderHolder ifTrue:[
        self sortOrderHolderChanged.
        ^ self.
    ].

    super update:something with:aParameter from:changedObject

    "Created: / 10.2.2000 / 13:46:38 / cg"
    "Modified: / 10.2.2000 / 13:48:18 / cg"
! !

!InspectorView methodsFor:'drag & drop'!

getDisplayObjects

    ^List with:self selection printString

    "Created: / 16-08-2005 / 21:54:52 / janfrog"
    "Modified: / 18-09-2006 / 21:11:16 / cg"
!

getDropObjects

    ^List with:(DropObject new:self selection).

    "Created: / 16-08-2005 / 21:49:23 / janfrog"
    "Modified: / 18-09-2006 / 21:11:31 / cg"
! !

!InspectorView methodsFor:'event handling'!

doubleClickOnLine:lineNr
    self inspectNext:self selectedField.

    "Created: / 29-07-2011 / 21:09:43 / cg"
!

keyPress:key x:x y:y
    "handle special keys"

    <resource: #keyboard (#BrowseIt #InspectIt)>

    self theSingleSelectionIndex "selection" notNil ifTrue:[
        (key == #BrowseIt) ifTrue:[
            self browse.
            ^ self.
        ].
        (key == #InspectIt) ifTrue:[
            self doInspect.
            ^ self.
        ].
    ].

    "all my other input is passed on to the workspace-field"
    x notNil ifTrue:[
        "/ not already delegated
        workspace keyPress:key x:-1 y:-1
    ].
!

selectedField
    ^ self theSingleSelectionIndex isNil 
                            ifTrue:[object] 
                            ifFalse:[self selection].

    "Created: / 27-07-2012 / 22:42:23 / cg"
!

sizeChanged:how
    super sizeChanged:how.

    isStandaloneInspector == true ifTrue:[
        LastExtent := self topView extent.
    ].
! !

!InspectorView methodsFor:'initialization & release'!

destroy
    (self topView objectAttributeAt:#rememberExtent) == true ifTrue:[
        self class rememberLastExtent:(self topView extent).
    ].

    inspectedObject := object := nil.
    monitorProcess notNil ifTrue:[
        monitorProcess terminate
    ].
    super destroy

    "Modified: / 23-10-2007 / 19:11:04 / cg"
!

initialize
    |v panel helpView labelView2|

    super initialize.

    displayStringMessage := #displayString.
    hideReceiver := false.
    hideHashes := self class defaultHideHashes.
    hideMessages := self class defaultHideMessages.
    integerDisplayRadix := (DefaultIntegerDisplayRadix ? 10).
    sortOrder := SortOrderInstvarOrder.
    sortOrderHolder := sortOrder asValue.
    sortOrderHolder addDependent:self.
    allowFollow := false.
    isStandaloneInspector := false.

    panel := VariableHorizontalPanel 
                origin:(0.0 @ 0.0)
                corner:(1.0 @ 1.0)
                in:self.

    helpView := View origin:(0.0 @ 0.0) corner:(0.3 @ 1.0) in:panel.
    helpView level:0; borderWidth:0.

    suppressHeadline == true ifFalse:[
        labelView := Label origin:0.0@0.0 corner:1.0@0.0 in:helpView.
        labelView label:(headLineLabel ? self defaultLabel).
        labelView bottomInset:(labelView preferredHeight negated).
    ].

    v := HVScrollableView 
            for:SelectionInListView 
            miniScrollerH:true
            miniScrollerV:false
            in:helpView.
    v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    labelView notNil ifTrue:[
        v topInset:(labelView preferredHeight).
    ].

"/    v autoHideScrollBars:true.

    listView := v scrolledView.
    listView action:[:lineNr | self selection:lineNr.].
    listView doubleClickAction:[:lineNr | self doubleClickOnLine:lineNr].
    listView ignoreReselect:false.
    listView menuHolder:self; menuPerformer:self; menuMessage:#fieldMenu.
    self initializeDragAndDrop.

    helpView := View origin:(0.3 @ 0.0) corner:(1.0 @ 1.0) in:panel.
    helpView level:0; borderWidth:0.

    suppressHeadline == true ifFalse:[
        labelView2 := Label origin:0.0@0.0 corner:1.0@0.0 in:helpView.
        labelView2 label:''.
        labelView2 bottomInset:(labelView preferredHeight negated).
    ].

    v := HVScrollableView 
                for:CodeView 
                miniScrollerH:true
                miniScrollerV:false
                in:helpView.
"/    v autoHideScrollBars:true.
    v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    labelView2 notNil ifTrue:[
        v topInset:(labelView2 preferredHeight).
    ].
    workspace := v scrolledView.
    workspace autoIndent:false.

    self setAcceptAction.

    nShown := 100.
    hasMore := false.

    "Modified: / 16-08-2005 / 21:54:04 / janfrog"
    "Modified: / 20-07-2012 / 10:48:34 / cg"
!

initializeDragAndDrop

    | source |
    source := DropSource 
                    receiver:self
                    argument:nil
                    dropObjectSelector:#getDropObjects
                    displayObjectSelector:#getDisplayObjects
                    dropFeedBackSelector:nil.

    listView dropSource:source.

    "Created: / 16-08-2005 / 21:51:43 / janfrog"
    "Modified: / 18-09-2006 / 21:13:05 / cg"
!

realize
    "delayed setup of lists till first map-time - 
     this makes startup of inspectors a bit faster"

    |o|

    super realize.
    "/ cg: I don't remember what this was needed for (is it still?)
    false "object notNil" ifTrue:[
        "
         kludge to trick inspect:, which ignores setting the
         same object again ...
        "
        o := object.
        inspectedObject := object := nil.
        self inspect:o
    ]

    "Created: / 30-05-1996 / 09:38:37 / cg"
    "Modified: / 05-11-2007 / 20:11:44 / cg"
!

release
    "release inspected object. This is normally not needed,
     since the garbage collector will find this memory alone.
     However, if some applications keeps invisible inspectors around
     (for example, the debugger does this), the inspected object
     would be kept from being freed or freed very late."

    "
    inspectedObject notNil ifTrue:[
        inspectedObject removeDependent:self
    ].
    "

    inspectedObject := object := nil.
    self setDoItAction.      "/ to release ref to inspectedObject in doItBlock
    workspace contents:nil.
    listView contents:nil.

    super release.

    "Modified: 11.6.1997 / 13:20:39 / cg"
!

setInitialSelection
    Error handle:[:ex |
    ] do:[
        object isProtoObject ifFalse:[
            object isString ifTrue:[
                self showSelection:1    "/ the self-line    
            ]
        ].
    ].
! !

!InspectorView methodsFor:'menu'!

fieldMenu
    "return the menu for the field-list"

    <resource: #programMenu>

    |items m sel operationItems|

    sel := self selection.

    items := #(
                       ('Copy Name or Key'             #doCopyKey              )
                       ('-')
                       ('Inspect'                      #doInspect              )
                       ('BasicInspect'                 #doBasicInspect         )
             ).
    sel isValueModel ifTrue:[
        items := items , #(
                       ('Inspect Value'                #doInspectValue         )
             ).
    ].
    NewInspector::NewInspectorView notNil ifTrue:[
        items := items , #(
                       ('Inspect Hierarchical'         #doNewInspect           )
                ).
    ].
    items := items , #(
                       ('Browse'                       #browse                 )
             ).
    sel isValueModel ifTrue:[
        items := items , #(
                       ('Browse Value'                 #browseValue            )
             ).
    ].
    (sel isSymbol) ifTrue:[
        items := items , #(
                       ('Browse Implementors'           #browseImplementorsOfSymbolValue)
              ).
    ].
    
    (inspectedObject class allInstVarNames includes:(self selectedKeyName)) ifTrue:[
        items := items , #(
                       ('Browse References to Instvar'           #browseReferencesToInstvar)
              ).
    ].
    
    items := items , (self optionalToolItems).
    items := items , (self optionalViewSelectionItems).
    items := items , #(
                       ('-') 
                       ('Owners'                       #showOwners             )  
                       ('Ref Chains'                   #showReferences         )
"/                       ('Browse class hierarchy'       #browseClassHierarchy   )
"/                       ('Browse full class protocol'   #browseFullClassProtocol)
              ).

    items := items , (self optionalMethodOrBlockSelectionItems).
    items := items , (self optionalStreamSelectionItems).
    items := items , (self optionalFilenameSelectionItems).
    items := items , (self optionalByteArraySelectionItems).

    items := items , #(
                       ('-')
                       ('Local Protocol'               #localProtocolMenu      )
                       ('Full Protocol'                #protocolMenu           )
                       ('-')
                       ('Trap Message...'              #doTrap                 )
                       ('Trap Update Messages...'      #doTrapUpdates          )
                       ('Trap all Messages'            #doTrapAll              )
                       ('Trace all Messages'           #doTraceAll             )
                       ('Untrace/Untrap'               #doUntrace              )
"/                       ('-')
"/                       ('Trap change to instVar'       #doTrapInstVarChange    )
"/                       ('Trap change to any instVar'   #doTrapAnyInstVarChange )
              ).

    sel isValueModel ifTrue:[
        (holderChangeInterest notNil
        and:[ (sel interestsFor:holderChangeInterest) notEmptyOrNil ]) ifTrue:[
            items := items , #(
                       ('Uncatch Changes'             #doUncatchChanges           )
              ).
        ] ifFalse:[
            items := items , #(
                       ('Catch Changes'               #doCatchChanges             )
              ).
        ].
    ].

    allowFollow ifTrue:[
        items := #(
                            ('Follow'                       #doFollow              )
                            ('Back'                         #doBack              )
                            ('-')
                  )
                 ,
                 items.
    ].

    monitorProcess isNil ifTrue:[
        items := items , #(
                        ('Start Monitor'                #doStartMonitor         )
                          ).
    ] ifFalse:[
        items := items , #(
                        ('Stop Monitor'                #doStopMonitor           )
                          ).
    ].

    hasMore ifTrue:[
        items := items , #(
                        ('-')
                        ('Show More'                    #showMore               )
                          ).
        (self numIndexedFields > (nShown * 2)) ifTrue:[
            items := items , #(
                        ('Show All'                     #showAll                )
                          )
        ].
    ].

    items := items , (self sortOrderItems).
    items := items , (self numberBaseItems).

    operationItems := (self optionalOperationMenuItemsFor:sel).
    operationItems notEmptyOrNil ifTrue:[
        items := items, #(('-')) , operationItems
    ].
    
    m := PopUpMenu
          itemList:items
          resources:resources.

    m subMenuAt:#protocolMenu put:(self protocolMenu).
    m subMenuAt:#localProtocolMenu put:(self localProtocolMenu).

    (self theSingleSelectionIndex isNil) ifTrue:[
        m disableAll:#(doFollow doInspect doBasicInspect doNewInspect
                       browse browseClassHierarchy browseFullClassProtocol
                       browseValue browseImplementorsOfSymbolValue
                       doStartMonitor doCopyKey doCopyKey)
    ].
    (self hasSelfEntry and:[selectionIndex == 1]) ifTrue:[
        m disableAll:#(doFollow doCopyKey "doInspect doBasicInspect")
    ].

    inspectHistory size == 0 ifTrue:[
        m disable:#doBack
    ].
    sel class hasImmediateInstances ifTrue:[
        m disableAll:#(showReferences doNewInspect)
    ].
"/    sel inspectorClass == self class ifFalse:[
"/        m disable:#doFollow
"/    ].
    sel isMethod ifFalse:[
        m disable:#browseMethodsClass
    ].

    sel := nil. "/ release ref to sel; helps reference finder

    ^ m

    "Modified: / 16-07-2013 / 19:56:54 / cg"
!

localProtocolMenu
    "return the menu for the inspected object's local implemented messages"

    |localSelectors labels localProtocolMenu|

    localSelectors := object class methodDictionary keysSorted.
    "/ kludge: '-' and '=' are special in a menu
    labels := localSelectors collect:[:sel | (#('-' '=') includes:sel) ifTrue:[' ',sel] ifFalse:[sel]].
    localProtocolMenu := PopUpMenu
                        labels:labels
                        selector:#letSelectedObjectPerform: 
                        args:localSelectors
                        receiver:self.

    ^ localProtocolMenu
!

numberBaseItems
    ^ {
        #('-') .
        (integerDisplayRadix == 10) 
            ifFalse:[ #('Show Integers as Decimal'  #setDisplayRadixTo10  ) ] .
        (integerDisplayRadix == 16) 
            ifFalse:[ #('Show Integers as Hex'  #setDisplayRadixTo16      ) ] .
        (integerDisplayRadix == 2) 
            ifFalse:[ #('Show Integers as Binary'  #setDisplayRadixTo2    ) ] .
      } select:[:el | el notNil].

    "Modified: / 24-08-2010 / 17:31:51 / cg"
!

optionalByteArraySelectionItems
"/    |sel|
"/
"/    sel := self selection.
    (object isByteArray) ifTrue:[
        ^ #(
               ('Save Bytes to File...'             #saveBytesToFile)
          ).
    ].
    ^ #()

    "Created: / 25-01-2011 / 17:16:12 / cg"
!

optionalFilenameSelectionItems
    |sel|

    sel := self selection.
    (object isFilename or:[sel isFilename or:[sel isString and:[sel asFilename exists]]]) ifTrue:[
        OperatingSystem isMSWINDOWSlike ifTrue:[
            ^ #(
                       ('Show in Explorer'             #showInWindowsExplorer)
                       ('Open FileBrowser'             #openFileBrowser)
              ).
        ].
        ^ #(
               ('Open FileBrowser'             #openFileBrowser)
          ).
    ].
    ^ #()

    "Created: / 09-02-2007 / 16:10:30 / cg"
    "Modified: / 05-02-2011 / 15:49:48 / cg"
!

optionalMethodOrBlockSelectionItems
    |sel items|

    sel := self selection.

    items := #().
    (sel isBlock or:[sel isContext]) ifTrue:[
        items := items , #(
                       ('Browse Block''s Home'           #browseHome)
              ).
    ].
    (object isMethod or:[sel isMethod]) ifTrue:[
        items := items , #(
                       ('Browse Method''s Class'         #browseMethodsClass)
                 ).
    ].
    (selectionIndex notNil 
    and:[(self fieldList at:selectionIndex ifAbsent:nil) = '-dependents']) ifTrue:[
        items := items , #(
                       ('Browse Update Methods'        #browseUpdateMethods)
                 ).
    ].

    ^ items

    "Modified: / 03-08-2011 / 15:03:36 / cg"
!

optionalOperationMenuItemsFor:anObject
    "chance to add instance-specific operation menu items.
     See SerialPort as an example"
     
    ^ anObject inspectorExtraMenuOperations

    "
     SerialPort new inspect    
    "
!

optionalStreamSelectionItems
    |sel|

    sel := self selection.

    sel isStream ifTrue:[
        sel isFileStream ifTrue:[
            OperatingSystem isMSWINDOWSlike ifTrue:[
                ^ #(
                       ('Show in Explorer'             #showInWindowsExplorer)
                       ('Open FileBrowser'             #openFileBrowser)
                  ).
            ].
            ^ #(
                       ('Open FileBrowser'             #openFileBrowser)
              ).
        ].
        sel isExternalStream ifFalse:[
            ^ #(
                       ('Show Stream Contents'         #showStreamContents)
              ).
        ].
    ].
    ^ #()

    "Created: / 09-02-2007 / 16:09:15 / cg"
    "Modified: / 05-02-2011 / 15:49:55 / cg"
!

optionalToolItems
    "inserted after inspect/browse"

    ^ #()

    "Created: / 27-01-2011 / 11:51:12 / cg"
!

optionalViewSelectionItems
    |sel|

    sel := self selection.

    sel isView ifTrue:[
        ^ #(
            ('Show Widget Hierarchy'             #openWidgetHierarchy)
          ).
    ].
    ^ #()
!

protocolMenu
    "return the menu for the inspected object's implemented messages"

    |protocols protocolsSorted selectorsByFirstCharacter protocolMenu|

    protocols := Dictionary new.
    selectorsByFirstCharacter := Dictionary new.
    object class withAllSuperclassesDo:[:eachClass |
        eachClass methodDictionary keysAndValuesDo:[:sel :m |
            sel argumentCount == 0 ifTrue:[
                (protocols at:(m category ?'') ifAbsentPut:[Set new]) add:sel.
                (selectorsByFirstCharacter at:(sel first asString) ifAbsentPut:[Set new]) add:sel.
            ]
        ].
    ].

    protocolsSorted := protocols keysSorted.
    protocolMenu := PopUpMenu
                        labels:#('alphabetical' '=') , protocolsSorted
                        selectors:#(nil nil) , protocolsSorted.

    protocolMenu 
        subMenuAt:'alphabetical'
        put:[
            |firstChars alphaMenu|

            firstChars := selectorsByFirstCharacter keysSorted.
            alphaMenu := PopUpMenu
                               labels:firstChars
                               selector:#mmm 
                               args:firstChars
                               receiver:self.
            firstChars do:[:ch |
                alphaMenu
                    subMenuAt:ch
                    put:[
                        |selectors sortedSelectors|

                        selectors := selectorsByFirstCharacter at:ch.
                        sortedSelectors := selectors asArray sort.
                        PopUpMenu
                            labels:sortedSelectors
                            selector:#letSelectedObjectPerform: 
                            args:sortedSelectors
                            receiver:self.
                    ]
            ].
            alphaMenu
        ].

    protocolsSorted do:[:p |
        protocolMenu 
            subMenuAt:p 
            put:[
                |selectors sortedSelectors|

                selectors := protocols at:p.
                sortedSelectors := selectors asArray sort.
                PopUpMenu
                    labels:sortedSelectors
                    selector:#letSelectedObjectPerform: 
                    args:sortedSelectors
                    receiver:self.
            ]
    ].
    ^ protocolMenu

    "Modified: / 15-10-2013 / 12:38:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sortOrderItems
    object class instSize == 0 ifTrue:[ ^ #() ].
    ^ {
        #('-') .
        (sortOrder == SortOrderInstvarOrder) 
            ifFalse:[ #('Instvar Order'  #setSortOrderToInstvarOrder  ) ] .
        (sortOrder == SortOrderAlphabetical) 
            ifFalse:[ #('Alphabetical'  #setSortOrderToAlphabetical  ) ] .
      } select:[:el | el notNil].

    "Created: / 20-07-2012 / 10:47:53 / cg"
! !

!InspectorView methodsFor:'menu actions'!

browse
    self doBrowse:self selectedField 
!

browseClass
    |cls|

    cls := self selectedField class.
    cls browserClass 
        openInClass:cls selector:nil
        "/ browseClass:cls

    "Modified: / 27-07-2012 / 22:42:39 / cg"
!

browseClassHierarchy
    |cls|

    cls := self selectedField class.
    cls browserClass browseClassHierarchy:cls

    "Modified: / 27-07-2012 / 22:42:47 / cg"
!

browseFullClassProtocol
    |cls|

    cls := self selectedField class.
    cls browserClass browseFullClassProtocol:cls

    "Modified: / 27-07-2012 / 22:42:50 / cg"
!

browseHome
    |sel mthd|

    sel := self selectedField.
    sel isBlock ifTrue:[
        mthd := sel homeMethod
    ] ifFalse:[
        sel isContext ifTrue:[
            mthd := sel method.
        ]
    ].
    mthd isNil ifTrue:[
        ^ self warn:'Sorry - cannot figure out home method.'
    ].
    mthd class browserClass 
        openInClass:mthd mclass selector:mthd selector

    "Modified: / 27-07-2012 / 22:42:55 / cg"
!

browseImplementorsOfSymbolValue
    |symbol|

    symbol := self selection.
    inspectedObject class  browserClass 
        browseImplementorsOf:symbol
!

browseMethodsClass
    |mthd mclass|

    mthd := self selection.
    (mclass := mthd mclass) isNil ifTrue:[
        Dialog information:'Method is no longer valid (class has been changed in the meanwhile)'
    ] ifFalse:[
        mclass browserClass 
            openInClass:mclass 
            selector:mthd selector
    ].
!

browseReferencesToInstvar
    SystemBrowser default
        browseRefsTo:(self selectedKeyName) 
        classVars:false
        in:(inspectedObject class withAllSuperclasses)
        modificationsOnly:false
!

browseUpdateMethods
    |deps methods|

    deps := self selection.
    methods := Set new.
    deps do:[:each | 
        |implClass|

        implClass := each class whichClassIncludesSelector:#'update:with:from:'.
        implClass notNil ifTrue:[
            methods add:(implClass compiledMethodAt:#'update:with:from:')
        ]
    ].
    methods isEmpty ifTrue:[^ self].

    methods first mclass browserClass 
        browseMethods:methods
        title:'Update Method(s) of dependent(s)'
!

browseValue
    self doBrowse:self selectedField value
!

doBack
    "user selected back-menu entry"

    |objectToInspect|

    inspectHistory size > 0 ifTrue:[
        objectToInspect := inspectHistory removeLast.
        inspectHistory size == 0 ifTrue:[
            inspectHistory := nil
        ].
        self inspect:objectToInspect.
    ]

    "Created: / 22.9.1998 / 18:22:01 / cg"
    "Modified: / 22.9.1998 / 18:22:28 / cg"
!

doBasicInspect
    "user selected inspect-menu entry"

    self doInspect:self selectedField basic:true
!

doBrowse:what
    |cls|

    cls := what class.
    cls browserClass openInClass:cls selector:nil

    "Created: / 14-12-1995 / 19:15:50 / cg"
    "Modified: / 27-07-2012 / 22:42:44 / cg"
!

doCatchChanges
    |sel|

    holderChangeInterest isNil ifTrue:[
        "/ remember the interest, in order to be able to retract later
        holderChangeInterest := [ self holderChanged:sel ]
    ].

    sel := self selection.
    sel onChangeSend:#value to:holderChangeInterest.
!

doFollow
    "user selected follow-menu entry"

    |objectToInspect|

    selectionIndex notNil ifTrue:[
        objectToInspect := self selection.
        inspectHistory isNil ifTrue:[
            inspectHistory := OrderedCollection new
        ].
        inspectHistory addLast:object.
        self inspect:objectToInspect.
    ]

    "Created: / 22.9.1998 / 18:21:08 / cg"
    "Modified: / 22.9.1998 / 18:22:23 / cg"
!

doInspect
    "user selected inspect menu entry"

    self doInspect:self selectedField basic:false
!

doInspectValue
    "user selected inspect-value menu entry"

    self doInspect:self selectedField value basic:false
!

doNewInspect
    self doInspect:#new
!

doStartMonitor
    "start a monitoring process"

    monitorProcess isNil ifTrue:[
        monitorProcess :=
            [
                |sel|

                [true] whileTrue:[
                    (sel := selectionIndex) notNil ifTrue:[
                        self showSelection:sel 
                    ].
                    (Delay forSeconds:0.5) wait
                ]
            ] forkAt:Processor userBackgroundPriority
    ]

    "Modified: 12.4.1996 / 14:20:06 / cg"
!

doStopMonitor
    "stop the monitor"

    monitorProcess terminate.
    monitorProcess := nil
!

doTraceAll
    "place a trace on all messages sent to the inspected object"

    self topView withWaitCursorDo:[MessageTracer traceAll:object on:Transcript]
!

doTrap
    "place a trap on a message sent to the inspected object"

    |string selector|

    string := Dialog request:'Selector to trap on:' onCancel:nil.

    string notNil ifTrue:[
        selector := string asSymbolIfInterned.

        selector isNil ifTrue:[
            self warn:'No such selector'
        ] ifFalse:[
            self topView withWaitCursorDo:[MessageTracer trap:object 
                                                         selector:selector]
        ]
    ]

    "Modified: 12.4.1996 / 14:07:01 / cg"
!

doTrapAll
    "place a trap on all messages sent to the inspected object"

    self topView withWaitCursorDo:[MessageTracer trapAll:object]
!

doTrapAnyInstVarChange
    "place a trap which is triggered if any instVar of the inspected object is changed"

    self topView withWaitCursorDo:[
        MessageTracer trapModificationsIn:object
    ]
!

doTrapInstVarChange
    "place a trap which is triggered if the selected instVar of the inspected object is changed"

    self topView withWaitCursorDo:[
        |idx|

        "/ a named instVar ?
        idx := self instVarIndexForLine:selectionIndex.
        idx isNil ifTrue:[
            self warn:'Select an instance variable first.'.
            ^ self.
        ].
        MessageTracer 
                trapModificationsOf:(object class allInstVarNames at:idx)
                in:object
    ]
!

doTrapUpdates
    "place a trap on all update and XXXChanged messages sent to the inspected object"

    |selectors|

    selectors := IdentitySet new.

    "/ find all dependencies which lead to a message to this object
    "/ (also look for onChangeSend: and onChangeEvaluate: dependencies)
    InterestConverter allInstances do:[:i |
        |dest mthd messages|

        dest := i destination.
        (dest == object) ifTrue:[
            selectors add:(i selector)
        ] ifFalse:[
            (dest isBlock 
            and:[ (dest methodHome receiver == object)
            and:[ (mthd := dest methodHome method) notNil ]]) ifTrue:[   
                "/ vague
                messages := mthd messagesSent.
                messages := messages select:[:sel | object class implements:sel].
                selectors addAll:messages.
            ].
        ]
    ].
    #(update:
      update:with:
      update:with:from:)
    do:[:each |
        (object class implements:each) ifTrue:[
            selectors add:each.
        ]
    ].

    InterestConverter allInstances 
        select:[:i | |dest|
                     dest := i destination.
                     dest class == MessageSend
                     and:[dest selector == #value
                     and:[dest receiver == object ]]]
        thenDo:[:i | selectors add:(i selector)].

    selectors isEmpty ifTrue:[
        Dialog information:'I found no update/interest messages to trap.'.
        ^ self.
    ].

    (Dialog 
        confirm:('About to place an instance trap on the following selectors:\\' withCRs
                    , (selectors asOrderedCollection sort asStringWith:'\' withCRs)))
        ifFalse:[ ^ self].

    self topView withWaitCursorDo:[
        MessageTracer trap:object selectors:selectors
    ]

    "Created: / 16-07-2013 / 19:56:08 / cg"
!

doUncatchChanges
    |sel|

    holderChangeInterest notNil ifTrue:[
        sel := self selection.
        sel retractInterestsFor:holderChangeInterest
    ].
!

doUntrace
    "remove traps/traces"

    MessageTracer untrace:object
!

inspectOwners
    "open an inspector on owners of the inspectedObject.
     (this is a secret function)"

    self withCursor:(Cursor questionMark) do:[
        |owners dict|

        owners := (ObjectMemory whoReferences:object) asOrderedCollection.
        owners size > 500 ifTrue:[
            (self confirm:'there are ' , owners size printString , ' owners.\\Do you really want to see them all ?' withCRs)
            ifFalse:[^ self]
        ].
        dict := IdentityDictionary new.
        owners do:[:owner |
            |set names oClass|

            owner ~~ self ifTrue:[
                set := Set new.
                names := owner class allInstVarNames.
                oClass := owner class.
                1 to:oClass instSize do:[:i |
                    (owner instVarAt:i) == object ifTrue:[
                        set add:(names at:i).
                    ].
                ].
                oClass isVariable ifTrue:[
                    oClass isPointers ifTrue:[
                        1 to:owner basicSize do:[:i |
                            (owner basicAt:i) == object ifTrue:[
                                 set add:i
                            ]
                        ]
                    ]
                ].
                dict at:owner put:set
            ].
        ].
        dict inspect
    ]
!

letSelectedObjectPerform:aSelector
    |sel argString|

    sel := self selectedField.
    aSelector argumentCount == 0 ifTrue:[
        (sel perform:aSelector) inspect.
        ^ self.
    ].
    aSelector argumentCount == 1 ifTrue:[
        argString := Dialog request:'Argument (Smalltalk Object)'.
        argString isEmptyOrNil ifTrue:[^ self].
        (sel perform:aSelector with:(Object readFrom:argString)) inspect.
        ^ self.
    ].
self halt:'unimplemented argumentCount'.

    "Modified: / 27-07-2012 / 22:43:37 / cg"
!

openFileBrowser
    |fn|

    fn := self selection.
    fn isNil ifTrue:[ fn := inspectedObject ].
    fn isStream ifTrue:[
        fn := fn pathName asFilename
    ].
    (UserPreferences fileBrowserClass) openOnFileNamed:fn asFilename.

    "Modified: / 22-03-2011 / 18:05:22 / cg"
!

openWidgetHierarchy
    |view|

    view := self selection.
    view isView ifFalse:[^ self].

    WindowTreeView openOn:view
!

saveBytesToFile
    |fn|

    fn := Dialog requestFileName:'Save bytes into:'.
    fn isEmptyOrNil ifTrue:[^ self].

    fn asFilename contents:inspectedObject.

    "Modified: / 25-01-2011 / 17:23:38 / cg"
!

setDisplayRadixTo10
    self setDisplayRadixTo:10

    "Created: / 24-08-2010 / 17:26:12 / cg"
!

setDisplayRadixTo16
    self setDisplayRadixTo:16

    "Created: / 24-08-2010 / 17:26:22 / cg"
!

setDisplayRadixTo2
    self setDisplayRadixTo:2

    "Created: / 24-08-2010 / 17:26:18 / cg"
!

setDisplayRadixTo:radix
    |sel|

    integerDisplayRadix := DefaultIntegerDisplayRadix := radix.
    self reinspect.
    sel := listView selection.
    sel notNil ifTrue:[
        self showSelection:sel
    ]

    "Created: / 24-08-2010 / 17:26:54 / cg"
!

setSortOrderTo:aSymbol
    "aSymbol must be one of #alphabetical or #instvarOrder"
    
    self assert:((aSymbol == SortOrderAlphabetical) or:[ aSymbol == SortOrderInstvarOrder ]).
    sortOrderHolder value:aSymbol.
!

setSortOrderToAlphabetical
    self setSortOrderTo:SortOrderAlphabetical

    "Created: / 20-07-2012 / 10:59:52 / cg"
!

setSortOrderToInstvarOrder
    self setSortOrderTo:SortOrderInstvarOrder

    "Created: / 20-07-2012 / 10:59:59 / cg"
!

showAll
    |o|

    hasMore ifTrue:[
        nShown := self numIndexedFields.
        "/ force update (which is otherwise ignored)
        o := object.
        inspectedObject := object := nil.
        self inspect:o keepSelection:true
    ]

    "Created: / 13-06-2012 / 09:27:45 / cg"
!

showAlphabetical:aBoolean
    aBoolean ifTrue:[
        self setSortOrderToAlphabetical
    ] ifFalse:[
        self setSortOrderToInstvarOrder
    ].
!

showInWindowsExplorer
    "show in explorer"

    |fn dir|

    fn := self selection.
    fn isNil ifTrue:[ fn := inspectedObject ].
    fn isStream ifTrue:[
        fn := fn pathName asFilename
    ].
    dir := fn isDirectory
            ifTrue:[ fn ]
            ifFalse:[ fn directory ].

    dir asFilename openExplorer

    "Created: / 05-02-2011 / 15:49:33 / cg"
!

showMore
    |o|

    hasMore ifTrue:[
        nShown := nShown * 2.
        "/ force update (which is otherwise ignored)
        o := object.
        inspectedObject := object := nil.
        self inspect:o keepSelection:true
    ]

    "Modified: / 26.8.1998 / 19:05:25 / cg"
!

showOwners
    |o|    

    o := self selection.
    self withCursor:(Cursor questionMark) do:[
        |owners dict|

        owners := (ObjectMemory whoReferences:o).
        owners isEmptyOrNil ifTrue:[
            self information:'No owners found.'.
            ^ self
        ].
        owners := owners asOrderedCollection.
        "
         skip weakArrays ... (they don't count)
        "
        owners := owners reject:[:owner | owner isMemberOf:WeakArray].
        owners inspect.
"/        inspector := DictionaryInspectorView openOn:dict.
"/        inspector listView doubleClickAction:[:lineNr | inspector doInspectKey].
    ]

    "Modified: 15.10.1996 / 22:09:38 / cg"
!

showReferences
    "user selected references-menu entry"

    self selection class hasImmediateInstances ifTrue:[
        ^ self warn:'Sorry - cannot show references to immediate objects'
    ].
    ObjectMemory displayRefChainTo:(self selection)

    "Modified: / 30.7.1998 / 14:03:16 / cg"
!

showStreamContents
    |sel|

    sel := self selection.
    (sel isStream and:[sel isExternalStream not]) ifTrue:[
        workspace replace:(sel contents printString)
    ].

    "Created: / 6.2.2000 / 13:46:37 / cg"
    "Modified: / 6.2.2000 / 13:47:37 / cg"
! !

!InspectorView methodsFor:'presentation'!

appendDisplayStringForElementsOf:val indent:lvl pad:padding to:aStream
    val doWithIndex:[:el :idx |
        |elValString|

        aStream spaces:lvl.
        aStream nextPutAll:(' ' paddedTo:padding with:$.).
        aStream nextPutAll:(' [',(idx printString leftPaddedTo:2),']').
        aStream nextPutAll:' : '.
        elValString := self basicDisplayStringForValue:el.
        aStream nextPutAll:elValString.
        aStream cr.
        "/ s nextPutAll:(self stringWithAllInstVarValuesFor:el level:lvl+4)
    ].

    "Created: / 12-02-2012 / 09:55:53 / cg"
!

basicDisplayStringForValue:someValue 
    "return the value's displayString to be pasted into the workspace."

    |s maxStringLength|

    maxStringLength := 100000.

    Error handle:[:ex |
        (ex creator == WriteError and:[s isStream]) ifTrue:[
            "hit the write limit"
            s writeLimit:nil.
            s nextPutAll:' ...'.
            ^ s contents.
        ].
        s := someValue class nameWithArticle.
        displayStringMessage == #displayString ifTrue:[
            s := s , ' "error in displayString: ' , ex description , '"'
        ] ifFalse:[
            s := s , ' "error in displayString (' , displayStringMessage , '): ' , ex description , '"'
        ].
        ^ s
    ] do:[
        [
            integerDisplayRadix ~= 10 ifTrue:[
                "/ not everything can be shown in HEX/Binary

                someValue isInteger ifTrue:[
                    (someValue < integerDisplayRadix) ifTrue:[  
                        ^ someValue printString.
                    ].
                    s := someValue radixPrintStringRadix:integerDisplayRadix.
                    s := s , ' "',(someValue printString),'"'.
                    ^ s
                ].
                (someValue isMemberOf:ByteArray) ifTrue:[
                    s := WriteStream on:(String new:10).
                    s writeLimit:maxStringLength.
                    someValue printOn:s base:integerDisplayRadix showRadix:true.
                    ^ s contents
                ]
            ].

            "/ displayStringMessage := #classNameWithArticle
            "/ displayStringMessage := #displayString
            "/ displayStringMessage := #printString

            someValue isProtoObject ifTrue:[
                "Lazy values redefine #displayOn: to stay layzy"
                displayStringMessage := #displayString
            ].

            s := CharacterWriteStream on:(String new:10).
            s writeLimit:maxStringLength.

            "/ mhmh - avoid sending #perform: (bad for proxy objects which pass it to somewhere..)
            displayStringMessage == #displayString ifTrue:[
                someValue displayOn:s.
                "/ s := someValue displayString.
            ] ifFalse:[
                displayStringMessage == #printString ifTrue:[
                    someValue printOn:s.
                    "/ s := someValue printString.
                ] ifFalse:[
                    displayStringMessage == #storeString ifTrue:[
                        someValue storeOn:s.
                        "/ s := someValue storeString.
                    ] ifFalse:[
                        ^ someValue perform:displayStringMessage.
                    ].
                ].
            ].
            ^ s contents
        ] valueWithWatchDog:[^ someValue class nameWithArticle]
          afterMilliseconds:1000
    ].

    "Modified: / 20-07-2012 / 10:54:05 / cg"
!

displayStringForValue:someValue
    "return the value's displayString to be pasted into the workspace."

    |idx sel extraAttributes|

    idx := self theSingleSelectionIndex.
    idx notNil ifTrue:[
        sel := self listEntryAt:idx.
        sel isNil ifTrue:[^ someValue].

        extraAttributes := self myObjectsInspectorExtraAttributes.
        (extraAttributes includesKey:sel) ifTrue:[
            ^ someValue "(extraAttributes at:sel) value" printString
        ].

        (sel startsWith:'-all inst vars') ifTrue:[
            ^ self stringWithAllInstVarValues
        ].
        (sel startsWith:'-all class vars') ifTrue:[
            ^ self stringWithAllClassVarValues
        ].
        (sel startsWith:'-all indexed vars') ifTrue:[
            ^ self stringWithAllIndexedVarValues
        ].
        (sel startsWith:'-all messages') ifTrue:[
            ^ self stringWithMessages:#all
        ].
        (sel startsWith:'-local messages') ifTrue:[
            ^ self stringWithMessages:#local
        ].
        (sel startsWith:'-inherited messages') ifTrue:[
            ^ self stringWithMessages:#inherited
        ].
    ].
    ^ self basicDisplayStringForValue:someValue

    "Modified: / 16-05-2012 / 17:55:05 / cg"
!

iconForValue:arg
    ^ self class iconForValue:arg
!

listEntryForName:nameString value:value
    |entryString|

    UserPreferences current showTypeIndicatorInInspector ifFalse:[
        ^ nameString
    ].

    Error handle:[:ex |
        ^ nameString
    ] do:[
        entryString := nameString allBold, (self valueStringInListEntryForValue:value).
        (value isProtoObject not and:[value isColor and:[value red notNil]]) ifTrue:[
            entryString := entryString
                         , '  ' , ('   '
                            colorizeAllWith:(value contrastingBlackOrWhite)
                            on:value).
        ].

        ^ LabelAndIcon string:entryString image:(self iconForValue:value)
    ].

    "Created: / 16-05-2012 / 18:42:28 / cg"
!

plainValueStringInListEntryForValue:value
    "returns nil or a string to show in angle brackets.
     This is the string shown in the name list on the left"

    |s|

    "/ UserPreferences current showTypeIndicatorInInspector ifFalse:[^ nil].

    value isLazyValue ifTrue:[
        "do not block on not yet finished Futures et al"
        ^ '>>Lazy value<<'
    ].
    value class == ValueHolder ifTrue:[
        "/ just in case...
        thisContext isRecursive ifTrue:[^ value inspectorValueStringInListFor:self].

        s := self plainValueStringInListEntryForValue:value value.
        s notNil ifTrue:[
            ^ '{' , s , '}'
        ].
        ^ nil
    ].
    (value isProtoObject or:[value isNumber or:[value isBoolean]]) ifTrue:[
        ^ self basicDisplayStringForValue:value "value printString"
    ].
    ^ value inspectorValueStringInListFor:self

    "Created: / 13-06-2012 / 12:50:26 / cg"
!

stringWithAllClassVarValues
    ^ self stringWithAllClassVarValuesFor:object level:0
!

stringWithAllClassVarValuesFor:anObject level:lvl
    |s names maxLen|

    s := CharacterWriteStream on:''.
    names := anObject allClassVarNames.
    true "sortOrder == SortOrderAlphabetical" ifTrue:[
        names := names copy sort
    ].
    maxLen := (names collect:[:eachName | eachName size]) max.
    names do:[:eachClassVarName |
        |val valString|

        IsDebuggingQuery answer:true do:[
            val := (anObject whichClassDefinesClassVar:eachClassVarName asSymbol) classVarAt:eachClassVarName.
        ].
        s spaces:lvl.
        s nextPutAll:((eachClassVarName , ' ') paddedTo:maxLen+1 with:$.).
        s nextPutAll:' : '.

        ((ExpandArraysInAllLists == true) and:[val isSequenceable and:[ val class isPointers] ]) ifTrue:[
            s cr.
            self appendDisplayStringForElementsOf:val indent:lvl pad:maxLen+1+1 to:s.
        ] ifFalse:[
            valString := self basicDisplayStringForValue:val.
            (valString includes:Character cr) ifTrue:[
                valString := valString copyTo:(valString indexOf:Character cr)-1.
                valString := valString , '...'.
            ].
            s nextPutAll:valString.
            s cr.
        ].
    ].
    ^ s contents
!

stringWithAllIndexedVarValues
    |nIdx s names maxLen varString padLeft|

    nIdx := object size.

    s := CharacterWriteStream on:''.
    names := self indexList.
    names size > 0 ifTrue:[
        maxLen := names inject:0 into:[:maxSoFar :eachName | (eachName displayString size) max:maxSoFar]. 
        padLeft := names conform:[:eachIdx | eachIdx isInteger].  

        names do:[:eachIdx |
            |val|

            self isIndexShown ifTrue:[
                padLeft ifTrue:[
                    s nextPutAll:(eachIdx printStringLeftPaddedTo:maxLen).
                ] ifFalse:[
                    s nextPutAll:((eachIdx displayString , ' ') paddedTo:maxLen+1 with:$.).
                ].
                s nextPutAll:' : '.
            ].

            val := self indexedValueAtKey:eachIdx.

            ((ExpandArraysInAllLists == true) and:[val isSequenceable and:[ val class isPointers]]) ifTrue:[
                s cr.
                self appendDisplayStringForElementsOf:val indent:2 pad:maxLen+1+1 to:s.
            ] ifFalse:[
                varString := self basicDisplayStringForValue:val.
                (varString includes:Character cr) ifTrue:[
                    varString := varString copyTo:(varString indexOf:Character cr)-1.
                    varString := varString , '...'.
                ].
                s nextPutLine:varString.
            ].
        ].
    ].
    nShown < nIdx ifTrue:[
        s nextPutLine:' ...'.
    ].
    ^ s contents

    "Modified: / 12-02-2012 / 10:52:04 / cg"
!

stringWithAllInstVarValues
    ^ self stringWithAllInstVarValuesFor:object level:0

    "Modified: / 31-01-2012 / 18:23:11 / cg"
!

stringWithAllInstVarValuesFor:anObject level:lvl
    |s names instVarOffsets maxLen|

    s := CharacterWriteStream on:''.
    names := anObject class allInstVarNames.
    instVarOffsets := 1 to:names size.
    sortOrder == SortOrderAlphabetical ifTrue:[
        instVarOffsets := instVarOffsets asArray.
        names := names copy sortWith:instVarOffsets
    ].
    maxLen := (names collect:[:eachName | eachName size]) max.
    names with:instVarOffsets do:[:eachInstVarName :eachInstVarIndex |
        |val valString|

        IsDebuggingQuery answer:true do:[
            val := anObject instVarAt:eachInstVarIndex.
        ].
        s spaces:lvl.
        s nextPutAll:((eachInstVarName , ' ') paddedTo:maxLen+1 with:$.).
        s nextPutAll:' : '.

        ((ExpandArraysInAllLists == true) and:[val isSequenceable and:[ val class isPointers] ]) ifTrue:[
            s cr.
            self appendDisplayStringForElementsOf:val indent:lvl pad:maxLen+1+1 to:s.
        ] ifFalse:[
            valString := self basicDisplayStringForValue:val.
            (valString includes:Character cr) ifTrue:[
                valString := valString copyTo:(valString indexOf:Character cr)-1.
                valString := valString , '...'.
            ].
            s nextPutAll:valString.
            s cr.
        ].
    ].
    ^ s contents

    "Created: / 31-01-2012 / 18:23:15 / cg"
!

stringWithMessages:which
    |cls s messages allSelectors|

    cls := object class.
    which == #local ifTrue:[
        messages := cls selectors.
    ] ifFalse:[
        allSelectors := cls allSelectors.
        which == #all ifTrue:[
            messages := allSelectors.
        ] ifFalse:[
            messages := allSelectors asNewSet removeAll:cls selectors; yourself.
        ].
    ].

    s := CharacterWriteStream on:''.
    messages asOrderedCollection sort do:[:eachSelector |
        s nextPutAll:eachSelector.
        s cr.
    ].
    ^ s contents
!

valueStringInListEntryForValue:value
    "returns something to append to the name"

    |valString|

    Error handle:[:ex |
        Transcript showCR:ex description.
        valString := '*** error in printString **'
    ] do:[
        valString := (self plainValueStringInListEntryForValue:value) ? ''.
    ].
    (inspectedObject notNil and:[value == inspectedObject]) ifTrue:[
        ^ ' (',valString,') (==self)' 
    ].
    ^ ' (',valString,')'

    "Created: / 13-06-2012 / 12:04:31 / cg"
! !

!InspectorView methodsFor:'private'!

baseInspectedObjectClass
    "only instvars below that are shown by me in the non-basic tab.
     This hides uninterresting details in the regular tab"
     
    ^ Object
!

defaultLabel
    ^ 'Inst & Pseudo Slots'

    "Modified: / 30-07-2013 / 09:40:52 / cg"
!

derivedFieldNames
    |d actionItems valueItems otherItems|

    d := self derivedFields.
    (d isDictionary) ifTrue:[
        actionItems := d keys select:[:k | k first == $!!] as:OrderedCollection .
        valueItems := d keys select:[:k | '-¤' includes:k first] as:OrderedCollection.
        otherItems := d keys select:[:k | ('!!-¤' includes: k first) not] as:OrderedCollection.
        ^ ((actionItems sort , valueItems sort) collect:[:k | (k copyTo:1),(k copyFrom:2) allItalic])
          ,
          otherItems sort
    ].
    ^ d collect:[:eachEntry |
            |nm|

            nm := (eachEntry isAssociation) 
                    ifTrue:[ eachEntry key ] 
                    ifFalse:[ eachEntry first ].
            '-',nm allItalic
        ]

    "Created: / 03-08-2006 / 15:02:54 / cg"
    "Modified: / 27-01-2011 / 11:45:17 / cg"
!

derivedFields
    ^ self myObjectsInspectorExtraAttributes
!

extraNamedFieldNames
    ^ self extraNamedFields 
        collect:[:eachEntry |
            |nm|

            nm := (eachEntry isAssociation) 
                    ifTrue:[ eachEntry key ] 
                    ifFalse:[ eachEntry first ].
            '`',nm
        ]

    "Modified: / 03-08-2006 / 15:17:19 / cg"
!

extraNamedFields
    "by redefining inspectorExtraNamedFields to return an array of
     pseudo-fieldName->value associations, the inspectors left list can be extended"

    "the check below is not sufficient - if someone catches messages, for example.
     Therefore, we do a manual lookup here:"

    (object class whichClassIncludesSelector:#inspectorExtraNamedFields) isNil ifTrue:[
        ^ #()
    ].
    ^ [object inspectorExtraNamedFields]
                on: MessageNotUnderstood
                do: [:ex | ex return: #() ]

    "Created: / 03-08-2006 / 13:34:18 / cg"
    "Modified: / 29-08-2006 / 13:03:57 / cg"
!

extraNamedVarIndexForLine:lineNr
    "helper - return the index for a named instVar;
     nil, if self or a keyed instvar is selected."

    |idx nNamedInstvarsShown nExtraNamedInstvarsShown cls baseCls firstRealIndex line|

    lineNr isNil ifTrue:[^ nil].
    firstRealIndex := 1.

    idx := lineNr.
    self hasSelfEntry ifTrue:[
        (lineNr == 1 or:[lineNr isNil]) ifTrue:[
            ^ nil "/ self selected
        ].
        idx := idx - 1.
        firstRealIndex := 2.
    ].

    [
        line := self listEntryAt:firstRealIndex. 
        line notNil and:[self isSpecialPseudoNameEntry:line]
    ] whileTrue:[
        firstRealIndex := firstRealIndex + 1.
        idx := idx - 1.
    ].

    cls := object class.
    baseCls := self baseInspectedObjectClass.

    nNamedInstvarsShown := cls instSize.
    "/ only the namedInstvars below baseInspectedObjectClass
    "/ are shown ...
    (cls == baseCls or:[cls isSubclassOf:baseCls]) ifTrue:[
        nNamedInstvarsShown := nNamedInstvarsShown - baseCls instSize.
    ].

    idx := idx - nNamedInstvarsShown.
    idx < 1 ifTrue:[
        ^ nil.
    ].

    nExtraNamedInstvarsShown := self extraNamedFields size.
    idx <= nExtraNamedInstvarsShown ifTrue:[
        ^ idx.
    ].

    ^ nil "/ indexed instvar or other selected

    "Created: / 03-08-2006 / 13:45:14 / cg"
    "Modified: / 16-05-2012 / 17:54:52 / cg"
!

fieldList 
    "return a list of names to show in the selectionList.
     Leave hasMore as true, if a '...' entry should be added."

    |derivedFieldList namedFieldList fieldList cls indexedList extraNamedFieldList|

    (object isNil" or:[object isLazyValue]") ifTrue:[
        ^ self hasSelfEntry ifFalse:[ #() ] ifTrue:[ #('-self') ]
    ].

    IsDebuggingQuery answer:true do:[
        cls := object class.

        self topView withWaitCursorDo:[
            namedFieldList := self namedFieldList.
            indexedList := self indexedFieldList.
            extraNamedFieldList := OrderedCollection new.

            self hasSelfEntry ifTrue:[
                self suppressPseudoSlots ifFalse:[
                    derivedFieldList := OrderedCollection new.
                    derivedFieldList addAll:(self pseudoFieldNamesWithIndexed:(indexedList notEmptyOrNil)).
                    derivedFieldList addAll:(self derivedFieldNames).
                    extraNamedFieldList addAll:(self extraNamedFieldNames).
                ].
            ].

            fieldList := OrderedCollection new.
            derivedFieldList notNil ifTrue:[fieldList addAll:derivedFieldList].
            namedFieldList notNil ifTrue:[fieldList addAll:namedFieldList].
            extraNamedFieldList notNil ifTrue:[fieldList addAll:extraNamedFieldList].
            indexedList notNil ifTrue:[fieldList addAll:indexedList].
        ].
    ].
    ^ fieldList

    "Modified: / 18-09-2006 / 21:16:03 / cg"
!

hasSelfEntry
    ^ hideReceiver not and:[self suppressPseudoSlots not]

    "Created: 14.12.1995 / 19:30:03 / cg"
    "Modified: 28.6.1996 / 15:13:41 / cg"
!

indexList 
    "return a list of indexes usable to access the object's indexed slots.
     Set hasMore to true, if a '...' entry should be added."

    |objSz n cls list|

    cls := object class.

    cls isVariable ifFalse:[^ nil ].

    n := objSz := self numIndexedFields.
    (n > nShown) ifTrue:[
        n := nShown.
        hasMore := true.
    ].
    list := (1 to:n).
    ^ list 
"/        keysAndValuesCollect:[:idx :nm |
"/            LabelAndIcon string:nm image:(self iconForValue:(object basicAt:idx))
"/        ].

    "Modified: / 13-06-2012 / 10:14:13 / cg"
!

indexOfFirstNamedInstvarInList
    "helper - return the index for the first named instVar;
     nil, if self or a keyed instvar is selected."

    |firstRealIndex|

    firstRealIndex := 1.
    self hasSelfEntry ifTrue:[
        firstRealIndex := 2.
    ].

    [
        |line|

        line := self listEntryAt:firstRealIndex. 
        line notNil and:[self isSpecialPseudoNameEntry:line]
    ] whileTrue:[
        firstRealIndex := firstRealIndex + 1.
    ].
    ^ firstRealIndex

    "Modified: / 16-05-2012 / 17:54:46 / cg"
!

indexedFieldList 
    "return a list of indexed-variable names to show in the selectionList.
     Set hasMore to true, if a '...' entry should be added."

    |l maxIndex sz list|

    l := self indexList.
    l isEmptyOrNil ifTrue:[^ nil ].

    integerDisplayRadix ~~ 10 ifTrue:[
        maxIndex := l last.
        maxIndex isInteger ifTrue:[
            sz := (maxIndex printStringRadix:integerDisplayRadix) size.
        ] ifFalse:[
            sz := 0
        ].
        list := l collect:
            [:i | 
                i isInteger ifTrue:[
                    (i printStringRadix:integerDisplayRadix size:sz fill:$0) 
                ] ifFalse:[
                    i printString
                ]
            ]
    ] ifFalse:[
        list := l collect:[:i | i printString].
    ].

    ^ list
        keysAndValuesCollect:[:idx :nm |
            |val|

            [
                val := self indexedValueAtIndex:idx.
            ] on:Error do:[
                val := ''
            ].
"/            [
"/                val := object at:idx.
"/            ] on:Error do:[
"/                [
"/                    val := object basicAt:idx
"/                ] on:Error do:[
"/                    val := ''
"/                ]
"/            ].
            self listEntryForName:nm value:val
        ].

"/    ^ list.

    "Modified: / 27-09-2012 / 21:51:58 / cg"
!

indexedValueAtIndex:idx
    ^ object basicAt:idx
!

indexedValueAtIndex:idx put:newValue
    object basicAt:idx put:newValue
!

indexedValueAtKey:key
    "/ kludge
    object isLimitedPrecisionReal ifTrue:[
        ^ object basicAt:key
    ].
    ^ object at:key
!

instVarIndexForLine:lineNr
    "helper - return the index for a named instVar;
     nil, if self or a keyed instvar is selected."

    |idx firstRealIndex line nm|

    lineNr isNil ifTrue:[^ nil].
    firstRealIndex := 1.

    line := (self listEntryAt:lineNr) string. 
    (self isSpecialPseudoNameEntry:line) ifTrue:[^ nil].

    nm := line asCollectionOfWords first.
    idx := object class allInstVarNames indexOf:nm.
    idx == 0 ifTrue:[^ nil].
    ^ idx.    

"/    [
"/        line := self listEntryAt:firstRealIndex. 
"/        (line startsWith:'-') and:[line size < 2 or:[line second isDigit not]]
"/    ] whileTrue:[
"/        firstRealIndex := firstRealIndex + 1.
"/        idx := idx - 1.
"/    ].
"/
"/    cls := object class.
"/    baseCls := self baseInspectedObjectClass.
"/
"/    nNamedInstvarsShown := cls instSize.
"/    "/ only the namedInstvars below baseInspectedObjectClass
"/    "/ are shown ...
"/    (cls includesBehavior:baseCls) ifTrue:[
"/        nNamedInstvarsShown := nNamedInstvarsShown - baseCls instSize.
"/    ].
"/
"/    idx <= nNamedInstvarsShown ifTrue:[
"/        ^ idx + self baseInspectedObjectClass instSize.
"/    ].
"/    ^ nil "/ indexed instvar or other selected

    "Modified: / 20-07-2012 / 11:11:10 / cg"
!

isSpecialPseudoNameEntry:line
    ^ (line startsWith:$-) 
    and:[line size < 2 or:[line second isDigit not]]
!

keyIndexForLine:lineNr
    "helper - return the index of the key-list;
     nil, if self or a namedInstVar is selected."

    |idx nNamedInstvarsShown nExtraNamedInstvarsShown cls baseCls firstRealIndex line|

    lineNr isNil ifTrue:[^ nil].

    firstRealIndex := 1.
    idx := lineNr.
    self hasSelfEntry ifTrue:[
        (lineNr == 1 or:[lineNr isNil]) ifTrue:[
            ^ nil "/ self selected
        ].
        idx := idx - 1.
        firstRealIndex := firstRealIndex + 1.
    ].

    [
        line := self listEntryAt:firstRealIndex. 
        line notNil and:[ self isSpecialPseudoNameEntry:line ]
    ] whileTrue:[
        firstRealIndex := firstRealIndex + 1.
        idx := idx - 1.
    ].

    cls := object class.
    baseCls := self baseInspectedObjectClass.

    nNamedInstvarsShown := cls instSize.
    "/ only the namedInstvars below baseInspectedObjectClass
    "/ are shown ...
    (cls includesBehavior:baseCls) ifTrue:[
        nNamedInstvarsShown := nNamedInstvarsShown - baseCls instSize.
    ].
    nExtraNamedInstvarsShown := self extraNamedFields size.

    idx <= (nNamedInstvarsShown+nExtraNamedInstvarsShown) ifTrue:[
        ^ nil "/ named instVar selected.
    ].
    ^ idx - (nNamedInstvarsShown+nExtraNamedInstvarsShown).

    "Modified: / 16-05-2012 / 17:54:34 / cg"
!

listEntryAt:lineNr
    |entry|

    entry := listView at:lineNr.
    entry isNil ifTrue:[^ entry].
    ^ entry perform:#string ifNotUnderstood:[ entry printString ].

    "Created: / 16-05-2012 / 17:53:39 / cg"
!

myObjectsInspectorExtraAttributes

    "the MessageNotUnderstood check below is not sufficient - if some proxy catches messages, for example.
     Therefore, we do a manual lookup here:"
    (object class canUnderstand:#inspectorExtraAttributes) ifFalse:[
        ^ #()
    ].
    ^ [object inspectorExtraAttributes]
                on: MessageNotUnderstood
                do: [:ex | ex return: #() ]

    "Created: / 17-07-2006 / 11:02:32 / cg"
    "Modified: / 29-08-2006 / 13:03:31 / cg"
!

namedFieldAt:idx
    |val|

    IsDebuggingQuery answer:true do:[
        val := object instVarAt:idx
    ].
    ^ val
!

namedFieldAt:idx put:newValue
    ^ object instVarAt:idx put:newValue
!

namedFieldList
    "return a list of instVar names to show in the selectionList."

    |aList cls baseCls offset|

    cls := object class.
    baseCls := self baseInspectedObjectClass.

    aList := OrderedCollection new.

    aList addAll:(cls allInstVarNames).
    offset := 0.
    (cls includesBehavior:baseCls) ifTrue:[
        "/ hide some stuff
        offset := self baseInspectedObjectClass instSize.
        aList := aList copyFrom:(offset + 1).
    ].
    aList := aList
                keysAndValuesCollect:[:idx :nm |
                    |val|

                    val := object instVarAt:idx+offset.
                    self listEntryForName:nm value:val
                ].
    sortOrder == SortOrderAlphabetical ifTrue:[
        aList sort:[:a :b | a string < b string].
    ].
    ^ aList

    "Modified: / 29-07-2012 / 12:11:06 / cg"
!

numIndexedFields
    ^ inspectedObject basicSize

    "Created: / 13-06-2012 / 10:13:24 / cg"
!

pseudoFieldNames
    "return a list of names to show in the selectionList.
     Leave hasMore as true, if a '...' entry should be added."

    ^ self pseudoFieldNamesWithIndexed: object class isVariable

    "Modified: / 06-06-2012 / 11:56:56 / cg"
!

pseudoFieldNamesWithIndexed:withIndexed
    "return a list of names to show in the selectionList.
     Leave hasMore as true, if a '...' entry should be added."

    |list cls|

    cls := object class.

    list := OrderedCollection new.
    self hasSelfEntry ifTrue:[
        list add:'-' , (object isJavaObject ifTrue:['this'] ifFalse:['self']) allItalic.
    ].
    list add:'-' , 'class' allItalic.
    hideMessages ifFalse:[
        list add:'-' , 'local messages' allItalic.
        "/ list add:'-' , 'inherited messages' allItalic.
        list add:'-' , 'all messages' allItalic.
    ].
    hideHashes ifFalse:[
        list add:'-' , 'hash' allItalic.
        list add:'-' , 'identityHash' allItalic.
    ].

    withIndexed ifTrue:[
        list add:'-' , 'basicSize' allItalic, (self valueStringInListEntryForValue:object basicSize).
    ].

    object isProtoObject ifFalse:[
        object isCollection ifTrue:[
            (cls whichClassImplements:#size) ~~ (cls whichClassImplements:#basicSize) ifTrue:[
                Error handle:[:ex |
                ] do:[
                    "/ Iterator has trouble
                    list add:'-' , 'size' allItalic , (self valueStringInListEntryForValue:object size).
                ].
            ]
        ].

        cls hasImmediateInstances ifFalse:[
            object dependents notEmptyOrNil ifTrue:[
                list add:'-' , 'dependents' allItalic, (self valueStringInListEntryForValue:object dependents size).
            ].
        ].

        object isClass ifTrue:[
            list add:'-' , 'all class vars' allItalic.
        ].
    ].

    cls instSize ~~ 0 ifTrue:[
        list add:'-' , 'all inst vars' allItalic.
    ].
    (withIndexed and:[self showAllIndexedVarsInFieldList]) ifTrue:[
        list add:'-' , 'all indexed vars' allItalic.
    ].
    ^ list

    "Modified: / 13-06-2012 / 12:10:16 / cg"
    "Modified: / 05-11-2013 / 17:57:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setAcceptAction
    "set the codeView's accept action"

    |idx acceptAction sel|

    acceptAction := [:theText | self doAccept:theText asString].

    idx := self theSingleSelectionIndex.

    (idx isNil
    or:[ object class hasImmediateInstances])
    ifTrue:[
        acceptAction := nil.
    ] ifFalse:[
        sel := self listEntryAt:idx.

        (sel startsWith:'-all') ifTrue:[
            acceptAction := nil.
        ].
        (sel startsWith:'-class') ifTrue:[
            acceptAction := nil.
        ].
        (sel startsWith:'-hash') ifTrue:[
            acceptAction := nil.
        ].
        (sel startsWith:'-basicSize') ifTrue:[
            acceptAction := nil.
        ].
        (sel startsWith:'-size') ifTrue:[
            acceptAction := nil.
        ].
        (sel startsWith:'-identityHash') ifTrue:[
            acceptAction := nil.
        ].
        (sel startsWith:'-dependents') ifTrue:[
            acceptAction := nil.
        ].
        (sel startsWith:'-source') ifTrue:[
            acceptAction := nil.
        ].
    ].

    workspace acceptAction:acceptAction.

    "Modified: / 06-06-2012 / 11:57:27 / cg"
!

setDoItAction
    "set the codeViews doit action"

    workspace
        doItAction:[:theCode |
            |evaluator|

            (evaluator := object class evaluatorClass)
            notNil ifTrue:[
                evaluator
                    evaluate:theCode
                    in:nil
                    receiver:object
                    notifying:workspace
                    logged:true
                    ifFail:nil
            ] ifFalse:[
                'object''s class provides no evaluator'
            ]
        ];
        editedMethodOrClass:(object class).

"/    object class evaluatorClass isNil ifTrue:[
"/        workspace doItAction:nil.
"/        workspace acceptAction:nil.
"/    ]

    "Modified: 1.8.1997 / 21:47:09 / cg"
!

showAllIndexedVarsInFieldList
    ^ true
!

theSingleSelectionIndex
    "helper - return the index of the (single) selected entry.
     Nil if nothing or multiple items are selected"

    |idx|

    idx := selectionIndex.
    idx isCollection ifTrue:[
        selectionIndex size == 1 ifTrue:[
            ^ selectionIndex first
        ].
        ^ nil
    ].
    ^ selectionIndex
!

valueAtLine:lineNr
    "helper - return the value of the selected entry"

    |idx lineEntry val|

    (self hasSelfEntry
    and:[lineNr == 1 or:[lineNr isNil]]) ifTrue:[
        ^ object
    ].

    ((lineEntry := self listEntryAt:lineNr) startsWith:$-) ifTrue:[
        (lineEntry ~= '-' 
          and:[(lineEntry at:2) isSeparator not
          and:[(lineEntry at:2) isDigit not "negative number"]]
        ) ifTrue:[
            ^ self valueForSpecialLine:lineEntry
        ].
    ].
    (lineEntry startsWith:$¤) ifTrue:[
        ^ self valueForSpecialLine:lineEntry
    ].

    "/ a named instVar ?
    idx := self instVarIndexForLine:lineNr.
    idx notNil ifTrue:[
        BreakPointInterrupt catch:[
            ^ self namedFieldAt:idx
        ]
    ].

    "/ an extra named field ?
    idx := self extraNamedVarIndexForLine:lineNr.
    idx notNil ifTrue:[
        BreakPointInterrupt catch:[
            val := ((self extraNamedFields) at:idx) value.
            val isBlock ifTrue:[ val := val value ].
            ^ val
        ]
    ].

    "/ an indexed instVar ?
    idx := self keyIndexForLine:lineNr.
    idx notNil ifTrue:[
        BreakPointInterrupt catch:[
            ^ self indexedValueAtIndex:idx.
        ]
    ].

    "/ nope
    ^ nil

    "Modified: / 16-05-2012 / 17:54:06 / cg"
!

valueAtLine:lineNr put:newValue
    |idx|

    idx := self instVarIndexForLine:selectionIndex.
    idx notNil ifTrue:[
        self namedFieldAt:idx put:newValue.
        ^ self.
    ].

    idx := self keyIndexForLine:selectionIndex.
    idx notNil ifTrue:[
        self indexedValueAtIndex:idx put:newValue.
        ^ self
    ].

    "/ self or special entry selected - don't store
    self beep.
    ^ self 
!

valueForSpecialLine:line
    |idx fieldEntry extraAttributes fields|

    extraAttributes := self myObjectsInspectorExtraAttributes.
    (extraAttributes includesKey:line) ifTrue:[
        ^ (extraAttributes at:line) value
    ].

    idx := self derivedFieldNames findFirst:[:l | l string = line string ].
    idx ~~ 0 ifTrue:[
        "a lot of backward compatibility crab which has to go away..."
        fields := self derivedFields.
        (fields isDictionary) ifTrue:[
            fieldEntry := fields associationAt:line string "idx".
        ] ifFalse:[
            fieldEntry := fields associationAt:idx.
        ].
    ] ifFalse:[
        idx := self extraNamedFieldNames indexOf:line.
        idx ~~ 0 ifTrue:[
            fieldEntry := self extraNamedFields at:idx.
        ].
    ].
    fieldEntry notNil ifTrue:[
        fieldEntry isAssociation ifTrue:[
            ^ fieldEntry value value
        ].
        ^ fieldEntry at:2.
    ].

    (line startsWith:'-self') ifTrue:[
        ^ object
    ].
    (line startsWith:'-basicSize') ifTrue:[
        ^ object basicSize
    ].
    (line startsWith:'-size') ifTrue:[
        ^ object size
    ].
    (line startsWith:'-class') ifTrue:[
        ^ object class
    ].
    (line startsWith:'-hash') ifTrue:[
        ^ object hash
    ].
    (line startsWith:'-identityHash') ifTrue:[
        ^ object identityHash
    ].
    (line startsWith:'-dependents') ifTrue:[
        ^ object dependents
    ].
    (line startsWith:'-all') ifTrue:[
        ^ object
    ].
    (line startsWith:'-local messages') ifTrue:[
        ^ object
    ].
    (line startsWith:'-inherited messages') ifTrue:[
        ^ object
    ].
    (line startsWith:'-all messages') ifTrue:[
        ^ object
    ].

    (line startsWith:'--- ') ifTrue:[
        "/ info line, such as '--- classvariables from...'
        ^ object
    ].

    self error:'unknown special line'.

    "Created: / 31-10-2001 / 09:17:45 / cg"
    "Modified: / 06-06-2012 / 11:57:54 / cg"
! !

!InspectorView methodsFor:'queries'!

canInspect:anObject
    ^ anObject inspectorClass == self class
!

compilerClass
    ^ object class compilerClass
!

dereferenceValueHolders
    ^ dereferenceValueHolders ? false
!

isIndexShown
    ^ true
!

labelFor:anObject
    "return the windowLabel to use in my topView, when inspecting anObject."

    |myClass lbl|

    myClass := self class.
    (myClass == InspectorView
     and:[anObject isProtoObject not and:[anObject inspectorClass ~~ InspectorView]]) ifTrue:[
        lbl := 'BasicInspector on: '
    ] ifFalse:[
        lbl := 'Inspector on: '
    ].
    ^ (myClass classResources string:lbl), (myClass commonLabelFor:anObject)

    "Modified: / 15-07-2011 / 16:22:05 / cg"
!

labelNameFor:anObject
    "return the iconLabel to use in my topView, when inspecting anObject.
     Simply returns the className or name of anObjects class"

    ^ self class labelNameFor:anObject

    "
     1234 inspect
     true inspect
     $a inspect
    "

    "Modified: / 25-07-2012 / 10:15:06 / cg"
!

selectedKeyName
    "used by the debugger, to fetch the selected instVar/pseudoVar name,
     so it can be reselected after the next single step
     (using tryToSelect..)"

    |sel|

    selectionIndex notNil ifTrue:[
        sel := listView listAt:selectionIndex.
        sel notNil ifTrue:[
            sel := sel string.
            "/ careful: pseudo entries may have spaces in-between
            (sel startsWith:'-') ifFalse:[
                "/ clip off the value-info string
                sel := sel copyUpTo:(Character space).
            ].
            ^ sel
        ].
    ].
    ^ nil
!

suppressPseudoSlots
    ^ suppressPseudoSlots ? false
! !

!InspectorView methodsFor:'selection'!

selection:lineNr
    self showSelection:lineNr
!

showSelection:lineNr
    "user clicked on an instvar - show value in workspace"

    |listSize|

    listSize := listView list size.
    listSize == 0 ifTrue:[^ self].

    (hasMore and:[lineNr == listSize]) ifTrue:[
        "clicked on the '...' entry"
        self showMore.
        listView setSelection:lineNr.
    ].

    (self hasSelfEntry and:[lineNr == 1]) ifTrue:[
        "selecting self also does a re-set, this allows updating the list"
        self reinspect.
    ].
    selectionIndex := selectedLine := lineNr.
    self showValue:(self selection).

    self setAcceptAction.

    "Modified: / 03-08-2006 / 14:26:22 / cg"
!

showValue:someValue
    "user clicked on an entry - show value in workspace"

    |s|

    self "topView" withWaitCursorDo:[
        [
            s := self displayStringForValue:someValue.
        ] valueWithWatchDog:[
            s := someValue classNameWithArticle,' "- printString generation took too long"'
        ] afterMilliseconds:1000.

        s = workspace selectionAsString ifFalse:[
            workspace replace:s.
        ].
    ].

    "Modified: / 28-10-2012 / 11:03:04 / cg"
! !

!InspectorView methodsFor:'user interaction'!

doAccept:theText
    "the selected text is evaluated and stored into the selected field"

    |sel newValue fieldNameList|

    sel := self listEntryAt:(self theSingleSelectionIndex).
    (sel startsWith:'-all') ifTrue:[
        workspace flash.
        ^ self.
    ].

    Error handle:[:ex |
        workspace flash
    ] do:[
        newValue := object class evaluatorClass
                       evaluate:theText
                       receiver:object
                       notifying:workspace.

        self dereferenceValueHolders ifTrue:[
            (self valueAtLine:selectionIndex) value:newValue
        ] ifFalse:[
            self valueAtLine:selectionIndex put:newValue.
        ].
        "/ update the fieldList...
        fieldNameList := self fieldList.
        hasMore ifTrue:[
            fieldNameList add:' ... '
        ].
        listView contents:fieldNameList.
    ]

    "Modified: / 04-06-2012 / 18:16:29 / cg"
!

doCopyKey
    "put the instVar-name into the text-copy-buffer"

    |nm selIdx|

    (selIdx := self theSingleSelectionIndex) notNil ifTrue:[
        nm := self selectedKeyName.
        nm notNil ifTrue:[
            self setClipboardText:(nm asString)
        ]
    ]
!

doInspect:basicBooleanOrSymbolForHow
    "user selected the inspect-menu entry"

    self doInspect:self selectedField basic:basicBooleanOrSymbolForHow
!

doInspect:objectToInspect basic:basic
    "user selected the basic-inspect-menu entry"

    objectToInspect notNil ifTrue:[
        (basic == #new and:[NewInspector::NewInspectorView notNil]) ifTrue:[
            NewInspector::NewInspectorView inspect:objectToInspect
        ] ifFalse:[
            basic ifTrue:[
                objectToInspect basicInspect
            ] ifFalse:[
                "/ cg: a bad hack; it is ok for a double-click, but not for the
                "/ menu item (i often want to have another inspector on the same object)
                "/ for the menu: add an extra follow/diveIn or whatever entry, if desired
"/                "HACK"
"/                app := (self topView perform:#application ifNotUnderstood: [nil]).
"/                (app notNil and:[app isKindOf: Tools::Inspector2]) ifTrue:[
"/                    app inspect: objectToInspect
"/                ] ifFalse:[
                    objectToInspect inspect
"/                ]
            ]
        ].
    ].

    "Modified: / 06-07-2011 / 15:58:55 / jv"
    "Modified: / 27-07-2012 / 22:43:11 / cg"
!

doUpdate
    self reinspect
!

monitor:anInstVarName
    "start a monitoring process, showing the given instVar
     in regular time intervals."

    |ivName|

    (ivName := anInstVarName) isInteger ifTrue:[
        ivName := anInstVarName printString
    ].
    listView selectElement:ivName.
    self doStartMonitor

    "Created: / 1.3.1996 / 19:31:45 / cg"
    "Modified: / 12.2.1999 / 16:05:47 / cg"
!

selection
    "helper - return the value of the (single) selected entry.
     Nil if nothing or multiple items are selected"

    |idx val|

    idx := self theSingleSelectionIndex.
    idx isNil ifTrue:[^ nil].

    val := self valueAtLine:idx.
    self dereferenceValueHolders ifTrue:[
        "workspace-variable-inspection"
        val := val value
    ].
    ^ val

    "Modified: / 03-08-2006 / 14:27:02 / cg"
!

showLast
    "user clicked on an instvar - show value in workspace"

    |lastIdx|

    lastIdx := listView list size.
    lastIdx ~~ 0 ifTrue:[
        self showSelection:lastIdx.
        listView selection:lastIdx.
    ]

    "Created: 28.6.1996 / 15:06:38 / cg"
    "Modified: 18.3.1997 / 18:22:54 / cg"
!

tryToSelectKeyNamed:aString
    "called from the debugger to try to select the previousöy selected
     field (by name)"
     
    |list idx aStringWithSpace|

    aString isEmptyOrNil ifTrue:[^ self].

    aStringWithSpace := aString string,' '.

    list := listView list.
    list notNil ifTrue:[
        idx := list findFirst:[:line |
                        line = aString
                        or:[line string startsWith:aStringWithSpace]].
        idx ~~ 0 ifTrue:[
            listView selection:idx
        ].
    ].

    "Created: / 16-11-2001 / 13:48:51 / cg"
! !

!InspectorView methodsFor:'workspace protocol'!

modified:aBoolean
    ^ workspace modified:aBoolean
!

saveAs:file doAppend:doAppend
    workspace saveAs:file doAppend:doAppend
! !

!InspectorView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


InspectorView initialize!
