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

Dictionary subclass:#BitTorrentTorrentFileRecord
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Bittorrent'
!

!BitTorrentTorrentFileRecord class methodsFor:'documentation'!

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

!BitTorrentTorrentFileRecord methodsFor:'accessing'!

length
    ^ self at:'length'

    "Created: / 07-01-2011 / 14:57:25 / cg"
!

path
    ^ self at:'path'

    "Created: / 07-01-2011 / 14:57:17 / cg"
! !

!BitTorrentTorrentFileRecord class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/bitTorrent/BitTorrentTorrentFileRecord.st,v 1.3 2011-01-08 14:48:36 cg Exp $'
! !
