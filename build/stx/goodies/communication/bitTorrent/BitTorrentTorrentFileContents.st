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

Dictionary subclass:#BitTorrentTorrentFileContents
	instanceVariableNames:'info'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Bittorrent'
!

!BitTorrentTorrentFileContents class methodsFor:'documentation'!

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
    I know about the format and contents of a .torrent file.
    These are bencoded dictionaries, which contain information for sharing
    (such as pieces, SHA hashes etc.)

    Author:
        Claus Gittinger

    See:
        http://wiki.theory.org/BitTorrentSpecification
"
!

examples
"
  mhmh - I was googling for 'torrent example', and got that one.
  (not that I want to promote any illegal downloading of any copyright material... ;-)

     |torrent|

     torrent := self fromURL:'http://torrents.thepiratebay.org/5292216/Example_-_What_We_Made.5292216.TPB.torrent'.

     self assert:(torrent encoding = 'UTF-8').
     self assert:(torrent announce = 'http://tracker.thepiratebay.org/announce').
     self assert:(torrent announceList size = 4).
     self assert:(torrent announceList first = #( 'http://tracker.thepiratebay.org/announce') ).
     self assert:(torrent comment = 'Torrent downloaded from http://thepiratebay.org').
     self assert:(torrent createdBy = 'uTorrent/1850').
     'mhmh - the info in pirate says 18:48:53 ?!!?
      where are those 1.8 seconds???'.
     self assert:(torrent creationDate floorSecond = (Timestamp year:2010 month:1 day:19 hour:18 minute:48 second:51 )).
     self assert:(torrent info name = 'What We Made').
     self assert:(torrent info pieces size = 517).
     self assert:(torrent info files size = 13).
     self assert:(torrent info files first length = 6537632).
     self assert:(torrent info files first path = #('04 Birthday Card.mp3')).
     '
      torrent info inspect.
     '.
"
! !

!BitTorrentTorrentFileContents class methodsFor:'instance creation'!

fromString:aBEncodedString
    ^ self new declareAllFrom:(BitTorrentBDecoder bDecode:aBEncodedString).

    "
     self fromURL:'http://torrents.thepiratebay.org/5292216/Example_-_What_We_Made.5292216.TPB.torrent'
    "

"
d
  8:announce
  40:http://tracker.thepiratebay.org/announce
  13:announce-list
    l
        l
            40:http://tracker.thepiratebay.org/announce
        e
        l
            42:udp://tracker.thepiratebay.org:80/announce
        e
        l
            44:udp://tracker.openbittorrent.com:80/announce
        e
        l
            42:http://tracker.openbittorrent.com/announce
        e
    e
  7:comment
  47:Torrent downloaded from http://thepiratebay.org
  10:created by
  13:uTorrent/1850
  13:creation date
  i1263923333e
  8:encoding
  5:UTF-8
  4:info
    d
        5:files
        l
            d
                6:length
                i6537632e
                4:path
                l20:04 Birthday Card.mp3
            e
        e
    d
        6:length
        i5862211e
        4:path
        l
            19:10 Really Sorry.mp3
        e
    e
    d
        6:length
        i5712104e
        4:path
        l
            21:03 Milk Your Goat.mp3
        e
    e
    d
        6:length
        i5477157e
        4:path
        l
            21:05 I Dont Want To.mp3
        e
    e
    d
        6:length
        i5453264e
        4:path
        l
            27:06 Popcorn & Fisticuffs.mp3
        e
    e
    d
        6:length
        i5376821e
        4:path
        l
            30:08 No Sleep For The Wicked.mp3
        e
    e
    d
        6:length
        i5160494e
        4:path
        l
            17:07 Posh Birds.mp3
        e
    e
    d
        6:length
        i5091256e4:pathl19:13 What We Made.mp3ee
    d
        6:lengthi4889064e4:pathl17:09 Me & Mandy.mp3ee
    d
        6:lengthi4750736e4:pathl25:11 Today I Met Myself.mp3ee
    d
        6:lengthi4456096e4:pathl20:02 You Can''t Rap.mp3ee
    d
        6:lengthi4449297e4:pathl20:01 So Many Roads.mp3ee
    d
        6:lengthi4443577e4:pathl15:12 Care 4 U.mp3ee
      e
    4:name
    12:What We Made
    12:piece length
    i131072e
    6:pieces
    10340:...
"

    "Created: / 07-01-2011 / 13:51:36 / cg"
!

fromURL:aURL
    |response contents|

    response := HTTPInterface get:aURL.
    contents := response data asString.
    ^ self fromString:contents

    "
     self fromURL:'http://torrents.thepiratebay.org/5292216/Example_-_What_We_Made.5292216.TPB.torrent'
    "

    "Created: / 07-01-2011 / 13:50:57 / cg"
! !

!BitTorrentTorrentFileContents methodsFor:'accessing'!

announce
    ^ self at:'announce'

    "Created: / 07-01-2011 / 14:26:31 / cg"
!

announceList
    ^ self at:'announce-list'

    "Created: / 07-01-2011 / 14:46:16 / cg"
!

comment
    ^ self at:'comment'

    "Created: / 07-01-2011 / 14:28:41 / cg"
!

createdBy
    ^ self at:'created by'

    "Created: / 07-01-2011 / 14:28:59 / cg"
!

creationDate
    "mhmh - creation date is in nanoseconds?"

    ^ Timestamp utcMillisecondsSince1970:(self at:'creation date') // 1000000.

    "Created: / 07-01-2011 / 14:29:21 / cg"
    "Modified: / 08-01-2011 / 16:11:54 / cg"
!

encoding
    ^ self at:'encoding'

    "Created: / 07-01-2011 / 14:28:26 / cg"
!

info
    info isNil ifTrue:[
        info := BitTorrentTorrentInfoRecord new declareAllFrom:(self at:'info')
    ].
    ^ info

    "Created: / 07-01-2011 / 14:41:17 / cg"
    "Modified: / 08-01-2011 / 15:55:44 / cg"
! !

!BitTorrentTorrentFileContents class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/bitTorrent/BitTorrentTorrentFileContents.st,v 1.9 2011-01-09 19:53:20 cg Exp $'
! !
