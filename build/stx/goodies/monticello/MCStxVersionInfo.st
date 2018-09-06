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
"{ Package: 'stx:goodies/monticello' }"

VersionInfo subclass:#MCStxVersionInfo
	instanceVariableNames:'uuid'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X support'
!

!MCStxVersionInfo class methodsFor:'documentation'!

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
    versionInfo as used in st/x.
    Named as it is, because MCVersionInfo already exists with completely different
    use & semantics.
"
! !

!MCStxVersionInfo class methodsFor:'instance creation'!

fromMCVersionString:aString
    "{ Pragma: +optSpace }"

    |words info t|

    info := self new.

    words := aString asCollectionOfWords.
    info revision:(words first).
    info uuid:(UUID fromString:words second).
    t := (Timestamp readIso8601FormatFrom:(words third)).
    info date:(t asDate).
    info time:(t asTime).
    info user:(words at:4 ifAbsent:'?').
    ^ info

    "Created: / 04-12-2011 / 10:04:30 / cg"
! !

!MCStxVersionInfo methodsFor:'accessing'!

uuid
    ^ uuid
!

uuid:something
    uuid := something.
! !

!MCStxVersionInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStxVersionInfo.st,v 1.2 2012-09-11 21:29:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStxVersionInfo.st,v 1.2 2012-09-11 21:29:20 cg Exp $'
! !
