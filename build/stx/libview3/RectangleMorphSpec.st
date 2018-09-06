"
 COPYRIGHT (c) 2009 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview3' }"

"{ NameSpace: Smalltalk }"

DisplayObjectComponentSpec subclass:#RectangleMorphSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!RectangleMorphSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!RectangleMorphSpec class methodsFor:'image specs'!

iconFilled
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconFilled inspect
     ImageEditor openOnClass:self andSelector:#iconFilled
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'RectangleMorphSpec class iconFilled'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EUUUUT@@@@@@EUUUUT@@@@@@EUUUUT@@@@@@EUUUUT@@@@@@EUUUUT@@@@@@EUUUUT@@@
@@@EUUUUT@@@@@@EUUUUT@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 107 239 99 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@C?0@C?0@C?0@C?0@C?0@C?0@C?0@C?0@C?0@C?0@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconUnfilled
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconUnfilled inspect
     ImageEditor openOnClass:self andSelector:#iconUnfilled
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'RectangleMorphSpec class iconUnfilled'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@C?0@B@P@B@P@B@P@B@P@B@P@B@P@B@P@B@P@C?0@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
! !

!RectangleMorphSpec methodsFor:'accessing-color & font'!

backgroundColor
    ^ nil
! !

!RectangleMorphSpec methodsFor:'building'!

basicCreateViewFor:aBuilder in:aParentView
    |component|

    component := RectangleMorph new.
    aParentView addComponent:component.
    ^ component
!

setAttributesIn:aComponent with:aBuilder
    super setAttributesIn:aComponent with:aBuilder.
!

setChannelsIn:aComponent with:aBuilder
    "set channels in aComponent"

    super setChannelsIn:aComponent with:aBuilder.
! !

!RectangleMorphSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.
    ^l
! !

!RectangleMorphSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    super fromView:aView callBack:aBlock.
! !

!RectangleMorphSpec methodsFor:'queries-UIPainter'!

icon
    fill == true ifTrue:[
        ^ self class iconFilled
    ].
    ^ self class iconUnfilled
! !

!RectangleMorphSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitRectangleMorphSpec:self
! !

!RectangleMorphSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview3/RectangleMorphSpec.st,v 1.9 2017-11-28 18:21:25 cg Exp $'
! !

