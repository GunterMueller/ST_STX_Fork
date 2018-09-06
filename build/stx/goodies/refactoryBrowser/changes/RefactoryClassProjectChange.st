"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryClassChange subclass:#RefactoryClassProjectChange
	instanceVariableNames:'packageID'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RefactoryClassProjectChange class methodsFor:'instance creation'!

changeProjectOf:aClass to:newPackage
        ^(self new)
                changeClass: aClass;
                package: newPackage;
                yourself
! !

!RefactoryClassProjectChange methodsFor:'accessing'!

package
    ^ packageID
!

package:something
    packageID := something.
! !

!RefactoryClassProjectChange methodsFor:'comparing'!

= aMethodCategoryChange 
        super = aMethodCategoryChange ifFalse: [^false].
        ^ packageID = aMethodCategoryChange package
!

hash
        ^packageID hash
! !

!RefactoryClassProjectChange methodsFor:'converting'!

asUndoOperation
    ^ RefactoryClassProjectChange 
        changeProjectOf:(self changeClass) to:(self changeClass package)
! !

!RefactoryClassProjectChange methodsFor:'executing'!

primitiveExecute
        ^ (self changeClass) package: packageID
! !

!RefactoryClassProjectChange methodsFor:'printing'!

changeString
        ^'Change package of %1 to: %2' 
            bindWith:className with:packageID
!

printOn: aStream 
        aStream
                nextPutAll: self displayClassName;
                nextPutAll: ' package: ';
                nextPutAll: packageID storeString;
                nextPut: $!!
! !

!RefactoryClassProjectChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RefactoryClassProjectChange.st,v 1.2 2003-09-23 10:47:23 cg Exp $'
! !
