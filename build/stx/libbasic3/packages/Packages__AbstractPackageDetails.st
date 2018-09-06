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

AbstractPackageNotebookApplication subclass:#AbstractPackageDetails
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Application'
!

!AbstractPackageDetails class methodsFor:'documentation'!

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

!AbstractPackageDetails methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."
    (self packagesSelectedHolder == changedObject) ifTrue:[
        self packagesSelectedHolderChanged:aParameter
    ].
! !

!AbstractPackageDetails methodsFor:'changes'!

declareDependents
    "assumed that the removeDependents has been called"
    self packagesSelectedHolder addDependent:self.
!

packagesSelectedHolderChanged:packagesSelected 

    self updateWithPackages:packagesSelected
!

removeDependents
    "assumed that the removeDependents has been called"
    self packagesSelectedHolder removeDependent:self.
!

updateWithPackages:packages
    self subclassResponsibility
! !

!AbstractPackageDetails class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/AbstractPackageDetails.st,v 1.3 2006/01/10 09:25:06 cg Exp $'
! !