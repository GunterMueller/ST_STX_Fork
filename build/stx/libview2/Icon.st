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
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Icon
	instanceVariableNames:''
	classVariableNames:'KnownIcons'
	poolDictionaries:''
	category:'Graphics-Images'
!

!Icon class methodsFor:'documentation'!

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
!

documentation
"
    The Icon class keeps track of already loaded Images and caches
    them for later reuse.
    Icons are accessed by a symbolic name, so there is no need to
    remember their names (they must have been registered under that name
    before - of course).

    Icon was mostly added for ST-80 Compatibility:

    Images are returned via the #constantNamed: message which is used by 
    many ST-80 public domain classes and returns corresponding ST/X icons.
    Notice, that ST/X does not provide Icon instances - Icon only consists
    of class mimicri protocol, to make your life easier.

    If you like the original ST-80 icons, install the image files in the `bitmap'
    directory under a name foo.xbm, where `foo' corresponds to the icons
    name symbol 
    (i.e. for the `Icon constantNamed:#foo', a 'foo.xbm' file is required).

    You can grab those icons from manchester or from the PrimeTime Freeware 
    (PTF) CD. A copy of those bitmaps (from the PTF-CD) is found in 
    'goodies/bitmaps/st80bitmaps'.

    [See also:]
        Image Form ImageReader

    [author:]
        Claus Gittinger
"
! !

!Icon class methodsFor:'initialization'!

initialize
    KnownIcons isNil ifTrue:[
        KnownIcons := Dictionary new.
	Color initialize.
    ]

    "
     Icon initialize
    "

    "Modified: 20.5.1996 / 09:24:10 / cg"
!

replacementNameFor:aName
    "return a replacement ST/X name for an ST80 icon name."

    self replacementNames do:[:aPair |
	(aPair at:1) == aName ifTrue:[^ aPair at:2].
    ].
    ^ nil
!

replacementNames
    "return an ST-80 constant name to ST/X file name translation.
     This was added for ST-80 compatibility, to support code which uses
     things like 'Icon constantNamed:#categoryBrowser'."

    ^ #( 
        #(file             FBrowser)
        #(debugger         Debugger)
        #(systembrowser    SBrowser)
        #(classbrowser     SBrowser)
        #(categoryBrowser  SBrowser)
        #(hierarchyBrowser SBrowser)
        #(methodBrowser    SBrowser)
        #(launcher         SmalltalkX)
        #(workspace        SmalltalkX)
        #(transcript       SmalltalkX)
        #(inspector        Inspector)
        #(default          SmalltalkX)
       )

    "
     Icon constantNamed:#categoryBrowser
     Icon constantNamed:#default
    "

    "Modified: 13.5.1996 / 10:29:43 / cg"
! !

!Icon class methodsFor:'accessing'!

constantNamed:aName
    "return the image registered under aName."

    ^ self constantNamed:aName searchForFile:true

    "
     Icon constantNamed:#file     
     Icon constantNamed:#debugger     
     Icon constantNamed:#systembrowser     
     Icon constantNamed:#SBrowser     
     Icon constantNamed:#SBrowser     
    "

    "Modified: 10.1.1997 / 17:52:06 / cg"
!

constantNamed:aName ifAbsentPut:aBlock
    "if an image for aName is registered, return it;
    otherwise, register the result from evaluating aBlock
    (which also could be a value holder) and return it."

    |image|

    image := self constantNamed:aName searchForFile:false.
    image isNil ifTrue:[
        image := aBlock value.
        self constantNamed:aName put:image.
    ].
    ^ image
!

constantNamed:aName ifAbsentPutImageFromFile:aFileName
    "if an image for aName is registered, return it;
    otherwise, load the image from aFileName (searched in bitmaps directories),
    register the result and return it."

    ^ self
        constantNamed:aName
        ifAbsentPut:[Smalltalk imageFromFileNamed:aFileName forClass:self]

!

constantNamed:aName put:anImage
    "register anImage under aName."

    KnownIcons isNil ifTrue:[
        self initialize
    ].
    KnownIcons at:aName put:anImage

    "Modified: 23.4.1996 / 11:40:51 / cg"
!

constantNamed:aName searchForFile:doSearchForFile
    "return the image registered under aName."

    |icon nm|

    KnownIcons isNil ifTrue:[
	self initialize
    ].
    icon := KnownIcons at:aName ifAbsent:[].

    (icon isNil and:[doSearchForFile]) ifTrue:[
        nm := self replacementNameFor:aName.
        nm notNil ifTrue:[
            icon := Smalltalk imageFromFileNamed:nm forClass:self.
            icon isNil ifTrue:[
                icon := Smalltalk imageFromFileNamed:(nm , '.xbm') forClass:self.
            ]
        ].

        icon isNil ifTrue:[
            icon := Smalltalk imageFromFileNamed:aName forClass:self.
            icon isNil ifTrue:[
                icon := Smalltalk imageFromFileNamed:(aName , '.xbm') forClass:self.
            ].
            icon isNil ifTrue:[
                ^ nil
            ].
            icon := icon onDevice:Screen default.
        ].
        KnownIcons at:aName put:icon.
    ].
    ^ icon

    "
     Icon constantNamed:#file     
     Icon constantNamed:#debugger     
     Icon constantNamed:#systembrowser     
     Icon constantNamed:#SBrowser     
     Icon constantNamed:#SBrowser     
    "

    "Modified: 10.1.1997 / 17:52:06 / cg"
!

nameIfKnownIcon:anImage
    "back-query, given an image, return its name-key if known; nil otherwise"

    KnownIcons isNil ifTrue:[^ nil].
    ^ KnownIcons keyAtValue:anImage ifAbsent:[nil].
! !

!Icon class methodsFor:'image specs'!

defaultSTXIcon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultSTXIcon1 inspect
     ImageEditor openOnClass:self andSelector:#defaultSTXIcon1
     Icon flushCachedIcons"
    
    ^ self constantNamed:#'Icon defaultSTXIcon1'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 2 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@E@@@@AP@D@@V@D@@APF@@@F&@@@AV@@@@&@@@@%P@@@&F@@@VBP@@V@I@@V@@P@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 0 127 127 184 231 231 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@X@A PGB@LX@_@A8@G@@<@GX@9 GC@8D@@@@@@b');
                            yourself);
                yourself
        ]
!

defaultSTXIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultSTXIcon2 inspect
     ImageEditor openOnClass:self andSelector:#defaultSTXIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^ Icon
        constantNamed:'Icon class defaultSTXIcon2'
        ifAbsentPut:[(Depth2Image width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@E@@@@AP@D@@T@D@@APD@@@DD@@@AT@@@@D@@@@EP@@@DD@@@T@P@@T@A@@T@@P@@@@@@@@@@@@@a') colorMapFromArray:#[184 231 231 0 127 127 0 0 0]; yourself]

    "Modified: / 30-01-2017 / 19:19:49 / stefan"
!

defaultSTXIcon3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultSTXIcon3 inspect
     ImageEditor openOnClass:self andSelector:#defaultSTXIcon3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'Icon class defaultSTXIcon3'
        ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[2]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@E@@@@AP@D@@V@D@@APF@@@FF@@@AV@@@@&@@@@%P@@@$F@@@T@X@@T@I@@T@@P@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 0 204 51 0 112 0]; yourself]

    "Modified: / 30-01-2017 / 19:19:58 / stefan"
!

stxIcon
    <resource:#programImage>
    |icn|

    (icn := self constantNamed:'stxIcon') isNil ifTrue:[
        icn := self stxIcon32x32.
        icn notNil ifTrue:[
            self constantNamed:'stxIcon' put:icn.
        ]
    ].
    ^ icn

    "
     Icon stxIcon   
    "

    "Modified: / 25.5.1999 / 15:42:55 / cg"
!

stxIcon16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stxIcon16x16 inspect
     ImageEditor openOnClass:self andSelector:#stxIcon16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^ self
        constantNamed:'Icon stxIcon16x16'
        ifAbsentPut:[(Depth2Image width:16 height:16) bits:(ByteArray fromPackedString:'************!!****(J*"**B*"**(Z"***""***(R****"**** ****""***R*Z**R*&**B**J*********** @a') colorMapFromArray:#[0 204 51 0 168 39 25 25 25 0 0 0]; yourself]
!

stxIcon32x32
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stxIcon32x32 inspect
     ImageEditor openOnClass:self andSelector:#stxIcon32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^ self
        constantNamed:'Icon stxIcon32x32'
        ifAbsentPut:[(Depth2Image width:32 height:32) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*@@@@F@@@@B(@@@A(@@@@J$@@@ZP@@@@* @@F$@@@@A*@@A)@@@@@B)@@ZP@@@@@F(@F$@@@@@
@J A)@@@@@@@ZPZP@@@@@@@*V$@@@@@@@@*)@@@@@@@@A*@@@@@@@@@F(@@@@@@@@A*$@@@@@@@@Z* @@@@@@@F)JP@@@@@@A*PZ@@@@@@@Z$@Y@@@@@@F)@
@(@@@@@A*P@A(@@@@@*$@@A$@@@@J*@@@B @@@B*$@@@F @@@J)@@@@FP@@@@@@@@@B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[0 0 0 184 231 231 0 128 128] mask:((ImageMask width:32 height:32) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@8@C@@N@A0@C0@<@@<@^@@O@O@@A8G @@^C0@@C!!8@@@<<@@@G>@@@@?@@@@O@@@@C0@@@A>@@@@? @@@_\@@@O''@@@G08@@C8
F@@A<A0@@>@N@@_@A @O0@\@C8@C @@@@H@@@@@@@@@@@@@@@@@b'); yourself); yourself]
!

stxIconOld
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stxIconOld inspect
     ImageEditor openOnClass:self andSelector:#stxIconOld
     Icon flushCachedIcons
    "

    <resource: #image>

    ^ self
        constantNamed:#'Icon stxIconOld'
        ifAbsentPut:[(Depth2Image new) width: 48; height: 48; photometric:(#palette); bitsPerSample:(#[2]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU@UUUUUUUTEUUUUUT@EUUUUUUPUUUUUUT@EU
UUUUUAUUUUUUT@EUUUUUXEUUUUUUT@EUUUUU %UUUUUUT@IUUUUVBUUUUUUUU@AUUUUXIUUUUUUUU@AUUUU EUUUUUUUUP@UUUV@UUUUUUUUUX@UUUTAUUUU
UUUUUT@EUUPEUUUUUUUUUV@EUU@UUUUUUUUUUU@AUTBUUUUUUUUUUUPBUPIUUUUUUUUUUUP@U@EUUUUUUUUUUUT@$@UUUUUUUUUUUUV@@AUUUUUUUUUUUUU@
@EUUUUUUUUUUUUU @%UUUUUUUUUUUUUPBUUUUUUUUUUUUUU@@UUUUUUUUUUUUUT@@EUUUUUUUUUUUUP@@EUUUUUUUUUUUU@I AUUUUUUUUUUUT@EPAUUUUUU
UUUUUP@UT@UUUUUUUUUUV@AUV@UUUUUUUUUUT@EUU EUUUUUUUUU@@UUUXIUUUUUUUUT@IUUUTAUUUUUUUUP@EUUUUBUUUUUUUT@@UUUUU %UUUUUUP@AUUU
UUPEUUUUUU@@EUUUUUTIUUUUUU@@EUUUUUUAUUUUUU@@UUUUUUUPUUUUUUPAUUUUUUUTUUUUUUUUUUUUUUUUEUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU') ; colorMapFromArray:#[0 204 51 25 25 25 0 112 21]; yourself]
!

stxIconTransparent
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stxIconTransparent inspect
     ImageEditor openOnClass:self andSelector:#stxIconTransparent
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Icon class stxIconTransparent'
        ifAbsentPut:[(Depth2Image width:48 height:48) bits:(ByteArray fromPackedString:'
UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU@UUUUUUUTEUUUUUT@EUUUUUUPUUUUUUT@EU
UUUUUAUUUUUUT@EUUUUUXEUUUUUUT@IUUUUU %UUUUUUT@IUUUUVBUUUUUUUU@AUUUUXIUUUUUUUU@AUUUU EUUUUUUUUPBUUUV@UUUUUUUUUP@UUUTBUUUU
UUUUUT@EUUPIUUUUUUUUUT@EUU@EUUUUUUUUUU@AUT@UUUUUUUUUUUP@UPAUUUUUUUUUUUP@U@EUUUUUUUUUUUT@D@UUUUUUUUUUUUT@@AUUUUUUUUUUUUU@
@EUUUUUUUUUUUUU@@%UUUUUUUUUUUUUPBUUUUUUUUUUUUUU@@UUUUUUUUUUUUUT@@%UUUUUUUUUUUUP@@EUUUUUUUUUUUU@A@IUUUUUUUUUUUT@EPAUUUUUU
UUUUUP@UT@UUUUUUUUUUV@AUT@UUUUUUUUUUX@EUU@EUUUUUUUUU @UUUPAUUUUUUUUT@AUUUTAUUUUUUUUP@EUUUV@UUUUUUUT@@UUUUU@%UUUUUUP@AUUU
UUPEUUUUUU@@EUUUUUTAUUUUUU@@%UUUUUUAUUUUUU@BUUUUUUUPUUUUUUPIUUUUUUUT%UUUUUUUUUUUUUUUEUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU') colorMapFromArray:#[0 204 51 25 25 25 127 229 153 0 0 0] mask:((ImageMask width:48 height:48) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G@@@A @@O @@C@@@O @@F@@@O @@\@@@O0@@<@@@O0@A8@@@G0@C0@@@G0@G @@@C8@O@@@@C8@O@@
@@A<@^@@@@A<@<@@@@@>A8@@@@@_C0@@@@@_G @@@@@O/@@@@@@O>@@@@@@G<@@@@@@G<@@@@@@C8@@@@@@G8@@@@@@O<@@@@@@_<@@@@@@>>@@@@@A<^@@@
@@C8O@@@@@O0O@@@@@_ G @@@@?@C0@@@A>@A0@@@C<@A8@@@O8@@<@@@_0@@\@@@? @@N@@@? @@F@@@?@@@C@@@^@@@A @@@@@@@ @@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@'); yourself); yourself]

    "Modified: / 30-01-2017 / 19:20:10 / stefan"
!

stxIconTransparent2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stxIconTransparent2 inspect
     ImageEditor openOnClass:self andSelector:#stxIconTransparent2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Icon class stxIconTransparent2'
        ifAbsentPut:[(Depth2Image width:48 height:48) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@D@@@@@@@@@D@@@@@PP@@@@@@@@@@@@@AA@@@@@@@@@@@@@@@D@@@@@@@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D@P@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@A@D@@@@@@@@@@@@@@@@@@A@@@@@@@@@@@@A@@D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P@@@@@@@@@@@@@A@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@P@P@@@@@@@@@@@@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DP@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@A@@@A@@@@@@@@@@@D@@@@P@@@@@@@@@@@@@@@DD@@@@@@@@@@D@@@@@@@@@@@@@@@@@@@@A@@@@@@@@@@@@@@@PP@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') colorMapFromArray:#[0 204 51 127 229 153 0 0 0] mask:((ImageMask width:48 height:48) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G@@@A @@O @@C@@@O @@F@@@O @@\@@@O0@@<@@@O0@A8@@@G0@A0@@@G8@C @@@C8@G@@@@C<@N@@
@@A<@\@@@@A>@8@@@@@>A8@@@@@_C0@@@@@_G @@@@@O/@@@@@@O>@@@@@@G<@@@@@@G<@@@@@@C8@@@@@@G8@@@@@@O<@@@@@@_<@@@@@@>>@@@@@A<^@@@
@@C8O@@@@@O0O@@@@@_ G @@@@?@C0@@@A>@A0@@@C<@@8@@@O8@@<@@@_0@@\@@@? @@N@@@? @@F@@@?@@@C@@@^@@@A@@@@@@@@ @@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@'); yourself); yourself]

    "Modified: / 30-01-2017 / 19:20:19 / stefan"
!

stxIconTransparent3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stxIconTransparent3 inspect
     ImageEditor openOnClass:self andSelector:#stxIconTransparent3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Icon class stxIconTransparent3'
        ifAbsentPut:[(Depth2Image width:48 height:48) bits:(ByteArray fromPackedString:'
UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
UUUUUUUUUUUUUUUUUUUUQUUUUUUUUUQUUUUUEEUUUUUUUUUUUUUTTUUUUUUUUUUUUUUUQUUUUUUUUUTUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUQUEUUUUUUUU
UUUUUUUUUUUUUUUUUUUUUTUQUUUUUUUUUUUUUUUUUUTUUUUUUUUUUUUTUUQUUUUUUUUUUUUUUUUUUUUUUUUUUUUUEUUUUUUUUUUUUUTUUUUUUUUUUUUUUUUU
UUUUUUUUUUUUUUUEUEUUUUUUUUUUUUUUTUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUQEUUUUUUUUUUUUUUUUUUUUUUU
UUUUUUUUUUUUUUUUUUUUTUUUTUUUUUUUUUUUQUUUUEUUUUUUUUUUUUUUUQQUUUUUUUUUUQUUUUUUUUUUUUUUUUUUUUTUUUUUUUUUUUUUUUEEUUUUUUUUUUUU
UUUUUUUUUUUUUUUUUUUQUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU') colorMapFromArray:#[0 102 26 0 204 51 0 0 0] mask:((ImageMask width:48 height:48) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G@@@A @@O @@C@@@O @@F@@@O @@\@@@O0@@<@@@O0@A8@@@G0@A0@@@G8@C @@@C8@G@@@@C<@N@@
@@A<@\@@@@A>@8@@@@@>A8@@@@@_C0@@@@@_G @@@@@O/@@@@@@O>@@@@@@G<@@@@@@G<@@@@@@C8@@@@@@G8@@@@@@O<@@@@@@_<@@@@@@>>@@@@@A<^@@@
@@C8O@@@@@O0O@@@@@_ G @@@@?@C0@@@A>@A0@@@C<@@8@@@O8@@<@@@_0@@\@@@? @@N@@@? @@F@@@?@@@C@@@^@@@A@@@@@@@@ @@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@'); yourself); yourself]

    "Modified: / 30-01-2017 / 19:20:28 / stefan"
! !

!Icon class methodsFor:'obsolete image specs'!

backwardIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary backward22x22_3DIcon
!

copyIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary copy22x22Icon
!

cutIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary cut22x22Icon
!

deleteIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary delete22x22Icon
!

downIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary down22x22Icon
!

downRightIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary downRight22x22Icon
!

forwardIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary forward22x22_3DIcon
!

helpIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary help22x22Icon
!

leftDownIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary leftDown22x22Icon
!

leftIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary left22x22Icon
!

loadIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary load22x22Icon
!

newIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary new22x22Icon
!

pasteIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary paste22x22Icon
!

rightIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary right22x22Icon
!

saveIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary save22x22Icon
!

startIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary start22x22Icon
!

upIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary up22x22Icon
!

upRightIcon
    <resource: #obsolete>
    "Obsolete - please goto ToolbarIconLibrary directly"
    ^ ToolbarIconLibrary upRight22x22Icon
! !

!Icon class methodsFor:'startup & release'!

flushCachedIcons
    KnownIcons removeAll

    "
     Icon flushCachedIcons
    "
!

preSnapshot
    "flush cached icons contents before saving a snapshot
     (do not save them in the image)"
    
    self flushCachedIcons
!

releaseCachedIconsFromDevice:aGraphicsDevice 
    KnownIcons do:[:eachImage | 
        eachImage graphicsDevice == aGraphicsDevice ifTrue:[
            eachImage release.
        ]
    ].

    "
     Icon releaseCachedIconsFromDevice:Display
    "
! !

!Icon class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Icon initialize!
