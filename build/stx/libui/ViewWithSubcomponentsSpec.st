"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

ComponentSpec subclass:#ViewWithSubcomponentsSpec
	instanceVariableNames:'component'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ViewWithSubcomponentsSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

    "Modified: 4.9.1995 / 19:40:38 / claus"
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

!ViewWithSubcomponentsSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'ViewWithSubcomponentsSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@QDQDQDQDQD0@P@@@@@@@@@ @PH"H"H"H#@ @PJH"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @PHQDQDQDQ@ @P@@@@@@@@@ @2H"H"H"H"H @@@@@@@@@@@@');
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

!ViewWithSubcomponentsSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        component
                     )
        to:env 
        for:inst 
        channel:aChannel

    "Modified: / 26.10.1997 / 03:48:30 / cg"
! !

!ViewWithSubcomponentsSpec class methodsFor:'queries'!

supportsSubComponents
    "answer whether instances of the spec class support sub components"

    ^ true
! !

!ViewWithSubcomponentsSpec methodsFor:'accessing'!

component
    ^ component

    "Modified: 4.9.1995 / 17:58:43 / claus"
!

component:something
    component := something.

    "Modified: 4.9.1995 / 17:58:43 / claus"
! !

!ViewWithSubcomponentsSpec methodsFor:'building'!

buildComponentFor:aBuilder in:v
    component notNil ifTrue:[
        component buildViewWithLayoutFor:aBuilder in:v.
    ].
!

buildViewWithLayoutFor:aBuilder in:aView
    |newView|

    newView := super buildViewWithLayoutFor:aBuilder in:aView.

    "/ build my children
    self buildComponentFor:aBuilder in:newView.
    ^ newView

    "Modified: 4.9.1995 / 19:12:01 / claus"
    "Modified: 15.2.1997 / 13:03:19 / cg"
! !

!ViewWithSubcomponentsSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    component notNil ifTrue:[
        component := component decodeAsLiteralArray
    ]

    "Modified: 4.9.1995 / 17:59:49 / claus"
    "Modified: 17.1.1997 / 21:23:41 / cg"
! !

!ViewWithSubcomponentsSpec methodsFor:'enumerating'!

do:aBlock
    aBlock value:self.
    component notNil ifTrue:[
        component do:[:each | each do:aBlock]
    ].
! !

!ViewWithSubcomponentsSpec methodsFor:'parsing a view'!

componentFromView:aView callBack:aBlock
    |subs|

    (subs := aView subViews) notNil ifTrue:[
        component := SpecCollection new fromViews:subs callBack:aBlock.
    ].
!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    super fromView:aView callBack:aBlock.
    self componentFromView:aView callBack:aBlock
! !

!ViewWithSubcomponentsSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ViewWithSubcomponentsSpec.st,v 1.26 2016-04-24 13:14:11 cg Exp $'
! !

