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

ObjectCoder subclass:#BitTorrentBEncoder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Bittorrent'
!

!BitTorrentBEncoder class methodsFor:'documentation'!

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
    I encode a limited subset of smalltalk object types into the bittorrent bEncoded representation.

    Allowed are:
        strings,
        integers
        Arrays / OrderedCollections,
        Dictionaries.

    Everything else is not representable. I do handle some limited recursive data structures.

    Author:
        Claus Gittinger

    See:
        http://wiki.theory.org/BitTorrentSpecification
"
!

examples
"
     |s o|

     #(
        (12345              'i12345e'           )
        ('abcd'             '4:abcd'            )
        (#(1 2 3)           'li1ei2ei3ee'       )
        (#('spam' 'eggs')   'l4:spam4:eggse'    )
     ) do:[:pair |
        o := pair first .
        s := BitTorrentBEncoder bEncode:o.
        self assert:(s = pair second).
     ].
     o := Dictionary new
            at:1 put:'one';
            at:2 put:'two';
            at:3 put:'three';
            yourself.
     s := BitTorrentBEncoder bEncode:o.
     self assert:(s = 'di1e3:onei2e3:twoi3e5:threee').
"
! !

!BitTorrentBEncoder class methodsFor:'encoding'!

bEncode: anObject
    "return a bittorrent bencoded string which represents the object"

    |encoder|

    encoder := self on:(String writeStreamWithInitialSize:100).
    anObject acceptVisitor:encoder.
    ^ encoder contents.

    "Created: / 07-01-2011 / 13:09:24 / cg"
    "Modified: / 09-01-2011 / 11:08:49 / cg"
! !

!BitTorrentBEncoder methodsFor:'visiting'!

visitDictionary:aDictionary with:aParameter
    stream nextPut: $d.
    aDictionary keysAndValuesDo: [:key :val |
       key acceptVisitor:self with:aParameter.
       val acceptVisitor:self with:aParameter.
    ].
    stream nextPut: $e.

    "Modified: / 07-01-2011 / 13:12:36 / cg"
!

visitInteger:anInteger with:aParameter
    stream nextPut:$i.
    anInteger printOn: stream.
    stream nextPut:$e.

    "Created: / 27-08-2007 / 11:30:10 / cg"
    "Modified: / 07-01-2011 / 13:11:57 / cg"
!

visitSequenceableCollection:aCollection with:aParameter
    stream nextPut:$l.
    aCollection do:[:val | val acceptVisitor:self with:aParameter].
    stream nextPut:$e.

    "Modified: / 07-01-2011 / 13:11:33 / cg"
!

visitString:aString with:aParameter
    aString size printOn:stream.
    stream nextPut:$:.
    stream nextPutAll:aString.

    "Modified: / 07-01-2011 / 13:13:37 / cg"
! !

!BitTorrentBEncoder class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/bitTorrent/BitTorrentBEncoder.st,v 1.5 2011-01-09 12:14:09 cg Exp $'
! !
