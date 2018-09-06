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

VariablePanelSpec subclass:#VariableVerticalPanelSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!VariableVerticalPanelSpec class methodsFor:'documentation'!

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

!VariableVerticalPanelSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'VariableVerticalPanelSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@QDQDQDQDQD0@P@@@@@@@@@ @PH"H"H"H#@ @PJH"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @P@@@@@@@@@ @PH"H"H"H#@ @PJH"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @PHQDQDQDQ@ @P@@@@@@@@@ @2H"H"H"H"H @@@@@@@@@@@@');
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

!VariableVerticalPanelSpec methodsFor:'building'!

setupInitialLayoutFor:aView
    aView geometryLayout:nil.

    (aView relativeOrigin isNil 
    or:[aView relativeExtent isNil and:[aView relativeCorner isNil]]) ifTrue:[
        aView corner:0@0.
        aView origin:0.0@0.0.
        aView extent:1.0@0.3.
        "/ aView superView setupSubviews.
        "/ aView superView resizeSubviews.
    ].

    "Modified (comment): / 11-02-2017 / 16:54:33 / cg"
! !

!VariableVerticalPanelSpec methodsFor:'queries'!

isVertical
    ^ true
! !

!VariableVerticalPanelSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/VariableVerticalPanelSpec.st,v 1.14 2017-02-12 01:13:31 cg Exp $'
! !

