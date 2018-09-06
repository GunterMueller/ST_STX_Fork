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

ApplicationModel subclass:#AbstractPackageBrowser
	instanceVariableNames:'applicationAspects'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Application'
!

!AbstractPackageBrowser class methodsFor:'documentation'!

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

!AbstractPackageBrowser methodsFor:'accessing'!

applicationAspects
    applicationAspects ifNil:[
        applicationAspects := Dictionary new
    ].
    ^ applicationAspects
!

applicationAspects:something
    "set the value of the instance variable 'applicationAspects' (automatically generated)"

    applicationAspects := something.
!

declareDependents
!

masterApplication:aMasterApplication
    aMasterApplication ifNil:[
        ^ self.
    ].
    
    self applicationAspects: aMasterApplication applicationAspects.
    self declareDependents.
    ^ super masterApplication:aMasterApplication.
!

packagesNamed:aCollectionOfPackageNamesOrSymbol 
    |aCollectionOfPackageNames|
    aCollectionOfPackageNames := aCollectionOfPackageNamesOrSymbol.
    aCollectionOfPackageNames isSymbol ifTrue:[
        aCollectionOfPackageNames := Array with:aCollectionOfPackageNamesOrSymbol.
    ].
    [(aCollectionOfPackageNamesOrSymbol includes:nil)] whileTrue:[
        aCollectionOfPackageNamesOrSymbol remove:nil
    ].
    
    ^ self packageManager packagesNamed:aCollectionOfPackageNames
!

packagesSelected
    ^ self packagesSelectedHolder value
!

undeclareDependents
! !

!AbstractPackageBrowser methodsFor:'accessing - shared'!

applicationAspectsAt:anIdentifier ifAbsent:aBlock
    ^ self applicationAspects at:anIdentifier ifAbsent:aBlock
!

applicationAspectsAt:aSymbol ifAbsentPut:anObject
    ^ self applicationAspects at:aSymbol ifAbsentPut:anObject
!

applicationAspectsAt:anIdentifier put:anObject
    ^ self applicationAspects at:anIdentifier put:anObject
!

packageManager
    ^ self applicationAspectsAt:#packageManager ifAbsent:[nil]
!

packageManager:aPackageManager
    ^ self applicationAspectsAt:#packageManager put:aPackageManager
!

packagesSelectedHolder
    ^ self applicationAspectsAt:#packagesSelectedHolder ifAbsent:[ValueHolder new]
!

packagesSelectedHolder:aPackageManager
    ^ self applicationAspectsAt:#packagesSelectedHolder put:aPackageManager
! !

!AbstractPackageBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/AbstractPackageBrowser.st,v 1.3 2006-01-10 09:25:27 cg Exp $'
! !
