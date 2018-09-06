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

Object subclass:#AbstractPackageManager
	instanceVariableNames:'packages'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Managers'
!

!AbstractPackageManager class methodsFor:'documentation'!

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

!AbstractPackageManager class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!AbstractPackageManager class methodsFor:'defaults'!

defaultPackages
    ^ Dictionary new.
! !

!AbstractPackageManager class methodsFor:'factory'!

newDefaultPackage
    ^ (self newPackageNamed:(Project noProjectID)) mergeFromImage.
!

newPackageNamed:aString
    ^ self packageClass named:aString
! !

!AbstractPackageManager methodsFor:'accessing'!

packages
    ^ packages
!

packages:something
    "set the value of the instance variable 'packages' (automatically generated)"

    packages := something.
! !

!AbstractPackageManager methodsFor:'api'!

installPackage:aPackage
    "installs aPackage into the image."
    self subclassResponsibility
!

loadPackage:aFilename
    "loads a package ready for installation into the image"
    self subclassResponsibility
!

savePackage:aPackage
    "saves package"
    self subclassResponsibility
!

savePackage:aPackage as:aFilename
    "saves package"
    self subclassResponsibility
!

uninstallPackage:aPackage
    "uninstalls aPackage from the image"
    self subclassResponsibility
!

unloadPackage:aPackage
    "unloads the package from the receiver"
    self subclassResponsibility
! !

!AbstractPackageManager methodsFor:'enumerating'!

packagesDo:aOneArgBlock
    self packagesDo:aOneArgBlock excluding:#().
!

packagesDo:aOneArgBlock excluding:aCollectionOrObject
    "iterate through all packages except for aCollection of packages. Return the receiver.
    also look at #packagesDo: if you dont want to exclude anything"
    (aCollectionOrObject isCollection) ifTrue:[
	self packages do:[:aPackage |
	    (aCollectionOrObject includes:aPackage) ifFalse:[
		aOneArgBlock value:aPackage.
	    ].
	].
	^ self.
    ].

    self packages do:[:aPackage |
	(aCollectionOrObject == aPackage) ifFalse:[
	    aOneArgBlock value:aPackage.
	].
    ].
! !

!AbstractPackageManager methodsFor:'initialization'!

initialize
    packages := self class defaultPackages.
    ChangeSet current addDependent:self.
"/    Smalltalk addDependent:self.
!

uninitialize
    packages := self class defaultPackages.
    ChangeSet current removeDependent:self.
"/    Smalltalk removeDependent:self.
! !

!AbstractPackageManager methodsFor:'queries'!

includesPackage:aPackage
    ^ packages includesKey:aPackage name
!

includesPackageNamed:aPackageName

    ^ packages includesKey:aPackageName
! !

!AbstractPackageManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/AbstractPackageManager.st,v 1.4 2006/08/24 08:39:01 cg Exp $'
! !