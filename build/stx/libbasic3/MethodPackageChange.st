"
 COPYRIGHT (c) 2006 by eXept Software AG
               All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

MethodChange subclass:#MethodPackageChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!MethodPackageChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    instances represent method-package changes (as done in the browser). 
    They are typically held in a ChangeSet.

    [author:]
        Claus Gittinger
"
! !

!MethodPackageChange class methodsFor:'instance creation'!

class:cls selector:sel package:pkg 
    ^ self basicNew class:cls selector:sel package:pkg

    "Created: / 09-10-2006 / 14:00:22 / cg"
! !

!MethodPackageChange methodsFor:'accessing'!

class:cls selector:sel package:pkg
    className := cls name.
    selector := sel.
    package := pkg

    "Created: / 09-10-2006 / 13:56:20 / cg"
!

className:clsName selector:sel package:pkg
    className := clsName.
    selector := sel.
    package := pkg

    "Created: / 09-10-2006 / 13:56:35 / cg"
!

prettyPrintedSource
    ^ self sourceForMethod , Character cr 
      , '    package:' , package storeString

    "Modified: / 09-10-2006 / 13:58:52 / cg"
!

source
    ^ self sourceForMethod, ' package:' , package storeString

    "Modified: / 09-10-2006 / 13:58:36 / cg"
! !

!MethodPackageChange methodsFor:'applying'!

apply
    "apply the change"

    |mthd|

    mthd := self changeMethod.
    mthd package:package.

    "Modified: / 23-11-2006 / 17:01:37 / cg"
! !

!MethodPackageChange methodsFor:'testing'!

isMethodCodeChange
    "true if this is a method's code change (not package, category etc.)"

    ^ false
!

isMethodPackageChange
    ^ true

    "Created: / 09-10-2006 / 14:00:58 / cg"
! !

!MethodPackageChange class methodsFor:'documentation'!

version
    ^ '$Header: MethodPackageChange.st 1909 2012-03-31 00:14:49Z vranyj1 $'
!

version_CVS
    ^ '§Header: /cvs/stx/stx/libbasic3/MethodPackageChange.st,v 1.4 2010/04/14 13:40:49 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: MethodPackageChange.st 1909 2012-03-31 00:14:49Z vranyj1 §'
! !

