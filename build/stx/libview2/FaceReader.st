"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

ImageReader subclass:#FaceReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!FaceReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    This class knows how to read face files.
    This format is used for people's faces - which can be obtained from some
     ftp-servers, to improve mail- and/or newsreaders :-).
    Other than above, that format is not used often.

    The file format is (ascii):
        ...
        FirstName: ...
        LastName: ...
        E-mail: ...
        PicData: ...
        Image: <width> <height> <depth>

        bits; encoded in uppercase hex ascii; 2 chars/pixel
        pixel values are greyscale-value; 0..255

    Only 8-bit greyscale is supported 
    - I have never encountered any other face-file-format.

    Only file reading is supported.


    Notice: 
        Face files come in two formats: the first is the one implemented here,
        the other is the blitImage file format, which only supports 48x48x1 images.
        The latter is supported by the BlitImageReader class.

    [See also:]
        Image Form Icon
        BlitImageReader GIFReader JPEGReader PBMReader PCXReader 
        ST80FormReader SunRasterReader TargaReader TIFFReader WindowsIconReader 
        XBMReader XPMReader XWDReader 
"
! !

!FaceReader class methodsFor:'initialization'!

initialize
    "install myself in the Image classes fileFormat table
     for the `.face' extension."

    MIMETypes defineImageType:nil suffix:'face' reader:self

    "Modified: 1.2.1997 / 15:01:25 / cg"
! !

!FaceReader methodsFor:'reading'!

readImage
    "read an image in my format from my inStream"

    |line 
     dstIndex "{ Class: SmallInteger }"
     bytesPerRow
     lo       "{ Class: SmallInteger }"
     hi       "{ Class: SmallInteger }"
     val      "{ Class: SmallInteger }"
     inHeader s depth|

    line := inStream nextLine.
    line isNil ifTrue:[
        ^ self fileFormatError:'short read'.
    ].

    inHeader := true.
    [inHeader] whileTrue:[
        (line startsWith:'Image:') ifTrue:[
            s := ReadStream on:line.
            s skip:6.
            width := Number readFrom:s.
            height := Number readFrom:s.
            depth := Number readFrom:s.
            inHeader := false.
        ].
        line := inStream nextLine
    ].

    depth == 8 ifFalse:[
        ^ self fileFormatError:'only depth 8 supported'.
    ].

    self reportDimension.

    [line isEmpty] whileTrue:[
        line := inStream nextLine.
    ].

    bytesPerRow := width * depth // 8.
    ((width * depth \\ 8) ~~ 0) ifTrue:[
        bytesPerRow := bytesPerRow + 1
    ].

    data := ByteArray uninitializedNew:(bytesPerRow * height).
    dstIndex := data size.

    [line notNil] whileTrue:[
        1 to:(line size) by:2 do:[:cI |
            hi := (line at:cI) digitValue.
            lo := (line at:(cI + 1)) digitValue.
            val := (hi bitShift:4) bitOr:lo.
            data at:dstIndex put:val.
            dstIndex := dstIndex - 1
        ].
        line := inStream nextLine
    ].
    photometric := #blackIs0.
    samplesPerPixel := 1.
    bitsPerSample := #(8)

    "
     FaceReader fromFile:'../goodies/faces/next.com/steve.face'
    "
    "this is NOT steve jobs :-)"

    "Modified: / 3.2.1998 / 17:50:52 / cg"
! !

!FaceReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/FaceReader.st,v 1.30 2003-11-19 15:28:06 cg Exp $'
! !


FaceReader initialize!
