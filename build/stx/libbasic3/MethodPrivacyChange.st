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
"{ Package: 'stx:libbasic3' }"

MethodChange subclass:#MethodPrivacyChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!MethodPrivacyChange class methodsFor:'documentation'!

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
    instances represent method-privacy changes (as done in the browser). 
    They are typically held in a ChangeSet.

    [author:]
        Claus Gittinger
"
! !

!MethodPrivacyChange class methodsFor:'instance creation'!

class:cls selector:selector privacy:privacy 
    ^ self basicNew class:cls selector:selector privacy:privacy

    "Modified: 27.8.1995 / 22:55:42 / claus"
!

className:aString selector:selector privacy:privacy 
    ^ self basicNew className:aString selector:selector privacy:privacy
! !

!MethodPrivacyChange methodsFor:'accessing'!

class:cls selector:sel privacy:p
    className := cls name.
    privacy := p.
    selector := sel

    "Modified: 27.8.1995 / 22:56:03 / claus"
!

className:clsName selector:sel privacy:p
    className := clsName.
    privacy := p.
    selector := sel

    "Modified: / 27.8.1995 / 22:56:03 / claus"
    "Created: / 16.2.1998 / 14:25:39 / cg"
!

source
    ^ self sourceForMethod , ' privacy:' , privacy storeString

    "Modified: / 27-08-1995 / 22:56:58 / claus"
    "Modified: / 09-10-2006 / 13:59:35 / cg"
! !

!MethodPrivacyChange methodsFor:'testing'!

isMethodCodeChange
    "true if this is a method's code change (not package, category etc.)"

    ^ false
! !

!MethodPrivacyChange class methodsFor:'documentation'!

version
    ^ '$Header: MethodPrivacyChange.st 1909 2012-03-31 00:14:49Z vranyj1 $'
!

version_CVS
    ^ '§Header: /cvs/stx/stx/libbasic3/MethodPrivacyChange.st,v 1.11 2010/04/14 13:40:33 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: MethodPrivacyChange.st 1909 2012-03-31 00:14:49Z vranyj1 §'
! !

