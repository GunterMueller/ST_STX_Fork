'From Smalltalk/X, Version:3.1.9 on 9-sep-1997 at 11:55:53 pm'                  !

Filename subclass:#MacFilename
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Mac'
!

!MacFilename class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    Filenames in macOS.
"
! !

!MacFilename class methodsFor:'queries'!

isCaseSensitive
    "return true, if filenames are case sensitive."

    ^ false
!

separator
    "return the file/directory separator."

     ^ $:

     "
      Filename concreteClass separator  
     "

    "Modified: 8.9.1997 / 00:18:03 / cg"
! !

!MacFilename methodsFor:'queries'!

isExplicitRelative
    "return true, if this name is an explicit relative name
     (i.e. starts with './' or '../', to avoid path-prepending)"

    (nameString startsWith:':') ifTrue:[
	^ true
    ].
    ^ false
! !

!MacFilename class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/MacFilename.st,v 1.1 1997/09/17 17:43:58 cg Exp $'
! !



