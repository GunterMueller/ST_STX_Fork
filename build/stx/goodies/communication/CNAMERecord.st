"
 COPYRIGHT (c) 2010 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

DNSRecord subclass:#CNAMERecord
	instanceVariableNames:'cname'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-DNS'
!

!CNAMERecord class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!CNAMERecord class methodsFor:'accessing'!

type
        ^ 5
! !

!CNAMERecord methodsFor:'accessing'!

cname
    ^ cname
! !

!CNAMERecord methodsFor:'printing'!

printOn: aStream
        aStream nextPutAll: name; nextPutAll: ': CNAME '; nextPutAll: cname
! !

!CNAMERecord methodsFor:'reading/writing'!

readFrom: aStream
        super readFrom: aStream.
        aStream skip: 2.
        cname := self class readNameFrom: aStream
! !

!CNAMERecord methodsFor:'testing'!

isCNAMERecord
    ^ true
! !

!CNAMERecord class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/CNAMERecord.st,v 1.3 2017-01-23 23:57:46 cg Exp $'
! !

