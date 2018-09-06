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

Dictionary subclass:#BitTorrentTorrentInfoRecord
	instanceVariableNames:'files'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Bittorrent'
!

!BitTorrentTorrentInfoRecord class methodsFor:'documentation'!

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
    A helper substructure of a torrent file

    Author:
        Claus Gittinger

    See:
        http://wiki.theory.org/BitTorrentSpecification
"
! !

!BitTorrentTorrentInfoRecord methodsFor:'accessing'!

files
    files isNil ifTrue:[
        files := (self at:'files') collect:[:each | BitTorrentTorrentFileRecord new declareAllFrom:each]
    ].
    ^ files

    "Created: / 07-01-2011 / 14:56:43 / cg"
    "Modified: / 08-01-2011 / 13:25:53 / cg"
!

name
    ^ self at:'name'

    "Created: / 07-01-2011 / 14:42:15 / cg"
!

pieceHashStringsFromString:aString
    self assert:(aString size \\ 20) == 0.  "/ multiple of 160bits
    ^ (1 to:aString size // 20) 
        collect:[:idx |
            aString copyFrom:((idx-1)*20+1) to:((idx-1+1)*20+1-1)
        ]

    "Created: / 07-01-2011 / 14:45:02 / cg"
    "Modified: / 08-01-2011 / 15:56:15 / cg"
!

pieceLength
    ^ self at:'piece length'

    "Created: / 07-01-2011 / 14:42:36 / cg"
!

pieces
    ^ self pieceHashStringsFromString:(self at:'pieces')

    "Created: / 07-01-2011 / 14:43:18 / cg"
! !

!BitTorrentTorrentInfoRecord class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/bitTorrent/BitTorrentTorrentInfoRecord.st,v 1.5 2011-01-08 14:56:24 cg Exp $'
! !
