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

Error subclass:#PackageError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Exception-Errors'
!

!PackageError class methodsFor:'documentation'!

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

!PackageError class methodsFor:'factory'!

invalidClassMoveError
    "dummy method     "
!

overrideClassError
    "dummy method"
!

removeClassError
    "return another error class am returning self here!!"
! !

!PackageError class methodsFor:'raising'!

raiseAddedClassFailedNamed:aClassName toPackage:newPackage
    ^ (self new) 
            errorString:'Cannot add ', aClassName, ' to package named: ',newPackage name, ' as it includes
            a class with the same name!!';
            raise.
!

raiseCannotAddAsPackageManagerAlreadyIncludesPackageNamed:aString
    ^ (self new) 
            errorString:'Cannot add as packageManager already includes package named ', aString;
            raise.
!

raiseCannotMoveClassNamed:aClassName toPackage:newOwnerPackage
    ^ (self new) 
            errorString:'Cannot move class named ', aClassName asString, ' from package ', newOwnerPackage name;
            raise.
!

raiseCannotRemoveClassNamed:aSymbol fromPackage:aPackage
    ^ (self new) 
            errorString:'Cannot removeClassNamed ', aSymbol asString, ' from package ', aPackage name;
            raise.
!

raiseCannotRemoveClassNamed:aClassName fromPackage:aPackage inContext:aContext

    ^ (self removeClassError new) 
            errorString:'Cannot remove packagedClass ', aClassName asString,
                ' from package: ';
"/            fromPackage:aPackage;
"/            context:aContext;
            raise.
!

raiseInvalidClassMove:aClass fromPackage:oldOwnerPackage toPackage:newOwnerPackage

    ^ (self invalidClassMoveError new) 
            errorString:'Cannot move packagedClass ', aClass name asString;
            raise.
!

raiseWithOverrideClassErrorClassNotFound:classBeingOverriddenName fromPackage:aPackage
    ^ (self removeClassError new) 
            errorString:'Class not found  ', classBeingOverriddenName  asString,
                ' from package: ' , aPackage name;
"/            fromPackage:aPackage;
"/            context:aContext;
            raise.
!

raiseWithOverrideMethodErrorMethodNotFound:methodBeingOverridden fromPackage:aPackage
    ^ (self new) raise.
! !

!PackageError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/PackageError.st,v 1.4 2006/01/10 09:29:56 cg Exp $'
! !