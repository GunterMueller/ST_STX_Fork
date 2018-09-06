"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryClassChange subclass:#RefactoryMethodProjectChange
	instanceVariableNames:'selector packageID'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RefactoryMethodProjectChange class methodsFor:'instance creation'!

changeProjectOf: aSymbol in: aClass to:newPackage
        ^(self new)
                changeClass: aClass;
                selector: aSymbol;
                package: newPackage;
                yourself
! !

!RefactoryMethodProjectChange methodsFor:'accessing'!

package
    ^ packageID
!

package:something
    packageID := something.
!

selector
    "return the value of the instance variable 'selector' (automatically generated)"

    ^ selector
!

selector:something
    "set the value of the instance variable 'selector' (automatically generated)"

    selector := something.
! !

!RefactoryMethodProjectChange methodsFor:'comparing'!

= aMethodCategoryChange 
        super = aMethodCategoryChange ifFalse: [^false].
        selector = aMethodCategoryChange selector ifFalse: [^false].
        ^ packageID = aMethodCategoryChange package
!

hash
        ^packageID hash bitXor:selector hash
! !

!RefactoryMethodProjectChange methodsFor:'converting'!

asUndoOperation
    |m|

    m := (self changeClass compiledMethodAt:selector).
    ^ RefactoryMethodProjectChange 
        changeProjectOf:selector in:(self changeClass) to:(m package)
! !

!RefactoryMethodProjectChange methodsFor:'executing'!

primitiveExecute
        ^ (self changeClass compiledMethodAt: selector) package: packageID
! !

!RefactoryMethodProjectChange methodsFor:'printing'!

changeString
        ^'Change package of %1 >> %2 to: %3' 
            bindWith:(className contractTo:20) 
            with:(selector contractTo:20)
            with:(packageID contractTo:20)
"/        ^'Change package of #<1s>, to: <2s>' 
"/            expandMacrosWith: selector
"/            with: packageID
!

printOn: aStream 
        aStream
                nextPutAll: '(';
                nextPutAll: self displayClassName;
                nextPutAll: ' compiledMethodAt: ';
                nextPutAll: selector storeString;
                nextPutAll: ' package: ';
                nextPutAll: packageID storeString;
                nextPutAll: ')';
                nextPut: $!!
! !

!RefactoryMethodProjectChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RefactoryMethodProjectChange.st,v 1.3 2003-09-23 10:47:45 cg Exp $'
! !
