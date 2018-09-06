"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

Object subclass:#PackageHandler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Handlers'
!

!PackageHandler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!PackageHandler class methodsFor:'instance creation'!

forFilename:aFilename
    (self isStxFile:aFilename) ifTrue:[
        ^ StxPackageFileHandler forFilename:aFilename
    ].


    self error:'Unknown file format'
!

forPackage:aPackage

    (self isStxPackage:aPackage) ifTrue:[
        ^ StxPackageFileHandler forPackage:aPackage
    ].

    self error:'Package not known...'
!

openStxPackageFormat:aFormat
    ^ (StxPackageFileHandler) openStxPackageFormat:aFormat
! !

!PackageHandler class methodsFor:'globals'!

smalltalkPackageManager
    ^ PackageManager smalltalkPackageManager  
! !

!PackageHandler class methodsFor:'queries'!

isStxFile:aFilename
    ^ true
!

isStxPackage:aPackage
    ^ true
! !

!PackageHandler class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/PackageHandler.st,v 1.3 2006-01-10 09:32:12 cg Exp $'
! !
