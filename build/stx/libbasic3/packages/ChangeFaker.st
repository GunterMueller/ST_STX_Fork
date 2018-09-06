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

Object subclass:#ChangeFaker
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Package-helpers'
!

ClassChange subclass:#ClassPackageChange
	instanceVariableNames:'oldPackageName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeFaker
!

MethodChange subclass:#MethodPackageChange
	instanceVariableNames:'oldPackageName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeFaker
!

!ChangeFaker class methodsFor:'documentation'!

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

!ChangeFaker class methodsFor:'initialization'!

initialize
"/    Smalltalk addDependent:self.
!

update:something with:aParameter from:changedObject
    | oldPackageName movedClass methodOwnedClass oldMethod|
    (something == #projectOrganization) ifTrue:[
        aParameter ifNil:[
            "no need to know about this. It has probably already been past here already!!"
            ^ self
        ].

        aParameter size == 1 ifTrue:[
            Transcript 
                    nextPutAll:'From PackageManager>>update:with:from:' ; 
                    cr;
                    nextPutAll:'When does this happen' ; 
                    cr.
                    "checking out changedObject = Smalltalk"

            ^ self.
        ].

        aParameter size == 2 ifTrue:[
               oldPackageName := aParameter second.
               movedClass := aParameter first.
               (oldPackageName isSymbol) ifTrue:[
               
               self classMovePackageChangeWithClass:movedClass
                    oldPackageName:oldPackageName.

            ^ self.
            ] ifFalse:[  
                "it is a method move but the change will be called again as 3 parameters
                 it is implemented in two ways. One by NewSystemBrowser>>moveMethods:toProject:
                 and  Method>>package i only care for the one implemented in method as it gives
                 me the previous package information"
                ^ self
            ].
        ].

        aParameter size == 3 ifTrue:[
                oldMethod := (aParameter second).
                methodOwnedClass := (aParameter first).
                oldPackageName :=  (aParameter third).
                self 
                    methodMovePackageChangeWithMethod:oldMethod      
                    class:methodOwnedClass 
                    oldPackageName:oldPackageName.
                ^ self.
        ].
        self breakPoint:''.
    ].
! !

!ChangeFaker class methodsFor:'accessing'!

changeSet
    ^ ChangeSet current
! !

!ChangeFaker class methodsFor:'faked - changes'!

classMovePackageChangeWithClass:class oldPackageName:oldPackageName 
    | fakedChange |
    fakedChange := ClassPackageChange className:class name oldPackageName:oldPackageName.
    self changeSet changed:#addChange: with:fakedChange.
!

methodMovePackageChangeWithMethod:movedMethod class:methodOwnedClass oldPackageName:oldPackageName
    | fakedChange |
    fakedChange := (MethodPackageChange new) 
            previousVersion:movedMethod;
            className:methodOwnedClass name;
            oldPackageName:oldPackageName.

    self changeSet changed:#addChange: with:fakedChange.
! !

!ChangeFaker::ClassPackageChange class methodsFor:'instance creation'!

className:className oldPackageName:oldPackageName 
    ^ (self basicNew) 
            className:className;
            oldPackageName:oldPackageName;
            package:(Smalltalk classNamed:className) package
! !

!ChangeFaker::ClassPackageChange methodsFor:'accessing'!

oldPackageName
    "return the value of the instance variable 'oldPackageName' (automatically generated)"

    ^ oldPackageName
!

oldPackageName:something
    "set the value of the instance variable 'oldPackageName' (automatically generated)"

    oldPackageName := something.
! !

!ChangeFaker::MethodPackageChange methodsFor:'accessing'!

oldPackageName
    "return the value of the instance variable 'oldPackageName' (automatically generated)"

    ^ oldPackageName
!

oldPackageName:something
    "set the value of the instance variable 'oldPackageName' (automatically generated)"

    oldPackageName := something.
! !

!ChangeFaker class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/ChangeFaker.st,v 1.3 2006-01-10 09:29:32 cg Exp $'
! !

ChangeFaker initialize!
