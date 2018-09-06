"
 COPYRIGHT (c) 1998 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SystemOrganizer
	instanceVariableNames:'categoryArray nameSpace'
	classVariableNames:'AllCategories CachedOrganizerForSmalltalk'
	poolDictionaries:''
	category:'Kernel-Support'
!

!SystemOrganizer class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
     In ST80, there is a systemOrganization, which groups classes
     to categories.
     All of this here is mimicri - ST/X keeps the category in the class.
     This class simulates the ST80 behavior.
"
! !

!SystemOrganizer class methodsFor:'instance creation'!

for:aNameSpaceOrNil
    "create & return a new instance of myself, to organize aNameSpace.
     All of this here is mimicri - ST/X keeps the category in the class."

    (aNameSpaceOrNil isNil or:[aNameSpaceOrNil == Smalltalk]) ifTrue:[
        CachedOrganizerForSmalltalk isNil ifTrue:[
            CachedOrganizerForSmalltalk := self new nameSpace:aNameSpaceOrNil.
        ].
        ^ CachedOrganizerForSmalltalk
    ].
    ^ self new nameSpace:aNameSpaceOrNil.

    "Modified: / 21.8.2001 / 15:22:20 / cg"
! !

!SystemOrganizer methodsFor:'accessing'!

addCategory:aCategory before:someOtherCategory
    (categoryArray isNil
    or:[(categoryArray includes:aCategory) not]) ifTrue:[
        categoryArray := nil.
        AllCategories add:aCategory.
    ].

    "Created: / 6.2.2000 / 20:42:20 / cg"
    "Modified: / 6.2.2000 / 20:44:34 / cg"
!

categories
    "return a collection of my classes class-categories.
     If my nameSpace is nil, all classes' categories are included;
     otherwise, only the categories of that particular namespace."

    |addClassAction categorySet searchedNamespace allNames|

    categoryArray notNil ifTrue:[
        ^ categoryArray
    ].

    addClassAction := [:aClass |
        |cat|

        aClass isMeta ifFalse:[
            aClass isNameSpace ifFalse:[
                cat := aClass category.
                cat isNil ifTrue:[
                    cat := '* no category *'
                ].
                cat ~= 'obsolete' ifTrue:[
                    categorySet add:cat
                ]
            ]
        ].
    ].

    AllCategories isNil ifTrue:[
        categorySet := Set new.
        Smalltalk allClassesDo:addClassAction.
        AllCategories := categorySet.
    ].
        
    (searchedNamespace := nameSpace) isNil ifTrue:[
        searchedNamespace := Smalltalk.
    ].
    allNames := (searchedNamespace == Smalltalk).
    searchedNamespace == Smalltalk ifTrue:[
        categorySet := AllCategories.
    ] ifFalse:[
        categorySet := Set new.
        searchedNamespace allClassesDo:addClassAction.
    ].
    categoryArray := categorySet asArray sort.
    ^ categoryArray

    "
     (SystemOrganizer for:nil) categories 
     (SystemOrganizer for:Smalltalk) categories 
     (SystemOrganizer for:Demos) categories 
    "

    "Modified: / 21.8.2001 / 15:24:10 / cg"
!

categoryOfElement:aClassName
    "return a classes category;
     the argument is the classes name"

    |cls|

    cls := Smalltalk at:aClassName ifAbsent:nil.
    cls notNil ifTrue:[
        ^ cls category
    ].
    self error:'no such class'.

    "Modified: / 6.2.2000 / 20:12:10 / cg"
!

classify:aClassName under:newCategory
    "change a classes category;
     the argument is the classes name"

    |cls cats|

    cls := Smalltalk at:aClassName ifAbsent:nil.
    cls notNil ifTrue:[
        (AllCategories includes:newCategory) ifFalse:[
            cats := AllCategories asOrderedCollection.
            cats add:newCategory.
            cats sort.
            AllCategories := cats.
        ].
        (categoryArray notNil and:[categoryArray includes:newCategory])
        ifFalse:[
            categoryArray := nil.
        ].
        cls category:newCategory.
        ^ self
    ].
    self error:'no such class'.

    "Created: / 4.2.2000 / 18:30:11 / cg"
    "Modified: / 6.2.2000 / 20:36:30 / cg"
!

environment

	^Smalltalk
!

listAtCategoryNamed:aCategory
    "return a collection of classes in aCategory."

    |classSet searchedNamespace allNames|

    classSet := IdentitySet new.

    (searchedNamespace := nameSpace) isNil ifTrue:[
        searchedNamespace := Smalltalk.
    ].
    "/ hack to enable ported tools (RefactoryBrowser) to see all classes
    allNames := (searchedNamespace == Smalltalk).

    searchedNamespace allClassesDo:[:aClass |
        |cat|

        aClass isMeta ifFalse:[
            aClass isRealNameSpace ifFalse:[
                (allNames or:[aClass nameSpace == nameSpace]) ifTrue:[
                    cat := aClass category.
                    cat = aCategory ifTrue:[
                        classSet add:aClass name
                    ]
                ]
            ]
        ]
    ].
    ^ classSet asArray sort.

    "
     (SystemOrganizer for:nil) listAtCategoryNamed:'Collections-Abstract' 
     (SystemOrganizer for:Smalltalk) listAtCategoryNamed:'Collections-Abstract' 
     (SystemOrganizer for:Demos) listAtCategoryNamed:'Collections-Abstract' 
    "

    "Modified: / 10-11-2006 / 17:12:56 / cg"
! !

!SystemOrganizer methodsFor:'change & update'!

update:something with:anArgument from:changedObject
    "/ flush cached categories ...
    categoryArray := nil.

    "Created: / 6.2.2000 / 20:08:52 / cg"
    "Modified: / 6.2.2000 / 20:10:21 / cg"
! !

!SystemOrganizer methodsFor:'private accessing'!

nameSpace:aNameSpace
    "set the nameSpace - nil is allowed and stands for: any"

    nameSpace := aNameSpace ? Smalltalk.
    nameSpace addDependent:self.
    nameSpace ~~ Smalltalk ifTrue:[Smalltalk addDependent:self].

    "
     (SystemOrganizer for:nil) organization
     (SystemOrganizer for:Demos) organization
    "

    "Modified: / 20.6.1998 / 12:35:34 / cg"
! !

!SystemOrganizer class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

