"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication/bitTorrent' }"

Stream subclass:#BitTorrentBDecoder
	instanceVariableNames:'stream'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Bittorrent'
!

!BitTorrentBDecoder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    I read data in the bEncode format, as used by bittorrent.
    Bencode is the encoding used by file sharing system BitTorrent. 
    Torrent files are simply Bencoded dictionaries. 

    See:
        http://wiki.theory.org/BitTorrentSpecification
        http://wiki.theory.org/Decoding_bencoded_data_with_python
"
!

examples
"
                                                                        [exBegin]
     |s o|

     #(
        ('i12345e'          12345               )
        ('4:abcd'           'abcd'              )
        ('li1ei2ei3ee'      #(1 2 3)            )
        ('l4:spam4:eggse'   #('spam' 'eggs')    )
     ) do:[:pair |
        s := pair first .
        o := BitTorrentBDecoder bDecode:s.
        self assert:(o = pair second).
     ].
     s := 'di1e3:onei2e3:twoi3e5:threee'.
     o := BitTorrentBDecoder bDecode:s.
     self assert:(o class == Dictionary).
     self assert:(o keys = #(1 2 3) asSet).
     self assert:(o at:1) = 'one'.
     self assert:(o at:2) = 'two'.
     self assert:(o at:3) = 'three'.
                                                                        [exEnd]
"
! !

!BitTorrentBDecoder class methodsFor:'instance creation'!

on: aStream
    ^ self basicNew stream: aStream

    "Created: / 07-01-2011 / 12:42:24 / cg"
! !

!BitTorrentBDecoder class methodsFor:'encoding & decoding'!

bDecode:string
    "decode the bencoded string to an object."

    ^ (self on:string readStream) nextObject

    "Created: / 07-01-2011 / 12:40:28 / cg"
! !

!BitTorrentBDecoder methodsFor:'private'!

stream:something
    stream := something.
! !

!BitTorrentBDecoder methodsFor:'reading'!

nextDictionary
    |dict|

    stream next.    "/ skip leading $d
    dict := Dictionary new.
    [
        |key value|

        stream peek == $e ifTrue:[stream next. ^ dict].
        key := self nextObject.
        value := self nextObject.
        dict at:key put:value
    ] loop.

    "Created: / 07-01-2011 / 13:00:50 / cg"
    "Modified: / 08-01-2011 / 15:52:20 / cg"
!

nextInteger
    |val|

    stream next.    "/ skip leading $i
    val := stream nextDecimalInteger.
    self assert:(stream next == $e).
    ^ val

    "Created: / 07-01-2011 / 12:56:49 / cg"
    "Modified: / 08-01-2011 / 15:52:29 / cg"
!

nextList
    |list|

    stream next.    "/ skip leading $l
    list := OrderedCollection new.
    [
        stream peek == $e ifTrue:[stream next. ^ list asArray].
        list add:(self nextObject).
    ] loop.

    "Created: / 07-01-2011 / 12:58:51 / cg"
    "Modified: / 08-01-2011 / 15:52:35 / cg"
!

nextObject
    |ch|

    ch := stream peek.
    ch == $i ifTrue:[^ self nextInteger].
    ch == $l ifTrue:[^ self nextList].
    ch == $d ifTrue:[^ self nextDictionary].
    ^ self nextString

    "Created: / 07-01-2011 / 12:55:34 / cg"
!

nextString
    |len|

    self assert:(stream peek isDigit).
    len := stream nextDecimalInteger.
    self assert:(stream next == $:).
    ^ stream next:len

    "Created: / 07-01-2011 / 12:57:45 / cg"
! !

!BitTorrentBDecoder class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/bitTorrent/BitTorrentBDecoder.st,v 1.5 2011-01-08 14:55:06 cg Exp $'
! !
