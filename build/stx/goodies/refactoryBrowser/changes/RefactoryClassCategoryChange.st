"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryClassChange subclass:#RefactoryClassCategoryChange
	instanceVariableNames:'category'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RefactoryClassCategoryChange class methodsFor:'instance creation'!

changeCategoryOf:aClass to:newCategory
        ^(self new)
                changeClass: aClass;
                category: newCategory;
                yourself
! !

!RefactoryClassCategoryChange methodsFor:'accessing'!

category
    ^ category
!

category:something
    category := something.
! !

!RefactoryClassCategoryChange methodsFor:'comparing'!

= aClassCategoryChange 
        super = aClassCategoryChange ifFalse: [^false].
        ^ category = aClassCategoryChange category
!

hash
        ^category hash
! !

!RefactoryClassCategoryChange methodsFor:'converting'!

asUndoOperation
    ^ RefactoryClassCategoryChange 
        changeCategoryOf:(self changeClass) to:(self changeClass category)
! !

!RefactoryClassCategoryChange methodsFor:'executing'!

primitiveExecute
    ^ (self changeClass) category: category.
! !

!RefactoryClassCategoryChange methodsFor:'printing'!

changeString
        ^'Change category of %1 to: %2' 
            bindWith:className 
            with:category
!

printOn: aStream 
        aStream
                nextPutAll: self displayClassName;
                nextPutAll: ' category: ';
                nextPutAll: category storeString;
                nextPut: $!!
! !

!RefactoryClassCategoryChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RefactoryClassCategoryChange.st,v 1.3 2004-03-19 14:48:40 cg Exp $'
! !
