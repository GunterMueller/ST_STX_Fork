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

ImageReader subclass:#BlitImageReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!BlitImageReader class methodsFor:'documentation'!

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
    A q&d hack to read 48x48x1 Blit images (faces)
    A variation of this format is also used to pass face-icons in mail headers
    (X-face: header line).
    To support those, images can also be read from a string which is
    encoded in that format (see: #fromCompressedString:).

    [See also:]
        Image Form Icon
        GIFReader FaceReader JPEGReader PBMReader PCXReader 
        ST80FormReader SunRasterReader TargaReader TIFFReader WindowsIconReader 
        XBMReader XPMReader XWDReader 
"
!

examples
"
    Image fromFile:'.../.../48x48x1'
"
! !

!BlitImageReader class methodsFor:'initialization'!

initialize
    "install myself in the Image classes fileFormat table
     for files named `48x48x1' (funny)."

    MIMETypes defineImageType:nil "'image/x-blitImage'" suffix:'48x48x1' reader:self

    "
     BlitImageReader initialize
    "

    "Modified: 1.2.1997 / 15:01:08 / cg"
! !

!BlitImageReader class methodsFor:'special formats'!

fromCompressedString:aString
    "given a compressed image string (such as present in mail headers),
     return a Depth1Image for it.
     Since I am not willing to port/include the uncompface stuff into ST/X,
     open a pipe to the uncompressor.
     If you dont have compface/uncompface, get it from your nearest ftp server."

    |s|

    s := self uncompressString:aString.
    ^ self fromStream:(s readStream).

    "   
     |s|

     s := '
Iqsa(US9p?)Y^W
+6Ff[Z]<t?\A!!eaL''DG{20*#{C1;''Ct&}L}B^/1(aYI@hP)4!!<}7D=2gm
8!!$T`8QNfK<te\20%A\`wm*wa2' , Character doubleQuote asString , '^Up*Qs' , Character doubleQuote asString ,
'X}KeV*3XeB2te&sKp*t`N;^BDh[6=K{ZBE=O>rM' , Character doubleQuote asString , 'uFE)
lFDjag1e]\/#2'.
    BlitImageReader fromCompressedString:s
    "

    "Created: 9.11.1995 / 17:55:19 / cg"
    "Modified: 9.11.1995 / 17:56:07 / cg"
!

uncompressString:aString
    "given a compressed string (as present in mail-headers),
     return a string in 48x48x1 BlitImage fromat.
     Since I am not willing to port/include the uncompface stuff into ST/X,
     open a pipe to the uncompressor.
     If you dont have compface/uncompface, get it from your nearest ftp server."

    |f s str|

    f := Filename newTemporary.
    s := f writeStream.
    s nextPutAll:aString.
    s close.

    s := PipeStream readingFrom:('uncompface ' , f name).
    s isNil ifTrue:[
	'BLITIMGREADER: no uncompface utility.' errorPrintNL.
	f delete.
	^ nil
    ].

    str := s contents asString.
    s close.
    f delete.
    ^ str

    "   
     |s|

     s := '
Iqsa(US9p?)Y^W
+6Ff[Z]<t?\A!!eaL''DG{20*#{C1;''Ct&}L}B^/1(aYI@hP)4!!<}7D=2gm
8!!$T`8QNfK<te\20%A\`wm*wa2' , Character doubleQuote asString , '^Up*Qs' , Character doubleQuote asString ,
'X}KeV*3XeB2te&sKp*t`N;^BDh[6=K{ZBE=O>rM' , Character doubleQuote asString , 'uFE)
lFDjag1e]\/#2'.
    BlitImageReader uncompressString:s
    "

    "Created: 9.11.1995 / 17:55:19 / cg"
    "Modified: 21.11.1995 / 19:28:41 / cg"
! !

!BlitImageReader class methodsFor:'testing'!

isValidImageFile:aFileName
    "return true, if aFileName contains a BlitImage image"

    ^ aFileName = '48x48x1'

    "Created: 9.11.1995 / 17:04:29 / cg"
    "Modified: 23.4.1996 / 12:48:01 / cg"
! !

!BlitImageReader methodsFor:'reading'!

fromStream:aStream
    "read an image in my format from aStream"

    |line 
     dstIndex "{ Class: SmallInteger }"
     bytesPerRow words|

    width := height := 48.
    self reportDimension.
    bytesPerRow := width // 8.

    data := ByteArray new:(bytesPerRow * height).
    dstIndex := 1.

    [aStream atEnd] whileFalse:[
        line := aStream nextLine.
        line notNil ifTrue:[
            words := (line asCollectionOfSubstringsSeparatedBy:$,) asOrderedCollection.
            words last isEmpty ifTrue:[
                words removeLast
            ].
            words do:[:w |
                |s bits|

                s := w readStream.
                s skip:2.
                bits := Integer readFrom:s radix:16 onError:0. 
                data at:dstIndex put:(bits bitShift:-8).
                data at:dstIndex+1 put:(bits bitAnd:16rFF).
                dstIndex := dstIndex + 2
            ]
        ]
    ].


    photometric := #whiteIs0.
    samplesPerPixel := 1.
    bitsPerSample := #(1)

    "
     BlitImageReader fromFile:'/tmp/faces/facedir/facedir/misc./acsnet/48x48x1'
    "

    "Created: 9.11.1995 / 17:03:04 / cg"
    "Modified: 23.4.1996 / 12:48:15 / cg"
! !

!BlitImageReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/BlitImageReader.st,v 1.16 2003-11-19 15:28:36 cg Exp $'
! !


BlitImageReader initialize!
