"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

Object subclass:#MethodCategoryCache
	instanceVariableNames:'cachedMethodCategories lock'
	classVariableNames:'TheOneAndOnlyCache'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!MethodCategoryCache class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!MethodCategoryCache class methodsFor:'instance creation'!

new
    TheOneAndOnlyCache isNil ifTrue:[
        TheOneAndOnlyCache := self basicNew initialize.
    ].
    ^ TheOneAndOnlyCache
! !

!MethodCategoryCache methodsFor:'accessing'!

allMethodCategories
    cachedMethodCategories isNil ifTrue:[
        self updateCachedMethodCategories
    ].
    ^ cachedMethodCategories
!

updateCachedMethodCategories
    lock critical:[
        cachedMethodCategories := Set new.
        Smalltalk allBehaviorsDo:[:eachClass |
            cachedMethodCategories addAll:eachClass categories 
        ].
    ].
! !

!MethodCategoryCache methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    |removed|

    changedObject == Smalltalk ifTrue:[
        something == #methodInClassRemoved ifTrue:[
            cachedMethodCategories := nil.
            ^ self.
        ].
        (something == #classOrganization) ifTrue:[
            cachedMethodCategories := nil.
            ^ self.
        ].
        (something == #methodCategoryAdded) ifTrue:[
            cachedMethodCategories notNil ifTrue:[
                cachedMethodCategories add:(aParameter second).
            ].
            ^ self.
        ].
        (something == #methodCategoryRemoved) ifTrue:[
            cachedMethodCategories := nil.
            ^ self.
        ].
        (something == #methodCategoriesRemoved) ifTrue:[
            cachedMethodCategories := nil.
"/            removed := aParameter second asSet.
"/            Smalltalk allMethodsDo:[:m |
"/                |mCat|
"/                mCat := m category.
"/                (removed includes:mCat) ifTrue:[
"/                    removed remove:mCat.
"/                    removed isEmpty ifTrue:[^ self ].
"/                ].
"/            ].
"/            cachedMethodCategories removeAll:removed.
            ^ self.
        ].
        (something == #methodCategoryRenamed) ifTrue:[
            cachedMethodCategories := nil.
            ^ self.
        ].
        something == #methodInClass ifTrue:[
            ^ self.
        ].
        ^ self.
    ].
    super update:something with:aParameter from:changedObject
! !

!MethodCategoryCache methodsFor:'initialization'!

initialize
    lock := Semaphore forMutualExclusion.
    Smalltalk addDependent:self.
! !

!MethodCategoryCache class methodsFor:'documentation'!

version_CVS
    ^ '§Header: /cvs/stx/stx/libtool/Tools__MethodCategoryCache.st,v 1.4 2011/07/03 13:33:26 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__MethodCategoryCache.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

