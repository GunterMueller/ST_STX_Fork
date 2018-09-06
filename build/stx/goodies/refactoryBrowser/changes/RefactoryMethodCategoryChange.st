"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryClassChange subclass:#RefactoryMethodCategoryChange
	instanceVariableNames:'selector category'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RefactoryMethodCategoryChange class methodsFor:'instance creation'!

changeCategoryOf: aSymbol in: aClass to:newCategory
        ^(self new)
                changeClass: aClass;
                selector: aSymbol;
                category: newCategory;
                yourself
! !

!RefactoryMethodCategoryChange methodsFor:'accessing'!

category
    "return the value of the instance variable 'category' (automatically generated)"

    ^ category
!

category:something
    "set the value of the instance variable 'category' (automatically generated)"

    category := something.
!

selector
    "return the value of the instance variable 'selector' (automatically generated)"

    ^ selector
!

selector:something
    "set the value of the instance variable 'selector' (automatically generated)"

    selector := something.
! !

!RefactoryMethodCategoryChange methodsFor:'comparing'!

= aMethodCategoryChange 
        super = aMethodCategoryChange ifFalse: [^false].
        selector = aMethodCategoryChange selector ifFalse: [^false].
        ^ category = aMethodCategoryChange category
!

hash
        ^category hash bitXor:selector hash
! !

!RefactoryMethodCategoryChange methodsFor:'converting'!

asUndoOperation
    |m|

    m := (self changeClass compiledMethodAt: selector).
    ^ RefactoryMethodCategoryChange 
        changeCategoryOf: selector in: (self changeClass) to:(m category)
! !

!RefactoryMethodCategoryChange methodsFor:'executing'!

primitiveExecute
        ^ (self changeClass compiledMethodAt: selector) category: category
! !

!RefactoryMethodCategoryChange methodsFor:'printing'!

changeString
        ^'Change category of %1 >> %2 to: %3' 
            bindWith:className with:selector with:category
"/        ^'Move #<1s> to <2s>-category' 
"/            expandMacrosWith: selector
"/            with: category
!

printOn: aStream 
        aStream
                nextPutAll: '(';
                nextPutAll: self displayClassName;
                nextPutAll: ' compiledMethodAt: ';
                nextPutAll: selector storeString;
                nextPutAll: ' category: ';
                nextPutAll: category storeString;
                nextPutAll: ')';
                nextPut: $!!
! !

!RefactoryMethodCategoryChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RefactoryMethodCategoryChange.st,v 1.2 2003-09-23 10:45:22 cg Exp $'
! !
